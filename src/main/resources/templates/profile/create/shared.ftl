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
        const onTabSwitchBtn = (newIndex) => {
            newIndex = switchToTab(newIndex);
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
            onTabSwitchBtn(tab)
        });
        <#noparse>
        const profile = {
            setItem: null,
            getItem: null,
            save: null,
            clear: null,
        };
        document.addEventListener("DOMContentLoaded", () => {
            const defaultProfile = {
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
            };
            let profileData = JSON.parse(window.localStorage.getItem("profileData")) || Object.assign({}, defaultProfile);
            profile.setItem = (key, value) => profileData[key] = value;
            profile.getItem = (key) => profileData[key];
            profile.save = () => window.localStorage.setItem("profileData", JSON.stringify(profileData));
            profile.clear = () => {
                window.localStorage.removeItem("profileData");
                profileData = Object.assign({}, defaultProfile)
            };
            document.dispatchEvent(new Event('profile-loaded'));
        });
        // TODO: add profile submit functionality
        </#noparse>
    </script>
</#macro>