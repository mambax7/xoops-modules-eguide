<{if $event}>
<{include file="db:eguide_event.tpl"}>
<{/if}>
<div class="event">
<h2 class="page-header"><{$lang_event_edit}></h2>
<!-- for DHTML calendar -->
<link rel="stylesheet" type="text/css" media="all" href="<{$xoops_url}>/modules/eguide/class/bootstrap-datepicker/datepicker3.css" />
<script type="text/javascript" src="<{$xoops_url}>/modules/eguide/class/bootstrap-datepicker/bootstrap-datepicker.js"></script>
<script type="text/javascript" src="<{$xoops_url}>/modules/eguide/class/bootstrap-datepicker/locales/bootstrap-datepicker.zh-TW.js" charset="UTF-8"></script>
<script type="text/javascript">
  $(document).ready(function() {
    $('.jdate').datepicker({
      format: "yyyy-mm-dd",
      language: "zh-TW",
      todayHighlight: true
    });
  });
</script>

<form action="admin.php<{if $eid}>?eid=<{$eid}><{/if}>" method="post" class="evbody form-inline" name="evform" id="evform" onsubmit="return xoopsFormValidate_evform();">
<table border="0" cellpadding="0" cellspacing="0">
<tr><td>
<h3><{$smarty.const._MD_TITLE}></h3>
<input type="text" name="title" id="title" value="<{$title}>" size="60" maxlength="80" class="form-control" />
</td><{if $input_category}><td>
<h3><{$smarty.const._MD_EVENT_CATEGORY}></h3>
<{$input_category}></td><{/if}></tr>
</table>
<h3><{$smarty.const._MD_EVENT_DATE}></h3>
<p>
<{$input_edate}> &nbsp;
<{$smarty.const._MD_TIMEC}> 
<{if $timetable}>
  <select name="edatetime" class="form-control">
    <{foreach item=timeopt from=$timetable}>
      <option value="<{$timeopt.value}>"<{if $timeopt.value==$edatetime}> selected="selected"<{/if}>><{$timeopt.label}></option>
    <{/foreach}>
  </select>
<{else}>
  <{$input_edatetime}>
<{/if}>
</p>
<fieldset>
  <legend>
<script type="text/javascript">
<{if $extent_sets || $edata.closetime!=3600 }>
document.write('<input type="checkbox" onClick="toggle(\'exdate\',this);" checked="checked" id="dateck"/>');
<{else}>
document.write('<input type="checkbox" onClick="toggle(\'exdate\',this);" id="dateck"/>');
<{/if}>
</script>
  <{$smarty.const._MD_EDIT_EXTENT}>
  </legend>
  <div id="exdate">
    <p><b><{$smarty.const._MD_EVENT_EXPIRE}></b> <{$input_expire}></p>
    <p><b><{$smarty.const._MD_CLOSEBEFORE}></b> <input type="text" name="before" id="before" size="7" value="<{$before}>" class="form-control" /> <span class="evinfo"><{$smarty.const._MD_CLOSEBEFORE_DESC}></span></p>
    <{if $input_extent}>
    <p>
      <b><{$smarty.const._MD_EVENT_EXTENT}></b> <{$input_extent}>
    <{if $extent_sets}>
    <div class="extents">
    <{foreach from=$extent_sets item=ext}>
      <nobr><{if $ext.disable}>&middot; <{else}><input type="checkbox" value="<{$ext.exdate}>" name="extent_sets[<{$ext.no}>]"<{if $ext.checked}> checked<{/if}>/><{/if}><{$ext.date}></nobr>
    <{/foreach}>
    </div>
    <{/if}>
    </p>
    <{/if}>
  </div>
</fieldset>
<h3><{$smarty.const._MD_INTROTEXT}></h3>
<{if $use_fckeditor}>
<textarea id="summary" name="summary" wrap="virtual" cols="60" rows="10" class="form-control mce"><{$summary|escape}></textarea>
<{else}>
<{$summary_textarea}>
<{/if}>
<h3><{$smarty.const._MD_EXTEXT}></h3>
<textarea name="body" wrap="virtual" cols="60" rows="10" class="form-control mce"><{$body}></textarea>

<{if $use_fckeditor}>
<script type="text/javascript" src="<{$xoops_url}>/modules/eguide/class/tinymce/tinymce.min.js"></script>
<script type="text/javascript" src="<{$xoops_url}>/modules/eguide/class/tinymce/jquery.tinymce.min.js"></script>
<script type="text/javascript">
tinymce.init({
    selector: "textarea.mce",
    theme: "modern",
    language : "zh_TW",
    plugins: ["advlist autolink lists link image charmap print preview anchor",
        "searchreplace visualblocks code fullscreen",
        "insertdatetime media table contextmenu paste textcolor"],
    toolbar: "insertfile undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image | forecolor backcolor"
});
</script>
<input type="hidden" name="style" value="0" />
<{else}>
<h3><{$smarty.const._MD_EVENT_STYLE}></h3>
<{$input_style}>
<{/if}>

