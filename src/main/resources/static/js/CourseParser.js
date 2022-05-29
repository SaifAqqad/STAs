class CourseParser {
    isRunning = false;
    endpoint = "/courses";

    constructor(groupId, callback) {
        this.group = document.getElementById(groupId);
        this.input = this.group.querySelector("#courseParserInput");
        this.button = this.group.querySelector("#courseParserButton");
        this.feedback = this.group.querySelector("#courseParserFeedback");
        this.callback = callback;
        this.button.addEventListener("click", () => this.parse());
    }

    async parse() {
        if (this.isRunning)
            return;
        this.isRunning = true;
        // check if input is valid
        if (this.input.reportValidity()) {
            this.setValidity(true);
            this.setLoading(true);
            // fetch the course data
            const response = await fetch(this.endpoint + "?" + new URLSearchParams({
                url: this.input.value,
            }));
            this.setLoading(false);
            // check if response is valid
            if (response.ok) {
                const course = await response.json();
                // check for a courseParser error
                if (course.error) {
                    this.setValidity(false, course.error);
                } else {
                    // empty the url input and apply the course data
                    this.input.value = "";
                    this.callback({
                        name: course["name"],
                        description: course["description"],
                        imageUri: course["imageUrl"],
                        url: course["url"],
                        publisher: course["publisher"],
                    });
                }
            } else {
                this.setValidity(false, "An error has occurred");
            }
        } else {
            this.setValidity(false, "Please enter a valid URL");
            await _animateCSS(this.input, "headShake");
        }
        this.isRunning = false;
    }

    setValidity(validity, message = null) {
        if (validity) {
            this.input.classList.remove("is-invalid");
            this.feedback.innerText = "";
        } else {
            this.input.classList.add("is-invalid");
            this.feedback.innerText = message;
        }
    }

    setLoading(isLoading) {
        if (isLoading) {
            this.button.querySelector(".btn-spinner").classList.remove("d-none");
            this.button.querySelector(".btn-text").classList.add("d-none");
        } else {
            this.button.querySelector(".btn-spinner").classList.add("d-none");
            this.button.querySelector(".btn-text").classList.remove("d-none");
        }
    }

}