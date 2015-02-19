module Socialization
  module ActiveRecordStoresWithCache 
    class Mention < ActiveRecord::Base

      class << self
        def mention!(mentioner, mentionable)
          ret_val = super(mentioner, mentionable)
          Socialization::RedisCache::Mention.mention!(mentioner, mentionable) if ret_val
          ret_val
        end

        def unmention!(mentioner, mentionable)
          ret_val = super(mentioner, mentionable)
          Socialization::RedisCache::Mention.unmention!(mentioner, mentionable) if ret_val
          ret_val
        end

        # Returns an ActiveRecord::Relation of all the mentioners of a certain type that are mentioning mentionable
        def mentioners_relation(mentionable, klass, opts = {})
          rel = Socialization::RedisCache::Mention.mentioners_relation(mentionable, klass, opts)
          rel = super(mentionable, klass, opts) if rel.blank?
          rel
        end

        # Returns all the mentioners of a certain type that are mentioning mentionable
        def mentioners(mentionable, klass, opts = {})
          rel = Socialization::RedisCache::Mention.mentioners(mentionable, klass, opts)
          rel = super(mentionable, klass, opts) if rel.blank?
          rel
        end

        # Returns an ActiveRecord::Relation of all the mentionables of a certain type that are mentioned by mentioner
        def mentionables_relation(mentioner, klass, opts = {})
          rel = Socialization::RedisCache::Mention.mentionables_relation(mentioner, klass, opts)
          rel = super(mentioner, klass, opts) if rel.blank?
          rel
        end

        # Returns all the mentionables of a certain type that are mentioned by mentioner
        def mentionables(mentioner, klass, opts = {})
          rel = Socialization::RedisCache::Mention.mentionables(mentioner, klass, opts)
          rel = super(mentioner, klass, opts) if rel.blank?
          rel
        end

        # Remove all the mentioners for mentionable
        def remove_mentioners(mentionable)
          super(mentionable)
          Socialization::RedisCache::Mention.remove_mentioners(mentionable)
        end

        # Remove all the mentionables for mentioner
        def remove_mentionables(mentioner)
          super(mentionable)
          Socialization::RedisCache::Mention.remove_mentionables(mentioner)
        end
    end
  end
end
