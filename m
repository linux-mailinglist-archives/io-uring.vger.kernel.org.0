Return-Path: <io-uring+bounces-3118-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D60E9973C4C
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 17:37:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6422D1F256E5
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 15:37:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 369F519B3E3;
	Tue, 10 Sep 2024 15:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b="toYjVSTX"
X-Original-To: io-uring@vger.kernel.org
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2040.outbound.protection.outlook.com [40.107.104.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25EC18DF72;
	Tue, 10 Sep 2024 15:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.104.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725982657; cv=fail; b=aqRk8RFBrIx5ykrhTrunGMSBUX56Nh8S/TWYCTyOQYEmSf2IUVfcwE3LcubEw2f5q5knrNtVAnYTcpXyqK3iYMIFJesFhN0oEXtThW1qDi+zKduwGpKxdz9EnHogDI8OFgYAIUEVnxhDSSu8ib5eNbzJKOs4aJ8ONVeo4qRB4ds=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725982657; c=relaxed/simple;
	bh=XNBzqTNxOoFXeiKHlOb+tXRDcFv7fKavhR2wVjZN0K0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=J/e4VC5LXnDbE8X+b9dNNONqRlHXd0jW71egq9I9/ntCYBuzySqHnDFyOP5tvRt5bW7Jb3tsHxScHfZgR0U5XmX1SJiniPWSanQMdpxrJRTW2q03BlMHimeczgT+KZBEkrTkcS0Ux/LP5p7h8yKwB0HFg4TFT2aK37V5uM+SgJM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com; spf=pass smtp.mailfrom=siemens.com; dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b=toYjVSTX; arc=fail smtp.client-ip=40.107.104.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=siemens.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u0buqsn6hFUhC9pCULXkAO+iSY7GAxVbeWK7RH8mLGtGvdnaIkouVYbA+mADkVRTtRJUFULHnrBj4H5tBNw0dNzkVAEq4xJLXDtH/GxnBJFBWJqNy98+8vTFQEsq+aYubGu6QX+78r4qUB/XY0enHrYEdyXgXhIIRvZtO5fz9cgVrUBB+FIkHDrmmRi49+0lDmy44bTUffyIqSkaFg8TKJkld77TVJijlApRrDVtibsi85opviRJj4E24eVN8BhCL7JSKhyfR/8Btah86XJj/HQr7uCmK+bHEmK2NAEw9SaW0PBe2U1mPoxYw86AiUITxCr8keUvKZFUrw251csSOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XNBzqTNxOoFXeiKHlOb+tXRDcFv7fKavhR2wVjZN0K0=;
 b=IfeSSbUUju1nNUVUddnHmzeeM4j417EF/hzbnPG+HbW+zWy5aXF8bkrwZ/vGFe8zwdqA+acP8IcalwhNlS1upc+Z0peN250Nr9/Ouu3dNYLGCzTACAPPL202NTLAW7QfVwr+peA1F22nQkNTBf0b5RAH2kq8Npn0jY4XU/hcH6incVW98FmXUyQi1kMvvz6fpxrzxgxpG/z1XqJHHHVF27UlkXpNAWk/g/bXYijl3lRCsQa4PGd6rTjtAWjMAw9uKmuMRpn+0qopJitVe5MpHkMTyLYuj4NocbPBEgMTNZikiy/yZVxr6/6Nka3MBcEWLGs1H4MKdSejqJ6aagB1JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XNBzqTNxOoFXeiKHlOb+tXRDcFv7fKavhR2wVjZN0K0=;
 b=toYjVSTXIfSwXirxLtvpf9KMBLWE5cKU/fwd+/q9frw+aO2U5gy8DAeq2tNi1p/AIiLgmie2lTtr+aYyUInNSIJttmfVRiU74EaU6Rw1lj0d2AnuqI1gJPe7/w2w6tuYk1R6/peWw7QmSzC+dl2n9e+vGkMXpb/fy2+yUwqyBn1s6VDln9Xvr7juQZfdJn2drQY7ZbI0X/nLVveMkmXu23lSxp/AjIn5Bkjm9ZXeFBPIb4CHO7zRdryMNPExWnSjWPmKlXWb4w/kYzS9LR/9tH5SGOUVnf0mCEYXFFAsOzplOn4uQWuKSkcxDdXHY6pmIUDMiVVeDZkoEBog9ByoFw==
Received: from DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:47f::13)
 by GV2PR10MB6431.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:150:b9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.25; Tue, 10 Sep
 2024 15:37:29 +0000
