require 'mina/bundler'
require 'mina/rails'

namespace :puma do
  set :web_server, :puma

  set_default :puma_config,    -> { "#{deploy_to}/#{shared_path}/config/puma.rb" }
  set_default :pumactl_cmd,    -> { "#{bundle_prefix} pumactl" }

  desc 'Start puma'
  task :start => :environment do
    pumactl_command 'start'
  end

  desc 'Stop puma'
  task stop: :environment do
    pumactl_command 'stop'
  end

  desc 'Restart puma'
  task restart: :environment do
    pumactl_command 'restart'
  end

  desc 'Restart puma (phased restart)'
  task phased_restart: :environment do
    pumactl_command 'phased-restart'
  end

  desc 'Restart puma (hard restart)'
  task hard_restart: :environment do
    invoke 'puma:stop'
    invoke 'puma:start'
  end

  desc 'Get status of puma'
  task status: :environment do
    pumactl_command 'status'
  end

  def pumactl_command(command)
    queue! %[
      cd #{deploy_to}/#{current_path} && #{pumactl_cmd} -F #{puma_config} #{command}
    ]
  end
end
