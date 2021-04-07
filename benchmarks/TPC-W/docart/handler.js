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

function doCart(args) {
    var connection = mysql.createConnection({
        host: '192.168.1.126',
        user: 'root',
        password: 'root',
        database: 'tpcw2'
    });
    function loop(i) {
        if (i == args.ids.length) {
            return new Promise(function (resolve, reject) {
                connection.query('UPDATE shopping_cart SET sc_time = CURRENT_TIMESTAMP WHERE sc_id = ' + args.SHOPPING_ID, function (err, rows, fields) {
                    if (err) {
                        reject(err);
                    }
                    else {
                        resolve();
                    }
                });
            }).then(function (res) {
                var cart;
                return new Promise(function (resolve, reject) {
                    connection.query('SELECT * FROM shopping_cart_line, item WHERE scl_i_id = item.i_id AND scl_sc_id = ' + args.SHOPPING_ID, function (err, rows, fields) {
                        if (err) {
                            reject(err);
                        }
                        else {
                            cart = new Cart(rows, 0.0);
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
                                    cart: cart
                                });
                            }
                        })
                    })
                })
            });
        }
        else {
            var I_IDstr = String(args.ids[i]);
            var QTYstr = String(args.quantities[i]);
            var QTY = Number(QTYstr);
            if (QTY == 0) {
                return new Promise(function (resolve, reject) {
                    connection.query('DELETE FROM shopping_cart_line WHERE scl_sc_id = ' + args.SHOPPING_ID + ' AND scl_i_id = ' + I_IDstr, function (err, rows, fields) {
                        if (err) {
                            reject(err);
                        }
                        else {
                            resolve();
                        }
                    });
                }).then(function (res) {
                    return loop(i + 1);
                });
            }
            else {
                return new Promise(function (resolve, reject) {
                    connection.query('UPDATE shopping_cart_line SET scl_qty = ' + QTYstr + ' WHERE scl_sc_id = ' + args.SHOPPING_ID + ' AND scl_i_id = ' + I_IDstr, function (err, rows, fields) {
                        if (err) {
                            reject(err);
                        }
                        else {
                            resolve();
                        }
                    });
                }).then(function (res) {
                    return loop(i + 1);
                });
            }
        }
    }
    if (args.I_ID != undefined) {
        return new Promise(function (resolve, reject) {
            connection.query("SELECT scl_qty FROM shopping_cart_line WHERE scl_sc_id = " + args.SHOPPING_ID + " AND scl_i_id = " + args.I_ID, function (err, rows, fields) {
                if (err) {
                    reject(err);
                }
                else {
                    resolve(rows);
                }
            });
        }).then(function (res) {
            if (res.length > 0) {
                var currqty = Number(res[0].scl_qty);
                currqty += 1;
                return new Promise(function (resolve, reject) {
                    connection.query("UPDATE shopping_cart_line SET scl_qty = " + currqty + " WHERE scl_sc_id = " + args.SHOPPING_ID + " AND scl_i_id = " + args.I_ID, function (err, rows, fields) {
                        if (err) {
                            reject(err);
                        }
                        else {
                            resolve();
                        }
                    });
                }).then(function (res) {
                    return loop(0);
                });
            }
            else {
                return new Promise(function (resolve, reject) {
                    connection.query('INSERT into shopping_cart_line (scl_sc_id, scl_qty, scl_i_id) VALUES (' + args.SHOPPING_ID + ',1,' + args.I_ID + ')', function (err, rows, fields) {
                        if (err) {
                            reject(err);
                        }
                        else {
                            resolve();
                        }
                    });
                }).then(function (res) {
                    return loop(0);
                });
            }
        });
    }
    else {
        return loop(0);
    }       
}

module.exports = async (event, context) => {
    return await doCart(event.body);
}
