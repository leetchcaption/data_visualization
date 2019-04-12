[TOC]



# 选取原则

- 激活日期在[当前日期-360天，当前日期-180天]

- 激活后30天内有订单用户

- 激活180天内有90天表现期的订单，以后逾期不再考虑范围。（ 包括用户订单的最小应还款日<当前日期-90天）

  > 欺诈评分样本逾期标志的逻辑熟悉后进行抽样时，抽取最近一年满足逾期标志条件的白条、金条、借贷平台用户，然后我们给到天翼征信让他们回溯激活时间往前1年的电信数据字段（他们存储了近2年的历史数据，
  > 所以我们抽取近1年的样本，能保证所有样本都可以回溯1年的数据）。
  > 有2张实名用户和注册用户的jd_pin 身份证 手机号对应的表，里面可以筛选出电信用户，具体到时可以问下	
  > 抽取的样本量级在15到30万之间吧，其中白条不同渠道、金条、借贷平台的样本比例，最终的逾期率需要结合业务思考确定一下，另外坏样本的比例和绝对数量也不能太少。


  >天青石:
  >@卧薪尝胆的熊猫 您好！关于样本提数，我们这边还有些问题
  >
  >天青石:
  >3）匹配方式为根据第3列电信手机号精确匹配，基于第4列回溯日期匹配回溯日期前一年（不包含该回溯日期当天）的数据；需要匹配的字段为所有非标版联合建模字段（参见附件“非标版联合建模字段”Sheet页）；
  >
  >天青石:
  >第三条规则，要求按回溯日期提取前一年的数据，不包含该回溯日期当天
  >
  >天青石:
  >事实上我们的非标版联合建模字段是按月汇总的，不支持按日回溯
  >
  >卧薪尝胆的熊猫:
  >那匹配回溯日期前12个月的月汇总数据就可以了。
  >
  >天青石:
  >并且，非标版联合建模字段本身已经对特征做了1，3，6，全年的衍生，不需要每个月提一遍全量的历史数据吧
  >
  >天青石:
  >举个例子，两条记录的回溯日期是18年11/1号和11/20号，我们提数月份都会设置成2018年10月份，本身18年10月份的数据会基于17年11月到18年10月的数据进行汇总
  >
  >天青石:
  >而不会把17年11月到18年10月的月表数据中同一个号码对应的记录都提取出来
  >
  >卧薪尝胆的熊猫:
  >好的，明白了，那就匹配回溯日期前离回溯日期最近的那个月的数据。
  >
  >

# 选取白条用户样本

## 白条第1步：选取激活日期在[当前日期-360天，当前日期-180天]

因为电信数据只能回溯2年内的数据

```sql
use zr_dev;
drop table if exists zr_dev.lhw_pinsetuniversal_180927;
create table zr_dev.lhw_pinsetuniversal_180927 as
select usr_pin as pin, activated_time, cast(init_flag as int) as init_flag
from dmr.DMR_B_BT_USER_INFO_S_D
where dt = '2018-09-27' and activated_time is not NULL and 
substr(activated_time,1,10) <= date_sub('2018-09-27', 180) and 
substr(activated_time,1,10) >= date_sub('2018-09-27', 360) and length(substr(activated_time,1,10))=10;
```

```sql
select count(*), count(distinct pin), min(activated_time), max(activated_time) from zr_dev.lhw_pinsetuniversal_180927;
```
9042810	9042810	2017-10-02 00:00:01	2018-03-31 23:59:59


```sql
select init_flag, count(*) as cnt
from zr_dev.lhw_pinsetuniversal_180927
group by init_flag
order by cnt desc;
```

|	init_flag	|	cnt	|		ratio|
|-------|-----------|-----------|
|	11	|	1977241	|	21.87%	|
|	20	|	1555814	|	17.20%	|
|	9	|	1476375	|	16.33%	|
|	7	|	1110442	|	12.28%	|
|	17	|	878336	|	9.71%	|
|	25	|	547129	|	6.05%	|
|	24	|	499248	|	5.52%	|
|	19	|	250420	|	2.77%	|
|	12	|	217213	|	2.40%	|
|	8	|	179095	|	1.98%	|
|	13	|	154701	|	1.71%	|
|	18	|	119562	|	1.32%	|
|	14	|	35618	|	0.39%	|
|	6	|	15425	|	0.17%	|
|	23	|	9577	|	0.11%	|
|	5	|	7801	|	0.09%	|
|	-1	|	3994	|	0.04%	|
|	16	|	1816	|	0.02%	|
|	1	|	1444	|	0.02%	|
|	4	|	1355	|	0.01%	|
|	28	|	108	|	0.00%	|
|	26	|	57	|	0.00%	|
|	21	|	9	|	0.00%	|
|	22	|	8	|	0.00%	|
|	27	|	8	|	0.00%	|
|	32	|	6	|	0.00%	|
|	29	|	4	|	0.00%	|
|	34	|	3	|	0.00%	|
|	10	|	1	|	0.00%	|
```sql
select substr(activated_time,1,7) as activated_ym, count(*)
from zr_dev.lhw_pinsetuniversal_180927
group by substr(activated_time,1,7)
order by activated_ym;
```
|	activated_ym	|	cnt	|	ratio	|
|-------|-----------|-----------|
|	17-10	|	1278112	|	14.13%	|
|	17-11	|	2487495	|	27.51%	|
|	17-12	|	1809719	|	20.01%	|
|	18-1	|	1343171	|	14.85%	|
|	18-2	|	898210	|	9.93%	|
|	18-3	|	1226103	|	13.56%	|

## 白条第2步：选取白条用户分期订单
>2017年5月之后为账单制，之前的数据记录在dmr_b_bt_loan_bill_s_d表中，商品分期会产生多条记录；之后的数据记录在dmr_b_bt_bill_detail_s_d中。对dmr_b_bt_bill_detail_s_d理解：   
1、不分期的商品在该表中产生1条记录，billplanid为空；   
2、无论账单或商品分期，都会产生多条记录，商品分期billplainid为空，账单分期，首期billplainid为空   
3、全额退款的商品不会产生记录   
4、过渡期分期会产生部分记录       

- 因为激活日期在2017-10-2以后，所以在dmr_b_bt_loan_bill_s_d表中能够获取所有数据


```sql
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
    dt='2018-09-27' and refundstatus<>2 
    and substr(billlimitpaydate,1,10) <= date_sub('2018-09-27', 90);
```

```sql

select a.flag,count(*) as cnt from (
select bill_id as id, 'all' as flag from zr_dev.lhw_temp_pinsetuniversal_bill
union all
select bill_id as id , 'bill_id' as  flag from zr_dev.lhw_temp_pinsetuniversal_bill group by bill_id
union all
select order_id as id , 'order_id' as  flag from zr_dev.lhw_temp_pinsetuniversal_bill group by order_id
union all
select usr_pin as id, 'usr_pin' as flag from zr_dev.lhw_temp_pinsetuniversal_bill group by usr_pin) a group by a.flag;

flag	 cnt
all      804,200,018
bill_id	 804,199,159
order_id 361,278,379
usr_pin	 28,377,363

```

## 白条第3步：选取激活180天内有90天表现期的订单
1）在激活180天内有账单且没有逾期90+会算作好用户   
2）在激活180天内有账单且有逾期90+会算作坏用户  
3）在激活180天内无90+表现期的账单则不会进入建模样本

```sql
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
from zr_dev.lhw_pinsetuniversal_180927 a
inner join zr_dev.lhw_temp_pinsetuniversal_bill b
on a.pin = b.usr_pin
where date_add(substr(bill_set_repay_time,1,10),90) < date_add(substr(a.activated_time,1,10),180);
```

```sql
select a.flag,count(*) as cnt from (
select bill_id as id, 'all' as flag from zr_dev.lhw_temp_pinsetuniversal_bill_sel 
union all
select bill_id as id , 'bill_id' as  flag from zr_dev.lhw_temp_pinsetuniversal_bill_sel group by bill_id
union all
select order_id as id , 'order_id' as  flag from zr_dev.lhw_temp_pinsetuniversal_bill_sel group by order_id
union all
select pin as id, 'usr_pin' as flag from zr_dev.lhw_temp_pinsetuniversal_bill_sel group by pin) a group by a.flag;

flag	         cnt
all	        22436283
usr_pin 	6076882
bill_id	        22436222
order_id	18461135

```

## 白条第4步：去除下单时间小于激活时间的订单
```sql
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
```

```sql
select a.flag,count(*) as cnt from (
select bill_id as id, 'all' as flag from zr_dev.lhw_temp_pinsetuniversal_bill_correct
union all
select bill_id as id , 'bill_id' as  flag from zr_dev.lhw_temp_pinsetuniversal_bill_correct group by bill_id
union all
select order_id as id , 'order_id' as  flag from zr_dev.lhw_temp_pinsetuniversal_bill_correct group by order_id
union all
select pin as id, 'usr_pin' as flag from zr_dev.lhw_temp_pinsetuniversal_bill_correct group by pin) a group by a.flag;

flag	        cnt
all	        22436281
usr_pin  	6076881
bill_id  	22436220
order_id	18461134

```

## 白条第5步：最大逾期天数>90天指定用户标签为1
```sql
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

```

