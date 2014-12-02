class ChallengeSerializer < ActiveModel::Serializer
  attributes :id, :description

  def description
  		if I18n.locale == :fr
        object.description_fr
      else
        object.description_en
      end
  end
end
