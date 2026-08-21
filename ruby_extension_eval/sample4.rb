require 'redis'

class CacheManager
  DEFAULT_TTL = 3600

  def initialize
    @redis = Redis.new
  end

  def get(key)
    value = @redis.get(key)
    return nil if value.nil?
    JSON.parse(value)
  end

  def set(key, value, ttl = DEFAULT_TTL)
    @redis.setex(key, ttl, value.to_json)
  end

  def delete(key)
    @redis.del(key)
  end

  def fetch(key, ttl = DEFAULT_TTL)
    cached = get(key)
    return cached unless cached.nil?
    fresh = yield
    set(key, fresh, ttl)
    fresh
  end

  def clear_pattern(pattern)
    keys = @redis.keys(pattern)
    @redis.del(*keys) unless keys.empty?
  end
end
