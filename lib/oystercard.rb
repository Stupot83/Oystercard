class Oystercard
  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1
  MINIMUM_CHARGE = 5
  attr_reader :balance, :entry_station

  def initialize
    @balance = 0
  end

  def top_up(amount)
    fail "Maximum balance of #{MAXIMUM_BALANCE} exceeded" if amount + balance > MAXIMUM_BALANCE
    @balance += amount
  end

  def touch_in(station)
    raise "Insufficient balance to touch in" if balance < MINIMUM_BALANCE
    @entry_station = station
  end

  def touch_out
    deduct(MINIMUM_CHARGE)
    @entry_station = nil
  end

  def in_journey?
    !!entry_station
  end

  private

  def deduct(amount)
    @balance -= amount
  end
end
