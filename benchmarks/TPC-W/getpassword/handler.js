'use strict'

var mysql = require('mysql');

function getPassword(args) {
    var passwd;
    var connection = mysql.createConnection({
        host: '192.168.1.126',
        user: 'root',
        password: 'root',
        database: 'tpcw2'
    });
    return new Promise(function (resolve, reject) {
        connection.query("SELECT c_passwd FROM customer WHERE c_uname = '" + args.C_UNAME + "'", function (err, rows, fields) {
            if (err) {
                reject(err);
            }
            else {
                if (rows.length > 0) {
                    passwd = rows[0].c_passwd;
                }
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
                        passwd: passwd
                    });
                }
            });
        });
    });
}

module.exports = async (event, context) => {
    return await getPassword(event.body);
}
