
# Titanic Advanced Analysis
![image.png](attachment:image.png)

## EDA


```python
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import warnings
import seaborn as sns
warnings.filterwarnings('ignore')

plt.rcParams['font.sans-serif']=['SimHei'] #正常显示中文标签
plt.rcParams['axes.unicode_minus']=False #正常显示中文符号
%config InlineBackend.figure_format = 'retina'
# 数据print精度
pd.set_option('precision',3) 
%matplotlib inline
#绘图工具
sns.set_style('darkgrid')
```

### 原始数据集


```python
train_set = pd.read_csv('D:\\Workspace\\Python\\datasets\\train.csv',sep=',')
test_set = pd.read_csv('D:\Workspace\Python\datasets\\test.csv',sep=',')
```


```python
train_set.tail(5)
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
      <th>886</th>
      <td>887</td>
      <td>0</td>
      <td>2</td>
      <td>Montvila, Rev. Juozas</td>
      <td>male</td>
      <td>27.0</td>
      <td>0</td>
      <td>0</td>
      <td>211536</td>
      <td>13.00</td>
      <td>NaN</td>
      <td>S</td>
    </tr>
    <tr>
      <th>887</th>
      <td>888</td>
      <td>1</td>
      <td>1</td>
      <td>Graham, Miss. Margaret Edith</td>
      <td>female</td>
      <td>19.0</td>
      <td>0</td>
      <td>0</td>
      <td>112053</td>
      <td>30.00</td>
      <td>B42</td>
      <td>S</td>
    </tr>
    <tr>
      <th>888</th>
      <td>889</td>
      <td>0</td>
      <td>3</td>
      <td>Johnston, Miss. Catherine Helen "Carrie"</td>
      <td>female</td>
      <td>NaN</td>
      <td>1</td>
      <td>2</td>
      <td>W./C. 6607</td>
      <td>23.45</td>
      <td>NaN</td>
      <td>S</td>
    </tr>
    <tr>
      <th>889</th>
      <td>890</td>
      <td>1</td>
      <td>1</td>
      <td>Behr, Mr. Karl Howell</td>
      <td>male</td>
      <td>26.0</td>
      <td>0</td>
      <td>0</td>
      <td>111369</td>
      <td>30.00</td>
      <td>C148</td>
      <td>C</td>
    </tr>
    <tr>
      <th>890</th>
      <td>891</td>
      <td>0</td>
      <td>3</td>
      <td>Dooley, Mr. Patrick</td>
      <td>male</td>
      <td>32.0</td>
      <td>0</td>
      <td>0</td>
      <td>370376</td>
      <td>7.75</td>
      <td>NaN</td>
      <td>Q</td>
    </tr>
  </tbody>
</table>
</div>




```python
train_set.info()
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
      <td>7.829</td>
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
      <td>7.000</td>
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
      <td>9.688</td>
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
      <td>8.662</td>
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
      <td>12.287</td>
      <td>NaN</td>
      <td>S</td>
    </tr>
  </tbody>
</table>
</div>




```python
test_set.info()
```

    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 418 entries, 0 to 417
    Data columns (total 11 columns):
    PassengerId    418 non-null int64
    Pclass         418 non-null int64
    Name           418 non-null object
    Sex            418 non-null object
    Age            332 non-null float64
    SibSp          418 non-null int64
    Parch          418 non-null int64
    Ticket         418 non-null object
    Fare           417 non-null float64
    Cabin          91 non-null object
    Embarked       418 non-null object
    dtypes: float64(2), int64(4), object(5)
    memory usage: 36.0+ KB
    

从上面的数据info中可以看出，Age、Fare、Cabin、Embarked数据有缺失。


```python
train_set['Survived'].value_counts().plot.pie(
    labeldistance = 1.1,
    autopct = '%1.2f%%',
    shadow = False,
    startangle = 90,
    pctdistance = 0.6)
plt.show()
#labeldistance，文本的位置离远点有多远，1.1指1.1倍半径的位置
#autopct，圆里面的文本格式，%3.1f%%表示小数有三位，整数有一位的浮点数
#shadow，饼是否有阴影
#startangle，起始角度，0，表示从0开始逆时针转，为第一块。一般选择从90度开始比较好看
#pctdistance，百分比的text离圆心的距离
#patches, l_texts, p_texts，为了得到饼图的返回值，p_texts饼图内部文本的，l_texts饼图外label的文本
```


![png](output_10_0.png)


### 缺失值处理


```python
train_data = train_set
test_data = test_set
```

对数据进行分析的时候要注意其中是否有缺失值。一些机器学习算法能够处理缺失值，比如神经网络，一些则不能。
对于缺失值，一般有以下几种处理方法:
- 如果数据集很多，但有很少的缺失值，可以删掉带缺失值的行；
- 如果该属性相对学习来说不是很重要，可以对缺失值赋均值或者众数。
- 对于标称属性，可以赋一个代表缺失的值，比如‘U0’。因为缺失本身也可能代表着一些隐含信息。比如船舱号Cabin这一属性，缺失可能代表并没有船舱。

比如在哪儿上船Embarked这一属性（共有三个上船地点），缺失俩值，可以用众数赋值


```python
# train_data.Pclass.value_counts().sort_index()
# train_data.Embarked[train_data['Embarked'].isnull()] = train_data['Embarked'].notnull().dropna().mode().values
train_data.Embarked[train_data.Embarked.isnull()] = train_data.Embarked.dropna().mode().values
```


```python
# train_data.Cabin[train_data['Cabin'].isnull()] = 'U0'
train_data.Cabin = train_data.Cabin.fillna('U0')
```

使用回归 随机森林等模型来预测缺失属性的值。

因为Age在该数据集里是一个相当重要的特征（先对Age进行分析即可得知），所以保证一定的缺失值填充准确率是非常重要的，对结果也会产生较大影响。

一般情况下，会使用数据完整的条目作为模型的训练集，以此来预测缺失值。对于当前的这个数据，可以使用随机森林来预测也可以使用线性回归预测。这里使用随机森林预测模型，选取数据集中的数值属性作为特征（因为sklearn的模型只能处理数值属性，所以这里先仅选取数值特征，但在实际的应用中需要将非数值特征转换为数值特征）


```python
from sklearn.ensemble import RandomForestRegressor
age_df = train_data[['Age','Survived','Fare', 'Parch', 'SibSp', 'Pclass']]
age_notnull = age_df[age_df.Age.notnull()]
age_isnull = age_df[age_df.Age.isnull()]
rfc = RandomForestRegressor(n_estimators=1000,n_jobs=10)
age_notnull_X = age_notnull.values[:,1:]
age_notnull_Y = age_notnull.values[:,0]
rfc.fit(age_notnull_X,age_notnull_Y)
```




    RandomForestRegressor(bootstrap=True, criterion='mse', max_depth=None,
               max_features='auto', max_leaf_nodes=None,
               min_impurity_decrease=0.0, min_impurity_split=None,
               min_samples_leaf=1, min_samples_split=2,
               min_weight_fraction_leaf=0.0, n_estimators=1000, n_jobs=10,
               oob_score=False, random_state=None, verbose=0, warm_start=False)




```python
predicts_age = rfc.predict(age_isnull.values[:,1:])
# age_isnull
predicts_age.shape
```




    (177,)




```python
train_data.loc[train_data.Age.isnull(),['Age']] = predicts_age 
```


```python
train_data.info()
```

    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 891 entries, 0 to 890
    Data columns (total 12 columns):
    PassengerId    891 non-null int64
    Survived       891 non-null int64
    Pclass         891 non-null int64
    Name           891 non-null object
    Sex            891 non-null object
    Age            891 non-null float64
    SibSp          891 non-null int64
    Parch          891 non-null int64
    Ticket         891 non-null object
    Fare           891 non-null float64
    Cabin          891 non-null object
    Embarked       891 non-null object
    dtypes: float64(2), int64(5), object(5)
    memory usage: 83.6+ KB
    

> 运用同样的方法，填充测试数据集


