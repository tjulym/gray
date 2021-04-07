'use strict'

function numAdd(num1, num2) {
    var baseNum, baseNum1, baseNum2;
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
    return (num1 * baseNum + num2 * baseNum) / baseNum;
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

function numMulti(num1, num2) {
    var baseNum = 0;
    try {
        baseNum += num1.toString().split(".")[1].length;
    } catch (e) {
    }
    try {
        baseNum += num2.toString().split(".")[1].length;
    } catch (e) {
    }
    return Number(num1.toString().replace(".", "")) * Number(num2.toString().replace(".", "")) / Math.pow(10, baseNum);
}

class CartLine {
    constructor(title, cost, srp, backing, qty, id) {
        this.scl_title = title;
        this.scl_cost = cost.toFixed(2);
        this.scl_srp = srp;
        this.scl_backing = backing;
        this.scl_qty = qty;
        this.scl_i_id = id;
    }
}

class Cart {
    constructor(rs, C_DISCOUNT) {
        var i;
        var total_items;
        this.lines  = new Array();
        for (var j = 0; j < rs.length; j ++) {
            var line = new CartLine(rs[j].I_TITLE, rs[j].I_COST, rs[j].I_SRP, rs[j].I_BACKING, rs[j].SCL_QTY, rs[j].SCL_I_ID);
            this.lines.push(line);
        }
        this.SC_SUB_TOTAL = 0;
        total_items = 0;
        for (i = 0; i < this.lines.length; i ++) {
            var thisline = this.lines[i];
            this.SC_SUB_TOTAL = numAdd(this.SC_SUB_TOTAL ,numMulti(thisline.scl_cost, thisline.scl_qty));
            total_items = numAdd(total_items, thisline.scl_qty);
        }
        this.SC_SUB_TOTAL = numMulti(this.SC_SUB_TOTAL, (numMulti(numSub(100 ,C_DISCOUNT), .01))).toFixed(2);
        this.SC_TAX = numMulti(this.SC_SUB_TOTAL, .0825).toFixed(2);
        this.SC_SHIP_COST = numAdd(3.00, numMulti(1.00, total_items)).toFixed(2);
        this.SC_TOTAL = numAdd(numAdd(this.SC_SUB_TOTAL, this.SC_SHIP_COST), this.SC_TAX).toFixed(2);
    }
}

var mysql = require('mysql');

function getCart(args) {
    var mycart;
    var connection = mysql.createConnection({
        host: '192.168.1.126',
        user: 'root',
        password: 'root',
        database: 'tpcw2'
    });
    return new Promise(function (resolve, reject) {
        connection.query('SELECT * FROM shopping_cart_line, item WHERE scl_i_id = item.i_id AND scl_sc_id = ' + args.SHOPPING_ID, function (err, rows, fields) {
            if (err) {
                reject(err);
            }
            else {
                mycart = new Cart(rows, args.c_discount);
                resolve();
            }
        });
    }).then(function (res) {
        return new Promise(function (resolve, reject) {
            connection.end(function (err) {
                if (err) {
                    reject(err);
                }
                else {
                    resolve({
                        cart: mycart
                    });
                }
            })
        })
    })
}

module.exports = async (event, context) => {
    return await getCart(event.body);
}
