# 작정하고 장고! Django로 Pinterest 따라만들기 : 바닥부터 배포까지 정리!!
<hr>

## django 개발 패턴

**M** odel  <br>
**V** iew  <br>
**T** emplate  <br>

* Model   <br>
  django에서 db와 통신을 하게 해주는 편리한 도구 <br> 
  DB는 Row,Columns,Item,Attributes를 가지고 있다.
    
* View 
  <br>
    user ----request----> server  <br>
    user <----response---- server  <br>
    
* Template  <br>
    HTML,JS,CSS 같은 프론트엔드와 밀접하게 관련이 있다.<br>
    ex) User ----HTML---> Server<br>
         HTML 내부에서 게시글을 구현해줄 작업이 필요하다. HTML은 정적인 언어이기 때문에 동적으로 만들어주는게 Template<br>
  

    django
    
    Template <--> View <--> Model
    UI와 밀접하게 관련
    인증,계산,확인 관련 작업
    데이터가 저장되는 곳,쉽게 연결하기 위해서 만들어진 곳

<hr>

## 개발환경 구축 (pycharm)
    * 터미널에서 실행
     django library 설치
     # pip install django
     django project 생성
     # django-admin startproject 프로젝트명(필자는 Pragmatic이라 칭함) 
     
     장고 프로젝트에 들어가면 터미널에서 venv 설정이 안되어있음. 
     setting - Project: Pragmatic - Python Interpreter - configuration(톱니바퀴) add - ok
     다시 터미널에 접속하면 venv 설정이 되어있고 
     # pip list 시 django가 없음(독자적인 가상환경이여서 존재하지 않음)
     # pip install django
     # python manage.py runserver 로 실행되는지 테스트


<hr>


### 첫 앱 시작, 기본적인 view 만들기
* 첫 앱 생성 <br>
  
        # python manage.py startapp accountapp //Terminal
        # pragmatic/pragmatic/settings.py 에서 INSTALLED_APPS에 'accountapp', 추가    (pragmatic 프로젝트 내에서 새로 만들어진 앱으로 인식하기 위해)
    
        # pragmatic/accountapp/views.py 
            def hello_world(request):
                return HttpResponse('Hello world!') #Response를 직접 만들어서 Hello world를 반환
        
        # pragmatic/pragmatic/urls.py urlpatterns에 path('account/',include('accountapp.urls')) 추가 accountapp 내부에 있는 urls.py를 참고해서 그 안에서 다시 분기를 하기 위해
        # pragmatic/accountapp/urls.py 생성
            from django.urls import path
            from accountapp.views import hello_world
        
            app_name="accountapp" # accountapp 내부에서
        
            urlpatterns = [
                path('hello_world/',hello_world,name='hello_world')  # name='hello_world'인 route로 그대로 가라
            ]
##### http://127.0.0.1:8000/account/hello_world/ 접속시 Hello world! 출력
    

<hr>


### Pycharm 전용 .gitignore 링크
##### https://github.com/github/gitignore/blob/master/Global/JetBrains.gitignore
### Django 환경 변수 관리 
##### https://django-environ.readthedocs.io/en/latest/ 참고
    
* SECRET KEY 관리를 위한 pragmatic/pragmatic/settings.py 추가
  

    import os,environ
    env = environ.Env(
        # set casting, default value
        DEBUG=(bool, False)
    )

    # reading .env file
    environ.Env.read_env(
        env_file=os.path.join(BASE_DIR,'.env')
    )
    SECRET_KEY = env('SECRET_KEY')

* pragmatic/.env 생성
  

    DEBUG=on
    SECRET_KEY=[pragmatic/pragmatic/settings.py의 SECRET_KEY로 변경]
    DATABASE_URL=psql://urser:un-githubbedpassword@127.0.0.1:8458/database
    SQLITE_URL=sqlite:///my-local-sqlite.db
    CACHE_URL=memcache://127.0.0.1:11211,127.0.0.1:11212,127.0.0.1:11213
    REDIS_URL=rediscache://127.0.0.1:6379/1?client_class=django_redis.client.DefaultClient&password=ungithubbed-secret

<hr>

### Django Template
* extends<br>
  미리 만들어 놓은 Html 파일을 가져와서 이것을  **바탕**으로 Html의 Block들을 채워나간다.
* include<br>
  만들고 있는 Html 파일이 있다고 할 때 거기에 조그만한 **조각**을 Html에 채워넣음
