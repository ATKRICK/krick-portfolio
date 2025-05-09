IF NOT EXISTS(SELECT * FROM sys.databases WHERE name = 'waggintrails')
CREATE DATABASE waggintrails
GO
USE waggintrails
GO
--DOWN
if exists(select*from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME='fk_walk_information_walk_client_id')
    alter table walk_information drop CONSTRAINT fk_walk_information_walk_client_id
if exists(select*from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME='fk_walk_informations_walk_walker_id')
    alter table walk_information drop CONSTRAINT fk_walk_informations_walk_walker_id 
DROP TABLE IF EXISTS walk_information
if exists(select*from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME='fk_clients_client_vet_id')
    alter table clients drop CONSTRAINT fk_clients_client_vet_id
if exists(select*from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME='fk_clients_client_region_id')
    alter table clients drop CONSTRAINT fk_clients_client_region_id
if exists(select*from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME='fk_clients_client_dog_class')
    alter table clients drop CONSTRAINT fk_clients_client_dog_class
DROP TABLE IF EXISTS clients
if exists(select*from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME='fk_invoices_schedule_id')
    alter table invoices drop CONSTRAINT fk_invoices_schedule_id
DROP TABLE IF EXISTS invoices
if exists(select*from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME='fk_schedule_time_slot_three')
    alter table schedules drop CONSTRAINT fk_schedule_time_slot_three   
if exists(select*from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME='fk_schedule_time_slot_two')
    alter table schedules drop CONSTRAINT fk_schedule_time_slot_two  
if exists(select*from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME='fk_schedule_time_slot_one')
    alter table schedules drop CONSTRAINT fk_schedule_time_slot_one
if exists(select*from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME='fk_schedule_discount_id')
    alter table schedules drop CONSTRAINT fk_schedule_discount_id
if exists(select*from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME='fk_schedule_duration_id')
    alter table schedules drop CONSTRAINT fk_schedule_duration_id
DROP TABLE IF EXISTS schedules 
DROP TABLE IF EXISTS discounts
DROP TABLE IF EXISTS duration_lookup
DROP TABLE IF EXISTS time_slot_lookup
if exists(select*from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME='pk_availability')
    alter table walker_availabilities drop CONSTRAINT pk_availability
if exists(select*from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME='fk_walker_availabilities_walker_id')
    alter table walker_availabilities drop CONSTRAINT fk_walker_availabilities_walker_id
if exists(select*from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME='fk_walker_availabilities_day_id')
    alter table walker_availabilities drop CONSTRAINT fk_walker_availabilities_day_id
DROP TABLE IF EXISTS walker_availabilities
DROP TABLE IF EXISTS day_lookup
if exists(select*from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME='fk_veterinarians_vet_region_id')
    alter table veterinarians drop CONSTRAINT fk_veterinarians_vet_region_id
DROP TABLE IF EXISTS veterinarians
if exists(select*from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME='fk_walkers_walker_region')
    alter table walkers drop CONSTRAINT fk_walkers_walker_region
DROP TABLE IF EXISTS walkers
if exists(select*from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME='fk_walker_positions_walker_largest_dog_class')
    alter table walker_positions drop CONSTRAINT fk_walker_positions_walker_largest_dog_class
DROP TABLE IF EXISTS walker_positions
DROP TABLE IF EXISTS dog_size_lookup
DROP TABLE IF EXISTS region_lookup

-- UP METADATA
CREATE TABLE region_lookup (
    region_id int IDENTITY not null,
    region_name VARCHAR(5) NOT NULL,
    region_city VARCHAR(50) NOT NULL,
    region_zipcode int NOT NULL
    CONSTRAINT pk_region_lookup_region_id PRIMARY KEY (region_id),
    CONSTRAINT u_region_lookup UNIQUE (region_name)
)
GO

