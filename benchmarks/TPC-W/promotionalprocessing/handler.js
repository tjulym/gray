'use strict'

var NUM_ITEMS = 10000;

function getRandomI_ID() {
    return Math.floor(Math.random() * NUM_ITEMS);
}

var OpenFaaS = require('openfaas');
var openfaas = new OpenFaaS('http://192.168.1.126:31112');

function displayPromotions(args) {
    var hfs = "http://192.168.3.12:80";
    var base = "http://192.168.1.126:31112";
    var I_ID = getRandomI_ID();
    var i;
    var url;
    var params = {
        I_ID: I_ID
    };
    return openfaas.invoke('getrelated', params, {isJson: true, isBinaryResponse: false}).then(result => {
        var res = result.body;
        var C_ID = args.C_ID;
        var SHOPPING_ID = args.SHOPPING_ID;
        var new_sid = args.new_sid;
        var html = `<TABLE ALIGN=CENTER BORDER=0 WIDTH=660>
        <TR ALIGN=CENTER VALIGN=top>
        <TD COLSPAN=5><B><FONT COLOR=#ff0000 SIZE=+1>Click on one of our latest books to find out more!</FONT></B></TD></TR>
        <TR ALIGN=CENTER VALIGN=top>
        `;
        for (i = 0; i < res.rows.length; i ++) {
            url = base + "/function/productdetail";
            url += ("?I_ID=" + String(res.rows[i].i_id));
            if (SHOPPING_ID != undefined) {
                url += ("&SHOPPING_ID=" + SHOPPING_ID);
            }
            else if (new_sid != -1) {
                url += ("&SHOPPING_ID=" + new_sid);
            }
            if (C_ID != undefined) {
                url += ("&C_ID=" + C_ID);
            }
            html += (`<TD><A HREF="` + url + `"><IMG SRC="${hfs}/images/` + res.rows[i].i_thumbnail + `" ALT="Book ` + String(i + 1) + `" WIDTH="100" HEIGHT="150"></A>
            </TD>
            `);
        }
        html += `</TR></TABLE>
        `;
        return {
            html: html
        };
    }).catch(err => {
        return {
            err: err
        }
    });
}

module.exports = async (event, context) => {
    return await displayPromotions(event.body);
}