```python
test_data.Cabin = test_data.Cabin.fillna('U0')
```


```python
test_data.Fare = test_data.Fare.fillna(test_data.Fare.notnull().mean())
```


```python
age_df = test_data[['Age','Fare', 'Parch', 'SibSp', 'Pclass']]
age_isnull = age_df[age_df.Age.isnull()]
age_isnull_X = age_isnull.values[:,1:]
# predicts_age = rfc.predict(age_isnull_X)
# test_data.loc[test_data.Age.isnull(),['Age']] = predicts_age
```

### 性别（Sex）与Survived的关系


```python
train_data[train_data.Survived == 1].Sex.value_counts().plot.pie(startangle=90)
plt.show()
```


![png](output_26_0.png)



```python
train_data.groupby(['Sex','Survived']).count()
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
      <th></th>
      <th>PassengerId</th>
      <th>Pclass</th>
      <th>Name</th>
      <th>Age</th>
      <th>SibSp</th>
      <th>Parch</th>
      <th>Ticket</th>
      <th>Fare</th>
      <th>Cabin</th>
      <th>Embarked</th>
    </tr>
    <tr>
      <th>Sex</th>
      <th>Survived</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th rowspan="2" valign="top">female</th>
      <th>0</th>
      <td>81</td>
      <td>81</td>
      <td>81</td>
      <td>81</td>
      <td>81</td>
      <td>81</td>
      <td>81</td>
      <td>81</td>
      <td>81</td>
      <td>81</td>
    </tr>
    <tr>
      <th>1</th>
      <td>233</td>
      <td>233</td>
      <td>233</td>
      <td>233</td>
      <td>233</td>
      <td>233</td>
      <td>233</td>
      <td>233</td>
      <td>233</td>
      <td>233</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">male</th>
      <th>0</th>
      <td>468</td>
      <td>468</td>
      <td>468</td>
      <td>468</td>
      <td>468</td>
      <td>468</td>
      <td>468</td>
      <td>468</td>
      <td>468</td>
      <td>468</td>
    </tr>
    <tr>
      <th>1</th>
      <td>109</td>
      <td>109</td>
      <td>109</td>
      <td>109</td>
      <td>109</td>
      <td>109</td>
      <td>109</td>
      <td>109</td>
      <td>109</td>
      <td>109</td>
    </tr>
  </tbody>
</table>
</div>




```python
train_data.Survived.shape
```




    (891,)




```python
train_data[['Sex','Survived']].groupby('Sex').mean().plot.bar()
plt.show()
```


![png](output_29_0.png)


**从上图可以很明显的得到，female在施救过程中会获得更多的Survived机会**

### 船舱等级（Pclass）与Survived的关系


```python
train_data.groupby(['Pclass','Survived']).count()
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
      <th></th>
      <th>PassengerId</th>
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
    <tr>
      <th>Pclass</th>
      <th>Survived</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th rowspan="2" valign="top">1</th>
      <th>0</th>
      <td>80</td>
      <td>80</td>
      <td>80</td>
      <td>80</td>
      <td>80</td>
      <td>80</td>
      <td>80</td>
      <td>80</td>
      <td>80</td>
      <td>80</td>
    </tr>
    <tr>
      <th>1</th>
      <td>136</td>
      <td>136</td>
      <td>136</td>
      <td>136</td>
      <td>136</td>
      <td>136</td>
      <td>136</td>
      <td>136</td>
      <td>136</td>
      <td>136</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">2</th>
      <th>0</th>
      <td>97</td>
      <td>97</td>
      <td>97</td>
      <td>97</td>
      <td>97</td>
      <td>97</td>
      <td>97</td>
      <td>97</td>
      <td>97</td>
      <td>97</td>
    </tr>
    <tr>
      <th>1</th>
      <td>87</td>
      <td>87</td>
      <td>87</td>
      <td>87</td>
      <td>87</td>
      <td>87</td>
      <td>87</td>
      <td>87</td>
      <td>87</td>
      <td>87</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">3</th>
      <th>0</th>
      <td>372</td>
      <td>372</td>
      <td>372</td>
      <td>372</td>
      <td>372</td>
      <td>372</td>
      <td>372</td>
      <td>372</td>
      <td>372</td>
      <td>372</td>
    </tr>
    <tr>
      <th>1</th>
      <td>119</td>
      <td>119</td>
      <td>119</td>
      <td>119</td>
      <td>119</td>
      <td>119</td>
      <td>119</td>
      <td>119</td>
      <td>119</td>
      <td>119</td>
    </tr>
  </tbody>
</table>
</div>



各舱级的存活率


```python
train_data[['Pclass','Survived']].groupby('Pclass').mean().plot.bar()
plt.show()
```


![png](output_34_0.png)


各舱级男女乘客存活情况


```python
# plt.figure(figsize=(30,5))
train_data[['Pclass','Sex','Survived']].groupby(['Pclass','Sex']).mean().plot.bar(
    facecolor = 'yellowgreen', 
    edgecolor = 'white', 
    label='second')
plt.show()
```


![png](output_36_0.png)


**总体上看，获救计划中Ladis frist，then 不同的舱级获救几率是不一样的，1舱最高，3舱最低**

### 年龄（Age）与Survived的关系


```python
train_data[['Age','Survived']].groupby('Survived').mean()
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
      <th>Age</th>
    </tr>
    <tr>
      <th>Survived</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>30.613</td>
    </tr>
    <tr>
      <th>1</th>
      <td>28.143</td>
    </tr>
  </tbody>
</table>
</div>




```python
train_data.Age.describe()
```




    count    891.000
    mean      29.665
    std       13.745
    min        0.420
    25%       21.000
    50%       28.000
    75%       37.000
    max       80.000
    Name: Age, dtype: float64



>训练样本有891个，平均年龄约为30岁，标准差13.5岁，最小年龄0.42，最大年龄80.

#### 乘客年龄的整体分布


```python
fig = plt.figure(figsize=(20,5))
plt.subplot(121)
plt.xlabel('Age')
plt.ylabel('cnt')
plt.hist(train_data.Age,bins=100,facecolor='orange')

plt.subplot(122)
plt.ylabel('Age')
# plt.boxplot(train_data.Age)
# train_data[train_data['Survived'] == 1].Age.plot.box(showfliers=False)
train_data.Age.plot.box(showfliers=False)

plt.show()
```


![png](output_43_0.png)


#### 船舱等级、年龄和性别、年龄与存活之间的关系


```python
fig,ax = plt.subplots(1,2, figsize = (20,5))
ax[0].set_yticks(range(0,110,10))
sns.violinplot("Pclass","Age",hue="Survived",data=train_data,split=True,ax=ax[0])
ax[0].set_title('Pclass and Age vs Survived') 

ax[1].set_yticks(range(0,110,10))
sns.violinplot("Sex",'Age',hue='Survived',data=train_data,split=True,ax=ax[1])
ax[1].set_title('Sex and Age vs Survived')
plt.show()
```


![png](output_45_0.png)


#### 不同年龄下生还和死亡的对比


```python
fact = sns.FacetGrid(train_data,hue='Survived',aspect=5)
fact.map(sns.kdeplot,'Age',shade=True)
fact.set(xlim=(0,train_data['Age'].max()))
fact.add_legend()

plt.show()
```


![png](output_47_0.png)


#### 不同年龄段下的存活率

**average survived passengers by age**


```python
sns.set_style("darkgrid")
fig,ax = plt.subplots(1,1,figsize=(20,5))
train_data['Age_int'] = train_data['Age'].values.astype(int)
age_average = train_data[['Age_int','Survived']].groupby('Age_int',as_index=False).mean()
sns.barplot(x='Age_int',y='Survived',data=age_average)
sns.pointplot(
    x='Age_int',
    y='Survived',
    data=age_average,
    join=True,
    color="#a11d64")