CREATE TABLE dog_size_lookup (
    dog_class INT IDENTITY NOT NULL,
    dog_size VARCHAR(50) NOT NULL
    CONSTRAINT pk_dog_size_lookup_dog_class PRIMARY KEY (dog_class)
)
GO

CREATE TABLE walker_positions (
    walker_position_id INT IDENTITY NOT NULL,
    walker_position VARCHAR(50) NOT NULL,
    walker_dog_number VARCHAR(50) NOT NULL,
    walker_largest_dog_class INT NOT NULL    
    CONSTRAINT pk_walker_positions_walker_position_id PRIMARY KEY (walker_position_id)
)
alter table walker_positions
    add CONSTRAINT fk_walker_positions_walker_largest_dog_class FOREIGN KEY (walker_largest_dog_class)
        REFERENCES dog_size_lookup(dog_class)
GO

CREATE TABLE walkers (
    walker_id int identity not null,
    walker_firstname VARCHAR(50) NOT NULL,
    walker_lastname VARCHAR(50) NOT NULL,
    walker_email VARCHAR(150) NOT NULL,
    walker_phone VARCHAR(50) NOT NULL,
    walker_region_id INT NOT NULL,
    walker_position_id INT NOT NULL,
    CONSTRAINT pk_walkers_walker_id PRIMARY KEY(walker_id),
    CONSTRAINT u_walkers_walker_email UNIQUE (walker_email)
)
alter table walkers
    add CONSTRAINT fk_walkers_walker_region_id FOREIGN KEY (walker_region_id) 
        REFERENCES regions(region_id)
GO

CREATE TABLE veterinarians (
    vet_id INT IDENTITY NOT NULL,
    vet_clinic VARCHAR(50) NOT NULL,
    vet_phone VARCHAR(50) NOT NULL,
    vet_email VARCHAR(50) UNIQUE NOT NULL,
    vet_street_number VARCHAR(50) NOT NULL,
    vet_street_name VARCHAR(50) NOT NULL,
    vet_region_id INT NOT NULL,
    CONSTRAINT pk_veterinarians_vet_id PRIMARY KEY (vet_id)
)
alter table veterinarians
    add CONSTRAINT fk_veterinarians_vet_region_id FOREIGN KEY (vet_region_id) 
    REFERENCES region_lookup(region_id)
GO

CREATE TABLE day_lookup (
    day_id INT IDENTITY NOT NULL,
    week_day VARCHAR(50) NOT NULL,
    CONSTRAINT pk_day_lookup_day_id PRIMARY KEY (day_id)
)
GO

CREATE TABLE walker_availabilities (
    available_walker_id INT NOT NULL,
    available_day_id INT NOT NULL,
    walk_date DATE NOT NULL,
)
ALTER TABLE walker_availabilities
    ADD
        CONSTRAINT pk_availability PRIMARY KEY (available_walker_id,available_day_id),
        CONSTRAINT fk_walker_availabilities_walker_id FOREIGN KEY (available_walker_id) 
            REFERENCES walkers(walker_id),
        CONSTRAINT fk_walker_availabilities_day_id FOREIGN KEY (available_day_id) 
            REFERENCES day_lookup(day_id)

GO

CREATE TABLE time_slot_lookup (
    time_slot_id INT IDENTITY NOT NULL,
    time_slot VARCHAR(50) NOT NULL,
    time_slot_price MONEY NOT NULL,
    CONSTRAINT pk_time_slot_id PRIMARY KEY (time_slot_id)
)
GO

CREATE TABLE duration_lookup (
    duration_id INT IDENTITY NOT NULL,
    duration_walk VARCHAR(50) NOT NULL,
    CONSTRAINT pk_duration_lookup_duration_id PRIMARY KEY (duration_id)
)
GO

CREATE TABLE discounts (
    discount_id INT IDENTITY NOT NULL,
    discount_daily_sessions INT NOT NULL,
    discount_total money NOT NULL
    CONSTRAINT pk_discounts_discount_id PRIMARY KEY (discount_id)
)
GO

