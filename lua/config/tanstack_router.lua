-- TanStack Router: auto-scaffold new route files (mirrors the Vite plugin behavior)
-- When the dev server runs, `@tanstack/router-plugin/vite` auto-fills any new
-- file created inside the app's `routes` directory with a route template
-- (createFileRoute / createLazyFileRoute / createRootRoute). In Neovim we
-- replicate that with a BufNewFile autocmd: create a new .tsx/.jsx file under
-- any `routes` folder and it gets filled automatically, no dev server needed.
--
-- Also provides :TanstackRoute <name> / :TanstackLazyRoute <name>.

local api = vim.api
local IMPORT = "@tanstack/react-router"

-- True when the path of a new file lives inside a `routes` directory.
local function is_route_file(fname)
	local ok_ext = fname:match("%.tsx$") ~= nil or fname:match("%.jsx$") ~= nil
	return fname:match("/routes/") ~= nil and ok_ext
end

-- Route id from the file path, relative to the routes dir:
--   test.tsx            -> /test
--   test.lazy.tsx       -> /test
--   admin/index.tsx     -> /admin
--   posts/$postId.tsx  -> /posts/$postId
--   foo.bar.tsx        -> /foo/bar   (dots flatten to slashes)
local function route_id(fname)
	local idx = fname:find("/routes/")
	if not idx then
		return nil
	end
	local rel = fname:sub(idx + #"/routes/")
	rel = rel:gsub("%.lazy$", "")          -- drop .lazy modifier
	rel = rel:gsub("%.[^/]+$", "")         -- drop extension
	rel = rel:gsub("%.", "/")              -- dots -> slashes
	rel = rel:gsub("/+$", "")              -- trailing slashes
	rel = rel:gsub("/index$", "")          -- nested index -> parent path
	if rel == "" then
		return "/"
	end
	return "/" .. rel
end

local function normal_template(id)
	local comp = "RouteComponent"
	return table.concat({
		"import { createFileRoute } from '" .. IMPORT .. "'",
		"",
		"export const Route = createFileRoute('" .. id .. "')({",
		"  component: " .. comp .. ",",
		"})",
		"",
		"function " .. comp .. "() {",
		"  return <div>Hello \"" .. id .. "\"!</div>",
		"}",
		"",
	}, "\n")
end

local function lazy_template(id)
	local comp = "RouteComponent"
	return table.concat({
		"import { createLazyFileRoute } from '" .. IMPORT .. "'",
		"",
		"export const Route = createLazyFileRoute('" .. id .. "')({",
		"  component: " .. comp .. ",",
		"})",
		"",
		"function " .. comp .. "() {",
		"  return <div>Hello \"" .. id .. "\"!</div>",
		"}",
		"",
	}, "\n")
end

local function root_template()
	return table.concat({
		"import { createRootRoute, Outlet } from '" .. IMPORT .. "'",
		"",
		"export const Route = createRootRoute({",
		"  component: () => (",
		"    <>",
		"      <Outlet />",
		"    </>",
		"  ),",
		"})",
		"",
	}, "\n")
end

local function template_for(fname)
	if fname == "" or not is_route_file(fname) then
		return nil
	end
	local base = fname:match("([^/]+)$")
	if not base then
		return nil
	end
	if base == "__root.tsx" or base == "__root.jsx" then
		return root_template()
	end
	local id = route_id(fname)
	if not id then
		return nil
	end
	if base:match("%.lazy%.tsx$") or base:match("%.lazy%.jsx$") then
		return lazy_template(id)
	end
	return normal_template(id)
end

api.nvim_create_autocmd("BufNewFile", {
	callback = function(args)
		-- Only fresh, regular buffers (skip filetype-driven events & existing files)
		if vim.bo[args.buf].buftype ~= "" then
			return
		end
		local fname = api.nvim_buf_get_name(args.buf)
		if vim.fn.filereadable(fname) ~= 0 then
			return
		end
		local text = template_for(fname)
		if text then
			api.nvim_buf_set_lines(args.buf, 0, -1, false, vim.split(text, "\n", { plain = true }))
			vim.bo[args.buf].filetype = fname:match("%.jsx$") and "javascriptreact" or "typescriptreact"
		end
	end,
})

-- ---------------------------------------------------------------------------
-- :TanstackRoute <name>          create src/routes/<name>.tsx
-- :TanstackLazyRoute <name>      create src/routes/<name>.lazy.tsx
-- ---------------------------------------------------------------------------
local function find_routes_dir()
	local cwd = vim.fn.getcwd()
	for _, candidate in ipairs({ cwd .. "/src/routes", cwd .. "/routes", cwd .. "/src/app/routes" }) do
		if vim.fn.isdirectory(candidate) == 1 then
			return candidate
		end
	end
	return nil
end

local function new_route(name, lazy)
	if not name or name == "" then
		vim.notify("TanstackRoute: route name required (e.g. posts/$postId)", vim.log.levels.WARN)
		return
	end
	local dir = find_routes_dir()
	if not dir then
		vim.notify("TanstackRoute: no `routes` directory found under " .. vim.fn.getcwd(), vim.log.levels.ERROR)
		return
	end
	name = name:gsub("^/+", ""):gsub("/+$", "")
	name = name:gsub("%.lazy$", "")
	local suffix = lazy and ".lazy.tsx" or ".tsx"
	local full = dir .. "/" .. name .. suffix
	if vim.fn.filereadable(full) ~= 0 then
		vim.notify("TanstackRoute: file already exists: " .. full, vim.log.levels.WARN)
		return
	end
	vim.fn.mkdir(vim.fn.fnamemodify(full, ":h"), "p")
	vim.cmd("edit " .. vim.fn.fnameescape(full))
	-- The BufNewFile autocmd already filled it; fall back just in case.
	if vim.fn.line("$") == 1 and vim.fn.getline(1) == "" then
		local text = template_for(full)
		if text then
			api.nvim_buf_set_lines(0, 0, -1, false, vim.split(text, "\n", { plain = true }))
		end
	end
	vim.cmd("silent write") -- actually create the file on disk
	vim.notify("Created route: " .. full)
end

api.nvim_create_user_command("TanstackRoute", function(args)
	new_route(args.fargs[1], false)
end, { nargs = 1 })
api.nvim_create_user_command("TanstackLazyRoute", function(args)
	new_route(args.fargs[1], true)
end, { nargs = 1 })
