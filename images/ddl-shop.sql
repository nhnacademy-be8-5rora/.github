create table addresses
(
    id                   bigint auto_increment
        primary key,
    address_road_address varchar(255) not null,
    constraint UKb5eopoy57wrhcb9x5og20h8sx
        unique (address_road_address)
);

create table author_roles
(
    id   bigint auto_increment
        primary key,
    role varchar(255) not null,
    constraint UKg5d3i1fs5gmjitvbn56bdgo9n
        unique (role)
);

create table authors
(
    id   bigint auto_increment
        primary key,
    name varchar(30) not null
);

create table categories
(
    id        bigint auto_increment
        primary key,
    name      varchar(20) not null,
    parent_id bigint      null,
    depth     int         not null,
    constraint fk_parent_category
        foreign key (parent_id) references categories (id)
            on delete cascade
);

create table point_policies
(
    id                    int auto_increment
        primary key,
    point_policy_value    decimal(10, 1)                                     not null,
    point_policy_name     varchar(50)                                        not null,
    point_policy_type     enum ('AMOUNT', 'PERCENTAGE')                      not null,
    is_active             bit                                                not null,
    point_policy_category enum ('ORDER', 'REVIEW', 'REVIEW_IMAGE', 'SIGNUP') not null,
    constraint unique_point_policy_name
        unique (point_policy_name)
);

create table publishers
(
    id   bigint auto_increment
        primary key,
    name varchar(50) not null,
    constraint UKan1ucpx8sw2qm194mlok8e5us
        unique (name)
);

create table roles
(
    id        bigint auto_increment
        primary key,
    role_name varchar(255) not null,
    constraint UK716hgxp60ym1lifrdgp67xt5k
        unique (role_name)
);

create table series
(
    id   bigint auto_increment
        primary key,
    name varchar(100) not null,
    constraint UKs4jd0prfged1pucstgaoh8qj4
        unique (name)
);

create table books
(
    is_sale       bit          not null,
    packaging     bit          not null,
    publish_date  date         not null,
    regular_price int          not null,
    sale_price    int          not null,
    stock         int          not null,
    id            bigint auto_increment
        primary key,
    publisher_id  bigint       not null,
    series_id     bigint       null,
    isbn          varchar(13)  not null,
    contents      text         null,
    explanation   text         not null,
    title         varchar(255) not null,
    constraint UKkibbepcitr0a3cpk3rfr7nihn
        unique (isbn),
    constraint FKayy5edfrqnegqj3882nce6qo8
        foreign key (publisher_id) references publishers (id),
    constraint FKh16ssynmso8qdbwd7jtkx2ifg
        foreign key (series_id) references series (id)
);

create table book_authors
(
    author_id      bigint not null,
    author_role_id bigint not null,
    book_id        bigint not null,
    id             bigint auto_increment
        primary key,
    constraint FKbhqtkv2cndf10uhtknaqbyo0a
        foreign key (book_id) references books (id),
    constraint FKnj4nkbtii7968fod7b7jy2n5s
        foreign key (author_role_id) references author_roles (id),
    constraint FKo86065vktj3hy1m7syr9cn7va
        foreign key (author_id) references authors (id)
);

create table book_categories
(
    book_id     bigint not null,
    category_id bigint not null,
    id          bigint auto_increment
        primary key,
    constraint FK3k3ahp5vqlgmrr9swqqprmbxy
        foreign key (book_id) references books (id),
    constraint FKrg2xlmc92mm2y5b1wmhd2g0y0
        foreign key (category_id) references categories (id)
);

create table book_views
(
    book_id bigint       not null,
    id      bigint auto_increment
        primary key,
    user_ip varchar(45)  not null,
    user_id varchar(255) not null,
    constraint FK52x4yrabbeqh065tdy8ykpfet
        foreign key (book_id) references books (id)
);

create table settings
(
    key_name varchar(16)  not null
        primary key,
    value    varchar(255) not null
);

create table shipments
(
    shipment_companies_code tinyint      null,
    state                   tinyint      not null,
    id                      bigint auto_increment
        primary key,
    shipment_datetime       datetime(6)  null,
    tracking_number         varchar(255) null,
    check (`shipment_companies_code` between 0 and 6),
    check (`state` between 0 and 2)
);

