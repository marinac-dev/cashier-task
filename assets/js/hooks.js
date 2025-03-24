let Hooks = {};

Hooks.ThemeToggle = {
  mounted() {
    this.el.addEventListener("click", (e) => {
      const html = document.querySelector("html");
      const currentTheme = html.getAttribute("data-theme");
      const newTheme = currentTheme === "dark" ? "light" : "dark";

      html.setAttribute("data-theme", newTheme);
      localStorage.setItem("theme", newTheme);
    });

    const savedTheme = localStorage.getItem("theme") || "dark";
    document.querySelector("html").setAttribute("data-theme", savedTheme);
  },
};

Hooks.ShoppingCart = {
  mounted() {
    console.log("ShoppingCart mounted");
  },
};

Hooks.AddToCart = {
  mounted() {
    this.el.addEventListener("click", (e) => {
      const productId = this.el.id;
      this.pushEvent("add", { product_code: productId });
      document.querySelector("#cart-sidebar").classList.remove("translate-x-full");
    });
  },
};

export default Hooks;
