-- ============================================================================
-- 大明家族人生模拟 - 豪阀品级（8级）专属事件池
-- 设计理念：豪阀势大，招致乡里猜忌、外敌虎视
-- ============================================================================

local GameData = require("Data.GameData")
local EventSystem = require("Systems.EventSystem")
local events = {}

-- 1. 乡里猜忌 — 功高震主
events[#events + 1] = {
    id = "r8_imperial_suspicion",
    title = "乡里猜忌",
    rankRange = {8, 9},
    weight = 10,
    cooldownMonths = 8,
    isDisaster = true,
    check = function(s) return s.fame > 500 end,
    execute = function(s, report)
        local fameLoss = math.ceil(s.fame * 0.1)
        local silverLoss = math.ceil(s.silver * 0.08)
        report.events[#report.events + 1] = "乡里对家族势力心生猜忌！"
        GameData.AddLog("功高震主，乡耆对家族猜忌日深。")
        return {
            title = "乡里猜忌",
            desc = "家族势力膨胀，引起乡里御史弹劾，言官奏章如雪片飞来，参你族'结党营私，恃势凌人'。\n乡耆龙颜不悦，下旨查办。",
            choices = {
                { text = "主动献银表忠心（-" .. silverLoss .. "银两）", cost = {silver = silverLoss}, effect = function()
                    GameData.AddResource("fame", -math.ceil(fameLoss * 0.3))
                    GameData.AddLog("进献银两以释圣疑，暂保平安。")
                end },
                { text = "上书自辩清白", effect = function()
                    if math.random() < 0.5 then
                        GameData.AddResource("fame", 10)
                        GameData.AddLog("辩章入微，乡耆释疑，反赐嘉奖。")
                    else
                        GameData.AddResource("fame", -fameLoss)
                        GameData.AddResource("silver", -math.ceil(silverLoss * 0.5))
                        GameData.AddLog("自辩无效，被削去部分产业。")
                    end
                end },
                { text = "低调蛰伏减少活动", effect = function()
                    GameData.AddResource("fame", -fameLoss)
                    GameData.AddLog("暂时收敛锋芒，等待风头过去。")
                end },
            }
        }
    end,
}

-- 2. 天灾人祸 — 复合灾害
events[#events + 1] = {
    id = "r8_compound_disaster",
    title = "天灾人祸",
    rankRange = {8, 9},
    weight = 8,
    cooldownMonths = 10,
    isDisaster = true,
    check = function(s) return s.grain > 200 and s.silver > 100 end,
    execute = function(s, report)
        local scale = EventSystem.GetDisasterScale(s.clanRank)
        local grainLoss = math.ceil(s.grain * math.min(0.35, 0.15 * scale))
        local silverLoss = math.ceil(s.silver * math.min(0.2, 0.08 * scale))
        local clothLoss = math.ceil(s.cloth * math.min(0.25, 0.1 * scale))

        report.events[#report.events + 1] = "地震引发大火，仓库受损严重！"
        GameData.AddLog("地动山摇，引发大火，仓库付之一炬。")
        return {
            title = "天灾人祸",
            desc = "夜半地动山摇，屋宇倾塌，继而引发大火。\n仓库、田庄、作坊均遭重创。\n预计损失：粮食" .. grainLoss .. " 银两" .. silverLoss .. " 布匹" .. clothLoss,
            choices = {
                { text = "全力救灾重建（-" .. math.ceil(50 * scale) .. "银两减半损失）", cost = {silver = math.ceil(50 * scale)}, effect = function()
                    GameData.AddResource("grain", -math.ceil(grainLoss * 0.5))
                    GameData.AddResource("silver", -math.ceil(silverLoss * 0.5))
                    GameData.AddResource("cloth", -math.ceil(clothLoss * 0.5))
                    GameData.AddResource("fame", 15)
                    GameData.AddLog("倾力救灾，虽损失惨重但保住了根基。")
                end },
                { text = "优先保护核心产业", effect = function()
                    GameData.AddResource("grain", -grainLoss)
                    GameData.AddResource("silver", -math.ceil(silverLoss * 0.3))
                    GameData.AddResource("cloth", -clothLoss)
                    GameData.AddLog("集中力量保住了银库，但粮仓和织坊尽毁。")
                end },
                { text = "向乡里请赈（-20声望）", effect = function()
                    GameData.AddResource("grain", -math.ceil(grainLoss * 0.6))
                    GameData.AddResource("silver", -math.ceil(silverLoss * 0.6))
                    GameData.AddResource("cloth", -math.ceil(clothLoss * 0.6))
                    GameData.AddResource("fame", -20)
                    GameData.AddLog("上书请赈，乡里拨付部分钱粮，然名望受损。")
                end },
            }
        }
    end,
}

-- 3. 敌族暗算
events[#events + 1] = {
    id = "r8_rival_sabotage",
    title = "敌族暗算",
    rankRange = {8, 9},
    weight = 9,
    cooldownMonths = 6,
    isDisaster = true,
    check = function(s) return #s.industries >= 10 end,
    execute = function(s, report)
        -- 随机损坏1-2个产业
        local damaged = {}
        local industries = {}
        for _, ind in ipairs(s.industries) do
            local indType = GameData.GetIndustryType(ind.typeId)
            if indType and indType.resource ~= "none" then
                industries[#industries + 1] = ind
            end
        end
        local dmgCount = math.min(#industries, math.random(1, 2))
        -- 随机打乱顺序取前dmgCount个
        for i = 1, dmgCount do
            local j = math.random(i, #industries)
            industries[i], industries[j] = industries[j], industries[i]
            damaged[#damaged + 1] = industries[i]
        end

        local damageDesc = {}
        for _, ind in ipairs(damaged) do
            local indType = GameData.GetIndustryType(ind.typeId)
            damageDesc[#damageDesc + 1] = indType.name .. "(Lv." .. ind.level .. ")"
        end

        report.events[#report.events + 1] = "敌族暗中破坏产业！"
        GameData.AddLog("有人暗中破坏家族产业，查明是敌族所为。")
        return {
            title = "敌族暗算",
            desc = "深夜有人潜入破坏，查明是敌对家族派人所为。\n受损产业：" .. table.concat(damageDesc, "、") .. "\n产业等级将被降低！",
            choices = {
                { text = "加强巡逻追查凶手（-30银两）", cost = {silver = 30}, effect = function()
                    -- 50%概率挽回
                    if math.random() < 0.5 then
                        GameData.AddResource("fame", 10)
                        GameData.AddLog("擒获暗探，敌族阴谋败露，产业未受大损。")
                    else
                        for _, ind in ipairs(damaged) do
                            ind.level = math.max(1, ind.level - 1)
                        end
                        GameData.AddResource("fame", 5)
                        GameData.AddLog("虽擒获部分暗探，但产业已遭破坏。")
                    end
                end },
                { text = "忍气吞声修复", effect = function()
                    for _, ind in ipairs(damaged) do
                        ind.level = math.max(1, ind.level - 1)
                    end
                    GameData.AddLog("暗中修复受损产业，但声望无损。")
                end },
                { text = "以牙还牙报复（-50银两）", cost = {silver = 50}, effect = function()
                    for _, ind in ipairs(damaged) do
                        ind.level = math.max(1, ind.level - 1)
                    end
                    GameData.AddResource("fame", 20)
                    GameData.AddResource("silver", math.random(20, 40))
                    GameData.AddLog("派人反击敌族，夺回部分银两，扬我家威。")
                end },
            }
        }
    end,
}

-- 4. 名士来投
events[#events + 1] = {
    id = "r8_scholar_joins",
    title = "名士来投",
    rankRange = {8, 9},
    weight = 7,
    cooldownMonths = 12,
    isDisaster = false,
    check = function(s) return s.fame > 300 end,
    execute = function(s, report)
        report.events[#report.events + 1] = "名士慕名来投，愿为家族效力。"
        GameData.AddLog("有名士闻家族大名，前来投奔。")
        return {
            title = "名士来投",
            desc = "一位饱学名士闻你家族声名远播，特来投奔，愿以一身才学辅佐家族。\n此人精通经史，可大幅提升族中文教。",
            choices = {
                { text = "厚礼相待纳入族中（-40银两）", cost = {silver = 40}, effect = function()
                    -- 提升所有读书族人学识
                    for _, m in ipairs(GameData.GetAliveMembers()) do
                        if m.state == "读书" then
                            m.study = math.min(100, m.study + math.random(5, 10))
                        end
                    end
                    GameData.AddResource("fame", 15)
                    GameData.AddLog("名士入族，教导后辈，学风大振。")
                end },
                { text = "礼貌婉拒", effect = function()
                    GameData.AddLog("婉拒名士好意，各自珍重。")
                end },
            }
        }
    end,
}

-- 5. 盐引争夺 — 豪阀逐利盐政，暴利与风险并存
events[#events + 1] = {
    id = "r8_salt_license",
    title = "盐引争夺",
    rankRange = {8, 9},
    weight = 8,
    cooldownMonths = 12,
    isDisaster = false,
    check = function(s) return s.silver > 300 end,
    execute = function(s, report)
        local bidCost = math.ceil(120 + s.clanRank * 20)
        report.events[#report.events + 1] = "盐运司放出新一批盐引，各方豪族竞相争夺！"
        GameData.AddLog("盐引竞标在即，豪族皆蠢蠢欲动。")
        return {
            title = "盐引争夺",
            desc = "盐运司放出新一批盐引，持引者可贩盐获利，一本万利。\n各方豪族闻风而动，竞标之价水涨船高。\n家族若要拿下这批盐引，需备下重金竞标。",
            choices = {
                { text = "重金竞标盐引（-" .. bidCost .. "银两）", cost = {silver = bidCost},
                  result = "竞标之日，家族以重金力压群豪，盐引终于到手。此后盐船往来淮扬之间，是坐收暴利还是血本无归，全看天时与经营。",
                  effect = function()
                    if math.random() < 0.65 then
                        local profit = bidCost * 2
                        GameData.AddResource("silver", profit)
                        GameData.AddResource("fame", 20)
                        GameData.AddLog("竞得盐引，贩盐获利" .. profit .. "银两。")
                    else
                        local loss = math.ceil(bidCost * 0.5)
                        GameData.AddResource("silver", -loss)
                        GameData.AddResource("fame", -5)
                        GameData.AddLog("盐引经营失利，亏损" .. loss .. "银两。")
                    end
                  end },
                { text = "联合商帮分摊风险（-100银两，声望+10）", cost = {silver = 100},
                  result = "族长邀集几家相熟商帮共襄此举，风险共担、利分三成。虽所得不丰，却也稳妥，且在商界结下善缘。",
                  effect = function()
                    GameData.AddResource("silver", math.random(60, 120))
                    GameData.AddResource("fame", 10)
                    GameData.AddLog("联合商帮共营盐务，稳中取利。")
                  end },
                { text = "按兵不动，静观其变",
                  result = "族长深谙「盐政如虎口」之理，按兵不动。旁人为盐引争得头破血流，家族却在旁静观，不失为明智之举。",
                  effect = function()
                    GameData.AddLog("按兵不动，避开盐政风波。")
                  end },
            }
        }
    end,
}

-- 6. 旁支请立 — 旁支人丁兴旺，请求另立祠堂
events[#events + 1] = {
    id = "r8_branch_shrine",
    title = "旁支请立",
    rankRange = {8, 9},
    weight = 7,
    cooldownMonths = 24,
    isDisaster = false,
    check = function(s) return #GameData.GetAliveMembers() >= 20 and s.silver > 150 end,
    execute = function(s, report)
        local shrineCost = math.ceil(100 + s.clanRank * 20)
        local branchCount = math.max(2, math.floor(#GameData.GetAliveMembers() / 8))
        report.events[#report.events + 1] = "旁支人丁兴旺，联名请求另立分祠。"
        GameData.AddLog("旁支诸房联名上书，请立分祠。")
        return {
            title = "旁支请立",
            desc = "家族开枝散叶，" .. branchCount .. "房旁支人丁兴旺，联名上书请求拨地另立分祠，各奉本房先祖。\n此事若准，族中格局将为之一变；若不允，恐伤同宗和气。",
            choices = {
                { text = "准许并拨款建祠（-" .. shrineCost .. "银两，声望+25）", cost = {silver = shrineCost},
                  result = "族长择吉日划地，拨银建祠。" .. branchCount .. "座分祠次第落成，各房欢欣，皆赞族长胸襟开阔、不忘同宗。阖族上下一心，气象一新。",
                  effect = function()
                    GameData.AddResource("fame", 25)
                    for _, m in ipairs(GameData.GetAliveMembers()) do
                        m.health = math.min(100, m.health + 2)
                    end
                    GameData.AddLog("拨款建分祠" .. branchCount .. "座，各房归心。")
                  end },
                { text = "划地自建，族中不拨款（-40银两，声望+6）", cost = {silver = 40},
                  result = "族长只拨了几亩薄地，余者令各房自筹。旁支虽勉强建成祠堂，心中却难免存了几分芥蒂。",
                  effect = function()
                    GameData.AddResource("fame", 6)
                    GameData.AddLog("划地令旁支自建分祠，各房勉强应下。")
                  end },
                { text = "严词拒绝，维护大宗（声望-20）",
                  result = "族长以「大宗不可分」为由严词拒绝，将请愿书掷于阶下。各房噤若寒蝉，不敢再言。然族中裂痕已生，人心暗浮动。",
                  effect = function()
                    GameData.AddResource("fame", -20)
                    GameData.AddLog("严拒立祠之请，各房心有不平。")
                  end },
            }
        }
    end,
}

return events
