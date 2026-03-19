import 'api_client.dart';

class CategoryService {

  final ApiClient api = ApiClient();

  Future<List> getCategories() async {

    final res = await api.dio.get("/categories/");

    return res.data;
  }

}