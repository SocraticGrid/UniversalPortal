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
<div class="homeContent">
    <table class="tblClean primaryLinks" style="width:100%">
        <tr><td colspan="2" style="width:50%"></td><td colspan="2" style="width:50%"></td></tr>
        <tr><td></td><td><h3 style="line-height:40px;padding-left:20px"><a href="#">About Sirona</a></h3></td>
            <td></td><td><h3 style="line-height:40px;padding-left:20px"><a href="#">Recent Medical News</a></h3></td></tr>
        <tr>
            <td id="aboutImage"></td><td id="aboutInfo" style="padding:0 20px"></td>
            <td id="newsImage"></td><td id="newsInfo" style="padding-left:20px"></td>
        </tr>
    </table>
</div>
<!-- Script to load data should be at the end of the HTML so that DOM is loaded -->
<script type="text/javascript">
    $(function($) {
        if (!sirona) return false; // Cannot be loaded without the config
        var _thisView = 'misc';

        // <!-- Load the images and css for this widget -->
        $('#aboutImage').prepend('<img src="' + Website.global.images + 'aboutSirona.jpg"/>')
        $('.miscImg').css({'float':'left', 'marginTop':'55px'});
        $('#newsImage').prepend('<img src="' + Website.global.images + 'Recent-News.jpg" style="padding-left:20px; border-left:1px solid #ccc"/>')
        $('.miscInfo').css({'float':'left', 'width':'340px'});

        sirona.localOnce=true;
        sirona.reqPS('getMiscellaneous', { view:_thisView,
            success: function(data) {
                $('#aboutInfo').html(data.about);
                $('#newsInfo').html(data.news);
            },
            error: function(data) {
                $('#aboutInfo').html('An error occurred retrieving the data');
                $('#newsInfo').html('An error occurred retrieving the data');
            }

        }, 'miscellaneousFact');

    });
</script>
</body>
</html>