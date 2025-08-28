Return-Path: <io-uring+bounces-9402-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF39CB3A350
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 17:02:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1B6F27B7E19
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 15:00:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5816823E356;
	Thu, 28 Aug 2025 15:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pCu3UfkZ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="KfuMt81Z"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73911214210;
	Thu, 28 Aug 2025 15:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756393311; cv=fail; b=NxXnc6hgtFQo1x5bVHKQdj7CRYfYZc6K7TS7j95lRQcWEx4QcyFGmtZ69+DZEKpEr0+LEeN7gtEGqvVHrfYI02l84qwUUzFbEhSSL9Zgkipy+rPLfXqqM3R2fJEWmQydGStGAnJ7G17PPzOoQEQ7BhktIioAcYpoDTnXqvmWq5A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756393311; c=relaxed/simple;
	bh=d1qOLYIE0ce/fD4Jpv6nHGFQQEubGyqwipf7RkldXmc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=VhLuhIWEAdWrlRknH86jpO+PQEVmvSf9hD8z08/pfo2Nj4WCsLKkOSk4FaCl0rnb/fhFKvlquTYTExUUvb02UfgtuCAh5zVYlE91N5xawcAsNxtbZmbZHsbtjl9RVnxwCtjeI9//kx/gTs4CAskRhGcTmaLHk8nBNcs0Nm0Kc3Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=pCu3UfkZ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=KfuMt81Z; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SEN8MS031320;
	Thu, 28 Aug 2025 15:00:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=gh0s1pep3p1Ef05Yk6
	agcqIM4GTdWmOJhAIw1GNk0g8=; b=pCu3UfkZauZdlA7/3XuoK2xSluznz7EgZ/
	46pqgKEaqMhuOmb/AIuwaANEdOj15msgJDWZN/SMXB75+qunUi4v6ctf1+0C91ly
	Mn/y8M1GSpiu3/LfFY6Fi7uGE2KRUtrxh/nXoMBw2Cs4TPHyrv8IdXa28pVxuvd6
	zY9FeCMjyjDOFdeBaBdHLJvVyCIyKHXZu+rosBR7GFt5qq8Ik4TN1IZGrBmoVrJT
	hkU2HixCa78PY5w6Nv2MRjIO1BK3aPSIjOmZX31LncPU24JANC8Cx8L2bTd1JGxF
	AF7EiLzCijVTxC6XH+Amjsj0ddeyehgm4xxp2Ar16jFHpNDe9BHQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q4e28u5t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 15:00:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SDuu9m012211;
	Thu, 28 Aug 2025 15:00:47 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02on2044.outbound.protection.outlook.com [40.107.95.44])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48q43byh0q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 15:00:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sPnz75ZiYIXoqJNBRosjX6QQ5sWHZCShx8GLcjAVLHTpurq8a4SfMYFYdn1eMr+Cr0QE7XzLcHJvqCFMBITYl565QSwb3lCcCMPoSChqz/cQN17PmDsExHWISAn8O4p9xhUXRA4En5JfQBXM9Q3f5w3HRFe94LohuURoZhM/fHQfVU09NnewHUoe1UdsxXJk4D8eYsUVzAU7V+q2FgFSdOTaVYtN1s274eIRmh4CQ7+bONeoE68Z+RDm8zOX5LGA4lKb1spUqA8/3nVps+03RoPHdJwVISmC/xpEgYRQsx4sJlWjwZOvjUXbK84TxYJJIkc6uYuTmKK2AcKYx3GMxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gh0s1pep3p1Ef05Yk6agcqIM4GTdWmOJhAIw1GNk0g8=;
 b=DOxoxG1MrOKpOXzByQDLhwOIEzaO5DOlfrUxzoKdTLX3UjJQdgIvNNHTLzECOgY6HUtwaAsyqGfzWcouM5FgTu+stHj6BIxNVJ8ZgFuBwSAvD+PBnCpNkC+UaUwUogYTFWIQBSXlRrBYQRjfiLROHXj81XPFNlQV0P87NPAU4HvoNfV9780sizdo0dgZLyMuQAP7RSwCYB0/5GUmRE8l9L/Yx06fdjnl9ETq2TMqURvfelm2I4NBlw1Q5Ey/ahn/S7r7D1gwwIzCk1Z7tv42Cbm5eNZod5x7OUYwcoDsSV2ug8qMFg5QrEv1eYpiU+6djBXrlPuHCy+NcLqZjDhnuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gh0s1pep3p1Ef05Yk6agcqIM4GTdWmOJhAIw1GNk0g8=;
 b=KfuMt81ZWmjnYqfjGUHr15dVtkVOsyhgmYl0ORWvjJzoEQdjMzCGdDVJmxcQUvdmesjypMrQKrAbNgTihFVQ1ah4dHEkIOhUJBwnEuvtBn7MrMJg1DaiLWvt1s4/EXsN7hlOIRJ7nicL4wvFAoi4U29svKSHshtZxzHTKk80vp4=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS0PR10MB8173.namprd10.prod.outlook.com (2603:10b6:8:1f9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Thu, 28 Aug
 2025 15:00:40 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 15:00:40 +0000
Date: Thu, 28 Aug 2025 16:00:31 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Zi Yan <ziy@nvidia.com>,
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
        wireguard@lists.zx2c4.com, x86@kernel.org
Subject: Re: [PATCH v1 10/36] mm: sanity-check maximum folio size in
 folio_set_order()
Message-ID: <f0c6e9f6-df09-4b10-9338-7bfe4aa46601@lucifer.local>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-11-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-11-david@redhat.com>
X-ClientProxiedBy: LO4P123CA0353.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18d::16) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS0PR10MB8173:EE_
X-MS-Office365-Filtering-Correlation-Id: a2e71c24-3e93-4c12-b9da-08dde643a747
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BtUUC5aiTA9aeWOI8NZI22B06kRUU8QaYE/9DyMmZc+vXjZxVGvlMw31A+NK?=
 =?us-ascii?Q?rhQdgNqIGAD8+eOACi84hLuX/rQBS2LvO1ukPwhLp2aAWeXEhiAf0eURQ8Le?=
 =?us-ascii?Q?hAallR9WH93NWeEExo+fFCFUb58lzSh7QzBrYE3D6gRGLaHd9GEnnA+jdJrb?=
 =?us-ascii?Q?EzBdaPZxZpVpg14IqKzHuaq40zSNUgrohVkaZR/HVmak81O2BicxTf+Isqlj?=
 =?us-ascii?Q?4k2LTcYfvDnwKFB6yPK/hm+LTfM5mbZnCvmU38km8mBioqfZNOHwwhDyj7wc?=
 =?us-ascii?Q?Ot3kWop6Q5nNAMUvdX3pgPjQgTlM/OR9kxU1/6e/Jm8pO4ajVIjmdzS/4Bdo?=
 =?us-ascii?Q?DnD3BT52msdKRsZrEG8F2SabgfvL8fHaLwdfzu5TKNbmyxcAD3gUC9GYfBf/?=
 =?us-ascii?Q?27vA/kmdKA2Oo/r7UTjdSpN34dJe1jYqfFUB91yvExIRldwueLY6LLHJgfH7?=
 =?us-ascii?Q?ZWspXfwq1VfiThsTuJ76H5pijXgLK37pEBeDO57RBDLXQ4Fj8iau3oaZEkLB?=
 =?us-ascii?Q?09+c51fSwAUbsUKUkhpadrZ+Ep9HeZVq9EvyBrluf+JNVG65Sy7z7Xo6Nr6A?=
 =?us-ascii?Q?88V4Pa53c6XqDUTYFpyCmbCtIUCn8bG8PfUmS9gwanRd0aDbMOl6zpWNa/Pi?=
 =?us-ascii?Q?2p0LNvhVG3177elOBF6EbsZvIebk6uuCViTZjbJq27UokVGRynt+lJpLgNuV?=
 =?us-ascii?Q?YjP0v8QZbW8hzPqohA8iyMCvcZRhK2uJbOhYtjzvwwvlnpqGeV00rq37R6VH?=
 =?us-ascii?Q?R5dJ5SWSQHvqSeLTgGCNb8M5F3dMRiS4cOQoEzmxQznyuZVHU+gbEBoGdWwQ?=
 =?us-ascii?Q?NG/61TY1yk2nVcdoejePgRbxRC02CoKjxSFuiOv0/xAA89uFlwSSICO48+cT?=
 =?us-ascii?Q?37Ipw+KJoPWGjpqasjQVfgdlLZTMZICpStOmtgl2Zw2QZoTGhw9y1kGLhiU3?=
 =?us-ascii?Q?rNl7YH3C/htf9gtFTkzUZ2tr/1eRxy+tu3E+fXLP3VwveVmNpG1wzOGoDHTf?=
 =?us-ascii?Q?HJ1tCQ87DZM7UY9CqiIgdshGQkK/7JXUzOQPMj19yvSMDUaXUnIwzqQkzgmw?=
 =?us-ascii?Q?skAY74GYizIaJwEsr5HxsCHTmuz/KAY9rt4VksoJi1Yh1VSmunSw+RIysHbq?=
 =?us-ascii?Q?2L3rPzerzcpgHcDOC+3jd8GE8h9Caua5qmF0APD+5wBPGP9r/Wb+uBIhO2qo?=
 =?us-ascii?Q?Q6iewXJTGvy9TiA8wDDCmxLHIPfVC1uEGx+z5DTYxqyKDoVK82byOeMY0D0F?=
 =?us-ascii?Q?cQ5UXFWRkdTDuG4reRe6j391t9vK5OAopanpabRzVMq/N3qmuAD+rHaTpgBT?=
 =?us-ascii?Q?ssklLBVN2iMQFzisu46ndCq0EX00rEL0BVcAGFRWF3BsC/jKnmdzeNhBobrN?=
 =?us-ascii?Q?jPbLO9hlyjmXGq6cWrW6h5Yu3psB4bfKlp/JRjJVql89s3wRU1Y0XmhwuoPI?=
 =?us-ascii?Q?PoX3vVQ/kLY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BIs9/FMXULxY9RCTEti/59F/aTvgMxS9aW++pY9Hn5ONXxNtuNao/YIKvxPD?=
 =?us-ascii?Q?MbG8Ro2Fg40XluK/7yEHL/M5ebppMrIMxAMQLW2EfwsI0BtNnjiz8oQx8IvG?=
 =?us-ascii?Q?2od/f+cwMQyr2T7u05TjKt7b2uj3Qy8YTAhEGihtfZOhq/bH4KhZruyqib0u?=
 =?us-ascii?Q?vSba2RtJ3zDX+ppU1/zPuOPXPQe23KMb70ZnWKHJvHx8oKj7kIkH40/TRAqd?=
 =?us-ascii?Q?bRSaCVd4e3pbHlpfaA18Vyy9o8JFWntXdK3jjqnJBox52J24jv4w76K0FhP8?=
 =?us-ascii?Q?wVH7GyFHcP1V8JcPEQWvQoUZLm4mJe5M/6tcfFLSb9c00P3kO8CsY7n26K9z?=
 =?us-ascii?Q?pYei0891FjemaauSzImDf0nsfC9O4ISgtjcs33yLfZvJ+Bjxub5N/9M+xLKl?=
 =?us-ascii?Q?npp0s9axYb/aeCBlO4yOLmqQZYsjrVxo80A7aNP6356vE0b0b5appwzvRuD5?=
 =?us-ascii?Q?8gb1mez9tD+lF9u2qv9m1bsIBKC7wsFI97bdTGwmK0S3cFS+98U8x6GK6822?=
 =?us-ascii?Q?RXYtGjgrAy1Va+BRdsBsKcmJX5M9HiN/Uyecx4miXY3DdOa/qsuei1winrVJ?=
 =?us-ascii?Q?/hBYnEH41vmpcIAAc/hLhvvTy9nOvFclvsTiUxNsmdag3Q/WcydAs7X6TwbP?=
 =?us-ascii?Q?EwPag6nKbXqlcA57E+7XXMt6ir14HizUWwR2fSfTTgzKQ2YFUQqjIjP6XryV?=
 =?us-ascii?Q?yBG5Pv06hczNRlUls8HTKpzEXmE1izIxqksypoVaJ3YqrWSckrWMVhsLAmu5?=
 =?us-ascii?Q?wKRTDa8f10bN7g09DSj/mrtXeFNFa1+jVP38AU4mkwkJzaUH196xJaYe0zyW?=
 =?us-ascii?Q?iZF1Cm6hPluoSs6wYnAJ7W+2jH+Bu+hw5JPVmJtki/axseUJjQxRiq8N3/aN?=
 =?us-ascii?Q?HY02jEZLpQ4cXF/yh+RO7aUIyPiEYRHjmWMUvuDcK+syfP7NzAAMlvVOw5sH?=
 =?us-ascii?Q?QceFNl9ffAXwGac7MumZeWviwKtb3W9F948uWegGj3UKoIvw1gW/ib8IjzbK?=
 =?us-ascii?Q?Fn6u3rVWmCku1T1aDT1tErsHOlz15inrju70D9BeFax0k52fWwOJfeIKCAHc?=
 =?us-ascii?Q?hymMHza3PnUJTYtn22j3QeQxP7wXl2qxyKQ99cfdBBRjnwLl3BI8kYobeTiI?=
 =?us-ascii?Q?3IOL2UXQvxBVX2XnalTrU8cu7y611Sx3MYEImY5cQJZLHp94oAyu2h+FRotZ?=
 =?us-ascii?Q?eyFJH7CKpGy7A8LwRlxutAoaym2sIAPD1FggYlSfHe581jFulIe729eYO/kK?=
 =?us-ascii?Q?HLMtAV68ZY+cGEopNBFq2p8V75uRKnMqTE9xdcd1khQl7zQzUL8PCw4dUDwm?=
 =?us-ascii?Q?H+unjd68R9Uo5MIElPZj+cT4E6drlIh23rxVNzEfRtR0sVleRbBTtq+ddNcb?=
 =?us-ascii?Q?uVvAzgZpm/u69DeEiUJQLErqpOa/u6UNA9hHSx7DG5M5+ZcXcGZ0hAV78AQ9?=
 =?us-ascii?Q?Jq43CoWh6B0KtSo66KbU5p5wyTEDMpImjKoD8UDthkGmmRsCP92XHHJAsdpL?=
 =?us-ascii?Q?ppVsEkAodnQDn6tukFCOYOhysEDNDBoquvhMSLZ/0jg8NvgXMqbwkFMX53y5?=
 =?us-ascii?Q?GcV3damRGir+j2eiKkVx8SIuMh2GL/Z2dNR7GFOBzTKIWZPPGcuFat4mDCQl?=
 =?us-ascii?Q?1A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nUHwkWijYdRsZYN7UXk9gBhxffZG9h9qOOuO0YUa3krPjxnsXxufbBl+aTWWzfNNdnBP6d1AWQQjAVzGLc7k/eTBjfwJP8W3+umqjtu8XuySmmvH6hFR4sJIukcdNIjcUXAKATpoHbkapuEs68wK39x7o5GNOjhV7qPrw+c/qpsHbO2geTdfkgTE7KfkcRxzZCX3jL7e7JU9CUvV2Cy3j/+vZ0TVAN14/RaBDaCehtAU8xpQwF9Q7h8/FwbX1XAyxpu521FCY9ibXuoK7F7ksItr2TBmk37I3NXut+ijPKbNGvYAAU1cGJz8Ny+cIduRzy2aQv0XT2zGV9t+Kg+SE9gxKtcZ2NzlgLe5mlOOf2Mznv7g0WApl/1UDaWP0FsikCoW57EVmmLpMvL0jdJ76zepn/dXVif+dGZggoXMM0lK/NWB1vO4WkixoMme5nUwfwj3n6wyKluzOW66sp5OWm3t9L+A430RJeplIVVK81ksmPW55NPHVgl8XTyuC8U/MhIpRt+jR0EMHAbxghAkPBJN9+QZMJlddNNzroL5LgVS7Tec8beXVDV5vXmpF0VWONiuJYuh/6wlqfvG34diR8EBsj+XTO7xY8w7TZfMIfk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2e71c24-3e93-4c12-b9da-08dde643a747
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 15:00:40.0807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: joYl3YjpIuloxqDYHJGs7E0noppuh1wgQrfRhLOu0QlOojrzvJ+VRZFTxcOCvFl5MhdubCeLn1UD/yjbic9Cj8iBTcKLpRbi7b6qfSeqA7c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8173
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508280126
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxNyBTYWx0ZWRfX1iFBYIyNUSWq
 3xvtbEzQ8KaRFzs5FNvX9ee5xMff9T8K2UGlKGoF12Gj45aDaiKvcSm8Njm2j5u1VvhCUM6OLBK
 B1sN0BUB68wsNiWg695zgUN9QxLvicvcYu5gjJlLD2WzQ87yDbGETeN5/jN3oKEJAp4CZ1IkPSQ
 5mWpDEFBOsF+AOOXp+mfyB8y4K4txNR9pPnVYaonY7OQKr/428yrKpefMQjfNtlfWWyQvqSNOUR
 XCa/pryNmtTpyCmbK/T3NVycdTk1RQXPFB1wUPXYvbkT37tj4EwfZnBCPzNnTm6nzlMAPTydmuy
 X9u+OE25vRVr0/DmZXzuJoQATZpDwczmCEkn6aaBmt1p9J1C8kx5KdVaw6CnBozlNFebpMI/GgR
 HfWXJO0hBevJ3cHWmX4RG4aRLjFqUA==
