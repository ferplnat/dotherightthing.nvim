local M = {}
local auto_command_group = vim.api.nvim_create_augroup("marco-autocopyright", {})

M.setup = function(opts)
    M.config = opts or {}

    local autocopyright_filetypes = {}

    local add_autocopyright = function(filetype, copyright_header)
        autocopyright_filetypes[filetype] = copyright_header
    end

    -- Support for functions and strings
    for ft, header in pairs(M.config) do
        add_autocopyright(ft, header)
    end

    vim.api.nvim_create_autocmd({ "BufNewFile" }, {
        group = auto_command_group,
        callback = function(cbk)
            if opts.debug then
                print(vim.inspect(cbk))
            end

            -- If the filetype is not supported, don't add the header
            if not autocopyright_filetypes[vim.bo.filetype] then
                if opts.debug then
                    print("Filetype not supported")
                end

                return
            end

            -- If the file exists, don't add the header
            if vim.fn.filereadable(vim.fn.expand("%")) == 1 then
                if opts.debug then
                    print("File exists. Not adding header")
                end

                return
            end

            local copyright = autocopyright_filetypes[vim.bo.filetype]

            -- If the file is empty, add the header
            if vim.fn.line("$") == 1 and vim.fn.getline(1) == "" then
                if opts.debug then
                    print("File is empty. Adding header")
                    print("Type: " .. type(copyright))
                end

                if type(copyright) == "string" then
                    vim.fn.append(0, { copyright })
                elseif type(copyright) == "function" then
                    copyright = copyright(cbk)

                    if type(copyright) ~= "string" then
                        error("The header must be a string or a function that returns a string")
                    end

                    vim.fn.append(0, { copyright(cbk) })
                elseif type(copyright) == "table" then
                    for count, line in ipairs(copyright) do
                        if opts.debug then
                            print("Line " .. count .. ": " .. type(line))
                        end

                        if type(line) == "function" then
                            line = line(cbk)
                        end

                        if type(line) ~= "string" then
                            error("The header must be a string or a function that returns a string")
                        end

                        vim.fn.append(count - 1, { line })
                    end
                end
            end
        end,
    })
end

return M
