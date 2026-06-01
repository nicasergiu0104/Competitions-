package com.csee.competitions.common;

public class ScoreDto {
    private final String code;
    private final Double score;
    private final boolean winner;
    private final boolean mine;

    public ScoreDto(String code, Double score, boolean winner, boolean mine) {
        this.code = code;
        this.score = score;
        this.winner = winner;
        this.mine = mine;
    }

    public String getCode() { return code; }
    public Double getScore() { return score; }
    public boolean isWinner() { return winner; }
    public boolean isMine() { return mine; }
}