Return-Path: <io-uring+bounces-9430-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C4A65B3AB5F
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 22:16:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 84DC52080C8
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 20:16:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCD7A274B47;
	Thu, 28 Aug 2025 20:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CiIsbdFf"
X-Original-To: io-uring@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2079.outbound.protection.outlook.com [40.107.220.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF94721018A;
	Thu, 28 Aug 2025 20:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756412158; cv=fail; b=VS/IEhajrewGAwbi14ovWKLfyluARdQCxKwZpN/DshZzh2NmMkLeI4GH1i8L+WN75W6tggT3dS0f0LLl7DdrPAM/+mkjturTgMtnu58xxjH01jn0pj1FYPUmuekpzoQ5jCAAgExlq0YWzepx99V0MvclgLJU/LVSE4pkTbWNFx4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756412158; c=relaxed/simple;
	bh=h8m6b5PPjcguRyNJD5OnSTF3NdDQJOw6bmiEHbOfkDI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RQ0mvxBTEngy4yF33NeMxJUX6PtNrQn7U1yt/8/M4/aVp0/Ll/O4/4fZhLwJSbL2XpLC55nmBNXUV6gerDTRFnkY+9keNvqmYJZFMe1ixIBze1ipmwpepKyQb4wnGur4Tm77qSD6XWEUnv1+LYHQaUXJmkb79/yuUDZz2LU57sQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CiIsbdFf; arc=fail smtp.client-ip=40.107.220.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y5w/cjZY9/rFmSnQwyDNR+TIt2kdjif7oOjMr4MmDwu0Rucbdu1dXLf/cc45tTiFEQcSr+DxHu8SW59PsyG48YK6hqeW+HNibYfboSpO4de0XTtTpszD/pJZ4+FYsy9Hn4oAs6YDzkKKUHl03sQ1y5DAS3yz0JpREXj2FIbMwdE8T4Lox5w1KnixqZqD6zExzeTvuARf2AjjqMr77gm6VTHCEswAQ5lNR0wxw+AGoTPVd6BC/G8bnjcsgpZKnX0Ue0WX8a9x9zS4jeWYYn+2YvV8/orh0HbyuQ3SLpktjWxU351b/g+TS6GedstH+vK+ULm6NoGIpwGhTYOGtrIMQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5NCZxsh7hXIhQTc+nlvlpEE5dDol9DLzOeRAAkojles=;
 b=ZGMz/RQ/HP5lAPiaFKrtnQ5+uBz/rKFoG5gRPgwfpEz/oz+D/pH9NAk+Hyz8XXqUbSx5WfISt2t3t/MPjzMBHFbmybn2WTIASweMhGEcp8VBG01TKwIjXRy2hyOKKaRhEDeHTBbUsBGXV/DmAS7BClZDq0KvXzgTbE0QCOcte7jmxP9H/ivx6/5A/pklQ5qvCA1a1ZBVr5lsbdzmMmWMG4SrF0o/NeV3mVoHw7Z6rxGR7LU+p3E4wHQCiHpxN7ex4rHM3iuZbi4diuZfoXvNW4FEa4LOkBr8GHzVQ/zG736fX1PDAR6tfHp8lBaC6MszQHZXO8LLjX8/TueAGtqXEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5NCZxsh7hXIhQTc+nlvlpEE5dDol9DLzOeRAAkojles=;
 b=CiIsbdFflQrGo93QtER2hWUketVf+uJm7gF4Q7OxefWg0qpkoZl2juc4VZRqbzB4tELutAk/+eeih1ycSvaqjqV2eKLKfnmJSeFeL3vm795A2zKSZW67RD14vkFalSphs+TQX0xcG51uFkl5wScaI4osw90KXMozZKk+GbqQoYI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by SA1PR12MB6994.namprd12.prod.outlook.com (2603:10b6:806:24d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.17; Thu, 28 Aug
 2025 20:15:49 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::bfd5:ffcf:f153:636a]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::bfd5:ffcf:f153:636a%5]) with mapi id 15.20.9073.010; Thu, 28 Aug 2025
 20:15:49 +0000
