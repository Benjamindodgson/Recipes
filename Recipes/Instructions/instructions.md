# Project Requirements Document: Recipes iOS App

## 1. Project Overview
The **Recipes** iOS application is a SwiftUI-based project that fetches a list of recipes from a remote API, displays them in a vertical list, and downloads images only on demand. To optimize bandwidth, images are cached using SwiftData. Additionally, the app should include unit tests demonstrating my testing approach for critical logic (e.g., data fetching and caching).

### Goals
- Demonstrate modern iOS development best practices using **SwiftUI** and **async/await**.
- Show how to fetch and display a list of items from a **remote API**.
- Implement **manual disk-based image caching** without external dependencies.
- Provide **unit tests** for data fetching and caching logic.

### Tech Stack & Dependencies
- **Language:** Swift (minimum iOS target: iOS 18 or above, depending on your team’s constraints).
- **UI Framework:** SwiftUI.
- **Asynchronous Programming:** Swift Concurrency (`async/await`) and Swift 6 strict concurrency.
- **Networking:** URLSession (no third-party wrappers).
- **Caching:** SwiftData
- **Testing:** Swift Testing

---

## 2. Features

1. **Fetch & Display Recipes**  
   - **Description:** The app fetches recipe data from a remote endpoint and displays them in a scrollable vertical list.
   - **Goal:** Users can see a list of recipes with relevant information (recipe name, cuisine, etc.).

2. **On-Demand Image Loading**  
   - **Description:** The app loads and displays recipe images only when a recipe cell is visible or needed in the UI.
   - **Goal:** Conserve bandwidth by not loading images until they are actually displayed.

3. **Manual Disk Caching for Images**  
   - **Description:** Downloaded images must be written to disk to avoid repeated network requests and preserve bandwidth.
   - **Goal:** If the user scrolls away and back, or if they close and reopen the app, images should load from disk without re-fetching from the network.

4. **Unit Testing**  
   - **Description:** Provide tests for core logic such as fetching recipes, handling malformed or empty data, and loading/caching images.
   - **Goal:** Demonstrate testing best practices and maintain confidence in the critical parts of the app’s logic.

---

## 3. Requirements

### 3.1 Fetch & Display Recipes
- **API Endpoint**: `https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json`
- **Data Fetching**:
  - Must use `URLSession` with `async/await`.
  - If the data is malformed, the app should show an error state.
  - If the data is empty, the app should show an empty list message (e.g., “No Recipes Found”).
- **UI**:
  - A `LazyVStack` in SwiftUI to display recipes vertically.
  - Each list row should display:
    - **Name** (e.g., “Grilled Cheese Sandwich”)
    - **Cuisine** (e.g., “American”)
    - **Small Photo** (on-demand)
- **Error Handling**:
  - If an error occurs during fetch, display a user-friendly error message or fallback UI.

### 3.2 On-Demand Image Loading
- **Implementation**:
  - Use an `ImageCache` or similar class to handle loading, caching, and returning the image.
  - Do **not** rely on automatic caching from `URLSession`.
  - Only initiate the download when the SwiftUI view is about to display the image.
- **Swift Concurrency**:
  - The image loading function (e.g., `fetchImage(for url: URL) async throws -> Image`) should use `async/await`.

### 3.3 Manual Disk Caching for Images
- **Location**:
  - Store recipes using SwiftData.
- **Logic**:
  1. Check in-memory cache (if implemented).
  2. Check disk cache for a previously stored file matching the image’s URL-based identifier.
  3. If cached, load from disk.
  4. If not cached, download via `URLSession`, then write to disk.
  5. Return the `Image`.

### 3.4 Unit Testing
- **Core Logic to Test**:
  1. **Data Fetching**: Ensure valid JSON decodes correctly. Malformed JSON or network errors produce the right error states.
  2. **Image Caching**:
     - Verify that an uncached image is downloaded and written to disk.
     - Confirm that subsequent requests load the image from disk instead of the network.
  3. **ViewModel Logic** (optional, but recommended):
     - Test that the view model updates states correctly (`loading`, `recipes`, `errorMessage`).
- **Tools**: 
  - Use built-in `Swift Testing`.
  - Implement mocks or sample JSON data to simulate network responses.

---

## 4. Data Model

### `Recipe` Struct
```swift
struct Recipe: Codable, Identifiable {
    let cuisine: String
    let name: String
    let photoURLLarge: String?
    let photoURLSmall: String?
    let uuid: String
    let sourceURL: String?
    let youtubeURL: String?

    var id: String { uuid }

    enum CodingKeys: String, CodingKey {
        case cuisine
        case name
        case photoURLLarge = "photo_url_large"
        case photoURLSmall = "photo_url_small"
        case uuid
        case sourceURL = "source_url"
        case youtubeURL = "youtube_url"
    }
}