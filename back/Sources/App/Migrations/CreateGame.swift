import Fluent

struct CreateGame: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("games")
            .id()
            .field("title", .string, .required)
            .field("min_players", .int, .required)
            .field("max_players", .int, .required)
            .field("duration_minutes", .int, .required)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("games").delete()
    }
}
