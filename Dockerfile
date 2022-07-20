FROM python:3.10 as requirements-stage

WORKDIR /tmp

RUN pip install poetry

COPY ./pyproject.toml ./poetry.lock* /tmp/

RUN poetry export -f requirements.txt --output requirements.txt --without-hashes

FROM python:3.10

WORKDIR /quasar

COPY --from=requirements-stage /tmp/requirements.txt /quasar/requirements.txt

RUN pip install --no-cache-dir --upgrade -r /quasar/requirements.txt


COPY . /quasar

EXPOSE 8000

RUN python manage.py migrate

CMD ["gunicorn", "--bind", ":8000", "core.wsgi:application"]