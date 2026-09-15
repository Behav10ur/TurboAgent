import ArgumentParser
import Foundation

@main
struct TurboAgent: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "turboagent",
        abstract: "Локальный агент, работающий с файлами в текущей папке."
    )

    func run() async throws {
        let workingDirectory = URL(
            filePath: FileManager.default.currentDirectoryPath,
            directoryHint: .isDirectory
        )

        REPL(workingDirectory: workingDirectory).run()
    }
}
