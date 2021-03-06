<#ftl output_format="HTML">
<#import "/spring.ftl" as spring />
<#import "../../shared/default.ftl" as default />
<#import "shared.ftl" as shared/>
<#import "components/contactInfo.ftl" as contactInfo/>
<#import "components/about.ftl" as about/>
<#import "components/education.ftl" as education/>
<#import "components/project.ftl" as project/>
<#import "components/experience.ftl" as experience/>
<#import "components/submit.ftl" as submit/>


<!DOCTYPE html>
<html lang="en">

<@default.head title="Create your portfolio - STAs">
    <link rel="stylesheet" href="<@spring.url "/css/tabs.css"/>"/>
</@default.head>

<body class="min-vh-100">
<@default.navbar profile="active"/>

<div class="container-fluid container-sm mb-3 animate__animated animate__fadeIn animate__faster">
    <div class="d-flex flex-column align-items-center mt-5 mx-md-5">

        <div class="d-flex flex-column align-items-center mb-2">
            <h2>Welcome to STAs</h2>
            <div class="text-muted fs-5 mb-3">Create your portfolio</div>
        </div>


        <div class="d-flex mb-3">
            <button data-tab-index="0" class="p-2 me-1 border rounded-circle"></button>
            <button data-tab-index="1" class="p-2 me-1 border rounded-circle"></button>
            <button data-tab-index="2" class="p-2 me-1 border rounded-circle"></button>
            <button data-tab-index="3" class="p-2 me-1 border rounded-circle"></button>
            <button data-tab-index="4" class="p-2 me-1 border rounded-circle"></button>
            <button data-tab-index="5" class="p-2 me-1 border rounded-circle"></button>
        </div>

        <div class="tabs w-100 w-lg-75 w-xl-50">
            <div class="tab tab-hidden animate__fast w-100" data-tab-index="0"><@contactInfo.card/></div>
            <div class="tab tab-hidden animate__fast w-100" data-tab-index="1"><@about.card/></div>
            <div class="tab tab-hidden animate__fast w-100" data-tab-index="2"><@education.card/></div>
            <div class="tab tab-hidden animate__fast w-100" data-tab-index="3"><@experience.card/></div>
            <div class="tab tab-hidden animate__fast w-100" data-tab-index="4"><@project.card/></div>
            <div class="tab tab-hidden animate__fast w-100" data-tab-index="5"><@submit.card/></div>
        </div>

    </div>
</div>

<@default.scripts/>
<@shared.scripts/>
<@contactInfo.script/>
<@about.script/>
<@education.script/>
<@project.script/>
<@experience.script/>
<@submit.script/>
</body>

</html>