class RightEyeOfRajh346 < Trinket
  include InternalCooldown
  include Buff

  # TODO confirm
  PROCS_OFF_OF = %w{autoattack crusader_strike hammer_of_wrath templars_verdict}
  DURATION = 10
  INTERNAL_COOLDOWN = 50

  PROC_CHANCE = 0.5

  def initialize(player, mob)
    super(player, mob)

    player.instance_variable_set(:@right_eye_of_rajh_346, self)
    Player.send("attr_reader", :right_eye_of_rajh_346)

    PROCS_OFF_OF.each do |ability_name|
      player.send(ability_name).extend(ProcTrinket)
    end

    player.extend(AugmentPlayerStrength)
  end

  def try_to_proc(callee)
    unless on_internal_cooldown? or random > PROC_CHANCE
      @active = true
      internal_cooldown_up_in(INTERNAL_COOLDOWN)
      buff_expires_in(DURATION)
    end
  end

  module ProcTrinket
    def use
      super
      if @attack == :crit
        @player.right_eye_of_rajh_346.try_to_proc(self)
      end
    end
  end

  module AugmentPlayerStrength
    def strength_from_buffs_and_consumables
      return super unless @right_eye_of_rajh_346.active?
      str = 1710
      str *= 1.05 if @plate_specialization
      str *= 1.05 if @buff_stats

      return (str + super).round
    end
  end
end