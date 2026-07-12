Return-Path: <io-uring+bounces-13990-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id jjD6Ax0DVGqTgwMAu9opvQ
	(envelope-from <io-uring+bounces-13990-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 12 Jul 2026 23:11:57 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id F2F40745ECB
	for <lists+io-uring@lfdr.de>; Sun, 12 Jul 2026 23:11:55 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=outlook.com header.s=selector1 header.b=mPOjNF2+;
	dmarc=pass (policy=none) header.from=outlook.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13990-lists+io-uring=lfdr.de@vger.kernel.org" designates 104.64.211.4 as permitted sender) smtp.mailfrom="io-uring+bounces-13990-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=reject ("cv is fail on i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 49A973001F82
	for <lists+io-uring@lfdr.de>; Sun, 12 Jul 2026 21:10:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46F1933F5A5;
	Sun, 12 Jul 2026 21:10:57 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from TY3P286CU002.outbound.protection.outlook.com (mail-japaneastazolkn19010017.outbound.protection.outlook.com [52.103.43.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D770C1A0BF3
	for <io-uring@vger.kernel.org>; Sun, 12 Jul 2026 21:10:55 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783890657; cv=fail; b=oaX5FdvEj1JDF61Oe0CQ9BNVv+t4B9/4n3qiL238R9pMEI8/t/ftL6Ct8OEZ5yFCGntZ/KZmzzw/xQmIyG6ebMf+blci3paX1cf2IdaoKzB5KdyflUnSwmiQ/JzqkGehwL5Wb4OS+HNpJ/yYhNhQG9c+gf0nHlhXEQe+fi1xfyM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783890657; c=relaxed/simple;
	bh=FvQzrtUkHoSIJ8cB/vMCow7LupnLZT3jCQVXox/knyc=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=B2OI0SOIhfBs2uY82QxCSPxL/gd0Awey8jy8S89iN81AhiEsPnbFovUUIaLv4rdHloKYm64eGgtAL2HwiuXayvF7EF2ymGcm6Otr9B7mRNx2dNjl8k4yTm2iULvCyb+KalR429N+ngY+hL/9wxZZcXdckByL5WJdEJUrngn4600=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=mPOjNF2+; arc=fail smtp.client-ip=52.103.43.17
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jhuhkn+FjR4ukXJjHqQ3/1jYQis66RiuXl5rblK/bYnQ/IjsfXVJRB0TxJaGJnyaKYHKWPPjZ7wfSNNlqTuzFft9cgksuePitHlKQDk/OKOvGK6M0AnKSFYnl/SQ0pO7ObSbc861oi2avztUK9q2+RT33V+bLs9LottO1iRQxaM/PHX+c+Qdtk3EYmyNu0kLusr0XrhDRYd22MWRAcKqYWAYEdtzSSPiroboO+fqqQnmiPqf6K8G8karShge5REr4rfc+dKWJ0BGw8niyGWs0uQqowi8acalMOMN5RX3k7Fd3HCdlIjzeAyBY8+WIugF+Of480I3CbAVRK0oadRRgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FvQzrtUkHoSIJ8cB/vMCow7LupnLZT3jCQVXox/knyc=;
 b=HBPMfzUj+A4um98GsqegmRzFOXKjy908iYVo0e9aLeoGear7kKdoIhZ7qJRVa/NIppw0WUwSH3FkvdNiAgiwGYtiO1fASBhqu2I+z+1bSI91d4dApiXzDY9Reu+acug2EfOuL2NG535Tb+1XXCPlav7nJhva9A4e1QtW5btqvVwwtsR66cO2FNeOE0BoZj9iUCbD30scVObn1XUpHpapcxwVYfJ+HbJUn6b4QpbS3WL8VwNm7lP4eNel0om3MaLbLIdg4DZ75rVxPsDF9urabY99djoU0XtKGUdzsnp9ZOtrR8svXnisDDn+PKhlYtqJylTf5kh2LlRTLrPEA7ViHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FvQzrtUkHoSIJ8cB/vMCow7LupnLZT3jCQVXox/knyc=;
 b=mPOjNF2+4L+ICK38doioMPrMAJGxPlq1oQGFuzY2ZY4eUrXTPcLP7Jcow5a+iEZ6XrS2hDHQ+3kSwBTZmFVar+944coxlBZi+kdmIRRcJp/yDLb/WGc+AiZUVx7a+8Hh6WxRaIBzhouTFSVQPPcbySfgx0Im9sQaoeZHyuJ6mnJYT4S880n8+jx0JcDhHkdQ9NX2AoNt7Dw3lSqGGNvSNtBewYGqy2LqNmpHvJZz8GSCD9VmlpZoc32OMbVxLmI2hEbu3sfNkqSOz68ghYefV6r4tucF04bLITk18h9FC+5LtNgq1ME+hXwDQEmdKS3lv2CIEugNTVDZ1simr94r8Q==
Received: from OS3PR01MB8810.jpnprd01.prod.outlook.com (2603:1096:604:17f::13)
 by OSCPR01MB12519.jpnprd01.prod.outlook.com (2603:1096:604:324::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.22; Sun, 12 Jul
 2026 21:10:53 +0000
Received: from OS3PR01MB8810.jpnprd01.prod.outlook.com
 ([fe80::6aab:3198:79a4:4a89]) by OS3PR01MB8810.jpnprd01.prod.outlook.com
 ([fe80::6aab:3198:79a4:4a89%4]) with mapi id 15.21.0202.014; Sun, 12 Jul 2026
 21:10:53 +0000
From: Ji Junye <jijunye1@outlook.com>
To: Jaeyeong Lee <iostreampy@proton.me>
CC: Jens Axboe <axboe@kernel.dk>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>
Subject: Re: [PATCH] io_uring/kbuf: free the replaced iovec after a successful
 grow
Thread-Topic: [PATCH] io_uring/kbuf: free the replaced iovec after a
 successful grow
Thread-Index: AQHdEkLs8/J50zCaPkGjViQqRd4hhg==
Date: Sun, 12 Jul 2026 21:10:53 +0000
Message-ID:
 <OS3PR01MB8810AD4FB8AAF0755099A1E683FB2@OS3PR01MB8810.jpnprd01.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS3PR01MB8810:EE_|OSCPR01MB12519:EE_
x-ms-office365-filtering-correlation-id: 47826c99-ea22-48ab-d351-08dee05a0ed2
x-microsoft-antispam:
 BCL:0;ARA:14566002|38102599003|25010399006|15080799012|4140399003|8062599012|24021099003|19110799012|8060799015|31061999003|11031999003|440099028|3412199025|26104999009|4295299021|102099032|52005399003|40105399003;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?F4af1GC5CaGDwWPCvBB5GnN29iWZWzQwlPZTDFAhrc9Ei+7lIrIgbMxeClRl?=
 =?us-ascii?Q?jqDB5AwnnvEDbUZU54PiYJjgVgILHE8b4kunEw/w0JsyoRLbqEGA4wU+/Oex?=
 =?us-ascii?Q?CFB9whiUf88iTMuWvkc7jxaWlOu0WcGmnAxWMmLZMQCR9R6Hrxp43CE3dEzQ?=
 =?us-ascii?Q?gFb5QR47SzPLdNuSebQRN1qJFHFCjOMNTlXzmZ9hTfKaVkiI+LLtpKPLmHuv?=
 =?us-ascii?Q?ju1y0fP6iiuZcJqEbYHvisulln6+8IFk0neZ7YWNNu5lnKf/V3LlTL13dnbG?=
 =?us-ascii?Q?9KA2VwUUgnVvp9SVrdMo/w0Dsl5SYfLwF4wFuDKOU3M9T4jRyjNv7z7wDtbi?=
 =?us-ascii?Q?cvjqMGHE8fTC6Dl6P0SDhjicFtGfDTN0UYaQULrjrjF7TXrVoBdPNgyHJ6D0?=
 =?us-ascii?Q?3m5ojL7niATnDGS6UY+gK+FoYbYIPsqNX8nlwcVDnIZj9+205yWPYBYf+qFp?=
 =?us-ascii?Q?Zv3Yhj1yCyejgkB3rhELcpVmk48yTjebUhNJIhdQ6WPA1fi/k2WstykAsRaS?=
 =?us-ascii?Q?U7mO+6D4BxahjW9zoEfl/O0bTKaJPncHooM7oOK3PagHHZVEdxMxZC7HBl0A?=
 =?us-ascii?Q?qRwfZHXtSsNrcGEMNVZHk6q+3U+EqAfINPNJare+tQ9mSzCr/ZxajwRAKL2N?=
 =?us-ascii?Q?eBw5VRuXldAwsd8HXaEkbp4KYPZYQMUGSsuek6mOZvRrQbvjZIX/PHMU9xzI?=
 =?us-ascii?Q?nvJiuFgZ5bxty/bGCRdUFd8Ub4FJurtGVJJV/SN36tSUBS6k7S0YLyYt0yxo?=
 =?us-ascii?Q?LEgm7iHbMIxNCqJ9i3s432lmtLdtSBpGw45AD0IjM3bTaMjSFAxbBvrhtxVZ?=
 =?us-ascii?Q?WC/C3g6De81LJ1TYQGaxXpkO+w/kWSl4pERWkl9Nt2/gmjl/kDhbcZbv/Fkt?=
 =?us-ascii?Q?0trDXypCu1vg3wLLZ8ocp0ZqlYUXC8nfb7jXkYwZmnkamWZu6QihdD1rYto2?=
 =?us-ascii?Q?eRG15gXyP0GLvGIo38sXt+Cr6nKn1f7BirpvS3fh9V7K+pFb1PYQID7oltVQ?=
 =?us-ascii?Q?vCfi?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?PDZNffbudZubGH7/ca78yyjBFpLSyswfe3ToBo2q7tDOdiSVTr6mW4v8tezj?=
 =?us-ascii?Q?rNjfGPNus0bSVaIxqWe/ZCRz1b90cwat3SZ9CjctLj6px+pKywSh1SS0N3Uh?=
 =?us-ascii?Q?J3pi8OmYXNTZvGisAQpStG+mBcbGLuQe+T7CNL7E7sJEcQfvt8qL5RrBgxmV?=
 =?us-ascii?Q?tMHcgpLMUw24zWjy3CucfGuhVAi21RjFbN0HxRonLzldju6LioNVipHqNOZX?=
 =?us-ascii?Q?oA5f42paoMIINItQ7HSN4T26UjmEvSgEb9DaVBK4fVF0t8gSXMrzUqXGOlMH?=
 =?us-ascii?Q?uFt72RlZlXN2wIIQzy4ahKXg3cDK8rgpX0jpYGt/gASsYA0EOUFOM7oPeVdW?=
 =?us-ascii?Q?+k3DvgV6suYmX0adWXhTEV3jcUbUCnGJT8xsOpAJzsjKNuK4Om1ncQWGwYFi?=
 =?us-ascii?Q?kk3iRQawlrFC7nE9BrMzSjfoCFNCBSof4Z+fkAL7hFgXjV8ajNSoe3hmzKly?=
 =?us-ascii?Q?16Nh+dlYd4YX85HzxJsOkmPZv1dX3BTBEPQyYoW5cYuAIoTQivYOLWTBpkhk?=
 =?us-ascii?Q?E3euRhX4WjV5HMJ0OD+YSRjvvDQhHRMBa6bPmHNNIKQJ1rqRE0b7YpNDtfEB?=
 =?us-ascii?Q?4Z6XnfVsh0bCJUW2OFfMAWlirl9DUqgGOCwTvJpPrXSr3Xc0RY9oVh4xeXBx?=
 =?us-ascii?Q?pa7LQAg9Fg/YSQnN7T2TokrhV/SIns616SFH4czZ1mpIsnzBT6/TBvcdE6Ef?=
 =?us-ascii?Q?WjdJAtHDp0X/Rqe536QGnvhP7SRdH4a0XBp4Rq9ZZdNhz4q5O6JiIxD5iiUe?=
 =?us-ascii?Q?gSic0ZuWJpfLTNGkEP+5ciME3+hxjGxESn9oqhp1HaRumH7wizACX6z1ltdr?=
 =?us-ascii?Q?kmdPWpW1w9aDayuDkm8ZVGZFvbhS1ImxQFyc9xn2/OeL6M3OJ99ypEf/YiOR?=
 =?us-ascii?Q?Wx3J/kxwBtVPB2kZcAqglWlKQDvj8/uzQQnDSOdkZd1grRTQQcTyURI02Jq5?=
 =?us-ascii?Q?ZwbBJvVh+isl5QN5I0QQkwkKU47T1AthQpAyeMuGyIt9vw8qARbK2ytFZW0G?=
 =?us-ascii?Q?XBbVarVTgWa6+lue61NuzWYPXyf1sTO4FdRkhObGAEQjLXGpShms4mVcrJdk?=
 =?us-ascii?Q?+QHNWxNGSMCCJF4FCsYQgcth8vb0Qt7S1GqbSQ4D6AaZ6elaMByShact2ztR?=
 =?us-ascii?Q?UBvoKQFkdg0h2Nnb5AHfXCyXl9MOKsSZJpaR2iwuTRUpagJS9UaLNaOejq1G?=
 =?us-ascii?Q?Ptv+aiFfNlFFyefGpih/BZ5dHJRTOzO4cZfIJ5OHGLDWJqKnn+vNicxdO5Qc?=
 =?us-ascii?Q?TFcwpI/RGWQvxOYwvac/qTtOzE3V6pyBHw4C3i2W4D1ays8jQctf+lR+RUTq?=
 =?us-ascii?Q?K1YWanQ3rAcHkxEid8DWsoSD7nPe38LDcwXrH+5F7bvLRzzIrZf0CgttOqbd?=
 =?us-ascii?Q?S/aOVgk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB8810.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 47826c99-ea22-48ab-d351-08dee05a0ed2
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2026 21:10:53.3232
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSCPR01MB12519
X-Rspamd-Action: no action
X-Spamd-Result: default: False [0.84 / 15.00];
	FAKE_REPLY(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[outlook.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[outlook.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:iostreampy@proton.me,m:axboe@kernel.dk,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	TAGGED_FROM(0.00)[bounces-13990-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FREEMAIL_FROM(0.00)[outlook.com];
	FORGED_SENDER(0.00)[jijunye1@outlook.com,io-uring@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[outlook.com:+];
	RCPT_COUNT_THREE(0.00)[3];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jijunye1@outlook.com,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,outlook.com:from_mime,outlook.com:email,outlook.com:dkim,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: F2F40745ECB

I ran the no-growth and successful-growth reproducers 100 times each,=0A=
along with 100 runs each of recvsend_bundle and recvsend_bundle-inc.=0A=
All 400 runs passed without a KASAN report.=0A=
=0A=
Tested-by: Junye Ji <jijunye1@outlook.com>=

