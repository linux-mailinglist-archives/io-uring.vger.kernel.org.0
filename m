Return-Path: <io-uring+bounces-13989-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id QgUjJAr+U2qlggMAu9opvQ
	(envelope-from <io-uring+bounces-13989-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 12 Jul 2026 22:50:18 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 21C01745E26
	for <lists+io-uring@lfdr.de>; Sun, 12 Jul 2026 22:50:18 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=outlook.com header.s=selector1 header.b="hUJWQB/G";
	dmarc=pass (policy=none) header.from=outlook.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13989-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13989-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=reject ("cv is fail on i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8DF1930028A5
	for <lists+io-uring@lfdr.de>; Sun, 12 Jul 2026 20:50:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2E8C3B2D14;
	Sun, 12 Jul 2026 20:50:14 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from TYVP286CU001.outbound.protection.outlook.com (mail-japaneastazolkn19011036.outbound.protection.outlook.com [52.103.43.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA033ACEF3;
	Sun, 12 Jul 2026 20:50:13 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783889414; cv=fail; b=bXiEmMsJQRB6wYdm0NZUAIrV8cjNA6DSXruZzLDw1AukfCaqWsWq7jgRpPrHdN+IvS4jpruXFLtznylSqbZI4AZ95jG1liuStmTo4HZaQvBjnF5E6fwucX1y/DxyDsVr+LJ7SBANe1v7/1vDmN82l99hYqRMmIeQVF1/8+/EFHk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783889414; c=relaxed/simple;
	bh=wAcF1b6sBxTNMk9I+i/zDr954yTkv43vJxkBUMS8dUY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OaszIj/RJcJFzDjrsY5RYOy2r5uCH+OYYVEBTq9jsNdqPzWdzwQ8vx61px3jm6yCrJeFo9xnD2VRV9Tj6u2LE6e0F8/7xlXFYndHGmKRgHPEoDVIBqXbVts9vWdqWxPeNiSerIQIc8fpIlPLQm8pS5AUwNIz9wBNx2aMnyNtIc4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=hUJWQB/G; arc=fail smtp.client-ip=52.103.43.36
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aVWT5dnWZwK6C1lo+rDiVY9aCN71G+ofhyi4UDJ3bDfXyhPTa3hqwAVmMbpz26E/GndrC2p3unislCpsgrJ6liMk84xMtchPE6wxXLj+ZfYnRUieiBzkI/Xlp3B4covQC2ODXT6EY9yFQblqOcs/C17WNmzyU6qWSI8mUoqsDXSFd/TlorYgPjWTJBIc6xEoyINPjZQ70QMuXo8GRNKkJcImnffxnQCHOu5jmJSDR1448IuI6/evnQ88U6nYF6RTa1ODj7fyV2kyM9sP6w1HL3sRQ2TzZe2r274/7G4OBd46vbWurz+eA5btApJsoOiHjYI+7BhPWhCLbjRQDukzZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wAcF1b6sBxTNMk9I+i/zDr954yTkv43vJxkBUMS8dUY=;
 b=bMquVY5u+wsVIO53H67L5KqsymfFPtx5MUxJT964QstbZmEc/al5j/aN92SSjNfHSp79rb7fyLHARN3bvFxgNxn7Ov4Twd3aNK9NbHSjHeDuiUF04i3QQOR/p24kOumrTSgnLC8sq1dA2j8950W36rPFM9srLmktQWTp033FBsjuPhH6SXN5k/dvXgZEDjkrGwZc9lsFX76+PutYAQYdPhzEVBuoJzau3m9ptS3oSzhDp5tKdlXuLftndMtRZMEqsk9vAipy9Ulb704p1nCbie6TGtABHHY5cNQk1FmfHfeOpmu2VWpG2a/o/d68tkkPEUIwEIzkXq5vV5dTsr7rZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wAcF1b6sBxTNMk9I+i/zDr954yTkv43vJxkBUMS8dUY=;
 b=hUJWQB/GdqU1XEx4d2rKo2+jpoHD2LGgCeyn+bwzlZzksq6GPUmJnQRIpw/ztkI0xMZ3W53s8xSN5yodTqjyWy/AYOvIcK7xTEfnkPb+5PuKQ6bNpINL6zXJtdXagQn5lBhcciBbbWLider9kPpBE/IzgEytI23qRYPpPuLzYm/Z1RAlcisVxvb27UlJtQ8UWdFGAOZ6o1kuIfTHP3nBGTdrq4dvjGuM3CdEgXBA4JCP+Yca1L/dR1nXo2rFxcesUUdJBziK3el13k0Xdz8G5hfNC1gF3q41azSKURP0az1oWaTOtkxe1gZmt8t8cPjWgzmnr0X0en8/0VmRUrwIOw==
Received: from OS3PR01MB8810.jpnprd01.prod.outlook.com (2603:1096:604:17f::13)
 by TYWPR01MB8624.jpnprd01.prod.outlook.com (2603:1096:400:179::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.21; Sun, 12 Jul
 2026 20:50:09 +0000
Received: from OS3PR01MB8810.jpnprd01.prod.outlook.com
 ([fe80::6aab:3198:79a4:4a89]) by OS3PR01MB8810.jpnprd01.prod.outlook.com
 ([fe80::6aab:3198:79a4:4a89%4]) with mapi id 15.21.0202.014; Sun, 12 Jul 2026
 20:50:09 +0000
From: Ji Junye <jijunye1@outlook.com>
To: Jens Axboe <axboe@kernel.dk>
CC: Hao-Yu Yang <naup96721@gmail.com>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] io_uring/kbuf: free cached iovec only after replacement
Thread-Topic: [PATCH] io_uring/kbuf: free cached iovec only after replacement
Thread-Index: AQHdEjwEXix+48+BHkqjfYO+JyG89rZqW5Ka
Date: Sun, 12 Jul 2026 20:50:08 +0000
Message-ID:
 <OS3PR01MB8810F38D613E37FBD684DC4D83FB2@OS3PR01MB8810.jpnprd01.prod.outlook.com>
References:
 <20260712-io-uring-kbuf-iovec-lifetime-v1-1-23028d00b6cf@outlook.com>
In-Reply-To:
 <20260712-io-uring-kbuf-iovec-lifetime-v1-1-23028d00b6cf@outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS3PR01MB8810:EE_|TYWPR01MB8624:EE_
x-ms-office365-filtering-correlation-id: 226c6581-109c-4a6e-0dea-08dee0572923
x-microsoft-antispam:
 BCL:0;ARA:14566002|31061999003|8022599003|38102599003|19110799012|8062599012|15080799012|8060799015|24021099003|25010399006|10035399007|11031999003|102099032|440099028|3412199025|26104999009;
x-microsoft-antispam-message-info:
 0HuCnhqgG8Y5td97sKvvDg8ekrFmm6iXXIkIXQYj1hT5FmxKswZAL08MLgAbbvHDYd747ZT2ksBCbvWXfQ4EFqMPUm+d6LpVZ3ZDEuwlEoizyTuOSrJg3GAgppX2cYGaY7dcxCUk6RnE2WRlJl1/qv0hPspJ4qQXFKkBy+L9zZfjsfjPE/7XllbkyW42/8EycmzOf2lcbmGXfPaCcRQNDlf85xxKwPHdf9wZRefNjTL2nkTDffkXVqJwxivkjsfV9A953LFHZs3s0YdEQCznwHB2vjeyF8mV47GIx9qo84eQjTHpEjGhwBxvNFFEtbmmDTDiZtHfSpShET+/cD1iaUs8Y1uShMWuEHAjus3RKy0xIwTjOdIEfs0G3u7NzDO7fNf4VPw2I950F49lEEY52g5Yy9gKU8H8MOqehmbSaM3JKfG6FiW8VVKKUWTbKp3DwHbXbfJN0RfeZX9VExVySc9ez0wQ9HK0zdQXDqB8TuZKV6+tMcnVpVLJvVE9tGoOeyBpeqNcwFIJAJgSIH4ejFCXDTYy0VlwCI3HqfG2ccA7Eu64JvNmoDyHiy7XTmr+xO+d0G/HxduqnapK69DpzH+yGyK21LkxqO9ullUnC4qQRu8nGwBDjLXTqqiReiuZ8dxSu2QROke0Ep7P7piK4MwMTs5rTQexIWklSN2uAEXtw8yioZeuNnN3b/P4OzoeEgDx6K+O8DqOOmutf9feeug7LKhneRmkojA7WHTdxK97E8VM0tELC7vSKtv64+qbidI1S0gZos8KRYpasyCHa3GZ77pTT3WZRRaqM1rmwsorGgqR1JhBxAJtGwh7Qow3QzfS/14YGQbeUDygkDT/fStrpyBw3wTNYiom2N3V1LaSrUtOVKlwRSK6U7vZ9L1aGvaxul2r4ULe8TQoapjQL7P9Ut+MrbCcdt+QPVA27Y2HTzcJg0QVPG4jGSCco7Aw
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?W7TdE5aiRFiGZocvvj3/s0ozCrKe2HfD0qDXOirkg0Vww2wICmG3Br/6hEEf?=
 =?us-ascii?Q?91Kb0JYad/aJOIYDl/X0lHVtXxg0K3xIg+ri5/4POQ85AtpHwdTYEGjhHio9?=
 =?us-ascii?Q?1KXJYx24iaqXrQOj+u18Z+6Ht0fsY+YFFMToTzZ+E2Ynn0eSOYGLZYTRMFWh?=
 =?us-ascii?Q?ey5iAZhZPsCmlta0cumT1JlR8bCvnPFvWQE1SyEqO4mJ3jbrqqqZoakpFtWd?=
 =?us-ascii?Q?nojuiZmhkx46FdUIZFU1EeaHQc/EsFmLcBMlbNUmHKDihuQmyoASLcEdexFc?=
 =?us-ascii?Q?pTQSawyiB7Od+mFqr+pTNxiy7bbpCAzTP9IOPEhXB3enTa6kt4apfdUtXNt3?=
 =?us-ascii?Q?+scJZ+YLAqCWs+31dvLtV5DtX8RrQ5ToXICI/Am4LpjULnc0PM326VVXFdKv?=
 =?us-ascii?Q?8WinsTe90M7fvveQEWoWD1b9pfHbKgp9UBYUhEFDWoyscJoxCFaqnlqmUCxy?=
 =?us-ascii?Q?L9KxhnntmfJU1E1X3bJOxFMVeWxT71b71H/XwtfvJuFjc7yW8oF9f5zxDKt9?=
 =?us-ascii?Q?NwH/ZWlOoNy0/iZT5ybs78O/JAIoqCOXLhgJNQdvKKnQhsKYfbWdTHpoaA+2?=
 =?us-ascii?Q?odIXfuq1N9ULStws3tGu8VqHpxhrdrSv8slXoNg7QEcp1cv3wUZXTEL6Lvsx?=
 =?us-ascii?Q?NBU2qudG0WX5ItMMRrjs6LgGXVkSq6E+eFIjg9afPzRvog+x8dLLio86b485?=
 =?us-ascii?Q?9FpHEKzBJV8PwVuYxfC263EAdVP83n98ActQqab/9zQsWow6osek/jFvVbfa?=
 =?us-ascii?Q?3WcVk4GdIvJ4I1I1Ji6yyq8F/mFiRE9gHkkcMB6RWkYLm5p0blYyeyDMllfY?=
 =?us-ascii?Q?AvaevR2TxS5bu214CO0eeTNtjrGRN1dBn4MfnG4r/s0V6EfTTzw7KndWP4Yu?=
 =?us-ascii?Q?r20d30NKTRMj8JfVlGEDg/yapGgJp7d6k4XCVlw4riF/4BB8IN1WYocLKpfg?=
 =?us-ascii?Q?0bJrRAJPxkadoxAD4MBrQ7woVAQPxVz+zyA09IRCUXH/kkgQPhnAX2Yfp9Zp?=
 =?us-ascii?Q?5sKCbh48bIQ28BIuc2I1dPdrrDhNi5+yZ/5Y8ZhV5x/qf4QD/DHRaC5LsveB?=
 =?us-ascii?Q?meWPKCByUR4AT9bkB7PufwMFMVG2eig7QFiU6ByvYzJdzn5xdHGo6D4dN9iH?=
 =?us-ascii?Q?3/qXwGVctXP/LfS5ZjVtjDuEmy6J5MAdAI+9BzcrDL9PWmd1CA3gLX+Y4tSr?=
 =?us-ascii?Q?tEX6snqFolhZLDTQUCkc6SNE3kBqEoB8GLRHxwdYBRuvIQ/PeuCrE3Y8pZAd?=
 =?us-ascii?Q?F4Fl4VQ9Br1+ryWZ0SXMmAXcGoI8wB1u5toauN2J4SkNUkO38Rxze08K3s7Z?=
 =?us-ascii?Q?3wDhEEYrAZJ9oQgjkb3lyQ4TZKkARk8l4qa0enbqMyCqGcUM8eXywiAQDjZ/?=
 =?us-ascii?Q?7SD+OXA=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 226c6581-109c-4a6e-0dea-08dee0572923
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2026 20:50:08.9765
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB8624
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[outlook.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[outlook.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13989-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FORGED_SENDER(0.00)[jijunye1@outlook.com,io-uring@vger.kernel.org];
	FREEMAIL_FROM(0.00)[outlook.com];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:naup96721@gmail.com,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,s:lists@lfdr.de];
	TO_DN_SOME(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	DKIM_TRACE(0.00)[outlook.com:+];
	RCPT_COUNT_THREE(0.00)[4];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,outlook.com:from_mime,outlook.com:dkim,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 21C01745E26

Looks like this was already fixed here:=0A=
=0A=
https://lore.gnuweeb.org/io-uring/20260712142612.188695595-iostreampy@proto=
n.me/=0A=
=0A=
Please ignore my patch.=

