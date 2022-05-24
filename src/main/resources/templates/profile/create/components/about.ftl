<#import "../../../shared/default.ftl" as default/>
<#import "../shared.ftl" as shared/>

<#macro card>
    <div id="aboutCard" class="card rounded-3 user-select-none w-100">
        <div class="card-body">
            <div class="d-flex justify-content-between align-items-center">
                <h6 class="card-title mb-1">Write a short bio</h6>
                <div class="form-check form-switch">
                    <input class="form-check-input" type="checkbox" role="switch" id="aboutPreview">
                    <label class="form-check-label" for="aboutPreview">Preview</label>
                </div>
            </div>
            <div class="md-edit">
                <div class="form-floating mt-3 fix-floating-label">
                <textarea class="form-control" data-profile-prop="about" id="about"
                          maxlength="5000" placeholder="About me"></textarea>
                    <label class="form-label text-muted" for="about">About me</label>
                </div>
                <div class="clearfix">
                    <div class="float-start">
                        <@default.mdDisclaimer/>
                    </div>
                    <div class="float-end text-muted user-select-none" id="aboutCharCount">0/5000</div>
                </div>
            </div>
            <div class="card card-border-grey p-3 pb-1 mt-3 d-none md-content" style="min-height: 4rem"></div>
            <div class="mt-4 clearfix">
                <@shared.backBtn/>
                <@shared.nextBtn/>
            </div>
        </div>
    </div>
</#macro>

<#macro script>
    <script src="/webjars/dompurify/dist/purify.min.js"></script>
    <script src="/webjars/marked/marked.min.js"></script>
    <script>
        <#noparse>
        (() => {
            const aboutElem = document.querySelector("#about");
            const aboutCharCount = document.querySelector("#aboutCharCount");
            const tabsContainer = document.querySelector('.tabs');
            const card = document.querySelector('#aboutCard');
            const currentTab = card.parentElement;

            // setup auto-expanding textarea
            _setupAutoTextArea(aboutElem);
            aboutElem.addEventListener("input", () => {
                _updateAutoTextArea(aboutElem);
                aboutCharCount.textContent = `${aboutElem.value.length}/5000`;
            });

            // save about content on blur
            aboutElem.addEventListener("change", () => {
                Profile.setItem("about", aboutElem.value)
                Profile.saveProfile()
            });

            // preview switch
            document.querySelector("#aboutPreview").addEventListener("change", (e) => {
                const isChecked = e.target.checked;
                const mdEdit = document.querySelector(".md-edit");
                const mdContent = document.querySelector(".md-content");
                if (isChecked) {
                    mdEdit.classList.add("d-none");
                    mdContent.innerHTML = DOMPurify.sanitize(marked.parse(aboutElem.value.trim()));
                    mdContent.classList.remove("d-none");
                } else {
                    mdEdit.classList.remove("d-none");
                    mdContent.classList.add("d-none");
                }
            });

            // handle tab changing event
            tabsContainer.addEventListener("tab-changing", () => {
                // if we're not the active tab -> don't handle it
                if (!currentTab.classList.contains('tab-active'))
                    return;
                Profile.setItem("about", aboutElem.value)
                Profile.saveProfile()
            })

            // handle tab changed event
            tabsContainer.addEventListener("tab-changed", () => {
                // if we're hidden -> don't handle it
                if (currentTab.classList.contains('tab-hidden'))
                    return;
                _updateAutoTextArea(aboutElem);
            })

            // load existing about text
            document.addEventListener("profile-loaded", () => {
                aboutElem.value = Profile.getItem("about") || ""
                aboutCharCount.textContent = `${aboutElem.value.length}/5000`;
                _updateAutoTextArea(aboutElem);
            })
        })()
        </#noparse>
    </script>
</#macro>