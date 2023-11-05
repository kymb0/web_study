sites built on react, node, etc

use `https://github.com/denandz/sourcemapper` after locating the .map file on a modern webapp    
example:  
`./sourcemapper -url https://www.website.com/static/js/main.72998b08.chunk.js.map -output ./output/ -proxy http://127.0.0.1:8080`  

crawl with katana to gather as many endpoints as possible  
`https://github.com/projectdiscovery/katana`  

can also use the hack in console located here:  
`https://0-a.nl/jsendpoints.txt`  

use `https://github.com/denandz/sourcemapper` after locating the .map file    
example:  
`./sourcemapper -url https://www.website.com/static/js/main.72998b08.chunk.js.map -output ./output/ -proxy http://127.0.0.1:8080`  
after this, run trufflehog on the created directories
`/trufflehog filesystem --directory=./output --debug`  

Don't forget to run through sonarqube - trust me, it's easier if you just do this in kali  
`sudo systemctl start postgresql`  
`sudo passwd postgres`  
`su - postgres`  
`createuser sonar`  
`psql`  
`postgres=# ALTER USER sonar WITH ENCRYPTED PASSWORD 'postgres';`  
`CREATE DATABASE sonarqube OWNER sonar;`  
`GRANT ALL PRIVILEGES ON DATABASE sonarqube to sonar;`  
`\q`  
`sudo mv sonarqube-9.8.0.63668 /opt/sonarqube`  
`sudo groupadd sonar`  
`sudo useradd -c "SonarQube - User" -d /opt/sonarqube/ -g sonar sonar`  
`sudo chown -R sonar:sonar /opt/sonarqube/`  
`sudo nano /opt/sonarqube/sonarqube-9.8.0.63668/conf/sonar.properties` either make changes as described in [here](https://thenewstack.io/how-to-install-the-sonarqube-security-analysis-platform/) or paste the contents in file in this repo  
`sudo nano /opt/sonarqube/sonarqube-9.8.0.63668/bin/linux-x86-64/sonar.sh` at the bottom of file insert `RUN_AS_USER=sonar`  
`sudo nano /etc/systemd/system/sonarqube.service` either make changes as described in [here](https://thenewstack.io/how-to-install-the-sonarqube-security-analysis-platform/) or paste the contents in file in this repo  
You will have to move the contents of /opt/sonarqube/sonarqube-xxx-xxx into /opt/sonarqube  
`sudo systemctl start sonarqube`  
`sudo systemctl start nginx` 
`sudo nano /etc/nginx/sites-enabled/sonarqube.conf` either make changes as described in [here](https://thenewstack.io/how-to-install-the-sonarqube-security-analysis-platform/) or paste the contents in file in this repo  
`sudo systemctl restart nginx`  
Access the site at `http://127.0.0.1:9000` admin:admin  
`sudo npm install sonarqube-scanner -g`  
