<#ftl output_format="HTML">
<#import "/spring.ftl" as spring />
<#import "../shared/default.ftl" as default />

<!DOCTYPE html>
<html lang="en">

<@default.head title="Profile search - STAs">
    <link rel="stylesheet" href="<@spring.url "/webjars/animate.css/animate.min.css"/>"/>
    <style>
        @media (min-width: 768px) {
            .profile-card {
                width: 18rem !important;
            }
        }

        .profile-card {
            width: 100%;
        }
    </style>
</@default.head>

<body class="min-vh-100">
<@default.navbar search="active"/>
<div class="container-fluid container-lg my-3 user-select-none animate__animated animate__fadeIn animate__faster">
    <div class="container mt-5">
        <div class="d-flex justify-content-center w-100">
            <div class="input-group w-100 w-sm-75 ">
                <input class="form-control border-end-0 border shadow-none" name="query" id="query"
                       placeholder="Search for a profile" aria-label="Search for a profile">
                <div class="input-group-text bg-white border-start-0 border shadow-none">
                    <button id="clearBtn" type="button" class="btn btn-sm bg-transparent shadow-none">
                        <@default.icon name="bx:x" height="24"/>
                    </button>
                </div>
                <button id="searchBtn" type="submit"
                        class="btn btn-primary d-flex align-items-center align-content-center">
                    <@default.icon name="mdi:magnify" height="24"/>
                </button>
            </div>
        </div>
        <div class="mt-3 ">
            <div class="card-body">
                <div id="profileCards" class="row row-cols-1 row-cols-sm-2 row-cols-lg-3 row-cols-xl-4">
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
    <div class="p-0 card card-border-grey h-100 user-select-none btn bg-hover animate__animated animate__fadeIn animate__faster profile-card">
        <img src="${imageUri}" data-prop="imageUri" class="card-img-top" onerror="_setPlaceholder(this)"
             data-placeholder="/images/generic_profile.jpeg" alt="Profile Picture">
        <div class="card-body d-flex flex-column flex-grow-1 w-100 align-content-start text-start">
            <h5 class="card-title" data-prop="name">${name}</h5>
            <h6 class="card-subtitle mb-2 text-muted overflow-hidden text-truncate"
                data-prop="major">${major}</h6>
            <div class="text-muted fs-6 overflow-hidden text-truncate">
                <@default.icon name="location" fallback="web" class="mx-1"/>
                <span data-prop="location" class="profile-view-item">${location}</span>
            </div>
            <div class="text-muted fs-6 overflow-hidden text-truncate">
                <@default.icon name="university" fallback="web" class="mx-1"/>
                <span data-prop="university" class="profile-view-item">${university}</span>
            </div>
            <a data-prop="publicUri" href="${publicUri}" class="stretched-link"></a>
        </div>
    </div>
</#macro>

<#macro emptyResult>
    <div class="w-100 min-h-100 d-flex justify-content-center align-items-center animate__animated animate__fadeIn animate__faster">
        <span class="fs-6 text-muted user-select-none">No matching profiles</span>
    </div>
</#macro>

<#macro loadingResult>
    <div class="w-100 min-h-100 d-flex justify-content-center align-items-center animate__animated animate__fadeIn animate__faster">
        <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Loading...</span>
        </div>
    </div>
</#macro>

<#macro loadingSpinner>
    <span>
        <span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>
        Loading
    </span>
</#macro>

