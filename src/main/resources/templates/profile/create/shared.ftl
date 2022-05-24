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