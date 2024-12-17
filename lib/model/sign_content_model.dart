class SignContentModel {
  List<SignContent>? data;
  bool? status;

  SignContentModel({
    this.data,
    this.status,
  });

  factory SignContentModel.fromJson(Map<String, dynamic> json) =>
      SignContentModel(
        data: json["data"] == null
            ? []
            : List<SignContent>.from(
                json["data"]!.map((x) => SignContent.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "status": status,
      };
}

class SignContent {
  double? st;
  double? et;
  String? vu;
  double? vd;
  String? s;
  int? q;

  SignContent({
    this.st,
    this.et,
    this.vu,
    this.vd,
    this.s,
    this.q,
  });

  factory SignContent.fromJson(Map<String, dynamic> json) => SignContent(
        st: json["st"]?.toDouble(),
        et: json["et"]?.toDouble(),
        vu: json["vu"],
        vd: json["vd"]?.toDouble(),
        s: json["s"],
        q: json["q"],
      );

  Map<String, dynamic> toJson() => {
        "st": st,
        "et": et,
        "vu": vu,
        "vd": vd,
        "s": s,
        "q": q,
      };
}
