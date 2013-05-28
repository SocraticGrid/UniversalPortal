/*******************************************************************************
 *
 * Copyright (C) 2012 by Cognitive Medical Systems, Inc (http://www.cognitivemedciine.com)
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not 
 * use this file except in compliance with the License. You may obtain a copy of 
 * the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed 
 * under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR 
 * CONDITIONS OF ANY KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations under the License.
 *
 ******************************************************************************/
 
 /******************************************************************************
 * Socratic Grid contains components to which third party terms apply. To comply 
 * with these terms, the following notice is provided:
 *
 * TERMS AND CONDITIONS FOR USE, REPRODUCTION, AND DISTRIBUTION
 * Copyright (c) 2008, Nationwide Health Information Network (NHIN) Connect. All 
 * rights reserved.
 * Redistribution and use in source and binary forms, with or without 
 * modification, are permitted provided that the following conditions are met:
 * 
 * - Redistributions of source code must retain the above copyright notice, this 
 *   list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice, 
 *   this list of conditions and the following disclaimer in the documentation 
 *   and/or other materials provided with the distribution.
 * - Neither the name of the NHIN Connect Project nor the names of its 
 *   contributors may be used to endorse or promote products derived from this 
 *   software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
 * INTERRUPTION HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
 * POSSIBILITY OF SUCH DAMAGE.
 * 
 * END OF TERMS AND CONDITIONS
 *
 ******************************************************************************/

var urlParams = {};
(function () {
    var e,
        a = /\+/g,  // Regex for replacing addition symbol with a space
        r = /([^&=]+)=?([^&]*)/g,
        d = function (s) { return decodeURIComponent(s.replace(a, " ")); },
        q = window.location.search.substring(1);

    while (e = r.exec(q))
       urlParams[d(e[1])] = d(e[2]);
})();

// Minified SHA1 function from http://www.webtoolkit.info/javascript-sha1.html
function SHA1(msg){function rotate_left(n,s){var t4=(n<<s)|(n>>>(32-s));return t4;};function lsb_hex(val){var str="";var i;var vh;var vl;for(i=0;i<=6;i+=2){vh=(val>>>(i*4+4))&0x0f;vl=(val>>>(i*4))&0x0f;str+=vh.toString(16)+vl.toString(16);}
return str;};function cvt_hex(val){var str="";var i;var v;for(i=7;i>=0;i--){v=(val>>>(i*4))&0x0f;str+=v.toString(16);}
return str;};function Utf8Encode(string){string=string.replace(/\r\n/g,"\n");var utftext="";for(var n=0;n<string.length;n++){var c=string.charCodeAt(n);if(c<128){utftext+=String.fromCharCode(c);}
else if((c>127)&&(c<2048)){utftext+=String.fromCharCode((c>>6)|192);utftext+=String.fromCharCode((c&63)|128);}
else{utftext+=String.fromCharCode((c>>12)|224);utftext+=String.fromCharCode(((c>>6)&63)|128);utftext+=String.fromCharCode((c&63)|128);}}
return utftext;};var blockstart;var i,j;var W=new Array(80);var H0=0x67452301;var H1=0xEFCDAB89;var H2=0x98BADCFE;var H3=0x10325476;var H4=0xC3D2E1F0;var A,B,C,D,E;var temp;msg=Utf8Encode(msg);var msg_len=msg.length;var word_array=new Array();for(i=0;i<msg_len-3;i+=4){j=msg.charCodeAt(i)<<24|msg.charCodeAt(i+1)<<16|msg.charCodeAt(i+2)<<8|msg.charCodeAt(i+3);word_array.push(j);}
switch(msg_len%4){case 0:i=0x080000000;break;case 1:i=msg.charCodeAt(msg_len-1)<<24|0x0800000;break;case 2:i=msg.charCodeAt(msg_len-2)<<24|msg.charCodeAt(msg_len-1)<<16|0x08000;break;case 3:i=msg.charCodeAt(msg_len-3)<<24|msg.charCodeAt(msg_len-2)<<16|msg.charCodeAt(msg_len-1)<<8|0x80;break;}
word_array.push(i);while((word_array.length%16)!=14)word_array.push(0);word_array.push(msg_len>>>29);word_array.push((msg_len<<3)&0x0ffffffff);for(blockstart=0;blockstart<word_array.length;blockstart+=16){for(i=0;i<16;i++)W[i]=word_array[blockstart+i];for(i=16;i<=79;i++)W[i]=rotate_left(W[i-3]^W[i-8]^W[i-14]^W[i-16],1);A=H0;B=H1;C=H2;D=H3;E=H4;for(i=0;i<=19;i++){temp=(rotate_left(A,5)+((B&C)|(~B&D))+E+W[i]+0x5A827999)&0x0ffffffff;E=D;D=C;C=rotate_left(B,30);B=A;A=temp;}
for(i=20;i<=39;i++){temp=(rotate_left(A,5)+(B^C^D)+E+W[i]+0x6ED9EBA1)&0x0ffffffff;E=D;D=C;C=rotate_left(B,30);B=A;A=temp;}
for(i=40;i<=59;i++){temp=(rotate_left(A,5)+((B&C)|(B&D)|(C&D))+E+W[i]+0x8F1BBCDC)&0x0ffffffff;E=D;D=C;C=rotate_left(B,30);B=A;A=temp;}
for(i=60;i<=79;i++){temp=(rotate_left(A,5)+(B^C^D)+E+W[i]+0xCA62C1D6)&0x0ffffffff;E=D;D=C;C=rotate_left(B,30);B=A;A=temp;}
H0=(H0+A)&0x0ffffffff;H1=(H1+B)&0x0ffffffff;H2=(H2+C)&0x0ffffffff;H3=(H3+D)&0x0ffffffff;H4=(H4+E)&0x0ffffffff;}
var temp2=cvt_hex(H0)+cvt_hex(H1)+cvt_hex(H2)+cvt_hex(H3)+cvt_hex(H4);return temp2.toLowerCase();}

