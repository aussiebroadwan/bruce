
local decks = {
    presets = {}
}

--- @type table<string, number> Deck composition for "The Steady Racer"
decks.presets.steady_racer = {
    ["move"] = 12,         -- Move 1: Reliable forward movement
    ["move_2"] = 10,       -- Move 2: Stronger movement forward
    ["boost"] = 4,         -- Turbo Boost: Double the next movement
    ["back"] = 2,          -- Move Back 1: Small risk
    ["skip"] = 2,          -- Skip: Minor disruption
    ["defend_back"] = 2    -- Defend: Protect against back movement
}

--- @type table<string, number> Deck composition for "The Aggressive Attacker"
decks.presets.aggressive_attacker = {
    ["move"] = 8,          -- Move 1: Forward movement
    ["move_2"] = 6,        -- Move 2: Stronger movement forward
    ["attack_back"] = 8,   -- Attack: Attack opponents and move them back
    ["defend_back"] = 4,   -- Defend: Protect against back attacks
    ["boost"] = 2,         -- Turbo Boost: Double the next movement
    ["push_ahead"] = 4     -- Push Ahead: Move forward and defend
}

--- @type table<string, number> Deck composition for "The Risky Gambler"
decks.presets.risky_gambler = {
    ["move"] = 10,         -- Move 1: Reliable forward movement
    ["move_2"] = 6,        -- Move 2: Stronger movement forward
    ["boost"] = 6,         -- Turbo Boost: Double the next movement
    ["back"] = 4,          -- Move Back 1: Small risk
    ["back_2"] = 4,        -- Double Back: High risk, big setback
    ["push_ahead"] = 2     -- Push Ahead: Move forward and defend
}

--- @type table<string, number> Deck composition for "The Defensive Strategist"
decks.presets.defensive_strategist = {
    ["move"] = 10,         -- Move 1: Reliable forward movement
    ["move_2"] = 6,        -- Move 2: Stronger movement forward
    ["defend_back"] = 8,   -- Defend: Protect against back attacks
    ["boost"] = 2,         -- Turbo Boost: Double the next movement
    ["attack_back"] = 4,   -- Attack: Attack opponents and move them back
    ["skip"] = 2           -- Skip: Minor disruption
}

--- @type table<string, number> Deck composition for "The Speedster"
decks.presets.speedster = {
    ["move"] = 12,         -- Move 1: Reliable forward movement
    ["move_2"] = 10,       -- Move 2: Stronger movement forward
    ["boost"] = 6,         -- Turbo Boost: Double the next movement
    ["push_ahead"] = 4     -- Push Ahead: Move forward and defend
}

--- @type table<string, number> Deck composition for "The Balanced Runner"
decks.presets.balanced_runner = {
    ["move"] = 10,         -- Move 1: Reliable forward movement
    ["move_2"] = 8,        -- Move 2: Stronger movement forward
    ["boost"] = 6,         -- Turbo Boost: Double the next movement
    ["attack_back"] = 4,   -- Attack: Attack opponents and move them back
    ["defend_back"] = 4    -- Defend: Protect against back attacks
}

--- @type table<string, number> Deck composition for "The Disruptor"
decks.presets.disruptor = {
    ["move"] = 6,          -- Move 1: Moderate forward movement
    ["move_2"] = 4,        -- Move 2: Stronger movement forward
    ["attack_back"] = 10,  -- Attack: Attack opponents and move them back
    ["skip"] = 6,          -- Skip: Force opponents to skip turns
    ["defend_back"] = 6    -- Defend: Protect against back attacks
}

--- @type table<string, number> Deck composition for "The Sprinter"
decks.presets.sprinter = {
    ["move"] = 14,         -- Move 1: Dominant forward movement
    ["move_2"] = 10,       -- Move 2: Stronger movement forward
    ["boost"] = 6,         -- Turbo Boost: Double the next movement
    ["back"] = 2           -- Move Back 1: Small risk
}

--- @type table<string, number> Deck composition for "The Opportunist"
decks.presets.opportunist = {
    ["move"] = 8,          -- Move 1: Reliable forward movement
    ["move_2"] = 6,        -- Move 2: Stronger movement forward
    ["boost"] = 4,         -- Turbo Boost: Double the next movement
    ["defend_back"] = 6,   -- Defend: Protect against back attacks
    ["attack_back"] = 4,   -- Attack: Attack opponents and move them back
    ["push_ahead"] = 4     -- Push Ahead: Move forward and defend
}

--- @type table<string, number> Deck composition for "The Risk Taker"
decks.presets.risk_taker = {
    ["move"] = 10,         -- Move 1: Reliable forward movement
    ["move_2"] = 6,        -- Move 2: Stronger movement forward
    ["boost"] = 4,         -- Turbo Boost: Double the next movement
    ["back"] = 4,          -- Move Back 1: Small risk
    ["back_2"] = 6,        -- Double Back: High risk, big setback
    ["skip"] = 2           -- Skip: Minor disruption
}

--- Generate a deck of 32 cards based on the composition.
--- @param deck_name string The name of the deck to load.
--- @return string[] A 32-card array of unique card names.
decks.load_deck = function(deck_name)
    local preset_decks = {
        ["steady_racer"] = decks.presets.steady_racer,
        ["aggressive_attacker"] = decks.presets.aggressive_attacker,
        ["risky_gambler"] = decks.presets.risky_gambler,
        ["defensive_strategist"] = decks.presets.defensive_strategist,
        ["speedster"] = decks.presets.speedster,
        ["balanced_runner"] = decks.presets.balanced_runner,
        ["disruptor"] = decks.presets.disruptor,
        ["sprinter"] = decks.presets.sprinter,
        ["opportunist"] = decks.presets.opportunist,
        ["risk_taker"] = decks.presets.risk_taker
    }

    local deck_composition = preset_decks[deck_name]
    if not deck_composition then
        error("Invalid deck name: " .. deck_name)
    end

    local card_pool = {}
    for card_name, count in pairs(deck_composition) do
        for i = 1, count do
            table.insert(card_pool, card_name)
        end
    end

    -- Ensure the deck has exactly 32 cards
    if #card_pool > 32 then
        error("Deck exceeds 32 cards. Composition is invalid for " .. deck_name)
    elseif #card_pool < 32 then
        local filler_card = "move"  -- Default filler card is "Move 1"
        while #card_pool < 32 do
            table.insert(card_pool, filler_card)
        end
    end

    return card_pool
end

--- Randomly select a deck name and generate its 32-card array.
--- @return string[] A 32-card array of unique card names.
decks.load_random_deck = function()
    local presets = {
        "steady_racer",
        "aggressive_attacker",
        "risky_gambler",
        "defensive_strategist",
        "speedster",
        "balanced_runner",
        "disruptor",
        "sprinter",
        "opportunist",
        "risk_taker"
    }

    -- Get all deck names into an array
    local deck_names = {}
    for _, deck_name in pairs(presets) do
        table.insert(deck_names, deck_name)
    end

    -- Choose a random deck name
    math.randomseed(os.time())
    local random_index = math.random(1, #deck_names)
    local chosen_deck_name = deck_names[random_index]

    -- Load the selected deck
    return decks.load_deck(chosen_deck_name)
end

return decks