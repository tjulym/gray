'use strict'

var OpenFaaS = require('openfaas');
var openfaas = new OpenFaaS('http://192.168.1.126:31112');

function buy_request(args) {
    var hfs = "http://192.168.3.12:80";
    var base = "http://192.168.1.126:31112";
    var html = ``;
    var url;
    var SHOPPING_ID = args.SHOPPING_ID;
    var RETURNING_FLAG = args.RETURNING_FLAG;
    var cust;
    html += `<!DOCTYPE HTML>
    <HTML><HEAD><TITLE>TPC-W Buy Request</TITLE></HEAD>
    <BODY BGCOLOR="ffffff">
    <H1 ALIGN="CENTER">TPC Web Commerce Benchmark (TPC-W)</H1>
    <H2 ALIGN="CENTER">Buy Request Page</H2>
    `;
    var name;
    var params;
    var res;
    function block() {
        if (SHOPPING_ID == undefined) {
            html += `ERROR: Shopping Cart ID not set!</BODY></HTML>`;
            return html;
        }
        params = {
            SHOPPING_ID: SHOPPING_ID,
            c_discount: cust.c_discount
        };
        return openfaas.invoke('getcart', params, {isJson: true, isBinaryResponse: false}).then(result => {
            res = result.body;
            var mycart = res.cart;
            html += `<HR><FORM ACTION="buyconfirm" METHOD="GET">
            <CENTER>
            <TABLE BORDER="0" WIDTH="90%">
            <TR ALIGN="LEFT" VALIGN="TOP">
            <TD VALIGN="TOP" WIDTH="45%">
            <H2>Billing Information:</H2>
            <TABLE WIDTH="100%" BORDER="0"><TR>
            <TR><TD>Firstname:</TD><TD>${cust.c_fname}</TD></TR>
            <TR><TD>Lastname: </TD><TD>${cust.c_lname}</TD></TR>
            <TR><TD>Addr_street_1:</TD><TD>${cust.addr_street1}</TD></TR>
            <TR><TD>Addr_street_2:</TD><TD>${cust.addr_street2}</TD></TR>
            <TR><TD>City:</TD><TD>${cust.addr_city}</TD></TR>
            <TR><TD>State:</TD><TD>${cust.addr_state}</TD></TR>
            <TR><TD>Zip:</TD><TD>${cust.addr_zip}</TD></TR>
            <TR><TD>Country:</TD><TD>${cust.co_name}</TD></TR>
            <TR><TD>Email:</TD><TD>${cust.c_email}</TD></TR>
            <TR><TD>Phone:</TD><TD>${cust.c_phone}</TD></TR>
            `;
            if (args.RETURNING_FLAG == "N") {
                html += `<TR><TD>USERNAME:</TD><TD>${cust.c_uname}</TD></TR>
                <TR><TD>C_ID:</TD><TD>${cust.c_id}</TD></TR>`;
            }
            html += `</TABLE></TD><TD VALIGN="TOP" WIDTH="45%">
            <H2>Shipping Information:</H2>
            <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="100%">
            <TR><TD WIDTH="50%">Addr_street_1:</TD>
            <TD><INPUT NAME="STREET_1" SIZE="40" VALUE=""></TD></TR>
            <TR><TD>Addr_street_ 2:</TD>
            <TD><INPUT NAME="STREET_2" SIZE="40" VALUE=""></TD></TR>
            <TR><TD>City:</TD><TD><INPUT NAME="CITY" SIZE="30" VALUE=""></TD></TR>
            <TR><TD>State:</TD><TD><INPUT NAME="STATE" SIZE="20" VALUE=""></TD></TR>
            <TR><TD>Zip:</TD><TD><INPUT NAME="ZIP" SIZE="10" VALUE=""></TD></TR>
            <TR><TD>Country:</TD><TD><INPUT NAME="COUNTRY" VALUE="" SIZE="40"></TD></TR>
            </TABLE></TD></TR></TABLE>
            <HR><H2>Order Information</H2>
            <TABLE BORDER="1" CELLSPACING="0" CELLPADDING="0">
            <TR><TD><B>Qty</B></TD><TD><B>Product</B></TD></TR>
            `;
            var i;
            for (i = 0; i < mycart.lines.length; i ++) {
                var thisline = mycart.lines[i];
                html += `<TR><TD VALIGN="TOP">${thisline.scl_qty}</TD>
                <TD VALIGN="TOP">Title: <I>${thisline.scl_title}</I> - Backing: ${thisline.scl_backing}<BR>SRP: $${thisline.scl_srp}<FONT COLOR="#aa0000">
                <B>Your Price: $${thisline.scl_cost}</B>
                </FONT></TD></TR>`;
            }
            html += `</TABLE>
            <P><BR></P><TABLE BORDER="0">
            <TR><TD><B>Subtotal with discount (${cust.c_discount.toFixed(2)}%): </B></TD><TD ALIGN="RIGHT"><B>$${mycart.SC_SUB_TOTAL}</B></TD></TR>
            <TR><TD><B>Tax: </B></TD><TD ALIGN="RIGHT"><B>$${mycart.SC_TAX}</B></TD></TR>
            <TR><TD><B>Shipping &amp; Handling: </B></TD><TD ALIGN="RIGHT"><B>$${mycart.SC_SHIP_COST}</B></TD></TR>
            <TR><TD><B>Total: </B></TD><TD ALIGN="RIGHT"><B>$${mycart.SC_TOTAL}</B></TD></TR></TABLE>
            <HR WIDTH="700"><P><BR></P>
            <TABLE BORDER="1" CELLPADDING="5" CELLSPACING="0"><TR>
            <TD>Credit Card Type</TD>
            <TD><INPUT TYPE="RADIO" NAME="CC_TYPE" VALUE="Visa" CHECKED="CHECKED">Visa
            <INPUT TYPE="RADIO" NAME="CC_TYPE" VALUE="Master">MasterCard
            <INPUT TYPE="RADIO" NAME="CC_TYPE" VALUE="Discover">Discover
            <INPUT TYPE="RADIO" NAME="CC_TYPE" VALUE="Amex">American Express
            <INPUT TYPE="RADIO" NAME="CC_TYPE" VALUE="Diners">Diners</TD></TR>
            <TR><TD>Name on Credit Card</TD>
            <TD><INPUT NAME="CC_NAME" SIZE="30" VALUE=""></TD></TR>
            <TR><TD>Credit Card Number</TD>
            <TD><INPUT NAME="CC_NUMBER" SIZE="16" VALUE=""></TD></TR>
            <TR><TD>Credit Card Expiration Date</TD>
            <TD><INPUT NAME="CC_EXPIRY" SIZE="15" VALUE=""></TD></TR>
            <TR><TD>Shipping Method</TD>
            <TD><INPUT TYPE="RADIO" NAME="SHIPPING" VALUE="AIR" CHECKED="CHECKED">AIR<INPUT TYPE="RADIO" NAME="SHIPPING" VALUE="UPS">UPS
            <INPUT TYPE="RADIO" NAME="SHIPPING" VALUE="FEDEX">FEDEX
            <INPUT TYPE="RADIO" NAME="SHIPPING" VALUE="SHIP">SHIP
            <INPUT TYPE="RADIO" NAME="SHIPPING" VALUE="COURIER">COURIER
            <INPUT TYPE="RADIO" NAME="SHIPPING" VALUE="MAIL">MAIL
            </TD></TR></TABLE></CENTER><CENTER><P>
            `;
            if (SHOPPING_ID != undefined) {
                html += `<INPUT TYPE=HIDDEN NAME="SHOPPING_ID" value = "${SHOPPING_ID}">
                `;
            }
            html += `<INPUT TYPE=HIDDEN NAME="C_ID" value = "${cust.c_id}">
            <INPUT TYPE="IMAGE" NAME="Confirm Buy" SRC="${hfs}/images/submit_B.gif">
            `;
            url = base + "/function/shoppingcartinteraction?ADD_FLAG=N&C_ID=" + cust.c_id;
            if (SHOPPING_ID != undefined) {
                url += ("&SHOPPING_ID=" + SHOPPING_ID);
            }
            html += `<A HREF="${url}"><IMG SRC="${hfs}/images/shopping_cart_B.gif" ALT="Shopping Cart"></A>
            `;
            url = base + "/function/orderinquiry?C_ID=" + cust.c_id;
            if (SHOPPING_ID != undefined) {
                url += ("&SHOPPING_ID=" + SHOPPING_ID);
            }
            html += `<A HREF="${url}"><IMG SRC="${hfs}/images/order_status_B.gif" ALT="Order Status"></A>
            </P></CENTER></BODY></HTML>`;
            return html;
        }).catch(err => {
            return {
                err: err
            }
        });
    }
    if (RETURNING_FLAG == undefined) {
        html += `ERROR: RETURNING_FLAG not set!</BODY><HTML>`;
        return html;
    }
    else if (RETURNING_FLAG == "Y") {
        var UNAME = args.UNAME;
        var PASSWD = args.PASSWD;
        if (String(UNAME).length == 0 || String(PASSWD).length == 0) {
            html += `Error: Invalid Input</BODY></HTML>`;
            return html;
        }
        params = {
            UNAME: UNAME
        };
        return openfaas.invoke('getcustomer', params, {isJson: true, isBinaryResponse: false}).then(result => {
            res = result.body;
            cust = res.cust;
            params = {
                C_ID: cust.c_id
            };
            return openfaas.invoke('refreshsession', params, {isJson: true, isBinaryResponse: false}).then(result => {
                res = result.body;
                if (PASSWD != cust.c_passwd) {
                    html += `Error: Incorrect Password</BODY></HTML>`;
                    return html;
                }
                return block();
            }).catch(err => {
                return {
                    err: err
                }
            });
        }).catch(err => {
            return {
                err: err
            }
        });
    }
    else if (RETURNING_FLAG == "N") {
        cust = {
            "c_fname": args.FNAME,
            "c_lname": args.LNAME,
            "addr_street1": args.STREET1,
            "addr_street2": args.STREET2,
            "addr_city": args.CITY,
            "addr_state": args.STATE,
            "addr_zip": args.ZIP,
            "co_name": args.COUNTRY,
            "c_phone": args.PHONE,
            "c_email": args.EMAIL,
            "c_birthdate": args.BIRTHDATE,
            "c_data": args.DATA
        };
        params = {
            cust: cust
        };
        return openfaas.invoke('createnewcustomer', params, {isJson: true, isBinaryResponse: false}).then(result => {
            res = result.body;
            cust = res.cust;
            return block();
        }).catch(err => {
            html += `Error: Invalid Input</BODY></HTML>`;
            return html;
        });
    }
    else {
        html += `ERROR: RETURNING_FLAG not set to Y or N!
        `;
        return block();
    }
}

module.exports = async (event, context) => {
    return await buy_request(event.query);
}
