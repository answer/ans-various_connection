# -*- coding: utf-8 -*-

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

      # Class.new のあと、すぐに定数に置かないと class_eval 時に内部で使いまわされる気がする
      base = Class.new(ActiveRecord::Base)
      Ans::VariousConnection::ConnectionPool.const_set name.to_s.camelize, base
      connection_bases[name] = base

      base.class_eval do
        self.abstract_class = true
        establish_connection :"#{name}_#{Rails.env}"
      end
    end
    def self.connection_bases
      @connection_bases ||= {}
    end

    def self.included(m)
      class_methods = Module.new
      m.const_set :AnsVariousConnectionClassMethods, class_methods
      m.send :extend, class_methods

      class_name = m.to_s

      sub_classes = {}
      Ans::VariousConnection.connection_bases.each do |name,connection_base|
        sub = Class.new(connection_base)
        m.const_set name.to_s.camelize, sub
        sub_classes[name] = sub

        sub.class_eval do
          self.table_name = class_name.underscore.pluralize
        end
      end

      class_methods.class_eval do
        define_method :connections do
          sub_classes
        end
        define_method :[] do |key|
          sub_classes[key]
        end
        define_method :for_all_connection do |&block|
          sub_classes.each do |name,sub|
            sub.class_exec name,&block
          end
        end
      end
    end

  end
end
