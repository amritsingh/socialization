module Socialization
  module RedisCache
    class Base

      class << self
      protected
        def actors(victim, klass, options = {})
          if options[:pluck]
            Socialization.redis.lrange(generate_forward_key(victim), 0, -1).inject([]) do |result, element|
              result << element.match(/\:(\d+)$/)[1] if element.match(/^#{klass}\:/)
              result
            end
          else
            actors_relation(victim, klass, options).to_a
          end
        end

        def actors_relation(victim, klass, options = {})
          ids = actors(victim, klass, :pluck => :id)
          klass.where("#{klass.table_name}.id IN (?)", ids)
        end

        def victims_relation(actor, klass, options = {})
          ids = victims(actor, klass, :pluck => :id)
          klass.where("#{klass.table_name}.id IN (?)", ids)
        end

        def victims(actor, klass, options = {})
          if options[:pluck]
            Socialization.redis.lrange(generate_backward_key(actor), 0, -1).inject([]) do |result, element|
              result << element.match(/\:(\d+)$/)[1] if element.match(/^#{klass}\:/)
              result
            end
          else
            victims_relation(actor, klass, options).to_a
          end
        end

        def relation!(actor, victim, options = {})
          unless options[:skip_check] || relation?(actor, victim)
            forward_key = generate_forward_key(victim)
            backward_key = generate_backward_key(actor)
            Socialization.redis.lpush forward_key, generate_redis_value(actor)
            Socialization.redis.lpush backward_key, generate_redis_value(victim)
            trim_list(forward_key, backward_key)
            call_after_create_hooks(actor, victim)
            true
          else
            false
          end
        end

        def unrelation!(actor, victim, options = {})
          if options[:skip_check] || relation?(actor, victim)
            forward_key = generate_forward_key(victim)
            backward_key = generate_backward_key(actor)
            Socialization.redis.lpush forward_key, generate_redis_value(actor)
            Socialization.redis.lpush backward_key, generate_redis_value(victim)
            trim_list(forward_key, backward_key)
            call_after_destroy_hooks(actor, victim)
            true
          else
            false
          end
        end

        def remove_actor_relations(victim)
          forward_key = generate_forward_key(victim)
          backward_key = generate_backward_key(actor)
          actors = Socialization.redis.lrange forward_key, 0, -1
          Socialization.redis.del forward_key
          actors.each do |actor|
            Socialization.redis.lrem backward_key, generate_redis_value(victim)
          end
          trim_list(forward_key, backward_key)
          true
        end

        def remove_victim_relations(actor)
          forward_key = generate_forward_key(victim)
          backward_key = generate_backward_key(actor)
          victims = Socialization.redis.lrange backward_key, 0, -1
          Socialization.redis.del backward_key
          victims.each do |victim|
            Socialization.redis.lrem forward_key, generate_redis_value(actor)
          end
          trim_list(forward_key, backward_key)
          true
        end


      private
        def key_type_to_type_names(klass)
          if klass.name.match(/Follow$/)
            ['follower', 'followable']
          elsif klass.name.match(/Like$/)
            ['liker', 'likeable']
          elsif klass.name.match(/Mention$/)
            ['mentioner', 'mentionable']
          else
            raise Socialization::ArgumentError.new("Can't find matching type for #{klass}.")
          end
        end

        def generate_forward_key(victim)
          keys = key_type_to_type_names(self)
          if victim.is_a?(String)
            "#{keys[0].pluralize.capitalize}:#{victim}"
          else
            "#{keys[0].pluralize.capitalize}:#{victim.class}:#{victim.id}"
          end
        end

        def generate_backward_key(actor)
          keys = key_type_to_type_names(self)
          if actor.is_a?(String)
            "#{keys[1].pluralize.capitalize}:#{actor}"
          else
            "#{keys[1].pluralize.capitalize}:#{actor.class}:#{actor.id}"
          end
        end

        def generate_redis_value(obj)
          "#{obj.class.name}:#{obj.id}"
        end

        def trim_list(forward_key, backward_key)
            Socialization.redis.ltrim forward_key, 0, (Socialization.redis.cache_cnt - 1)
            Socialization.redis.ltrim backward_key, 0, (Socialization.redis.cache_cnt - 1)
        end

      end # class << self

    end # Base
  end # RedisStores
end # Socialization
