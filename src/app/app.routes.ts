import { Routes } from '@angular/router';
import {MainViewComponent} from './views/main-view/main-view.component';
import {FiltersSubViewComponent} from './views/main-view/filters-sub-view/filters-sub-view.component';

export const routes: Routes = [
  {
    path: 'main',
    component: MainViewComponent,
    children: [
      { path: 'search', loadComponent: () => import('./views/main-view/search-sub-view/search-sub-view.component').then((c) => c.SearchSubViewComponent) },
      { path: 'filters', loadComponent: () => import('./views/main-view/filters-sub-view/filters-sub-view.component').then((c) => c.FiltersSubViewComponent) },
      { path: 'timeline', loadComponent: () => import('./views/main-view/timeline-sub-view/timeline-sub-view.component').then((c) => c.TimelineSubViewComponent) },
      { path: 'library', loadComponent: () => import('./views/main-view/library-sub-view/library-sub-view.component').then((c) => c.LibrarySubViewComponent) },
      { path: 'settings', loadComponent: () => import('./views/main-view/settings-sub-view/settings-sub-view.component').then((c) => c.SettingsSubViewComponent) },
    ]
  },
  { path: 'work/:workId', loadComponent: () => import('./views/work-view/work-view.component').then((c) => c.WorkViewComponent) },
  { path: 'work/:workId/chapter/:chapterId', loadComponent: () => import('./views/chapter-view/chapter-view.component').then((c) => c.ChapterViewComponent) },
  { path: '', redirectTo: 'main/search', pathMatch: 'full', }
];
