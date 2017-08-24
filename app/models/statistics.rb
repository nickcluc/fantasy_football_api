module Statistics
  def self.sum(arr)
    arr.inject(0){|accum, i| accum + i }
  end

  def self.average(arr, count)
    return 0 if count == 0
    arr.inject(0){|accum, i| accum + i } / count
  end
end
