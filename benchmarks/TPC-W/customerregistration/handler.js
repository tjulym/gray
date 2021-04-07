'use strict'

var OpenFaaS = require('openfaas');
var openfaas = new OpenFaaS('http://192.168.1.126:31112');

function customer_registration(args) {
    var hfs = "http://192.168.3.12:80";
    var base = "http://192.168.1.126:31112";
    var url;
    var html = ``;
    var C_ID = args.C_ID;
    var SHOPPING_ID = args.SHOPPING_ID;
    var username;
    function block() {
        html += `<!DOCTYPE HTML>
        <HTML>
        <HEAD><TITLE>Customer Registration</TITLE></HEAD>
        <BODY BGCOLOR="#ffffff">
        <H1 ALIGN="center">TPC Web Commerce Benchmark (TPC-W)</H1><H1 ALIGN="center">
        <IMG SRC="${hfs}/images/tpclogo.gif" ALIGN="BOTTOM" BORDER="0" WIDTH="288" HEIGHT="67"></H1><H2 ALIGN="center">Customer Registration Page</H2>
        <FORM ACTION="buyrequest" METHOD="get"><BLOCKQUOTE><BLOCKQUOTE>
        <HR><TABLE BORDER="0"><TR>
        <TD><INPUT CHECKED="CHECKED" NAME="RETURNING_FLAG" TYPE="radio" VALUE="Y">I am an existing customer</TD></TR><TR><TD>
        <INPUT NAME="RETURNING_FLAG" TYPE="radio" VALUE="N">I am a first time customer</TD></TR></TABLE>
        <HR><P><B>If you're an existing customer, enter your User ID and Password:</B><BR><BR></P>
        <TABLE><TR ALIGN="left">
        <TD>User ID: <INPUT NAME="UNAME" SIZE="23"></TD></TR>
        <TR ALIGN="left">
        <TD>Password: <INPUT SIZE="14" NAME="PASSWD" TYPE="password"></TD></TR></TABLE> 
        <HR><P><B>If you re a first time customer, enter the details below:</B><BR></P>
        <TABLE><TR><TD>Enter your birth date (yyyy-mm-dd):</TD>
        <TD> <INPUT NAME="BIRTHDATE" SIZE="10"></TD></TR><TR><TD>Enter your First Name:</TD>
        <TD> <INPUT NAME="FNAME" SIZE="15"></TD></TR>
        <TR><TD>Enter your Last Name:</TD>
        <TD><INPUT NAME="LNAME" SIZE="15"></TD></TR>
        <TR><TD>Enter your Address 1:</TD>
        <TD><INPUT NAME="STREET1" SIZE="40"></TD></TR>
        <TR><TD>Enter your Address 2:</TD>
        <TD> <INPUT NAME="STREET2" SIZE="40"></TD></TR>
        <TR><TD>Enter your City, State, Zip:</TD>
        <TD><INPUT NAME="CITY" SIZE="30"><INPUT NAME="STATE"><INPUT NAME="ZIP" SIZE="10">
        </TD></TR><TR><TD>Enter your Country:</TD>
        <TD><INPUT NAME="COUNTRY" SIZE="50"></TD></TR>
        <TR><TD>Enter your Phone:</TD>
        <TD><INPUT NAME="PHONE" SIZE="16"></TD></TR>
        <TR><TD>Enter your E-mail:</TD>
        <TD> <INPUT NAME="EMAIL" SIZE="50"></TD></TR></TABLE>
        <HR><TABLE><TR><TD COLSPAN="2">Special Instructions:<TEXTAREA COLS="65" NAME="DATA" ROWS="4"></TEXTAREA></TD></TR></TABLE></BLOCKQUOTE></BLOCKQUOTE><CENTER>
        <INPUT TYPE="IMAGE" NAME="Enter Order" SRC="${hfs}/images/submit_B.gif">
        `;
        if (SHOPPING_ID != undefined) {
            html += `<INPUT TYPE=HIDDEN NAME="SHOPPING_ID" value = "${SHOPPING_ID}">
            `;
        }
        if (C_ID != undefined) {
            html += `<INPUT TYPE=HIDDEN NAME="C_ID" value = "${C_ID}">
            `;
        }
        url = base + "/function/searchrequest";
        if (SHOPPING_ID != undefined) {
            url += ("?SHOPPING_ID=" + SHOPPING_ID);
            if (C_ID != undefined) {
                url += ("&C_ID=" + C_ID);
            }
        }
        else if (C_ID != undefined) {
            url += ("?C_ID=" + C_ID);
        }
        html += `<A HREF="${url}"><IMG SRC="${hfs}/images/search_B.gif" ALT="Search Item"></A>`;
        url = base + "/function/homeinteraction";
        if (SHOPPING_ID != undefined) {
            url += ("?SHOPPING_ID=" + SHOPPING_ID);
            if (C_ID != undefined) {
                url += ("&C_ID=" + C_ID);
            }
        }
        else if (C_ID != undefined) {
            url += ("?C_ID=" + C_ID);
        }
        html += `<A HREF="${url}"><IMG SRC="${hfs}/images/home_B.gif" ALT="Home"></A></CENTER></FORM></BODY></HTML>`;
        return html;
    }
    if (C_ID != undefined) {
        var params = {
            C_ID: C_ID
        };
        return openfaas.invoke('getusername', params, {isJson: true, isBinaryResponse: false}).then(result => {
            var res = result.body;
            username = res.u_name;
            return block();
        }).catch(err => {
            return {
                err: err
            }
        });
    }
    else {
        username = "";
        return block();
    }
}

module.exports = async (event, context) => {
    return await customer_registration(event.query);
}
