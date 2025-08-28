Return-Path: <io-uring+bounces-9360-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7F54B390D7
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 03:14:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8334E172BAF
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 01:14:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C35A01D5ACE;
	Thu, 28 Aug 2025 01:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YW3BsJ0P"
X-Original-To: io-uring@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2072.outbound.protection.outlook.com [40.107.243.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A536FC5;
	Thu, 28 Aug 2025 01:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756343689; cv=fail; b=M3iXc53sQi7RHgcZ5buB5HbD7SjGXI6Hfvn8GANN2BFPoAhSwETRq1RnHjUJ/aC+7WlmaTYn3ZwyqADMJa6Cc0mCfK2VS0SAR8+D56gq9JFYQMtoGEUGz/Js/ru1SSTkpdBW2XjA+/1nPQCw65e6K4oly416FSZO8vO66yEIpd0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756343689; c=relaxed/simple;
	bh=D27iUuuIOoaebBW0YDfSGRZ1BxCAzRgxTxKK04D+kaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Bk76zRGBi7Hx/0pCRt6J7CsOlSJHodg87M7EuZTE77vrbvjcr1HecTnm3xvaLfpIz7oQIIjxolDoYz1KzPy5brM+Vt2HknK3o4lmHPougDR0Gp0CrJV8D6dgv/hhuX6L/ohmZoPez9ZJIOzcEOd/lVBCaRLc1FRotNJ1CIdyFPU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YW3BsJ0P; arc=fail smtp.client-ip=40.107.243.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XQFx4cYMZybm2J2nM8eFTb7B1A2OEKmPLOSvRYX+cK6XqBGn25jpzB+udse2u2HCd551xV+BlxB3OZm/CiSgpTtW0X4dz5i6ZzL1TFGz9cWduwChr0+V97SxhGDSani/cD4BMdnNmmKapW5ng+hqSNgyDXZ2gpMKt3Da7X7noZxJmRDpMk+Yrev+DfTEOoGbEV67iy1eIywIT3sgsQfzVSz3MbzHrYjVaJbIjrtr65IqW3dpmkLArZRbD2TKB6dj/0lxceizjGLmo9q3CHdLNVeiLd8qPtbzwm9ds6m0I3bR8VpmC7+t1MYSxsFYwQedLQrT2Ld+8rdvijmV1rGL0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eOGtdA0Di0Rlnjn+c0u3tTO1GxdwIqcIssxc+f51KF0=;
 b=DLDCi5N8wmoNX1fB9DXvjJK2Vvp4P1BbU+6c/LQiegFQO6JRz1kzyL6AL+ohdwSOnsd3Dpb2Tk5hUohhP0pBWpxBNSPfmqwMpQkZWhsyKU4jFefO6eTBRiYTaShUwkllch7uJS5ZdpNvHCx8/r1tw/atIQtU+fBGvJUPGOW8nPlOJMc3NjNr6gwiggT47FbOxUXRuvMvrmQmVz9HVGdjPHaNeDV3ToFuryq4gCH3/fg5tFjSQvcq73EsisAbYihD+dryY7MZyOTbC3+yHGJfRTgjuqAcQSLgPFzi9B+KBaT6857sEHvdMC33EyEcizizfy/3l9I8PgHkAVkcLgvhzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eOGtdA0Di0Rlnjn+c0u3tTO1GxdwIqcIssxc+f51KF0=;
 b=YW3BsJ0PrUXgvjpil9q8FjW2Gn/+6soqT6ib+NUNZ8aUblA4WNiFQLdGigUuVpmeF3ibOmCNOdhsLis8thCHoniR7ucR470x3iwc6U2HRCwBCYMjgGd1Wu9dtP9w+HUeD6LnhlGNPinMiCk0mcwXXg6j8Tf/L3IA5SrDuTUhpd00YudO3XBsNa+yAy8YPPDs88QbmLDNY/GWKNmUB+urHCM0cFvXtvIVdZSkcJ7d4it+WPg+ID597QZrsgUsrVgmsXA8lvZYmXdlmumaQJhcnidS7svUwnizvZX7NGcv4ZSpyuGq77q9U7T2moSiCCFamYdCV71YSuRfenMZukCsTg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 BL1PR12MB5755.namprd12.prod.outlook.com (2603:10b6:208:392::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.13; Thu, 28 Aug
 2025 01:14:44 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 01:14:44 +0000
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
Subject: Re: [PATCH v1 15/36] hugetlbfs: remove nth_page() usage within folio
 in adjust_range_hwpoison()
Date: Wed, 27 Aug 2025 21:14:40 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <521A948B-6E62-4CF3-947E-17B93F524DA0@nvidia.com>
In-Reply-To: <20250827220141.262669-16-david@redhat.com>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-16-david@redhat.com>
Content-Type: text/plain
X-ClientProxiedBy: BL1P223CA0040.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:5b6::13) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|BL1PR12MB5755:EE_
X-MS-Office365-Filtering-Correlation-Id: 13406c34-d33b-4262-f00e-08dde5d0456b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DQ1btIH1/OU0LfcBm//weklucY7uq/JeyjMqxcSb9EijXvlcjUuqBhorQIYZ?=
 =?us-ascii?Q?wi9/YNjAZxRzJPNApKGUHGCXM/9JSlamXQJO8sotiqYE7qSCGCe3Jz1MomHG?=
 =?us-ascii?Q?sbz9VRlWRUcIEpIkmcDQQgTZq1zLPQNf5fe/sS2JtexkUkL/JAE51IQP+xrH?=
 =?us-ascii?Q?kYiX+hynt4rFmbEFbvlp5PKQYmn22bBwNKfztufgBA5n4kfc3++W5i1KshL/?=
 =?us-ascii?Q?QEJnCmy0NRvPDUG3VX3VH3YmGD6CVwqn1k6IxvDCqWNyAHH4O0Mfb+bG4uWr?=
 =?us-ascii?Q?fp4smFq0mSDBOKkLZ9fcmadnQ/Cv8I+F018ESB1ycQvKxB7Bn+JKHmOsmDK4?=
 =?us-ascii?Q?IuI7KxAftQ610wUj4X47KmhmMYDSqwrjf2QjgFHuR/MrFckKOQaPB48mFfC9?=
 =?us-ascii?Q?5KefS4SiTHn0DazBnCW07EmpV9FwVgqmLR3ozCVpceCwBdQ3ULlutG2xlEjY?=
 =?us-ascii?Q?feoRu9IJrZ4gudvYvcKYvKj/U1f6q4/VTzarWQTnPxPqtvRM4e/2/zoYJpx2?=
 =?us-ascii?Q?P4EowQTkvDe4U36JRYwMfUvzAF1gerB8I/+Xp5F8J7nfzEz2TgvKzzhX3CT+?=
 =?us-ascii?Q?hJmM0qv8lQmL7kPA5WIehwwZtGrxacwmOutUH9W4S/Bi8kyhMIcvE7i1bb95?=
 =?us-ascii?Q?kf8TxAg1kKXuRxNmff7Y9vw1IAj0/C1HOZ7ubdGU0M/4dZwEJ+MuBkHHJdUl?=
 =?us-ascii?Q?/xhqwW3ErzO4SAbJFaX4UmgTTBeY4Mp1tlGPgNRB2gFKf9wC6NsHhO4D0V2d?=
 =?us-ascii?Q?549v7PasxnI7+hcEY0Hzbk81ebN5g1OyVWoEkI3D9L1F2XPd3WMDeZO4cXxk?=
 =?us-ascii?Q?UmGIG2L3qdSxDjZe9z2wAXWVPfGh4BkzA2jh1ME3MPAJ+EN/nZ/17qy7de7o?=
 =?us-ascii?Q?aViWzhZw563mM8MPd+PYOMJ4blBfLdrwsUNj8cvfgQxPySXR9gtSYKRqXMdI?=
 =?us-ascii?Q?C2dLUwF6gQO/Ygm4w8wjKIhYZSQt2k6xfusSAyfsaVGWAWW5MMLnQMSWZsAn?=
 =?us-ascii?Q?hlZzX3bz9aTj0m3rQoQLmvz0VEeeuWJgj/U7AbXFXeQwIplQea50uOO9tfI/?=
 =?us-ascii?Q?fx59KfpniARPlFqB7Hv/47EvTGFHelgE7ggHPtEse41ES2X8AuRCdohShEcY?=
 =?us-ascii?Q?+WbzyfLMhqDAJ3V289W7am9gQ1vnZzExNfpaJNXfrh7DccgprPMCD5JwgyXu?=
 =?us-ascii?Q?bHmVHAqRPZjouFsxJ09T4E8Vf2wU6XGs8vmGHomnOygyCBycgy3x5Noa1b16?=
 =?us-ascii?Q?77essKYfv0+dnBdB19RLhXOPtg1epxRoPdUV41u++LejZb8QTWAfN4pzOgE/?=
 =?us-ascii?Q?hSnErFsVeESuFm6pf1rSdoAlXnMaelnb8NkWWSfokaIpnAd/SenvaR2moysO?=
 =?us-ascii?Q?D5Hk8oZkD2P2HjG58++yfxH431r+gXcMMc3SdIQtQv1bBQGq5w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FK7IDYCXKu8JNi+OBI2CFu3IzqBv3kCtXf1uoRLlTqr6hQUDMPOzwzshdiVj?=
 =?us-ascii?Q?abJoYmGiIztOdTuV0BiHcOnpSEN9uQmncrmId9zK/3dB8wIAWHEVEq+4kGNV?=
 =?us-ascii?Q?MjRwGA4sS/9JZl6levdUChRbeNTb9+leafcNhT52JlUnhGfAPlOZct9SKcx8?=
 =?us-ascii?Q?2ipAJscc6pggZImgo+ZuAhl2x1K9Sj8XyMyIIHUGdnmW1p2yRdkMCNEHxeOL?=
 =?us-ascii?Q?etELJoR/SbX2UCSu2q/6fF7Q+19EG8gacp5B2qiO+ylbS3BDgYMMWN4IqfXx?=
 =?us-ascii?Q?HnAOXKBVraAC21CREORzTTlwqCAPKvFjYl3ws8q9kcXZ15dhUR3nhz1xrVoK?=
 =?us-ascii?Q?pLVwoauuqo3U2brn1gErB6S0ocRDymZj1o1gq1XpYmWkMTRpp4oNuqOnroZG?=
 =?us-ascii?Q?WXe3ji+Gi1M6YGAKSD07t94/jyyia+o0msMEBUxxlCPTY5p6nlJ7LxUmhBea?=
 =?us-ascii?Q?16CvUTCOfP8vjwJOejO4cPC/i89bCXuLw3iViwh+ryIwELip7tD0vxI/vrGZ?=
 =?us-ascii?Q?/AZTaAEFNrng26VVHvNoJCoorMRFCWuSFVudz9c/Mvekwrjja0fmKIOnzlzk?=
 =?us-ascii?Q?ma/Zkrgx52V/r+z5vtvJDrYWPcj8QdSB1TNjn6KuGcuVMQtE8i6/jOPTFcVm?=
 =?us-ascii?Q?gfUlqNDLAmsH7TlZnfsunEioPrrHR0WQt4ZgeaP+/2iY6ihf6lMAXMm0mELc?=
 =?us-ascii?Q?LCg2S5SdiOkb6DxJ/tdEgE94OaIQ50qFZMAdm7KxFREq/GuTdtKoAsviEw/n?=
 =?us-ascii?Q?S0J4bepq87omKUhD44Jio3P4c7UrZMOAd7lFt9/MZa6AmYO8VMr9M+xoSixK?=
 =?us-ascii?Q?p2JhnQHgPFNWdYvDAOff3ZJeNEQDgBsZvSDyF9y8Jf5KwQTx1v8bZnI8l5Px?=
 =?us-ascii?Q?5IRcCqJKRhAl4iIZ3v2fCmibSyr8QVVK1Qsa1h4Hi3bz9kMbUXL9Dwa1rgbT?=
 =?us-ascii?Q?yH+fQSM9W61yrGfNVSdA+kZBqIDiGnOcByN3wZVoKy4EfKKF1S78CiMegQvb?=
 =?us-ascii?Q?754zXlpR6C0k4F+40gXDkWq5RbfkFgMB96YQnjGREYE5qt46T8eSn6WKvwER?=
 =?us-ascii?Q?D/VU4RIWd+bghsp1XdyhNg+11O9L9Y/h7sf21T1v3hhl1Qnd7hU1Zeiqsv64?=
 =?us-ascii?Q?J3C/G3iGyjxz1oW1GdZpLj+5Pldmog33KnE1fg2d9fOl7b1OgBz88j11f+he?=
 =?us-ascii?Q?3ImiKvfcsHoNdRrz6ah8RENMBf0GioU4DeTgCxbPyOgvpLPtVXPcHppEZkOR?=
 =?us-ascii?Q?CbcTNuyhfaK644HlSxP36ea52+NFvBbnQ1Hr+d6PAaD7a55oze4qTgBNikxY?=
 =?us-ascii?Q?4/WjA6tmAjROPBPnqDYFT4nURLYuHAPAS+NXXQXQwlp+hG6av+f/QPgT57wb?=
 =?us-ascii?Q?CJo152MrYeaAackX6awBw2uXR2d1frds2V3ypnXY2XgDfIVmv2ao/mRKG2+r?=
 =?us-ascii?Q?DNLovNDAJjNmRUVCQoSpW+uQPML+jUTWZKk0Zt0Kmz01BRFjnLp69CLOcKwx?=
 =?us-ascii?Q?Lfs3xuJWP2XmOkEZ1uRX7+M/qBKXTgHOi0HyJbns7cM10P8CqdTyeyEbv92l?=
 =?us-ascii?Q?WNt4PSAl8p3ZaZAJuGc5dRpDaGOIMuaf8ox+qtmV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13406c34-d33b-4262-f00e-08dde5d0456b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 01:14:43.8835
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BWNOW8xk+ahrDJdsv+KB0H5muwq4mEATrKm4/WnVLUKR+GfC6TiqXBhYaTVsXER7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5755

On 27 Aug 2025, at 18:01, David Hildenbrand wrote:

> The nth_page() is not really required anymore, so let's remove it.
> While at it, cleanup and simplify the code a bit.
>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  fs/hugetlbfs/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

LGTM. Reviewed-by: Zi Yan <ziy@nvidia.com>

--
Best Regards,
Yan, Zi

