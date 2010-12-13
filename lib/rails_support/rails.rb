# puts "Enhance Rails to copy plugin resources..."

require "rails"

Rails.module_eval do
  class << self
    # Copy plugin's resource to rails root
    def copy_plugin_resources(plugin, plugin_home = nil)
      cpr = ENV["copy_plugin_resources"] || ENV["copy_plugin_resource"] || "false"
      return if not cpr.downcase == "true"

      plugin_home ||= File.join(Rails.root, "vendor" ,"plugins", plugin)
      Rails.logger.info("Copy plugin %s resources to Rails.public", plugin)
      # Workaround a problem with script/plugin and http-based repos.
      # See http://dev.rubyonrails.org/ticket/8189
      Dir.chdir(Dir.getwd.sub(/vendor.*/, '')) do
        Dir[File.join(plugin_home, "public/**/*")].each do |file|
          # skip svn or git
          next if file =~ /[\/\\]\.(svn|git|cvs)/
          next if file =~ /Thumbs\.db/
          relative = file.sub(File.join(plugin_home, "public/" ), "")
          relative = File.join(Rails.root, "public", relative)
          File.directory?(file) ?
            (FileUtils.mkdir(relative) unless File.exist?(relative)) :
            FileUtils.cp(file, relative )
        end
      end
    end

    # Migrate for the hooked plugin
    def migrate(plugin, plugin_home = nil)
      plugin_home ||= File.join(Rails.root, "vendor" ,"plugins", plugin)
      ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
      db_migrate_path = File.join(plugin_home, "db/migrate/")
      ActiveRecord::Migrator.migrate(db_migrate_path, ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
    end
  end
end
