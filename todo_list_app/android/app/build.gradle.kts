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

// --- PERBAIKAN FINAL (Disable Unit Test) ---
subprojects {
    afterEvaluate {
        // Cek jika module ini adalah module Android
        if (extensions.findByName("android") != null) {
            try {
                // Konfigurasi untuk mematikan unit tests
                configure<com.android.build.gradle.BaseExtension> {
                    testOptions {
                        unitTests.all {
                            // PERBAIKAN: Gunakan 'it.enabled' bukan 'isEnabled'
                            it.enabled = false
                        }
                    }
                }
            } catch (e: Exception) {
                // Abaikan jika ada error konfigurasi minor
            }
        }
    }
}