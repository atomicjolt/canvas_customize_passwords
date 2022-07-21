module CanvasCustomizePasswords
    module PasswordPolicy
      def self.validate(record, attr, value)
        policy = record.account.password_policy
        value = value.to_s
        if policy[:enforce_password_composition_rules]
          uppercase = !(value =~ /[A-Z]/)
          lowercase = !(value =~ /[a-z]/)
          numerical = !(value =~ /[0-9]/)
          # https://web.archive.org/web/20220616155452/https://owasp.org/www-community/password-special-characters
          special = !(value =~ /[\ \!\"\#\$\%\&\'\(\)\*\+\,\-\.\/\:\;\<\=\>\?\@\[\\\]\^\_\`\{\|\}\~]+/)
          record.errors.add attr, "too_simple" if [uppercase, lowercase, numerical, special].any?
        end
      end
    end
end
