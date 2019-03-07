FROM python:3

RUN pip3 install Flask mysql-connector-python hvac

WORKDIR /usr/src/app
ADD templates ./templates/
ADD app.py db_client.py ./
ADD config.ini ./config/

VOLUME ["/usr/src/app/config"]

CMD [ "python", "./app.py" ]
