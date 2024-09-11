Return-Path: <io-uring+bounces-3132-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A7BF9974AE9
	for <lists+io-uring@lfdr.de>; Wed, 11 Sep 2024 09:03:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC3311C22F94
	for <lists+io-uring@lfdr.de>; Wed, 11 Sep 2024 07:03:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEB093D0D5;
	Wed, 11 Sep 2024 07:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b="eirPgQsT"
X-Original-To: io-uring@vger.kernel.org
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2062.outbound.protection.outlook.com [40.107.21.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2615F78C6C;
	Wed, 11 Sep 2024 07:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.21.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726038152; cv=fail; b=Y9CmdrA0qfhLwACOiN513kB9CuUbDrm3dZRGHaIz/ghU2vqPiWuUXjWrF+F9vGShDBTVokVFBPVy4+htzDUe0FEwgdPGG1SKZmX77eOwplc+XmjG9ElOZ8r51k17iK2Ys6ZAHiaAWsP2sqUNwWJwJW9riUHomlvn2ii4HTqysmY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726038152; c=relaxed/simple;
	bh=ehEwbj+taaCYWCz48M9VvX0HllB95+WU1YBIg41p4xQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qwiv5GvPG/SjMgMnXktNKaerU4CGm3Qr8rRxZOLHbnlBzyDJ36HubO1QnG91FP+mb/LcKcJ64YTNomuUokrQ47bRxYJSpnBIGDISxoRreLQZsWUJq2V3erDq1vCc9HJHkn5GgUZEGYqDvTzoccPzW5UMvl/tvMf+/JLwBcSMKRw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com; spf=pass smtp.mailfrom=siemens.com; dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b=eirPgQsT; arc=fail smtp.client-ip=40.107.21.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=siemens.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gujUhvKmsEgkG4VVIuZfYfAUQTpD5myv357vorQ7BNiMMRTwv1d+5d1pxplySMcVgiWuKi3JeOWADH/D8VxGfM99iOReOpDbhSEtK0YZnZTEsbZS3XZfPCafnN6eZX7x0UxO95STx19DQBnxrZ/YZIKYJREJJyAD3gKr4cUoP0ue3POw7/94mfQFcfQ4COTEbTXJ2avJDesJxZjA7XYlqg7YptSzGz1RcL8gCjUtm7dm5pqdKbe0KtPrCc5XnDp/lNNav6ngP0uV+TyEc5rwnwNEtKRvJ/yUNeqGx98HKglLkFGaG1+FDmyOT4jstGpiDaWNk9aNfenQImLG8711xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ehEwbj+taaCYWCz48M9VvX0HllB95+WU1YBIg41p4xQ=;
 b=fyJIPtazRvw75355XAqtvMGgZrlmUQR099qJHerdo558stHitrcLIkjYcsN4j/3R9TTKxATHHcRXCUln5txDnxC4n+JWPsveWCPka1E1zD2Q2+UkssI76uq4FH99XUZ472Wbn1MnkgiwDjhb8s1YQapVKmOPaNcIU/BUxnO3ODUK2c30e5hZRXM8dMm48dUAd+C6qzXglFbzkjx1fTA5tmGSW5gaBRsRaXiJmKY0SotBS3aasewYFnXjPo/G2ifjnyGCAp3dmmsz4D4GEDB0haNrYQnmI/RKqo2uFkK1XBKDELl7ob5ctw8zJgoa1R6+gA3TB+R3RrZgF/xA04syag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ehEwbj+taaCYWCz48M9VvX0HllB95+WU1YBIg41p4xQ=;
 b=eirPgQsTcWUhjH3Qkr2VRmN529yF8BwzBxiP7xh77Em/edL3ax8Lk86fvPwgbYSCsN1f2E6yDnSgy8AkOuln4Ryn7mf/A3a0/6rRwz+1GJcq0a4SWtUqD9onTnggNTwryOuynD4xcX1vyNbgtF0BDbItKl1Z2/kj+1DPfJXw1ixq1YE/WxXe8eafn+MWyAQBPM1PEL2/cHCMeKKSB7l3TnSqP0k06ApgWo4XqUk+xSSrpBUithFFu9IUCr/1Jh5CbRKjJfy1oIpf47w8WVhKs9sfm9yAmdl11Eab0qaBO7v6+lzpvNwKmTPaM/NZWitObTrfzs33LZ54I3tisTqkZQ==
Received: from DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:47f::13)
 by DU0PR10MB6755.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:473::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.24; Wed, 11 Sep
 2024 07:02:25 +0000