function renderSurvey(jsonIn, container, updateSurveyId) {
    var _questions = '';
    var _surveyId = (jsonIn.itemId)?jsonIn.itemId:updateSurveyId;
    if (!_surveyId) return;
    // If a complete survey is being rendered, then it will have "surveyQuestions"
    // If it contains "updateQuestions", then the survey is being updated, not rendered from scratch
    if (jsonIn.surveyQuestions) {
        _questions = jsonIn.surveyQuestions;
        // Create the survey element.  Also attach a class and the survey data so that the delegate will know what to do when questions are answered
        container.empty().html('<ul id="' + _surveyId + '"></ul>').addClass('suiteSurveyContainer')
            .data({surveyId:_surveyId, cssClass:jsonIn.cssClass})
            .undelegate()
            .delegate('.surveyQuestionCancel,:button', 'click', function(e){ $.publish('/suite/surveyAnswer', [e, container.data()], e); return false })
            .delegate(':not(:button)', 'change', function(e){ $.publish('/suite/surveyAnswer', [e, container.data()], e); return false });
    } else if (jsonIn.updateQuestions) {
        if ($('#'+updateSurveyId).length == 0) return;   // Return if the survey is not active anymore
        _questions = jsonIn.updateQuestions;
    } else return;

    // Loop though all the questions on the survey
    $.each(_questions, function() {
        var _questionId = this.itemId;
        var _inputType = (this.suggestedControl)?this.suggestedControl:'text';   // TODO - put dynamic control selection logic here
        var _answered = this.currentAnswer!=undefined;
        var _currAnswer = (_answered)?this.currentAnswer:'';

        // Default to adding questions
        var _action = (this.action)?this.action.toLowerCase():'add';
        if (_action == 'delete') {
            $('#'+_questionId).remove();
            return; // Continue to next question
        }
        // Start the question
        var _display = '';

        // Loop through and create all the possible input values for an element
        if (!this.possibleAnswers) {
            // Display a default text input box for questions that do NOT have possible answers
            _display += '<input style="height:18px;width:150px;border: 1px solid #cccccc" type="text" value="' + _currAnswer + '"/>';
        } else {
            // Loop through and create the control with all the possible answers
            $.each(this.possibleAnswers, function() {
                if (_inputType=='button') {
                    _display += '<button value="' + this.value + '"' + ((_answered && this.value!=_currAnswer)?' disabled':'') + '>' + this.label + '</button>';
                } else if (_inputType=='combobox') {
                    _display += '<option value="' + this.value + '"' + ((this.value == _currAnswer)?' selected':'') + '>' + this.label + '</option>';
                } else {
                    _display += '<span style="padding-right:10px"><input name="' + _questionId + '" type="' + _inputType + '" value="' + this.value + '"';
                    if ( (_inputType == 'radio' && this.value == _currAnswer) || (_inputType == 'checkbox' && _currAnswer.indexOf(this.value) >= 0 ) )
                        _display += ' checked';
                    _display += '>' + this.label + '</span>';
                }
            });
            // Wrap a combobox in a <select> tag
            if (_inputType=='combobox') _display = '<select style="width:152px"><option value="null">Select a choice:</option>' + _display + '</select>';
        }

        // Create and style the survey question element
        var _question = '<li id="' + _questionId + ((jsonIn.cssClass)?'" class="'+jsonIn.cssClass:'') ;
        if (_answered) _question += (this.successType && this.successType.toLowerCase() == "valid")?' surveyAnswerGood':(_currAnswer)?' surveyAnswerError':'';
        _question += '"><div>' + ((this.preLabel && this.preLabel!='')?'<label for="' + _questionId + '"> ' + this.preLabel + '</label>':'' ) + '</div><div class="surveyQuestionDisplay">' + _display;
        if (_answered && _action!='disable') _question += '<img class="surveyQuestionCancel" src="images/' + sirona.portal + 'SurveyUndo.png">';  // Append a portal specific Undo button
        _question += '</div></li>';

        // Now place place the question where it needs to go
        switch(_action) {
        case 'update':
            $('#'+_questionId).replaceWith(_question);
            break;
        case 'disable':
            $('#'+_questionId).replaceWith(_question);
            $('#'+_questionId+' .surveyQuestionDisplay').children().attr('disabled','disabled');
            break;
        default: // 'add'
            if (this.position==null) {
                $('#'+_surveyId).append(_question);
            } else {
                $('.'+jsonIn.cssClass).eq(this.position).before(_question);
            }
        }
    });
}
$.subscribe('/suite/surveyAnswer', 'suite', function(e, objData) {
    // Fires when a Survey answer is given.  Retrieve the answer through the event and call Presentation Services
    var _surveyContainer = $('#'+ objData.surveyId).parent();

    var _data = e.target.value;
    if (e.target.type =='checkbox') {  // If the survey element answered is a checkbox, get() all the checked items and create an array
        _data = $(e.target).parent().children(':checked').map( function() { return this.value; }).get().join(',');
    } else if ($(e.target).hasClass('surveyQuestionCancel')) _data='null';

    var _question = $(e.target).closest('li');
    _question.removeClass('surveyAnswerGood surveyAnswerError');  // Remove any styling before request
    sirona.reqPS('setSurvey', { view:'suite', data: { patientId:sirona.patient.id, 'surveyId':objData.surveyId, 'questionId':_question.attr('id'), answer:_data  },
/*      TODO will this ever fire to style a bad response?
        error: function(data) {
            if (data.updateQuestions) renderSurvey($.extend(data,{'cssClass':objData.cssClass}), _surveyContainer, objData.surveyId );
            _question.removeClass('surveyAnswerGood').addClass('surveyAnswerError');
        },
*/
        success: function(data) {
            if (_data=='null') {    // If question was undone, reset the answered question to an unanswered state
                if ($('input', _question).attr('type')=='text') $('input', _question).val('');
                else $(':selected,:button,:checked', _question).removeAttr("selected disabled checked");

                $('.surveyQuestionCancel', _question).remove();
            } else {
                if ($('.surveyQuestionCancel', _question).length == 0) _question.children().last().append('<img class="surveyQuestionCancel" src="images/suiteSurveyUndo.png">');
                _question.addClass('surveyAnswerGood');
            }
            if (data.updateQuestions) renderSurvey($.extend(data,{'cssClass':objData.cssClass}), _surveyContainer, objData.surveyId );
            objData.question = _question;  // Add the question element to the object
            $.publish('/suite/surveyAnswered', [$.extend(objData, data)]);  // Publish that a correct answer was given, and pass the result and element answered
        }
    }, 'surveyFact', 'POST');
});

