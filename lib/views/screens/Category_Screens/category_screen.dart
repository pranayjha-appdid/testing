import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../controllers/category_controller.dart';
import '../../base/common_button.dart';
import '../../base/dialogs/custom_textfield.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _searchController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      controller: _searchController,
                      hintText: 'Search Meal',
                      prefixIcon: Icons.search,
                      onChanged: (query) async {
                        if (query.trim().isNotEmpty) {
                          // Implement search functionality here
                          // await controller.SearchMeal(query.trim());
                        } else {
                          // controller.mealList.clear(); // Clear results if input is empty
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.black),
                    ),
                    child: IconButton(
                      onPressed: () {
                        // Refresh or reset the search
                      },
                      icon: Icon(Icons.refresh),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              GetBuilder<CategoryController>(
                builder: (categoryController) {
                  return Expanded(
                    child: categoryController.categoryDataList.isEmpty
                        ? Center(child: CircularProgressIndicator()) // Show loading indicator
                        : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 0,
                      ),
                      itemCount: categoryController.categoryDataList.length,
                      itemBuilder: (context, index) {
                        final category = categoryController.categoryDataList[index];
                        return GestureDetector(
                          onTap: () {

                            // Implement category details navigation here
                            // Get.to(CategoryDetailsPage(category: category.strCategory));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.network(
                                category.strCategoryThumb,
                                height: 100,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(child: CircularProgressIndicator());
                                },
                              ),
                              SizedBox(height: 10),
                              Text(
                                category.strCategory,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              // If you decide to use the logout button, uncomment below:
              // CustomButton(
              //   onTap: () async {
              //     await FirebaseAuth.instance.signOut();
              //     // Get.to(Login());
              //   },
              //   text: "Logout"
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
