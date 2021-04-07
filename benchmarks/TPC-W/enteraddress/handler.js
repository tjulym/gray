'use strict'

var mysql = require('mysql');

function enterAddress(args) {
    var addr_id = 0;
    var addr_co_id;
    var connection = mysql.createConnection({
        host: '192.168.1.126',
        user: 'root',
        password: 'root',
        database: 'tpcw2'
    });
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
    }).then(function (res) {
        return new Promise(function (resolve, reject) {
            connection.query("SELECT addr_id FROM address WHERE addr_street1 = '" + args.street1 + "' AND addr_street2 = '" + args.street2 + "' AND addr_city = '" + args.city + "' AND addr_state = '" + args.state + "' AND addr_zip = '" + args.zip + "' AND addr_co_id = " + addr_co_id, function (err, rows, fields) {
                if (err) {
                    reject(err);
                }
                else {
                    resolve(rows);
                }
            });
        }).then (function (res) {
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
                        connection.query("INSERT into address (addr_id, addr_street1, addr_street2, addr_city, addr_state, addr_zip, addr_co_id) VALUES (" + addr_id + ", '" + args.street1 + "', '" + args.street2 + "', '" + args.city + "', '" + args.state + "', '" + args.zip + "', " + addr_co_id + ")", function (err, rows, fields) {
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
                                        addr_id: addr_id
                                    });
                                }
                            });
                        });
                    });
                });
            }
            else {
                addr_id = res[0].addr_id;
                return {
                    addr_id: addr_id
                };
            }
        });
    });
}

module.exports = async (event, context) => {
    return await enterAddress(event.body);
}
