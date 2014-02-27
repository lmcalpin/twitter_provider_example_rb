module OData
  module TwitterSchema
    class EntityType < OData::InMemorySchema::EntityType
      def initialize(schema, client, cls, options = {})
        super(schema, cls, options)
        @client = client
        # remove methods that we aren't interested in exposing via OData
        self.properties.delete_if { |x| x.name.end_with?('?') }
        self.properties.delete_if { |x| x.name == '[]' }
        self.properties.delete_if { |x| x.name.start_with?('to_') }
        self.properties.delete_if { |x| x.name.start_with?('attrs') }
      end
      
      def find_all(key_values = {}, options = nil)
        filters = OData::Core::Options.filters(options)
        tweets = []
        user_specified = false
        unless filters.nil?
          user_filter = filters.find_filter(:user)
          user_filter.each do |user| 
            user_specified = true
            p user.value
            tweets << @client.user_timeline(user.value, :count=>20, :include_entities=>true)
          end
        end
        tweets << @client.home_timeline(:count=>100, :include_entities=>true) unless user_specified
        tweets.flatten
      end
      
      # return a string value for a property
      def stringify(prop, val)
        return val.user_name if (prop == 'user')
        val
      end
    end
  end
end
