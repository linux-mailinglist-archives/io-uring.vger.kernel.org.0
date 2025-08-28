Return-Path: <io-uring+bounces-9423-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 60B72B3A966
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 20:03:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E08031C860A7
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 18:03:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E308F2620F5;
	Thu, 28 Aug 2025 18:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="e8ubxcK8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="juWBvo0Z"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C3D23D7EC;
	Thu, 28 Aug 2025 18:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756404153; cv=fail; b=ThQLeABu3Ael2wtrncu/GFi93O3ggme46ZNqS/gnNoQYq+7U1/RYcwZlmUsM4eZRxrPkoP/z8/2GVnp5Wm6Sea6/F7mkPY/n7ZzrFMUbY2est7QGotL+u2ZHhsagYyaAw9tzuUTWGWgGaj3qSdEOakKTqJpkjTrEOkhXHPq52UU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756404153; c=relaxed/simple;
	bh=eqrcy7hvbyRg7i/XtbWv/sUYRqwgWeEmQ0wDZleDJAg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tKaAJQyQ7Waq7Y8vs5QsB3e5HMNdDdxaGfAlvkvMErSU4e/UT5kAOqUelCc6RRagVMwk6h6aFhVvPQjOUROeb0DQAT1p3EFWe/xADWK1b9NhSmK3uCZdfazKZqvKIN8g7WE/9fuzLgkuipDihR2jMVfQ0YHEtGtR7YCOIBtPC+c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=e8ubxcK8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=juWBvo0Z; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SHMpvv022826;
	Thu, 28 Aug 2025 18:01:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=7UCjMSFvgRTChzB0N4
	gM602hcPhGlG9I0mTc9bZi2kw=; b=e8ubxcK8fNk/8a3GEV8vhja9p52w41+OWK
	v58nrcWPm22JUMw4bNjPtm5fVfCQtPxAOGeVXZPseTCPiFswfRaOr+j9AMaEyoN7
	YC/rzAYpsm67TwIAKL/UikyjuRMAiX5XqIcLPJflmHpXGbwz+6vQcTxhRT66HKi3
	XEONOBSVmukeQ8p0/UhFdX7ooxpyELsfTgOeyIyYax3GTWUPzmylFNffnBGzuxQA
	O2j1LfvOpee7Z00LHM1ft0hpvTfsR8DFDnqjoH/cF7wKsqoaCTjj5mnNPi/PUDOL
	5W0dAa0Icg786+sheJB4QNKcVmX+pcQR7AdIk2N+0w6VaVp8RvBg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q4e2977r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 18:01:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SHOIvB012230;
	Thu, 28 Aug 2025 18:01:46 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2053.outbound.protection.outlook.com [40.107.223.53])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48q43c6hb3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 18:01:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ofk7bP//YcpdOX+E92VgvGPoDX+cX9GhlDR7oEmNLaVA987dpktxUwyQkmbWVprwE4ggvV4qwUOR6gMFo1g8kS6Q5N6qy1VErAz0NLuSjVL+8RkPxjdZqNhLs2LRvUgp7Ex5O9L1/flyq0uS6zvsP9d/i4Sh+OqUCe9yUDFHIBPBG2gBw2OYu09Y3v1Ce3M05x7HQyoJZI3kyYoRfp5VcQK6KuE8bvLqN7jnxEgA+wZZCWsa2y++gCvYR8PxyfjaoNrbtCyzIyPrakP34vxA8dBFp+dlYx/qEmLljH+tZgvyQibYDrrVlHbRNdz+ZbAOyzNyfMRJ9czRLcccuGQxaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7UCjMSFvgRTChzB0N4gM602hcPhGlG9I0mTc9bZi2kw=;
 b=YQituLtAyiuiOzQ64DNP6Hmlpr2xzAZAQFqqRutWV+OWEtCAbP0yr033/Iw7OfsmAcm0mNH08u2B+KgyFjy37YfJX2Qhwk7XYCs5Zm55DCvK0U9vF8/hrwATdcCcsv7h9Zw4xlL0+MpPnLom1qFXjR92el2bN95F9QhxBCCEnxbrTifshNp4w1rBZGebhymJqGnyxJc3xncfuJfq6rrRy0SemNiMsy5vPmYLdyfDApoO+czA0wPPvbdLGFYJR700ebQdt8x74gjyN8Wxt1a+Ekk39DPKUFWY1udeS6SZ6PTWTAjbrcxw1Ms3Rj+ut8uuQplKpQfwvH71dT7RAnuSgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7UCjMSFvgRTChzB0N4gM602hcPhGlG9I0mTc9bZi2kw=;
 b=juWBvo0Z+LZDVUm3vuJSQU85j5ma4nn3+FDd/+LF/6wnRSG+StIjNc4fzy/1iIpP/+YGk1mvEsBmEc5+t5q112bM0f6XD+r6lkojTq+HGIB61WrLcSSXVwjhLwXQ7wmMLC6cRR4oXIUeMHeIsI3FnqT4T0MXb4VbSo1vgU8xbPI=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH0PR10MB5147.namprd10.prod.outlook.com (2603:10b6:610:c2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.13; Thu, 28 Aug
 2025 18:01:39 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 18:01:39 +0000
Date: Thu, 28 Aug 2025 19:01:30 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Brett Creeley <brett.creeley@amd.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Alexander Potapenko <glider@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Brendan Jackman <jackmanb@google.com>,
        Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev,
        io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
        John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com,
        kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mm@kvack.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org, Marco Elver <elver@google.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
        Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
        Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
        virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
        wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v1 31/36] vfio/pci: drop nth_page() usage within SG entry
