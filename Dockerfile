FROM ruby:2.7.1-slim

RUN apt-get update \
&& apt-get install -y \    
build-essential \    
make \  
bash \
&& rm -rf /var/lib/apt/lists/*

RUN mkdir /usr/app

WORKDIR /usr
COPY . /usr
RUN bundle install
CMD ["ruby", "app/bot_runner.rb"]