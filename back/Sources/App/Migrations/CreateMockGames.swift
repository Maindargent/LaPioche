//
//  CreateMockGames.swift
//  LaPioche
//
//  Created by Apprenant 87 on 16/11/2026.
//

import Fluent

struct CreateMockGames: AsyncMigration {

    func prepare(on database: Database) async throws {
        let games = [
            Game(
                title: "Catan",
                minPlayers: 3,
                maxPlayers: 4,
                durationMinutes: 90,
            ),
            Game(
                title: "7 Wonders",
                minPlayers: 2,
                maxPlayers: 7,
                durationMinutes: 30,
            ),
            Game(
                title: "Azul",
                minPlayers: 2,
                maxPlayers: 4,
                durationMinutes: 45,
            ),
            Game(
                title: "Dixit",
                minPlayers: 3,
                maxPlayers: 8,
                durationMinutes: 30,
            ),
            Game(
                title: "Les Aventuriers du Rail",
                minPlayers: 2,
                maxPlayers: 5,
                durationMinutes: 60,
            )
        ]

        for game in games {
            try await game.save(on: database)
        }
    }

    func revert(on database: Database) async throws {
        try await Game.query(on: database)
            .filter(\.$title ~~ [
                "Catan",
                "7 Wonders",
                "Azul",
                "Dixit",
                "Les Aventuriers du Rail"
            ])
            .delete()
    }
}
