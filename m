Return-Path: <io-uring+bounces-12975-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OCa9INP71Wn4/gcAu9opvQ
	(envelope-from <io-uring+bounces-12975-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 08:55:15 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D21D53B7C79
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 08:55:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5575D3032F5E
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2026 06:54:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EEA4364937;
	Wed,  8 Apr 2026 06:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Ii7UkdVm"
X-Original-To: io-uring@vger.kernel.org
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012032.outbound.protection.outlook.com [52.101.48.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60E536495E;
	Wed,  8 Apr 2026 06:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775631263; cv=fail; b=ONnZbJNlFX1wRCaFBau1y9L66kqTGphVwmLtg+1If40BxvB/RjcJeD4rfC0f5StLmky+hthekw5k1aWNE/b4dffnD5REv+PiVrrYS+bgOnigQMbdbo96CNHHr6Y4V80xP4gsUGZWodd6HGhO5GmDIgQXLLVEQALDe9s4XUMW+OA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775631263; c=relaxed/simple;
	bh=Fc0PkfxjbOmxusn9lg48Yk29/IhMhLdVSlcHiNlncNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=d5UUeIZSrobZLgguFYQ2OHpjwFx9oqe/2YxQbbJG4vd12hpu+KWlBjd6MAzBA5loBcuAjXe0xIXLZ1O9rVplOVF/ZadTLYmiSrJMdLaOPMJPw9ATrek2zyReCF108qyp4A9EZOUdGkLU0Q3qj3P0QaFySuwfvF6HVgfAX4lLqbs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Ii7UkdVm; arc=fail smtp.client-ip=52.101.48.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ax7GiawnNWWMT8fWwzLkX6EOgZiPkZKTb5iYECgs8EjHrp69FrSYOD1SUqQJkbfUtDzY/YkEJ6TiAAFgMwrYI7fZkbZmCqMCDZAYcIVezqzYL/zmex4DcTlNz0N+rBPlkqlYasFXMMMO9BpeYYAUZ2ed4Xn+E31vET3kDGHd78aGv0E9iPTREa45bpUmJXHmeQAhIdECR25QCTLsefY5ZT0CweNfxC/n2Xx+t3deV0J8ESAutThtIWONHkZtKNxFV7YzAYEOxfIZ9awn6b2nMSPlBcmTJBbQuelZHEdjH/WGPZ9rUkDkf9j4FOi8c0awnOWT3tz9kGOyYx+dRNZgjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hV/2srNa4z7lJxx79cn3ybAgn7icbGz7Xw873E7u0z8=;
 b=S+wa1iH0q6MNx7EzoToRJVfxmMUpweCu34Tax4YqWtkxJkxQhCQzhpJtX2XjgcvVE41uKa+rzDP9B+70N1Kbn8a11zKXqA5YOA1bY9e0UVH9+wv+t1IyLKe5pYUbyCK8DOYHKJh7YJEEXa1zRTm8dV/uUywGcNXnVpaibf1Np861mhE0WEW5N1bHR+hN5cc2JNerm84kO/uHto25R6yhNqFYjTJSOh1n/e3mt2R4MOfWLglX1My0SsZHLKn5Ks05sdUnxcRUONi2WTyvMbxx8jJyruWRqXhI38vlIAO+CfyFgcdb7/v5Yz/R1VxJsxkXEiYA+ig8TGq0mmcp+LScDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hV/2srNa4z7lJxx79cn3ybAgn7icbGz7Xw873E7u0z8=;
 b=Ii7UkdVmJE+beRAN8NIao+KjUokDNgfvE1lCa5d8BXH27VXDuaffS5m41XtdR0TSgoDwJMiiQAE3bpTZRddsqhtWsKksCnTjhBCoGsM3WWqdBEKZX4DUY83bs393o/ycvRaFTf4w52KT4XLoBS5QM8bvoFk/PCxXIf2YONgBZyg8ddywqP4Edc9zZDo/fnxLLTltqj8inin2H8T2yJEtzyzG1oIwK8Or7fYMzJufMs4D88Oq+sxtMTuklTEVeeJCNZlFRcMpQXZKt6JGTXfcDmDnfkQL6I2zHnaNykzcizKYOcHq5Qj1EyQEYn73S2SIMSSQFDLdQ1dnuKgYeFgjkg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHXPR12MB999244.namprd12.prod.outlook.com
 (2603:10b6:610:2fc::17) by LV3PR12MB9412.namprd12.prod.outlook.com
 (2603:10b6:408:211::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.17; Wed, 8 Apr
 2026 06:54:19 +0000
Received: from CHXPR12MB999244.namprd12.prod.outlook.com
 ([fe80::168f:599c:f74d:7688]) by CHXPR12MB999244.namprd12.prod.outlook.com
 ([fe80::168f:599c:f74d:7688%5]) with mapi id 15.20.9769.018; Wed, 8 Apr 2026
 06:54:19 +0000
From: KobaK <kobak@nvidia.com>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Keith Busch <kbusch@kernel.org>,
	Ming Lei <ming.lei@redhat.com>,
	io-uring@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Koba Ko <kobak@nvidia.com>
Subject: [PATCH 1/3] io_uring: fix pinned pages and pages array leak in io_region_pin_pages()
Date: Wed,  8 Apr 2026 14:54:06 +0800
Message-ID: <20260408065408.2017967-2-kobak@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260408065408.2017967-1-kobak@nvidia.com>
References: <20260408065408.2017967-1-kobak@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TY4PR01CA0026.jpnprd01.prod.outlook.com
 (2603:1096:405:2bf::12) To CHXPR12MB999244.namprd12.prod.outlook.com
 (2603:10b6:610:2fc::17)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHXPR12MB999244:EE_|LV3PR12MB9412:EE_
X-MS-Office365-Filtering-Correlation-Id: 239d698f-268c-4d18-aeab-08de953ba852
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	W98h8IbKcKhMFZPyrhKKHv6HTG7aXW0R5iYMVk3bp4e0+Q8HnDWhkF3i9taJVY5Jv3p6RMoA8Fl+Q1t5bIGWk/f1cfEby1wC5fJUd8RJy4iWxv3v2RXRHox0VBGM8en/R3G92SGf5uaVuOHwUECq19ffUISW7YMSESe/cPet+rb0HU9OyUn4yEZs7BOo/Iy6p4/YcU0HlYDjFFSWlqoARUaB5UDhumeZd5E38Y8eMXzFCclx2emvbh2Iv0UJQehZvo/DeOzymu0jG+Q0SDg2Gf6Qsz04JQJ4Bmw6WZDyNNaDKO0/8NO4sXS9JAELhI+3TNJAM/EcgUyG3Xrq314jSDWaOxQkVNFrtvl8LFDnPMEpFuG+/lBTx3R8zxXL6LeKNXwoZpMy8wm1C6pQClcYrY6z6RFLLHBhrIqbjx+WnCMVDrmrRAzbE2s8nIHRvjDYfeMWxGih424OtNJPcXfnSLtedhWAOddZrZ8Y4082y3BYuCJzlxIceYkZrm8CEkeeq/+zRb1/eJf/Y1hkbHhxQ+dt03Oxih56cFPwVEsjVVd42tBAIojpqS6AHRbs6Dpkr/W7HxftxmIUemMyXlSfliEK8XMqPKQLYIVY5i3ktRlB8GomyPmDxBDckWc6N1jy9ApXLBMVTDvZAA+6UcaCeWvw1tcO+uAlvRNXEWOFjGWUtDiEAzAA9miFP136EysgjLaQTj6tzFfzMYWJdPh9QPnWMSQO4Z9FtlqkccOdKHc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHXPR12MB999244.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SmFYZVFxTWtkYm1DUTdnQmxRbzVOTkgySlZCUlhyNFcrK3ZKTnMrMzZ0R3VJ?=
 =?utf-8?B?aE9kQ1E2THFOU3NLMFY2b0wvVUxNMkR4VHdqRnVacnBtVktuUWdEY0o1K3E2?=
 =?utf-8?B?cnNtQTJoNE84bGNJRyt6djkvY3lBbGRTZTZWVjhJeGhvQjNVa3VGdjNHYmJh?=
 =?utf-8?B?WVNmMUFXRmwvc3phSDF4cW5vQ2x6U2hUMVdyYVBJYk5RNFVPOVBCSGdITDVD?=
 =?utf-8?B?TjlIK2dOdXQwQnFWbDhCNGNTQjBnZE5XbUlHSXk1Vmx6cndCWHRwNDg3a1JE?=
 =?utf-8?B?ek11ZWRyNitneFVMZmZuLy8vRG1wN2xINCttUExlMWY5eTJWTkFzdVA4QTVn?=
 =?utf-8?B?Yko1ckQ5WXVCbmN5YURCMmJBM1EyWnZxOHRJbzBOOUd6QU0yM2lzbWU2YWls?=
 =?utf-8?B?dUJkVnZqRWkvMzhsOWdpZXVUOUhEcXdrc3ZKS1lTVjZSdEo2U2Y1dmxRWG1R?=
 =?utf-8?B?SEZKdmJyTUd5djZLS0o2cytFY3dRY3VJVGFqQzJEV2Yra2daSDRhbzRtd0Q4?=
 =?utf-8?B?THUwS2ROWWVnRURLSUpYOXVhTVRIalN5SVN0SVl4TC9hbC83WkRVZW0xUXZm?=
 =?utf-8?B?MEFobHNhcnM4VGJCUVZlRVord2xLd0FEUTBIUjlJWlpPQ08wZG9TMlJQOXdj?=
 =?utf-8?B?UnlMM0NFSC9nOUVUdEJpSUw4U3U3OFo0dkJNTm5FTmdYbnpBVUgzQjlQL0da?=
 =?utf-8?B?TWNSRitlV0lza3YxaWN0ZTJGSVRnUUNXaklSYjlOM2JIUTZkKyt0T2FvK25j?=
 =?utf-8?B?Z0Z6ZWdSbzdkUkRFY2lqVndhNm51c1dIUHdKWENWVnpJOXBPUVpZd1NqMzcw?=
 =?utf-8?B?RzVyWmZvdVFBdUxzZERGZGVESi9tQ2IxeHF5Y0g5dEw5Uk9jb1Y2TnlRbnBq?=
 =?utf-8?B?M3RrUlArNUtJYlVVcjFMd25icjFXanMzcUdoMTVrc0RxQ0d6bDdYaHlHQURU?=
 =?utf-8?B?aUVpOW0vRHJ6WEp3a01ZNGJQSHFjbWtZeXpFZXdaWTA0NmZ3cjBFb040ZWk4?=
 =?utf-8?B?NzkyRWZvMTM5cFoyL2JmK2J3RXB0b0VZK1F1bk1zYWUraDgyS3FzeENjSkNm?=
 =?utf-8?B?UzhsdzVaNEwzaHJNQWdQN3hPNnFlaGtOSzRnSnRrQi8wcFllMmFhcytaV1p4?=
 =?utf-8?B?S3YwOTFiSFVWcHpZVGRnWTVWdC9pVSt6L2xwS0t3M3ZOR1JyRUtCeVJOcmYr?=
 =?utf-8?B?eHdTeFYxZjByZzd5TzM2VEZZTTQvUzFHa3QrdWczcjdWcGo2WXFMMnpqVlpa?=
 =?utf-8?B?U2wzdzdwZUNTU3pUSk9tdXFEOHp3VHNmL0JxVDIwQmY2Q3lNOCt5Y0l6RSsz?=
 =?utf-8?B?VEpkUW1acm5kVG9kcFVnbXJKTjBuMVJ5M3FGZ05JM3JpOFFkV0hJTVNTSmxN?=
 =?utf-8?B?OUJHb2dNWUtUSWhkUVhaQWxhU25xY1VnTXVoakJDZzdWYitlR2U3ZDJISm42?=
 =?utf-8?B?WU1jazdreTQ0eXVZUFU4MVIzbUhLMDMveC9BYy9xOFQrSFVkNU9icm5IRCs4?=
 =?utf-8?B?TjRzZmRhUG9wNHowVUluK0hWUytPQ0gyWHd3MzROV2o2UlNHVE5yU1hUUkMw?=
 =?utf-8?B?TjlJUXlxUFRnc0JwSGV4Z2hENk1GSm9VdHVReXQvREZyZW04ckEzU1BRTGM0?=
 =?utf-8?B?WlZ3RGFOMGhhSzVUQ3hUQ0hydUFWK1lsRzdITW9GRzE1VEpad0I3ZzBQeVBS?=
 =?utf-8?B?MjR1eWRqTy9sU1lCNHpldmVWeTc4LzIxTGpwTEV4MjhIQlhVcXNDY1d4VTNF?=
 =?utf-8?B?cWVXWW9FdFhvRmVHeXNnTmVCc29hNXBXN2pNQU1SZTIrYS9wRmZYL0l5NjU0?=
 =?utf-8?B?WEZSSUI4RjV0aDBsR25UY0V1M1A4eUNwdUNud1ErNnNtN1BQZ2RyaUVTQ0la?=
 =?utf-8?B?WkRXdjFjbTZTY0RaQU0vYjBTU1AxSk44VDJSQjFzNEVNSXVlVTdpK0tTRjF1?=
 =?utf-8?B?WXI4NFE0a1lqTkdCTStuS0pyMTQ0L3VVMUVhZURpajRpaE9ueU5lNzVLWWE1?=
 =?utf-8?B?aHR1S29lWTZSUGNvR3hWK1dFWGhnZjZaVDRUVlI1bkFlS0RkNE40ME1RRzNP?=
 =?utf-8?B?MnVIdUlXVGRIWUgyMFBvMUVsdXdvWnEyeEhGbWw1OHQrS0xLdFpjS1FXUWho?=
 =?utf-8?B?SWJFNDhoYnFROUdXSlNwYjBodHlvNSsrd2I2Y2ZNSVRmb1pHamlTSW12cnho?=
 =?utf-8?B?bHZZOGdiV0cyY1hqOWpabkRVVVRCMEhjcDZ2WHpoYW10V3FBaEg0V2NGZU9S?=
 =?utf-8?B?dUpYZGtOMHdwOFl0ZDE4OEJPQTJib2VoZG83c21QVlVkbVlqK2U3U1F5TGFE?=
 =?utf-8?B?N2pzMXVLS2RVSTg0dWJtR0J5MndlZ2JaaERFRFk3bGFoZDZna2s4QT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 239d698f-268c-4d18-aeab-08de953ba852
X-MS-Exchange-CrossTenant-AuthSource: CHXPR12MB999244.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2026 06:54:19.3331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2WNcIgjMxczOxt9jOyUdXpFpCbdStLHtBdFnC7gcQgpiqkdVUicjocTmvJxslnbPta7ZsZxMndohipSAo167FA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9412
X-Spamd-Result: default: False [2.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[kernel.dk,gmail.com];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12975-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kobak@nvidia.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[8];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[Nvidia.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,nvidia.com:email,nvidia.com:mid]
X-Rspamd-Queue-Id: D21D53B7C79
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: Koba Ko <kobak@nvidia.com>

When io_pin_pages() succeeds but the subsequent nr_pages sanity check
fires (WARN_ON_ONCE), the function returns -EFAULT without unpinning the
user pages or freeing the kvmalloc'd pages array. The caller's cleanup
via io_free_region() won't help either, because mr->pages was never
assigned — so the entire cleanup block is skipped.

Add unpin_user_pages() and kvfree() before the error return to prevent
the leak.

Fixes: a90558b36ccee ("io_uring/memmap: helper for pinning region pages")
Signed-off-by: Koba Ko <kobak@nvidia.com>
---
 io_uring/memmap.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index e6958968975a8..9f0d3750ce3bc 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -141,8 +141,11 @@ static int io_region_pin_pages(struct io_mapped_region *mr,
 	pages = io_pin_pages(reg->user_addr, size, &nr_pages);
 	if (IS_ERR(pages))
 		return PTR_ERR(pages);
-	if (WARN_ON_ONCE(nr_pages != mr->nr_pages))
+	if (WARN_ON_ONCE(nr_pages != mr->nr_pages)) {
+		unpin_user_pages(pages, nr_pages);
+		kvfree(pages);
 		return -EFAULT;
+	}
 
 	mr->pages = pages;
 	mr->flags |= IO_REGION_F_USER_PROVIDED;
-- 
2.43.0


