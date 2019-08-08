set :stages, %w(production development staging)
set :default_stage, "staging"
set :application, "danbooru"
set :repo_url,  "git://github.com/r888888888/danbooru.git"
set :deploy_to, "/var/www/danbooru2"
set :rbenv_ruby, "2.5.1"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "vendor/bundle"
set :branch, ENV.fetch("branch", "master")

# skip migrations if files in db/migrate weren't modified
set :conditionally_migrate, true

# run migrations on the primary app server
set :migration_role, :app
