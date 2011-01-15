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
    primary.item :home, 'Startseite', root_path do |home|

      home.item :home_menu1, "Menüpunkt1", "#"
      home.item :home_menu2, "Menüpunkt2", "#"
    end
    primary.item :test, 'Main menu 2', "#"
    if user_signed_in?
      primary.item :test2, 'personal menu 2', "#"
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


