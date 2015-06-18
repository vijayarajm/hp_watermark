module ApplicationHelper
  def signed_in?
    !current_user.nil?
  end

  def reseller?
    !admin?
  end

  def admin?
    current_user.admin
  end

  def nav_tab_list
    [ 
      ["Users", :users, users_path],
      ["Projects", :projects, projects_path],
    ]
  end
  
  def nav_tabs
    navigation = nav_tab_list.map do |tab|       
      content_tag(:li, link_to(tab[0], tab[2], 
          :class => ((@selected_tab == tab[1]) ? "active" : ""))).html_safe
    end    
    navigation.compact
  end
end
