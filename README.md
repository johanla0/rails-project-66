### Hexlet tests and linter status:
[![Actions Status](https://github.com/johanla0/rails-project-66/workflows/hexlet-check/badge.svg)](https://github.com/johanla0/rails-project-66/actions)
[![Ruby on Rails CI](https://github.com/johanla0/rails-project-66/actions/workflows/rubyonrails.yml/badge.svg)](https://github.com/johanla0/rails-project-66/actions/workflows/rubyonrails.yml)

## What is it?
Repository Quality Analyzer service. Sign in, choose your github repo, see what linter says, fix, repeat.
- check model relies on the state machine
- shallow clones repository (only the latest commit)
- uses custom linter and formatter libraries for pretty output

## App can be found here
https://rails-project-66.onrender.com/

## Development
### Install locally (no docker containers currently)

`make install`

### Start a new branch

`make branch feature_name`

### Run sidekiq

`make sidekiq`

### Bundle js and watch the stimulus controllers directory

`make esbuild`

### Check styles (slim, js, scss) and run tests (models, controllers) before pushing

`make check`

### Push

`make push`
