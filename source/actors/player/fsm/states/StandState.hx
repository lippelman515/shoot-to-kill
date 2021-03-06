package actors.player.fsm.states;

import flixel.FlxObject;

class StandState extends PlayerState {

    public function new(player:Player) {
        super(player);
    }

    override public function handleInput(input:Input):Int {
        if (input.attackJustPressed) {
            return PlayerStates.ATTACKING.getIndex();
        }
        
		if ((input.reloadJustPressed && this.managedPlayer.roundsLeft < this.managedPlayer.rounds) || (this.managedPlayer.roundsLeft == 0)) {
            return PlayerStates.RELOADING.getIndex();
        }

        if (input.jumpJustPressed) {
            return PlayerStates.JUMPING.getIndex();
        }

        if (input.downPressed) {
            return PlayerStates.CROUCHING.getIndex();
        }

        if (input.leftPressed || input.rightPressed) {
            return PlayerStates.RUNNING.getIndex();
        }

		if (!this.managedPlayer.isTouching(FlxObject.DOWN))
		{
			return PlayerStates.FALLING.getIndex();
		}

        return super.handleInput(input);
    }

	override public function update(elapsed:Float):Void {
        if (this.managedPlayer.animation.finished && this.managedPlayer.animation.name != Player.STAND_ANIMATION) {
            this.managedPlayer.animation.play(Player.STAND_ANIMATION);
        }
    }

    override public function transitionIn():Void {
        this.managedPlayer.drag.x = Player.STANDING_DECELERATION;

        this.managedPlayer.airJumps = this.managedPlayer.maxAirJumps;

        if (this.managedPlayer.animation.finished) {
            this.managedPlayer.animation.play(Player.STAND_ANIMATION);
        }
    }

    override public function transitionOut():Void {
        this.managedPlayer.drag.x = 0;
    }
}