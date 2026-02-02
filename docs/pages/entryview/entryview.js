function entryviewPopulate(entry, jamFolder) {
    document.title = entry.title + " | GMC Jam";

    let titleElement = document.getElementById("jam-title");
    titleElement.textContent = entry.title;

    if (entry.thumbnailPath) {
        let thumbnailElement = document.getElementById("entry-thumbnail");
        thumbnailElement.src = jamFolder + entry.thumbnailPath;
    }

    entryviewPopulateOverview(entry);

    let viewElement = document.getElementById("pending");
    viewElement.style.visibility = "visible";
}

// --------
// Overview
// --------

function entryviewPopulateOverview(entry) {
    let overviewEntries = document.getElementById("overview-entries");
    let addOverviewEntry = function(label, value) {
        let row = overviewEntries.insertRow();
        row.innerHTML = 
            `<td class="overview-label">${label}:</td>` +
            `<td class="overview-value">${value}</td>`;
    }

    if (entry.team)
        addOverviewEntry("Team", entry.team);

    if (entry.authors) {
        let authorElements = entry.authors.map(authorData => {
            return `${authorData[1]}`;
        });
        addOverviewEntry(authorElements.length > 1 ? "Authors" : "Author", authorElements.join(", "));
    }

    if (entry.jam) {
        let jamLink = `<a href="/jamview.html?id=${entry.jam[0]}">${entry.jam[1]}</a>`;
        addOverviewEntry("Jam", jamLink);
    }

    if (entry.rank) {
        addOverviewEntry("Rank", getRankDescription(entry.rank));
    }

    if (entry.awards) {
        let awardsRows = entry.awards.map(award => "🏆 " + award[1]);
        addOverviewEntry("Awards", awardsRows.join("<br/>"));
    }

    if (entry.links) {
        let linkRows = entry.links.map(link => `<a href="${link.url}" target="_blank">${link.title}</a>`);
        addOverviewEntry("Links", linkRows.join("<br/>"));
    }
}

function getRankDescription(rank) {
    if (rank == 1)
        return "🥇 1st";
    else if (rank == 2)
        return "🥈 2nd";
    else if (rank == 3)
        return "🥉 3rd";

    let mod10 = rank % 10;
    let mod100 = rank % 100;
    if (mod100 >= 11 && mod100 <= 20)
        return `${rank}th`;
    else if (mod10 == 1)
        return `${rank}st`;
    else if (mod10 == 2)
        return `${rank}nd`;
    else if (mod10 == 3)
        return `${rank}rd`;
    else
        return `${rank}th`;
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