```sql
select dq_flag, count(*) from zr_dev.lhw_temp_pinsetuniversal_targets group by dq_flag;

```

|逾期状态| dq_flag |cnt | ratio |
|:-------|:---------|:----|:--------|
|未逾期90+| 0 | 6004008 | 98.80% |
|逾期90+| 1 | 72873 | 1.20% |

## 白条第6步：聚合激活时间，渠道信息

```sql
use zr_app;
drop table if exists zr_app.lhw_pinsetuniversal_180927_targets90_actm;
create table zr_app.lhw_pinsetuniversal_180927_targets90_actm as
select a.*, b.activated_time, b.init_flag
from zr_dev.lhw_temp_pinsetuniversal_targets a
inner join zr_dev.lhw_pinsetuniversal_180927 b
on a.pin = b.pin;
```

```sql
select count(1)  from zr_dev.lhw_temp_pinsetuniversal_targets; #选取了激活180天内有90天表现的订单
6076881
select count(*) from zr_dev.lhw_pinsetuniversal_180927;
9042810
```

```sql
select dq_flag, count(*)
from zr_app.lhw_pinsetuniversal_180927_targets90_actm
group by dq_flag
order by dq_flag;
```
|逾期状态| dq_flag |cnt | ratio |
|:-------|:---------|:----|:--------|
|未逾期90+| 0 | 6004008 | 98.80% |
|逾期90+| 1 | 72873 | 1.20% |

```sql
select count(*), count(distinct pin), min(activated_time), max(activated_time) from zr_app.lhw_pinsetuniversal_180927_targets90_actm;

6076881	6076881	2017-10-02 00:00:01	2018-03-31 23:59:59

```
## 白条第7步：选取激活30内下单用户

```sql
use zr_app;
drop table if exists zr_app.lhw_pinsetuniversal_180927_targets90af_actm;
create table zr_app.lhw_pinsetuniversal_180927_targets90af_actm as
select *
from zr_app.lhw_pinsetuniversal_180927_targets90_actm
where datediff(substr(min_created_date,1,10),substr(activated_time,1,10))<=30;

```

```sql
select dq_flag, count(*)
from zr_app.lhw_pinsetuniversal_180927_targets90af_actm
group by dq_flag
order by dq_flag;
```
|逾期状态| dq_flag |cnt | ratio |
|:-------|:---------|:----|:--------|
|未逾期90+| 0 | 5675705 | 98.77% |
|逾期90+| 1   |   70471 | 1.23% |



```sql
select substr(activated_time, 1, 7) as activated_dt, count(*), avg(dq_flag) as dq_rate
from zr_app.lhw_pinsetuniversal_180927_targets90af_actm
group by substr(activated_time, 1, 7)
order by activated_dt;
```

| 年月 | 激活人数 | 逾期比例 |
|:--- |:---  |:----  |
| 2017-10 | 861815 | 1.42% |
| 2017-11 | 1650075 | 1.69% |
| 2017-12 | 1133102 | 1.43% |
| 2018-01 | 810054 | 0.87% |
| 2018-02 | 540051 | 0.57% |
| 2018-03 | 751079 | 0.53% |

```sql
select flag1, flag2, dq_flag1, dq_flag2, count(*)
from
(
    select pin, dq_flag as dq_flag1, 1 as flag1
    from zr_app.lhw_pinsetuniversal_180927_targets90af_actm
) a
full outer join
(
    select pin, dq_flag as dq_flag2, 1 as flag2
    from zr_app.lhw_pinsetuniversal_180927_targets90_actm
) b
on a.pin = b.pin
group by flag1, flag2, dq_flag1, dq_flag2
order by flag1, flag2, dq_flag1, dq_flag2;


```

| 是否在新样本中 | 是否在老样本中 | 新样本中是否逾期 | 老样本中是否逾期 | 数量 |
| :------- | :------ | :--- | :--- | :--- |
| NULL | 1 | NULL | 0 | 好样本减少数：328303 |
| NULL | 1 | NULL | 1 | 坏样本减少数： 2402 |
| 1 | 1 | 0 | 0 | 新数据好样本数：5675705 |
| 1 | 1 | 1 | 1 | 新数据坏样本数量： 70471 |

- 其中好样本减少328303 占原好样本的比例为5.46%
- 坏样本减少2402 占原来坏样本比例为3.27%
- 新样本总体减少330705 ，占旧样本比例为5.44%
- 逾期率由1.20%上升到1.23%

# 金条样本选取

## 金条第1步：选取激活日期在[当前日期-360，当前日期180]
- 电信数据只能回溯到两年前，所以激活日期需在360天之内


```
use zr_tmp;
drop table if exists zr_tmp.lhw_jtpinsetuniversal_180927;
create table zr_tmp.lhw_jtpinsetuniversal_180927 as
select jd_pin as pin, activated_time,ord_tm
from dmr.dmr_b_bt_jt_user_info_s_d
where dt ='2018-09-27' and activated_time is not NULL and 
substr(activated_time,1,10) <= date_sub('2018-09-27', 180)  and
substr(activated_time,1, 10) >= date_sub('2018-09-27',360) and length(substr(activated_time,1,10))=10 ; 

```

```sql
select count(*),count(distinct pin),min(activated_time),max(activated_time) from zr_tmp.lhw_jtpinsetuniversal_180927;

2216435	2216435	2017-10-02 00:00:02	2018-03-31 23:59:55
```

## 金条第2步：选取激活180天内有90天表现期的订单
1）在激活180天内有账单且没有逾期90+会算作好用户  
2）在激活180天内有账单且有逾期90+会算作坏用户   
3）在激活180天内无90+表现期的账单则不会进入建模样本
```sql
use zr_tmp;
drop table if exists zr_tmp.lhw_jt_bill_flag;
create table zr_tmp.lhw_jt_bill_flag as
select a.pin,a.activated_time,b.created_date,order_id, set_repay_time,repay_date,overduedays
from zr_tmp.lhw_jtpinsetuniversal_180927 a 
inner join 
(
    select * 
    from dmr.dmr_b_bt_jt_loan_bill_s_d 
    where dt='2018-09-27'
) b
on a.pin=b.jd_pin 
where date_add(substr(b.set_repay_time,1,10),90) < date_add(substr(a.activated_time,1,10),180);
```

```sql
select count(*), count(distinct pin), count(distinct order_id) from zr_tmp.lhw_jt_bill_flag;

2310056	615306	1517995

```
## 金条第3步：修复下单时间早于激活时间的用户
- 没有需要修复的记录 


```sql
select count(*), count(distinct pin), count(distinct order_id)
from zr_tmp.lhw_jt_bill_flag
where datediff(substr(created_date,1,10), substr(activated_time,1,10)) <0;
0	0	0
```
## 金条第4步：在用户维度打标签
```sql
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

```

## 金条第5步：融合用户激活时间

```sql
use zr_app;
drop table if exists zr_app.lhw_jtpinsetuniversal_180927_targets90_actm;
create table zr_app.lhw_jtpinsetuniversal_180927_targets90_actm as
select a.*, b.activated_time
from zr_tmp.lhw_temp_jtpinsetuniversal_targets a
inner join zr_tmp.lhw_jtpinsetuniversal_180927 b
on a.pin = b.pin;
```

```sql
select count(*), count(distinct pin), min(activated_time), max(activated_time) from zr_app.lhw_jtpinsetuniversal_180927_targets90_actm;

615306	615306	2017-10-02 00:00:52	2018-03-31 23:59:27

```

```sql
select dq_flag, count(*)
from zr_app.lhw_jtpinsetuniversal_180927_targets90_actm
group by dq_flag
order by dq_flag;

```
| dq_flag | cnt | ratio |
| :----- | :----- | :----- |
| 好样本：0 | 611651 | 99.41% |
| 坏样本：1 | 3655 | 0.59% |

## 金条第6步：选取30内下单用户
```sql
use zr_app;
drop table if exists zr_app.lhw_jtpinsetuniversal_180927_targets90af_actm;
create table zr_app.lhw_jtpinsetuniversal_180927_targets90af_actm as
select *
from zr_app.lhw_jtpinsetuniversal_180927_targets90_actm
where datediff(substr(min_created_date,1,10),substr(activated_time,1,10))<=30;

```

```sql
select dq_flag, count(*)
from zr_app.lhw_jtpinsetuniversal_180927_targets90af_actm
group by dq_flag
order by dq_flag;
```
| dq_flag | cnt | ratio |
| :----- | :----- | :----- |
| 好样本：0 | 532264 | 99.33% |
| 坏样本：1 | 3588 | 0.67% |

```sql
select substr(activated_time, 1, 7) as activated_dt, count(*), avg(dq_flag) as dq_rate
from zr_app.lhw_jtpinsetuniversal_180927_targets90af_actm
group by substr(activated_time, 1, 7)
order by activated_dt;
```
| 年月 | 数量 | 逾期率 |
| :----- | :----- | :----- |
| 2017-10 | 76724 | 0.62% |
| 2017-11 | 93843 | 0.84% |
| 2017-12 | 64482 | 0.85% |
| 2018-01 | 97099 | 0.41% |
| 2018-02 | 93818 | 0.72% |
| 2018-03 | 109886 | 0.64% |

