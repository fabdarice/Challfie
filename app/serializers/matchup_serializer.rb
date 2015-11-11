class MatchupSerializer < ActiveModel::Serializer
  attributes :id, :type_matchup, :duration, :status, :end_date_with_timezone, :is_creator, :list_selfies, :matchup_winner

  delegate :current_user, to: :scope

  has_one :winner
  has_one :challenge  
  has_many :users
  #has_many :matchup_users

  def end_date_with_timezone
    if object.end_date
      object.end_date.in_time_zone(current_user.timezone)
    end
  end

  def is_creator
    matchup_user = object.matchup_users.where(user_id: current_user.id).first    
    return matchup_user.is_creator    
  end
  
  def list_selfies
    object.selfies
  end

  def matchup_winner
    if object.winner
      object.winner.username
    end
  end

end
