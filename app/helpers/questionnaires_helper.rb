module QuestionnairesHelper
  def link_to_remove_fields(name, builder)
    builder.hidden_field(:_destroy) + link_to(name, '#', class: 'remove-fields-for')
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).class.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s + '_fields', :f => builder)
    end
    link_to(name, '#', :onclick => "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")")
  end
end
