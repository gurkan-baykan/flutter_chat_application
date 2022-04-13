class HataMesajlari {
  String goster(String code) {
    switch (code) {
      case "email-already-in-use":
        return "Bu mail adresi zaten kullanımda lütfen farklı bir mail adresi kullanınız.";
        break;
      case "user-not-found":
        return "Kullanıcı bulunamadı !";
        break;
      default:
        return "İşlem sırasında bir hata oluştu !";
    }
  }
}
