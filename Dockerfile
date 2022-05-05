# front-end build
FROM node:13 AS frontend

COPY . /app
WORKDIR /app

RUN npm install && npm run prod

# actual build
FROM python:3-slim-stretch

RUN apt-get update && apt-get install -y \
gcc \
netbase \
build-essential

RUN pip install --upgrade pip

# copy generated assets
COPY --from=frontend /app/assets /app/assets
# copy generated index page
COPY --from=frontend /app/templates /app/templates
# copy python files
COPY faucet.py /app/
COPY requirements.txt /app/
RUN pip install -r /app/requirements.txt

# run the app
ENTRYPOINT [ "python", "/app/faucet.py"]
CMD [ "start"]
