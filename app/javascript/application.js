// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
document.addEventListener('DOMContentLoaded', () => {
    const searchBox = document.getElementById('search-box');
    searchBox.addEventListener('input', (event) => {
      const searchTerm = event.target.value;
      console.log(searchTerm); 
    });
  });