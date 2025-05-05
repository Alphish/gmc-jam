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
        .then(jam => {
            document.title = jam.title + " | GMC Jam";
            
            let titleElement = document.getElementById("jamtitle");
            titleElement.textContent = jam.title;

            if (jam.logoPath) {
                let logoElement = document.getElementById("jam-logo");
                logoElement.src = jamFolder + jam.logoPath;
            }

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

            let viewElement = document.getElementById("pending");
            viewElement.style.visibility = "visible";
        })
        .catch(error => {
            document.title = "Unknown Jam | GMC Jam";
            console.error(error);
        });
}
