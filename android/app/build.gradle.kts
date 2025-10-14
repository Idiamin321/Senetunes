plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")  // <-- bon ID Kotlin en Kotlin DSL
    // Le plugin Flutter DOIT être appliqué après Android & Kotlin
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.senetunes.senetunes"

    // Les valeurs flutter.compileSdkVersion etc. sont injectées par le plugin Flutter
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "26.1.10909125"

    compileOptions {
        // AGP 8.x recommande Java 17
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.senetunes.senetunes"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: configure ta signature release
            signingConfig = signingConfigs.getByName("debug")
            // minifyEnabled/proguard si nécessaire
        }
        debug {
            // options debug si besoin
        }
    }
}

flutter {
    source = "../.."
}
