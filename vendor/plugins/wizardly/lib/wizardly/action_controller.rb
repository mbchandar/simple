require 'wizardly/wizard'

module Wizardly
  module ActionController
    def self.included(base)
      base.extend(ClassMethods)
      
      base.class_eval do
        before_filter :guard_entry
        class << self
          attr_reader :wizard_config #note: reader for @wizard_config on the class (not the instance)
        end
        hide_action :reset_wizard_session_vars, :wizard_config, :methodize_button_name
      end
    end

    module ClassMethods
      private
      def configure_wizard_for_model(model, opts={}, &block)
        
        # controller_name = self.name.sub(/Controller$/, '').underscore.to_sym
        @wizard_config = Wizardly::Wizard::Configuration.create(controller_name, model, opts, &block)
        # define methods
        self.class_eval @wizard_config.print_page_action_methods
        self.class_eval @wizard_config.print_callbacks
        self.class_eval @wizard_config.print_helpers
        self.class_eval @wizard_config.print_callback_macros
      end
    end

    # instance methods for controller
    public
    def wizard_config; self.class.wizard_config; end

  end
end