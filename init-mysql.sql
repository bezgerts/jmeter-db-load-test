create schema otus;

create table otus.product_categories
(
    id   int unsigned auto_increment comment 'Идентификатор категории продуктов',
    name VARCHAR(255) not null comment 'Название категории',
    constraint product_categories_pk
        primary key (id)
)
comment 'Категория продуктов';

create unique index product_categories_id_uindex on otus.product_categories (id);

create table otus.products
(
    id                      int             unsigned auto_increment comment 'Идентификатор продукта',
    name                    varchar(255)    not null comment 'Название продукта',
    category_id             int             unsigned not null,
    cost                    decimal         not null,
    attributes_json         JSON            comment 'Джейсон с аттрибутами продукта',
    description             text            not null comment 'Описание товара',
    constraint products_pk
        primary key (id),
    constraint products_product_categories_id_fk
        foreign key (category_id) references otus.product_categories (id)
)    comment 'Таблица с продуктами интернет-магазина';

create unique index products_id_uindex on otus.products (id);

-- Добавление категории продуктов

INSERT INTO otus.product_categories (id, name)
    VALUES (1, 'Одежда'),
           (2, 'Бытовая техника'),
           (3, 'Продукты питания');

-- Добавление продуктов

INSERT INTO otus.products (id, name, cost, category_id, attributes_json, description)
    VALUES (1, 'Хлеб', 59, 3, '{"weight":"800g", "type":"ржаной"}','вкусный'),
           (2, 'Молоко', 100, 3, '{"volume":"1L", "fat":"5%"}', 'коровье'),
           (3, 'Халва', 150, 3, null, 'подсолнечная'),
           (4, 'Колбаса', 200, 3, '{"weight":"1kg"}', 'вареная'),
           (5, 'Холодильник', 24999, 2, '{}', 'двухкамерный'),
           (6, 'Телевизор', 50000, 2, null, 'жк'),
           (7, 'Посудомойка', 32149, 2, null, 'хорошо отмывает посуду'),
           (8, 'Джинсы', 3499, 1, null, 'левис'),
           (9, 'Рубашка', 2999, 1, '{"color": "blue", "size":"M"}', 'синяя');

