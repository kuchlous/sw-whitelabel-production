# == Schema Information
#
# Table name: illustration_categories
#
#  id         :integer          not null, primary key
#  name       :string(32)       not null
#  created_at :datetime
#  updated_at :datetime
#  origin_url :string(255)
#  uuid       :string(255)
#
# Indexes
#
#  index_illustration_categories_on_name  (name)
#

class IllustrationCategory < ActiveRecord::Base
  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 32 }

  default_scope {order("name ASC") }
  has_and_belongs_to_many :illustrations

  after_create :add_uuid_and_origin_url

  after_commit :reindex_illustrations
 
  translates :name, :translated_name

  def add_uuid_and_origin_url
    self.uuid = "#{Settings.org_info.prefix}-#{self.id}"
    self.origin_url = Settings.org_info.url
    self.save
  end

  def reindex_illustrations
    illustrations.each{|illustration| illustration.reindex}
  end
end
