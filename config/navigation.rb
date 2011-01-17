# encoding: utf-8
SimpleNavigation::Configuration.run do |navigation|
  # Specify a custom renderer if needed.
  # The default renderer is SimpleNavigation::Renderer::List which renders HTML lists.
  # The renderer can also be specified as option in the render_navigation call.
  # navigation.renderer = Your::Custom::Renderer

  # Specify the class that will be applied to active navigation items. Defaults to 'selected'
  # navigation.selected_class = 'your_selected_class'

  # Item keys are normally added to list items as id.
  # This setting turns that off
  # navigation.autogenerate_item_ids = false

  # You can override the default logic that is used to autogenerate the item ids.
  # To do this, define a Proc which takes the key of the current item as argument.
  # The example below would add a prefix to each key.
  # navigation.id_generator = Proc.new {|key| "my-prefix-#{key}"}

  # The auto highlight feature is turned on by default.
  # This turns it off globally (for the whole plugin)
  # navigation.auto_highlight = false

  # Define the primary navigation

  navigation.items do |primary|
    primary.dom_class="nav"
    primary.item :home, 'Startseite', root_path, :highlights_on=>/^(\/home|\/)$/ do |home| #spezieller pfad, auf /home und auf /
      home.item :home_menu1, "Menüpunkt1", "#"
      home.item :home_menu1, "Menüpunkt2", "#"
    end
    if user_signed_in?
      primary.item :my, 'Persönlicher Bereich', "my_path" do |my|
        #my.dom_class="nav"
        my.item :my_start, 'Meine Startseite', "my_start_path"
        my.item :my_edit_registration, 'Edit registration', edit_user_registration_path
      end
      primary.item :my_logout, 'Logout', destroy_user_session_path
    else
      primary.item :login, 'Register', new_user_registration_path
      primary.item :login, 'Login', new_user_session_path
    end

    if user_signed_in?
      primary.item :admin, "Admin-Bereich", "admin_path"
    end
  end

  # You can also specify a condition-proc that needs to be fullfilled to display an item.
  # Conditions are part of the options. They are evaluated in the context of the views,
  # thus you can use all the methods and vars you have available in the views.
  #
  #primary.item :key_3, 'Admin', url, :class => 'special', :if => Proc.new { current_user.admin? }
  #primary.item :key_4, 'Account', url, :unless => Proc.new { logged_in? }

  # you can also specify a css id or class to attach to this particular level
  # works for all levels of the menu
  # primary.dom_id = 'menu-id'
  # primary.dom_class = 'menu-class'

  # You can turn off auto highlighting for a specific level
  # primary.auto_highlight = false


end