CREATE TABLE schedules (
    schedule_id INT IDENTITY NOT NULL,
    schedule_duration_id INT NOT NULL,
    schedule_time_slot_one INT NOT NULL,
    schedule_time_slot_two INT NOT NULL,
    schedule_time_slot_three INT NOT NULL,
    schedule_discount_id INT NOT NULL,
    schedule_total_price money NOT NULL,
    CONSTRAINT pk_schedules_schedule_id PRIMARY KEY (schedule_id),
)
Alter TABLE schedules
    ADD
        CONSTRAINT fk_schedule_duration_id FOREIGN KEY (schedule_duration_id) 
            REFERENCES duration_lookup(duration_id),
        CONSTRAINT fk_schedule_discount_id FOREIGN KEY (schedule_discount_id) 
            REFERENCES discounts(discount_id),
        CONSTRAINT fk_schedule_time_slot_one FOREIGN KEY (schedule_time_slot_one) 
            REFERENCES time_slot_lookup(time_slot_id),
        CONSTRAINT fk_schedule_time_slot_two FOREIGN KEY (schedule_time_slot_two) 
            REFERENCES time_slot_lookup(time_slot_id),
        CONSTRAINT fk_schedule_time_slot_three FOREIGN KEY (schedule_time_slot_three) 
            REFERENCES time_slot_lookup(time_slot_id)
GO

CREATE TABLE invoices (
    invoice_id INT NOT NULL,
    invoice_schedule_id INT NOT NULL,
    invoice_total_days INT NOT NULL,
    invoice_total MONEY NOT NULL,
    CONSTRAINT pk_invoices_invoice_id PRIMARY KEY (invoice_id)
)
ALTER TABLE invoices
    add CONSTRAINT fk_invoices_schedule_id FOREIGN KEY (invoice_schedule_id) 
        REFERENCES schedules(schedule_id)
GO

CREATE TABLE clients (
    client_id INT IDENTITY NOT NULL,
    client_firstname VARCHAR(50) NOT NULL,
    client_lastname VARCHAR(50) NOT NULL,
    client_phone VARCHAR(50) NOT NULL,
    client_email VARCHAR(50) NOT NULL,
    client_street_number VARCHAR(50) NOT NULL,
    client_street_name VARCHAR(50) NOT NULL,
    client_region_id INT NOT NULL,
    client_invoice_id INT,
    client_dog_class INT NOT NULL,
    client_vet_id INT NOT NULL
    CONSTRAINT pk_clients_client_id PRIMARY KEY (client_id),
    CONSTRAINT u_clients_client_email UNIQUE (client_email)  
)
ALTER TABLE clients
     add
        CONSTRAINT fk_clients_client_region_id FOREIGN KEY (client_region_id) 
            REFERENCES region_lookup(region_id),
        CONSTRAINT fk_clients_client_invoice_id FOREIGN KEY (client_invoice_id) 
            REFERENCES invoices(invoice_id),
        CONSTRAINT fk_clients_client_dog_class FOREIGN KEY (client_dog_class) 
            REFERENCES dog_size_lookup(dog_class),
        CONSTRAINT fk_clients_client_vet_id FOREIGN KEY (client_vet_id) 
            REFERENCES veterinarians(vet_id)
GO

CREATE TABLE walk_information (
    walk_id INT IDENTITY NOT NULL,
    walk_walker_id INT NOT NULL,
    walk_day_id int NOT NULL,
    walk_client_id INT NOT NULL,
    CONSTRAINT pk_walk_information_walk_id PRIMARY KEY (walk_id),
);
ALTER TABLE walk_information
    ADD 
        CONSTRAINT fk_walk_information_walk_walker_id FOREIGN KEY (walk_walker_id, walk_day_id)
            REFERENCES walker_availabilities(available_walker_id, available_day_id),
        CONSTRAINT fk_walk_information_walk_client_id FOREIGN KEY (walk_client_id)
            REFERENCES clients(client_id)

GO


