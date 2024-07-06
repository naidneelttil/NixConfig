{
  # Import all your configuration modules here
  imports = [ ./bufferline.nix ];
 
######
#  options = {
#    number = true;
#    relativenumber = true;
#    shiftwidth = 2;


#  };
######

  globals.mapleader = " ";

  colorschemes.gruvbox.enable = true;


  plugins = { 
        telescope.enable = true;
	oil.enable = true;
	treesitter.enable = true;
	luasnip.enable = true;

       lualine.enable = true; 
        lsp.enable = true;
	lsp.servers = { 
           lua-ls.enable = true;
	   rust-analyzer.enable = true;

	   rust-analyzer.installRustc = true;
	   rust-analyzer.installCargo = true;
	};


	

  };
  
}
