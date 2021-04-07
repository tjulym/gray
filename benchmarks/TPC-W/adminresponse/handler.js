'use strict'

function isValidPrice(val) {
    if (parseFloat(val).toString() == "NaN") {
        return false;
    }
    else if (Number(val) <= 0){
        return false;
    }
    return true;
}
function convertToDate(date) {
    return new Date(date).toISOString().slice(0, 10);
}
function numSub(num1, num2) {
    var baseNum, baseNum1, baseNum2;
    var precision;
    try {
        baseNum1 = num1.toString().split(".")[1].length;
    } catch (e) {
        baseNum1 = 0;
    }
    try {
        baseNum2 = num2.toString().split(".")[1].length;
    } catch (e) {
        baseNum2 = 0;
    }
    baseNum = Math.pow(10, Math.max(baseNum1, baseNum2));
    precision = (baseNum1 >= baseNum2) ? baseNum1 : baseNum2;
    return ((num1 * baseNum - num2 * baseNum) / baseNum).toFixed(precision);
}

var OpenFaaS = require('openfaas');
var openfaas = new OpenFaaS('http://192.168.1.126:31112');

function admin_response(args) {
    var hfs = "http://192.168.3.12:80";
    var base = "http://192.168.1.126:31112";
    var html = ``;
    var url;
    var I_ID = args.I_ID;
    var I_NEW_IMAGE = args.I_NEW_IMAGE;
    var I_NEW_THUMBNAIL = args.I_NEW_THUMBNAIL;
    var I_NEW_COSTstr = args.I_NEW_COST;
    var C_ID = args.C_ID;
    var SHOPPING_ID = args.SHOPPING_ID;
    var params = {
        i_id: I_ID
    };
    var res;
    return openfaas.invoke('getbook', params, {isJson: true, isBinaryResponse: false}).then(result => {
        res = result.body;
        var book = res.book;
        html += `<!DOCTYPE HTML>
        <HTML> <HEAD><TITLE>TPC-W Admin Response Page</TITLE></HEAD>
        <BODY BGCOLOR="#FFFFFF">
        <H1 ALIGN="CENTER">TPC Web Commerce Benchmark (TPC-W)</H1>
        <H2 ALIGN="CENTER"><IMG SRC="${hfs}/images/tpclogo.gif" ALIGN="BOTTOM" BORDER="0" WIDTH="288" HEIGHT="67"></H2> `;
        if (!isValidPrice(I_NEW_COSTstr) || String(I_NEW_IMAGE).length == 0 || String(I_NEW_THUMBNAIL).length == 0) {
            html += `<H2>Invalid Input</H2>`;
            html += `</BODY></HTML>`;
            return html;
        }
        else {
            I_NEW_COSTstr = Number(I_NEW_COSTstr).toFixed(2);
            params = {
                i_id: I_ID,
                cost: I_NEW_COSTstr,
                image: I_NEW_IMAGE,
                thumbnail: I_NEW_THUMBNAIL 
            };
            return openfaas.invoke('adminupdate', params, {isJson: true, isBinaryResponse: false}).then(result => {
                res = result.body;
                html += `<H2>Product Updated</H2><H2>Title: ${book.i_title}</H2>
                <P>Author: ${book.a_fname} ${book.a_lname}</P>
                <P><IMG SRC="${hfs}/images/${I_NEW_IMAGE}" ALIGN="RIGHT" BORDER="0" WIDTH="200" HEIGHT="200"><IMG SRC="${hfs}/images/${I_NEW_THUMBNAIL}" ALT="Book 1" ALIGN="RIGHT" WIDTH="100" HEIGHT="150">
                Description: ${book.i_desc}</P>
                <BLOCKQUOTE><P><B>Suggested Retail: $${book.i_srp}</B><BR><B>Our Price: </B><FONT COLOR="#DD0000"><B>$${I_NEW_COSTstr}</B></FONT><BR><B>You Save: </B><FONT COLOR="#DD0000"><B>$${numSub(book.i_srp, I_NEW_COSTstr)}</B></FONT></P></BLOCKQUOTE> <P><FONT SIZE="2">${book.i_backing}, ${book.i_page} pages<BR>
                Published by: ${book.i_publisher}<BR>
                Publication date: ${convertToDate(book.i_pub_Date)}<BR>
                Dimensions (in inches): ${book.i_dimensions}<BR>
                ISBN: ${book.i_isbn}</FONT><BR CLEAR="ALL"></P>
                <CENTER><P>`;
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
                html += `<A HREF="${url}"><IMG SRC="${hfs}/images/home_B.gif" ALT="Home"></A></P></CENTER>
                </FORM>
                `;
                html += `</BODY></HTML>`;
                return html;
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

module.exports = async (event, context) => {
    return await admin_response(event.query);
}
