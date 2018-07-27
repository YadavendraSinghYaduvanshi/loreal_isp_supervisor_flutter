class JOURNEY_PLAN_SUP {
  final int STORE_CD;
  final int EMP_CD;
  final String VISIT_DATE;
  final String KEYACCOUNT;
  final String STORENAME;
  final String CITY;
  final String STORETYPE;
  final String UPLOAD_STATUS;
  final String CHECKOUT_STATUS;
  final String LATTITUDE;
  final String LONGITUDE;
  final String GEO_TAG;
  final int CHANNEL_CD;
  final String CHANNEL;

  JOURNEY_PLAN_SUP({
    this.STORE_CD,
    this.EMP_CD,
    this.VISIT_DATE,
    this.KEYACCOUNT,
    this.STORENAME,
    this.CITY,
    this.STORETYPE,
    this.UPLOAD_STATUS,
    this.CHECKOUT_STATUS,
    this.LATTITUDE,
    this.LONGITUDE,
    this.GEO_TAG,
    this.CHANNEL_CD,
    this.CHANNEL,
  });

  factory JOURNEY_PLAN_SUP.fromJson(Map<String, dynamic> json) {
    return JOURNEY_PLAN_SUP(
      STORE_CD: json['STORE_CD'] as int,
      EMP_CD: json['EMP_CD'] as int,
      VISIT_DATE: json['VISIT_DATE'] as String,
      KEYACCOUNT: json['KEYACCOUNT'] as String,
      STORENAME: json['STORENAME'] as String,
      CITY: json['CITY'] as String,
      STORETYPE: json['STORETYPE'] as String,
      UPLOAD_STATUS: json['UPLOAD_STATUS'] as String,
      CHECKOUT_STATUS: json['CHECKOUT_STATUS'] as String,
      LATTITUDE: json['LATTITUDE'] as String,
      LONGITUDE: json['LONGITUDE'] as String,
      GEO_TAG: json['GEO_TAG'] as String,
      CHANNEL_CD: json['CHANNEL_CD'] as int,
      CHANNEL: json['CHANNEL'] as String,
    );
  }
}

class JCPGetterSetter {
  int _STORE_CD;
  int _EMP_CD;
  String _VISIT_DATE;
  String _KEYACCOUNT;
  String _STORENAME;
  String _CITY;
  String _STORETYPE;
  String _UPLOAD_STATUS;
  String _CHECKOUT_STATUS;
  String _LATTITUDE;
  String _LONGITUDE;
  String _GEO_TAG;
  int _CHANNEL_CD;
  String _CHANNEL;

  JCPGetterSetter(this._STORE_CD, this._EMP_CD, this._VISIT_DATE,
      this._KEYACCOUNT, this._STORENAME, this._CITY, this._STORETYPE,
      this._UPLOAD_STATUS, this._CHECKOUT_STATUS, this._LATTITUDE,
      this._LONGITUDE, this._GEO_TAG, this._CHANNEL_CD, this._CHANNEL);

  int get STORE_CD => _STORE_CD;

  set STORE_CD(int value) {
    _STORE_CD = value;
  }

  String get CHANNEL => _CHANNEL;

  set CHANNEL(String value) {
    _CHANNEL = value;
  }

  int get CHANNEL_CD => _CHANNEL_CD;

  set CHANNEL_CD(int value) {
    _CHANNEL_CD = value;
  }

  String get GEO_TAG => _GEO_TAG;

  set GEO_TAG(String value) {
    _GEO_TAG = value;
  }

  String get LONGITUDE => _LONGITUDE;

  set LONGITUDE(String value) {
    _LONGITUDE = value;
  }

  String get LATTITUDE => _LATTITUDE;

  set LATTITUDE(String value) {
    _LATTITUDE = value;
  }

  String get CHECKOUT_STATUS => _CHECKOUT_STATUS;

  set CHECKOUT_STATUS(String value) {
    _CHECKOUT_STATUS = value;
  }

  String get UPLOAD_STATUS => _UPLOAD_STATUS;

  set UPLOAD_STATUS(String value) {
    _UPLOAD_STATUS = value;
  }

  String get STORETYPE => _STORETYPE;

  set STORETYPE(String value) {
    _STORETYPE = value;
  }

  String get CITY => _CITY;

  set CITY(String value) {
    _CITY = value;
  }

  String get STORENAME => _STORENAME;

  set STORENAME(String value) {
    _STORENAME = value;
  }

  String get KEYACCOUNT => _KEYACCOUNT;

  set KEYACCOUNT(String value) {
    _KEYACCOUNT = value;
  }

  String get VISIT_DATE => _VISIT_DATE;

  set VISIT_DATE(String value) {
    _VISIT_DATE = value;
  }

  int get EMP_CD => _EMP_CD;

  set EMP_CD(int value) {
    _EMP_CD = value;
  }


}


class CoverageGettersetter{

  String KEY_STORE_CD = "STORE_CD", KEY_STORE_IMG_IN = "STORE_IMG_IN", KEY_STORE_IMG_OUT = "STORE_IMG_OUT";
  int _STORE_CD;
  String _STORE_IMG_IN, _STORE_IMG_OUT;

  CoverageGettersetter(this._STORE_CD, this._STORE_IMG_IN, this._STORE_IMG_OUT);

  int get STORE_CD => _STORE_CD;

  get STORE_IMG_OUT => _STORE_IMG_OUT;

  String get STORE_IMG_IN => _STORE_IMG_IN;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      KEY_STORE_CD: _STORE_CD,
      KEY_STORE_IMG_IN: _STORE_IMG_IN,
      KEY_STORE_IMG_OUT: _STORE_IMG_OUT
    };
  /*  if (id != null) {
      map[columnId] = id;
    }*/
    return map;
  }

}

class ImageGettersetter{

  String _img_path;

  ImageGettersetter(this._img_path);

  String get img_path => _img_path;
}