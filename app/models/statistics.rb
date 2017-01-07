module Statistics
  def self.sum(arr)
    arr.inject(0){|accum, i| accum + i }
  end

  def self.average(arr, count)
    arr.inject(0){|accum, i| accum + i } / count
  end
end
