'use strict'

class Customer {
    constructor(rs) {
        this.c_id = rs.C_ID;
        this.c_uname = rs.C_UNAME;
        this.c_passwd = rs.C_PASSWD;
        this.c_fname = rs.C_FNAME;
        this.c_lname = rs.C_LNAME;
        this.c_phone = rs.C_PHONE;
        this.c_email = rs.C_EMAIL;
        this.c_since = rs.C_SINCE;
        this.c_last_visit = rs.C_LAST_VISIT;
        this.c_login = rs.C_LOGIN;
        this.c_expiration = rs.C_EXPIRATION;
        this.c_discount = rs.C_DISCOUNT;
        this.c_balance = rs.C_BALANCE;
        this.c_ytd_pmt = rs.C_YTD_PMT;
        this.c_birthdate = rs.C_BIRTHDATE;
        this.c_data = rs.C_DATA;
        this.addr_id = rs.ADDR_ID;
        this.addr_street1 = rs.ADDR_STREET1;
        this.addr_street2 = rs.ADDR_STREET2;
        this.addr_city = rs.ADDR_CITY;
        this.addr_state = rs.ADDR_STATE;
        this.addr_zip = rs.ADDR_ZIP;
        this.addr_co_id = rs.ADDR_CO_ID;
        this.co_name = rs.CO_NAME;
    }
}

var mysql = require('mysql');

function getCustomer(args) {
    var cust;
    var connection = mysql.createConnection({
        host: '192.168.1.126',
        user: 'root',
        password: 'root',
        database: 'tpcw2'
    });
    return new Promise(function (resolve, reject) {
        connection.query("SELECT * FROM customer, address, country WHERE customer.c_addr_id = address.addr_id AND address.addr_co_id = country.co_id AND customer.c_uname = '" + args.UNAME + "'", function (err, rows, fields) {
            if (err) {
                reject(err);
            }
            else {
                if (rows.length > 0) {
                    cust = new Customer(rows[0]);
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
                        cust: cust
                    });
                }
            });
        })
    });
}

module.exports = async (event, context) => {
    return await getCustomer(event.body);
}