Received: from DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8198:b4e0:8d12:3dfe]) by DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8198:b4e0:8d12:3dfe%4]) with mapi id 15.20.7939.022; Tue, 10 Sep 2024
 15:37:29 +0000
From: "MOESSBAUER, Felix" <felix.moessbauer@siemens.com>
To: "axboe@kernel.dk" <axboe@kernel.dk>
CC: "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "Bezdeka, Florian"
	<florian.bezdeka@siemens.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "longman@redhat.com" <longman@redhat.com>,
	"asml.silence@gmail.com" <asml.silence@gmail.com>, "dqminh@cloudflare.com"
	<dqminh@cloudflare.com>, "Schmidt, Adriaan" <adriaan.schmidt@siemens.com>
Subject: Re: [PATCH 0/2] io_uring/io-wq: respect cgroup cpusets
Thread-Topic: [PATCH 0/2] io_uring/io-wq: respect cgroup cpusets
Thread-Index: AQHbA45p2jJwLZGl/U6eNmWxPlYEebJRGycAgAAENgCAAAJ9AIAABbgA
Date: Tue, 10 Sep 2024 15:37:29 +0000
Message-ID: <e7b15755c350f6d9ae719065a7fc20f940d314b3.camel@siemens.com>
References: <20240910143320.123234-1-felix.moessbauer@siemens.com>
	 <ec01745a-b102-4f6e-abc9-abd636d36319@kernel.dk>
	 <92d7b08e4b077530317a62bb49bc2888413b244a.camel@siemens.com>
	 <9cd8bae3-ba32-4b44-a4c0-63f5e5a3de35@kernel.dk>
