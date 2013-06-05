uri = URI.parse("redis://redistogo:eb5a38c51510d22f3574b6e098f55ffb@cod.redistogo.com:9563/")
REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
