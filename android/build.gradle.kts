pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        file("local.properties").inputStream().use { properties.load(it) }
        properties.getProperty("flutter.sdk")
            ?: throw GradleException("flutter.sdk not set in local.properties")
    }

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
        maven { url = uri("$flutterSdkPath/packages/flutter_tools/gradle") }
    }

    plugins {
        id("dev.flutter.flutter-plugin-loader") version "1.0.0"
        id("com.android.application") version "8.2.0" apply false
        id("org.jetbrains.kotlin.android") version "2.1.0" apply false
    }
}

include(":app")
