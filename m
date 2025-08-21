Return-Path: <io-uring+bounces-9220-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FCA2B306A5
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 22:49:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4F590623254
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 20:43:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1C6938E754;
	Thu, 21 Aug 2025 20:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SjduOVIm"
X-Original-To: io-uring@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2068.outbound.protection.outlook.com [40.107.220.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64123728BA;
	Thu, 21 Aug 2025 20:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755807659; cv=fail; b=QVr6Ihc6kMznRrGoGn8LgzO2X/QQBJQtK2ugWsTTCIYZoHJfYZIUSAjWcHTNUR9nCmSU/2A7dhELOgwPpbzVSwub+c4CM6HHd0kZH2oWTNY5o5ExYwJTqNTDhquX8lx1kntc6PYQ5zdRMr8q8HdZo9hE3xv3H1bzSL03W9Q8Xvk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755807659; c=relaxed/simple;
	bh=j5irm5WDNbR0Tr9l8uf6DbANiFALdBCaIfAmEa3bHeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EA8hG0dP1NGf8jpaNhgIPo4na4NOal+Xf1xZO4dBIL/VKmlIGHhBYI57f4gBx3y+pkrFkbpjVUc5lPeyafQi163ZdfAmHJey27Im6zxcTYJH3XfbVJ2DTVTsgMX1rUCGOKGNTJ4PYEYF08VXG/2XfsBkI5HfOaz59fxbxsulJ50=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SjduOVIm; arc=fail smtp.client-ip=40.107.220.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wl26AXQUltoo7OVE436mwjXQ4iSO7o9p3JNyEkXZsqSICr/QRthpazH+m9Lri6brjXYXswoTde+qIbF68H0LR1EL22WPkqn9+SlFFwCXKY0/dm+ChSgYkGh5966wLJq3HYi3lnuWt825dbL+drcUt8fGn/pU7OE8lgI73z88zXWVxM720PFpt8zcZ7q0wyv+Z0WCfjHE2EMYfGO4fJu/CqdhOOEQ5gtyEGgB1gxpMhxh5kLlYSUenjO/o0aXMCnk3+MI3s1cRyGVwra7HsXCe4DP0FmZKLtjsfEfNcJhQnHcIn1sdB0p7XlLYqcefVGhZu7xORYpwZxPDpJVZDMcrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5LsCWXH2/2V1Mf+JKRuFmpoWPyhjz6TsTO+1Eky5ij0=;
 b=p16SuRHBUAq8MzcNVc31bD3W/X0n0bk6Y0gwASDJApQsnwfXEtIw09Nc5CWCnHgf0XXnn6wraLN7tWz0AG09urGq/I9KqWS5x8O5I83NbYmGLzVbLuuNuqltEXL732abQ1QAdYDEPamVTFO7Q0afDUnJLAg5YgkfyzNLiyNBZ12Y4Rk6J7ucruJtvmrVoq16fJvIjuJvW2208pEY1OWJw+5aJvJrBCkhvcT69DdxWXWthBgU90oy0QYFgRITbvjx8hGtJR97Nc1+KDtmpbVnLRiFlbguh5F9y5KVCE/F4BlWvRCNIslk3gSGW6sw1g8LgGzKnB5IcHZoKJmtxbqxEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5LsCWXH2/2V1Mf+JKRuFmpoWPyhjz6TsTO+1Eky5ij0=;
 b=SjduOVImrScv0d9IB5sktsTu6zcET1TOgnkQMWpveM0GU3hqIhW16m52oZDyQwsK3/evBCy3UeRcLyaM7NtrLQ8lOrngJrzWL9CPb833s6WpLSF66YTu7zxTD61M17H7uZ2gOKPAP9JJNWYHjv7nZ3JjCwbZICM8j3EeNMCL/ReFDvw2BaoLJx6QH6gUJsDscVBZatyOAMd7qOwxIdZvYHFbxRGCw8s088m92cI7LlaPq9pVX1fag5PRVcZsH9rDsKCr+8g+/8957j7bwomNe9X9o7vN1TTP/UPGvc5EcBcW3iyIEauqwpXvTrxwaij6Nk+X7RFirL3CA/bbESIRig==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MN0PR12MB6002.namprd12.prod.outlook.com (2603:10b6:208:37e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Thu, 21 Aug
 2025 20:20:54 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9052.013; Thu, 21 Aug 2025
 20:20:54 +0000
From: Zi Yan <ziy@nvidia.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, "David S. Miller" <davem@davemloft.net>,
 Andreas Larsson <andreas@gaisler.com>,
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
 Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, x86@kernel.org
Subject: Re: [PATCH RFC 01/35] mm: stop making SPARSEMEM_VMEMMAP
 user-selectable
Date: Thu, 21 Aug 2025 16:20:48 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <7169DDE5-A347-44F9-A6A1-707BF9A314F0@nvidia.com>
In-Reply-To: <20250821200701.1329277-2-david@redhat.com>
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-2-david@redhat.com>
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0031.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::44) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MN0PR12MB6002:EE_
X-MS-Office365-Filtering-Correlation-Id: f619df36-2515-4ba2-b3f1-08dde0f03b24
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?94SELf5U2sNfP7OiFIZT+KX54w6OibGahhp+ocWf82oNd0GpqeivdqHRHVGK?=
 =?us-ascii?Q?uItD8QqcuT95QIQ8nQs3LOvvq51TiyXWNTIs9hd5knXWbrX1lRxEa7+GmA92?=
 =?us-ascii?Q?1ipcg4zSZG4jBfNSBa1H+/kEbIU6A/x0oXpqxPczCeOmxXxQDOprVy5gdZI2?=
 =?us-ascii?Q?ddD1NgoIwpIZ9UWsApYlA8HsuVwQ7h5KxzFdjAic6JmUxZlUKVtHgsTRxuJY?=
 =?us-ascii?Q?v4hpse9scVINpz8kHOPICZ4VGfdmDZrrsIn76KaD9FusH/zg2IHsTh3P3HjN?=
 =?us-ascii?Q?TWjYNgm5mpyeX4Wc8AQuwZ0+kU1hzk3YDRhc6fgAySiruetFFidd/Cn0sv2F?=
 =?us-ascii?Q?FQmo9Hk1O0b2AuuiM66Blg/FaTEHqR4022QS5wBcG5PLiYJd0oY4wlKy1hGU?=
 =?us-ascii?Q?EORGiOHqpDTrjQpgt05PNPGlkQ/Q7I0WrfZv58CuvIN8vPhi/dTOkLPzJgyD?=
 =?us-ascii?Q?YpOqBGTKYiBpR/i5uiuhFLcb6ffFUueXaBZpCfPzoBT985L0iWzeS3yjyNIH?=
 =?us-ascii?Q?9p2GIZsZ+OlFDkYYfLj0E2/fhOJkr1Rwb4h1Ksq9T7Zpdkmi12C4nRm8JBGL?=
 =?us-ascii?Q?McQnP47RlGckCSZl77ebgjK+1LnkMadQkeYcS0Jrq6xMS+Koom8gELpNCr2c?=
 =?us-ascii?Q?nX8xBhVF4h4xrgtr34Lhk4XElDVzpQ+h7VsNCSoZGaDYmOOaToImZKNeOZvh?=
 =?us-ascii?Q?vXg45A2gSWjh/iiyvNPKa28BoDsGdE5VGpJ19J19KSh3FXZpcKL951imRV+c?=
 =?us-ascii?Q?jEKY6JqzC1xCy9fT6Et7Ly2U+LV64vFumxCZWMiPy33feabaBgoQBzXIwPwU?=
 =?us-ascii?Q?rGUwEmyHsBx684GxKeSdR53uy3Me7wNXnDthX1p41Edken/gvgD+o4q33AaK?=
 =?us-ascii?Q?qrL+RffI/XZIEPBnIG6X5FaFYjPFV1TS6GzAniixEiHPRwf9WKf4wAMLY/Nl?=
 =?us-ascii?Q?szOMeGh3+9Xgw8RP4CktSa7MYSc6ppqrakT7Rrw0cO6Sh04SLMWIaVqiBQbA?=
 =?us-ascii?Q?3/AZzMPxzfsuB7Fg88Z+l5MG9mjDUWwgv9Eh/4ZAtgAhLt+uKXVnsQvZ7MYm?=
 =?us-ascii?Q?jHBJDTzjWMZ1T9ZupZj1yLmfCtFvJ9XZIXBIn2esFx8TnELqLPhobtUzXJZo?=
 =?us-ascii?Q?48uW6TK51KbDwz5FN2RTHEKKc2wkHQ9axmEFUVBcSErHPUEJQyzmtgQTB5Vl?=
 =?us-ascii?Q?TDuajQxbSp/bZySk0+8tuvIpMu5rKsY+ho2wVNvTa7g8u9Ne2NK8dfwjEOCQ?=
 =?us-ascii?Q?tCQBBGSK6d2HVZs84wW+npsv0rnY9To+p6PkYc/XBV6EleZWB1PQTqEykojm?=
 =?us-ascii?Q?Cqk3E9Nr/dwS2IPg7TR2LNWYPZM756maQsARAt1wJf5lHOG0PVV0L1hfxpWW?=
 =?us-ascii?Q?za0rYCAaXWW+YlS1NAR+VD+DRgz2F5VKdbsnp6ZwV3/VsPA8wocKtOHL+zQi?=
 =?us-ascii?Q?Xt3+uNWpX9U=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6jIehKUcneFDG1zDKFaFkuxUaQsVIZNcI+dmwYK7640S4s/tY+bvSg/50FWw?=
 =?us-ascii?Q?OgOAFNtX/CO4VGRdqqM5SOGtww2SFOQnFadF0GQ8vYTR6GIDlkK2xsaAJ8UV?=
 =?us-ascii?Q?qqsTR3ZYkW3s3iDMKCoCg0pkKZjiv7CI08Havf8z6S6wJbVbpilWN0RWhb0m?=
 =?us-ascii?Q?5pLmS5dB4cPaUP8Grpw4mT+9lxsDLHgQNmoEwEMbd901MtyYtH7XDmjb0yD5?=
 =?us-ascii?Q?GDdQwAbaULjHOICOrUV9EeM12JusWXEi/HRjWpt+IxG4w8i3Xu8YbKTITsXT?=
 =?us-ascii?Q?PtRGepn/eIp10wfbvWHVxP6QoHo2mq/sEGSTlUAmgCdYw+rvnyiMhA3qqGKd?=
 =?us-ascii?Q?EKNoi5aMGlL6fCbyIKLgZNL+wbiX/JPPccTJALw6n+VrUZVTJjemlNStqS5a?=
 =?us-ascii?Q?CRvp8MxLNDo5uwfbVxapMtxV9hWeTDOHon5xg4sQVduz6B/Yk9LpPosWSVUT?=
 =?us-ascii?Q?9qnTRhKEqyzu++t+K1c9Vezr8xJ5AljQuIE8A+YlupfuNm0Pe3c/56N48cOb?=
 =?us-ascii?Q?QoLSqAPtMVw76SSpKpUONG6zkxl+VYhtUrj9ZXgMRDlclsjdHbLutYzXwJfY?=
 =?us-ascii?Q?SfDIlVyypRuwY7L1seLlXfG2oGZNC/sSy5hFbyJuX5Oo7TiQ135PIBZMBF/0?=
 =?us-ascii?Q?Ip1EWpglfVCpCXSHIjMbhVcWNaAL5GWjccIzRX2Qp1QkWNl9TA6rGlDRJD+2?=
 =?us-ascii?Q?7x3madmh5FPIDh48tKLvFnhIUklPbr0O+bzFF8YikclBb0prePGMfZoVzXBF?=
 =?us-ascii?Q?z2ZoRJSPV+Ju8ji1WeA0xpJ96GTlVhSzvHiZHOUbCN/uMHcsoCiilIvgChGc?=
 =?us-ascii?Q?PZVvy6oNLbemQARoWfkhXLspee6IGZ0lx9Z5ncKcdRV3/UgMU4jXpDCBJdjG?=
 =?us-ascii?Q?0hpfyb/+wmnuDkccKhw0MGNJTGoengp4vbh8JEnG0Ju/CrrBsapVu8aSrcDv?=
 =?us-ascii?Q?3FkkCgIExLy6ElmTqDU8IRUpB4UY7OpWWZ077kZHDkoEPewPUloyWQKHKj8i?=
 =?us-ascii?Q?tIRD/pL9SiYm6TBSJh6sEfGWRGwm7LBxbVWtPJrf/pflW7oAnPpanP/GyZ20?=
 =?us-ascii?Q?YbvT1cKBrwnaqpGqTorzD31Lrvk4a3X38O4FH60iqH6/XHoaBUB/svd6oMGw?=
 =?us-ascii?Q?D7dnSY0BXwJnaKMI2pt+DeIdaT68q3C91IrrYdY4BSyzHJj720eGaw2UKctA?=
 =?us-ascii?Q?vz26eYXhL6d1RLp/jMrQ4eN64i0NdxQlKKf1mxyjLVoH1mkfJXLU2FEGcj+E?=
 =?us-ascii?Q?TaWJtFDjj45GM9qD5hkhWDx4s8mVG9FBhIQ1E/4gG/evJ57msPCdTBC0sB/p?=
 =?us-ascii?Q?MbRWFpV6Rwprx1Yd0z9ev1St3bm+QnfvxtKWPOc+12Sy5sy3luOZxmo6jlI7?=
 =?us-ascii?Q?JNvHDKN85NpAHTb4qbbJQakoi50tDtkIqyT3Vqc4lIqZ6jH6QqMbQrCjalaO?=
 =?us-ascii?Q?6ATbrAQ+tas+oHjRzp9E/SDBEdGh9JRbA/czc3RXoDnQcYnFnUmh20GFX6Bk?=
 =?us-ascii?Q?2xqPE6EnubM2CFTxpHIA0C1jGJKUqnHaI0uuBa/HKvGl00pxD/jQJJqucIch?=
 =?us-ascii?Q?IpC7ht5mX7OwBmcPVkKPUwJX4yB6SorOGno3bLPp?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f619df36-2515-4ba2-b3f1-08dde0f03b24
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 20:20:54.7076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y9Fke4yeWvHxDD3HPGMFf43Uf0a/h+ZaKyS5tFV4TnJDPSmOfCjHaQFDFZiDBtKA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6002

On 21 Aug 2025, at 16:06, David Hildenbrand wrote:

> In an ideal world, we wouldn't have to deal with SPARSEMEM without
> SPARSEMEM_VMEMMAP, but in particular for 32bit SPARSEMEM_VMEMMAP is
> considered too costly and consequently not supported.
>
> However, if an architecture does support SPARSEMEM with
> SPARSEMEM_VMEMMAP, let's forbid the user to disable VMEMMAP: just
> like we already do for arm64, s390 and x86.
>
> So if SPARSEMEM_VMEMMAP is supported, don't allow to use SPARSEMEM without
> SPARSEMEM_VMEMMAP.
>
> This implies that the option to not use SPARSEMEM_VMEMMAP will now be
> gone for loongarch, powerpc, riscv and sparc. All architectures only
> enable SPARSEMEM_VMEMMAP with 64bit support, so there should not really
> be a big downside to using the VMEMMAP (quite the contrary).
>
> This is a preparation for not supporting
>
> (1) folio sizes that exceed a single memory section
> (2) CMA allocations of non-contiguous page ranges
>
> in SPARSEMEM without SPARSEMEM_VMEMMAP configs, whereby we
> want to limit possible impact as much as possible (e.g., gigantic hugetlb
> page allocations suddenly fails).

Sounds like a good idea.

>
> Cc: Huacai Chen <chenhuacai@kernel.org>
> Cc: WANG Xuerui <kernel@xen0n.name>
> Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
> Cc: Paul Walmsley <paul.walmsley@sifive.com>
> Cc: Palmer Dabbelt <palmer@dabbelt.com>
> Cc: Albert Ou <aou@eecs.berkeley.edu>
> Cc: Alexandre Ghiti <alex@ghiti.fr>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Andreas Larsson <andreas@gaisler.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  mm/Kconfig | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

