-- ============================================================================
-- 大明家族人生模拟 - 名门品级（7级）专属事件池
-- 设计理念：名门望族树大招风，面临乡里倾轧、地方豪强觊觎
-- ============================================================================

local GameData = require("Data.GameData")
local EventSystem = require("Systems.EventSystem")
local events = {}

-- 1. 大旱连年 — 名门级天灾，产业连带损失
events[#events + 1] = {
    id = "r7_great_drought",
    title = "大旱连年",
    rankRange = {7, 9},
    weight = 10,
    cooldownMonths = 8,
    isDisaster = true,
    check = function(s) return s.grain > 100 end,
    execute = function(s, report)
        local scale = EventSystem.GetDisasterScale(s.clanRank)
        local grainLoss = math.ceil(s.grain * math.min(0.4, 0.2 * scale))
        -- 产业也受损：随机1-2个农业产业降低产出（通过临时扣粮模拟）
        local farmCount = 0
        for _, ind in ipairs(s.industries) do
            if ind.typeId == "dry_field" or ind.typeId == "paddy_field" then farmCount = farmCount + 1 end
        end
        local extraLoss = farmCount * math.ceil(5 * scale)
        local totalLoss = grainLoss + extraLoss
        local rescueCost = math.ceil(40 * scale)

        report.events[#report.events + 1] = "大旱连年，田地龟裂！粮食-" .. totalLoss
        GameData.AddLog("连年大旱，庄稼颗粒无收，田产荒芜。")
        return {
            title = "大旱连年",
            desc = "旱情持续数月，河流断流，井水枯竭。\n家族" .. farmCount .. "处田产严重受灾。\n预计损失粮食" .. totalLoss,
            choices = {
                { text = "开仓放粮赈济乡邻（-" .. rescueCost .. "银+30声望）", cost = {silver = rescueCost}, effect = function()
                    GameData.AddResource("grain", -math.ceil(totalLoss * 0.5))
                    GameData.AddResource("fame", 30)
                    GameData.AddLog("开仓赈灾，乡邻感恩，损失减半。")
                end },
                { text = "紧闭仓门自保", effect = function()
                    GameData.AddResource("grain", -totalLoss)
                    GameData.AddResource("fame", -10)
                    GameData.AddLog("闭门自保，乡邻怨声载道。")
                end },
                { text = "组织挖井引水（-20银两-10布匹）", cost = {silver = 20, cloth = 10}, effect = function()
                    GameData.AddResource("grain", -math.ceil(totalLoss * 0.3))
                    GameData.AddLog("组织族人挖深井引水，大幅减轻灾情。")
                end },
            }
        }
    end,
}

-- 2. 地方豪强挑衅
events[#events + 1] = {
    id = "r7_bully_challenge",
    title = "豪强挑衅",
    rankRange = {7, 9},
    weight = 9,
    cooldownMonths = 6,
    isDisaster = false,
    check = function(s) return #GameData.GetAliveMembers() >= 10 end,
    execute = function(s, report)
        local fameLoss = math.ceil(15 + s.clanRank * 3)
        local fightCost = math.ceil(30 + s.clanRank * 5)
        report.events[#report.events + 1] = "地方豪强公然挑衅，意图夺取产业！"
        GameData.AddLog("豪强上门挑衅，扬言要吞并我族产业。")
        return {
            title = "豪强挑衅",
            desc = "邻近一方豪强眼红家族产业，纠集打手上门挑衅，扬言要抢占田庄商铺。\n若不回应，恐怕声望大损。",
            choices = {
                { text = "花钱摆平（-" .. fightCost .. "银两）", cost = {silver = fightCost}, effect = function()
                    GameData.AddResource("fame", 5)
                    GameData.AddLog("以银两打发豪强，暂时平息。")
                end },
                { text = "硬气回绝", effect = function()
                    -- 50%概率豪强退缩，50%概率损失
                    if math.random() < 0.5 then
                        GameData.AddResource("fame", 15)
                        GameData.AddLog("强硬回绝，豪强见势不妙，灰溜溜退去。")
                    else
                        GameData.AddResource("fame", -fameLoss)
                        GameData.AddResource("silver", -math.ceil(fightCost * 0.5))
                        GameData.AddLog("豪强纠众闹事，产业受损，声望受挫。")
                    end
                end },
                { text = "报官处理（-10银两）", cost = {silver = 10}, effect = function()
                    if math.random() < 0.7 then
                        GameData.AddResource("fame", 10)
                        GameData.AddLog("报官后豪强被约谈，暂时收敛。")
                    else
                        GameData.AddResource("fame", -5)
                        GameData.AddLog("官府偏袒豪强，敷衍了事。")
                    end
                end },
            }
        }
    end,
}

-- 3. 族内争产
events[#events + 1] = {
    id = "r7_family_dispute",
    title = "族内争产",
    rankRange = {7, 9},
    weight = 8,
    cooldownMonths = 10,
    isDisaster = false,
    check = function(s) return #GameData.GetAliveMembers() >= 15 end,
    execute = function(s, report)
        report.events[#report.events + 1] = "族中旁支对产业分配不满，闹起争端。"
        GameData.AddLog("族内争产风波骤起。")
        return {
            title = "族内争产",
            desc = "家族日益壮大，旁支子弟对田产分配心生不满，聚众请愿，要求重新分配产业收益。\n处理不当恐引发族内分裂。",
            choices = {
                { text = "公平分配（-30银两-20粮食+15声望）", cost = {silver = 30, grain = 20}, effect = function()
                    GameData.AddResource("fame", 15)
                    GameData.AddLog("族长主持公道，合理分配，族人心服。")
                end },
                { text = "严厉弹压", effect = function()
                    if math.random() < 0.4 then
                        GameData.AddResource("fame", -20)
                        -- 随机一人出走
                        local members = GameData.GetAliveMembers()
                        if #members > 5 then
                            local target = members[math.random(1, #members)]
                            if not target.isFounder then
                                target.alive = false
                                target.deathCause = "出走"
                                GameData.AddLog(target.name .. "愤而出走，与家族决裂！")
                            end
                        end
                    else
                        GameData.AddResource("fame", -8)
                        GameData.AddLog("弹压暂时平息争端，但族人心有怨言。")
                    end
                end },
                { text = "开设旁支产业安抚（-50银两）", cost = {silver = 50}, effect = function()
                    GameData.AddResource("fame", 10)
                    GameData.AddLog("为旁支另设产业，各安其分。")
                end },
            }
        }
    end,
}

-- 4. 乡耆赐匾 — 名门获乡赠匾额，荣耀加身
events[#events + 1] = {
    id = "r7_imperial_plaque",
    title = "乡耆赐匾",
    rankRange = {7, 9},
    weight = 8,
    cooldownMonths = 18,
    isDisaster = false,
    check = function(s) return s.fame > 400 end,
    execute = function(s, report)
        local feastCost = math.ceil(40 + s.clanRank * 8)
        report.events[#report.events + 1] = "乡耆名家亲题匾额，赐予家族！"
        GameData.AddLog("乡耆乡赠匾额，阖族荣光。")
        return {
            title = "乡耆赐匾",
            desc = "家族声名上达天听，乡耆龙颜大悦，名家亲题「忠义传家」四字匾额，遣乡使送至府上。\n此乃天大的荣耀，然迎匾之礼若失体统，恐惹圣颜不悦；若大操大办，又需破费不少。",
            choices = {
                { text = "隆重迎匾，宴请四方（-" .. feastCost .. "银两，声望+40）", cost = {silver = feastCost},
                  result = "族中张灯结彩，焚香沐浴，鼓乐齐鸣，阖族跪迎赠匾入祠。四方宾客纷至沓来，观礼者挤满街巷。乡使回京复命，盛赞家族知礼守义，天颜甚悦。",
                  effect = function()
                    GameData.AddResource("fame", 40)
                    GameData.AddLog("隆重迎匾入祠，乡里嘉许，声威大振。")
                  end },
                { text = "简朴恭迎，诚心为上（声望+20）",
                  result = "族长率全族老幼素衣跪迎，不设鼓乐，不摆宴席，唯有满腔赤诚。乡使见状动容，叹道「真忠义之家也」。礼数虽薄，诚意却重。",
                  effect = function()
                    GameData.AddResource("fame", 20)
                    GameData.AddLog("简朴恭迎赠匾，以诚敬之心感召乡里。")
                  end },
                { text = "拓印匾文分赠族学（-20银两，全族学识+3）", cost = {silver = 20},
                  result = "族长命人精拓匾文数十份，分悬于族学、书院与各房子弟读书处，令后人日日瞻仰，不忘忠义之训。子弟见名家亲题而自励，学风为之一振。",
                  effect = function()
                    for _, m in ipairs(GameData.GetAliveMembers()) do
                        m.study = math.min(100, m.study + 3)
                    end
                    GameData.AddLog("拓印赠匾文分赠族学，子弟向学之风大盛。")
                  end },
            }
        }
    end,
}

-- 5. 士林文会 — 名门主持文会，结交士林
events[#events + 1] = {
    id = "r7_gentry_gathering",
    title = "士林文会",
    rankRange = {7, 9},
    weight = 7,
    cooldownMonths = 12,
    isDisaster = false,
    check = function(s) return s.fame > 300 and s.silver > 80 end,
    execute = function(s, report)
        local hostCost = math.ceil(30 + s.clanRank * 10)
        report.events[#report.events + 1] = "士林名流联名，欲借家族园林举办文会。"
        GameData.AddLog("士林文会之邀送达，盛会可期。")
        return {
            title = "士林文会",
            desc = "江南士林名流联名来函，欲借家族园林举办一场文会，届时四方才俊云集，吟诗作赋、论道经史。\n主办者可得士林清望，然耗费亦不在少数。",
            choices = {
                { text = "出资主办，极尽地主之谊（-" .. hostCost .. "银两，声望+35）", cost = {silver = hostCost},
                  result = "园林中曲水流觞、文采飞扬，三日方散。名士们留下诗篇数十首，传抄江南。家族崇文重教之名，自此为士林所公认。",
                  effect = function()
                    GameData.AddResource("fame", 35)
                    for _, m in ipairs(GameData.GetAliveMembers()) do
                        if m.state == "读书" then
                            m.study = math.min(100, m.study + math.random(3, 6))
                        end
                    end
                    GameData.AddLog("主办士林文会，崇文之名传遍江南。")
                  end },
                { text = "只遣子弟赴会，不担主办（声望+8）",
                  result = "族中几位子弟携诗文赴会，与各方才俊切磋。虽未拔得头筹，却也算开了眼界，结交了几位知己。",
                  effect = function()
                    GameData.AddResource("fame", 8)
                    GameData.AddLog("子弟赴文会切磋，略有收获。")
                  end },
                { text = "婉言谢绝（声望-6）",
                  result = "族长以「族中事务繁多」为由婉拒。士林中人颇有微词，议论名门之家不识风雅、吝于结交。",
                  effect = function()
                    GameData.AddResource("fame", -6)
                    GameData.AddLog("谢绝文会之邀，士林颇有微词。")
                  end },
            }
        }
    end,
}

-- 6. 乡里摊派
events[#events + 1] = {
    id = "r7_court_levy",
    title = "乡里摊派",
    rankRange = {7, 9},
    weight = 9,
    cooldownMonths = 6,
    isDisaster = true,
    check = function(s) return s.silver > 200 end,
    execute = function(s, report)
        local scale = EventSystem.GetDisasterScale(s.clanRank)
        local levy = math.ceil(s.silver * math.min(0.15, 0.05 * scale))
        local grainLevy = math.ceil(s.grain * math.min(0.1, 0.03 * scale))
        report.events[#report.events + 1] = "乡里加派赋税！银两-" .. levy .. " 粮食-" .. grainLevy
        GameData.AddLog("乡里以军饷不足为由，向豪族加派重税。")
        return {
            title = "乡里摊派",
            desc = "乡里以边关军饷不足为由，向各地豪门大族加派钱粮。\n应缴银两" .. levy .. "、粮食" .. grainLevy .. "\n名门之家，首当其冲。",
            choices = {
                { text = "如数缴纳以示恭顺", effect = function()
                    GameData.AddResource("silver", -levy)
                    GameData.AddResource("grain", -grainLevy)
                    GameData.AddResource("fame", 10)
                    GameData.AddLog("如数上缴，乡里嘉许。")
                end },
                { text = "疏通关系减免三成（-" .. math.ceil(levy * 0.3) .. "银两行贿）", cost = {silver = math.ceil(levy * 0.3)}, effect = function()
                    GameData.AddResource("silver", -math.ceil(levy * 0.7))
                    GameData.AddResource("grain", -math.ceil(grainLevy * 0.7))
                    GameData.AddLog("打点关系，减免部分赋税。")
                end },
                { text = "拖延抗拒", effect = function()
                    if math.random() < 0.3 then
                        GameData.AddLog("地方官未敢强征，暂时蒙混过关。")
                    else
                        GameData.AddResource("silver", -math.ceil(levy * 1.3))
                        GameData.AddResource("grain", -math.ceil(grainLevy * 1.3))
                        GameData.AddResource("fame", -15)
                        GameData.AddLog("官差强行征缴，加罚三成，声望受损。")
                    end
                end },
            }
        }
    end,
}

return events
