module CanvasCustomizePasswords
  class Engine < ::Rails::Engine
    isolate_namespace CanvasCustomizePasswords

    config.to_prepare do
      Canvas::Plugin.register(:canvas_customize_passwords, nil, {
        name: "Canvas Customize Passwords",
        author: "Atomic Jolt",
        description: "Enables custom password requirements",
        version: "1.0.0",
        select_text: "Canvas Customize Passwords 1.0.0",
        settings_partial: 'canvas_customize_passwords/plugin_settings'
      })

      if ActiveRecord::Base.connection.table_exists?('plugin_settings') && Canvas::Plugin.find(:canvas_customize_passwords).enabled?
        plugin = PluginSetting.find_by(name: "canvas_customize_passwords")
        Canvas::PasswordPolicy.define_singleton_method :default_policy do
          {
            :max_repeats => plugin.settings[:max_repeats] || 2,
            :max_sequence => plugin.settings[:max_sequence] || 3,
            :disallow_common_passwords => (plugin.settings[:disallow_common_passwords] == 1) || true,
            :min_length => plugin.settings[:min_length] || 12,
          }
        end

        message_path = File.join(Rails.root.to_s, 'gems', 'plugins', 'canvas_customize_passwords', 'messages')
        Canvas::MessageHelper.add_message_path(message_path)
      end
    end
  end
end
