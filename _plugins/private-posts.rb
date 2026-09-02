#!/usr/bin/env ruby
#
# Map private posts to Jekyll's native unpublished behavior

Jekyll::Hooks.register :posts, :post_init do |post|
  value = post.data['private']
  next unless value == true || value.to_s.casecmp('true').zero?

  post.data['published'] = false
end
