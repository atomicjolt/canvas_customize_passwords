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
        min_length = plugin.settings[:min_length].present? ? plugin.settings[:min_length].to_i : 12
        max_repeats = plugin.settings[:max_repeats].present? ? plugin.settings[:max_repeats].to_i : 2
        max_sequence = plugin.settings[:max_sequence].present? ? plugin.settings[:max_sequence].to_i : 3
        disallow_common_passwords = plugin.settings[:disallow_common_passwords].to_i == 1
        enforce_password_composition_rules = plugin.settings[:enforce_password_composition_rules].to_i == 1
        Canvas::PasswordPolicy.define_singleton_method :default_policy do
          {
            :max_repeats => max_repeats,
            :max_sequence => max_sequence,
            :disallow_common_passwords => disallow_common_passwords,
            :min_length => min_length,
            :enforce_password_composition_rules => enforce_password_composition_rules,
          }
        end

        message_path = File.join(Rails.root.to_s, 'gems', 'plugins', 'canvas_customize_passwords', 'messages')
        Canvas::MessageHelper.add_message_path(message_path)
      end
    end
  end
end
