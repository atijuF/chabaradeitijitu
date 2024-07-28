document.addEventListener('DOMContentLoaded', (event) => {
  const sidebar = document.querySelector('.sticky-sidebar');
  const offset = 20; // 上からのオフセット
  const footer = document.querySelector('.footer'); // フッター要素を取得

  window.addEventListener('scroll', () => {
    const sidebarHeight = sidebar.offsetHeight;
    const footerTop = footer.offsetTop;
    const scrollY = window.scrollY;
    const windowHeight = window.innerHeight;

    if (scrollY + offset > sidebar.offsetTop) {
      if (scrollY + sidebarHeight + offset > footerTop - offset) {
        sidebar.style.position = 'absolute';
        sidebar.style.top = `${footerTop - sidebarHeight - offset}px`;
      } else {
        sidebar.style.position = 'fixed';
        sidebar.style.top = `${offset}px`;
      }
    } else {
      sidebar.style.position = 'relative';
      sidebar.style.top = 'initial';
    }
  });
});