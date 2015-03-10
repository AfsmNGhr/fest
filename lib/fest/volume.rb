# coding: utf-8
#
module Volume
   def check_optimal_volume
    @volume = @current_volume - @current_volume / 10 * @step
  end

  def optimize_volume
    @optimize_volume = (
    if @current_volume > @max_volume
      @max_volume
    elsif @current_volume < @min_volume
      @min_volume
    else
      @current_volume
    end
    )
  end

  def inputs
    @inputs = `pactl list sink-inputs | grep № | grep -o '[0-9]*'`.split("\n")
  end

  def turn_down_volume
    @inputs.each do |input|
      volume = @current_volume
      loop do
        system("pactl set-sink-input-volume #{input} '#{volume * 655}'")
        volume -= @step
        break if volume < @volume
      end
    end
  end

  def return_current_volume
    @inputs.each do |input|
      volume = @volume
      loop do
        system("pactl set-sink-input-volume #{input} '#{volume * 655}'")
        volume += @step
        break if volume > @current_volume
      end
    end
  end
end
