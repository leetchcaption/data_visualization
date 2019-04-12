
## 白条第1步
use zr_dev;
drop table if exists zr_dev.lhw_pinsetuniversal_181022;
create table zr_dev.lhw_pinsetuniversal_181022 as
select usr_pin as pin, activated_time, cast(init_flag as int) as init_flag
from dmr.DMR_B_BT_USER_INFO_S_D
where dt = '2018-10-22' and activated_time is not NULL and 
substr(activated_time,1,10) <= date_sub('2018-10-22', 180) and 
substr(activated_time,1,10) >= date_sub('2018-10-22', 360) and length(substr(activated_time,1,10))=10;

## 白条第2步
use zr_dev;
drop table if exists zr_dev.lhw_temp_pinsetuniversal_bill;
create table zr_dev.lhw_temp_pinsetuniversal_bill as
select 
    billdetailid as  bill_id
    ,orderid as order_id
    ,pin as usr_pin
    ,plannum as instalment_num
    ,curplannum as cur_instalment
    ,billlimitpaydate as bill_set_repay_time
    ,repay_date  as repay_date
    ,overdays as plan_overdue_days 
    ,amount-amountdiscount-planedamt as bill_amount
    ,cxsdpamt+cxalreadypayamt as refund_amount
    ,consumerdate as  created_date
from
    dmr.dmr_b_bt_bill_detail_s_d 
where 
    dt='2018-10-22' and refundstatus<>2 
    and substr(billlimitpaydate,1,10) <= date_sub('2018-10-22', 90);

## 白条第3步
use zr_dev;
drop table if exists zr_dev.lhw_temp_pinsetuniversal_bill_sel;
create table zr_dev.lhw_temp_pinsetuniversal_bill_sel as
select 
a.*,
b.bill_id,               
b.order_id,                                      
b.instalment_num,           
b.cur_instalment,                    
b.bill_set_repay_time,      
b.repay_date, 
b.plan_overdue_days,                  
b.bill_amount,        
b.refund_amount,                                   
b.created_date
from zr_dev.lhw_pinsetuniversal_181022 a
inner join zr_dev.lhw_temp_pinsetuniversal_bill b
on a.pin = b.usr_pin
where date_add(substr(bill_set_repay_time,1,10),90) < date_add(substr(a.activated_time,1,10),180);

## 白条第4步
use zr_dev;
drop table if exists zr_dev.lhw_temp_pinsetuniversal_bill_correct;
create table zr_dev.lhw_temp_pinsetuniversal_bill_correct as
select a.*
from zr_dev.lhw_temp_pinsetuniversal_bill_sel a
left join
(
select distinct pin
from zr_dev.lhw_temp_pinsetuniversal_bill_sel c
where datediff(substr(created_date,1,10), substr(activated_time,1,10)) < 0
) b
on a.pin = b.pin
where b.pin is NULL;



## 白条第5步：最大逾期天数>90天指定用户标签为1

use zr_dev;
drop table if exists zr_dev.lhw_temp_pinsetuniversal_targets;
create table zr_dev.lhw_temp_pinsetuniversal_targets as
select pin,
       case when max_overduedays >90 then 1 else 0 end as dq_flag,
       min_created_date
from
(
select pin, max(plan_overdue_days) as max_overduedays, min(created_date) as min_created_date
from zr_dev.lhw_temp_pinsetuniversal_bill_correct
group by pin
) tmp;


## 白条第6步：聚合激活时间，渠道信息
use zr_app;
drop table if exists zr_app.lhw_pinsetuniversal_181022_targets90_actm;
create table zr_app.lhw_pinsetuniversal_181022_targets90_actm as
select a.*, b.activated_time, b.init_flag
from zr_dev.lhw_temp_pinsetuniversal_targets a
inner join zr_dev.lhw_pinsetuniversal_181022 b
on a.pin = b.pin;


