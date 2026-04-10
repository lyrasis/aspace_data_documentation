# frozen_string_literal: true

module AspaceDataTools
  module Doc
    class Rectype
      attr_reader :name, :schema

      class << self
        # @param model [String] like "JSONModel(:agent_family) uri" or
        #   "JSONModel(:extent) object"
        def from_model_ref(model)
          namematch = model.match(/^JSONModel\(:(.*)\) /)
          unless namematch
            fail("#{name}: No jsonmodel_type name extracted from #{model}")
          end

          ADT.get_rectype(namematch[1])
        end
      end

      # @param name [String] of JSON model/record type
      # @param schema [Hash]
      # @param mode [:top_record, :subrecord]
      def initialize(name, schema, mode: :top_record)
        @name = name
        @schema = schema
      end

      def fields
        schema["properties"].map { |prop, cfg| Field.new(prop, cfg, self) }
      end

      def norm
        fields.map(&:normalize_config)
          .uniq
      end

      def to_s
        "<##{self.class}:#{object_id.to_s(8)} name: #{name}>"
      end
      alias_method :inspect, :to_s
    end
  end
end
