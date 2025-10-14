// Fichier racine pour les repositories subprojects, clean, etc.

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Place les dossiers build de tous les sous-projets sous /build (à la racine Flutter)
val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
    // s'assure que :app est évalué en premier
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
