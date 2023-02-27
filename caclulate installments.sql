/*
create a function to calculate the number of payment times should the clints pay based in the contract payment type.
-function inputs: start date, end date, contract payment type (annual, half annual, quarter, monthly)
-function output: number of payment times
 */

CREATE OR REPLACE FUNCTION num_of_payments(start_date DATE, end_date DATE, contract_type VARCHAR2)
RETURN NUMBER
    IS
        num_of_pay NUMBER(10);
    BEGIN
    
        CASE contract_type
            WHEN 'ANNUAL' THEN
                num_of_pay := MONTHS_BETWEEN(end_date, start_date)/12;
            WHEN 'HALF_ANNUAL' THEN               
                num_of_pay := MONTHS_BETWEEN(end_date, start_date)/6;
            WHEN 'MONTHLY' THEN
                
                num_of_pay := MONTHS_BETWEEN(end_date, start_date);
            WHEN 'QUARTER' THEN
                num_of_pay := MONTHS_BETWEEN(end_date, start_date)/3;
        END CASE;
        return num_of_pay;
    END;
    

/*
create a function to calculate the installment dates that the client should pay on.
-function inputs: start date, number of payments, contract payment type (annual, half annual, quarter, monthly)
-function output: installment date
 */   
    
CREATE OR REPLACE FUNCTION calc_installment_date(start_date DATE, num_of_payments NUMBER, contract_type VARCHAR2)
RETURN DATE
    IS
    installment_date DATE;
    BEGIN
        
        CASE contract_type
        WHEN 'ANNUAL' THEN
            installment_date := ADD_MONTHS(start_date, 12*(num_of_payments -1 ));
        WHEN 'HALF_ANNUAL' THEN
            installment_date := ADD_MONTHS(start_date,6*(num_of_payments -1 ));
        WHEN 'QUARTER' THEN
            installment_date := ADD_MONTHS(start_date, 3*(num_of_payments -1 ));
        WHEN 'MONTHLY' THEN
            installment_date := ADD_MONTHS(start_date, (num_of_payments -1 ));
        END CASE;
        
        RETURN installment_date;

    END;
  
--create sequence to handle the installment id.  
DROP SEQUENCE installment_id_seq; --drop sequence if exists
CREATE SEQUENCE installment_id_seq
    START WITH 1
    INCREMENT BY 1;
    
--create trigger to auto adding the installment_id based on the created sequence. 
 
CREATE OR REPLACE TRIGGER installment_trig 
BEFORE INSERT ON installments 
FOR EACH ROW
    BEGIN
        :NEW.installment_id := installment_id_seq.NEXTVAL;
    END;
    
--create a procedure to handle the insertion into the installment table using previous functions 
 
CREATE OR REPLACE PROCEDURE insert_installments --cursor contain the needed cilumns from contracts table
    IS
        CURSOR contracts_data IS
            SELECT contract_id, contract_startdate, contract_enddate, contract_total_fees, contract_deposit_fees, contract_payment_type
            FROM contracts;
            
        v_count_of_installment NUMBER(20,3);
        v_installment_date DATE;
        v_total_amount NUMBER(20,3);
        v_installment_amount NUMBER(20,3);
            
    BEGIN
    
        FOR contract_record IN contracts_data
        LOOP
        
        
			v_total_amount := contract_record.contract_total_fees - NVL(contract_record.contract_deposit_fees, 0); --calculate the total amount after paid the deposit
            v_count_of_installment := num_of_payments(contract_record.contract_startdate, contract_record.contract_enddate, contract_record.contract_payment_type); --use num_of_payments function to find payment times
            v_installment_amount := v_total_amount / (v_count_of_installment); --devide the amount on the number of payment types to find the payment amount on each time

            
            FOR num in 1 .. v_count_of_installment --loop to insert each time and its date
            LOOP
                v_installment_date := calc_installment_date(contract_record.contract_startdate, num, contract_record.contract_payment_type); --use calc_installment_date to find the installment dates
                INSERT INTO installments
                (contract_id, installment_date, installment_amount, paid)
                Values
                (contract_record.contract_id, v_installment_date, v_installment_amount, 0);
               
            END LOOP;
            
        END LOOP;

    END;
    
    
exec insert_installments; --run the procedure
                
                          
SHOW ERRORS;

SELECT * FROM installments;
