-- ============================================================================
-- 大明家族人生模拟 - 年号系统与历史事件时间线
-- 架空大明王朝（1368-1644），276年兴衰史
-- ============================================================================

local EraSystem = {}

-- ============================================================================
-- 明朝年号表（17个年号）
-- ============================================================================

EraSystem.ERA_NAMES = {
    { name = "洪舞", emperor = "高祖猪元掌",  startYear = 1368, endYear = 1398 },
    { name = "建纹", emperor = "愍帝猪允文",  startYear = 1399, endYear = 1402 },
    { name = "永勒", emperor = "成帝猪迪",    startYear = 1403, endYear = 1424 },
    { name = "洪希", emperor = "仁帝猪高赤",  startYear = 1425, endYear = 1425 },
    { name = "宣得", emperor = "宣帝猪詹吉",  startYear = 1426, endYear = 1435 },
    { name = "正通", emperor = "英帝猪岐镇",  startYear = 1436, endYear = 1449 },
    { name = "景太", emperor = "代帝猪岐玉",  startYear = 1450, endYear = 1456 },
    { name = "天舜", emperor = "英帝猪岐镇",  startYear = 1457, endYear = 1464 },
    { name = "承化", emperor = "宪帝猪建申",  startYear = 1465, endYear = 1487 },
    { name = "宏志", emperor = "孝帝猪佑堂",  startYear = 1488, endYear = 1505 },
    { name = "正得", emperor = "武帝猪厚昭",  startYear = 1506, endYear = 1521 },
    { name = "嘉敬", emperor = "世帝猪厚聪",  startYear = 1522, endYear = 1566 },
    { name = "隆青", emperor = "穆帝猪载基",  startYear = 1567, endYear = 1572 },
    { name = "万丽", emperor = "神帝猪奕均",  startYear = 1573, endYear = 1620 },
    { name = "太昌", emperor = "光帝猪常乐",  startYear = 1620, endYear = 1620 },
    { name = "天奇", emperor = "熹帝猪由孝",  startYear = 1621, endYear = 1627 },
    { name = "崇贞", emperor = "思帝猪由简",  startYear = 1628, endYear = 1644 },
}

--- 根据绝对年份获取年号信息
--- @param absYear number 绝对年份（如1368）
--- @return string eraName 年号名
--- @return number eraYear 年号第几年
--- @return string emperor 皇帝称号
function EraSystem.GetEraInfo(absYear)
    -- 特殊处理太昌元年（1620年同时属于万丽48年和太昌元年）
    -- 游戏中按月推进，年份+1时触发，此处太昌只有1620年
    for i = #EraSystem.ERA_NAMES, 1, -1 do
        local era = EraSystem.ERA_NAMES[i]
        if absYear >= era.startYear then
            local eraYear = absYear - era.startYear + 1
            return era.name, eraYear, era.emperor
        end
    end
    return "洪舞", 1, "高祖猪元掌"
end

--- 获取年份显示字符串，如 "洪舞元年" "永勒三年"
--- @param absYear number 绝对年份
--- @return string 如 "洪舞元年(1368)"
function EraSystem.GetYearLabel(absYear)
    local eraName, eraYear = EraSystem.GetEraInfo(absYear)
    local yearStr
    if eraYear == 1 then
        yearStr = "元"
    else
        yearStr = tostring(eraYear)
    end
    return eraName .. yearStr .. "年"
end

--- 获取带公元年的完整标签
--- @param absYear number
--- @return string 如 "洪舞元年(1368)"
function EraSystem.GetFullYearLabel(absYear)
    return EraSystem.GetYearLabel(absYear) .. "(" .. absYear .. ")"
end

-- ============================================================================
-- 明朝历史大事件时间线（1368-1644）
-- 按朝代分期，effect 对应 MonthlyUpdate.CheckHistoryEvent 中的处理逻辑
-- ============================================================================

