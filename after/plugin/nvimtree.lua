local nvim_tree = require("neo-tree")

nvim_tree.setup({
	filesystem ={

		filtered_items = {
			hide_by_pattern= {
				"*.meta",
				"*.asset"
			}
		}

	}

})
