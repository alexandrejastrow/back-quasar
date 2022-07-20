# FROM python:3.8
# ENV PYTHONUNBUFFERED=1
# WORKDIR /gs
# COPY requirements.txt /gs/
# RUN pip install -r requirements.txt
# COPY . /gs/
# CMD python3 manage.py runserver 0.0.0.0:$PORT

FROM python:3.10

EXPOSE 8000

ENV DJANGO_SETTINGS_MODULE=core.settings
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN \
    apt update && \ 
    apt-get install -y build-essential python3-dev libpq-dev

WORKDIR /quasar
COPY . /quasar
ADD . .

# Install dependencies:
RUN pip install -r requirements.txt
# RUN python3 manage.py makemigrations
CMD ["gunicorn", "--bind", ":8000", "--timeout", "120", "core.wsgi:application"]
