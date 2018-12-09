
# 泰坦尼克号乘客生存预测

## 案例背景
泰坦尼克号沉船事故是世界上最著名的沉船事故之一。1912年4月15日，在她的处女航期间，泰坦尼克号撞上冰山后沉没，造成2224名乘客和机组人员中超过1502人的死亡。这一轰动的悲剧震惊了国际社会，并导致更好的船舶安全法规。 事故中导致死亡的一个原因是许多船员和乘客没有足够的救生艇。然而在被获救群体中也有一些比较幸运的因素；一些人群在事故中被救的几率高于其他人，比如妇女、儿童和上层阶级。 这个Case里，我们需要分析和判断出什么样的人更容易获救。最重要的是，要利用机器学习来预测出在这场灾难中哪些人会最终获救；


```python
import pandas as pd
import numpy as np
train_set = pd.read_csv('D:\\Workspace\\Python\\datasets\\train.csv',sep=',')
test_set = pd.read_csv('D:\Workspace\Python\datasets\\test.csv',sep=',')
```

## 数据特征
- PassengerId	乘客编号
- Survived	存活情况（存活：1 ; 死亡：0）
- Pclass	客舱等级
- Name	乘客姓名
- Sex	性别
- Age	年龄
- SibSp	同乘的兄弟姐妹/配偶数
- Parch	同乘的父母/小孩数
- Ticket	船票编号
- Fare	船票价格
- Cabin	客舱号
- Embarked	登船港口
> PassengerId 是数据唯一序号；Survived 是存活情况，为预测标记特征；剩下的10个是原始特征数据

## 数据处理


```python
train_set.head(5)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>PassengerId</th>
      <th>Survived</th>
      <th>Pclass</th>
      <th>Name</th>
      <th>Sex</th>
      <th>Age</th>
      <th>SibSp</th>
      <th>Parch</th>
      <th>Ticket</th>
      <th>Fare</th>
      <th>Cabin</th>
      <th>Embarked</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1</td>
      <td>0</td>
      <td>3</td>
      <td>Braund, Mr. Owen Harris</td>
      <td>male</td>
      <td>22.0</td>
      <td>1</td>
      <td>0</td>
      <td>A/5 21171</td>
      <td>7.2500</td>
      <td>NaN</td>
      <td>S</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2</td>
      <td>1</td>
      <td>1</td>
      <td>Cumings, Mrs. John Bradley (Florence Briggs Th...</td>
      <td>female</td>
      <td>38.0</td>
      <td>1</td>
      <td>0</td>
      <td>PC 17599</td>
      <td>71.2833</td>
      <td>C85</td>
      <td>C</td>
    </tr>
    <tr>
      <th>2</th>
      <td>3</td>
      <td>1</td>
      <td>3</td>
      <td>Heikkinen, Miss. Laina</td>
      <td>female</td>
      <td>26.0</td>
      <td>0</td>
      <td>0</td>
      <td>STON/O2. 3101282</td>
      <td>7.9250</td>
      <td>NaN</td>
      <td>S</td>
    </tr>
    <tr>
      <th>3</th>
      <td>4</td>
      <td>1</td>
      <td>1</td>
      <td>Futrelle, Mrs. Jacques Heath (Lily May Peel)</td>
      <td>female</td>
      <td>35.0</td>
      <td>1</td>
      <td>0</td>
      <td>113803</td>
      <td>53.1000</td>
      <td>C123</td>
      <td>S</td>
    </tr>
    <tr>
      <th>4</th>
      <td>5</td>
      <td>0</td>
      <td>3</td>
      <td>Allen, Mr. William Henry</td>
      <td>male</td>
      <td>35.0</td>
      <td>0</td>
      <td>0</td>
      <td>373450</td>
      <td>8.0500</td>
      <td>NaN</td>
      <td>S</td>
    </tr>
  </tbody>
</table>
</div>




```python
test_set.head(5)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>PassengerId</th>
      <th>Pclass</th>
      <th>Name</th>
      <th>Sex</th>
      <th>Age</th>
      <th>SibSp</th>
      <th>Parch</th>
      <th>Ticket</th>
      <th>Fare</th>
      <th>Cabin</th>
      <th>Embarked</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>892</td>
      <td>3</td>
      <td>Kelly, Mr. James</td>
      <td>male</td>
      <td>34.5</td>
      <td>0</td>
      <td>0</td>
      <td>330911</td>
      <td>7.8292</td>
      <td>NaN</td>
      <td>Q</td>
    </tr>
    <tr>
      <th>1</th>
      <td>893</td>
      <td>3</td>
      <td>Wilkes, Mrs. James (Ellen Needs)</td>
      <td>female</td>
      <td>47.0</td>
      <td>1</td>
      <td>0</td>
      <td>363272</td>
      <td>7.0000</td>
      <td>NaN</td>
      <td>S</td>
    </tr>
    <tr>
      <th>2</th>
      <td>894</td>
      <td>2</td>
      <td>Myles, Mr. Thomas Francis</td>
      <td>male</td>
      <td>62.0</td>
      <td>0</td>
      <td>0</td>
      <td>240276</td>
      <td>9.6875</td>
      <td>NaN</td>
      <td>Q</td>
    </tr>
    <tr>
      <th>3</th>
      <td>895</td>
      <td>3</td>
      <td>Wirz, Mr. Albert</td>
      <td>male</td>
      <td>27.0</td>
      <td>0</td>
      <td>0</td>
      <td>315154</td>
      <td>8.6625</td>
      <td>NaN</td>
      <td>S</td>
    </tr>
    <tr>
      <th>4</th>
      <td>896</td>
      <td>3</td>
      <td>Hirvonen, Mrs. Alexander (Helga E Lindqvist)</td>
      <td>female</td>
      <td>22.0</td>
      <td>1</td>
      <td>1</td>
      <td>3101298</td>
      <td>12.2875</td>
      <td>NaN</td>
      <td>S</td>
    </tr>
  </tbody>
