'use strict'

var mysql = require('mysql');

function getRelated(args) {
    var connection = mysql.createConnection({
        host: '192.168.1.126',
        user: 'root',
        password: 'root',
        database: 'tpcw2'
    });
    return new Promise(function (resolve, reject) {
        connection.query('SELECT J.i_id,J.i_thumbnail from item I, item J where (I.i_related1 = J.i_id or I.i_related2 = J.i_id or I.i_related3 = J.i_id or I.i_related4 = J.i_id or I.i_related5 = J.i_id) and I.i_id = ' + args.I_ID, function (err, rows, fields) {
            if (err) {
                reject(err);
            }
            else {
                resolve(rows);
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
                        rows: res
                    });
                }
            });
        });
    });
}

module.exports = async (event, context) => {
    return await getRelated(event.body);
}
