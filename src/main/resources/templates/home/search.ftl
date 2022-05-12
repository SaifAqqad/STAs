<#ftl output_format="HTML">
<#import "/spring.ftl" as spring />
<#import "../shared/default.ftl" as default />

<!DOCTYPE html>
<html lang="en">

<@default.head title="Profile search - STAs"/>

<body>
<@default.navbar search="active"/>
<div class="container-fluid container-lg my-3 user-select-none">
    <div class="container mt-5">
        <div class="d-flex w-100">
            <div class="input-group">
                <input class="form-control" name="query" id="query"
                       placeholder="Search for a profile" aria-label="Search for a profile">
                <button id="searchBtn" type="submit"
                        class="btn btn-primary d-flex align-items-center align-content-center">
                    <@default.icon name="mdi:magnify" height="24"/>Search
                </button>
            </div>
        </div>
        <div class="mt-3 ">
            <div class="card-body">
                <div id="profileCards" class="row row-cols-1 row-cols-lg-2">
                </div>
                <div class="w-100 d-flex justify-content-center align-content-center">
                    <button id="loadMoreBtn" type="button" class="btn btn-sm btn-primary d-none">Load more</button>
                </div>
            </div>
        </div>
    </div>
</div>


<@default.scripts/>

<#macro profileCard name="_" imageUri="_" publicUri="_" major="_" location="_" university="_">
    <div class="p-0 card card-border-grey h-100 user-select-none btn bg-hover profile-card" style="width: 18rem;">
        <img src="${imageUri}" data-prop="imageUri" class="card-img-top"
             alt="Profile Picture">
        <div class="card-body d-flex flex-column flex-grow-1 w-100 align-items-start align-content-start text-start">
            <h5 class="card-title" data-prop="name">${name}</h5>
            <h6 class="card-subtitle mb-2 text-muted overflow-hidden text-truncate"
                data-prop="major">${major}</h6>
            <div class="text-muted fs-6 overflow-hidden text-truncate">
                <@default.icon name="location" fallback="web" class="mx-1"/>
                <span data-prop="location" class="profile-view-item text-truncate">${location}</span>
            </div>
            <div class="text-muted fs-6 overflow-hidden text-truncate">
                <@default.icon name="university" fallback="web" class="mx-1"/>
                <span data-prop="university" class="profile-view-item text-truncate">${university}</span>
            </div>
            <a data-prop="publicUri" href="${publicUri}" class="stretched-link"></a>
        </div>
    </div>
</#macro>

<#macro emptyResult>
    <div class="card w-100 min-h-100 d-flex justify-content-center align-items-center">
        <span class="fs-6 text-muted user-select-none">No matching profiles</span>
    </div>
</#macro>

<#macro loadingResult>
    <div class="w-100 min-h-100 d-flex justify-content-center align-items-center">
        <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Loading...</span>
        </div>
    </div>
</#macro>

<script>
    (() => {
        // Templates
        const profileCardTemplate = <@default.jsStr><@profileCard/></@default.jsStr>;
        const emptyResultTemplate = <@default.jsStr><@emptyResult/></@default.jsStr>;
        const loadingResultTemplate = <@default.jsStr><@loadingResult/></@default.jsStr>;

        // Variables
        const searchUri = "/profile/search";
        const queryInput = document.getElementById('query');
        const searchBtn = document.getElementById('searchBtn');
        const loadMoreBtn = document.getElementById('loadMoreBtn');
        const profileCards = document.getElementById('profileCards');

        // Functions
        const createProfileCard = (profile) => {
            const templateElem = document.createElement('template');
            templateElem.innerHTML = profileCardTemplate;
            const profileCard = templateElem.content.firstElementChild;
            profileCard.querySelector('[data-prop="name"]').innerText = profile["name"];
            profileCard.querySelector('[data-prop="major"]').innerText = profile["major"];
            profileCard.querySelector('[data-prop="location"]').innerText = profile["location"];
            profileCard.querySelector('[data-prop="university"]').innerText = profile["university"];
            profileCard.querySelector('[data-prop="publicUri"]').href = profile["publicUri"];
            profileCard.querySelector('[data-prop="imageUri"]').src = profile["imageUri"];
            const column = document.createElement('div');
            column.classList.add('col', 'mb-3', 'd-flex', 'justify-content-center', 'justify-content-sm-start');
            column.appendChild(profileCard);
            return column;
        }
        const clearResults = () => {
            profileCards.replaceChildren();
            loadMoreBtn.classList.add('d-none');
        }
        const setResults = (template) => {
            clearResults();
            const templateElem = document.createElement('template');
            templateElem.innerHTML = template;
            profileCards.appendChild(templateElem.content.firstElementChild);
        }

        // Event listeners
        const searchEventListener = async () => {
            clearResults();
            const query = queryInput.value;
            if (query.length === 0)
                return
            setResults(loadingResultTemplate);
            let response = await fetch(searchUri + "?" + new URLSearchParams({query}))
            if (response.ok) {
                const search = await response.json();
                const profiles = search["result"];
                if (profiles.length === 0)
                    return setResults(emptyResultTemplate);
                clearResults();
                for (const profile of profiles) {
                    const profileCard = createProfileCard(profile);
                    profileCards.appendChild(profileCard);
                }
                if (profiles.length < search["totalCount"]) {
                    loadMoreBtn.setAttribute("data-page", search["page"] + 1);
                    loadMoreBtn.classList.remove('d-none');
                }
            }
        }
        searchBtn.addEventListener('click', searchEventListener);
        queryInput.addEventListener('keypress', (event) => {
            if (event.key === "Enter") {
                event.preventDefault();
                searchEventListener();
            }
        })
    })()
</script>

</body>
</html>