## 白条第7步：选取激活30内下单用户
use zr_app;
drop table if exists zr_app.lhw_pinsetuniversal_181022_targets90af_actm;
create table zr_app.lhw_pinsetuniversal_181022_targets90af_actm as
select *
from zr_app.lhw_pinsetuniversal_181022_targets90_actm
where datediff(substr(min_created_date,1,10),substr(activated_time,1,10))<=30;

# 金条样本选取
## 金条第1步：选取激活日期在[当前日期-360，当前日期180]
use zr_tmp;
drop table if exists zr_tmp.lhw_jtpinsetuniversal_181022;
create table zr_tmp.lhw_jtpinsetuniversal_181022 as
select jd_pin as pin, activated_time,ord_tm
from dmr.dmr_b_bt_jt_user_info_s_d
where dt ='2018-10-22' and activated_time is not NULL and 
substr(activated_time,1,10) <= date_sub('2018-10-22', 180)  and
substr(activated_time,1, 10) >= date_sub('2018-10-22',360) and length(substr(activated_time,1,10))=10 ; 

## 金条第2步：选取激活180天内有90天表现期的订单
use zr_tmp;
drop table if exists zr_tmp.lhw_jt_bill_flag;
create table zr_tmp.lhw_jt_bill_flag as
select a.pin,a.activated_time,b.created_date,order_id, set_repay_time,repay_date,overduedays
from zr_tmp.lhw_jtpinsetuniversal_181022 a 
inner join 
(
    select * 
    from dmr.dmr_b_bt_jt_loan_bill_s_d 
    where dt='2018-10-22'
) b
on a.pin=b.jd_pin 
where date_add(substr(b.set_repay_time,1,10),90) < date_add(substr(a.activated_time,1,10),180);


## 金条第4步：在用户维度打标签

use zr_tmp;
drop table if exists zr_tmp.lhw_temp_jtpinsetuniversal_targets;
create table zr_tmp.lhw_temp_jtpinsetuniversal_targets as
select pin,
       case when max_overduedays >90 then 1 else 0 end as dq_flag,
       min_created_date
from
(
select pin, max(overduedays) as max_overduedays, min(created_date) as min_created_date
from zr_tmp.lhw_jt_bill_flag
group by pin
) tmp;



## 金条第5步：融合用户激活时间
use zr_app;
drop table if exists zr_app.lhw_jtpinsetuniversal_181022_targets90_actm;
create table zr_app.lhw_jtpinsetuniversal_181022_targets90_actm as
select a.*, b.activated_time
from zr_tmp.lhw_temp_jtpinsetuniversal_targets a
inner join zr_tmp.lhw_jtpinsetuniversal_181022 b
on a.pin = b.pin;


## 金条第6步：选取30内下单用户
use zr_app;
drop table if exists zr_app.lhw_jtpinsetuniversal_181022_targets90af_actm;
create table zr_app.lhw_jtpinsetuniversal_181022_targets90af_actm as
select *
from zr_app.lhw_jtpinsetuniversal_181022_targets90_actm
where datediff(substr(min_created_date,1,10),substr(activated_time,1,10))<=30;



# 借钱平台样本选取
## 平台第1步：选取申请截至当天申请通过的用户，用户维度
use zr_tmp;
drop table if exists zr_tmp.lhw_jdpt_success_apply;
create table zr_tmp.lhw_jdpt_success_apply as
select user_jrid, apply_date, apply_no, lend_id, loan_product_id, loan_product_name, max(loan_amount) as loan_amount
from dwd.dwd_wallet_crpl_loan_apply_i_d
where dt <= '2018-10-22' and apply_status in ('PASS', 'EXPIRED')
group by user_jrid, apply_date, apply_no, lend_id, loan_product_id, loan_product_name;