Message-ID: <1b1b425f-e8de-4760-a70e-f29897fd9367@lucifer.local>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-32-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-32-david@redhat.com>
X-ClientProxiedBy: LO4P123CA0178.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18a::21) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH0PR10MB5147:EE_
X-MS-Office365-Filtering-Correlation-Id: 2bddc756-4e68-4c22-3918-08dde65cf010
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aSmAbdtXPGNQH0L0K6KOeCB7yPGPJcaqb3+s+Md2hh3QQEFjBHH2y3dpD9at?=
 =?us-ascii?Q?50ihjT5uNIhiDUmosX4hL+pLsRrKWSNkregB/YJsSCg2/L142nw8GTsjHTJO?=
 =?us-ascii?Q?6JGJSdLpRhmMpHzqXANq9oIuNaE7CRvzrE6jEBT4XjTtQArl1UbwgQK6F61t?=
 =?us-ascii?Q?gZlUA7UJNeNZyIbJfro7JGku3gjnSwOrf57KfpALWmd3Gq8Q84iNTbq+yuYG?=
 =?us-ascii?Q?k4RY9q47TKAvsm6fONVS1vqVFAb6rfEXdqq+ARpwVWqvVwRtyctgPUxHZSpO?=
 =?us-ascii?Q?1xj3yLezFObcNE/eAUcUfQ3VuMzA/4cehwc6yiCLNmnwfPYFpqO2YwonzOSb?=
 =?us-ascii?Q?eLeGeERW26TzrARzff8BzVZy90uEiZ9NB5muFFteZkuq/u2eAbnup3Rz+BM3?=
 =?us-ascii?Q?UJK9vxFJ9ci+mHDQvQjLCu2Rlqx/e82kOYr88q7AOCE17ZCnq28wzTS1vpcy?=
 =?us-ascii?Q?RFdMPQ7ERLvw1n5g+2DR/x6wr0xm+MBlCo/1UF/FY0A57Qxbogk01WzLCym1?=
 =?us-ascii?Q?DBbOcUiW/6LZO0HaJrEkCjyrgn13R3LgpkQFg2MdKlnD1PCVk70mx+CYmAr6?=
 =?us-ascii?Q?X+zgTkIYmBxpkQqMVT+cKJo37evM1sAZenHtqxEuvsOIrmMC+qHDTV3XBeEQ?=
 =?us-ascii?Q?8U7ejHfIYbTD8JcXFYm/kIu43c5iot5xXUtjO5bWoTnZ2msfCGBmdZBylQjC?=
 =?us-ascii?Q?qqmmC05FDOkM2FzOCJM+2xlsmCEvvgOZE0uQ73h2GMyGSjNuvdWQCANKlDjZ?=
 =?us-ascii?Q?h6ODoeHByCKZQiwGHRiV3oTdp09Q8Qo4ocaXBFgAr3qZCQhNzlrvgGYYyoW5?=
 =?us-ascii?Q?VcIP2RqwvswKoiBa9XFXZmoV8Lr7wnqBvtM9SvaTw0iA5IHEBNZRU3D75QUc?=
 =?us-ascii?Q?SKVeaUT903DEawIOyr8zyyLdFebZU9sTRsDPNkn3VZ2b0BggsTIEzbpTdjST?=
 =?us-ascii?Q?c7xw2mB5K6MGNPIopWhyPeOMNIW3Yy6e9jJHnBVCEpW/zBu5owzQU0dAT268?=
 =?us-ascii?Q?O4yEFd1ZWXQtNplHQwfdx7wjjLjlHXMTGx0lFKkDJe1tCCk9jz679QjSQ9Fk?=
 =?us-ascii?Q?XELfDwUylsWL/IlqCIKN4uo6ih+Q0iaQmRAW28nGWcXS7kcG/tIie1grvpBm?=
 =?us-ascii?Q?5dWeTXK9rhGmYS9ZGBKW5B6sq4s+MzGSdtSsZb8e5L265aEAMJJd8K4RkXLh?=
 =?us-ascii?Q?2z08dSomZ/yLgLVi+r6kR7xEnsq3neGh6UNSJrA2pP7nVWTy74YFtgogzyKd?=
 =?us-ascii?Q?DLsgNpP34KZXGF1giM7lCU+mqPn568uOkMCDrzAqef7Q9QHrSfSr8pEw4fbP?=
 =?us-ascii?Q?H1R0tap8HsNdX6lratRgTDU4qBn1V9+Wz1CKdA+h+r8mbce5cr+ESZPokcZq?=
 =?us-ascii?Q?pag6JSiACRI0KoYLMBe9reG2gS2pm+saALVbSfOjjMO++J84XPNHc5RRm9IA?=
 =?us-ascii?Q?I6yA+BrVFmM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?d327opf5f5eIbF7Kn9PXshHk0HecWG6G/9WOyAAndf8TNdeolssYFBRo0+H7?=
 =?us-ascii?Q?P30LD7WX+VQBc3n3oRUCNY4bchyxrqmh/ENOyX4dbXHcOfBoFYcY/eaz3ndd?=
 =?us-ascii?Q?Bro357GQJ5MYO4w6PX0iYixMED9Xbh4KSmhUZ2dRxWOYDW/LI8zDuW09Ku0K?=
 =?us-ascii?Q?s6WvaJJ87xvHz2U+jxacJAiciUxiskNdYXWB9thGWIrhjdRbiw4oUl+tCGsf?=
 =?us-ascii?Q?BhOCFo8j2x5qfN5f4l4O9a3np3eGvpvWKzYznfNd2o6/7UVpp5a+P0HjeA4h?=
 =?us-ascii?Q?4qbIhf2OgCV2hdaP5+DLnT6mDi4WP05xdYKRmLXS8ODgmnfyob3ASJQ0hlHI?=
 =?us-ascii?Q?lgzbBT5wJOj9dU6z2TuE5y1tIvvzhiommg1UIMdFeOPRpkvzRXepEU5BBDuG?=
 =?us-ascii?Q?jqSfhMcN1GGLjfGiXwGGG8WbyVQgr8oa7IHt5fDYPmUYg/ua2J0PedIYubSw?=
 =?us-ascii?Q?YXaFPxhKbLNGpVOJL6No6eNTpRG6Pu/h/EVN01OxvO/KWlEJ8+aF3qZcUS/1?=
 =?us-ascii?Q?/6/lnqx4FYKvu7v+JEmt4mGEKOLBF/Sx5jnqR67pp+osSGhH+nXS1JAfCTKP?=
 =?us-ascii?Q?l0txEpHQxeazClZ0RIlTe7WYn6AosHGTOh89XAzDPRJpcotxLTVLEhjGfEvG?=
 =?us-ascii?Q?xxJLY6gThjznRKGjqYAJ/ev0RgnfLPtSP6Z9lEoTQlTQQ7ntBbtGx71NkSGt?=
 =?us-ascii?Q?YI06AvaZcCuM4JJGkAd/S4FEGq93E9PZFhUorfMJEzwIgIJyViKEVyNCj7NX?=
 =?us-ascii?Q?KB0IUJtHzvxVZRB6N0nuUDB+JVUFdSijUgsLOiXte1UPxXW9mTb+xONxy0ZA?=
 =?us-ascii?Q?sQpLu5Ug8/rss9dL6B4B8hO00Io8zqZsX9U4EwPEtc6FvTnpHraRxPVNnIdR?=
 =?us-ascii?Q?WDtZ/uyiB2GLMOca/jNBK5zrVFgyMgSsfyHiepJGgBlsfZ3FUp39HCA8z3/F?=
 =?us-ascii?Q?LHgwYgbilmlIaG1eTL3GAKo2WkVDnghAKiDpa3QLxjjdsehxKcv05k0nLGbR?=
 =?us-ascii?Q?pP+g++xtqmWbnO+OWmXpVCY00hvqt9Cu4oUEPWAYa01ns3ixXi6A4P8Hhnck?=
 =?us-ascii?Q?FPic8JOQ5mPAHYjI3mJYzVO6qS/kgKNOY1YlahJ2bc/bi4GIuqIOFTSwlItU?=
 =?us-ascii?Q?LTIqWlsM/87ZnA9kpCOh7oxGK1Ngt2NlD5Pp1+Nhlmm6M/C8LVW1nOhfFp72?=
 =?us-ascii?Q?54lB8srWnZl1QdJP+Xo3OOHvMV8eHryANR7ANMC12PfiCZF7bYfSY4dTbhy3?=
 =?us-ascii?Q?W0cnp1W8qST1tn9hF+AB8OMPQuxWawg+yhGN+EUsULO+0qg8yjhavbylODa+?=
 =?us-ascii?Q?iv4OvvsxB2e9wH2JnwVci2tnwc8BLidVigd28uc+SLBUQgZreYfuYwQ6h5/g?=
 =?us-ascii?Q?5NGIQ5PVJCVZ90sQQwIAVciJqvZ30zpGTCcG9zRsh23jW/a84eEphyVn5Wt7?=
 =?us-ascii?Q?3AaBO2YMIfXjy5PXm/25GiqOM0agBCCL6JafR2k+Imf0ebSky+eNgG/VQ2Mq?=
 =?us-ascii?Q?6OL0PSusWekslq0h5gAiaVxa/jchNBnZtjKCqUiRSbJ7IlhBS+1WieYPTPPV?=
 =?us-ascii?Q?+UJJqp7DJR8oHKDOt79kDU2ZjKKDkVbF3WyMey/A6eJXQzJcOItRH5Fg/IjM?=
 =?us-ascii?Q?5w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	T2N8x6plRzbsq+82EfgQqvwdGeKnABTO1ivonI7ALSimEtYHV2oVz2wzaqV7G2qHrvAFcDOVjqcYVOcrr5CaLldPRJUxNQzmr3yX/TO42jf9XJcBUultU2TOCe+JSnBLY94lCUHPi3mqeTINMaQFND4rP48J8Ypw56OY/TNjFyXc75/doL60SdVyEs+CGntbCqEoDVWAzEtA5xL4K/kjUcko5MsvvWNedzn6bYMM/zJUYRyzzMtlv4AfuBPJr2Q7jjEtU0t4JFq4ikrxvtr+wDTHysStEvHExnSmDT2lZU1+lzM4qF0nvvF0enyXBD+bLKYpbmUaB4FOLsq4Y/jVfwceZrWbltI3lw1hF5tMFWcaPN9EV62zIqXxRG/cLnfI0oPcAqUHe+YIPGEB6zo1loGEFijbptXzQT80pJr+Pa4BVqGUrL6yV7IRrb4Zll+NIJRgU8Ml/b41bv8UzUIe72cNpg0kFYrYLFrtNbTfT61MCNO+DEkrYOdkAifC5tayP3xIlXPZ46WiRrVY74rs9l/8PsoRuqXiddl3I6Oi3MAYPx3oeXexELUDxU4cMI2AyluHPW2EZGionsB+iFcJvZY6Q32ulklL1eIQuvyyR8U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bddc756-4e68-4c22-3918-08dde65cf010
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 18:01:39.6083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qqSkD3mZo09lFaVpTYMZxJSaKzvkToyQFiS4t+v8MYtF7rTxThmD6P/RcveOB2ffgAGUWiPDlLviSbNAaXbuP4RKQWpahIIQPP1WRM14URw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5147
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508280151
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxNyBTYWx0ZWRfX/TXmYD8obhuv
 Bcm7MFm6aedIgCFD5dp/Ie+CsnAzruKLtoZUa94wCxzu+l82f40OEtUR5D7j2jjIWa4IeUhrJ3X
 HZDZ2URGz1zUwX9tksS/ls3lqY5NRtinir6QuHaUKhG/bI0STq4JENASRCW9REc+NEk4s7gfBNN
 TGBmCSRhrWAgYJT5jjoqs8mmgyjTYb+Yq4UW53l7jYvAHFty5O956TNYp2U8YX1SxHvhzY1qCUR
 8hbRVbgQ+JOl3naTa2RNrzS/ZMNJxjl16PLL7DTv0lUgU6b9aN9D8Qj/xHOM6zvypTq/XtmKJdd
 PCi36VUhvVM4Id+s7/hVynn5HKLtKutWFZIgtz1qz3SaUY8m5Sm6Rz92HokWK2EMsNtUbs69HVc
 7doz4eY/8/T39Z4/VTR/NNjHPBzt0A==
