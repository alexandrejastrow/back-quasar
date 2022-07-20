FROM python:3.10 as requirements-stage

WORKDIR /tmp

RUN pip install poetry

COPY ./pyproject.toml ./poetry.lock* /tmp/

RUN poetry export -f requirements.txt --output requirements.txt --without-hashes

FROM python:3.10

WORKDIR /estour

COPY --from=requirements-stage /tmp/requirements.txt /estour/requirements.txt

RUN pip install --no-cache-dir --upgrade -r /estour/requirements.txt


COPY . /estour

EXPOSE 8000
RUN python manage.py migrate

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]