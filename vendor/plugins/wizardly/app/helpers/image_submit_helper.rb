module ImageSubmitHelper
  
  def wizardly_submit
    @@wizardly_submit ||= {}
    step_id = "#{controller_name}_#{@step}".to_sym
    unless @@wizardly_submit[step_id]
      buttons = @wizard.pages[@step].buttons
      @@wizardly_submit[step_id] = buttons.inject(StringIO.new) do |io, button|
        io << submit_tag(button.name)
      end.string
    end
    @@wizardly_submit[step_id]
  end
  
  def wizardly_image_submit(asset_dir = nil, opts = {})
    @@wizardly_image_submit ||={}
    step_id = "#{controller_name}_#{@step}".to_sym
    unless @@wizardly_image_submit[step_id]
      asset_dir = asset_dir ? "#{asset_dir}/".squeeze("/").sub(/^\//,'') : "wizardly/"
      buttons = @wizard.pages[@step].buttons
      opts[:name] = 'commit'
      @@wizardly_image_submit[step_id] = buttons.inject(StringIO.new) do |io, button|
        opts[:value] = button.name
        io << image_submit_tag("#{asset_dir}#{button.id}.png", opts)
      end.string
    end
    @@wizardly_image_submit[step_id]
  end
  
end
