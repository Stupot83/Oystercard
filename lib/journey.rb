# The Journey class
class Journey
  MINIMUM_FARE = 1
  PENALTY_FARE = 6

  attr_reader :entry_station, :exit_station

  def initialize
    @entry_station = nil
    @exit_station = nil
  end

  def start(station)
    @entry_station = station
  end

  def finish(station)
    @exit_station = station
  end

  def complete?
    @entry_station && @exit_station
  end

  def fare
    complete? ? MINIMUM_FARE : PENALTY_FARE
  end
end
