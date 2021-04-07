'use strict'

function isValidQTY(QTY) {
    if (QTY == undefined) {
        return true;
    }
    if (parseInt(QTY, 10).toString() == QTY && Number(QTY) >= 0) {
        return true;
    }
    return false;
}

var OpenFaaS = require('openfaas');
var openfaas = new OpenFaaS('http://192.168.1.126:31112');

function shopping_cart_interaction(args) {
    var hfs = "http://192.168.3.12:80";
    var base = "http://192.168.1.126:31112";
    var cart;
    var url;
    var html = ``;
    var C_IDstr = args.C_ID;
    var SHOPPING_IDstr = args.SHOPPING_ID;
    var params;
    var res;
    function block() {
        var add_flag = args.ADD_FLAG;
        var I_IDstr;
        if (add_flag == "Y") {
            I_IDstr = args.I_ID;
            if (I_IDstr == undefined) {
                html += `<!DOCTYPE HTML>
                <HTML><BODY>Error- need to specify an I_ID!</BODY></HTML>
                `;
                return html;
            }
        }
        else {
            I_IDstr = undefined;
        }
        var quantities = new Array();
        var ids = new Array();
        var i = 0;
        var curr_QTYstr;
        var curr_I_IDstr;
        if (!isValidQTY(args["QTY_" + String(i)])) {
            html = `<!DOCTYPE HTML>
	    <HTML> <HEAD><TITLE>TPC-W Admin Response Page</TITLE></HEAD>
	    <BODY BGCOLOR="#FFFFFF">
	    <H1 ALIGN="CENTER">TPC Web Commerce Benchmark (TPC-W)</H1>
	    <H2 ALIGN="CENTER"><IMG SRC="${hfs}/images/tpclogo.gif" ALIGN="BOTTOM" BORDER="0" WIDTH="288" HEIGHT="67"></H2> <H2>Invalid Input</H2></BODY></HTML>`;
            return html;
        }
        curr_QTYstr = args["QTY_" + String(i)];
        curr_I_IDstr = args["I_ID_"+ String(i)];
        while (curr_I_IDstr != undefined) {
            ids.push(curr_I_IDstr);
            quantities.push(curr_QTYstr);
            i ++;
            if (!isValidQTY(args["QTY_" + String(i)])) {
                html = `<!DOCTYPE HTML>
	        <HTML> <HEAD><TITLE>TPC-W Admin Response Page</TITLE></HEAD>
	        <BODY BGCOLOR="#FFFFFF">
	        <H1 ALIGN="CENTER">TPC Web Commerce Benchmark (TPC-W)</H1>
	        <H2 ALIGN="CENTER"><IMG SRC="${hfs}/images/tpclogo.gif" ALIGN="BOTTOM" BORDER="0" WIDTH="288" HEIGHT="67"></H2> <H2>Invalid Input</H2></BODY></HTML>`;
                return html;
            }
            curr_QTYstr = args["QTY_" + String(i)];
            curr_I_IDstr = args["I_ID_"+ String(i)];
        }
        if (I_IDstr != undefined) {
            params = {
                SHOPPING_ID: SHOPPING_IDstr,
                I_ID: I_IDstr,
                ids: ids,
                quantities: quantities
            };
        }
        else {
            params = {
                SHOPPING_ID: SHOPPING_IDstr,
                ids: ids,
                quantities: quantities
            };
        }
        return openfaas.invoke('docart', params, {isJson: true, isBinaryResponse: false}).then(result => {
            res = result.body;
            cart = res.cart;
            html += `<!DOCTYPE HTML>
            <HTML><!--Shopping Cart--> <HEAD><TITLE>TPC W Shopping Cart</TITLE></HEAD> 
            <BODY BGCOLOR="#ffffff">
            <H1 ALIGN="center">TPC Web Commerce Benchmark (TPC-W)</H1>
            <CENTER><IMG SRC="${hfs}/images/tpclogo.gif" ALIGN="BOTTOM" BORDER="0" WIDTH="288" HEIGHT="67"></CENTER>
            <H2 ALIGN="center">Shopping Cart Page</H2>
            `;
            params = {
                C_ID : args.C_ID,
                SHOPPING_ID: SHOPPING_IDstr,
                new_sid: SHOPPING_IDstr
            };
            return openfaas.invoke('promotionalprocessing', params, {isJson: true, isBinaryResponse: false}).then(result => {
                res = result.body;
                html += res.html;
                html += `<FORM ACTION="shoppingcartinteraction" METHOD="get">
                <CENTER><P></P><TABLE BORDER="0">
                <TR><TD><B>Qty</B></TD><TD><B>Product</B></TD></TR>
                `;
                for (i = 0; i < cart.lines.length; i ++) {
                    var line = cart.lines[i];
                    html += `<TR><TD VALIGN="top">
                    <INPUT TYPE=HIDDEN NAME="I_ID_${i}" value = "${line.scl_i_id}">
                    <INPUT NAME="QTY_${i}" SIZE="3" VALUE="${line.scl_qty}"></TD>
                    <TD VALIGN="top">Title:<I>${line.scl_title}</I> - Backing: ${line.scl_backing}<BR>
                    <B>SRP: $${line.scl_srp}</B>
                    <FONT COLOR="#aa0000"><B>Your Price: $${line.scl_cost}</B></FONT></TD></TR>
                    `;
                }
                html += `</TABLE><B><I>Subtotal price: ${cart.SC_SUB_TOTAL}</I></B>
                `;
                url = base + "/function/customerregistration?SHOPPING_ID=" + SHOPPING_IDstr;
                if (C_IDstr != undefined) {
                    url += ("&C_ID=" + C_IDstr);
                }
                html += `<P><BR><A HREF="${url}"><IMG SRC="${hfs}/images/checkout_B.gif"></A>
                `;
                url = base + "/function/homeinteraction?SHOPPING_ID=" + SHOPPING_IDstr;
                if (C_IDstr != undefined) {
                    url += ("&C_ID=" + C_IDstr);
                }
                html += `<A HREF="${url}"><IMG SRC="${hfs}/images/home_B.gif"></A></P>
                <P>If you have changed the quantities and/or taken anything out<BR> of your shopping cart, click here to refresh your shopping cart:</P> <INPUT TYPE=HIDDEN NAME="ADD_FLAG" value = "N">
                <INPUT TYPE=HIDDEN NAME="SHOPPING_ID" value = "${SHOPPING_IDstr}">
                `;
                if (C_IDstr != undefined) {
                    html += `<INPUT TYPE=HIDDEN NAME="C_ID" value = "${C_IDstr}">
                    `;
                }
                html += `<P><INPUT TYPE="IMAGE" NAME="Refresh Shopping Cart" SRC="${hfs}/images/refresh_B.gif"></P>
                </CENTER></FORM></BODY></HTML>
                `;
                return html;
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
    };
    if (SHOPPING_IDstr == undefined) {
        params = {};
        return openfaas.invoke('createemptycart', params, {isJson: true, isBinaryResponse: false}).then(result => {
            res = result.body;
            SHOPPING_IDstr = res.SHOPPING_ID;
            return block();
        }).catch(err => {
            return {
                err: err
            }
        });
    }
    else {
        return block();
    }
}

module.exports = async (event, context) => {
    return await shopping_cart_interaction(event.query);
}
