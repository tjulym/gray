'use strict'

function convertToDate(date) {
    return new Date(date).toISOString().slice(0, 10);
}

var OpenFaaS = require('openfaas');
var openfaas = new OpenFaaS('http://192.168.1.126:31112');

function order_display(args) {
    var hfs = "http://192.168.3.12:80";
    var base = "http://192.168.1.126:31112";
    var html = ``;
    var C_ID = args.C_ID;
    var SHOPPING_ID = args.SHOPPING_ID;
    var url;
    html += `<!DOCTYPE HTML>
    <HTML><HEAD><TITLE>TPC-W Order Display Page</TITLE></HEAD>
    <BODY BGCOLOR="#FFFFFF"><H1 ALIGN="CENTER">TPC Web Commerce Benchmark (TPC-W)</H1>
    <H2 ALIGN="CENTER">Order Display Page</H2>
    <BLOCKQUOTE> <BLOCKQUOTE> <BLOCKQUOTE> <BLOCKQUOTE> <HR>
    `;
    var uname = args.UNAME;
    var passwd = args.PASSWD;
    function block() {
        html += `<CENTER><P>
        `;
        url = base + "/function/searchrequest";
        if (SHOPPING_ID != undefined) {
            url += ("?SHOPPING_ID=" + SHOPPING_ID);
            if (C_ID != undefined) {
                url += ("?C_ID=" + C_ID);
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
                url += ("?C_ID=" + C_ID);
            }
        }
        else if (C_ID != undefined) {
            url += ("?C_ID=" + C_ID);
        }
        html += `<A HREF="${url}"><IMG SRC="${hfs}/images/home_B.gif" ALT="Home"></A></P>
        </CENTER></BODY></HTML>`;
        return html;
    };
    if (uname != "" && passwd != "") {
        var params = {
            C_UNAME: uname
        };
        var res;
        return openfaas.invoke('getpassword', params, {isJson: true, isBinaryResponse: false}).then(result => {
            res = result.body;
            var storedpasswd = res.passwd;
            if (storedpasswd != passwd) {
                html += `Error: Incorrect password.
                `;
                return block();
            }
            else {
                params = {
                    C_UNAME: uname
                };
                return openfaas.invoke('getmostrecentorder', params, {isJson: true, isBinaryResponse: false}).then(result => {
                    res = result.body;
                    var lines = res.order_lines;
                    var order = res.order;
                    if (order != undefined) {
                        var i;
                        html += `<P>Order ID: ${order.o_id}<BR>
                        Order Placed on ${convertToDate(order.o_date)}<BR>
                        Shipping Type: ${order.o_ship_type}<BR>
                        Ship Date: ${convertToDate(order.o_ship_date)}<BR>
                        Order Subtotal: ${order.o_subtotal}<BR>
                        Order Tax: ${order.o_tax}<BR>
                        Order Total: ${order.o_total}<BR></P>
                        <TABLE BORDER="0" WIDTH="80%">
                        <TR><TD><B>Bill To:</B></TD><TD><B>Ship To:</B></TD></TR><TR><TD COLSPAN="2"> <H4>${order.c_fname} ${order.c_lname}</H4></TD></TR>
                        <TR><TD WIDTH="50%"><ADDRESS>${order.ship_addr_street1}<BR>
                        ${order.ship_addr_street2}<BR>
                        ${order.ship_addr_state} ${order.ship_addr_zip}<BR>
                        ${order.ship_co_name}<BR><BR>
                        Email: ${order.c_email}<BR>
                        Phone: ${order.c_phone}</ADDRESS><BR><P>
                        Credit Card Type: ${order.cx_type}<BR>
                        Order Status: ${order.o_status}</P></TD>
                        <TD VALIGN="TOP" WIDTH="50%"><ADDRESS>${order.bill_addr_street1}<BR>
                        ${order.bill_addr_street2}<BR>
                        ${order.bill_addr_state} ${order.bill_addr_zip}<BR>
                        ${order.bill_co_name}
                        </ADDRESS></TD></TR></TABLE></BLOCKQUOTE></BLOCKQUOTE></BLOCKQUOTE></BLOCKQUOTE><CENTER><TABLE BORDER="1" CELLPADDING="5" CELLSPACING="0">
                        <TR><TD><H4>Item #</H4></TD><TD><H4>Title</H4></TD><TD><H4>Cost</H4></TD><TD><H4>Qty</H4></TD><TD><H4>Discount</H4></TD><TD><H4>Comment</H4></TD></TR>
                        `;
                        if (lines != undefined) {
                            for (i = 0; i < lines.length; i ++) {
                                var line = lines[i];
                                html += `<TR><TD><H4>${line.ol_i_id}</H4></TD>
                                <TD VALIGN="top"><H4>${line.i_title}<BR>Publisher: ${line.i_publisher}</H4></TD>
                                <TD><H4>${line.i_cost}</H4></TD>
                                <TD><H4>${line.ol_qty}</H4></TD>
                                <TD><H4>${line.ol_discount}</H4></TD>
                                <TD><H4>${line.ol_comments}</H4></TD></TR>
                                `;
                            }
                        }
                        html += `</TABLE><BR></CENTER>
                        `;
                        return block();
                    }
                    else {
                        html += `User has no order!
                        `;
                        return block();
                    }
                }).catch(err => {
                    return {
                        err: err
                    }
                });
            }
        }).catch(err => {
            return {
                err: err
            }
        });
    }
    else {
        html += `Error:TPCW_order_display_servlet, uname and passwd not set!
        `;
        return block();
    }
}

module.exports = async (event, context) => {
    return await order_display(event.query);
}
