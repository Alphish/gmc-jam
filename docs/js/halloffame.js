import { createParticipantLink } from "./common.js";

function hallPopulate(trophies) {
    let tableEntries = document.getElementById("hof-participants");
    let lastRank = 0;
    for (let i = 0; i < trophies.length; i++) {
        let trophyStats = trophies[i];
        let matchesPrevious = i > 0 ? trophiesMatch(trophies[i - 1], trophyStats) : false;
        let rank = matchesPrevious ? lastRank : i + 1;
        lastRank = rank;

        if (i == 0)
            insertSeparator(tableEntries, "🥇 Gold Medal Winners");
        else if (trophies[i][2] === 0 && trophies[i - 1][2] > 0)
            insertSeparator(tableEntries, "🥈 Silver Medal Winners");
        else if (trophies[i][2] === 0 && trophies[i][3] === 0 && trophies[i - 1][3] > 0)
            insertSeparator(tableEntries, "🥉 Bronze Medal Winners");
        else if (trophies[i][2] === 0 && trophies[i][3] === 0 && trophies[i][4] === 0 && trophies[i - 1][4] > 0)
            insertSeparator(tableEntries, '📜 "Best of" Award Winners');

        let row = tableEntries.insertRow();
        row.innerHTML = 
            `<td class="hof-rank">${rank}</td>` +
            `<td class="hof-participant">${createParticipantLink(trophyStats[0], trophyStats[1])}</td>` +
            trophyCountCell(`hof-wins`, trophyStats[2]) +
            trophyCountCell(`hof-2nds`, trophyStats[3]) +
            trophyCountCell(`hof-3rds`, trophyStats[4]) +
            trophyCountCell(`hof-awards`, trophyStats[5]);
    }
}

function trophiesMatch(previous, next) {
    return previous != undefined && previous[2] === next[2] && previous[3] === next[3] && previous[4] === next[4] && previous[5] === next[5];
}

function insertSeparator(tableEntries, content) {
    let separator = tableEntries.insertRow();
    separator.innerHTML = `<td class="hof-separator" colspan="6">${content}</td>`;
}

function trophyCountCell(className, count) {
    if (count === 0)
        className += " zero-value";

    return `<td class="${className}">${count}</td>`;
}

// -----
// Setup
// -----

fetch("/jams/trophies.json")
    .then(response => {
        if (response.ok)
            return response.json();
        else
            throw new Error(`Could not retrieve trophies data.`);
    })
    .then(trophies => hallPopulate(trophies))
    .catch(error => {
        console.error(error);
    });
