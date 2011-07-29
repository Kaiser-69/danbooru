Factory.define(:user) do |f|
  f.name {rand(1_000_000).to_s}
  f.password "password"
  f.password_hash {User.sha1("password")}
  f.email {Faker::Internet.email}
  f.default_image_size "medium"
  f.base_upload_limit 10
  f.level 20
end

Factory.define(:banned_user, :parent => :user) do |f|
  f.is_banned true
  f.ban {|x| x.association(:ban)}
end

Factory.define(:privileged_user, :parent => :user) do |f|
  f.level 30
end

Factory.define(:contributor_user, :parent => :user) do |f|
  f.level 33
end

Factory.define(:janitor_user, :parent => :user) do |f|
  f.level 35
end

Factory.define(:moderator_user, :parent => :user) do |f|
  f.level 40
end

Factory.define(:admin_user, :parent => :user) do |f|
  f.level 50
end
