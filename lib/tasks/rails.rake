namespace :rails do
  desc "Copy all plugin resources to public folder"
  task :copy_plugin_resources do
    plugins_home ||= File.join("vendor" ,"plugins")
    Dir["vendor/plugins/*"].each do |plugin|
      puts format("Copy plugin %s resources to Rails.public", plugin)
      # Workaround a problem with script/plugin and http-based repos.
      # See http://dev.rubyonrails.org/ticket/8189
      Dir.chdir(Dir.getwd.sub(/vendor.*/, '')) do
        Dir[File.join(plugin, "public/**/*")].each do |file|
          # skip svn or git
          next if file =~ /[\/\\]\.(svn|git|cvs)/
          next if file =~ /Thumbs\.db/
          relative = file.sub(File.join(plugin, "public/" ), "")
          relative = File.join(Rails.root, "public", relative)
          File.directory?(file) ?
            (FileUtils.mkdir(relative) unless File.exist?(relative)) :
            FileUtils.cp(file, relative )
        end
      end
    end
  end
end