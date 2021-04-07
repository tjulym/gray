'use strict'

var OpenFaaS = require('openfaas');
var openfaas = new OpenFaaS('http://192.168.1.126:31112');

function admin_request(args) {
    var hfs = "http://192.168.3.12:80";
    var base = "http://192.168.1.126:31112";
    var url;
    var html = ``;
    var I_IDstr = args.I_ID;
    var C_ID = args.C_ID;
    var SHOPPING_ID = args.SHOPPING_ID;
    var params = {
        i_id: I_IDstr
    };
    return openfaas.invoke('getbook', params, {isJson: true, isBinaryResponse: false}).then(result => {
        var res = result.body;
        var book = res.book;
        html += `<!DOCTYPE HTML>
        <HTML><HEAD><TITLE>TPC-W Product Update Page</TITLE></HEAD><BODY BGCOLOR="#ffffff">
        <H1 ALIGN="center">TPC Web Commerce Benchmark (TPC-W)</H1><H2 ALIGN="center"><IMG SRC="${hfs}/images/tpclogo.gif" ALIGN="BOTTOM" BORDER="0" WIDTH="288" HEIGHT="67"></H2>
        <H2 ALIGN="center">Admin Request Page</H2><H2 ALIGN="center">Title:${book.i_title}</H2>
        <P ALIGN="LEFT">Author: ${book.a_fname} ${book.a_lname}<BR></P>
        <IMG SRC="${hfs}/images/${book.i_image}" ALIGN="RIGHT" BORDER="0" WIDTH="200" HEIGHT="200" >
        <IMG SRC="${hfs}/images/${book.i_thumbnail}" ALIGN="RIGHT" BORDER="0"><P><BR><BR></P><FORM ACTION="adminresponse" METHOD="get">
        <INPUT NAME="I_ID" TYPE="hidden" VALUE="${I_IDstr}">
        <TABLE BORDER="0">
        <TR><TD><B>Suggested Retail:</B></TD><TD><B>$ ${book.i_srp}</B></TD></TR>
        <TR><TD><B>Our Current Price: </B></TD><TD><FONT COLOR="#dd0000"><B>$ ${book.i_cost}</B></FONT></TD></TR>
        <TR><TD><B>Enter New Price:</B></TD><TD ALIGN="right">$ <INPUT NAME="I_NEW_COST"></TD></TR><TR><TD><B>Enter New Picture:</B></TD><TD ALIGN="right"><INPUT NAME="I_NEW_IMAGE"></TD></TR>
        <TR><TD><B>Enter New Thumbnail:</B></TD><TD ALIGN="RIGHT"><INPUT TYPE="TEXT" NAME="I_NEW_THUMBNAIL"></TD></TR>
        </TABLE><P><BR CLEAR="ALL"></P> <P ALIGN="center">`;
        if (SHOPPING_ID != undefined) {
            html += `<INPUT TYPE=HIDDEN NAME="SHOPPING_ID" value = "${SHOPPING_ID}">
            `;
        }
        if (C_ID != undefined) {
            html += `<INPUT TYPE=HIDDEN NAME="C_ID" value = "${C_ID}">
            `;
        }
        html += `<INPUT TYPE="IMAGE" NAME="Submit" SRC="${hfs}/images/submit_B.gif">
        `;
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
        html += `<A HREF="${url}"><IMG SRC="${hfs}/images/search_B.gif" ALT="Search"></A>
        `;
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
        html += `<A HREF="${url}"><IMG SRC="${hfs}/images/home_B.gif" ALT="Home"></A></P>
        </FORM></BODY></HTML>`;
        return html;
    }).catch(err => {
        return {
            err: err
        }
    });
}

module.exports = async (event, context) => {
    return await admin_request(event.query);
}
