FROM ruby:latest

ENV APP_ROOT /app

#Workディレクトリの設定
WORKDIR $APP_ROOT

#apt-getでtoolのインストール
RUN apt-get update && \
        apt-get install -y nodejs && \
        apt-get install -y vim

ADD Gemfile $APP_ROOT/Gemfile
ADD Gemfile.lock $APP_ROOT/Gemfile.lock
RUN bundle install
ADD . $APP_ROOT

EXPOSE 25:25

CMD ["bundle", "exec", "ruby", "smtp.rb"]