EraSystem.HISTORY_EVENTS = {
    -- === 洪舞朝（1368-1398）：开国定鼎 ===
    { year = 1368, title = "大明开国",
      desc = "猪元掌于膺天府称帝，国号大明，年号洪舞。徐答北伐，攻克燕都，蒙兀北遁。",
      effect = "era_start" },
    { year = 1370, title = "大封功臣",
      desc = "高祖大封开国功臣，徐答、常玉春等封公侯。",
      effect = "fame_boost" },
    { year = 1373, title = "编户齐民",
      desc = "官府推行黄籍制度，清查户口田亩，编户齐民，赋役渐重。",
      effect = "tax_reform" },
    { year = 1380, title = "胡维庸案",
      desc = "丞相胡维庸谋反伏诛，高祖废丞相制，株连甚广，朝野震动。",
      effect = "political_purge" },
    { year = 1385, title = "空荫案",
      desc = "空荫案发，牵连数百官员被诛，天下官吏人心惶惶。",
      effect = "political_purge" },
    { year = 1390, title = "兰玉案",
      desc = "凉国公兰玉以谋反罪被诛，牵连万余人，功臣几乎殆尽。",
      effect = "political_purge" },
    { year = 1393, title = "鱼鳞册",
      desc = "官府编制鱼鳞册，丈量天下田亩，赋税更加严密。",
      effect = "tax_up" },
    { year = 1398, title = "高祖驾崩",
      desc = "洪舞帝崩于南都，皇太孙猪允文即位，年号建纹。",
      effect = "emperor_change" },

    -- === 建纹-永勒朝（1399-1424）：靖南与盛世 ===
    { year = 1399, title = "靖南之役",
      desc = "燕王猪迪起兵靖南，南北交战四年，天下纷扰，百姓苦于兵火。",
      effect = "war_civil" },
    { year = 1402, title = "燕王入京",
      desc = "猪迪攻入南都，建纹帝下落不明。猪迪即位，改元永勒。",
      effect = "emperor_change" },
    { year = 1405, title = "郑河下汐洋",
      desc = "三宝内侍郑河率船队首次远航西洋，扬国威于海外，通商互利。",
      effect = "trade_boost" },
    { year = 1410, title = "永勒北征",
      desc = "成帝亲征漠北，大败达旦，边塞暂安。然军费浩繁，赋役加重。",
      effect = "military_draft" },
    { year = 1421, title = "迁都北都",
      desc = "官家正式迁都北都，南都为留都。北都扼守门户，南方赋税北运。",
      effect = "capital_move" },
    { year = 1424, title = "成帝驾崩",
      desc = "永勒帝崩于北征途中，太子猪高赤即位，年号洪希，施政宽仁。",
      effect = "emperor_change" },

    -- === 仁宣之治（1425-1435）：太平盛世 ===
    { year = 1425, title = "仁帝即位",
      desc = "仁帝轻徭薄赋，与民休息，虽在位不足一年，却开太平之基。",
      effect = "tax_relief" },
    { year = 1426, title = "宣帝即位",
      desc = "宣帝猪詹吉即位，年号宣得。文治武功，号称仁宣之治。",
      effect = "prosperity" },
    { year = 1430, title = "海榷渐严",
      desc = "官府收紧海榷，郑河最后一次下汐洋后，海外贸易渐趋萧条。",
      effect = "trade_decline" },

    -- === 正通-景太-天舜（1436-1464）：土木之变 ===
    { year = 1436, title = "正通即位",
      desc = "英帝年幼即位，太皇太后与三相辅政，朝局尚稳。",
      effect = "emperor_change" },
    { year = 1449, title = "涂木堡之变",
      desc = "英帝亲征瓦喇，于涂木堡大败被俘！京畿震动，举国惶恐。",
      effect = "military_crisis" },
    { year = 1450, title = "景太即位·北都保卫战",
      desc = "于骞拥立成王为帝，率军击退瓦喇，保全社稷。",
      effect = "war_defense" },
    { year = 1457, title = "夺盟之变",
      desc = "英帝复辟，于骞被杀，朝局动荡，改元天舜。",
      effect = "political_purge" },

    -- === 承化-宏志（1465-1505）：中兴与承平 ===
    { year = 1465, title = "承化即位",
      desc = "宪帝即位，早年勤政，后渐怠政，西缉局横行，朝政渐坏。",
      effect = "emperor_change" },
    { year = 1471, title = "荆襄流民",
      desc = "荆襄一带流民数十万聚集，官府招抚设府，流民问题凸显。",
      effect = "refugees" },
    { year = 1488, title = "宏志中兴",
      desc = "孝帝即位，勤勉仁厚，远奸佞、亲贤臣，天下称宏志中兴。",
      effect = "prosperity" },

    -- === 正得朝（1506-1521）：荒唐岁月 ===
    { year = 1506, title = "正得即位",
      desc = "武帝即位，宠信刘锦等八彪宦侍，朝政日非。",
      effect = "emperor_change" },
    { year = 1510, title = "安华王叛乱",
      desc = "安华王以诛刘锦为名叛乱，虽很快平定，但朝野不安。",
      effect = "rebellion" },
    { year = 1519, title = "宁望之乱",
      desc = "宁王猪宸豪起兵谋反，王阳名仅用四十三日平定叛乱。",
      effect = "rebellion" },

    -- === 嘉敬朝（1522-1566）：海寇与朝争 ===
    { year = 1522, title = "嘉敬即位",
      desc = "世帝以宗藩入继大统，大礼仪之争起，朝堂分裂。",
      effect = "emperor_change" },
    { year = 1529, title = "大礼仪定",
      desc = "嘉敬帝在大礼仪中获胜，群臣庭杖，朝局为之一变。",
      effect = "political_purge" },
    { year = 1542, title = "人寅宫变",
      desc = "宫女谋刺嘉敬帝未遂，帝受惊后移居西苑，不再上朝，沉迷修道。",
      effect = "governance_decline" },
    { year = 1547, title = "海寇猖獗",
      desc = "东南沿海海寇大肆侵扰，烧杀抢掠，沿海百姓苦不堪言。",
      effect = "bandit_up" },
    { year = 1555, title = "戚纪光平海寇",
      desc = "戚纪光练兵浙东，戚家兵屡败海寇，东南渐安。",
      effect = "military_victory" },
    { year = 1566, title = "嘉敬驾崩",
      desc = "世帝崩，穆帝即位，改元隆青，开放海榷，史称隆青开关。",
      effect = "emperor_change" },

    -- === 隆青-万丽前期（1567-1600）：张居政改革 ===
    { year = 1567, title = "隆青开关",
      desc = "穆帝开放海榷，准许民间出海贸易，海外白银大量流入。",
      effect = "trade_boost" },
    { year = 1573, title = "万丽即位",
      desc = "神帝年幼即位，张居政辅政，推行改革，吏治清明。",
      effect = "emperor_change" },
    { year = 1578, title = "一条编法",
      desc = "张居政推行一条编法，统一赋役，清丈田亩，国库充盈。",
      effect = "tax_reform" },
    { year = 1582, title = "张居政病逝",
      desc = "首揆张居政病逝，万丽帝清算其党，改革成果渐遭废弃。",
      effect = "governance_decline" },

    -- === 万丽中后期（1600-1620）：三次征伐与朝争 ===
    { year = 1592, title = "万丽三次征伐",
      desc = "宁夏、播州、朝鲜三次征伐接连发起，虽战胜但国力大耗。",
      effect = "military_drain" },
    { year = 1601, title = "万丽怠政",
      desc = "万丽帝数十年不上朝，朝中缺官过半，政务荒废，朝争渐烈。",
      effect = "governance_decline" },
    { year = 1615, title = "东霖朝争",
      desc = "东霖党与内珰党之争愈演愈烈，挺击案、红完案迭起，朝局混乱。",
      effect = "political_chaos" },
    { year = 1616, title = "北金崛起",
      desc = "努尔哈斥建立北金，统一女贞各部，辽北边患日益严重。",
      effect = "border_threat" },
    { year = 1619, title = "萨儿湖之战",
      desc = "明军四路出击北金，于萨儿湖惨败，辽北局势急转直下。",
      effect = "military_crisis" },

    -- === 天奇-崇贞（1620-1644）：末世乱局 ===
    { year = 1620, title = "太昌即位",
      desc = "光帝即位仅一月即崩，红完案震惊朝野，熹帝即位。",
      effect = "emperor_change" },
    { year = 1621, title = "魏钟贤专权",
      desc = "天奇帝宠信魏钟贤，内珰党势力滔天，残害东霖忠良。",
      effect = "political_purge" },
    { year = 1625, title = "辽北失陷",
      desc = "北金连克申阳、辽扬，辽北大部沦陷，只剩宁原、锦洲一线。",
      effect = "border_fall" },
    { year = 1628, title = "崇贞即位",
      desc = "思帝即位，诛魏钟贤，锐意中兴，然积弊已深，回天乏术。加征边课，百姓苦不堪言。",
      effect = "tax_up" },
    { year = 1630, title = "流寇壮大",
      desc = "陕西大旱连年，流民揭竿而起，李自承、张献钟等势力日益壮大。",
      effect = "bandit_surge" },
    { year = 1633, title = "北金入关",
      desc = "北金军绕道蒙兀入关劫掠，直逼京畿，明军不能制。",
      effect = "military_draft" },
    { year = 1635, title = "流寇会盟荥扬",
      desc = "高迎翔、李自承、张献钟等十三家流寇会盟荥扬，分兵出击。",
      effect = "bandit_surge" },
    { year = 1637, title = "全国大旱",
      desc = "赤地千里，饿殍遍野，粮价飞涨，各地饥民蜂起。",
      effect = "famine" },
    { year = 1639, title = "瘟疫横行",
      desc = "大疫横行华北，死者枕藉，人心惶惶，十室九空。",
      effect = "plague" },
    { year = 1640, title = "河南大饥",
      desc = "河南饥荒至极，人相食之惨状频现，民不聊生。",
      effect = "great_famine" },
    { year = 1641, title = "李自承破洛扬",
      desc = "闯将攻破洛扬，顺王猪常寻被杀，天下震动。",
      effect = "war_escalate" },
    { year = 1642, title = "松锦大战",
      desc = "松稠之战明军大败，洪承筹归北，辽北门户洞开。",
      effect = "military_crisis" },
    { year = 1643, title = "张献钟入蜀",
      desc = "张献钟率军入川，湖广大乱，大西政权割据一方。",
      effect = "south_war" },
    { year = 1644, title = "天倾之变",
      desc = "李自承攻入北都，崇贞帝自缢梅山，大明覆亡。",
      effect = "game_end" },
}

