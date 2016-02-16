class Array
  def with_value(base)
    reject { |field| base.send(field).nil? }
  end

  def without_id
    reject { |key| key == :id }
  end
end
