require "ans/various_connection/version"

module Ans
  module VariousConnection
    module ConnectionPool; end

    def self.establish_connections(names)
      names.each do |name|
        establish_connection name
      end
    end
    def self.establish_connection(name)
      name = name.to_sym
      base = Class.new(ActiveRecord::Base)
      base.class_eval do
        self.abstract_class = true
        establish_connection :"#{name}_#{Rails.env}"
      end
      connection_bases[name] = base
      Ans::VariousConnection::ConnectionPool.const_set name.to_s.camelize, base
    end
    def self.connection_bases
      @connection_bases ||= {}
    end

    def self.included(m)
      class_methods = Module.new
      m.const_set :AnsVariousConnectionClassMethods, class_methods
      m.send :extend, class_methods

      class_name = m.to_s

      connection_classes = {}
      Ans::VariousConnection.connection_bases.each do |name,connection_base|
        connection_class = Class.new(connection_base)
        connection_class.class_eval do
          self.table_name = class_name.underscore.pluralize
        end
        connection_classes[name] = connection_class
        m.const_set name.to_s.camelize, connection_class
      end

      class_methods.class_eval do
        define_method :connections do
          connection_classes
        end
        define_method :for_all_connection do |&block|
          connection_classes.each do |name,connection_class|
            connection_class.class_eval &block
          end
        end
      end
    end

  end
end
