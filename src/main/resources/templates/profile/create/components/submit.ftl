<#import "../../../shared/default.ftl" as default/>
<#import "../shared.ftl" as shared/>
<#import "../../popup.ftl" as popups />

<#macro card>
    <div id="submitCard" class="card rounded-3 user-select-none w-100">
        <div class="card-body">
            <div class="mb-3 animate__animated animate__fadeIn animate__faster" data-state="initial">
                <div class="d-flex flex-column align-items-center">
                    <h5 class="card-title">That's all!</h5>
                    <div class="card-text">Click the button below to finish creating your portfolio</div>
                </div>
            </div>
            <div class="mb-3 d-none animate__animated animate__fadeIn animate__faster" data-state="progress">
                <div class="d-flex flex-column align-items-center">
                    <h5 class="card-title">Creating your portfolio...</h5>
                    <div class="mt-3 w-100 min-h-100 d-flex justify-content-center align-items-center">
                        <div class="spinner-border text-primary" role="status">
                            <span class="visually-hidden">Loading...</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="mb-3 d-none animate__animated animate__fadeIn animate__faster" data-state="feedback">
                <div class="d-flex flex-column align-items-center justify-content-center">
                    <h6 class="d-flex align-items-center card-title">
                        <span class="me-2">An error occurred</span>
                        <span class="iconify-inline" data-icon="emojione:sad-but-relieved-face" data-width="28"></span>
                    </h6>
                    <div class="card-text feedback-text"></div>
                </div>
            </div>
            <div class="mt-4 clearfix">
                <@shared.backBtn/>
                <div class="float-end">
                    <button class="btn btn-primary d-flex align-items-center submit-button">
                        <@default.icon name="mdi:card-account-details-outline" height="24" width="24" class="align-middle me-2"/>
                        <span>Create my portfolio</span>
                    </button>
                </div>
            </div>
        </div>
    </div>
</#macro>

<#macro script>
    <script>
        (() => {
            const groups = {
                    initial: document.querySelector("#submitCard [data-state='initial']"),
                    progress: document.querySelector("#submitCard [data-state='progress']"),
                    feedback: document.querySelector("#submitCard [data-state='feedback']"),
                },
                submitButton = document.querySelector("#submitCard .submit-button"),
                feedbackText = groups.feedback.querySelector(".feedback-text");
            let inProgress = false;


            groups.initial.classList.remove("d-none");
            groups.progress.classList.add("d-none");
            groups.feedback.classList.add("d-none");

            submitButton.addEventListener("click", async () => {
                if (inProgress)
                    return;
                inProgress = true;
                Profile.saveProfile();
                groups.initial.classList.add("d-none");
                groups.progress.classList.remove("d-none");
                const response = await fetch("/profile/create", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json",
                        [document.querySelector("meta[name='_csrf_header']").content]: document.querySelector("meta[name='_csrf']").content,
                    },
                    body: localStorage.getItem("profile"),
                });
                if (response.ok) {
                    localStorage.clear();
                    inProgress = false;
                    window.location.href = "/profile";
                } else {
                    groups.progress.classList.add("d-none");
                    feedbackText.textContent = "Failed with error " + response.status;
                    groups.feedback.classList.remove("d-none");
                    setTimeout(() => {
                        groups.feedback.classList.add("d-none");
                        groups.initial.classList.remove("d-none")
                        inProgress = false;
                    }, 2000);
                }
            });
        })();
    </script>
</#macro>