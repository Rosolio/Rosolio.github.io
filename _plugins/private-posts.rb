#!/usr/bin/env ruby
#
# Remove private posts from the public site before generation

Jekyll::Hooks.register :site, :post_read do |site|
  posts = site.collections['posts']&.docs
  next unless posts

  posts.reject! { |post| private_post?(post) }
end

def private_post?(post)
  value = post.data['private']
  value == true || value.to_s.casecmp('true').zero?
end
