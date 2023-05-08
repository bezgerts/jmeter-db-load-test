create table if not exists product_categories
(
    id serial not null
        constraint product_categories_pk
            primary key,
    name varchar(255) not null
);
comment on table product_categories is 'Категории продуктов';
comment on column product_categories.id is 'Идентификатор категории продуктов';
comment on column product_categories.name is 'Название категории';

create table if not exists products
(
    id          serial       not null
        constraint products_pk
            primary key,
    name        varchar(255) not null,
    cost        integer      not null,
    category_id integer      not null
        constraint category_id
            references product_categories
);
comment on table products is 'Таблица с продуктами интернет-магазина';
comment on column products.id is 'Идентификатор продукта';
comment on column products.name is 'Название продукта';
comment on column products.cost is 'Цена';

create unique index if not exists products_id_uindex on products (id);
create unique index if not exists product_categories_id_uindex on product_categories (id);

-- Добавление категории продуктов

INSERT INTO product_categories (id, name)
VALUES (1, 'Одежда'),
       (2, 'Бытовая техника'),
       (3, 'Продукты питания')
RETURNING (id, name);

-- Добавление продуктов

INSERT INTO products (id, name, cost, category_id)
VALUES (1, 'Хлеб', 59, 3),
       (2, 'Молоко', 100, 3),
       (3, 'Халва', 150, 3),
       (4, 'Колбаса', 200, 3),
       (5, 'Холодильник', 24999, 2),
       (6, 'Телевизор', 50000, 2),
       (7, 'Посудомойка', 32149, 2),
       (8, 'Джинсы', 3499, 1),
       (9, 'Рубашка', 2999, 1)
RETURNING (id, name, cost, category_id);