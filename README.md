Forked to show pundit issue with cache in tests: https://github.com/varvet/pundit/issues/470

### Setup

```
bundle install
bundle rails db:create db:migrate
```

### Test Case

```
bundle exec rspec ./spec/controllers/vistors_controller_spec.rb
```
