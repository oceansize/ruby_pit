helpers do
  def all_tags
    Tag.all.map(&:text)
  end
end