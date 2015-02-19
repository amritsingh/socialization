module Socialization
  module ActiveRecordStoresWithCache 
    class Follow < ActiveRecord::Base

      class << self
        def follow!(follower, followable)
          ret_val = super(follower, followable)
          Socialization::RedisCache::Follow.follow!(follower, followable) if ret_val
          ret_val
        end

        def unfollow!(follower, followable)
          ret_val = super(follower, followable)
          Socialization::RedisCache::Follow.unfollow!(follower, followable) if ret_val
          ret_val
        end

        # Returns an ActiveRecord::Relation of all the followers of a certain type that are following followable
        def followers_relation(followable, klass, opts = {})
          rel = Socialization::RedisCache::Follow.followers_relation(followable, klass, opts)
          rel = super(followable, klass, opts) if rel.blank?
          rel
        end

        # Returns all the followers of a certain type that are following followable
        def followers(followable, klass, opts = {})
          rel = Socialization::RedisCache::Follow.followers(followable, klass, opts)
          rel = super(followable, klass, opts) if rel.blank?
          rel
        end

        # Returns an ActiveRecord::Relation of all the followables of a certain type that are followed by follower
        def followables_relation(follower, klass, opts = {})
          rel = Socialization::RedisCache::Follow.followables_relation(follower, klass, opts)
          rel = super(follower, klass, opts) if rel.blank?
          rel
        end

        # Returns all the followables of a certain type that are followed by follower
        def followables(follower, klass, opts = {})
          rel = Socialization::RedisCache::Follow.followables(follower, klass, opts)
          rel = super(follower, klass, opts) if rel.blank?
          rel
        end

        # Remove all the followers for followable
        def remove_followers(followable)
          super(followable)
          Socialization::RedisCache::Follow.remove_followers(followable)
        end

        # Remove all the followables for follower
        def remove_followables(follower)
          super(followable)
          Socialization::RedisCache::Follow.remove_followables(follower)
        end

      end # class << self
    end
  end
end
