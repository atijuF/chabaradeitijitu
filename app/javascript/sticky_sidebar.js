document.addEventListener('DOMContentLoaded', (event) => {
  const sidebar = document.querySelector('.sticky-sidebar');
  const offset = 20; // 上からのオフセット
  
  window.addEventListener('scroll', () => {
    if (window.scrollY > sidebar.offsetTop - offset) {
      sidebar.style.position = 'fixed';
      sidebar.style.top = `${offset}px`;
    } else {
      sidebar.style.position = 'relative';
      sidebar.style.top = 'initial';
    }
  });
});