</table>
</div>




```python
train_set[['Survived','Age','SibSp','Parch','Fare']].describe(include='all')
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Survived</th>
      <th>Age</th>
      <th>SibSp</th>
      <th>Parch</th>
      <th>Fare</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>count</th>
      <td>891.000000</td>
      <td>714.000000</td>
      <td>891.000000</td>
      <td>891.000000</td>
      <td>891.000000</td>
    </tr>
    <tr>
      <th>mean</th>
      <td>0.383838</td>
      <td>29.699118</td>
      <td>0.523008</td>
      <td>0.381594</td>
      <td>32.204208</td>
    </tr>
    <tr>
      <th>std</th>
      <td>0.486592</td>
      <td>14.526497</td>
      <td>1.102743</td>
      <td>0.806057</td>
      <td>49.693429</td>
    </tr>
    <tr>
      <th>min</th>
      <td>0.000000</td>
      <td>0.420000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>25%</th>
      <td>0.000000</td>
      <td>20.125000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>7.910400</td>
    </tr>
    <tr>
      <th>50%</th>
      <td>0.000000</td>
      <td>28.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>14.454200</td>
    </tr>
    <tr>
      <th>75%</th>
      <td>1.000000</td>
      <td>38.000000</td>
      <td>1.000000</td>
      <td>0.000000</td>
      <td>31.000000</td>
    </tr>
    <tr>
      <th>max</th>
      <td>1.000000</td>
      <td>80.000000</td>
      <td>8.000000</td>
      <td>6.000000</td>
      <td>512.329200</td>
    </tr>
  </tbody>
</table>
</div>




```python
print(train_set.info())
```

    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 891 entries, 0 to 890
    Data columns (total 12 columns):
    PassengerId    891 non-null int64
    Survived       891 non-null int64
    Pclass         891 non-null int64
    Name           891 non-null object
    Sex            891 non-null object
    Age            714 non-null float64
    SibSp          891 non-null int64
    Parch          891 non-null int64
    Ticket         891 non-null object
    Fare           891 non-null float64
    Cabin          204 non-null object
    Embarked       889 non-null object
    dtypes: float64(2), int64(5), object(5)
    memory usage: 83.6+ KB
    None
    

从上面数据我们可以看到Age,Cabin和Embarked列的数据有缺失，Age列共有714条数据，缺失117条数据；Cabin列有204条数据，缺失687条数据；Embarked列有889条数据，缺失2条数据，其他列都是891条数据；

## 特征选取

### 缺省值处理
客舱号Cabin列由于存在大量的空值，如果直接对空值进行填空，带来的误差影响会比较大，先不选用Cabin列做特征
年龄列对于是否能够存活的判断很重要，采用Age均值对空值进行填充
PassengerId是一个连续的序列，对于是否能够存活的判断无关，不选用PassengerId作为特征


```python
train_set['Age'] = train_set['Age'].fillna(train_set['Age'].median())
```


```python
train_set['Age'].describe()
```




    count    891.000000
    mean      29.361582
    std       13.019697
    min        0.420000
    25%       22.000000
    50%       28.000000
    75%       35.000000
    max       80.000000
    Name: Age, dtype: float64



### 归一化


```python
train_line = train_set
train_set.columns
```




    Index(['PassengerId', 'Survived', 'Pclass', 'Name', 'Sex', 'Age', 'SibSp',
           'Parch', 'Ticket', 'Fare', 'Cabin', 'Embarked'],
          dtype='object')




```python
dum_sex = pd.get_dummies(train_line['Sex'],prefix='Sex')
# train_line.head(10)
dum_sex.head(5)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Sex_female</th>
      <th>Sex_male</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>0</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>0</td>
      <td>1</td>
    </tr>
  </tbody>
