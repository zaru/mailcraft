FROM ruby:latest

ENV APP_ROOT /app

#Workディレクトリの設定
WORKDIR $APP_ROOT

#apt-getでtoolのインストール
RUN apt-get update && \
        apt-get install -y nodejs && \
        apt-get install -y vim && \
        apt-get install -y redis-server
RUN service redis-server stop

ADD Gemfile $APP_ROOT/Gemfile
ADD Gemfile.lock $APP_ROOT/Gemfile.lock
RUN bundle install
ADD . $APP_ROOT

EXPOSE 4567:4567

CMD ["rackup", "-p", "4567", "-o", "0.0.0.0"]