<#ftl output_format="HTML">
<#import "/spring.ftl" as spring />
<#import "../shared/default.ftl" as default/>
<#import "../shared/account.ftl" as account/>

<!DOCTYPE html>
<html lang="en">
<@default.head title="Account security - STAs" />

<body>
<@default.navbar account="active"/>

<div class="container-fluid mt-3">
    <div class="row">
        <div class="col-sm-3">
            <@account.sidebar accountSecurity="active"/>
        </div>
        <div class="col-sm-9">
            <div class="container mt-2">
                <h4>Account security</h4>
            </div>
        </div>
    </div>
</div>

<@default.scripts />
<@default.toast />
</body>
</html>