class CountdownService {
    countdownOptions = undefined;
    timer = undefined;

    start(jamData) {
        let jamTitle = jamData.title;
        let jamStartTicks = Date.parse(jamData.startTime);
        let jamEndTicks = Date.parse(jamData.endTime);
        let initialNow = Date.now();

        if (initialNow < jamStartTicks) {
            this.beginPreJamCountdown(jamStartTicks, jamTitle);
        } else if (initialNow < jamEndTicks) {
            this.beginMidJamCountdown(jamEndTicks, jamTitle);
        } else {
            this.setCountdownText(jamTitle + " is finished!", "", "", "GMC Jam Home");
        }
    }

    // ---------------
    // Countdown setup
    // ---------------

    beginCountdown(options) {
        this.countdownOptions = options;
        this.processCountdown();
        this.timer = setInterval(() => this.processCountdown(), 1000);
    }

    beginPreJamCountdown(target, jamTitle) {
        this.beginCountdown({
            countdownTarget: target,
            progressSubtitle: " until Jam starts",
            progressCaption: jamTitle + " starts in...",
            progressFootnote: undefined,
            finishText: "Let's Jam!",
            finishTitle: "Let's Jam!",
            finishCaption: undefined,
            finishFootnote: undefined,
        });
    }

    beginMidJamCountdown(target, jamTitle) {
        this.beginCountdown({
            countdownTarget: target,
            progressSubtitle: " until Jam ends",
            progressCaption: jamTitle + " ends in...",
            progressFootnote: undefined,
            finishText: "Time's up!",
            finishTitle: "Time's up!",
            finishCaption: undefined,
            finishFootnote: "If you have yet to submit your entry, wrap it up as soon as you can and send it to the Jam hosts!<br>"
                + "Otherwise, please wait while the Jam ZIP is gathered...",
        });
    }

    // ---------------
    // Core processing
    // ---------------

    processCountdown() {
        let options = this.countdownOptions;

        let now = Date.now();
        let remainingTicks = options.countdownTarget - now;
        if (remainingTicks > 0) {
            let text = this.formatCountdown(remainingTicks);
            this.setCountdownText(options.progressCaption, text, options.progressFootnote, text + options.progressSubtitle);
        } else {
            this.setCountdownText(options.finishCaption, options.finishText, options.finishFootnote, options.finishTitle);
            if (!!this.timer)
                clearInterval(this.timer);
        }
    }

    formatCountdown(remainingTicks, showDays) {
        let ticksPerSecond = 1000;
        let ticksPerMinute = 60 * ticksPerSecond;
        let ticksPerHour = 60 * ticksPerMinute;
        let ticksPerDay = 24 * ticksPerHour;

        let remainingDays = Math.floor(remainingTicks / ticksPerDay);
        let remainingHours = Math.floor((remainingTicks % ticksPerDay) / ticksPerHour);
        let remainingMinutes = Math.floor((remainingTicks % ticksPerHour) / ticksPerMinute);
        let remainingSeconds = Math.floor((remainingTicks % ticksPerMinute) / ticksPerSecond);

        if (remainingTicks < ticksPerMinute) {
            let secondsText = remainingSeconds.toString()
            return remainingSeconds > 10 ? secondsText + "..." : secondsText + "!"; 
        } else if (remainingTicks < ticksPerDay) {
            return `${remainingHours}:${this.padTwoZero(remainingMinutes)}:${this.padTwoZero(remainingSeconds)}`;
        } else {
            return `${remainingDays}d ${remainingHours}h ${remainingMinutes}m ${remainingSeconds}s`;
        }
    }

    padTwoZero(value) {
        if (value >= 10)
            return value.toString();
        else
            return "0" + value.toString();
    }

    // -------------------
    // Elements management
    // -------------------

    setCountdownText(caption, text, footnote, title) {
        this.setElementContent("countdown-caption", caption);
        this.setElementContent("countdown-text", text);
        this.setElementContent("countdown-footnote", footnote);
        document.title = title;
    }

    setElementContent(elementId, content) {
        document.getElementById(elementId).innerHTML = content ?? "";
    }
}

// initialising the countdown
fetch("/jams/jamlist.json")
    .then(response => response.json())
    .then(jamlist => fetch("/jams/" + jamlist[0].filename + ".json"))
    .then(response => response.json())
    .then(jamData => {
        let countdown = new CountdownService();
        countdown.start(jamData);
    });
