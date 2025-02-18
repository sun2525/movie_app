document.addEventListener("DOMContentLoaded", function () {
  function updateCarouselSettings() {
    let perSlide = window.innerWidth <= 767 ? 3 : 5;
    let carousels = document.querySelectorAll(".carousel-inner"); // 🔄 すべての .carousel-inner を取得

    if (carousels.length === 0) {
      console.error("🚨 .carousel-inner が見つかりません！");
      return;
    }

    carousels.forEach(carouselInner => {
      let movies = Array.from(carouselInner.querySelectorAll(".movie-card"));
      let groupedMovies = [];

      // `perSlide` ごとにグループ分け
      for (let i = 0; i < movies.length; i += perSlide) {
        groupedMovies.push(movies.slice(i, i + perSlide));
      }

      // 既存のスライドをクリア
      carouselInner.innerHTML = "";

      // 新しいスライドを追加
      groupedMovies.forEach((group, index) => {
        let slide = document.createElement("div");
        slide.classList.add("carousel-item");
        if (index === 0) slide.classList.add("active");

        let row = document.createElement("div");
        row.classList.add("row", "flex-nowrap", "align-items-center");

        group.forEach(movie => row.appendChild(movie));
        slide.appendChild(row);
        carouselInner.appendChild(slide);
      });
    });

    console.log(`✅ スライド設定完了（${perSlide}本ずつ）`);
  }

  updateCarouselSettings();
  window.addEventListener("resize", updateCarouselSettings);
});