</table>
</div>




```python
from sklearn.linear_model import LinearRegression
# 训练集交叉验证，得到均值
from sklearn.model_selection import KFold
# 初始化线性回归算法
alg = LinearRegression()
# 进行3折交叉验证
kf = KFold(n_splits=3,shuffle=False)
train_line_final = pd.concat([train_line,dum_sex],axis=1)
train_line_final.columns
```




    Index(['PassengerId', 'Survived', 'Pclass', 'Name', 'Sex', 'Age', 'SibSp',
           'Parch', 'Ticket', 'Fare', 'Cabin', 'Embarked', 'Sex_female',
           'Sex_male'],
          dtype='object')




```python
# 参与变量
vctors = ['Pclass','Sex_female','Sex_male','Age','SibSp','Parch','Fare']
train_line_final[vctors].head(10)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Pclass</th>
      <th>Sex_female</th>
      <th>Sex_male</th>
      <th>Age</th>
      <th>SibSp</th>
      <th>Parch</th>
      <th>Fare</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>3</td>
      <td>0</td>
      <td>1</td>
      <td>22.0</td>
      <td>1</td>
      <td>0</td>
      <td>7.2500</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1</td>
      <td>1</td>
      <td>0</td>
      <td>38.0</td>
      <td>1</td>
      <td>0</td>
      <td>71.2833</td>
    </tr>
    <tr>
      <th>2</th>
      <td>3</td>
      <td>1</td>
      <td>0</td>
      <td>26.0</td>
      <td>0</td>
      <td>0</td>
      <td>7.9250</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1</td>
      <td>1</td>
      <td>0</td>
      <td>35.0</td>
      <td>1</td>
      <td>0</td>
      <td>53.1000</td>
    </tr>
    <tr>
      <th>4</th>
      <td>3</td>
      <td>0</td>
      <td>1</td>
      <td>35.0</td>
      <td>0</td>
      <td>0</td>
      <td>8.0500</td>
    </tr>
    <tr>
      <th>5</th>
      <td>3</td>
      <td>0</td>
      <td>1</td>
      <td>28.0</td>
      <td>0</td>
      <td>0</td>
      <td>8.4583</td>
    </tr>
    <tr>
      <th>6</th>
      <td>1</td>
      <td>0</td>
      <td>1</td>
      <td>54.0</td>
      <td>0</td>
      <td>0</td>
      <td>51.8625</td>
    </tr>
    <tr>
      <th>7</th>
      <td>3</td>
      <td>0</td>
      <td>1</td>
      <td>2.0</td>
      <td>3</td>
      <td>1</td>
      <td>21.0750</td>
    </tr>
    <tr>
      <th>8</th>
      <td>3</td>
      <td>1</td>
      <td>0</td>
      <td>27.0</td>
      <td>0</td>
      <td>2</td>
      <td>11.1333</td>
    </tr>
    <tr>
      <th>9</th>
      <td>2</td>
      <td>1</td>
      <td>0</td>
      <td>14.0</td>
      <td>1</td>
      <td>0</td>
      <td>30.0708</td>
    </tr>
  </tbody>
</table>
</div>



## 线性回归算法


```python
# 交叉训练线性回归模型
# 预测目标值
predictions = []
for train, test in kf.split(train_line_final):
    train_predictors = (train_line_final[vctors].iloc[train,:])
    train_target = train_line_final['Survived'].iloc[train]
    alg.fit(train_predictors,train_target)
    test_predictions = alg.predict(train_line_final[vctors].iloc[test,:])
    predictions.append(test_predictions)
