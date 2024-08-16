# Diarmuid's GTD App
GTD is a method of task management whereby you stratify tasks into what you need for completing them. This application is my implementation of that, providing a cross-platform interface for access to tasks. I've provided a Golang backend for efficient server access and flutter for mobile and desktop apps.

## Key Features

- User authentication and different profiles
- Task creation and management
- Simple and intuitive interface
- Cross-platform support

## Running the Application

### Client

Go into the runnables section and download the compiled version for your system and run it.

If you can't find anything for your version it's okay no worries.
  1. Ensure you've got flutter installed
     - https://radixweb.com/blog/install-flutter-on-windows-mac-and-android
     - https://docs.flutter.dev/get-started/install/linux/android
  2. Build for your device
     - https://docs.codemagic.io/flutter-configuration/flutter-projects/
  3. You should be able to run your files if you can find it in the output folders of the project.
     - https://medium.com/@chetan.akarte/how-to-get-apk-and-ipa-files-from-flutter-af2f7af1220f


### Backend 
I've provided a globally accessible server for this project, but if you want to create your own local version here's the process.


1. Make sure you have Go and Git installed on your system.
   - https://go.dev/doc/install
   - https://github.com/git-guides/install-git
2. Clone the Repository
   - git clone https://github.com/DiarmuidMalanaphy/Task-Manager
3. Navigate to the server directory.
   - cd Task-Manager/server
4. Run the Go-Server
   - go run .

The program should run and show you your public and local IP addresses. You can connect over either of these. If you want to use the global IP address over the internet you will have to open your ports. 

If you want the application to connect to your server over mine you will have to modify the IP setting in the splash page of the app.
![OnPaste 20240816-023416](https://github.com/user-attachments/assets/323f479a-d0bb-4722-8c97-732233ca8a0c)


