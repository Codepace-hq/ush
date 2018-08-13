require 'sinatra/base'
require "ush/db/sqlite"
module Ush
  # The sinatra app that runs ush
  class App < Sinatra::Base
    set :server, 'webrick'
    db = Ush::Sqlite.new

    get '/' do
      "Your 'ush' deployment seems to be working!"
    end

    get '/:code' do
      escaped = Addressable::URI.escape(params[:code])
      url = db.get_url_for_code(params[:code])
      puts url
      puts url.class
      if url.instance_of? NilClass
        status 404
        "path `#{escaped}` does not exist"
      else
        redirect url
      end
    end

    post '/' do
      if params[:code].nil? && !params[:url].nil?
        db.add_url(Ush::Adapter.parse_url(params[:url]), Ush::Adapter.shorten(params[:url]))
        response.headers['Location'] = File.join(request.url, Ush::Adapter.shorten(params[:url]))
      elsif params[:url].nil?
        status 400
        "'url' parameter is not set"
      else

        if db.code_exists?(params[:code]) # If there is already a url shortened
          status 409
          return Ush::DuplicateCodeError.message(params[:url], params[:code])
        end
        db.add_url(Ush::Adapter.parse_url(params[:url]), params[:code])
        loc = File.join(request.url, params[:code])
        response.headers['Location'] = loc
        "Shortlink created at #{loc}"
      end
    end

    # Strips nasty characters in the given string. Used for parsing shortcodes.
    def simple_escape(s)
      s = s.to_s
      s.gsub! /<|>/, ''
      s
    end
  end
end