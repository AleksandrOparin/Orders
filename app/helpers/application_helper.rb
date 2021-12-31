module ApplicationHelper
  def nav_tab(title, icon, url, options = {}) 
    current_page = options.delete :current_page
    css_class = current_page == title ? 'active disabled' : ''
    
    options[:class] = if options[:class]
                        options[:class] + ' ' + css_class
                      else
                        css_class
                      end

    link_to url, options do
      content_tag(:div) do
        content_tag(:i, '', class: "fas fa-#{icon} fa-lg mb-1")
      end << "#{title}"
    end
  end
  
  def currently_at(current_page = '')
    render partial: 'partials/navbar', locals: {current_page: current_page}
  end

  def full_title(page_title = '')
    base_title = t('.base_title')
    if page_title.present?
      "#{page_title} | #{base_title}"
    else
      base_title
    end
  end
end
