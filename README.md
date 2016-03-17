# Buildmode
A Garry's Mod addon made for builder protection. Uploaded here so people can laugh at my mistakes.

####Features: 
*Players can enable Buildmode (with "!buildmode", by default) to restrict their weapons to the Physgun, Toolgun, and Camera and have invincibility. 
*Builders and/or Non-Builders can be highlighted with any RGB color. 
*If a Builder manages to kill a Non-Builder they will be kicked from the game. 

####Recent Additions: 
*+Added Buildmode abuse prevention. It will kick anyone who manages to kill someone while in Buildmode. (See Console Variables to disable) 
*+Added Builder Highlights. It outlines Builders. (See Console Variables to disable or configure) 
*+Added Non-Builder Highlights. It outlines people who aren't Builders. (See Console Variables to disable or configure) 
*+Added various console commands (See Console Variables) 
*=Changed various names to prevent incompatibility from other addons
*-Removed a "return" to fix a "compatibility" issue.

####Console Variables: 
All of these variables need to be edited by the server and apply to all clients. 
*"_kyle_builderCommand" Change the command to toggle Buildmode. 
*"_kyle_builderOnSpawn" Toggle whether Buildmode is enabled by default. (0-1) 
*"_kyle_builderAbuseKick" Toggle whether Builders are kicked for abusing Builder. (0-1) 

*"_kyle_builderHighlight" Toggle whether Builders are outlined. (0-1) 
*"_kyle_builderHighlightR" Change the RED hue of the Builder outline. (0-255) 
*"_kyle_builderHighlightB" Change the BLUE hue of the Builder outline. (0-255) 
*"_kyle_builderHighlightG" Change the GREEN hue of the Builder outline. (0-255) 

*"_kyle_builderExHighlight 1" Toggle whether Non-Builders are outlined. (0-1) 
*"_kyle_builderExHighlightR" Change the RED hue of the Non-Builder outline. (0-255) 
*"_kyle_builderExHighlightB" Change the BLUE hue of the Non-Builder outline. (0-255) 
*"_kyle_builderExHighlightG" Change the GREEN hue of the Non-Builder outline. (0-255) 
