

fire_sniper_rifle_lua = class ({})


function fire_sniper_rifle_lua:OnSpellStart()
	self.fire_sniper_rifle_speed = self:GetSpecialValueFor( "fire_sniper_rifle_speed" )
	self.fire_sniper_rifle_distance = self:GetSpecialValueFor( "fire_sniper_rifle_distance" ) -- 2500 
	self.fire_sniper_rifle_damage = self:GetSpecialValueFor( "fire_sniper_rifle_damage" ) 

	EmitSoundOn( "Hero_Sniper.AssassinateProjectile", self:GetCaster() )

	local info = {
		EffectName = "particles/units/heroes/hero_lina/lina_spell_dragon_slave.vpcf",
		Ability = self,
		vSpawnOrigin = self:GetCaster():GetOrigin(), 
		fStartRadius = self.dragon_slave_width_initial,
		fEndRadius = self.dragon_slave_width_end,
		vVelocity = vDirection * self.dragon_slave_speed,
		fDistance = self.dragon_slave_distance,
		Source = self:GetCaster(),
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	}

	ProjectileManager:CreateLinearProjectile( info )
	EmitSoundOn( "Hero_Lina.DragonSlave", self:GetCaster() )
end


