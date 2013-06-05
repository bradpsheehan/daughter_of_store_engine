uri = Redis.connect(:url => ENV['REDISTOGO_URL']) 
Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
