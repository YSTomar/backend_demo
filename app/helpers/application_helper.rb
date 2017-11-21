module ApplicationHelper
  def receivers_for_select
  	User.all.collect { |u| [u.name, u.id] }
  end

  def gravatar_for(user, opts = {})
	opts[:alt] = user.name
	image_tag "https://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(user.email)}?s=#{opts.delete(:size) { 40 }}",
	opts
  end
end