Received: from DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8198:b4e0:8d12:3dfe]) by DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8198:b4e0:8d12:3dfe%4]) with mapi id 15.20.7939.022; Wed, 11 Sep 2024
 07:02:25 +0000
From: "MOESSBAUER, Felix" <felix.moessbauer@siemens.com>
To: "longman@redhat.com" <longman@redhat.com>, "axboe@kernel.dk"
	<axboe@kernel.dk>
CC: "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "Schmidt, Adriaan"
	<adriaan.schmidt@siemens.com>, "Bezdeka, Florian"
	<florian.bezdeka@siemens.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "asml.silence@gmail.com"
	<asml.silence@gmail.com>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>, "dqminh@cloudflare.com" <dqminh@cloudflare.com>
Subject: Re: [PATCH v3 2/2] io_uring/io-wq: inherit cpuset of cgroup in io
 worker
Thread-Topic: [PATCH v3 2/2] io_uring/io-wq: inherit cpuset of cgroup in io
 worker
Thread-Index: AQHbA6SU7psinHbY70Kphop1exYxy7JRSlQAgADffgA=
Date: Wed, 11 Sep 2024 07:02:25 +0000
Message-ID: <4eddbc8f761c113fb098b81ed4c542827664abb3.camel@siemens.com>
References: <20240910171157.166423-1-felix.moessbauer@siemens.com>
	 <20240910171157.166423-3-felix.moessbauer@siemens.com>
	 <1589cf94-6d27-4575-bcea-e36c3667b260@redhat.com>