X-Proofpoint-ORIG-GUID: XdqIUS537zQqNtrz798pfeyYBdYoAPqp
X-Proofpoint-GUID: XdqIUS537zQqNtrz798pfeyYBdYoAPqp
X-Authority-Analysis: v=2.4 cv=IauHWXqa c=1 sm=1 tr=0 ts=68b0998b b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=zd2uoN0lAAAA:8 a=9jRdOu3wAAAA:8
 a=Ikd4Dj_1AAAA:8 a=i0EeH86SAAAA:8 a=QyXUC8HyAAAA:8 a=20KFwNOVAAAA:8
 a=yPCof4ZbAAAA:8 a=aox0EPyTZyg_S_bYfxsA:9 a=CjuIK1q_8ugA:10
 a=ZE6KLimJVUuLrTuGpvhn:22 cc=ntf awl=host:12069

On Thu, Aug 28, 2025 at 12:01:35AM +0200, David Hildenbrand wrote:
> It's no longer required to use nth_page() when iterating pages within a
> single SG entry, so let's drop the nth_page() usage.
>
> Cc: Brett Creeley <brett.creeley@amd.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Yishai Hadas <yishaih@nvidia.com>
> Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  drivers/vfio/pci/pds/lm.c         | 3 +--
>  drivers/vfio/pci/virtio/migrate.c | 3 +--
>  2 files changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/vfio/pci/pds/lm.c b/drivers/vfio/pci/pds/lm.c
> index f2673d395236a..4d70c833fa32e 100644
> --- a/drivers/vfio/pci/pds/lm.c
> +++ b/drivers/vfio/pci/pds/lm.c
> @@ -151,8 +151,7 @@ static struct page *pds_vfio_get_file_page(struct pds_vfio_lm_file *lm_file,
>  			lm_file->last_offset_sg = sg;
>  			lm_file->sg_last_entry += i;
>  			lm_file->last_offset = cur_offset;
> -			return nth_page(sg_page(sg),
> -					(offset - cur_offset) / PAGE_SIZE);
> +			return sg_page(sg) + (offset - cur_offset) / PAGE_SIZE;
>  		}
>  		cur_offset += sg->length;
>  	}
> diff --git a/drivers/vfio/pci/virtio/migrate.c b/drivers/vfio/pci/virtio/migrate.c
> index ba92bb4e9af94..7dd0ac866461d 100644
> --- a/drivers/vfio/pci/virtio/migrate.c
> +++ b/drivers/vfio/pci/virtio/migrate.c
> @@ -53,8 +53,7 @@ virtiovf_get_migration_page(struct virtiovf_data_buffer *buf,
>  			buf->last_offset_sg = sg;
>  			buf->sg_last_entry += i;
>  			buf->last_offset = cur_offset;
> -			return nth_page(sg_page(sg),
> -					(offset - cur_offset) / PAGE_SIZE);
> +			return sg_page(sg) + (offset - cur_offset) / PAGE_SIZE;
>  		}
>  		cur_offset += sg->length;
>  	}
> --
> 2.50.1
>

