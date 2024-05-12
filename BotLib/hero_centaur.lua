----------------------------------------------------------------------------------------------------
--- The Creation Come From: BOT EXPERIMENT Credit:FURIOUSPUPPY
--- BOT EXPERIMENT Author: Arizona Fauzie 2018.11.21
--- Link:http://steamcommunity.com/sharedfiles/filedetails/?id=837040016
--- Refactor: 决明子 Email: dota2jmz@163.com 微博@Dota2_决明子
--- Link:http://steamcommunity.com/sharedfiles/filedetails/?id=1573671599
--- Link:http://steamcommunity.com/sharedfiles/filedetails/?id=1627071163
----------------------------------------------------------------------------------------------------
local X = {}
local bDebugMode = ( 10 == 10 )
local bot = GetBot()

local J = require( GetScriptDirectory()..'/FunLib/jmz_func' )
local Minion = dofile( GetScriptDirectory()..'/FunLib/aba_minion' )
local sTalentList = J.Skill.GetTalentList( bot )
local sAbilityList = J.Skill.GetAbilityList( bot )
local sOutfitType = J.Item.GetOutfitType( bot )

local tTalentTreeList = {
						['t25'] = {0, 10},
						['t20'] = {0, 10},
						['t15'] = {0, 10},
						['t10'] = {10, 0},
}

local tAllAbilityBuildList = {
						{1,3,1,2,1,6,1,3,3,3,6,2,2,2,6}
}

local nAbilityBuildList = J.Skill.GetRandomBuild( tAllAbilityBuildList )

local nTalentBuildList = J.Skill.GetTalentBuild( tTalentTreeList )

local tOutFitList = {}

tOutFitList['outfit_carry'] = {

	"item_bristleback_outfit",
	"item_bracer",
	"item_echo_sabre",
	"item_ultimate_scepter",
	"item_blink",
	"item_aghanims_shard",
	"item_black_king_bar",
	"item_travel_boots",
	"item_aghanims_shard",
	"item_bloodthorn",
	"item_ultimate_scepter_2",
	"item_overwhelming_blink",
	"item_moon_shard",
	"item_travel_boots_2",

}

tOutFitList['outfit_mid'] = tOutFitList['outfit_tank']

tOutFitList['outfit_priest'] = tOutFitList['outfit_tank']

tOutFitList['outfit_mage'] = tOutFitList['outfit_tank']

tOutFitList['outfit_tank'] = {
	
	"item_tank_outfit",
	"item_blade_mail",
	-- "item_echo_sabre",
	"item_crimson_guard",
	"item_lotus_orb",
	"item_black_king_bar",
	--"item_ultimate_scepter",
	--"item_heavens_halberd",
	--"item_assault",
	"item_travel_boots",
	"item_aghanims_shard",
	--"item_satanic",
	--"item_ultimate_scepter_2",
	"item_heart",
	--"item_moon_shard",
	"item_travel_boots_2",
	
}

X['sBuyList'] = tOutFitList[sOutfitType]

X['sSellList'] = {

	"item_power_treads",
	"item_quelling_blade",

	"item_assault",
	"item_magic_wand",

	-- "item_heart",
	-- "item_armlet",
	
	"item_travel_boots",
	"item_magic_wand",
	
	
	"item_assault",
	"item_ancient_janggo",

}


if J.Role.IsPvNMode() or J.Role.IsAllShadow() then X['sBuyList'], X['sSellList'] = { 'PvN_tank' }, {"item_power_treads", 'item_quelling_blade'} end

nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] = J.SetUserHeroInit( nAbilityBuildList, nTalentBuildList, X['sBuyList'], X['sSellList'] )

X['sSkillList'] = J.Skill.GetSkillList( sAbilityList, nAbilityBuildList, sTalentList, nTalentBuildList )

X['bDeafaultAbility'] = false
X['bDeafaultItem'] = false

function X.MinionThink( hMinionUnit )

	if Minion.IsValidUnit( hMinionUnit )
	then
		Minion.IllusionThink( hMinionUnit )
	end

end

