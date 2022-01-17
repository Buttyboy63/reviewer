FROM python:3.7.7-slim
WORKDIR /
ADD ./requirements.txt .
ADD ./productpage.py .
RUN ["pip", "install", "--no-cache-dir", "-r", "requirements.txt"]
ARG FLOOD_FACTOR_DEF=0
ENV FLOOD_FACTOR=$FLOOD_FACTOR_DEF
COPY ./ /opt/microservices
CMD ["python","productpage.py","9080"]
