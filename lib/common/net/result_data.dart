/// 网络结果数据
class ResultData {
  dynamic data;
  bool result;
  int? code;
  dynamic headers;

  ResultData(this.data, this.result, this.code, {this.headers});
}
