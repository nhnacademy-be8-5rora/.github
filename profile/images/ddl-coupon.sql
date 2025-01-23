create table discount_rule
(
    max_sale     int null,
    need_cost    int null,
    sale_amount  int null,
    sale_percent int null,
    discount_id  bigint auto_increment
        primary key
);

create table coupon_policy
(
    discount_id bigint                     not null,
    policy_id   bigint auto_increment
        primary key,
    policy_name varchar(255)               not null,
    sale_type   enum ('AMOUNT', 'PERCENT') not null,
    constraint FKr0ka0sjj7rugqusu99b6pfr6s
        foreign key (discount_id) references discount_rule (discount_id)
);

create table book_policy
(
    book_coupon bigint auto_increment
        primary key,
    book_id     bigint not null,
    policy_id   bigint not null,
    constraint FKk3vq2qtftgngkusggcumqpn0r
        foreign key (policy_id) references coupon_policy (policy_id)
);

create table category_policy
(
    category_coupon bigint auto_increment
        primary key,
    category_id     bigint not null,
    policy_id       bigint not null,
    constraint FKkygve14cjq0cwdddrfmsix2r
        foreign key (policy_id) references coupon_policy (policy_id)
);

create table coupon_policy_book_policies
(
    book_policies_book_coupon bigint not null,
    coupon_policy_policy_id   bigint not null,
    constraint UK3de13lxijbw8iw8y69on51o2i
        unique (book_policies_book_coupon),
    constraint FK17njl76ope7hpv3xy6dhj4d56
        foreign key (coupon_policy_policy_id) references coupon_policy (policy_id),
    constraint FK8w8wvn4tlmtw8xjky88r5w51i
        foreign key (book_policies_book_coupon) references book_policy (book_coupon)
);

create table coupon_policy_category_policies
(
    category_policies_category_coupon bigint not null,
    coupon_policy_policy_id           bigint not null,
    constraint UK9n1jhqd7pqoh8dl5nlmkc3ipb
        unique (category_policies_category_coupon),
    constraint FKhw4d3g3xp0f1idkwccow72dcv
        foreign key (category_policies_category_coupon) references category_policy (category_coupon),
    constraint FKolbpiec5xl8d6sftdqn1p15dd
        foreign key (coupon_policy_policy_id) references coupon_policy (policy_id)
);

create table user_coupon
(
    change_period date                             null,
    end_date      date                             null,
    start_date    date                             not null,
    coupon_id     bigint auto_increment
        primary key,
    policy_id     bigint                           not null,
    user_id       varchar(255)                     not null,
    coupon_state  enum ('LIVE', 'TIMEOUT', 'USED') null,
    constraint FKsamxnfsj7b3wwxyw5gt69sfe1
        foreign key (policy_id) references coupon_policy (policy_id)
);


