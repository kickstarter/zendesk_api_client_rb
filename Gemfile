source 'https://rubygems.org'

# gem "bundler", "~> 1.2.0"
# ruby "1.9.3"

gem "simplecov", :platforms => :ruby_19, :group => :test
gem "jruby-openssl", :platforms => :jruby
gem "multipart-post", :git => "https://github.com/steved555/multipart-post.git"

group :server do
  gem "thin"

  gem "rack-ssl-enforcer"

  gem "sinatra"
  gem "sinatra-contrib"

  gem "haml"

  gem "compass"
  gem "bootstrap-sass"

  gem "coderay"
  gem "coderay_bash"

  gem "redcarpet"

  gem "mongoid"
  gem "database_cleaner"

  gem "newrelic_rpm"
end

group :console do
  gem "ripl"
end

gem "json", :group => :test, :platform => :ruby_18

gemspec
