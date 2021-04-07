'use strict'

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
function convertToDate(date) {
    return new Date(date).toISOString().slice(0, 10);
}

var OpenFaaS = require('openfaas');
var openfaas = new OpenFaaS('http://192.168.1.126:31112');

function product_detail(args) {
    var hfs = "http://192.168.3.12:80";
    var base = "http://192.168.1.126:31112";
    var url;
    var I_IDstr = args.I_ID;
    var C_ID = args.C_ID;
    var SHOPPING_ID = args.SHOPPING_ID;
    var html = ``;
    var params = {
        i_id: I_IDstr
    };
    return openfaas.invoke('getbook', params, {isJson: true, isBinaryResponse: false}).then(result => {
        var res = result.body;
        var mybook = res.book;
        html += `<!DOCTYPE HTML>
        <HTML><HEAD> <TITLE>TPC-W Product Detail Page</TITLE>
        </HEAD> <BODY BGCOLOR="#ffffff"> <H1 ALIGN="center">TPC Web Commerce Benchmark (TPC-W)</H1>
        <CENTER><IMG SRC="${hfs}/images/tpclogo.gif" ALIGN="BOTTOM" BORDER="0" WIDTH="288" HEIGHT="67">
        </CENTER> <H2 ALIGN="center">Product Detail Page</H2>
        <H2> Title: ${mybook.i_title}</H2>
        <P>Author: ${mybook.a_fname} ${mybook.a_lname}<BR>
        Subject: ${mybook.i_subject}
        <P><IMG SRC="${hfs}/images/${mybook.i_image}" ALIGN="RIGHT" BORDER="0" WIDTH="200" HEIGHT="200">
        Decription: <I>${mybook.i_desc}</I></P>
        <BLOCKQUOTE><P><B>Suggested Retail: $${mybook.i_srp}</B>
        <BR><B>Our Price:</B>
        <FONT COLOR="#dd0000"> <B> $${mybook.i_cost}</B></FONT><BR>
        <B>You Save:</B><FONT COLOR="#dd0000"> $${Number(numSub(mybook.i_srp, mybook.i_cost)).toFixed(2)}</B></FONT></P>
        </BLOCKQUOTE><DL><DT><FONT SIZE="2">
        Backing: ${mybook.i_backing}, ${mybook.i_page} pages<BR>
        Published by: ${mybook.i_publisher}<BR>
        Publication date: ${convertToDate(mybook.i_pub_Date)}<BR>
        Avail date: ${convertToDate(mybook.i_avail)}<BR>
        Dimensions (in inches): ${mybook.i_dimensions}<BR>
        ISBN: ${mybook.i_isbn}</FONT></DT></DL><P>
        `;
        url = base + "/function/shoppingcartinteraction?I_ID=" + I_IDstr + "&QTY=1";
        if (SHOPPING_ID != undefined) {
            url += ("&SHOPPING_ID=" + SHOPPING_ID);
        }
        if (C_ID != undefined) {
            url += ("&C_ID=" + C_ID);
        }
        url += "&ADD_FLAG=Y";
        html += `<CENTER> <A HREF="${url}">
        <IMG SRC="${hfs}/images/add_B.gif" ALT="Add to Basket"></A>
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
        html += `<A HREF="${url}"><IMG SRC="${hfs}/images/home_B.gif" ALT="Home"></A>
        `;
        url = base + "/function/adminrequest?I_ID=" + I_IDstr;
        if (SHOPPING_ID != undefined) {
            url += ("&SHOPPING_ID=" + SHOPPING_ID);
        }
        if (C_ID != undefined) {
            url += ("&C_ID=" + C_ID);
        }
        html += `<A HREF="${url}"><IMG SRC="${hfs}/images/update_B.gif" ALT="Update"></A>
        </CENTER></BODY> </HTML>
        `;
        return html;
    }).catch(err => {
        return {
            err: err
        }
    });
}

module.exports = async (event, context) => {
    return await product_detail(event.query);
}
