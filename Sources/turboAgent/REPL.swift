import Foundation

/// Интерактивный цикл: приглашение, чтение строки, ответ.
/// Пока эхо — на этапе 3 сюда приедет транскрипт и обращения к модели.
struct REPL {
    let workingDirectory: URL

    func run() {
        printBanner()

        loop: while true {
            printPrompt()

            guard let line = readLine() else {
                // nil == EOF: Ctrl+D, либо ввод пришёл из пайпа и кончился
                print()
                break
            }

            let input = line.trimmingCharacters(in: .whitespacesAndNewlines)
            if input.isEmpty { continue }

            if input.hasPrefix("/") {
                switch handle(command: input) {
                case .handled: continue
                case .exit: break loop
                }
            }

            print("you: \(input)")
        }

        print("\(Style.dim)пока\(Style.reset)")
    }

    // MARK: - Команды

    private enum CommandResult {
        case handled
        case exit
    }

    private func handle(command: String) -> CommandResult {
        switch command {
        case "/exit", "/quit":
            return .exit
        case "/help":
            printHelp()
            return .handled
        default:
            print("\(Style.warn)неизвестная команда \(command)\(Style.reset) — /help покажет список")
            return .handled
        }
    }

    // MARK: - Вывод

    private func printBanner() {
        let path = workingDirectory.path(percentEncoded: false)
        print("\(Style.accent)turboAgent\(Style.reset) \(Style.dim)·\(Style.reset) \(path)")
        print("\(Style.dim)/help — команды, /exit или Ctrl+D — выход\(Style.reset)")
    }

    private func printPrompt() {
        print("\(Style.accent)> \(Style.reset)", terminator: "")
        fflush(stdout)
    }

    private func printHelp() {
        print("""
        \(Style.dim)/help\(Style.reset)   список команд
        \(Style.dim)/exit\(Style.reset)   выход (также /quit или Ctrl+D)
        """)
    }
}

/// ANSI-последовательности для раскраски.
/// Если stdout не терминал (пайп, редирект в файл) — все коды пустые,
/// иначе управляющие символы попадут в файл мусором.
enum Style {
    private static let isTTY = isatty(fileno(stdout)) == 1

    static var reset: String { isTTY ? "\u{1B}[0m" : "" }
    static var dim: String { isTTY ? "\u{1B}[2m" : "" }
    static var accent: String { isTTY ? "\u{1B}[36m" : "" }
    static var warn: String { isTTY ? "\u{1B}[33m" : "" }
}
