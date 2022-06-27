<#ftl output_format="HTML">
<#import "/spring.ftl" as spring />
<#import "../shared/default.ftl" as default />

<!DOCTYPE html>
<html lang="en">
<@default.head title="Admin panel - STAs">
    <style>
        .table > :not(:first-child) {
            border-top: 0;
        }
    </style>
</@default.head>

<body>
<@default.navbar admin="active"/>

<div class="container-fluid container-lg my-3">
    <div class="table-responsive p-2">
        <table class="table table-light table-hover caption-top card-border-grey user-select-none users-table animate__animated animate__fadeIn animate__faster">
            <caption class="card-title fs-6 mb-0">User accounts</caption>
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
        <div id="loadingSpinner"
             class="w-100 min-h-100 d-flex justify-content-center align-items-center animate__animated animate__fadeIn animate__faster">
            <div class="spinner-border text-primary" role="status">
                <span class="visually-hidden">Loading...</span>
            </div>
        </div>
    </div>

</div>

<@default.scripts/>

<script src="<@spring.url "/webjars/bootstrap-modbox/dist/bootstrap-modbox.min.js"/>"></script>
<script>
    (() => {
        const connectionIcons = {
            "google": <@default.jsStr><@default.icon name='flat-color-icons:google'/></@default.jsStr>,
            "github": <@default.jsStr><@default.icon name='mdi:github'/></@default.jsStr>,
            "linkedin": <@default.jsStr><@default.icon name='logos:linkedin-icon'/></@default.jsStr>,
        }
        const dropdownIcon =<@default.jsStr><@default.icon name='bxs:down-arrow'/></@default.jsStr>;

        const loadingSpinner = document.getElementById('loadingSpinner')
        const usersTable = document.querySelector('.users-table')
        const usersBody = document.querySelector('.users-body');
        const usersFooter = document.querySelector('.users-footer');

        const User = (class {
            static baseEndpoint = "/users";
            static ROLES = {
                "ROLE_STUDENT": "Student",
                "ROLE_ADMIN": "Admin",
            };
            static csrfHeader = document.querySelector("meta[name='_csrf_header']").content;
            static csrfToken = document.querySelector("meta[name='_csrf']").content;

            static async getAll(page, size) {
                const response = await fetch(User.baseEndpoint + "?" + new URLSearchParams({page, size}))
                if (!response.ok)
                    return null;
                return await response.json();
            }

            static async delete(id) {
                const response = await fetch(User.baseEndpoint + "/" + id, {
                    headers: {[User.csrfHeader]: User.csrfToken},
                    method: "DELETE",
                });
                return response.ok;
            }

            static async disable2FA(id) {
                const response = await fetch(User.baseEndpoint + "/" + id + "/disable-2FA", {
                    headers: {[User.csrfHeader]: User.csrfToken},
                    method: "POST",
                });
                return response.ok;
            }

            static async setRole(id, role) {
                const response = await fetch(User.baseEndpoint + "/" + id + "/role", {
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                        [User.csrfHeader]: User.csrfToken,
                    },
                    method: "POST",
                    body: new URLSearchParams({role}),
                });
                return response.ok;
            }
        });
        let currentPage = 0, totalPages = 0, pageSize = 10;

        const userToRow = (user) => {
            const row = document.createElement('tr');

            const id = row.insertCell()
            id.textContent = user["userId"];

            const name = row.insertCell()
            name.textContent = user["firstName"] + " " + user["lastName"];

            const email = row.insertCell()
            email.textContent = user["email"] || "NA";

            const role = row.insertCell()
            const roleDropdownContainer = document.createElement('div');
            roleDropdownContainer.classList.add('dropdown');

            // Role tag button
            const roleTag = document.createElement('div');
            const isAdmin = user["role"] === "ROLE_ADMIN";
            roleTag.classList.add('badge', 'clickable', 'fw-normal', 'rounded-pill', isAdmin ? 'bg-info' : 'bg-primary');
            roleTag.textContent = isAdmin ? "Admin " : "Student ";
            roleTag.setAttribute("data-bs-toggle", "dropdown");
            roleTag.insertAdjacentHTML('beforeend', dropdownIcon);
            roleTag.id = "role-tag-" + user["userId"];
            roleDropdownContainer.appendChild(roleTag);

            const roleDropdownMenu = document.createElement('ul');
            roleDropdownMenu.classList.add('dropdown-menu');
            roleDropdownMenu.setAttribute("aria-labelledby", "role-tag-" + user["userId"]);

            // add each role to the dropdown menu
            Object.entries(User.ROLES).forEach(([role, roleName]) => {
                const roleDropdownItem = document.createElement('li');
                const roleDropdownItemButton = document.createElement('button');

                roleDropdownItemButton.classList.add('dropdown-item');
                roleDropdownItemButton.textContent = roleName;
                roleDropdownItemButton.addEventListener('click', async () => {
                    setLoading(true);
                    if (await User.setRole(user["userId"], role))
                        await fetchCurrentPage();
                    setLoading(false);
                });

                roleDropdownItem.appendChild(roleDropdownItemButton);
                roleDropdownMenu.appendChild(roleDropdownItem);
            });

            // add the dropdown menu to the dropdown container
            roleDropdownContainer.appendChild(roleDropdownMenu);
            // add the dropdown container to the role cell
            role.appendChild(roleDropdownContainer);

            const state = row.insertCell()
            const stateTag = document.createElement('span');
            stateTag.classList.add('badge', 'fw-normal', 'rounded-pill', user["enabled"] ? 'bg-success' : 'bg-danger');
            stateTag.textContent = user["enabled"] ? "Enabled" : "Disabled";
            state.appendChild(stateTag);

            const twoFA = row.insertCell()
            const tag2FA = document.createElement('span');
            twoFA.appendChild(tag2FA);
            tag2FA.classList.add('badge', 'fw-normal', 'rounded-pill', user["using2FA"] ? 'bg-success' : 'bg-danger');
            tag2FA.textContent = user["using2FA"] ? "Enabled" : "Disabled";
            if (user["using2FA"]) {
                tag2FA.classList.add('clickable');
                tag2FA.addEventListener('click', async () => modbox.confirm({
                    title: "Disable 2FA?",
                    body: "Are you sure you want to disable 2FA for this user?",
                    center: true,
                    okButton: {
                        label: 'Yes'
                    },
                    closeButton: {
                        label: 'No'
                    },
                    relatedTarget: deleteButton,
                }).then(async () => {
                    setLoading(true);
                    if (await User.disable2FA(user["userId"]))
                        await fetchCurrentPage();
                    setLoading(false);
                }).catch(() => {
                }));

                new bootstrap.Tooltip(tag2FA, {title: "Disable 2FA"});
            }

            const connections = row.insertCell()
            const connectionsRow = document.createElement('div');
            connectionsRow.classList.add('d-flex', 'justify-content-start');
            connections.appendChild(connectionsRow);
            user["connections"].forEach(connection => {
                const connElem = document.createElement('span');
                connElem.classList.add('fs-5', 'me-1');
                connElem.innerHTML = connectionIcons[connection["serviceName"]];
                connectionsRow.appendChild(connElem);
            });
            if (user["connections"].length === 0) {
                connectionsRow.textContent = "NA";
            }

            const actions = row.insertCell()
            const actionsRow = document.createElement('div');
            actionsRow.classList.add('d-flex', 'justify-content-between');
            actions.appendChild(actionsRow);

            // add delete button
            const deleteButton = document.createElement('button');
            actionsRow.appendChild(deleteButton);
            deleteButton.classList.add('btn', 'btn-outline-danger', 'btn-sm');
            deleteButton.textContent = "Delete user";
            deleteButton.addEventListener('click', () => modbox.confirm({
                title: "Delete user",
                body: "Are you sure you want to delete this user?",
                center: true,
                okButton: {
                    label: 'Yes'
                },
                closeButton: {
                    label: 'No'
                },
                relatedTarget: deleteButton,
            }).then(async () => {
                setLoading(true);
                if (await User.delete(user["userId"]))
                    await fetchCurrentPage();
                setLoading(false);
            }).catch(() => {
            }));

            return row;
        };

        const setLoading = (state) => {
            if (state) {
                usersTable.classList.add('d-none');
                loadingSpinner.classList.remove('d-none');
            } else {
                usersTable.classList.remove('d-none');
                loadingSpinner.classList.add('d-none');
            }
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

        const fetchCurrentPage = async () => {
            // show loading spinner
            setLoading(true);
            // fetch the current page
            const data = await User.getAll(currentPage, pageSize);
            // empty the table body
            usersBody.replaceChildren();
            // for each user, create a row and append it to the table
            data.content.forEach(user => usersBody.appendChild(userToRow(user)))
            // if there are no users
            if (data.content.length === 0) {
                usersBody.innerHTML = "<tr><td colspan='8' class='text-center'>There are no users yet</td></tr>";
            }
            // update current and total page count
            currentPage = data["pageable"]["pageNumber"];
            totalPages = data["totalPages"];
            // update the pagination footer
            await updatePagination();
            // hide loading spinner
            setLoading(false);
        };

        // on page load -> fetch the first page
        document.addEventListener("DOMContentLoaded", () => fetchCurrentPage());
    })();
</script>

</body>

</html>