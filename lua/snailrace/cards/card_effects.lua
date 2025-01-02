--- Enum for card effects.
local effects = {
    FORWARD = "move",   -- Move the snail forward by 1 space
    BACK = "back",      -- Move the snail backward by 1 space
    SKIP = "skip",      -- Skip the snail's turn
    BOOST = "boost",    -- Double the snail's next movement whether that is double forward, backward, skip, etc.
    ATTACK = "attack",  -- Set card to effect another random snail with the matching effects on the card
    DEFEND = "defend",  -- Set card to defend against an attack of certain effects
}

return effects