```sql
select flag1, flag2, dq_flag1, dq_flag2, count(*)
from
(
    select pin, dq_flag as dq_flag1, 1 as flag1
    from zr_app.lhw_jtpinsetuniversal_180927_targets90af_actm
) a
full outer join
(
    select pin, dq_flag as dq_flag2, 1 as flag2
    from zr_app.lhw_jtpinsetuniversal_180927_targets90_actm
) b
on a.pin = b.pin
group by flag1, flag2, dq_flag1, dq_flag2
order by flag1, flag2, dq_flag1, dq_flag2;
```

| 是否在新样本中 |  是否在老样本中 | 新样本中是否逾期 | 老样本中是否逾期 | 数量 |
| :----- | :----- | :----- | :----- | :----- |
| NULL | 1 | NULL | 0 | 好样本减少数：79387 |
| NULL | 1 | NULL | 1 | 坏样本减少数：67 |
| 1 | 1 | 0 | 0 | 新数据好样本数：532264 |
| 1 | 1 | 1 | 1 | 新数据好样本数：3588 |
- 逾期率由老样本的0.59%到新样本的0.67%
- 好样本减少79387占老样本好样本的12.98%
- 坏样本减少67，占老样本坏样本的1.83% 
- 样本整体减少12.91%

# 借钱平台样本选取

## 平台第1步：选取申请截至当天申请通过的用户，用户维度
```sql
use zr_tmp;
drop table if exists zr_tmp.lhw_jdpt_success_apply;
create table zr_tmp.lhw_jdpt_success_apply as
select user_jrid, apply_date, apply_no, lend_id, loan_product_id, loan_product_name, max(loan_amount) as loan_amount
from dwd.dwd_wallet_crpl_loan_apply_i_d
where dt <= '2018-09-27' and apply_status in ('PASS', 'EXPIRED')
group by user_jrid, apply_date, apply_no, lend_id, loan_product_id, loan_product_name;
```



```sql
select substr(apply_date, 1, 7) as apply_ym, count(*), count(distinct apply_no), count(distinct user_jrid)
from zr_tmp.lhw_jdpt_success_apply
group by substr(apply_date, 1, 7)
grouping sets ((),substr(apply_date, 1, 7))
order by apply_ym;
```

| 年月 | 非重复order_no | 非重复apply_no | 非重复pin |
| :----- | :----- | :----- | :----- |
| NULL | 3295474 | 3295305 | 1472861 |
| 2016-12 | 5 | 5 | 3 |
| 2017-01 | 22 | 22 | 20 |
| 2017-02 | 183 | 183 | 124 |
| 2017-03 | 2407 | 2407 | 2283 |
| 2017-04 | 5160 | 5160 | 4536 |
| 2017-05 | 50630 | 50630 | 44252 |
| 2017-06 | 69545 | 69545 | 59858 |
| 2017-07 | 76075 | 76075 | 63233 |
| 2017-08 | 83739 | 83739 | 69873 |
| 2017-09 | 184517 | 184517 | 132615 |
| 2017-10 | 158300 | 158300 | 116249 |
| 2017-11 | 260093 | 260093 | 188193 |
| 2017-12 | 262288 | 262288 | 196764 |
| 2018-01 | 161191 | 161191 | 124731 |
| 2018-02 | 141574 | 141574 | 108418 |
| 2018-03 | 177201 | 177201 | 132911 |
| 2018-04 | 177496 | 177496 | 135261 |
| 2018-05 | 188248 | 188248 | 138342 |
| 2018-06 | 257673 | 257673 | 186699 |
| 2018-07 | 324339 | 324170 | 233530 |
| 2018-08 | 385424 | 385424 | 272394 |
| 2018-09 | 329364 | 329364 | 240218 |

## 平台第2步：选取截至当天成功取现的订单，订单维度
```sql
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
    where dt<='2018-09-27' and status in ('COMPLETE', 'LOANED')
    group by cash_id, apply_no, created_date, loan_amount, cash_amount
) b
on a.apply_no = b.apply_no;
```

```sql

select count(*), count(distinct apply_no), count(distinct cash_id), 
sum(case when cash_id is not NULL and loan_amount!=loan_amount_cash_table then 1 else 0 end)
from zr_tmp.lhw_jdpt_success_cash ;

6668538	3295305	5605942	8248
```



```sql
select if_cash, count(*)
from
(
    select apply_no, max(case when cash_id is not NULL then 1 else 0 end) as if_cash
    from zr_tmp.lhw_jdpt_success_cash
    group by apply_no
) tmp
group by if_cash
order by if_cash;
```

| if_cash | cnt | ratio |
| :----- | :----- | :----- |
| cash_id不为空：0 | 1062324 | 32.24% |
| cash_id为空：1 | 2232981 | 67.76% |


## 平台第3步：选取还款账单数据
```sql
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
    where dt<='2018-09-27' and status in ('COMPLETE', 'LOANED')
    group by cash_id, apply_no, created_date, loan_amount, cash_amount
) a
inner join 
(
     select payment_no, order_no, repayment_index, repayment_time, repayment_real_time, 
         amount, principal, repayment_real_amount, real_principal, 
         overdue_amount, overdue_principal, overdue_days, status
     from dwd.dwd_wallet_crpl_repayment_plan_s_d
     where dt='2018-09-27'
     group by payment_no, order_no, repayment_index, repayment_time, repayment_real_time
         , amount, principal, repayment_real_amount, real_principal,
         overdue_amount, overdue_principal, overdue_days, status
) b
on a.cash_id = b.order_no;

```

```sql


select a.flag, count(*) as cnt from (
select 'all' as flag from zr_tmp.lhw_jdpt_repayment1
union all
select 'payment_no' as flag from zr_tmp.lhw_jdpt_repayment1 group by payment_no
union all
select 'apply_no' as flag from zr_tmp.lhw_jdpt_repayment1 group by apply_no
union all
select 'order_no' as flag from zr_tmp.lhw_jdpt_repayment1 group by order_no
union all
select 'order_index' as flag from  zr_tmp.lhw_jdpt_repayment1 group by concat(order_no, repayment_index)
) a group by a.flag;



all	        35585490
apply_no	2226040
order_no	5585158
payment_no	5480132
order_index	35585487


```

```sql
select count(*), count(distinct order_no)
from zr_tmp.lhw_jdpt_repayment1
where repayment_index=9999;

1671649	1671649
```
## 平台第4步：获取足额还款最后两期应还金额，实还金额，还款时间

- total_amount 为最后两笔还款金额
- once_repayment_real_amount为最后一次足额还款金额
- repayment_real_time 最后一次足额还款时间


```sql
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

```

## 平台第5步：补全足额还款的order_no的逾期账单还款时间
```sql

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
```

## 平台第6步：去除噪声数据
### CASE1: 还款时间为空，但实际并不为空，无法精确匹配得到还款时间，这部分order_no直接排除
```sql
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
    where dt<='2018-09-27'
    group by order_no
) b
on a.order_no = b.order_no;
```

### CASE2：当前未还总金额>授信总额度，此种情况授信总额度存疑
```sql
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
```

### CASE3：部分还款
```sql
use zr_tmp;
drop table if exists zr_tmp.lhw_jdpt_temp3;
create table zr_tmp.lhw_jdpt_temp3 as 
select order_no
from zr_tmp.lhw_jdpt_repayment3
where amount<=0 or (repayment_real_time is not NULL and if_new_repayment_real_time=0 and amount-repayment_real_amount>0)
group by order_no;
```

### 去除CASE1 CASE2 CASE3
```sql
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
```

## 平台第7步：选取激活日期[当前日期-360， 当前日期-180]

```sql
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
          where substr(apply_date,1,10)<=date_sub('2018-09-27', 180) and                           
                substr(apply_date,1,10)>=date_sub('2018-09-27', 360) and  
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
```

```sql

select a.flag , count(*)  as cnt from (
select '0_all' as flag from zr_tmp.lhw_jdpt_success_cash_repayment_status
union all 
select '1_user_jrid' as flag from zr_tmp.lhw_jdpt_success_cash_repayment_status group by user_jrid
union all 
select '2_apply_no' as flag from zr_tmp.lhw_jdpt_success_cash_repayment_status group by apply_no
union all
select '3_cash_id' as flag from zr_tmp.lhw_jdpt_success_cash_repayment_status group by cash_id
union all
select '4_cash_id_index' as flag from zr_tmp.lhw_jdpt_success_cash_repayment_status group by concat(cash_id, repayment_index)
) a group by a.flag;


0_all	            1894768
1_user_jrid	        477908
2_apply_no	        739729
3_cash_id	        1081260
4_cash_id_index	    1894768

```

## 平台第8步：在用户维度打标签
```sql
use zr_app;
drop table if exists zr_app.lhw_jdptpinsetuniversal_180927_targets90_actm;
create table zr_app.lhw_jdptpinsetuniversal_180927_targets90_actm as
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
```

```sql
select count(*), count(distinct pin), min(apply_date), max(apply_date) from zr_app.lhw_jdptpinsetuniversal_180927_targets90_actm;

739729	477908	2017-10-02 00:00:37	2018-03-31 23:59:50

```