In-Reply-To: <1589cf94-6d27-4575-bcea-e36c3667b260@redhat.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.46.4-2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DU0PR10MB6828:EE_|DU0PR10MB6755:EE_
x-ms-office365-filtering-correlation-id: 0dc45317-8012-4170-e43c-08dcd22fb133
x-ms-exchange-atpmessageproperties: SA
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?S2UwWFFBdlpHeHB1VGxhREVtZTRZakE2czNqeGVqR29BaFhMS2VzaWh1a0Zz?=
 =?utf-8?B?bWVDcWJSVkpjbTFQbnBVd3g3T29pY0hxY0dQazhxRzhQTWdVaUk3T0xhVmht?=
 =?utf-8?B?elZTVDI2QkE1ZUF5UlFjS1o2V0cvdXJlV3hEb1FtWHBPNW02a2RzZC9TdmVH?=
 =?utf-8?B?bURwdnZuZE1tN3MwR2puSndnQVJkSUlBK2Q3LytnczEycXhxZFNyU25rakw2?=
 =?utf-8?B?T0laWmlxeXc4ZHk4Nm5Sd01ESVk1REhkenFUcFNYckNwTWpNdTE4NG5xRnVN?=
 =?utf-8?B?S2Y4L0FYWjV0elJSMlpTSU8zdkRiZHd3WnRQM2twY3pYMHFlWmJkNDNzeE14?=
 =?utf-8?B?bDYzY0VIem5yZDZ6akhnalE1Y0R1RkttNjZtVDRsM0Rtcy9TUnBlV252NGpM?=
 =?utf-8?B?MTNxS3FYUXcwazZkU2doM3VPUW83U1J0Vk1XNVIzUWxFU0R2SXBaU2JLZ21N?=
 =?utf-8?B?WnpSdlVkWHo0TWtVUkdNajJzS3hZY0g2dkcvM2NCdklxNFc4a3BWOE90TzJi?=
 =?utf-8?B?MjNEa2RTdDNkbnBWem1UY2l5Sjk5K21BNVFISU9jTzdiNEVMMjFCK01mZjJh?=
 =?utf-8?B?blVWcms0b2xGUm5lVTFsTmNDL05BclA4dVR3bE5uT2hXY3QwUEpsM09Bak1P?=
 =?utf-8?B?NkJ0MjVESzRqRkxZME9QLzRDNXBmNkY5bXNwZUJOdWlCOEpuc1F4ZG5Sa2c0?=
 =?utf-8?B?NnQxZ2tLSGVCQm9jMXNpY3hJRWR1a2w2VWFzelNydGgwRHhURU9NcGZsQUF4?=
 =?utf-8?B?eFVDSFNMNVdMdmNWMG1UWXd5QUIwc01mTGplK0FnRldxZ09ORDlwazZnTjAr?=
 =?utf-8?B?Q2RPTVFERFY0TW4yYVZER090b1BwNkwwWGJManppblp6WDBLbll4S1N3UThP?=
 =?utf-8?B?MHhQVWpTRjYwM0pabWh2TmwzK254eEtTOFpONDRvMHdKczVVT0owWnVVMllO?=
 =?utf-8?B?SnhiUGhTYkJ6U21nd2JBOE4wb25DcW53NUtLUWVXTEtsZTZ4cnBzZ3FjbkU5?=
 =?utf-8?B?Y1lGaVVmQ2N5bEcwS3diTCsxeDFxRno5ZFdwV0twdFpvYzNLVWpZeGVJa012?=
 =?utf-8?B?Mk54NDF5MmZZOVU2bTJBWTVFWVphdDZsM2M1UUU1ZE1ZVVhKRHUzLy85ekhF?=
 =?utf-8?B?RUM1NkYxdjZ5enh4dFl4aW1oMjU4eGVJYVhJQm92ZXBqZmRoTjdFRTZSbHFh?=
 =?utf-8?B?WHppRVN1VDJIaFBKcE5HbGxLVzVFb0dvRnM1L1RlVE40dDlVR20rUHdydHZh?=
 =?utf-8?B?QkZGaUNJOVMvMjZYRmxkYU9MQkJCNnorMkh1RXpzU3VEemJrOGxIb05peExH?=
 =?utf-8?B?VGJpT0RIMzRaZXBod254ZGtVQ3RvUE84eXZQV2hkZVdoVWYyaXhveW1xcDN0?=
 =?utf-8?B?ZE5IRFQvTVRlUmNMdG9wdkpYcHd3N1hHNGwzbEE0dXRJN0lpOXhBYW9hQ2lp?=
 =?utf-8?B?QzdOeXpPMFBkSXZDVnlWMjNtZkhDTkRaMnJkMUtTSG9Ndnk3RUszY1d3WHBC?=
 =?utf-8?B?WGZmZDU4dFR6RCtvOU5LOURFcWZKWWswTU1xUnZ1WkpFUHJqRXF1OVlNSEdB?=
 =?utf-8?B?N0NIb3B5NDIxaUxYaVl6SzlHOWlNM2V1eUtvczJ1RkNlRkVIRFZDRndTck1k?=
 =?utf-8?B?cW9XVGhlVVluUkhodStkMkxZZmNUeEZUOUtTcHZaeWd3ZGt5dGFvaUNvMFBQ?=
 =?utf-8?B?R3BIc3F6dEkyWTdBYVFBN1NEdnoza1YvenNJcFdmTDhhZkZEMUtjcE8vRFJF?=
 =?utf-8?B?TkN3NlhKWDN6UTRHZE1uelBsKzNEWU9BbFNZeFQ2S2MwdVhZV2RwdEg1K29v?=
 =?utf-8?B?Z25wdGJuWCtIZ1JUR3VrUDlLcFNNVnBKbitkbzAzYmUxajRRajdYUTEzUldW?=
 =?utf-8?B?NmpGcEwwSHJtTkszVEwwQlEvTkFnYSt4TFBaN05HNEdlZ1E9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RmFGb1dibTlsSm81R1Q2TC92VTdESHhIdGJudTJiL2hEU0hvaExsdWVPc3Z2?=
 =?utf-8?B?UFN5MW1RY0s1SE01Zk9UV1hvcWw0eHQ0bzYwWGpEYS83YVlsNytDNGRvek4x?=
 =?utf-8?B?UzFMWWdFeXNRRzErMFFFeEhJbDlxTFU1bldvdHFkRE02TGo4RkIxWHBTMVRa?=
 =?utf-8?B?OGhVTHp3aHRVSVZ5dHNaU3BXK0ZRRmRQNG9XOGJEMGpLcTY1VzZvYXZWUGNa?=
 =?utf-8?B?WHJ5UEIxaVdCOG10NG5DUGRhMzkvem5tamJ6SThBSHpWQVJsUjhneUVqcXhI?=
 =?utf-8?B?M1VSSGJPNEFtdHIycnpVUmdlTlRwM1VpVkdxU1NjZDNtcjRQNytQRisvaE1z?=
 =?utf-8?B?Tmt2R0pJUlF6Tk9VMTFnOTB5NkZYOUNVeFhGS21UWkJNd1orYXRadDh4Z3BS?=
 =?utf-8?B?NTNTYTRZL3g2aUdmZU5iQ0k3cDNRenp4SS9QQ2ZETk9PTlcyMEpqK1B2Qi9u?=
 =?utf-8?B?Y25VUDRKbjlKRDJweDE3bzN3RVhLVlVzL1FGWHQ2TEpPYjVreDZaRklIaVhX?=
 =?utf-8?B?QUpGaDVZUFZnWnlzb09DKy80b1NEU2h1dHNuc1IyVjRLMHBzZzJxZHFxZWtL?=
 =?utf-8?B?akNmWTVzWU5NTGVDRnNxRnlqU2ZQdVM0eHlGbFVrSVZCVjhrQ2Z0RFNESDIz?=
 =?utf-8?B?Ynh4ekpNeHVvQUtQZkpJUjBpVXQrcytIcVlyWm0vVjZGM0F5ak9jZG16SHJ6?=
 =?utf-8?B?MXRIWHVXS3BEOWRYWHBHeEQ3Yi8wR2xjbGs5V2pHR3NtZ2NOUUo1b2pYU3o5?=
 =?utf-8?B?dllwQ2lyUzI2UVRQd05NckJuVWxnWWROcStycVlYbXIrQnJSRDd5WGJSMU5O?=
 =?utf-8?B?U3FFU09MbysyOXZUbUpRVUlqa3kyTkNCM0lPM1JrcEptaHVVa0M3elh6Vmlw?=
 =?utf-8?B?WGNPdkxMK2VFajlJRGtyakVBaURZMEhScVN1VEdCM3grSEdaZ0wxOUsxYUtZ?=
 =?utf-8?B?UUtaSDZzVUlLWjkvS2dMMC9EUWVWVmJSWU16cEIvUGFDUElGVTU5emt4dTJT?=
 =?utf-8?B?cmVJSnoxa01qc1lFZDlkRmVCSFRVUUUwK2ZjeUpqdi9TZy9ySVhlaE1ndmY1?=
 =?utf-8?B?SUIwckpwbnNCNENsSitmQ21ZWTArMVZVY3Bpeis1a1RTQWtvUHpiM09sWFAz?=
 =?utf-8?B?V2JZclNsd0ExS2xFbE9QY2NmREV3ZWhDbU1LTk8zUjZLeG1Jc0pnRWZtZmxJ?=
 =?utf-8?B?YXdQc2xTd3grSHd1dGFCUjZLZzN5RXhZMXFNUCtIbGFaRmQzM3FLeFJDZ1E1?=
 =?utf-8?B?QWJVRW55UWRneFR3dG1TQ1RLMlJXZHdyeUxjNWtQbmdCTkNhYWtUdW5lMG5P?=
 =?utf-8?B?dE8yN2hFYVV5VWVrQ01TM3htaGNiRFR2UDNUS0d1anRiRURJRGpqOThjaEox?=
 =?utf-8?B?c2dEMXI3TWZRQkI0ODJNU3kzMDNjb3hRVTA3emo5ZVYrS0hLQzNwMlhHS01I?=
 =?utf-8?B?dk01ZHlhd0YxbkszeFg2QldKNkdiWVphNWxDTUV6ZGh2VGtIaS9RNEdMaWYw?=
 =?utf-8?B?UUo0aUcwbVFhdk9pRlVKeWh3Y0lhVEpnVUV3NzVJS05hYVAyQStuMzllT1hi?=
 =?utf-8?B?MnBWQnNSYnlKRkNYeG9NcjF4WjJkOUsvaWhuVCtzMDA5WFg0TGhUTVpaRUZT?=
 =?utf-8?B?TlZBZkVFV2tvcmdxTUJ5SnRTdHJyUXA4WjdBVFNITUluRlVybmJza2h3ZFNT?=
 =?utf-8?B?alB3VHc4VlZORnYxUzBDU29NTUN2Mkh5czlCRWhkc1U0WVJyT3Y5MXFTWWVV?=
 =?utf-8?B?dFArMW1zTWR0ZDAxVTlscHlsYzZEK1hvV3ZOYXplRWM4cG1BTTAxQXlQdTVH?=
 =?utf-8?B?RUEyMUZMemx1Zy9MVU5PbjVnSndQd0htMU1WU3A2STBlZStRN2l3TVdCYjRQ?=
 =?utf-8?B?L3I4NW5hT2RXWWlxQytSUW13aHVIRjZKTzRuclNTeXJ6aVJtMTFjWEdIcS9C?=
 =?utf-8?B?OGl5NUNVSkRZRkN4RXY2c2x3OGwyblVzbVBud1ZlVWpncXMyOXc4emxPQlND?=
 =?utf-8?B?Z0h0bmNBREpGcmRMQUNSTHJRc2pEQVFsTlRlV1MxSkx4U25yVUtMOHVYa1dl?=
 =?utf-8?B?d0svNHBFT3d6VEkxWW5wdHlMQVRXZWYvOWtkbFY0NVpSb010SUFUTHBvSHI1?=
 =?utf-8?B?SjJZSmgvWldJbXJTUGFTQmN0dVd2eG1YejlJVitNbHl1MkpoUjEvVnRRalJ6?=
 =?utf-8?B?Wkovd3IrME03b1ZDeSs1ZmY2WnJoeTJIa2NKdUlhR1h4RVZWcVVhd1dzQmpr?=
 =?utf-8?Q?tgP3Wpwi5xgYKvxa63mlVPVZ+2jeZLca3ZSDTXfNAA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6C1156DCCBE44B4E911FD3C5E06129D9@EURPRD10.PROD.OUTLOOK.COM>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dc45317-8012-4170-e43c-08dcd22fb133
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2024 07:02:25.7834
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: riwgLFzmcDGTLV6Mms0xSn7Zx6LT+WzKyRmn7XYbHDUj6fs52D84H360RPIjt/ga7FKkDimQEXfNNETNFH31qL9odw2EbJCT7C4Ko9Uq/1A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR10MB6755

