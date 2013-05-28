<!DOCTYPE HTML>
<!--
 ~
 ~ Copyright (C) 2012 by Cognitive Medical Systems, Inc (http://www.cognitivemedciine.com)
 ~
 ~ Licensed under the Apache License, Version 2.0 (the "License"); you may not 
 ~ use this file except in compliance with the License. You may obtain a copy of 
 ~ the License at
 ~
 ~     http://www.apache.org/licenses/LICENSE-2.0
 ~
 ~ Unless required by applicable law or agreed to in writing, software distributed 
 ~ under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR 
 ~ CONDITIONS OF ANY KIND, either express or implied. See the License for the
 ~ specific language governing permissions and limitations under the License.
 ~
-->
 
<!--
 ~ Socratic Grid contains components to which third party terms apply. To comply 
 ~ with these terms, the following notice is provided:
 ~
 ~ TERMS AND CONDITIONS FOR USE, REPRODUCTION, AND DISTRIBUTION
 ~ Copyright (c) 2008, Nationwide Health Information Network (NHIN) Connect. All 
 ~ rights reserved.
 ~ Redistribution and use in source and binary forms, with or without 
 ~ modification, are permitted provided that the following conditions are met:
 ~ 
 ~ - Redistributions of source code must retain the above copyright notice, this 
 ~   list of conditions and the following disclaimer.
 ~ - Redistributions in binary form must reproduce the above copyright notice, 
 ~   this list of conditions and the following disclaimer in the documentation 
 ~   and/or other materials provided with the distribution.
 ~ - Neither the name of the NHIN Connect Project nor the names of its 
 ~   contributors may be used to endorse or promote products derived from this 
 ~   software without specific prior written permission.
 ~ 
 ~ THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
 ~ AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
 ~ IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
 ~ ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
 ~ LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
 ~ CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
 ~ SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
 ~ INTERRUPTION HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
 ~ CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
 ~ ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
 ~ POSSIBILITY OF SUCH DAMAGE.
 ~ 
 ~ END OF TERMS AND CONDITIONS
 ~
-->

<html>
<body>

<div style="padding-left:170px">
    <div id="suiteBodyHeader">
        <div class="suiteBodyHeaderTop"><div id="suiteBodyTitle">Request an Account</div></div>
    </div>
    <p>Vivamus vel ipsum quam, vitae posuere tellus. Etiam bibendum diam in odio vitae posuere sollicitudin fringilla. Etiam bibendum
diam in odio sollicitudin fringilla. Upon completion further instructions will be emailed to you/</p>
    <div id="newAcctMessage"></div>

    <div id="newAccountInput" class="primaryLinks">
        <form><input type="hidden" id="action" name="action" value="create"/>
            <!--  Form template:  Make sure all items being serialized() has a NAME attribute -->
        <table class="tblClean inputTable">
            <tr><td><label for="userName">Username</label><span class="suiteFieldReq">&nbsp;</span></td><td style="width:35%"><input id="userName" name="userName" size="25"/></td>
                <td></td><td></td>
            </tr>
            <tr><td><label for="firstName">First Name</label><span class="suiteFieldReq">&nbsp;</span></td><td><input id="firstName" name="firstName" size="25"/></td>
                <td><label for="middleName">Middle Name</label><span class="suiteFieldReq">&nbsp;</span></td><td><input id="middleName" name="middleName" size="25"/></td>
            </tr>
            <tr><td><label for="lastName">Last Name</label><span class="suiteFieldReq">&nbsp;</span></td><td><input id="lastName" name="lastName" size="25"/></td>
                <td><label for="ssn">SSN</label><span class="suiteFieldReq">&nbsp;</span></td><td><input id="ssn" name="ssn" size="25"/></td>
            </tr>
            <tr><td><label for="address1">Address 1</label><span class="suiteFieldReq">&nbsp;</span></td><td><input id="address1" name="address1" size="25"/></td>
                <td><label for="address2">Address 2</label><span class="suiteFieldReq">&nbsp;</span></td><td><input id="address2" name="address2" size="25"/></td>
            </tr>
            <tr><td><label for="city">City</label><span class="suiteFieldReq">&nbsp;</span></td><td><input id="city" name="city" size="25"/></td>
                <td><label for="state">State</label><span class="suiteFieldReq">&nbsp;</span></td><td><input id="state" name="state" size="25"/></td>
            </tr>
            <tr><td><label for="postalCode">Zip Code</label><span class="suiteFieldReq">&nbsp;</span></td><td><input id="postalCode" name="postalCode" size="25"/></td>
                <td><label for="emailAddress">Email</label><span class="suiteFieldReq">&nbsp;</span></td><td><input id="emailAddress" name="emailAddress" size="25" type="email"/></td>
            </tr>
            <tr><td><label for="homePhone">Home Phone</label><span class="suiteFieldReq">&nbsp;</span></td><td><input id="homePhone" name="homePhone" size="25"/></td>
                <td><label for="workPhone">Work Phone</label><span class="suiteFieldReq">&nbsp;</span></td><td><input id="workPhone" name="workPhone" size="25"/></td>
            </tr>
            <tr><td><label for="mobilePhone">Mobile</label><span class="suiteFieldReq">&nbsp;</span></td><td><input id="mobilePhone" name="mobilePhone" size="25"/></td>
                <td></td><td></td>
            </tr>
            <tr><td><label for="password">Password</label><span class="suiteFieldReq">&nbsp;</span></td><td><input id="password" name="password" type="password" size="25"/></td>
                <td><label for="confirmPass">Confirm Password</label><span class="suiteFieldReq">&nbsp;</span></td><td><input id="confirmPass" type="password" size="25"/></td>
            </tr>
            <tr><td></td><td colspan="3"><span id="newAccountMessage">* denotes a required field</span></td></tr>
        </table>
        </form>
        <p id="termsHeading" style="font-weight:bold">Terms of Service</p>
        <div id="descArea" class="contentPadding" style="max-height:120px; overflow-x:hidden; background-color:white; border:1px solid #d3d3d3"></div>
        <p>By clicking on "Request Account" below, you are agreeing to the <a href="#" id="terms">Terms of Service</a> above and the <a href="#" id="privacy">Privacy Policy"</a></p>
        <p><button id="btnSubmit" style="margin-right:20px;">Request Account</button><button id="btnCancel">Cancel</button></p>
    </div>
</div>

<!-- Scripts should be at the end of the HTML so that DOM is loaded -->
<script type="text/javascript">
    $(function($) {
        if (!sirona) return false; // Cannot be loaded without the config
        var _thisView = "newAccount";
        var termsOfService;
        var privacyPolicy;

        // Publishers
        $('#terms').click(function (e) { $.publish('/suite/termsOfService',[],e); });
        $('#privacy').click(function (e) { $.publish('/suite/privacyPolicy',[],e); });
        $('#btnCancel').click(function (e) { $.publish('/suite/navigateView', ['login'], e) });

        // Subscribers
        $.subscribe('/suite/termsOfService',_thisView, function(action) { $('#termsHeading').html('Terms of Service'); $('#descArea').html(termsOfService); });
        $.subscribe('/suite/privacyPolicy',_thisView, function(action) { $('#termsHeading').html('Privacy Policy'); $('#descArea').html(privacyPolicy); });

        // Submit
        $('#btnSubmit').click(function (e) {
            e.preventDefault(); // Prevent first just incase there are errors below
            if ($('#password').val() != $('#confirmPass').val()) {
                alert('Passwords do not match');
                return;
            }
            // Serialize all form inputs that contain a NAME attribute and pass to PS
            sirona.reqPS('setAccount', { view:_thisView, data: $('form').serialize(),
                 success: function(data){
                     alert((data.statusMessage)?data.statusMessage:'Your request has been received.  Please check your email for updates.');
                     $.publish('/suite/navigateView', ['login'])
                 },
                 error: function(data) { alert(data.statusMessage)}
             }, 'setAccountFact', 'POST');
        });

// INITIALIZATION
        $('td:has("label")').css({ 'text-align':'right'});   // Align all cells that contain a label field to the right
        // Load the required fields and style the widget
        sirona.reqPS('getRequiredFields', { view:_thisView, data:{ "apiName":"setAccount" },
            success: function(data) {
                $.each(data.requiredFields, function() {
                    // Find the label element for the field, and add an asterisk in the span element next to it
                    $('label[for="' + this.toString() +'"]+span').html('*');
                });
//                $('#newAccountMessage').html(_test);
            }
        }, 'requiredsFact');

        sirona.localOnce=true;
        sirona.reqPS('getMiscellaneous', { view:_thisView,
            success: function(data) {
                $('#descArea').html(data.termsOfService);
                termsOfService=data.termsOfService;
                privacyPolicy=data.privacyPolicy;
            },
            error: function(data) {
                alert('Error retrieving data: '+data.statusMessage);
            }

        }, 'miscellaneousFact');
    });
</script>
</body>
</html>