-- UP DATA
INSERT INTO region_lookup
    (region_name, region_city, region_zipcode) 
    VALUES
    ('North', 'Northernton', 13528),('South', 'Southside Summit', 13529),('East', 'Eastern Echoes', 13527), ('West', 'Western Windsor',13526)
GO

INSERT INTO dog_size_lookup(dog_size) VALUES
    ('Small'), ('Medium'), ('Large')
GO

INSERT INTO walker_positions
    (walker_position, walker_dog_number, walker_largest_dog_class) 
    VALUES
    ('Senior', 'Multiple', 3), 
    ('Junior', 'Single',2)
GO

INSERT INTO walkers
    (walker_firstname, walker_lastname, walker_email,walker_phone, walker_position_id, walker_region_id) 
    VALUES
    ('Walker', 'Stride', '555-123-4567', 'walker.stride@example.com',1,4),
    ('Mitchell', 'Marcher', '555-987-6543', 'mitchell.marcher@example.com',2,3),
    ('Travis', 'Treks', '555-222-3333', 'Ttreks@example.com',1,2),
    ('Dan', 'Walken', '555-622-6125', 'danw@example.com', 1,3),
    ('Mike', 'Chew', '555*668-4987', 'mc@example.com', 2,4 ),
    ('Mary', 'Puppins', '555-414-2214', 'puppins@example.com', 2,2),
    ('Howl', 'Jackman', '555-854-8792', 'hjack@exmaple.com',1,4)
GO

INSERT INTO veterinarians
    (vet_clinic,vet_phone,vet_email,vet_street_number,vet_street_name, vet_region_id) 
    VALUES
    ('Furry Friends Animal Clinic', '555-676-8899','FFAC@clinic.com','12A','Maple Drive',3),
    ('Pawsington Animal Hospital', '555-457-2211','Paws@clinic.com','1487','Oak Lanes',1),
    ('Animal Wellness', '555-987-4152','AW@wellness.com','527','Hooper Path',4),
    ('Paws & Claws Veterinary Clinic', '555-646-1166', 'info@pcvc.com', '5458', 'River Run Drive', 2)
GO

INSERT INTO day_lookup(week_day) VALUES
    ('Monday'),('Tuesday'),('Wednesday'),('Thursday'),('Friday'),('Saturday'),('Sunday')
GO

INSERT INTO time_slot_lookup(time_slot, time_slot_price) VALUES
    ('Morning', 20), ('Afternoon', 15),('Evening',25)

INSERT INTO duration_lookup(duration_walk) VALUES
    ('30 minutes'), ('60 minutes')

INSERT INTO discounts(discount_daily_sessions, discount_total) VALUES
    (1,0), (2,5), (3,10)