T24gVHVlLCAyMDI0LTA5LTEwIGF0IDEzOjQyIC0wNDAwLCBXYWltYW4gTG9uZyB3cm90ZToNCj4g
DQo+IE9uIDkvMTAvMjQgMTM6MTEsIEZlbGl4IE1vZXNzYmF1ZXIgd3JvdGU6DQo+ID4gVGhlIGlv
IHdvcmtlciB0aHJlYWRzIGFyZSB1c2VybGFuZCB0aHJlYWRzIHRoYXQganVzdCBuZXZlciBleGl0
IHRvDQo+ID4gdGhlDQo+ID4gdXNlcmxhbmQuIEJ5IHRoYXQsIHRoZXkgYXJlIGFsc28gYXNzaWdu
ZWQgdG8gYSBjZ3JvdXAgKHRoZSBncm91cCBvZg0KPiA+IHRoZQ0KPiA+IGNyZWF0aW5nIHRhc2sp
Lg0KPiANCj4gVGhlIGlvLXdxIHRhc2sgaXMgbm90IGFjdHVhbGx5IGFzc2lnbmVkIHRvIGEgY2dy
b3VwLiBUbyBiZWxvbmcgdG8gYSANCj4gY2dyb3VwLCBpdHMgcGlkIGhhcyB0byBiZSBwcmVzZW50
IHRvIHRoZSBjZ3JvdXAucHJvY3Mgb2YgdGhlIA0KPiBjb3JyZXNwb25kaW5nIGNncm91cCwgd2hp
Y2ggaXMgbm90IHRoZSBjYXNlIGhlcmUuDQoNCkhpLCB0aGFua3MgZm9yIGp1bXBpbmcgaW4uIEFz
IHNhaWQsIEknbSBub3QgdG9vIGZhbWlsaWFyIHdpdGggdGhlDQppbnRlcm5hbHMgb2YgdGhlIGlv
IHdvcmtlciB0aHJlYWRzLiBOb25ldGhlbGVzcywgdGhlIGtlcm5lbCBwcmVzZW50cw0KdGhlIGNn
cm91cCBhc3NpZ25tZW50IHF1aXRlIGNvbnNpc3RlbnRseS4gVGhpcyBob3dldmVyIGNvbnRyYWRp
Y3RzIHlvdXINCnN0YXRlbWVudCBmcm9tIGFib3ZlLiBFeGFtcGxlOg0KDQpwaWQgICAgIHRpZA0K
NjQ4NDYwICA2NDg0NjAgIFNDSEVEX09USEVSICAgMjAgIFMgICAgMCAgMC0xICAuL3Rlc3Qvd3Et
YWZmLnQNCjY0ODQ2MCAgNjQ4NDYxICBTQ0hFRF9PVEhFUiAgIDIwICBTICAgIDEgIDEgICAgaW91
LXNxcC02NDg0NjANCjY0ODQ2MCAgNjQ4NDYyICBTQ0hFRF9PVEhFUiAgIDIwICBTICAgIDAgIDAg
ICAgaW91LXdyay02NDg0NjENCg0KV2hlbiBJIG5vdyBjaGVjayB0aGUgY2dyb3VwLnByb2NzLCBJ
IGp1c3Qgc2VlIHRoZSA2NDg0NjAsIHdoaWNoIGlzDQpleHBlY3RlZCBhcyB0aGlzIHRoZSBwcm9j
ZXNzICh3aXRoIGl0cyBtYWluIHRocmVhZCkuIENoZWNraW5nDQpjZ3JvdXAudGhyZWFkcyBzaG93
cyBhbGwgdGhyZWUgdGlkcy4NCg0KV2hlbiBjaGVja2luZyB0aGUgb3RoZXIgd2F5IHJvdW5kLCBJ
IGdldCB0aGUgc2FtZSBpbmZvcm1hdGlvbjoNCiRjYXQgL3Byb2MvNjQ4NDYwL3Rhc2svNjQ4NDYx
L2Nncm91cCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICANCjA6Oi91c2VyLnNsaWNl
L3VzZXItMTAwMC5zbGljZS9zZXNzaW9uLTEuc2NvcGUNCiRjYXQgL3Byb2MvNjQ4NDYwL3Rhc2sv
NjQ4NDYyL2Nncm91cCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICANCjA6Oi91c2Vy
LnNsaWNlL3VzZXItMTAwMC5zbGljZS9zZXNzaW9uLTEuc2NvcGUNCg0KTm93IEknbSB3b25kZXJp
bmcgaWYgaXQgaXMganVzdCBwcmVzZW50ZWQgaW5jb3JyZWN0bHksIG9yIGlmIHRoZXNlDQp0YXNr
cyBpbmRlZWQgYmVsb25nIHRvIHRoZSBtZW50aW9uZWQgY2dyb3VwPw0KDQo+IE15IHVuZGVyc3Rh
bmRpbmcgaXMNCj4gdGhhdCB5b3UgYXJlIGp1c3QgcmVzdHJpY3RpbmcgdGhlIENQVSBhZmZpbml0
eSB0byBmb2xsb3cgdGhlIGNwdXNldA0KPiBvZiANCj4gdGhlIGNvcnJlc3BvbmRpbmcgdXNlciB0
YXNrIHRoYXQgY3JlYXRlcyBpdC4gVGhlIENQVSBhZmZpbml0eQ0KPiAoY3B1bWFzaykgDQo+IGlz
IGp1c3Qgb25lIG9mIHRoZSBtYW55IHJlc291cmNlcyBjb250cm9sbGVkIGJ5IGEgY2dyb3VwLiBU
aGF0DQo+IHByb2JhYmx5IA0KPiBuZWVkcyB0byBiZSBjbGFyaWZpZWQuDQoNClRoYXQncyBjbGVh
ci4gTG9va2luZyBhdCB0aGUgYmlnZ2VyIHBpY3R1cmUsIEkgd2FudCB0byBlbnN1cmUgdGhhdCB0
aGUNCmlvIHdvcmtlcnMgZG8gbm90IGJyZWFrIG91dCBvZiB0aGUgY2dyb3VwIGxpbWl0cyAoSSBj
YWxsZWQgaXQgImFtYmllbnQiDQpiZWZvcmUsIHNpbWlsYXIgdG8gdGhlIGNhcGFiaWxpdGVzKSwg
YmVjYXVzZSB0aGlzIGJyZWFrcyB0aGUgaXNvbGF0aW9uDQphc3N1bXB0aW9uLiBJbiBvdXIgY2Fz
ZSwgd2UgYXJlIG1vc3RseSBpbnRlcmVzdGVkIGluIG5vdCBsZWF2aW5nIHRoZQ0KY3B1c2V0LCBh
cyB3ZSB1c2UgdGhhdCB0byBwZXJmb3JtIHN5c3RlbSBwYXJ0aXRpb25pbmcgaW50byByZWFsdGlt
ZSBhbmQNCm5vbiByZWFsdGltZSBwYXJ0cy4NCg0KPiANCj4gQmVzaWRlcyBjcHVtYXNrLCB0aGUg
Y3B1c2V0IGNvbnRyb2xsZXIgYWxzbyBjb250cm9scyB0aGUgbm9kZSBtYXNrIG9mDQo+IHRoZSBt
ZW1vcnkgbm9kZXMgYWxsb3dlZC4NCg0KWWVzLCBhbmQgdGhhdCBpcyBlc3BlY2lhbGx5IGltcG9y
dGFudCBhcyBzb21lIG1lbW9yeSBjYW4gYmUgImNsb3NlciIgdG8NCnRoZSBJT3MgdGhhbiBvdGhl
cnMuDQoNCkJlc3QgcmVnYXJkcywNCkZlbGl4DQoNCi0tIA0KU2llbWVucyBBRywgVGVjaG5vbG9n
eQ0KTGludXggRXhwZXJ0IENlbnRlcg0KDQoNCg==