-- ============================================================================
-- 年代分期（用于游戏难度曲线和随机事件权重）
-- ============================================================================

--- 获取当前年份所处的时代阶段
--- @param absYear number
--- @return string period 时代分期ID
--- @return string periodName 时代分期名称
--- @return number difficultyMul 难度系数（1.0为基准）
function EraSystem.GetPeriod(absYear)
    if absYear < 1399 then
        return "founding", "开国定鼎", 1.0
    elseif absYear < 1450 then
        return "prosperity", "永宣之治", 0.8
    elseif absYear < 1465 then
        return "turmoil", "土木之变", 1.2
    elseif absYear < 1522 then
        return "middle", "承宏承平", 0.9
    elseif absYear < 1567 then
        return "jiajing", "嘉敬海乱", 1.1
    elseif absYear < 1600 then
        return "reform", "隆万新政", 0.85
    elseif absYear < 1620 then
        return "decline", "万丽怠政", 1.15
    elseif absYear < 1628 then
        return "late", "天奇乱政", 1.3
    else
        return "endgame", "崇贞末世", 1.5
    end
end

--- 获取当前年代的税率修正系数
--- @param absYear number
--- @return number 税率系数（1.0为基准）
function EraSystem.GetTaxModifier(absYear)
    local period = EraSystem.GetPeriod(absYear)
    local modifiers = {
        founding    = 1.0,
        prosperity  = 0.8,
        turmoil     = 1.1,
        middle      = 0.9,
        jiajing     = 1.05,
        reform      = 0.85,
        decline     = 1.1,
        late        = 1.3,
        endgame     = 1.6,
    }
    return modifiers[period] or 1.0
