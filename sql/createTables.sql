--create customers table
CREATE TABLE customers(
  customer_id SERIAL PRIMARY KEY, 
  phone VARCHAR(12) UNIQUE NOT NULL,
  name VARCHAR(40)
);

--create services table
CREATE TABLE services(
  service_id SERIAL PRIMARY KEY, 
  name VARCHAR(40)
);

--create appointments table
CREATE TABLE appointments(
  appointment_id SERIAL PRIMARY KEY, 
  customer_id INT NOT NULL, 
  service_id INT NOT NULL,
  time VARCHAR(8) NOT NULL
);

--add foreign keys
ALTER TABLE appointments ADD FOREIGN KEY(customer_id) REFERENCES customers(customer_id);
ALTER TABLE appointments ADD FOREIGN KEY(service_id) REFERENCES services(service_id);
