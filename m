Return-Path: <io-uring+bounces-4197-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 28BD69B6234
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 12:48:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DBF0B283370
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 11:48:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE1DA1E47CE;
	Wed, 30 Oct 2024 11:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="dAnyJ3ov"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84CE01DC759;
	Wed, 30 Oct 2024 11:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730288914; cv=fail; b=PRpiIEq4VVPKOLSVOeJLfVGNDYP0LYEmf2i+/MRoH9vQUg8/74ZNYe+gL8AGuMQenPSI8MgQQi+a4nkxlvRHaOOTYaUT2j7X/37TGrnR18o8XDIo0DPNK9L/oemSE7hxslpM+3SZ6ObOsGA71sPQZyUKWmlVB9U8NuccICk8FP4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730288914; c=relaxed/simple;
	bh=PnO3ZxJuNm8QL9FLsXDy7d8tzBWug5YAP3tHduInMvg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rlC3bUKl72JFeooCHlBVsqyssqRiPitEIUpalc3Yyw6t/IYRquwMuwzQjhHTmRF8JB+X8whpI8nQlrXiIzSPbGgQAZSnBbD1qK06HpbUKTCAkZIRfkUW3Jp0yC7w+QTLmhxruI0YtT4ua6PKLyyAihQ5KAKp0i+3Xkv9w6re+z8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=dAnyJ3ov; arc=fail smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49UAngGR004844;
	Wed, 30 Oct 2024 04:48:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	s2048-2021-q4; bh=PnO3ZxJuNm8QL9FLsXDy7d8tzBWug5YAP3tHduInMvg=; b=
	dAnyJ3ov8m0tizr+zD378IyRh7KzjV+abp3IUSrG7BLk2p2T9xKBQAn4UaRmdnpi
	M7rZvuQt4gU0ZPAvfN0Z76gaXaxg/DU3j4eIdvfzdlBeja8/EiuT9heYLw41x4RB
	LVY7Y1dgziMMTujvhQldToEaipsKZpDho2n3cZI9SPwx7pAc116Xq09JaT+ZsfwV
	8VVZy1zeQdC6UUs4HOA1EK12OAP7aWnJ0NJIjwZFqVeq04FM3jhGbcZJQnNiIimO
	Jb/uL4DXGyOnCuT/9Hl10/nFQkMXd5RBT0kEGPlr1TX8IZnGqbF4xkoi0rYVNymD
	3gSGofv8KPObYn5N30Al2Q==
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 42kkcmraj1-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Oct 2024 04:48:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=woMc2I/LRoJnlCLc6+LF/nOhXkVuI5YWy0guAZ5xFusOKUUVSBygyJqO2JS5gyeOf0ku/tYlw7bId0AFbwQWq2A9IuAcbMiOEvenvwqoIk8anuwqfNzKZpEioE35I71zjlD6MNg1eOdkw5uNKdIPa3UbW9ctYAXdFGlnokbVyxROtvUSMQoy7pLaXiM4yjZi13jLVpQr4+rFqZpp4GXrBo2ffvk9A/T8iMDClUdhFyHJk8dJqOfJ8rLDocmQvQjOICbzvM4u3Fj/mM0J14Mxz3aJNg/QU66h7RaberBEW4jzlSahFwLPezzWpZi7fsVF1OTzouAZ/KkGugfrZovRjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PnO3ZxJuNm8QL9FLsXDy7d8tzBWug5YAP3tHduInMvg=;
 b=ItZMimC9U4pIYt+QM0foWMtE7NsaB5sr8CJTriQ/+m5tok7S7NvKGJSt+HtYxQDj9+TQJn9DlTKifO5oSFh22R7pY+pEZREGQM7Wcmriv2KOEPjjsVkVzAdRf5AZFcueLJH/piuWO3sykS+uqpViMO22wHjOynrPmmAwMc687cBdM/Q64aDjbMUhQtHYaE7QKXcQ8N5iWn8dJq/h5z62+tvcS02bdXEwVHMKIzuG3Luo+aghDVNRNFW5XfVVMzPjUBoZFLdzSUxyFtugodko/oEAKm9o+rKtLBguKHM/DOAW9A7w7aml6xwJvtyQmI00oGUlJ8Sw3Id/Gvdso0xDLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SJ2PR15MB5669.namprd15.prod.outlook.com (2603:10b6:a03:4c0::15)
 by CO1PR15MB5034.namprd15.prod.outlook.com (2603:10b6:303:e9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.20; Wed, 30 Oct
 2024 11:48:27 +0000
Received: from SJ2PR15MB5669.namprd15.prod.outlook.com
 ([fe80::bff4:aff5:7657:9fe8]) by SJ2PR15MB5669.namprd15.prod.outlook.com
 ([fe80::bff4:aff5:7657:9fe8%6]) with mapi id 15.20.8093.024; Wed, 30 Oct 2024
 11:48:26 +0000
From: Mark Harmstone <maharmstone@meta.com>
To: Anand Jain <anand.jain@oracle.com>, Mark Harmstone <maharmstone@meta.com>
CC: "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v4 0/5] btrfs: io_uring interface for encoded reads
Thread-Topic: [PATCH v4 0/5] btrfs: io_uring interface for encoded reads
Thread-Index: AQHbJJHBGU/CKSkKSEaVm6GhyzSUH7Kei0MAgACu2oA=
Date: Wed, 30 Oct 2024 11:48:26 +0000
Message-ID: <236674a5-a96d-4a87-8015-66e2bb4cf660@meta.com>
References: <20241022145024.1046883-1-maharmstone@fb.com>
 <2117807e-3863-4809-8447-a7dd2bec436a@oracle.com>
In-Reply-To: <2117807e-3863-4809-8447-a7dd2bec436a@oracle.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR15MB5669:EE_|CO1PR15MB5034:EE_
x-ms-office365-filtering-correlation-id: 469bffcb-8e08-4770-9132-08dcf8d8c419
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?STZwUmlYaXpjc0pXVnNCSStYYm9Sc1B2blRRakt1d0U3czB2dzZMem8ydnFn?=
 =?utf-8?B?TkJEREJhY2w1eE8wT2dVZGdJYXdoNmQ1OCs3WGtrZFkvVHpqZWRJaWcxYnox?=
 =?utf-8?B?MmRSdEo3WmlFc2IwWXMwbHdJVHpBa2tzemgzQll2VU1kS2l1M1FGVG4yUElx?=
 =?utf-8?B?MXhRamtsYkNQRmhjdHZqWDBkVjVoRHIrNk1EdnFiRmIxa3RhL3FXUCt4bWpJ?=
 =?utf-8?B?ZmQzUUtQcTlqaXNiWHk4RmFyZ1BEc09WWDVFR1JOMTBHQXBadGdBNm5PUFh3?=
 =?utf-8?B?SjNHUGtvYWZaUnN5cnNmaTBFRVovREk2S1djZStyM0xPQWhLN3BRZ01qWnZX?=
 =?utf-8?B?UlFHUHEvSEdWUFd2UEtxa2diODdEWjhkZ25ZcUo2cldNWGVWbjFJTmtrakFv?=
 =?utf-8?B?YklTUkNkNGR6anAzcHFHK0JKUjhJT3orZ0pRODRSanRKdHg1SDBPZ1NQeEpt?=
 =?utf-8?B?Nlh1SWpUYXFsbFYrRThUV0hCYmZZSFBnYlhGWDJ3c3FwRnhqSTNqQ0VlQ1ZR?=
 =?utf-8?B?eWpueElIZ042YWhmVXlubUw1d1ovYUxaRE5MMzZkSCthYVN4V2Q5a3lCVllO?=
 =?utf-8?B?V1RQRjNXZXVZK0x1MW1YTFFIb2l4dUVNVXd3eEhrdUZuOWpMRzlIbXgzSWI5?=
 =?utf-8?B?NitIOXN6QTJKbkJTeWMzVHF6eVFFSWVQUkRHUXlFSmIzT2dvdTFMbDI2S281?=
 =?utf-8?B?d2JsaitXY1FKNTVPTkhRcjBaZm4yVW8zOG5yd09hcm45L1JsU09LSnpCL1Bi?=
 =?utf-8?B?cDlxdWlsQVhwOEs3cS9BNm5SQkVYaFhac3R0bzJJRUIvTHFkSFZmbDhVMmIv?=
 =?utf-8?B?c01SVUg1V2RuSC9Ea1AyMS9LdEhxWFlXK2NCM1RPRXpzNm5GVW5YREhBbEp6?=
 =?utf-8?B?ejJZYjRuVWh5UUJTNHUrRE5vcFZLZzZJMVBmdnNmRERYaCtMcGE3VHdXWDh2?=
 =?utf-8?B?aytQOFgvQm9Mb3JPeHBFcEZUSkwxV0VDUjdCWDBKOTJ0MjcrR0w4RkJtdUJp?=
 =?utf-8?B?OXkzUGhaazdLSTd0OEhaUUZSTUU1UmtFOWpXd1NUTWg5MllRaDk1RDdtcGdl?=
 =?utf-8?B?dk0rYUJ6c3JrVFM5Q05ySEZXU1RpWC9IOHdVWHZxVTdJSUlDZ1VjWTRpZ0xZ?=
 =?utf-8?B?UkN1Q1pzdmowVTBzUnhxU1p5cWpYODNJL09OMGg3N2lvUkFWeU9qeFVJNkRk?=
 =?utf-8?B?OGdsUTJqa1pCaEZWZktteHE3SlpPbnUyQnFmMlVmejA3T0ppMnozV3VJd3Nw?=
 =?utf-8?B?Tmw0RXFrUkFTQUREUnorSndROGhWbktrRmZYY1YxdFpxK3ZxR051eXRTcE5p?=
 =?utf-8?B?eVYrUTVWNUR3M2JNbXl5RzdLVkFqNE9jVHd5dmJMbkxJNnFycDRZLzdHRGhZ?=
 =?utf-8?B?WUFHL1RweTRNeTZqWWFEZVI3Wng4a1NTS3VxeE4zNE1LcWpVQ1BPRTdQc0dn?=
 =?utf-8?B?NDZiQ3VCT0x2ODlRdkNxNUN2YXYzU1ByVDRRaE5oaG5RcTNFR3pGaFMrWE4x?=
 =?utf-8?B?YncwaDNOcHNZcGxwV3o1K3c3aGw2V2lrR2tJdSswTWNsQ2c5R3h0MXFkeG5o?=
 =?utf-8?B?SDVQaXpZUmV5ZWM5QnJpSEpaVTFqcTUxSm9mZXJ5clI4UGpOaGdBelFQVzBt?=
 =?utf-8?B?akM5di9UN3o1MWdNTVR0YlFWSHIxcmdIeHh6dmVHMmtNcjVJMEozSDdQZktn?=
 =?utf-8?B?K1A2TlNFRHdpN2hIaTBick9JR1EvdmpScUU3blJyaHpEdFUrWFZvQm9VbHZR?=
 =?utf-8?B?ZVQ3YmkzR3VRTEZoWktVUzZTMjJpUFFYRDBkb1VZZHA0dS9Cb1VkallsQ1cx?=
 =?utf-8?Q?i/4neMzEh3557l3qF7ib4dihRQ9can/V1ChNM=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR15MB5669.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NGJNZzlIejVjSDZCOU84alRUMFFrSGwwUDcrVFErN3hPY0N3ODVsUFM0UnRu?=
 =?utf-8?B?VlhjSVBLS2p1NDkwQnNKazZtS1BlVnZJVCtmQy9CQ3JDTi94RG90amdLYllv?=
 =?utf-8?B?V0p0UzVoaGhwVXZrZEVmWE9jQmttcFE4emhGSEJjeG5zQTlsMTNQTmRuK3VV?=
 =?utf-8?B?em85cW1BNHBnWkRqS291TVM2MXF4TjZHeFhJdzBkci93VUp2WVQ3Q3E4SExB?=
 =?utf-8?B?YVN4NHVwRStjclZITDlocEUxblVTTDBZbHVJT1ZkdCsvYVVqdHcvaWlPb0dG?=
 =?utf-8?B?NTM5dFV0RDBvdnNkcDdrVXJxWjVmOUFqeU94WFlJLzFYd004NkdqMUVGRGF5?=
 =?utf-8?B?WmZEN0pkdFhRdzZRZ0tXRWd3L2x2b2YvYXVVckFuV214Qmo4ZGl0MVNpeWpn?=
 =?utf-8?B?T1ZoRDlNNVZpd0hrWTRXQ3pLSmgySWhYd2djcVhzdjNWb1Urb2htN1VwM0Rl?=
 =?utf-8?B?MVFlL2xEcXFlNzZTbFc4Y1B6UjZjNjF5TU5RTTZvSjhJcHNGWHpkcDFMUVBX?=
 =?utf-8?B?czJteVB5QW1yeDBFQUpTNFJVM3REeEYzU2JISUNiUGZtaDFISG5pVjl4NUVv?=
 =?utf-8?B?VS8ybkUyMUVmZU1xaERDQnAyaEgxME9STHFXNWg4cXVNSzZiS2Q2YW9xMVJj?=
 =?utf-8?B?TEZmc1RVT1pkaWF5eHhMYkg1MGRFbUU3KzFPMloxd3lSQUtsdnVLNklkOTVX?=
 =?utf-8?B?MS9BRHBUVHJxdjdENG53ODN3TlBuZHBDL2Q0S3lyVDJ5ZVFLQ1hPYzdlRDBQ?=
 =?utf-8?B?TlpaOEZnclJOSVBuWGVPaG4xa3JYMFY1bDU5L1lJenp0WXN1YVJyRElHM2x2?=
 =?utf-8?B?WFg4c1hzLzE5Q25NVUJORW5DZ0kzbGFuZTM4bFR5R0JSSERwb1kzQ0hYTmNJ?=
 =?utf-8?B?RUIrQk1EbW92S1NGeGN4eVliRi9ZejNIYXRUNTVjdUc3WFZaTGpxdDNORlpY?=
 =?utf-8?B?QzlGZnRsUUhIdnliMS9hS0dXZWprSlB0UEVSd294QzZuYXMzd2pyQVVUMnds?=
 =?utf-8?B?WDhVc2s4Tmg2a1ZERVZsSlVOTmh5aGw1dk9FZHBHeW5ocEd5dHdRZzFicllV?=
 =?utf-8?B?U0o3Rjk4Q3hCOEZIZ2U5MzhvU1dTTDQ2UjVDb2FjeC9LWWc1RXFWOU1ydWFa?=
 =?utf-8?B?UEZRMTFoYkpUVy9KQjZWNENFZXRZT05QK3pyUzZRazJqTG5lSHpiRldMTmRi?=
 =?utf-8?B?V2hkUGEvWmlqZmlBemRVdGI0c0VCWnF0cm9PSG92czUrbUpMT216bnRlQjRF?=
 =?utf-8?B?WGU0cHdJUjRadklIem4zb1JhK3dTMVFlV2ZzWnNPT01GNDJxMFBGVGN5U3k2?=
 =?utf-8?B?RWlLMzIyRGprMUhXaU1RcWVVT0x4T0Q3dnZqYStjQ3JVUXEwQkl5bGk5SHpu?=
 =?utf-8?B?MmlicFNqWXZUMHhrZ0M4c1NZdi81UXlaQ203NW1yRHlEMkY3eDJpb2pkUzFu?=
 =?utf-8?B?a3l4RWIwUmt6MGJtL2hmb3pjdExnTjU1dEFZQ0tpTGgzTGRDdUFmZExranUv?=
 =?utf-8?B?dFF5ZmM5Z1FxalRpekZCNTBpT3JMYVl4YTNHQ1FnL0k2WUt2dXhiZnY0ejJS?=
 =?utf-8?B?Q0Y2M3ZDbWdvcVhWZ2ZtT1IzVlNBTWlIanFaMU1YbjY3L2Y2Q0lrOE1PNnk4?=
 =?utf-8?B?VDBtZmtKN0IwVkN4UnVKeFFsMTRVWlRoWW5meG4zUXhZSlFEZytYTVNxejB4?=
 =?utf-8?B?TVFjTkZKZUtpZlcwRGlXakF3eGkzNlBYYWhTeE5qaGlVNmluSEpldWdYOW1t?=
 =?utf-8?B?SWUwWkZvU3FIbm8rMjY1bm5JdSt1S2gxUlVvVGtuclJWUWdpU1V3dDJQelRs?=
 =?utf-8?B?RnlTMUF5UzRhWGQ4eFZpTXFtWDhUbk1TNU83aCtXZTB1aW1uODdWUzhROXN6?=
 =?utf-8?B?Ty95ZlhyS01VU2wvaHFyN2E4dU1zNVNXYlNkdTlLb01Id2c1ZHFmQ3VrTmZT?=
 =?utf-8?B?MmNZaVQyRzg3UFNyRXBaMnNrRFN6Mk1vV0U0SXRuMzJwTE5UeUlPL0VWR1ox?=
 =?utf-8?B?aEtsY0t1bVVVWmhTMWlzblA1ZjBXWm5rK1hnbjArZk5FRGtwdTlCSjVOLzBE?=
 =?utf-8?B?aUJhcTFRRXBMMDY2bUFELzRxOWVNeWpjUnRSMkhLVTBFNHkyQlh1MmZFdHEv?=
 =?utf-8?B?ZDVJK3VZMVVIOGVqWlJpWTRGc0YwdjVRMkRjRnFqOG1aYnRMRmR4T1I4bFc3?=
 =?utf-8?Q?CWaOPoU+oAz5N5KULSlg0lI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <52B64106FD36344282837959FE76700D@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR15MB5669.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 469bffcb-8e08-4770-9132-08dcf8d8c419
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2024 11:48:26.6238
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q5yDAOmhQjtCz4LI0xdaU5KRKYCtw7fYH/u+BcRZudW1IKnpWHBtOJ86N8Cy8BdyKVYefTuRx1GWxixn4yiZ5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR15MB5034
X-Proofpoint-GUID: Ajjt7Ayi7td055bEdcWUMyRlIwWLxluS
X-Proofpoint-ORIG-GUID: Ajjt7Ayi7td055bEdcWUMyRlIwWLxluS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

T24gMzAvMTAvMjQgMDE6MjIsIEFuYW5kIEphaW4gd3JvdGU6DQo+IE9uIDIyLzEwLzI0IDIyOjUw
LCBNYXJrIEhhcm1zdG9uZSB3cm90ZToNCj4+IFRoaXMgaXMgdmVyc2lvbiA0IG9mIGEgcGF0Y2gg
c2VyaWVzIHRvIGFkZCBhbiBpb191cmluZyBpbnRlcmZhY2UgZm9yDQo+PiBlbmNvZGVkIHJlYWRz
LiBUaGUgcHJpbmNpcGFsIHVzZSBjYXNlIGZvciB0aGlzIGlzIHRvIGV2ZW50dWFsbHkgYWxsb3cN
Cj4+IGJ0cmZzIHNlbmQgYW5kIHJlY2VpdmUgdG8gb3BlcmF0ZSBhc3luY2hyb25vdXNseSwNCj4g
DQo+IEhvdyB3b3VsZCB5b3UgZGVmaW5lIGFuIGFzeW5jaHJvbm91c2x5IG9wZXJhdGVkIEJ0cmZz
IHNlbmQgYW5kIHJlY2VpdmU/DQo+IEFyZSB5b3UgcmVmZXJyaW5nIHRvIEJ0cmZzIHNlbmQgYW5k
IHJlY2VpdmUgdGhlIGxldmVyYWdpbmcgaW9fdXJpbmcNCj4gYXN5bmNocm9ub3VzIG9wZXJhdGlv
bj8NCg0KWWVzLiBUaGUgaWRlYWwgZm9yIGJ0cmZzIHJlY2VpdmUgd291bGQgYmUgaWYgd2UgY291
bGQgbW1hcCB0aGUgc3RyZWFtIA0KZmlsZSwgbG9vcCB0aHJvdWdoIHRoZSBUTFYgZW50cmllcyB0
cmFuc2xhdGluZyB0aGVtIGludG8gaW9fdXJpbmcgU1FFcywgDQp0aGVuIHdhaXQgYXQgdGhlIGVu
ZCBmb3IgY29tcGxldGlvbi4NCg0KTWFyaw0KDQo=