plt.show()
```


![png](output_49_0.png)


#### 按照年龄，将乘客根据年龄分组
- 儿童、
- （青）少年、
- 成年、
- 老年

分析四个群体的生还情况


```python
plt.figure(figsize=(10,5))
bins = [0, 12, 18, 65, 100]
train_data['Age_group'] = pd.cut(train_data.Age,bins)
# by_age = train_data[['Survived','Age_group']].groupby('Age_group').mean()
by_age = train_data.groupby('Age_group')['Survived'].mean()
by_age.plot(kind='bar')
plt.ylabel('Survival Rate ')
plt.show()
```


![png](output_51_0.png)


### 称谓（Name）与Survived的关系

通过观察名字数据，我们可以看出其中包括对乘客的称呼

如：Mr、Miss、Mrs等，称呼信息包含了乘客的年龄、性别，同时也包含了入社会地位等的称呼

如：Dr，Lady，Major（少校），Master（硕士，主人，师傅）等的称呼


```python
train_data['Name'].head(5).value_counts()
```




    Allen, Mr. William Henry                               1
    Futrelle, Mrs. Jacques Heath (Lily May Peel)           1
    Braund, Mr. Owen Harris                                1
    Heikkinen, Miss. Laina                                 1
    Cumings, Mrs. John Bradley (Florence Briggs Thayer)    1
    Name: Name, dtype: int64



#### 对Name字段分词分析


```python
Frist_name = train_data['Name'].str.split(',',expand=True)[0]
tmp_name = train_data['Name'].str.split('.',expand=True)[0]
title = tmp_name.str.split(',',expand=True)[1]
Secend_name = train_data['Name'].str.split('.',expand=True)[1]

train_data['Frist_name'] = Frist_name
train_data['title'] = title
train_data['Secend_name'] = Secend_name
```


```python
plt.figure(figsize=(20,5))
title_avg = train_data.groupby(['title'])['Survived'].mean()
title_avg.plot(kind='bar')
plt.ylabel('Survival Rate')
plt.show()
```


![png](output_56_0.png)


#### 不同的称谓与生存率的关系


```python
plt.subplots(1,1,figsize=(20,5))
ti = train_data['Name'].str.extract('([A-Za-z]+)\.',expand=False)
train_data['Title'] = ti
pd.crosstab(train_data['Title'],train_data['Sex'])
Title_avg = train_data[['Title','Survived']].groupby(['Title'],as_index=False).mean()
sns.barplot(x='Title',y='Survived',data=Title_avg)
plt.show()
```


![png](output_58_0.png)


#### 观察Name长度和Survived rate之间是否有关系


```python
plt.subplots(1,1,figsize=(20,5))
train_data['Name_length'] = train_data['Name'].apply(len)
# name_lengthgth = train_data[['Name_length','Survived']].groupby(['Name_length'], as_index=False).mean()
name_length_avg = train_data.groupby(['Name_length'],as_index=False)['Survived'].mean()
sns.barplot(x='Name_length', y='Survived',data=name_length_avg)
plt.show()
```


![png](output_60_0.png)


>***Name的长度和Survival rate之间存在一定的正向相关性***

### 有无兄弟姐妹(SibSp)与Survived的关系


```python
train_data['SibSp'].value_counts()
# train_data.groupby(['SibSp'])['Survived'].mean()
```




    0    608
    1    209
    2     28
    4     18
    3     16
    8      7
    5      5
    Name: SibSp, dtype: int64



#### 将数据分为有兄弟姐妹和没有兄弟姐妹


```python
sibsp_df = train_data[train_data['SibSp'] != 0]
no_sibsp_df = train_data[train_data['SibSp'] == 0]
plt.figure(figsize=(20,9))

plt.subplot(121)
sibsp_df['Survived'].value_counts().plot.pie(
#     labels=['No Survived','Survived'],
    autopct= '%1.2f%%',
    startangle=90)
plt.xlabel('sibsp')

plt.subplot(122)
no_sibsp_df['Survived'].value_counts().plot.pie(
#     labels=['No Survived','Survived'],
    autopct= '%1.2f%%',
    startangle=90)
plt.xlabel('no_sibsp')
 
plt.show()
```


![png](output_65_0.png)


#### 增加新变量：是否有兄弟姐妹


```python
def if_SibSp(x):
    if x == 0:
        return 0
    else:
        return 1
```


```python
IF_SibSp = train_data['SibSp'].apply(if_SibSp)
train_data['IF_SibSp'] = IF_SibSp
```


```python
SibSp_avg = train_data[['IF_SibSp','Survived']].groupby('IF_SibSp',as_index=False).mean()
sns.barplot(x='IF_SibSp',y='Survived',data=SibSp_avg)
plt.show()
```


![png](output_69_0.png)


### 有无父母子女(Parch)与Survived的关系分析

#### 将数据分为有父母子女和无父母子女两组


```python
Parch_df = train_data[train_data.Parch != 0]
no_Parch_df = train_data[train_data.Parch == 0]

fig = plt.figure(figsize=(20,9))
plt.subplot(121)
plt.xlabel('Parch')
# sns.distplot())
Parch_df['Survived'].value_counts().sort_index().plot.pie(
#     labels=['No Survived','Survived'],
    autopct= '%1.2f%%',
    startangle=90)
# plt.show()

plt.subplot(122)
no_Parch_df['Survived'].value_counts().sort_index().plot.pie(
    autopct= '%1.2f%%',
    startangle=90)
plt.xlabel('no Parch')
```




    Text(0.5,0,'no Parch')




![png](output_72_1.png)


>**从上面可以看出，有父母子女的人群存活率更高一些**

#### 亲友的人数和存活与否的关系 SibSp & Parch


```python
fig, ax=plt.subplots(1,2,figsize=(18,5))
train_data[['Parch','Survived']].groupby(['Parch']).mean().plot.bar(ax=ax[0])
ax[0].set_title('Parch and Survival rate')

train_data[['SibSp','Survived']].groupby(['SibSp']).mean().plot.bar(ax=ax[1])
ax[1].set_title('SibSp and Survival rate')

plt.show()
```


![png](output_75_0.png)



```python
train_data['Family_size'] = train_data.Parch + train_data.SibSp + 1
```


```python
train_data[['Family_size','Survived']].groupby(['Family_size']).mean().plot(kind='bar')
plt.show()
```


![png](output_77_0.png)


### 票价(Fare)与Survived的关系


```python
plt.figure(figsize=(10,5))
train_data[['Fare']].hist(bins=100)
plt.show()
```


    <Figure size 720x360 with 0 Axes>



![png](output_79_1.png)



```python
fig, ax=plt.subplots(1,2,figsize=(18,5))
train_data[['Fare','Survived']].boxplot(column='Fare',by='Survived',ax=ax[0],showfliers=False)
train_data[['Fare','Pclass']].boxplot(column='Fare',by='Pclass',ax=ax[1],showfliers=False)
plt.show()
```


![png](output_80_0.png)


#### 绘制生存与否与票价均值和方差的关系


```python
fare_not_survived = train_data['Fare'][train_data['Survived'] == 0]
fare_survived = train_data['Fare'][train_data['Survived'] == 1]
 
average_fare = pd.DataFrame([fare_not_survived.mean(),fare_survived.mean()])
std_fare = pd.DataFrame([fare_not_survived.std(),fare_survived.std()])
average_fare.plot(yerr=std_fare,kind='bar',legend=False)
 
