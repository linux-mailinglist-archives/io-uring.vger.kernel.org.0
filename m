Return-Path: <io-uring+bounces-9232-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B37B7B307DC
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 23:05:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1524C1D204DB
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 21:01:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 522292EA744;
	Thu, 21 Aug 2025 20:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZRAMTS8I"
X-Original-To: io-uring@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2072.outbound.protection.outlook.com [40.107.244.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86FAB2D7DFC;
	Thu, 21 Aug 2025 20:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755809762; cv=fail; b=ozJa17PFi1PKlfmfSCMU5Vmkm/ENTFAU2yrknlt9fuI5Ezm7A6cmAApCXqU/i5xZO+QsLvIChFgu26Tf1mILEVJ/P5J5v4V2zkJ9F8B+2BRLfxm74GvGZ4pCNUEiS/mqfma48XIPxlIOKAKY85C7vFKqXdSkj3ryU+jBRis63ZI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755809762; c=relaxed/simple;
	bh=xDAtmMZjC7n433YkNuIvyMJaf0FV+tB385V+pb5tmqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=e1SWUUi+FY14z9eS/hTlaTTDV8EtNa4iNINqLUP9nJkJatJ/UKNz9tcOG16iDolYIiGVRnmYU81VKutGYqczriHAIdH1nji2k7j4y2XGv0CNuX7ala7pPkyOQtu/fjPe1WqhHl8XoOk5bgeu4dZGiPFTQ7e38Q8c7Rhfb9q6pyg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZRAMTS8I; arc=fail smtp.client-ip=40.107.244.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BGtO701Wpp3SQ+JSkp12FhJBwkI2qSfgJktct3ITnhgZBnN0rsZyHsVHVxvjiLDPOEPrNXM1FygvVPiZEqoQPWVo0M8gYBbbkQDuRfQbS5KBJ7TLweeoGkvYJm+Bd8LAROewGgjaork/dkQUpTOEbPYAMWYzguxuuxAX0RqpL5vF88gROU301kXFUx8CHSCdST25Tqc8QQFMLRH7Czsl15KM1izzNpJ15LXoYlOnGDJDwWTTDjKMdmI9I/zp7fLyCw3JFtv2ClUtAaI+FN2S+uwfqHznJnBZRnWE2RwPe3ZV+n4DnJaB22LRV/xpaj35dbxxhgBxDM7qKdumfO6EuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uD6U2yYEcuK6Q08U/iYV3O62S0ShleTOpomGqDgXsYI=;
 b=PleA2I5UJoDSA2Bvc+l8O3eT6+0DyyMoq1gnYvzJdedWt0Kbaqo31PGHgN7+9tgXTkUC7uPPMJGibIDUazLnaC4oZsCvtA1y7sErGwgw3/tnhwYXmyja8Zuca6OQoAfYRuIMfySwrpU1J6mQKi7AwtlQI9SMLbXCEUkNHSCw0WQEHL9HlgrFDFrHXDn2bz2mJDrT7WmyiuEGSEIRBLPHv4TtgR33lkUE95ef0Je6OtL9FgR3l8QyxtYgK62vTPYPJ5e5DVyG9JVYfJDnM5gwbgezuALaMRycuDlX5kyQHghh+sJGC3z39pnRUceFeXQXJhVRrUPcwapomRxmu2YHcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uD6U2yYEcuK6Q08U/iYV3O62S0ShleTOpomGqDgXsYI=;
 b=ZRAMTS8IO1yvquvWwj1YPQ595GciHz04wjKHRcsg9grLd7zAPPKn1iLIS64o1ivjeA4xfuM6AEsjAWlD+gKgN4GKecIQsidbTm/C9peywSn4pTSo3+Y0nDgmzlFnc7vJG+L45Sq98AncL9N7uLz3mRvI7tbSQKYcz40fYwYjL0hQ1Qi7hT8aqf1YrUjXlXLe14/HEbU5tsaM3qW6jDVS3ca2s9gEHd4uJHxaJOuNWdHSHT4rnbgiTkGKLy8P6opCQO/jlik5b66u8AODXMwbImBsUVNdl8GN6FukYZpjtbZUjKBVFIRsB1/lBKLvhvlr8hUttuqdYx40v1+0MTwVPQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DM3PR12MB9435.namprd12.prod.outlook.com (2603:10b6:0:40::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9031.24; Thu, 21 Aug 2025 20:55:57 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9052.013; Thu, 21 Aug 2025
 20:55:57 +0000
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
Subject: Re: [PATCH RFC 13/35] mm: simplify folio_page() and folio_page_idx()
Date: Thu, 21 Aug 2025 16:55:52 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <E1AA1AC8-06E4-4896-B62B-F3EA0AE3E09C@nvidia.com>
In-Reply-To: <20250821200701.1329277-14-david@redhat.com>
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-14-david@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN0PR05CA0013.namprd05.prod.outlook.com
 (2603:10b6:208:52c::7) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DM3PR12MB9435:EE_
X-MS-Office365-Filtering-Correlation-Id: 53f644a2-a6e9-425e-f5ac-08dde0f52088
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SLASAnWO5dsLJrJaGcvQK8asVFX5uUU6DChGG8O74SKblEWes73GHfSEq5cy?=
 =?us-ascii?Q?5Jsbz0OMROVpE9y8CEHztDg9Vz9/3Q9eakouNUIaZnxCuAUGA1b8rOopJI2G?=
 =?us-ascii?Q?QqjMZ5JvUQ3ui/vYkjjwylsH4eAhfKQjR7oBD7+yjs7bXFu1hw/SAXMes/uK?=
 =?us-ascii?Q?mnUsSpTbOMD/oMLKkQT0J6/7WyMa3zF/mIo8RjMYcskl96e/hpdVONJOYeQR?=
 =?us-ascii?Q?oCwpWnGlrqZ/mwF2Sqyc7+tZV6qSbIOPGfV3L6sogjJbNImuV1jVr43JJMVX?=
 =?us-ascii?Q?8kOrN/vYfGQV7wwX5C0RlDJyrzsdekkt+xTrArBx7IVRA/xrImmyLtV8+PEI?=
 =?us-ascii?Q?FfUj+TFTWkXufCfGS8c950TIFJPnH1Dxt3OF3Ar3V7HS1RZul7ph3y7FcOrQ?=
 =?us-ascii?Q?ngUOH7uGjJV1/xjw3bPFYEtxcYOGcMwuYsQii5bU3g4oDOX61/EKKVF50YlG?=
 =?us-ascii?Q?raeCrN2i6KYXwHqRfDHZtTT9D6JGRRdcG1Xf7xbqWg7+bGPCLh+TsWvbkTy4?=
 =?us-ascii?Q?WHiOwVrr90S/zev7FmHbk1aRKkEE9bmsr5EVenGj7jUdX/w0og9VhvE8T//B?=
 =?us-ascii?Q?Zl/Xzb4DqvzlNlDSijTxplTQaSVGsyjQzYJlPsAiuM5kGC4L2Ssph6/sE6jc?=
 =?us-ascii?Q?+JgIyDYqfABy1McMPqEMGRm+Rql2vyVpr9vk+a/DRHdcqYuZrFSi6qsA0c7C?=
 =?us-ascii?Q?WKQt78MmjQmozUkCoTFaK8UfDroi1fu6PzYebdu6/FkcgjVKwS9Hx0ypLn0o?=
 =?us-ascii?Q?2dCb99incVd00aTYigJE/C2Um8YDQSEhd0GbXMf5mdpmiO51eTaH4POmvrey?=
 =?us-ascii?Q?pLrwz4VG8AwiOtHXOsGkwOq4yKhMUjyCZBRnpOhLt9nXwM/hPjhb4ZqiyVN1?=
 =?us-ascii?Q?TUTW7VFsA98GcuJ2RZfFtZKIll8BJ01lMikki5R8ybxikLkq6XtMUbkvqNMX?=
 =?us-ascii?Q?O2HhX9W2HaLsCnmVGNVeMrW9PNBNREZke58yQNg6/hlUMyzCo7+p2NSWUsZS?=
 =?us-ascii?Q?DJthMMa9qbnk2fHL5t4QnBOGtVXfqeQeqlLVXmt+6JV+Q2rZx6DPw04B8v7a?=
 =?us-ascii?Q?6mvjy0LE+LWRG10EaUk93JNqsRkuAA+vOpF6SC2qljzQ5XdC441g03scFcoi?=
 =?us-ascii?Q?P3jjwFaIZJeCoSHkBGiIarnL2nrtDi6u6bD34WtJzRCukFxhSF+PX9zJn6lJ?=
 =?us-ascii?Q?ZAVFD7DmL0c4lhpAyAUtrdHTP2k9LkFjbXxCZHPSzAn2O/C+Et8g56oBXUzz?=
 =?us-ascii?Q?3nFGxQWArrbHzzhw95y6cGMrjzZthlczlAsJhMAE5JXS/lb/1kRCPKWvQGMu?=
 =?us-ascii?Q?7yvxHYdFAOzvhZdRjDMQUC4+msaBw1PeUr8/Icqxq0ozboCK4FABZhppSFJI?=
 =?us-ascii?Q?Sg6H7OA2a+SpVufQ33b1aDFdmcyzvXzDcFIieiwYsICuwdrCebdlYSR63JqR?=
 =?us-ascii?Q?F4Q0HFqgous=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GCW3TSWvDDZgtPRu0mapa8vVSPYB0lARyPKCbDeWnthBZKcVQvKVJDBEuDgT?=
 =?us-ascii?Q?OH9lwPa67imtbAZpYy+vp4DVuPjsF0rZaO72T8QRQjn6+CYzHTzMqEbT0tqk?=
 =?us-ascii?Q?9ViWOdSuFUtXntkPdm47L+HxhOLAuXVTR4nTEmx3MpDi4hqLDxhbA/61fnBs?=
 =?us-ascii?Q?hhN4i7ESnS54wzxChkLwiTl1R6SHKdCF5kUucT9XJ7YvIFe5KXFfzenits3J?=
 =?us-ascii?Q?TbeTCmZY+DX6g8MCi5dhLwZeVwXpxPZpwuHDTJegZ+E9OwBsLYKUwKZEEFys?=
 =?us-ascii?Q?UL+RFy2sArsjRv5F+vs8ZMjuy8WIQQssYiyf8AdHXmRfO8LvYvy6knWqUqtK?=
 =?us-ascii?Q?084R8z1rKGvw9kR70ZpYqasX/R86HMkK1aBp4uZO61CJjtGI0X6ndAw1TD2c?=
 =?us-ascii?Q?ZBg6p5cESNvDK0riuIMTmfUjbxi7zmaLbJpO/Z9zycx6vikb14CM/MJSemOY?=
 =?us-ascii?Q?ncNDBbAXw4tJoI/hSCkcTaVSUTaRsTnY/Gwr/NPou7YJAjuksXi8nuVviUu6?=
 =?us-ascii?Q?kj3al/GAeElizyH6e8XxRzcPRKL/6ZRkWL5haduotRyR4+Y51LuuOHfm8UkZ?=
 =?us-ascii?Q?nHsXhH0Mz7FT1LNUuEX3rk0VG0bDPS26oH2FPLPJjNCAfbjI04Fxt0Lem2I9?=
 =?us-ascii?Q?IbLwTDQFoZNCxijpHYeVmztjLxHY+sNXQTqwrE19WQgsOZzc6cylv0TOmSmi?=
 =?us-ascii?Q?KkJHT4q0oA8V7w1eoZl4r0vn1Ug0EqZ3X4FrUfpVu5R8tYfst0DAoHmRvSBy?=
 =?us-ascii?Q?x10cHiEzDLPP11Nx4+o3EkABxq/IsMQRLoVBPIL4V1DqBTn488DX2Yo7Cvv+?=
 =?us-ascii?Q?0T//OE6bTA5vG8c5qEgpAin/J3SYcUCn+/g8As009rDrZu5l3UjWbzboRBYK?=
 =?us-ascii?Q?SFnoLevLyh8N+5KigM7Q0IkyTVNVC6ELt7VswA2FMAWVxY3AVgV/8svceINs?=
 =?us-ascii?Q?pMDtHDeomlH2ZrZcQmR9+Uid0dQL5JkRnN7g/lgzh++4f9hR5mDIUOmev/o9?=
 =?us-ascii?Q?E5V6rC6h3FKsF7GSOFVkoNr0UaVnVWUCvc+jFDLnAsObwxzq2AW5rzvrIFm7?=
 =?us-ascii?Q?AFXxc1LNuTXYjKDL3NkO7d4vwnm5GaN6Nuj1mV8MMoUn4pHyh6iodeH1IlQL?=
 =?us-ascii?Q?IVPvevRSZXw7FH/nBMbi4RnCfGJCBgYy2KvmJdBNCzun1o02laQrqZDigbLa?=
 =?us-ascii?Q?zuWFPQQB1Ky9GxS+c/uj8rBdD3sIeyy+Lq5oht8bPLy9MX3YaUkB+u3/0HJr?=
 =?us-ascii?Q?CbVlAcRsTCIAHGDXlefu2u+y5He9/s9YB9vNRiKMN8W+bVg9FORSWy1jsJqh?=
 =?us-ascii?Q?cXF99coGunlp16CeSjPuOfXXoizrD69nwrb7m3XE3XiYbU+RXVR1QDlGBRqz?=
 =?us-ascii?Q?ad79/45mmr3x/7c74ailpgNZoag/C2hzTkfNsQWkzAcSXZSojRYB8pSpYMLE?=
 =?us-ascii?Q?Ci4i/fET8pFEtYTlhp70B+rdXmXT6sVvCAx5Z0pKz7/56YeRfqf7jfs/f8tN?=
 =?us-ascii?Q?pyP0zzE6EZ4PJgwJV79mwyghO681WwuqqCN5B0hIBV9laUYEWlwHFXWRnaRu?=
 =?us-ascii?Q?9wqyvmGu2ju7TcU4mKnUrDeFknZdseYHpIYYwFdE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53f644a2-a6e9-425e-f5ac-08dde0f52088
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 20:55:57.5860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l98mhjCEPP2PIcqstFN7T4wAHLpAWbpLGr/OMjiznshiERwmm281INsYH3GPRneT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9435

On 21 Aug 2025, at 16:06, David Hildenbrand wrote:

> Now that a single folio/compound page can no longer span memory section=
s
> in problematic kernel configurations, we can stop using nth_page().
>
> While at it, turn both macros into static inline functions and add
> kernel doc for folio_page_idx().
>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  include/linux/mm.h         | 16 ++++++++++++++--
>  include/linux/page-flags.h |  5 ++++-
>  2 files changed, 18 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 48a985e17ef4e..ef360b72cb05c 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -210,10 +210,8 @@ extern unsigned long sysctl_admin_reserve_kbytes;
>
>  #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
>  #define nth_page(page,n) pfn_to_page(page_to_pfn((page)) + (n))
> -#define folio_page_idx(folio, p)	(page_to_pfn(p) - folio_pfn(folio))
>  #else
>  #define nth_page(page,n) ((page) + (n))
> -#define folio_page_idx(folio, p)	((p) - &(folio)->page)
>  #endif
>
>  /* to align the pointer to the (next) page boundary */
> @@ -225,6 +223,20 @@ extern unsigned long sysctl_admin_reserve_kbytes;
>  /* test whether an address (unsigned long or pointer) is aligned to PA=
GE_SIZE */
>  #define PAGE_ALIGNED(addr)	IS_ALIGNED((unsigned long)(addr), PAGE_SIZE=
)
>
> +/**
> + * folio_page_idx - Return the number of a page in a folio.
> + * @folio: The folio.
> + * @page: The folio page.
> + *
> + * This function expects that the page is actually part of the folio.
> + * The returned number is relative to the start of the folio.
> + */
> +static inline unsigned long folio_page_idx(const struct folio *folio,
> +		const struct page *page)
> +{
> +	return page - &folio->page;
> +}
> +
>  static inline struct folio *lru_to_folio(struct list_head *head)
>  {
>  	return list_entry((head)->prev, struct folio, lru);
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index d53a86e68c89b..080ad10c0defc 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -316,7 +316,10 @@ static __always_inline unsigned long _compound_hea=
d(const struct page *page)
>   * check that the page number lies within @folio; the caller is presum=
ed
>   * to have a reference to the page.
>   */
> -#define folio_page(folio, n)	nth_page(&(folio)->page, n)
> +static inline struct page *folio_page(struct folio *folio, unsigned lo=
ng nr)
> +{
> +	return &folio->page + nr;
> +}

Maybe s/nr/n/ or s/nr/nth/, since it returns the nth page within a folio.=


Since you have added kernel doc for folio_page_idx(), it does not hurt
to have something similar for folio_page(). :)

+/**
+ * folio_page - Return the nth page in a folio.
+ * @folio: The folio.
+ * @n: Page index within the folio.
+ *
+ * This function expects that n does not exceed folio_nr_pages(folio).
+ * The returned page is relative to the first page of the folio.
+ */

>
>  static __always_inline int PageTail(const struct page *page)
>  {
> -- =

> 2.50.1

Otherwise, Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

