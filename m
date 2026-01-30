Return-Path: <io-uring+bounces-11988-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WN0sFvMqfGn1KwIAu9opvQ
	(envelope-from <io-uring+bounces-11988-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 04:52:19 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EF40B6E8E
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 04:52:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 259243008242
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 03:52:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D5071F5437;
	Fri, 30 Jan 2026 03:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QDkCUEWM"
X-Original-To: io-uring@vger.kernel.org
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011041.outbound.protection.outlook.com [52.101.52.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0704736604A;
	Fri, 30 Jan 2026 03:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769745134; cv=fail; b=IOwmqrB2NS6e5P07PvpB1cHunhQZhqlXziRcz8ETIhWqTUssrTVZskJyb7dUqi49ClM7sayY8W7Xg7K3Q9ZZAjZdnPPS38hNaW3nMlmyK3a5RYIggmswgeGJn5IXMuYMDrlOjcin9beCKwv0mM/EdDepeNybXXqZ9+W4g0uZSJw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769745134; c=relaxed/simple;
	bh=nrzb1JRcIUVH+iR6WagN0jcWM/4u3V7PnGXYMAvWnfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eyofkPjUwzkGz4Fuzqurbqt0y2DD55JTgDPJqO3vgtCEYSczxY3PI8R3qBEwLWsUFIT1KWbHABiTu6tpnGSd/u9A5dvZo1iS+AhstZO40PIO1cQDzurqCfwPUjhf9+NKBAqAHHNxDDRXg9srVmD6WDRmdGUJG5S3TM22XQ+5MOs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QDkCUEWM; arc=fail smtp.client-ip=52.101.52.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=so8dx4jnoP+DBMNQ2DId/7nFCgzVYqheySm0GOTsnCEMYBQrtybyj33SOuKmp6axJMuEc+sDDGRfY2eu7+6NFzEbwep9wZ/ihODXXQGJVSKU/4QM50dGB8kbVp1pC1DwpsadSwTRMLmkKfAodkkXgRY4zhXNwNGsoJPD7SR62dQTaepDNLoct5kS2arhUBKeF65B5NEvkfxlNgRwWj6QgIWH+TXF06UfId7GLu8AhqoTO1RFGgOXD+B758dnpilKgMCkVxFxbBwgDnrBLN2chRzB0dZ8IGClxZtysisNZ0UW6Jz8h+ba222GrNCVpUG0wp5tttcvsat+jOn9t06IsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qi6a0fURhrPurifYpDQgewVQSbIOADWal2Rw1rBiNCE=;
 b=e6Wa6eHGfefqj1W+wOWayioNJ/AkdNSNmIHnrd2F2+0uGRjnOWiHk2XzNMxIQHnNiOgbigW1o37oh6KJVhj+7E5K4Hf0/ppA6U/w1K2i6hfMA2p5dfPXP9dF1ze8G9sKG7TQT0RlaY4GGrccIL3TeQ8J0h+tqyYxKBQ+uJDtBeL/K/nU0xaoPU4w9dTQMPJS72fr63IazyEuq2CW0AW/BfMGUaAs/bdOGVYRSR5Qpc4kgnVb1/cFrbMGukuXN0sR6PIZILg/V5AxxXbEjuMsxISbkzQ+tnRLpbp6dvV7vpbwffEnixwkWOJB8tOo+VPQfIGzFdqCflWP7ScisEnBqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qi6a0fURhrPurifYpDQgewVQSbIOADWal2Rw1rBiNCE=;
 b=QDkCUEWMU4/iQxMHT1u6cFgbvZasCTLrXLl0us9mKAR72Xov0sE0eo/05vYZx2EslfaybtG/pCeteZzRZqpfJNrHa24K9RHr7exNAuh4ITguXSiHbBlf3pAuPr6SxILyuxsEFfXYZ8wJqKdNunBZWVUh+WPF3XukU/OrEgafar9dN5MNoUxOVx3xgHz6wU0IYsKx9Ai7Ka1hpj3dFbkAlk1uCXCemo9wCJaKzZX3TEtIWUE5HlwJdWr20nrz5JDp7tmCH02BEvZqtJY+Dl5s6uhAP7kzP0vKHLhPcA1lbEj8NRYiZP9VJz5zHvUDrNkMFqzPbWePsoTbGa0YAEDaAA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB8312.namprd12.prod.outlook.com (2603:10b6:208:3fc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.8; Fri, 30 Jan
 2026 03:52:08 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9564.006; Fri, 30 Jan 2026
 03:52:08 +0000
From: Zi Yan <ziy@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>
Cc: Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jens Axboe <axboe@kernel.dk>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: [RFC PATCH 3/5] mm/hugetlb: set large_rmappable on hugetlb and avoid deferred_list handling
Date: Thu, 29 Jan 2026 22:48:16 -0500
Message-ID: <20260130034818.472804-4-ziy@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260130034818.472804-1-ziy@nvidia.com>
References: <20260130034818.472804-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR03CA0002.namprd03.prod.outlook.com
 (2603:10b6:208:23a::7) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB8312:EE_
X-MS-Office365-Filtering-Correlation-Id: adea936f-b09c-400b-4e5b-08de5fb2f112
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HEzxbo7AFjHt/H/Hkz4TMmYQeM9cVqtbpwUJ3jfnu0jWqYoRYRnfPCqMJgHT?=
 =?us-ascii?Q?C8rvcXiwehybzyENxnwbbTBp4NLIfgVy69GDEXwE/CiMbPWTRic1At1MMyJJ?=
 =?us-ascii?Q?Ah8T5/eXHL2mO84vlntobC53u4Vm42yKVbCEAprfZToh3EHpoewc3zCmZ1sB?=
 =?us-ascii?Q?uR9ZjrfL9e7DxwvheTyMttnbwyR9Do33tK1SUoEGCKWNM6BgHWklK1OaegDO?=
 =?us-ascii?Q?bPyhaqIc9BZFWMjQXmtNtMVnib17EKfWlh836AKfonEBBhAYfWQwQ86eNWIb?=
 =?us-ascii?Q?bA4lt3EOoJvehIGlMTBWqslat1R1gTqQ7DI00+vC3wkG+BINhID2OUaqrwhk?=
 =?us-ascii?Q?hJf/ssHSuSfwXZ721P0Xo69L+2y9gfmhkG15uf9TRQe8LDXy2uC6dmG8lmSE?=
 =?us-ascii?Q?n5J0ya693yAoY4Xe7g10yR3yZzrCCEzOax/N+hFyJOmA3RDlZLLTWcUlVFWY?=
 =?us-ascii?Q?Q1kF7vMGxJh/ne+Awp3dmuhjxpKMvud/5/nP41GQyLcCYwAm7JpvM5PuvKGe?=
 =?us-ascii?Q?hwQVe6uC79yvA0fLIYI6X4vv3Y8uRkJtRm4VuXWgVc6kf8E7EMYXCaBHKOt/?=
 =?us-ascii?Q?HVAaYkE3KSsPHA6jDh9wF8AxLhm1prQlszuG45t1Ow2F2kpfSVfE6qv4Idsg?=
 =?us-ascii?Q?0hj0jVkBsqm2xNPxviBOzpwKgch7H0pj6YJ4cNiFdKBrFsM7N+vn0qnlsWFa?=
 =?us-ascii?Q?I8GR702DoPG3CjQY+8UFJPbroljnp0nAjAe7NyVLKFsp6VT5tESQ6HHbozyb?=
 =?us-ascii?Q?sWuB1Qodx8zEvSvWgyOcUpupBYVvTCBFZU60Zcx96XZk9fpQoUQBqOee0398?=
 =?us-ascii?Q?cIo2wHCpjWrHVwL5mJf40sd9atfnJAcHyJMzjrW6iKaSfetd/8YDJfVBZckT?=
 =?us-ascii?Q?z1G1y4tGzvRP2B4WvV2UVOLGv5PhE8V2MO/y7VERf8O6StPdwML7jSbuIryS?=
 =?us-ascii?Q?1F/QpQDKF5Zq2JYDm0mjJ74yUVQSte6JOlAt654ZKaKOJKoxva8x3px57GQ3?=
 =?us-ascii?Q?dFfbOddVomlrg9GzTK0bwCkE09Js8KoiiKKdk+NAedYOlswytduf5pZpb+Zb?=
 =?us-ascii?Q?0WP1K9RRLTwihlEM4hC8Jqdxove1vZcPf7PRIm+Q87Xs2vUEEx6Ye4nWm9Rr?=
 =?us-ascii?Q?MOaVFJuUb/3xMJT0PuFJ+btQ4L/2R0Hq1mil/9z9j8vs/vann1mPmANUzNKD?=
 =?us-ascii?Q?i3JwUt+3qYQWLRb6Q2izRiV2/f1z86SG0Yl2oZ1pMU3l2IoJpRIkjcv0rwXC?=
 =?us-ascii?Q?RkeRcx3wG58tK7FSCMOd5YmGjt4qqMFSO6Bc+VS4DYQabtppONdwahqEfO0p?=
 =?us-ascii?Q?FZiiwdJsJmOpTIQiw3odg05+KPq45auqMWZ88Lpd6jsk0ycHwMkiFXi+mvxZ?=
 =?us-ascii?Q?u5d4fCLfOAYncKp6OUKIB1minuM+U+uH8rSpELnYQix1ji1ruTbqYNVl1525?=
 =?us-ascii?Q?Q3ucX/BW2n4tuETTwObwtUWLtRE4R9UVzhTiVBtvXyC5CWPjKLGSF0HiihrH?=
 =?us-ascii?Q?SdzOUAE80OqKdRdd+ZcOAv2lhBLFCXFnlu5Hb2m/dNbDHHz6uNn04y4cXzNb?=
 =?us-ascii?Q?D0RUwgZKDyiOvqRzf1I=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sdQHu7zbgwQzFRo48cD3gyx0ScqGHI+IFl6aaZPMCow1OyBa6fEQZAhNOlAc?=
 =?us-ascii?Q?8vtT9D60zvD+Wyxjl1n8RnYjhjdQAGxEqS4vmqqb7hq609UuqpXmEiHKxIGY?=
 =?us-ascii?Q?XOgdEN//Xs3s7tHb3IDoWkhxm9qjbN6ORUVpCIPjEY8DHIOz41nayE5EHL90?=
 =?us-ascii?Q?bbo349cPypJTAcMfJjE4adpoPeg8C+Zy8IRbAAcKN617SHGYbgV78Ca2BDk6?=
 =?us-ascii?Q?+VciEuxWAg1hCUukao6zTNWS81pzGFrUqwpo/qf+6ZKsis+t8oW/5cC2EHuA?=
 =?us-ascii?Q?KkmD4IWmpI6VosM4IDP7xz9EyI5m4OBtxU/8Jt/T7W8r+GNgL/yDJ9umy8NR?=
 =?us-ascii?Q?/jEC5mIQpKknLPpMIJuuT6Wgwb/iAgMCDJfcm0QTwdxpJQa+A5CYwk4stWs6?=
 =?us-ascii?Q?AWmsbHSdXilVmJgC2mw0j8HNj2pDhefEEsGuhzYqU+6Gx5ZH54xL93+4s13n?=
 =?us-ascii?Q?Jw1dZiHu2m53vbXVfj0oRk1cOlF2jlBsc12pXU7G2faT1sVoMeqHaeWFnepY?=
 =?us-ascii?Q?9HC4Lu2ngxi8CX+PxXkVDUGB9Il6RWQ7v2LSKcIKwIB5wR3kDB8ZAMHF//uu?=
 =?us-ascii?Q?2zrjOtIGemIzbwcOURGPJEoAY9oZqtDV1q/7ydELWR/ifwYxWnYgZLM2iTZ+?=
 =?us-ascii?Q?AYg3e201sGRyuQCB9050SpxmdxI0FYMw3J57tN1+bSOE/cOyF6ju+JgUe/Xp?=
 =?us-ascii?Q?2zvhlF24wIDRhSfVcxKcBgfjOwCYqgtbsYoE3Gxiz+t77M+1dJQUjjegBcod?=
 =?us-ascii?Q?WW3lGFDPQPenlMunuruKQwlE0wLYLzwk9zkty/2jNZulOL6GAC7LWyoXa4kc?=
 =?us-ascii?Q?0e86NZpl9kOZr5eMwsTiNNzC8UdfhnWoXJOdGhi2/01yQaOC41Va/hFG6Ky0?=
 =?us-ascii?Q?uU8nPyNmoNltZW12me1GR6Ed2dvC41gG/t+umQtvUJbcC1A8y2HO4y33l/2f?=
 =?us-ascii?Q?6gn1y6wq5vUaN1HiW2zpd/Lm+0IJHpKGGL+tqVjZZkgNcYm4NuE0nJuS7nnb?=
 =?us-ascii?Q?eZZNwSR6CXqhvSIBRfJGhRBt9vKnDY12gr6SNsQUqEql9lnexQpuXP2BOG6Q?=
 =?us-ascii?Q?6OY2Ago5pfcE2e7mPpjG9LAri2UCcNO4VBXpf6jjSjBLqWpBUzj6CwP5at4m?=
 =?us-ascii?Q?ctUcmcywSDG8U8gwwxRXhO2KO+E5BWETlGwXcu892HDfat2ego/daRKEyh4Q?=
 =?us-ascii?Q?7yW52toTKVxRjt1bR1TvPzX4Hnzs5gKizXnIWEhw4lwRP/o8b14QQvC20LoG?=
 =?us-ascii?Q?DwfFXUUMssQJe+sHds9kz8pjGVRu8kXJANyXVzazfCC0K0jRNvj/G2+5S8i1?=
 =?us-ascii?Q?RlXqxZOvtrZZubXpiIeNYtjZPbjVEPq2Ri/X/W8pZCKCJGYrvLNx0jtzw4qb?=
 =?us-ascii?Q?zhwEAvunQCtTyNbgxE1X57cSLRRYvR2xOZOwmmWCv/kjq2pO+rsLDygxmfOa?=
 =?us-ascii?Q?CDLcXi9DZ1QAT+cdqyWtfWZfK3mPcG/czCfOVnjh1B884O2ZXSn8qlH48aR7?=
 =?us-ascii?Q?MUNxAEO1RucHTEn0JrkqLy5uPuECvJkJ/6s+AV1YMu9essOXsOyFuSB43oKl?=
 =?us-ascii?Q?q6I6QaKBvIZIwJmr5R+7Gh4VAZcVLTVvgKTbOwwnpqrcNER7EgTH+a/GB4hK?=
 =?us-ascii?Q?tExpdHueB1ozAnlLzfXcs8G6jkA5TZ0GZqnT9lKiwHEq0GtEpG3PJUApQMdJ?=
 =?us-ascii?Q?lfCJnQjDM3C50ss+O6bGYC7E15TvmGyUkui/MADLLBt0Pbiq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adea936f-b09c-400b-4e5b-08de5fb2f112
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 03:52:08.8202
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6FzJb7LOXCWxVIHWfTNeb/mdBIZ/jDw7vI/XMUYtzoB9g9rUixq+wQRd8cpQ7k36
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8312
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[27];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11988-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ziy@nvidia.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 2EF40B6E8E
X-Rspamd-Action: no action

Commit f708f6970cc9 ("mm/hugetlb: fix kernel NULL pointer dereference when
migrating hugetlb folio") fixed a NULL pointer dereference when
folio_undo_large_rmappable(), now folio_unqueue_deferred_list(), is used on
hugetlb to clear deferred_list. It cleared large_rmappable flag on hugetlb.
hugetlb is rmappable, thus clearing large_rmappable flag looks misleading.
Instead, reject hugetlb in folio_unqueue_deferred_list() to avoid the
issue.

This prepares for code separation of compound page and folio in a follow-up
commit.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/hugetlb.c     | 6 +++---
 mm/hugetlb_cma.c | 2 +-
 mm/internal.h    | 3 ++-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 6e855a32de3d..7466c7bf41a1 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1422,8 +1422,8 @@ static struct folio *alloc_gigantic_frozen_folio(int order, gfp_t gfp_mask,
 	if (hugetlb_cma_exclusive_alloc())
 		return NULL;
 
-	folio = (struct folio *)alloc_contig_frozen_pages(1 << order, gfp_mask,
-							  nid, nodemask);
+	folio = page_rmappable_folio(alloc_contig_frozen_pages(1 << order, gfp_mask,
+							  nid, nodemask));
 	return folio;
 }
 #else /* !CONFIG_ARCH_HAS_GIGANTIC_PAGE || !CONFIG_CONTIG_ALLOC */
@@ -1859,7 +1859,7 @@ static struct folio *alloc_buddy_frozen_folio(int order, gfp_t gfp_mask,
 	if (alloc_try_hard)
 		gfp_mask |= __GFP_RETRY_MAYFAIL;
 
-	folio = (struct folio *)__alloc_frozen_pages(gfp_mask, order, nid, nmask);
+	folio = page_rmappable_folio(__alloc_frozen_pages(gfp_mask, order, nid, nmask));
 
 	/*
 	 * If we did not specify __GFP_RETRY_MAYFAIL, but still got a
diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index f83ae4998990..4245b5dda4dc 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -51,7 +51,7 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
 	if (!page)
 		return NULL;
 
-	folio = page_folio(page);
+	folio = page_rmappable_folio(page);
 	folio_set_hugetlb_cma(folio);
 	return folio;
 }
diff --git a/mm/internal.h b/mm/internal.h
index d67e8bb75734..8bb22fb9a0e1 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -835,7 +835,8 @@ static inline void folio_set_order(struct folio *folio, unsigned int order)
 bool __folio_unqueue_deferred_split(struct folio *folio);
 static inline bool folio_unqueue_deferred_split(struct folio *folio)
 {
-	if (folio_order(folio) <= 1 || !folio_test_large_rmappable(folio))
+	if (folio_order(folio) <= 1 || !folio_test_large_rmappable(folio) ||
+	    folio_test_hugetlb(folio))
 		return false;
 
 	/*
-- 
2.51.0


