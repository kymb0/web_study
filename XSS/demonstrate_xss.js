(function() {
  const div = document.createElement("div");
  div.innerText = "retrieved and executed via XSS";
  div.style.position = "fixed";
  div.style.top = 0;
  div.style.left = 0;
  div.style.width = "100vw";
  div.style.height = "100vh";
  div.style.fontSize = "48px";
  div.style.fontWeight = "bold";
  div.style.color = "#fff";
  div.style.backgroundColor = "#f00";
  div.style.zIndex = 99999;
  div.style.display = "flex";
  div.style.alignItems = "center";
  div.style.justifyContent = "center";
  document.body.appendChild(div);

  let toggle = true;
  setInterval(() => {
    div.style.backgroundColor = toggle ? "#f00" : "#000";
    toggle = !toggle;
  }, 300);
})();
