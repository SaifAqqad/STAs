<#ftl output_format="HTML">
<#import "/spring.ftl" as spring />
<#import "../shared/default.ftl" as default />
<#import "../shared/account.ftl" as account />

<!DOCTYPE html>
<html lang="en">

<@default.head title="Account information - STAs"/>

<body class="min-vh-100">
<@default.navbar account="active"/>

<div class="container-fluid container-lg my-3">
    <div class="row">
        <#-- Sidebar -->
        <div class="col-md-3">
            <@account.sidebar accountDetails="active"/>
        </div>
        <#-- Main page -->
        <div class="col-md-9 animate__animated animate__fadeIn animate__faster">
            <div class="container mt-2">
                <div class="fs-4 user-select-none"><@default.icon name="accountEdit"/>
                    Account information
                </div>
                <div class="card mt-3">
                    <div class="card-body">
                        <#if !(accountDetails.email?has_content)>
                            <div class="text-danger fw-bold fs-6">
                                To avoid losing access to your account, please add an email below.
                            </div>
                        </#if>
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
    </div>
</div>

<@default.toast/>
<@default.scripts/>
</body>
</html>