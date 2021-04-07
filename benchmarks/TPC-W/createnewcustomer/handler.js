'use strict'

function DigSyl(d) {
    var s = "";
    for (; d != 0; d = Math.floor(d / 10)) {
        var c = d % 10;
        s = digS[c] + s;
    }
    return s;
}
function convert(date) {
    var temp = date;
    temp.setHours(temp.getHours() + 8);
    return temp.toISOString().slice(0, 19).replace('T', ' ');
}

var mysql = require('mysql');
var OpenFaaS = require('openfaas');
var openfaas = new OpenFaaS('http://192.168.1.126:31112');

function createNewCustomer(args) {
    var cust = args.cust;
    cust.c_discount = 0.0;
    cust.c_balance = 0.0;
    cust.c_ytd_pmt = 0.0;
    cust.c_last_visit = new Date();
    cust.c_since = new Date();
    cust.c_login = new Date();
    cust.c_expiration = new Date();
    cust.c_expiration.setHours(cust.c_expiration.getHours() + 2);
    var params = {
        street1: cust.addr_street1,
        street2: cust.addr_street2,
        city: cust.addr_city,
        state: cust.addr_state,
        zip: cust.addr_zip,
        country: cust.co_name
    };
    return openfaas.invoke('enteraddress', params, {isJson: true, isBinaryResponse: false}).then(result => {
        var res = result.body;
        cust.addr_id = res.addr_id;
        var connection = mysql.createConnection({
            host: '192.168.1.129',
            user: 'root',
            password: 'root',
            database: 'tpcw2'
        });
        return new Promise(function (resolve, reject) {
            connection.query("SELECT max(c_id) FROM customer", function (err, rows, fields) {
                if (err) {
                    reject(err);
                }
                else {
                    if (rows[0]["max(c_id)"] != null) {
                        cust.c_id = rows[0]["max(c_id)"];
                    }
                    else {
                        cust.c_id = 0;
                    }
                    cust.c_id += 1;
                    cust.c_uname = DigSyl(cust.c_id);
                    cust.c_passwd = cust.c_uname.toLowerCase();
                    resolve();
                }
            });
        }).then(function (res) {
            return new Promise(function (resolve, reject) {
                connection.query("INSERT into customer (c_id, c_uname, c_passwd, c_fname, c_lname, c_addr_id, c_phone, c_email, c_since, c_last_login, c_login, c_expiration, c_discount, c_balance, c_ytd_pmt, c_birthdate, c_data) VALUES (" + cust.c_id + ", '" + cust.c_uname + "', '" + cust.c_uname + "', '" + cust.c_fname + "', '" + cust.c_lname + "', " + cust.addr_id + ", '" + cust.c_phone + "', '" + cust.c_email + "', '" + convert(cust.c_since) + "', '" + convert(cust.c_last_visit) + "', '" + convert(cust.c_login) + "', '" + convert(cust.c_expiration) + "', " + cust.c_discount + ", " + cust.c_balance + ", " + cust.c_ytd_pmt + ", '" + convert(new Date(cust.c_birthdate + " 00:00:00")) + "', '" + cust.c_data + "')", function (err, rows, fields) {
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
                                cust: cust
                            });
                        }
                    });
                });
            });
        });
    }).catch(err => {
        return {
            err: err
        }
    });
}

module.exports = async (event, context) => {
    return await createNewCustomer(event.body);
}