--[[

npc_dota_hero_centaur

"Ability1"		"centaur_hoof_stomp"
"Ability2"		"centaur_double_edge"
"Ability3"		"centaur_return"
"Ability4"		"generic_hidden"
"Ability5"		"generic_hidden"
"Ability6"		"centaur_stampede"
"Ability10"		"special_bonus_hp_regen_5"
"Ability11"		"special_bonus_movement_speed_20"
"Ability12"		"special_bonus_armor_5"
"Ability13"		"special_bonus_unique_centaur_4"
"Ability14"		"special_bonus_unique_centaur_3"
"Ability15"		"special_bonus_unique_centaur_5"
"Ability16"		"special_bonus_unique_centaur_1"
"Ability17"		"special_bonus_unique_centaur_2"


--]]

local abilityQ = bot:GetAbilityByName( sAbilityList[1] )
local abilityW = bot:GetAbilityByName( sAbilityList[2] )
local abilityE = bot:GetAbilityByName( sAbilityList[3] )
local abilityR = bot:GetAbilityByName( sAbilityList[6] )
local talent2 = bot:GetAbilityByName( sTalentList[2] )
local talent6 = bot:GetAbilityByName( sTalentList[6] )

local castQDesire, castQTarget
local castWDesire, castWTarget
local castEDesire, castETarget
local castRDesire, castRTarget

local nKeepMana, nMP, nHP, nLV, hEnemyList, hAllyList, botTarget, sMotive
local aetherRange = 0


function X.SkillsComplement()

	if J.CanNotUseAbility( bot ) or bot:IsInvisible() then return end

	nKeepMana = 400
	aetherRange = 0
	nLV = bot:GetLevel()
	nMP = bot:GetMana() / bot:GetMaxMana()
	nHP = bot:GetHealth() / bot:GetMaxHealth()
	botTarget = J.GetProperTarget( bot )
	hEnemyList = bot:GetNearbyHeroes( 1600, true, BOT_MODE_NONE )
	hAllyList = J.GetAlliesNearLoc( bot:GetLocation(), 1600 )

	
	castRDesire, castRTarget, sMotive = X.ConsiderR()
	if castRDesire > 0
	then
		J.SetReportMotive( bDebugMode, sMotive )

		--J.SetQueuePtToINT( bot, false )

		bot:ActionQueue_UseAbility( abilityR )
		return
	end
	
	castQDesire, castQTarget, sMotive = X.ConsiderQ()
	if castQDesire > 0
	then
		J.SetReportMotive( bDebugMode, sMotive )

		--J.SetQueuePtToINT( bot, false )

		bot:ActionQueue_UseAbility( abilityQ )
		return
	end

	castWDesire, castWTarget, sMotive = X.ConsiderW()
	if castWDesire > 0
	then
		J.SetReportMotive( bDebugMode, sMotive )

		--J.SetQueuePtToINT( bot, true )

		bot:ActionQueue_UseAbilityOnEntity( abilityW , castWTarget)
		return
	end



end


