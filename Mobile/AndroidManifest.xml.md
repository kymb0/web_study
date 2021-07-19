#### To inspect a manifest file:  
`apktool d <apk_file>`  
`nano AndoroidManifest.xml`  
From within here you can see information such as compiled version, app name, permissions, etc

#### To further inspect an `.apk`  
`java -jar ClassyShark.jar`  
open the `.apk`  

#### interesting perms:  
_The android.permission.SET_DEBUG_APP allows the application to turn on debugging
for another application._  
_The android.permission.DUMP allows the application to retrieve the internal state of the
system_  
_The com.android.email.permission.READ_ATTACHMENT allows the application to read your
email attachments._  
_The android.permission.MANAGE_ACCOUNTS allows the application to perform
operations like adding/removing accounts and deleting their passwords_  
