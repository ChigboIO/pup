class Object
  def self.const_missing(name)
    require name.to_s.to_snakecase
    Object.const_get(name)
  end
end
