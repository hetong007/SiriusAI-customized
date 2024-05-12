----------------------------------------------------------------------------------------------------
--- The Creation Come From: BOT EXPERIMENT Credit:FURIOUSPUPPY
--- BOT EXPERIMENT Author: Arizona Fauzie 2018.11.21
--- Link:http://steamcommunity.com/sharedfiles/filedetails/?id=837040016
--- Refactor: 决明子 Email: dota2jmz@163.com 微博@Dota2_决明子
--- Link:http://steamcommunity.com/sharedfiles/filedetails/?id=1573671599
--- Link:http://steamcommunity.com/sharedfiles/filedetails/?id=1627071163
----------------------------------------------------------------------------------------------------
local X = {}
local bDebugMode = ( 1 == 10 )
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
						{2,1,2,1,3,6,3,1,1,3,6,3,2,2,6},
}

local nAbilityBuildList = J.Skill.GetRandomBuild( tAllAbilityBuildList )

local nTalentBuildList = J.Skill.GetTalentBuild( tTalentTreeList )

local tOutFitList = {}

tOutFitList['outfit_carry'] = {

	"item_sven_outfit",
	"item_bracer",
	"item_aghanims_shard",
	"item_eternal_shroud",
	"item_veil_of_discord",
--	"item_echo_sabre",
	"item_blink",
	"item_black_king_bar",
	"item_shivas_guard",
	"item_ultimate_scepter",
	"item_travel_boots",
--	"item_bloodthorn",
	"item_ultimate_scepter_2",
	"item_overwhelming_blink",
	"item_moon_shard",
	"item_travel_boots_2",
}

tOutFitList['outfit_mid'] = tOutFitList['outfit_carry']

tOutFitList['outfit_priest'] = tOutFitList['outfit_carry']

tOutFitList['outfit_mage'] = tOutFitList['outfit_carry']

tOutFitList['outfit_tank'] = tOutFitList['outfit_carry']

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

npc_dota_hero_doom_bringer

"Ability1"		"doom_bringer_devour"
"Ability2"		"doom_bringer_scorched_earth"
"Ability3"		"doom_bringer_infernal_blade"
"Ability4"		"doom_bringer_empty1"
"Ability5"		"doom_bringer_empty2"
"Ability6"		"doom_bringer_doom"
"Ability10"		"special_bonus_unique_doom_3"
"Ability11"		"special_bonus_unique_doom_4"
"Ability12"		"special_bonus_unique_doom_6"
"Ability13"		"special_bonus_unique_doom_2"
"Ability14"		"special_bonus_unique_doom_9"
"Ability15"		"special_bonus_unique_doom_1"
"Ability16"		"special_bonus_unique_doom_10"
"Ability17"		"special_bonus_unique_doom_11"

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


	castWDesire, castWTarget, sMotive = X.ConsiderW()
	if castWDesire > 0
	then
		J.SetReportMotive( bDebugMode, sMotive )

		--J.SetQueuePtToINT( bot, true )

		bot:ActionQueue_UseAbility( abilityW )
		return
	end

	
	castRDesire, castRTarget, sMotive = X.ConsiderR()
	if castRDesire > 0
	then
		J.SetReportMotive( bDebugMode, sMotive )

		--J.SetQueuePtToINT( bot, false )

		bot:ActionQueue_UseAbilityOnEntity( abilityR, castRTarget )
		return
	end

	castQDesire, castQTarget, sMotive = X.ConsiderQ()
	if castQDesire > 0
	then
		J.SetReportMotive( bDebugMode, sMotive )

		--J.SetQueuePtToINT( bot, false )

		bot:ActionQueue_UseAbilityOnEntity( abilityQ, castQTarget )
		return
	end

	castEDesire, castETarget, sMotive = X.ConsiderE()
	if castEDesire > 0
	then
		J.SetReportMotive( bDebugMode, sMotive )

		--J.SetQueuePtToINT( bot, false )

		bot:ActionQueue_UseAbilityOnEntity( abilityE, castETarget )
		return
	end




end


