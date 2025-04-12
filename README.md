# BookstoreDBS

This database is designed for an online bookstore, managing books, customers, orders, and shipping. It supports multi-language books, multiple authors per book, and customer address tracking.

Database Schema
Tables & Relationships
1. Core Tables
Table	                    Description	                                               Key Fields
country	               Stores countries for addresses	                              country_id, country_name
address	               Stores customer addresses	                                  address_id, street, city, postal_code, country_id (FK)
address_status	       Tracks address status (e.g., "Primary", "Secondary")	        address_status_id, status_name
customer	             Stores customer details	                                    customer_id, first_name, last_name, email, phone
customer_address	     Junction table linking customers to addresses	              customer_id (FK), address_id (FK), address_status_id (FK)

2. Book & Author Management
Table	                   Description	                                                        Key Fields
book_language	      Stores supported languages (e.g., "English", "French")	         language_id, language_name
publisher	          Stores book publishers	                                         publisher_id, publisher_name
book	              Stores book details	                                             book_id, book_author, isbn, publication_year, language_id (FK), publisher_id (FK), price, stock
author	            Stores author details	                                           author_id, first_name, last_name
book_author	        Junction table for books and authors (many-to-many)	             book_id (FK), author_id (FK)

3. Order Management
Table	                 Description	                                                     Key Fields
order_status	         Tracks order statuses (e.g., "Pending", "Shipped")	            status_id, status_name
shipping_method	       Stores shipping options (e.g., "Standard", "Express")	        shipping_method_id, method_name, cost
cust_order	           Stores order headers	                                          order_id, customer_id (FK), order_date, shipping_method_id (FK), status_id (FK)
order_line	           Stores ordered books and quantities	                          order_line_id, order_id (FK), book_id (FK), quantity, price
order_history	         Logs order status changes	                                    order_history_id, order_id (FK), status_id (FK), changed_at

Database Users & Permissions
User	                        Privileges	                                 Purpose
bookstore_admin	             ALL PRIVILEGES	                       Full database access (admin tasks)
bookstore_staff	             SELECT, INSERT, UPDATE, DELETE	       Staff managing orders and inventory
bookstore_readonly	         SELECT	                               Read-only access for reports

Optimizations
Indexes for faster queries:

book_author (book_id, author_id)

book (publisher_id, language_id)

customer (email)

customer_address (customer_id, address_id)
