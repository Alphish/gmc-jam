import { getOrdinal, addOverviewEntry, createJamLink, createEntryLink, createParticipantLink } from "./common.js";

function participantviewPopulate(participant, participantsFolder) {
    document.title = participant.name + " | GMC Jam";

    let titleElement = document.getElementById("participant-name");
    titleElement.textContent = participant.name;

    if (participant.thumbnailPath) {
        let thumbnailElement = document.getElementById("participant-thumbnail");
        thumbnailElement.src = participantsFolder + participant.thumbnailPath;
    }

    participantviewPopulateOverview(participant);
    participantviewPopulateEntries(participant.entries);
    
    let viewElement = document.getElementById("pending");
    viewElement.style.visibility = "visible";
}

// --------
// Overview
// --------

function participantviewPopulateOverview(participant) {
    let overviewEntries = document.getElementById("overview-entries");

    /* [0] - jam ID, [1] - jam title, [2] - entry ID, [3] - entry title, [4] - team, [5] - rank, [6]? - awards */
    let entries = participant.entries;
    let actualEntries = entries.filter(entry => !!entry[2]);
    let totalCount = actualEntries.length;
    addOverviewEntry(overviewEntries, "Total entries", totalCount);

    if (totalCount > 0) {
        let firstCount = actualEntries.filter(entry => entry[5] == 1).length;
        let secondCount = actualEntries.filter(entry => entry[5] == 2).length;
        let thirdCount = actualEntries.filter(entry => entry[5] == 3).length;
        if (firstCount + secondCount + thirdCount == 0) {
            let bestRank = actualEntries.reduce((previous, current) => Math.min(previous, current[5]), actualEntries[0][5]);
            addOverviewEntry(overviewEntries, "Best rank", getOrdinal(bestRank));
        } else {
            let entries = [];
            if (firstCount > 0)
                entries.push(`🥇 <b>x${firstCount}</b>`);
            if (secondCount > 0)
                entries.push(`🥈 <b>x${secondCount}</b>`);
            if (thirdCount > 0)
                entries.push(`🥉 <b>x${thirdCount}</b>`);

            addOverviewEntry(overviewEntries, "Medals", entries.join('<br>'));
        }
    }

    let awardsCount = entries.reduce((previous, current) => previous + (current[6]?.length ?? 0), 0);
    if (awardsCount > 0)
        addOverviewEntry(overviewEntries, "Awards", `🏆 <b>x${awardsCount}</b>`);

    if (participant.links) {
        let linkRows = participant.links.map(link => `<a href="${link.url}" target="_blank">${link.title}</a>`);
        addOverviewEntry(overviewEntries, participant.links.length > 1 ? "Pages" : "Page", linkRows.join("<br/>"));
    }
}

// -------
// Entries
// -------

function participantviewPopulateEntries(entriesData) {
    let entries = entriesData.map(participantviewUnwrapEntry);
    let entriesTable = document.getElementById("all-entries");
    let oddRow = true;
    for (let entry of entries) {
        jamviewMakeEntryRow(entriesTable, entry, oddRow);
        oddRow = !oddRow;
    }
}

function participantviewUnwrapEntry(entryData) {
    let hasTeamName = typeof(entryData[4][0]) === "string";
    let teamName = hasTeamName ? entryData[4][0] : undefined;
    let authorsData = hasTeamName ? entryData[4].slice(1) : entryData[4];
    let authors = authorsData.map(authorData => {
        return { id: authorData[0], name: authorData[1] };
    });
    let awards = entryData.length >= 7
        ? entryData[6].map(awardData => ({ id: awardData[0], name: awardData[1] }))
        : [];
    
    return {
        jamId: entryData[0], jamTitle: entryData[1],
        id: entryData[2], title: entryData[3], teamName: teamName, authors: authors,
        rank: entryData[5], awards: awards,
    };
}

function jamviewMakeEntryRow(tbody, entry, oddRow) {
    let row = tbody.insertRow();
    row.className = oddRow ? 'spanning-odd' : 'spanning-even';
    if (entry.rank == 1)
        row.className += ' rank-1st';
    else if (entry.rank == 2)
        row.className += ' rank-2nd';
    else if (entry.rank == 3)
        row.className += ' rank-3rd';

    let authors = entry.authors.map(author => createParticipantLink(author.id, author.name)).join(', ');
    let team = entry.teamName ? `${entry.teamName} (${authors})` : authors;

    let jamCell = createJamLink(entry.jamId, entry.jamTitle);
    let entryCell = createEntryLink(entry.jamId, entry.id, entry.title);
    let rankCell = `<b>${getOrdinal(entry.rank)}</b>`;
    let awardsCell = entry.awards.map(award => `🏆 ${award.name}`).join('<br>');
    row.innerHTML = `<td>${jamCell}</td><td>${entryCell}</td><td>${team}</td><td>${rankCell}</td><td>${awardsCell}</td>`;
}

// -----
// Setup
// -----

let urlSearch = new URLSearchParams(window.location.search);
let participantId = urlSearch.get("id");

if (!participantId) {
    document.title = "Unknown Entry | GMC Jam";
} else {
    let participantsFolder = "/participants/";
    let participantFilename = encodeURIComponent(participantId) + ".participant.json";
    fetch(participantsFolder + participantFilename)
        .then(response => {
            if (response.ok)
                return response.json();
            else
                throw new Error(`Could not retrieve participant data of '${participantId}'.`);
        })
        .then(participant => participantviewPopulate(participant, participantsFolder))
        .catch(error => {
            document.title = "Unknown Entry | GMC Jam";
            console.error(error);
        });
}
