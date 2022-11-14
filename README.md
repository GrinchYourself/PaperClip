# PaperClip Application
## Technical test

- MVVM-Coordinator architecture
- Swift 5.7, UIKit, Combine
- Use of SPM, packages as follows:
    - *Domain*: defines the interfaces between other modules and the app
    - *RemoteStore*: manages the remote requests
    - *Repository*: manages the interfaces between the remote stores and the ViewModels of the different screens
- Unit tests created for:
    -  Repository module
    - RemoteStore module
    - App
        - ViewModels
        - Helpers
## Could be improved
- Using a CacheLoader to deal with the download of images
- Using a LocalStore (CoreData) to cache and/or persist the results of remote calls instead of storing them in memory
- A finest management of the errors inside each module and for the ViewModels
- Improving the UI of the app
