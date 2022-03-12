<#ftl output_format="HTML">
<#import "/spring.ftl" as spring />
<#import "../shared/default.ftl" as default />

<!DOCTYPE html>
<html lang="en">
<@default.head title="Error - STAs"/>
<body>
<@default.navbar />
<div class="container">
    <div class="d-flex align-items-center justify-content-center mt-5 mx-md-5 mx-lg-5-5">
        <div class="card  mb-3 w-75">
            <div class="card-header">
                <div class="d-flex align-items-center justify-content-between">
                    ${errorTitle!"An error has occurred"}
                    <span class="iconify-inline" data-icon="emojione:sad-but-relieved-face" data-width="28"></span>
                </div>
            </div>
            <div class="card-body">
                ${oauthError!authError!error!""}
            </div>
        </div>
    </div>
</div>

<@default.scripts/>
</body>
</html>