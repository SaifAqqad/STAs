<#ftl output_format="HTML">
<#import "/spring.ftl" as spring />
<#import "../shared/default.ftl" as default />

<!DOCTYPE html>
<html lang="en">
<@default.head title="Dashboard - STAs">
    <style>
        .table > :not(:first-child) {
            border-top: 0;
        }
    </style>
</@default.head>

<body>
<@default.navbar admin="active"/>

<div class="container-fluid container-lg my-3 animate__animated animate__fadeIn animate__faster">
    <div class="table-responsive p-2">
        <table class="table table-light table-hover shadow shadow-lg user-select-none users-table">
            <thead class="users-header">
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Email</th>
                <th>Role</th>
                <th>State</th>
                <th>2FA</th>
                <th>Connections</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody class="users-body">

            </tbody>
            <tfoot>
            <tr>
                <td colspan="8" class="users-footer">
                </td>
            </tr>
            </tfoot>
        </table>
    </div>

</div>

<@default.scripts/>

<script>
    (() => {
        let currentPage = 0, totalPages = 0, pageSize = 10;
        const usersBaseEndpoint = "/users";
        const connectionIcons = {
            "google": <@default.jsStr><@default.icon name='flat-color-icons:google'/></@default.jsStr>,
            "github": <@default.jsStr><@default.icon name='mdi:github'/></@default.jsStr>,
            "linkedin": <@default.jsStr><@default.icon name='mdi:linkedin'/></@default.jsStr>,
        }
        const loadingSpinner = <@default.jsStr><@loadingSpinner/></@default.jsStr>;

        const usersHeader = document.querySelector(".users-header");
        const usersBody = document.querySelector('.users-body');
        const usersFooter = document.querySelector('.users-footer');

        const userToRow = (user) => {
            const row = document.createElement('tr');

            const id = row.insertCell()
            id.textContent = user["userId"];

            const name = row.insertCell()
            name.textContent = user["firstName"] + " " + user["lastName"];

            const email = row.insertCell()
            email.textContent = user["email"] || "NA";

            const role = row.insertCell()
            const roleTag = document.createElement('span');
            const isAdmin = user["role"] === "ROLE_ADMIN";
            roleTag.classList.add('badge', 'fw-normal', 'rounded-pill', isAdmin ? 'bg-info' : 'bg-primary');
            roleTag.textContent = isAdmin ? "Admin" : "Student";
            role.appendChild(roleTag);

            const state = row.insertCell()
            const stateTag = document.createElement('span');
            stateTag.classList.add('badge', 'fw-normal', 'rounded-pill', user["enabled"] ? 'bg-success' : 'bg-danger');
            stateTag.textContent = user["enabled"] ? "Enabled" : "Disabled";
            state.appendChild(stateTag);

            const twoFA = row.insertCell()
            const twoFATag = document.createElement('span');
            twoFATag.classList.add('badge', 'fw-normal', 'rounded-pill', user["using2FA"] ? 'bg-success' : 'bg-danger');
            twoFATag.textContent = user["using2FA"] ? "Enabled" : "Disabled";
            twoFA.appendChild(twoFATag);

            const connections = row.insertCell()
            const connectionsRow = document.createElement('div');
            connectionsRow.classList.add('d-flex', 'justify-content-between');
            user["connections"].forEach(connection => {
                const connElem = document.createElement('span');
                connElem.classList.add('fs-5');
                connElem.innerHTML = connectionIcons[connection["serviceName"]];
                connectionsRow.appendChild(connElem);
            });
            if (user["connections"].length === 0) {
                connectionsRow.textContent = "NA";
            }
            connections.appendChild(connectionsRow);

            const actions = row.insertCell()
            // TODO: Add actions

            return row;
        };

        const updatePagination = async () => {
            // clear the footer
            usersFooter.replaceChildren();

            // create the pagination container
            const container = document.createElement('div');
            container.classList.add('d-flex', 'justify-content-center');

            // create the pagination list
            const pagination = document.createElement('ul');
            pagination.classList.add('pagination', 'm-0');

            // create the previous page li and button
            const prev = document.createElement('li');
            prev.classList.add('page-item');
            if (currentPage < 1) { // we are on the first page
                prev.classList.add('disabled');
            }

            const prevBtn = document.createElement('button');
            prevBtn.classList.add('page-link');
            prevBtn.textContent = "Previous";
            prevBtn.addEventListener('click', () => {
                if (currentPage > 0) {
                    currentPage--;
                    fetchCurrentPage();
                }
            });
            prev.appendChild(prevBtn);
            pagination.appendChild(prev);

            // create the next page li and button
            const next = document.createElement('li');
            next.classList.add('page-item');
            if (currentPage + 1 >= totalPages) { // we reached the last page
                next.classList.add('disabled');
            }

            const nextBtn = document.createElement('button');
            nextBtn.classList.add('page-link');
            nextBtn.textContent = "Next";
            nextBtn.addEventListener('click', () => {
                if (currentPage + 1 < totalPages) {
                    currentPage++;
                    fetchCurrentPage();
                }
            });
            next.appendChild(nextBtn);
            pagination.appendChild(next);

            // append the pagination to the footer
            container.appendChild(pagination);
            usersFooter.appendChild(container);
        };

        const fetchCurrentPage = () => {
            // empty the table
            usersBody.replaceChildren();
            // show the loading spinner
            usersFooter.innerHTML = loadingSpinner;
            // hide the table header
            usersHeader.classList.add('d-none');
            // fetch the current page
            fetch(usersBaseEndpoint + "?" + new URLSearchParams({
                "page": currentPage.toString(),
                "size": pageSize.toString()
            })).then(response => response.json())
                .then(data => {
                    // for each user, create a row and append it to the table
                    data.content.forEach(user => usersBody.appendChild(userToRow(user)));
                    // show the table header
                    usersHeader.classList.remove('d-none');
                    // update current and total page count
                    currentPage = data["pageable"]["pageNumber"];
                    totalPages = data["totalPages"];
                    // update the pagination footer
                    updatePagination();
                })
        };

        // on page load -> fetch the first page
        document.addEventListener("DOMContentLoaded", () => fetchCurrentPage());
    })();
</script>

</body>

</html>

<#macro loadingSpinner>
    <div class="w-100 min-h-100 d-flex justify-content-center align-items-center animate__animated animate__fadeIn animate__faster">
        <div class="spinner-border text-dark" role="status">
            <span class="visually-hidden">Loading...</span>
        </div>
    </div>
</#macro>