create table storage_infos
(
    id           bigint auto_increment
        primary key,
    storage_name varchar(255) not null,
    storage_url  varchar(255) not null,
    constraint UKh1yu7y4sbgwmtgrwv8dyfygfw
        unique (storage_url)
);

create table book_images
(
    is_thumbnail    bit          not null,
    book_id         bigint       not null,
    id              bigint auto_increment
        primary key,
    storage_info_id bigint       null,
    file_path       varchar(255) not null,
    constraint FK5lauhxnv8a4pwsfw9pdtxokx0
        foreign key (storage_info_id) references storage_infos (id),
    constraint FKcnpy06tjmrsjisjf2bqpuvvbl
        foreign key (book_id) references books (id)
);

create table tags
(
    id   bigint auto_increment
        primary key,
    name varchar(15) not null,
    constraint UK_tags_name
        unique (name)
);

create table book_tags
(
    book_id bigint not null,
    id      bigint auto_increment
        primary key,
    tag_id  bigint not null,
    constraint FKl2e3gu495l604c29573nj0bc4
        foreign key (tag_id) references tags (id),
    constraint FKnm8mi22mkfqgu9lbgcw1echrv
        foreign key (book_id) references books (id)
);

create table user_ranks
(
    point_rate      decimal(5, 2)                                 not null,
    rank_max_amount int                                           null,
    rank_min_amount int                                           not null,
    id              bigint auto_increment
        primary key,
    rank_name       enum ('GENERAL', 'GOLD', 'PLATINUM', 'ROYAL') not null
);

create table users
(
    is_oauth          bit                                    not null,
    user_birthday     date                                   not null,
    user_signup_date  date                                   not null,
    user_last_login   datetime(6)                            null,
    user_phone_number varchar(13)                            not null,
    id                varchar(50)                            not null
        primary key,
    user_name         varchar(50)                            not null,
    user_email        varchar(100)                           not null,
    user_pwd          varchar(255)                           null,
    user_status       enum ('ACTIVE', 'DELETED', 'INACTIVE') not null
);

create table carts
(
    id      bigint auto_increment
        primary key,
    user_id varchar(50) not null,
    constraint UK64t7ox312pqal3p7fg9o503c2
        unique (user_id),
    constraint FKb5o626f86h46m4s7ms6ginnop
        foreign key (user_id) references users (id)
);

create table cart_items
(
    quantity int    not null,
    book_id  bigint not null,
    cart_id  bigint not null,
    id       bigint auto_increment
        primary key,
    constraint FK_cart_items_books
        foreign key (book_id) references books (id),
    constraint FKpcttvuq4mxppo8sxggjtn5i2c
        foreign key (cart_id) references carts (id),
    check (`quantity` >= 1)
);

create table likes
(
    is_like bit         not null,
    book_id bigint      not null,
    id      bigint auto_increment
        primary key,
    user_id varchar(50) not null,
    constraint FKcs5o49xjjpot3n862l7mmeh26
        foreign key (book_id) references books (id),
    constraint FKnvx9seeqqyy71bij291pwiwrg
        foreign key (user_id) references users (id)
);

create table orders
(
    delivery_fee            int           not null,
    point_amount            int default 0 not null,
    preferred_delivery_date date          null,
    state                   tinyint       not null,
    total_amount            int default 0 not null,
    id                      bigint auto_increment
        primary key,
    order_time              datetime(6)   not null,
    user_id                 varchar(50)   null,
    name                    varchar(255)  not null,
    order_email             varchar(255)  null,
    order_phone             varchar(255)  not null,
    password                varchar(255)  null,
    constraint FK32ql8ubntj5uh44ph9659tiih
        foreign key (user_id) references users (id),
    check (`state` between 0 and 6)
);

create table payments
(
    amount           int          not null,
    status           tinyint      not null,
    id               bigint auto_increment
        primary key,
    order_id         bigint       null,
    payment_datetime datetime(6)  null,
    payment_key      varchar(255) null,
    constraint FK81gagumt0r8y3rmudcgpbk42l
        foreign key (order_id) references orders (id),
    check (`status` between 0 and 2)
);

