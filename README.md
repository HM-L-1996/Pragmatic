# 작정하고 장고! Django로 Pinterest 따라만들기 : 바닥부터 배포까지
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
    <br>
    server  <br>
  
        Check if authenticated  
        Check request valid 
        Collect data from DB  
        Render response  
    
* Template  <br>
    HTML,JS,CSS 같은 프론트엔드와 밀접하게 관련이 있다.<br>
    ex) User ----HTML---> Server<br>
         HTML 내부에서 게시글을 구현해줄 작업이 필요하다. HTML은 정적인 언어이기 때문에 동적으로 만들어주는게 Template<br>
    
    

    django
    
    Template <--> View <--> Model
    UI와 밀접하게 관련
    인증,계산,확인 관련 작업
    데이터가 저장되는 곳,쉽게 연결하기 위해서 만들어진 곳

    
### 첫 앱 시작, 기본적인 view 만들기
* 첫 앱 생성 <br>
  
        # python manage.py startapp accountapp //Terminal
        # pragmatic/pragmatic/settings.py 에서 INSTALLED_APPS에 'accountapp', 추가    (pragmatic 프로젝트 내에서 새로 만들어진 앱으로 인식하기 위해)
    
        # pragmatic/accountapp/views.py 
            def hello_world(request):
                return HttpResponse('Hello world!')
        
        # pragmatic/pragmatic/urls.py urlpatterns에 path('account/',include('accountapp.urls')) 추가 accountapp 내부에 있는 urls.py를 참고해서 그 안에서 다시 분기를 하기 위해
        # pragmatic/accountapp/urls.py 생성
            from django.urls import path
            from accountapp.views import hello_world
        
            app_name="accountapp" # accountapp 내부에서
        
            urlpatterns = [
                path('hello_world/',hello_world,name='hello_world')  # name='hello_world'인 route로 그대로 가라
            ]
##### http://127.0.0.1:8000/account/hello_world/ 접속시 Hello world! 출력
    

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

