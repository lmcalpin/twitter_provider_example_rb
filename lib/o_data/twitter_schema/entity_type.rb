module OData
  module TwitterSchema
    class EntityType < OData::InMemorySchema::EntityType
      def initialize(schema, client, cls, options = {})
        super(schema, cls, {})
        @client = client
        # remove methods that we aren't interested in exposing via OData
        self.properties.delete_if { |x| x.name.end_with?('?') }
        self.properties.delete_if { |x| x.name == '[]' }
        self.properties.delete_if { |x| x.name.start_with?('to_') }
        self.properties.delete_if { |x| x.name.start_with?('attrs') }
      end
      
      def find_all(key_values = {}, options = nil)
        filters = OData::Core::Options.filters(options)
        screen_name_filter = filters.find_filter(:user)
        unless screen_name_filter.nil?
          raise FilterTooComplicatedException.new("user filter only supports eq") if screen_name_filter.operator != :eq
          screen_name = screen_name_filter.value.gsub("'", '')
        end
        @client.user_timeline(:screen_name => screen_name, :count=>35, :include_entities => true)
      end
      
      # return a string value for a property
      def stringify(prop, val)
        return val.user_name if (prop == 'user')
        val
      end
    end
  end
end
