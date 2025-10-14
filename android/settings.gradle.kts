import java.util.Properties
import java.io.FileInputStream

pluginManagement {
    repositories {
        // ordre recommandé
        gradlePluginPortal()
        google()
        mavenCentral()
    }

    // Déclare les versions des plugins
    plugins {
        id("com.android.application") version "8.4.1"
        id("org.jetbrains.kotlin.android") version "1.9.24"
        // Le loader Flutter doit être déclaré ici
        id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    }
}

// Localisation du SDK Flutter (pour charger le build des outils)
val localProperties = Properties().apply {
    val file = File(rootDir, "local.properties")
    if (file.exists()) {
        FileInputStream(file).use { load(it) }
    }
}
val flutterSdkPath = localProperties.getProperty("flutter.sdk")
    ?: System.getenv("FLUTTER_SDK")
    ?: throw GradleException("flutter.sdk not set in local.properties or FLUTTER_SDK env var")

// Permet à Gradle d’inclure le build des outils Flutter
includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

// Projets inclus
include(":app")
