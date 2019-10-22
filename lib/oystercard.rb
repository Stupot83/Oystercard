# The Oystercard class
class Oystercard
  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1
  MINIMUM_CHARGE = 5
  attr_reader :balance, :entry_station, :exit_station, :journeys

  def initialize
    @balance = 0
    @journeys = []
  end

  def top_up(amount)
    raise "Maximum balance of #{MAXIMUM_BALANCE} exceeded" if amount + balance > MAXIMUM_BALANCE
    @balance += amount
  end

  def touch_in(station)
    raise 'Insufficient balance to touch in' if balance < MINIMUM_BALANCE
    @entry_station = station
  end

  def touch_out(station)
    @exit_station = station
    @journeys << { entry_station: @entry_station, exit_station: @exit_station }
    @entry_station = nil
    deduct(MINIMUM_CHARGE)
  end

  def in_journey?
    !!entry_station
  end

  private

  def deduct(amount = MINIMUM_CHARGE)
    @balance -= amount
  end
end
