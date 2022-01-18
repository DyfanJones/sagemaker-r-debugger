src_dir = ./vendor/smdebug_rulesconfig/smdebug_rulesconfig/debugger_rules/rule_config_jsons
dest_dir = ./inst

get-json-config:
	@git submodule init
	@git submodule update --remote
	@mkdir -p $(dest_dir)
	@cp -R $(src_dir) $(dest_dir)
