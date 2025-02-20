# Related documentation:
# - https://jekyllrb.com/docs/installation/ubuntu/
# - https://thelinuxcode.com/how-to-use-apt-install-correctly-in-your-dockerfile/
# - https://github.com/envygeeks/jekyll-docker

FROM ruby:3.4.2-alpine

# Copy over the gemfile that has all the gems that we need
WORKDIR /temp
COPY src/Gemfile /temp/Gemfile
COPY src/Gemfile.lock /temp/Gemfile.lock

# Set environment variables to avoid warnings and optimize bundler
ENV BUNDLE_HOME=/usr/local/bundle
ENV BUNDLE_APP_CONFIG=/usr/local/bundle
ENV BUNDLE_DISABLE_PLATFORM_WARNINGS=true
ENV BUNDLE_BIN=/usr/local/bundle/bin
ENV GEM_BIN=/usr/gem/bin
ENV GEM_HOME=/usr/gem

# Install only the necessary Alpine packages and clean up in a single RUN command
RUN apk add --no-cache --virtual .build-deps build-base zlib-dev git && \
  # Dependencies for Jekyll
  gem install bundler -v 2.6.2 && \ 
  gem install jekyll && \
  # Install gems for the project
  bundle install --no-cache && \
  # Clean up the image to reduce its size, which speeds up the workflow
  gem clean && \
  apk del .build-deps && \
  rm -rf /var/cache/apk/* /usr/local/bundle/cache /usr/gem/cache
