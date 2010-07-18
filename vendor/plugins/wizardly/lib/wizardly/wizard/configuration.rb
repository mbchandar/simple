require 'wizardly/wizard/utils'
require 'wizardly/wizard/dsl'
require 'wizardly/wizard/button'
require 'wizardly/wizard/page'
require 'wizardly/wizard/configuration/methods'

module Wizardly
  module Wizard
    class Configuration
      include TextHelpers
      attr_reader :pages, :completed_redirect, :canceled_redirect, :controller_path, :controller_class_name, :controller_name, :page_order
      
      #enum_attr :persistance, %w(sandbox session database)

      def initialize(controller, opts) #completed_redirect = nil, canceled_redirect = nil)
        @controller_class_name = controller.to_s.camelcase
        @controller_class_name += 'Controller' unless @controller_class_name =~ /Controller$/
        @controller_path = @controller_class_name.sub(/Controller$/,'').underscore
        @controller_name = @controller_class_name.demodulize.sub(/Controller$/,'').underscore
        @completed_redirect = opts[:completed] || opts[:when_completed] || opts[:redirect] #format_redirect(completed_redirect)
        @canceled_redirect = opts[:canceled] || opts[:when_canceled] || opts[:redirect]
        @include_skip_button = opts[:skip] || opts[:allow_skip] || opts[:allow_skipping] || false
        @include_cancel_button = opts.key?(:cancel) ? opts[:cancel] : true
        @guard_entry = opts.key?(:guard) ? opts[:guard] : true
        @password_fields = opts[:mask_fields] || opts[:mask_passwords] || [:password, :password_confirmation]
        @persist_model = opts[:persist_model] || :per_page
        @form_data = opts[:form_data] || :session
        raise(ArgumentError, ":persist_model option must be one of :once or :per_page", caller) unless [:once, :per_page].include?(@persist_model)
        raise(ArgumentError, ":form_data option must be one of :sandbox or :session", caller) unless [:sandbox, :session].include?(@form_data)
        @page_order = []
        @pages = {}
        @buttons = nil
        @default_buttons = Hash[*[:next, :back, :cancel, :finish, :skip].collect {|default| [default, Button.new(default)] }.flatten]
      end

      def guard?; @guard_entry; end
      def persist_model_per_page?; @persist_model == :per_page; end
      def form_data_keep_in_session?; @form_data == :session; end
      def model; @wizard_model_sym; end
      def model_instance_variable; "@#{@wizard_model_sym.to_s}"; end
      def model_class_name; @wizard_model_class_name; end
      def model_const; @wizard_model_const; end

      def first_page?(name); @page_order.first == name; end
      def last_page?(name); @page_order.last == name; end
      def next_page(name)
        index = @page_order.index(name)
        index += 1 unless self.last_page?(name)
        @page_order[index]
      end
      def previous_page(name)
        index = @page_order.index(name)
        index -= 1 unless self.first_page?(name)
        @page_order[index]
      end
      def button_for_function(name); @default_buttons[name]; end
      def buttons
        return @buttons if @buttons
        # reduce buttons
        @buttons = Hash[*@default_buttons.collect{|k,v|[v.id, v]}.flatten]
      end
    
      def self.create(controller_name, model_name, opts={}, &block)
        # controller_name = controller_name.to_s.underscore.sub(/_controller$/, '').to_sym
        model_name = model_name.to_s.underscore.to_sym
        config = Wizardly::Wizard::Configuration.new(controller_name, opts)
        config.inspect_model!(model_name)
        Wizardly::Wizard::DSL.new(config).instance_eval(&block) if block_given?
        config
      end

    
      def inspect_model!(model)
        # first examine the model symbol, transform and see if the constant
        # exists
        begin
          @wizard_model_sym = model.to_sym
          @wizard_model_class_name = model.to_s.camelize
          @wizard_model_const = @wizard_model_class_name.constantize
        rescue Exception=>e
          raise ModelNotFoundError, "Cannot convert :#{@wizard_model_sym} to model constant for #{@wizard_model_class_name}: " + e.message, caller
        end

        begin
          @page_order = @wizard_model_const.validation_group_order 
        rescue Exception => e
          raise ValidationGroupError, "Unable to read validation groups from #{@wizard_model_class_name}: " + e.message, caller
        end
        raise(ValidationGroupError, "No validation groups defined for model #{@wizard_model_class_name}", caller) unless (@page_order && !@page_order.empty?)

        begin
          groups = @wizard_model_const.validation_groups
          enum_attrs = @wizard_model_const.respond_to?(:enumerated_attributes) ? @wizard_model_const.enumerated_attributes.collect {|k,v| k } : []
          model_inst = @wizard_model_const.new
          last_index = @page_order.size-1
          @page_order.each_with_index do |p, index|
            fields = groups[p].map do |f|
              column = model_inst.column_for_attribute(f)
              type = case
              when enum_attrs.include?(f) then :enum
              when (@password_fields && @password_fields.include?(f)) then :password
              else
                column ? column.type : :string
              end
              PageField.new(f, type)
            end
            page = Page.new(self, p, fields)

            # default button settings based on order, can be altered by
            # set_page(@id).buttons_to []
            buttons = []
            buttons << @default_buttons[:next] unless index >= last_index
            buttons << @default_buttons[:finish] if index == last_index
            buttons << @default_buttons[:back] unless index == 0
            buttons << @default_buttons[:skip] if (@include_skip_button && index != last_index)
            buttons << @default_buttons[:cancel] if (@include_cancel_button)
            page.buttons = buttons
            @pages[page.id] = page
          end
        rescue Exception => e
          raise ValidationGroupError, "Failed to configure wizard from #{@wizard_model_class_name} validation groups: " + e.message, caller
        end
      end

      public
      # internal DSL method handlers
      def _when_completed_redirect_to(redir); @completed_redirect = redir; end
      def _when_canceled_redirect_to(redir); @canceled_redirect = redir; end
      def _change_button(name)
        raise(WizardConfigurationError, "Button :#{name} in _change_button() call does not exist", caller) unless self.buttons.key?(name)
        _buttons = self.buttons
        @buttons = nil # clear the buttons for regeneration after change in next line
        _buttons[name]
      end
      def _create_button(name, opts)
        id = opts[:id] || button_name_to_symbol(name)
        raise(WizardConfigurationError, "Button '#{name}' with id :#{id} cannot be created. The ID already exists.", caller) if self.buttons.key?(id)
        @buttons=nil
        @default_buttons[id] = UserDefinedButton.new(id, name)
      end
      def _set_page(name); @pages[name]; end
      def _mask_passwords(passwords)
        case passwords
        when String
          passwords = [passwords.to_sym]
        when Symbol
          passwords = [passwords]
        when Array
        else
          raise(WizardlyConfigurationError, "mask_passwords method only accepts string, symbol or array of password fields")
        end
        @password_fields.push(*passwords).uniq!
      end
      
      def print_config
        io = StringIO.new
        class_name = controller_name.to_s.camelize
        class_name += 'Controller' unless class_name =~ /Controller$/
        io.puts "#{class_name} wizard configuration"
        io.puts
        io.puts "model: #{model_class_name}"
        io.puts "instance: @#{model}"
        io.puts
        io.puts "pages:"
        self.page_order.each do |pid|
          page = pages[pid]
          # io.puts "  #{index+1}. '#{page.title}' page (:#{page.id}) has"
          io.puts "  '#{page.title}' page (:#{page.id}) has"
          io.puts "    --fields: #{page.fields.inject([]){|a, f| a << '"'+f.name.to_s.titleize+'" [:'+f.column_type.to_s+']'}.join(', ')}"
          io.puts "    --buttons: #{page.buttons.inject([]){|a, b| a << b.name.to_s }.join(', ')}"
        end
        io.puts
        io.puts "redirects:"
        io.puts "  when completed: #{completed_redirect ? completed_redirect.inspect : 'redirects to initial referer by default (specify :completed=>url to override)'}"
        io.puts "  when canceled: #{canceled_redirect ? canceled_redirect.inspect : 'redirects to initial referer by default (specify :canceled=>url to override)'}"
        io.puts   
        io.puts "buttons:"
        self.buttons.each do |k, b|
          bs = StringIO.new
          bs << "  #{b.name} (:#{b.id}) "
          if (b.user_defined?)
            bs << "-- user defined button and function"
          else
            dk = @default_buttons.index(b)
            bs << "-- used for internal <#{dk}> functionality"
          end
          io.puts bs.string
        end
        io.puts 
        io.string      
      end    
    end
  end    
end
