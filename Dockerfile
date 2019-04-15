FROM ruby:2.3.4
ENV APP_HOME /home/gusto
WORKDIR $APP_HOME
COPY Gemfile Gemfile.lock contract_value_object.gemspec $APP_HOME/
COPY lib/contract_value_object/version.rb $APP_HOME/lib/contract_value_object/version.rb
RUN bundle install
COPY . $APP_HOME
