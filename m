Return-Path: <io-uring+bounces-13205-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CtG2FBDC9WmVOgIAu9opvQ
	(envelope-from <io-uring+bounces-13205-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 02 May 2026 11:21:20 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 49EA14B1810
	for <lists+io-uring@lfdr.de>; Sat, 02 May 2026 11:21:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 178D3300B9A8
	for <lists+io-uring@lfdr.de>; Sat,  2 May 2026 09:21:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F5E11B3925;
	Sat,  2 May 2026 09:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ntu.edu.sg header.i=@ntu.edu.sg header.b="lL97UsLN"
X-Original-To: io-uring@vger.kernel.org
Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012023.outbound.protection.outlook.com [40.107.75.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94EAEBA34;
	Sat,  2 May 2026 09:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777713674; cv=fail; b=Jjm+ivZr6V5HACfgDY0D2Oa4JUETq9d2LU/7YApmhqM3+Y65uj3ptp94tHjdDlGj8s/Ob4Dn2ugh23WnOAwbbguWXnIfHqHFQmiieydaI7AK1qnWYeS90fVDUSUV6hhbuglJ6hYw7iA7RSg0vFN1YymVjPruM2SaXq8BBmXb01s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777713674; c=relaxed/simple;
	bh=8rdSzAdkwYC0+8UTKhBXsb1PjfKISovC0N2RZOe2OPA=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=K6jLEzsJHp/V4tBcEdrPz5tEoswrvrwO4nKWH2mFKzEniBJNtMc1iWvdDkQeP+nHbXe4r/d0Yn0POkLkcM+lFcqdCld9fbzaP/GC8sg9nSXf9tdaRxFg1kE3Q+Hn7XqY7uFKd4kwv3yZ4axHCjG73jaOghY9PR4lG2YdYXFsqNI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ntu.edu.sg; spf=pass smtp.mailfrom=ntu.edu.sg; dkim=pass (2048-bit key) header.d=ntu.edu.sg header.i=@ntu.edu.sg header.b=lL97UsLN; arc=fail smtp.client-ip=40.107.75.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ntu.edu.sg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ntu.edu.sg
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jB9sKK0mtbhJTXHnwLCK4/XJMNXsOEsyR9P+pXkUUO4E8WCHdE8ithFPGvbWBouzefgHkBDfAk7n/FCpC09FtGwjNpaHUqZXv4ZyB8EQO596wNLvFHJhzdDzZfdXSRmk/cPR61vm+KnIxme+/LSPdqUSKmhoue9BCe1HO7Tv56x21DKle0n4OPLP3sMrvP3/jCMbOTpEyRjfmmJdksi7iLwCI3aDUGcKntqp8RGiOdoYsZpVyIrSuqP53UJ5P3Pp52do6cKmyayRcvwKB6if0rG0U2cum+TZ2g+IXYrN64i/q1jX4aX7MZmcMxU9DwdkHZI88539GOrjK1D1h131jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mgxVnNFUEPsWxA+yvEOXyJvmRDHKpTX6j7zQgTtpUbM=;
 b=JdwEyGrcWDlgtSNA0si05wlv981wSrnknaGXASS7XkJAq8WV2fNT3RuaF7PAlmCsms1R4fOjzSFPMCTACi5mfg5GOeZ59YkFnhMuT+CJ+hJ0riH4QBqvLVONKJ6o5iCb1HEOzbb5ePExyFO9ajK1X214YoWVAoKBO2IofHrHnzS9NQOtaLTVWm/XEXObRKU/7gY4k2PJ4/qVJB24CMmP+xCTEHfvNlAXNqrjuu2XDu/VN2R1CbJ2zrESw3grZH17rwYCnKZhoRLq1pYgFot5ZeMBjKbrIzkCqzQgAO/S2b7mkjKVPJ2VvA096QiUsYLXoAIWgRH06H7Bx9VBl+bauw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ntu.edu.sg; dmarc=pass action=none header.from=ntu.edu.sg;
 dkim=pass header.d=ntu.edu.sg; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ntu.edu.sg;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mgxVnNFUEPsWxA+yvEOXyJvmRDHKpTX6j7zQgTtpUbM=;
 b=lL97UsLNQbITMNzU9dTBcX/jVrYh50Qz1c8ztL8NK/LX3gz6lVP/kAQUUDgUKRU5lNOYWYNkF73xiJT7rQe2YVQF+HogLRY7OwSCvj2Z+UyV4/LGM4dqI8Qe7JhtLYbcynm+h+JMxH1MXr4SB8Zr9xyM66fFLAXm7cvL4b8+QQxDv2CfvXCRKpvKJDKQm39+Y4d18CtWleKUF9QejQYJtySNs1HLAPtjFFgwlyzuZXNcpAdm4Jg8pE45bwnFwUBFM701GKh/bJQKcvKPhTjFyiGkEWOEKKqRclZ20UkrSikqFdGUMLya0FTV2p4a5zEvs6JKBYn3zBqpQOMuRuZIJw==
Received: from TYZPR01MB6758.apcprd01.prod.exchangelabs.com
 (2603:1096:405:a2::6) by SEYPR01MB5219.apcprd01.prod.exchangelabs.com
 (2603:1096:101:dc::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.23; Sat, 2 May
 2026 09:21:06 +0000
Received: from TYZPR01MB6758.apcprd01.prod.exchangelabs.com
 ([fe80::bbb1:1ecd:fe69:9743]) by TYZPR01MB6758.apcprd01.prod.exchangelabs.com
 ([fe80::bbb1:1ecd:fe69:9743%6]) with mapi id 15.20.9870.022; Sat, 2 May 2026
 09:21:05 +0000
From: Xie Maoyi <maoyi.xie@ntu.edu.sg>
To: Jens Axboe <axboe@kernel.dk>
CC: Pavel Begunkov <asml.silence@gmail.com>, Andrei Vagin <avagin@gmail.com>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: io_uring: should IORING_TIMEOUT_ABS honour the submitter's time
 namespace?
Thread-Topic: io_uring: should IORING_TIMEOUT_ABS honour the submitter's time
 namespace?
Thread-Index: AQHc2gC1O+evKeW+H0uOkX1nIKwMBg==
Date: Sat, 2 May 2026 09:21:05 +0000
Message-ID:
 <TYZPR01MB67582BE6855BE725AA5174CBDC332@TYZPR01MB6758.apcprd01.prod.exchangelabs.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ntu.edu.sg;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYZPR01MB6758:EE_|SEYPR01MB5219:EE_
x-ms-office365-filtering-correlation-id: df53ecdc-094c-425b-a9a1-08dea82c234f
x-o365: NTU-OFF365
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|6049299003|376014|1800799024|786006|4053099003|38070700021|56012099003|18002099003;
x-microsoft-antispam-message-info:
 nJdv+uzNz9sooOzAlKvms0HZcUy8dXlwn9RjshVkf1/IjZ451pFbEICXxH6MW7+cIyFJwAwBvtc9xyEwSVsLiJAJngjgUx6cPlTxCmPJOUqopM/IEPX2SbnNIB6TSOXLqcJgynooienpKdN2Cdc5WUy2cDyhHp8P6+o6Q8B3SPks2qLk9SthBB2HKKmaW06PyGWr/rLWVUFE6vxQalh0Vi3qlNm9L3eQONufHtg8i9u+g3a35M/sj6lc0aTDoMyl2Ctsg6dyVEYpKqeGlWLFyH9DjjD6cvShSzSXVg7XRQ+/vKFD4iFEmln1ERH0MwrVjjZXNa5bPjicTT5HBVM8kOc8rWjbj//XAtQOfp8mje5O+aGR/gHQ9WNn2InDY7u6iZQehVo92vlS3kW2RY8OIT5DHrzkz77DlZhZBHMJXfQ3JaOyFWJM4sWPX9+jHL2KxyOa8o/bHwau7rUaqFxswcxI4+n/0wcQ5ONDObzkULeZZEBekNLUtMfEs1Rqd6bNDz512SfnpA9E40WrEyIrW1y0uTpGjoBO0336MQhdKJf/l75bDyjzuHnES5+26XzcB6fznjvqu8IzKioN/96cjeIsxfsyTFsSnF4HK434WLRBYHYLJ5JSU24MH+8EBh+4IF+m8ULRG2TdE7eYUVxJdxtfLok8vnuo32d+BuMEE/rVfuLmfKtX1O4HO9Yd8dsNjajN48gg6itTPrYEEQyuGg==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR01MB6758.apcprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(6049299003)(376014)(1800799024)(786006)(4053099003)(38070700021)(56012099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?rhUnuXFm8Ycovdg9yGX8DpvUckQIzc1a1Eb7K8c2lvI9ZYilyhibOqryhL?=
 =?iso-8859-1?Q?6RkC+w+Vj/4LJWpAV1WKb15IR1GFCfMBQCTxXjjIGAZ/KmQ1YVSgfnCnSF?=
 =?iso-8859-1?Q?H5lultolun2cc6zQ/RVNrY7kjVBurx2FVq4nMyvuQ7jQluzXQTjtSkRWt5?=
 =?iso-8859-1?Q?wv0SkNuZMpXWLYUXew6QHBVm0jnqftleCR8W3MRLKGkewpmnBkGe9+UQkS?=
 =?iso-8859-1?Q?R2Z05lGfNbKPUflZVWDRaKNgLmuHfHoFKgrbVfRXAmMsTajzqLzvbyGcwt?=
 =?iso-8859-1?Q?NPkIXhX1Knms0c3tGLjyzXtvi68lOik0KN4Hl/1Sc279jjtGLU4IKLtKTW?=
 =?iso-8859-1?Q?JJYTrqAa9nHX08eyluU3Jh9nnD/u4HMtFQqFJGlVP/ZGZFkkrZaMd3JTP4?=
 =?iso-8859-1?Q?IDNaHz0mO98ekydaQesHuvOJCds6FrN+/fXNYe2gdaRsBlnhuA38KCAX4v?=
 =?iso-8859-1?Q?CDmG99ZKuF4/XlqZ+6dkMsnQ7EtVYnFbqiICe5HIla02Cw50uE+lQt36Rw?=
 =?iso-8859-1?Q?P8clFfztwlIefyeB+BsOck5vfAvTCvN5rfU27HCLrglJidwA1XvrhdIZ2L?=
 =?iso-8859-1?Q?FNGY+z8Q/wamviFaYTfJAmJOv8ZAkKI7gftPaqvVzw5jlT6TnsMBfeqHIb?=
 =?iso-8859-1?Q?5XSz18G5zi0V+dHMMYv2OzwcAzI4JaZc6keUMdyGAYO5JslpQR+Nk3kdpm?=
 =?iso-8859-1?Q?CyK89rf9qSB9mKbjspGS7u1n/nwZWWX2+szj1kRCfiyF9QTfsuds5dfuC8?=
 =?iso-8859-1?Q?piqyGGiAf9ST4ofBJFN38VcNxk7P06VW5tRLHP4pAO4fQ8FR3sHQuzhZ8W?=
 =?iso-8859-1?Q?QdJjJSVJEJGCklEssG9F9GB1p2+/ki6wpzRmyyVBFvVE/ZcPo1eYzFkF71?=
 =?iso-8859-1?Q?1JgWv1BV8W8WUyDH7thepGQJnILO79MIJA2h0uFUuQiO7nUgDzwFgvPzrz?=
 =?iso-8859-1?Q?KZCwZwjXPc1vWt8zC8wMDnuLNDLLKf3UDLH3iefofcHRAWvppTBC08d9Wx?=
 =?iso-8859-1?Q?WzkzT1XGirNyu57xkerWfxnONMO6YkPfKmHhc1HG3/3LIk+GBGetEyC/P3?=
 =?iso-8859-1?Q?cMbwLpyL4F2odTAyWFXI52MJV/yQHD2TjsJXOMsMM/BCF74yCuhtnpnHWT?=
 =?iso-8859-1?Q?5LePrq3Dmf32OGS7uLoJ+NgOYba9/jyZFg9xxePQHcYIe7Bfwu4A9G8YGM?=
 =?iso-8859-1?Q?RnyYTagGrKm98PNYY7Bqb8jAwi7Y3mxGPuB6wyA9wWiDWIFfowkRByqAo8?=
 =?iso-8859-1?Q?7JKPNvM1QDF/I8LsveUXoq433urjy9a8qYj1qukm1BLWjzkJZmgVFlbln3?=
 =?iso-8859-1?Q?LNnuVC9Xlqb9FA+loaaIp1DX31hssnwc37AsoB2vTDUc1Z5ebhAw6upnif?=
 =?iso-8859-1?Q?krx0urqPBtJJ0ECsuVWtYYOV3346O3QBcOYR/Zzr4v6T2dKBTUAAiHwvZD?=
 =?iso-8859-1?Q?nKpCz86Y5xP2V4T7MVMC+JqD75oU3ScoPpR7RPQnPxRx+HTH7S5BTXJ0oZ?=
 =?iso-8859-1?Q?b8mw++Yma3wGq+THUgfuGolPtMmf4YrzE5u3uBbP9ytN+AzDuZ6QXwORuq?=
 =?iso-8859-1?Q?6ww2OzfI76c1vb8FnlPLH/C81xUnYOSec56bM/iY6qIFShGnl3CkB7K0CS?=
 =?iso-8859-1?Q?bxvM7gJd2ieeF795fPqyblxS6uvLZH/MJOpYy3hrkyPbEZfD/gJ6a2nBeo?=
 =?iso-8859-1?Q?eRIU6GjQ8yvQajTlexjC5ly7FRIhQG9qi+/axAjSOErYO1lqkzEGlpMSoi?=
 =?iso-8859-1?Q?QFyF7nZS0I4aGQTZdCSdfyI9n4q3h2lmPy7WPOPZnLv6iHnNL24IspnXl7?=
 =?iso-8859-1?Q?qXouAiQNJbiyrbOBYLia9EqLHSaOV9g=3D?=
Content-Type: multipart/mixed;
	boundary="_003_TYZPR01MB67582BE6855BE725AA5174CBDC332TYZPR01MB6758apcp_"
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: ntu.edu.sg
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYZPR01MB6758.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df53ecdc-094c-425b-a9a1-08dea82c234f
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 May 2026 09:21:05.7512
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 15ce9348-be2a-462b-8fc0-e1765a9b204a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7YzRCWw0+02bd17EokRA92MLIzyBTrfKDiKOMkG+witPauE26P+WSzIycMwoiEm2L+gNZVlN+k5CU6hOdlh+iw9FHUzXwVW2Dwn01XdJwE4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR01MB5219
X-Rspamd-Queue-Id: 49EA14B1810
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	SUBJECT_ENDS_QUESTION(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[ntu.edu.sg,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	R_DKIM_ALLOW(-0.20)[ntu.edu.sg:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[multipart/mixed,text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13205-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+,1:+,2:~,3:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[ntu.edu.sg:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maoyi.xie@ntu.edu.sg,io-uring@vger.kernel.org];
	HAS_ATTACHMENT(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_SENDER_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5]

--_003_TYZPR01MB67582BE6855BE725AA5174CBDC332TYZPR01MB6758apcp_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi all,

I think I have found what might be a bug in io_uring's absolute-deadline pa=
th on v7.0 mainline, and I would appreciate your confirmation on whether it=
 is actually a bug and whether it is worth fixing.

When a process inside a CLONE_NEWTIME time namespace submits IORING_OP_TIME=
OUT with IORING_TIMEOUT_ABS, the deadline is interpreted in host CLOCK_MONO=
TONIC instead of the caller's namespace view, so the timer can fire at the =
wrong moment.

A small reproducer (poc_iou_timens.c, attached) sets a -10 second CLOCK_MON=
OTONIC offset in a fresh time namespace and submits a "now + 1 second" abso=
lute deadline. On vanilla v7.0 the CQE comes back in well under a milliseco=
nd instead of the expected ~1 second.

    =3D=3D=3D baseline (host time_ns) =3D=3D=3D
    [parent] elapsed=3D1000.478 ms, cqe res=3D-62
    =3D=3D=3D child (NEWTIME, monotonic offset -10s) =3D=3D=3D
    [child]  elapsed=3D0.797   ms, cqe res=3D-62

The other absolute-deadline interfaces (timer_settime, clock_nanosleep with=
 TIMER_ABSTIME, alarm_timer_nsleep with TIMER_ABSTIME, timerfd_settime with=
 TFD_TIMER_ABSTIME) all run a user-supplied absolute timestamp through time=
ns_ktime_to_host() before arming the hrtimer. io_uring/timeout.c does not, =
which is why I am bringing it up. CONFIG_TIME_NS landed in 5.6 and IORING_T=
IMEOUT_ABS predates it. I do not know whether this was a deliberate choice =
when CONFIG_TIME_NS landed or simply not considered at the time, so I would=
 appreciate your view.

Could you let me know whether you consider this a bug worth fixing. If yes,=
 I would be happy to send a patch and a SQPOLL follow-up in a separate thre=
ad.

I have only tested the non-SQPOLL synchronous io_uring_enter path on x86_64=
 with KASAN and lockdep enabled. I have a small patch that fixes the synchr=
onous path and have re-run the same reproducer against it, where the child =
now sees ~1000 ms as expected.

Attachments:
  poc_iou_timens.c -- C reproducer, raw io_uring syscalls
  poc_post_patch.log -- reproducer output on the patched v7.0

Thanks for taking a look, and apologies in advance if this is already known=
 or out of scope.

Best regards,
Maoyi
Nanyang Technological University
https://maoyixie.com/
________________________________

CONFIDENTIALITY: This email is intended solely for the person(s) named and =
may be confidential and/or privileged. If you are not the intended recipien=
t, please delete it, notify us and do not copy, use, or disclose its conten=
ts.
Towards a sustainable earth: Print only when necessary. Thank you.

--_003_TYZPR01MB67582BE6855BE725AA5174CBDC332TYZPR01MB6758apcp_
Content-Type: application/octet-stream; name="poc_post_patch.log"
Content-Description: poc_post_patch.log
Content-Disposition: attachment; filename="poc_post_patch.log"; size=539;
	creation-date="Sat, 02 May 2026 08:58:52 GMT";
	modification-date="Sat, 02 May 2026 08:58:52 GMT"
Content-Transfer-Encoding: base64

V2FybmluZzogUGVybWFuZW50bHkgYWRkZWQgJ1sxMjcuMC4wLjFdOjEwMDIyJyAoRUQyNTUxOSkg
dG8gdGhlIGxpc3Qgb2Yga25vd24gaG9zdHMuDQo9PT0gYmFzZWxpbmUgKGhvc3QgdGltZV9ucykg
PT09CltwYXJlbnRdIG5ldG5zLXRpbWU9dGltZTpbNDAyNjUzMTgzNF0sIENMT0NLX01PTk9UT05J
Qz0yMTI4LjYyNDU4OTkwNgpbcGFyZW50XSBpb191cmluZ19lbnRlciByYz0xIGVycm5vPTAsIGVs
YXBzZWQ9MTAwMC4yNDggbXMsIGNxZT17cHJlc2VudD0xLHJlcz0tNjJ9Cgo9PT0gY2hpbGQgKE5F
V1RJTUUsIG1vbm90b25pYyBvZmZzZXQgLTEwcykgPT09CltjaGlsZF0gbmV0bnMtdGltZT10aW1l
Ols0MDI2NTMyMjYwXSwgQ0xPQ0tfTU9OT1RPTklDPTIxMTkuNjMzODk4NzE5CltjaGlsZF0gaW9f
dXJpbmdfZW50ZXIgcmM9MSBlcnJubz0wLCBlbGFwc2VkPTEwMDAuMjAzIG1zLCBjcWU9e3ByZXNl
bnQ9MSxyZXM9LTYyfQpbY2hpbGRdIE9LOiBkZWFkbGluZSBmaXJlZCB+MXMgYXMgZXhwZWN0ZWQg
KHRpbWVfbnMgb2Zmc2V0IGhvbm91cmVkKQo=

--_003_TYZPR01MB67582BE6855BE725AA5174CBDC332TYZPR01MB6758apcp_
Content-Type: text/plain; name="poc_iou_timens.c"
Content-Description: poc_iou_timens.c
Content-Disposition: attachment; filename="poc_iou_timens.c"; size=8467;
	creation-date="Sat, 02 May 2026 08:58:52 GMT";
	modification-date="Sat, 02 May 2026 08:58:52 GMT"
Content-Transfer-Encoding: base64

LyogUG9DIGZvciBpb191cmluZyBJT1JJTkdfT1BfVElNRU9VVCAoSU9SSU5HX1RJTUVPVVRfQUJT
KSBpZ25vcmluZyB0aW1lCiAqIG5hbWVzcGFjZSBvZmZzZXRzLgogKgogKiBJZGVhOgogKiAgIDEu
IHVuc2hhcmUoQ0xPTkVfTkVXVVNFUiB8IENMT05FX05FV1RJTUUpIGFuZCBzZXQgbW9ub3Rvbmlj
IG9mZnNldCB0bwogKiAgICAgIGEgbGFyZ2UgcG9zaXRpdmUgdmFsdWUgKHNvIGNoaWxkIHNlZXMg
Q0xPQ0tfTU9OT1RPTklDID0gaG9zdCAtIG9mZnNldCkuCiAqICAgICAgVGhlbiB3ZSBleGVjIGlu
dG8gdGhlIG5ldyB0aW1lX25zIHZpYSAvcHJvYy9zZWxmL25zL3RpbWVfZm9yX2NoaWxkcmVuCiAq
ICAgICAgYWZ0ZXIgZm9yay4KICogICAyLiBJbiB0aGUgY2hpbGQgKGluIHRpbWVfbnMpLCByZWFk
IENMT0NLX01PTk9UT05JQyAtPiB0X25zOyBzdWJtaXQKICogICAgICBJT1JJTkdfT1BfVElNRU9V
VCB3aXRoIElPUklOR19USU1FT1VUX0FCUywgZGVhZGxpbmUgPSB0X25zICsgMXMuCiAqICAgICAg
TWVhc3VyZSBob3cgbG9uZyBpb191cmluZ19lbnRlciBibG9ja3Mgd2FpdGluZyBmb3IgdGhlIENR
RS4KICoKICogVmFuaWxsYSBidWcgYmVoYXZpb3VyOiBpb191cmluZyBjb21wdXRlcyBocnRpbWVy
IGluIGhvc3QgQ0xPQ0tfTU9OT1RPTklDCiAqICAgdmlldzsgY2hpbGQncyB0X25zICsgMXMgaXMg
d2F5IGluIHRoZSBwYXN0IGZyb20gaG9zdCdzIFBPViAoYmVjYXVzZQogKiAgIHRoZSBvZmZzZXQg
c2hpZnRzIHRpbWVfbnMgQ0xPQ0tfTU9OT1RPTklDIGludG8gdGhlIHBhc3QpLiBocnRpbWVyCiAq
ICAgZmlyZXMgaW1tZWRpYXRlbHkuIE9ic2VydmVkIHdhaXQgPDwgMXMgKG9mdGVuIG1pY3Jvc2Vj
b25kcykuCiAqCiAqIEZpeGVkIGtlcm5lbCBiZWhhdmlvdXI6IGlvX3VyaW5nIGNvbnZlcnRzIHRf
bnMgKyAxcyB0aHJvdWdoCiAqICAgdGltZW5zX2t0aW1lX3RvX2hvc3QoKTsgaHJ0aW1lciBmaXJl
cyB+MXMgYWZ0ZXIgc3VibWl0LiBPYnNlcnZlZCB3YWl0CiAqICAgfjFzLgogKgogKiBCdWlsZDog
Z2NjIHBvY19pb3VfdGltZW5zLmMgLW8gcG9jX2lvdV90aW1lbnMKICogUnVuOiAgIC4vcG9jX2lv
dV90aW1lbnMgICAobXVzdCBiZSB1bnByaXZpbGVnZWQtdXNlcm5zIGNhcGFibGUga2VybmVsKQog
Ki8KI2RlZmluZSBfR05VX1NPVVJDRQojaW5jbHVkZSA8c3RkaW8uaD4KI2luY2x1ZGUgPHN0ZGxp
Yi5oPgojaW5jbHVkZSA8c3RyaW5nLmg+CiNpbmNsdWRlIDx1bmlzdGQuaD4KI2luY2x1ZGUgPGVy
cm5vLmg+CiNpbmNsdWRlIDxmY250bC5oPgojaW5jbHVkZSA8c2NoZWQuaD4KI2luY2x1ZGUgPHNp
Z25hbC5oPgojaW5jbHVkZSA8c3RkaW50Lmg+CiNpbmNsdWRlIDx0aW1lLmg+CiNpbmNsdWRlIDxz
eXMvc3lzY2FsbC5oPgojaW5jbHVkZSA8c3lzL21tYW4uaD4KI2luY2x1ZGUgPHN5cy93YWl0Lmg+
CiNpbmNsdWRlIDxzeXMvdWlvLmg+CiNpbmNsdWRlIDxsaW51eC9pb191cmluZy5oPgoKI2lmbmRl
ZiBDTE9ORV9ORVdUSU1FCiNkZWZpbmUgQ0xPTkVfTkVXVElNRSAweDAwMDAwMDgwCiNlbmRpZgoK
LyogRnJvbSA8bGludXgvaW9fdXJpbmcuaD46IGVudW0gY29kZXMgKHZlcmlmeSB0aGV5IG1hdGNo
IHRoZSBydW5uaW5nIGtlcm5lbCBVQVBJKSAqLwojaWZuZGVmIElPUklOR19PUF9USU1FT1VUCiNk
ZWZpbmUgSU9SSU5HX09QX1RJTUVPVVQgMTEKI2VuZGlmCiNpZm5kZWYgSU9SSU5HX1RJTUVPVVRf
QUJTCiNkZWZpbmUgSU9SSU5HX1RJTUVPVVRfQUJTICgxVSA8PCAwKQojZW5kaWYKCnN0YXRpYyBp
bnQgaW9fdXJpbmdfc2V0dXAodW5zaWduZWQgZW50cmllcywgc3RydWN0IGlvX3VyaW5nX3BhcmFt
cyAqcCkKeyByZXR1cm4gKGludClzeXNjYWxsKF9fTlJfaW9fdXJpbmdfc2V0dXAsIGVudHJpZXMs
IHApOyB9CnN0YXRpYyBpbnQgaW9fdXJpbmdfZW50ZXIoaW50IGZkLCB1bnNpZ25lZCB0b19zdWJt
aXQsIHVuc2lnbmVkIG1pbl9jb21wbGV0ZSwKICAgICAgICAgICAgICAgICAgICAgICAgICB1bnNp
Z25lZCBmbGFncywgc2lnc2V0X3QgKnNpZykKeyByZXR1cm4gKGludClzeXNjYWxsKF9fTlJfaW9f
dXJpbmdfZW50ZXIsIGZkLCB0b19zdWJtaXQsIG1pbl9jb21wbGV0ZSwgZmxhZ3MsIHNpZywgMCk7
IH0KCnN0cnVjdCByaW5nIHsKICAgIGludCBmZDsKICAgIHZvaWQgKnNxX3B0cjsgc2l6ZV90IHNx
X3NpemU7CiAgICB2b2lkICpjcV9wdHI7IHNpemVfdCBjcV9zaXplOwogICAgdm9pZCAqc3FlX3B0
cjsgc2l6ZV90IHNxZV9zaXplOwogICAgdW5zaWduZWQgKnNxX2hlYWQsICpzcV90YWlsLCAqc3Ff
bWFzaywgKnNxX2FycmF5OwogICAgdW5zaWduZWQgKmNxX2hlYWQsICpjcV90YWlsLCAqY3FfbWFz
azsKICAgIHN0cnVjdCBpb191cmluZ19zcWUgKnNxZXM7CiAgICBzdHJ1Y3QgaW9fdXJpbmdfY3Fl
ICpjcWVzOwp9OwoKc3RhdGljIGludCByaW5nX3NldHVwKHN0cnVjdCByaW5nICpyLCB1bnNpZ25l
ZCBlbnRyaWVzKQp7CiAgICBzdHJ1Y3QgaW9fdXJpbmdfcGFyYW1zIHAgPSB7MH07CiAgICByLT5m
ZCA9IGlvX3VyaW5nX3NldHVwKGVudHJpZXMsICZwKTsKICAgIGlmIChyLT5mZCA8IDApIHsgcGVy
cm9yKCJpb191cmluZ19zZXR1cCIpOyByZXR1cm4gLTE7IH0KCiAgICByLT5zcV9zaXplID0gcC5z
cV9vZmYuYXJyYXkgKyBwLnNxX2VudHJpZXMgKiBzaXplb2YodW5zaWduZWQpOwogICAgci0+Y3Ff
c2l6ZSA9IHAuY3Ffb2ZmLmNxZXMgKyBwLmNxX2VudHJpZXMgKiBzaXplb2Yoc3RydWN0IGlvX3Vy
aW5nX2NxZSk7CiAgICByLT5zcWVfc2l6ZSA9IHAuc3FfZW50cmllcyAqIHNpemVvZihzdHJ1Y3Qg
aW9fdXJpbmdfc3FlKTsKCiAgICByLT5zcV9wdHIgPSBtbWFwKDAsIHItPnNxX3NpemUsIFBST1Rf
UkVBRHxQUk9UX1dSSVRFLCBNQVBfU0hBUkVEfE1BUF9QT1BVTEFURSwKICAgICAgICAgICAgICAg
ICAgICAgci0+ZmQsIElPUklOR19PRkZfU1FfUklORyk7CiAgICByLT5jcV9wdHIgPSBtbWFwKDAs
IHItPmNxX3NpemUsIFBST1RfUkVBRHxQUk9UX1dSSVRFLCBNQVBfU0hBUkVEfE1BUF9QT1BVTEFU
RSwKICAgICAgICAgICAgICAgICAgICAgci0+ZmQsIElPUklOR19PRkZfQ1FfUklORyk7CiAgICBy
LT5zcWVfcHRyID0gbW1hcCgwLCByLT5zcWVfc2l6ZSwgUFJPVF9SRUFEfFBST1RfV1JJVEUsIE1B
UF9TSEFSRUR8TUFQX1BPUFVMQVRFLAogICAgICAgICAgICAgICAgICAgICAgci0+ZmQsIElPUklO
R19PRkZfU1FFUyk7CiAgICBpZiAoci0+c3FfcHRyID09IE1BUF9GQUlMRUQgfHwgci0+Y3FfcHRy
ID09IE1BUF9GQUlMRUQgfHwgci0+c3FlX3B0ciA9PSBNQVBfRkFJTEVEKSB7CiAgICAgICAgcGVy
cm9yKCJtbWFwIik7IHJldHVybiAtMTsKICAgIH0KICAgIHItPnNxX2hlYWQgID0gci0+c3FfcHRy
ICsgcC5zcV9vZmYuaGVhZDsKICAgIHItPnNxX3RhaWwgID0gci0+c3FfcHRyICsgcC5zcV9vZmYu
dGFpbDsKICAgIHItPnNxX21hc2sgID0gci0+c3FfcHRyICsgcC5zcV9vZmYucmluZ19tYXNrOwog
ICAgci0+c3FfYXJyYXkgPSByLT5zcV9wdHIgKyBwLnNxX29mZi5hcnJheTsKICAgIHItPmNxX2hl
YWQgID0gci0+Y3FfcHRyICsgcC5jcV9vZmYuaGVhZDsKICAgIHItPmNxX3RhaWwgID0gci0+Y3Ff
cHRyICsgcC5jcV9vZmYudGFpbDsKICAgIHItPmNxX21hc2sgID0gci0+Y3FfcHRyICsgcC5jcV9v
ZmYucmluZ19tYXNrOwogICAgci0+c3FlcyAgICAgPSByLT5zcWVfcHRyOwogICAgci0+Y3FlcyAg
ICAgPSByLT5jcV9wdHIgKyBwLmNxX29mZi5jcWVzOwogICAgcmV0dXJuIDA7Cn0KCnN0YXRpYyBp
bnQgc3VibWl0X3RpbWVvdXRfYWJzKHN0cnVjdCByaW5nICpyLCBzdHJ1Y3QgX19rZXJuZWxfdGlt
ZXNwZWMgKmRlYWRsaW5lKQp7CiAgICB1bnNpZ25lZCB0YWlsID0gKnItPnNxX3RhaWw7CiAgICB1
bnNpZ25lZCBpZHggPSB0YWlsICYgKnItPnNxX21hc2s7CiAgICBzdHJ1Y3QgaW9fdXJpbmdfc3Fl
ICpzcWUgPSAmci0+c3Flc1tpZHhdOwogICAgbWVtc2V0KHNxZSwgMCwgc2l6ZW9mKCpzcWUpKTsK
ICAgIHNxZS0+b3Bjb2RlID0gSU9SSU5HX09QX1RJTUVPVVQ7CiAgICBzcWUtPmZkID0gLTE7CiAg
ICBzcWUtPmFkZHIgPSAodWludHB0cl90KWRlYWRsaW5lOwogICAgc3FlLT5sZW4gPSAxOwogICAg
c3FlLT5vZmYgPSAwOwogICAgc3FlLT50aW1lb3V0X2ZsYWdzID0gSU9SSU5HX1RJTUVPVVRfQUJT
OwogICAgc3FlLT51c2VyX2RhdGEgPSAweENBRkVCQUJFOwogICAgci0+c3FfYXJyYXlbaWR4XSA9
IGlkeDsKICAgIF9fYXRvbWljX3N0b3JlX24oci0+c3FfdGFpbCwgdGFpbCArIDEsIF9fQVRPTUlD
X1JFTEVBU0UpOwogICAgcmV0dXJuIGlvX3VyaW5nX2VudGVyKHItPmZkLCAxLCAxLCBJT1JJTkdf
RU5URVJfR0VURVZFTlRTLCBOVUxMKTsKfQoKc3RhdGljIGxvbmcgZWxhcHNlZF9ucyhzdHJ1Y3Qg
dGltZXNwZWMgKmEsIHN0cnVjdCB0aW1lc3BlYyAqYikKewogICAgcmV0dXJuIChiLT50dl9zZWMg
LSBhLT50dl9zZWMpICogMTAwMDAwMDAwMEwgKyAoYi0+dHZfbnNlYyAtIGEtPnR2X25zZWMpOwp9
CgpzdGF0aWMgaW50IHJ1bl9pbl90aW1lbnMoaW50IGRvX3Vuc2hhcmVfdGltZSkKewogICAgLyog
UmVhZCBDTE9DS19NT05PVE9OSUMgaW4gY3VycmVudCBuYW1lc3BhY2UgKi8KICAgIHN0cnVjdCB0
aW1lc3BlYyB0MDsKICAgIGNsb2NrX2dldHRpbWUoQ0xPQ0tfTU9OT1RPTklDLCAmdDApOwogICAg
Y2hhciBuc2FbNjRdOyBpbnQgcmwgPSByZWFkbGluaygiL3Byb2Mvc2VsZi9ucy90aW1lIiwgbnNh
LCA2Myk7CiAgICBuc2FbcmwgPiAwID8gcmwgOiAwXSA9IDA7CiAgICBmcHJpbnRmKHN0ZGVyciwg
Ilslc10gbmV0bnMtdGltZT0lcywgQ0xPQ0tfTU9OT1RPTklDPSVsZC4lMDlsZFxuIiwKICAgICAg
ICAgICAgZG9fdW5zaGFyZV90aW1lID8gImNoaWxkIiA6ICJwYXJlbnQiLAogICAgICAgICAgICBu
c2EsIChsb25nKXQwLnR2X3NlYywgdDAudHZfbnNlYyk7CgogICAgc3RydWN0IHJpbmcgciA9IHsw
fTsKICAgIGlmIChyaW5nX3NldHVwKCZyLCA4KSA8IDApIHJldHVybiAxOwoKICAgIC8qIERlYWRs
aW5lID0gbm93ICsgMXMsIEFCUyBpbiBjYWxsZXIncyB0aW1lIHZpZXcgKi8KICAgIHN0cnVjdCB0
aW1lc3BlYyBub3c7CiAgICBjbG9ja19nZXR0aW1lKENMT0NLX01PTk9UT05JQywgJm5vdyk7CiAg
ICBzdHJ1Y3QgX19rZXJuZWxfdGltZXNwZWMgZDsKICAgIGQudHZfc2VjID0gbm93LnR2X3NlYyAr
IDE7CiAgICBkLnR2X25zZWMgPSBub3cudHZfbnNlYzsKCiAgICBzdHJ1Y3QgdGltZXNwZWMgdF9w
cmUsIHRfcG9zdDsKICAgIGNsb2NrX2dldHRpbWUoQ0xPQ0tfTU9OT1RPTklDLCAmdF9wcmUpOwog
ICAgaW50IHJjID0gc3VibWl0X3RpbWVvdXRfYWJzKCZyLCAmZCk7CiAgICBjbG9ja19nZXR0aW1l
KENMT0NLX01PTk9UT05JQywgJnRfcG9zdCk7CiAgICBsb25nIG5zID0gZWxhcHNlZF9ucygmdF9w
cmUsICZ0X3Bvc3QpOwoKICAgIC8qIENoZWNrIENRRSAqLwogICAgdW5zaWduZWQgaGVhZCA9ICpy
LmNxX2hlYWQ7CiAgICB1bnNpZ25lZCB0YWlsID0gX19hdG9taWNfbG9hZF9uKHIuY3FfdGFpbCwg
X19BVE9NSUNfQUNRVUlSRSk7CiAgICBpbnQgZ290X2NxZSA9IDA7CiAgICBpbnQgY3FlX3JlcyA9
IDA7CiAgICBpZiAodGFpbCAhPSBoZWFkKSB7CiAgICAgICAgc3RydWN0IGlvX3VyaW5nX2NxZSAq
Y3FlID0gJnIuY3Flc1toZWFkICYgKnIuY3FfbWFza107CiAgICAgICAgY3FlX3JlcyA9IGNxZS0+
cmVzOwogICAgICAgIGdvdF9jcWUgPSAxOwogICAgICAgIF9fYXRvbWljX3N0b3JlX24oci5jcV9o
ZWFkLCBoZWFkICsgMSwgX19BVE9NSUNfUkVMRUFTRSk7CiAgICB9CiAgICBmcHJpbnRmKHN0ZGVy
ciwKICAgICAgICAiWyVzXSBpb191cmluZ19lbnRlciByYz0lZCBlcnJubz0lZCwgZWxhcHNlZD0l
bGQuJTAzbGQgbXMsICIKICAgICAgICAiY3FlPXtwcmVzZW50PSVkLHJlcz0lZH1cbiIsCiAgICAg
ICAgZG9fdW5zaGFyZV90aW1lID8gImNoaWxkIiA6ICJwYXJlbnQiLAogICAgICAgIHJjLCBlcnJu
bywgbnMvMTAwMDAwMCwgKG5zLzEwMDApJTEwMDAsIGdvdF9jcWUsIGNxZV9yZXMpOwoKICAgIGlm
IChkb191bnNoYXJlX3RpbWUpIHsKICAgICAgICBpZiAobnMgPCAxMDAqMTAwMCoxMDAwTCkKICAg
ICAgICAgICAgZnByaW50ZihzdGRlcnIsCiAgICAgICAgICAgICAgICAiW2NoaWxkXSAqKiogQlVH
OiBBQlMgZGVhZGxpbmUgMXMgaW4gZnV0dXJlIGZpcmVkIGluICVsZCBtcyDigJQgIgogICAgICAg
ICAgICAgICAgImlvX3VyaW5nIGlzIHVzaW5nIEhPU1QgQ0xPQ0tfTU9OT1RPTklDLCBub3QgdGhl
IHRpbWVfbnMgdmlldyAqKipcbiIsCiAgICAgICAgICAgICAgICBucy8xMDAwMDAwKTsKICAgICAg
ICBlbHNlIGlmIChucyA+PSA4MDAqMTAwMCoxMDAwTCAmJiBucyA8PSAxNTAwKjEwMDAqMTAwMEwp
CiAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLAogICAgICAgICAgICAgICAgIltjaGlsZF0gT0s6
IGRlYWRsaW5lIGZpcmVkIH4xcyBhcyBleHBlY3RlZCAodGltZV9ucyBvZmZzZXQgaG9ub3VyZWQp
XG4iKTsKICAgICAgICBlbHNlCiAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLAogICAgICAgICAg
ICAgICAgIltjaGlsZF0gPz8/IHVuZXhwZWN0ZWQgdGltaW5nICVsZCBtc1xuIiwgbnMvMTAwMDAw
MCk7CiAgICB9CiAgICBtdW5tYXAoci5zcV9wdHIsIHIuc3Ffc2l6ZSk7CiAgICBtdW5tYXAoci5j
cV9wdHIsIHIuY3Ffc2l6ZSk7CiAgICBtdW5tYXAoci5zcWVfcHRyLCByLnNxZV9zaXplKTsKICAg
IGNsb3NlKHIuZmQpOwogICAgcmV0dXJuIDA7Cn0KCmludCBtYWluKHZvaWQpCnsKICAgIC8qIEZp
cnN0IGluIGN1cnJlbnQgbnM6IHNhbml0eSBiYXNlbGluZSAobXVzdCB0YWtlIH4xcykuICovCiAg
ICBmcHJpbnRmKHN0ZGVyciwgIj09PSBiYXNlbGluZSAoaG9zdCB0aW1lX25zKSA9PT1cbiIpOwog
ICAgcnVuX2luX3RpbWVucygwKTsKCiAgICAvKiBOb3cgY3JlYXRlIGEgdGltZV9ucyB3aXRoIGEg
bm9uLXplcm8gbW9ub3RvbmljIG9mZnNldCBhbmQgcmUtcnVuLiAqLwogICAgLyogdW5zaGFyZSBD
TE9ORV9ORVdVU0VSfENMT05FX05FV1RJTUUsIHdyaXRlIHRpbWVucyBvZmZzZXRzIHZpYQogICAg
ICogL3Byb2Mvc2VsZi90aW1lbnNfb2Zmc2V0cywgdGhlbiBleGVjIGEgY2hpbGQgdmlhIGZvcmsg
dGhhdCByZS1leGVjcwogICAgICogaW5oZXJpdGluZyB0aW1lX25zX2Zvcl9jaGlsZHJlbi4gKi8K
ICAgIGlmICh1bnNoYXJlKENMT05FX05FV1VTRVIgfCBDTE9ORV9ORVdUSU1FKSA8IDApIHsKICAg
ICAgICBwZXJyb3IoInVuc2hhcmUoTkVXVVNFUnxORVdUSU1FKSIpOyByZXR1cm4gMTsKICAgIH0K
ICAgIGludCBmZCA9IG9wZW4oIi9wcm9jL3NlbGYvc2V0Z3JvdXBzIiwgT19XUk9OTFkpOwogICAg
aWYgKGZkID49IDApIHsgd3JpdGUoZmQsICJkZW55IiwgNCk7IGNsb3NlKGZkKTsgfQogICAgZmQg
PSBvcGVuKCIvcHJvYy9zZWxmL3VpZF9tYXAiLCBPX1dST05MWSk7CiAgICBpZiAoZmQgPj0gMCkg
eyB3cml0ZShmZCwgIjAgMCAxXG4iLCA2KTsgY2xvc2UoZmQpOyB9CiAgICBmZCA9IG9wZW4oIi9w
cm9jL3NlbGYvZ2lkX21hcCIsIE9fV1JPTkxZKTsKICAgIGlmIChmZCA+PSAwKSB7IHdyaXRlKGZk
LCAiMCAwIDFcbiIsIDYpOyBjbG9zZShmZCk7IH0KCiAgICAvKiBTZXQgbW9ub3RvbmljIG9mZnNl
dCA9IC0xMCBzZWMgKHNoaWZ0IGNoaWxkJ3MgTU9OT1RPTklDIDEwcyBpbnRvIHRoZQogICAgICog
cGFzdCByZWxhdGl2ZSB0byBob3N0KS4gRm9ybWF0OiAiPGNsa2lkPiA8c2Vjcz4gPG5hbm9zPlxu
Ii4KICAgICAqIENMT0NLX01PTk9UT05JQz0xLCBDTE9DS19CT09UVElNRT03LiBUaGUga2VybmVs
IHJlamVjdHMgb2Zmc2V0cwogICAgICogbGFyZ2VyIHRoYW4gY3VycmVudCB1cHRpbWU7IC0xMHMg
aXMgZmluZSBhZnRlciBhIGZldyBzZWNvbmRzIG9mIGJvb3QuICovCiAgICBmZCA9IG9wZW4oIi9w
cm9jL3NlbGYvdGltZW5zX29mZnNldHMiLCBPX1dST05MWSk7CiAgICBpZiAoZmQgPCAwKSB7IHBl
cnJvcigib3BlbiB0aW1lbnNfb2Zmc2V0cyIpOyByZXR1cm4gMTsgfQogICAgY29uc3QgY2hhciAq
b2ZmID0gIjEgLTEwIDBcbjcgLTEwIDBcbiI7CiAgICBpZiAod3JpdGUoZmQsIG9mZiwgc3RybGVu
KG9mZikpIDwgMCkgewogICAgICAgIHBlcnJvcigid3JpdGUgdGltZW5zX29mZnNldHMiKTsgY2xv
c2UoZmQpOyByZXR1cm4gMTsKICAgIH0KICAgIGNsb3NlKGZkKTsKCiAgICAvKiBmb3JrOyBjaGls
ZCBpbmhlcml0cyB0aW1lX25zX2Zvcl9jaGlsZHJlbi4gKi8KICAgIHBpZF90IHBpZCA9IGZvcmso
KTsKICAgIGlmIChwaWQgPT0gMCkgewogICAgICAgIGZwcmludGYoc3RkZXJyLCAiXG49PT0gY2hp
bGQgKE5FV1RJTUUsIG1vbm90b25pYyBvZmZzZXQgLTEwcykgPT09XG4iKTsKICAgICAgICBydW5f
aW5fdGltZW5zKDEpOwogICAgICAgIF9leGl0KDApOwogICAgfQogICAgaW50IHN0OyB3YWl0cGlk
KHBpZCwgJnN0LCAwKTsKICAgIHJldHVybiAwOwp9Cg==

--_003_TYZPR01MB67582BE6855BE725AA5174CBDC332TYZPR01MB6758apcp_--

