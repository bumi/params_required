module Railslove
  module ParamsRequired
    
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      
      def params_required(*args)
        class_inheritable_accessor :required_params
        options = args.extract_options!
        
        self.required_params ||= []
        self.required_params << args
        
        include Railslove::ParamsRequired::InstanceMethods
        
        self.prepend_before_filter :validate_params, options
      end
    end
    
    module InstanceMethods
      
      def validate_params
        required_params.each do |param|
          render(:nothing, :status => 404) unless param_present?(param)
        end
      end
      # params = :bavaria => {:germany => {:earth => true}}
      # required = :bavaria => {:germany => :earth}
      # param_present?({:bavaria => {:germany => :earth}}) #=> true
      # param_present?({:bavaria => {:germany => :mars}}) #=> false
      def param_present?(key_or_hash, hash_to_test= params)
        if key_or_hash.is_a?(Hash)
          key_or_hash.each do |key,value|
            return false unless hash_to_test.has_key?(key) && param_present?(value, hash_to_test[key])
          end
        else
          return false unless hash_to_test.has_key?(key_or_hash)
        end
        return true
      end
      
    end
  end
end