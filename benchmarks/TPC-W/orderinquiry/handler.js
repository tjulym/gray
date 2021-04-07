'use strict'

function order_inquiry(args) {
    var hfs = "http://192.168.3.12:80";
    var base = "http://192.168.1.126:31112";
    var html = ``;
    var username = "";
    var url;
    var C_ID = args.C_ID;
    var SHOPPING_ID = args.SHOPPING_ID;
    html += `<!DOCTYPE HTML>
    <HTML><HEAD><TITLE>TPC-W Order Inquiry Page</TITLE>
    </HEAD><BODY BGCOLOR="#ffffff">
    <H1 ALIGN="center">TPC Web Commerce Benchmark (TPC-W)</H1>
    <H2 ALIGN="center">Order Inquiry Page</H2>
    <FORM ACTION="orderdisplay" METHOD="get">
    <TABLE ALIGN="CENTER">
    <TR> <TD> <H4>Username:</H4></TD>
    <TD><INPUT NAME="UNAME" VALUE="${username}" SIZE="23"></TD></TR>
    <TR><TD> <H4>Password:</H4></TD>
    <TD> <INPUT NAME="PASSWD" SIZE="14" TYPE="password"></TD>
    </TR></TABLE><CENTER><P ALIGN="CENTER">
    <INPUT TYPE="IMAGE" NAME="Display Last Order" SRC="${hfs}/images/display_last_order_B.gif">
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
    html += `<A HREF="${url}"><IMG SRC="${hfs}/images/home_B.gif" ALT="Home"></A></P></CENTER>
    `;
    html += `</FORM></BODY></HTML>`;
    return html;
}

module.exports = async (event, context) => {
    return await order_inquiry(event.query);
}
