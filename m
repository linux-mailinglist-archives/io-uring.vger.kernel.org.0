Return-Path: <io-uring+bounces-9221-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C07FB3072F
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 22:54:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6934F6431E3
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 20:48:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0363A393DD8;
	Thu, 21 Aug 2025 20:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MZiG0IB2"
X-Original-To: io-uring@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2078.outbound.protection.outlook.com [40.107.220.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72092393DC8;
	Thu, 21 Aug 2025 20:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755807796; cv=fail; b=ndgbJ/FHeKKoUWsLMe1slFaG8HBAi4c6a32VArveHpVpYPBaUbXUySKNj+quOHhAdxmGZxd6bnsfxDqvuQTjYR8a2TaKQAx8H7RNtPchU4+0vJD+w50bauTOyngeS4ZN0Ox8X/Ol9RV0ZW87b6oBFfa53omIF7W5/bbGH+XwtWg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755807796; c=relaxed/simple;
	bh=oUq7LjkzBBT5G/MYpMLY4W8RcJHmdTF7LZ3fvHuP7gE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=A4mc/JHgQklRxRgi7Isd/0TJrYYrtYMM6VZx8wqC/A5AYACWaW75vSbuqt6dFvRXdQsvyhd/cCmlNkJ/U5nz/QgYPHauNxnfLHfMvR22sEP2k7K+oS3HEDx+VV5zNu08XAN9lrvxY+57sT51qo/ySXKGACBfk8EwwiO4wOgpMsM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MZiG0IB2; arc=fail smtp.client-ip=40.107.220.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O30FOsGVFG/gk1k6oGa147BFnCrgeSa01x0ssDZtSvQ0KVpSAiL1Nm3ZJSvqmBBHNKHjgbXy26lK6IXhwQQpLH2oyS5Gh3BqGfFyDxpye1RLxu9YWtGrp4vdSmAyoBz7WPyjKT6KSohpExt4oSquEs/Fvm8XcJ7QVxfxmdmEJBA1q5xXvhWwC8EskShvXfm9Gv5GR3liuPrdVDLT6TanLlhHAlAa6AFpLtVvkTaInMklDjD2gcYdzcX+raJ/Ao60FbEtVtHaJpY6qU2V6lla2Hpr7byGWH22r3TPkaPp6zTAG2ZthgNoRsQ5v1CPn4JRjwbP/AwS05hQC9zFmQb96g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WgmiAibO5FmTDZwywRZ2ZsbC9r/pbgm4izdfkPSm79A=;
 b=AWaV5HAsB4p73TWokCt/T/9dmvzZ5V76rMicMchv67FdCJJAhJ3LdA+C0Dx3pyBuWymUus77CyQd1RNte3JYDBEW+SgAKSd6qxr2ty6VmAuMhGh0FIc2PqCoQyZcwsV5OdnQjIw4JMV1XyBo46/FMhMFJedDv+XFWrWR8bwyJrfxhIyLVn36w4IdVxFTWrBsppY4GT+hq8xB+S9QuY8CNQLYkkA8Bp4+bDrGdPvm5TEsFpkkXEdJj/9vOH6Z/L/JR4ptJVIrL7Z9aLtsOuksJ72HcnJVsOvW8FfBITtfMtj5k1uznf93Ko/M9PmzAi1o8ZcHJV/7ZZ17GTPsujUO4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WgmiAibO5FmTDZwywRZ2ZsbC9r/pbgm4izdfkPSm79A=;
 b=MZiG0IB2mv7javpTm9PdHjAhBxkoAD/64otl2Gg12Gveai6pqeEJ7e4pEI9DNVGL56rugCnmm0qCATtnxH1laa7SdViI4m8vCFXzNFy/l0vFCznO+tQnB/K/ZfwrAOb6B0XvdQ8+wkeC5akQvyBJPwBYY3SL5ztBgr3xR+dLYzTTAKEvSu99yEzkqM9tSVo5UtVOsyYirOVVPBJdBTaGkyz/gEZbAsUHEQGXU/nWverf71BHPXXMbNkV20SW98nSqYI7se9CyRpT7FoQFE9aaiTwYZOqck+egUsxDZXVLtN0q5aj02Nx6JpmH05t6R9/k8W61LpiH67V6B2ao1gLbg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CYYPR12MB8704.namprd12.prod.outlook.com (2603:10b6:930:c2::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.16; Thu, 21 Aug 2025 20:23:11 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9052.013; Thu, 21 Aug 2025
 20:23:11 +0000
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
Subject: Re: [PATCH RFC 06/35] mm/page_alloc: reject unreasonable
 folio/compound page sizes in alloc_contig_range_noprof()
Date: Thu, 21 Aug 2025 16:23:05 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <E2F739EA-4779-4C4C-B4BE-76AC64B42EAF@nvidia.com>
In-Reply-To: <20250821200701.1329277-7-david@redhat.com>
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-7-david@redhat.com>
Content-Type: text/plain
X-ClientProxiedBy: BN9P222CA0028.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:408:10c::33) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CYYPR12MB8704:EE_
X-MS-Office365-Filtering-Correlation-Id: 039e2a95-75be-463e-7dad-08dde0f08c84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2SOcjnvQ1yc8CYg8StAZLMCyN87BeaFK26J6AIrwdZ3OW+UWJgN801R3CUkM?=
 =?us-ascii?Q?U3pK1n+Wh7pW1XAuyED4fbNqncdJj/4gtlqibHT7kXLeav4+7Tj2LlGRwQUj?=
 =?us-ascii?Q?a3Fj+2DExo7LM5jEXZJKGjv1xU52PYZH2GrXI03bzX/3FPvKySauplSz9Lwl?=
 =?us-ascii?Q?Ab4wAGTd4ceW2WbUg1HTYrkp7zkNcm7U0fkv0RaMcNWdBOz8X91EJtE+UjC1?=
 =?us-ascii?Q?Gne7xhOI+XxFHfEP7HPu0NVTr3McSByMyT0c9IY7BzjLok/0FGqPQzuSUnGJ?=
 =?us-ascii?Q?ODP6GOisgV8IITn7xeFMdf0COYYHgykV/cxmUjQoloc6tcKOQFmu4gu95toG?=
 =?us-ascii?Q?4PfY7IC1sNdCpn6odiU3I6X09TWaOrL0FdCmJW5YlqoODFGWg4RIran3uWC5?=
 =?us-ascii?Q?cjUDAhzvss7eVYXgGcWHG0bk/0vr4umZu/OIIJXU+alepldeZYwthwCdCQuQ?=
 =?us-ascii?Q?s32bciYM5g4rvWzafzwAFKrI2YOuTbzxedOnSUJYAJwQb+xskJscWe6VDrDc?=
 =?us-ascii?Q?U3DZelFs6ijSxo0ceB5DKh9m6IcVuvpRGXcWSYLR3NazP2EROl/gKGjzIpox?=
 =?us-ascii?Q?84qEVs7ToGiARIo518v/wzNgNgToFcSkfDLqT9QuYGHgn8zB77aLR52WQhnJ?=
 =?us-ascii?Q?x500VtWduznBGQQ6a2YaGvPpKkcuaipEZt5eswX6Z7TbiySM75GnEZHI9sr5?=
 =?us-ascii?Q?63HbpLWcHe5uJj1MMENCzVCWwvmXTmbkzdyj3mz5L8Rzs4aOEPewYtrb9USO?=
 =?us-ascii?Q?M18yFMq31MxnONUsKs/kU/MDPAlQJrI2rmNyRF1Qv9BBvhziVc7ApCUKJjpn?=
 =?us-ascii?Q?CsZawx7m2RqQZfnmPPYBw/9XrKVub9uelv+6Eil+Q1T1raAzO2q6Vje3RsXF?=
 =?us-ascii?Q?h4DJcSxNW2c6vc4dscS9LoXsOGhWdBBzD6MBmXDP/ryhiLErw5FuRRfxvqSk?=
 =?us-ascii?Q?ZbAwhgD6i+sc7Kk7CgqAP5VYAnc9MojYgqzxTGmwCoAo+mTxkqOEiFRXxLUC?=
 =?us-ascii?Q?2KI/DQ4DT3cscitkbbeOpigPluGCWQpT8hoUgRKn8OBDUtNzx0Rr7bDWBaKT?=
 =?us-ascii?Q?srEHLHl8lVDZ/VW+QiEMDDZblVF29FGzOrVSz+LJ7eB8vsEqrW+E0InWZwlF?=
 =?us-ascii?Q?S6PAVUr+vvi+y5ogdcdvnw6oMyg2e+SiQZiEeFHk3aP+F3z1L3DyGZS8d2eV?=
 =?us-ascii?Q?Hdy5q5p34rKnpFJYc5HdClg/h85vOZMkrLN9K+v7MjYu0mMoX0e9yqyZkx5M?=
 =?us-ascii?Q?izWTzP0oabvbUEgFy28xJrrb/jGqFV37lczVid1sgj8KGsh/Stj4D58U69Wp?=
 =?us-ascii?Q?pbo5tGJkl15oOtSf90C3RBgABc3LC8ClNZCPjjK26XLKCVcoAKS66f0o+Iu0?=
 =?us-ascii?Q?XmPJoUJTEkNCtCe8Y+RwZ3pwV/fpSL40JS1G+uNHguzd1hOeQW/zWxC7yR2A?=
 =?us-ascii?Q?/YkNMLG5vWE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?S2GqQDZvFkJz43+K3qaGBIwLEm2BR5AOngTWzbbIW6Yb++v3CG2aApiWuoAA?=
 =?us-ascii?Q?VUvtQohyYeJknrmkTQd84aJICtjYWZp+v6tG1OQY8YCYVS/V4dBt3iL0zHal?=
 =?us-ascii?Q?96ziL38e5fhh0JUvGlDGD2vqe2V3LKMcgVgezw9OwdfBnFyUufGulinAeciu?=
 =?us-ascii?Q?fD5ju4Yj1qdodWIDkLI2fB1GL1/z4nzI2CuCqCQv54o7yGV3lg4FZsEbbT/b?=
 =?us-ascii?Q?x9WmcxZ5/L4G7LanEyKE/Ebhwl8Cd+saQ8PVubu1sftDJ6Ok+wNx7FF11Prw?=
 =?us-ascii?Q?9JnMpO3t4jyX+l4lHxAfzrB3pHIneVSXR6EMZHXwmI8iAT+pBPQ6H//ZWSi4?=
 =?us-ascii?Q?rq8AwaImlUZ5iMnO+GJEO7wcDXxu9YmIh6UaIWJl1ph5RJiDx3xPFw+cXyRv?=
 =?us-ascii?Q?BfED479qTRd4f8i0iu50CbJvLhhjDcN/an9GiM6dNlwf1n4Q4dI57ZnnuhBp?=
 =?us-ascii?Q?2LwvizgB0SlXYY6JjjkbhjjH6xp+MfCcTQx+aExSsvLjc/jj7sKwOVq4lvRc?=
 =?us-ascii?Q?RHXUKIop7tJlDJtkoLl06scUoTWoldGVgtryBCVUrNa68axTNNQAAeWYycex?=
 =?us-ascii?Q?1ZxJ1WzoQiiWobngqTFESwkivI7eQiSFuoIMMz4CFfVkyqZI26P7NGD3Udwi?=
 =?us-ascii?Q?89Ajcl3UUKdcAAS1VPDD8dalFHaUYlqQoAAiq4+JcjKbzf7+fE/sQnjyi3vM?=
 =?us-ascii?Q?Va9Ydc6dfisNr7jPt+swHml/Z6mENJSDMOcVObQWiechwiLxQj/yocfWsam/?=
 =?us-ascii?Q?kKbpOs2CmzSN9m3XvcSf/mw1GyQ/BjsspjjYgKhelPyPYYIanyPKdN9OcIyK?=
 =?us-ascii?Q?S5Pz0BIzWaNNi225F0ojJtpP9RAnWAQw80xens+/C/gDUvyNIotB/h6v62d+?=
 =?us-ascii?Q?Vj1M/8qZ/Tr9y1VXUEn8qloydfSXdH8kilS0RE+5I3zw4dulWB4v83f5Jz+2?=
 =?us-ascii?Q?iBQ9FE1xbbhszwUGeeKj7hXM7b2V1x1mAvMH1yQvXMnNaHfHGppy0wpoj2+a?=
 =?us-ascii?Q?+jNJGSm55uCBUrbBphh/VHP0JpjQnXeL7qQgDhoh+40FvHDJRNGzNuIRx8ub?=
 =?us-ascii?Q?3EwGIoDjEHMp0Kqy+jBhAbtS96mmOJVfggUncxaLlIU5TRmtGC+9eQzoFbtT?=
 =?us-ascii?Q?KFCTA7APz9/9/8JsMBvRnDIFq9IXSue5QmXn5YdrjrdR7uw7G0ppq1kCp0bJ?=
 =?us-ascii?Q?Vv3FEX1nw2HxGw4DUZ+MepLKFgDDI8RokTe70VOyypQMw4XERpAe2jFkrOV9?=
 =?us-ascii?Q?oRNuNuVi5ZRiH2HnuoDP2lIFDGcGvVflz/kXN2Rp3oD48sOBYiZGB1a+KQl2?=
 =?us-ascii?Q?P0kb3vZkqPgDwPf7Z2H4HeJX6T7X0idfZuyeWfOdO3tD5dyWB6S7axACx3Rg?=
 =?us-ascii?Q?QvsJ7h3W5Lxy9Gho4ojaPlYzzJxn3HIoKv+31YLNeH2kTrYDrR2Vsnu2ZaOG?=
 =?us-ascii?Q?sbFt2COziGbzDW87XRwXnoAxgLRtxCehUrHZbLwQDq0FUmxj/Y5oEAM0YAIN?=
 =?us-ascii?Q?0vQIrYOWfZDjIgfSEn4Zysg8Sd7/bA6MrkgiOO+IwdBJTmeALkvirhrgXOR7?=
 =?us-ascii?Q?j3Vg7C2LFLgFs5ZsH/6U0x/MjWTcF3orvpGfFj7D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 039e2a95-75be-463e-7dad-08dde0f08c84
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 20:23:11.1958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sTerHDDlxLFxjl7Sd9flN9RH1j2PaxmBGjwEz+JX2CPWfBdtkFsdyO8NMiWs1ANy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8704

On 21 Aug 2025, at 16:06, David Hildenbrand wrote:

> Let's reject them early, which in turn makes folio_alloc_gigantic() reject
> them properly.
>
> To avoid converting from order to nr_pages, let's just add MAX_FOLIO_ORDER
> and calculate MAX_FOLIO_NR_PAGES based on that.
>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  include/linux/mm.h | 6 ++++--
>  mm/page_alloc.c    | 5 ++++-
>  2 files changed, 8 insertions(+), 3 deletions(-)
>

LGTM. Reviewed-by: Zi Yan <ziy@nvidia.com>


Best Regards,
Yan, Zi

