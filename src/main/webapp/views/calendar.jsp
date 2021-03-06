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

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html>
    <head> 
        <link rel='stylesheet' type='text/css' href='css/fullcalendar.css' />
        <link rel='stylesheet' type='text/css' href='css/fullcalendar.print.css' media='print' />
        <!-- Theme style overrides for the calendar -->
        <style type="text/css">
            /*#calendarDatePicker .ui-datepicker-header { padding:0 !important; }*/
            /*#calendarDatePicker .ui-datepicker .ui-datepicker-prev, .ui-datepicker .ui-datepicker-next { position:absolute; top: 2px; width: 1.8em; height: 25px !important; }*/
            #calendarDatePicker .ui-datepicker-title { line-height: 25px; text-align:center; }
            #calendarDatePicker .ui-widget-content { border:none }
            #calendarDatePicker .ui-widget-header, .fc-content .ui-widget-header { line-height:22px; border:none }
            #calendarDatePicker .ui-datepicker { width: 205px; padding:0 }
            #calendarDatePicker .ui-datepicker-header { padding:0;}
            #calendarDatePicker .ui-datepicker table {margin:0 }
            /*#calendarDatePicker a.ui-state-default { color:#ffffff;border:1px solid #eee }*/
            /*#calendarDatePicker a.ui-state-active { color:#000000;font-weight:bold; }*/
            .fc-header-title h2 { line-height:34px }
            .fc-today { border:1px solid #ccc !important; }
            /*#calendarNav li { font-weight:bold; font-size:10px }*/
        </style>
    </head>

    <body>
        <div id="suiteBodyHeader">
            <div class="suiteBodyHeaderTop">
                <div id="suiteBodyTitle">Calendar</div>
                <div class="suiteBodyHeaderButtonsR">
                    <button onclick="$.publish('/suite/notImpl')">Print</button>
                    <button id="closeRecord" onclick="sirona.requestPatientChange('')">Close Record</button>
                </div>
            </div>
        </div>
        <div id="suiteBody">
            <div id="suiteSplitBottom">
                <div class="contentPadding">
                    <table class="tblClean">
                        <tr>
                            <td style="padding-right:15px">
                                <div id="calendarNav">
                                    <div id="calendarsMine" class="suiteBorder" style="display:none;margin-bottom:15px">
                                        <div class="primaryBG suiteHeadingHeight" style="padding-left:10px">Personal Calendars</div>
                                        <ul style="padding:10px">
                                        </ul>
                                    </div>
                                    <div id="calendarAppointments" class="suiteBorder">
                                        <div class="primaryBG suiteHeadingHeight" style="padding-left:10px">Medical Calendars</div>
                                        <ul style="padding:10px">
                                        </ul>
                                    </div>
                                    <div>
                                        <div id="calendarDatePicker" class="suiteBorder" style="margin-top:15px"></div>
                                    </div>
                                </div>
                            </td>
                            <td style="width:100%"><div id="calendarContainer" class="suiteBorder" style="overflow-y:hidden"><div id='calendar'></div></div></td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>

        <script type='text/javascript' src='js/fullcalendar.min.js'></script>
        <!--<script type='text/javascript' src='js/gcal.js'></script>-->
        <script type='text/javascript'>

            $(document).ready(function() {
                if (!sirona)
                    return false; // Cannot be loaded without the config
                var _thisView = 'calendar';

                $.subscribe('/suite/contentResized', _thisView, function(resizeObj) {
                    $('#calendarContainer').height(resizeObj.suiteSplitBottomH - 2 - 30);
                    $('#calendar').fullCalendar('option', 'height', (resizeObj.suiteSplitBottomH - 2 - 30)); // Subtract the borders and padding above and below
                });
                $('#calendarNav').undelegate().delegate('input', 'click', function() {
                    // Remove or add events based on calendars/appointments checked off
                    $('#calendar').fullCalendar((($(this).attr('checked')) ? 'addEventSource' : 'removeEventSource'), _calendars[$(this).attr('id')]);
                    $('#calendar').fullCalendar('rerenderEvents');
                });
            
                //CUSTOMIZE BUTTONS
                var _closeRecordButton = $('#closeRecord');
                if (!sirona.patient.id){
                    _closeRecordButton.hide();
                }

                // INITIALIZATION
                var date = new Date();
                var d = date.getDate();
                var m = date.getMonth();
                var y = date.getFullYear();

                $("#calendarDatePicker").datepicker({
                    onSelect: function(dateText, inst) {
                        // When a date is clicked on in the date picker, move the full calendar to that date
                        $('#calendar').fullCalendar('gotoDate', new Date(dateText));
                    }
                });

                // Draw the calendar
                $('#calendar').fullCalendar({
                    theme: true,
                    header: {
                        left: 'prev,next',
                        center: 'title',
                        right: 'today month,agendaWeek,agendaDay'
                    },
                    editable: true, allDayDefault: false, lazyFetching: false, eventResizeDrop: function() {
                        $.publish('/suite/debug', ['calendar: ' + new Date()])
                    },
                    eventDrop: function(event, dayDelta, revertAction) {
                        /*
                         sirona.reqPS('setCalendar', { view:_thisView, data: { 'patientId':_modelIds.join(','), 'providerId':_thresholds.join(','),
                         'calendarId':null, 'eventId':null, 'title':null,
                         'start':null, 'end':null, 'allDay':false, 'action':null},
                         success: function(data){
                         $(this).fullCalendar('rerenderEvents');
                         }
                         }, 'calendarFact', 'POST');
                         */
                    }
                });

                var _data = {}, _calendars = {};
                if (sirona.patient.id)
                    _data.patientId = sirona.patient.id;
                sirona.reqPS('getCalendar', {view: _thisView, data: _data,
                    success: function(data) {
                        var _container, calendarCnt = 0;
                        // Loop through all the calendars, adding the color to the appropriate events
                        $.each(data.calendars, function(idx, calendar) {
                            // Set which container to put the calendar selector in
                            if (calendar.type.toLowerCase() == 'private')
                                _container = $('#calendarsMine');
                            else if ('provider|personal'.indexOf(calendar.type.toLowerCase()) >= 0)
                                _container = $('#calendarAppointments');
                            else
                                return;

                            calendarCnt++;
                            var _calendarId = 'calendar' + calendarCnt;
                            $('ul', _container).append('<li style="font-weight:bold;color:' + calendar.backgroundColor + '"><input type="checkbox" id="' + _calendarId + '" checked>' + calendar.title + '</li>');
                            _container.show();

                            _calendars[_calendarId] = [];
                            $.each(calendar.events, function() {
                                _calendars[_calendarId].push($.extend(this, {'backgroundColor': calendar.backgroundColor, 'textColor': calendar.textColor}));
                            })
                            $('#calendar').fullCalendar('addEventSource', _calendars[_calendarId]); // Add the events with the new properties
                        });
                    }
                }, 'calendarsFact');

            });

        </script> 

    </body>
</html> 