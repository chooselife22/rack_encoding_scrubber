require "rack_encoding_scrubber/version"

class RackEncodingScrubber
  REGEX_UTF = /%u00\h{0,2}/
  REGEX_MB  = /%[a-fA-F]\h/
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
        if h = env[header]
          if h["%u00"]
            h.gsub!(REGEX_UTF, "")
          end
          if h[REGEX_MB] # check for byte
            tmp = CGI.unescape(h).force_encoding('utf-8')
            if !tmp.valid_encoding?
              env[header] = CGI.escape(tmp.scrub(''))
              if %w[REQUEST_PATH PATH_INFO REQUEST_URI].include? header
                env[header].gsub! '%2F', '/'
              end
            end
          end
        end
      end
    end
  end
end