String.prototype.toCamel = function() {
    // Converts a string with spaces to camelCase
    return this.replace(/(\s[a-z|A-Z])/g, function($1){return $1.toUpperCase().replace(' ','');});
};
String.prototype.wrapTag = function(tag, condition) {
    // Wraps a tag around a string based on a condition.
    return (condition)?('<' + tag + '>' + this + '</' + tag + '>'):this;
};

var sort_by = function(field, reverse, primer) {
    // Sort comparator to pass to the sort() function
    // Convert the "field" passed in using an optional "primer" function
    reverse = (reverse) ? -1 : 1;

    return function(a,b){

       a = a[field];
       b = b[field];

       if (typeof(primer) != 'undefined'){
           a = primer(a);
           b = primer(b);
       }

       if (a<b) return reverse * -1;
       if (a>b) return reverse; // * 1;
       return 0;

    }
};
function isNumber(n) {
  return !isNaN(parseFloat(n)) && isFinite(n);
}
function concatObject(obj) {
  str='';
  for(prop in obj) {
    str+=prop + " value :"+ obj[prop]+"\n";
  }
  return(str);
}
function getObjValues(objData) {
    // Create a new object of just the single data values, no arrays
    var _newData = {};
    for (prop in objData) {
        if (objData.hasOwnProperty(prop) && !$.isArray(objData[prop])) _newData[prop]=objData[prop];
    }
    return _newData;
}

