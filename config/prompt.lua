-- local function lambda_prompt_filter()
--     clink.prompt.value = string.gsub(clink.prompt.value, "{lamb}", "$")
-- end

---
 -- Resolves closest directory location for specified directory.
 -- Navigates subsequently up one level and tries to find specified directory
 -- @param  {string} path    Path to directory will be checked. If not provided
 --                          current directory will be used
 -- @param  {string} dirname Directory name to search for
 -- @return {string} Path to specified directory or nil if such dir not found
local function get_dir_contains(path, dirname)

    -- return parent path for specified entry (either file or directory)
    local function pathname(path)
        local prefix = ""
        local i = path:find("[\\/:][^\\/:]*$")
        if i then
            prefix = path:sub(1, i-1)
        end
        return prefix
    end

    -- Navigates up one level
    local function up_one_level(path)
        if path == nil then path = '.' end
        if path == '.' then path = clink.get_cwd() end
        return pathname(path)
    end

    -- Checks if provided directory contains git directory
    local function has_specified_dir(path, specified_dir)
        if path == nil then path = '.' end
        local found_dirs = clink.find_dirs(path..'/'..specified_dir)
        if #found_dirs > 0 then return true end
        return false
    end

    -- Set default path to current directory
    if path == nil then path = '.' end

    -- If we're already have .git directory here, then return current path
    if has_specified_dir(path, dirname) then
        return path..'/'..dirname
    else
        -- Otherwise go up one level and make a recursive call
        local parent_path = up_one_level(path)
        if parent_path == path then
            return nil
        else
            return get_dir_contains(parent_path, dirname)
        end
    end
end

local function get_git_dir(path)
    return get_dir_contains(path, '.git')
end

---
 -- Find out current branch
 -- @return {false|git branch name}
---
local function get_git_branch()
    for line in io.popen("git branch 2>nul"):lines() do
        local m = line:match("%* (.+)$")
        if m then
            return m
        end
    end

    return false
end

---
 -- Get the status of working dir
 -- @return {bool}
---
local function get_git_status()
    return os.execute("git diff --quiet --ignore-submodules HEAD 2>nul")
end

local function git_prompt_filter()

    -- Colors for git status
    local colors = {
        clean = "\x1b[1;37;40m",
        dirty = "\x1b[31;1m",
    }

    if get_git_dir() then
        -- if we're inside of git repo then try to detect current branch
        local branch = get_git_branch()
        if branch then
            -- Has branch => therefore it is a git folder, now figure out status
            if get_git_status() then
                color = colors.clean
                string.gsub(branch, "*", "")
            else
                color = colors.dirty
                branch = branch .. "*"
            end

            clink.prompt.value = string.gsub(clink.prompt.value, "{git}", color.." ("..branch..")")
            return false
        end
    end

    -- No git present or not in git file
    clink.prompt.value = string.gsub(clink.prompt.value, "{git}", "")
    return false
end

-- clink.prompt.register_filter(lambda_prompt_filter, 40)
clink.prompt.register_filter(git_prompt_filter, 50)
