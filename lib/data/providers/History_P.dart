import 'package:ao3mobile/data/models/History.dart';
import 'package:sembast/sembast.dart';

import '../DB/SDB.dart';



class History_P {

  History_P();

  static StoreRef<String, Map<String, dynamic>> HistoryStore = StoreRef<String, Map<String, dynamic>>("History");

  Future<bool> checkIfHistoryExists(int workId, int chapId) async {
    String key = "${workId}_${chapId}";
    return HistoryStore.record(key).get(await SDB.instance.history) != null;
  }

  Future<void> pushHistory(History history) async {
    String key = "${history.workId}_${history.chapId}";
    await HistoryStore.record(key).put(await SDB.instance.history, history.toMap());
  }

  Future<History> getHistory(int workId, int chapId) async {
    String key = "${workId}_${chapId}";
    return mapToHistory(HistoryStore.record(key).get(await SDB.instance.history) as Map<String, dynamic>);
  }

  Future<List<History>> getHistoryList() async {
    Finder search = Finder(sortOrders: [SortOrder("accessDate", false)], limit: 100); // limiting to 100 max for performance
    List<Map<String, dynamic>> recs = await HistoryStore.find(await SDB.instance.history, finder: search) as List<Map<String, dynamic>>;

    List<History> out = [];
    for(Map<String, dynamic> rec in recs) {
      out.add(mapToHistory(rec));
    }

    return out;
  }



  History mapToHistory(Map<String, dynamic> input) {
    History temp = History();

    if (input.containsKey("workId")) temp.workId = input["workId"];
    if (input.containsKey("workName")) temp.workName = input["workName"];
    if (input.containsKey("author")) temp.author = input["author"];
    if (input.containsKey("chapId")) temp.chapId = input["chapId"];
    if (input.containsKey("chapNum")) temp.chapNum = input["chapNum"];
    if (input.containsKey("chapName")) temp.chapName = input["chapName"];
    if (input.containsKey("pos")) temp.pos = input["pos"];
    if (input.containsKey("maxPos")) temp.maxPos = input["maxPos"];
    if (input.containsKey("accessDate")) temp.accessDate = input["accessDate"];

    return temp;
  }
}