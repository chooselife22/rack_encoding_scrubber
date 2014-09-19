require "rack_encoding_scrubber/version"

class RackEncodingScrubber
  def initialize(app)
    @app = app
  end

  def call(env)
    encode env
    @app.call(env)
  end

  def encode(env)
    request_method = env['REQUEST_METHOD']
    if request_method == 'GET'
      %w[QUERY_STRING REQUEST_PATH PATH_INFO QUERY_STRING REQUEST_URI ORIGINAL_FULLPATH].each do |header|
        if env[header] and env[header]["%u00"]
          env[header].gsub!(/%u00\h{0,2}/, "")
          env[header].gsub!(/%\h{0,2}/,"")
        end
      end
    end
  end
end