end

--- 获取当前年代的灾害死亡率修正
--- @param absYear number
--- @return number 死亡率系数
function EraSystem.GetDeathRateModifier(absYear)
    local period = EraSystem.GetPeriod(absYear)
    local modifiers = {
        founding    = 1.0,
        prosperity  = 0.7,
        turmoil     = 1.3,
        middle      = 0.8,
        jiajing     = 1.0,
        reform      = 0.8,
        decline     = 1.2,
        late        = 1.5,
        endgame     = 2.0,
    }
    return modifiers[period] or 1.0
end

--- 获取随机事件触发率
--- @param absYear number
--- @return number 触发率(0-1)
function EraSystem.GetEventTriggerRate(absYear)
    local period = EraSystem.GetPeriod(absYear)
    local rates = {
        founding    = 0.25,
        prosperity  = 0.20,
        turmoil     = 0.35,
        middle      = 0.25,
        jiajing     = 0.30,
        reform      = 0.25,
        decline     = 0.35,
        late        = 0.40,
        endgame     = 0.50,
    }
    return rates[period] or 0.30
end

--- 获取经商波动系数（晚期波动更大）
--- @param absYear number
--- @return number 波动系数
function EraSystem.GetTradeVolatility(absYear)
    local period = EraSystem.GetPeriod(absYear)
    local volatilities = {
        founding    = 0.05,
        prosperity  = 0.03,
        turmoil     = 0.10,
        middle      = 0.05,
        jiajing     = 0.08,
        reform      = 0.04,
        decline     = 0.10,
        late        = 0.15,
        endgame     = 0.25,
    }
    return volatilities[period] or 0.05