## 平台第2步：选取截至当天成功取现的订单，订单维度
use zr_tmp;
drop table if exists zr_tmp.lhw_jdpt_success_cash;
create table zr_tmp.lhw_jdpt_success_cash as
select
a.user_jrid,
a.apply_date,
a.apply_no,
a.lend_id,
a.loan_product_id,
a.loan_product_name,
a.loan_amount,
b.cash_id,
b.created_date as cash_date,
b.loan_amount as loan_amount_cash_table,
b.cash_amount
from zr_tmp.lhw_jdpt_success_apply a
left join 
(
    select cash_id, apply_no, created_date, loan_amount, cash_amount
    from dwd.dwd_wallet_crpl_cash_apply_i_d
    where dt<='2018-10-22' and status in ('COMPLETE', 'LOANED')
    group by cash_id, apply_no, created_date, loan_amount, cash_amount
) b
on a.apply_no = b.apply_no;




## 平台第3步：选取还款账单数据

use zr_tmp;
drop table if exists zr_tmp.lhw_jdpt_repayment1;
create table zr_tmp.lhw_jdpt_repayment1 as
select
a.cash_id, 
a.apply_no, 
a.created_date, 
a.loan_amount, 
a.cash_amount,
b.*
from 
(
    select cash_id, apply_no, created_date, loan_amount, cash_amount
    from dwd.dwd_wallet_crpl_cash_apply_i_d
    where dt<='2018-10-22' and status in ('COMPLETE', 'LOANED')
    group by cash_id, apply_no, created_date, loan_amount, cash_amount
) a
inner join 
(
     select payment_no, order_no, repayment_index, repayment_time, repayment_real_time, 
         amount, principal, repayment_real_amount, real_principal, 
         overdue_amount, overdue_principal, overdue_days, status
     from dwd.dwd_wallet_crpl_repayment_plan_s_d
     where dt='2018-10-22'
     group by payment_no, order_no, repayment_index, repayment_time, repayment_real_time
         , amount, principal, repayment_real_amount, real_principal,
         overdue_amount, overdue_principal, overdue_days, status
) b
on a.cash_id = b.order_no;


## 平台第4步：获取足额还款最后两期应还金额，实还金额，还款时间



use zr_tmp;
drop table if exists zr_tmp.lhw_jdpt_repayment2;
create table zr_tmp.lhw_jdpt_repayment2 as
select a.*, b.once_repayment_real_amount, b.repayment_real_time
from 
(
    select order_no, sum(amount) as total_amount
    from zr_tmp.lhw_jdpt_repayment1
    where (repayment_index!=9999 and repayment_real_time is NULL) or repayment_index=9999
    group by order_no
) a
inner join
(
    select order_no, sum(repayment_real_amount) as once_repayment_real_amount, min(repayment_real_time) as repayment_real_time
    from zr_tmp.lhw_jdpt_repayment1
    where repayment_index=9999
    group by order_no
    
) b
on a.order_no = b.order_no;



## 平台第5步：补全足额还款的order_no的逾期账单还款时间

use zr_tmp;
drop table if exists zr_tmp.lhw_jdpt_repayment3;
create table zr_tmp.lhw_jdpt_repayment3 as
select
a.cash_id,
a.apply_no,
a.created_date,
a.loan_amount,
a.cash_amount,
a.payment_no,
a.order_no,
a.repayment_index,
a.repayment_time,
case when repayment_index!=9999 and a.repayment_real_time is NULL and b.order_no is not NULL then b.repayment_real_time
     else a.repayment_real_time
end as repayment_real_time,
a.amount,
a.principal,
a.repayment_real_amount,
a.real_principal,
a.overdue_amount,
a.overdue_principal,
a.overdue_days,
a.status,
case when repayment_index!=9999 and a.repayment_real_time is NULL and b.order_no is not NULL then 1 else 0 end as if_new_repayment_real_time
from zr_tmp.lhw_jdpt_repayment1 a
left join 
(
    select *
    from zr_tmp.lhw_jdpt_repayment2
    where once_repayment_real_amount-total_amount>=-0.1
) b
on a.order_no = b.order_no;


## 平台第6步：去除噪声数据
### CASE1: 还款时间为空，但实际并不为空，无法精确匹配得到还款时间，这部分order_no直接排除

