--create clients table

CREATE TABLE clients 
(
client_id NUMBER(20) CONSTRAINT pk_client_id PRIMARY KEY,
client_name VARCHAR2(100),
mobile VARCHAR2 (20),
address VARCHAR2(250),
nid VARCHAR2(20)
);

--create contracts table

CREATE TABLE contracts
(
contract_id NUMBER(20) CONSTRAINT pk_contract_id PRIMARY KEY,
contract_startdate DATE,
contract_enddate DATE,
contract_total_fees NUMBER(20,2),
contract_deposit_fees NUMBER(20,2),
client_id NUMBER(20),
contract_payment_type VARCHAR2(50),
notes VARCHAR2 (1000)
);

--add foreign key to contract table

ALTER TABLE contracts
ADD CONSTRAINT fk_client_id FOREIGN KEY (client_id) REFERENCES clients;

--create installments table

CREATE TABLE installments 
(
installment_id NUMBER(20) CONSTRAINT pk_installment_id PRIMARY KEY,
contract_id NUMBER(20),
installment_date DATE,
installment_amount NUMBER(20,2),
Paid VARCHAR2(20)
);

--add foreign key to installments table

ALTER TABLE installments
ADD CONSTRAINT fk_contract_id FOREIGN KEY (installment_id) REFERENCES installments;


--insert data into clients table

INSERT INTO "CLIENTS" (CLIENT_ID, CLIENT_NAME, MOBILE, ADDRESS) VALUES ('1', 'Ahmed Omar', '01234567891', 'Cairo');
INSERT INTO "CLIENTS" (CLIENT_ID, CLIENT_NAME, MOBILE, ADDRESS) VALUES ('2', 'Marwa Hesham', '01001001003', 'Alex');
INSERT INTO "CLIENTS" (CLIENT_ID, CLIENT_NAME, MOBILE, ADDRESS) VALUES ('3', 'Tarek Shawky', '0111111111', 'Giza');

--insert data into contracts table

INSERT INTO "CONTRACTS" (CONTRACT_ID, CONTRACT_STARTDATE, CONTRACT_ENDDATE, CONTRACT_TOTAL_FEES, CLIENT_ID, CONTRACT_PAYMENT_TYPE) VALUES ('101', TO_DATE('2021-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), '500000', '1', 'ANNUAL');
INSERT INTO "CONTRACTS" (CONTRACT_ID, CONTRACT_STARTDATE, CONTRACT_ENDDATE, CONTRACT_TOTAL_FEES, CONTRACT_DEPOSIT_FEES, CLIENT_ID, CONTRACT_PAYMENT_TYPE) VALUES ('102', TO_DATE('2021-03-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-03-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), '600000', '10000', '2', 'QUARTER');
INSERT INTO "CONTRACTS" (CONTRACT_ID, CONTRACT_STARTDATE, CONTRACT_ENDDATE, CONTRACT_TOTAL_FEES, CONTRACT_DEPOSIT_FEES, CLIENT_ID, CONTRACT_PAYMENT_TYPE) VALUES ('103', TO_DATE('2021-05-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-05-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), '400000', '50000', '3', 'QUARTER');
INSERT INTO "CONTRACTS" (CONTRACT_ID, CONTRACT_STARTDATE, CONTRACT_ENDDATE, CONTRACT_TOTAL_FEES, CLIENT_ID, CONTRACT_PAYMENT_TYPE) VALUES ('104', TO_DATE('2021-03-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-03-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), '700000', '2', 'MONTHLY');
INSERT INTO "CONTRACTS" (CONTRACT_ID, CONTRACT_STARTDATE, CONTRACT_ENDDATE, CONTRACT_TOTAL_FEES, CONTRACT_DEPOSIT_FEES, CLIENT_ID, CONTRACT_PAYMENT_TYPE) VALUES ('105', TO_DATE('2021-04-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2026-04-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), '900000', '300000', '1', 'ANNUAL');
INSERT INTO "CONTRACTS" (CONTRACT_ID, CONTRACT_STARTDATE, CONTRACT_ENDDATE, CONTRACT_TOTAL_FEES, CONTRACT_DEPOSIT_FEES, CLIENT_ID, CONTRACT_PAYMENT_TYPE) VALUES ('106', TO_DATE('2021-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2026-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), '1000000', '200000', '2', 'HALF_ANNUAL');