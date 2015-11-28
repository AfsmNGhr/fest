# coding: utf-8
module Volume
  def current_volumes_on_inputs
    info = `pactl list sink-inputs`
    inputs = info.scan(/\A#|№(\d+)/).flatten
    volumes = info.scan(/\W+:\s\w+\W+\w+:\s\d+\s\/\s+(\d+)%/).flatten
    @current_volumes = inputs.zip(volumes.map(&:to_i)).to_h
  end

  def volumes_for_inputs
    @volumes = {}
    @current_volumes.each do |input, volume|
      @volumes.merge!({ input => (volume - volume / 10 * @step) })
    end
    @volumes
  end

  def optimize_volume
    case @flat_volumes
    when 'yes'
      optimize_common_volume
    else
      100
    end
  end

  def optimize_common_volume
    if @common_volume > @max_volume
      @max_volume
    elsif @common_volume < @min_volume
      @min_volume
    else
      @common_volume
    end
  end

  def change_common_volume(volume)
    system("amixer set Master '#{volume}%' \
      > /dev/null 2>&1") if @flat_volumes == 'no'
  end

  def change_volumes(volumes, break_volumes, step)
    volumes.each do |input, volume|
      change = volume > break_volumes[input] ? 'down' : 'up'
      loop do
        system("pactl set-sink-input-volume #{input} '#{volume * 655}'")
        change == 'up' ? volume += step : volume -= step
        break if change == 'up' ? volume > break_volumes[input] :
                   volume < break_volumes[input]
      end
    end
  end
end
