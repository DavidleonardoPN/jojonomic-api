RUN bundle exec rake db:create
RUN bundle exec rake db:migrate
RUN bundle install
RUN rails c
