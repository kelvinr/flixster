module ApplicationHelper
  def options(selected=nil)
    options_for_select((1..5).map{ |num| [pluralize(num, "Star"), num]}, selected)
  end
end
