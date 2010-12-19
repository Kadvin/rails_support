# puts "Enhance Rails to copy plugin resources..."

require "rails"

Rails.module_eval do
  class << self
    # Migrate for the hooked plugin
    def migrate(plugin, plugin_home = nil)
      plugin_home ||= File.join(Rails.root, "vendor" ,"plugins", plugin)
      ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
      db_migrate_path = File.join(plugin_home, "db/migrate/")
      ActiveRecord::Migrator.migrate(db_migrate_path, ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
    end
  end
end
