class ChallengeSerializer < ActiveModel::Serializer
  attributes :id, :description, :difficulty

  def description
  		if I18n.locale == :fr
        object.description_fr
      else
        object.description_en
      end
  end
end
