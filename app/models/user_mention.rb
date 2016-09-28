class UserMention
  include Mongoid::Document
  field :username, type: String
  field :mentions, type: Hash
end
