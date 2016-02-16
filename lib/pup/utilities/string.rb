class String
  def to_camelcase
    split("_").map(&:capitalize).join
  end

  def to_snakecase
    gsub(/::/, "/").
      gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
      gsub(/([a-z\d])([A-Z])/, '\1_\2').
      tr("-", "_").
      downcase
  end

  def sanitize_path!
    replace(self[0..-2]) if self[-1] == "/"
    replace("/" + self) if self[0] != "/"
  end
end
