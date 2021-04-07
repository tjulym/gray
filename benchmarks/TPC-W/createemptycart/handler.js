'use strict'

var mysql = require('mysql');

function createEmptyCart(args) {
    var SHOPPING_ID = 0;
    var connection = mysql.createConnection({
        host: '192.168.1.126',
        user: 'root',
        password: 'root',
        database: 'tpcw2'
    });
    return new Promise(function (resolve, reject) {
        connection.query('SELECT COUNT(*) FROM shopping_cart', function (err, rows, fields) {
            if (err) {
                reject(err);
            }
            else {
                SHOPPING_ID = rows[0]["COUNT(*)"];
                resolve();
            }
        });
    }).then(function (res) {
        return new Promise(function (resolve, reject) {
            connection.query('INSERT into shopping_cart (sc_id, sc_time) VALUES (' + SHOPPING_ID + ',CURRENT_TIMESTAMP)', function (err, rows, fields) {
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
                            SHOPPING_ID: SHOPPING_ID
                        });
                    }
                })
            })
        });
    });
}

module.exports = async (event, context) => {
    return await createEmptyCart(event.body);
}
