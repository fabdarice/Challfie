module ApplicationHelper
  def display_error(record, attr_name)
    if record.errors[attr_name].present?
      record.errors[attr_name].first
    end
  end

  def link_to_if_with_block condition, options, html_options={}, &block
     if condition
       link_to options, html_options, &block
     else
       capture &block
     end
   end
end
