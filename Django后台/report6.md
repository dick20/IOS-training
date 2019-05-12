# 中山大学数据科学与计算机学院本科生实验报告

## （2019年春季学期）

| 课程名称 |   IOS开发   |   任课老师   |           郑贵锋           |
| :------: | :---------: | :----------: | :------------------------: |
|   年级   |     16      | 专业（方向） | 软件工程（计算机应用方向） |
|   学号   |  16340132   |     姓名     |           梁颖霖           |
|   电话   | 13680473185 |    Email     |        dic0k@qq.com        |
| 开始日期 |  2019/4/21  |   完成日期   |         2019/4/24          |

------

## 一、实验题目

**服务端技术介绍**

**IM业务系统设计**

**Django**

## 二、实现内容

+ 总结服务端技术
+ 总结IM业务系统设计的要点
+ Django入门教程

## 三、实验结果

### A. 服务端技术介绍

#### 解决什么问题？

数据

+ 存储：⽤户资料 / 商品 / ⽂章 / 图⽚ / 视频
+ 传输：消息投递 / 转账 / 上传 / 下载

计算

+ 数据计算：地图导航 / 搜索 / 信息流推荐
+ 提供算力：语⾳合成 / 语⾳实时转写 / 图像内容识别

#### 技术栈

![6](C:\Users\asus\Desktop\6.png)

#### 接入层

+ 反向代理请求
  + nginx
+ 负载均衡
  + 轮询/随机/权重
  + hash/一致性hash

#### 逻辑层

+ 根据业务逻辑，处理用户请求，得到结果

设计模式

+ 单体式服务
  + 所有的业务逻辑都集中在一个代码仓库，一个进程
  + 优点
    + 简单，适合协作人数少，功能较少
    + 维护/更新方便
  + 缺点
    + 难以支持高复杂度系统
+ 微服务
  + 业务逻辑按功能或类型作划分，分别部署多个服务，使用网络通信交换数据
  + 优点
    + 多人团队协作成本较低
    + 功能复用，系统解耦，故障隔离
  + 缺点
    + 影响性能，系统复杂度高
    + 对网络，基础框架要求更高

#### 存储层

数据的存储/转发/查找

常用的存储

+ sql类关系型存储
+ NoSQL类Key-Value存储
+ 分布式文件系统
+ 队列存储

#### 常用技术名词

RPC  远程过程调用

+ 封装网络收发/传输协议
+ 专注业务逻辑开发
+ gRPC / bRPC / thrift



非关系型数据库

简单、性能高、横向扩展性高

+ Redis
+ memcached
+ MongoDB



关系型数据库

支持复杂的数据关系存储和查询

+ Mysql



消息队列

解耦业务逻辑，**削峰限流**

**抢红包业务，并发性高**

+ Kafka
+ RabbitMQ
+ ZeroMQ

### B. 业务系统设计——设计一个im服务

##### 考虑的问题

+ 账户 / 消息 / 关系链 存储选型
+ 消息模型： 读扩散 / 写扩散
+ 消息收发逻辑
+ 新消息推送

##### 整体框架

![7](C:\Users\asus\Desktop\7.png)

##### 存储转发

利用序号

![8](C:\Users\asus\Desktop\8.png)

##### 发消息逻辑

1. 发送消息请求
2. 检查账户
3. 检查关系链
   + 好友
   + 群聊
   + 陌生人
4. 将消息写入接受者的收件箱
5. 发送新消息通知

##### 收消息逻辑

1. 接受新消息通知
2. 发起收消息请求
3. 检查账户
4. 根据消息编写，读取未收下的消息

##### 扩展：群聊

写扩散，消息投递队列（延时

小群大群 （优先级

消息的分级 例如红包 （优先级



### C. Django学习之路

这周就进入正式的开发环节，我们小组想要完成的是一个IM聊天工具，该应用需要较多的逻辑与服务器打交道，所以我们小组在最初期分配了两个同学来做服务器，两个同学先做前端页面的基础展示。

这里，经过我们小组的协商，我们打算用Django来进行这次后台开发的工具，所以在本周就学习一下Django这门技术，并尝试先定义几个简单的api接口提供使用。



### 一. 初识Django

Django 无需数据库就可以使用，它提供了**对象关系映射器**，通过此技术，我可以使用 Python 代码来描述数据库结构，这解决了数年以来在数据库模式中的难题。

