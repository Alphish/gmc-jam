fetch("/jams/jamlist.json")
    .then(response => response.json())
    .then(jamlist => {
        let tableEntries = document.getElementById("jamlist-entries");
        for (let jam of jamlist) {
            let row = tableEntries.insertRow();
            row.innerHTML = 
                `<td class="jam-title"><a href="/jamview.html?id=${jam.id}">${jam.title}</a></td>` +
                `<td class="jam-theme">${jam.theme}</td>` +
                `<td class="jam-date">${jam.date}</td>` +
                `<td class="jam-hosts">${jam.hosts}</td>`;
        }
    });
