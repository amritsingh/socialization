module Socialization
  class << self
    def redis
      @redis ||= Redis.new
    end

    def redis=(redis)
      @redis = redis
    end

    def cache_cnt
      @cache_cnt ||= 100
    end

    def cache_cnt=(cache_cnt)
      @cache_cnt = cache_cnt
    end
  end
end
