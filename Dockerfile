FROM python:3.8.10

WORKDIR /home/

RUN git clone https://github.com/HM-L-1996/Pragmatic.git

WORKDIR /home/Pragmatic/

RUN pip install -r requirements.txt

RUN echo "SECRET_KEY=django-insecure-l=()=m9%=_--iddt0s9%p$gkcg16%%o#ltfx#r1=dje5o+xq1u" > .env

RUN python manage.py migrate

EXPOSE 8000

CMD ["python","manage.py","runserver","0.0.0.0:8000"]