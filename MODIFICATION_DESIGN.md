# WeeklyMenu App Modification Design Document

## 1. Overview
This document outlines the design for addressing the incorrect order of bottom navigation items in the WeeklyMenu application. The current order does not match the desired sequence of "Weekly Menu", "Shopping List", "Cookbook", "Settings" (from left to right). The goal is to implement an integration test to verify the correct ordering and then modify the application code to achieve this new sequence.

## 2. Detailed Analysis of the Goal or Problem

### 2.1. Incorrect Bottom Navigator Item Order
- **Problem:** The `BottomNavigationBar` items are currently not ordered as "Weekly Menu", "Shopping List", "Cookbook", "Settings" from left to right. This affects user experience and application consistency.
- **Analysis:** In Flutter applications using `go_router` with `StatefulShellRoute.indexedStack`, the order of `BottomNavigationBarItem`s is directly tied to the order of the `StatefulShellBranch`es defined in the `GoRouter` configuration. Similarly, the `BottomNavigationBar` widget in `lib/presentation/widgets/scaffold_with_nav_bar.dart` defines the visual order of its items. For the order to be correct and consistent, both these lists must be aligned.

## 3. Alternatives Considered

### 3.1. Verification Approach
- **Option 1 (Integration Test - Preferred):** Develop a dedicated integration test (`integration_test/bottom_navigator_order_test.dart`) to programmatically verify the order of navigation items. This provides automated, repeatable confirmation of the UI structure.
- **Option 2 (Manual visual inspection):** Manually launch the application and visually confirm the order. While essential for a final sanity check, this method is not automated and can be prone to oversight.

### 3.2. Implementation Approach
- **Option 1 (Direct modification of `main.dart` and `scaffold_with_nav_bar.dart` - Preferred):** Adjust the order of `StatefulShellBranch` definitions within `lib/main.dart` and the corresponding `BottomNavigationBarItem`s within `lib/presentation/widgets/scaffold_with_nav_bar.dart`. This is the most direct and efficient way to achieve the desired ordering.

## 4. Detailed Design for the Modification

### 4.1. Integration Test Design

- **Goal:** Create an integration test (`integration_test/bottom_navigator_order_test.dart`) to assert the correct order of the bottom navigation bar items.
- **Test Setup:**
    1.  Log in a test user to reach a state where the `BottomNavigationBar` is visible.
    2.  Navigate to any screen that displays the `BottomNavigationBar` (e.g., `WeeklyMenuScreen`).
- **Test Steps:**
    1.  Find all `BottomNavigationBarItem`s in the `BottomNavigationBar`.
    2.  Extract the `icon` or `label` of each item.
    3.  Assert that these extracted identifiers are in the exact sequence: `Weekly Menu` (Icons.menu_book), `Shopping List` (Icons.shopping_cart), `Cookbook` (Icons.restaurant_menu), `Settings` (Icons.settings).
    4.  A robust way to check order would be to get a list of the icons/labels and compare it against an expected ordered list. Alternatively, tap each icon in the expected order and verify the corresponding screen appears. The latter is more comprehensive for navigation tests. For just order verification, comparing a list of icons/labels should suffice.

### 4.2. Fix Implementation

- **Approach:** Synchronize the order of `StatefulShellBranch`es in `lib/main.dart` and `BottomNavigationBarItem`s in `lib/presentation/widgets/scaffold_with_nav_bar.dart`.
- **Target Files:**
    - `lib/main.dart`: Contains the `GoRouter` configuration with `StatefulShellBranch`es.
    - `lib/presentation/widgets/scaffold_with_nav_bar.dart`: Contains the `BottomNavigationBar` widget and its `items` list.
- **Changes:**
    1.  **In `lib/main.dart`**: Reorder the `StatefulShellBranch` definitions within the `StatefulShellRoute.indexedStack`'s `branches` list to:
        -   `/weekly-menu` branch
        -   `/shopping-list` branch
        -   `/cookbook` branch
        -   `/settings` branch
    2.  **In `lib/presentation/widgets/scaffold_with_nav_bar.dart`**: Reorder the `BottomNavigationBarItem` widgets within the `items` list of the `BottomNavigationBar` to precisely match the new order of `StatefulShellBranch`es:
        -   Item for `Weekly Menu` (Icons.menu_book)
        -   Item for `Shopping List` (Icons.shopping_cart)
        -   Item for `Cookbook` (Icons.restaurant_menu)
        -   Item for `Settings` (Icons.settings)
- **Rationale:** This synchronization ensures that the `GoRouter`'s routing mechanism (which uses the branch index) correctly corresponds to the visual order presented by the `BottomNavigationBar`.

## 5. Diagrams

### 5.1. Bottom Navigation Order Flow

```mermaid
graph TD
    A[lib/main.dart: GoRouter Configuration] --> B{StatefulShellRoute.indexedStack};
    B -- Order of Branches --> C[lib/presentation/widgets/scaffold_with_nav_bar.dart: BottomNavigationBar];
    C -- Order of Items --> D[Rendered UI: Bottom Navigator Order (Weekly Menu, Shopping List, Cookbook, Settings)];

    subgraph GoRouter Configuration
        W(StatefulShellBranch: /weekly-menu)
        S(StatefulShellBranch: /shopping-list)
        C(StatefulShellBranch: /cookbook)
        T(StatefulShellBranch: /settings)
    end

    subgraph BottomNavigationBar Items
        IW(Item: Weekly Menu)
        IS(Item: Shopping List)
        IC(Item: Cookbook)
        IT(Item: Settings)
    end

    W --- C
    S --- T
    C --- I
    T --- S
```

## 6. Summary of the Design

The design outlines a process to correct the bottom navigation item order in the WeeklyMenu app. This will be achieved by first creating an integration test (`bottom_navigator_order_test.dart`) to programmatically assert the desired sequence: "Weekly Menu", "Shopping List", "Cookbook", "Settings". The implementation will then involve carefully reordering the `StatefulShellBranch`es within `lib/main.dart`'s `GoRouter` configuration and synchronizing this order with the `BottomNavigationBarItem`s in `lib/presentation/widgets/scaffold_with_nav_bar.dart`. This ensures both the routing logic and the visual presentation are aligned with the specified left-to-right order.

## 7. References to Research URLs
- [Flutter GoRouter documentation: StatefulShellRoute](https://pub.dev/documentation/go_router/latest/go_router/StatefulShellRoute-class.html)
- [Flutter BottomNavigationBar documentation](https://api.flutter.dev/flutter/material/BottomNavigationBar-class.html)
- [Flutter Integration Testing](https://flutter.dev/docs/testing/integration-tests)
