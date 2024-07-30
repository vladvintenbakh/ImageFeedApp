# ImageFeed

https://github.com/user-attachments/assets/4c56afd9-0d99-4036-9fd8-8a817d594b3b

# Links

- [Figma Design](https://clck.ru/38ddGT)
- [Unsplash API](https://unsplash.com/documentation)

# Purpose

ImageFeed is a multi-screen app intended for viewing images loaded with Unsplash API.

Main usage:
- Viewing the infinite feed of images loaded from Unsplash Editorial.
- Viewing user profile information.

# Brief app description

- The app requires authorization with OAuth.
- The main screen consists of an image feed. The user can scroll through it, like/unlike images (i.e. add to/remove from favorites).
- The user can view each image individually and share the link to it.
- The user has a profile page showing brief profile information.

# Non-functional requirements

1. Authorization is implemented using Unsplash OAuth (sending a POST request to obtain an Auth Token).
2. The image feed is implemented using UITableView.
3. The app uses the following UI components: UImageView, UIButton, UILabel, UITabBarController, UINavigationController, UINavigationBar, UITableView, UITableViewCell.
4. Minimum deployment version: iOS 13.
5. The UI elements adapt to different iPhone screens (iPhone X or higher).
6. Supports portrait orientation only.
7. All fonts in the app are system fonts.

# Functional requirements

# Authorization using OAuth

The user must authorize with OAuth to be able to use the app.

**The authorization screen contains:**
1. The app logo
2. The sign in button

**Logic and available actions:**

1. The user sees the launch screen when they open the app.
2. A screen that allows the user to authorize is shown when the app loads.
    1. When the user clicks the "Sign in" button, Unsplash authorization page opens in the browser.
        1. When the user clicks the "Login" button, the browser screen is dismissed. A loading screen is displayed in the app.
        2. If the Unsplash OAuth authorization is not configured, nothing happens upon clicking the login button.
        3. If the Unsplash OAuth authorization is configured incorrectly, the user will not be able to access the main app functionality.
        4. If the login attempt is failed, an error alert is displayed;
            1. If the user presses "OK", they are redirected back to the authorization screen.
        5. If the authorization was successful, the browser closes. The image feed screen is shown in the app.

## Viewing the image feed

The image feed functionality allows the user to scroll through the images in the feed, transition to viewing individual images, and like/unlike images (i.e. add to/remove from favorites).

**The image feed screen contains:**

1. The image card for each image.
    1. The like button.
    2. Image upload date.
2. The tab bar for navigating between the image feed and profile screens.

**Logic and available actions:**

1. The image feed screen is shown by default if the user is signed in.
2. The feed contains images from Unsplash Editorial.
3. The user can view the images by scrolling up or down.
    1. If an image is still loading, a loading indicator is displayed.
    2. If an image cannot be loaded, a placeholder is shown in its place.
4. The user can like an image by pressing the like button (gray heart). A loading indicator is displayed after pressing it.
    1. If the request succeeds, the loading indicator is hidden, and the icon color changes to red.
    2. If the request fails, an error alert is shown. The user can press the button in the alert to try again.
5. The user can unlike an image by pressing the like button (red heart) again. A loading indicator is displayed after pressing it.
    1. If the request succeeds, the loading indicator is hidden, and the icon color changes to gray.
    2. If the request fails, an error alert is shown. The user can press the button in the alert to try again.
6. If the user clicks the image card, the image that it contains will expand, and the user will transition to the individual image screen (see the "Viewing an image in full screen" section).
7. If the user presses the profile icon, they can go to the profile screen.
8. The user can switch between the image feed and profile screen using the tab bar.

## Viewing an image in full screen

The user can view individual images in full-screen mode and share them.

**The screen contains:**

1. The image expanded to take up the whole screen.
2. A button to go back to the previous screen.
3. A button that allows the user to share the image or perform other system actions.

**Logic and available actions:**

1. When the user enters full-screen mode, the image expands to take up the whole screen and is aligned in the center.
    1. If the image cannot be loaded and displayed, a placeholder is shown in its place.
    2. If no response is received, an error alert is displayed.
2. The user can return to the image feed screen by pressing the back button.
3. Gestures can be used to pan the expanded image or zoom in/out.
4. When the share button is pressed, a system menu comes up that allows the user to share the image or perform other standard system actions with it.
    1. The menu is hidden after performing the action.
    2. The user can swipe down or press the "x" icon to dismiss the menu.

## Viewing the user profile

The user can switch to their profile tab to view their profile details or sign out.

**The profile screen contains:**

1. The profile details
    1. Profile picture
    2. Name
    3. Username
    4. Bio
2. Logout button
3. Tab bar

**Logic and available actions:**

1. The profile details are loaded from the Unsplash profile. They cannot be edited in the app.
    1. If the profile data could not be loaded, a placeholder is displayed instead of the profile picture while the name and username are not shown.
2. The user can sign out of their account by pressing the logout button. Upon pressing the button, a system alert asking for the user's confirmation is shown.
    1. If the user clicks "Yes", they are logged out and redirected back to the authorization screen.
    2. If the user clicks "No", they return to the profile screen.
3. The user can switch between the image feed and profile screens using the tab bar.