plt.show()
```


![png](output_82_0.png)


>由上图表可知，票价与是否生还有一定的相关性，生还者的平均票价要大于未生还者的平均票价。

### 船舱类型(Cabin)与Survived的关系

由于船舱的缺失值确实太多，有效值仅仅有204个，很难分析出不同的船舱和存活的关系，所以在做特征工程的时候，可以直接将该组特征丢弃掉。 

当然，这里我们也可以对其进行一下分析，对于缺失的数据都分为一类。

简单地将数据分为是否有Cabin记录作为特征，与生存与否进行分析：


```python
train_data['Has_Cabin'] = train_data['Cabin'].apply(lambda x: 0 if x == 'U0' else 1)
train_data[['Has_Cabin','Survived']].groupby(['Has_Cabin']).mean().plot.bar()
plt.show()
```


![png](output_86_0.png)



```python
import re
# create feature for the alphabetical part of the cabin number
train_data['CabinLetter'] = train_data['Cabin'].map(lambda x: re.compile("([a-zA-Z]+)").search(x).group())
# convert the distinct cabin letters with incremental integer values
train_data['CabinLetter'] = pd.factorize(train_data['CabinLetter'])[0]
train_data[['CabinLetter','Survived']].groupby(['CabinLetter']).mean().plot.bar()
plt.show()
```


![png](output_87_0.png)


>船舱类型和survival之间的关联不强

### 上船港口(Embarked)与Survived的关系

>背景：泰坦尼克号从英国的南安普顿港出发，途径法国瑟堡和爱尔兰昆士敦，那么在昆士敦之前上船的人，有可能在瑟堡或昆士敦下船，这些人将不会遇到海难。


```python
train_data.Embarked.value_counts()
```




    S    646
    C    168
    Q     77
    Name: Embarked, dtype: int64




```python
fig,ax3 = plt.subplots(1,2,figsize=(20,6))
Embarked_avg =  train_data[['Embarked','Survived']].groupby(['Embarked']).mean()
Embarked_avg.sort_index().plot(kind='bar',ax=ax3[0])
plt.title('Embarked、Sex and Survived')

sns.countplot(x='Embarked',
              hue='Survived',
              data=train_data[['Embarked','Survived']].sort_values('Embarked'),
              ax=ax3[1])
plt.title('Embarked and Survived')
plt.show()
```


![png](output_92_0.png)



```python
sns.factorplot('Embarked','Survived',data = train_data , size=3, aspect=4)
plt.title('Embarked and Survived rate')
plt.show()
```


![png](output_93_0.png)


由上可以看出，在不同的港口上船，生还率不同，C最高，Q次之，S最低。

以上为所给出的数据特征与生还与否的分析。 

据了解，泰坦尼克号上共有2224名乘客。本训练数据只给出了891名乘客的信息，如果该数据集是从总共的2224人随机选出的，根据中心极限定理，该样本的数据量也足够大，那么我们的分析结果就具有代表性.

### summary

*对于数据集中没有给出的特征信息，我们还可以联想其他可能会对模型产生影响的特征因素。如：乘客的国籍、乘客的身高、乘客的体重、乘客是否会游泳、乘客职业等等*

*另外还有数据集中没有分析的几个特征：Ticket（船票号）、Cabin（船舱号），这些因素的不同可能会影响乘客在船中的位置从而影响逃生的顺序。但是船舱号数据缺失，船票号类别大，难以分析规律，所以在后期模型融合的时候，将这些因素交由模型来决定其重要性*

## 变量转换

变量转换的目的是将数据转换为适用于模型使用的数据，不同模型接受不同类型的数据，Scikit-learn要求数据都是数字型numeric，所以我们要将一些非数字型的原始数据转换为数字型numeric，以在进行特征工程的时候使用。 所有的数据可以分为两类：

1. 定性（Qualitative）变量可以以某种方式，Age就是一个很好的例子。
2. 定量（Quantitative）变量描述了物体的某一（不能被数学表示的）方面，Embarked就是一个例子。

### 定性变量（Qualitative）转换

#### Dummy Variables

就是类别变量或者二元变量，当qualitative variable是一些频繁出现的几个独立变量时，Dummy Variables比较适用。

我们以Embarked只包含三个值’S'，‘C'，’Q'，我们可以使用下面的代码将其转换为dummies


```python
Embarked_dummies = pd.get_dummies(train_data['Embarked'],prefix='Embarked')
train_data = pd.concat([train_data,Embarked_dummies],axis=1)
```


```python
# train_data.drop(['Embarked'],axis=1, inplace=True)
train_data.head(3)
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
      <th>...</th>
      <th>Secend_name</th>
      <th>Title</th>
      <th>Name_length</th>
      <th>IF_SibSp</th>
      <th>Family_size</th>
      <th>Has_Cabin</th>
      <th>CabinLetter</th>
      <th>Embarked_C</th>
      <th>Embarked_Q</th>
      <th>Embarked_S</th>
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
      <td>7.250</td>
      <td>...</td>
      <td>Owen Harris</td>
      <td>Mr</td>
      <td>23</td>
      <td>1</td>
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
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
      <td>71.283</td>
      <td>...</td>
      <td>John Bradley (Florence Briggs Thayer)</td>
      <td>Mrs</td>
      <td>51</td>
      <td>1</td>
      <td>2</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
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
      <td>7.925</td>
      <td>...</td>
      <td>Laina</td>
      <td>Miss</td>
      <td>22</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
    </tr>
  </tbody>
</table>
<p>3 rows × 26 columns</p>
</div>




```python
# embark_dummies = pd.get_dummies(train_data['Embarked'],prefix='Embarked')
# train_data = train_data.join(embark_dummies)
# train_data.drop(['Embarked_S','Embarked_C','Embarked_Q'], axis=1, inplace=True)
# embark_dummies = train_data[['Embarked_S','Embarked_C','Embarked_Q']]
# embark_dummies.head()
```

#### Factoring

dummy不好处理Cabin（船舱号）这种标称属性，因为他出现的变量比较多。所以Pandas有一个方法叫做factorize()，它可以创建一些数字，来表示类别变量，对每一个类别映射一个ID，这种映射最后只生成一个特征，不像dummy那样生成多个特征


```python
# Replace missing values with "U0"
train_data['Cabin'][train_data.Cabin.isnull()] = 'U0'
# create feature for the alphabetical part of the cabin number
train_data['CabinLetter'] = train_data['Cabin'].map(lambda x: re.compile("([a-zA-Z]+)").search(x).group())
# convert the distinct cabin letters with incremental integer values
train_data['CabinLetter'] = pd.factorize(train_data['CabinLetter'])[0]
```


```python
# tmp = train_set
# tmp.Cabin[tmp.Cabin.isnull()] = 'U0'
# tmp_CabinLetter = tmp.Cabin.map(lambda x: re.compile("([a-zA-Z]+)").search(x).group())
# tmp.CabinLetter.value_counts()
```

### 定量变量（Quantitative）转换

#### Scaling

Scaling可以将一个很大范围的数值映射到一个很小范围（通常是 -1到1，或者是0到1），很多情况下我们需要将数值做Scaling使其范围大小一样，否则大范围数特征将会有更高的权重。比如：Age的范围可能只是0-100，而income的范围可能是0-10000000，在某些对数组大小敏感的模型中会影响其结果


```python
from sklearn import preprocessing
# 校验数据长度
assert np.size(train_data['Age']) == 891
scaler = preprocessing.StandardScaler()
val = scaler.fit_transform(train_data['Age'].values.reshape(-1,1))
train_data['Age_scaled'] = val
```

#### Binning

Binning通过观察“邻居”（即周围的值）将连续数据离散化。存储的值被分布到一些“桶”或“箱”中，就像直方图的bin将数据划分成几块一样。

下面的代码对Fare进行Binning


```python
tmp = pd.qcut(train_data.Fare,5)
train_data['Fare_bin'] = tmp
```

**在将数据Binning化后，要么将数据factorize化，要么dummies化。**


```python
# facorize
val = pd.factorize(train_data['Fare_bin'])
train_data['Fare_bin_id'] = val[0]
```


```python
# dummies
val = pd.get_dummies(train_data['Fare_bin'],prefix='Fare')
# fare_bin_dummies_df = pd.get_dummies(train_data['Fare_bin']).rename(columns=lambda x: 'Fare_' + str(x))
train_data = pd.concat([train_data,val],axis=1)
```


```python
train_data.shape
```




    (891, 34)




