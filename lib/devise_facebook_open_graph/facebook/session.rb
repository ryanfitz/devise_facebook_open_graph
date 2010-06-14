# encoding: utf-8

require 'koala'

module DeviseFacebookOpenGraph
  module Facebook
    class Session
      #
      # Keys found in cookie content. We are supplying reader 
      # methods for these values which are read from cookie content
      #
      FACEBOOK_SESSION_KEYS = %w(session_key expires uid sig secret access_token)

      #
      # Creates a new Facebook session based cookies hash from a request
      #
      def initialize(cookies)
        @cookies = cookies
      end

      #
      # Returns facebook's cookie content
      #
      def cookie_content
        @cookie_content ||= parse_cookie
      end
      
      #
      # Gives access to query as user with an oauth access token fetched from the cookie content
      #
      def graph
        Koala::Facebook::GraphAPI.new(access_token)
      end


      #
      # Define reader methods for facebook session keys
      #
      FACEBOOK_SESSION_KEYS.each do |key|
        define_method key do
          cookie_content[key] if cookie_content
        end
      end

      #
      # Is this a valid session? True if we were able to parse facebook's cookie content
      #
      def valid?
        !!cookie_content
      end
      
      private
        def parse_cookie # :nodoc:
          oauth = Koala::Facebook::OAuth.new(Config.application_id, Config.application_secret)
          parsed = oauth.get_user_from_cookie(@cookies)
        end
    end
  end
end
