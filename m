Return-Path: <io-uring+bounces-13810-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id CTcsH6P3OGr0kgcAu9opvQ
	(envelope-from <io-uring+bounces-13810-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 22 Jun 2026 10:51:47 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CBE346ADEC1
	for <lists+io-uring@lfdr.de>; Mon, 22 Jun 2026 10:51:46 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Oj464p5y;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13810-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13810-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=reject ("cv is fail on i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 20AF03005D29
	for <lists+io-uring@lfdr.de>; Mon, 22 Jun 2026 08:51:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E0D03932D0;
	Mon, 22 Jun 2026 08:51:32 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010022.outbound.protection.outlook.com [52.101.85.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6163921F6;
	Mon, 22 Jun 2026 08:51:29 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782118292; cv=fail; b=hHhUYhGHGMRkQFI1Xoqox1PxYcawQS39mkuR+AtrwqcVH58zhILpwtvlyvoP6zMBLsKCtzex1s/OzOgjfbz5/JC9e0/HskSMvBmwujlNpM8gMBjogNPfHD57yVjK+6hta8PsmBdfIgfBXVgK556Q2q7JDIAadr0cY0mr4oyRwYc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782118292; c=relaxed/simple;
	bh=5nsxj7zwfySyJPiUSPAYBBuCFUlLNIcFsTKvpV2+Lrc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lPSJGQbO2jZWAnjWqjHXbwRrUvnXcRYFam603MU/jGpyv3X8W6/6apZfRXwZpZfuXwuC5yM39+oNsAZSdOrsnhn4WKqINLiOoAmBlwGeU7gY2sdQCN28RfDf6T+/sL2VV7SvFAMneysIGw6a+6YqYBC3Ipxx6qeHoBu2b7ceOfM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Oj464p5y; arc=fail smtp.client-ip=52.101.85.22
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nwQEh21o2VSckybAsizVeLRP7aTQEFc4SNJ0W9rMBBl7zoo8WGU8Mc/X0VHZvDlOeUm8vF41TVCHv1zvIWYDnaDUneW/1gBrbztOfzufGEaqS3BE2IjU9VOKDAFNUxLIJAzJu8bR0hODDMG7+BBipKPx4k4TNZWBVZV2X9/zYZx+hU8+d+MHc9Zl4OfHM4/YvOkqJHtBbW3KoiD3Ei4h/9i542in/JhC/S32kgZ+nMScNTtScKx1142XpMQdnioZ2EEj3wXGBQVcLbI0P78AfMPJEtx7vknE/8Vhidz5f0DTraRsaZPFx2HSmEAD8FxRiJkcowwTYcqIiC1IcmTElw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N1CTmu+6LGlgB/BKD81AcsdoGTuKCbZDkKyItYzOVJo=;
 b=v2BY7tj0h5oxjj5yjsfFWtN6tFLH1gBgks+WFLJ8PSOPB7aoNyAVL0vDPzKTPwTOrGmnSA7hQkXhi3bwmVz8vho6Sl8SMT3wr+E0jWH+MCC+yBqfbtDGMYbpdmEudGgvNcKe8wV+zzL5dGk+PzpFfNcTLxG71TbWPjnG+rUcJzlgQQXNn5zrlkRJzozVkLPbZcQwUq5yWwoQ9rlLYR2bxt64rKBWZg757AbAoP3JQbsp+9M+yU+avHJgkPUIpIUYzIMBfmAyfV6vCu5Jsntk6q8FjvoqJiaMMivEeQIQLtE4mjz3kF9snAu+26NgmnaEr3QD8xS9+ouPCxblF/ZSnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N1CTmu+6LGlgB/BKD81AcsdoGTuKCbZDkKyItYzOVJo=;
 b=Oj464p5yFx5WkTQKYW8C8t7LwqSVyT6K0+Eerw7lOm1sv/TNiWcQQ12aVmFPOGW8RHuWPAaEUnGLM0cm98TZ162SScfM2ZUYlKAxuSj/Opwr+nDe74rJojsk35fGlijgwwCpXUr1RSNLZCtfh/zo5Xq68aZg8LGT0MwX4rNmDvQ=
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by SA0PR12MB4365.namprd12.prod.outlook.com (2603:10b6:806:96::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.19; Mon, 22 Jun
 2026 08:51:25 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%5]) with mapi id 15.21.0113.015; Mon, 22 Jun 2026
 08:51:25 +0000
Message-ID: <4f55fc00-e83f-43a3-9dd3-739c75534b14@amd.com>
Date: Mon, 22 Jun 2026 10:51:10 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/7] list: Add mutable iterator variants
To: Kaitao Cheng <kaitao.cheng@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Tejun Heo <tj@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Paul Moore <paul@paul-moore.com>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>
Cc: David Howells <dhowells@redhat.com>,
 Simona Vetter <simona.vetter@ffwll.ch>, Randy Dunlap
 <rdunlap@infradead.org>, Luca Ceresoli <luca.ceresoli@bootlin.com>,
 Philipp Stanner <phasta@kernel.org>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 linux-ntfs-dev@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, audit@vger.kernel.org, bpf@vger.kernel.org,
 netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 kexec@lists.infradead.org, live-patching@vger.kernel.org,
 linux-modules@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-pm@vger.kernel.org, rcu@vger.kernel.org, sched-ext@lists.linux.dev,
 linux-mm@kvack.org, virtualization@lists.linux.dev, damon@lists.linux.dev,
 llvm@lists.linux.dev, Kaitao Cheng <chengkaitao@kylinos.cn>
References: <20260622040533.29824-1-kaitao.cheng@linux.dev>
 <20260622040533.29824-2-kaitao.cheng@linux.dev>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20260622040533.29824-2-kaitao.cheng@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FRYP281CA0001.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::11)
 To PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|SA0PR12MB4365:EE_
