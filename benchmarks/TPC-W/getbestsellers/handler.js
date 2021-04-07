'use strict'

class ShortBook {
    constructor(rs) {
        this.i_id = rs.i_id;
        this.i_title = rs.i_title;
        this.a_fname = rs.a_fname;
        this.a_lname = rs.a_lname;
    }
}

var mysql = require('mysql');

function getBestSellers(args) {
    var vec = new Array();
    var connection = mysql.createConnection({
        host: '192.168.1.126',
        user: 'root',
        password: 'root',
        database: 'tpcw2'
    });
    return new Promise(function (resolve, reject) {
        connection.query("SELECT i_id, i_title, a_fname, a_lname FROM item, author, order_line WHERE item.i_id = order_line.ol_i_id AND item.i_a_id = author.a_id AND order_line.ol_o_id > (SELECT MAX(o_id)-3333 FROM orders) AND item.i_subject = '" + args.subject + "' GROUP BY i_id, i_title, a_fname, a_lname ORDER BY SUM(ol_qty) DESC limit 50", function (err, rows, fields) {
            if (err) {
                reject(err);
            }
            else {
                for (var i = 0; i < rows.length; i ++){
                    vec.push(new ShortBook(rows[i]));
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
                        books: vec
                    });
                }
            });
        });
    });
}

module.exports = async (event, context) => {
    return await getBestSellers(event.body);
}
