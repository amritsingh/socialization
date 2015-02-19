module Socialization
  module ActiveRecordStoresWithCache 
    class Like < Socialization::ActiveRecordStores::Like

      class << self
        def like!(liker, likeable)
          ret_val = super(liker, likable)
          Socialization::RedisCache::Like.like!(liker, likeable)  if ret_val
          ret_val
        end

        def unlike!(liker, likeable)
          ret_val = super(liker, likable)
          Socialization::RedisCache::Like.unlike!(liker, likeable)  if ret_val
          ret_val
        end

        # Returns an ActiveRecord::Relation of all the likers of a certain type that are liking  likeable
        def likers_relation(likeable, klass, opts = {})
          rel = Socialization::RedisCache::Like.likers_relation(likeable, klass, opts)
          rel = super(likeable, klass, opts) if rel.blank?
          rel
        end

        # Returns all the likers of a certain type that are liking  likeable
        def likers(likeable, klass, opts = {})
          rel = Socialization::RedisCache::Like.likers(likeable, klass, opts)
          rel = super(likeable, klass, opts) if rel.blank?
          rel
        end

        # Returns an ActiveRecord::Relation of all the likeables of a certain type that are liked by liker
        def likeables_relation(liker, klass, opts = {})
          rel = Socialization::RedisCache::Like.likeables_relation(liker, klass, opts)
          rel = super(liker, klass, opts) if rel.blank?
          rel
        end

        # Returns all the likeables of a certain type that are liked by liker
        def likeables(liker, klass, opts = {})
          rel = Socialization::RedisCache::Like.likeables(liker, klass, opts)
          rel = super(liker, klass, opts) if rel.blank?
          rel
        end

        # Remove all the likers for likeable
        def remove_likers(likeable)
          super(likeable)
          Socialization::RedisCache::Like.remove_likers(likeable)
        end

        # Remove all the likeables for liker
        def remove_likeables(liker)
          super(liker)
          Socialization::RedisCache::Like.remove_likeables(liker)
        end
      end # class << self
    end
  end
end
