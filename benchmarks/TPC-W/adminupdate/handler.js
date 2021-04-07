'use strict'

var mysql = require('mysql');

function adminUpdate(args) {
    var related_items = new Array();
    var connection = mysql.createConnection({
        host: '192.168.1.126',
        user: 'root',
        password: 'root',
        database: 'tpcw2'
    });
    return new Promise(function (resolve, reject) {
        connection.query("UPDATE item SET i_cost = " + args.cost + ", i_image = '" + args.image + "', i_thumbnail = '" + args.thumbnail + "', i_pub_date = CURRENT_DATE WHERE i_id = " + args.i_id, function (err, rows, fields) {
            if (err) {
                reject(err);
            }
            else {
                resolve();
            }
        });
    }).then(function (res) {
        return new Promise(function (resolve, reject) {
            connection.query("SELECT ol_i_id FROM orders, order_line WHERE orders.o_id = order_line.ol_o_id AND NOT (order_line.ol_i_id = " + args.i_id + ") AND orders.o_c_id IN (SELECT o_c_id FROM orders, order_line WHERE orders.o_id = order_line.ol_o_id AND orders.o_id > (SELECT MAX(o_id)-10000 FROM orders) AND order_line.ol_i_id = " + args.i_id + ") GROUP BY ol_i_id ORDER BY SUM(ol_qty) DESC limit 5", function (err, rows, fields) {
                if (err) {
                    reject(err);
                }
                else {
                    var last = 0;
                    for (var i = 0; i < rows.length; i ++) {
                        last = rows[i].ol_i_id;
                        related_items.push(last);
                    }
                    while (related_items.length < 5) {
                        last ++;
                        related_items.push(last);
                    }
                    resolve();
                }
            });
        }).then(function (res) {
            return new Promise(function (resolve, reject) {
                connection.query("UPDATE item SET i_related1 = " + related_items[0] + ", i_related2 = " + related_items[1] + ", i_related3 = " + related_items[2] + ", i_related4 = " + related_items[3] + ", i_related5 = " + related_items[4] + " WHERE i_id = " + args.i_id, function (err, rows, fields) {
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
                            resolve({});
                        }
                    });
                });
            });
        });
    });
}

module.exports = async (event, context) => {
    return await adminUpdate(event.body);
}