```

> shape of predictions
> (3, 297)
### 模型正确率
* The predictions are in three aeparate numpy arrays.	Concatenate them into one.

* We concatenate them on axis 0,as they only have one axis.


```python
import numpy as np
prediction = np.array(predictions)
prediction.shape
```




    (3, 297)




```python
predictions = np.concatenate(prediction,axis=0)
# print(predictions.size)
# Map predictions to outcomes(only possible outcomes are 1 and 0)
predictions[predictions>0.5] = 1
predictions[predictions<=0.5] = 0
accuracy = sum(predictions == train_line_final["Survived"]) / len(predictions)
print ("准确率为: ", accuracy)
# predictions
```

    准确率为:  0.7845117845117845
    

## 逻辑回归算法


```python
from sklearn import model_selection
#逻辑回归
from sklearn.linear_model import LogisticRegression 
```


```python
# 训练模型
LR = LogisticRegression()
LR.fit(train_line_final[vctors],train_line_final['Survived'])
```




    LogisticRegression(C=1.0, class_weight=None, dual=False, fit_intercept=True,
              intercept_scaling=1, max_iter=100, multi_class='ovr', n_jobs=1,
              penalty='l2', random_state=None, solver='liblinear', tol=0.0001,
              verbose=0, warm_start=False)



### 模型验证


```python
test_data = test_set
test_data = pd.concat([test_data,dum_sex],axis=1)
test_data.drop(['Sex'],axis=1)

