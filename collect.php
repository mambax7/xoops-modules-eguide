<?php
// Event collection setting by Poster
// $Id: collect.php,v 1.1 2006/06/04 07:04:02 nobu Exp $

include 'header.php';
$_GET['op'] = '';	// only for poster
include 'perm.php';

if (isset($_POST['persons'])) {
    foreach ($_POST['persons'] as $k => $v) {
	if ($v=='') $v = 'null';
	else $v = intval($v);
	if (preg_match('/^(\\d+)-(\\d+)$/', $k, $d)) {
	    $eid = intval($d[1]);
	    $exid = intval($d[2]);
	    $xoopsDB->query("UPDATE ".EXTBL." SET expersons=$v WHERE exid=$exid AND eidref=$eid");
	} else {
	    $eid = intval($k);
	    $xoopsDB->query("UPDATE ".OPTBL." SET persons=$v WHERE eid=$eid");
	}
    }
    $url = isset($_SERVER['HTTP_REFERER'])?$_SERVER['HTTP_REFERER']:EGUIDE_URL.'/collect.php';
    redirect_header($url, 1, _MD_DBUPDATED);
    exit;
}

$fields = "e.eid, cdate, title, closetime, summary,
IF(expersons IS NULL,persons, expersons) persons, expersons,
IF(exdate,exdate,edate) edate, 
IF(x.reserved,x.reserved,o.reserved) reserved,
uid, status, style, counter, catid, catname, catimg, exid, exdate";
$now = time();
$cond = 'status<>'.STAT_DELETED.' AND reservation';
$cond .= " AND IF(exdate,exdate,edate)>$now";

if ($xoopsUser->isAdmin($xoopsModule->getVar('mid'))) {
    if (isset($_GET['uid'])) $cond .= ' AND uid='.intval($_GET['uid']);
} else {
    $cond .= ' AND uid='.$xoopsUser->getVar('uid');
}
if (isset($_GET['eid'])) $cond .= ' AND e.eid='.intval($_GET['eid']);

$result = $xoopsDB->query($x='SELECT '.$fields.' FROM '.EGTBL.' e LEFT JOIN '.
OPTBL.' o ON e.eid=o.eid LEFT JOIN '.CATBL.' ON topicid=catid LEFT JOIN '.
EXTBL." x ON e.eid=eidref WHERE $cond ORDER BY edate");

include XOOPS_ROOT_PATH.'/header.php';
$xoopsOption['template_main'] = 'eguide_collect.html';
$xoopsTpl->assign('xoops_module_header', HEADER_CSS);

$num = $xoopsDB->getRowsNum($result);
$tline = array();
$cells = array();
$event = array();
$peid = 0;			// prime event id
while ($data = $xoopsDB->fetchArray($result)) {
    $edate = $data['edate'];
    $day = formatTimestamp($edate, _MD_SDATE_FMT);
    $time = formatTimestamp($edate, _MD_STIME_FMT);
    $eid = $data['eid'];
    if (!isset($event[$eid])) {
	$event[$eid] = edit_eventdata($data);
	if (!$peid && $data['exid']) $peid = $data['eid'];
    }
    if (isset($tline[$time])) $tline[$time]++;
    else $tline[$time] = 1;
    if (!isset($cells[$day])) $cells[$day] = array();
    if (isset($cells[$day][$time])) {
	$cells[$day][$time][] = $data;
    } else {
	$cells[$day][$time] = array($data);
    }
}


if (empty($xoopsModuleConfig['time_defs'])) {
    $timeline = array_keys($tline);
} else {
    $timeline = array_unique(array_merge(array_keys($tline),
		 preg_split('/\\s*,\\s*/', $xoopsModuleConfig['time_defs'])));
    sort($timeline);
}
$xoopsTpl->assign('event', $event);
$xoopsTpl->assign('peid', $peid);
$xoopsTpl->assign('timeline', $timeline);
$xoopsTpl->assign('cells', $cells);
$xoopsTpl->assign('export', file_exists(EGUIDE_PATH.'/export.php'));
$xoopsTpl->assign('lang_export', _MD_EXPORT_OUT);

include XOOPS_ROOT_PATH.'/footer.php';
?>