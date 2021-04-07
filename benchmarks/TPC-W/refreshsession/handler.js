'use strict'

var mysql = require('mysql');

function refreshSession(args) {
    var connection = mysql.createConnection({
        host: '192.168.1.126',
        user: 'root',
        password: 'root',
        database: 'tpcw2'
    });
    return new Promise(function (resolve, reject) {
        connection.query("UPDATE customer SET c_login = NOW(), c_expiration = (CURRENT_TIMESTAMP + INTERVAL 2 HOUR) WHERE c_id = " + args.C_ID, function (err, rows, fields) {
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
            })
        });
    });
}

module.exports = async (event, context) => {
    return await refreshSession(event.body);
}
