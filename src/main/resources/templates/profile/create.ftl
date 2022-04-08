<#ftl output_format="HTML">
<#import "/spring.ftl" as spring />
<#import "../shared/default.ftl" as default />

<!DOCTYPE html>
<html lang="en">

<@default.head title="Login - STAs">
</@default.head>
<script type='text/javascript'>
    function addFields(){
        // Generate a dynamic number of inputs
        var number = document.getElementById("member").value;
        // Get the element where the inputs will be added to
        var container = document.getElementById("container");
        // Remove every children it had before
        while (container.hasChildNodes()) {
            container.removeChild(container.lastChild);
        }
        for (i=0;i<number;i++){
            // Append a node with a random text
            container.appendChild(document.createTextNode("Member " + (i+1)));
            // Create an <input> element, set its type and name attributes
            var input = document.createElement("input");
            input.type = "text";
            input.name = "member" + i;
            container.appendChild(input);
            // Append a line break
            container.appendChild(document.createElement("br"));
        }
    }
</script>
<body>
<@default.navbar login="active"/>
<#assign loginError = authError?? && RequestParameters.error??/>

<div class="container rounded bg-white mt-5 mb-5">
    <div class="row">

        <div class="col-md-12 border-right">
            <div class="p-3 py-5">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h4 class="text-right">Profile Create</h4>
                </div>

                <div class="row mt-3">
                    <div class="col-md-12"><label class="labels">Full Name</label><input type="text" class="form-control" placeholder="Full Name" value=""></div>
                    <div class="col-md-12"><label class="labels">Email ID</label><input type="text" class="form-control" placeholder="enter email id" value=""></div>
                    <div class="col-md-12"><label class="labels">Mobile Number</label><input type="text" class="form-control" placeholder="enter phone number" value=""></div>
                    <div class="col-md-12"><label class="labels">university</label><input type="text" class="form-control" value="" placeholder="university"></div>
                    <div class="col-md-12"><label class="labels">major</label><input type="text" class="form-control" placeholder="major" value=""></div>
                    <div class="col-md-12"><label class="labels">location</label><input type="text" class="form-control" placeholder="location" value=""></div>

                </div>


                <div class="mb-3">
                    <label for="About" class="form-label labels">About</label>
                    <textarea class="form-control" id="About" rows="3"></textarea>
                </div>
                <div class="mt-5 text-center"><button class="btn btn-primary" type="button">Save Profile</button></div>
            </div>
        </div>

    </div>
</div>
</div>
</div>

<@default.scripts/>
</body>
</html>
