'use strict'

var OpenFaaS = require('openfaas');
var openfaas = new OpenFaaS('http://192.168.1.126:31112');

function buy_confirm(args) {
    var hfs = "http://192.168.3.12:80";
    var base = "http://192.168.1.126:31112";
    var i;
    var url;
    var html = ``;
    var SHOPPING_IDstr = args.SHOPPING_ID;
    var C_IDstr = args.C_ID;
    var CC_TYPE = args.CC_TYPE;
    var CC_NUMBERstr = args.CC_NUMBER;
    var CC_NAME = args.CC_NAME;
    try {
        Date(args.CC_EXPIRY);
    }
    catch (err){
        html = `<!DOCTYPE HTML>
        <HTML> <HEAD><TITLE>TPC-W Admin Response Page</TITLE></HEAD>
        <BODY BGCOLOR="#FFFFFF">
        <H1 ALIGN="CENTER">TPC Web Commerce Benchmark (TPC-W)</H1>
        <H2 ALIGN="CENTER"><IMG SRC="${hfs}/images/tpclogo.gif" ALIGN="BOTTOM" BORDER="0" WIDTH="288" HEIGHT="67"></H2> <H2>Invalid Input</H2></BODY></HTML>`;
        return html;
    }
    var CC_EXPIRYstr = args.CC_EXPIRY;
    var SHIPPING = args.SHIPPING;
    var STREET_1 = args.STREET_1;
    var Result;
    var params;
    if (String(STREET_1).length != 0) {
        var STREET_2 = args.STREET_2;
        var CITY = args.CITY;
        var STATE = args.STATE;
        var ZIP = args.ZIP;
        var COUNTRY = args.COUNTRY;
        params = {
            shopping_id: SHOPPING_IDstr,
            customer_id: C_IDstr,
            cc_type: CC_TYPE,
            cc_number: CC_NUMBERstr,
            cc_name: CC_NAME,
            cc_expiry: CC_EXPIRYstr,
            shipping: SHIPPING,
            street_1: STREET_1,
            street_2: STREET_2,
            city: CITY,
            state: STATE,
            zip: ZIP,
            country: COUNTRY
        };
    }
    else {
        params = {
            shopping_id: SHOPPING_IDstr,
            customer_id: C_IDstr,
            cc_type: CC_TYPE,
            cc_number: CC_NUMBERstr,
            cc_name: CC_NAME,
            cc_expiry: CC_EXPIRYstr,
            shipping: SHIPPING
        };
    }
    return openfaas.invoke('dobuyconfirm', params, {isJson: true, isBinaryResponse: false}).then(result => {
        var res = result.body;
        Result = res.Result;
        html += `<!DOCTYPE HTML> <HTML>
        <HEAD><TITLE>Order Confirmation</TITLE></HEAD> <BODY BGCOLOR="#FFFFFF"><H1 ALIGN="CENTER">TPC Web Commerce Benchmark (TPC-W)</H1>
        <H2 ALIGN="CENTER">Buy Confirm Page</H2>
        <BLOCKQUOTE><BLOCKQUOTE><BLOCKQUOTE><BLOCKQUOTE>
        <CENTER>
        <H2>Order Information</H2>
        <TABLE BORDER="1" CELLSPACING="0" CELLPADDING="0">
        <TR><TD><B>Qty</B></TD><TD><B>Product</B></TD></TR> `;
        for (i = 0; i < Result.cart.lines.length; i ++) {
            var line = Result.cart.lines[i];
            html += `<TR><TD VALIGN="TOP">${line.scl_qty}</TD>
            <TD VALIGN="TOP">Title: <I>${line.scl_title}</I> - Backing: ${line.scl_backing}<BR>SRP: $${line.scl_srp} <FONT COLOR="#aa0000"><B>Your Price: $${line.scl_cost}</FONT> </TD></TR>
            `;
        }
        html += `</TABLE><H2>Your Order has been processed.</H2>
        <TABLE BORDER="1" CELLPADDING="5" CELLSPACING="0">
        <TR><TD><H4>Subtotal with discount:</H4></TD>
        <TD> <H4>$${Result.cart.SC_SUB_TOTAL}</H4></TD></TR><TR><TD><H4>Tax (8.25%):</H4></TD>
        <TD><H4>$${Result.cart.SC_TAX}</H4></TD></TR>
        <TR><TD><H4>Shipping &amp; Handling:</H4></TD>
        <TD><H4>$${Result.cart.SC_SHIP_COST}</H4></TD></TR>
        <TR><TD> <H4>Total:</H4></TD>
        <TD><H4>$${Result.cart.SC_TOTAL}</H4></TD></TR></TABLE>
        <P><BR></P><H2>Order Number: ${Result.order_id}</H2>
        <H1>Thank you for shopping at TPC-W</H1> <P></P>
        </CENTER>
        `;
        url = base + "/function/searchrequest?SHOPPING_ID=" + SHOPPING_IDstr;
        if (C_IDstr != undefined) {
            url += ("&C_ID=" + C_IDstr);
        }
        html += `<CENTER><P><A HREF="${url}"><IMG SRC="${hfs}/images/search_B.gif" ALT="Search"></A>
        `;
        url = base + "/function/homeinteraction?SHOPPING_ID=" + SHOPPING_IDstr;
        if (C_IDstr != undefined) {
            url += ("&C_ID=" + C_IDstr);
        }
        html += `<A HREF="${url}"><IMG SRC="${hfs}/images/home_B.gif" ALT="Home"></A>
        </P></CENTER></BLOCKQUOTE></BLOCKQUOTE></BLOCKQUOTE></BLOCKQUOTE></BODY></HTML>`;
        return html;
    }).catch(err => {
        html = `<!DOCTYPE HTML>
        <HTML> <HEAD><TITLE>TPC-W Admin Response Page</TITLE></HEAD>
        <BODY BGCOLOR="#FFFFFF">
        <H1 ALIGN="CENTER">TPC Web Commerce Benchmark (TPC-W)</H1>
        <H2 ALIGN="CENTER"><IMG SRC="${hfs}/images/tpclogo.gif" ALIGN="BOTTOM" BORDER="0" WIDTH="288" HEIGHT="67"></H2> <H2>Invalid Input</H2></BODY></HTML>`;
        return html;
    });
}

module.exports = async (event, context) => {
    return await buy_confirm(event.query);
}
