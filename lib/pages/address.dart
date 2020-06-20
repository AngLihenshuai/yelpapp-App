class Address {  
  static const String search_by_id_URL = "https://api.yelp.com/v3/businesses/";
  static const String nearby_URL = "https://api.yelp.com/v3/businesses/search?term=restaurants&latitude=";
  static const String search_URL = "https://api.yelp.com/v3/autocomplete?text=";
  //static const String req_header = 'Bearer endKOtxDzmquiDBFQKImIss0K8oBAsSaatw84j7Z_mdayis_dfwdaAeiAGgARwPu7I9i3rYzQcNTVA8JL05phkq7O7elOZ5fLYjliuElh5ac8QyeJ9Lsdn871yE2XXYx';
  static const String req_header = 'Bearer 8OtpFqTO4ZtGaIUR60x5ovrBLKDo4XAip9RAzB0lZDa6uowQpVjxA29VtMTcbToRm3UaYNXmc3AW1Lpwm6pIN_gI3WtdYbhL-UdhhpJq6T93lk0Hg1WAv0oVE3KqXnYx';
  static const String backend_root_address = "https://yelp-diy-service.herokuapp.com/";
  static const String review_url_address = backend_root_address + "getreviewurl?url=";
  static const String review_by_id = backend_root_address + "/getreview/<businessId>";  
  static const String review_search_address = backend_root_address + "/search/<term>/<location>/";
  // static const String item_pic = 'https://lh3.googleusercontent.com/tTI-TsvK6Gn_9PiUD_aiIAXiC-4uSYC5SBif_IFXgPIVgdCkA0BthkZskqp6ww_90ikUiIaII_Ipktl40J4Fn8Dh1FvmSP2lZXl_hbMoEzDRUbVmRp50xsKRK77M3aCaeS3y6Qqk';
  static const String item_pic = "https://lh6.googleusercontent.com/FJLmj6S9DN-JFRZwH3Dapnjf1Kv-WvIRiUtffbaZZfziJFd0omj7-QmndcRY2X0v0cKOXV2EmE4rIpPO9_FPn2lmNZ1vWliMMfMPGKLbz_r7TZaqB_CeW9Twp_dE7X_kKkBq4NEI";
}
