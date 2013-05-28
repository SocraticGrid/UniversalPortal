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
<%@page import="org.socraticgrid.universalportal.config.Configuration" %>
<%
Configuration cfg = Configuration.getInstance();
String username = cfg.getProperty(Configuration.PROPERTY_NAME.PREDEFINED_USER);
String password = cfg.getProperty(Configuration.PROPERTY_NAME.PREDEFINED_PASSWORD);
%>
<html>
<body>
<div id="loginMain">
    <div class="homeContent" style="height:340px; background:url('images/Home-Page-Image-2.jpg');background-repeat:no-repeat;background-position:right top">
        <div id="loginInput" style="width:50%">
            <form id="loginForm">
            <table class="tblClean tblCenter inputTable primaryLinks">
                <tr><td colspan="3" style="padding-top:95px">
                    <div style="text-align:center;padding-bottom:15px">
                        <div style="font-family:serif;font-size:38px;line-height:40px" class="primaryText">Partners in Health</div>
                        <span> For patients and health care providers,<br/>vitae vel posuere tellus etiam</span>
                    </div>
                </td></tr>
                <tr><td style="width:65px"><label for="userName">Username</label></td><td><input id="userName" value="<%=username%>"/></td><td rowspan="3" style="vertical-align:middle;"><img id="formSubmit" src="images/loginTransparent.png"/></td></tr>
                <tr><td><label for="userPass">Password</label></td><td><input id="userPass" type="password" value="<%=password%>"/></td></tr>
                <tr><td><label for="userCAC">or CAC</label></td><td><input id="userCAC" type="password"/><img src="images/Question-mark-icon.png" style="padding-left:5px"/></td></tr>
                <!--<tr><td id="loginMessage" class="suiteErrorText" colspan="3"></td> </tr>-->

                <tr><td colspan="3"><a id="forgotPass" href="#">Request new password?</a><span style="padding:0 10px">|</span><a id="newAccount" href="#">Request an account</a></td></tr>
                <tr></tr>
            </table>
            </form>
            <div id="loginMessage" class="suiteErrorText"></div>
        </div>
    </div>
</div>
<div id="miscInfo" class="homeContent" style="padding:15px 0">
    <table class="tblClean primaryLinks tblCenter" style="width:100%">
        <tr><td colspan="2" style="width:50%"></td><td colspan="2" style="width:50%"></td></tr>
        <tr><td></td><td style="line-height:40px"><a href="#" style="font-size:18px" onclick="$.publish('/suite/navigateView', ['about'], event)">About Socratic Grid</a></td>
            <td></td><td style="line-height:40px"><a href="#" style="font-size:18px" onclick="$.publish('/suite/navigateView', ['medicalNews'], event)">Recent Medical News</a></td></tr>
        <tr>
            <td id="aboutImage" style="min-width:170px;text-align:center"></td><td id="aboutInfo" style="padding-right:20px"></td>
            <td id="newsImage" style="min-width:170px;text-align:center;border-left:1px solid #ccc"></td><td id="newsInfo" style="padding-right:20px"></td>
        </tr>
    </table>
</div>

<!-- Scripts should be at the end of the HTML so that DOM is loaded -->
<script type="text/javascript">
    $(function($) {
        if (!sirona) return false; // Cannot be loaded without a template which loads the global namespace
        var _thisView = 'login';

        $('td:has("label")').css({ 'text-align':'right'});   // Align all cells that contain a label field to the right
        //<!-- Load the images and css for this widget -->
        $('#aboutImage').prepend('<img src="images/aboutSG.jpg"/>');
        $('.miscImg').css({'float':'left', 'marginTop':'55px'});
        $('#newsImage').prepend('<img src="images/Recent-News.jpg" style="border-left:1px solid #ccc"/>');
        $('.miscInfo').css({'float':'left', 'width':'340px'});

        sirona.localOnce=true;
        sirona.reqPS('getMiscellaneous', { view:_thisView,
            success: function(data) {
                $('#aboutInfo').html(data.aboutSummary);
                $('#newsInfo').html(data.newsSummary);
            }
        }, 'miscellaneousFact');

        // Publishers
        $('#newAccount').click(function (e) { $.publish('/suite/navigateView', ['newAccount'], e) });
        $('#forgotPass').click(function (e) { $.publish('/suite/navigateView', ['forgotPassword'], e) });

        $('#formSubmit').click(function (e) {
            e.preventDefault();

            // Validate form submission against Presentation Services
            sirona.reqPS('validateAccount', { view:_thisView, data:{ userName:$('#userName').val(), password:$('#userPass').val() },  // TODO SHA1 this??
                success: function(data) {
                    if (data.successStatus) {
                        var _url = ((data.role)?data.role:'patient') + '.jsp?userId=' + data.userId + '&token=' + data.token;
                        if (data.providerId) _url += '&providerId=' + data.providerId;
                        window.location.replace(_url);
                    } else {
                        $('#loginMessage').html(data.statusMessage);
                    }
                },
                error: function(data) { $('#loginMessage').html(data.statusMessage); }
            }, 'validateAccountFact', 'GET', true);
            return false;
        });
        $('#loginForm input').keypress(function(e){ if (e.which==13) $('#formSubmit').click(); });  // Enter/Return key submits the form also
    });
</script>
</body>
</html>