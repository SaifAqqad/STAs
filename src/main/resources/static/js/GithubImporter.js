class GithubImporter {
    connectionEndpoint = "/connections/github"
    signInEndpoint = "/connect/github"
    windowOptions = "toolbar=no, menubar=no, width=600, height=700";

    constructor(groupId, applyFunc) {
        this.applyFunc = applyFunc;
        this.group = document.getElementById(groupId);
        this.preLoginElems = this.group.querySelectorAll(".gi-pre-login");
        this.postLoginElems = this.group.querySelectorAll(".gi-post-login");
        this.loginBtn = this.group.querySelector("button.gi-login-btn");
        this.userNameElem = this.group.querySelector(".gi-username");
        this.feedbackElem = this.group.querySelector(".gi-feedback");
        this.repoDropdown = this.group.querySelector(".gi-repos");
        this.loginBtn.addEventListener("click", this.onLoginBtn.bind(this));
    }

    async init() {
        this.clear();
        const profile = await this.fetchGithubProfile();
        if (profile) {
            _showElems(this.postLoginElems, true);
            _showElems(this.preLoginElems, false);
            // set the username
            this.userNameElem.textContent = profile["userName"];
            profile["repositories"].forEach(repo => {
                // create a new dropdown item and append it
                const repoItem = this.createRepoItem(repo);
                this.repoDropdown.appendChild(repoItem);
            });
        } else { // failed to get githubProfile
            _showElems(this.postLoginElems, false);
            _showElems(this.preLoginElems, true);
        }
    }

    async fetchGithubProfile() {
        const response = await fetch(this.connectionEndpoint);
        if (!response.ok) {
            return null;
        }
        const connection = await response.json();
        return connection["serviceUserProfile"];
    }

    clear() {
        _showElems(this.postLoginElems, false);
        _showElems(this.preLoginElems, false);
        this.feedbackElem.textContent = "";
        this.userNameElem.textContent = "Github";
        this.repoDropdown.replaceChildren();
    }

    onLoginBtn() {
        if (!this.loginWindow || this.loginWindow.closed) {
            this.feedbackElem.textContent = "";
            this.loginWindow = window.open(this.signInEndpoint, "Github OAuth", this.windowOptions);
        }
        this.loginWindow.focus();
        document.addEventListener("oauth-callback", async (event) => {
            const isOAuthError = event.detail.oauthError;
            if (isOAuthError) {
                this.feedbackElem.textContent = "Failed to connect to Github";
            } else {
                this.loginWindow.close();
                await this.init();
            }
        }, {once: true});
    }

    createRepoItem(repo) {
        const button = document.createElement("button");
        // set the button props
        button.classList.add("dropdown-item")
        button.type = "button"
        button.textContent = repo["name"];
        // set repo's click handler
        button.addEventListener("click", () => {
            // convert the repo to a project Object
            const projectObj = this.repoToProject(repo)
            // apply it onto the form
            this.applyFunc(projectObj);
        });
        // wrap the button with a list item
        const li = document.createElement("li")
        li.appendChild(button)
        return li;
    }

    repoToProject(repo) {
        return {
            name: repo["name"],
            description: repo["description"],
            category: repo["language"],
            url: repo["htmlUrl"],
        };
    }

}