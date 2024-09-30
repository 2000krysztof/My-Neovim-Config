require('ufo').setup({
    provider_selector = function(bufnr, filetype, buftype)
        return ""
    end
})
vim.cmd("set foldcolumn=1")
