'use strict'

function getRandom(i) {
    return Math.floor(Math.random() * i) + 1;
}
function getRandomString(min, max) {
    var newstring = new String();
    var i;
    var chars = ['a','b','c','d','e','f','g','h','i','j','k',
                 'l','m','n','o','p','q','r','s','t','u','v',
                 'w','x','y','z','A','B','C','D','E','F','G',
                 'H','I','J','K','L','M','N','O','P','Q','R',
                 'S','T','U','V','W','X','Y','Z','!','@','#',
                 '$','%','^','&','*','(',')','_','-','=','+',
                 '{','}','[',']','|',':',';',',','.','?','/',
                 '~',' '];
    var strlen = Math.floor(Math.random() * (max - min + 1));
    strlen += min;
    for (i = 0; i < strlen; i ++) {
        var c = chars[Math.floor(Math.random() * 79)];
        newstring += c;
    }
    return newstring;
}
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
function convert(date) {
    var temp = date;
    temp.setHours(temp.getHours() + 8);
    return temp.toISOString().slice(0, 19).replace('T', ' ');
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

function doBuyConfirm(args) {
    var Result = new Object();
    var ship_addr_id;
    var c_discount;
    var connection = mysql.createConnection({
        host: '192.168.1.126',
        user: 'root',
        password: 'root',
        database: 'tpcw2'
    });
    return new Promise(function (resolve, reject) {
        connection.query("SELECT c_discount FROM customer WHERE customer.c_id = " + args.customer_id, function (err, rows, fields) {
            if (err) {
                reject(err);
            }
            else {
                if (rows.length > 0) {
                    c_discount = rows[0].c_discount;
                    resolve();
                }
                else {
                    reject();
                }
            }
        });
    }).then(function (res) {
        return new Promise(function (resolve, reject) {
            connection.query('SELECT * FROM shopping_cart_line, item WHERE scl_i_id = item.i_id AND scl_sc_id = ' + args.shopping_id, function (err, rows, fields) {
                if (err) {
                    reject(err);
                }
                else {
                    Result.cart = new Cart(rows, c_discount);
                    resolve();
                }
            });
        }).then(function (res) {
            function block() {
                var o_id;
                return new Promise(function (resolve, reject) {
                    connection.query("SELECT count(o_id) FROM orders", function (err, rows, fields) {
                        if (err) {
                            reject(err);
                        }
                        else {
                            o_id = rows[0]["count(o_id)"] + 1;
                            resolve();
                        }
                    });
                }).then(function (res) {
                    var o_bill_addr_id;
                    return new Promise(function (resolve, reject) {
                        connection.query("SELECT c_addr_id FROM customer WHERE customer.c_id = " + args.customer_id, function (err, rows, fields) {
                            if (err) {
                                reject(err);
                            }
                            else {
                                if (rows.length > 0) {
                                    o_bill_addr_id = rows[0].c_addr_id;
                                    resolve();
                                }
                                else {
                                    reject();
                                }
                            }
                        });
                    }).then(function (res) {
                        return new Promise(function (resolve, reject) {
                            connection.query("INSERT into orders (o_id, o_c_id, o_date, o_sub_total, o_tax, o_total, o_ship_type, o_ship_date, o_bill_addr_id, o_ship_addr_id, o_status) VALUES (" + o_id + ", " + args.customer_id + ", CURRENT_DATE, " + Result.cart.SC_SUB_TOTAL + ", 8.25, " + Result.cart.SC_TOTAL + ", '" + args.shipping + "', CURRENT_DATE + INTERVAL " + getRandom(7) + " DAY, " + o_bill_addr_id + ", " + ship_addr_id + ", 'Pending')", function (err, rows, fields) {
                                if (err) {
                                    reject(err);
                                }
                                else {
                                    resolve();
                                }
                            });
                        }).then(function (res) {
                            var es = Result.cart.lines;
                            var counter = 0;
                            function loop(i) {
                                if (i == es.length) {
                                    Result.order_id = o_id;
                                    if (String(args.cc_type).length > 10) {
                                        args.cc_type = String(args.cc_type).substring(0, 10);
                                    }
                                    if (String(args.cc_name).length > 30) {
                                        args.cc_name = String(args.cc_name).substring(0, 30);
                                    }
                                    return new Promise(function (resolve, reject) {
                                        connection.query("INSERT into cc_xacts (cx_o_id, cx_type, cx_num, cx_name, cx_expire, cx_xact_amt, cx_xact_date, cx_co_id) VALUES (" + Result.order_id + ", '" + args.cc_type + "', '" + args.cc_number + "', '" + args.cc_name + "', '" + convert(new Date(args.cc_expiry + " 00:00:00")) + "', " + Result.cart.SC_TOTAL + ", CURRENT_DATE, (SELECT co_id FROM address, country WHERE addr_id = " + ship_addr_id + " AND addr_co_id = co_id))", function (err, rows, fields) {
                                            if (err) {
                                                reject(err);
                                            }
                                            else {
                                                resolve();
                                            }
                                        });
                                    }).then(function (res) {
                                        return new Promise(function (resolve, reject) {
                                            connection.query("DELETE FROM shopping_cart_line WHERE scl_sc_id = " + args.shopping_id, function (err, rows, fields) {
                                                if (err) {
                                                    reject(err);
                                                }
                                                else {
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
                                                            Result: Result
                                                        });
                                                    }
                                                });
                                            });
                                        });
                                    });
                                }
                                else {
                                    var cart_line = es[i];
                                    return new Promise(function (resolve, reject) {
                                        connection.query("INSERT into order_line (ol_id, ol_o_id, ol_i_id, ol_qty, ol_discount, ol_comments) VALUES (" + counter + ", " + o_id + ", " + cart_line.scl_i_id + ", " + cart_line.scl_qty + ", " + c_discount + ", '" + getRandomString(20, 100) + "')", function (err, rows, fields) {
                                            if (err) {
                                                reject(err);
                                            }
                                            else {
                                                resolve();
                                            }
                                        });
                                    }).then(function (res) {
                                        counter ++;
                                        var stock;
                                        return new Promise(function (resolve, reject) {
                                            connection.query("SELECT i_stock FROM item WHERE i_id = " + cart_line.scl_i_id, function (err, rows, fields) {
                                                if (err) {
                                                    reject(err);
                                                }
                                                else {
                                                    if (rows.length > 0) {
                                                        stock = rows[0].i_stock;
                                                        resolve();
                                                    }
                                                    else {
                                                        reject();
                                                    }
                                                }
                                            });
                                        }).then(function (res) {
                                            return new Promise(function (resolve, reject) {
                                                connection.query("UPDATE item SET i_stock = " + String(stock - cart_line.scl_qty) + " WHERE i_id = " + cart_line.scl_i_id, function (err, rows, fields) {
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
                                        })
                                    });
                                }
                            }
                            return loop(0);
                        });
                    });
                });
            }
            if (args.street_1 == undefined) {
                return new Promise(function (resolve, reject) {
                    connection.query("SELECT c_addr_id FROM customer WHERE customer.c_id = " + args.customer_id, function (err, rows, fields) {
                        if (err) {
                            reject(err);
                        }
                        else {
                            if (rows.length > 0) {
                                ship_addr_id = rows[0].c_addr_id;
                                resolve();
                            }
                            else {
                                reject();
                            }
                        }
                    });
                }).then(function (res) {
                    return block();
                });
            }
            else {
                var addr_id = 0;
                var addr_co_id;
                return new Promise(function (resolve, reject) {
                    connection.query("SELECT co_id FROM country WHERE co_name = '" + args.country + "'", function (err, rows, fields) {
                        if (err) {
                            reject(err);
                        }
                        else {
                            if (rows.length > 0) {
                                addr_co_id = rows[0].co_id;
                                resolve();
                            }
                            else {
                                reject();
                            }
                        }
                    });
                }).then(function(res) {
                    return new Promise(function (resolve, reject) {
                        connection.query("SELECT addr_id FROM address WHERE addr_street1 = '" + args.street_1 + "' AND addr_street2 = '" + args.street_2 + "' AND addr_city = '" + args.city + "' AND addr_state = '" + args.state + "' AND addr_zip = '" + args.zip + "' AND addr_co_id = " + addr_co_id, function (err, rows, fields) {
                            if (err) {
                                reject(err);
                            }
                            else {
                                resolve(rows);
                            }
                        });
                    }).then(function (res) {
                        if (res.length == 0) {
                            return new Promise(function (resolve, reject) {
                                connection.query("SELECT max(addr_id) FROM address", function (err, rows, fields) {
                                    if (err) {
                                        reject(err);
                                    }
                                    else {
                                        if (rows[0]["max(addr_id)"] != null) {
                                            addr_id = rows[0]["max(addr_id)"] + 1;
                                        }
                                        resolve();
                                    }
                                });
                            }).then(function (res) {
                                return new Promise(function (resolve, reject) {
                                    connection.query("INSERT into address (addr_id, addr_street1, addr_street2, addr_city, addr_state, addr_zip, addr_co_id) VALUES (" + addr_id + ", '" + args.street_1 + "', '" + args.street_2 + "', '" + args.city + "', '" + args.state + "', '" + args.zip + "', " + addr_co_id + ")", function (err, rows, fields) {
                                        if (err) {
                                            reject(err);
                                        }
                                        else {
                                            resolve();
                                        }
                                    });
                                }).then(function (res) {
                                    ship_addr_id = addr_id;
                                    return block();
                                });
                            });
                        }
                        else {
                            ship_addr_id = res[0].addr_id;
                            return block();
                        }
                    });
                });
            }
        });
    });
}

module.exports = async (event, context) => {
    return await doBuyConfirm(event.body);
}
