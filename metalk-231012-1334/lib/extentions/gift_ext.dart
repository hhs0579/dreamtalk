enum GiftExt {
  coffee(icon: 'assets/image/coffee.svg', title: '커피', diamond: 1),
  cake(icon: 'assets/image/cake.svg', title: '케이크', diamond: 5),
  rose(icon: 'assets/image/rose.svg', title: '장미', diamond: 10),
  bouquet(icon: 'assets/image/bouquet.svg', title: '꽃다발', diamond: 50),
  ring(icon: 'assets/image/ring.svg', title: '반지', diamond: 100),
  necklace(icon: 'assets/image/heart-necklace.svg', title: '목걸이', diamond: 500),
  bags(icon: 'assets/image/handbag.svg', title: '가방', diamond: 1000),
  foreignCar(icon: 'assets/image/car.svg', title: '외제차', diamond: 5000),
  house(icon: 'assets/image/home.svg', title: '집', diamond: 9999),
  ;

  final String icon;
  final String title;
  final int diamond;

  const GiftExt({
    required this.icon,
    required this.title,
    required this.diamond,
  });

  static GiftExt getValueOf(String? enumStr) {
    return GiftExt.values.firstWhere((element) => element.name == enumStr,
        orElse: () => GiftExt.values.first);
  }
}