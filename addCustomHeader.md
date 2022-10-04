Add custom header regex to pull a value of a cookie/macro extracted param and apply to header: `vrfx=(.*?);` - note you MUST have semi colon
You don't always need to invoke teh custom header extension in sesion handling rules, you can simply invoke a macro and configure the add custome header extension.  
Sometimes using ATOR will be more suitable if the auth flow is complex.  
