export function getOrdinal(rank) {
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
// Links
// -----

export function createPageLink(url, title) {
    return `<a href="${url}" target="_blank">${title}</a>`;
}

export function createPageList(links) {
    let elements = links.map(link => createPageLink(link.url, link.title));
    return elements.join('<br>');
}

export function createJamLink(id, title) {
    return `<a href="/jamview.html?id=${id}">${id, title}</a>`;
}

export function createEntryLink(jamId, id, title) {
    return `<a href="/entryview.html?jam=${jamId}&entry=${id}">${title}</a>`;
}

export function createParticipantLink(id, name) {
    return `<a href="/participantview.html?id=${id}">${name}</a>`;
}

// --------
// Overview
// --------

export function addOverviewEntry(table, label, value) {
    let row = table.insertRow();
    row.innerHTML = 
        `<td class="overview-label">${label}:</td>` +
        `<td class="overview-value">${value}</td>`;
}
