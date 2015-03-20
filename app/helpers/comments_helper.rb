module CommentsHelper
	def cache_key_for_comments
	    count          = Comment.count
	    max_updated_at = Comment.maximum(:updated_at).try(:utc).try(:to_s, :number)
	    "selfies/all-#{count}-#{max_updated_at}"
	end
end
