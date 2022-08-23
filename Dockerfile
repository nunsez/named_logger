FROM ruby:3.0

ENV LANG="en_US.UTF-8"

RUN useradd user --create-home --uid=1000

ENV PROJECT_ROOT="/app"
ENV HISTFILE="${PROJECT_ROOT}/tmp/.bash_history"
ENV GEM_HOME="${PROJECT_ROOT}/vendor/bundle"
ENV BUNDLE_APP_CONFIG="${GEM_HOME}"

ENV PATH="${GEM_HOME}/bin:${GEM_HOME}/gems/bin:$PATH"
ENV PATH="${PROJECT_ROOT}/bin:${PATH}"

WORKDIR ${PROJECT_ROOT}
