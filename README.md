# Getir iOS Shopping App - Final Case

![Getir_iOS_Shopping_App (1)](https://github.com/Tayfo10/GetirFinalCase/assets/105911315/ca569028-ef4b-4750-82f3-e1edf86d516f)

<p align="justify">
  Welcome to the repository for the Getir Final Case project, an iOS shopping application designed to simulate a real-world e-commerce experience.
</p>

## App Demonstrations

<p align="center">
  <img src="https://github.com/Tayfo10/GetirFinalCase/assets/105911315/43ea490f-4abc-4bdc-bbf4-c0acf16118d7" alt="Record 1" width="30%" style="margin-right: 10px;">
  <img src="https://github.com/Tayfo10/GetirFinalCase/assets/105911315/0859f34c-0d16-4a81-8dd3-9831e9a1bec7" alt="Record 2" width="30%" style="margin-right: 10px;">
  <img src="https://github.com/Tayfo10/GetirFinalCase/assets/105911315/c3bda04f-f71b-4a4f-a8ae-6ddba6527b47" alt="Record 3" width="30%">
</p>

## Features
#### Product Listing (`ProductListingVC`)

- **Dynamic Display**: Utilizes a `UICollectionView` to display products in either a list or a grid format, adapting to device orientation and user preferences.
- **Responsive Layouts**: Implements `UICollectionViewCompositionalLayout` for a flexible and responsive product display.
- **Product Categories**: Products are categorized into sections, allowing users to easily browse through different types of products(horizontal and vertical).
- **Real-time UI Updates**: Integrates with `CartManager` to update UI elements dynamically based on user actions, such as adding items to the cart.
#### Product Details (`ProductDetailVC`)

- **Detailed Product Information**: Shows detailed information about each product, including images, price, and other attributes.
- **Interactive UI**: Users can change product quantities, view detailed descriptions, and add items to their cart directly from this view.
- **Navigation Integration**: Seamlessly integrates with `NavigationCartButton` to allow users to view their cart or go back to the product listing.

#### Shopping Cart (`ShoppingCartVC`)
- **Cart Management**: Allows users to see all items they have added to their cart, with options to adjust quantities or remove items entirely.
- **Checkout Process**: Implements a checkout process that includes confirmation dialogs, displaying total prices, and a final call to action for purchase completion.
- **Dynamic Updates**: The total price and item count are updated in real-time as users add or remove products.
- **Empty State Handling**: Provides feedback when the cart is empty and guides users back to the product listing for further browsing.

## Project Data Management and Architecture
- The application adopts the Model-View-Controller (MVC) architecture to ensure clean separation of concerns, making it easier to manage and maintain.
- The `CartManager` is implemented as a singleton to ensure there is only one instance of this class throughout the application, which manages all shopping cart functionalities.
- Changes in the cart are synchronized across the application via the singleton `CartManager`, ensuring all views display the updated data without requiring a reload.

- ## Setup

To run this project, clone this repository and open it in Xcode:

```bash
git clone https://github.com/Tayfo10/GetirFinalCase.git
cd GetirFinalCase
open App.xcodeproj anything to add?
