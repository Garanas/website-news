# Use the Debian-based Ruby slim image
FROM ruby:3.4.2-slim

# Copy over the Gemfile that has all the required gems
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

# Install necessary dependencies and clean up in a single RUN command
RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  zlib1g-dev \
  git \
  imagemagick && \
  # Install dependencies for Jekyll
  gem install bundler -v 2.6.2 && \
  gem install jekyll && \
  # Install gems for the project
  bundle install --no-cache && \
  # Clean up the image to reduce its size
  gem clean && \
  apt-get remove -y build-essential && \
  apt-get autoremove -y && \
  rm -rf /var/lib/apt/lists/* /usr/local/bundle/cache /usr/gem/cache