<h3><{$smarty.const._MD_RESERV_SETTING}></h3>
<div><label class="checkbox-inline"><input type="checkbox" name="reservation" value="1"<{if $reservation}> checked<{/if}>/> <{$smarty.const._MD_RESERV_DESC}></label></div>
<div>
  <label class="checkbox-inline">
  <input type="checkbox" name="strict" value="1"<{if $strict}> checked<{/if}>/> <{$smarty.const._MD_RESERV_STOPFULL}>
  </label>
  <label class="checkbox-inline">
  <input type="checkbox" name="autoaccept" value="1"<{if $autoaccept}> checked<{/if}>/> <{$smarty.const._MD_RESERV_AUTO}>
  </label>
</div>
<div><label class="checkbox-inline"><input type="checkbox" name="notify" value="1"<{if $notify}> checked<{/if}>/> <{$smarty.const._MD_RESERV_NOTIFYPOSTER}></label></div>
<div><b><{$smarty.const._MD_RESERV_PERSONS}></b> <input type="text" name="persons" value="<{$persons}>" size="3" class="form-control" /> <{$smarty.const._MD_RESERV_UNIT}></div>
<h3><{$smarty.const._MD_RESERV_ITEM}></h3>
<textarea name="optfield" wrap="virtual" cols="100" rows="10" class="form-control"><{$optfield}></textarea>
<div id="itemhelper" style="display:none;margin-top:5px;">
  <{$smarty.const._MD_RESERV_LAB}> <input type="text" name="xelab" size="10" class="form-control">
  <input type="checkbox" name="xereq" title="<{$smarty.const._MD_RESERV_REQ}>">
  <select name="xetype" class="form-control">
    <option value="text">text</option>
    <option value="checkbox">checkbox</option>
    <option value="radio">radio</option>
    <option value="textarea">textarea</option>
    <option value="select">select</option>
    <option value="hidden">hidden</option>
    <option value="const">const</option>
  </select>
  <input type="text" name="xeopt" size="30" class="form-control" />
  <button onClick="return addFieldItem();" class="btn btn-default"><{$smarty.const._MD_RESERV_ADD}></button>
</div>
<div class="evinfo">
  <{$smarty.const._MD_RESERV_ITEM_DESC}> <{$label_desc}></div>
<fieldset>
  <legend>
<script type="text/javascript">
<{if $edata.optvars}>
document.write('<input type="checkbox" onClick="toggle(\'optvars\',this);" checked="checked" id="optck"/>');
<{else}>
document.write('<input type="checkbox" onClick="toggle(\'optvars\',this);" id="optck"/>');
<{/if}>
</script>
  <{$smarty.const._MD_OPTION_VARS}>
  </legend>
  <div id="optvars">
    <h3><{$smarty.const._MD_RESERV_REDIRECT}></h3>
    <input type="text" name="redirect" value="<{$optvars.redirect|escape}>" size="60" class="form-control" />
    <div class="evinfo"><{$smarty.const._MD_RESERV_REDIRECT_DESC}></div>
    
    <h3><{$smarty.const._MD_OPTION_OTHERS}></h3>
    <textarea name="opt_others" cols="60" rows="4" class="form-control"><{$opt_others|escape}></textarea>
  </div>
</fieldset>
<{if $input_status}>
<p><{$input_status}></p>
<{/if}>

<{if $eid && $enable_copy}>
<div class="checkbox"><label><input type="checkbox" name="eid" value="0"> <{$smarty.const._MD_NEWTITLE}></label></div>
<{/if}>
<div style="margin-top:10px">
<input type="submit" name="preview" value="<{$smarty.const._MD_PREVIEW}>" class="btn btn-default" />
<input type="submit" name="save" value="<{$smarty.const._MD_SAVE}>" class="btn btn-primary" />
</div>
</form>
<script type="text/javascript">
<!--//

// display only JavaScript enable
xoopsGetElementById("itemhelper").style.display = "block";
function addFieldItem() {
    var myform = window.document.evform;
    var item=myform.xelab.value;
    if (item == "") {
	alert("<{$smarty.const._MD_RESERV_LABREQ}>");
	myform.xelab.focus();
	return false;
    }
    if (myform.xereq.checked) item += '*';
    var ty = myform.xetype.value;
    var ov = myform.xeopt.value;
    item += ','+ty;
    if (ty != 'text' && ty != 'textarea' && ov == "") {
	alert(ty+": <{$smarty.const._MD_RESERV_OPTREQ}>");
	myform.xeopt.focus();
	return false;
    }
    if (ov != "") item += ','+ov;
    opts = myform.optfield;
    if (opts.value!="" && !opts.value.match(/[\n\r]$/)) item = "\n"+item;
    opts.value += item;
    myform.xelab.value = ""; // clear old value
    myform.xeopt.value = "";
    return false; // always return false
}
function xoopsFormValidate_evform() {
    myform = window.document.evform;
<{foreach from=$check key=name item=msg}>
if ( myform.<{$name}>.value == "" ) { window.alert("<{$msg}>"); myform.<{$name}>.focus(); return false; }
<{/foreach}>
return true;

}

function toggle(id,a) {
    xoopsGetElementById(id).style.display = a.checked?"block":"none";
}
toggle("exdate", xoopsGetElementById("dateck"));
toggle("optvars", xoopsGetElementById("optck"));
//--></script>
</div>
