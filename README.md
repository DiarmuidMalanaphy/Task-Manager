# Diarmuid's GTD App

This application is my implementation of the Getting Things Done (GTD) method, a task management system that helps you organize and prioritize tasks based on what you need to complete them. This application employs a client server model combined with a cloud service for access anywhere across different devices.
| ![Image 1](https://github.com/user-attachments/assets/6e0c2507-7381-4475-a968-4f5fdaa2da37) | ![Image 2](https://github.com/user-attachments/assets/d8ceb144-fd29-4e37-a0ba-2ad425e12381) |
|:---:|:---:|
| **Splash Page** | **Task list page** |

**There are different, animated themes available**






## Key Features
- Cloud-based for constant availability
- User authentication with support for multiple profiles
- Comprehensive task creation and management
- Intuitive and user-friendly interface
- Cross-platform support (mobile, desktop, and web)

## Key Technologies
- Protocol Buffers (Protobuf) for efficient data serialization
- Flutter for cross-platform development
- User Tokens for secure authentication
- Golang for robust backend services

## Running the Application

### Client

#### Pre-compiled Versions
Check the `runnables` section for a pre-compiled version compatible with your system. If available, download and run it directly.

#### Building from Source
If a pre-compiled version isn't available for your system, follow these steps:
   - As of right now there is only versions available for Linux and Android due to Windows and MacOS requiring a device with their respective OS to build -> for simplicities sake you can just compile to web.

1. Install Flutter:
   - [Windows/Mac installation guide](https://radixweb.com/blog/install-flutter-on-windows-mac-and-android)
   - [Linux/Android installation guide](https://docs.flutter.dev/get-started/install/linux/android)

2. Build for your target device:
   - Follow the [Codemagic guide](https://docs.codemagic.io/flutter-configuration/flutter-projects/) for your specific platform

3. Locate and run the built application:
   - Refer to this [guide on finding APK and IPA files](https://medium.com/@chetan.akarte/how-to-get-apk-and-ipa-files-from-flutter-af2f7af1220f) in your project's output folders

### Backend 

Whilst a globally accessible server is already provided, you can set up your own local version:

1. Install prerequisites:
   - [Go installation guide](https://go.dev/doc/install)
   - [Git installation guide](https://github.com/git-guides/install-git).
  
2. Clone the Repository
   - ```bash
     git clone https://github.com/DiarmuidMalanaphy/Task-Manager
3. Navigate to the server directory.
   - ```bash
     cd Task-Manager/server
4. Run the Go-Server
   - ```bash
     go run .

The program should run and show you your public and local IP addresses. You can connect over either of these. If you want to use the global IP address over the internet you will have to open your ports. 

If you want the application to connect to your server over mine you will have to modify the IP setting in the splash page of the app.
![OnPaste 20240816-023416](https://github.com/user-attachments/assets/323f479a-d0bb-4722-8c97-732233ca8a0c)
You can then just type the address you want to connect to in the text section and it should automatically connect to your server.
![image](https://github.com/user-attachments/assets/a26f61b8-4dda-4dae-8750-29ff0b4ee447)