<script>
    (() => {
        // Templates
        const profileCardTemplate = <@default.jsStr><@profileCard/></@default.jsStr>;
        const emptyResultTemplate = <@default.jsStr><@emptyResult/></@default.jsStr>;
        const loadingResultTemplate = <@default.jsStr><@loadingResult/></@default.jsStr>;
        const loadingSpinnerTemplate = <@default.jsStr><@loadingSpinner/></@default.jsStr>;

        // Variables
        const searchUri = "/profile/search";
        const queryInput = document.getElementById('query');
        const searchBtn = document.getElementById('searchBtn');
        const clearBtn = document.getElementById('clearBtn');
        const loadMoreBtn = document.getElementById('loadMoreBtn');
        const profileCards = document.getElementById('profileCards');
        const backendQuery = "${(query!"")?js_string?no_esc}";

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
            profileCard.querySelector('[data-prop="imageUri"]').src = profile["imageUri"] || "";
            const column = document.createElement('div');
            column.classList.add('col', 'mb-3', 'd-flex', 'justify-content-center', 'justify-content-md-start');
            column.appendChild(profileCard);
            return column;
        }
        const clearResultsArea = () => {
            profileCards.replaceChildren();
            loadMoreBtn.classList.add('d-none');
        }
        const setResultsArea = (template) => {
            clearResultsArea();
            const templateElem = document.createElement('template');
            templateElem.innerHTML = template;
            profileCards.appendChild(templateElem.content.firstElementChild);
        }
        const doSearch = async (query) => {
            setResultsArea(loadingResultTemplate);
            history.replaceState({}, '', "/search?query=" + encodeURIComponent(query));
            let response = await fetch(searchUri + "?" + new URLSearchParams({query}))
            if (response.ok) {
                const search = await response.json();
                const profiles = search["result"];
                if (search["totalCount"] === 0)
                    return setResultsArea(emptyResultTemplate);
                clearResultsArea();
                for (const profile of profiles) {
                    const profileCard = createProfileCard(profile);
                    profileCards.appendChild(profileCard);
                }
                if (profiles.length < search["totalCount"]) {
                    loadMoreBtn.setAttribute("data-query", query);
                    loadMoreBtn.setAttribute("data-page", search["page"] + 1);
                    loadMoreBtn.innerText = "Load More";
                    loadMoreBtn.classList.remove('d-none');
                }
            }
        }

        // Event listeners
        searchBtn.addEventListener('click', () => {
            const query = queryInput.value;
            if (query.length < 3)
                return
            clearResultsArea();
            doSearch(query);
        });
        clearBtn.addEventListener('click', () => {
            queryInput.value = "";
            history.replaceState({}, '', "/search");
            clearResultsArea();
        });
        queryInput.addEventListener('keypress', (event) => {
            if (event.key === "Enter") {
                event.preventDefault();
                const query = queryInput.value;
                if (query.length < 3)
                    return
                clearResultsArea();
                doSearch(query);
            }
        })
        loadMoreBtn.addEventListener('click', async () => {
            const query = loadMoreBtn.getAttribute("data-query");
            const page = loadMoreBtn.getAttribute("data-page");
            if (!query || !page)
                return;
            loadMoreBtn.innerHTML = loadingSpinnerTemplate;
            let response = await fetch(searchUri + "?" + new URLSearchParams({query, page}))
            if (response.ok) {
                const search = await response.json();
                const profiles = search["result"];
                if (profiles.length === 0) {
                    loadMoreBtn.removeAttribute("data-query");
                    loadMoreBtn.removeAttribute("data-page");
                    loadMoreBtn.classList.add('d-none');
                    return;
                }
                for (const profile of profiles) {
                    const profileCard = createProfileCard(profile);
                    profileCards.appendChild(profileCard);
                }
                const profileCount = document.querySelectorAll(".profile-card").length;
                if (profileCount < search["totalCount"]) {
                    loadMoreBtn.setAttribute("data-query", query);
                    loadMoreBtn.setAttribute("data-page", search["page"] + 1);
                    loadMoreBtn.innerText = "Load More";
                    loadMoreBtn.classList.remove('d-none');
                }
            }
        });
        // do an initial search if there's a query in the model
        if (backendQuery.length > 0) {
            queryInput.value = backendQuery;
            doSearch(backendQuery);
        }
    })()
</script>

</body>
</html>