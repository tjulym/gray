'use strict'

class Book {
    constructor(rs) {
        this.i_id = rs.I_ID;
        this.i_title = rs.I_TITLE;
        this.i_pub_Date = rs.I_PUB_DATE;
        this.i_publisher = rs.I_PUBLISHER;
        this.i_subject = rs.SUBJECT;
        this.i_desc = rs.I_DESC;
        this.i_related1 = rs.I_RELATED1;
        this.i_related2 = rs.I_RELATED2;
        this.i_related3 = rs.I_RELATED3;
        this.i_related4 = rs.I_RELATED4;
        this.i_related5 = rs.I_RELATED5;
        this.i_thumbnail = rs.I_THUMBNAIL;
        this.i_image = rs.I_IMAGE;
        this.i_srp = rs.I_SRP;
        this.i_cost = rs.I_COST.toFixed(2);
        this.i_avail = rs.I_AVAIL;
        this.i_isbn = rs.I_ISBN;
        this.i_page = rs.I_PAGE;
        this.i_backing = rs.I_BACKING;
        this.i_dimensions = rs.I_DIEMNSIONS;
        this.a_id = rs.A_ID;
        this.a_fname = rs.A_FNAME;
        this.a_lname = rs.A_LNAME;
    }
}

var mysql = require('mysql');

function  doAuthorSearch(args) {
    var vec = new Array();
    var connection = mysql.createConnection({
        host: '192.168.1.126',
        user: 'root',
        password: 'root',
        database: 'tpcw2'
    });
    return new Promise(function (resolve, reject) {
        connection.query("SELECT * FROM author, item WHERE substring(soundex(author.a_lname),0,4)=substring(soundex('" + args.search_key + "'),0,4) AND item.i_a_id = author.a_id ORDER BY item.i_title limit 50", function (err, rows, fields) {
            if (err) {
                reject(err);
            }
            else {
                for (var i = 0; i < rows.length; i ++){
                    vec.push(new Book(rows[i]));
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
    return await doAuthorSearch(event.body);
}