```sql
select
case when cnt_apply>=3 then 3 else cnt_apply end as cnt_apply_new,
cnt_dq_flag,
dq_flag,
count(*)
from
(
    select pin, count(*) as cnt_apply, count(distinct dq_flag) as cnt_dq_flag, max(dq_flag) as dq_flag
    from zr_app.lhw_jdptpinsetuniversal_180927_targets90_actm
    group by pin
    order by pin
) tmp
group by
case when cnt_apply>=3 then 3 else cnt_apply end,
cnt_dq_flag,
dq_flag
order by 
cnt_apply_new,
cnt_dq_flag,
dq_flag;

```
- 去除30天下单用户之前逾期情况

| 申请成功次数 | 90+逾期状态去重 | 是否逾期 | 次数 | 比率 |
| :----- | :----- | :----- | :----- | :----- |
| 1 | 1 | 0 | 290518 | 60.79% |
| 1 | 1 | 1 | 12427 | 2.60% |
| 2 | 1 | 0 | 110072 | 23.03% |
| 2 | 1 | 1 | 1388 | 0.29% |
| 2 | 2 | 1 | 1490 | 0.31% |
| 3 | 1 | 0 | 60925 | 12.75% |
| 3 | 1 | 1 | 274 | 0.06% |
| 3 | 2 | 1 | 814 | 0.17% |

- _多次申请成功但逾期标志不一致的比例为：0.48%_
- _多次申请成功的用户为：36.61%_
- _逾期比例为3.43%_

## 平台第9步：选取激活30内下单的用户

```sql
use zr_app;
drop table if exists zr_app.lhw_jdptpinsetuniversal_180927_targets90af_actm;
create table zr_app.lhw_jdptpinsetuniversal_180927_targets90af_actm as
select *
from zr_app.lhw_jdptpinsetuniversal_180927_targets90_actm
where datediff(substr(min_cash_date,1,10),substr(apply_date,1,10))<=30;
```

```sql
select count(*), count(distinct pin), min(apply_date), max(apply_date) from zr_app.lhw_jdptpinsetuniversal_180927_targets90af_actm;

710532	467481	2017-10-02 00:00:37	2018-03-31 23:59:50

```

```sql
select
case when cnt_apply>=3 then 3 else cnt_apply end as cnt_apply_new,
cnt_dq_flag,
dq_flag,
count(*)
from
(
    select pin, count(*) as cnt_apply, count(distinct dq_flag) as cnt_dq_flag, max(dq_flag) as dq_flag
    from zr_app.lhw_jdptpinsetuniversal_180927_targets90af_actm
    group by pin
    order by pin
) tmp
group by
case when cnt_apply>=3 then 3 else cnt_apply end,
cnt_dq_flag,
dq_flag
order by 
cnt_apply_new,
cnt_dq_flag,
dq_flag;

```
- 去除30天下单用户后逾期情况

| 申请成功次数 | 90+逾期状态去重 | 是否逾期 | 次数 | 比率 |
| :----- | :----- | :----- | :----- | :----- |
| 1 | 1 | 0 | 289583 | 61.95% |
| 1 | 1 | 1 | 12416 | 2.66% |
| 2 | 1 | 0 | 106487 | 22.78% |
| 2 | 1 | 1 | 1369 | 0.29% |
| 2 | 2 | 1 | 1477 | 0.32% |
| 3 | 1 | 0 | 55101 | 11.79% |
| 3 | 1 | 1 | 272 | 0.06% |
| 3 | 2 | 1 | 776 | 0.17% |
- _多次申请成功但逾期标志不一致的比例为：0.49%_
- _多次申请成功的用户为：35.40%_
- _逾期比例为3.49%_
- _用户总量减少10427，占比2.18%_
- _好用户减少，占原样本好用户比例：2.24%_
- _坏用户减少，占原样本坏用户比例：0.51%_

```sql
select substr(apply_date, 1, 7) as apply_ym, count(*), avg(dq_flag) as dq_rate
from zr_app.lhw_jdptpinsetuniversal_180927_targets90af_actm
group by substr(apply_date, 1, 7)
order by apply_ym;

select substr(apply_date, 1, 7) as apply_ym, count(*), avg(dq_flag) as dq_rate
from zr_app.lhw_jdptpinsetuniversal_181022_targets90af_actm
group by substr(apply_date, 1, 7)
order by apply_ym;


```

| 年月 | apply_pin_cnt | 逾期率 |
| :----- | :----- | :----- |
| 2017-10 | 101879 | 3.45% |
| 2017-11 | 178695 | 4.71% |
| 2017-12 | 155783 | 2.50% |
| 2018-01 | 93062 | 0.91% |
| 2018-02 | 81707 | 1.11% |
| 2018-03 | 99406 | 1.03% |


# 白条、金条、借钱平台数据融合

## 融合第1步：union all 白条、金条、借钱平台

```sql
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
    from zr_app.lhw_pinsetuniversal_180927_targets90af_actm
    
    union all
    
    select 
    pin
    , dq_flag
    , activated_time
    , min_created_date
    , 'jt' as source
    , 1 as source_index
    , NULL as init_flag
    from zr_app.lhw_jtpinsetuniversal_180927_targets90af_actm
    
    union all
    
    select 
    pin
    , dq_flag
    , apply_date as activated_time
    , min_cash_date as min_created_date
    , 'jdpt' as source
    , 2 as source_index
    , NULL as init_flag
    from zr_app.lhw_jdptpinsetuniversal_180927_targets90af_actm
    
) tmp;


```

```sql
select source, count(*), count(distinct pin)
from zr_tmp.lhw_combpinsetuniversal_prep
group by source
grouping sets((),source)
order by source;
```



```sql

select
cnt_apply,
if_bt,
if_jt,
if_jdpt,
cnt_dq_flag,
dq_flag,
count(*)
from
(
    select pin, 
           count(distinct source) as cnt_apply, 
           max(case when source='bt' then 1 else 0 end) as if_bt,
           max(case when source='jt' then 1 else 0 end) as if_jt,
           max(case when source='jdpt' then 1 else 0 end) as if_jdpt,
           count(distinct dq_flag) as cnt_dq_flag,
           max(dq_flag) as dq_flag
    from zr_tmp.lhw_combpinsetuniversal_prep
    group by pin
    order by pin
) tmp
group by cnt_apply,if_bt,if_jt,if_jdpt,cnt_dq_flag,dq_flag
order by cnt_apply,if_bt,if_jt,if_jdpt,cnt_dq_flag,dq_flag;

```

| cnt_apply | if_bt | if_jt | if_jdpt | cnt_dq_flag | dq_flag | cnt | ratio |
| :----- | :----- | :----- | :----- | :----- | :----- | :----- | :----- |
| 1 | 0 | 0 | 1 | 1 | 0 | 383544 | 5.8401% |
| 1 | 0 | 0 | 1 | 1 | 1 | 12235 | 0.1863% |
| 1 | 0 | 0 | 1 | 2 | 1 | 1928 | 0.0294% |
| 1 | 0 | 1 | 0 | 1 | 0 | 397344 | 6.0503% |
| 1 | 0 | 1 | 0 | 1 | 1 | 2466 | 0.0375% |
| 1 | 1 | 0 | 0 | 1 | 0 | 5523422 | 84.1040% |
| 1 | 1 | 0 | 0 | 1 | 1 | 68100 | 1.0369% |
| 2 | 0 | 1 | 1 | 1 | 0 | 23332 | 0.3553% |
| 2 | 0 | 1 | 1 | 1 | 1 | 89 | 0.0014% |
| 2 | 0 | 1 | 1 | 2 | 1 | 260 | 0.0040% |
| 2 | 1 | 0 | 1 | 1 | 0 | 39762 | 0.6054% |
| 2 | 1 | 0 | 1 | 1 | 1 | 1014 | 0.0154% |
| 2 | 1 | 0 | 1 | 2 | 1 | 1517 | 0.0231% |
| 2 | 1 | 1 | 0 | 1 | 0 | 107465 | 1.6363% |
| 2 | 1 | 1 | 0 | 1 | 1 | 365 | 0.0056% |
| 2 | 1 | 1 | 0 | 2 | 1 | 731 | 0.0111% |
| 3 | 1 | 1 | 1 | 1 | 0 | 3744 | 0.0570% |
| 3 | 1 | 1 | 1 | 1 | 1 | 7 | 0.0001% |
| 3 | 1 | 1 | 1 | 2 | 1 | 49 | 0.0007% |

## 融合第2步：存在多条记录时候按借钱平台，金条，白条顺序选择，并最大dq_flag

```sql
use zr_app;
drop table if exists zr_app.lhw_combpinsetuniversal_180927_targets90af_actm;
create table zr_app.lhw_combpinsetuniversal_180927_targets90af_actm as
select a.pin, b.dq_flag, a.activated_time, a.min_created_date, a.source, a.init_flag
from
(
    select *
    from 
    (
        select *, row_number() over (partition by pin order by source_index desc,activated_time) as rownum
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

```

```sql
select source, count(*), count(distinct pin)
from zr_app.lhw_combpinsetuniversal_180927_targets90af_actm
group by source
grouping sets((),source)
order by source;
```
| source | cnt     | pin_cnt | ratio   |
| ------ | ------- | ------- | ------- |
| NULL   | 6567374 | 6567374 | 100.00% |
| bt     | 5591522 | 5591522 | 85.14%  |
| jdpt   | 467481  | 467481  | 7.12%   |
| jt     | 508371  | 508371  | 7.74%   |



