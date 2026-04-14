import { getOrdinal, addOverviewEntry, createPageList, createJamLink, createParticipantLink, showId } from "./common.js";

function entryviewPopulate(entry, jamFolder) {
    document.title = entry.title + " | GMC Jam";

    let titleElement = document.getElementById("jam-title");
    titleElement.textContent = entry.title;

    let thumbnailElement = document.getElementById("entry-thumbnail");
    thumbnailElement.src = entry.thumbnailPath ? jamFolder + entry.thumbnailPath : "/jamlogo.png";
    thumbnailElement.style.visibility = "visible";

    entryviewPopulateOverview(entry);

    showId("pending");
}

// --------
// Overview
// --------

function entryviewPopulateOverview(entry) {
    let overviewEntries = document.getElementById("overview-entries");
    if (entry.team)
        addOverviewEntry(overviewEntries, "Team", entry.team);

    let authorElements = entry.authors.map(authorData => createParticipantLink(authorData[0], authorData[1]));
    addOverviewEntry(overviewEntries, authorElements.length > 1 ? "Authors" : "Author", authorElements.join(", "));

    addOverviewEntry(overviewEntries, "Jam", createJamLink(entry.jam[0], entry.jam[1]));

    if (entry.rank)
        addOverviewEntry(overviewEntries, "Rank", getRankDescription(entry.rank));

    if (entry.awards) {
        let awardsRows = entry.awards.map(award => "🏆 " + award[1]);
        addOverviewEntry(overviewEntries, "Awards", awardsRows.join("<br/>"));
    }

    if (entry.links)
        addOverviewEntry(overviewEntries, "Links", createPageList(entry.links));
}

function getRankDescription(rank) {
    if (rank == 1)
        return "🥇 1st";
    else if (rank == 2)
        return "🥈 2nd";
    else if (rank == 3)
        return "🥉 3rd";
    else
        return getOrdinal(rank);
}

// -----
// Setup
// -----

let urlSearch = new URLSearchParams(window.location.search);
let jamId = urlSearch.get("jam");
let entryId = urlSearch.get("entry");

if (!jamId || !entryId) {
    document.title = "Unknown Entry | GMC Jam";
} else {
    let jamFolder = "/jams/" + encodeURIComponent(jamId) + "/";
    let entryFilename = encodeURIComponent(entryId) + ".entry.json";
    fetch(jamFolder + "/" + entryFilename)
        .then(response => {
            if (response.ok)
                return response.json();
            else
                throw new Error(`Could not retrieve entry data of '${entryId}' in the '${jamId}' jam.`);
        })
        .then(entry => entryviewPopulate(entry, jamFolder))
        .catch(error => {
            document.title = "Unknown Entry | GMC Jam";
            console.error(error);
        });
}
