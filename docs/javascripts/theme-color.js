(() => {
  const storageKey = "transcripts-theme-color";
  const colors = [
    { id: "jade", name: "青玉", value: "#236b5e" },
    { id: "indigo", name: "靛蓝", value: "#465a9d" },
    { id: "rose", name: "绛红", value: "#963f52" },
    { id: "graphite", name: "石墨", value: "#505963" },
  ];

  const readColor = () => {
    try {
      const value = localStorage.getItem(storageKey);
      return colors.some((color) => color.id === value) ? value : "jade";
    } catch {
      return "jade";
    }
  };

  const saveColor = (value) => {
    try {
      localStorage.setItem(storageKey, value);
    } catch {
      // The selected color still applies when storage is unavailable.
    }
  };

  const applyColor = (value, menu) => {
    const selected = colors.find((color) => color.id === value) || colors[0];
    document.body.dataset.transcriptColor = selected.id;
    saveColor(selected.id);

    if (!menu) return;
    const current = menu.querySelector(".theme-color-current");
    current.style.setProperty("--swatch-color", selected.value);
    menu.querySelector("summary").title = `主题色：${selected.name}`;
    menu.querySelectorAll(".theme-color-swatch").forEach((button) => {
      button.setAttribute("aria-pressed", String(button.dataset.color === selected.id));
    });
  };

  const mountColorMenu = () => {
    const header = document.querySelector(".md-header__inner");
    if (!header) return;

    let menu = header.querySelector(".theme-color-menu");
    if (!menu) {
      menu = document.createElement("details");
      menu.className = "theme-color-menu";
      menu.innerHTML = `
        <summary aria-label="选择主题色">
          <span class="theme-color-current" aria-hidden="true"></span>
        </summary>
        <div class="theme-color-options" role="group" aria-label="主题色">
          ${colors.map((color) => `
            <button
              class="theme-color-swatch"
              type="button"
              data-color="${color.id}"
              title="${color.name}"
              aria-label="${color.name}"
              aria-pressed="false"
              style="--swatch-color: ${color.value}"
            ></button>
          `).join("")}
        </div>
      `;

      menu.addEventListener("click", (event) => {
        const button = event.target.closest(".theme-color-swatch");
        if (!button) return;
        applyColor(button.dataset.color, menu);
        menu.open = false;
      });

      const search = header.querySelector("label[for='__search']");
      header.insertBefore(menu, search);
    }

    applyColor(readColor(), menu);
  };

  document.addEventListener("click", (event) => {
    const menu = document.querySelector(".theme-color-menu[open]");
    if (menu && !menu.contains(event.target)) menu.open = false;
  });

  if (typeof document$ !== "undefined") {
    document$.subscribe(mountColorMenu);
  } else if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", mountColorMenu);
  } else {
    mountColorMenu();
  }
})();
