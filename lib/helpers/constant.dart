class Constant {
  static String domainIP = "10.41.38.4";
  static String port = "2035";
  static String mainUrl = port == '' ? domainIP : "$domainIP:$port";
  static String httpMainUrl = "http://$mainUrl";
}