#### 1. 声明对象，保存数据

这里有一个简单的例子，说明Django如何描述数据库结构的。

```python
from django.db import models

class Reporter(models.Model):
    full_name = models.CharField(max_length=70)

    def __str__(self):
        return self.full_name

class Article(models.Model):
    pub_date = models.DateField()
    headline = models.CharField(max_length=200)
    content = models.TextField()
    reporter = models.ForeignKey(Reporter, on_delete=models.CASCADE)

    def __str__(self):
        return self.headline
```

分析：这里声明了两个表Reporter与Article，利用models.charField表明该变量是一个字符串类型，DateField表明该变量是一个日期类型，TextField表明该变量是一个文本类型，**ForeignKey表明该变量是一个外键，并填入参数Reporter是它的外键变量，删除的模式是models.CASCADE，连带删除**。

#### 2.创建数据库表

运行 Django 命令行工具来创建数据库表：

```python
$ python manage.py migrate
```

这个 `migrate` 命令查找你所有可用的模型并将在数据库中创建那些不存在的表。

#### 3. 对于数据库表的增删查改操作

接下来，直接使用便捷而丰富的api来访问之前的数据，这些API是即时创建的，而不用显示的生成代码

+ 导入刚才声明的两个表

```python
>>> from news.models import Article, Reporter
```

+ 访问表中的数据，由于还没有插入，故现在会显示为空

```python
>>> Reporter.objects.all()
<QuerySet []>
```

+ 向Reporter表中插入一个条目

```python
>>> r = Reporter(full_name='John Smith')
>>> r.save()
```

+ 再次查看表格中的数据

```python
>>> Reporter.objects.all()
<QuerySet [<Reporter: John Smith>]>
```

+ 通过多种api查找表格，如属性的开始字符，属性包含，条目的id等

```python
>>> Reporter.objects.get(id=1)
<Reporter: John Smith>
  
>>> Reporter.objects.get(full_name__startswith='John')
<Reporter: John Smith>
  
>>> Reporter.objects.get(full_name__contains='mith')
<Reporter: John Smith>
```

+ 向Article插入一个条目，其中日期属性使用datetime模块，外键reporter为上面已插入的r

```python
>>> from datetime import date
>>> a = Article(pub_date=date.today(), headline='Django is 
                cool',content='Yeah.',reporter=r)
>>> a.save()
```

+ 查看Article表

```python
>>> Article.objects.all()
<QuerySet [<Article: Django is cool>]>
```

+ 通过a来访问它外键的属性

```python
>>> r = a.reporter
>>> r.full_name
'John Smith'
```

+ 同样r也可以访问到a

```python
>>> r.article_set.all()
<QuerySet [<Article: Django is cool>]>
```

+ 利用filter过滤器来查找表中的条目，这里查找reporter外键的full_name字段开始于'John'的Article

```python
>>> Article.objects.filter(reporter__full_name__startswith='John')
<QuerySet [<Article: Django is cool>]>
```

+ 修改属性的值，记得使用save()来保存生效

```python
>>> r.full_name = 'Billy Goat'
>>> r.save()
```

+ 删除这个对象

```python
>>> r.delete()
```



#### 4. 动态管理接口

当你的模型完成定义，Django 就会自动生成一个专业的生产级管理接口 ——一个允许认证用户添加、更改和删除对象的 Web 站点。你只需简单的在 admin 站点上注册你的模型即可：

```python
from django.contrib import admin

from . import models

admin.site.register(models.Article)
```

创建 Django 应用的典型流程是，**先建立数据模型，然后搭建管理站点，之后你的员工（或者客户）就可以向网站里填充数据了**。

#### 5. 规划URLs

为了设计你自己的URLconf ，你需要创建一个叫做 URLconf 的 Python 模块。这是网站的目录，它包含了一张 URL 和 Python 回调函数之间的映射表。URLconf 也有利于将 Python 代码与 URL 进行解耦。

```python
from django.urls import path

from . import views

urlpatterns = [
    path('articles/<int:year>/', views.year_archive),
    path('articles/<int:year>/<int:month>/', views.month_archive),
    path('articles/<int:year>/<int:month>/<int:pk>/', views.article_detail),
]
```

上述代码将 URL 路径映射到了 Python 回调函数（“视图”）。路径字符串使用参数标签从URL中“捕获”相应值。当用户请求页面时，Django 依次遍历路径，直至初次匹配到了请求的 URL。(如果无匹配项，Django 会调用 404 视图。) 这个过程非常快，因为路径在加载时就编译成了正则表达式。

