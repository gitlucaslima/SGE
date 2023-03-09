# pull official base image
FROM python:3.10.5

# set work directory
WORKDIR /sge

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# create the app directory - and switch to it
RUN mkdir -p /sge
WORKDIR /sge

# install dependencies
COPY requirements.txt /tmp/requirements.txt

RUN set -ex && \
    pip install --upgrade pip && \
    pip install -r /tmp/requirements.txt && \
    rm -rf /root/.cache/

# copy project
COPY . /sge/

RUN python manage.py collectstatic --noinput

# expose port 8000
EXPOSE 8000

CMD ["gunicorn", "--bind", ":8000", "--workers", "2", "SGE.wsgi:application"]