In-Reply-To: <9cd8bae3-ba32-4b44-a4c0-63f5e5a3de35@kernel.dk>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.46.4-2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DU0PR10MB6828:EE_|GV2PR10MB6431:EE_
x-ms-office365-filtering-correlation-id: f05d153a-9b85-4460-6aab-08dcd1ae7ab4
x-ms-exchange-atpmessageproperties: SA
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?ZWpDeS9iNUMxalVMWHpzN0p1TWhaWW1KSUZPWkVzaFZvZU1CbTRUWEJuUlJz?=
 =?utf-8?B?Tkh5Wm1MNXJNZFNESVowQmcrZVlsQitzNUk5MFVCK1p1ekdrMjZOamZ4ZEM0?=
 =?utf-8?B?RFpITVpaUHdVTTFLODFEa0VGVjJLVWZpTzRnY0tiejdzTVRIMm8vMllZRmpK?=
 =?utf-8?B?WUxmMkg2cHd0LzdyZDZYV1RqdkVOWUFrdm0vbDRPSXh1VGhkRGpWWXlBZEQ2?=
 =?utf-8?B?T3lKL3laUy9NQ1c0eUZjRjVnT0ZlQ1NUWnVncGdPNVo3OXpwZGRDTXNKcmdI?=
 =?utf-8?B?Y2xQbnZaTkpYRlIwbGpSTFJQNzdVeWVqMEVxaHI4UHFFVk1zbW52MEpGZWtw?=
 =?utf-8?B?Y1c0QlpyUTRQeUU1OVpCVVk3UDNURnYvZEFDZFd0NFFFODcyZ1pYbWxvckZR?=
 =?utf-8?B?dTVaTFlRSzFON2FBclJDSXBWTml1OW5LWUxnM3pCY2ovQlRzWFMwazdxaXdi?=
 =?utf-8?B?aXZLZ3BOWGQ0bEJFZVN5bDlpemVkZG5OVEtybnpjcFB6NTRTOG9uNjJKQ2dF?=
 =?utf-8?B?OGh1blczUmhkTng2Q2RvVEVIVTk2dytDYWNqZTVOM3ZqODJSRVlGdXNKUzFO?=
 =?utf-8?B?TVk4aG1RRHZ6emIwM2hYWlViMmsvQmJVcHpsVWh4Um94QlNEYzVtd3pneU1n?=
 =?utf-8?B?UFRlNDNZTjkwUjlKZ2xvMHFqVk42ZTduVVcxb3BxblJUL0VTNTd6RDNmRWZC?=
 =?utf-8?B?RGNxMTBKSXJqRy9sN3poQU1SVnFjV2JyallsbGdvdWVkSElIS0VaaXUvaTd0?=
 =?utf-8?B?dCsvOTczRERucUNaZHl6RUE2K3NacUNacVY3VEVDby8yaTRvSk5lUjVXY2h1?=
 =?utf-8?B?NjV1MUFmR2VLVVRUV1FCTUtnTjJmVGllRUxzbzBaaSt1TTFJY3RSWVh2YmhH?=
 =?utf-8?B?VUNSQ1ZyeXJTcWlpQmVrR3F0TjFJd0tta2xSTUJXbTIyT043SmIyTiszMkEz?=
 =?utf-8?B?NHQyTklVbWRQMDZKZDFTeWlQbWpDR0Q1b2h0d3haWE1oaEJHWjNnKy9ZMmZL?=
 =?utf-8?B?aWtaN2ZlcjdtMzBYak9pekJWZEdqbnQ3ajBTNHlXZysvM3AwTXcrQkpWcHNl?=
 =?utf-8?B?aktvb2xyeTA4Q2NoN1l2Tk0xK0YvUUI3eGpVQVdGcEpsQVRCK0hNMGk0c1Nl?=
 =?utf-8?B?dzByT1huaytMRGlWaGs5SElMWTdTYVR0SVREVmFCL3NSMUM2UUI2bEEyeERs?=
 =?utf-8?B?WHdDTlJIQ3JDSXQ0Q2s1V0RvTHZ6MDlMdG1iTlQxQm5HUTc3MTJ3SllPbXlU?=
 =?utf-8?B?NE5qQ0NhTzhBbkFQZEVQaS9sR0tnam5DdlNsT0E2cmFOT1F2L0IwTnpLRk9Q?=
 =?utf-8?B?ckcvd2NqaTRtZHdHV01WTkptWlVzcFF4NlBEMy9CdXJvZS95cThYM25pNS8x?=
 =?utf-8?B?eFhGcFlrTFVLVDdXSERTSHRtVWdlVUpUQUEyMWJKYkErWm40SVNyZHhlbi96?=
 =?utf-8?B?dHA1TkZNdU11eDUvTWpOZXhJT2VZYjdCVncrUUVxa1JjbDRSNVIzbzJNNS8y?=
 =?utf-8?B?RkVMSVFsZVl5RVVlYnNuMi9ReGE2TFB3Nzd5clY5R2tpSHdIMFVvNGJjcG1a?=
 =?utf-8?B?QnBKeUhnd1N6NVIyanBMSkIza3grNi9jRkpFZGlaeXNKUGNKRlN1YThsWW9q?=
 =?utf-8?B?bVdvOG5FSlozWjdoekJwY2dWbEUxcHVNdHVwV1h4bW9Ia1hTN1BSdlVuSlFs?=
 =?utf-8?B?S0dqc1lPdFJEQ0k0b3NnZnVuNnQ5dzEvZXFpYXNFM3Flem1OSXBZcm5WMS9y?=
 =?utf-8?B?OTB5d2lVZFZ6UThjeC9IZlJJNWh2QnB0ck1WVGJ4R2k3QnVHWlNSQ1ZPdGZ5?=
 =?utf-8?Q?EkweAt+6q07h9/3XK8SxYE9LSPWpgoHfm1Ne0=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bEx3ZVB6REwrb3U3Zzc3NjFHakRmemJZUklSN2FycmlQNzliQ01wclpLSTJD?=
 =?utf-8?B?T2toOEZVUmxhUEswNzBIUUozOG92b04zaTFqRFRZdWFLcE1JZnFmNEFhUHRa?=
 =?utf-8?B?eVZxNFZTRXNXay8yWHdjRThUcXhid0NMeHhXSUgxc0tJb2cxQ3djRGtmN1Vv?=
 =?utf-8?B?RHZoZ0VzZStuMUNWWEp4eXZHQ1ZZRXo5eFlpczYrTWtnRFBFb2hNcFltM2FY?=
 =?utf-8?B?MVlsWjNrVXRYQ2lSOEZGZVVYUTJheEhzdjBRbkFNZjh0YTBFYkp5NzZnc0RQ?=
 =?utf-8?B?QWYrKy9xQUU4ak1Nc0NyZUtXSVIxQzZXcWZEbWVkUzA0VG44dnAwRmpTYlF4?=
 =?utf-8?B?ZDEyL0FGMXhLcjc4S3JPeHc3RlY3SEdGMldSNjFiUi9ZQjNQNmo0RGNwSmpo?=
 =?utf-8?B?VHN3cmd6akZNUWVpYTVyZ1FEZis4T3lkT3N5Z3h5eDRrdEFncUJ1VXcrNnhK?=
 =?utf-8?B?NXowK2NveGRrdTBNQlZRVEozbktBcVhtMGt2c2ttOUtzeDFEYldFNkxld0xk?=
 =?utf-8?B?ZUVwUEt5WW1tYUxFOE5yRWc3NXN5MnE1dnY3TDMwYW9YZ2wxYnFqS2dEK0h6?=
 =?utf-8?B?clFES3BtT2xPTk9FZ0I2bjlXbWxJZk9CRzZaVzRrVFVVcWFSWHlrb3hPSlJl?=
 =?utf-8?B?Rm9qMGljTFZvckJvR3hpNVp5K2RaRXdwR0tHbWM2YkE4SVF4Yy95c3dLbXBn?=
 =?utf-8?B?bjhOdUswOW1zdzFkWlA4UHhNS1dOQ2toTkpZWlJqY3htMURVdDdqQjg0R1Jq?=
 =?utf-8?B?MGtpa2xhcml4U1d1OXJwZ08xSDBMNHFQL2RVdk5wYncyZEtMQVBEa0R2QlhF?=
 =?utf-8?B?LzUrbGNPem5yZzVrOVZqYjF2bHh0NVZ6U1kwSkdHSWhuNmtqdk41NGg5L3l0?=
 =?utf-8?B?MS9jK0tDejBsdTB3ZWt0VmFtRm8reXVZWHpiVzRBQUVTS29TeTZCci9JQ0lj?=
 =?utf-8?B?NkxRMExOMnNEQk40N2J1RG9SdHVOUS94MmFmQVhpOCt5MUFuK3VWcjZpMnNL?=
 =?utf-8?B?M0dVUmZTZ0YxbUVXdEpzZjNEekdtZHJEY3haM2pVTVl5WjBxRHg1Wm1RMzRZ?=
 =?utf-8?B?MVFiMlVhZlhuanNQVUpJQVJjZFptcXRSbDljMmtjVGhqL2t1VjY5UEs0UFhB?=
 =?utf-8?B?TU1PRE5pZSsyeGR6NHdlS0pubm15VzRSSWpuS25kQUlQVC90SkJmN3RTZUJi?=
 =?utf-8?B?SUYva29Hak1VMFFNemVMcGJMNjJZczR0ZG05NzVGR1Q2WEx6dXdidnFIWWpK?=
 =?utf-8?B?S21oTE9aY3dDU1JrT2ZxdVFHaEUveE8ycEFpdURMc2NYdGJIVGdiZENRdkRL?=
 =?utf-8?B?ell6UzNzek1vQXRmenM0WnFJeWN5RkEwUzM2THJOdDVyWUtxRysxVVFrODlh?=
 =?utf-8?B?V01SekpyZU9DbjB2NEp5Q3F6ZWNtMlQ4SUV2WnZWejJ0QjQwVjNGQ0xJOUpS?=
 =?utf-8?B?TjIxb1R2b3A4VU5YUk1nV2drdW1sMHErRSt6N2NjdWdsdm04TU96NTI3bUlw?=
 =?utf-8?B?dEpxSTE1ZmhDbUMwbllUSjRFSmxLK0dXMkJCRkQ0T1M5NHY0T3V0bDM1d3ZW?=
 =?utf-8?B?aS9ZcnJCMVpEalF4bnR5aUFSZlNzZ1BidnFRblU1RnU1V1RuUUFmeHc1V0R5?=
 =?utf-8?B?aTNpTDVyOHZZOUY0YnNwT3o5M3dHU3Zob2o2YnNuQVlxdkN6aXF3bUhpQS9L?=
 =?utf-8?B?OFF6NWZ2V3VpNzdiR3JCUmhtK1JtVnc4cWRBVURDaEFFYVY0cDBaVEVyQ3Ni?=
 =?utf-8?B?Z2FtTDFtbnlKd0lId1JRcWw4blcwbUdya3VIaUtLSGx2N1BOcXRiTEFHc241?=
 =?utf-8?B?ZnkrN05WaW85TWQ3Y2lNcGlKZmRCOE1palJYOFZaMXJybGpPakZBbWt1RDRp?=
 =?utf-8?B?VjF3TlZWMWs0NlkyQkhsUjdhd2xJS01ORi9EbERRcWI4YitDd0VqMElQTm5N?=
 =?utf-8?B?WXZkV1NaYUkzUFRrRzZYVGROUmxYTitRS2xkMVVhOGlGSnVtY2tqWVVxVk9G?=
 =?utf-8?B?d0EvRWtYUEVtY0ZPQjNqMFR4cFRpNzhTWFArVVgzUStoZEJqV2U0MzUzY0c1?=
 =?utf-8?B?a2FzR01rUUhwbVV2SjQzOTVzeWNIbk1aNFd1cjd0Ym5GUXI3dWZjUkJmaEZs?=
 =?utf-8?B?NURjRmpCV21wVmJFMUh6WXZEVG82eU41SFltOEVEaWZ5MkZUellwMVdjelJH?=
 =?utf-8?B?SmlIK01JL3paSVlXempBZlFON3lWRSs5ZkFZdCtVdTdaenhMQ1J0YVliYjRM?=
 =?utf-8?Q?bwYT1PELS/U0F73MbA2EytXz9VVMKgScIwF0I8r/8A=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A9250AD7597EF44580C32BCD447CD9C3@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: f05d153a-9b85-4460-6aab-08dcd1ae7ab4
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2024 15:37:29.2723
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zsryKI/L7jnDWPvFxsTCxNC6PvhoP7HMwXSP7VBQ8+B1wqD2g2VAvy1GCcrtDEjZob0fGuvwIywGvo25U/aSw2jF+zqgYwguSL1eVh/kT8w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR10MB6431

