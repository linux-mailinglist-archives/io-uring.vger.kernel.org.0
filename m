Return-Path: <io-uring+bounces-9226-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6589FB3076D
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 22:58:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B4D285C36AE
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 20:53:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CBC634F47C;
	Thu, 21 Aug 2025 20:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rcCjS/R+"
X-Original-To: io-uring@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2086.outbound.protection.outlook.com [40.107.212.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866D834A333;
	Thu, 21 Aug 2025 20:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755808620; cv=fail; b=FKWHRIYrOASJ5YGdgfvzTIfpEwy3TPjN7rQYIiXoCW4/LD5yKNoS9P222iZPa2WnuoGhnLDoaiNdvJukyBI4wt1k7xyshy3EVWjXEuPRGddj7kSHgMImszHJD78/Vlj/VgWUWKSVMEN/9ayBX6p1btWPE1f+9QBQvs8bx7174BY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755808620; c=relaxed/simple;
	bh=NW5VawqowcIHcPwHempLEKmsG2hli7UG37cQ0VSvaNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=E/VOJ1cbqhl03wGzDGxeEI/xOTUgggzr9cvMMKEuOWuJbKTkS1hys90VpAIqwPcdVR8c3EDQNUDJBMNljlr1E7QY5IDKEvA7qrYyG8tBgV6j0PLU2rCqjtA85GnGxeQNbNC8Eb+jPzJu1nkMD4fGFh2Efe3LBZwfjjQjcJnvfMg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rcCjS/R+; arc=fail smtp.client-ip=40.107.212.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BY7LS5y3JQenbmDByqzihvByyrkH1pN9soIW0P9fMXbW8+WpzopxmLSDm26mfFPN9oLmxBqOEFnaNIl+cSgDJv8Chn7ihmyNM9elDFFJTu+8zJ9LY0KbWuVBW/MrUrQtJcd1mwouOLjErg/B9nY61f8s4zLAmm1OG3RUX/8vGfQAOBv+Yw9ERGvXDqPLoM1Sk3IGIn9nXeunHnJywjlgJRh7WyYfeGWfvbGGslVtlxiCVLw34ma1f2fOQy9X+V7R/nkiyGR/L8rltTOKs1fzyJPWP1CFBWjXTtDNe3ICTRIJfUJpQ3zSuvSfSylPYnuwr5O2y8mn/RX4u9gBFsillg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=koxUl9Bhb6pOKk6qTtolc4aNI2RYQiUs0Al/jCKT/zU=;
 b=qI70dwEuPwA0XcKralhUMn9j/7sGA/Wtj5TxNEeIpTBuemix5hp5yFVdULQr30Huzn58n4HXilwaCY/L1H+3nH1VHriNhV8mssgAO/2RNKRTP3BvXLK3o8p0g+BNluIWNSV43R4RmDTrJJXgOBkTwNqRsM0VMzZOEPOI+vV/rFmHHDo8sn/vtwWYcezJ5/Pj9IzdbFq5SiXxexvs1GYmrTKUBD3I2Km5Q4kJ/qglzH+1xAruQbj16eO97BBvEN25bSaIqar9tyIgUFrdA/iPYTMD1TyEBvCKt03ZanadFeWDrXa8heVKDB34alCLTgpTNccsv821ElRuS6pKM8zV5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=koxUl9Bhb6pOKk6qTtolc4aNI2RYQiUs0Al/jCKT/zU=;
 b=rcCjS/R+CjeoNMYftPzeFlQRMIxhYUid/53O/2ptT3QT996oxwgRqQoP0ZTcPg3tZmKva1TIALZAoJG1toRf/AvrFKlyCTae6j4QQv4vXTIxupeN9lHjMEg9DcCdjHQ7HvKYMcEwNUHJovus9ME7XToKHVtRl5Be2MkQXqRbJWvngiD/8sk2ccM+3C83NCEgiWQG2GFRQvYA+cjf1R/BLpGFBHwBR/l3GScSeBHdTWVZAk+vV6qJoJyG5vF57jpxemo10GJrCjqT8NX07IuEjnPQj9oDWADqzQq8sacJHfUAtqNujQEqczFkXvpGi5ueQAtlda0b5k8VmPhVoNQ6tQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 LV2PR12MB5967.namprd12.prod.outlook.com (2603:10b6:408:170::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.16; Thu, 21 Aug
 2025 20:36:55 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9052.013; Thu, 21 Aug 2025
 20:36:55 +0000
From: Zi Yan <ziy@nvidia.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 kasan-dev@googlegroups.com, kvm@vger.kernel.org,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Marco Elver <elver@google.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
 Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
 Robin Murphy <robin.murphy@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Tejun Heo <tj@kernel.org>, virtualization@lists.linux.dev,
 Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, x86@kernel.org
Subject: Re: [PATCH RFC 11/35] mm: sanity-check maximum folio size in
 folio_set_order()
Date: Thu, 21 Aug 2025 16:36:49 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <5566D681-ED92-41A8-AF46-216AC8F62174@nvidia.com>
In-Reply-To: <20250821200701.1329277-12-david@redhat.com>
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-12-david@redhat.com>
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0501.namprd03.prod.outlook.com
 (2603:10b6:408:130::26) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|LV2PR12MB5967:EE_
X-MS-Office365-Filtering-Correlation-Id: 03b70a1a-d4c1-4d7a-4988-08dde0f277cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oPSl07THh7u3O1EO6lVPOnLiqj1qdmDxNG48EQlXY/Z1DBgjMvRNhbBgVbP+?=
 =?us-ascii?Q?5c8IQn+YeAvMft2RN5YpsUx8tf7odVvPJN4YsNBfkrUtQFeaKBqc4anI4Lft?=
 =?us-ascii?Q?2pgj/DQv9voztvCeamHV0GoZ61QF75TomBVTq8uIpMlq4e0fnAG4Ay7GMBh1?=
 =?us-ascii?Q?pCWRdRTdUvwxF/o5xGQBb13ydF743QdzOa1614X2B+YO3+Z0HqXfkLt7smRQ?=
 =?us-ascii?Q?4SfsJMu3bj/9F3eYDHXtJM6PlXI3E8eYROWE7p9eJdwe6VlSIrOfeJ8I8Q8/?=
 =?us-ascii?Q?Rz/xwL6c7gOIFa+67+vyemz82fJCPQPDnXPMffcFlCsoCh78RAHGAZ7eqsUY?=
 =?us-ascii?Q?U5DueMcDmQY/0WL9EL1VN3VoMtzpIzf5opEIqUAWlRego7b7t59QxZUCbNLB?=
 =?us-ascii?Q?i6xuaTLhjzpSeYqp4zLzndjf5znIIqx8l8HSmWL2wYQCKA0Ax581aGlWkniL?=
 =?us-ascii?Q?rZoCCMLJcd+iNc/OuEpqoZng3XANzftlFqHqKNBSoDwgfkAiNzURHOpp0LAv?=
 =?us-ascii?Q?vDFBXequetCV9I/J9wcP9mSVTKRS5WPFrg/KjKOQsP+wNJZlwJ4lkBVu/Ry9?=
 =?us-ascii?Q?v4VnzKccbctS66ESBJC/2Cyxu2BuWhNhXg8aR8spFpD09PmJ93YbcRMJ7nAP?=
 =?us-ascii?Q?wEEWF99o0SJQ4eVr6eoqT1Vgb3oYiJoFkrf90NaeIpG41NDyY+IJc0u1INe3?=
 =?us-ascii?Q?eNJPHuJxJCkDQeoxEGzxgQoLRq0Yi9wVFV4J0tDBho0O0ghbEV0+/0wFydA3?=
 =?us-ascii?Q?RoXClFOHshIO2weAkXu83wuil3VdSkCQuohwC0fgeA6NM9S/jDqSN5jVZBfB?=
 =?us-ascii?Q?IIB7xtpz0QTCHp7cY+PCom1oxGOIX0ikbtpROouo3eC/lVDrrmAvy/sDbFwk?=
 =?us-ascii?Q?BVOg6L9DTE/l2qX+9qy3PR4608Cp9NeoxlOxXYzC4wd1R2v+4oWPy1XN+8li?=
 =?us-ascii?Q?9jQlN0LlQCYZAXJX2/lbP+V9fQFpOAZ1T73uV4orqvUZJB4nG0/uVfWiJaC3?=
 =?us-ascii?Q?a5EWMnFOh2bKUYS3NHOoodPSJTUs8VDFOihMRMxB3vUO77EuPr+Jd5jXu1m3?=
 =?us-ascii?Q?QPi/qZKvK1EUNjrc3G3ULcYr6/+j0orXdCpAs9xIKwqkRaNdWoMR0mbCbMmE?=
 =?us-ascii?Q?eA/BmX9E1pZeUXaoNyHxs2lzfWkNqG1+Kx7zPxrs9eBfXR5uLR2aL5i/4pWr?=
 =?us-ascii?Q?3ae5JVIJZQtvXFx6iC4i6+ANoAYbp6gu1rlZKug7Wy/HVzNoqSZQoZKzsOZe?=
 =?us-ascii?Q?OuEd27ahWJDBRK9uNsAnnYlij7711+fpEEf4dhP9fzhjrsmT3Me62283SHcO?=
 =?us-ascii?Q?6BIqDqYhGC9bi3DgYmxLLk2l5fnCb8hBUdMbs0ogqaFyOCYrbKn6Z+MZM6Sz?=
 =?us-ascii?Q?6wNqb8DmcE3LSjlPzQ1Q2mB2TaE+9Hy0t6HxFW4pIyT0KkI9aD9MfqWGvGqg?=
 =?us-ascii?Q?kqKS6IGegl0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NCxgrQAmFjVQiLWTEgbWaY1DWfNMsLBr5j4o7FqESo567f8Zsbf6o9O2Jxk/?=
 =?us-ascii?Q?ByZkiveTXAXeSQZglx3TtNeqj9M0134y2uBhq405H0h7FO+B+VtL6xci2Eio?=
 =?us-ascii?Q?TfittsCGQkzFdQj5e6dCcd0tOWGjvpz2ccs41HYAfeXvnFlCfnjGrhpaYeDY?=
 =?us-ascii?Q?2V9xnAM+/TSc4HfNgbeQQTo87KaKBGCUo1d10iVinUnReSxT1iRjp6U/rAY9?=
 =?us-ascii?Q?lwgZSPu6DXNpzvFanA/fAKzt0VjT+9r9PxJMr3hhC2D9gXe3v7qaQFtRMwNm?=
 =?us-ascii?Q?bTyxMuvGH9vxWcEaNSqo+nWDGgLANM39pacn/xTHeQf8RQTIJq0i/xKwKv4b?=
 =?us-ascii?Q?X6E5zUafF3q2r/9SCLgY0pgIwtVMaeBYd3c1wX4kJgXUHr9oYuegtOd3Bcsz?=
 =?us-ascii?Q?7k86wy/Jsh46mBqrUmq0hI1lXzQR8iTyBUTkB93aTsz/TveLLVQtvHS40+ZV?=
 =?us-ascii?Q?+pgXPV5MqpzfQAB+UKWTg4cQGuiIyJ70P3kRQoXTxgqm4emTtWCzcGL/RMjl?=
 =?us-ascii?Q?Qby52xm1T004O7RgxffycpNwHIR+Zu7am1RyOl3Rs4ZcNQW7LJrioi85KPVU?=
 =?us-ascii?Q?V9BDEp574hHu8HvH80fyi1LheAiX2kOWPKzi8LxhjaWuzYWsZ0Zx/ZRLXgqh?=
 =?us-ascii?Q?k8gWefQxOTmuKeH9URI6a22pkabpy2E9iToh0AEXVFi0K7qRMIgbOW/9LESZ?=
 =?us-ascii?Q?dSGLV/CXKjBWvYrDSsh1I97IUvpqi+LsmuuJLjvjOSFx3SOIkcQIj/KCrBaV?=
 =?us-ascii?Q?w8PJsAEYr+A5NYX3+ahuCPLIlKWOLt3vRpgdHqbiMJtty7BG7IPGy+r5i8jj?=
 =?us-ascii?Q?hM2fcLktkFLJycL+FBqgJcWyLEkgPh4zy4/cymAv6FKdFp+GMCIV2DhgpJUR?=
 =?us-ascii?Q?W5PDB3LhDArixTSi62DrDJ6pegFsaDX5UgaF5nWcdUecW3FrnbbggGL8LxjT?=
 =?us-ascii?Q?IoKBdKemFTdoYQZNG9sLHzV67Z/EttdA8gWbOCbedjzfS6aeEGjOLFxt3TdE?=
 =?us-ascii?Q?15aHpR532HIFMTzkWO9mZTMqKeWybAyu/4QD2Dc/yS3wy0DTqe8HVvSwevuA?=
 =?us-ascii?Q?wOArp8D0/x3FOncrLjj2Hm/c9TS5K5IS1S9c5+0ONdpv7v0cjnFwdgFElOkL?=
 =?us-ascii?Q?w5CrIQ1oHYf4/BIavrQ84/rxhpUsdrGW4wHwiw4lapCAS6FafCdRTMaojS7V?=
 =?us-ascii?Q?J3EGXKj5RwGfGCpcHeVrZVT/hVPbPeBZk2DPxjm2gABpKOwzGIT9UqrGKkQN?=
 =?us-ascii?Q?0S5xWs2IPJT7wsM1qgS98Q/PbRix8XxVKziCntzYXlQ/GVJWywgRUopWEnG1?=
 =?us-ascii?Q?tEsGzTPn3BBtKKVYmWGEla1rLgERpkS0gnrcIkp+a8Qzcj7tQA1L1qbEHFOs?=
 =?us-ascii?Q?5Adq83nn4i3xhRoMtRa8h9eQfDOtKYEWgCUy3sVr+iAmqHY1TC+tE/UOrVq0?=
 =?us-ascii?Q?sYvDPO9P40i2BIVEJTfsuhU/VfEqRWvyxQFCFaj77ZqGi8CUZ9msrA+dFj3E?=
 =?us-ascii?Q?wtG6Nrl3LDege89oYWCgeU+cOHtCdkJkKaZgjx3QNTqlG+4UNMHexFMs4F6L?=
 =?us-ascii?Q?ZjP+GY5NuKmstmha0QkelsVjJ3ERyasWtxek21yV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03b70a1a-d4c1-4d7a-4988-08dde0f277cf
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 20:36:55.4394
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1C2xVTmQxGlMPGE216NMJWrvZ0hUQ0fdjv+vn5C3E0IEGdPCLRnd2ChnSJgmZQ4Y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5967

On 21 Aug 2025, at 16:06, David Hildenbrand wrote:

> Let's sanity-check in folio_set_order() whether we would be trying to
> create a folio with an order that would make it exceed MAX_FOLIO_ORDER.
>
> This will enable the check whenever a folio/compound page is initialized
> through prepare_compound_head() / prepare_compound_page().
>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  mm/internal.h | 1 +
>  1 file changed, 1 insertion(+)
>

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