一旦有 URL 路径匹配成功，Django 会调用相应的视图函数。每个视图函数会接受一个请求对象——包含请求元信息——以及在匹配式中获取的参数值。

例如，当用户请求了这样的 URL "/articles/2005/05/39323/"，Django 会调用 `news.views.article_detail(request, year=2005, month=5, pk=39323)`。



#### 6. 初始化创建project

```python
$ django-admin startproject mysite
```

文件目录如下：

```
mysite/
    manage.py
    mysite/
        __init__.py
        settings.py
        urls.py
        wsgi.py
```

这些目录和文件的用处是：

+ 最外层的:file: mysite/ 根目录只是你项目的容器， Django 不关心它的名字，你可以将它重命名为任何你喜欢的名字。
+ `manage.py`: 一个让你用各种方式管理 Django 项目的命令行工具。
+ 里面一层的 `mysite/` 目录包含你的项目，它是一个纯 Python 包。它的名字就是当你引用它内部任何东西时需要用到的 Python 包名。 (比如 `mysite.urls`).
+ `mysite/__init__.py`：一个空文件，告诉 Python 这个目录应该被认为是一个 Python 包。
+ `mysite/settings.py`：Django 项目的配置文件。
+ `mysite/urls.py`：Django 项目的 URL 声明，就像你网站的“目录”。
+ `mysite/wsgi.py`：作为你的项目的运行在 WSGI 兼容的Web服务器上的入口。

![1](C:/Users/asus/Desktop/dick/1.png)



运行

```python
$ python manage.py runserver
```

![2](C:/Users/asus/Desktop/dick/2.png)

在浏览器打开http://127.0.0.1:8000/即可看到运行页面，此时表明开发环境已经搭建完毕。

![3](C:/Users/asus/Desktop/dick/3.png)

#### 7. Helloworld Demo实现

处于 `manage.py` 所在的目录下，然后运行这行命令来创建一个应用：

```python
$ python manage.py startapp polls
```

在 Django 中，每一个应用都是一个 Python 包，并且遵循着相同的约定。Django 自带一个工具，可以帮你生成应用的基础目录结构.你的应用可以存放在任何Python path中定义的路径。

![5](C:/Users/asus/Desktop/dick/5.png)



+ 编写视图：

打开 `polls/views.py`，把下面这些 Python 代码输入进去：

```python
from django.http import HttpResponse

def index(request):
    return HttpResponse("Hello, world. You're at the polls index.")
```

+ 添加url映射

如果想看见效果，我们需要将一个 URL 映射到它——这就是我们需要 URLconf 的原因了。为了创建 URLconf，请在 polls 目录里新建一个 `urls.py` 文件。

在 `polls/urls.py` 中，输入如下代码：

```python
from django.urls import path

from . import views

urlpatterns = [
    path('', views.index, name='index'),
]
```

+ 将polls模块的映射传回我们的主模块当中

在根 URLconf 文件中指定我们创建的 `polls.urls` 模块。在 `mysite/urls.py` 文件的 `urlpatterns` 列表里插入一个 `include()`， 如下:

```python
from django.contrib import admin
from django.urls import include, path

urlpatterns = [
    path('polls/', include('polls.urls')),
    path('admin/', admin.site.urls),
]
```

访问页面http://127.0.0.1:8000/polls即可显示

**注意后缀，因为我们设定的url是polls/**

实现结果：

![4](C:/Users/asus/Desktop/dick/4.png)

## 四、实验思考及感想

​	这周讲的是关于IOS服务器开发相关内容，一个好的IOS应用或者其他应用都离不开对服务器的访问，用作数据访问或者数据计算等。我们小组要做的是一个IM聊天工具，肯定也就离不开后台API的设计，所以这一节课也是十分重要的。经过组内的协商，我们打算用Djungo来进行后台开发，这个框架能简单的处理数据访问，加之用python语言来编写，代码量也不会太大，能把重点放回在IOS开发上。

​	这周我的工作就是在学习这个Djungo，写出几个简单的api，在IOS之前实验写过的网络访问来进行测试，能成功get或者post到服务器的信息，证明基本的开发环境已经配置成功了。下一步要做的就是跟组内多讨论一下接口的详情，先把基本的数据库表商量出来。

​	