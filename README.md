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
- Using a CaheLoader to deal with the download of images
- Use a LocalStore (CoreData) to cache and/or persist the results of remote calls instead of storing them in memory
- improve the UI of the app 
