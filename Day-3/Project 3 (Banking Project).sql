create database day3project;

use day3project;

select * from accounts;
select * from merchants;
select * from transactions;

-- 1. Top 20 highest-spending customers (total debit amount).
-- Identify which accounts generate the most revenue through actual spending.

select a.account_id, a.name, sum(amount) as revenue
from accounts a
join transactions t on a.account_id = t.account_id
join merchants m on t.merchant_id = m.merchant_id
where txn_type = "debit"
group by a.account_id, a.name
order by revenue desc
limit 20;	

-- 2. Monthly transaction trend (volume + total amount).
-- Banks watch for seasonal dips/spikes → liquidity & planning.

select month(txn_date) as month,
count(txn_id) as txn_volume,
sum(amount) as total_amount
from transactions
group by month(txn_date)
order by month asc;

-- 3. Merchants generating the highest total transaction volume.
-- Useful for partnerships and merchant acquisition strategy.

select m.merchant_id , m.merchant_name, count(t.txn_id) as volume
from merchants m
join transactions t on m.merchant_id  = t.merchant_id
group by m.merchant_id , m.merchant_name
order by volume desc;

-- 4. Suspicious high-value transactions (above 3× a merchant’s average).
-- Early fraud indicator.

with cte as (
    select merchant_id, avg(amount) as avg_amt
    from transactions
    group by merchant_id)

select t.txn_id,t.merchant_id,
t.amount as txn_amount,c.avg_amt
from transactions t
join cte c on t.merchant_id = c.merchant_id
where t.amount > 3 * c.avg_amt;

-- 5. Accounts with unusually high number of transactions in a single day.
-- Detect automated or compromised accounts.

select account_id,day(txn_date) as txn_day,
count(*) as txn_count
from transactions
group by account_id, day(txn_date)
having txn_count > 10
order by txn_count desc;

-- 6. Cities with the highest fraud rate (fraud_count / total_txn_count).
-- Shows geography-based risk clustering.

select city,
(count(case when is_fraud = 1 then 1 end) * 100.0 / count(*)) as fraud_rate
from transactions
group by city
order by fraud_rate desc;

-- 7. Customers who transacted with more than 10 unique merchants.
-- Good for segmentation → "high diversification" spenders.

select account_id,
count(distinct merchant_id) as unique_merchants
from transactions
group by account_id
having unique_merchants > 10;

-- 8. Transactions happening in a city different from the account holder’s home city.
-- Possible fraud or travel-based risk.

select a.account_id, a.city as home_city,
t.city as transaction_city
from accounts a
join transactions t on a.account_id = t.account_id
where a.city <> t.city;

-- 9. Merchants with unusually high refund rates (refund_count / total_txns).
-- Signals poor merchant quality or fraud.

select m.merchant_id,m.merchant_name,
(sum(case when t.txn_type = 'refund' then 1 end) * 100.0 / count(*)) as refund_rate
from transactions t
join merchants m on t.merchant_id = m.merchant_id
group by m.merchant_id, m.merchant_name
order by refund_rate desc;

-- 10. Accounts that received multiple refunds but made few purchases.
-- Chargeback abuse pattern.

select account_id,
sum(case when txn_type = 'refund' then 1 end) as refund_count,
sum(case when txn_type = 'debit' then 1 end) as purchase_count
from transactions
group by account_id
having refund_count > 3 and purchase_count < 5;

-- 11. Identify “night-time transactions” (midnight–5 AM) above ₹5,000.
-- Classic high-risk time window for card fraud.

select txn_id, account_id,
amount,txn_date, 
hour(txn_date) as txn_hour
from transactions
where hour(txn_date) between 0 and 5 and amount > 5000
order by amount desc;

-- 12. For each merchant category, calculate:
-- total transaction amount
-- average ticket size
-- fraud percentage
-- Useful for risk scoring and pricing models.

select merchant_category, sum(amount) as total_amount,
avg(amount) as avg_ticket_size,
(sum(case when is_fraud = 1 then 1 end) * 100.0 / count(*)) as fraud_percentage
from transactions t
join merchants m on t.merchant_id = m.merchant_id
group by merchant_category
order by total_amount desc;