function X.ConsiderQ()


	if not abilityQ:IsFullyCastable() then return 0 end

	local nSkillLV = abilityQ:GetLevel()
	local nCastRange = abilityQ:GetSpecialValueInt( 'radius' )
	local nRadius = abilityQ:GetSpecialValueInt( 'radius' )
	local nCastPoint = abilityQ:GetCastPoint()
	local nManaCost = abilityQ:GetManaCost()
	local nDamage = abilityQ:GetAbilityDamage()
	local nDamageType = DAMAGE_TYPE_MAGICAL
	local nInRangeEnemyList = J.GetAroundEnemyHeroList( nCastRange - 50 )
	local nInBonusEnemyList = J.GetAroundEnemyHeroList( nCastRange - 100 )
	local hCastTarget = nil
	local sCastMotive = nil

	
	--击杀打断敌人
	for _, npcEnemy in pairs( nInRangeEnemyList )
	do 
		if J.IsValid( npcEnemy )
			and J.CanCastOnNonMagicImmune( npcEnemy )
			and ( J.CanKillTarget( npcEnemy, nDamage, nDamageType )
					or npcEnemy:IsChanneling() )
		then
			hCastTarget = npcEnemy
			sCastMotive = 'Q-击杀打断'..J.Chat.GetNormName( hCastTarget )
			return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
		end
	
	end


	--打架攻击
	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( botTarget )
			and J.IsInRange( botTarget, bot, nRadius - 50 )
			and J.CanCastOnMagicImmune( botTarget )	
			and not J.IsDisabled( botTarget )
		then			
			hCastTarget = botTarget
			sCastMotive = 'Q-攻击'..J.Chat.GetNormName( hCastTarget )
			return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
		end
	end
	
	
	--团战AOE
	if J.IsInTeamFight( bot, 1000 )
	then
		local nAoeCount = 0
		for _, npcEnemy in pairs( nInBonusEnemyList )
		do 
			if J.IsValidHero( npcEnemy )
				and J.CanCastOnNonMagicImmune( npcEnemy )
			then
				nAoeCount = nAoeCount + 1	
			end
		end

		if nAoeCount >= 2
		then
			hCastTarget = botTarget
			sCastMotive = 'Q-团战AOE'..nAoeCount
			return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
		end
	end
	
	
	--撤退时保护自己
	if J.IsRetreating( bot )
	then
		for _, npcEnemy in pairs( nInRangeEnemyList )
		do
			if J.IsValid( npcEnemy )
				and bot:WasRecentlyDamagedByHero( npcEnemy, 5.0 )
				and J.CanCastOnNonMagicImmune( npcEnemy )
				and not J.IsDisabled( npcEnemy )
				and not npcEnemy:IsDisarmed()
			then
				hCastTarget = npcEnemy
				sCastMotive = 'Q-撤退'..J.Chat.GetNormName( hCastTarget )
				return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
			end
		end
	end
	
	
	--带线AOE
	if ( J.IsPushing( bot ) or J.IsDefending( bot ) or J.IsFarming( bot ) )
		and J.IsAllowedToSpam( bot, nManaCost )
		and #hAllyList <= 2
	then
		local laneCreepList = bot:GetNearbyLaneCreeps( nCastRange , true )
		if ( #laneCreepList >= 4 or ( #laneCreepList >= 3 and nMP > 0.82 ) )
			and not laneCreepList[1]:HasModifier( "modifier_fountain_glyph" )
		then
			hCastTarget = creep
			sCastMotive = 'Q-带线AOE'..(#laneCreepList)
			return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
		end
	end
	
	
	
	--打野AOE
	if J.IsFarming( bot )
		and DotaTime() > 6 * 60
		and J.IsAllowedToSpam( bot, nManaCost )
	then
		local creepList = bot:GetNearbyNeutralCreeps( nRadius )

		if #creepList >= 3
			and J.IsValid( botTarget )
		then
			hCastTarget = botTarget
			sCastMotive = 'Q-打野AOE'..(#creepList)
			return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
	    end
	end
	
	
	if bot:GetActiveMode() == BOT_MODE_ROSHAN
		and bot:GetMana() >= 400
	then
		local npcTarget = bot:GetAttackTarget()
		if J.IsRoshan( npcTarget )
			and not J.IsDisabled( npcTarget )
			and not npcTarget:IsDisarmed()
			and J.IsInRange( npcTarget, bot, nCastRange )
		then
			hCastTarget = botTarget
			sCastMotive = 'Q-打肉山'
			return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
		end
	end

	return BOT_ACTION_DESIRE_NONE


end


function X.ConsiderW()


	if not abilityW:IsFullyCastable() then return 0 end

	local nSkillLV = abilityW:GetLevel()
	local nCastRange = abilityW:GetCastRange()
	local nRadius = 600
	local nCastPoint = abilityW:GetCastPoint()
	local nManaCost = abilityW:GetManaCost()
	local nHeahthCost = abilityW:GetAbilityDamage() --abilityW:GetSpecialValueInt('edge_damage')
	local nDamage = abilityW:GetAbilityDamage()
	local nDamageType = DAMAGE_TYPE_MAGICAL
	local nInRangeEnemyList = J.GetAroundEnemyHeroList( nCastRange )
	local nInBonusEnemyList = J.GetAroundEnemyHeroList( nCastRange + 200 )
	local hCastTarget = nil
	local sCastMotive = nil

	--击杀敌人
	for _, npcEnemy in pairs( nInRangeEnemyList )
	do 
		if J.IsValid( npcEnemy )
			and J.CanCastOnNonMagicImmune( npcEnemy )
			and J.CanKillTarget( npcEnemy, nDamage, nDamageType )
			and J.IsAllowedToSpamHealth( bot, nHeahthCost )
		then
			hCastTarget = npcEnemy
			sCastMotive = 'W-击杀'..J.Chat.GetNormName( hCastTarget )
			return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
		end
	
	end


	--打架攻击
	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( botTarget )
			and J.IsInRange( botTarget, bot, nRadius - 50 )
			and J.IsAllowedToSpamHealth( bot, nHeahthCost )
		then			
			hCastTarget = botTarget
			sCastMotive = 'W-攻击'..J.Chat.GetNormName( hCastTarget )
			return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
		end
	end
	
	
	--团战AOE
	if J.IsInTeamFight( bot, 1000 )
	then
		local nAoeCount = 0
		for _, npcEnemy in pairs( nInBonusEnemyList )
		do 
			if J.IsValidHero( npcEnemy )
				and J.CanCastOnNonMagicImmune( npcEnemy )
			then
				nAoeCount = nAoeCount + 1	
			end
		end

		if nAoeCount >= 2
		then
			hCastTarget = botTarget
			sCastMotive = 'W-团战AOE'..nAoeCount
			return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
		end
	end
	
	
	--带线AOE
	if ( J.IsPushing( bot ) or J.IsDefending( bot ) or J.IsFarming( bot ) )
		and J.IsAllowedToSpamHealth( bot, nHeahthCost )
		and #hAllyList <= 2
	then
		local laneCreepList = bot:GetNearbyLaneCreeps( nCastRange , true )
		if ( #laneCreepList >= 4 or ( #laneCreepList >= 3 and nMP > 0.82 ) )
			and not laneCreepList[1]:HasModifier( "modifier_fountain_glyph" )
		then
			hCastTarget = creep
			sCastMotive = 'Q-带线AOE'..(#laneCreepList)
			return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
		end
	end
	
	
	
	--打野AOE
	if J.IsFarming( bot )
		and DotaTime() > 6 * 60
		and J.IsAllowedToSpamHealth( bot, nHeahthCost )
	then
		local creepList = bot:GetNearbyNeutralCreeps( nRadius )

		if #creepList >= 3
			and J.IsValid( botTarget )
		then
			hCastTarget = botTarget
			sCastMotive = 'Q-打野AOE'..(#creepList)
			return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
	    end
	end


	return BOT_ACTION_DESIRE_NONE


end

function X.ConsiderR()


	if not abilityR:IsFullyCastable() then return 0 end

	local nSkillLV = abilityR:GetLevel()
	local nCastRange = abilityR:GetCastRange()
	local nRadius = 600
	local nCastPoint = abilityR:GetCastPoint()
	local nManaCost = abilityR:GetManaCost()
	local nDamage = 0
	local nDamageType = DAMAGE_TYPE_MAGICAL
	local hCastTarget = nil
	local sCastMotive = nil

	
	--攻击敌人时
	if J.IsGoingOnSomeone( bot )
		and J.IsRunning( bot )
	then
		if J.IsValidHero( botTarget )
			and J.IsInRange( bot, botTarget, 1600 )
			and not J.IsInRange( bot, botTarget, 200 )
		then
			hCastTarget = botTarget
			sCastMotive = 'R-进攻:'..J.Chat.GetNormName( hCastTarget )
			return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
		end
	end
	
	
	--逃跑时
	if J.IsRetreating( bot ) 
		and J.IsRunning( bot ) 
		and bot:WasRecentlyDamagedByAnyHero( 5.0 )
		and #hEnemyList >= 1
	then
		hCastTarget = bot
		sCastMotive = 'R-撤退了'
		return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive	
	end


	return BOT_ACTION_DESIRE_NONE


end

return X
-- dota2jmz@163.com QQ:2462331592..

