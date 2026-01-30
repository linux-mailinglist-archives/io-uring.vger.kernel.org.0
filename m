Return-Path: <io-uring+bounces-11996-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2JsvIOXefGmpPAIAu9opvQ
	(envelope-from <io-uring+bounces-11996-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 17:40:05 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D001BBC927
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 17:40:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6466E3014958
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 16:40:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58685352C36;
	Fri, 30 Jan 2026 16:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ucbSE9Kd"
X-Original-To: io-uring@vger.kernel.org
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010051.outbound.protection.outlook.com [52.101.61.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356AB350A29;
	Fri, 30 Jan 2026 16:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769791201; cv=fail; b=b76x2Hai2tlrdwnSz62rVHxiy0aIJbI+7QytNP8KI/vgs2HTc8J79SY8bwZt4a++vXghgVbZ1jClNpEx3ADjP9QZfhlJWuuqLtsiqFpG3vJK6CY9Zzxnb5EcSM3IpCBkFUswArKJgCfE98GuB92UNk+WaY+ztZyofwtSvqQCYKk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769791201; c=relaxed/simple;
	bh=Wga6BbIWtqKhHD3vVlMEGzA6I4whQVAvkpl45olHqps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jr1Ew+HXMya1OUAp5ZVZUjLSX0w1FTjjaEI/8+xDqLRJZs3MQBFq2/VO3Bj1ixn7RtqcxUs90xymJm/QtZaVNQvY3sY96S/eGyOLaPaMNobS7phAImvKpOUgGxKv+3ot7KdahQA9zjF9oDxWf2lCLMli8W9ajgdkDVXfYzNmW9A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ucbSE9Kd; arc=fail smtp.client-ip=52.101.61.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Oqpf03Qljrtp1oelbqD6NU8XgmAVenbLZDO5QQ9G5v3x6jwCwfe5wg5wEk6zXBtfhpnIcBFT5998fv7/FxNAjUmg1sWNciYrZoxShDNQ4hEPrHEAaMrGggP0Vz9uo/1USxmJcoG/hN1rJWXJtbDIAfrlFkEpEeybe/i0QwjQJHCj7Lgj344fGBcAy0ClalURHKSlp6IqDmC2co/8Wz60ewDmZMpLSOHEmvhJ5Zg4DfFrArgjahpRHx3SZU9uutn6IRwe/jGi0qXw6H1KV/u+x1Bz4ugdPKj/MgyDy4Mv88sAUEYJ9FSRmQaXcNno1P4lLXHuakrWBUji1DoRNoIYVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HUGGo+36f7qwsFsPL5VjqY0jYr2eh/0L5rr/8TMI5s8=;
 b=bdDrRxnPqZtbfce9QJNAHWrufM/1X95aTYf1zykjCJ4kMz3sXgILmbTrzkp3jmiVKIOoqurHPx2cjCggxmuS+Dx9eCi+Cr+05ikPLXpVRQRK6vPVCr6fqowJAzsjCpAO3R7+68EPYvaecdRtAltu3t9pOVASMTTmDCpKetYtgYjGIddY4rVrK+ALTy1Qzwl3Nbh4+FKI06bMhEry/rSdCp1fzsZDXIaYBodgRMuf1WtWaDXfo3GoNCpyUIFEot3MiI0o2jwmcPsuaQwFVhahVWem6BP+SV4eIDWbHWgUH9FekFc1lmymLAs+/pAYDzqrv3i4OU6ioOFILnbookaUYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HUGGo+36f7qwsFsPL5VjqY0jYr2eh/0L5rr/8TMI5s8=;
 b=ucbSE9Kd6ejhtWRV4Nb9+cHFwTl2SbDWPJgDzAkty5iT+Wr2j0b6yoL2MhF4Bg/f3k+5HD9kCm/z/L+260dROmMFWjhcRY87WZ570RQWM79SnSXOlqOYD9RC1Y7WlSFswjw1p0+O79XyxwFXOeBU/nwYnJbyUdEB5bqhA8Dfsopb/fym0yp9FWfAXXC11TVQ8kMfe5S2qzqpMfUyuhmFe3o1mEDln+LpyvExgi3+jAOFx5/+CgS20Q8+UJUNLLekz3EEF7L/waQtSeimlLaKhhkN5Gm5oFzD7qvtxGuL2v66qO9clE1F+uG5Z/oQ/F83Cw/yuiapXb7XCVSPUXG4og==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 LV3PR12MB9402.namprd12.prod.outlook.com (2603:10b6:408:213::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.11; Fri, 30 Jan
 2026 16:39:49 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9564.010; Fri, 30 Jan 2026
 16:39:48 +0000
From: Zi Yan <ziy@nvidia.com>
To: syzbot ci <syzbot+ci7f632827e1b1c91b@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, apopple@nvidia.com, axboe@kernel.dk,
 balbirs@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 david@kernel.org, dev.jain@arm.com, hannes@cmpxchg.org,
 io-uring@vger.kernel.org, jackmanb@google.com, jgg@nvidia.com,
 lance.yang@linux.dev, liam.howlett@oracle.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, mhocko@suse.com,
 muchun.song@linux.dev, npache@redhat.com, osalvador@suse.de, rppt@kernel.org,
 ryan.roberts@arm.com, surenb@google.com, vbabka@suse.cz, willy@infradead.org,
 syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Separate compound page from folio
Date: Fri, 30 Jan 2026 11:39:40 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <2A678D66-2516-4130-A34B-6A0B3549EEA7@nvidia.com>
In-Reply-To: <697c68b3.a70a0220.9914.0032.GAE@google.com>
References: <697c68b3.a70a0220.9914.0032.GAE@google.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR03CA0114.namprd03.prod.outlook.com
 (2603:10b6:a03:333::29) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|LV3PR12MB9402:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ed83828-0bbe-4aef-dead-08de601e2e91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PoRsv9AVYuCIcpmoG+bn0g+WnTs/gghYD+SjbYQ/12AjhKJW4Loh8nnSo2LM?=
 =?us-ascii?Q?bIJ6dWxCURdTNFYToR3JxkEwD+J9eVC+Ezjio9j7DXfJAicV6nNd77LrZCuN?=
 =?us-ascii?Q?Ptu7lEtDL3ENQ0unkMhAPc3XOpqvn8vJYxiHNjx7jX1zywxLhTYEJGgflX3Z?=
 =?us-ascii?Q?XhLgFAej/6zSgclAbIvbgElzgRIrj6TdNMrQMQKyLerizwWdrsHL5cr/n4Tg?=
 =?us-ascii?Q?iZyUL4fjZuYuIx9Yul0LqW7HkbUtsy0m8izXMY5FNxg10rh1lxcNGupsgR9X?=
 =?us-ascii?Q?NbzDaqm9/5guujDaNYAmYpsiE1muXIyQUSK26IECHT8EhivZn7OYDHax4IoN?=
 =?us-ascii?Q?MfZdX+2YIlSTjLEMjNv2otNzDij5NXNsdglMSyex3d2S8sdp0VxtLTVGorBb?=
 =?us-ascii?Q?Dj3yULnQQGlyWO1hgk+fHCBHQ98MWpXvbwFG76oithX96ai7NvbcN50q3tpm?=
 =?us-ascii?Q?DJICmeGbZytV+bBLm/Kte/Yhvt1rQuVLPWh7CKmfvd1vJykmBAXCSDqHI/sv?=
 =?us-ascii?Q?tibypD6fxDR0V0v85hr7mYtH9AassDwEAkvG9bEutxUUWPgqnyfnjVhY5gmK?=
 =?us-ascii?Q?1YDvoQera/tjrUtvCgrWDhtCsbJma8wqIqMYNgSxN99xaKqHU9yCuSfy6YXK?=
 =?us-ascii?Q?Vqtvr80u6W8J1zWVeAal4ZK5Nne3jZQyQ8LfpHzgziDdYXS7Lu9STJ7HjE77?=
 =?us-ascii?Q?dHaunJMhkboof3R1thgo8DF7QqYSdb7wKmN/wwwETY4IBZhjr/pAdaGu+nA7?=
 =?us-ascii?Q?ZLr34Ad7DNuocUnbC1Kz5MV7leypejq1/warWMVaJUzNUr4Tbn5iBFABTQ9l?=
 =?us-ascii?Q?AnKaDMDsrw3APMER3Vg3aNcqqHFQL6hyA0ASzDCgY9Qai/uaQw9Egd/CoPlJ?=
 =?us-ascii?Q?SDHP+RQyz88ILg1aqc5lkKwO2Ii1S/zJH6SBRH+NpyiaDw8NT6jODPG1Gtvz?=
 =?us-ascii?Q?Q79p/ohqB8eOELOidHc3YcXVGTWG7CPfCk9meO7iYRA28k//4x4lZhcFDO9n?=
 =?us-ascii?Q?n6BWRG0TptcPuyzRZltzTH9OiHjyhai9NuQMhDuNtLyuQpJ14IEKEDTMHhVr?=
 =?us-ascii?Q?GIgav8dawZw9S+umTpVd6Pqq/U+z0vLvy9qnipog/ZB7sYAZCvpNu7EUL287?=
 =?us-ascii?Q?glZOmOclga8XLFnYg7DgDMn0buFU9Tbd7kGSWfF0hXrt4qIAq0pdtUiijWbz?=
 =?us-ascii?Q?Q/xCPU05aR4syl/TmXf/bd1H7y3y7MKvTTauJZFnkY8dnPhfN/J412Qr/QP4?=
 =?us-ascii?Q?HZhVk1f2m0YSNXrIfYYGLTFFgD8dZGRWRNRQ0CPAExpOhVe+/0ODNmfxyGKE?=
 =?us-ascii?Q?MxVcTIRHeHuZyKyCOhmEnmLjOynS7n0jvDule4MKgr8yc69xKVv2sEV/87rT?=
 =?us-ascii?Q?JAMY4GyVKujfaKuw3BSkbFewHmhgUeFQKEGi9B5asTP5A3wweHvbSYRUli1e?=
 =?us-ascii?Q?E0gtE8EXIU+zK5LFrFX0Kngfpiiivjut9cGGkVdt0K9fDKjubBo813PPTE66?=
 =?us-ascii?Q?mP4Wa7cK4qpZ9W+NRtI8ltslhMJQR5xyZsFjVdSEH9DJ+P2Zo3FmFEKubfvb?=
 =?us-ascii?Q?BHhOzBiiIizo+Lu9hs8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vDBSl3mDDge9rtpYBmF9KPPN4R2ilyRmVtstRm1qelO7BoqRrbdAtPTcKwdH?=
 =?us-ascii?Q?PT+3H2INePTSndPuuUY0MoXw8HF2nUVYeewtIGDU/zRbb3Ncw5HRqi7pdtwm?=
 =?us-ascii?Q?UzTSqVqD2UCMYY5S86D13J3RwJVGkPTXqTd2IXywTYIqqXmmsMmEGaEt7V/T?=
 =?us-ascii?Q?eTB5BiyCcw86uFd9KfCHdrB/2DbCyWGmu8WdGFx7cdn5JbBe8CopfFlSrkFq?=
 =?us-ascii?Q?XMJGaSWnjqR8/z31hvu0ZJidZZS8svXkmt6uuCMOTM+/P/TLBUsGdzPejmUC?=
 =?us-ascii?Q?DV+aHyv8Pgm5BnnKt4Nfy/zxukxnKTOnMbhrt+G3l+/ljUToNXpbKbxlNjIf?=
 =?us-ascii?Q?/vbUNdPy3TLMndr/rrAFm7LU+8aEin804wGyWvmnbL3iT8PifCv++7W2yuLA?=
 =?us-ascii?Q?FPo0WvuOXKkMQMMGq+Aryi5VDMjlqgh1Qb3a44t0hsGEtN0P8OhZVNXJw7aW?=
 =?us-ascii?Q?DP1Ii6garj/1O/HiTyW5L3SetlD2Aanc4GQ22WTWDryUUqlXEGek2Cs5MKmQ?=
 =?us-ascii?Q?q/NVshT2+cY2JIWoV6hUyyGXSyCY8BX6IBeY/8mA00J/vVNeix0ZpYN2k2rt?=
 =?us-ascii?Q?XE4lhbHo8vwdDsCfkpARvWSQzXjHdcOa8uWGBlttMEvQ13LzbqafgUr7YjcD?=
 =?us-ascii?Q?aMEu6D2NIlve1/+Mx3diQ2Va2CTQTGqEgxM5HlG29xb3xMCWf7Gg/86XMrgK?=
 =?us-ascii?Q?yXbL6gZjjkIn1Xos0pBEtz+Us45KMYwWzPhV5uA2YUvjF5plGWqRuuE80rb8?=
 =?us-ascii?Q?MPo3JF1CsxfO5N/pR3NTnqrd2EjHa+L6e84HNRYLwzy1Eb20UDuJBsrKem+h?=
 =?us-ascii?Q?SEwxUGVm8c/qCtNFdXdUAHTnrb037kpQAjGeFmYxTv+COGwOTzJo1Yltw1+V?=
 =?us-ascii?Q?PTJL4UdaTd/hmyGY+7yXlWPechCMsrl3D1ht14+cvLK4FOSUSbZ+dL+VbsCk?=
 =?us-ascii?Q?Tfry47k7WJ4igemAg1s8l4QOz3bA86kQuINsNEl5CChTwz63SdPndRriF3pv?=
 =?us-ascii?Q?ifQwzbekTQiP6+M42zuCEiHSBDISgB177C/L/GqlAYuv5F+TtkTvGMmXKXbN?=
 =?us-ascii?Q?6cTQ0woCkQBIxES2487yF2Ox5NSWM0qmVACBQy+OTS9fhaKHIM1qh5Iaaoyv?=
 =?us-ascii?Q?aGRQqLxGg3qVJhotHDTbJGaGv9fLzB/cwq6eT3gYbhak/ga9uqcTLRJPYF4g?=
 =?us-ascii?Q?xH1lgwvoi8kwKqvUbcUhiBHuiRfh01j4CSrEM2QTycstBP3jozUnWaNZqm6i?=
 =?us-ascii?Q?JV3PfBqaUvOdwjPSvFQ5C5Eg9Kwahb7Pyb/8oHkdo1YJ3xyrd2liYd9Fn/NR?=
 =?us-ascii?Q?sbruD7NiNmyRoD/2GFnbJRF/RfjryRtaFj9UgRqMdks3LTc9P8Iu85C5rpmD?=
 =?us-ascii?Q?lxBhuaQaDNWOs1n2XbFfNlSNkfggRKBpjx8bo3KSUqgK9waHL4sbxHcXOzSL?=
 =?us-ascii?Q?jUfXUlUFoYuVBbfIC3/BPwwyEDwwPCRmIy0hCq28VvUnwe6XOJxHnURoONhl?=
 =?us-ascii?Q?nleWKtWXWYSiadzuuBQNAPUmh9XmHY5rVtPxpent3OHlKW+Q93gwdqBFe2yq?=
 =?us-ascii?Q?JNt5Nn54OaGJD0xN5iB2ESeQH5tDoJPXzvW9UkpRIkwp+xrukCQs0avMpx8V?=
 =?us-ascii?Q?udsbyPh8WZjnxuO97bGFubuQ4M+865RyDrcWYlXGC+Gz8fKupyAU8GtkNxSh?=
 =?us-ascii?Q?w/LCoiUjdux/M/UgHhJ58YTjmh6/u9+3YiBxiC+8DCaiWC4ru6RFmOaouJHr?=
 =?us-ascii?Q?nkpglx8l4g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ed83828-0bbe-4aef-dead-08de601e2e91
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 16:39:48.1480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yggb7pthLG5XMZIrayrui370kiccGaUcu6AFOdNb6B1T1p1NThZYY6MCTptNTfyz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9402
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[29];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11996-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ziy@nvidia.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring,ci7f632827e1b1c91b];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,nvidia.com:mid,Nvidia.com:dkim]
X-Rspamd-Queue-Id: D001BBC927
X-Rspamd-Action: no action

On 30 Jan 2026, at 3:15, syzbot ci wrote:

> syzbot ci has tested the following series
>
> [v1] Separate compound page from folio
> https://lore.kernel.org/all/20260130034818.472804-1-ziy@nvidia.com
> * [RFC PATCH 1/5] io_uring: allocate folio in io_mem_alloc_compound() a=
nd function rename
> * [RFC PATCH 2/5] mm/huge_memory: use page_rmappable_folio() to convert=
 after-split folios
> * [RFC PATCH 3/5] mm/hugetlb: set large_rmappable on hugetlb and avoid =
deferred_list handling
> * [RFC PATCH 4/5] mm: only use struct page in compound_nr() and compoun=
d_order()
> * [RFC PATCH 5/5] mm: code separation for compound page and folio
>
> and found the following issue:
> WARNING in __folio_large_mapcount_sanity_checks
>
> Full report is available here:
> https://ci.syzbot.org/series/f64f0297-d388-4cfa-b3be-f05819d0ce34
>
> ***
>
> WARNING in __folio_large_mapcount_sanity_checks
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akp=
m/mm.git
> base:      0241748f8b68fc2bf637f4901b9d7ca660d177ca
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1=
~exp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/76dc5ea6-0ff5-410b-8b1f-72e5607=
a704e/config
> C repro:   https://ci.syzbot.org/findings/a308f1d6-69e2-4ebc-80a9-b51d9=
dc02851/c_repro
> syz repro: https://ci.syzbot.org/findings/a308f1d6-69e2-4ebc-80a9-b51d9=
dc02851/syz_repro
>
> ------------[ cut here ]------------
> diff > folio_large_nr_pages(folio)
> WARNING: ./include/linux/rmap.h:148 at __folio_large_mapcount_sanity_ch=
ecks+0x499/0x6b0 include/linux/rmap.h:148, CPU#1: syz.0.17/5988
> Modules linked in:
> CPU: 1 UID: 0 PID: 5988 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT=
(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-=
1.16.2-1 04/01/2014
> RIP: 0010:__folio_large_mapcount_sanity_checks+0x499/0x6b0 include/linu=
x/rmap.h:148
> Code: 5f 5d e9 4a 4e 64 09 cc e8 84 d8 aa ff 90 0f 0b 90 e9 82 fc ff ff=
 e8 76 d8 aa ff 90 0f 0b 90 e9 8f fc ff ff e8 68 d8 aa ff 90 <0f> 0b 90 e=
9 b8 fc ff ff e8 5a d8 aa ff 90 0f 0b 90 e9 f2 fc ff ff
> RSP: 0018:ffffc900040e72f8 EFLAGS: 00010293
> RAX: ffffffff8217c0f8 RBX: ffffea0006ef5c00 RCX: ffff888105fdba80
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
> RBP: 0000000000000001 R08: ffffea0006ef5c07 R09: 1ffffd4000ddeb80
> R10: dffffc0000000000 R11: fffff94000ddeb81 R12: 0000000000000001
> R13: 0000000000000000 R14: 1ffffd4000ddeb8f R15: ffffea0006ef5c78
> FS:  00005555867b3500(0000) GS:ffff8882a9923000(0000) knlGS:00000000000=
00000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00002000000000c0 CR3: 0000000103ab0000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  folio_add_return_large_mapcount include/linux/rmap.h:184 [inline]
>  __folio_add_rmap mm/rmap.c:1377 [inline]
>  __folio_add_file_rmap mm/rmap.c:1696 [inline]
>  folio_add_file_rmap_ptes+0x4c2/0xe60 mm/rmap.c:1722
>  insert_page_into_pte_locked+0x5ab/0x910 mm/memory.c:2378
>  insert_page+0x186/0x2d0 mm/memory.c:2398
>  packet_mmap+0x360/0x530 net/packet/af_packet.c:4622
>  vfs_mmap include/linux/fs.h:2053 [inline]
>  mmap_file mm/internal.h:167 [inline]
>  __mmap_new_file_vma mm/vma.c:2468 [inline]
>  __mmap_new_vma mm/vma.c:2532 [inline]
>  __mmap_region mm/vma.c:2759 [inline]
>  mmap_region+0x18fe/0x2240 mm/vma.c:2837
>  do_mmap+0xc39/0x10c0 mm/mmap.c:559
>  vm_mmap_pgoff+0x2c9/0x4f0 mm/util.c:581
>  ksys_mmap_pgoff+0x51e/0x760 mm/mmap.c:605
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f5d7399acb9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89=
 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f=
0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffe9f3eea78 EFLAGS: 00000246 ORIG_RAX: 0000000000000009
> RAX: ffffffffffffffda RBX: 00007f5d73c15fa0 RCX: 00007f5d7399acb9
> RDX: 0000000000000002 RSI: 0000000000030000 RDI: 0000200000000000
> RBP: 00007f5d73a08bf7 R08: 0000000000000003 R09: 0000000000000000
> R10: 0000000000000011 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f5d73c15fac R14: 00007f5d73c15fa0 R15: 00007f5d73c15fa0
>  </TASK>
>
>
> ***
>
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
>   Tested-by: syzbot@syzkaller.appspotmail.com
>
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The issue comes from alloc_one_pg_vec_page() in net/packet/af_packet.c.
It allocates a compound page with __GFP_COMP, but latter does vm_insert_p=
age()
in packet_mmap(), using it as a folio.

The fix below is a hack. We will need a get_free_folios() instead.
I will check all __GFP_COMP callers to find out which ones are using it
as a folio and which ones are using it as a compound page. I suspect
most are using it as a folio.


#syz test

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2194a6b3a062..90858d20dfbe 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5311,6 +5311,8 @@ unsigned long get_free_pages_noprof(gfp_t gfp_mask,=
 unsigned int order)
        page =3D alloc_pages_noprof(gfp_mask & ~__GFP_HIGHMEM, order);
        if (!page)
                return 0;
+       if (gfp_mask & __GFP_COMP)
+               return (unsigned long)folio_address(page_rmappable_folio(=
page));
        return (unsigned long) page_address(page);
 }
 EXPORT_SYMBOL(get_free_pages_noprof);

Best Regards,
Yan, Zi

