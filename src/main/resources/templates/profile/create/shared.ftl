<#import "../../shared/default.ftl" as default />

<#macro nextBtn id="">
    <div class="float-end">
        <button <#if id?has_content>id="${id}"</#if> class="btn  btn-primary d-flex align-items-center next-btn">
            <span>Next</span>
            <@default.icon name="ic:round-navigate-next" height="24" width="24" class="align-middle"/>
        </button>
    </div>
</#macro>

<#macro backBtn id="">
    <div class="float-start">
        <button <#if id?has_content>id="${id}"</#if> class="btn  btn-secondary d-flex align-items-center back-btn">
            <@default.icon name="ic:round-navigate-before" height="24" width="24" class="align-middle"/>
            <span>Previous</span>
        </button>
    </div>
</#macro>

<#macro emptyContainer>
    <div class="w-100 min-h-100 d-flex justify-content-center align-items-center empty-container">
        <span class="fs-6 text-muted user-select-none">You haven't added anything yet</span>
    </div>
</#macro>

<#macro itemCard cardType>
    <div class="card card-border-grey w-100 h-100 user-select-none btn bg-hover ${cardType}">
        <div class="d-flex flex-column flex-md-row align-content-between align-items-center w-100">
            <div class="h-100 w-50 ${cardType}-image-container d-flex align-items-center">
                <img src="" class="w-100 rounded-3 shadow-lg object-fit-cover aspect-ratio-1 ${cardType}-image"
                     alt="${cardType}-image">
            </div>
            <div class="card-body d-flex flex-column flex-grow-1 w-100">
                <h5 class="card-title user-select-none ${cardType}-title"></h5>
                <h6 class="card-subtitle mb-2 text-muted ${cardType}-subtitle"></h6>
                <p class="card-text limit-lines-4 ${cardType}-text"></p>
                <#nested/>
            </div>
        </div>
    </div>
</#macro>

<#macro scripts>
    <script src="<@spring.url "/js/tabs.js"/>"></script>
    <script>
        // setup tab-switching buttons
        const onTabSwitchBtn = (newIndex, isFirstLoad = false) => {
            newIndex = switchToTab(newIndex, isFirstLoad);
            if (newIndex !== undefined && newIndex !== null) {
                updateTabIndicators(newIndex);
                window.localStorage.setItem("currentTab", newIndex)
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
        // setup initial tab
        document.addEventListener("DOMContentLoaded", () => {
            // load previous tab from localstorage
            const tab = Number(window.localStorage.getItem("currentTab") || 0)
            onTabSwitchBtn(tab, true)
        });
        <#noparse>

        class Profile {
            static #defaultProfile = {
                name: null,
                contactEmail: null,
                contactPhone: null,
                location: null,
                about: null,
                university: null,
                major: null,
                imageUri: null,
                imageData: null,
                isPublic: false,
                includeInSearch: false,
                links: {},
                courses: [],
                activities: [],
                projects: [],
                experiences: [],
            }
            static Course = (class {
                id = null;
                name = null;
                description = null;
                studentComment = null;
                publisher = null;
                url = null;
                imageUri = null;

                constructor(obj = null) {
                    if (obj === null)
                        return;
                    this.id = obj.id
                    this.name = obj.name
                    this.description = obj.description
                    this.studentComment = obj.studentComment
                    this.publisher = obj.publisher
                    this.url = obj.url
                    this.imageUri = obj.imageUri
                    this.imageData = obj.imageData
                }
            });
            static #profile;
            static {
                Profile.#profile = JSON.parse(window.localStorage.getItem("profile")) || Object.assign({}, this.#defaultProfile);
                document.addEventListener("DOMContentLoaded", () => {
                    document.dispatchEvent(new Event('profile-loaded'));
                })
            }

            static setItem(key, value) {
                if (Profile.#profile.hasOwnProperty(key)) {
                    Profile.#profile[key] = value;
                }
            }

            static getItem(key) {
                return Profile.#profile[key];
            }

            static saveProfile() {
                window.localStorage.setItem("profile", JSON.stringify(Profile.#profile));
            }

            static clearProfile() {
                Profile.#profile = Object.assign({}, this.#defaultProfile);
                window.localStorage.removeItem("profile");
            }
        }

        // TODO: add profile submit functionality
        </#noparse>
    </script>
</#macro>