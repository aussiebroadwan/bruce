local decks = {}

--- Deck presets with names for later development. By default all
--- these decks will be identical, being filled with `move 1` 
--- cards. See `special_presets` for the more advanced version.
--- @type table<string, table<string, number>>
decks.presets = {
    ["steady_racer"] = { },
    ["aggressive_attacker"] = { },
    ["risky_gambler"] = { },
    ["defensive_strategist"] = { },
    ["speedster"] = { },
    ["balanced_runner"] = { },
    ["disruptor"] = { },
    ["sprinter"] = { },
    ["opportunist"] = { },
    ["risk_taker"] = { },
    ["slime_master"] = { },
    ["turbo_charger"] = { },
    ["chaos_creator"] = { },
    ["defensive_crawler"] = { },
    ["trailblazer"] = { },
    ["trickster"] = { },
    ["power_snail"] = { },
    ["opportunist_stalker"] = { },
    ["speed_demon"] = { },
    ["saboteur"] = { }
}

--- This is currently unused but will add some cool features
--- to the race, it just needs balancing.
--- @type table<string, table<string, number>>
decks.special_presets = {
    -- Focuses on reliable forward movement with some defensive options.
    ["steady_racer"] = {
        ["move_2"] = 6,
        ["boost"] = 4,
        ["defend_back"] = 2
    },
    -- Focuses on attacking opponents and disrupting their progress.
    ["aggressive_attacker"] = {
        ["attack_back"] = 6,
        ["double_attack"] = 4,
        ["slime_trail"] = 2
    },
    -- A high-risk, high-reward deck with powerful boosts and risky setbacks.
    ["risky_gambler"] = {
        ["boost"] = 6,
        ["back_2"] = 4,
        ["reverse_psychology"] = 2
    },
    -- Prioritizes defense and consistent progress while mitigating risks.
    ["defensive_strategist"] = {
        ["defend_back"] = 8,
        ["shell_shield"] = 6,
        ["slime_trail"] = 2
    },
    -- A speed-focused deck for rapid forward movement.
    ["speedster"] = {
        ["move_2"] = 6,
        ["boost"] = 4,
        ["escargot_express"] = 2
    },
    -- A balanced deck that combines forward movement and defense.
    ["balanced_runner"] = {
        ["move_2"] = 4,
        ["boost"] = 4,
        ["defend_back"] = 4
    },
    -- A disruptive deck that slows down opponents with attacks and skips.
    ["disruptor"] = {
        ["attack_back"] = 6,
        ["compost_chaos"] = 4,
        ["salt_storm"] = 2
    },
    -- Focuses on bursts of forward movement with minimal interference.
    ["sprinter"] = {
        ["move_2"] = 8,
        ["boost"] = 4,
        ["push_ahead"] = 2
    },
    -- Balances offensive and defensive strategies for opportunistic plays.
    ["opportunist"] = {
        ["boost"] = 4,
        ["defend_back"] = 6,
        ["charge"] = 2
    },
    -- Trades stability for risky cards and unpredictable outcomes.
    ["risk_taker"] = {
        ["boost"] = 6,
        ["back_2"] = 4,
        ["slime_trail"] = 2
    },
    -- A disruption-heavy deck with strong skip and attack effects.
    ["slime_master"] = {
        ["slime_trail"] = 6,
        ["skip"] = 4,
        ["attack_back"] = 4
    },
    -- Prioritizes momentum through boosts and strong forward movement.
    ["turbo_charger"] = {
        ["boost"] = 8,
        ["morning_dew"] = 4,
        ["escargot_express"] = 2
    },
    -- A chaos-driven deck that spreads disruption among all players.
    ["chaos_creator"] = {
        ["salt_storm"] = 6,
        ["compost_chaos"] = 4,
        ["reverse_psychology"] = 2
    },
    -- A defensive deck that prioritizes survival and slow, steady progress.
    ["defensive_crawler"] = {
        ["defend_back"] = 8,
        ["shell_shield"] = 6,
        ["garden_buffet"] = 2
    },
    -- A consistent, forward-focused deck for reliable progress.
    ["trailblazer"] = {
        ["move_2"] = 8,
        ["boost"] = 6,
        ["push_ahead"] = 2
    },
    -- A sneaky deck that relies on skips and back effects to frustrate opponents.
    ["trickster"] = {
        ["sticky_trap"] = 6,
        ["back"] = 4,
        ["double_attack"] = 2
    },
    -- A deck designed for impactful plays with big, high-value cards.
    ["power_snail"] = {
        ["move_2"] = 6,
        ["escargot_express"] = 4,
        ["charge"] = 2
    },
    -- Combines opportunistic attacks with defensive strategies.
    ["opportunist_stalker"] = {
        ["attack_back"] = 6,
        ["defend_back"] = 6,
        ["sticky_trap"] = 2
    },
    -- A fast but risky deck for snails that live on the edge.
    ["speed_demon"] = {
        ["move_2"] = 8,
        ["boost"] = 6,
        ["back"] = 4
    },
    -- Specializes in sabotaging opponents to hinder their progress.
    ["saboteur"] = {
        ["slime_trail"] = 6,
        ["compost_chaos"] = 4,
        ["salt_storm"] = 2
    }
}


--- Generate a deck of 32 cards based on the composition.
--- @param deck_name string The name of the deck to load.
--- @return string[] deck A 32-card array of unique card names.
decks.load_deck = function(deck_name)
    local deck_composition = decks.presets[deck_name]
    if not deck_composition then
        error("Invalid deck name: " .. deck_name)
    end

    local card_pool = {}
    for card_name, count in pairs(deck_composition) do
        for _ = 1, count do
            table.insert(card_pool, card_name)
        end
    end

    -- Ensure the deck has exactly 32 cards
    if #card_pool > 32 then
        error("Deck exceeds 32 cards. Composition is invalid for " .. deck_name)
    elseif #card_pool < 32 then
        local filler_card = "move" -- Default filler card is "Move 1"
        while #card_pool < 32 do
            table.insert(card_pool, filler_card)
        end
    end

    return card_pool
end

--- Randomly select a deck name and generate its 32-card array.
--- @return string[] deck A 32-card array of unique card names.
decks.load_random_deck = function()
    -- Get a list of all deck names
    local deck_names = {}
    for name in pairs(decks.presets) do
        table.insert(deck_names, name)
    end

    -- Choose a random deck name
    local chosen_deck_name = deck_names[math.random(#deck_names)]

    -- Load the selected deck
    return decks.load_deck(chosen_deck_name)
end

return decks

