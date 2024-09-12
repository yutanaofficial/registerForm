# syntax = docker/dockerfile:1

# This Dockerfile is designed for production, not development. Use with Kamal or build'n'run by hand:
# docker build -t registerform .
# docker run -d -p 3000:3000 --name registerform -e RAILS_MASTER_KEY=4c2e6bdb90849b8246060f5849dbeb5a -e SECRET_KEY_BASE=<your_secret_key_base> registerform

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.3.1
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Rails app lives here
WORKDIR /rails

# Install base packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips sqlite3 && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development" \
    SECRET_KEY_BASE="e1fb56c38b6a09b90dd79ec7da1bb086989a68a07996f8f460bb99aefe2427185f03ff32d823545c8919860ee99fceea3603e1dd2d82cc731869ae42b49b335d"
# Throw-away build stage to reduce size of final image
FROM base AS build

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy application code
COPY . .

# Precompile assets
RUN bundle exec rake assets:precompile

# Final stage
FROM base AS final

# Copy built gems from build stage
COPY --from=build /usr/local/bundle /usr/local/bundle

# Copy application code from build stage
COPY --from=build /rails /rails

# Expose port 3000 to the Docker host, so we can access it from the outside.
EXPOSE 3000

# Start the main process.
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]