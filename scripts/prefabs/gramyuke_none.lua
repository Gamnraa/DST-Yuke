local assets =
{
	Asset( "ANIM", "anim/esctemplate.zip" ),
	Asset( "ANIM", "anim/ghost_esctemplate_build.zip" ),
}

local skins =
{
	normal_skin = "esctemplate",
	ghost_skin = "ghost_esctemplate_build",
}

return CreatePrefabSkin("gramyuke_none",
{
	base_prefab = "gramyuke",
	type = "base",
	assets = assets,
	skins = skins, 
	skin_tags = {"GRAMYUKE", "CHARACTER", "BASE"},
	build_name_override = "gramyuke",
	rarity = "Character",
})