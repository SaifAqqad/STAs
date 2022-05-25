<#import "../shared.ftl" as shared/>

<#macro card>
    <div id="contactInfoCard" class="card rounded-3 user-select-none w-100">
        <div class="card-body">
            <h6 class="card-title mb-1">Tell us about yourself</h6>
            <div class="form-floating mt-3">
                <input class="form-control" required type="text" data-profile-prop="name" id="name"
                       placeholder="Name">
                <label class="form-label text-muted" for="name">Name</label>
            </div>
            <div class="form-floating mt-3">
                <input class="form-control" type="text" data-profile-prop="location" id="location"
                       placeholder="Location">
                <label class="form-label text-muted" for="location">Location</label>
            </div>
            <div class="form-floating mt-3">
                <input class="form-control" required type="email" data-profile-prop="contactEmail"
                       id="contactEmail" placeholder="Email">
                <label class="form-label text-muted" for="contactEmail">Email</label>
            </div>
            <div class="form-floating mt-3">
                <input class="form-control" type="text" data-profile-prop="contactPhone" id="contactPhone"
                       placeholder="Phone number">
                <label class="form-label text-muted" for="contactPhone">Phone number</label>
            </div>
            <div class="mt-4 clearfix">
                <@shared.nextBtn id="contactInfoNext"/>
            </div>
        </div>
    </div>
</#macro>

<#macro script>
    <script>
        (() => {
            const tabsContainer = document.querySelector('.tabs');
            const card = document.querySelector('#contactInfoCard');
            const currentTab = card.parentElement;

            // validate the form
            const validate = () => {
                let isValid = true;
                card.querySelectorAll("[data-profile-prop]").forEach(input => {
                    if (input.reportValidity()) {
                        input.classList.remove('is-invalid');
                    } else {
                        _animateCSS(input, 'headShake');
                        input.classList.add('is-invalid');
                        input.addEventListener('input', () => input.classList.remove('is-invalid'), {once: true});
                        isValid = false;
                    }
                });
                return isValid;
            };

            // when the tab is changing, validate and save the form
            tabsContainer.addEventListener('tab-changing', (event) => {
                // if we're not the active tab -> don't handle it
                if (!currentTab.classList.contains('tab-active'))
                    return;
                if (validate()) {
                    card.querySelectorAll("[data-profile-prop]").forEach(element => {
                        Profile.setItem(element.getAttribute("data-profile-prop"), element.value);
                    });
                    Profile.saveProfile();
                } else {
                    event.preventDefault();
                }
            });

            // when the profile data is loaded, fill the form
            document.addEventListener("profile-loaded", () => {
                card.querySelectorAll("[data-profile-prop]").forEach(element => {
                    element.value = Profile.getItem(element.getAttribute("data-profile-prop")) || "";
                })
            });
        })()
    </script>
</#macro>
