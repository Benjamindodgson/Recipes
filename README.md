# Recipes

### Summary: Include screen shots or a video of your app highlighting its features
https://www.loom.com/share/b18da657ae1e405bab00d2960e5e23b8

### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?
I mostly focused on architecture by focusing of the 4 key areas
1. Performance
   - I focused on optimizing data fetching and display by utilizing Actors and @Observable state in my view models
   - Used Swift structured concurrency (async/await) to handle API requests efficiently AND confroming to Swift 6's strict concurrency
   - Planned to employ lazy loading (e.g., LazyVStack) to handle large numbers of recipes without impacting performance.
2. Code Quality
   - Ensured maintainable, clean code by following consistent naming conventions and avoiding force-unwraps.
   - Documented public types and functions to guide future contributors.
   - Added meaningful debug logs throughout the codebase to trace data flow and simplify troubleshooting.
3. Error Handling
   - Incorporated robust do-catch statements for every asynchronous operation to gracefully handle all possible failure cases.
   - Used Result types to return values and manage success or error scenarios clearly.
4. Testing
   - Used Swifts new Testing framework which was new for me and I quited enjoyed it
   - Covered all the relevant business logic cases which actually led to some refactoring in the Cacheing logic

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?
8-10 hours over 2 weeks. I was pretty busy and didnt have a ton of dedicated heads down time. 

My first goal was to get the overall file structure down and start stubbing things out. Then it was figuring out how I wanted to cache/display things. Lazy stacks are easy but I went down a little rabit hole with SwiftData and realized that wasnt appropriate for this. Maybe at scale where you want to do more than just show a photo quickly. But sometimes the simplest solution is the best, in this case a dictionary backed by protocol so if you wanted to switch it out in the future you could pretty easily.

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?
MVVM in SwiftUI certainly has is its pros and cons. But value vs reference types quickly become problemmatic, especially when supporting strict concurrency. This was evident in my use of Actors for my Services and at first trying to call them with in the body of a view. This isnt something I would typcially do, but given that the view was a reusable one, it didnt feel appropriate to have its view model. I find this awkwardness creep in often when dealing with MVVM in SwiftUI. It just doesnt always feel right.

### Weakest Part of the Project: What do you think is the weakest part of your project?
Theres one test that always fails on first run. Every subsequent run is fine. I spent about 30 mins trying to figure out why the mock sessions status code was getting over written but ultimately decided to move on.

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.
I 100% used AI to do this. I believe that the engineers that arent using it will be replaced by the ones that are. I used this project to try out some new tools and processes to better utilize AI in my development. 
