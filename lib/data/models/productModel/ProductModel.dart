class ProductModel {
  String? title;
  String? titleLowercase;
  String? price;
  String? category;
  String? condition;
  String? description;
  String? address;
  List<dynamic>? images;
  Map<String , dynamic> ? favorites;
  String? vendorName;
  String? imageProfileVendor;
  String? uIdVendor;
  dynamic timesTamp;



  ProductModel({
    this.title,
    this.titleLowercase,
    this.price,
    this.category,
    this.condition,
    this.description,
    this.address,
    this.images,
    this.favorites,
    this.vendorName,
    this.imageProfileVendor,
    this.uIdVendor,
    this.timesTamp,
});



  ProductModel.fromJson(Map<String , dynamic> json) {
    title = json['title'];
    titleLowercase = json['title_lowercase'];
    price = json['price'];
    category = json['category'];
    condition = json['condition'];
    description = json['description'];
    address = json['address'];
    images = json['images'];
    favorites = json['favorites'];
    vendorName = json['vendor_name'];
    imageProfileVendor = json['image_profile_vendor'];
    uIdVendor = json['uId_vendor'];
    timesTamp = json['times_tamp'];

  }


  Map<String , dynamic> toMap() {

    return {
      'title': title,
      'title_lowercase': titleLowercase,
      'price': price,
      'category': category,
      'condition': condition,
      'description': description,
      'address': address,
      'images': images,
      'favorites': favorites,
      'vendor_name': vendorName,
      'image_profile_vendor': imageProfileVendor,
      'uId_vendor': uIdVendor,
      'times_tamp': timesTamp,

  };


}


}