#### 적용해보기  
* pragmatic/templates 디렉토리 생성
* pragmatic/templates/base.html 생성


    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Title</title>
    </head>
    <body>
        Hello worlds!
    </body>
    </html>

* pragmatic/setting.py 


    TEMPLATES = [
        {
            'BACKEND': 'django.template.backends.django.DjangoTemplates',
            'DIRS': [],
            'APP_DIRS': True,
            'OPTIONS': {
                'context_processors': [
                    'django.template.context_processors.debug',
                    'django.template.context_processors.request',
                    'django.contrib.auth.context_processors.auth',
                    'django.contrib.messages.context_processors.messages',
                ],
            },
        },
    ]

    'DIRS':[ ]을 'DIRS': [os.path.join(BASE_DIR,'templates')] 수정하여 templates 디렉토리의 하위 파일들을 연결 

* pragmatic/pragmatic/views.py 수정
  

    from django.http import HttpResponse
    from django.shortcuts import render
    
    
    def hello_world(request):
        return render(request,'base.html')  # base.html을 request에 포함시켜 반환

<hr>

#### Bootstrap,Font 적용하기

* head 부분
  

    <head>
      <meta charset="UTF-8">
      <title>Pragmatic</title>
  
      <!--  Bootstrap Link  -->
      <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/css/bootstrap.min.css" rel="stylesheet"
            integrity="sha384-+0n0xVW2eSR5OomGNYDnhzAbDsOXxcvSN1TPprVMTNDbiYZCxYbOOl7+AMvyTG2x" crossorigin="anonymous">
      <!--  GOOGLE FONTS LINK  -->
      <link rel="preconnect" href="https://fonts.gstatic.com">
      <link href="https://fonts.googleapis.com/css2?family=Do+Hyeon&display=swap" rel="stylesheet">
    </head>

* div와 같은 태그 부분
  
  
    <div style="font-family: 'Do Hyeon', sans-serif;">

<hr>

#### Static 설정 및 CSS 파일 분리

* pragmatic/pragmatic/settings.py
  

    STATIC_ROOT = os.path.join(BASE_DIR,'staticfiles')
    
    STATICFILES_DIRS = [
        BASE_DIR / "static"
    ]

* pragmatic/static/base.css 생성


    .pragmatic_logo{
        font-family: 'Do Hyeon', sans-serif;
    }
    .pragmatic_footer_button{
        font-size: .6rem ;
    }
    .pragmatic_footer{
        text-align: center; margin-top: 2rem;
    }
    .pragmatic_header{
        text-align: center; margin: 2rem 0;
    }

* head 부분 추가
  

    <!--  DEFAULT CSS LINK  -->
    <link rel="stylesheet" type="text/css" href="{% static 'base.css' %}">

* div와 같은 태그 부분

  
    <div class="pragmatic_header">

    </div>


<h4 style="color: red;"># css가 브라우저에서 적용되지 않을때</h3>

    html 이나 CSS 같은 파일들은 정적이라, 브라우저 자체 캐쉬를 해놓는 경우가 많다보니 브라우저에 적용되지 않는 현상이 발생함.
    하지만 정적이라고 해도 개발중에는 수시로 바뀔수 있는 파일이라 종종 보게 되는 현상
    
    개발을 할때 이런 현상을 방지하는 방법입니다.
    
    일단 개발중일때는, F12를 눌러 개발자탭을 활성화하고 개발자탭 중에서 Network 에서 Disable Cache 버튼을 활성화
    이런 설정을 통해, 개발을 하는 도중에는 항상 CSS 가 캐쉬되지 않고, 새로이 서버에서 불러온 파일을 사용하게 됨.

* css 적용 우선 순위
  

  `1. <div style=""></div>`<br>
  `2. <style></style>`<br>
  `3. css 파일`<br>
  
<hr>

#### Model,DB 연동
* pragmatic/accountapp/models.py


    from django.db import models
    
    class HelloWorld(models.Model):
        text = models.CharField(max_length=255,null=False)
* Terminal
  

    python manage.py makemigrations # models.py와 db를 연동시키기 위한 파이썬 파일을 만들어줌
    python manage.py migrate        # models.py와 db를 연동

* pragmatic/pragmatic/settings.py 에서 연결할 db를 확인 가능하다.


    DATABASES = {
        'default': {
            'ENGINE': 'django.db.backends.sqlite3',
            'NAME': BASE_DIR / 'db.sqlite3',
        }
    }