## 融合第3步：去除企业账户，公司员工

### 筛选企业账号
```sql
use zr_app;
drop table if exists zr_app.lhw_enterprise_users_180927;
create table zr_app.lhw_enterprise_users_180927 as
select user_log_acct as pin
from dwd.DWD_JDMALL_SALE_ORDR_M04_SUM_I_D
where dt>='2014-01-01' and substr(ord_tm,1,10)>='2014-01-01' and length(reg_user_type_cd)>2
group by user_log_acct;
```

- 其中包含533个企业用户


```sql
select count(*)
from zr_app.lhw_combpinsetuniversal_180927_targets90af_actm a
inner join zr_app.lhw_enterprise_users_180927 b
on a.pin = b.pin;

553
```

- 其中包含3388个员工


```sql
select count(*)
from zr_app.lhw_combpinsetuniversal_180927_targets90af_actm a
inner join zr_app.dp_employee_users_180623 b
on a.pin = b.pin;
3388

```

### 去除企业账号，员工账号

```sql
use zr_app;
drop table if exists zr_app.lhw_combpinsetuniversal_180927_targets90af_actm_exld;
create table zr_app.lhw_combpinsetuniversal_180927_targets90af_actm_exld as
select a.*
from zr_app.lhw_combpinsetuniversal_180927_targets90af_actm a
left join
(
  select pin
  from
  (
    select pin
    from zr_app.lhw_enterprise_users_180927
    
    union all
    
    select pin
    from zr_app.dp_employee_users_180623
  ) tmp
  group by pin
) b
on a.pin = b.pin
where b.pin is NULL;
```

# 数据概览
## bt，jt，jqpt样本比例及逾期情况汇总
```sql
select source, count(*)
, count(distinct pin)
, sum(dq_flag) as dq_cnt
, avg(dq_flag) as dq_rate
from zr_app.lhw_combpinsetuniversal_180927_targets90af_actm_exld
group by source
grouping sets((),source)
order by source;
```

| source | cnt     | pin_cnt | dq_cnt | dq_rate |
| ------ | ------- | ------- | ------ | ------- |
| NULL   | 6563439 | 6563439 | 88715  | 1.35%   |
| bt     | 5589748 | 5589748 | 68088  | 1.22%   |
| jdpt   | 466392  | 466392  | 17068  | 3.66%   |
| jt     | 507299  | 507299  | 3559   | 0.70%   |

 

## 按激活年月查看激活人数及逾期率


```sql
select 
source
,substr(activated_time, 1, 7) as activated_ym
, count(*) as activated_cnt
, sum(dq_flag)  as dq_cnt
, avg(dq_flag) as dq_rate
from zr_app.lhw_combpinsetuniversal_180927_targets90af_actm_exld
group by substr(activated_time, 1, 7),source
grouping sets((),(substr(activated_time, 1, 7),source),substr(activated_time, 1, 7))
order by source,activated_ym;

```
| source | activated_ym | activated_cnt | dq_cnt | dq_rate |
| ------ | ------------ | ------------- | ------ | ------- |
| NULL   | NULL         | 6563439       | 88715  | 1.35%   |
| NULL   | 2017-10      | 980008        | 15988  | 1.63%   |
| NULL   | 2017-11      | 1805170       | 35172  | 1.95%   |
| NULL   | 2017-12      | 1262309       | 19794  | 1.57%   |
| NULL   | 2018-01      | 940048        | 8084   | 0.86%   |
| NULL   | 2018-02      | 669645        | 4343   | 0.65%   |
| NULL   | 2018-03      | 906259        | 5334   | 0.59%   |
| bt     | 2017-10      | 832270        | 11773  | 1.41%   |
| bt     | 2017-11      | 1595198       | 26757  | 1.68%   |
| bt     | 2017-12      | 1097277       | 15738  | 1.43%   |
| bt     | 2018-01      | 790263        | 6908   | 0.87%   |
| bt     | 2018-02      | 532731        | 3008   | 0.56%   |
| bt     | 2018-03      | 742009        | 3904   | 0.53%   |
| jdpt   | 2017-10      | 77295         | 3753   | 4.86%   |
| jdpt   | 2017-11      | 122293        | 7633   | 6.24%   |
| jdpt   | 2017-12      | 103718        | 3498   | 3.37%   |
| jdpt   | 2018-01      | 58712         | 783    | 1.33%   |
| jdpt   | 2018-02      | 47177         | 670    | 1.42%   |
| jdpt   | 2018-03      | 57197         | 731    | 1.28%   |
| jt     | 2017-10      | 70443         | 462    | 0.66%   |
| jt     | 2017-11      | 87679         | 782    | 0.89%   |
| jt     | 2017-12      | 61314         | 558    | 0.91%   |
| jt     | 2018-01      | 91073         | 393    | 0.43%   |
| jt     | 2018-02      | 89737         | 665    | 0.74%   |
| jt     | 2018-03      | 107053        | 699    | 0.65%   |

## 不同渠道逾期情况

```sql
select 
source
, init_flag
, count(*) as cnt
, count(distinct pin) as pin_cnt
, sum(dq_flag) as dq_cnt
,avg(dq_flag) as dq_rate
, min(activated_time) as min_activated_time
, max(activated_time) as max_activated_time
from zr_app.lhw_combpinsetuniversal_180927_targets90af_actm_exld
group by source, init_flag
grouping sets((),source,(source, init_flag))
order by source, dq_rate desc;
```

| source | init_flag | cnt     | pin_cnt | dq_cnt | dq_rate | min_activated | max_activated |
| ------ | --------- | ------- | ------- | ------ | ------- | ------------- | ------------- |
| NULL   | NULL      | 6563439 | 6563439 | 88715  | 1.35%   | 2017/10/2     | 2018/3/31     |
| bt     | 8         | 83314   | 83314   | 4248   | 5.10%   | 2017/10/2     | 2018/1/27     |
| bt     | 7         | 529962  | 529962  | 18014  | 3.40%   | 2017/10/2     | 2018/3/31     |
| bt     | 16        | 969     | 969     | 30     | 3.10%   | 2017/10/2     | 2017/11/29    |
| bt     | 25        | 221898  | 221898  | 6689   | 3.01%   | 2017/10/2     | 2018/3/31     |
| bt     | 4         | 701     | 701     | 17     | 2.43%   | 2017/10/2     | 2017/11/20    |
| bt     | 6         | 7523    | 7523    | 176    | 2.34%   | 2017/10/2     | 2018/3/14     |
| bt     | -1        | 2594    | 2594    | 58     | 2.24%   | 2017/10/2     | 2018/3/31     |
| bt     | 24        | 242957  | 242957  | 5177   | 2.13%   | 2017/10/2     | 2018/3/31     |
| bt     | 18        | 48173   | 48173   | 847    | 1.76%   | 2017/10/2     | 2018/3/31     |
| bt     | 23        | 5005    | 5005    | 72     | 1.44%   | 2017/10/2     | 2018/3/31     |
| bt     | 12        | 205862  | 205862  | 2772   | 1.35%   | 2017/10/2     | 2018/3/31     |
| bt     | NULL      | 5589748 | 5589748 | 68088  | 1.22%   | 2017/10/2     | 2018/3/31     |
| bt     | 9         | 796530  | 796530  | 8363   | 1.05%   | 2017/10/2     | 2018/3/31     |
| bt     | 17        | 492189  | 492189  | 4606   | 0.94%   | 2017/10/2     | 2018/3/31     |
| bt     | 19        | 237083  | 237083  | 2109   | 0.89%   | 2017/10/2     | 2018/3/31     |
| bt     | 20        | 747842  | 747842  | 5591   | 0.75%   | 2017/10/2     | 2018/3/31     |
| bt     | 11        | 1890374 | 1890374 | 9035   | 0.48%   | 2017/10/2     | 2018/3/31     |
| bt     | 5         | 4931    | 4931    | 22     | 0.45%   | 2017/10/2     | 2018/3/31     |
| bt     | 13        | 62320   | 62320   | 228    | 0.37%   | 2017/10/2     | 2018/3/31     |
| bt     | 14        | 9465    | 9465    | 34     | 0.36%   | 2017/10/2     | 2018/3/31     |
| bt     | 26        | 15      | 15      | 0      | 0.00%   | 2017/10/9     | 2017/12/26    |
| bt     | 22        | 3       | 3       | 0      | 0.00%   | 2017/10/31    | 2018/2/6      |
| bt     | 21        | 4       | 4       | 0      | 0.00%   | 2017/11/3     | 2018/2/12     |
| bt     | 27        | 1       | 1       | 0      | 0.00%   | 2017/11/6     | 2017/11/6     |
| bt     | 28        | 30      | 30      | 0      | 0.00%   | 2017/10/18    | 2018/1/2      |
| bt     | 10        | 1       | 1       | 0      | 0.00%   | 2018/3/12     | 2018/3/12     |
| bt     | 29        | 1       | 1       | 0      | 0.00%   | 2017/10/31    | 2017/10/31    |
| bt     | 32        | 1       | 1       | 0      | 0.00%   | 2017/11/1     | 2017/11/1     |
| jdpt   | NULL      | 466392  | 466392  | 17068  | 3.66%   | 2017/10/2     | 2018/3/31     |
| jdpt   | NULL      | 466392  | 466392  | 17068  | 3.66%   | 2017/10/2     | 2018/3/31     |
| jt     | NULL      | 507299  | 507299  | 3559   | 0.70%   | 2017/10/2     | 2018/3/31     |
| jt     | NULL      | 507299  | 507299  | 3559   | 0.70%   | 2017/10/2     | 2018/3/31     |