X-Proofpoint-ORIG-GUID: sBOrTaqn2oy2glCCVAAd7nVgkEF6yb_6
X-Proofpoint-GUID: sBOrTaqn2oy2glCCVAAd7nVgkEF6yb_6
X-Authority-Analysis: v=2.4 cv=IauHWXqa c=1 sm=1 tr=0 ts=68b06f1f b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=Ikd4Dj_1AAAA:8 a=20KFwNOVAAAA:8
 a=yPCof4ZbAAAA:8 a=hxZD7SQwFA71348cTyEA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12069

On Thu, Aug 28, 2025 at 12:01:14AM +0200, David Hildenbrand wrote:
> Let's sanity-check in folio_set_order() whether we would be trying to
> create a folio with an order that would make it exceed MAX_FOLIO_ORDER.
>
> This will enable the check whenever a folio/compound page is initialized
> through prepare_compound_head() / prepare_compound_page().

NIT: with CONFIG_DEBUG_VM set :)

>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>

LGTM (apart from nit below), so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  mm/internal.h | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/mm/internal.h b/mm/internal.h
> index 45da9ff5694f6..9b0129531d004 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -755,6 +755,7 @@ static inline void folio_set_order(struct folio *folio, unsigned int order)
>  {
>  	if (WARN_ON_ONCE(!order || !folio_test_large(folio)))
>  		return;
> +	VM_WARN_ON_ONCE(order > MAX_FOLIO_ORDER);

Given we have 'full-fat' WARN_ON*()'s above, maybe worth making this one too?

>
>  	folio->_flags_1 = (folio->_flags_1 & ~0xffUL) | order;
>  #ifdef NR_PAGES_IN_LARGE_FOLIO
> --
> 2.50.1
>

