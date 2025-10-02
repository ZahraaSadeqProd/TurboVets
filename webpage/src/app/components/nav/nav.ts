import { Component } from '@angular/core';
import { RouterLink, RouterLinkActive } from '@angular/router';

@Component({
  selector: 'app-nav',
  imports: [RouterLink, RouterLinkActive],
  templateUrl: './nav.html',
  styleUrl: './nav.css'
})
export class Nav {
  darkMode = false;

  constructor() {
    // Check if user had dark mode on from last session
    this.darkMode = document.documentElement.classList.contains('dark');
  }

  toggleDark() {
    this.darkMode = !this.darkMode;
    if (this.darkMode) {
      document.documentElement.classList.add('dark');
    } else {
      document.documentElement.classList.remove('dark');
    }
    // Optional: persist setting
    localStorage.setItem('darkMode', this.darkMode ? 'true' : 'false');
  }
}


