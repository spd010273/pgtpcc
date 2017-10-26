CREATE TABLE warehouse
(
    w_id        INTEGER PRIMARY KEY NOT NULL,
    w_name      VARCHAR(10) NOT NULL,
    w_street_1  VARCHAR(20) NOT NULL,
    w_street_2  VARCHAR(20) NOT NULL,
    w_city      VARCHAR(20) NOT NULL,
    w_state     CHAR(2) NOT NULL,
    w_zip       CHAR(9) NOT NULL,
    w_tax       NUMERIC(4,4) NOT NULL,
    w_ytd       NUMERIC(12,2) NOT NULL
);

CREATE TABLE district
(
    d_id        INTEGER NOT NULL,
    d_w_id      INTEGER NOT NULL REFERENCES warehouse NOT NULL,
    d_name      VARCHAR(10) NOT NULL,
    d_street_1  VARCHAR(20) NOT NULL,
    d_street_2  VARCHAR(20) NOT NULL,
    d_city      VARCHAR(20) NOT NULL,
    d_state     CHAR(2) NOT NULL,
    d_zip       CHAR(9) NOT NULL,
    d_tax       NUMERIC(4,4) NOT NULL,
    d_ytd       NUMERIC(12,2) NOT NULL,
    d_next_o_id INTEGER NOT NULL,
    PRIMARY KEY( d_w_id, d_id )
);

CREATE TABLE customer
(
    c_id            INTEGER NOT NULL,
    c_d_id          INTEGER NOT NULL,
    c_w_id          INTEGER NOT NULL,
    c_first         VARCHAR(16) NOT NULL,
    c_middle        CHAR(2) NOT NULL,
    c_last          VARCHAR(16) NOT NULL,
    c_street_1      VARCHAR(20) NOT NULL,
    c_street_2      VARCHAR(20) NOT NULL,
    c_city          VARCHAR(20) NOT NULL,
    c_state         CHAR(2) NOT NULL,
    c_zip           CHAR(9) NOT NULL,
    c_phone         CHAR(16) NOT NULL,
    c_since         TIMESTAMP NOT NULL,
    c_credit        CHAR(2) NOT NULL,
    c_credit_lim    NUMERIC(12,2) NOT NULL,
    c_discount      NUMERIC(4,4) NOT NULL,
    c_balance       NUMERIC(12,2) NOT NULL,
    c_ytd_payment   NUMERIC(12,2) NOT NULL,
    c_payment_cnt   NUMERIC(4) NOT NULL,
    c_delivery_cnt  NUMERIC(4) NOT NULL,
    c_data          VARCHAR(500) NOT NULL,
    PRIMARY KEY( c_w_id, c_d_id, c_id ),
    FOREIGN KEY ( c_w_id, c_d_id ) REFERENCES district;
);

CREATE TABLE history
(
    h_c_id          INTEGER NOT NULL,
    h_c_d_id        INTEGER NOT NULL,
    h_c_w_id        INTEGER NOT NULL,
    h_d_id          INTEGER NOT NULL,
    h_w_id          INTEGER NOT NULL,
    h_date          TIMESTAMP NOT NULL,
    h_amount        NUMERIC(6,2) NOT NULL,
    h_data          VARCHAR(24) NOT NULL,
    FOREIGN KEY( h_c_w_id, h_c_d_id, h_c_id ) REFERENCES customer,
    FOREIGN KEY( h_w_id, h_d_id ) REFERENCES district
);

CREATE TABLE "order"
(
    o_id            INTEGER NOT NULL,
    o_d_id          INTEGER NOT NULL,
    o_w_id          INTEGER NOT NULL,
    o_c_id          INTEGER NOT NULL,
    o_entry_d       TIMESTAMP NOT NULL,
    o_carrier_id    INTEGER NOT NULL NOT NULL,
    o_ol_cnt        NUMERIC(2) NOT NULL NOT NULL,
    o_all_local     NUMERIC(1) NOT NULL NOT NULL,
    PRIMARY KEY( o_w_id, o_d_id, o_id ),
    FOREIGN KEY (o_w_id, o_d_id, o_c_id ) REFERENCES customer
);

CREATE TABLE new_order
(
    no_o_id         INTEGER NOT NULL NOT NULL,
    no_d_id         INTEGER NOT NULL NOT NULL,
    no_w_id         INTEGER NOT NULL NOT NULL,
    PRIMARY KEY( no_w_id, no_d_id, no_o_id ),
    FOREIGN KEY( no_w_id, no_d_id, no_o_id ) REFERENCES "order"
);

CREATE TABLE order_line
(
    ol_o_id         INTEGER NOT NULL,
    ol_d_id         INTEGER NOT NULL,
    ol_w_id         INTEGER NOT NULL,
    ol_number       INTEGER NOT NULL,
    ol_i_id         INTEGER NOT NULL,
    ol_supply_w_id  INTEGER NOT NULL,
    ol_delivery_d   TIMESTAMP,
    ol_quantity     NUMERIC(2) NOT NULL,
    ol_amount       NUMERIC(6,2) NOT NULL,
    ol_dist_info    TEXT(24) NOT NULL
);

CREATE TABLE item
(
    i_id            INTEGER PRIMARY KEY,
    i_im_id         INTEGER NOT NULL,
    i_name          VARCHAR(24) NOT NULL,
    i_price         NUMERIC(5,2) NOT NULL,
    i_data          VARCHAR(50)
);

CREATE TABLE stock
(
    s_i_id          INTEGER NOT NULL,
    s_w_id          INTEGER NOT NULL,
    s_quantity      NUMERIC(4) NOT NULL,
    s_dist_01       CHAR(24) NOT NULL,
    s_dist_02       CHAR(24) NOT NULL,
    s_dist_03       CHAR(24) NOT NULL,
    s_dist_04       CHAR(24) NOT NULL,
    s_dist_05       CHAR(24) NOT NULL,
    s_dist_06       CHAR(24) NOT NULL,
    s_dist_07       CHAR(24) NOT NULL,
    s_dist_08       CHAR(24) NOT NULL,
    s_dist_09       CHAR(24) NOT NULL,
    s_dist_10       CHAR(24) NOT NULL,
    s_ytd           NUMERIC(8) NOT NULL,
    s_order_cnt     NUMERIC(4) NOT NULL,
    s_remote_cnt    NUMERIC(4) NOT NULL,
    s_data          VARCHAR(50) NOT NULL,
    PRIMARY KEY( s_w_id, s_i_id ),
    FOREIGN KEY ( s_w_id ) REFERENCES warehouse,
    FOREIGN KEY ( s_i_id ) REFERENCES item
);

/*
    TPC-C v5.11 Sizing guidelines:
        Warehouse: W unique keys
        District: W*10 unique keys
        Stock: W*100000 unique keys
        Customer: W*30000 unique keys
        History: W*30000+ unique keys
        Order: W*30000+ unique keys
        Order-Line: W*300000+ unique keys
        New-Order: W*9000+ unique keys
        Item: 100000 unique keys
*/
