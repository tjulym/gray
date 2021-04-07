'use strict'

var mysql = require('mysql');

function getName(args) {
    var connection = mysql.createConnection({
        host: '192.168.1.126',
        user: 'root',
        password: 'root',
        database: 'tpcw2'
    });
    return new Promise(function (resolve, reject) {
        connection.query('SELECT c_fname,c_lname FROM customer WHERE c_id = ' + args.C_ID, function (err, rows, fields) {
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
    return await getName(event.body);
}