Message-ID: <de02027e-964a-4510-b988-c93c87d132e9@amd.com>
Date: Thu, 28 Aug 2025 13:15:42 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 31/36] vfio/pci: drop nth_page() usage within SG entry
To: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc: Brett Creeley <brett.creeley@amd.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Yishai Hadas <yishaih@nvidia.com>,
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 Kevin Tian <kevin.tian@intel.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 Alexander Potapenko <glider@google.com>,
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
 Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, x86@kernel.org,
 Zi Yan <ziy@nvidia.com>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-32-david@redhat.com>
Content-Language: en-US
From: Brett Creeley <bcreeley@amd.com>
In-Reply-To: <20250827220141.262669-32-david@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0191.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::16) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|SA1PR12MB6994:EE_
X-MS-Office365-Filtering-Correlation-Id: a67faebf-c655-4d24-4bb6-08dde66fae0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U292QldXcXZkSW03TkcxYVE1d05tOGpMamZQOEtzWWdmMGw1STlIaUsrT2Np?=
 =?utf-8?B?NExhT3NLVmkzZFJWZ1JLSlhHaEFOQ2pZWTREN3B0K3gyWGZ4SVFYa21ZQUlU?=
 =?utf-8?B?NDlMZFVpQkZLTlo1TDVQVFBjTkFIcFp4QUZMRXl6UC81ak44T0RYd3dpeUxH?=
 =?utf-8?B?QUIrb3c3STFRQUl0dS8rRkxwUHc0eWZJa1ZNdFcxR1JMVlQwNmF3bGxVNDRN?=
 =?utf-8?B?cElVcHJNQW8zOEl6eG8zY0JxaTRCQ2ovdmorMjhHU0VkWi8zWEJ3S3RrMUdC?=
 =?utf-8?B?OTFPOGI3K3VEL1FxUWZDT1R0SUp4R0EvSVpadGlNWVY4NGV5WmMydzBhZUpV?=
 =?utf-8?B?NWZJMVE4S1F0NXY4SzRQVzFudUVRcmxuaWNpdU9nWlFXSFk1RXFvaUlGMXpM?=
 =?utf-8?B?TTRZNnVQeC9oRTNGeURob3UwOXNQSDJqNnpmZG9aVEZXRW9PODUvZk1RM3ZW?=
 =?utf-8?B?dkQ0OTNYWFJ3Q09INk1hRmlFZmtDalZzNWNrbitHSk1zSEZsb2NUdUR0S0ZW?=
 =?utf-8?B?VlBoWk55MEdFTGJpbTdmLzlhTzlJVDVOOFM3V0o2Zk5XZVNYN1J0TDNqTHY1?=
 =?utf-8?B?VC8vbERFV1pDd1JGdnhlS0RsUXVHU3RJdDNwdmdwYlliRWtLdGZPeGg0N2Vq?=
 =?utf-8?B?ZU1jcHcwUzFVTnlXVjVra1ZUMDhDZzhLTjB0a2d1UnIzUEVGNnRXaGJWTlFs?=
 =?utf-8?B?QUJUazNlL3ZpcXZCVkNzTUg2UUxqVWZvZUZXeVhOcXMvOFVFdUl0YVRNV0Jq?=
 =?utf-8?B?ZHNacE45ZjBQblNCbXRvNkFTSDE5anIyaURkV0VOYmluVEszWW05MUIzaCtw?=
 =?utf-8?B?cVFKMUluNlQ5SGdPemtGM3VOMEtVRzdzT3dpRlpQdTl3SVdWcGxYdThNbWJT?=
 =?utf-8?B?VFFBbk1jMkNqdDNqRTBqMnJhT3UzaDlDY1RlRElEY09SNDdYeGQ1SHRyc0Rz?=
 =?utf-8?B?eGlKNVJEcXJ3eTRsdWtrdVcrMTd5UXBuY2NCelpHK2UzTjc0Njlsa25DWGQ0?=
 =?utf-8?B?cmFvKzcwWUpESkJLZlJ6dUFDZE9tUi9QeU1FeGNRUE9pMGlsVXlXTkZoT0tv?=
 =?utf-8?B?Z2FzazViU0djcFVyRitVSDNuU05CY1BLNlFhSFRPazYxcDdIdW96UnFQanBY?=
 =?utf-8?B?ZEIwdmpCQWR1NUZUQ2FRaTdybUlNMzdGNkNNVW9UYURLNXFsVk8vWEJtWUg3?=
 =?utf-8?B?YzZVODh1RmdCaitBeFhxNERBR2xmRWc4MnZnVTg0WFJVbTBRWjdqRkxET09K?=
 =?utf-8?B?RWJFdDZEVCs4bmY0aFNKY1JRWnEzU3VENkJsSnBLMVN0TXpwSlNFd0ZyQnJB?=
 =?utf-8?B?citiYzM3QUZHRGxIUG1EM2RlajVhelB2OGpiZTJkZjFRZ3ZuUWh0RlBuSGJt?=
 =?utf-8?B?OUgwR1Z6aWdPOUV1cFZhTXNoamViWmU3aDVhbDN4NUhEallLS2tSbWwramFP?=
 =?utf-8?B?VGk0Lzlxdk4rRXZkZURueWU1Z3RXR1R0dExHSndlSityQXBtQmlGZU41Z3Fv?=
 =?utf-8?B?TWxLMTRQNG80eEFXYyt5eWphQVk2RFdYeUR3Rzh5cGZMZmFkZ2dvTVZNdkFp?=
 =?utf-8?B?OHhDYndEbTNrL3FReGxMN05KK0FJcTZ6Z0ZlWW5VbDdaUTdScmRFS1pSMjA1?=
 =?utf-8?B?M0tMYmc2QVJmcEg3b1lsYzJLQytVdzZreHo2MkJZdjFEa1Y1RVk2NkhwOE1x?=
 =?utf-8?B?VkFBdERMc2k4WW9MdkhOemdiZ2ZyVUdvc2o0Und5TkxZbjZhUFpOSi9SQm1y?=
 =?utf-8?B?MFY5WlFKNU1haFZkTzFIMmFhSXp0STFUUHlvTDlwejd4blVSbU1iRHIrdWpN?=
 =?utf-8?B?c2x5VzJvZ3U3Z3hBY08zM3RqTENvTFJaaHB6M2J3a1h6M1FPTEo5WDBZWXJO?=
 =?utf-8?B?Zkc2M3I0blV1Y0h1MWhQbHpPSVA1RytkSStEWFUyQm55UCtsZzhDTElBT1Zn?=
 =?utf-8?Q?7Kh2L1I3SCI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dXJvWEZoQVpacGxzWi9iM0JmSzBwZzMvM09qUDlzRnd4SzR1QnJ0SXJDQkVx?=
 =?utf-8?B?SkJpcDBBUnZCVDc5a040eWJjZEFaZ29QMmdTUVZVOHhZQjBXNk96bVFxL3B0?=
 =?utf-8?B?SXV1ZmVsb1R1aHdWWUpVd21Nd3hYa0RXenc2dDdBQ3FERVFNY1ZRKzFHY1pq?=
 =?utf-8?B?akhHUTJocC84dFc4MExTWmszbG50NFMyVi9mMnkrMC9RN1hkRUd0cml4SFRU?=
 =?utf-8?B?YWhrZEFrUzdWN3gwWkVsOG54MmRseUlndURUN2lielhRQUxmT2UzZnk2dEha?=
 =?utf-8?B?MU1mS0k2ZGp3bzUzZE9iYjRDeFFDTDgraUxXdnhkTll1cWllbGVSMWFwRm50?=
 =?utf-8?B?cW1OL2lSK2htNlM5cENHSlp1NFFxb21FT0NhVGtOVU9yYmJZZEZmSXZ5Umhs?=
 =?utf-8?B?Zlc0SisvT1llMFlrS0FPNHh5V2JtSm9waExDUW5XZEtyYWJGSW5ZbnlONHZz?=
 =?utf-8?B?aHpmcHM4SUpXaENYMlY4UUNWYzhtMkFxOTd1RGN1VG55UjRTSDhMWWkva0kx?=
 =?utf-8?B?K0draFJhbm1JZnB1bnpveDhRSGFQRFUyL0hhSVBjVU5zdDFYRHFuSzZneGp6?=
 =?utf-8?B?czNmSDVrbHVKaGtEM3N0QUhtRmZHUE1iSXNsdHNYa0JqNzMvRE5xTERndysx?=
 =?utf-8?B?Y1ZEVldzL3ZLUmFaNG1oZUpKRHNkbDBpT2lJdzZERHBHem5nOTBKQWZuWUFM?=
 =?utf-8?B?WTRVem5DZk8wKzMzVXRLVitNN1ltdE0ySjZEVHowUitwb3R0OGVWL1prdWR6?=
 =?utf-8?B?ZndJUmpPdXV1cW9CSDFBa2dkQ0VjeXo5cTUvbGFGUGhvMVo3dFlGRExhVEVq?=
 =?utf-8?B?SHE4VEVtM3ZOTUQzZDg5SERJeUh2c0w5WWVMQVVpY3JRYjBrdHBORUh6blln?=
 =?utf-8?B?MDdjV3JFMmNZT012azFnTmczbTkvOFIzUXFseHdlTFpoZEc3TlZRN2tSWGtk?=
 =?utf-8?B?dXRscGhUMFJOditLL081dTRxT2VHeC9NdG9KczNRVHhydmNxb1hyYmNJYkJH?=
 =?utf-8?B?cVRKWmY3MlE4bWNwL1BQWUY0U1RsYm9NS0preW9HV0JQNHN0Q1JXYWpTaE1a?=
 =?utf-8?B?eGsrR1FoWTN2YjJnVURTWDU1bzBXYng5bWlwRFUydkxQSXB1VnhZVXFDVExP?=
 =?utf-8?B?d3A1dko2YUMzTllPMmJkMFRyamlobTFSWnZGTHRoSU1uSGYzUEVoaEMwSXVr?=
 =?utf-8?B?YldzU0EvSkVaQmtwenZEbDczUjFXN2oxaHkyZmRMSkxoU3VIN0VHZ0IwRE1O?=
 =?utf-8?B?YXpqWDNlQlZuKzJCdk1Qd2hCNlB3NEZKU3FQR1JwdGFMN29zTnErUjRucUdM?=
 =?utf-8?B?ZFQxTWozY3ZQbkxXMHFPb0Jwa1BBTU9jdTdZdkkxSTNUb1BCZ0R0ZzA0Mk1Y?=
 =?utf-8?B?eEF6YWhNNE16UUxOMldQeEhheEJUYkFtbUFtOHc5VXNtUnhKN3RpeFZxV3cv?=
 =?utf-8?B?OS9aWVp6M01PbmJMbTVKc0NhNGhSbmFvb1dOT0lhY0hVeCtpa1A3dTh0dFk2?=
 =?utf-8?B?WFZlb0dxUjY4ZlhFSHRnR3FkblR5dzdkRWJFOEJQaFFnLzFoWlFyL0JBeXRE?=
 =?utf-8?B?ZGxxQXpMcEhRS1kwS3hReENiRWJCMzd1bDNjZlB0bFN1dnB4Y0xiQms4aS9z?=
 =?utf-8?B?UmFUa2pKeEpCRk1mdXZzVS9Db2I0TEp0L3J0K290MHhPTFlScGtlSUwydFRP?=
 =?utf-8?B?TEFVaDBWK1FWL0svNm9wQ0k2blhHWDZjTGJkTzE2MnE4RFhvTXVYR3NjbVlX?=
 =?utf-8?B?STN2a1lIK1FQT2lKdkhza0ZZTllacnVHQzRzWlhrOC9tUkthemIzNm9TbXdl?=
 =?utf-8?B?bHRCb1dKZUVYRnVjWVEvSUYvZWdIc0YxRWhzc3hOZ2F6d05rWWw0NWV1UzZi?=
 =?utf-8?B?Rk5xV05aYlAzV3hZRERLbG1GV2tJeXpHcGlrSmtnVDRaekVtek5xWnhrUU9X?=
 =?utf-8?B?bk41T0lHejRqdU1HTFozRUZ4RTZRME1RQUhHWXNZUWlwOVpFMXRCNFcvT2l3?=
 =?utf-8?B?UTB1dE9pYkFnZ0Fwc0daTjRKZDVNRitYczJUbWxLajkybXpuUVRMMmE4bDBB?=
 =?utf-8?B?K2lpLzg3d2E0UVA3eTRYNW9YdGVtdndsK2lXVHhzQnFMRUkrbXA4ZXlTVExS?=
 =?utf-8?Q?ABGgS8baU4PzLH7BG9JBiJhRX?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a67faebf-c655-4d24-4bb6-08dde66fae0c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 20:15:49.4373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZWX72iSnzux1BBrPn1OlvuZ2nBV/HdxLjzylCF38ic/JnLsa9JlrvX3VFwuAFVMRx1w1QnuVMnscn+Q3pEYazQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6994



