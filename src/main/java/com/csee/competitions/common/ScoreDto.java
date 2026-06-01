package com.csee.competitions.common;

public class ScoreDto {
    private final Double score;
    private final boolean winner;

    public ScoreDto(Double score, boolean winner) {
        this.score = score;
        this.winner = winner;
    }

    public Double getScore() { return score; }
    public boolean isWinner() { return winner; }
}