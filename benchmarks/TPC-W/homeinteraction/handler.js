'use strict'

var OpenFaaS = require('openfaas');
var openfaas = new OpenFaaS('http://192.168.1.126:31112');

function home_interaction(args) {
    var hfs = "http://192.168.3.12:80";
    var base = "http://192.168.1.126:31112";
    var i;
    var url;
    var column1 = new Array("ARTS", "BIOGRAPHIES", "BUSINESS", "CHILDREN", "COMPUTERS", "COOKING", "HEALTH", "HISTORY", "HOME", "HUMOR", "LITERATURE");
    var column2 = new Array("NON-FICTION", "PARENTING", "POLITICS", "REFERENCE", "RELIGION", "ROMANCE", "SELF-HELP", "SCIENCE-NATURE", "SCIENCE-FICTION", "SPORTS", "MYSTERY");
    var html = ``;
    var C_ID = args.C_ID;
    var SHOPPING_ID = args.SHOPPING_ID;
    html += `<!DOCTYPE HTML>
    <HTML> <HEAD> <TITLE>TPC-W Home Page</TITLE></HEAD>
    <BODY BGCOLOR="#ffffff">
    <H1 ALIGN="center">TPC Web Commerce Benchmark (TPC-W)</H1>
    <P ALIGN="CENTER">
    <IMG SRC="${hfs}/images/tpclogo.gif" ALIGN="BOTTOM" BORDER="0" WIDTH="288" HEIGHT="67"></P>
    <H2 ALIGN="center">Home Page</H2>
    `;
    var params = {
        C_ID: C_ID
    }
    return openfaas.invoke('sayhello', params, {isJson: true, isBinaryResponse: false}).then(result => {
        var res = result.body;
        html += res.html;
        params = {
            C_ID: C_ID,
            SHOPPING_ID: SHOPPING_ID,
            new_sid: -1
        };
        return openfaas.invoke('promotionalprocessing', params, {isJson: true, isBinaryResponse: false}).then(result => {
            res = result.body;
            html += res.html;
            html += `<TABLE ALIGN="center" BGCOLOR="#c0c0c0" BORDER="0" CELLPADDING="6" CELLSPACING="0" WIDTH="700">
            <TR ALIGN="CENTER" BGCOLOR="#ffffff" VALIGN="top">
            <TD COLSPAN="2" VALIGN="MIDDLE" WIDTH="300">
            <IMG SRC="${hfs}/images/whats_new.gif" ALT="New Product">
            </TD>
            <TD BGCOLOR="#ffffff" WIDTH="100"></TD>
            <TD COLSPAN="2" WIDTH="300">
            <IMG SRC="${hfs}/images/best_sellers.gif" ALT="Best Seller"></TD></TR>
            `;
            for (i = 0; i < column1.length; i ++) {
                html += `<TR><TD><P ALIGN="center">`;
                url = base + "/function/newproducts";
                url += ("?subject=" + column1[i]);
                if (SHOPPING_ID != undefined) {
                    url += ("&SHOPPING_ID=" + SHOPPING_ID);
                }
                if (C_ID != undefined) {
                    url += ("&C_ID=" + C_ID);
                }
                html += (`<A HREF="` + url);
                html += (`">` + column1[i] + `</A></P></TD>
                `);
                url = base + "/function/newproducts";
                url += ("?subject=" + column2[i]);
                if (SHOPPING_ID != undefined) {
                    url += ("&SHOPPING_ID=" + SHOPPING_ID);
                }
                if (C_ID != undefined) {
                    url += ("&C_ID=" + C_ID);
                }
                html += (`<TD><P ALIGN="center"><A HREF="` + url);
                html += (`">` + column2[i] + `</A></P></TD>
                `);
                html += `<TD BGCOLOR="#ffffff" WIDTH="50"></TD>
                <TD> <P ALIGN="center">`;
                url = base + "/function/bestsellers";
                url += ("?subject=" + column1[i]);
                if (SHOPPING_ID != undefined) {
                    url += ("&SHOPPING_ID=" + SHOPPING_ID);
                }
                if (C_ID != undefined) {
                    url += ("&C_ID=" + C_ID);
                }
                html += (`<A HREF="` + url);
                html += (`">` + column1[i] + `</A></P></TD>
                `);
                url = base + "/function/bestsellers";
                url += ("?subject=" + column2[i]);
                if (SHOPPING_ID != undefined) {
                    url += ("&SHOPPING_ID=" + SHOPPING_ID);
                }
                if (C_ID != undefined) {
                    url += ("&C_ID=" + C_ID);
                }
                html += (`<TD><P ALIGN="center"><A HREF="` + url);
                html += (`">` + column2[i] + `</A></P></TD>
                `);
                html += `</TR>
                `;
            }
            html += `</TABLE>
            `;
            html += `<P ALIGN="CENTER">
            `;
            url = base + "/function/shoppingcartinteraction";
            url += "?ADD_FLAG=N";
            if (SHOPPING_ID != undefined) {
                url += ("&SHOPPING_ID=" + SHOPPING_ID);
            }
            if (C_ID != undefined) {
                url += ("&C_ID=" + C_ID);
            }
            html += (`<A HREF="` + url);
            html += (`"><IMG SRC="${hfs}/images/shopping_cart_B.gif"` + ` ALT="Shopping Cart"></A>
            `);
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
            html += (`<A HREF="` + url);
            html += (`"><IMG SRC="${hfs}/images/search_B.gif"` + ` ALT="Search"></A>
            `);
            url = base + "/function/orderinquiry";
            if (SHOPPING_ID != undefined) {
                url += ("?SHOPPING_ID=" + SHOPPING_ID);
                if (C_ID != undefined) {
                    url += ("&C_ID=" + C_ID);
                }
            }
            else if (C_ID != undefined) {
                url += ("?C_ID=" + C_ID);
            }
            html += (`<A HREF="` + url);
            html += (`"><IMG SRC="${hfs}/images/order_status_B.gif"` + ` ALT="Order Status"></A>
            `);
            html += `<hr><font size=-1>
            <a href="http://www.tpc.org/miscellaneous/TPC_W.folder/Company_Public_Review.html">TPC-W Benchmark</a>,
            <a href="http://www.cae.wisc.edu/~mikko/ece902.html">ECE 902</a>,
            <a href="http://www.cs.wisc.edu/~arch/uwarch">University of Wisconsin Computer Architecture</a>,November 1999.
            </font> </BODY> </HTML>
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
}

module.exports = async (event, context) => {
    return await home_interaction(event.query);
}
