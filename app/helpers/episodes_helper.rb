module EpisodesHelper
  def insert_episodes_tag_list(list)
    unless list.empty?
      "[" +
      list.map { |tag| 
        link_to( tag, tag_episodes_path(tag) )
      }.join(", ").html_safe +
      "]"
    else
      ""
    end
  end
end