function X.ConsiderQ()


	if not abilityQ:IsFullyCastable() then return 0 end

	local nSkillLV = abilityQ:GetLevel()
	local nCastRange = abilityQ:GetCastRange()
	local nRadius = 600
	local nCastPoint = abilityQ:GetCastPoint()
	local nManaCost = abilityQ:GetManaCost()
	local nDamage = 0
	local nDamageType = DAMAGE_TYPE_MAGICAL
	local nInRangeEnemyList = J.GetAroundEnemyHeroList( nCastRange )
	local nInBonusEnemyList = J.GetAroundEnemyHeroList( nCastRange + 200 )
	local nLvl = bot:GetLevel()
	local hCastTarget = nil
	local sCastMotive = nil

	if not abilityQ:GetAutoCastState()
	then
		abilityQ:ToggleAutoCast()
	end

	if ( not J.IsRetreating( bot ) )
		and J.IsAllowedToSpam( bot, nManaCost )
	then
		local creepList = bot:GetNearbyNeutralCreeps( nRadius )
		local laneCreepList = bot: GetNearbyLaneCreeps( nCastRange, true )
		if #creepList >= 1
		then
			for _, creep in pairs( creepList )
			do
				if J.IsValid( creep )
					and creep:IsAlive()
					and creep:GetLevel() <= nSkillLV+3
					and ( not creep:IsAncientCreep() or nLvl >= 28)
				then
					hCastTarget = creep
					sCastMotive = 'Q-吃野'
					return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
					--break
				end
			end
		elseif #laneCreepList >= 1
		then
			for _, creep in pairs( laneCreepList)
			do
				if J.IsValid( creep )
					and creep:IsAlive()
					and creep:GetLevel() <= nSkillLV+3
				then
					hCastTarget = creep
					sCastMotive = 'Q-吃兵'
					return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
					--break
				end
			end
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
	local nDamage = abilityW:GetAbilityDamage()
	local nDamageType = DAMAGE_TYPE_MAGICAL
	local nInRangeEnemyList = J.GetAroundEnemyHeroList( nRadius )
	local hCastTarget = nil
	local sCastMotive = nil

	
	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( botTarget )
			and J.IsInRange( botTarget, bot, nCastRange + 100 )
		then			
			hCastTarget = botTarget
			sCastMotive = 'W-攻击:'..J.Chat.GetNormName( hCastTarget )
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
				sCastMotive = 'W-撤退'..J.Chat.GetNormName( hCastTarget )
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
		then
			hCastTarget = creep
			sCastMotive = 'W-带线AOE'..(#laneCreepList)
			return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
		end
	end


	--打野时
	if J.IsFarming( bot )
		and nSkillLV >= 4
		and J.IsAllowedToSpam( bot, nManaCost )
	then
		local targetCreep = bot:GetAttackTarget()
		if J.IsValid( targetCreep )
			and J.IsInRange( bot, targetCreep, nCastRange )
		then
			hCastTarget = targetCreep
			sCastMotive = 'W-打野'
			return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
	    end
	end
	
	
	--打肉 
	if bot:GetActiveMode() == BOT_MODE_ROSHAN
	then
		if J.IsRoshan( botTarget )
			and J.IsInRange( botTarget, bot, nCastRange )
		then
			hCastTarget = botTarget
			sCastMotive = 'W-肉山'
			return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
		end
	end


	return BOT_ACTION_DESIRE_NONE


end


function X.ConsiderE()


	if not abilityE:IsFullyCastable() then return 0 end

	local nSkillLV = abilityE:GetLevel()
	local nCastRange = bot:GetAttackRange()
	local nRadius = 600
	local nCastPoint = abilityE:GetCastPoint()
	local nManaCost = abilityE:GetManaCost()
	local nDamage = abilityE:GetAbilityDamage()
	local nDamageType = DAMAGE_TYPE_MAGICAL
	local nInRangeEnemyList = J.GetAroundEnemyHeroList( nCastRange )
	local nInBonusEnemyList = J.GetAroundEnemyHeroList( nCastRange + 200 )
	local hCastTarget = nil
	local sCastMotive = nil


	--打断
	if #nInRangeEnemyList > 0 then
		for i=1, #nInRangeEnemyList do
			if J.IsValid( nInRangeEnemyList[i] )
				and J.CanCastOnNonMagicImmune( nInRangeEnemyList[i] )
				and J.CanCastOnTargetAdvanced( nInRangeEnemyList[i] )
				and nInRangeEnemyList[i]:IsChanneling()
			then
				hCastTarget = nInRangeEnemyList[i]
				sCastMotive = 'E-打断:'..J.Chat.GetNormName( hCastTarget )
				return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
			end
		end
	end


	--攻击敌人时
	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( botTarget )
			and J.IsInRange( botTarget, bot, nCastRange )
			and J.CanCastOnNonMagicImmune( botTarget )			
			and J.CanCastOnTargetAdvanced( botTarget )
			and not botTarget:HasModifier( 'modifier_item_lotus_orb_active' )
			and not botTarget:HasModifier( 'modifier_antimage_spell_shield' )
		then			
			hCastTarget = botTarget
			sCastMotive = 'W-攻击:'..J.Chat.GetNormName( hCastTarget )
			return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
		end
	end
	

	if J.IsInTeamFight( bot, 1200 )
	then
		local npcMostDangerousEnemy = nil
		local nMostDangerousDamage = 0

		for _, npcEnemy in pairs( nInRangeEnemyList )
		do
			if J.IsValid( npcEnemy )
				and J.CanCastOnNonMagicImmune( npcEnemy )
				and J.CanCastOnTargetAdvanced( npcEnemy )
				and not J.IsDisabled( npcEnemy )
				and not npcEnemy:HasModifier( 'modifier_item_lotus_orb_active' )
				and not npcEnemy:HasModifier( 'modifier_antimage_spell_shield' )
			then
				local npcEnemyDamage = npcEnemy:GetEstimatedDamageToTarget( false, bot, 3.0, DAMAGE_TYPE_PHYSICAL )
				if ( npcEnemyDamage > nMostDangerousDamage )
				then
					nMostDangerousDamage = npcEnemyDamage
					npcMostDangerousEnemy = npcEnemy
				end
			end
		end

		if ( npcMostDangerousEnemy ~= nil )
		then
			sCastMotive = 'W-团战打大哥:'..J.Chat.GetNormName( hCastTarget )
			return BOT_ACTION_DESIRE_HIGH, npcMostDangerousEnemy, sCastMotive
		end
	end


	if ( bot:GetActiveMode() == BOT_MODE_ROSHAN )
	then
		local npcTarget = bot:GetAttackTarget()
		if ( J.IsRoshan( npcTarget )
			and J.IsInRange( npcTarget, bot, nCastRange + 150 )
			and not J.IsDisabled( npcTarget ) )
		then
			sCastMotive = 'W-打肉山:'..J.Chat.GetNormName( hCastTarget )
			return BOT_ACTION_DESIRE_LOW, npcTarget, sCastMotive
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
	local nInRangeEnemyList = J.GetAroundEnemyHeroList( nCastRange )
	local nInBonusEnemyList = J.GetAroundEnemyHeroList( nCastRange + 200 )
	local hCastTarget = nil
	local sCastMotive = nil

	--攻击敌人时
	if J.IsGoingOnSomeone( bot )
	then
		if J.IsValidHero( botTarget )
			and J.IsInRange( botTarget, bot, nCastRange )
			and J.CanCastOnNonMagicImmune( botTarget )			
			and J.CanCastOnTargetAdvanced( botTarget )
			and not botTarget:HasModifier( 'modifier_item_lotus_orb_active' )
			and not botTarget:HasModifier( 'modifier_antimage_spell_shield' )
		then			
			hCastTarget = botTarget
			sCastMotive = 'R-攻击:'..J.Chat.GetNormName( hCastTarget )
			return BOT_ACTION_DESIRE_HIGH, hCastTarget, sCastMotive
		end
	end
	

	if J.IsInTeamFight( bot, 1200 )
	then
		local npcMostDangerousEnemy = nil
		local nMostDangerousDamage = 0

		for _, npcEnemy in pairs( nInRangeEnemyList )
		do
			if J.IsValid( npcEnemy )
				and J.CanCastOnNonMagicImmune( npcEnemy )
				and J.CanCastOnTargetAdvanced( npcEnemy )
				and not J.IsDisabled( npcEnemy )
				and not npcEnemy:HasModifier( 'modifier_item_lotus_orb_active' )
				and not npcEnemy:HasModifier( 'modifier_antimage_spell_shield' )
			then
				local npcEnemyDamage = npcEnemy:GetEstimatedDamageToTarget( false, bot, 3.0, DAMAGE_TYPE_PHYSICAL )
				if ( npcEnemyDamage > nMostDangerousDamage )
				then
					nMostDangerousDamage = npcEnemyDamage
					npcMostDangerousEnemy = npcEnemy
				end
			end
		end

		if ( npcMostDangerousEnemy ~= nil )
		then
			sCastMotive = 'R-团战打大哥:'..J.Chat.GetNormName( hCastTarget )
			return BOT_ACTION_DESIRE_HIGH, npcMostDangerousEnemy, sCastMotive
		end
	end


	return BOT_ACTION_DESIRE_NONE


end


return X
-- dota2jmz@163.com QQ:2462331592..

