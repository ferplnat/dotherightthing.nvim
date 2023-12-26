# Do the right thing!
This plugin automatically adds text headers to files as flexibly as possible.<br>
It was created with the intention of automatically adding copyright headers to the<br>
top of files, but it really could be used for anything.

This wasn't originally intended to be a plugin, so the source is a bit of a mess.<br>
it started as something that was sitting in my config and was adapted to be shared :)

## Setup

Configuration is minimal, there are very few options. An example configuration
below.

```lua
require('dotherightthing').setup({
    filetypes = {
        ['ps1'] = '# Copyright CompanyName. All rights reserved.',

        ['cs'] = {
            local company_name = "CompanyName"
            function(cbk)
                -- Get the filename from the full path in the callback
                local filename = vim.fn.fnamemodify(cbk.match, ':t')
                return '// <copyright file="' .. filename .. '" company="' .. '">'
            end,

            '// Copyright (c) ' .. '. All rights reserved.',
            '// </copyright>',
        },

    debug = false,
})
```

## Flexibility

Flexibility was a very important part of how I constructed this plugin, I wanted<br>
to yield the creation of strings as much as possible back to the setup function.

As such, there are many valid formats of the filetypes configuration.

The `filetypes` field takes key value pairs with the key matching the filetype<br>
provided through Neovim's filetype detection. You can find the filetype for any<br>
given buffer by running `:lua print(vim.bo.filetype)` within a buffer.

The value is where there are many syntax options. Strings, tables, and functions<br>
are accepted.

- Tables may contain strings, functions or a mix of both.
- Tables, in all scenarios, are interpreted as every entry being a new line.
- Functions must always return either a table of strings, or a string.
- Any function is invoked with the callback provided by Nvim's autocmd's 'command'

If there are any other scenarios that would be helpful to support, I am open<br>
to contributions or suggestions. I think the options provided should cover 99% of<br>
cases.

## TODO:
- Default configurations for popular filetypes with intuitive functions.