// Portal template resizing class
var resizeContent = {
    windowH:0,
    suiteHeaderH:null, suiteSplitTop:null, suiteSplitTopHeader:null, suiteSplitBottom:null,
    suiteBody:$('#suiteBody'),
    suiteBodyHeaderH:0,
    suiteSplitTopHeaderH:0,
    suiteSplitTopH:0,
    suiteSplitTopFooterH:0,
    suiteBodyHeaderBottomH:0,
    suiteSplitBottomFooterH:0,
    suiteSplitBottomH:0,
    suiteBodyH:0,
    suiteFooterH:0,  // Can be set initially because the height will never change
    gridT:null,     // Top grid
    gridB:null,     // Bottom grid
    gridTHH:0,      // Top grid header height
    gridBHH:0,      // Bottom grid header height
    testCount:0,
    init: function() {
        this.suiteBody = $('#suiteBody');
        this.suiteSplitTop=$('#suiteSplitTop');
        this.suiteSplitTopHeader=$('#suiteSplitTopHeader');
        this.suiteSplitBottom=$('#suiteSplitBottom');
        this.gridT = $('#suiteTopGrid');
        this.gridB = $('#suiteBottomGrid');
        this.suiteFooterH = $('#suiteFooter').height();
        this.suiteHeaderH = $('#suiteHeader').height();
        this.suiteBodyHeaderH = $('#suiteBodyHeader').height();
        this.suiteSplitTopHeaderH = this.suiteSplitTopHeader.height();
        this.suiteBodyHeaderBottomH=$('#suiteBodyHeaderBottom').height();
        this.suiteSplitTopFooterH = $('.suiteSplitTopFooter').height();
        this.suiteSplitBottomFooterH = $('.suiteSplitBottomFooter').height();    },
    updateAll: function() {
        this.init();
        this.updateHeight();
        this.updateWidth();
    },
    updateHeight: function() {
        this.windowH = $(window).height();
        if (this.suiteSplitTop) this.suiteSplitTopH = this.suiteSplitTop.height();
        this.suiteBodyH = this.windowH - this.suiteHeaderH - this.suiteFooterH - this.suiteBodyHeaderH - 2; // Subtract the bottom padding and the borders
        // Grid header heights could change as the heading is shrinked to wrap
        this.gridTHH = ($('#gview_suiteTopGrid .ui-jqgrid-hdiv').is(":visible")) ? $('#gview_suiteTopGrid .ui-jqgrid-hdiv').outerHeight() : 0;
        this.gridBHH = ($('#gview_suiteBottomGrid .ui-jqgrid-hdiv').is(":visible")) ? $('#gview_suiteBottomGrid .ui-jqgrid-hdiv').outerHeight() : 0;

        this.suiteSplitBottomH = this.suiteBodyH - this.suiteSplitTopH  - 15;       // Subtract the margin on the bottom
        if (this.suiteSplitBottom) this.suiteSplitBottom.height(this.suiteSplitBottomH);

        if (this.gridT && this.gridT.length>0) {
            this.gridT.jqGrid('setGridHeight', this.suiteSplitTopH - this.suiteSplitTopHeaderH - this.suiteSplitTopFooterH - this.gridTHH );
        }
        if (this.gridB && this.gridB.length>0) {
            this.gridB.jqGrid('setGridHeight', this.suiteSplitBottomH - this.suiteBodyHeaderBottomH - this.suiteSplitBottomFooterH - this.gridBHH);
        }
        this.testCount++;
        $.publish('/suite/contentResized',[this]);
    },
    updateGrids: function() {
        this.init();
        this.updateAll();
    },
    updateWidth: function() {
        if (this.gridT && this.gridT.length>0) this.gridT.jqGrid('setGridWidth', this.suiteBody.width());
        if (this.gridB && this.gridB.length>0) this.gridB.jqGrid('setGridWidth', $('#gbox_suiteBottomGrid').parent().width() );
        if (this.suiteSplitTopHeader) this.suiteSplitTopHeader.width(this.suiteBody.width());
        $.publish('/suite/contentResized',[this]);
    }
};
$.subscribe('/suite/widgetLoaded', 'suite', function(dataObj) {
    if (dataObj.container.attr('id')!='suiteContent') return false;         // Return if not loading the main container
    resizeContent.updateAll();                                              // Initialize the available containers
});