use zr_tmp;
drop table if exists zr_tmp.lhw_jdpt_temp1;
create table zr_tmp.lhw_jdpt_temp1 as 
select a.order_no
from
(
    select order_no, max(repayment_real_time) as repayment_real_time
    from zr_tmp.lhw_jdpt_repayment3
    group by order_no
    having repayment_real_time is NULL 
) a
inner join
(
    select order_no
    from dwd.dwd_wallet_crpl_repayment_record_i_d
    where dt<='2018-10-22'
    group by order_no
) b
on a.order_no = b.order_no;


### CASE2：当前未还总金额>授信总额度，此种情况授信总额度存疑

use zr_tmp;
drop table if exists zr_tmp.lhw_jdpt_temp2;
create table zr_tmp.lhw_jdpt_temp2 as 
select a.apply_no, a.unpaid_principal-b.loan_amount as amount_diff
from
(
    select apply_no, sum(unpaid_principal) as unpaid_principal
    from
    (
        select apply_no, principal as unpaid_principal
        from zr_tmp.lhw_jdpt_repayment3
        where repayment_real_time is NULL
        union all
        select apply_no, principal-real_principal as unpaid_principal
        from zr_tmp.lhw_jdpt_repayment3
        where repayment_real_time is not NULL and if_new_repayment_real_time=0 and principal-real_principal>0
    ) tmp
    group by apply_no
) a
inner join 
(
    select apply_no, loan_amount
    from zr_tmp.lhw_jdpt_repayment3
    group by apply_no, loan_amount
) b
on a.apply_no = b.apply_no
where a.unpaid_principal-b.loan_amount>=0.1;


### CASE3：部分还款

use zr_tmp;
drop table if exists zr_tmp.lhw_jdpt_temp3;
create table zr_tmp.lhw_jdpt_temp3 as 
select order_no
from zr_tmp.lhw_jdpt_repayment3
where amount<=0 or (repayment_real_time is not NULL and if_new_repayment_real_time=0 and amount-repayment_real_amount>0)
group by order_no;


### 去除CASE1 CASE2 CASE3

use zr_tmp;
drop table if exists zr_tmp.lhw_jdpt_repayment4;
create table zr_tmp.lhw_jdpt_repayment4 as
select a.*
from zr_tmp.lhw_jdpt_repayment3 a
left join
(
    select order_no
    from
    (
        select order_no
        from zr_tmp.lhw_jdpt_temp1
        
        union all
        
        select b.order_no
        from zr_tmp.lhw_jdpt_temp2 a
        inner join 
        (
            select apply_no, order_no
            from zr_tmp.lhw_jdpt_repayment3
            group by apply_no, order_no
        ) b
        on a.apply_no = b.apply_no
        
        union all
       
        select order_no
        from zr_tmp.lhw_jdpt_temp3
    ) tmp
    group by order_no
) b
on a.order_no = b.order_no
where b.order_no is NULL;


## 平台第7步：选取激活日期[当前日期-360， 当前日期-180]
use zr_tmp;
drop table if exists zr_tmp.lhw_jdpt_success_cash_repayment_status;
create table zr_tmp.lhw_jdpt_success_cash_repayment_status as
select c.*
from
(
    select 
    a.*,
    b.repayment_index,
    b.overdue_days,
    datediff(substr(b.repayment_real_date_new,1,10), substr(b.repayment_time,1,10)) as overdue_days_new
    from 
    (
        select *
        from zr_tmp.lhw_jdpt_success_cash
          where substr(apply_date,1,10)<=date_sub('2018-10-22', 180) and                           
                substr(apply_date,1,10)>=date_sub('2018-10-22', 360) and  
                length(substr(apply_date,1,10))=10
    ) a
    inner join 
    (
        select *, case when repayment_real_time is NULL then '2020-01-01' else   
                  substr(repayment_real_time,1,10) end as repayment_real_date_new
        from zr_tmp.lhw_jdpt_repayment4
    ) b
    on a.cash_id = b.cash_id 
    where substr(b.repayment_time,1,10)>substr(a.apply_date,1,10) and
          date_add(substr(b.repayment_time,1,10),90) < date_add(substr(a.apply_date,1,10),180)
) c
left join
(   
    select a.user_jrid
    from zr_tmp.lhw_jdpt_success_cash a
    inner join zr_tmp.lhw_jdpt_repayment4 b
    on a.cash_id = b.cash_id 
    where substr(b.repayment_time,1,10)<=substr(a.apply_date,1,10)
    group by a.user_jrid
) d
on c.user_jrid = d.user_jrid
where d.user_jrid is NULL;



