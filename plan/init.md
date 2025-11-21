create an application to let the user create a cookbook of custom recipes and automatically generate customized weekly menu and shopping list based on the recipes.

the app helps the user to input recipes with preferences and ingredients and automatically generate weekly menu and shopping list for each day upon user request.

the app should have the following screens:
- login screen
- sign up screen
- weekly menu screen
- shopping list screen
- cookbook screen
- recipe screen
- settings screen

here are the details about the screens:
- the login screen should have input fields for email and password, a login button, a sign up button, a reset button for forgotten password.
- the sign up screen should have input fields for email, password, and confirm password, and a sign up button.
- the settings screen should show a welcome word for the user, the current user's email, a selector to let the user choose which meals should be included in the weekly menu (choices are breakfast, lunch, dinner, snack), a selector for the user to choose which week days should the weekly menu include (choices are monday, tuesday, wednesday, thursday, friday, saturday, sunday), a button for sign out, a button for delete the account
- the weekly menu screen should show a list. a item in the list is the menu for a day of the week days user selected in the settings screen containing the meals the user selected in the settings screen. the weekly menu should also have a button for re-generate the weekly menu.
- the cookbook screen should show a list of user added recipes and a button for adding new receipes.
- the recipe screen should show ingredients for the recipe, style of the recipe, type of the recipe (which is a multi-selection of breakfast, lunch, dinner, snack), and a star rating of the recipe. star rating can have a integer value of 1/2/3/4/5. all properties in the recipe screen can be edited with a edit button.
- shopping list screen should show a checklist that user can mark down. the checklist is generated from the ingredients of the weekly menu generated. when the menu re-generates, the checklist should be updated, outdated items will be removed. the list should cluster by days of week with monday on top and sunday at buttom.

here is how the screens should interact:
- when the app launches, the login screen should be displayed. when the user successfully sign in or the user has signed in before, the user should be navigated to the weekly menu screen.
- when the user taps on the sign up button, the user should be navigated from the login screen to the sign up screen. Upon successful sign up, the user should be navigated back to the login screen and immediately navigated to the weekly menu screen.
- the weekley menu screen, settings screen, cookbook screen should be a group navigated by bottom navigator bar or swiping left or right on the screen. The order on the bottom navigator bar is weekley menu, cookbook, settings. Use corresponding icon for the bottom navigator.
- when the user sign out or delete account in the settings screen, the user should be navigated back to the login screen.
- when the user taps on a recipe in the cookbook screen, the user should be navigated to the corresponding recipe screen.
- when the user tap on the add new recipe button, a pop up will show up to prompt user input the name of the recipe, other properties will require user to modify in the recipe screen after creation. the default style is "daily" and the default rating is 1.

the app should use firebase as the backend service. the app should only use authentication and firestore from firebase and do not use any other service.

in the database, each user should have a collection `/users/{uid}`. `/users/{uid}` collection should have the following properties:
- `weeklyMenu` to hold the current weekly menu, only the most recent generated menu is kept and previous one will be replaced.
- `cookbook` to hold the user added recipes.
- `profile` to hold the user profile.

the logic for regenerate weekly menu should be:
- compose a list of all avaialbe recipes that satifies the current requirement. For example, for generating lunch, all recipes with lunch type checked should be in the list.
- replicate entries according to the star ratings. for example, a recipe with star rating of 2 will be replicated to have 2 identical entries in the list.
- randomly pick from the list without replacement for all the days in a week selected by the user.
- repeat it for all the meal types selected by the user.

the app should be internationalized to support english and chinese, when the user choose system default, if the user's system language is chinese, use chinese, otherwise use english.

the app will only support email and password authentication through firebase authentication.

do not attempt to initialize firebase for the app, do everything else and the user will initialize firebase for the app when all tasks are completed.

finish the tasks independently, do not prompt user input, use your best guess for any unclarified details.