T24gVHVlLCAyMDI0LTA5LTEwIGF0IDA5OjE3IC0wNjAwLCBKZW5zIEF4Ym9lIHdyb3RlOg0KPiBP
biA5LzEwLzI0IDk6MDggQU0sIE1PRVNTQkFVRVIsIEZlbGl4IHdyb3RlOg0KPiA+IE9uIFR1ZSwg
MjAyNC0wOS0xMCBhdCAwODo1MyAtMDYwMCwgSmVucyBBeGJvZSB3cm90ZToNCj4gPiA+IE9uIDkv
MTAvMjQgODozMyBBTSwgRmVsaXggTW9lc3NiYXVlciB3cm90ZToNCj4gPiA+ID4gSGksDQo+ID4g
PiA+IA0KPiA+ID4gPiB0aGlzIHNlcmllcyBjb250aW51ZXMgdGhlIGFmZmluaXR5IGNsZWFudXAg
d29yayBzdGFydGVkIGluDQo+ID4gPiA+IGlvX3VyaW5nL3NxcG9sbC4gSXQgaGFzIGJlZW4gdGVz
dGVkIGFnYWluc3QgdGhlIGxpYnVyaW5nDQo+ID4gPiA+IHRlc3RzdWl0ZQ0KPiA+ID4gPiAobWFr
ZSBydW50ZXN0cyksIHdoZXJlYnkgdGhlIHJlYWQtbXNob3QgdGVzdCBhbHdheXMgZmFpbHM6DQo+
ID4gPiA+IA0KPiA+ID4gPiDCoCBSdW5uaW5nIHRlc3QgcmVhZC1tc2hvdC50DQo+ID4gPiA+IMKg
IEJ1ZmZlciByaW5nIHJlZ2lzdGVyIGZhaWxlZCAtMjINCj4gPiA+ID4gwqAgdGVzdF9pbmMgMCAw
DQo+ID4gPiA+IGZhaWxlZMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoA0KPiA+ID4gPiDCoMKgwqAgDQo+ID4gPiA+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCANCj4gPiA+
ID4gwqAgVGVzdCByZWFkLW1zaG90LnQgZmFpbGVkIHdpdGggcmV0IDHCoMKgwqDCoCANCj4gPiA+
ID4gDQo+ID4gPiA+IEhvd2V2ZXIsIHRoaXMgdGVzdCBhbHNvIGZhaWxzIG9uIGEgbm9uLXBhdGNo
ZWQgbGludXgtbmV4dCBAIA0KPiA+ID4gPiBiYzgzYjRkMWYwODYuDQo+ID4gPiANCj4gPiA+IFRo
YXQgc291bmRzIHZlcnkgb2RkLi4uIFdoYXQgbGlidXJpbmcgYXJlIHlvdSB1c2luZz8gT24gb2xk
DQo+ID4gPiBrZXJuZWxzDQo+ID4gPiB3aGVyZSBwcm92aWRlZCBidWZmZXIgcmluZ3MgYXJlbid0
IGF2YWlsYWJsZSB0aGUgdGVzdCBzaG91bGQganVzdA0KPiA+ID4gc2tpcCwNCj4gPiA+IG5ldyBv
bmVzIGl0IHNob3VsZCBwYXNzLiBPbmx5IHRoaW5nIEkgY2FuIHRoaW5rIG9mIGlzIHRoYXQgeW91
cg0KPiA+ID4gbGlidXJpbmcNCj4gPiA+IHJlcG8gaXNuJ3QgY3VycmVudD8NCj4gPiANCj4gPiBI
bW0uLi4gSSB0ZXN0ZWQgYWdhaW5zdA0KPiA+IGh0dHBzOi8vZ2l0aHViLmNvbS9heGJvZS9saWJ1
cmluZy9jb21taXQvNzRmZWZhMWI1MWVlMzVhMjAxNGNhNmU3NjY3ZDdjMTBlOWM1YjA2Zg0KPiAN
Cj4gVGhhdCBzaG91bGQgY2VydGFpbmx5IGJlIGZpbmUuDQo+IA0KPiA+IEknbGwgcmVkbyB0aGUg
dGVzdCBhZ2FpbnN0IHRoZSB1bnBhdGNoZWQga2VybmVsIHRvIGJlIDEwMCUgc3VyZQ0KPiA+IHRo
YXQgaXQNCj4gPiBpcyBub3QgcmVsYXRlZCB0byBteSBwYXRjaGVzLiBUaGUgLTIyIGlzIGxpa2Vs
eSBhbiAtRUlOVkFMLg0KPiANCj4gSSdkIGJlIGhpZ2hseSBzdXJwcmlzZWQgaWYgaXQncyByZWxh
dGVkIHRvIHlvdXIgcGF0Y2hlcyEgSGVyZSdzIHdoYXQNCj4gSQ0KPiBnZXQgb24gdGhlIGN1cnJl
bnQga2VybmVsOg0KPiANCj4gYXhib2VAbTJtYXgta3ZtIH4vZy9saWJ1cmluZyAobWFzdGVyKT4g
dGVzdC9yZWFkLW1zaG90LnQNCj4gYXhib2VAbTJtYXgta3ZtIH4vZy9saWJ1cmluZyAobWFzdGVy
KT4gZWNobyAkc3RhdHVzDQoNCldpdGhvdXQgeW91ciBwYXRjaGVzIGZvciBsaWJ1cmluZywgdGhp
cyB0ZXN0IGRlZmluaXRlbHkgZmFpbHMgb24gbGludXgtDQpuZXh0IEAgYmM4M2I0ZDFmMDg2IChp
biBxZW11KS4gU2FtZSBlcnJvciBhcyBhYm92ZS4gU29tZSBtb3JlDQppbmZvcm1hdGlvbjoNCiQg
dW5hbWUgLWENCkxpbnV4IHRlc3QtaW91IDYuMTEuMC1yYzcgIzEgU01QIFBSRUVNUFRfRFlOQU1J
QyBUaHUsIDAxIEphbiAxOTcwDQowMTowMDowMCArMDAwMCB4ODZfNjQgR05VL0xpbnV4DQoNClN0
cmFuZ2UuLi4NCg0KPiAwDQo+IA0KPiBhbmQgb24gYW4gb2xkZXIgNi42LXN0YWJsZSB0aGF0IGRv
ZXNuJ3Qgc3VwcG9ydCBpdDoNCj4gDQo+IGF4Ym9lQG0ybWF4LWt2bSB+L2cvbGlidXJpbmcgKG1h
c3Rlcik+IHRlc3QvcmVhZC1tc2hvdC50DQo+IHNraXANCj4gYXhib2VAbTJtYXgta3ZtIH4vZy9s
aWJ1cmluZyAobWFzdGVyKSBbNzddPiBlY2hvICRzdGF0dXMNCj4gNzcNCj4gDQo+IGFuZCB0aGVu
IEkgdHJpZWQgNi4xIHNpbmNlIHRoYXQgc2VlbXMgdG8gYmUgeW91ciBiYXNlIGFuZCBnZXQgdGhl
DQo+IHNhbWUNCj4gcmVzdWx0IGFzIDYuNi1zdGFibGUuIFNvIG5vdCBxdWl0ZSBzdXJlIHdoeSBp
dCBmYWlscyBvbiB5b3VyIGVuZCwgYnV0DQo+IGluDQo+IGFueSBjYXNlLCBJIHB1c2hlZCBhIGNv
bW1pdCB0aGF0IEkgdGhpbmsgd2lsbCBzb3J0IGl0IGZvciB5b3UuDQoNCldpdGggbGlidXJpbmdA
MzUwNTA0N2EzNWRmIGFuZCBteSBrZXJuZWwgcGF0Y2hlcywgYWxsIHRlc3RzIHBhc3MuDQoNCkJ5
IHRoYXQsIEkgYXNzdW1lIG15IHBhdGNoZXMgdGhlbXNlbHZlcyBhcmUgZmluZS4gSSdsbCBqdXN0
IHVwZGF0ZSB0aGUNCmNvbW1pdCBtZXNzYWdlcyB0byBmaXggdGhlIG9kZGl0aWVzIGFuZCBzZW5k
IGEgZnVuY3Rpb25hbGx5IGlkZW50aWNhbA0KdjIuDQoNCkZlbGl4DQoNCi0tIA0KU2llbWVucyBB
RywgVGVjaG5vbG9neQ0KTGludXggRXhwZXJ0IENlbnRlcg0KDQoNCg==

