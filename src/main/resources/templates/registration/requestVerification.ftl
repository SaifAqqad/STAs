<#ftl output_format="HTML">
<#import "/spring.ftl" as spring />
<#import "../shared/default.ftl" as default />
<#import "../shared/account.ftl" as register/>

<!DOCTYPE html>
<html lang="en">
<@default.head title="Request a verification code - STAs"/>
<body>
<@default.navbar />

<div class="container mt-3">
    <div class="d-flex align-items-center justify-content-center mt-5 mx-md-5">
        <div class="card text-dark bg-light mb-3 w-75">
            <div class="card-header">Request a verification code</div>
            <div class="card-body">
                <form method="post">
                    <@default.csrfInput/>
                    <div class="form-floating mt-3">
                        <input class="form-control" type="email" name="email" id="email" placeholder="Email" required >
                        <label class="form-label text-muted" for="email">Email</label>
                    </div>
                    <div class="mt-3">
                        <input class="btn btn-primary" value="Request" type="submit"/>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<@default.scripts/>
</body>
</html>