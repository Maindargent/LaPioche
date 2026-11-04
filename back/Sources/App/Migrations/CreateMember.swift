import Fluent

struct CreateMember: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("members")
            .id()
            .field("name", .string, .required)
            .field("email", .string, .required)
            .unique(on: "email")
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("members").delete()
    }
}