var gridFacts = {
    colNames:[], colModel:[], colWidths:[],
    gridsLoaded:{},                     // Booleans for which grids have been loaded
    gridCache:{},                       // Entire data set for each grid type
    gridData:{},                        // Miscellaneous metadata for each grid type
    gridSliding:false,                  // Wont update the bottom grid if top is sliding horizontally
    rowSelected:{},                     // Used to keep track of rows selected for the slider logic

    initGrid: function(grid) {
        this.gridData[grid]={}; this.gridCache[grid]={}; this.gridsLoaded[grid]=false; this.rowSelected={}; this.colWidths=[];
    },
    defineListTabs: function(objListTabs) {
        // List tabs are for the "upper" grid only
        this.initGrid('upper');
        if (objListTabs) sirona.getView('simpleTabs', { container:$('#factListTabs'), data:objListTabs });
    },
    defineDetailTabs: function(objDetailTabs) {
        // Detail tabs are for the "lower" grid only
        this.initGrid('lower');
        if(objDetailTabs) {
            $.extend(this.gridData['lower'], objDetailTabs[0]);
            sirona.getView('simpleTabsBottom', { container:$('#factDetailTabs'),  data:objDetailTabs });
        }

    },
    resetDisplay: function(location) {
        // Unload grids, destroy any sliders, and hide wrappers
        // When drawGrid is called again, will redraw if necessary
        $('#suite' + location + 'Grid').jqGrid('GridUnload');
        $('#suite' + location + 'GridSlider').slider('destroy');
        $('#suite' + location  + 'GridNavWrapper').hide();
    },
    buildHeaders: function(gridLoc, objGridHeaders) {
        // Define the columns
        if (objGridHeaders) {
            // TODO put in dynamic hidden columns
            this.colNames = ['','','']; this.colModel = [
                {name:'code', hidden:true},{name:'codeSystemCode', hidden:true},{name:'itemId', hidden:true}
            ];
            $.each(objGridHeaders, function() {
                gridFacts.colNames.push(this.value || '');                              // Create the headings
                var _colModel =  { name:this.columnId, width:parseInt(this.width) };
                if (this.formatter) _colModel.formatter = eval(this.formatter);         // Apply the formatter to the column
                gridFacts.colModel.push(_colModel);
            });
            // Append blank columns to the gridHeaders so that when scrolled to the last columns, the column widths are maintained
            var _blankCol = {columnId:'',value:'',width:objGridHeaders.slice(-1)[0].width};
            for (var iCol=0;iCol < gridFacts.gridCache[gridLoc].maxColumns - objGridHeaders.length;iCol++) {
                this.colModel.push(_blankCol); this.colNames.push('');
            }
        }
    },
    createSlider: function(gridLoc) {
        var _elementName = (gridLoc=='upper')?'#suiteTopGrid':'#suiteBottomGrid';
        var _sliderW = 0;
//        $(_elementName + 'Slider').slider('destroy');
        $(_elementName + 'Slider').slider({
            max:gridFacts.gridCache[gridLoc].gridHeaders.length - gridFacts.gridCache[gridLoc].fixedColumns -1,
            slide: function(e, ui) {
                gridFacts.gridSliding = true;
                var _tip = $(_elementName + 'SliderTip');
                var _tipHeader = gridFacts.gridCache[gridLoc].gridHeaders[ui.value + gridFacts.gridCache[gridLoc].fixedColumns];
                // Show either the grid header or, if not visible, the first row values for the tooltip
                _tip.text((gridFacts.gridCache[gridLoc].visibleGridHeaders)?_tipHeader.value:gridFacts.gridCache[gridLoc].facts[0][_tipHeader.columnId]);
                var _tipW = _tip.outerWidth();
                _tip.css({left:((_tipW > _sliderW)?('-'+(_tipW-_sliderW)/2):(_sliderW-_tipW)/2)+'px'}).show();    // Center the tooltip above the handle
            },
            change: function(e, ui) {
                gridFacts.gridSliding = true;
                $(_elementName + 'SliderTip').hide();
                // jqGrid does NOT update the headings with "reloadGrid", so redraw the entire grid with the new data slice
                $(_elementName).jqGrid('GridUnload');
                gridFacts.drawGrid($(_elementName), gridLoc, gridFacts.pageGrid(gridLoc, ui.value));
                gridFacts.gridSliding = false;
                resizeContent.updateAll();
            }
        });
        // Append a tooltip element INSIDE the handle that was created above, so that it will move with the handle
        var _handle = $(_elementName + 'Slider .ui-slider-handle');
        _sliderW = _handle.outerWidth();
        _handle.append('<span id="' + _elementName.substr(1) + 'SliderTip" class="gridSliderTip primaryBG"></span>');
        // Create the slider arrow event to move the handle
        $(_elementName + 'SliderArrows .suiteGridSliderArrow').click(function() {
            var _slider = $(_elementName + 'Slider'), _which = $(this).attr('id').substr(-1), _value = _slider.slider('option','value') + ((_which=='L')?-1:1);
            if ((_which=='L' && (_value >= _slider.slider('option','min'))) || (_which=='R' && (_value <= _slider.slider('option','max')))) _slider.slider('option','value',_value);
        }); //.mousedown(function() {$(this).addClass('primaryBG')});
    },
    pageGrid: function(gridLoc, startCol) {
        // Paging is necessary for a grid.  Reset the display index and store the data object
        var _cache = this.gridCache[gridLoc], _fixed = (_cache.fixedColumns)?_cache.fixedColumns:1; _cache.fixedColumns = _fixed;
        var _facts = $.extend({}, _cache);
        // The _facts is a new instance of the _cache with a new slice of the gridHeaders
        _facts.gridHeaders = $.merge(_cache.gridHeaders.slice(0, _fixed), _cache.gridHeaders.slice(startCol + _fixed, startCol + _cache.maxColumns - _fixed + 1 ));
        return _facts;
    },
    drawGrid: function(gridContainer, gridLoc, objData) {
        if (!objData.facts || objData.facts.length == 0) return false;
        var _elementName = (gridLoc=='upper')?'#suiteTopGrid':'#suiteBottomGrid';
        // Save the existing column widths before redrawing the grid if it exists
        $($('.jqgfirstrow td', gridContainer).each(function(idx, ele){gridFacts.colWidths[idx]=$(this).outerWidth() }));

        // Determine if the grid being drawn needs a horizontal slider.  This is determined by how many gridHeaders are sent
        if (objData.maxColumns!=undefined && objData.gridHeaders!=undefined && (objData.gridHeaders.length > objData.maxColumns) ) {
            this.gridCache[gridLoc] = objData;          // Store the entire result into the cache
            objData = this.pageGrid(gridLoc, 0);        // Initialize to the first page
            $(_elementName + 'NavWrapper').show();
            this.createSlider(gridLoc);
        }

        this.buildHeaders(gridLoc, objData.gridHeaders);

        // Draw the grid
        gridContainer.jqGrid({
            datatype: "jsonstring", datastr:objData, loadonce: true, jsonReader: { root: "facts", repeatitems:false },
            colNames:gridFacts.colNames, colModel:gridFacts.colModel,
            afterInsertRow: function(rowid, rowdata, rowelem) {
                if (rowelem.hoverTexts) gridFacts.rowHoverTexts(gridContainer, rowid, rowelem.hoverTexts);
            },
            forceFit:true, hoverrows:false, scrollrows:true, title:false,
            loadComplete: function() {
                // Option to not display the grid headings and show a border separator instead
                if (objData.visibleGridHeaders == false) gridContainer.closest('.ui-jqgrid-view').find('.ui-jqgrid-hdiv').hide();
                $(_elementName + 'Spacer').toggleClass('suiteGridSpacer', objData.visibleGridHeaders == false);

                // Initialize the grid after it is loaded
                gridFacts.gridsLoaded[gridLoc] = true;

                // Select the row that was previously selected while sliding, or to the first row
                if (gridContainer.getGridParam("reccount") > 0 ) {
                    gridContainer.jqGrid('setSelection',(gridFacts.rowSelected[gridLoc] || '1'));
                }
                resizeContent.updateGrids();
            },
            onSelectRow: function(rowid, status) {
                // Check current rowid and process and publish if different
                if (gridFacts.rowSelected[gridLoc] != rowid) {
                    gridFacts.rowSelected[gridLoc] = rowid;                                     // Store the active row selected for each grid
                    gridFacts.gridData[gridLoc].rowData = gridContainer.getRowData(rowid);      // Set the row data
                    // Reset the lower slider if upper row is changing
                    if (gridLoc=='upper' && !gridFacts.gridSliding) $('#suiteBottomGridSlider').slider('value',0);
                    $.publish('/suite/gridRowChanged/'+gridLoc);            // Publish that a grid row updated
                }
            },
            resizeStop: function(newW, idx) {
//                alert('suiteutil: '+ $($('.jqgfirstrow td', gridContainer)[idx]).outerWidth());
//                $(_elementName + 'SliderSpacer').width( $($('.jqgfirstrow td', gridContainer)[idx]).outerWidth() );
            }
        });
    },
    rowHoverTexts: function(grid, rowId, aryHoversText) {
        $.each(aryHoversText, function(idx){
            if (this != '') grid.setCell(rowId, idx + 3, '', '', { title:this } );  // Add 3 to skip over the 3 hidden columns
        });
    },
    tempRemap: function(objData, objTmpl) {
        var _remappedData = $.extend({},objTmpl); _remappedData.facts = [];         // Clone the template object passed in and convert the facts to an array
//        alert('util: '+ objData.FactListImpl.contains.length);
        $.each(objData.FactListImpl.contains, function(idx, rowData) {              // Iterate through each FactListImpl.contains object to create the new rows needed
            var _tmplRow = $.extend({}, objTmpl.facts);                             // Clone the template row so it can be altered
            $.each(objTmpl.facts, function(key, value) {                            // Iterate through the template fields, doing the search and replace
                var _newValue = '', _wasArray = false;
                if ($.isArray(value)) { value = value.join('|'); _wasArray=true }   // Create a string out of the array values
                $.each(value.split('+'), function(idxField, valField) {
                    var _newField = this.match(/[A-Z|a-z|\.]+/i)[0];
                    _newValue += valField.replace(_newField, _newField.split('.').reduce(index, rowData))
                    if (key=='fillDate') alert('util: '+ _newField +'/'+_newValue);
                });
                _tmplRow[key] = (_wasArray)?_newValue.split("|"):_newValue;         // Replace with the new value and recreate the array if it was one
            });
            _remappedData.facts.push(_tmplRow);                                     // Push the new remapped fact into the new result set
        });
        return _remappedData;
    }
};
function index(obj,i) {return obj[i] || ''}

