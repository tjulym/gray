'use strict'

var mysql = require('mysql');

function getUserName(args) {
    var u_name;
    var connection = mysql.createConnection({
        host: '192.168.1.126',
        user: 'root',
        password: 'root',
        database: 'tpcw2'
    });
    return new Promise(function (resolve, reject) {
        connection.query("SELECT c_uname FROM customer WHERE c_id = " + args.C_ID, function (err, rows, fields) {
            if (err) {
                reject(err);
            }
            else {
                if (rows.length > 0) {
                    u_name = rows[0].c_uname;
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
                    if (u_name != undefined) {
                        resolve({
                            u_name: u_name
                        });
                    }
                    else {
                        resolve({});
                    }
                }
            });
        })
    })
}

module.exports = async (event, context) => {
    return await getUserName(event.body);
}
