<#ftl output_format="HTML">
<#import "/spring.ftl" as spring />
<#import "../shared/default.ftl" as default />

<!DOCTYPE html>
<html lang="en">

<@default.head title="Create profile">
    <link rel="stylesheet" href="<@spring.url "/webjars/animate.css/animate.min.css"/>"/>
    <link rel="stylesheet" href="<@spring.url "/css/tabs.css"/>"/>
</@default.head>

<body>
<@default.navbar profile="active"/>

<div class="container-fluid container-sm mb-3">
    <div class="d-flex flex-column align-items-center mt-5 mx-md-5">

        <div class="d-flex flex-column align-items-center mb-2">
            <h2>Welcome to STAs</h2>
            <div class="text-muted fs-5 mb-3">Create your portfolio</div>
        </div>


        <div class="d-flex mb-3">
            <button data-tab-index="0" class="p-2 me-1 border bg-primary border-light rounded-circle"></button>
            <button data-tab-index="1" class="p-2 me-1 border bg-transparent border-primary rounded-circle"></button>
            <button data-tab-index="2" class="p-2 me-1 border bg-transparent border-primary rounded-circle"></button>
        </div>

        <div class="tabs w-100 w-sm-75 w-xl-50">

            <div class="tab tab-active animate__fast w-100" data-tab-index="0">
                <div class="card rounded-3 user-select-none w-100">
                    <div class="card-body">
                        <h6 class="mb-1">Tell us about yourself</h6>
                        <div class="form-floating mt-3">
                            <input class="form-control" required type="text" name="name" id="name"
                                   placeholder="Name">
                            <label class="form-label text-muted" for="name">Name</label>
                        </div>
                        <div class="form-floating mt-3">
                            <input class="form-control" required type="text" name="location" id="location"
                                   placeholder="Location">
                            <label class="form-label text-muted" for="location">Location</label>
                        </div>
                        <div class="form-floating mt-3">
                            <input class="form-control" required type="text" name="contactPhone"
                                   id="contactPhone"
                                   placeholder="Phone number">
                            <label class="form-label text-muted" for="contactPhone">Phone number</label>
                        </div>
                        <div class="form-floating mt-3">
                            <input class="form-control" required type="text" name="contactEmail"
                                   id="contactEmail"
                                   placeholder="Email">
                            <label class="form-label text-muted" for="contactEmail">Email</label>
                        </div>
                        <div class="mt-4 d-flex justify-content-end">
                            <@nextBtn/>
                        </div>
                    </div>
                </div>
            </div>

            <div class="tab tab-hidden animate__fast w-100" data-tab-index="1">
                <div class="card rounded-3 user-select-none w-100">
                    <div class="card-body">
                        <h6 class="mb-1">What about your education?</h6>
                        <div class="form-floating mt-3">
                            <input class="form-control" required type="text" name="major" id="major"
                                   placeholder="Major">
                            <label class="form-label text-muted" for="major">Major</label>
                        </div>
                        <div class="form-floating mt-3">
                            <input class="form-control" required type="text" name="university" id="university"
                                   placeholder="University">
                            <label class="form-label text-muted" for="university">University</label>
                        </div>
                        <div class="mt-4 d-flex justify-content-between">
                            <@backBtn/>
                            <@nextBtn/>
                        </div>
                    </div>
                </div>
            </div>

            <div class="tab tab-hidden animate__fast w-100" data-tab-index="2">
                <div class="card rounded-3 user-select-none w-100">
                    <div class="card-body">
                        <h6 class="mb-1">Write a short bio about yourself</h6>
                        <div class="form-floating mt-3 fix-floating-label">
                            <textarea class="form-control" name="about" id="about"
                                      maxlength="5000" placeholder="About me"></textarea>
                            <label class="form-label text-muted" for="about">About me</label>
                        </div>
                        <div class="clearfix">
                            <div class="float-start">
                                <@default.mdDisclaimer/>
                            </div>
                            <div class="float-end text-muted user-select-none" id="aboutCharCount">0/5000</div>
                        </div>

                        <div class="mt-4 d-flex justify-content-between">
                            <@backBtn/>
                            <@nextBtn/>
                        </div>
                    </div>
                </div>
            </div>


        </div>

    </div>
</div>


<@default.scripts/>
<#-- profile wizard content script -->
<script src="<@spring.url "/js/profile/create.js"/>"></script>
<#-- 'About me' auto-expand script -->
<script>
    <#noparse>
    document.addEventListener("DOMContentLoaded", () => {
        const aboutElem = document.querySelector("#about");
        const aboutCharCount = document.querySelector("#aboutCharCount");
        _setupAutoTextArea(aboutElem);
        aboutElem.addEventListener("input", () => {
            _updateAutoTextArea(aboutElem);
            aboutCharCount.textContent = `${aboutElem.value.length}/5000`;
        });
    });
    </#noparse>
</script>
<#-- Tabs script -->
<script src="<@spring.url "/js/tabs.js"/>"></script>
<script>
    // setup initial tab
    document.addEventListener("DOMContentLoaded", () => {
        updateTabsHeight();
        updateTabIndicators(0);
    });
    // setup tab-switching buttons
    const onTabSwitchBtn = (newIndex) => {
        newIndex = switchToTab(newIndex);
        if (newIndex !== undefined && newIndex !== null) {
            updateTabIndicators(newIndex);
        }
    }
    document.querySelectorAll("button[data-tab-index]").forEach(button =>
        button.addEventListener('click', () => onTabSwitchBtn(button.getAttribute('data-tab-index')))
    );
    document.querySelectorAll("button.next-btn").forEach(button =>
        button.addEventListener('click', () => onTabSwitchBtn(getActiveTabIndex() + 1))
    );
    document.querySelectorAll("button.back-btn").forEach(button =>
        button.addEventListener('click', () => onTabSwitchBtn(getActiveTabIndex() - 1))
    );
</script>
</body>
</html>

<#macro nextBtn id="">
    <button <#if id?has_content>id="${id}"</#if> class="btn  btn-primary d-flex align-items-center next-btn">
        <span>Next</span>
        <@default.icon name="ic:round-navigate-next" height="24" width="24" class="align-middle"/>
    </button>
</#macro>
<#macro backBtn id="">
    <button <#if id?has_content>id="${id}"</#if> class="btn  btn-secondary d-flex align-items-center back-btn">
        <@default.icon name="ic:round-navigate-before" height="24" width="24" class="align-middle"/>
        <span>Previous</span>
    </button>
</#macro>