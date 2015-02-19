%w(
  lib/*.rb
  stores/mixins/base.rb
  stores/mixins/**/*.rb
  stores/active_record/mixins/base.rb
  stores/active_record/mixins/**/*.rb
  stores/redis/mixins/base.rb
  stores/redis/mixins/**/*.rb
  cache/redis/mixins/base.rb
  cache/redis/mixins/**/*.rb
  stores/active_record/**/*.rb
  stores/active_record_with_redis_cache/**/*.rb
  stores/redis/base.rb
  stores/redis/**/*.rb
  cache/redis/base.rb
  cache/redis/**/*.rb
  actors/**/*.rb
  victims/**/*.rb
  helpers/**/*.rb
  config/**/*.rb
).each do |path|
  Dir["#{File.dirname(__FILE__)}/socialization/#{path}"].each { |f| require(f) }
end

ActiveRecord::Base.send :include, Socialization::ActsAsHelpers
