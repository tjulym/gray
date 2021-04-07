'use strict'

var OpenFaaS = require('openfaas');
var openfaas = new OpenFaaS('http://192.168.1.126:31112');

function new_products(args) {
    var hfs = "http://192.168.3.12:80";
    var base = "http://192.168.1.126:31112";
    var html = ``;
    var i;
    var url;
    var subject = args.subject;
    var C_ID = args.C_ID;
    var SHOPPING_ID = args.SHOPPING_ID;
    html += `<!DOCTYPE HTML>
    <HTML><HEAD><TITLE> New ${subject}</TITLE></HEAD>
    <BODY BGCOLOR="#ffffff">
    <H1 ALIGN="center">TPC Web Commerce Benchmark (TPC-W)</H1>
    <P ALIGN="center">
    <IMG SRC="${hfs}/images/tpclogo.gif" ALIGN="BOTTOM" BORDER="0" WIDTH="288" HEIGHT="67"> </P> <P></P>
    <H2 ALIGN="center">New Products Page - Subject: ${subject}</H2>
    `;
    var params = {
        C_ID: C_ID,
        SHOPPING_ID: SHOPPING_ID,
        new_sid: -1
    };
    return openfaas.invoke('promotionalprocessing', params, {isJson: true, isBinaryResponse: false}).then(result => {
        var res = result.body;
        html += res.html;
        html += `<TABLE ALIGN="center" BORDER="1" CELLPADDING="1" CELLSPACING="1">
        <TR> <TD WIDTH="30"></TD>
        <TD><FONT SIZE="+1">Author</FONT></TD>
        <TD><FONT SIZE="+1">Title</FONT></TD></TR>
        `;
        params = {
            subject: subject
        };
        return openfaas.invoke('getnewproducts', params, {isJson: true, isBinaryResponse: false}).then(result => {
            res = result.body;
            var books = res.books;
            for (i = 0; i < books.length; i ++) {
                var book = books[i];
                html += `<TR><TD>${i + 1}</TD>
                <TD><I>${book.a_fname} ${book.a_lname}</I></TD>
                `;
                url = base + "/function/productdetail?I_ID=" + String(book.i_id);
                if (SHOPPING_ID != undefined) {
                    url += ("&SHOPPING_ID=" + SHOPPING_ID);
                }
                if (C_ID != undefined) {
                    url += ("&C_ID=" + C_ID);
                }
                html += `<TD><A HREF="${url}">${book.i_title}</A></TD></TR>
                `;
            }
            html += `</TABLE><CENTER><P>
            `;
            url = base + "/function/shoppingcartinteraction?ADD_FLAG=N";
            if (SHOPPING_ID != undefined) {
                url += ("&SHOPPING_ID=" + SHOPPING_ID);
            }
            if (C_ID != undefined) {
                url += ("&C_ID=" + C_ID);
            }
            html += `<A HREF="${url}"><IMG SRC="${hfs}/images/shopping_cart_B.gif" ALT="Shopping Cart"></A>
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
            html += `<A HREF="${url}"><IMG SRC="${hfs}/images/home_B.gif" ALT="Home"></A></P></CENTER>
            </BODY> </HTML>
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
    return await new_products(event.query);
}