```python
train_data.head(3)
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
      <th>...</th>
      <th>Embarked_Q</th>
      <th>Embarked_S</th>
      <th>Age_scaled</th>
      <th>Fare_bin</th>
      <th>Fare_bin_id</th>
      <th>Fare_(-0.001, 7.854]</th>
      <th>Fare_(7.854, 10.5]</th>
      <th>Fare_(10.5, 21.679]</th>
      <th>Fare_(21.679, 39.688]</th>
      <th>Fare_(39.688, 512.329]</th>
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
      <td>7.250</td>
      <td>...</td>
      <td>0</td>
      <td>1</td>
      <td>-0.558</td>
      <td>(-0.001, 7.854]</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
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
      <td>71.283</td>
      <td>...</td>
      <td>0</td>
      <td>0</td>
      <td>0.607</td>
      <td>(39.688, 512.329]</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
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
      <td>7.925</td>
      <td>...</td>
      <td>0</td>
      <td>1</td>
      <td>-0.267</td>
      <td>(7.854, 10.5]</td>
      <td>2</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
  </tbody>
</table>
<p>3 rows × 34 columns</p>
</div>



## 特征工程

在进行特征工程的时候，我们不仅需要对训练数据进行处理，还需要同时将测试数据同训练数据一起处理，使得二者具有相同的数据类型和数据分布


```python
train_set = pd.read_csv('D:\\Workspace\\Python\\datasets\\train.csv',sep=',')
test_set = pd.read_csv('D:\Workspace\Python\datasets\\test.csv',sep=',')
```


```python
train_df_org = train_set
test_df_org = test_set
test_df_org['Survived'] = 0
```

对数据进行特征工程，也就是从各项参数中提取出对输出结果有或大或小的影响的特征，将这些特征作为训练模型的依据。一般来说，我们会先从含有缺失值的特征开始。


```python
combined_train_test = train_df_org.append(test_df_org)
# 保留测试集的passageID
test_PassengerId = test_df_org['PassengerId']
```


```python
print(combined_train_test.info())
combined_train_test.describe()
```

    <class 'pandas.core.frame.DataFrame'>
    Int64Index: 1309 entries, 0 to 417
    Data columns (total 12 columns):
    Age            1046 non-null float64
    Cabin          295 non-null object
    Embarked       1307 non-null object
    Fare           1308 non-null float64
    Name           1309 non-null object
    Parch          1309 non-null int64
    PassengerId    1309 non-null int64
    Pclass         1309 non-null int64
    Sex            1309 non-null object
    SibSp          1309 non-null int64
    Survived       1309 non-null int64
    Ticket         1309 non-null object
    dtypes: float64(2), int64(5), object(5)
    memory usage: 132.9+ KB
    None
    




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
      <th>Age</th>
      <th>Fare</th>
      <th>Parch</th>
      <th>PassengerId</th>
      <th>Pclass</th>
      <th>SibSp</th>
      <th>Survived</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>count</th>
      <td>1046.000</td>
      <td>1308.000</td>
      <td>1309.000</td>
      <td>1309.00</td>
      <td>1309.000</td>
      <td>1309.000</td>
      <td>1309.000</td>
    </tr>
    <tr>
      <th>mean</th>
      <td>29.881</td>
      <td>33.295</td>
      <td>0.385</td>
      <td>655.00</td>
      <td>2.295</td>
      <td>0.499</td>
      <td>0.261</td>
    </tr>
    <tr>
      <th>std</th>
      <td>14.413</td>
      <td>51.759</td>
      <td>0.866</td>
      <td>378.02</td>
      <td>0.838</td>
      <td>1.042</td>
      <td>0.439</td>
    </tr>
    <tr>
      <th>min</th>
      <td>0.170</td>
      <td>0.000</td>
      <td>0.000</td>
      <td>1.00</td>
      <td>1.000</td>
      <td>0.000</td>
      <td>0.000</td>
    </tr>
    <tr>
      <th>25%</th>
      <td>21.000</td>
      <td>7.896</td>
      <td>0.000</td>
      <td>328.00</td>
      <td>2.000</td>
      <td>0.000</td>
      <td>0.000</td>
    </tr>
    <tr>
      <th>50%</th>
      <td>28.000</td>
      <td>14.454</td>
      <td>0.000</td>
      <td>655.00</td>
      <td>3.000</td>
      <td>0.000</td>
      <td>0.000</td>
    </tr>
    <tr>
      <th>75%</th>
      <td>39.000</td>
      <td>31.275</td>
      <td>0.000</td>
      <td>982.00</td>
      <td>3.000</td>
      <td>1.000</td>
      <td>1.000</td>
    </tr>
    <tr>
      <th>max</th>
      <td>80.000</td>
      <td>512.329</td>
      <td>9.000</td>
      <td>1309.00</td>
      <td>3.000</td>
      <td>8.000</td>
      <td>1.000</td>
    </tr>
  </tbody>
</table>
</div>



### Embarked

因为“Embarked”项的缺失值不多，所以这里我们以众数来填充.


```python
em_mode = combined_train_test.Embarked.mode()
combined_train_test['Embarked'].fillna(em_mode[0],inplace=True)
combined_train_test.Embarked.value_counts()
# em_mode[0]
```




    S    916
    C    270
    Q    123
    Name: Embarked, dtype: int64




```python
#为了后面的特征分析，这里我们将Embarked特征进行factorizing
combined_train_test['Embarked'] = pd.factorize(combined_train_test['Embarked'])[0]
#使用pd.get_dummies获取one-hot编码
emb_dummies_df = pd.get_dummies(combined_train_test['Embarked'],prefix=combined_train_test[['Embarked']].columns[0])
combined_train_test = pd.concat([combined_train_test, emb_dummies_df], axis=1)
emb_dummies_df.head()
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
      <th>Embarked_0</th>
      <th>Embarked_1</th>
      <th>Embarked_2</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>0</td>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>1</td>
      <td>0</td>
      <td>0</td>
    </tr>
  </tbody>
</table>
</div>



### Sex

Sex字段全部非空，对Sex进行one-hot编码，增加Sex_female,Sex_male特征


```python
# 对Sex字段进行factorizing
combined_train_test['Sex'] =pd.factorize(combined_train_test['Sex'])[0]
sex_dummies_df = pd.get_dummies(combined_train_test['Sex'],prefix='Sex')
combined_train_test = pd.concat([combined_train_test,sex_dummies_df],axis=1)
```


```python
print("the shape of :" + str(combined_train_test.shape) )
```

    the shape of :(1309, 17)
    

### Name

首先从名字中提取各种称呼.


```python
# what is each person's title?
combined_train_test['Title'] = combined_train_test['Name'].map(lambda x: re.compile(",(.*?)\.").findall(x)[0])
# 去掉字段中空格
combined_train_test['Title'] = combined_train_test['Title'].apply(lambda x:x.strip())
```

将称谓分类：Officer、Royalty、Mrs、Mr、Miss、Master


```python
title_Dict = {}
title_Dict.update(dict.fromkeys(['Capt','Col','Major','Dr','Rev'],'Officer'))
title_Dict.update(dict.fromkeys(['Dona','Sir','the Countess','Don','Lady'],'Royalty'))
title_Dict.update(dict.fromkeys(['Mme','Ms','Mrs'],'Mrs'))
title_Dict.update(dict.fromkeys(['Miss'],'Miss'))
title_Dict.update(dict.fromkeys(['Mr','Male','Mlle'],'Mr'))
title_Dict.update(dict.fromkeys(['Master','Jonkheer'],'Master'))
 
combined_train_test['Title'] = combined_train_test['Title'].map(title_Dict)
```

为了后面的特征分析，这里我们也将Title特征进行factorizing(0-1化)


```python
combined_train_test['title'] = pd.factorize(combined_train_test['Title'])[0]
combined_train_test.Title.value_counts()
```




    Mr         759
    Miss       260
    Mrs        200
    Master      62
    Officer     23
    Royalty      5
    Name: Title, dtype: int64



Dummiies Title(one hot编码)


```python
title_dummies_df = pd.get_dummies(combined_train_test['title'],prefix='title')
combined_train_test = pd.concat([combined_train_test,title_dummies_df],axis=1)
```


```python
combined_train_test['Name_length'] = combined_train_test['Name'].apply(len)
```


```python
combined_train_test.shape
```




    (1309, 47)



