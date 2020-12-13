class XMASProtocol
  attr_reader :detection_range
  attr_reader :frames

  def initialize(detection_range = 25)
    @detection_range = detection_range
    @frames = []
  end

  def add_frame(frame_value)
    range = usable_range(frames.size)
    @frames << { value: frame_value.to_i, sums: [] }.tap do |frame|
      frame[:sums] = ((range[:min])..(range[:max] - 1)).map do |idx|
        frame[:value] + frames[idx][:value]
      end.reverse
    end
  end

  def weakness
    weakness = (@detection_range..(frames.size - 1)).detect(&method(:is_weak?))
    return { frame: nil, value: 0 } if weakness.nil?
    { frame: weakness + 1, value: frames[weakness][:value] }
  end

  def break_encryption
    protocol_weakness = weakness
    try_break_frame(0, protocol_weakness[:value])
  end

  private

  def usable_range(idx)
    { min: [idx - (@detection_range - 1), 0].max, max: idx }
  end

  def is_weak?(frame_id)
    range = usable_range(frame_id)
    available = (range[:min]..range[:max]).map.with_index do |frame_id, idx|
      frames[frame_id][:sums].first(detection_range - (detection_range - idx - 1))
    end.flatten.uniq
    !available.include?(frames[frame_id][:value])
  end

  def try_break_frame(frame_id, target)
    return { breaking_factor: nil, breaking_numbers: [], breaking_frame_start: nil } if frame_id >= frames.size

    accumulator = 0
    breaking_factor = 0

    (frame_id..(frames.size - 1)).each do |frame_id|
      accumulator += frames[frame_id][:value]
      breaking_factor += 1
      break if accumulator >= target
    end

    return { breaking_factor: breaking_factor, breaking_numbers: frames[frame_id, breaking_factor].map { |frame| frame[:value] }, breaking_frame_start: frame_id + 1 } if accumulator == target
    try_break_frame(frame_id + 1, target)
  end
end
