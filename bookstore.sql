USE bookstore;

-- Country table
CREATE TABLE country (
	country_id INT AUTO_INCREMENT PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL
);

-- Address table
CREATE TABLE address (
	address_id INT AUTO_INCREMENT PRIMARY KEY,
    street VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    country_id INT NOT NULL,
    FOREIGN KEY (country_id) REFERENCES country(country_id)
);

-- Address status table
CREATE TABLE address_status (
	address_status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(60) NOT NULL
);

-- Customers table
CREATE TABLE customer (
	customer_id INT AUTO_INCREMENT PRIMARY KEY,
	first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20)
);

-- Customer address(join table)
CREATE TABLE customer_address (
	customer_id INT,
	address_id INT,
    address_status_id INT,
	PRIMARY KEY (customer_id, address_id),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (address_id) REFERENCES address(address_id),
    FOREIGN KEY (address_status_id) REFERENCES address_status(address_status_id)
);

-- Book language table
CREATE TABLE book_language (
	language_id INT AUTO_INCREMENT PRIMARY KEY,
    language_name VARCHAR(50) NOT NULL
);

-- Publisher table
CREATE TABLE publisher (
	publisher_id INT AUTO_INCREMENT PRIMARY KEY,
	publisher_name VARCHAR(100) NOT NULL
);

-- Book table
CREATE TABLE book (
	book_id INT AUTO_INCREMENT PRIMARY KEY,
    book_author VARCHAR(100) NOT NULL,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    publication_year YEAR,
    language_id INT,
    publisher_id INT,
    price DECIMAL(10,2),
    stock INT DEFAULT 0,
    FOREIGN KEY (language_id) REFERENCES book_language(language_id),
    FOREIGN KEY (publisher_id) REFERENCES publisher(publisher_id)
);

-- Author table
CREATE TABLE author (
	author_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL
);

-- Book author(many-to-many)
CREATE TABLE book_author (
	book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id),
    FOREIGN KEY (author_id) REFERENCES author(author_id)
);

-- Order status table
CREATE TABLE order_status (
	status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL
);

-- Shipping method table
CREATE TABLE shipping_method (
	shipping_method_id INT AUTO_INCREMENT PRIMARY KEY,
    method_name VARCHAR(90) NOT NULL,
    cost DECIMAL(10,2) NOT NULL
);

-- Customer order table
CREATE TABLE cust_order (
	order_id INT AUTO_INCREMENT PRIMARY KEY,
	customer_id INT NOT NULL,
	order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
	shipping_method_id INT,
	status_id INT,
	FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
	FOREIGN KEY (shipping_method_id) REFERENCES shipping_method(shipping_method_id),
	FOREIGN KEY (status_id) REFERENCES order_status(status_id)
);

-- Order line table
CREATE TABLE order_line (
	order_line_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    book_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id)
);

-- Order history table
CREATE TABLE order_history (
	order_history_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    status_id INT NOT NULL,
    changed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (status_id) REFERENCES order_status(status_id)
);



-- Create users and roles
CREATE USER 'bookstore_admin'@'%' IDENTIFIED BY 'Admin123';
CREATE USER 'bookstore_staff'@'%' IDENTIFIED BY 'Staff123';
CREATE USER 'bookstore_readonly'@'%' IDENTIFIED BY 'Readonly123';

-- Grant full access to admin
GRANT ALL PRIVILEGES ON bookstore.* TO 'bookstore_admin'@'%';

-- Grant staff read-write
GRANT SELECT, INSERT, UPDATE, DELETE ON bookstore.* TO 'bookstore_staff'@'%';

-- Grant read-only
GRANT SELECT ON bookstore.* TO 'bookstore_readonly'@'%';

-- Apply changes
FLUSH PRIVILEGES;



-- Indexing for Optimiztion
CREATE INDEX idx_book_author_book_id ON book_author(book_id);
CREATE INDEX idx_book_author_author_id ON book_author(author_id);

CREATE INDEX idx_book_publisher_id ON book(publisher_id);
CREATE INDEX idx_book_language_id ON book(language_id);

CREATE INDEX idx_customer_email ON customer(email);

CREATE INDEX idx_customer_address_customer_id ON customer_address(customer_id);
CREATE INDEX idx_customer_address_address_id ON customer_address(address_id);