### Fare


```python
fare_avg = combined_train_test.groupby('Pclass').transform(np.mean)
# 下面transform将函数np.mean应用到各个group中,按照Pclass分组。
combined_train_test['Fare'] = combined_train_test[['Fare']].fillna(fare_avg)
```

通过对Ticket数据的分析，我们可以看到部分票号数据有重复，同时结合亲属人数及名字的数据，和票价船舱等级对比，我们可以知道购买的票中有家庭票和团体票，所以我们需要将团体票的票价分配到每个人的头上


```python
combined_train_test['Group_Ticket'] = combined_train_test['Fare'].groupby(by=combined_train_test['Ticket']).transform('count')
tmp = combined_train_test['Fare']/combined_train_test['Group_Ticket']
combined_train_test['Fare'] = tmp
combined_train_test.drop(['Group_Ticket'],axis=1,inplace=True)
```

使用binning给票价分等级(等频分组)


```python
combined_train_test['Fare_bin'] =  pd.qcut(combined_train_test['Fare'],5)
```


```python
# factorizing 因子分解
combined_train_test['Fare_bin_id'] = pd.factorize(combined_train_test['Fare_bin'])[0]
# dummy
fare_bin_dummies_df = pd.get_dummies(combined_train_test['Fare_bin_id'],prefix='Fare')
combined_train_test = pd.concat([combined_train_test,fare_bin_dummies_df],axis=1)
```


```python
combined_train_test.drop(['Fare_bin'],axis=1, inplace=True)
print("the shape of combined_train_test:")
print(str(combined_train_test.shape))
```

    the shape of combined_train_test:
    (1309, 31)
    

### Pclass

Pclass这一项，其实已经可以不用继续处理了，我们只需将其转换为dummy形式即可。 但是为了更好的分析，我们这里假设对于不同等级的船舱，各船舱内部的票价也说明了各等级舱的位置，那么也就很有可能与逃生的顺序有关系。所以这里分析出每等舱里的高价和低价位。


```python
combined_train_test['Fare'].groupby(by=combined_train_test['Pclass']).mean()
pclass_dummies_df = pd.get_dummies(combined_train_test['Pclass'],prefix='Pclass')
combined_train_test = pd.concat([combined_train_test,pclass_dummies_df],axis=1)
```


```python
pclass_dummies_df['Pclass_1'].value_counts()
```




    0    986
    1    323
    Name: Pclass_1, dtype: int64




```python
from sklearn.preprocessing import LabelEncoder
#建立Pclass Fare Category
def pclass_fare_category(df,pclass1_mean_fare,pclass2_mean_fare,pclass3_mean_fare):
    if df['Pclass'] == 1:
        if df['Fare'] <= pclass1_mean_fare:
            return 'Pclass1_Low'
        else:
            return 'Pclass1_High'
    elif df['Pclass'] == 2:
        if df['Fare'] <= pclass2_mean_fare:
            return 'Pclass2_Low'
        else:
            return 'Pclass2_High'
    elif df['Pclass'] == 3:
        if df['Fare'] <= pclass3_mean_fare:
            return 'Pclass3_Low'
        else:
            return 'Pclass3_High'
```


```python
Pclass1_mean_fare = combined_train_test.groupby(combined_train_test['Pclass']).mean()['Fare'].get(1)
Pclass2_mean_fare = combined_train_test.groupby(combined_train_test['Pclass']).mean()['Fare'].get(2)
Pclass3_mean_fare = combined_train_test['Fare'].groupby(by=combined_train_test['Pclass']).mean().get(3)

#建立Pclass_Fare Category
combined_train_test['Pclass_Fare_Category'] = combined_train_test.apply(
    pclass_fare_category,args=(Pclass1_mean_fare,Pclass2_mean_fare,Pclass3_mean_fare),axis=1)

pclass_level = LabelEncoder()
#给每一项添加标签
pclass_level.fit(np.array(['Pclass1_Low','Pclass1_High','Pclass2_Low','Pclass2_High','Pclass3_Low','Pclass3_High']))
#转换成数值
combined_train_test['Pclass_Fare_Category'] = pclass_level.transform(combined_train_test['Pclass_Fare_Category'])
# dummy 转换
pclass_dummies_df = pd.get_dummies(combined_train_test['Pclass_Fare_Category']).rename(columns=lambda x: 'Pclass_' + str(x))
combined_train_test = pd.concat([combined_train_test,pclass_dummies_df],axis=1)
```


```python
combined_train_test['Pclass'] = pd.factorize(combined_train_test['Pclass'])[0]
```


```python
combined_train_test['Pclass'].value_counts()
```




    0    709
    1    323
    2    277
    Name: Pclass, dtype: int64



### Parch and SibSp

由前面的分析，我们可以知道，亲友的数量没有或者太多会影响到Survived。所以将二者合并为FamliySize这一组合项，同时也保留这两项


```python
def family_size_category(family_size):
    if family_size <= 1:
        return 'Single'
    elif family_size <= 4:
        return 'Small_Family'
    else:
        return 'Large_Family'
```


```python
combined_train_test['Family_Size'] = combined_train_test['Parch'] + combined_train_test['SibSp'] + 1
combined_train_test['Family_Size_Category'] = combined_train_test['Family_Size'].map(family_size_category)
```


```python
# Label编码和One hot编码差异较大
le_family = LabelEncoder()
le_family.fit(np.array(['Single', 'Small_Family', 'Large_Family']))
combined_train_test['Family_Size_Category'] = le_family.transform(combined_train_test['Family_Size_Category'])
family_size_dummies_df = pd.get_dummies(
    combined_train_test['Family_Size_Category'],
    prefix=combined_train_test[['Family_Size_Category']].columns[0])
```


```python
combined_train_test = pd.concat([combined_train_test, family_size_dummies_df], axis=1)
```


```python
combined_train_test['Family_Size_Category'].value_counts().sort_index()
```




    0     82
    1    790
    2    437
    Name: Family_Size_Category, dtype: int64



### Age


```python
combined_train_test[combined_train_test.Age.isnull()].head()
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
      <th>Age</th>
      <th>Cabin</th>
      <th>Embarked</th>
      <th>Fare</th>
      <th>Name</th>
      <th>Parch</th>
      <th>PassengerId</th>
      <th>Pclass</th>
      <th>Sex</th>
      <th>SibSp</th>
      <th>...</th>
      <th>Pclass_1</th>
      <th>Pclass_2</th>
      <th>Pclass_3</th>
      <th>Pclass_4</th>
      <th>Pclass_5</th>
      <th>Family_Size</th>
      <th>Family_Size_Category</th>
      <th>Family_Size_Category_0</th>
      <th>Family_Size_Category_1</th>
      <th>Family_Size_Category_2</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>5</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>2</td>
      <td>8.458</td>
      <td>Moran, Mr. James</td>
      <td>0</td>
      <td>6</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>...</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>1</td>
      <td>1</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>17</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>0</td>
      <td>13.000</td>
      <td>Williams, Mr. Charles Eugene</td>
      <td>0</td>
      <td>18</td>
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>...</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>1</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>19</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>1</td>
      <td>7.225</td>
      <td>Masselmani, Mrs. Fatima</td>
      <td>0</td>
      <td>20</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>...</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>26</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>1</td>
      <td>7.225</td>
      <td>Emir, Mr. Farred Chehab</td>
      <td>0</td>
      <td>27</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>...</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>28</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>2</td>
      <td>7.879</td>
      <td>O'Dwyer, Miss. Ellen "Nellie"</td>
      <td>0</td>
      <td>29</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>...</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>1</td>
      <td>1</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
    </tr>
  </tbody>
</table>
<p>5 rows × 46 columns</p>
</div>



由于Age字段缺失比较多，所以不能单纯的通过填充均值、中位数等解决，误差会比较大，我们可以基于一些字段建模型预测,我们可以多模型预测，然后再做模型的融合，提高预测的精度。

Modeling


```python
from sklearn import ensemble
from sklearn import model_selection
from sklearn.ensemble import GradientBoostingRegressor
from sklearn.ensemble import RandomForestRegressor

