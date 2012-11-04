require 'bundler/setup'
Bundler.require(:default, :development)

require 'capistrano_colors'

set :bundle_cmd, '. /etc/profile && bundle'
require "bundler/capistrano"

require 'yaml'
require 'erb'

require File.expand_path(File.join('lib', 'initialisers', 'init'))

set :application, "Dashboard"
set :repository, $CONFIG.deploy.repo.url
set :branch, $CONFIG.deploy.repo.branch

set :scm, :git
set :scm_verbose, true

set :deploy_to, "#{$CONFIG.deploy.base}/#{$CONFIG.deploy.name}"
set :deploy_via, :remote_cache

set :keep_releases, 3
set :use_sudo, false
set :normalize_asset_timestamps, false

set :user, $CONFIG.deploy.ssh_user
ssh_options[:port] = $CONFIG.deploy.ssh_port
ssh_options[:keys] = eval($CONFIG.deploy.ssh_key)
ssh_options[:forward_agent] = true

role :app, $CONFIG.deploy.ssh_host

after "deploy:update", "deploy:cleanup"
after "deploy:setup", "deploy:more_setup"

before "deploy:create_symlink",
  "deploy:configs",
  "nginx:config",
  "nginx:reload"

require 'capistrano-unicorn'

namespace :deploy do

  desc 'More setup.. ensure necessary directories exist, etc'
  task :more_setup do
    run "mkdir -p #{shared_path}/tmp/pids #{shared_path}/config #{shared_path}/config/unicorn"
  end

  desc 'Deploy necessary configs into shared/config'
  task :configs do
    put $CONFIG.reject { |x| x == 'deploy' }.to_yaml, "#{shared_path}/config/config.yml"
    run "ln -nfs #{shared_path}/config/config.yml #{release_path}/config/config.yml"
  end
end

namespace :nginx do

  desc 'Deploy nginx site configuration'
  task :config do
    config = $CONFIG.deploy.nginx

    nginx_base_dir = "/etc/nginx"
    nginx_available_dir = "#{nginx_base_dir}/sites-available"
    nginx_enabled_dir = "#{nginx_base_dir}/sites-enabled"
    nginx_available_file = "#{nginx_available_dir}/#{$CONFIG.deploy.name}"

    put nginx_site_config(config), nginx_available_file
    run "ln -nsf #{nginx_available_file} #{nginx_enabled_dir}/"
  end

  desc 'Reload nginx'
  task :reload do
    sudo 'service nginx reload'
  end
end

namespace :unicorn do

  desc 'Deploy unicorn configuration'
  task :config do
    config = $CONFIG.deploy.unicorn
    config.working_directory = "#{current_release}"
    config.pid = "#{shared_path}/pids/unicorn.pid"
    config.stdout_log = "#{shared_path}/log/#{$CONFIG.deploy.app_name}_stdout.log"
    config.stderr_log = "#{shared_path}/log/#{$CONFIG.deploy.app_name}_stderr.log"

    unicorn_file = "#{shared_path}/config/unicorn/production.rb"

    put unicorn_config(config), unicorn_file
    run "ln -nfs #{shared_path}/config/unicorn/production.rb #{current_release}/config/unicorn/production.rb"
  end
end

def unicorn_config config
  template = ERB.new(File.read("config/unicorn.erb"))
  template.result(binding)
end

def nginx_site_config config
  template = ERB.new(File.read("config/nginx.erb"))
  template.result(binding)
end
