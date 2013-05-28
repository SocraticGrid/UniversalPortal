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
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <!--<link rel="stylesheet" type="text/css" href="css/jquery.cleditor.css" />-->
    <!--<link rel="stylesheet" type="text/css" href="css/jquery.wysiwyg.css" />-->
    <link type="text/css" rel="stylesheet" href="css/jquery.rte.css" />
</head>
<body>
    <div id="suiteBodyHeader">
        <div class="suiteBodyHeaderTop">
            <div id="suiteBodyTitle">Compose</div>
            <div id="inboxButtons" class="suiteBodyHeaderButtonsR">
                <button>Send</button>
                <button>Save Draft</button>
                <button>Discard</button>
                <button>Attach</button>
                <button style="margin-left:20px">Print</button>
            </div>
        </div>
    </div>
    <div id="suiteBody">
    <div id="suiteSplitBottom">
        <div id="suiteBodyHeaderBottom">
            <div id="inboxDetailHeader" class="suiteSplitBottomDetail lightBG">
                <table class="tblClean inputTable lightBG">
                     <!--<tr><td class="inputLabel">From:</td><td id="inboxMessageFrom"></td></tr>-->
                     <tr><td class="inputLabel"><a href="#" class="primaryText">To:</a></td><td><span id="sendTo"></span></td></tr>
                     <tr><td class="inputLabel"><label for="inboxSubject">Subject:</label></td><td><input id="inboxSubject" style="border:1px solid #ccc;" size="100"/></td></tr>
                     <tr><td class="inputLabel"><a href="#" class="primaryText">CC:</a></td><td><span id="ccTo"></span></td></tr>
                 </table>
            </div>
        </div>
            <div id="inboxDetail">
                <textarea id="inboxDetailInput"></textarea>
            </div>
        </div>
    </div>

<!-- Scripts should be at the end of the HTML so that DOM is loaded -->
<script type="text/javascript" src="js/jquery.rte2.js"></script>
<script type="text/javascript" src="js/jquery.rte.tb.js"></script>

<!--  Almost works, but sizing needs to be fixed <script type="text/javascript" src="js/jquery.cleditor.min.js"></script>-->
<!--  Terrible incompatibility with CSS <script type="text/javascript" src="js/jquery.wysiwyg.js"></script>-->
<!--<script type="text/javascript" src="js/wysiwyg.image.js"></script>-->
<!--<script type="text/javascript" src="js/wysiwyg.link.js"></script>-->
<script type="text/javascript">
    $(document).ready (function($) {
        if (!sirona) return false; // Cannot be loaded without the config
        var _thisView = 'inboxCompose';
        var _draftFlag=true;

// SUBSCRIBERS
        $.subscribe('/addressBook/selected',_thisView, function(contactIds) {
            _contactsTo.html(contactIds);
        });
        $.subscribe('/suite/contentResized', _thisView, function(resizeObj) {
//$.publish( '/suite/debug', [ new Date() +  ': inboxcompose :' + resizeObj.suiteSplitBottomH  +'/'+ resizeObj.suiteBodyHeaderBottomH +'/'+ $('.rte-toolbar').height() ] );
             $('#inboxDetailInput').css({ 'height':resizeObj.suiteSplitBottomH  - resizeObj.suiteBodyHeaderBottomH - $('.rte-toolbar').outerHeight() });
        });
        $.subscribe('/suite/unloadView', _thisView, function(viewUnloading) {
            if (_draftFlag && _thisView==viewUnloading && confirm(sirona.confirmDraft)) setMessages('Save Draft');
        });

// PUBLISHERS
        $('#suiteBodyHeaderBottom a').click(function (e) {
            e.preventDefault();
            // Save which element was clicked so that when the dialog closes, we know where the selected contacts should go
            if ($(e.target).html() == 'To:') _contactsTo=$('#sendTo'); else _contactsTo=$('#ccTo');

            showDialog('dialogSelectAddressBook', { width:400 });
        });

        $('#inboxButtons button').click ( function(e) {
            // Executes when a Action button (Send, Save, Discard... is pressed
            if ('attach|print'.indexOf($(this).text().toLowerCase()) >= 0) $.publish('/suite/notImpl');
            else setMessages(e.target.innerHTML);
        });
        function setMessages(setAction) {
            if (setAction=='Discard') {
                if (!confirm(sirona.confirmDiscard)) return;
                _draftFlag=false;
                sirona.getView('inbox', { data:{location:sirona.viewData.inboxCompose.location} } );
                return;
            }

            if (setAction=='Send' &&  $('#sendTo').html()==''){
                alert('No contacts chosen to send to.');
                return;
            }

            // Build the data object for the requested action
            var _data = { patientId:sirona.patient.id, 'messageId':sirona.viewData.inboxCompose.messageId, 'action':setAction, 'location':sirona.viewData.inboxCompose.location, 'types':'Email',
                    'sendTo':$('#sendTo').html(), 'subject':$('#inboxSubject').val(), 'body':_editor['inboxDetailInput'].get_content() };
            if ($('#ccTo').text() != '') _data.CCTo = $('#ccTo').text();
            if (setAction=='Save Draft') _data.action='Save';

            sirona.reqPS('setMessages', { view:_thisView, data: _data,
                success: function(data){
                    _draftFlag = false;
                    sirona.getView('inbox', { data:{location:sirona.viewData.inboxCompose.location}} );
                }
            }, 'setMessagesFact', 'POST');
        }

// INITIALIZATION
        var _contactsTo;
//        alert('compose: '+ concatObject(sirona.viewData.inboxCompose));
        var _action = (sirona.viewData.inboxCompose.action || 'save').toLowerCase();
        var _subject = sirona.viewData.inboxCompose.title || '';
        if (_action.indexOf('reply')>=0){
            _subject='Re: '+_subject;
            $('#sendTo').html(sirona.viewData.inboxCompose.from);
            if (_action=='reply all') $('#ccTo').html($.distinct($.merge(sirona.viewData.inboxCompose.sentTo,sirona.viewData.inboxCompose.CCTo)).join(','));
        } else
            if (_action=='forward') _subject='Fw: '+_subject;
        else
            if (sirona.patient.id) $('#sendTo').html(sirona.patient.contactId);

        $('#inboxSubject').val(_subject);

        // Load the RTF editor here
        var _editor = $('#inboxDetailInput').rte( {
            height:200,
            controls_rte: rte_toolbar,
            controls_html: html_toolbar
        });
        _editor['inboxDetailInput'].set_content(sirona.viewData.inboxCompose.body);

     });
</script>
</body>
</html>