def gbm_reg(train,test):
    train_X = train.drop(['Age'],axis=1)
    train_Y = train['Age']
    test_X = test.drop(['Age'],axis=1)
    # model gbm
    gbm_reg = GradientBoostingRegressor(random_state=42)
    gbm_reg_param_grid = {'n_estimators': [2000],
                          'max_depth': [4],
                          'learning_rate': [0.01],
                          'max_features': [3]}
    gbm_reg_grid = model_selection.GridSearchCV(
        gbm_reg, gbm_reg_param_grid, cv=10, n_jobs=25, verbose=1, scoring='neg_mean_squared_error')
    gbm_reg_grid.fit(train_X,train_Y)
    print('Age feature Best GB Params:' + str(gbm_reg_grid.best_params_))
    print('Age feature Best GB Score:' + str(gbm_reg_grid.best_score_))
    print('GB Train Error for "Age" Feature Regressor:' + str(gbm_reg_grid.score(train_X, train_Y)))
    gbm_res = gbm_reg_grid.predict(test_X)
#     print(missing_age_test['Age_GB'][:4])
    return gbm_res

def rf_reg(train,test):
    train_X = train.drop(['Age'],axis=1)
    train_Y = train['Age']
    test_X = test.drop(['Age'],axis=1)
    # model rf
    rf_reg = RandomForestRegressor()
    rf_reg_param_grid = {'n_estimators': [200], 
                         'max_depth': [5], 
                         'random_state': [0]}
    rf_reg_grid = model_selection.GridSearchCV(
        rf_reg, rf_reg_param_grid, cv=10, n_jobs=25, verbose=1, scoring='neg_mean_squared_error')
    rf_reg_grid.fit(train_X, train_Y)
    print('Age feature Best RF Params:' + str(rf_reg_grid.best_params_))
    print('Age feature Best RF Score:' + str(rf_reg_grid.best_score_))
    print('RF Train Error for "Age" Feature Regressor' + str(rf_reg_grid.score(train_X, train_Y)))
    rf_res = rf_reg_grid.predict(test_X)
#     print(missing_age_test['Age_RF'][:4])
    return rf_res
```


```python
# 取出和Age相关的字段作为模型参数
missing_age_df = pd.DataFrame(
    combined_train_test[['Age', 'Embarked', 'Sex', 'title', 'Name_length', 'Family_Size', 'Family_Size_Category','Fare', 'Fare_bin_id', 'Pclass']])
# 以有Age的作为train
missing_age_train = missing_age_df[missing_age_df['Age'].notnull()]
# # 以无Age的作为test
missing_age_test = missing_age_df[missing_age_df['Age'].isnull()]
missing_age_test.head()
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
      <th>Age</th>
      <th>Embarked</th>
      <th>Sex</th>
      <th>title</th>
      <th>Name_length</th>
      <th>Family_Size</th>
      <th>Family_Size_Category</th>
      <th>Fare</th>
      <th>Fare_bin_id</th>
      <th>Pclass</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>5</th>
      <td>NaN</td>
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>16</td>
      <td>1</td>
      <td>1</td>
      <td>8.458</td>
      <td>2</td>
      <td>0</td>
    </tr>
    <tr>
      <th>17</th>
      <td>NaN</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>28</td>
      <td>1</td>
      <td>1</td>
      <td>13.000</td>
      <td>3</td>
      <td>2</td>
    </tr>
    <tr>
      <th>19</th>
      <td>NaN</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>23</td>
      <td>1</td>
      <td>1</td>
      <td>7.225</td>
      <td>4</td>
      <td>0</td>
    </tr>
    <tr>
      <th>26</th>
      <td>NaN</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>23</td>
      <td>1</td>
      <td>1</td>
      <td>7.225</td>
      <td>4</td>
      <td>0</td>
    </tr>
    <tr>
      <th>28</th>
      <td>NaN</td>
      <td>2</td>
      <td>1</td>
      <td>2</td>
      <td>29</td>
      <td>1</td>
      <td>1</td>
      <td>7.879</td>
      <td>0</td>
      <td>0</td>
    </tr>
  </tbody>
</table>
</div>




```python
gbm_res = gbm_reg(missing_age_train,missing_age_test)
rf_res = rf_reg(missing_age_train,missing_age_test)
```

    Fitting 10 folds for each of 1 candidates, totalling 10 fits
    

    [Parallel(n_jobs=25)]: Done   5 out of  10 | elapsed:   12.0s remaining:   12.0s
    [Parallel(n_jobs=25)]: Done  10 out of  10 | elapsed:   19.0s finished
    

    Age feature Best GB Params:{'learning_rate': 0.01, 'max_depth': 4, 'max_features': 3, 'n_estimators': 2000}
    Age feature Best GB Score:-129.81885365025488
    GB Train Error for "Age" Feature Regressor:-65.10285171746763
    Fitting 10 folds for each of 1 candidates, totalling 10 fits
    

    [Parallel(n_jobs=25)]: Done   5 out of  10 | elapsed:   11.8s remaining:   11.8s
    [Parallel(n_jobs=25)]: Done  10 out of  10 | elapsed:   18.0s finished
    

    Age feature Best RF Params:{'max_depth': 5, 'n_estimators': 200, 'random_state': 0}
    Age feature Best RF Score:-119.74290969276963
    RF Train Error for "Age" Feature Regressor-96.8416373763306
    


