'use strict'

class Order {
    constructor(rs) {
        this.o_id = rs.O_ID;
        this.c_fname = rs.C_FNAME;
        this.c_lname = rs.C_LNAME;
        this.c_passwd = rs.C_PASSWD;
        this.c_uname = rs.C_UNAME;
        this.c_phone = rs.C_PHONE;
        this.c_email = rs.C_EMAIL;
        this.o_date = rs.O_DATE;
        this.o_subtotal = rs.O_SUB_TOTAL.toFixed(2);
        this.o_tax = rs.O_TAX.toFixed(2);
        this.o_total = rs.O_TOTAL.toFixed(2);
        this.o_ship_type = rs.O_SHIP_TYPE;
        this.o_ship_date = rs.O_SHIP_DATE;
        this.o_status = rs.O_STATUS;
        this.cx_type = rs.cx_type;
        this.bill_addr_street1 = rs.bill_addr_street1;
        this.bill_addr_street2 = rs.bill_addr_street2;
        this.bill_addr_state = rs.bill_addr_state;
        this.bill_addr_zip = rs.bill_addr_zip;
        this.bill_co_name = rs.bill_co_name;
        this.ship_addr_street1 = rs.ship_addr_street1;
        this.ship_addr_street2 = rs.ship_addr_street2;
        this.ship_addr_state = rs.ship_addr_state;
        this.ship_addr_zip = rs.ship_addr_zip;
        this.ship_co_name = rs.ship_co_name;
    }
}

class OrderLine {
    constructor(rs) {
        this.ol_i_id = rs.OL_I_ID;
        this.i_title = rs.I_TITLE;
        this.i_publisher = rs.I_PUBLISHER;
        this.i_cost = rs.I_COST.toFixed(2);
        this.ol_qty = rs.OL_QTY;
        this.ol_discount = rs.OL_DISCOUNT;
        this.ol_comments = rs.OL_COMMENTS;
    }
}

var mysql = require('mysql');

function getMostRecentOrder(args) {
    var order_lines = new Array();
    var order_id;
    var order;
    var connection = mysql.createConnection({
        host: '192.168.1.126',
        user: 'root',
        password: 'root',
        database: 'tpcw2'
    });
    return new Promise(function (resolve, reject) {
        connection.query("SELECT o_id FROM customer, orders WHERE customer.c_id = orders.o_c_id AND c_uname = '" + args.C_UNAME + "' ORDER BY o_date DESC, orders.o_id DESC limit 1", function (err, rows, fields) {
            if (err) {
                reject(err);
            }
            else {
                if (rows.length > 0) {
                    order_id = rows[0].o_id;
                }
                resolve();
            }
        });
    }).then(function (res) {
        return new Promise(function (resolve, reject) {
            if (order_id != undefined) {
                connection.query('SELECT orders.*, customer.*, cc_xacts.cx_type, ship.addr_street1 AS ship_addr_street1, ship.addr_street2 AS ship_addr_street2, ship.addr_state AS ship_addr_state, ship.addr_zip AS ship_addr_zip, ship_co.co_name AS ship_co_name, bill.addr_street1 AS bill_addr_street1, bill.addr_street2 AS bill_addr_street2, bill.addr_state AS bill_addr_state, bill.addr_zip AS bill_addr_zip, bill_co.co_name AS bill_co_name FROM customer, orders, cc_xacts, address AS ship, country AS ship_co, address AS bill, country AS bill_co WHERE orders.o_id = ' + order_id + ' AND cx_o_id = orders.o_id AND customer.c_id = orders.o_c_id AND orders.o_bill_addr_id = bill.addr_id AND bill.addr_co_id = bill_co.co_id AND orders.o_ship_addr_id = ship.addr_id AND ship.addr_co_id = ship_co.co_id AND orders.o_c_id = customer.c_id', function (err, rows, fields) {
                    if (err) {
                        reject(err);
                    }
                    else {
                        if (rows.length > 0) {
                            order = new Order(rows[0]);
                        }
                        resolve();
                    }
                });
            }
            else {
                resolve();
            }
        }).then(function (res) {
            return new Promise(function (resolve, reject) {
                if (order != undefined) {
                    connection.query('SELECT * FROM order_line, item WHERE ol_o_id = ' + order_id + ' AND ol_i_id = i_id', function (err, rows, fields) {
                        if (err) {
                            reject(err);
                        }
                        else {
                            for (var i = 0; i < rows.length; i ++) {
                                order_lines.push(new OrderLine(rows[i]));
                            }
                            resolve();
                        }
                    });
                }
                else {
                    resolve();
                }
            }).then(function (res) {
                return new Promise(function (resolve, reject) {
                    connection.end(function (err) {
                        if (err) {
                            reject(err);
                        }
                        else {
                            resolve({
                                order: order,
                                order_lines: order_lines
                            });
                        }
                    });
                });
            });
        });
    });
}

module.exports = async (event, context) => {
    return await getMostRecentOrder(event.body);
}
