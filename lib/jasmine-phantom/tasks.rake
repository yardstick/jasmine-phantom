require 'jasmine-phantom/server'

namespace :jasmine do
  namespace :phantom do
    desc "Run jasmine specs using phantomjs and report the results"
    task :ci => "jasmine:require" do
      require 'spoon'
      jasmine_config_overrides = File.join(Jasmine::Config.new.project_root, 'spec', 'javascripts' ,'support' ,'jasmine_config.rb')
      require jasmine_config_overrides if File.exist?(jasmine_config_overrides)

      port = Jasmine::Phantom::Server.start
      script = File.join File.dirname(__FILE__), 'run-jasmine.js'

      phantomjs = ENV['PATH'].split(':').map { |path| "#{path}/phantomjs" }.detect { |bin| File.executable?(bin) }

      if phantomjs.nil?
        raise 'phantomjs not in your PATH. wat are you even doing?'
      end

      pid = Spoon.spawn(phantomjs, script, "http://localhost:#{port}")
      wait_pid, status = Process.waitpid2(pid)
      exit(1) unless status.success?
    end
  end
end