end

--- 判断某个随机事件在当前年代是否可以触发
--- 用于替代 MonthlyUpdate 中硬编码的年份检查
--- @param absYear number
--- @param eventCategory string 事件分类
--- @return boolean
function EraSystem.CanTriggerEvent(absYear, eventCategory)
    local gameYears = absYear - 1368  -- 游戏已经过的年数

    local requirements = {
        -- 灾害类事件：开局5年后逐步出现
        bandit_raid     = gameYears >= 3,
        drought         = gameYears >= 5,
        locust          = gameYears >= 8,
        plague          = gameYears >= 10,
        famine          = gameYears >= 12,
        -- 军事类事件：需要特定年代
        military_draft  = gameYears >= 8,
        army_passage    = gameYears >= 15,
        rebel_recruit   = gameYears >= 20,
        -- 经济类事件
        trade_crisis    = gameYears >= 5,
        tax_increase    = gameYears >= 5,
        grain_inflation = gameYears >= 10,
        -- 正面事件：早期更容易出现
        good_harvest    = gameYears < 200,
        refugee_influx  = gameYears >= 10,
        -- 战斗事件
        fortress_battle = gameYears >= 15,
    }

    return requirements[eventCategory] ~= false  -- 无条件的默认可触发
end

--- 获取经商风险修正（用于乱世经商）
--- @param absYear number
--- @return number 风险系数
function EraSystem.GetMerchantRiskModifier(absYear)
    local _, _, diffMul = EraSystem.GetPeriod(absYear)
    return diffMul
end

--- 获取丰收事件概率（太平盛世更高）
--- @param absYear number
--- @return boolean 是否有丰收可能
function EraSystem.IsGoodHarvestLikely(absYear)
    local period = EraSystem.GetPeriod(absYear)
    return period == "prosperity" or period == "middle" or period == "reform"
end

--- 获取BGM切换阈值（哪些时期该用危机BGM）
--- @param absYear number
--- @return string bgmType "peaceful" | "crisis"
function EraSystem.GetBGMType(absYear)
    local period = EraSystem.GetPeriod(absYear)
    if period == "endgame" or period == "late" or period == "turmoil" then
        return "crisis"
    end
    return "peaceful"
end

return EraSystem
