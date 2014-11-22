class SelfieSerializer < ActiveModel::Serializer
  attributes :id, :message, :photo, :shared_fb, :challenge_id, :private, :approval_status, :is_daily, :created_at

  has_one :user
  has_one :challenge

end