- 整体656w样本，白条573w，金条42w，借钱平台41w，比例约为14：1：1
- 总体逾期率为1.35%，白条逾期率为1.25%，金条逾期率0.67%，借钱平台逾期率3.55%
- 逾期总人数为8.8w，其中白条用户7.1w，金条逾期0.3w，借钱平台逾期1.4w



# 筛选电信用户

## 筛选程序

```sql
use zr_app;
drop table if exists zr_app.lhw_combpinsetuniversal_180927_targets90af_actm_exld_tele ;
create table zr_app.lhw_combpinsetuniversal_180927_targets90af_actm_exld_tele AS
select * from (
select
a.*
,b.mobile_md5
,source_mobile
,row_number() over (partition by a.pin order by b.source_mobile)  as rownum
from
zr_app.lhw_combpinsetuniversal_180927_targets90af_actm_exld a
join
(
    select jdpin as pin
    , telephone_md5 as mobile_md5
    , 1 as source_mobile
    from app.a_bt_realnameinfo_s_d
    where dt = '2018-09-27'
    and telephone_tm REGEXP '^(?:133|1349|149|1410|153|1700|1701|1702|177|173|18[019]|199)\\S{7,8}$|^(1740[0-5]\\S{6}$)'
    
    union all
    
    select pin
    , min(mobile_md5) as mobile_md5
    , 2 as source_mobile
    from app.a_jdmall_user_userinfo_s_d
    where dt = '2018-09-27'
    and mobile_tm REGEXP '^(?:133|1349|149|1410|153|1700|1701|1702|177|173|18[019]|199)\\S{7,8}$|^(1740[0-5]\\S{6}$)'
    group by pin
) b 
on a.pin = b.pin
) t
where t.rownum = 1;

```



## 查看电话号码来源

```sql
select 
source
, source_mobile
, count(*) as cnt
,sum(dq_flag) as dq_cnt
, avg(dq_flag) as dq_rate
from zr_app.lhw_combpinsetuniversal_180927_targets90af_actm_exld_tele
group by source,source_mobile
grouping sets((),(source,source_mobile),source,source_mobile)
order by source,source_mobile;
```

| source | source_mobile | cnt    | dq_cnt | dq_rate |
| ------ | ------------- | ------ | ------ | ------- |
| NULL   | NULL          | 907661 | 12261  | 1.35%   |
| NULL   | 1             | 807744 | 10125  | 1.25%   |
| NULL   | 2             | 99917  | 2136   | 2.14%   |
| bt     | NULL          | 769742 | 9573   | 1.24%   |
| bt     | 1             | 692007 | 7938   | 1.15%   |
| bt     | 2             | 77735  | 1635   | 2.10%   |
| jdpt   | NULL          | 66289  | 2164   | 3.26%   |
| jdpt   | 1             | 55630  | 1743   | 3.13%   |
| jdpt   | 2             | 10659  | 421    | 3.95%   |
| jt     | NULL          | 71630  | 524    | 0.73%   |
| jt     | 1             | 60107  | 444    | 0.74%   |
| jt     | 2             | 11523  | 80     | 0.69%   |

  

## 按月度查看逾期情况

```sql
select 
source
,substr(activated_time, 1, 7) as activated_ym
, count(*) as cnt
, sum(dq_flag) as dq_cnt
, avg(dq_flag) as dq_rate
from zr_app.lhw_combpinsetuniversal_180927_targets90af_actm_exld_tele
group by substr(activated_time, 1, 7),source
grouping sets((),source,(substr(activated_time, 1, 7),source),substr(activated_time, 1, 7))
order by source,activated_ym;

```

| source | activated_ym | cnt    | dq_cnt | dq_rate |
| ------ | ------------ | ------ | ------ | ------- |
| NULL   | NULL         | 907661 | 12261  | 1.35%   |
| NULL   | 2017-10      | 137686 | 2269   | 1.65%   |
| NULL   | 2017-11      | 251020 | 4724   | 1.88%   |
| NULL   | 2017-12      | 172800 | 2638   | 1.53%   |
| NULL   | 2018-01      | 128772 | 1192   | 0.93%   |
| NULL   | 2018-02      | 92048  | 653    | 0.71%   |
| NULL   | 2018-03      | 125335 | 785    | 0.63%   |
| bt     | NULL         | 769742 | 9573   | 1.24%   |
| bt     | 2017-10      | 116245 | 1704   | 1.47%   |
| bt     | 2017-11      | 221941 | 3669   | 1.65%   |
| bt     | 2017-12      | 150042 | 2130   | 1.42%   |
| bt     | 2018-01      | 107421 | 1023   | 0.95%   |
| bt     | 2018-02      | 72556  | 459    | 0.63%   |
| bt     | 2018-03      | 101537 | 588    | 0.58%   |
| jdpt   | NULL         | 66289  | 2164   | 3.26%   |
| jdpt   | 2017-10      | 11037  | 483    | 4.38%   |
| jdpt   | 2017-11      | 17014  | 940    | 5.52%   |
| jdpt   | 2017-12      | 14343  | 426    | 2.97%   |
| jdpt   | 2018-01      | 8625   | 111    | 1.29%   |
| jdpt   | 2018-02      | 6908   | 104    | 1.51%   |
| jdpt   | 2018-03      | 8362   | 100    | 1.20%   |
| jt     | NULL         | 71630  | 524    | 0.73%   |
| jt     | 2017-10      | 10404  | 82     | 0.79%   |
| jt     | 2017-11      | 12065  | 115    | 0.95%   |
| jt     | 2017-12      | 8415   | 82     | 0.97%   |
| jt     | 2018-01      | 12726  | 58     | 0.46%   |
| jt     | 2018-02      | 12584  | 90     | 0.72%   |
| jt     | 2018-03      | 15436  | 97     | 0.63%   |



## 9,11,20 预授信渠道打标签,并对激活时间重新筛选

```sql
use zr_tmp;
drop table if exists zr_tmp.lhw_dx_pinlist_prep;
create table zr_tmp.lhw_dx_pinlist_prep as
select *,
case when source in ('jdpt', 'jt') then source
     when source = 'bt' and init_flag in (9,11,20) then 'bt_1'
     when source = 'bt' and init_flag not in (9,11,20) then 'bt_2'
end as source_new
from zr_app.lhw_combpinsetuniversal_180927_targets90af_actm_exld_tele
where substr(activated_time,1,10) >= date_sub('2018-09-27',330);

```

  

```sql
select 
source_new
, count(*) as cnt
, count(distinct pin) as pin_cnt
,sum(dq_flag) as dq_cnt
, avg(dq_flag) as dq_rate
from zr_tmp.lhw_dx_pinlist_prep
group by source_new
grouping sets((),source_new)
order by source_new;
```

| source_new | cnt    | pin_cnt | dq_cnt | dq_rate |
| ---------- | ------ | ------- | ------ | ------- |
| NULL       | 769975 | 769975  | 9992   | 1.30%   |
| bt_1       | 401069 | 401069  | 3053   | 0.76%   |
| bt_2       | 252428 | 252428  | 4816   | 1.91%   |
| jdpt       | 55252  | 55252   | 1681   | 3.04%   |
| jt         | 61226  | 61226   | 442    | 0.72%   |



```sql
select 
source_new
,substr(activated_time, 1, 7) as activated_ym
, count(*) as cnt
, sum(dq_flag) as dq_cnt
, avg(dq_flag) as dq_rate
from zr_tmp.lhw_dx_pinlist_prep
group by substr(activated_time, 1, 7),source_new
grouping sets((),source_new,(substr(activated_time, 1, 7),source_new),substr(activated_time, 1, 7))
order by source_new,activated_ym;
```

   

