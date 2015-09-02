class ChallengeSerializer < ActiveModel::Serializer
  attributes :id, :description, :difficulty, :complete_status

  delegate :current_user, to: :scope

  def description
  		if I18n.locale == :fr
        object.description_fr
      else
        object.description_en
      end
  end

  def complete_status
  		if current_user.selfies.where(challenge_id: object.id, approval_status: 1, blocked: false, hidden: false).count != 0
  			return 1
  		else
  			if current_user.selfies.where(challenge_id: object.id, approval_status: 2, blocked: false, hidden: false).count != 0
  				return 2
  			else
  				return 0
  			end	
  		end  		
  end
end
