allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

// --- PERBAIKAN UNTUK ERROR "DIFFERENT ROOTS" (DRIVE C vs D) ---
// Kode di bawah ini akan mematikan Unit Test di semua module Android
// agar Gradle tidak bingung menghubungkan file cache (C:) dengan project (D:)

subprojects {
    afterEvaluate {
        // Cek apakah module ini adalah module Android
        if (extensions.findByName("android") != null) {
            try {
                // Konfigurasi untuk mematikan unit tests
                configure<com.android.build.gradle.BaseExtension> {
                    testOptions {
                        unitTests.all {
                            isEnabled = false
                        }
                    }
                }
            } catch (e: Exception) {
                // Abaikan jika ada error konfigurasi minor
            }
        }
    }
}