import { Injectable } from '@angular/core';
import {SQL} from '../../DB/sql';
import {Observable} from 'rxjs';
import {Work} from '../../models/work';

@Injectable({
  providedIn: 'root'
})
export class WorkPipeline {

  constructor(private sql: SQL) { }

  get(id: number): Observable<Work> {
    return new Observable<Work>();
  }
}
