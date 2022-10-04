Add custom header regex to pull a value of a cookie/macro extracted param and apply to header: `vrfx=(.*?);` - note you MUST have semi colon
When creating a new rule to invoke macro, make sure at the bottom you select invoke extension - it cant be a seperate rule condition.  
You don't always need to invoke teh custom header extension in sesion handling rules, you can simply invoke a macro and configure the add custome header extension.  
Sometimes using ATOR will be more suitable if the auth flow is complex.  