## 平台第8步：在用户维度打标签

use zr_app;
drop table if exists zr_app.lhw_jdptpinsetuniversal_181022_targets90_actm;
create table zr_app.lhw_jdptpinsetuniversal_181022_targets90_actm as
select pin,
       apply_no,
       case when max_overduedays >90 then 1 else 0 end as dq_flag,
       apply_date,
       min_cash_date
from
(
    select user_jrid as pin, apply_no, max(overdue_days_new) as max_overduedays, min(apply_date) as apply_date, min(cash_date) as min_cash_date
    from zr_tmp.lhw_jdpt_success_cash_repayment_status
    group by user_jrid, apply_no
) tmp;


## 平台第9步：选取激活30内下单的用户


use zr_app;
drop table if exists zr_app.lhw_jdptpinsetuniversal_181022_targets90af_actm;
create table zr_app.lhw_jdptpinsetuniversal_181022_targets90af_actm as
select *
from zr_app.lhw_jdptpinsetuniversal_181022_targets90_actm
where datediff(substr(min_cash_date,1,10),substr(apply_date,1,10))<=30;



# 白条、金条、借钱平台数据融合

## 融合第1步：union all 白条、金条、借钱平台

use zr_tmp;
drop table if exists zr_tmp.lhw_combpinsetuniversal_prep;
create table zr_tmp.lhw_combpinsetuniversal_prep as
select *
from
(
    select 
    pin
    , dq_flag
    , activated_time
    , min_created_date
    , 'bt' as source
    , 0 as source_index
    , init_flag
    from zr_app.lhw_pinsetuniversal_181022_targets90af_actm
    
    union all
    
    select 
    pin
    , dq_flag
    , activated_time
    , min_created_date
    , 'jt' as source
    , 1 as source_index
    , NULL as init_flag
    from zr_app.lhw_jtpinsetuniversal_181022_targets90af_actm
    
    union all
    
    select 
    pin
    , dq_flag
    , apply_date as activated_time
    , min_cash_date as min_created_date
    , 'jdpt' as source
    , 2 as source_index
    , NULL as init_flag
    from zr_app.lhw_jdptpinsetuniversal_181022_targets90af_actm
) tmp;



## 融合第2步：存在多条记录时候按借钱平台，金条，白条顺序选择，并最大dq_flag

use zr_app;
drop table if exists zr_app.lhw_combpinsetuniversal_181022_targets90af_actm;
create table zr_app.lhw_combpinsetuniversal_181022_targets90af_actm as
select a.pin, b.dq_flag, a.activated_time, a.min_created_date, a.source, a.init_flag
from
(
    select *
    from 
    (
        select *, row_number() over (partition by pin order by source_index desc) as rownum
        from zr_tmp.lhw_combpinsetuniversal_prep
    ) tmp
    where rownum=1
) a
inner join
(
    select pin, max(dq_flag) as dq_flag
    from zr_tmp.lhw_combpinsetuniversal_prep
    group by pin
) b
on a.pin = b.pin;


## 融合第3步：去除企业账户，公司员工
### 筛选企业账号

use zr_app;
drop table if exists zr_app.lhw_enterprise_users_181022;
create table zr_app.lhw_enterprise_users_181022 as
select user_log_acct as pin
from dwd.DWD_JDMALL_SALE_ORDR_M04_SUM_I_D
where dt>='2014-01-01' and substr(ord_tm,1,10)>='2014-01-01' and length(reg_user_type_cd)>2
group by user_log_acct;