```python
missing_age_test['Age_GB'] = gbm_res
missing_age_test['Age_RF'] = rf_res
missing_age_test.head()
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
      <th>Age</th>
      <th>Embarked</th>
      <th>Sex</th>
      <th>title</th>
      <th>Name_length</th>
      <th>Family_Size</th>
      <th>Family_Size_Category</th>
      <th>Fare</th>
      <th>Fare_bin_id</th>
      <th>Pclass</th>
      <th>Age_GB</th>
      <th>Age_RF</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>5</th>
      <td>34.282</td>
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>16</td>
      <td>1</td>
      <td>1</td>
      <td>8.458</td>
      <td>2</td>
      <td>0</td>
      <td>35.051</td>
      <td>33.513</td>
    </tr>
    <tr>
      <th>17</th>
      <td>32.301</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>28</td>
      <td>1</td>
      <td>1</td>
      <td>13.000</td>
      <td>3</td>
      <td>2</td>
      <td>31.504</td>
      <td>33.098</td>
    </tr>
    <tr>
      <th>19</th>
      <td>34.607</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>23</td>
      <td>1</td>
      <td>1</td>
      <td>7.225</td>
      <td>4</td>
      <td>0</td>
      <td>34.361</td>
      <td>34.854</td>
    </tr>
    <tr>
      <th>26</th>
      <td>28.525</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>23</td>
      <td>1</td>
      <td>1</td>
      <td>7.225</td>
      <td>4</td>
      <td>0</td>
      <td>28.902</td>
      <td>28.149</td>
    </tr>
    <tr>
      <th>28</th>
      <td>21.338</td>
      <td>2</td>
      <td>1</td>
      <td>2</td>
      <td>29</td>
      <td>1</td>
      <td>1</td>
      <td>7.879</td>
      <td>0</td>
      <td>0</td>
      <td>20.169</td>
      <td>22.507</td>
    </tr>
  </tbody>
</table>
</div>




```python
# two models merge
print('shape1', missing_age_test['Age'].shape, missing_age_test[['Age_GB', 'Age_RF']].mode(axis=1).shape)
# 众数填充
missing_age_test['Age'] = missing_age_test[['Age_GB', 'Age_RF']].mode(axis=1)
print(missing_age_test['Age'][:4])
```

    shape1 (263,) (263, 2)
    5     33.513
    17    31.504
    19    34.361
    26    28.149
    Name: Age, dtype: float64
    


```python
print('shape of Age:', missing_age_test['Age'].shape)
print('shape of Age_GB/Age_rf:',missing_age_test[['Age_GB', 'Age_RF']].mode(axis=1).shape)
missing_age_test.head()
```

    shape of Age: (263,)
    shape of Age_GB/Age_rf: (263, 2)
    




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
      <th>Age</th>
      <th>Embarked</th>
      <th>Sex</th>
      <th>title</th>
      <th>Name_length</th>
      <th>Family_Size</th>
      <th>Family_Size_Category</th>
      <th>Fare</th>
      <th>Fare_bin_id</th>
      <th>Pclass</th>
      <th>Age_GB</th>
      <th>Age_RF</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>5</th>
      <td>33.513</td>
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>16</td>
      <td>1</td>
      <td>1</td>
      <td>8.458</td>
      <td>2</td>
      <td>0</td>
      <td>35.051</td>
      <td>33.513</td>
    </tr>
    <tr>
      <th>17</th>
      <td>31.504</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>28</td>
      <td>1</td>
      <td>1</td>
      <td>13.000</td>
      <td>3</td>
      <td>2</td>
      <td>31.504</td>
      <td>33.098</td>
    </tr>
    <tr>
      <th>19</th>
      <td>34.361</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>23</td>
      <td>1</td>
      <td>1</td>
      <td>7.225</td>
      <td>4</td>
      <td>0</td>
      <td>34.361</td>
      <td>34.854</td>
    </tr>
    <tr>
      <th>26</th>
      <td>28.149</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>23</td>
      <td>1</td>
      <td>1</td>
      <td>7.225</td>
      <td>4</td>
      <td>0</td>
      <td>28.902</td>
      <td>28.149</td>
    </tr>
    <tr>
      <th>28</th>
      <td>20.169</td>
      <td>2</td>
      <td>1</td>
      <td>2</td>
      <td>29</td>
      <td>1</td>
      <td>1</td>
      <td>7.879</td>
      <td>0</td>
      <td>0</td>
      <td>20.169</td>
      <td>22.507</td>
    </tr>
  </tbody>
</table>
</div>




```python
missing_age_test['Age'] = missing_age_test[['Age_GB','Age_RF']].apply(lambda x: x.mean(), axis=1)
missing_age_test[['Age','Age_GB','Age_RF']].head()
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
      <th>Age</th>
      <th>Age_GB</th>
      <th>Age_RF</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>5</th>
      <td>34.282</td>
      <td>35.051</td>
      <td>33.513</td>
    </tr>
    <tr>
      <th>17</th>
      <td>32.301</td>
      <td>31.504</td>
      <td>33.098</td>
    </tr>
    <tr>
      <th>19</th>
      <td>34.607</td>
      <td>34.361</td>
      <td>34.854</td>
    </tr>
    <tr>
      <th>26</th>
      <td>28.525</td>
      <td>28.902</td>
      <td>28.149</td>
    </tr>
    <tr>
      <th>28</th>
      <td>21.338</td>
      <td>20.169</td>
      <td>22.507</td>
    </tr>
  </tbody>
</table>
</div>



**预测值填充训练样本中的空缺值**


```python
missing_age_test.drop(['Age_GB', 'Age_RF'], axis=1, inplace=True)
combined_train_test.loc[(combined_train_test.Age.isnull()), 'Age'] = missing_age_test['Age']
```

### Ticket

观察Ticket的值，我们可以看到，Ticket有字母和数字之分，而对于不同的字母，可能在很大程度上就意味着船舱等级或者不同船舱的位置，也会对Survived产生一定的影响，所以我们将Ticket中的字母分开，为数字的部分则分为一类


```python
combined_train_test.Ticket.head()
```




    0           A/5 21171
    1            PC 17599
    2    STON/O2. 3101282
    3              113803
    4              373450
    Name: Ticket, dtype: object




```python
combined_train_test['Ticket_Letter'] = combined_train_test['Ticket'].str.split().str[0]
combined_train_test['Ticket_Letter'] = combined_train_test['Ticket_Letter'].apply(
    lambda x: 'U0' if x.isnumeric() else x )
```


```python
combined_train_test['Ticket_Letter'].value_counts()
```




    U0            957
    PC             92
    C.A.           46
    SOTON/O.Q.     16
    STON/O         14
    W./C.          14
    CA.            12
    A/5            12
    SC/PARIS       11
    A/5.           10
    CA             10
    F.C.C.          9
    C               8
    SOTON/OQ        8
    S.O./P.P.       7
    S.O.C.          7
    STON/O2.        7
    A/4             6
    SC/Paris        5
    SC/AH           5
    LINE            4
    PP              4
    F.C.            3
    S.C./PARIS      3
    A.5.            3
    A/4.            3
    A./5.           3
    SOTON/O2        3
    SC              2
    P/PP            2
    W.E.P.          2
    WE/P            2
    A.              1
    C.A./SOTON      1
    S.O.P.          1
    A/S             1
    A4.             1
    LP              1
    S.C./A.4.       1
    Fa              1
    AQ/3.           1
    SW/PP           1
    STON/OQ.        1
    S.W./PP         1
    AQ/4            1
    W/C             1
    S.P.            1
    SC/A4           1
    SCO/W           1
    SC/A.3          1
    SO/C            1
    Name: Ticket_Letter, dtype: int64




```python
# 对非数字的分类，数字类的Ticket作为一个大类U0，然后做归一化处理
combined_train_test['Ticket_Letter'] = pd.factorize(combined_train_test['Ticket_Letter'])[0]
```

### Cabin

因为Cabin项的缺失值确实太多了，我们很难对其进行分析，或者预测。所以这里我们可以直接将Cabin这一项特征去除。但通过上面的分析，可以知道，该特征信息的有无也与生存率有一定的关系，所以这里我们暂时保留该特征，并将其分为有和无两类。


```python
# 将没有船舱类型的归为一类,赋值为0
combined_train_test.loc[combined_train_test.Cabin.isnull(), 'Cabin'] = 'U0'
combined_train_test['Cabin'] = combined_train_test['Cabin'].apply(lambda x: 0 if x == 'U0' else 1)
```

### 特征间相关性分析


```python
print('shape of combined_train_test:')
print(combined_train_test.shape)
combined_train_test.columns
```

    shape of combined_train_test:
    (1309, 48)
    




    Index(['Age', 'Cabin', 'Embarked', 'Fare', 'Name', 'Parch', 'PassengerId',
           'Pclass', 'Sex', 'SibSp', 'Survived', 'Ticket', 'Embarked_0',
           'Embarked_1', 'Embarked_2', 'Sex_0', 'Sex_1', 'Title', 'title',
           'title_0', 'title_1', 'title_2', 'title_3', 'title_4', 'title_5',
           'Fare_bin_id', 'Fare_0', 'Fare_1', 'Fare_2', 'Fare_3', 'Fare_4',
           'Pclass_1', 'Pclass_2', 'Pclass_3', 'Pclass_Fare_Category', 'Pclass_0',
           'Pclass_1', 'Pclass_2', 'Pclass_3', 'Pclass_4', 'Pclass_5',
           'Family_Size', 'Family_Size_Category', 'Family_Size_Category_0',
           'Family_Size_Category_1', 'Family_Size_Category_2', 'Name_length',
           'Ticket_Letter'],
          dtype='object')




```python
Correlation = pd.DataFrame(combined_train_test[['Embarked','Sex','title','Name_length','Family_Size',
                                                'Family_Size_Category','Fare','Fare_bin_id','Pclass',
                                                'Pclass_Fare_Category','Age','Ticket_Letter','Cabin']])
import matplotlib.pyplot as plt
plt.figure(figsize=(16,12))
plt.title('Pearson Correaltion of Feature',y=1.05,size=15)
sns.heatmap(Correlation.astype(float).corr(),
            linewidths=0.1,
            vmax=1.0,
#             cmap = sns.cubehelix_palette(start = 1.5, rot = 3, gamma=0.8, as_cmap = True),
            cmap = 'viridis',
            square=True,
            linecolor='white',
            annot=True)
```




    <matplotlib.axes._subplots.AxesSubplot at 0x287eb484358>




![png](output_193_1.png)

