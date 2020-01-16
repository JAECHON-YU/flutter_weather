import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/common/streams.dart';
import 'package:flutter_weather/model/data/read_data.dart';
import 'package:flutter_weather/model/service/read_service.dart';
import 'package:flutter_weather/viewmodel/viewmodel.dart';

class ReadViewModel extends ViewModel {
  final _service = ReadService();

  final data = StreamController<List<ReadData>>();

  List<ReadData> _cacheData = List();
  bool selfLoading = false;
  int _page = 1;
  String _typeUrl;

  void init({@required String typeUrl}) {
    _typeUrl = typeUrl;
    loadData(type: LoadType.NEW_LOAD);
  }

  Future<Null> loadData({@required LoadType type}) async {
    if (selfLoading) return;
    selfLoading = true;

    if (type == LoadType.REFRESH) {
      _page = 1;
      _cacheData.clear();
    } else {
      isLoading.safeAdd(true);
    }

    try {
      final list = await _service.getReadDatas(lastUrl: _typeUrl, page: _page);

      _cacheData.addAll(list);
      data.safeAdd(_cacheData);
      _page++;
    } on DioError catch (e) {
      selfLoadType = type;
      doError(e);
    } finally {
      selfLoading = false;
      isLoading.safeAdd(false);
    }
  }

  void reload() {
    loadData(type: selfLoadType);
  }

  void loadMore() {
    loadData(type: LoadType.LOAD_MORE);
  }

  @override
  void dispose() {
    _service.dispose();
    _cacheData.clear();

    data.close();

    super.dispose();
  }
}