// FORMATTERS - the gridHeaders object in the Facts could supply a "formatter" field.
//      There needs to be a formatter function created here for each possible formatter coming from PS
function pageIcon (cellvalue, options, rowObject) {
    // Formatting function for a column that displays a page icon instead of text.
    // When the user hovers over the image, publish the click so that the subscription will display it.  Passes the mouse event so it can get the coordinates
    return (cellvalue && cellvalue!='') ? '<img style="cursor:pointer" src="images/pageIcon.png" onclick="$.publish(\'/patientData/pageIconHover\',[\'' + cellvalue + '\',event])"/>':'';
}
function boldFormatter (cellvalue, options, rowObject) {
    // Formatting function for a column that displays a page icon instead of text.
    // When the user hovers over the image, publish the click so that the subscription will display it.  Passes the mouse event so it can get the coordinates
    return (cellvalue && cellvalue!='') ? '<span style="font-weight:bold">' + cellvalue + '</span>':'';
}
function factFlagFormatter (cellvalue, options, rowObject) {
    // Formatting function for boolean type fields from fact services.  Will be formatted into a checkmark or a link for a popup
    if (!cellvalue) return '';
    return (cellvalue==true)?('<img src="images/checkmark2.png"' + ((rowObject.title)?' title="' + rowObject.title + '"':'') + '>'):
            '<a href="#" onclick="$.publish(\'/patientData/pageIconHover\',[\'' + escapeHTML(cellvalue) + '\',event])">Available</a>';
}
function factDateFormatter (cellvalue, options, rowObject) {
    // All fact dates come in the format "1997-03-05T00:00:00-08:00"
    if (!cellvalue) return '';
    return '<span' + ((rowObject.title)?' title="' + rowObject.title + '"':'') + '>' + cellvalue.substr(0, 10) + '</span>';
}
function factDateTimeFormatter_mmm (cellvalue, options, rowObject) {
    if (!cellvalue || cellvalue.length < 10) return '';
    // All fact dates come in the format "1997-03-05T00:00:00-08:00"
    // Formatting function for date fields from the fact services
    var _month = 'JanFebMarAprMayJunJulAugSepOctNovDec'.substr(parseInt(cellvalue.substr(5,2))*3-3, 3);
    var _newDate = cellvalue.substr(8,2)+'-'+_month+'-'+cellvalue.substr(0,4)+' ' +cellvalue.substr(11,5);
    return '<span' + ((rowObject.title)?' title="' + rowObject.title + '"':'') + '>' + _newDate + '</span>';
}
function factDateTimeFormatter (cellvalue, options, rowObject) {
    // All fact dates come in the format "1997-03-05T00:00:00-08:00"
    if (!cellvalue) return '';
    return '<span' + ((rowObject.title)?' title="' + rowObject.title + '"':'') + '>' + factDateFormatter(cellvalue, options, rowObject) + ' ' + cellvalue.substr(11,5) + '</span>';
}
function escapeHTML(val) {
    var _newHTML = val.replace(/\'/gi,'\\x27');     // Single quotes
    _newHTML = _newHTML.replace(/\"/gi,'\\x22');    // Double quotes
    return _newHTML;
}
// Global subscriptions/bindings no matter which template is loaded
$.subscribe('/suite/selectDropdown', 'suite', function(objData, dropdownElement) {
    var _list = $('#suiteDropdownList');
    _list.empty().css({ "margin-top":dropdownElement.height() + "px" });        // Clear and position the dropdown
    $.each(objData.items, function() {                                          // Loop through the labels passed in and create the <li> items of the dropdown
        this.container = objData.container;                                     // Metadata to store inside the new <li>
        _list.append('<li class="suiteDropdownListItem ' + (this.cssClass ||'') + '">' + this.label + '</li>');
        _list.children().last().data(this);
    });
    if (objData.classRemove) $('.' + objData.classRemove, _list).remove();      // Remove the filter class if provided
    var _dropdownPos = dropdownElement.offset().left + dropdownElement.width() - $('#suiteDropdown').width();   // Default aligned to the right and below the clicked element
    $('#suiteDropdown').css({"top":dropdownElement.offset().top, "left":_dropdownPos}).show();                  // Position and show the dropdown
});
$('#suiteDropdown').mouseleave(function(){$(this).hide()});                                                     // Hide the dropdown if the mouse leaves the <div>
$('#suiteDropdownList').delegate('li', 'click', function() {
    $('#suiteDropdown').hide();
    $.publish( '/suite/selectedDropdown',[ $(this).data() ] );
    return false;
});

// DIALOGS logic
function showDialog(viewName, sizingData) {
    var _mainDialog = $('#suiteDialogContent');
//    var _height = sizingData.height || 400;
    var _width = sizingData.width || 500;
    sirona.getView(viewName, { container:_mainDialog, data:sizingData.data,
        success: function() {
            $('#suiteDialogBody').width(_width);
            if (sizingData.height) $('#suiteDialogBody').height(sizingData.height);
            _mainDialog.css({ left:($(window).width()-_mainDialog.width())/2, top:($(window).height()-_mainDialog.height())/2 }).draggable({containment:$('#suiteDialogOverlay')});

            // Make the dialog resizable if requested and setup related resizing events
//            if (sizingData.resizable) _mainDialog.resizable( {  minWidth:_width, minHeight:_height,
//                resize: function(e, ui) { $.publish('/suite/dialogResize',[ui]) },
//                stop: function(e, ui) { $.publish('/suite/dialogResize',[ui]) }
//            });  // { handles:'n,s,e,w'}

            $('.suiteDialog').show();
        }
    });
}
$.subscribe('/suite/dialogClose', 'suite', function(dialog) {
    $('#suiteDialogContent').draggable('destroy').resizable('destroy').empty().removeData();
    $.unsubscribeView(dialog);
    $('.suiteDialog').hide();
});
//$.subscribe('/suite/dialogResize', 'suite', function(ui) {
//    var _dialogBody = $('#suiteDialogBody');
//    var _dialogWindow = $('#suiteDialogContent');
//    _dialogBody.height(_dialogWindow.innerHeight());
//    _dialogBody.width(_dialogWindow.innerWidth());
//});

function abortTimer(viewName) {
    clearInterval(sirona.timers[viewName]);
    delete sirona.timers[viewName];
}
// If the logout topic subscription fires, then redirect to the login page
$.subscribe('/suite/logout', 'suite', function() {
    $.publish( '/suite/unloadView',[] );  // Publish when the body will be replaced, signalling widgets to do something before
    window.location = './';
});
$.subscribe('/suite/changeScreenSize', 'suite', function(element) {
    // Full screen capability subscription.  The element that initiated the request is passed here.
    var _wasFull = (element.hasClass('fullScreen'));
    $('#suiteHeaderWrapper').animate({ height:((_wasFull)?'90px':'22px') }, { easing:'linear',  animate:'slow',
         step:function(now, fx) { resizeContent.updateAll() }
//         , complete:function(now, fx) { resizeContent.init() }
     });
    $('.normalScreen').toggle(_wasFull); $('.fullScreen').toggle(!_wasFull);
});

// Update the template display when the window changes sizes
$(window).resize ( function() { resizeContent.updateAll() });

// Extend JQuery to add an outerHTML function
$.fn.outerHTML = function(s) {
    return (s)? this.before(s).remove(): $("<div>").append(this.eq(0).clone()).html();
};
// Extend JQuery to add a function that creates an object out of form parameters
$.fn.serializeObject = function() {
    var o = {};
    var a = this.serializeArray();
    $.each(a, function() {
        if (o[this.name]) {
            if (!o[this.name].push) {
                o[this.name] = [o[this.name]];
            }
            o[this.name].push(this.value || '');
        } else {
            o[this.name] = this.value || '';
        }
    });
    return o;
};
// Extend JQuery methods
$.extend({
    // Return unique array values.  Compatible with IE
    distinct: function(arr) {
        var result = [];
        $.each(arr, function(i, v){
            if ($.inArray(v, result) == -1) result.push(v);
        });
        return result;
    }
});

var formTemplate = {
    // This class is used to populate a template of fields from a JSON structure.  The fields can be input or just labels.
    breakField:null, breakSection:null, objDataCnt:0, tmplClasses:[],
    init: function() {
        this.breakField = null, this.breakSection = null, this.objDataCnt = 0;
    },
    loadForm: function(objData, template) {
        this.init();
        this.loadFields(objData, template);
        $.each($.distinct(this.tmplClasses), function() { });
    },
    loadFields: function(objData, template, prefix) {
        // This function recieves an object of key/value data fields and loads the form with the data
        if (!template) template = {};

        if (template && template.breakClass) {
            formTemplate.objDataCnt++;
            var _class = prefix + '_outputrow'; this.tmplClasses.push(prefix);
            var _outputRow = $('.' + _class); // Class of the detail output row from the templ
            
            // Check for any break fields and load the section that needs to be cloned when the break happens
            if (formTemplate.breakField != objData[template.breakClass.field]) {
                // Append fa cloned {prefix}_break class if one exists.  These rows are for the header of a break.  Convert the _break to a normal _outputrow
                _outputRow.last().after(formTemplate.cloneElements($('.' + prefix + '_break')).removeClass(prefix + '_break').addClass(_class).show());
                formTemplate.breakField = objData[template.breakClass.field];
            }
            // Append a new detail output row that needs to be cloned from the template, and then populated below
            $('.' + _class).last().after( formTemplate.cloneElements(_outputRow.first()).show() );
       }

        $.each(objData, function(key1, val1) {
            if ($.isArray(val1)) {
                 if (typeof(val1[0])=='object') {
                    // Arrays of objects
                    formTemplate.init();
                    $.each(val1, function() { formTemplate.loadFields(this, template[key1], key1) });
                 }
            } else if (typeof(val1) == 'object') {
                // Object below root
                formTemplate.loadFields(val1, template[key1], key1)
            } else {
                // Populate the field, prepending the parent key and appending the unique count
                var _field = ((prefix)?prefix+'_':'') + key1 + ((formTemplate.objDataCnt > 0)?formTemplate.objDataCnt:'');
                var _ele = $('#'+ _field);
                if (_ele.length > 0) {          // Make sure the element exists in the form
                    var _tag = _ele.get(0).tagName.toLowerCase();
                    if ('input|textarea'.indexOf(_tag) >= 0) {
                        if (template[key1] && template[key1].type && template[key1].type == 'checkbox' & val1) _ele.attr('checked','checked');
                        else _ele.val(val1);

                        if (template[key1] && template[key1].dataType == 'integer') _ele.addClass('suiteIntegerInput');
                    }
                    else if (_tag=='select') {
                        if (objData[key1+'s'])
                            $.each(objData[key1+'s'], function() { _ele.append('<option' + ((this==objData[key1])?' selected':'') + '>'  + this + '</option>')});
                    } else _ele.html(val1);
                    // Set the width of the element if provided
                    if (template[key1] && template[key1].width) _ele.width(template[key1].width);
                }
            }
        });
    },
    cloneElements: function(element) {
        // Clones all of the elements inside the passed element, and change the ids
        var _newBreak = element.clone(false);       // Clone the entire child, then replace all of the ids
        $.each(_newBreak.find("[name]"), function() { $(this).attr('name', $(this).attr('name') + '[' + formTemplate.objDataCnt + ']') });
        $.each(_newBreak.find("[id]"), function() { $(this).attr('id', $(this).attr('id') + formTemplate.objDataCnt) });
        $.each(_newBreak.find("[for]"), function() { $(this).attr('for', $(this).attr('for') + formTemplate.objDataCnt) });
        return _newBreak;
    }
};
//$(document).keydown( function(e) { return (e.which!=37 && e.which!=39)});  // Disables left and right arrow keys
$('body').delegate('input.suiteIntegerInput', 'keypress', function(e) {
    var key = e.which || e.keyCode || 0;
//if (sirona.debugIt) $.publish( '/suite/debug', [ 'suiteutil: '+ e.keyCode + '/'+ key + '/' + e.shiftKey ] );
    return (!e.shiftKey && (key==8 || key==9 || key==46 || (key >= 48 && key <= 57) || (key >=34 && key <=40)) );  //  || (key >= 96 && key <= 105));
});
$('.ajaxWait').ajaxStart(function() {
    // Only show the wait icon after a set period of milliseconds.  see config.jsp
    timer = setTimeout(function() { $('.ajaxWait').show() }, sirona.ajaxWaitDelay);
}).ajaxStop(function() { $(this).hide(); clearTimeout(timer); resizeContent.updateHeight() });  //
$.subscribe('/suite/notImpl', 'suite', function() { alert('This functionality is not currently implemented') });

