import { Component, signal, OnInit } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { Nav } from './components/nav/nav'; 

@Component({
  selector: 'app-root',
  imports: [RouterOutlet, Nav],
  templateUrl: './app.html',
  styleUrl: './app.css'
})
export class App implements OnInit {
  ngOnInit() {
    try {
        const params = new URLSearchParams(window.location.search);
        const q = params.get('theme');
        const saved = localStorage.getItem('darkMode');

        if (q === 'dark') {
          document.documentElement.classList.add('dark');
          localStorage.setItem('darkMode', 'true');
        } else if (q === 'light') {
          document.documentElement.classList.remove('dark');
          localStorage.setItem('darkMode', 'false');
        } else if (saved === 'true') {
          document.documentElement.classList.add('dark');
        } else if (saved === 'false') {
          document.documentElement.classList.remove('dark');
        }
      } catch (e) {}
    }
  }