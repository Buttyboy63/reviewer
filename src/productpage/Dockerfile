FROM python:3.7.7-slim
ADD ./requirements.txt /
RUN ["pip", "install", "--no-cache-dir", "-r", "requirements.txt"]
ARG FLOOD_FACTOR_DEF=0
ENV FLOOD_FACTOR=$FLOOD_FACTOR_DEF
WORKDIR /opt/microservices
COPY ./ .
EXPOSE 9080
CMD ["python","productpage.py","9080"]
