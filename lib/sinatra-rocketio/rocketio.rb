module Sinatra
  module RocketIO

    def self.push(type, data, opt={})
      Sinatra::CometIO.push type, data, opt
      Sinatra::WebSocketIO.push type, data, opt
    end

    def self.sessions
      {
        :websocket => Sinatra::WebSocketIO.sessions,
        :comet => Sinatra::CometIO.sessions
      }
    end

  end
end
EventEmitter.apply Sinatra::RocketIO
Sinatra::CometIO.on :* do |event_name, *args|
  if args.size > 1
    Sinatra::RocketIO.emit event_name, args[0], args[1], :comet
  else
    Sinatra::RocketIO.emit event_name, args[0], :comet
  end
end
Sinatra::WebSocketIO.on :* do |event_name, *args|
  if args.size > 1
    Sinatra::RocketIO.emit event_name, args[0], args[1], :websocket
  else
    Sinatra::RocketIO.emit event_name, args[0], :websocket
  end
end