module OData
  module TwitterSchema
    class Base < OData::InMemorySchema::Base
      def initialize(namespace, client, options = {})
        super(namespace)
        @client = client
        self.register(Twitter::Tweet, :id)
      end

      def EntityType(*args)
        entity_type = EntityType.new(self, @client, *args)
        @entity_types << entity_type
        entity_type
      end
    end
  end
end