| source | activated_ym | cnt    | dq_cnt | dq_rate |
| ------ | ------------ | ------ | ------ | ------- |
| NULL   | NULL         | 769975 | 9992   | 1.30%   |
| NULL   | 2017-11      | 251020 | 4724   | 1.88%   |
| NULL   | 2017-12      | 172800 | 2638   | 1.53%   |
| NULL   | 2018-01      | 128772 | 1192   | 0.93%   |
| NULL   | 2018-02      | 92048  | 653    | 0.71%   |
| NULL   | 2018-03      | 125335 | 785    | 0.63%   |
| bt_1   | NULL         | 401069 | 3053   | 0.76%   |
| bt_1   | 2017-11      | 139873 | 1374   | 0.98%   |
| bt_1   | 2017-12      | 99409  | 859    | 0.86%   |
| bt_1   | 2018-01      | 72447  | 459    | 0.63%   |
| bt_1   | 2018-02      | 42004  | 179    | 0.43%   |
| bt_1   | 2018-03      | 47336  | 182    | 0.38%   |
| bt_2   | NULL         | 252428 | 4816   | 1.91%   |
| bt_2   | 2017-11      | 82068  | 2295   | 2.80%   |
| bt_2   | 2017-12      | 50633  | 1271   | 2.51%   |
| bt_2   | 2018-01      | 34974  | 564    | 1.61%   |
| bt_2   | 2018-02      | 30552  | 280    | 0.92%   |
| bt_2   | 2018-03      | 54201  | 406    | 0.75%   |
| jdpt   | NULL         | 55252  | 1681   | 3.04%   |
| jdpt   | 2017-11      | 17014  | 940    | 5.52%   |
| jdpt   | 2017-12      | 14343  | 426    | 2.97%   |
| jdpt   | 2018-01      | 8625   | 111    | 1.29%   |
| jdpt   | 2018-02      | 6908   | 104    | 1.51%   |
| jdpt   | 2018-03      | 8362   | 100    | 1.20%   |
| jt     | NULL         | 61226  | 442    | 0.72%   |
| jt     | 2017-11      | 12065  | 115    | 0.95%   |
| jt     | 2017-12      | 8415   | 82     | 0.97%   |
| jt     | 2018-01      | 12726  | 58     | 0.46%   |
| jt     | 2018-02      | 12584  | 90     | 0.72%   |
| jt     | 2018-03      | 15436  | 97     | 0.63%   |



# 最终确定样本比例

## 筛选程序

```sql
use zr_app;
drop table if exists zr_app.lhw_dx_pinlist_180927_final;
create table zr_app.lhw_dx_pinlist_180927_final as
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
```



```sql
select 
source_new
, count(*) as cnt
, count(distinct jd_pin) as pin_cnt
,sum(dq_flag) as dq_cnt
, avg(dq_flag) as dq_rate
from zr_app.lhw_dx_pinlist_180927_final
group by source_new
grouping sets((),source_new)
order by source_new;



```

| source_new | cnt    | pin_cnt | dq_cnt | dq_rate |
| ---------- | ------ | ------- | ------ | ------- |
| NULL       | 200000 | 200000  | 9920   | 4.96%   |
| bt_1       | 30000  | 30000   | 3000   | 10.00%  |
| bt_2       | 70000  | 70000   | 4800   | 6.86%   |
| jdpt       | 50000  | 50000   | 1680   | 3.36%   |
| jt         | 50000  | 50000   | 440    | 0.88%   |

​    

```sql
select 
min(activated_time)
, max(activated_time)
from zr_app.lhw_dx_pinlist_180927_final;
```

> 2017-11-01 00:00:16	2018-03-31 23:59:10



```sql
select 
source_new
,substr(activated_time, 1, 7) as activated_ym
, count(*) as cnt
, sum(dq_flag) as dq_cnt
, avg(dq_flag) as dq_rate
from  zr_app.lhw_dx_pinlist_180927_final
group by substr(activated_time, 1, 7),source_new
grouping sets((),source_new,(substr(activated_time, 1, 7),source_new),substr(activated_time, 1, 7))
order by source_new,activated_ym;
```

| source_new | activated_ym | cnt    | dq_cnt | dq_rate |
| ---------- | ------------ | ------ | ------ | ------- |
| NULL       | NULL         | 200000 | 9920   | 4.96%   |
| NULL       | 2017-11      | 59211  | 4698   | 7.93%   |
| NULL       | 2017-12      | 41603  | 2616   | 6.29%   |
| NULL       | 2018-01      | 33278  | 1177   | 3.54%   |
| NULL       | 2018-02      | 27778  | 651    | 2.34%   |
| NULL       | 2018-03      | 38130  | 778    | 2.04%   |
| bt_1       | NULL         | 30000  | 3000   | 10.00%  |
| bt_1       | 2017-11      | 10754  | 1356   | 12.61%  |
| bt_1       | 2017-12      | 7548   | 842    | 11.16%  |
| bt_1       | 2018-01      | 5312   | 448    | 8.43%   |
| bt_1       | 2018-02      | 2985   | 178    | 5.96%   |
| bt_1       | 2018-03      | 3401   | 176    | 5.17%   |
| bt_2       | NULL         | 70000  | 4800   | 6.86%   |
| bt_2       | 2017-11      | 23137  | 2289   | 9.89%   |
| bt_2       | 2017-12      | 14220  | 1266   | 8.90%   |
| bt_2       | 2018-01      | 9773   | 560    | 5.73%   |
| bt_2       | 2018-02      | 8299   | 279    | 3.36%   |
| bt_2       | 2018-03      | 14571  | 406    | 2.79%   |
| jdpt       | NULL         | 50000  | 1680   | 3.36%   |
| jdpt       | 2017-11      | 15432  | 939    | 6.08%   |
| jdpt       | 2017-12      | 12992  | 426    | 3.28%   |
| jdpt       | 2018-01      | 7778   | 111    | 1.43%   |
| jdpt       | 2018-02      | 6236   | 104    | 1.67%   |
| jdpt       | 2018-03      | 7562   | 100    | 1.32%   |
| jt         | NULL         | 50000  | 440    | 0.88%   |
| jt         | 2017-11      | 9888   | 114    | 1.15%   |
| jt         | 2017-12      | 6843   | 82     | 1.20%   |
| jt         | 2018-01      | 10415  | 58     | 0.56%   |
| jt         | 2018-02      | 10258  | 90     | 0.88%   |
| jt         | 2018-03      | 12596  | 96     | 0.76%   |



# 跑取最新数据概览

## 总体用户

```sql
select 
source
,substr(activated_time, 1, 7) as activated_ym
, count(*) as activated_cnt
, sum(dq_flag)  as dq_cnt
, avg(dq_flag) as dq_rate
from zr_app.lhw_combpinsetuniversal_181022_targets90af_actm_exld
group by substr(activated_time, 1, 7),source
grouping sets((),(substr(activated_time, 1, 7),source),substr(activated_time, 1, 7))
order by source,activated_ym;
```

| source | activated_ym | cnt     | dq_cnt | dq_rate |
| ------ | ------------ | ------- | ------ | ------- |
| NULL   | NULL         | 6560463 | 81523  | 1.24%   |
| NULL   | 2017-10      | 189161  | 3128   | 1.65%   |
| NULL   | 2017-11      | 1796742 | 35526  | 1.98%   |
| NULL   | 2017-12      | 1253981 | 19978  | 1.59%   |
| NULL   | 2018-01      | 933249  | 8129   | 0.87%   |
| NULL   | 2018-02      | 668729  | 4430   | 0.66%   |
| NULL   | 2018-03      | 907884  | 5475   | 0.60%   |
| NULL   | 2018-04      | 810717  | 4857   | 0.60%   |
| bt     | 2017-10      | 156186  | 2071   | 1.33%   |
| bt     | 2017-11      | 1586546 | 26791  | 1.69%   |
| bt     | 2017-12      | 1089574 | 15768  | 1.45%   |
| bt     | 2018-01      | 783724  | 6923   | 0.88%   |
| bt     | 2018-02      | 529512  | 3017   | 0.57%   |
| bt     | 2018-03      | 739685  | 3945   | 0.53%   |
| bt     | 2018-04      | 643986  | 3598   | 0.56%   |
| jdpt   | 2017-10      | 17067   | 958    | 5.61%   |
| jdpt   | 2017-11      | 122770  | 7966   | 6.49%   |
| jdpt   | 2017-12      | 103332  | 3653   | 3.54%   |
| jdpt   | 2018-01      | 59137   | 811    | 1.37%   |
| jdpt   | 2018-02      | 50224   | 751    | 1.50%   |
| jdpt   | 2018-03      | 61993   | 831    | 1.34%   |
| jdpt   | 2018-04      | 50676   | 583    | 1.15%   |
| jt     | 2017-10      | 15908   | 99     | 0.62%   |
| jt     | 2017-11      | 87426   | 769    | 0.88%   |
| jt     | 2017-12      | 61075   | 557    | 0.91%   |
| jt     | 2018-01      | 90388   | 395    | 0.44%   |
| jt     | 2018-02      | 88993   | 662    | 0.74%   |
| jt     | 2018-03      | 106206  | 699    | 0.66%   |
| jt     | 2018-04      | 116055  | 676    | 0.58%   |





## 电信用户

```sql
select 
source
,substr(activated_time, 1, 7) as activated_ym
, count(*) as cnt
, sum(dq_flag) as dq_cnt
, avg(dq_flag) as dq_rate
from zr_app.lhw_combpinsetuniversal_181022_targets90af_actm_exld_tele
group by substr(activated_time, 1, 7),source
grouping sets((),source,(substr(activated_time, 1, 7),source),substr(activated_time, 1, 7))
order by source,activated_ym;
```

