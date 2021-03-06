# require 'highline/import'

class Photo < ActiveRecord::Base
  include Splashbox::Dropbox

  attr_accessible :source_url

  def self.new_from_source_url(url)
    Photo.create(source_url: url)
  end

  def save_to_dropbox(user, id, url)
    agent = Mechanize.new

    # Deal with any redirects (e.g. bit.ly)
    initial_url = agent.get(url)
    destination_url = initial_url.uri.to_s

    content = agent.get_file(destination_url)
    upload_file(user, "#{ id }.jpg", content)
  end

  private

  def self.reset_ids
    if ask("Are you sure you want to reset the photos table ids back to '1'? (yes/no)", String) == "yes"
      ActiveRecord::Base.connection.reset_pk_sequence!('photos')
    end
  end
end
