import 'package:ao3mobile/data/models/SearchData.dart';
import 'package:sembast/sembast.dart';

import '../DB/SDB.dart';



class Search_P {

  Search_P();

  static StoreRef<int, dynamic> SearchStore = StoreRef<int, dynamic>("Search");

  Future<SearchData> getSearchData() async {
    SearchData temp = SearchData();

    if (await SearchStore.record(0).get(await SDB.instance.temp) == null) return temp;
    else temp.numFound = await SearchStore.record(0).get(await SDB.instance.temp) as String;

    Finder search = Finder(offset: 1);
    List<RecordSnapshot<int, dynamic>> recs = await SearchStore.find(await SDB.instance.temp, finder: search);

    for(int i = 0; i < recs.length; i++) {
      temp.workIds.add(recs[i].value as int);
    }

    return temp;
  }

  Future<void> updateSearchinfo(List<dynamic> list) async {
    await (await SDB.instance.temp).transaction((txn) async {
      for(int i = 0; i < list.length; i++) {
        await SearchStore.record(i).put(txn, list[i]);
      }
    });
  }

  Future<void> clearStore() async {
    await SearchStore.drop(await SDB.instance.temp);
  }

}