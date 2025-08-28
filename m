Return-Path: <io-uring+bounces-9361-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CAA32B390F8
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 03:18:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 85A473A55A4
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 01:18:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BE2E2063E7;
	Thu, 28 Aug 2025 01:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SO/zxCy3"
X-Original-To: io-uring@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2081.outbound.protection.outlook.com [40.107.93.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD1D1F0E2E;
	Thu, 28 Aug 2025 01:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756343911; cv=fail; b=QLUYAQD2O9K/s2S/dyeF2i36HXe0mB8YjtP12ue+K6JA3yjghxyaPU/TMVDDt3UezkC5hXZIpNQ/1tIWCUioE15oNDZcs2a6auT/Jk5tATSIg9WTTp/Ad5KvJzNZlipKS+01QTDgI+bgH6aRMgBLgb5kfOdr04fZqHl7RD7XVGo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756343911; c=relaxed/simple;
	bh=DgEraQjk8YvfJrjcJEr5399iQMrdwzTLvXj7SbaLvVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GPuoxuBr2I97IMDxruhEbN/kdvH0KCK/mLZDQoy06C+lAe7+yI03FGV575HPK6jHmrBlkpGKcGYwIkCqKnxK67KFQbUMzDPc0qA6RAwXqerAzpsC4FGRi9/kZxy8yQtl0IWYvGmyM5RszoJIwQJYU8klPq3e6MFqOjEXfytKvjI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SO/zxCy3; arc=fail smtp.client-ip=40.107.93.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RP5KFazG5jt0wRDpY5RUlYPJeRQ1i0iTWQTsu5rAGB2yMLjhWiVNoubqnQJHdxkskQr6MjSNLPf5R/l4aaR3lzokPPXe8nujnQmUh76tpFy5CJVR+vhLSpyktA+OuNjMey6gn8aJ2czUXLqiSiRJDwhHasDGDD60wnLqM0mzb+6QbBCvpUDAkIVLi6bg+qAKZF5W7S0RPNLkqW9dPKPeO34pWbUCrZTHMroC31wgqHo6SDrh1/fR3t9ZhHQvsIRd5MQ9/H7uoiUnCkY8nXgCt4nL3M6ck9yEC2piTIJaEKOlCyxeCY9noZcGQNEUxlceBmJjkM/Lr5TCxZ05T8sQuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f0z0GspihNSSfeTybTglosJQYVAZScewsE15DFtKC2Q=;
 b=UHIvvRpYJgCfQ8VxeuBp+qe/WcxTzkoUEZQ4lLDhu5MT6gmLBN365eKTRAGk1ODbqH4jGRif8jdQgeIW5687g36hU9gyXuBk7tbesjnzcOYgNTX0+twhOgWCN1ucY8BnfHtt0HZKO9NIWvCS9UKIZc1gdcFHWd92stchW8cuyy7VP1GxIMBw5nN93+1+3YNKwKQwfmJKjwOQuinAgw0z8Ypbhi8gW0BWSRVX8cuwUstiJG7ocIF2Z7sPuLmowmuW9xtz5dnp3viJ+c3SNJMqe8jj0PUxvkVNk/ISDAPBfGQi/pdfurm+ElPbdYoGakhDng3XezUeZt2Ld1nzAQwHhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f0z0GspihNSSfeTybTglosJQYVAZScewsE15DFtKC2Q=;
 b=SO/zxCy3z5A3QFClcXnl2nRRmlxyAuQq3KUZ1lVjnvKat0sHUNXcuoX/ngp/uhEPVg0b1WnrroH1x3PW+49bZrNru52SvkMCm4Z6AhrF3h+Wpj1CKhmV1TQapWv0LRyBXyO5z6mXsPowN0Bm0rkJ4dro015BCukp4iE5w5LcSGCmHm+HOFbBTFVvf/GJXcOQ73PSH5J/oA0Z5P3GItwhUIvCEHEqYJ1hzA6eYoV6VXJR+aeYJKsCVzmuLLRLFVNi6tlFPFJaxsGiF8y4TsaAHpvlhJ1X+X9xQHfEMPwfIY5w/KwAJIIxPZ28llaBJbdUvViNNVdwydDANydZC5vj8Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB7825.namprd12.prod.outlook.com (2603:10b6:8:14d::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.21; Thu, 28 Aug 2025 01:18:26 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 01:18:26 +0000
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
Subject: Re: [PATCH v1 16/36] hugetlbfs: cleanup folio in
 adjust_range_hwpoison()
Date: Wed, 27 Aug 2025 21:18:21 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <22900121-30DB-4A1B-88A2-E3D158E009E2@nvidia.com>
In-Reply-To: <20250827220141.262669-17-david@redhat.com>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-17-david@redhat.com>
Content-Type: text/plain
X-ClientProxiedBy: MN2PR06CA0025.namprd06.prod.outlook.com
 (2603:10b6:208:23d::30) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB7825:EE_
X-MS-Office365-Filtering-Correlation-Id: 011d6e5f-b108-4c67-6566-08dde5d0c9c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?anuDnOeBHohnJ67dJqfsbZG2Om5PvfX2R/G0mJZJutrEWiFCJsCoNoNBTXyW?=
 =?us-ascii?Q?Rx1OGMepNnj7VQdMMoT0k7OkLbyZr1gHVvLBYUjMqnYuIgMujFcsg0S6hVTe?=
 =?us-ascii?Q?bzR7Ici2ncRdLv6Z8w1JKbAdT/5SxJs2vjEm6eQBOapBZHH6pTX4qr7Q4fDl?=
 =?us-ascii?Q?FOj77WVwottXVSharV18MyL4eXuFdEUCQ8my6kHchU6qrwjwZq1hIxE0nzdW?=
 =?us-ascii?Q?w91lfBgk9xI8RWHAGwTkwVWHMuloM+LIM5dU+M67FjH2hcWOQWjmBpbTvgGG?=
 =?us-ascii?Q?GkTVQa7cYY2FB+ghC/pDnT44NMsVeiwOSuFTANIuXMbt13Yj2uWAbauO+/Gh?=
 =?us-ascii?Q?TVzM2bGiwFDVcGAJHR50HjSgCqGDKlsROhurpiOn1SE51l+QCutcvTDPn8cF?=
 =?us-ascii?Q?8rwhcDp/6QD/mOy6TeILTGBmDp4GQjhowCx2QrkGxcLBUL0xBZnob9hKr8fe?=
 =?us-ascii?Q?wAYiWhqGcsOzoSnAlZAc4eVB3w9I7BKQQX1YwZ0RaiL7LF5Fizf0w2lyv2ek?=
 =?us-ascii?Q?9t+zxb5WTK6umfui9Ofu2xuL9eFds7tMW5hz5VDbDYRQS6Wjr7lWvsGe0AiR?=
 =?us-ascii?Q?zZnLOIU2g7QZ4ypzDRvdCAkqU93inPkFUjfolL7LS4/rQbKi6uoBFEl+4FWK?=
 =?us-ascii?Q?XuQFXy+LH0hbotWnxMYBQLSD0w/w9Wpdt7adacB8qLn/fndN5wV2MwqCda6X?=
 =?us-ascii?Q?ZbjI3p2rKEBvsYc7ni+p9GEpPG5YfQgiAeTgqUO9ug0rFOGR9jg7XHcyt/Gn?=
 =?us-ascii?Q?6Y7eSQ2OdXQa1c7wPjunC0/Shnn/zr1OxTDP2/zl91sxmrhhrfqh9JdN+5mD?=
 =?us-ascii?Q?J+SEl96fE/LqLmAPrIIXH0qbRIx5GtRqbwORM32K4SArsBFNcmFnfSn4jZO1?=
 =?us-ascii?Q?sxLixGlpueCTjj9dkz78e2/H1I5ZIm+oFqMSAyariDHrC7C7dUnp4TlT6Pzn?=
 =?us-ascii?Q?CkNvy0oQb3VIL6XGHZjB9r0oMzmJdqE1CZsxTVpTrEzKjQLh9QtuBKlvwT2f?=
 =?us-ascii?Q?qB7XqnsFQsJFGfAk4Qt9/usPAQArZ2RWRc/S4RQBFbMQyoLm/YziX0phPFEB?=
 =?us-ascii?Q?SA+h9yZ4phYgY4madHtpR0FGTW7h0KhfOkJKPzjGT4RAHzj0wgRWKI4kGKb3?=
 =?us-ascii?Q?GYzAhPVZ1DqSYuaSgl+MQEw43YVrD7dv/852/3c1Atx7/hOck3Bznh/UTBpW?=
 =?us-ascii?Q?TUcns7lE5UkL2Xsi+Hjssr+2/NS61gmhxboqIsVeErciZMN1TQciROeM5dBJ?=
 =?us-ascii?Q?srVs0FffB504LHiJH/u+ykPhLFaA2dkH/fu6qRXXVLRhegHzVkObgc7JeoIY?=
 =?us-ascii?Q?L1Lsh81F7hgncghVIxaUJocmHCiXRHkQkhRb9uqm0f1IEYAKv7HUftdJQtvP?=
 =?us-ascii?Q?PuptyPRpzwmqVHCC2gJJCpo7CUmRBWlUomx5wlnjMWSfXKGTEUnYOHYpkrGZ?=
 =?us-ascii?Q?cXt9GYvfqVo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iorvuWOtIzYyTz1Y5tdMMXd4HQLh73OM8fEEUVhaCmYH+a3Fwm/nwXXAbYpw?=
 =?us-ascii?Q?zZ0y1Z3YhMqi0S+ghhB7C5/cnQKvPSHYGkl+HF10VtayOYFw3iQzALbJW4wo?=
 =?us-ascii?Q?pYegPGgjaMSqDDOtlOk4dsou35D/5WCGZV5s4sguq4dYRK6RbfD1aToVmctx?=
 =?us-ascii?Q?axyE4LRVgUxSiun0WCndPOTIndKRmTAKMvCMuSbS8PJKYVU2EyCxRu4/4qh+?=
 =?us-ascii?Q?TumGsAjcqY7vCnaDVlwuZHG5b/VrsGKs+bimUB09vZXq4LpcxISdXoQwJRWc?=
 =?us-ascii?Q?2RjN8IV0G+EQmOahufcFwKxZAgogkp/eSbnfgnZVgJP10SK98e1FtGNic6hv?=
 =?us-ascii?Q?FAXnClYBjWZqR9+rpOjfAGDk495pdgW+rHAifqxt6wgbDO1akIlHA8KBXONW?=
 =?us-ascii?Q?NVjEgPdX/JU6k8dOwHhVyjTYI+uDT8FMavojfaiEA8EDvcUrw0T9a+uStEOD?=
 =?us-ascii?Q?U82IijIw9IDkN+hLEyiDxa+xQHzSLkfGKD8w/GHtXFAO3ByGGXVmhAq9M0oO?=
 =?us-ascii?Q?GkpCNZr4/qayC3wlb3vFYQ5SFoGoNZ7Qpql7Er5DuzKHZEf3YWLRzZlKjvfa?=
 =?us-ascii?Q?8hPXLuXsDHKMGHbr6hHUKXTg1KldFH+y5XJejBJtTlODsRRw2Co/JzD6aM/d?=
 =?us-ascii?Q?3kIjf/jIKAZ/muS9votPMhf5tt4bTee7IHmur4dwux8Qf6HlXDEoAQyj07Y4?=
 =?us-ascii?Q?gDkUgKugZ55IdL5d5r61I1E4lmojpC3bWGuZQvCPhiJSYkXyLMYdKzcAEAVb?=
 =?us-ascii?Q?pT0C624l9s1VQtcgfzPq+m9fdVtuQ2IKzbQlxGyyoj6na0QQZnfICcJv3zRY?=
 =?us-ascii?Q?VkgwXGO0Ij8+qhkoWH+0im0X7W5/WL2Ijck4fKtjzDxLnsY/XkjgHGCa6xte?=
 =?us-ascii?Q?7zT8Ys8FZUd/KZ9BiuqLQciO46tal6/qL0Vf9vQSjFt3OMYkHIyZeEOfydq7?=
 =?us-ascii?Q?aMsvG5c276Qp7DH75alL4y7WA1KmeYhA8LeIfZN+sER1eGz6bPxTlroQwhoK?=
 =?us-ascii?Q?BAC75rSWWGBjTE7YE1ZbGQDR2Uz8N9d+XtPjYydyz++qAJr5upYBouiol7go?=
 =?us-ascii?Q?RaLNaA2wJEzf1d5r4uS7KUzu5Cqkjd9Ak/bPhlIVrdhWC7qqixYmt+dy77QO?=
 =?us-ascii?Q?I+NmXQtRnb8E3rrHJsDvHRsXCIQYAekr4J7ckmX6EIbpYHcBueVAWvRV38CQ?=
 =?us-ascii?Q?5JekFs2UKbU1cLnKGJuM/R3c5Tvpz/srbrZcu7GHHb7ZcAeRxOjPvTyyppB5?=
 =?us-ascii?Q?6S0mpd5xyNopp/XNmyESEpTnLhQ2xr1uBNXdceXmwuXw2uapGscVRyl8DG02?=
 =?us-ascii?Q?wFiQoQg0PA6YGjxiHzghYhQRjDfvI3/7DxrGr9bzgrELZbdei6SEP6+QwfE/?=
 =?us-ascii?Q?N3wzIpbcTCyKyz+mb3sEtLZS9RurDFdRV21Wy3t8qL/vtngaB5EqjRQiDy3R?=
 =?us-ascii?Q?7WH/3i7ikwq94x/4dn3eB1kS3XiGAiqsfZdzKDxZ9uYoKta1pwOT4MiqhYDU?=
 =?us-ascii?Q?DCC/NXY6ENfbLLd0BtNu/Wly45mwvkbn09u7zWYyWxUH9mMCmITO2N5b/vjY?=
 =?us-ascii?Q?J3ofjQx9O3HVICBIjwo7bsNUClembdhtDvQiI8Z3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 011d6e5f-b108-4c67-6566-08dde5d0c9c4
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 01:18:25.9047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UF0Ue62x+n8oaTn5s9htiLbTjQUtfbOemw40/1mhrxlnWfwDqqZWaepMNo7yAr8j
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7825

On 27 Aug 2025, at 18:01, David Hildenbrand wrote:

> Let's cleanup and simplify the function a bit.
>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  fs/hugetlbfs/inode.c | 33 +++++++++++----------------------
>  1 file changed, 11 insertions(+), 22 deletions(-)
>
LGTM. Reviewed-by: Zi Yan <ziy@nvidia.com>

--
Best Regards,
Yan, Zi

