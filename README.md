# GitHub Repo Viewer

This application allows users to search for and view repositories from GitHub based on a given username. After entering the username, it lists the repositories belonging to that user, and the user can view repository details. Additionally, the app works offline by caching data.

## Features

- **User Search**: After entering a GitHub username, the app fetches and lists users and their repositories from the GitHub API.
- **Responsive Repo Listing**: Repositories can be displayed in 1, 2, or 3 columns. The user can change the number of columns using a segmented control in the app.
- **Pagination**: If there are many repositories, the app loads them page by page as the user scrolls down.
- **Data Caching**: Data fetched from GitHub is cached locally using the Realm database, allowing access even when offline.
- **Offline Support**: When there is no internet connection, the app loads the previously cached data.
- **Comprehensive Repo Details**: The app displays repository information, including name, owner, fork count, watch count, and size.
- **Image Caching with Kingfisher**: The profile images of repository owners are loaded and cached using the Kingfisher library.

## Technologies Used

- **Swift**: The application is developed in Swift.
- **Realm**: Used for local data storage and caching.
- **Alamofire**: Handles HTTP requests to the GitHub API.
- **Kingfisher**: Loads and caches profile images of repository owners.
- **SnapKit**: Simplifies AutoLayout constraints.
- **MVVM Architecture**: The application follows the MVVM (Model-View-ViewModel) architecture pattern.

## Installation

To run this application locally, follow the steps below:

1. **Clone the repository**:

    ```bash
    git clone https://github.com/username/repo.git
    cd repo
    ```

2. **Install dependencies**:

    The project uses CocoaPods to manage dependencies:

    ```bash
    pod install
    ```

    If you don’t have CocoaPods installed, install it by running:

    ```bash
    sudo gem install cocoapods
    ```

3. **Open the project**:

    ```bash
    open FordCase.xcworkspace
    ```

4. **Run the project**:

    You can build and run the project using Xcode on a simulator or a physical device.

## Usage

1. When the app opens, enter a GitHub username in the search field.
2. Once more than 3 characters are entered, the search will begin.
3. After selecting a user, the repositories owned by that user will be displayed.
4. Use the segmented control at the top of the screen to switch between 1, 2, or 3 column layouts.
5. For each repository, details such as the repository name, owner name, fork count, watcher count, and size are displayed.
6. The owner's profile images are loaded and cached using Kingfisher.

## File Structure

- `RepoListViewController.swift`: Manages the screen that displays the list of GitHub repositories.
- `RepoListViewModel.swift`: Manages API requests and data handling, passing data to the ViewController.
- `Repo.swift`: Realm database model and representation of the repository data from the GitHub API.
- `CustomRepoCell.swift`: Configures each UICollectionView cell for repositories.
- `NetworkManager.swift`: Handles HTTP requests using Alamofire.
- `APIEndpoint.swift`: Enum that configures the GitHub API endpoints.

## Caching and Offline Mode

The application caches data using the Realm database so that previously fetched data can be accessed when offline. When the user comes back online, the data will be automatically updated with new information from the GitHub API.

## API Usage and Rate Limiting

The application uses GitHub's public API. There are some limitations to the API:

- **Rate Limiting**: The GitHub API limits unauthenticated requests to 60 per hour. If this limit is exceeded, you will receive a 403 error. In this case, the app will display a message: "Request limit exceeded, please wait for a while."

The app manages rate limiting by checking the response headers from the API and informing the user when they have hit the limit.

## Contributing

If you'd like to contribute to the project:

1. Fork the repository.
2. Create a new branch: `git checkout -b my-feature`
3. Commit your changes: `git commit -m 'Add my feature'`
4. Push to the branch: `git push origin my-feature`
5. Open a pull request.