On 8/27/2025 3:01 PM, David Hildenbrand wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
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
> ---
>   drivers/vfio/pci/pds/lm.c         | 3 +--
>   drivers/vfio/pci/virtio/migrate.c | 3 +--
>   2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vfio/pci/pds/lm.c b/drivers/vfio/pci/pds/lm.c
> index f2673d395236a..4d70c833fa32e 100644
> --- a/drivers/vfio/pci/pds/lm.c
> +++ b/drivers/vfio/pci/pds/lm.c
> @@ -151,8 +151,7 @@ static struct page *pds_vfio_get_file_page(struct pds_vfio_lm_file *lm_file,
>                          lm_file->last_offset_sg = sg;
>                          lm_file->sg_last_entry += i;
>                          lm_file->last_offset = cur_offset;
> -                       return nth_page(sg_page(sg),
> -                                       (offset - cur_offset) / PAGE_SIZE);
> +                       return sg_page(sg) + (offset - cur_offset) / PAGE_SIZE;
>                  }
>                  cur_offset += sg->length;
>          }
> diff --git a/drivers/vfio/pci/virtio/migrate.c b/drivers/vfio/pci/virtio/migrate.c
> index ba92bb4e9af94..7dd0ac866461d 100644
> --- a/drivers/vfio/pci/virtio/migrate.c
> +++ b/drivers/vfio/pci/virtio/migrate.c
> @@ -53,8 +53,7 @@ virtiovf_get_migration_page(struct virtiovf_data_buffer *buf,
>                          buf->last_offset_sg = sg;
>                          buf->sg_last_entry += i;
>                          buf->last_offset = cur_offset;
> -                       return nth_page(sg_page(sg),
> -                                       (offset - cur_offset) / PAGE_SIZE);
> +                       return sg_page(sg) + (offset - cur_offset) / PAGE_SIZE;
>                  }
>                  cur_offset += sg->length;
>          }

LGTM. Thanks.

Reviewed-by: Brett Creeley <brett.creeley@amd.com>

> --
> 2.50.1
> 

