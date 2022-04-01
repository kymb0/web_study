Consider that a web page contains addEventListener() in the source:
```
                    <script>
                        window.addEventListener('message', function(e) {
                            document.getElementById('ads').innerHTML = e.data;
                        })
                    </script>
```

As the event listener does not verify the origin of the message, and the postMessage() method specifies the targetOrigin "*", the event listener accepts the payload and passes it into a sink, in this case, the eval() function.

We can exploit this by injecting the below javascript into a page, so when the user loads a page, say, in an email, and it tries to load an iframe stored on the page containing the addEventListener(), when the page is loaded it triggers print() because an "event" has occured? (the event is the page being called as an iframe)

<iframe src="https://ac5f1f471f6efd53c0331224005500d8.web-security-academy.net/" onload="this.contentWindow.postMessage('<img src=1 onerror=print()>','*')">
