function jamviewPopulate(jam, jamFolder) {
    document.title = jam.title + " | GMC Jam";
    
    let titleElement = document.getElementById("jamtitle");
    titleElement.textContent = jam.title;

    if (jam.logoPath) {
        let logoElement = document.getElementById("jam-logo");
        logoElement.src = jamFolder + jam.logoPath;
    }

    jamviewPopulateOverview(jam);

    if (jam.entries) {
        document.getElementById("no-entries").remove();
        jamviewPopulateEntries(jam);
    }

    let viewElement = document.getElementById("pending");
    viewElement.style.visibility = "visible";
}

// --------
// Overview
// --------

function jamviewPopulateOverview(jam) {
    let overviewEntries = document.getElementById("overview-entries");
    let addOverviewEntry = function(label, value) {
        let row = overviewEntries.insertRow();
        row.innerHTML = 
            `<td class="overview-label">${label}:</td>` +
            `<td class="overview-value">${value}</td>`;
    }

    if (jam.startTime) {
        let from = new Date(jam.startTime);
        let fromText = from.getDate().toString().padStart(2, "0") + "/" + (from.getMonth() + 1).toString().padStart(2, "0") + "/" + (from.getFullYear() % 100);
        let to = new Date(jam.endTime);
        let toText = to.getDate().toString().padStart(2, "0") + "/" + (to.getMonth() + 1).toString().padStart(2, "0") + "/" + (to.getFullYear() % 100);
        addOverviewEntry("Timeframe", `${fromText} - ${toText}`);
    }
    
    if (jam.theme)
        addOverviewEntry("Theme", jam.theme);

    if (jam.hosts)
        addOverviewEntry(jam.hosts.length > 1 ? "Hosts" : "Host", jam.hosts.join(", "));

    if (jam.links) {
        for (let link of jam.links) {
            let linkRow = overviewEntries.insertRow();
            linkRow.innerHTML = `<td colspan="2" class="overview-link"><a href="${link.url}" target="_blank">${link.title}</a></td>`;
        }
    }
}

// -------
// Entries
// -------

function jamviewPopulateEntries(jam) {
    let entries = jam.entries.map(jamviewUnwrapEntry);
    let entriesById = {};
    for (let entry of entries) {
        entriesById[entry.id] = entry;
    }

    if (!jam.results) {
        let entriesTable = document.getElementById("all-entries");
        let oddRow = true;
        for (let entry of entries) {
            jamviewMakeEntriesRow(entriesTable, "", entry, oddRow);
            oddRow = !oddRow;
        }
        return;
    }

    document.getElementById("unrank-entries").remove();
    let rankingEntries = jam.results.ranking.map(entryId => entriesById[entryId]);

    let top3Table = document.getElementById("top3-entries");
    jamviewMakeEntriesRow(top3Table, "🥇", rankingEntries[0], true);
    jamviewMakeEntriesRow(top3Table, "🥈", rankingEntries[1], false);
    jamviewMakeEntriesRow(top3Table, "🥉", rankingEntries[2], true);

    let rankingTable = document.getElementById("ranking-entries");
    let rank = 1;
    for (let entry of rankingEntries) {
        jamviewMakeEntriesRow(rankingTable, getOrdinal(rank++), entry, rank % 2 == 1);
    }

    let awardEntries = jam.results.awards.map(awardData => jamviewUnwrapAward(awardData, entriesById));
    let awardTable = document.getElementById("awards-entries");
    let oddRow = true;
    for (let award of awardEntries) {
        jamviewMakeEntriesRow(awardTable, "🏆 " + award.name, award.winners, oddRow);
        oddRow = !oddRow;
    }
}

function jamviewUnwrapEntry(entryData) {
    let hasTeamName = typeof(entryData[2][0]) === "string";
    let teamName = hasTeamName ? entryData[2][0] : undefined;
    let authorsData = hasTeamName ? entryData[2].slice(1) : entryData[2];
    let authors = authorsData.map(authorData => {
        return { id: authorData[0], name: authorData[1] };
    });
    return { id: entryData[0], title: entryData[1], teamName: teamName, authors: authors };
}

function jamviewUnwrapAward(awardData, entriesById) {
    let awardedEntity = awardData[3] ?? 'entry';
    let winners;
    if (awardedEntity === 'entry') {
        winners = awardData[2].map(entryId => entriesById[entryId]);
    } else {
        winners = awardData[2].map(participant => ({ id: participant.id, title: participant.name, authors: []}));
    }
    return { id: awardData[0], name: awardData[1], winners: winners };
}

function jamviewMakeEntriesRow(tbody, label, entries, oddRow) {
    if (!Array.isArray(entries)) {
        entries = [entries];
    }

    let firstRow = true;
    for (let entry of entries) {
        let row = tbody.insertRow();
        row.className = oddRow ? 'spanning-odd' : 'spanning-even';
        let authors = entry.authors.map(author => `${author.name}`).join(", ");
        let team = entry.teamName ? `${entry.teamName} (${authors})` : authors;

        let firstCell = firstRow && label !== '' ? `<td class="entry-label-column" rowspan="${entries.length}">${label}</td>` : ``;
        row.innerHTML = `${firstCell}<td>${entry.title}</td><td>${team}</td>`;

        firstRow = false;
    }
}

function getOrdinal(rank) {
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
let jamId =  urlSearch.get("id");

if (!jamId) {
    document.title = "Unknown Jam | GMC Jam";
} else {
    let jamFolder = "/jams/" + encodeURIComponent(jamId) + "/";
    fetch(jamFolder + "/jaminfo.json")
        .then(response => {
            if (response.ok)
                return response.json();
            else
                throw new Error(`Could not retrieve jam data of '${jamId}'.`);
        })
        .then(jam => jamviewPopulate(jam, jamFolder))
        .catch(error => {
            document.title = "Unknown Jam | GMC Jam";
            console.error(error);
        });
}
