<#import "../../../shared/default.ftl" as default/>
<#import "../shared.ftl" as shared/>
<#import "../../popup.ftl" as popups />

<#macro card>
    <div id="educationCard" class="card rounded-3 user-select-none w-100">
        <div class="card-body">
            <h6 class="card-title mb-1">What about your education?</h6>
            <div class="form-floating mt-3">
                <input class="form-control" required type="text" data-profile-prop="major" id="major"
                       placeholder="Major">
                <label class="form-label text-muted" for="major">Major</label>
            </div>
            <div class="form-floating mt-3">
                <input class="form-control" required type="text" data-profile-prop="university"
                       id="university"
                       placeholder="University">
                <label class="form-label text-muted" for="university">University</label>
            </div>
            <div class="card card-border-grey w-100 mt-3 p-3 pt-2 ">
                <div class="d-flex justify-content-between align-items-center">
                    <h6 class="card-title mb-2">
                        Have you taken any courses?
                    </h6>
                    <button class="btn btn-outline-primary mb-2" id="addCourseButton">Add course</button>
                </div>
                <div class="row row-cols-1 row-cols-lg-2">
                    <div class="w-100 min-h-100 d-flex justify-content-center align-items-center">
                        <span class="fs-6 text-muted user-select-none">You haven't added anything yet</span>
                    </div>
                </div>
            </div>
            <div class="mt-4 clearfix">
                <@shared.backBtn/>
                <@shared.nextBtn/>
            </div>
        </div>
    </div>
</#macro>

<#macro script>
    <script>
        (() => {
            const tabsContainer = document.querySelector('.tabs');
            const card = document.querySelector('#educationCard');
            const currentTab = card.parentElement;

            tabsContainer.addEventListener("tab-changing", () => {
                if (!currentTab.classList.contains("tab-active"))
                    return;
                card.querySelectorAll("[data-profile-prop]").forEach(element => {
                    Profile.setItem(element.getAttribute("data-profile-prop"), element.value)
                });
                courses.save();
                Profile.saveProfile();
            });

            document.addEventListener("profile-loaded", () => {
                card.querySelectorAll("[data-profile-prop]").forEach(element => {
                    element.value = Profile.getItem(element.getAttribute("data-profile-prop"))
                });
                // TODO: add a new card for each course in the data
            })

        })()
    </script>
</#macro>

