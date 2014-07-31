module ApplicationHelper
	def display_error(record, attr_name)
    if record.errors[attr_name].present?
      record.errors[attr_name].first
    end
  end
end