| source_new | activated_ym | cnt    | dq_cnt | dq_rate |
| ---------- | ------------ | ------ | ------ | ------- |
| NULL       | NULL         | 908830 | 11359  | 1.25%   |
| NULL       | 2017-10      | 26693  | 426    | 1.60%   |
| NULL       | 2017-11      | 250876 | 4793   | 1.91%   |
| NULL       | 2017-12      | 172258 | 2681   | 1.56%   |
| NULL       | 2018-01      | 128317 | 1212   | 0.94%   |
| NULL       | 2018-02      | 92320  | 666    | 0.72%   |
| NULL       | 2018-03      | 125974 | 813    | 0.65%   |
| NULL       | 2018-04      | 112392 | 768    | 0.68%   |
| bt         | NULL         | 762931 | 8831   | 1.16%   |
| bt         | 2017-10      | 22047  | 284    | 1.29%   |
| bt         | 2017-11      | 221632 | 3692   | 1.67%   |
| bt         | 2017-12      | 149503 | 2150   | 1.44%   |
| bt         | 2018-01      | 106944 | 1031   | 0.96%   |
| bt         | 2018-02      | 72384  | 465    | 0.64%   |
| bt         | 2018-03      | 101593 | 610    | 0.60%   |
| bt         | 2018-04      | 88828  | 599    | 0.67%   |
| jdpt       | NULL         | 66501  | 1978   | 2.97%   |
| jdpt       | 2017-10      | 2426   | 130    | 5.36%   |
| jdpt       | 2017-11      | 17171  | 987    | 5.75%   |
| jdpt       | 2017-12      | 14334  | 448    | 3.13%   |
| jdpt       | 2018-01      | 8696   | 123    | 1.41%   |
| jdpt       | 2018-02      | 7362   | 111    | 1.51%   |
| jdpt       | 2018-03      | 9016   | 107    | 1.19%   |
| jdpt       | 2018-04      | 7496   | 72     | 0.96%   |
| jt         | NULL         | 79398  | 550    | 0.69%   |
| jt         | 2017-10      | 2220   | 12     | 0.54%   |
| jt         | 2017-11      | 12073  | 114    | 0.94%   |
| jt         | 2017-12      | 8421   | 83     | 0.99%   |
| jt         | 2018-01      | 12677  | 58     | 0.46%   |
| jt         | 2018-02      | 12574  | 90     | 0.72%   |
| jt         | 2018-03      | 15365  | 96     | 0.62%   |
| jt         | 2018-04      | 16068  | 97     | 0.60%   |



```sql
select 
min(activated_time)
, max(activated_time)
from zr_app.lhw_combpinsetuniversal_181022_targets90af_actm_exld_tele;
```

> 2017-10-27 00:00:15	2018-04-25 23:59:53



## 按时间重新筛选电信用户

```sql
use zr_tmp;
drop table if exists zr_tmp.lhw_dx_pinlist_prep;
create table zr_tmp.lhw_dx_pinlist_prep as
select *,
case when source in ('jdpt', 'jt') then source
     when source = 'bt' and init_flag in (9,11,20) then 'bt_1'
     when source = 'bt' and init_flag not in (9,11,20) then 'bt_2'
end as source_new
from zr_app.lhw_combpinsetuniversal_181022_targets90af_actm_exld_tele
where substr(activated_time,1,10) >= date_sub('2018-10-22',350);
```



## 时间筛选后电信用户

```sql
select 
source_new
,substr(activated_time, 1, 7) as activated_ym
, count(*) as cnt
, sum(dq_flag) as dq_cnt
, avg(dq_flag) as dq_rate
from zr_tmp.lhw_dx_pinlist_prep
group by substr(activated_time, 1, 7),source_new
grouping sets((),source_new,(substr(activated_time, 1, 7),source_new),substr(activated_time, 1, 7))
order by source_new,activated_ym;
```

| source_new | activated_ym | cnt    | dq_cnt | dq_rate |
| ---------- | ------------ | ------ | ------ | ------- |
| NULL       | NULL         | 833367 | 10216  | 1.23%   |
| NULL       | 2017-11      | 202106 | 4076   | 2.02%   |
| NULL       | 2017-12      | 172258 | 2681   | 1.56%   |
| NULL       | 2018-01      | 128317 | 1212   | 0.94%   |
| NULL       | 2018-02      | 92320  | 666    | 0.72%   |
| NULL       | 2018-03      | 125974 | 813    | 0.65%   |
| NULL       | 2018-04      | 112392 | 768    | 0.68%   |
| bt_1       | NULL         | 408414 | 2997   | 0.73%   |
| bt_1       | 2017-11      | 111916 | 1152   | 1.03%   |
| bt_1       | 2017-12      | 99072  | 866    | 0.87%   |
| bt_1       | 2018-01      | 72129  | 464    | 0.64%   |
| bt_1       | 2018-02      | 41928  | 182    | 0.43%   |
| bt_1       | 2018-03      | 47339  | 191    | 0.40%   |
| bt_1       | 2018-04      | 36030  | 142    | 0.39%   |
| bt_2       | NULL         | 288438 | 4978   | 1.73%   |
| bt_2       | 2017-11      | 65684  | 1968   | 3.00%   |
| bt_2       | 2017-12      | 50431  | 1284   | 2.55%   |
| bt_2       | 2018-01      | 34815  | 567    | 1.63%   |
| bt_2       | 2018-02      | 30456  | 283    | 0.93%   |
| bt_2       | 2018-03      | 54254  | 419    | 0.77%   |
| bt_2       | 2018-04      | 52798  | 457    | 0.87%   |
| jdpt       | NULL         | 61286  | 1716   | 2.80%   |
| jdpt       | 2017-11      | 14382  | 855    | 5.94%   |
| jdpt       | 2017-12      | 14334  | 448    | 3.13%   |
| jdpt       | 2018-01      | 8696   | 123    | 1.41%   |
| jdpt       | 2018-02      | 7362   | 111    | 1.51%   |
| jdpt       | 2018-03      | 9016   | 107    | 1.19%   |
| jdpt       | 2018-04      | 7496   | 72     | 0.96%   |
| jt         | NULL         | 75229  | 525    | 0.70%   |
| jt         | 2017-11      | 10124  | 101    | 1.00%   |
| jt         | 2017-12      | 8421   | 83     | 0.99%   |
| jt         | 2018-01      | 12677  | 58     | 0.46%   |
| jt         | 2018-02      | 12574  | 90     | 0.72%   |
| jt         | 2018-03      | 15365  | 96     | 0.62%   |
| jt         | 2018-04      | 16068  | 97     | 0.60%   |

```sql
select 
min(activated_time)
, max(activated_time)
from zr_tmp.lhw_dx_pinlist_prep;
```

> 2017-11-06 00:00:03	2018-04-25 23:59:53

## 重新选择样本

```sql
use zr_app;
drop table if exists zr_app.lhw_dx_pinlist_181022_final;
create table zr_app.lhw_dx_pinlist_181022_final as
select
pin                              
        
,source_new as source                               
,init_flag
,mobile_md5
,substr(activated_time,1,10) as activated_day   
,dq_flag  

from
(
    select 
    *
    , row_number() over (partition by source_new,dq_flag order by rand(100)) as rownum2
    from zr_tmp.lhw_dx_pinlist_prep
) tmp
where (source_new='jdpt' and dq_flag = 1 and tmp.rownum2<=1700) or
      (source_new='jdpt' and dq_flag = 0 and tmp.rownum2<=48300) or
      (source_new='jt' and dq_flag = 1 and tmp.rownum2<=500) or
      (source_new='jt' and dq_flag = 0 and tmp.rownum2<=49500) or
      (source_new='bt_1' and dq_flag = 1 and tmp.rownum2<=2900) or
      (source_new='bt_1' and dq_flag = 0 and tmp.rownum2<=27100) or
      (source_new='bt_2' and dq_flag = 1 and tmp.rownum2<=4900) or
      (source_new='bt_2' and dq_flag = 0 and tmp.rownum2<=65100);
```



```sql
select 
source_new
, count(*) as cnt
, count(distinct jd_pin) as pin_cnt
,sum(dq_flag) as dq_cnt
, avg(dq_flag) as dq_rate
from zr_app.lhw_dx_pinlist_181022_final
group by source_new
grouping sets((),source_new)
order by source_new;
```

| source_new | activated_ym | cnt    | dq_cnt | dq_rate |
| ---------- | ------------ | ------ | ------ | ------- |
| NULL       | 200000       | 200000 | 10000  | 5.00%   |
| bt_1       | 30000        | 30000  | 2900   | 9.67%   |
| bt_2       | 70000        | 70000  | 4900   | 7.00%   |
| jdpt       | 50000        | 50000  | 1700   | 3.40%   |
| jt         | 50000        | 50000  | 500    | 1.00%   |

```sql
select 
min(activated_time)
, max(activated_time)
from zr_app.lhw_dx_pinlist_181022_final;
```

> 2017-11-06 00:00:10	2018-04-25 23:59:14



## 减1个月样本情况

```sql
select 
source_new
, count(*) as cnt
, count(distinct jd_pin) as pin_cnt
,sum(dq_flag) as dq_cnt
, avg(dq_flag) as dq_rate
from zr_app.lhw_dx_pinlist_181022_final
where substr(activated_time,1,10) >= date_sub('2018-10-22',330)
group by source_new
grouping sets((),source_new)
order by source_new;


```

| source_new | cnt    | cnt_pin | dq_cnt | dq_rate |
| ---------- | ------ | ------- | ------ | ------- |
| NULL       | 164496 | 164496  | 6734   | 4.09%   |
| bt_1       | 22580  | 22580   | 1936   | 8.57%   |
| bt_2       | 55919  | 55919   | 3303   | 5.91%   |
| jdpt       | 41138  | 41138   | 1066   | 2.59%   |
| jt         | 44859  | 44859   | 429    | 0.96%   |