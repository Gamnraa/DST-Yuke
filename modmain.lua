PrefabFiles = {
	"gramyuke",
	"gramyuke_none",
    "ster"
}

Assets = {
    --[[Asset( "IMAGE", "images/saveslot_portraits/gramyuke.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/gramyuke.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/gramyuke.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/gramyuke.xml" ),
	
    Asset( "IMAGE", "images/selectscreen_portraits/gramyuke_silho.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/gramyuke_silho.xml" ),]]
	
	Asset( "IMAGE", "bigportraits/gramyuke.tex" ),
    Asset( "ATLAS", "bigportraits/gramyuke.xml" ),
	
    Asset( "IMAGE", "bigportraits/gramyuke_none.tex" ),
    Asset( "ATLAS", "bigportraits/gramyuke_none.xml" ),
	
	Asset( "IMAGE", "images/map_icons/gramyuke.tex" ),
	Asset( "ATLAS", "images/map_icons/gramyuke.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_gramyuke.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_gramyuke.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_ghost_gramyuke.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_gramyuke.xml" ),
	
	Asset( "IMAGE", "images/avatars/self_inspect_gramyuke.tex" ),
    Asset( "ATLAS", "images/avatars/self_inspect_gramyuke.xml" ),
	
	Asset( "IMAGE", "images/names_gramyuke.tex" ),
    Asset( "ATLAS", "images/names_gramyuke.xml" ),
	
	Asset( "IMAGE", "images/names_gold_gramyuke.tex" ),
    Asset( "ATLAS", "images/names_gold_gramyuke.xml" ),
	
	Asset("SOUNDPACKAGE", "sound/gramyuke.fev"),
	Asset("SOUND", "sound/gramyuke.fsb"),
}

AddMinimapAtlas("images/map_icons/gramyuke.xml")

local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS

-- The character select screen lines
STRINGS.CHARACTER_TITLES.gramyuke = "The Succubus"
STRINGS.CHARACTER_NAMES.gramyuke = "Yuke"
STRINGS.CHARACTER_DESCRIPTIONS.gramyuke = "Not normally afflicted by temperature\n*Heat makes her insane and powerful\n*Cold relaxes her but weakens her"
STRINGS.CHARACTER_QUOTES.gramyuke = "\"That is not dead which can eternal lie, and with strange aeons even death may die.\""
STRINGS.CHARACTER_SURVIVABILITY.gramyuke = "Slim"

-- Custom speech strings
STRINGS.CHARACTERS.GRAMYUKE = require "speech_gramyuke"

-- The character's name as appears in-game 
STRINGS.NAMES.GRAMYUKE = "Yuke"
STRINGS.SKIN_NAMES.gramyuke_none = "Yuke"

-- The skins shown in the cycle view window on the character select screen.
-- A good place to see what you can put in here is in skinutils.lua, in the function GetSkinModes
local skin_modes = {
    { 
        type = "ghost_skin",
        anim_bank = "ghost",
        idle_anim = "idle", 
        scale = 0.75, 
        offset = { 0, -25 } 
    },
}

RemapSoundEvent( "dontstarve/characters/gramyuke/death_voice", "gramyuke/characters/gramyuke/death_voice" )
RemapSoundEvent( "dontstarve/characters/gramyuke/hurt", "gramyuke/characters/gramyuke/hurt" )
RemapSoundEvent( "dontstarve/characters/gramyuke/emote", "gramyuke/characters/gramyuke/emote" )
RemapSoundEvent( "dontstarve/characters/gramyuke/yawn", "gramyuke/characters/gramyuke/yawn" )
RemapSoundEvent( "dontstarve/characters/gramyuke/pose", "gramyuke/characters/gramyuke/pose" )
RemapSoundEvent( "dontstarve/characters/gramyuke/ghost_LP", "gramyuke/characters/gramyuke/ghost_LP" )
RemapSoundEvent( "dontstarve/characters/gramyuke/talk_LP", "gramyuke/characters/gramyuke/talk_LP" )
RemapSoundEvent( "dontstarve/characters/gramyuke/carol", "gramyuke/characters/gramyuke/carol" )
RemapSoundEvent( "dontstarve/characters/gramyuke/eye_rub_vo", "gramyuke/characters/gramyuke/eye_rub_vo" )
RemapSoundEvent( "dontstarve/characters/gramyuke/sinking", "gramyuke/characters//gramyuke/sinking" )

-- Add mod character to mod character list. Also specify a gender. Possible genders are MALE, FEMALE, ROBOT, NEUTRAL, and PLURAL.
AddModCharacter("gramyuke", "FEMALE", skin_modes)