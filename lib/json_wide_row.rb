require_relative 'config'
require_relative 'class_methods'

module Sequel
  module Plugins
    module JsonWideRow
      def self.configure(model, opts)
        config = Config.new
        config.json_column = opts.fetch(:json_column)
        config.extra_fields = opts.fetch(:extra_fields)

        model.instance_eval do
          @json_wide_row_config = config

          class << self
            attr_accessor :json_wide_row_config 
          end

          config.extra_fields.each do |field|
            field_str = field.to_s
            define_method "#{field}" do
              self.send(config.json_column)[field_str]
            end

            define_method("#{field}=") do |val|
              json_column_val = self.send(config.json_column) || {}
              self.send("#{config.json_column}=", json_column_val)
              json_column_val[field_str] = val
            end
          end
        end
      end
    end
  end
end
