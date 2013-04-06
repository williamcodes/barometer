module Barometer
  module Converter
    class FromWeatherIdToGeocode
      def initialize(query)
        @query = query
      end

      def call
        return unless can_convert?

        response = WebService::WeatherID.reverse(@query)
        @query.add_conversion(:geocode, format_response(response))
      end

      private

      def can_convert?
        !!@query.get_conversion(:weather_id)
      end

      def format_response(response)
        [response["city"], response["region"], response["country"]].select{|r|!r.empty?}.join(', ')
      end
    end
  end
end