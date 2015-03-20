module SelfiesHelper
	def cache_key_for_selfies
	    count          = Selfie.count
	    max_updated_at = Selfie.maximum(:updated_at).try(:utc).try(:to_s, :number)
	    "selfies/all-#{count}-#{max_updated_at}"
	end
end
