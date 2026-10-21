-- ============================================================================
-- 大明家族人生模拟 - 乡里事务系统 (C2)
-- 品级≥6触发的乡里事务事件池
-- 特点：3选项深度策略、可触发战斗、连锁后果、动态数值
-- ============================================================================

local GameData = require("Data.GameData")
local EraSystem = require("Data.EraSystem")
local EventSystem = require("Systems.EventSystem")

local events = {}

-- ============================================================================
-- 辅助函数
-- ============================================================================

--- 根据品级计算差事奖惩基数
local function GetMissionScale(rank)
    local scales = {
        [6] = 1.0, [7] = 1.5, [8] = 2.2, [9] = 3.0,
    }
    return scales[rank] or 1.0
end

--- 获取所有可用战士（按武艺降序）
local function GetAllFighters()
    local candidates = {}
    for _, m in ipairs(GameData.GetAliveMembers()) do
        if m.gender == "male" and m.age >= 16 and m.age <= 55
           and m.health > 20 and m.state ~= "生病" then
            candidates[#candidates + 1] = m
        end
    end
    table.sort(candidates, function(a, b) return (a.martial or 0) > (b.martial or 0) end)
    return candidates
end

--- 获取前N个战士的名字列表（用于描述文本）
local function GetFighterNames(fighters, count)
    local names = {}
    for i = 1, math.min(count or 4, #fighters) do
        names[#names + 1] = fighters[i].name
    end
    return names
end

--- 获取族中官员（知县/知府/宣政使）
local function GetOfficials()
    local officials = {}
    for _, m in ipairs(GameData.GetAliveMembers()) do
        if m.officialRank and m.officialRank ~= "" then
            officials[#officials + 1] = m
        end
    end
    return officials
end

--- 获取族中读书人
local function GetScholars()
    local scholars = {}
    for _, m in ipairs(GameData.GetAliveMembers()) do
        if m.state == "读书" or m.identity == "书生" or m.identity == "才俊"
           or m.identity == "名士" then
            scholars[#scholars + 1] = m
        end
    end
    return scholars
end

-- ============================================================================
-- 1. 乡勇清剿 —— 乡里公议清剿匪患，可触发3D战斗
-- ============================================================================
events[#events + 1] = {
    id = "court_bandit_suppression",
    title = "乡勇清剿",
    rankRange = {6, 9},
    weight = 10,
    cooldownMonths = 8,
    isDisaster = false,
    isChainEvent = false,
    check = function(s)
        local fighters = GetAllFighters()
        return #fighters > 0
    end,
    execute = function(s, report)
        local scale = GetMissionScale(s.clanRank)
        local allFighters = GetAllFighters()
        local fighterNames = GetFighterNames(allFighters, 3)
        local nameStr = table.concat(fighterNames, "、")

        local bribeCost = math.floor(40 * scale)
        local hireCost = math.floor(60 * scale)
        local fameReward = math.floor(25 * scale)
        local fameLoss = math.floor(15 * scale)

        report.events[#report.events + 1] = "乡里公议集资清剿匪患。"
        GameData.AddLog("乡里推我族牵头，须限期平定匪患。")

        local banditNames = {"黑风寨", "青狼山", "白莲余孽", "红巾残部", "九连山匪帮"}
        local banditName = banditNames[math.random(1, #banditNames)]

        return {
            title = "乡勇清剿",
            desc = "武曹行文至本族：" .. banditName .. "盘踞山林，劫掠商旅，为祸一方。"
                .. "乡中耆老联名恳请我族牵头清剿，推诿者恐失乡望。\n\n"
                .. "族中可战之人：" .. nameStr .. "（武艺最高者" .. (allFighters[1] and allFighters[1].martial or 0) .. "）",
            choices = {
                -- 选项1：亲自出兵剿匪（3D战斗）
                { text = "派族人亲率兵丁剿匪（战斗）", effect = function()
                    if #allFighters == 0 then
                        s.pendingEvents[#s.pendingEvents + 1] = {
                            title = "无人可战",
                            desc = "族中无人能战，只得花银子雇佣镖师代为剿匪，耗费巨大。",
                            choices = { { text = "罢了", effect = function()
                                GameData.AddResource("silver", -hireCost)
                                GameData.AddLog("雇佣镖师剿匪，耗银" .. hireCost .. "两。")
                            end } }
                        }
                        return
                    end
                    local RivalClans = require("Data.RivalClans")
                    -- 生成匪寇rival数据
                    local tierIndex = math.min(4, math.max(1, s.clanRank - 4))
                    local tier = RivalClans.DIFFICULTY_TIERS[tierIndex]
                    local memberCount = math.random(tier.memberRange[1], tier.memberRange[2])
                    local surnames = {"马", "韩", "黄", "吴", "曹"}
                    local surname = surnames[math.random(1, #surnames)]
                    local members = {}
                    local names = {"虎", "豹", "龙", "蛟", "猛", "刚", "铁", "狼", "彪", "熊"}
                    for j = 1, memberCount do
                        local isLeader = (j == 1)
                        local mart = math.random(tier.martialRange[1], tier.martialRange[2])
                        local hp = math.random(tier.healthRange[1], tier.healthRange[2])
                        if isLeader then mart = math.min(100, mart + 15); hp = math.min(100, hp + 10) end
                        members[j] = {
                            name = surname .. names[math.random(1, #names)],
                            gender = "male",
                            age = isLeader and math.random(30, 50) or math.random(18, 45),
                            title = isLeader and "匪首" or nil,
                            martial = mart, health = hp,
                            isLeader = isLeader, memberIndex = j,
                        }
                    end
                    local soldiers = math.random(tier.soldierRange[1], tier.soldierRange[2])
                    soldiers = math.floor(soldiers / 100) * 100
                    if soldiers < 100 then soldiers = 100 end
                    local rewardMul = tier.rewardMul * 0.8
                    local rival = {
                        id = 0, name = banditName, surname = surname,
                        tierId = tier.id, tierName = tier.name,
                        tierColor = tier.color, tierDesc = "乡里事务",
                        members = members, soldiers = soldiers,
                        rewards = {
                            silver = math.floor(20 * rewardMul * scale),
                            grain = math.floor(15 * rewardMul * scale),
                            fame = math.floor(fameReward * 1.5),
                        },
                        unitStyle = "bandit",
                    }
                    local defeatPenalty = {
                        silver = math.floor(30 * scale),
                        grain = math.floor(20 * scale),
                        cloth = 0,
                        fame = fameLoss,
                    }
                    local victoryBonus = { fame = fameReward }
                    local GS = require("UI.GameScreen")
                    GS.EventBattle(allFighters, rival, {
                        soldierCount = 0,
                        onSettle = function(result, rivalData, deployedIds)
                            -- 自定义结算
                            if result == "victory" then
                                GameData.AddResource("silver", rivalData.rewards.silver)
                                GameData.AddResource("grain", rivalData.rewards.grain)
                                GameData.AddResource("fame", rivalData.rewards.fame)
                                GameData.AddLog("剿灭" .. banditName .. "！乡里酬谢银" ..
                                    rivalData.rewards.silver .. "两、声望+" .. rivalData.rewards.fame)
                            else
                                GameData.AddResource("silver", -defeatPenalty.silver)
                                GameData.AddResource("grain", -defeatPenalty.grain)
                                GameData.AddResource("fame", -defeatPenalty.fame)
                                GameData.AddLog("剿匪失利，损失银" .. defeatPenalty.silver ..
                                    "两、声望-" .. defeatPenalty.fame)
                            end
                            -- 出战族人伤亡
                            for _, memberId in ipairs(deployedIds) do
                                local member = GameData.GetMember(memberId)
                                if member then
                                    local injuryRoll = math.random(100)
                                    local threshold = (result == "victory") and 15 or 50
                                    if injuryRoll < threshold then
                                        local loss = math.random(5, 20)
                                        if result == "defeat" then loss = loss + 10 end
                                        member.health = math.max(1, member.health - loss)
                                        if member.health <= 10 then
                                            if member.state ~= "生病" then member.prevState = member.state end
                                            member.state = "生病"
                                        end
                                    end
                                end
                            end
                        end,
                    })
                end },
                -- 选项2：花钱雇佣镖师代劳
                { text = "雇佣镖师代为剿匪（-" .. hireCost .. "银两）", effect = function()
                    if s.silver < hireCost then
                        GameData.AddResource("silver", -math.floor(hireCost * 0.5))
                        GameData.AddResource("fame", -fameLoss)
                        GameData.AddLog("银两不足，镖师半途而废，匪患未清，乡邻颇有怨言。")
                    else
                        GameData.AddResource("silver", -hireCost)
                        GameData.AddResource("fame", math.floor(fameReward * 0.5))
                        GameData.AddLog("镖师代为剿匪，虽非亲力亲为，乡里亦认这份情。")
                    end
                end },
                -- 选项3：贿赂上官周旋
                { text = "上下打点免去差事（-" .. bribeCost .. "银两，声望-" .. fameLoss .. "）", effect = function()
                    GameData.AddResource("silver", -bribeCost)
                    GameData.AddResource("fame", -fameLoss)
                    GameData.AddLog("花银打点上官，剿匪之事推给他族，然声名有损。")
                end },
            }
        }
    end,
}

-- ============================================================================
-- 2. 河渠修缮 —— 乡里公推主持河工，涉及大量资源调配
-- ============================================================================
events[#events + 1] = {
    id = "court_river_project",
    title = "河渠修缮",
    rankRange = {6, 9},
    weight = 9,
    cooldownMonths = 10,
    isDisaster = false,
    isChainEvent = false,
    check = function(s)
        return s.silver >= 50
    end,
    execute = function(s, report)
        local scale = GetMissionScale(s.clanRank)
        local investHigh = math.floor(80 * scale)
        local investMid = math.floor(40 * scale)
        local grainCost = math.floor(30 * scale)
        local fameHigh = math.floor(35 * scale)
        local fameMid = math.floor(15 * scale)
        local profitCut = math.floor(25 * scale)

        report.events[#report.events + 1] = "乡里公推我族主持河渠修缮。"
        GameData.AddLog("奉旨督办河工，责任重大。")

        return {
            title = "河渠修缮",
            desc = "大河连年决堤，殃及数县，乡里凑出公帑修筑堤坝，公推本族主持此事。"
                .. "河工乃国之大计，办好则功在社稷，然其中猫腻极多——"
                .. "工料采购、民夫征发、银款调拨，每一环节皆有油水可揩。\n\n"
                .. "如何行事，关系家族声望与乡邻信服。",
            choices = {
                -- 选项1：廉洁奉公
                { text = "清廉督办，自掏腰包补缺（-" .. investHigh .. "银-" .. grainCost .. "粮）",
                  effect = function()
                    GameData.AddResource("silver", -investHigh)
                    GameData.AddResource("grain", -grainCost)
                    GameData.AddResource("fame", fameHigh)
                    GameData.AddLog("河工督办清廉如水，堤坝坚固，朝野交口称赞。声望+" .. fameHigh)
                    -- 连锁：后续可能获乡里嘉奖
                    if math.random(100) <= 40 then
                        s.pendingEvents[#s.pendingEvents + 1] = {
                            title = "乡里嘉奖",
                            desc = "河工告竣，堤坝坚固，经秋汛而不溃。乡里感念功德，特赠「泽被桑梓」匾额、酬银百两。",
                            choices = { { text = "谢恩", effect = function()
                                GameData.AddResource("silver", math.floor(60 * scale))
                                GameData.AddResource("fame", math.floor(20 * scale))
                                GameData.AddLog("河工有功，获乡里酬谢银两及匾额。")
                            end } }
                        }
                    end
                end },
                -- 选项2：中规中矩
                { text = "按部就班办理，不贪不亏（-" .. investMid .. "银两）",
                  effect = function()
                    GameData.AddResource("silver", -investMid)
                    GameData.AddResource("fame", fameMid)
                    GameData.AddLog("河工循例办理，虽无出彩亦算交差。声望+" .. fameMid)
                end },
                -- 选项3：中饱私囊
                { text = "暗中克扣工料，从中牟利（+" .. profitCut .. "银两，风险）",
                  effect = function()
                    GameData.AddResource("silver", profitCut)
                    -- 30%概率被查出
                    if math.random(100) <= 30 then
                        local penalty = math.floor(profitCut * 2.5)
                        local famePenalty = math.floor(30 * scale)
                        GameData.AddResource("silver", -penalty)
                        GameData.AddResource("fame", -famePenalty)
                        GameData.AddLog("克扣工料事发！乡里哗然，罚银" .. penalty .. "两、声望-" .. famePenalty)
                        s.pendingEvents[#s.pendingEvents + 1] = {
                            title = "河工弊案",
                            desc = "乡老查出河工贪墨，所修堤坝偷工减料、遇汛即溃。"
                                .. "乡老联名上告，严查到底。族人被罚银"
                                .. penalty .. "两，声望大损。",
                            choices = { { text = "咎由自取", effect = function() end } }
                        }
                    else
                        GameData.AddResource("fame", -5)
                        GameData.AddLog("暗中得利" .. profitCut .. "银两，幸未被察觉。")
                    end
                end },
            }
        }
    end,
}

-- ============================================================================
-- 3. 护乡御寇 —— 乡里急请护乡御寇，高风险高回报
-- ============================================================================
events[#events + 1] = {
    id = "court_quell_rebellion",
    title = "护乡御寇",
    rankRange = {7, 9},
    weight = 8,
    cooldownMonths = 12,
    isDisaster = false,
    isChainEvent = false,
    check = function(s)
        local fighters = GetAllFighters()
        return #fighters > 0 and s.year >= 1400
    end,
    execute = function(s, report)
        local scale = GetMissionScale(s.clanRank)
        local allFighters = GetAllFighters()
        local fighterNames = GetFighterNames(allFighters, 4)
        local nameStr = table.concat(fighterNames, "、")

        local silverCost = math.floor(80 * scale)
        local grainCost = math.floor(60 * scale)
        local fameWin = math.floor(50 * scale)
        local fameLoss = math.floor(25 * scale)

        local rebels = {"豪强作乱", "流民举事", "山匪聚众", "邪教惑众", "矿工暴动"}
        local rebelName = rebels[math.random(1, #rebels)]

        report.events[#report.events + 1] = rebelName .. "！乡里急请我族主持防务。"
        GameData.AddLog("变乱骤起——" .. rebelName .. "，乡里急请各地大户护乡。")

        return {
            title = "护乡御寇",
            desc = rebelName .. "！乱军势大，连破数寨。乡里急请各地大户出资出兵，共保桑梓。\n\n"
                .. "此乃赌上身家性命的大事——护乡有功则名重一方、荣耀无上；"
                .. "若叛军势不可挡，则族人性命堪忧。\n\n"
                .. "可用之将：" .. nameStr,
            choices = {
                -- 选项1：倾力护乡（触发高难度战斗）
                { text = "倾力护乡、以命相搏（战斗，高难度）", effect = function()
                    if #allFighters == 0 then
                        GameData.AddResource("fame", -fameLoss)
                        GameData.AddLog("族中无人可战，护乡之请未能应承，乡邻失望。")
                        return
                    end
                    local RivalClans = require("Data.RivalClans")
                    local tierIndex = math.min(4, s.clanRank - 4)
                    if tierIndex < 2 then tierIndex = 2 end
                    local tier = RivalClans.DIFFICULTY_TIERS[tierIndex]
                    local memberCount = math.random(tier.memberRange[1] + 1, tier.memberRange[2] + 2)
                    memberCount = math.min(memberCount, 8)
                    local members = {}
                    local rebelSurnames = {"张", "李", "王", "刘", "陈"}
                    local surname = rebelSurnames[math.random(1, #rebelSurnames)]
                    local gnames = {"献忠", "自成", "天王", "九龙", "铁牛", "大彪", "豹子", "猛虎"}
                    for j = 1, memberCount do
                        local isLeader = (j == 1)
                        local mart = math.random(tier.martialRange[1] + 5, math.min(100, tier.martialRange[2] + 10))
                        local hp = math.random(tier.healthRange[1] + 5, math.min(100, tier.healthRange[2] + 10))
                        if isLeader then mart = math.min(100, mart + 20); hp = math.min(100, hp + 15) end
                        members[j] = {
                            name = surname .. gnames[math.random(1, #gnames)],
                            gender = "male",
                            age = isLeader and math.random(30, 50) or math.random(18, 45),
                            title = isLeader and "叛军主帅" or nil,
                            martial = mart, health = hp,
                            isLeader = isLeader, memberIndex = j,
                        }
                    end
                    local soldiers = math.random(tier.soldierRange[1], tier.soldierRange[2]) + 200
                    soldiers = math.floor(soldiers / 100) * 100
                    local rival = {
                        id = 0, name = "叛军", surname = surname,
                        tierId = tier.id, tierName = tier.name,
                        tierColor = tier.color, tierDesc = "护乡御寇",
                        members = members, soldiers = soldiers,
                        rewards = {
                            silver = math.floor(40 * scale),
                            grain = math.floor(30 * scale),
                            fame = fameWin,
                        },
                    }
                    local defeatPenalty = {
                        silver = silverCost,
                        grain = grainCost,
                        cloth = math.floor(15 * scale),
                        fame = fameLoss * 2,
                    }
                    local GS = require("UI.GameScreen")
                    GS.EventBattle(allFighters, rival, {
                        soldierCount = 0,
                        onSettle = function(result, rivalData, deployedIds)
                            if result == "victory" then
                                GameData.AddResource("silver", rivalData.rewards.silver)
                                GameData.AddResource("grain", rivalData.rewards.grain)
                                GameData.AddResource("fame", rivalData.rewards.fame)
                                GameData.AddLog("护乡大捷！乡里论功行赏，声望+" .. rivalData.rewards.fame)
                                -- 连锁嘉奖
                                s.pendingEvents[#s.pendingEvents + 1] = {
                                    title = "护乡嘉奖",
                                    desc = "护乡大功告成，乡邻感念不已！耆老亲赠「义卫乡里」金匾，酬银百两，并许以乡约主事之名。\n\n"
                                        .. "此一战定乾坤，家族声威达到顶峰。",
                                    choices = { { text = "谢主隆恩", effect = function()
                                        GameData.AddResource("silver", math.floor(80 * scale))
                                        GameData.AddResource("fame", math.floor(30 * scale))
                                        GameData.AddLog("护乡嘉奖！获赐银两及乡望。")
                                    end } }
                                }
                            else
                                GameData.AddResource("silver", -defeatPenalty.silver)
                                GameData.AddResource("grain", -defeatPenalty.grain)
                                GameData.AddResource("cloth", -defeatPenalty.cloth)
                                GameData.AddResource("fame", -defeatPenalty.fame)
                                GameData.AddLog("护乡失利！损失惨重，乡邻责难。")
                            end
                            -- 高伤亡
                            for _, memberId in ipairs(deployedIds) do
                                local member = GameData.GetMember(memberId)
                                if member then
                                    if result == "defeat" and math.random(100) <= 12 then
                                        member.state = "已故"
                                        member.deathAge = member.age
                                        member.deathYear = s.year
                                        member.deathCause = "战死"
                                        GameData.AddLog(member.name .. "平叛战死，英勇殉国。")
                                    elseif math.random(100) <= ((result == "victory") and 20 or 60) then
                                        local loss = math.random(8, 25)
                                        member.health = math.max(1, member.health - loss)
                                        if member.health <= 10 then
                                            if member.state ~= "生病" then member.prevState = member.state end
                                            member.state = "生病"
                                        end
                                    end
                                end
                            end
                        end,
                    })
                end },
                -- 选项2：出钱出粮不出人
                { text = "捐资助饷（-" .. silverCost .. "银-" .. grainCost .. "粮）",
                  effect = function()
                    GameData.AddResource("silver", -silverCost)
                    GameData.AddResource("grain", -grainCost)
                    GameData.AddResource("fame", math.floor(fameWin * 0.4))
                    GameData.AddLog("只捐银不派人，未亲赴前线，乡邻略有不满。")
                end },
                -- 选项3：称病观望
                { text = "称病不出、静观其变（声望-" .. fameLoss .. "）",
                  effect = function()
                    GameData.AddResource("fame", -fameLoss)
                    -- 50%概率被追责
                    if math.random(100) <= 50 then
                        local fine = math.floor(40 * scale)
                        GameData.AddResource("silver", -fine)
                        GameData.AddLog("称病不出被人识破，乡里罚银" .. fine .. "两、声望大损。")
                    else
                        GameData.AddLog("称病避战，暂未被追究，然名声有损。")
                    end
                end },
            }
        }
    end,
}

-- ============================================================================
-- 4. 乡里赈济 —— 乡里公推我族主持赈济，考验人品与能力
-- ============================================================================
events[#events + 1] = {
    id = "court_famine_relief",
    title = "乡里赈济",
    rankRange = {6, 9},
    weight = 9,
    cooldownMonths = 8,
    isDisaster = false,
    isChainEvent = false,
    check = function(s)
        return s.grain >= 30
    end,
    execute = function(s, report)
        local scale = GetMissionScale(s.clanRank)
        local grainHigh = math.floor(60 * scale)
        local silverHigh = math.floor(30 * scale)
        local grainMid = math.floor(25 * scale)
        local silverMid = math.floor(10 * scale)
        local fameHigh = math.floor(30 * scale)
        local fameMid = math.floor(12 * scale)
        local profit = math.floor(35 * scale)

        report.events[#report.events + 1] = "乡里公推我族主持赈济。"
        GameData.AddLog("受乡里之托，主持赈济事宜。")

        local disasterAreas = {"河南", "山东", "湖广", "江西", "陕西"}
        local area = disasterAreas[math.random(1, #disasterAreas)]

        return {
            title = "乡里赈济",
            desc = area .. "大灾，饥民遍野。乡里公推本族主持赈济事宜，凑出赈银粮米若干。\n\n"
                .. "灾区哀鸿遍野，然赈灾之银亦是一笔巨款——"
                .. "清廉者倾囊相助可得万民颂扬，贪墨者中饱私囊亦多有先例。\n\n"
                .. "当如何行事，全凭良心。",
            choices = {
                -- 选项1：倾力赈灾
                { text = "额外捐粮赈灾（-" .. grainHigh .. "粮-" .. silverHigh .. "银）",
                  effect = function()
                    GameData.AddResource("grain", -grainHigh)
                    GameData.AddResource("silver", -silverHigh)
                    GameData.AddResource("fame", fameHigh)
                    GameData.AddLog("倾力赈灾，活人无数，声望大增。声望+" .. fameHigh)
                    -- 30%概率获得灾民感恩投效
                    if math.random(100) <= 30 then
                        s.pendingEvents[#s.pendingEvents + 1] = {
                            title = "灾民投效",
                            desc = "赈灾之恩深入人心，灾民中有能工巧匠数人感念恩德，愿举家投效本族效力。",
                            choices = {
                                { text = "欣然接纳", effect = function()
                                    GameData.AddResource("fame", 5)
                                    -- 增加人口
                                    local pop = math.random(2, 5)
                                    s.population = (s.population or 0) + pop
                                    GameData.AddLog("灾民" .. pop .. "口投效入族。")
                                end },
                                { text = "婉言谢绝", effect = function()
                                    GameData.AddLog("婉拒灾民投效。")
                                end },
                            }
                        }
                    end
                end },
                -- 选项2：中规中矩
                { text = "按额赈济不多不少（-" .. grainMid .. "粮-" .. silverMid .. "银）",
                  effect = function()
                    GameData.AddResource("grain", -grainMid)
                    GameData.AddResource("silver", -silverMid)
                    GameData.AddResource("fame", fameMid)
                    GameData.AddLog("赈灾按部就班，交差了事。声望+" .. fameMid)
                end },
                -- 选项3：贪墨赈银
                { text = "侵吞赈银（+" .. profit .. "银两，风险极大）",
                  effect = function()
                    GameData.AddResource("silver", profit)
                    -- 40%概率被弹劾
                    if math.random(100) <= 40 then
                        local penalty = math.floor(profit * 3)
                        local famePenalty = math.floor(40 * scale)
                        GameData.AddResource("silver", -penalty)
                        GameData.AddResource("fame", -famePenalty)
                        GameData.AddLog("侵吞赈银事发！乡老联名上告，罚银" .. penalty .. "两、声望-" .. famePenalty)
                        s.pendingEvents[#s.pendingEvents + 1] = {
                            title = "赈灾贪墨案",
                            desc = "赈灾贪墨之事败露，乡老联名上告，官府震怒，"
                                .. "下旨严惩——族人被罚没家产、革去功名。\n\n"
                                .. "罚银" .. penalty .. "两，声望-" .. famePenalty,
                            choices = { { text = "自食恶果", effect = function() end } }
                        }
                    else
                        GameData.AddResource("fame", -8)
                        GameData.AddLog("暗中侵吞赈银" .. profit .. "两，幸未败露。")
                    end
                end },
            }
        }
    end,
}

-- ============================================================================
-- 5. 族产核账 —— 族老请来账房稽查族产账目
-- ============================================================================
events[#events + 1] = {
    id = "court_tax_audit",
    title = "族产核账",
    rankRange = {6, 9},
    weight = 8,
    cooldownMonths = 8,
    isDisaster = false,
    isChainEvent = false,
    check = function(s)
        return #s.industries >= 3
    end,
    execute = function(s, report)
        local scale = GetMissionScale(s.clanRank)
        local indCount = #s.industries
        local taxBase = math.floor(indCount * 8 * scale)
        local bribeCost = math.floor(taxBase * 0.6)
        local bonusTax = math.floor(taxBase * 1.5)
        local fameGain = math.floor(15 * scale)
        local fameLoss = math.floor(10 * scale)

        report.events[#report.events + 1] = "族老请来账房稽查族产账目。"
        GameData.AddLog("税官登门，稽查本族产业税赋。")

        return {
            title = "族产核账",
            desc = "度支曹派遣税官稽查地方税赋，本族产业" .. indCount
                .. "处，乃重点稽查对象。\n\n"
                .. "税官明查暗访，逐一核对账册。据初步核算，应补税银约" .. taxBase .. "两。\n\n"
                .. "然税官亦非铁面无私之人...",
            choices = {
                -- 选项1：如实缴税
                { text = "如实补缴税款（-" .. taxBase .. "银两，声望+" .. fameGain .. "）",
                  effect = function()
                    GameData.AddResource("silver", -taxBase)
                    GameData.AddResource("fame", fameGain)
                    GameData.AddLog("如实补缴税银" .. taxBase .. "两，税官上报'纳税模范'。")
                end },
                -- 选项2：贿赂税官
                { text = "暗中打点税官（-" .. bribeCost .. "银两）",
                  effect = function()
                    GameData.AddResource("silver", -bribeCost)
                    -- 20%概率税官翻脸
                    if math.random(100) <= 20 then
                        GameData.AddResource("silver", -bonusTax)
                        GameData.AddResource("fame", -fameLoss * 2)
                        GameData.AddLog("税官收钱后翻脸加倍征收！补税" .. bonusTax .. "两、声望大损。")
                    else
                        GameData.AddResource("fame", -5)
                        GameData.AddLog("打点税官" .. bribeCost .. "银，免去大部分补税。")
                    end
                end },
                -- 选项3：据理力争
                { text = "据理力争、要求重新核算",
                  effect = function()
                    -- 50%概率减税，50%概率加税
                    if math.random(100) <= 50 then
                        local reduced = math.floor(taxBase * 0.4)
                        GameData.AddResource("silver", -reduced)
                        GameData.AddResource("fame", math.floor(fameGain * 0.5))
                        GameData.AddLog("据理力争有效，仅需补税" .. reduced .. "两。")
                    else
                        GameData.AddResource("silver", -bonusTax)
                        GameData.AddResource("fame", -fameLoss)
                        GameData.AddLog("与税官争执激怒上官，加倍征收" .. bonusTax .. "两！")
                    end
                end },
            }
        }
    end,
}

-- ============================================================================
-- 6. 商路斡旋 —— 乡里托族中出面与邻郡通商
-- ============================================================================
events[#events + 1] = {
    id = "court_diplomacy",
    title = "商路斡旋",
    rankRange = {7, 9},
    weight = 7,
    cooldownMonths = 12,
    isDisaster = false,
    isChainEvent = false,
    check = function(s)
        local scholars = GetScholars()
        return #scholars > 0
    end,
    execute = function(s, report)
        local scale = GetMissionScale(s.clanRank)
        local scholars = GetScholars()
        local envoy = scholars[1]

        local silverCost = math.floor(50 * scale)
        local clothCost = math.floor(20 * scale)
        local fameWin = math.floor(35 * scale)
        local tradeProfit = math.floor(45 * scale)

        report.events[#report.events + 1] = "乡里托族中" .. envoy.name .. "赴邻郡通商。"
        GameData.AddLog(envoy.name .. "启程赴邻郡通商。")

        local nations = {"安南", "暹罗", "琉球", "日本", "朝鲜"}
        local nation = nations[math.random(1, #nations)]

        return {
            title = "商路斡旋",
            desc = "乡里托族中" .. envoy.name .. "（学识" .. (envoy.knowledge or 0)
                .. "）为使臣出使" .. nation .. "。\n\n"
                .. "远赴邻郡路途遥远、险阻重重，然若斡旋得力，不仅乡里称便，"
                .. "更可为族中开辟海外商路。\n\n"
                .. "使团规格直接影响出使成败。",
            choices = {
                -- 选项1：大规模使团
                { text = "组建豪华使团（-" .. silverCost .. "银-" .. clothCost .. "布匹）",
                  effect = function()
                    GameData.AddResource("silver", -silverCost)
                    GameData.AddResource("cloth", -clothCost)
                    -- 学识决定成功率
                    local knowledge = envoy.knowledge or 50
                    local successRate = math.min(85, 40 + knowledge * 0.5)
                    if math.random(100) <= successRate then
                        GameData.AddResource("fame", fameWin)
                        GameData.AddResource("silver", tradeProfit)
                        GameData.AddLog(envoy.name .. "出使" .. nation .. "大获成功！"
                            .. "开辟商路获利" .. tradeProfit .. "银、声望+" .. fameWin)
                    else
                        GameData.AddResource("fame", math.floor(fameWin * 0.3))
                        GameData.AddLog(envoy.name .. "出使" .. nation .. "，虽未尽全功亦有所获。")
                    end
                end },
                -- 选项2：轻装简行
                { text = "轻车简从出使（-" .. math.floor(silverCost * 0.3) .. "银两）",
                  effect = function()
                    GameData.AddResource("silver", -math.floor(silverCost * 0.3))
                    local knowledge = envoy.knowledge or 50
                    local successRate = math.min(60, 20 + knowledge * 0.4)
                    if math.random(100) <= successRate then
                        GameData.AddResource("fame", math.floor(fameWin * 0.6))
                        GameData.AddResource("silver", math.floor(tradeProfit * 0.4))
                        GameData.AddLog(envoy.name .. "轻装出使" .. nation .. "，不辱使命。")
                    else
                        GameData.AddResource("fame", -5)
                        GameData.AddLog(envoy.name .. "通商未果，邻郡轻慢来使。")
                    end
                end },
                -- 选项3：推辞不去
                { text = "以故推辞不去（声望-" .. math.floor(fameWin * 0.4) .. "）",
                  effect = function()
                    GameData.AddResource("fame", -math.floor(fameWin * 0.4))
                    GameData.AddLog("推辞通商之托，乡邻颇有不满。")
                end },
            }
        }
    end,
}

-- ============================================================================
-- 7. 文坛争鸣 —— 两大文脉流派拉拢，涉及站队风险
-- ============================================================================
events[#events + 1] = {
    id = "court_power_struggle",
    title = "文坛争鸣",
    rankRange = {7, 9},
    weight = 8,
    cooldownMonths = 10,
    isDisaster = false,
    isChainEvent = false,
    check = function(s)
        return s.fame >= 100
    end,
    execute = function(s, report)
        local scale = GetMissionScale(s.clanRank)
        local bribeSilver = math.floor(60 * scale)
        local fameSwing = math.floor(35 * scale)

        local factions = {
            { name = "宗文书院山长", reward = "silver", amt = math.floor(80 * scale) },
            { name = "江南诗社盟主", reward = "fame", amt = math.floor(40 * scale) },
            { name = "织造行会首", reward = "grain", amt = math.floor(50 * scale) },
        }
        local factionA = factions[math.random(1, #factions)]
        local factionB = factions[math.random(1, #factions)]
        while factionB.name == factionA.name do
            factionB = factions[math.random(1, #factions)]
        end

        report.events[#report.events + 1] = "文坛两大流派相互攻讦，试图拉拢本族。"
        GameData.AddLog(factionA.name .. "与" .. factionB.name .. "争鸣，族人被迫抉择。")

        return {
            title = "文坛争鸣",
            desc = factionA.name .. "与" .. factionB.name
                .. "各执一说、势同水火，皆遣人登门求我族表态。\n\n"
                .. "附议" .. factionA.name .. "可得" .. factionA.reward .. "+"
                .. factionA.amt .. "；\n"
                .. "附议" .. factionB.name .. "可得" .. factionB.reward .. "+"
                .. factionB.amt .. "。\n\n"
                .. "但站错一边的代价不小——落败一方的门生故旧难免受牵连。",
            choices = {
                -- 选项1：站A方
                { text = "附议" .. factionA.name, effect = function()
                    -- 55%概率A方获胜
                    if math.random(100) <= 55 then
                        GameData.AddResource(factionA.reward, factionA.amt)
                        GameData.AddResource("fame", math.floor(fameSwing * 0.8))
                        GameData.AddLog("附议" .. factionA.name .. "得势！获" .. factionA.reward
                            .. "+" .. factionA.amt .. "，声望大增。")
                    else
                        GameData.AddResource("silver", -bribeSilver)
                        GameData.AddResource("fame", -fameSwing)
                        GameData.AddLog(factionA.name .. "落败！本族受牵连，损失惨重。")
                    end
                end },
                -- 选项2：站B方
                { text = "附议" .. factionB.name, effect = function()
                    -- 45%概率B方获胜
                    if math.random(100) <= 45 then
                        GameData.AddResource(factionB.reward, factionB.amt)
                        GameData.AddResource("fame", math.floor(fameSwing * 0.8))
                        GameData.AddLog("附议" .. factionB.name .. "得势！获" .. factionB.reward
                            .. "+" .. factionB.amt .. "，声望大增。")
                    else
                        GameData.AddResource("silver", -bribeSilver)
                        GameData.AddResource("fame", -fameSwing)
                        GameData.AddLog(factionB.name .. "落败！本族受牵连，损失惨重。")
                    end
                end },
                -- 选项3：两不相帮
                { text = "置身事外、两不相帮", effect = function()
                    GameData.AddResource("fame", -math.floor(fameSwing * 0.2))
                    GameData.AddLog("不参与文坛之争，虽未得利亦未遭祸，但两方皆有微词。")
                end },
            }
        }
    end,
}

-- ============================================================================
-- 8. 编修族谱 —— 族中公议重修族谱
-- ============================================================================
events[#events + 1] = {
    id = "court_compile_history",
    title = "编修族谱",
    rankRange = {6, 9},
    weight = 7,
    cooldownMonths = 12,
    isDisaster = false,
    isChainEvent = false,
    check = function(s)
        local scholars = GetScholars()
        return #scholars > 0
    end,
    execute = function(s, report)
        local scale = GetMissionScale(s.clanRank)
        local scholars = GetScholars()
        local bestScholar = scholars[1]
        for _, sc in ipairs(scholars) do
            if (sc.knowledge or 0) > (bestScholar.knowledge or 0) then
                bestScholar = sc
            end
        end

        local silverCost = math.floor(35 * scale)
        local fameHigh = math.floor(40 * scale)
        local fameMid = math.floor(18 * scale)

        report.events[#report.events + 1] = bestScholar.name .. "受命主持编修族谱。"
        GameData.AddLog(bestScholar.name .. "入书院主持修谱。")

        return {
            title = "编修族谱",
            desc = "族中开馆修谱，遍邀饱学之士共襄盛举。族中"
                .. bestScholar.name .. "（学识" .. (bestScholar.knowledge or 0)
                .. "）以才学出众被征召入馆。\n\n"
                .. "修谱乃一族至高盛事，然旷日持久、耗时经年。"
                .. "可投入多少资源支持修谱，决定了成果的质量。",
            choices = {
                -- 选项1：全力支持
                { text = "捐资购书、全力支持修史（-" .. silverCost .. "银两）",
                  effect = function()
                    GameData.AddResource("silver", -silverCost)
                    -- 学识决定品质
                    local knowledge = bestScholar.knowledge or 50
                    if knowledge >= 80 then
                        GameData.AddResource("fame", fameHigh)
                        GameData.AddLog(bestScholar.name .. "修谱成书，文采斐然、传诵乡里！声望+" .. fameHigh)
                        -- 提升族人学识
                        bestScholar.knowledge = math.min(100, (bestScholar.knowledge or 0) + 5)
                    else
                        GameData.AddResource("fame", math.floor(fameHigh * 0.6))
                        GameData.AddLog(bestScholar.name .. "参与修谱，虽非主笔亦有贡献。")
                        bestScholar.knowledge = math.min(100, (bestScholar.knowledge or 0) + 3)
                    end
                end },
                -- 选项2：仅挂名参与
                { text = "挂名参与、不投入太多精力",
                  effect = function()
                    GameData.AddResource("fame", fameMid)
                    GameData.AddLog(bestScholar.name .. "挂名修史，略有声名。")
                    bestScholar.knowledge = math.min(100, (bestScholar.knowledge or 0) + 1)
                end },
                -- 选项3：借机篡改
                { text = "借修史之机美化家族历史（风险）",
                  effect = function()
                    -- 30%概率被发现
                    if math.random(100) <= 30 then
                        local penalty = math.floor(25 * scale)
                        GameData.AddResource("fame", -penalty)
                        GameData.AddResource("silver", -math.floor(20 * scale))
                        GameData.AddLog("篡改史书被同僚揭发！声名扫地。")
                    else
                        GameData.AddResource("fame", math.floor(fameHigh * 1.2))
                        GameData.AddLog("家族辉煌事迹载入史册，千秋留名。声望+" .. math.floor(fameHigh * 1.2))
                    end
                end },
            }
        }
    end,
}

-- ============================================================================
-- 9. 押运商货 —— 押运大宗商货上路，途中可能遭劫
-- ============================================================================
events[#events + 1] = {
    id = "court_escort_tribute",
    title = "押运商货",
    rankRange = {6, 9},
    weight = 8,
    cooldownMonths = 8,
    isDisaster = false,
    isChainEvent = false,
    check = function(s)
        local fighters = GetAllFighters()
        return #fighters > 0
    end,
    execute = function(s, report)
        local scale = GetMissionScale(s.clanRank)
        local allFighters = GetAllFighters()
        local fighterNames = GetFighterNames(allFighters, 3)

        local clothCost = math.floor(25 * scale)
        local silverCost = math.floor(30 * scale)
        local fameReward = math.floor(25 * scale)
        local hireCost = math.floor(45 * scale)

        report.events[#report.events + 1] = "行会托付本族押运大宗商货上路。"
        GameData.AddLog("奉命护送岁贡进京。")

        return {
            title = "押运商货",
            desc = "行会托付本族押运一批大宗商货——丝绸锦缎" .. clothCost
                .. "匹、白银" .. silverCost .. "两——安全送抵京畿。\n\n"
                .. "沿途山贼出没、盗匪横行，须派族人亲自护卫。"
                .. "若商货有失，全族须照价赔偿。\n\n"
                .. "可派之将：" .. table.concat(fighterNames, "、"),
            choices = {
                -- 选项1：族人亲自护送（可能触发战斗）
                { text = "族人亲自领队护送", effect = function()
                    -- 40%概率遭遇劫匪
                    if math.random(100) <= 40 then
                        if #allFighters == 0 then
                            GameData.AddResource("cloth", -clothCost)
                            GameData.AddResource("silver", -silverCost)
                            GameData.AddResource("fame", -math.floor(fameReward * 0.8))
                            GameData.AddLog("押运途中遭匪劫，商货尽失！")
                            return
                        end
                        local RivalClans = require("Data.RivalClans")
                        local tierIndex = math.min(3, math.max(1, s.clanRank - 5))
                        local tier = RivalClans.DIFFICULTY_TIERS[tierIndex]
                        local memberCount = math.random(tier.memberRange[1], tier.memberRange[2])
                        local members = {}
                        local snList = {"马", "韩", "吴", "魏", "孙"}
                        local sn = snList[math.random(1, #snList)]
                        local gn = {"虎", "豹", "龙", "猛", "铁", "彪", "刚", "毅"}
                        for j = 1, memberCount do
                            local isLeader = (j == 1)
                            local mart = math.random(tier.martialRange[1], tier.martialRange[2])
                            local hp = math.random(tier.healthRange[1], tier.healthRange[2])
                            if isLeader then mart = math.min(100, mart + 10); hp = math.min(100, hp + 10) end
                            members[j] = {
                                name = sn .. gn[math.random(1, #gn)],
                                gender = "male",
                                age = isLeader and math.random(25, 45) or math.random(18, 40),
                                title = isLeader and "匪首" or nil,
                                martial = mart, health = hp,
                                isLeader = isLeader, memberIndex = j,
                            }
                        end
                        local soldiers = math.random(tier.soldierRange[1], tier.soldierRange[2])
                        soldiers = math.floor(soldiers / 100) * 100
                        if soldiers < 100 then soldiers = 100 end
                        local rival = {
                            id = 0, name = "山贼", surname = sn,
                            tierId = tier.id, tierName = tier.name,
                            tierColor = tier.color, tierDesc = "押运商货",
                            members = members, soldiers = soldiers,
                            rewards = { silver = math.floor(15 * scale), grain = 0, fame = math.floor(10 * scale) },
                            unitStyle = "bandit",
                        }
                        local GS = require("UI.GameScreen")
                        GS.EventBattle(allFighters, rival, {
                            soldierCount = 0,
                            onSettle = function(result, rivalData, deployedIds)
                                if result == "victory" then
                                    GameData.AddResource("fame", fameReward)
                                    GameData.AddResource("silver", rivalData.rewards.silver)
                                    GameData.AddLog("击退劫匪，商货安全送达！声望+" .. fameReward)
                                else
                                    GameData.AddResource("cloth", -clothCost)
                                    GameData.AddResource("silver", -silverCost)
                                    GameData.AddResource("fame", -math.floor(fameReward * 0.6))
                                    GameData.AddLog("押运失败，商货被劫，行会索赔！")
                                end
                                -- 伤亡处理
                                for _, memberId in ipairs(deployedIds) do
                                    local member = GameData.GetMember(memberId)
                                    if member and math.random(100) <= ((result == "victory") and 15 or 40) then
                                        local loss = math.random(5, 15)
                                        member.health = math.max(1, member.health - loss)
                                        if member.health <= 10 then
                                            if member.state ~= "生病" then member.prevState = member.state end
                                            member.state = "生病"
                                        end
                                    end
                                end
                            end,
                        })
                    else
                        -- 60%概率平安送达
                        GameData.AddResource("fame", fameReward)
                        GameData.AddLog("商货平安送达，行会称许。声望+" .. fameReward)
                    end
                end },
                -- 选项2：雇佣镖师
                { text = "花钱雇镖师护送（-" .. hireCost .. "银两）",
                  effect = function()
                    GameData.AddResource("silver", -hireCost)
                    GameData.AddResource("fame", math.floor(fameReward * 0.5))
                    GameData.AddLog("雇镖师押运商货，安全送达，行会记功。")
                end },
                -- 选项3：谎报商货被劫
                { text = "谎报途中被劫、侵吞商货（风险极大）",
                  effect = function()
                    local profit = math.floor((clothCost * 3 + silverCost) * 0.5)
                    GameData.AddResource("silver", profit)
                    -- 35%概率被查
                    if math.random(100) <= 35 then
                        local penalty = profit * 3
                        local famePenalty = math.floor(40 * scale)
                        GameData.AddResource("silver", -penalty)
                        GameData.AddResource("fame", -famePenalty)
                        GameData.AddLog("失信于人！侵吞商货败露，罚银" .. penalty .. "两，声望尽失！")
                    else
                        GameData.AddResource("fame", -10)
                        GameData.AddLog("谎报被劫，暗中得利" .. profit .. "银两。")
                    end
                end },
            }
        }
    end,
}

-- ============================================================================
-- 10. 才艺会演 —— 乡里会演，族中女子可能崭露头角
-- ============================================================================
events[#events + 1] = {
    id = "court_palace_selection",
    title = "才艺会演",
    rankRange = {6, 9},
    weight = 7,
    cooldownMonths = 12,
    isDisaster = false,
    isChainEvent = false,
    check = function(s)
        for _, m in ipairs(GameData.GetAliveMembers()) do
            if m.gender == "female" and m.age >= 14 and m.age <= 22
               and not m.spouseId then
                return true
            end
        end
        return false
    end,
    execute = function(s, report)
        local scale = GetMissionScale(s.clanRank)
        local candidate = nil
        for _, m in ipairs(GameData.GetAliveMembers()) do
            if m.gender == "female" and m.age >= 14 and m.age <= 22
               and not m.spouseId then
                candidate = m
                break
            end
        end
        local name = candidate and candidate.name or "族中女子"
        local beauty = candidate and (candidate.charm or candidate.knowledge or 50) or 50

        local silverCost = math.floor(40 * scale)
        local fameGain = math.floor(30 * scale)
        local bribeCost = math.floor(50 * scale)

        report.events[#report.events + 1] = "乡里会演，" .. name .. "崭露头角。"
        GameData.AddLog("乡里会演在即，" .. name .. "名列参演名册。")

        return {
            title = "才艺会演",
            desc = "乡里三年一度的才艺会演将至，族中" .. name .. "年方"
                .. (candidate and candidate.age or 16) .. "，姿容才艺俱佳，被列入参演名册。\n\n"
                .. "若一举夺魁，阖族名声大振；"
                .. "然台上一刻、台下十年，成败皆在一瞬。\n\n"
                .. "是倾力栽培以期夺魁，还是低调处之不求闻达？",
            choices = {
                -- 选项1：倾力栽培
                { text = "延师教习、全力栽培（-" .. silverCost .. "银两）",
                  effect = function()
                    GameData.AddResource("silver", -silverCost)
                    local successRate = math.min(70, 30 + beauty * 0.5)
                    if math.random(100) <= successRate then
                        GameData.AddResource("fame", fameGain * 2)
                        GameData.AddLog(name .. "会演夺魁，名动乡里！声望+" .. fameGain * 2)
                        if candidate then
                            candidate.state = "献艺"
                            candidate.prevState = nil
                        end
                    else
                        GameData.AddResource("fame", math.floor(fameGain * 0.3))
                        GameData.AddLog(name .. "会演虽未夺魁，亦得众人称许。")
                        if candidate then
                            candidate.state = "献艺"
                            candidate.prevState = nil
                        end
                    end
                end },
                -- 选项2：打点主事免演
                { text = "打点主事免去会演（-" .. bribeCost .. "银两）",
                  effect = function()
                    if s.silver >= bribeCost then
                        GameData.AddResource("silver", -bribeCost)
                        GameData.AddLog("重金打点主事，" .. name .. "免去会演。")
                    else
                        GameData.AddResource("silver", -math.floor(bribeCost * 0.5))
                        GameData.AddResource("fame", -10)
                        GameData.AddLog("银两不足以打点，" .. name .. "仍须登台。")
                        if candidate then
                            candidate.state = "献艺"
                            candidate.prevState = nil
                        end
                    end
                end },
                -- 选项3：托病避演
                { text = "托病避演、不求闻达",
                  effect = function()
                    if math.random(100) <= 25 then
                        local famePenalty = math.floor(20 * scale)
                        GameData.AddResource("fame", -famePenalty)
                        GameData.AddResource("silver", -math.floor(30 * scale))
                        GameData.AddLog("装病之事被识破，乡里唾弃！声望-" .. famePenalty)
                    else
                        GameData.AddLog(name .. "避开会演，留在族中。")
                    end
                end },
            }
        }
    end,
}

return events