test_data['Age'] = test_data['Age'].fillna(test_data['Age'].median())
test_data[vctors].info()
# lr_predictions = LR.predict(test_data[vctors])
```

    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 891 entries, 0 to 890
    Data columns (total 7 columns):
    Pclass        418 non-null float64
    Sex_female    891 non-null uint8
    Sex_male      891 non-null uint8
    Age           891 non-null float64
    SibSp         418 non-null float64
    Parch         418 non-null float64
    Fare          417 non-null float64
    dtypes: float64(5), uint8(2)
    memory usage: 36.6 KB
    


```python
# 使用sklearn库里面的交叉验证函数获取预测准确率分数
scores = model_selection.cross_val_score(LR,train_line_final[vctors],train_line_final["Survived"],cv=2)
#使用交叉验证分数的平均值作为最终的准确率
print(scores)
print("准确率为: ",scores.mean())
```

    [0.79820628 0.78426966]
    准确率为:  0.791237970474127
    

## 增加特征Embarked列，查看对预测的影响


```python
vctors
```




    ['Pclass', 'Sex_female', 'Sex_male', 'Age', 'SibSp', 'Parch', 'Fare']




```python
#缺失值用最多的S进行填充
train_line_final["Embarked"] = train_line_final["Embarked"].fillna('S') 
#地点用0,1,2
train_line_final.loc[train_line_final["Embarked"] == "S","Embarked"] = 0    
train_line_final.loc[train_line_final["Embarked"] == "C","Embarked"] = 1
train_line_final.loc[train_line_final["Embarked"] == "Q","Embarked"] = 2
train_line_final['Embarked'].value_counts()
```




    0    646
    1    168
    2     77
    Name: Embarked, dtype: int64




```python
dum_embarked = pd.get_dummies(train_line_final['Embarked'],prefix='Embarked')
```


```python
dum_embarked.head(3)
dum_embarked.columns
train_line_final = pd.concat([train_line_final,dum_embarked],axis=1)
```


```python
vctors_uppdate = vctors+['Embarked_C', 'Embarked_Q', 'Embarked_S']
vctors_uppdate
vctors_uppdate_1 = vctors + ['Embarked']
```


```python
# 训练模型
LR1 = LogisticRegression()
LR1.fit(train_line_final[vctors_uppdate_1],train_line_final['Survived'])
```




    LogisticRegression(C=1.0, class_weight=None, dual=False, fit_intercept=True,
              intercept_scaling=1, max_iter=100, multi_class='ovr', n_jobs=1,
              penalty='l2', random_state=None, solver='liblinear', tol=0.0001,
              verbose=0, warm_start=False)



### 验证更新后的模型


```python
# 使用sklearn库里面的交叉验证函数获取预测准确率分数
scores = model_selection.cross_val_score(LR,train_line_final[vctors_uppdate_1],train_line_final["Survived"],cv=2)
#使用交叉验证分数的平均值作为最终的准确率
print(scores)
print("准确率为: ",scores.mean())
```

    [0.80044843 0.78651685]
    准确率为:  0.7934826422129289
    

通过增加特征，模型的准确率提高到79.34%，说明好的特征有利于提升模型的预测能力。

## 随机森林算法


```python
from sklearn import model_selection
from sklearn.ensemble import RandomForestClassifier
```


```python
vctors_tree = vctors_uppdate_1
```


```python
#10棵决策树，停止的条件：样本个数为2，叶子节点个数为1
alg=RandomForestClassifier(random_state=1,n_estimators=10,min_samples_split=2,min_samples_leaf=1) 

# Compute the accuracy score for all the cross validation folds.  (much simpler than what we did before!)
# kf=cross_validation.KFold(train_line_final.shape[0],n_folds=3,random_state=1)
kf=model_selection.KFold(n_splits=3,shuffle=False, random_state=1)

scores=model_selection.cross_val_score(alg,train_line_final[vctors_tree],train_line_final["Survived"],cv=kf)
print(scores)
#Take the mean of the scores (because we have one for each fold)
scores.mean()
```

    [0.78787879 0.8013468  0.79461279]
    




    0.7946127946127945



增加决策树到30棵


```python
alg2 = RandomForestClassifier(random_state=1,n_estimators=30,min_samples_split=2,min_samples_leaf=1)
kf=model_selection.KFold(n_splits=10,shuffle=False, random_state=1)
scores=model_selection.cross_val_score(alg2,train_line_final[vctors_tree],train_line_final["Survived"],cv=kf)
print(scores)
#Take the mean of the scores (because we have one for each fold)
scores.mean()
```

    [0.75555556 0.78651685 0.7752809  0.80898876 0.85393258 0.79775281
     0.7752809  0.78651685 0.80898876 0.87640449]
    




    0.802521847690387


