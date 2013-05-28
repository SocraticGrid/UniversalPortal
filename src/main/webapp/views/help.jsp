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
<div>
    <div id="suiteBodyHeader">
        <div class="suiteBodyHeaderTop"><div id="suiteBodyTitle">Help</div></div>
    </div>

    <p>Vivamus vel ipsum quam, vitae posuere tellus. Etiam bibendum diam in odio vitae posuere sollicitudin fringilla. Etiam bibendum
diam in odio sollicitudin fringilla</p>

    <h3>Search</h3>
    <label for="helpSearch"></label><input id="helpSearch" size="50"/>
    <button style="margin-right:20px;">Search</button>

    <h4>Search results:</h4>
    <div id="helpResults">
Vitae posuere tellus. Etiam bibendum diam in odio sollicitudin fringilla. Maecenas condimentum lectus ac erat sodales convallis. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.Vivamus vel ipsum quam,
vitae posuere tellus. Etiam bibendum diam in odio sollicitudin fringilla. Maecenas condimentum lectus ac erat sodales convallis. Pellentesque habitant senectus et netus et condimentum lectus ac erat sodales convallis. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas
    </div>
</div>

<!-- Scripts should be at the end of the HTML so that DOM is loaded -->
<script type="text/javascript">
    $(function() {
        if (!sirona) return false; // Cannot be loaded without the config

        $('#btnCancel').click(function (e) { $.publish('/suite/navigateView', ['login'], e) });
    });
</script>
</body>
</html>