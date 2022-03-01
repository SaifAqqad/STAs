<#ftl output_format="HTML">
<#import "/spring.ftl" as spring />
<#import "../shared/default.ftl" as default />
<#import "../shared/account.ftl" as account />

<!DOCTYPE html>
<html lang="en">

<@default.head title="Account information - STAs"/>

<body>
<@default.navbar account="active"/>

<div class="container-fluid mt-3">
    <div class="row">
        <#-- Sidebar -->
        <div class="col-sm-3">
            <@account.sidebar accountDetails="active"/>
        </div>
        <#-- Main page -->
        <div class="col-sm-9">
            <div class="container mt-2">
                <h4>Account information</h4>
                <form class="" action="<@spring.url "/account/update"/>" method="post">
                    <@default.csrfInput/>
                    <div class="row">
                        <div class="col">
                            <div class="form-floating mt-3">
                                <@account.formElement path="accountDetails.firstName" label="First Name" attrb="required " placeholder="First Name" />
                            </div>
                        </div>
                        <div class="col">
                            <div class="form-floating mt-3">
                                <@account.formElement path="accountDetails.lastName" label="Last Name" attrb="required" placeholder="Last Name" />
                            </div>
                        </div>
                    </div>
                    <div class="form-floating mt-3">
                        <@account.formElement path="accountDetails.email" label="Email" type="email" attrb="required" placeholder="Email" />
                    </div>
                    <div class="form-floating mt-3">
                        <@account.formElement path="accountDetails.dateOfBirth" label="Date of birth" type="date" attrb="required" placeholder="Date of birth" />
                    </div>
                    <div class="mt-3">
                        <input class="btn btn-outline-primary" value="Save" type="submit">
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<@default.toast/>
<@default.scripts/>
</body>
</html>