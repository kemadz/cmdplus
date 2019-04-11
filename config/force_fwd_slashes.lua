local function force_fwd_slashes(text, first, last)
    clink.slash_translation(1)
    return false
end

clink.register_match_generator(force_fwd_slashes, -1)