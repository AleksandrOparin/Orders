ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  is_label = html_tag.index "<label"
  css_class = is_label ? "text-danger" : "is-invalid"

  class_pos = html_tag.index('class="') + 7

  if class_pos
    html_tag.insert class_pos, "#{css_class} "
  else
    html_tag.insert(html_tag.index(">"), " class=#{css_clss}")
  end
end