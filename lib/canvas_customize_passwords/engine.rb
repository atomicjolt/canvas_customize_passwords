# Copyright (C) 2022 Atomic Jolt

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

module CanvasCustomizePasswords
  NAME = "Canvas Customize Passwords".freeze
  DISPLAY_NAME = "Enables custom password requirements".freeze
  DESCRIPTION = "Enables custom password requirements".freeze

  class Engine < ::Rails::Engine
    config.paths["lib"].eager_load!

    config.to_prepare do
      Canvas::Plugin.register(
        :canvas_customize_passwords,
        nil,
        name: -> { I18n.t(:canvas_fips_name, NAME) },
        display_name: -> { I18n.t :canvas_fips_display, DISPLAY_NAME },
        author: "Atomic Jolt",
        author_website: "http://www.atomicjolt.com/",
        description: -> { t(:description, DESCRIPTION) },
        version: CanvasCustomizePasswords::VERSION,
        settings_partial: 'canvas_customize_passwords/plugin_settings'
      )

      if ActiveRecord::Base.connection.table_exists?('plugin_settings') && Canvas::Plugin.find(:canvas_customize_passwords).enabled?
        Canvas::PasswordPolicy.define_singleton_method :default_policy do
          @plugin ||= PluginSetting.find_by(name: "canvas_customize_passwords")
          min_length = @plugin.settings[:min_length].present? ? @plugin.settings[:min_length].to_i : 12
          max_repeats = @plugin.settings[:max_repeats].present? ? @plugin.settings[:max_repeats].to_i : 2
          max_sequence = @plugin.settings[:max_sequence].present? ? @plugin.settings[:max_sequence].to_i : 3
          disallow_common_passwords = @plugin.settings[:disallow_common_passwords].to_i == 1
          enforce_password_composition_rules = @plugin.settings[:enforce_password_composition_rules].to_i == 1
          {
            :max_repeats => max_repeats,
            :max_sequence => max_sequence,
            :disallow_common_passwords => disallow_common_passwords,
            :min_length => min_length,
            :enforce_password_composition_rules => enforce_password_composition_rules,
          }
        end

        Canvas::PasswordPolicy.define_singleton_method :validate_original, &Canvas::PasswordPolicy.method(:validate)

        Canvas::PasswordPolicy.define_singleton_method :validate do |record, attr, value|
          CanvasCustomizePasswords::PasswordPolicy.validate(record, attr, value)
          validate_original(record, attr, value)
        end

        message_path = File.join(Rails.root.to_s, 'gems', 'plugins', 'canvas_customize_passwords', 'messages')
        Canvas::MessageHelper.add_message_path(message_path)
      end

    end
  end
end
