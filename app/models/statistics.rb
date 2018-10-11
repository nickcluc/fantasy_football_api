module Statistics
  def self.sum(arr)
    arr.inject(0){|accum, i| accum + i }
  end

  def self.average(arr, count)
    return 0 if count == 0
    arr.inject(0){|accum, i| accum + i } / count
  end

  def self.median(arr)
    sorted = arr.sort
    len = sorted.length
    (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
  end
end
