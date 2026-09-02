#!/usr/bin/env ruby
#
# Hide private posts from the public site

module Jekyll
  class PrivatePostsGenerator < Generator
    priority :highest

    def generate(site)
      posts = site.posts.docs
      private_posts = posts.select { |post| private_post?(post) }

      return if private_posts.empty?

      posts.reject! { |post| private_post?(post) }
    end

    private

    def private_post?(post)
      value = post.data['private']
      value == true || value.to_s.casecmp('true').zero?
    end
  end
end
