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
                <div class="container mt-3">
                    <h6>Change password</h6>
                    <form action="<@spring.url "/account/security/update"/>" method="post">
                        <@default.csrfInput/>
                        <div class="form-floating mt-3">
                            <@account.formElement path="passwordForm.currentPassword" label="Current password" type="password" attrb="required" placeholder="Current password" bindValue=false />
                        </div>
                        <div class="form-floating mt-3">
                            <@account.formElement path="passwordForm.newPassword" label="New password" type="password" attrb="required" placeholder="New password" bindValue=false/>
                        </div>
                        <div class="form-floating mt-3">
                            <input class="form-control" name="confirmNewPassword" id="confirmNewPassword" required
                                   placeholder="Confirm password" type="password"/>
                            <label class="form-label" for="confirmNewPassword">Confirm password</label>
                            <span class="invalid-feedback" id="confirmNewPasswordFeedback"></span>
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

<@account.confirmPasswordScript passwordId="newPassword" confirmPasswordId="confirmNewPassword" confirmPasswordFeedbackId="confirmNewPasswordFeedback"/>
<@default.scripts />
<@default.toast />
</body>
</html>