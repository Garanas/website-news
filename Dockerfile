# Related documentation:
# - https://jekyllrb.com/docs/installation/ubuntu/
# - https://thelinuxcode.com/how-to-use-apt-install-correctly-in-your-dockerfile/
# - https://github.com/envygeeks/jekyll-docker

FROM ruby:3.4.1

ENV BUNDLE_HOME=/usr/local/bundle
ENV BUNDLE_APP_CONFIG=/usr/local/bundle
ENV BUNDLE_DISABLE_PLATFORM_WARNINGS=true
ENV BUNDLE_BIN=/usr/local/bundle/bin
ENV GEM_BIN=/usr/gem/bin
ENV GEM_HOME=/usr/gem

# Install all gems, do not use sudo here
RUN gem install jekyll bundler && gem clean

WORKDIR /temp
COPY src/Gemfile /temp/Gemfile
COPY src/Gemfile.lock /temp/Gemfile.lock

# Install all dependencies
RUN bundle install