### 去除企业账号，员工账号

use zr_app;
drop table if exists zr_app.lhw_combpinsetuniversal_181022_targets90af_actm_exld;
create table zr_app.lhw_combpinsetuniversal_181022_targets90af_actm_exld as
select a.*
from zr_app.lhw_combpinsetuniversal_181022_targets90af_actm a
left join
(
  select pin
  from
  (
    select pin
    from zr_app.lhw_enterprise_users_181022
    
    union all
    
    select pin
    from zr_app.dp_employee_users_180623
  ) tmp
  group by pin
) b
on a.pin = b.pin
where b.pin is NULL;



# 筛选电信用户

## 筛选程序

use zr_app;
drop table if exists zr_app.lhw_combpinsetuniversal_181022_targets90af_actm_exld_tele ;
create table zr_app.lhw_combpinsetuniversal_181022_targets90af_actm_exld_tele AS
select * from (
select
a.*
,b.mobile_md5
,source_mobile
,row_number() over (partition by a.pin order by b.source_mobile)  as rownum
from
zr_app.lhw_combpinsetuniversal_181022_targets90af_actm_exld a
join
(
    select jdpin as pin
    , telephone_md5 as mobile_md5
    , 1 as source_mobile
    from app.a_bt_realnameinfo_s_d
    where dt = '2018-10-22'
    and telephone_tm REGEXP '^(?:133|1349|149|1410|153|1700|1701|1702|177|173|18[019]|199)\\S{7,8}$|^(1740[0-5]\\S{6}$)'
    
    union all
    
    select pin
    , min(mobile_md5) as mobile_md5
    , 2 as source_mobile
    from app.a_jdmall_user_userinfo_s_d
    where dt = '2018-10-22'
    and mobile_tm REGEXP '^(?:133|1349|149|1410|153|1700|1701|1702|177|173|18[019]|199)\\S{7,8}$|^(1740[0-5]\\S{6}$)'
    group by pin
) b 
on a.pin = b.pin
) t
where t.rownum = 1;



## 9,11,20 预授信渠道打标签,并对激活时间重新筛选
use zr_tmp;
drop table if exists zr_tmp.lhw_dx_pinlist_prep;
create table zr_tmp.lhw_dx_pinlist_prep as
select *,
case when source in ('jdpt', 'jt') then source
     when source = 'bt' and init_flag in (9,11,20) then 'bt_1'
     when source = 'bt' and init_flag not in (9,11,20) then 'bt_2'
end as source_new
from zr_app.lhw_combpinsetuniversal_181022_targets90af_actm_exld_tele
where substr(activated_time,1,10) >= date_sub('2018-10-22',330);



# 最终确定样本比例
## 筛选程序
use zr_app;
drop table if exists zr_app.lhw_dx_pinlist_181022_final;
create table zr_app.lhw_dx_pinlist_181022_final as
select
pin as jd_pin,                               
dq_flag,                           
activated_time,                                
min_created_date,                          
source,
source_new,                               
init_flag
,mobile_md5
,source_mobile
from
(
    select 
    *
    , row_number() over (partition by source_new,dq_flag order by rand(100)) as rownum2
    from zr_tmp.lhw_dx_pinlist_prep
) tmp
where (source_new='jdpt' and dq_flag = 1 and tmp.rownum2<=1680) or
      (source_new='jdpt' and dq_flag = 0 and tmp.rownum2<=48320) or
      (source_new='jt' and dq_flag = 1 and tmp.rownum2<=440) or
      (source_new='jt' and dq_flag = 0 and tmp.rownum2<=49560) or
      (source_new='bt_1' and dq_flag = 1 and tmp.rownum2<=3000) or
      (source_new='bt_1' and dq_flag = 0 and tmp.rownum2<=27000) or
      (source_new='bt_2' and dq_flag = 1 and tmp.rownum2<=4800) or
      (source_new='bt_2' and dq_flag = 0 and tmp.rownum2<=65200);

