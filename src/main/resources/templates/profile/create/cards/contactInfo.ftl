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
                <input class="form-control" type="text" data-profile-prop="contactPhone" id="contactPhone"
                       placeholder="Phone number">
                <label class="form-label text-muted" for="contactPhone">Phone number</label>
            </div>
            <div class="form-floating mt-3">
                <input class="form-control" type="email" data-profile-prop="contactEmail"
                       id="contactEmail" placeholder="Email">
                <label class="form-label text-muted" for="contactEmail">Email</label>
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

            const validate = () => {
                let isValid = true;
                card.querySelectorAll("[data-profile-prop]").forEach(input => {
                    if (input.reportValidity()) {
                        input.classList.remove('is-invalid');
                    } else {
                        _animateCSS(input, 'headShake');
                        input.classList.add('is-invalid');
                        isValid = false;
                    }
                });
                return isValid;
            };

            card.querySelectorAll("[data-profile-prop]").forEach(input => {
                input.addEventListener('input', () => input.classList.remove('is-invalid'));
            });

            tabsContainer.addEventListener('tab-changing', (event) => {
                if (currentTab.classList.contains('tab-hidden'))
                    return;
                if (validate()) {
                    // TODO: save data to shared profile object
                    console.log('saving data');
                } else {
                    event.preventDefault();
                }
            });
        })()
    </script>
</#macro>
