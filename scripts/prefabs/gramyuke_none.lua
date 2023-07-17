local assets =
{
	Asset( "ANIM", "anim/gramyuke.zip" ),
	Asset( "ANIM", "anim/ghost_gramyuke_build.zip" ),
}

local skins =
{
	normal_skin = "gramyuke",
	ghost_skin = "ghost_gramyuke_build",
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