X-MS-Office365-Filtering-Correlation-Id: f5843db8-2292-4c6f-6373-08ded03b7106
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|18002099003|22082099003|921020|4143699003|6133799003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	UrYmGbn8maWnHNc5D1qlVh+jrcQmrgStTdJf4BpRRFgI09yY0t5o3kI+QFue1RhDqmkyHpxlbNIsUyVgifZBOfhgqCKTMcjX995MBXWc20TEezTy5dAGaJra4KOqCesvs8RpPueT0jpnFEwuvTeS3ivGUM75dL6izUy8aZ5IA9mkAlRyUxcdmVBWoVuN3m3FQa1T1jMdGsfOLVZIi5pGVsHI8Vg00YPKD0qr5kXFjd/sNeinWHYCNkwR1HIcyfjeFoWuBJ0xuPLSv0ZQMLm4nUaJ6/fCgDfkZysVJyYCjdU7AXJ/tAW0o8wmQbWA4/AEwiC0MmyWuVg8HaSTBShQX4TNauMFcLGutmZSSNW077PQwIcEUnKRoW/FA0mQ7TkpSflOuOgzVUJFfXfRiduI5+807QLgLHM09PTDE2r9q9MOVMatD74eT2o1BBGRwrLLJolVQhYpkznZ9O6QMSF3KFOuL8uEA/nRzKJz9LorWYPkk5Z++5e8KmAoMQvJBwwh7V1k7jSq6csJb7X0EKS7JAjrpUsCe6Kd73jW5zEdBErveu3sVf1+ktIcyuDFF18B7xKsBEIP7CF6PAwdRDJuc8lNstT6A14JkeH+9nJwJTY7BI2jnUP7ZE282Y7U9nkglCXQ59yNkgS/WDdKg6jk3F4gDabH999DqevpnZFnlGpX921G6ifWu98iLl/S02N/shf0Me8MgGWkt8E+cGwGRA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(18002099003)(22082099003)(921020)(4143699003)(6133799003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?azFEQUF2QnZLcC9OTzB6SkdoWk9zdXBGTHNqdVlzTWNaVWVTRHN1ZDVQQUpQ?=
 =?utf-8?B?UFdNTUhKZWxsd2hFTitYRmw2aTYvZW5sc08vZWdYeDdaaXdLdzBpWkZuUUFL?=
 =?utf-8?B?MDZWTVE3dzExbzNMQnBlTEt3RVN0Nk1aTjJEdlQzamhvRFU2SWgwVGVoUUNt?=
 =?utf-8?B?ZjJhQVBlVGZ2WkRtVHh6SzZHbHlPNUtJZEJKNDJTT3F1YkVZeGpCNjVmenVr?=
 =?utf-8?B?WGpXSW0rLzM1TThvQjBoRVBJNDlIQUsyK1M0TmRFNkphQWJCVzMrRWxGQnoz?=
 =?utf-8?B?VmptY1F4SXZkdTBrVjhMZmp4SmdVVkJKT09vQkVIOU91bXlZeEliZmFNYVdh?=
 =?utf-8?B?eVViOE5SVHdPVmVqaGdMSGs3MjMydVBmR3A1RFloL2llSmV1SFJIVERWQ1F3?=
 =?utf-8?B?RC84R2kyRHkwVjFzblY1RUZHRjN3aFhISi91VUQ4Uy9lc1RTMkRIK2JjR0VC?=
 =?utf-8?B?SDE0eSt3R2VBRm1TN09RdzcrTzB3by80Qy9DcG9acWZnRDFJanpObWh3NHlr?=
 =?utf-8?B?aGU5WVdCMUhNeEwreU5HNE8zQW5iZmltR2Jvd2FrYmN5M1JabExEMGtTby9U?=
 =?utf-8?B?TjJZaXpObGJxWmNrTWxYWGdZdUE1bHRLMVdCbUNCelR4MjI3OWJsVVp3aFBK?=
 =?utf-8?B?NzUvUU9Ia2NTb3N5VFZveWFPZVR2bkFSeUgxb3NzS0ZCeEdHRTRiMFJIN2xI?=
 =?utf-8?B?bjJyMFQrYTZFR3N0YlpXRE9VY3J4NVF3d0FLNnlITTZIcGk2ZnhFTDlzL3RO?=
 =?utf-8?B?QTBROFpwRjUwMTZFdW5QNW1VYmh0VUxoZi9LMnNtNTV2QmtWSXlqT3hKMlZS?=
 =?utf-8?B?UzY4aW51Q0kyMWZkaGY5MjB1VzdLTGw0MFVaYnZOcHVHKzFwT09xSXdqVU1U?=
 =?utf-8?B?R0dJWW5jR0RFc1JIMkVkM3lkS0JlanFUSWVwblQyTlZVV1BjUEVrbThjUXlY?=
 =?utf-8?B?ZHN6TjlrbFJrRDc2MklweWoyeFdFdmNVemRMejRQK0NINFlycFBnMVBzSmpM?=
 =?utf-8?B?L0RiNU1PZXloakd6VVVwVXNwTzA0aHZuMUNXOUpJQmlPakkrQWpTTVR4QTVC?=
 =?utf-8?B?YUk5VGVBM2d6ejdibE9YVjE3UFRVWFBXc09XeXVBMUQvYmE1Y0NXQ01VRWxI?=
 =?utf-8?B?QkFpcTQvTnpOMGZ1a3cxeFdhOSttME1LTVplUHc5RWJBWG4yREp5SmRUc0d4?=
 =?utf-8?B?ZWh6V3MxNXBWK0pWUFZ3b2hyazdOa2xvSEUrWnRsZjVWMHVQVGJ1WEhNeGNy?=
 =?utf-8?B?L01XSFhReWk5QmNFRTNLWjRmS1o1Rm9qMzNPenpGNHdYZS9oNjlha2g3MERW?=
 =?utf-8?B?cHc4cnI4QUpvN1FoSzZCQWJMNkVTWU9MU2hBcGZEM0hvMHM0cHc2RGtkQmVS?=
 =?utf-8?B?ajIxeHhKL0ZSMWJxN2YwTGdjVkJyM0J6eDBIZGhJTDVVejJrTnMyUlFmamI2?=
 =?utf-8?B?aWJUMm5QN0c1d1V1bm1oSCt6Mi82ZkZGcUx6aW85MGpVcDVUQkpHaTZqNFVW?=
 =?utf-8?B?cVBNYVVMNzd1T25kUWVhNWczTGxhV0hRZSswYjRFdVZSRlRRMDJkcElKclJD?=
 =?utf-8?B?bWdJQ00vdVFxbXZWYUhVTURmNUhTSVhONWRUbjFUaHdTd21UcDk0Nlpna0Z0?=
 =?utf-8?B?WEs5VlNvUC8vbjBFNTltMDVqNEZaY2tpRmcybmZvL20rRWtJRUZXTmVoRHVk?=
 =?utf-8?B?dGwzYVVoUDViSkxPeFJOR28wQ3N1YXNtdHlDTGtwZk5xbnFBTTFWaGtybWxM?=
 =?utf-8?B?REJnTTBFTnRydjhodnkwd3U4Ty9tdStqMDdjbUpIMjVQU0ZNUmIvaWN1d1pj?=
 =?utf-8?B?Q0JubWNkNUtPTExteUtRUUdUalpydUJDMXZHa3hMTERhWFFCZ0I3bTk4dnFV?=
 =?utf-8?B?YklhOXZ6MEtaUnhwUUMrOGtMOW1EWjBMZUl4K01YamZlZkFoOG8yNStHMERt?=
 =?utf-8?B?NWordldKV3lBTWVmVW1TWGtvRzh6YjhpZzV3L3h5aTJRMVB3YTdkWi9QZTVS?=
 =?utf-8?B?UHZaMUt2UUhsYk9XcEJmTE9neDFJRHpiSlhHR3dhWjd0SWJLUS83bVhyMEl6?=
 =?utf-8?B?U0RweUtUNHRYNis4TFhYNU94U1A0S2JabmIyQ29qWU5tUk55M1FadC9ZRU9T?=
 =?utf-8?B?NHlxM1E4aDF2RXYzd3ltOHlBeEVFUHp1REF2cUovemZ1aFJyVHFtdFE4WkR5?=
 =?utf-8?B?UGxUZ05XQWFsVE1FNEptYXV6akl3K0JEVU5EYVN2eXAwUEFtMjJ5RUdSd1hN?=
 =?utf-8?B?eVFRTzZNOHlHayt3ZGhXbEw3ZWl5SER6SlpOc2d1WG1IcVRhRzJCZEY2cmUw?=
 =?utf-8?Q?I/sExwDfVHkzWno0CT?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5843db8-2292-4c6f-6373-08ded03b7106
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2026 08:51:25.3341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MyQthcf0k8t8V1QPq+PMD5vm3w+cwazXpSklvIukCqaryCgt6VPENiHsqHAftsLd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4365
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13810-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER(0.00)[christian.koenig@amd.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS(0.00)[m:kaitao.cheng@linux.dev,m:akpm@linux-foundation.org,m:david@kernel.org,m:axboe@kernel.dk,m:tj@kernel.org,m:viro@zeniv.linux.org.uk,m:brauner@kernel.org,m:ast@kernel.org,m:daniel@iogearbox.net,m:andrii@kernel.org,m:hannes@cmpxchg.org,m:peterz@infradead.org,m:mingo@redhat.com,m:acme@kernel.org,m:namhyung@kernel.org,m:tglx@kernel.org,m:juri.lelli@redhat.com,m:vincent.guittot@linaro.org,m:paul@paul-moore.com,m:andriy.shevchenko@linux.intel.com,m:paulmck@kernel.org,m:shakeel.butt@linux.dev,m:dhowells@redhat.com,m:simona.vetter@ffwll.ch,m:rdunlap@infradead.org,m:luca.ceresoli@bootlin.com,m:phasta@kernel.org,m:linux-block@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:cgroups@vger.kernel.org,m:linux-ntfs-dev@lists.sourceforge.net,m:linux-fsdevel@vger.kernel.org,m:io-uring@vger.kernel.org,m:audit@vger.kernel.org,m:bpf@vger.kernel.org,m:netdev@vger.kernel.org,m:dri-devel@lists.freedesktop.org,m:linux-perf-users@vger.kernel.org,m:linux-trace-kernel@vger.kernel.org,m
 :kexec@lists.infradead.org,m:live-patching@vger.kernel.org,m:linux-modules@vger.kernel.org,m:linux-crypto@vger.kernel.org,m:linux-pm@vger.kernel.org,m:rcu@vger.kernel.org,m:sched-ext@lists.linux.dev,m:linux-mm@kvack.org,m:virtualization@lists.linux.dev,m:damon@lists.linux.dev,m:llvm@lists.linux.dev,m:chengkaitao@kylinos.cn,s:lists@lfdr.de];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[christian.koenig@amd.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_GT_50(0.00)[51];
	MID_RHS_MATCH_FROM(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kylinos.cn:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,vger.kernel.org:from_smtp,amd.com:dkim,amd.com:mid,amd.com:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: CBE346ADEC1

On 6/22/26 06:05, Kaitao Cheng wrote:
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> The list_for_each*_safe() helpers are used when the loop body may
> remove the current entry.  Their API exposes the temporary cursor at
> every call site, even though most users only need it for the iterator
> implementation and never reference it in the loop body.
> 
> Add *_mutable() variants for list and hlist iteration.  The new helpers
> support both forms: callers may keep passing an explicit temporary cursor
> when they need to inspect or reset it, or omit it and let the helper use
> a unique internal cursor.

That sounds like a bad idea to me. The macro should really be doing one job and that as best as it can.

> This makes call sites that only mutate the list through the current entry
> less noisy, while keeping the existing *_safe() helpers available for
> compatibility.

This can be perfectly used for code that which really needs the separate variable for the next entry.

Regards,
Christian.


> 
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
> ---
>  include/linux/list.h | 269 +++++++++++++++++++++++++++++++++++++------
>  1 file changed, 231 insertions(+), 38 deletions(-)
> 
> diff --git a/include/linux/list.h b/include/linux/list.h
> index 09d979976b3b..1081def7cea9 100644
> --- a/include/linux/list.h
> +++ b/include/linux/list.h
> @@ -7,6 +7,7 @@
>  #include <linux/stddef.h>
>  #include <linux/poison.h>
>  #include <linux/const.h>
> +#include <linux/args.h>
>  
>  #include <asm/barrier.h>
>  
> @@ -763,28 +764,72 @@ static inline void list_splice_tail_init(struct list_head *list,
>  #define list_for_each_prev(pos, head) \
>  	for (pos = (head)->prev; !list_is_head(pos, (head)); pos = pos->prev)
>  
> -/**
> - * list_for_each_safe - iterate over a list safe against removal of list entry
> - * @pos:	the &struct list_head to use as a loop cursor.
> - * @n:		another &struct list_head to use as temporary storage
> - * @head:	the head for your list.
> +/*
> + * list_for_each_safe is an old interface, use list_for_each_mutable instead.
>   */
>  #define list_for_each_safe(pos, n, head) \
>  	for (pos = (head)->next, n = pos->next; \
>  	     !list_is_head(pos, (head)); \
>  	     pos = n, n = pos->next)
>  
> +#define __list_for_each_mutable_internal(pos, tmp, head)		\
> +	for (typeof(pos) tmp = (pos = (head)->next)->next;		\
> +	     !list_is_head(pos, (head));				\
> +	     pos = tmp, tmp = pos->next)
> +
> +#define __list_for_each_mutable1(pos, head)				\
> +	__list_for_each_mutable_internal(pos, __UNIQUE_ID(next), head)
> +
> +#define __list_for_each_mutable2(pos, next, head)			\
> +	list_for_each_safe(pos, next, head)
> +
>  /**
> - * list_for_each_prev_safe - iterate over a list backwards safe against removal of list entry
> + * list_for_each_mutable - iterate over a list safe against entry removal
>   * @pos:	the &struct list_head to use as a loop cursor.
> - * @n:		another &struct list_head to use as temporary storage
> - * @head:	the head for your list.
> + * @...:	either (head) or (next, head)
> + *
> + * next:	another &struct list_head to use as optional temporary storage.
> + *		The temporary cursor is internal unless explicitly supplied by
> + *		the caller.
> + * head:	the head for your list.
> + */
> +#define list_for_each_mutable(pos, ...)					\
> +	CONCATENATE(__list_for_each_mutable, COUNT_ARGS(__VA_ARGS__))	\
> +		(pos, __VA_ARGS__)
> +
> +/*
> + * list_for_each_prev_safe is an old interface, use list_for_each_prev_mutable instead.
>   */
>  #define list_for_each_prev_safe(pos, n, head) \
>  	for (pos = (head)->prev, n = pos->prev; \
>  	     !list_is_head(pos, (head)); \
>  	     pos = n, n = pos->prev)
>  
> +#define __list_for_each_prev_mutable_internal(pos, tmp, head)		\
> +	for (typeof(pos) tmp = (pos = (head)->prev)->prev;		\
> +	     !list_is_head(pos, (head));				\
> +	     pos = tmp, tmp = pos->prev)
> +
> +#define __list_for_each_prev_mutable1(pos, head)			\
> +	__list_for_each_prev_mutable_internal(pos, __UNIQUE_ID(prev), head)
> +
> +#define __list_for_each_prev_mutable2(pos, prev, head)			\
> +	list_for_each_prev_safe(pos, prev, head)
> +
> +/**
> + * list_for_each_prev_mutable - iterate over a list backwards safe against entry removal
> + * @pos:	the &struct list_head to use as a loop cursor.
> + * @...:	either (head) or (prev, head)
> + *
> + * prev:	another &struct list_head to use as optional temporary storage.
> + *		The temporary cursor is internal unless explicitly supplied by
> + *		the caller.
> + * head:	the head for your list.
> + */
> +#define list_for_each_prev_mutable(pos, ...)				\
> +	CONCATENATE(__list_for_each_prev_mutable, COUNT_ARGS(__VA_ARGS__)) \
> +		(pos, __VA_ARGS__)
> +
>  /**
>   * list_count_nodes - count nodes in the list
>   * @head:	the head for your list.
> @@ -895,12 +940,8 @@ static inline size_t list_count_nodes(struct list_head *head)
>  	for (; !list_entry_is_head(pos, head, member);			\
>  	     pos = list_prev_entry(pos, member))
>  
> -/**
> - * list_for_each_entry_safe - iterate over list of given type safe against removal of list entry
> - * @pos:	the type * to use as a loop cursor.
> - * @n:		another type * to use as temporary storage
> - * @head:	the head for your list.
> - * @member:	the name of the list_head within the struct.
> +/*
> + * list_for_each_entry_safe is an old interface, use list_for_each_entry_mutable instead.
>   */
>  #define list_for_each_entry_safe(pos, n, head, member)			\
>  	for (pos = list_first_entry(head, typeof(*pos), member),	\
> @@ -908,15 +949,36 @@ static inline size_t list_count_nodes(struct list_head *head)
>  	     !list_entry_is_head(pos, head, member); 			\
>  	     pos = n, n = list_next_entry(n, member))
>  
> +#define __list_for_each_entry_mutable_internal(pos, tmp, head, member)	\
> +	for (typeof(pos) tmp = list_next_entry(pos =			\
> +		list_first_entry(head, typeof(*pos), member), member);	\
> +	     !list_entry_is_head(pos, head, member);			\
> +	     pos = tmp, tmp = list_next_entry(tmp, member))
> +
> +#define __list_for_each_entry_mutable2(pos, head, member)		\
> +	__list_for_each_entry_mutable_internal(pos, __UNIQUE_ID(next), head, member)
> +
> +#define __list_for_each_entry_mutable3(pos, next, head, member)		\
> +	list_for_each_entry_safe(pos, next, head, member)
> +
>  /**
> - * list_for_each_entry_safe_continue - continue list iteration safe against removal
> + * list_for_each_entry_mutable - iterate over a list safe against entry removal
>   * @pos:	the type * to use as a loop cursor.
> - * @n:		another type * to use as temporary storage
> - * @head:	the head for your list.
> - * @member:	the name of the list_head within the struct.
> + * @...:	either (head, member) or (next, head, member)
>   *
> - * Iterate over list of given type, continuing after current point,
> - * safe against removal of list entry.
> + * next:	another type * to use as optional temporary storage. The
> + *		temporary cursor is internal unless explicitly supplied by the
> + *		caller.
> + * head:	the head for your list.
> + * member:	the name of the list_head within the struct.
> + */
> +#define list_for_each_entry_mutable(pos, ...)				\
> +	CONCATENATE(__list_for_each_entry_mutable, COUNT_ARGS(__VA_ARGS__)) \
> +		(pos, __VA_ARGS__)
> +
> +/*
> + * list_for_each_entry_safe_continue is an old interface,
> + * use list_for_each_entry_mutable_continue instead.
>   */
>  #define list_for_each_entry_safe_continue(pos, n, head, member) 		\
>  	for (pos = list_next_entry(pos, member), 				\
> @@ -924,30 +986,79 @@ static inline size_t list_count_nodes(struct list_head *head)
>  	     !list_entry_is_head(pos, head, member);				\
>  	     pos = n, n = list_next_entry(n, member))
>  
> +#define __list_for_each_entry_mutable_continue_internal(pos, tmp, head, member) \
> +	for (typeof(pos) tmp = list_next_entry(pos =			\
> +		list_next_entry(pos, member), member);			\
> +	     !list_entry_is_head(pos, head, member);			\
> +	     pos = tmp, tmp = list_next_entry(tmp, member))
> +
> +#define __list_for_each_entry_mutable_continue2(pos, head, member)	\
> +	__list_for_each_entry_mutable_continue_internal(pos,		\
> +		__UNIQUE_ID(next), head, member)
> +
> +#define __list_for_each_entry_mutable_continue3(pos, next, head, member) \
> +	list_for_each_entry_safe_continue(pos, next, head, member)
> +
>  /**
> - * list_for_each_entry_safe_from - iterate over list from current point safe against removal
> + * list_for_each_entry_mutable_continue - continue list iteration safe against removal
>   * @pos:	the type * to use as a loop cursor.
> - * @n:		another type * to use as temporary storage
> - * @head:	the head for your list.
> - * @member:	the name of the list_head within the struct.
> + * @...:	either (head, member) or (next, head, member)
>   *
> - * Iterate over list of given type from current point, safe against
> - * removal of list entry.
> + * next:	another type * to use as optional temporary storage. The
> + *		temporary cursor is internal unless explicitly supplied by the
> + *		caller.
> + * head:	the head for your list.
> + * member:	the name of the list_head within the struct.
> + *
> + * Iterate over list of given type, continuing after current point,
> + * safe against removal of list entry.
> + */
> +#define list_for_each_entry_mutable_continue(pos, ...)			\
> +	CONCATENATE(__list_for_each_entry_mutable_continue,		\
> +		COUNT_ARGS(__VA_ARGS__))(pos, __VA_ARGS__)
> +
> +/*
> + * list_for_each_entry_safe_from is an old interface,
> + * use list_for_each_entry_mutable_from instead.
>   */
>  #define list_for_each_entry_safe_from(pos, n, head, member) 			\
>  	for (n = list_next_entry(pos, member);					\
>  	     !list_entry_is_head(pos, head, member);				\
>  	     pos = n, n = list_next_entry(n, member))
>  
> +#define __list_for_each_entry_mutable_from_internal(pos, tmp, head, member) \
> +	for (typeof(pos) tmp = list_next_entry(pos, member);		\
> +	     !list_entry_is_head(pos, head, member);			\
> +	     pos = tmp, tmp = list_next_entry(tmp, member))
> +
> +#define __list_for_each_entry_mutable_from2(pos, head, member)		\
> +	__list_for_each_entry_mutable_from_internal(pos,		\
> +		__UNIQUE_ID(next), head, member)
> +
> +#define __list_for_each_entry_mutable_from3(pos, next, head, member)	\
> +	list_for_each_entry_safe_from(pos, next, head, member)
> +
>  /**
> - * list_for_each_entry_safe_reverse - iterate backwards over list safe against removal
> + * list_for_each_entry_mutable_from - iterate over list from current point safe against removal
>   * @pos:	the type * to use as a loop cursor.
> - * @n:		another type * to use as temporary storage
> - * @head:	the head for your list.
> - * @member:	the name of the list_head within the struct.
> + * @...:	either (head, member) or (next, head, member)
>   *
> - * Iterate backwards over list of given type, safe against removal
> - * of list entry.
> + * next:	another type * to use as optional temporary storage. The
> + *		temporary cursor is internal unless explicitly supplied by the
> + *		caller.
> + * head:	the head for your list.
> + * member:	the name of the list_head within the struct.
> + *
> + * Iterate over list of given type from current point, safe against
> + * removal of list entry.
> + */
> +#define list_for_each_entry_mutable_from(pos, ...)			\
> +	CONCATENATE(__list_for_each_entry_mutable_from,			\
> +		COUNT_ARGS(__VA_ARGS__))(pos, __VA_ARGS__)
> +
> +/*
> + * list_for_each_entry_safe_reverse is an old interface,
> + * use list_for_each_entry_mutable_reverse instead.
>   */
>  #define list_for_each_entry_safe_reverse(pos, n, head, member)		\
>  	for (pos = list_last_entry(head, typeof(*pos), member),		\
> @@ -955,6 +1066,37 @@ static inline size_t list_count_nodes(struct list_head *head)
>  	     !list_entry_is_head(pos, head, member); 			\
>  	     pos = n, n = list_prev_entry(n, member))
>  
> +#define __list_for_each_entry_mutable_reverse_internal(pos, tmp, head, member) \
> +	for (typeof(pos) tmp = list_prev_entry(pos =			\
> +		list_last_entry(head, typeof(*pos), member), member);	\
> +	     !list_entry_is_head(pos, head, member);			\
> +	     pos = tmp, tmp = list_prev_entry(tmp, member))
> +
> +#define __list_for_each_entry_mutable_reverse2(pos, head, member)	\
> +	__list_for_each_entry_mutable_reverse_internal(pos,		\
> +		__UNIQUE_ID(prev), head, member)
> +
> +#define __list_for_each_entry_mutable_reverse3(pos, prev, head, member)	\
> +	list_for_each_entry_safe_reverse(pos, prev, head, member)
> +
> +/**
> + * list_for_each_entry_mutable_reverse - iterate backwards over list safe against removal
> + * @pos:	the type * to use as a loop cursor.
> + * @...:	either (head, member) or (prev, head, member)
> + *
> + * prev:	another type * to use as optional temporary storage. The
> + *		temporary cursor is internal unless explicitly supplied by the
> + *		caller.
> + * head:	the head for your list.
> + * member:	the name of the list_head within the struct.
> + *
> + * Iterate backwards over list of given type, safe against removal
> + * of list entry.
> + */
> +#define list_for_each_entry_mutable_reverse(pos, ...)			\
> +	CONCATENATE(__list_for_each_entry_mutable_reverse,		\
> +		COUNT_ARGS(__VA_ARGS__))(pos, __VA_ARGS__)
> +
>  /**
>   * list_safe_reset_next - reset a stale list_for_each_entry_safe loop
>   * @pos:	the loop cursor used in the list_for_each_entry_safe loop
> @@ -1189,6 +1331,31 @@ static inline void hlist_splice_init(struct hlist_head *from,
>  	for (pos = (head)->first; pos && ({ n = pos->next; 1; }); \
>  	     pos = n)
>  
> +#define __hlist_for_each_mutable_internal(pos, tmp, head)		\
> +	for (typeof(pos) tmp = (pos = (head)->first) ? pos->next : NULL; \
> +	     pos;							\
> +	     pos = tmp, tmp = pos ? pos->next : NULL)
> +
> +#define __hlist_for_each_mutable1(pos, head)				\
> +	__hlist_for_each_mutable_internal(pos, __UNIQUE_ID(next), head)
> +
> +#define __hlist_for_each_mutable2(pos, next, head)			\
> +	hlist_for_each_safe(pos, next, head)
> +
> +/**
> + * hlist_for_each_mutable - iterate over a hlist safe against entry removal
> + * @pos:	the &struct hlist_node to use as a loop cursor.
> + * @...:	either (head) or (next, head)
> + *
> + * next:	another &struct hlist_node to use as optional temporary storage.
> + *		The temporary cursor is internal unless explicitly supplied by
> + *		the caller.
> + * head:	the head for your hlist.
> + */
> +#define hlist_for_each_mutable(pos, ...)				\
> +	CONCATENATE(__hlist_for_each_mutable, COUNT_ARGS(__VA_ARGS__))	\
> +		(pos, __VA_ARGS__)
> +
>  #define hlist_entry_safe(ptr, type, member) \
>  	({ typeof(ptr) ____ptr = (ptr); \
>  	   ____ptr ? hlist_entry(____ptr, type, member) : NULL; \
> @@ -1224,18 +1391,44 @@ static inline void hlist_splice_init(struct hlist_head *from,
>  	for (; pos;							\
>  	     pos = hlist_entry_safe((pos)->member.next, typeof(*(pos)), member))
>  
> -/**
> - * hlist_for_each_entry_safe - iterate over list of given type safe against removal of list entry
> - * @pos:	the type * to use as a loop cursor.
> - * @n:		a &struct hlist_node to use as temporary storage
> - * @head:	the head for your list.
> - * @member:	the name of the hlist_node within the struct.
> +/*
> + * hlist_for_each_entry_safe is an old interface, use hlist_for_each_entry_mutable instead.
>   */
>  #define hlist_for_each_entry_safe(pos, n, head, member) 		\
>  	for (pos = hlist_entry_safe((head)->first, typeof(*pos), member);\
>  	     pos && ({ n = pos->member.next; 1; });			\
>  	     pos = hlist_entry_safe(n, typeof(*pos), member))
>  
> +#define __hlist_for_each_entry_mutable_internal(pos, tmp, head, member)	\
> +	for (struct hlist_node *tmp = (pos =				\
> +		hlist_entry_safe((head)->first, typeof(*pos), member)) ? \
> +		pos->member.next : NULL;				\
> +	     pos;							\
> +	     pos = hlist_entry_safe((tmp), typeof(*pos), member),	\
> +		tmp = pos ? pos->member.next : NULL)
> +
> +#define __hlist_for_each_entry_mutable2(pos, head, member)		\
> +	__hlist_for_each_entry_mutable_internal(pos,			\
> +		__UNIQUE_ID(next), head, member)
> +
> +#define __hlist_for_each_entry_mutable3(pos, next, head, member)	\
> +	hlist_for_each_entry_safe(pos, next, head, member)
> +
> +/**
> + * hlist_for_each_entry_mutable - iterate over hlist safe against entry removal
> + * @pos:	the type * to use as a loop cursor.
> + * @...:	either (head, member) or (next, head, member)
> + *
> + * next:	a &struct hlist_node to use as optional temporary storage. The
> + *		temporary cursor is internal unless explicitly supplied by the
> + *		caller.
> + * head:	the head for your hlist.
> + * member:	the name of the hlist_node within the struct.
> + */
> +#define hlist_for_each_entry_mutable(pos, ...)				\
> +	CONCATENATE(__hlist_for_each_entry_mutable,			\
> +		COUNT_ARGS(__VA_ARGS__))(pos, __VA_ARGS__)
> +
>  /**
>   * hlist_count_nodes - count nodes in the hlist
>   * @head:	the head for your hlist.


