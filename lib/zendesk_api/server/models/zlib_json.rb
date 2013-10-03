module ZendeskAPI::Server
  class ZlibJSON < Hash
    class << self
      def demongoize(serialized_object)
        MultiJson.load(Zlib.inflate(serialized_object.to_s), :symbolize_keys => true)
      end

      def mongoize(input_hash)
        Moped::BSON::Binary.new(:generic, Zlib.deflate(input_hash.to_json))
      end
    end
  end
end
