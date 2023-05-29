class Constant {
  static String appName = "Chat App";
  static String yourCompany = "Chat App, Inc";
  static String domainIP = "api-auth.febriansyah.dev";
  static String port = "";
  static String mainUrl = port == '' ? domainIP : "$domainIP:$port";
  static String httpMainUrl = "https://$mainUrl";
}