INSERT INTO clients(client_firstname, client_lastname, client_dog_class, client_phone, client_email, client_street_number, client_street_name, client_region_id, client_vet_id) VALUES
    ('Taylor', 'Tails', 3,'555-542-8763', 'totallytaylor@me.com', '15H', 'Wondering Way',3,1),
    ('Beverly', 'Beagle', 2,'555-542-7561', 'lovemybeagle@example.com', '2874', 'Hollow Heights',3,2),
    ('James', 'Spot',3, '555-542-7421', 'james.spot@example.com', '867', 'Jenny Avenue',1,1),
    ('Brian', 'Butterball', 2, '555-663-2255', 'b.butterball@example.com', '875', 'Circle Road',2,1),
    ('Bark', 'Obama', 2,'555-645-6831', 'bark@example.com', '5656', 'Oak Street',1,3),
    ('Drulius', 'Ceasar', 3, '555-632-5244', 'druc@example.com', ' 899', 'Flower Lane', 2,3),
    ('Paw', 'McCartney', 2, '555-477-3255', 'paw_b@example.com', '4225', 'Willow Way', 3,1),
    ('Woofie' , 'Golderberg', 2, '555-336-2121', 'woof@example.com', '4419', 'Stone Street', 1,2),
    ('Fetch', 'Astaire', 3, '555-654-8911', 'astaire@exapmple.com', '2548', 'Lilly Lane', 2,1),
    ('Panting', 'Tatum', 3, '555-624+7855', 'Panting@example.com', '4199', 'Yorkie Way', 1,1),
    ('Rover', 'Downey', 2, '555-323-7778', 'Rover@example.com', '2584', 'River Walk Way', 3,4),
    ('Bone', 'Jovi', 3, '555-226-2221', 'bjovi@example.com', '8744', 'Jenny Avenue', 1,1),
    ('Sniffy', 'Longstocking', 3, '555-254-4895', 'sniffl@example.com', '421', 'Main Street', 2,3),
    ('Growl', 'Gyllenhaal', 2, '555-587-6826', 'growler@example.com', '1488', 'Rock Court', 1,2),
    ('Bark', 'Wahlberg', 2, '555-898-6322', 'barkw@example.com', '7332', 'Holly Drive', 2,2),
    ('Doggy', 'Depp', 2, '555-878-8587', 'doggy_d@example.com', '1985', 'Alison Drive', 1,3),
    ('Dodgy', 'Glover', 3, '555-336-7794', 'd_glove@example.com', '855', 'Paradise Street', 3, 4),
    ('Tail', 'Swift', 3, '555-976-5936', 'tswift@example.com', '25A', 'Central Avenue', 1,4),
    ('Harry', 'Pawter', 2, '555-987-3579', 'pawterh@example.com', '55', 'Mary Way', 2,3),
    ('Collin', 'Firth', 3, '555-216-6577', 'collie@example.com', '8856', 'Timber Drive', 2,4),
    ('Canine', 'West', 2, '555-666-8596', 'cwest@example.com', '3344', 'Lilly Lane', 2,1),
    ('Leash', 'Witherspoon', 2, '555-445-2256', 'leashwith@example.com', '299', 'Wonderinng Way', 2,3),
    ('Mutt', 'Damon', 3, '555-977-6778', 'muttdam@example.com', '549', 'Lake View Drive', 1,1),
    ('Pawris', 'Hilton', 3, '555-445-2562', 'pawrish@example.com', '7599', 'Paradise Street', 3, 4),
    ('Jimmy', 'Chew', 2, '555-655-6363', ' jimmychew@example.com', '2001', 'Maple Drive', 3,3),
    ('Virginia', 'Woof', 2, '555-655-3258', 'virginiawo@example.com', ' 3022', 'Central Avenue', 1, 1),
    ('Bark', 'Twain', 3, '555-887-2224', 'twainb@example.com', '5011', 'Allen Street', 2,2),
    ('Woof', 'Blitzer', 2, '555-478-8744', 'wblitz@example.com', ' 588', 'Sunset Avenue', 3, 3),
    ('Mike', 'Judge', 3, '555-565-2155', 'mjudge@eaxample.com', '5045', 'Timber Drive', 1, 4),
    ('Chris', 'Cole', 2, '555-656-1155', 'ccole@example.com', '254', 'Partridge Street', 2, 4),
    ('Harry', 'Paws', 3, '555-455-5844', 'hpaws@example.com', '4651', 'Dreary Lane', 1, 2)
GO
INSERT INTO schedules (schedule_id, schedule_duration_id , schedule_time_slot_one, schedule_time_slot_two, schedule_time_slot_three, schedule_discount_id, schedule_total_price) 
VALUES ()

INSERT INTO invoices (invoice_id, invoice_schedule_id, invoice_total_days, invoice_total)
VALUES ()

INSERT INTO walk_information (walk_id, walk_walker_id, walk_day_id, walk_client_id)
VALUES()


--Verify
select * from region_lookup
select * from dog_size_lookup
select * from walker_positions
select * from walkers
select * from veterinarians
select * from day_lookup
select * from walker_availabilities
select * from duration_lookup
select * from time_slot_lookup
select * from discounts
select * from schedules
select * from invoices
select * from clients
select * from walk_information

