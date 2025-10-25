plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Função para ler a API key do arquivo .env
fun getEnvVariable(name: String, defaultValue: String = ""): String {
    val envFile = file("../../.env")
    if (envFile.exists()) {
        val envContent = envFile.readText()
        val lines = envContent.split("\n")
        for (line in lines) {
            if (line.trim().startsWith("$name=")) {
                return line.substringAfter("=").trim()
            }
        }
    }
    return System.getenv(name) ?: defaultValue
}

android {
    namespace = "com.example.mapnavigatorapp"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.mapnavigatorapp"
        
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // Adicionar a API key como resource string
        resValue("string", "google_maps_api_key", getEnvVariable("GOOGLE_MAPS_API_KEY", ""))
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