create table point_histories
(
    point_amount     int                                                     not null,
    point_policy_id  int                                                     null,
    id               bigint auto_increment
        primary key,
    order_id         bigint                                                  null,
    transaction_date datetime(6)                                             not null,
    user_id          varchar(50)                                             not null,
    point_type       enum ('EARNED', 'EARNED_CANCEL', 'USED', 'USED_CANCEL') not null,
    constraint FK4yklqh8xyuhs24sp910tocq0l
        foreign key (order_id) references orders (id),
    constraint FKp1n0qput9f88pa5lwy2nsr19f
        foreign key (user_id) references users (id),
    constraint fk_point_history_point_policy
        foreign key (point_policy_id) references point_policies (id)
);

create table reviews
(
    review_rating    int         not null,
    book_id          bigint      not null,
    id               bigint auto_increment
        primary key,
    review_create_at datetime(6) not null,
    user_id          varchar(50) not null,
    review_content   text        null,
    constraint FK6a9k6xvev80se5rreqvuqr7f9
        foreign key (book_id) references books (id),
    constraint FK_reviews_user
        foreign key (user_id) references users (id)
);

create table review_images
(
    id                      bigint auto_increment
        primary key,
    review_id               bigint       not null,
    review_image_created_at datetime(6)  not null,
    storage_infos_id        bigint       null,
    image_file_path         varchar(255) not null,
    constraint FK3aayo5bjciyemf3bvvt987hkr
        foreign key (review_id) references reviews (id),
    constraint FKf7lxmlxjdvekwy2n2f3d212ib
        foreign key (storage_infos_id) references storage_infos (id)
);

create table shipment_information
(
    order_id         bigint       not null
        primary key,
    customer_request varchar(255) null,
    receiver_address varchar(255) not null,
    receiver_name    varchar(255) not null,
    receiver_phone   varchar(255) not null,
    constraint FK5y6xjuhuqc6sqxu8b9313qmrs
        foreign key (order_id) references orders (id)
);

create table user_addresses
(
    addr_id            bigint       not null,
    id                 bigint auto_increment
        primary key,
    user_addr_receiver varchar(30)  not null,
    user_id            varchar(50)  not null,
    user_addr_detail   varchar(255) not null,
    user_addr_nickname varchar(50)  not null,
    constraint UKa5f8ovkiub4g41fmsxl6ipfix
        unique (user_addr_nickname),
    constraint FKhx5w6i7roohrmrwm4kuf6gy7w
        foreign key (addr_id) references addresses (id),
    constraint FKn2fisxyyu3l9wlch3ve2nocgp
        foreign key (user_id) references users (id)
);

create table user_rank_histories
(
    changed_at    timestamp default CURRENT_TIMESTAMP null,
    id            bigint auto_increment
        primary key,
    rank_id       bigint                              not null,
    user_id       varchar(50)                         not null,
    change_reason tinytext                            not null,
    constraint FK419wf3kvrpyu482lfd0yaf6ln
        foreign key (rank_id) references user_ranks (id),
    constraint FKhoj3nuuwyr3kl7452gcmf1jyk
        foreign key (user_id) references users (id)
);

create table user_roles
(
    id      bigint auto_increment
        primary key,
    role_id bigint      null,
    user_id varchar(50) null,
    constraint FKh8ciramu9cc9q3qcqiv4ue8a6
        foreign key (role_id) references roles (id),
    constraint FKhfh9dx7w3ubf1co1vdev94g3f
        foreign key (user_id) references users (id)
);

create table wraps
(
    amount int default 0 not null,
    id     bigint auto_increment
        primary key,
    name   varchar(64)   not null
);

create table order_details
(
    amount_detail         int     not null,
    quantity              int     not null,
    refund_or_cancel_date date    null,
    state                 tinyint not null,
    book_id               bigint  null,
    coupon_id             bigint  null,
    id                    bigint auto_increment
        primary key,
    order_id              bigint  null,
    shipment_id           bigint  not null,
    wrap_id               bigint  null,
    constraint FKjqe04yonp6a52rhbf2y0m03qw
        foreign key (book_id) references books (id),
    constraint FKjyu2qbqt8gnvno9oe9j2s2ldk
        foreign key (order_id) references orders (id),
    constraint FKl2w1egc39m1xaabg11vrh88x3
        foreign key (wrap_id) references wraps (id),
    constraint FKo7llktimeennx1k67rgc5r1y6
        foreign key (shipment_id) references shipments (id),
    check (`quantity` >= 0),
    check (`state` between 0 and 6)
);


