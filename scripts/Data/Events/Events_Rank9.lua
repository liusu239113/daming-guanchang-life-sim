-- ============================================================================
-- 大明人生官场模拟 - 国柱品级（9级）专属事件池
-- 设计理念：国柱之家与国同休，面临最高级别的挑战与机遇
-- ============================================================================

local GameData = require("Data.GameData")
local EventSystem = require("Systems.EventSystem")
local events = {}

-- 1. 社稷之灾 — 终极天灾
events[#events + 1] = {
    id = "r9_national_calamity",
    title = "社稷之灾",
    rankRange = {9, 9},
    weight = 10,
    cooldownMonths = 12,
    isDisaster = true,
    check = function(s) return s.grain > 500 or s.silver > 500 end,
    execute = function(s, report)
        local scale = EventSystem.GetDisasterScale(s.clanRank)
        local grainLoss = math.ceil(s.grain * 0.25)
        local silverLoss = math.ceil(s.silver * 0.15)
        local fameLoss = math.ceil(s.fame * 0.1)

        -- 族人也受波及
        local members = GameData.GetAliveMembers()
        local wounded = 0
        for _, m in ipairs(members) do
            if math.random() < 0.15 then
                m.health = math.max(10, m.health - math.random(10, 25))
                wounded = wounded + 1
            end
        end

        report.events[#report.events + 1] = "社稷动荡！家族首当其冲！"
        GameData.AddLog("天崩地裂，社稷动荡，国柱之家遭受重创。")
        return {
            title = "社稷之灾",
            desc = "连月地震、旱蝗并作、流民四起。\n身为国柱，朝廷与百姓皆仰望你族赈济。\n不出手则声望崩溃，出手则家底大伤。\n族中" .. wounded .. "人受伤。\n预计损失：粮" .. grainLoss .. " 银" .. silverLoss,
            choices = {
                { text = "倾家赈灾保社稷（全额损失+30声望）", effect = function()
                    GameData.AddResource("grain", -grainLoss)
                    GameData.AddResource("silver", -silverLoss)
                    GameData.AddResource("fame", 30)
                    GameData.AddLog("国柱之家倾力赈灾，天下感念。")
                end },
                { text = "出半数赈济尽人事（半额损失）", effect = function()
                    GameData.AddResource("grain", -math.ceil(grainLoss * 0.5))
                    GameData.AddResource("silver", -math.ceil(silverLoss * 0.5))
                    GameData.AddResource("fame", 5)
                    GameData.AddLog("量力赈济，虽非全力但亦尽心。")
                end },
                { text = "明哲保身闭门不出", effect = function()
                    GameData.AddResource("fame", -fameLoss)
                    GameData.AddResource("grain", -math.ceil(grainLoss * 0.2))
                    GameData.AddLog("国柱之家闭门不救，天下人齿冷。")
                end },
            }
        }
    end,
}

-- 2. 权臣构陷
events[#events + 1] = {
    id = "r9_framed_by_minister",
    title = "权臣构陷",
    rankRange = {9, 9},
    weight = 9,
    cooldownMonths = 10,
    isDisaster = true,
    check = function(s) return s.fame > 800 end,
    execute = function(s, report)
        local silverLoss = math.ceil(s.silver * 0.12)
        local fameLoss = math.ceil(s.fame * 0.15)

        report.events[#report.events + 1] = "朝中权臣设计构陷，意图扳倒你族！"
        GameData.AddLog("朝中奸臣密谋构陷，家族危在旦夕。")
        return {
            title = "权臣构陷",
            desc = "朝中权臣嫉你家族势大，伪造罪证上奏弹劾，罗织谋反之罪。\n若处置不当，轻则抄家罚没，重则族灭满门。\n此乃生死存亡之际！",
            choices = {
                { text = "进京面圣自辩（-" .. math.ceil(silverLoss * 0.5) .. "银两路费）", cost = {silver = math.ceil(silverLoss * 0.5)}, effect = function()
                    if math.random() < 0.6 then
                        GameData.AddResource("fame", 20)
                        GameData.AddLog("面圣自辩成功，权臣反被治罪！家族声威更盛。")
                    else
                        GameData.AddResource("fame", -math.ceil(fameLoss * 0.5))
                        GameData.AddResource("silver", -math.ceil(silverLoss * 0.3))
                        GameData.AddLog("面圣未能完全洗清嫌疑，被罚没部分家产。")
                    end
                end },
                { text = "联络同盟反击（-" .. silverLoss .. "银两）", cost = {silver = silverLoss}, effect = function()
                    GameData.AddResource("fame", 10)
                    GameData.AddLog("联合朝中友人反击，权臣阴谋败露。")
                end },
                { text = "忍辱求全献财免灾", effect = function()
                    GameData.AddResource("silver", -silverLoss)
                    GameData.AddResource("fame", -fameLoss)
                    GameData.AddLog("献出大量家财求得平安，但声望一落千丈。")
                end },
            }
        }
    end,
}

-- 3. 万民请愿
events[#events + 1] = {
    id = "r9_peoples_plea",
    title = "万民请愿",
    rankRange = {9, 9},
    weight = 7,
    cooldownMonths = 12,
    isDisaster = false,
    check = function(s) return s.fame > 500 end,
    execute = function(s, report)
        report.events[#report.events + 1] = "百姓联名请愿，恳请家族庇护一方。"
        GameData.AddLog("万民请愿书送达，恳请国柱之家庇佑乡梓。")
        return {
            title = "万民请愿",
            desc = "四方百姓联名上书，恳请你族出面调停地方纷争、赈济灾民。\n国柱之家，已与一方百姓的命运紧紧相连。",
            choices = {
                { text = "全力以赴（-80银两-50粮食+50声望）", cost = {silver = 80, grain = 50}, effect = function()
                    GameData.AddResource("fame", 50)
                    GameData.AddLog("倾力相助，万民称颂，声名如日中天。")
                end },
                { text = "量力而行（-30银两-20粮食+20声望）", cost = {silver = 30, grain = 20}, effect = function()
                    GameData.AddResource("fame", 20)
                    GameData.AddLog("适度出手，百姓感恩。")
                end },
                { text = "婉言推辞", effect = function()
                    GameData.AddResource("fame", -15)
                    GameData.AddLog("推辞不管，百姓失望，声望受损。")
                end },
            }
        }
    end,
}

-- 4. 传世家训
events[#events + 1] = {
    id = "r9_family_legacy",
    title = "传世家训",
    rankRange = {9, 9},
    weight = 6,
    cooldownMonths = 24,
    isDisaster = false,
    check = function(s) return true end,
    execute = function(s, report)
        report.events[#report.events + 1] = "族长提议编撰家训，传诸后世。"
        GameData.AddLog("家族已至国柱之尊，当立家训以传千秋。")
        return {
            title = "传世家训",
            desc = "家族已至国柱之巅，族长提议延请大儒编撰《家训》，将家族数代积累的治家之道、为人处世之理汇编成册，以教化后人。",
            choices = {
                { text = "重金延请大儒编撰（-100银两+40声望）", cost = {silver = 100}, effect = function()
                    GameData.AddResource("fame", 40)
                    -- 全族学识微提
                    for _, m in ipairs(GameData.GetAliveMembers()) do
                        m.study = math.min(100, m.study + math.random(2, 5))
                    end
                    GameData.AddLog("家训编成，传诸后世，全族受益。")
                end },
                { text = "族长亲自撰写（+20声望）", effect = function()
                    GameData.AddResource("fame", 20)
                    GameData.AddLog("族长亲撰家训，言简意赅，族人传诵。")
                end },
            }
        }
    end,
}

-- 5. 尚公主 — 皇室赐婚，荣耀背后的取舍
events[#events + 1] = {
    id = "r9_imperial_marriage",
    title = "尚公主",
    rankRange = {9, 9},
    weight = 7,
    cooldownMonths = 24,
    isDisaster = false,
    check = function(s) return s.fame > 600 and s.silver > 300 end,
    execute = function(s, report)
        local betrothalCost = math.ceil(200 + s.clanRank * 20)
        report.events[#report.events + 1] = "圣上欲将公主下嫁族中子弟，天恩浩荡！"
        GameData.AddLog("天子有意结亲，尚主之议传遍朝野。")
        return {
            title = "尚公主",
            desc = "圣上念家族世代忠勤，欲将金枝玉叶下嫁族中俊彦，成就一段君臣佳话。\n然祖制有云：尚主之家，子弟不得掌实权。\n这门亲事是泼天的富贵，却也意味着族中子弟须避嫌退让。",
            choices = {
                { text = "备重礼迎娶公主（-" .. betrothalCost .. "银两，声望+80）", cost = {silver = betrothalCost},
                  result = "聘礼浩浩荡荡送入宫门，婚礼极尽隆重，满城争睹。自此家族与皇室结成姻亲，门第之显赫，一时无两。虽子弟须避实权之嫌，然有皇家为靠山，富贵绵长。",
                  effect = function()
                    GameData.AddResource("fame", 80)
                    GameData.AddLog("子弟尚公主，家族与皇室结为姻亲。")
                  end },
                { text = "上表婉辞，专心实务（声望-30）",
                  result = "族长上表恳辞，言「子弟愚钝，恐辱天恩，愿以微躯报效社稷」。圣上虽准，然心中不悦。朝野皆叹家族错失天恩，却也敬其识大体。",
                  effect = function()
                    GameData.AddResource("fame", -30)
                    GameData.AddLog("婉辞尚主之议，虽失天恩却保实权。")
                  end },
                { text = "恳请以族女入宫侍奉（-50银两，声望+30）", cost = {silver = 50},
                  result = "族长婉陈公主下嫁恐折了皇家体面，愿以族中淑女入宫侍奉天家。圣上嘉其恭谨，允之。虽非正姻，却也算与宫闱结下一线机缘。",
                  effect = function()
                    GameData.AddResource("fame", 30)
                    GameData.AddLog("族女入宫侍奉，家族与禁中结缘。")
                  end },
            }
        }
    end,
}

-- 6. 国宴风波 — 朝堂站队的生死抉择
events[#events + 1] = {
    id = "r9_state_banquet",
    title = "国宴风波",
    rankRange = {9, 9},
    weight = 8,
    cooldownMonths = 10,
    isDisaster = true,
    check = function(s) return s.fame > 400 end,
    execute = function(s, report)
        local giftSilver = math.ceil(60 + s.clanRank * 10)
        local fameLoss = math.ceil(s.fame * 0.12)
        report.events[#report.events + 1] = "国宴之上，清流与权贵当廷争执，家族被迫表态！"
        GameData.AddLog("国宴风波骤起，朝堂两派当廷交锋。")
        return {
            title = "国宴风波",
            desc = "岁末大宴，百官毕集。席间权臣与清流因新政之争当廷反目，唇枪舌剑，圣上面沉如水。\n满座目光齐聚国柱之家——你族一言，可定风向。",
            choices = {
                { text = "仗义执言，力陈利弊",
                  result = "族长起身，直言新政利弊，不偏不党，字字铿锵。满座寂然，圣上凝神细听。此言一出，是福是祸，只在圣心一念之间。",
                  effect = function()
                    if math.random() < 0.5 then
                        GameData.AddResource("fame", 60)
                        GameData.AddLog("廷对得体，圣心大悦，声望大涨。")
                    else
                        GameData.AddResource("fame", -fameLoss)
                        GameData.AddLog("直言触怒权贵，遭人忌恨，声望受损。")
                    end
                  end },
                { text = "沉默旁观，不涉党争",
                  result = "族长始终缄默，只作壁上观。风波过后虽未惹祸，然朝野皆议国柱之家明哲保身，全无担当。",
                  effect = function()
                    GameData.AddResource("fame", -15)
                    GameData.AddLog("国宴之上缄默不言，朝野颇有微词。")
                  end },
                { text = "暗中结好权臣（-" .. giftSilver .. "银两）", cost = {silver = giftSilver},
                  result = "族长席后暗中遣人向权臣奉上厚礼，示以交好之意。权臣笑纳，日后朝中颇多关照，然清流一党自此视家族为佞幸之流。",
                  effect = function()
                    GameData.AddResource("silver", giftSilver * 2)
                    GameData.AddResource("fame", -35)
                    GameData.AddLog("结好权臣获利，然清流侧目。")
                  end },
            }
        }
    end,
}

return events
