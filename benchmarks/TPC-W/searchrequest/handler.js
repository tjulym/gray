'use strict'

var OpenFaaS = require('openfaas');
var openfaas = new OpenFaaS('http://192.168.1.126:31112');

function search_request(args) {
    var hfs = "http://192.168.3.12:80";
    var base = "http://192.168.1.126:31112";
    var html = ``;
    var C_ID = args.C_ID;
    var SHOPPING_ID = args.SHOPPING_ID;
    var url;
    html += `<!DOCTYPE HTML>
    <HTML><HEAD><TITLE>Search Request Page</TITLE></HEAD>
    <BODY BGCOLOR="#ffffff">
    <H1 ALIGN="center">TPC W Commerce Benchmark (TPC-W)</H1>
    <H2 ALIGN="center"><IMG SRC="${hfs}/images/tpclogo.gif" ALIGN="BOTTOM" BORDER="0" WIDTH="288" HEIGHT="67"></H2>
    <H2 ALIGN="center">Search Request Page</H2>
    `;
    var params = {
        C_ID: C_ID,
        SHOPPING_ID: SHOPPING_ID,
        new_sid: -1
    };
    return openfaas.invoke('promotionalprocessing', params, {isJson: true, isBinaryResponse: false}).then(result => {
        var res = result.body;
        html += res.html;
        html += `<FORM ACTION="executesearch" METHOD="get">
        <TABLE ALIGN="center"><TR><TD ALIGN="right">
        <H3>Search by:</H3></TD><TD WIDTH="100"></TD></TR>
        <TR><TD ALIGN="right">
        <SELECT NAME="search_type" SIZE="1">
        <OPTION SELECTED="SELECTED" VALUE="author">Author</OPTION>
        <OPTION VALUE="title">Title</OPTION>
        <OPTION VALUE="subject">Subject</OPTION></SELECT></TD>
        <TD><INPUT NAME="search_string" SIZE="30"></TD></TR>
        </TABLE>
        <CENTER><P ALIGN="CENTER">
        <INPUT TYPE="IMAGE" NAME="Search" SRC="${hfs}/images/submit_B.gif">
        `;
        if (SHOPPING_ID != undefined) {
            html += `<INPUT TYPE=HIDDEN NAME="SHOPPING_ID" value = "${SHOPPING_ID}">
            `;
        }
        if (C_ID != undefined) {
            html += `<INPUT TYPE=HIDDEN NAME="C_ID" value = "${C_ID}">
            `;
        }
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
        html += `<A HREF="${url}"><IMG SRC="${hfs}/images/home_B.gif" ALT="Home"></A>
        `;
        url = base + "/function/shoppingcartinteraction?ADD_FLAG=N";
        if (SHOPPING_ID != undefined) {
            url += ("&SHOPPING_ID=" + SHOPPING_ID);
        }
        if (C_ID != undefined) {
            url += ("&C_ID=" + C_ID);
        }
        html += `<A HREF="${url}"><IMG SRC="${hfs}/images/shopping_cart_B.gif" ALT="Shopping Cart"></A>
        </P></CENTER></FORM></BODY></HTML>`;
        return html;
    }).catch(err => {
        return {
            err: err
        }
    });
}

module.exports = async (event, context) => {
    return await search_request(event.query);
}
