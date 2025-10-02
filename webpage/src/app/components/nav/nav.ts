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
    if (this.darkMode) document.documentElement.classList.add('dark');
    else document.documentElement.classList.remove('dark');
    localStorage.setItem('darkMode', this.darkMode ? 'true' : 'false');

    // Post message to Flutter webview JS channel if available
    try {
      const ch = (window as any).ThemeChannel;
      if (ch && typeof ch.postMessage === 'function') {
        ch.postMessage(this.darkMode ? 'dark' : 'light');
      }
    } catch (e) {}
  }
}


