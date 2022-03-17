<#ftl output_format="HTML">
<#import "/spring.ftl" as spring />
<#import "../shared/default.ftl" as default/>
<#import "../shared/account.ftl" as account/>

<!DOCTYPE html>
<html lang="en">
<@default.head title="Account security - STAs" />

<body>
<@default.navbar account="active"/>

<div class="container-fluid my-3">
    <div class="row">
        <div class="col-sm-3">
            <@account.sidebar accountSecurity="active"/>
        </div>
        <div class="col-sm-9">
            <div class="container mt-2">
                <h4>Account security</h4>
                <div class="container">
                    <div class="card mt-3">
                        <div class="card-body">
                            <h6>Change your password</h6>
                            <form action="<@spring.url "/account/security/update"/>" method="post">
                                <@default.csrfInput/>
                                <div class="form-floating mt-3">
                                    <@account.formElement path="passwordForm.currentPassword" label="Current password" type="password" attrb=(currentPasswordDisabled??)?then("disabled","") placeholder="Current password" bindValue=false />
                                </div>
                                <div class="form-floating mt-3">
                                    <@account.formElement path="passwordForm.newPassword" label="New password" type="password" attrb="required" placeholder="New password" bindValue=false/>
                                </div>
                                <div class="form-floating mt-3">
                                    <input class="form-control" name="confirmNewPassword" id="confirmNewPassword"
                                           required
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
                    <div class="card mt-3">
                        <div class="card-body">
                            <h6 class="mb-0">
                                Two-factor authentication
                                <span class="form-check-inline form-switch mx-2 mb-1">
                                      <input class="form-check-input" type="checkbox" role="switch"
                                             id="twoFactorSwitch" aria-label="Two-factor authentication">
                                </span>
                            </h6>
                            <#if twoFactorSecret??>
                                <div class="card-text">
                                    Scan this QR code with your authenticator app (e.g. Google Authenticator).
                                    <br>
                                    If you can't scan the QR code, click the button below it to reveal the secret then
                                    enter it in the authenticator app.
                                </div>
                                <div class="card text-center mt-3" style="width: 256px;">
                                    <img src="https://chart.googleapis.com/chart?cht=qr&chs=256x256&chld=H|0&chl=FDSHJ476DJKJ2438RFJ534535fdfgfdgdg"
                                         class="img-fluid rounded" width="256" alt="QR Code">
                                    <button class="btn btn-primary rounded-0 rounded-bottom">Reveal secret</button>
                                </div>
                            </#if>
                            <form id="form_2fa" action="<@spring.url "/account/security/set-2fa"/>"
                                  class="visually-hidden"
                                  action="<@spring.url "/account/security/set-2fa"/>" method="post">
                                <@default.csrfInput/>
                                <input type="hidden" id="twoFactorState" name="state"/>
                                <input type="hidden" id="twoFactorCode" name="code"/>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<@account.confirmPasswordScript passwordId="newPassword" confirmPasswordId="confirmNewPassword" confirmPasswordFeedbackId="confirmNewPasswordFeedback"/>
<@default.scripts />
<@default.toast />
<script>
    const twoFactorSwitch = document.getElementById("twoFactorState");
    twoFactorSwitch.addEventListener("click", function (e) {


    })
</script>
</body>
</html>