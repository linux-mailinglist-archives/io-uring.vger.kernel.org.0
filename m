Return-Path: <io-uring+bounces-9410-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F8D5B3A69B
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 18:41:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A9449563033
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 16:40:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF345326D62;
	Thu, 28 Aug 2025 16:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="e7yPOHVf";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JJQz+YEJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D435432A3CC;
	Thu, 28 Aug 2025 16:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756399126; cv=fail; b=gADrNnT4DTcPPPcyu/m0wNsBlGkSQ8Ibdn3qyOHQ4jPwBqlI04gIbjQ10NOaoB+3sb5NRWfYFr+GX+KkdkUuDZgf7bdp5zm/8QBMS55yCAmchm6iKEEKSe3x1LBoSr3IDY0ij6IG8t6z2crm7lRgg8XzCRaPNXe0MviXKEERsPc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756399126; c=relaxed/simple;
	bh=9ULSnH3t9TlcHQAXbhmoCCnaitOfcTfdHF4hM2HO9xs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nciGyTX0O20oQeHz6CYUx7yZ3y72Uz4r9yPxwBkcYf6XjfsezAGMfJOqJ+5uncbfAIk9qKtqGwaSJIItaaIQVP4TywkeNdIiNOBQ1b/H4QnAwsiz1rsdV5ApCCwP4Kl6tooje9j02Ki9jPTy1JPgia0mCSLqdEcQWL53eRbGmII=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=e7yPOHVf; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JJQz+YEJ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SENDLv016398;
	Thu, 28 Aug 2025 16:38:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=uaJlJ1VpzBDhm5ln6y
	g/WhLRDAxiw8JzGZM4doGLJ+4=; b=e7yPOHVfP6ZlJWKQXSAKNgfTwabWjaEEPe
	8WpxWCDJ+5rJUkAezDdfIjmUAYzdw5poGniT+N9pi6i5iuNqsx65jGXg5TtjIRWy
	UQRM0IYhJarpDZV+/6yMApBYXKhpKStR0BnIgIrFy52akRLLklGu10QapFeoSTqv
	qdXr/D8CGA9xBDSriGr7IqFWmcR83AwMhCZsB9JUvxuQjv0z8qAb+HAutMNFOYIh
	818T0KHorhsKrHNYDvvmk+cjlW0apEhHc8Td2+X5P3Tt1zNveqYHGQYKTYsr/e6S
	zMul72VITKFVAtI8KyV9F/cXdcVOlugE+emOxdlCYu/fFtxTQ4AQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q42t8sce-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 16:38:10 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SFpR5M014687;
	Thu, 28 Aug 2025 16:38:10 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04on2040.outbound.protection.outlook.com [40.107.100.40])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48q43c3sw6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 16:38:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BhMUJjYKO3iE+gjKKcp4XGGEx5ruOhrAdGv+I9ycPeALlc8sIM6Sjzzhkl4BoBc6cCX5J8eCzcCrDcIy6BJZj9W6vX7KE3K3u2+rO5fY6iGoqnYm49tE2vOUGycySiXs2E6TqOPg83HMfcz4jmPZ1eEOOuQIIqwT+kKy83CrzeBN5G+jLNyTaww/wR15c3cPn+1Cb+j0bpX9RUDy06js5YYBSL4mpllmzubfb2lAJNQDNRsrZ4LA3OcmHGBH+xP+QkuQm60wzBzRPOKm+XQlCNTlxLOVDjD6C3VZRBvtYCG6HTkcJ9nuSBGAUPJKYi8tLMivr7A5TQPxGSqzgDxJ6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uaJlJ1VpzBDhm5ln6yg/WhLRDAxiw8JzGZM4doGLJ+4=;
 b=HM5cUVlQHNXNSSs9hIrdv4oE+jw9l+8+/vkpcCfSHseEARrncpWmH2rAaxwcYjhOnLy48MfIFQF076PefZ7KU98d7lZ9UHdPo9OUEzRMT/YcoGEztwpvjMEVQlSV7m93veGbtMON9Wbp54K1Aakm71qcTueN9ww/SYehSEsaG9tdkzS9/QuXfmZAhpS46Ro/8bpWqdESb0xwjNitGVjweck6HowVov6Siz8PrPbvd8BSAyudijTdlAmIDWAG5oCJVcE9Rx8ZQ1CUoQdzvEPyDtToB8qSY++YYlz89C6fDmTUzErO4wBTrzUd4drlEyb23ShTv68ZK+Ls+7tXSl2wQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uaJlJ1VpzBDhm5ln6yg/WhLRDAxiw8JzGZM4doGLJ+4=;
 b=JJQz+YEJ/gHXaXdGESfin9K61VQlVME9hGQ7KytLe0pupAxnfgiAYFJVINugwoEWCkNm+GxM2uVAmByWOgEi6pNKEBlbu6dUbiuWTi9z76gw3dvkaghXQASJfBEEIy3lBkskV9sVB8kGO/e44gmXNjMTQGGlm0AuW4k8gGIFOZg=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by LV3PR10MB8057.namprd10.prod.outlook.com (2603:10b6:408:291::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Thu, 28 Aug
 2025 16:38:03 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 16:38:03 +0000
Date: Thu, 28 Aug 2025 17:37:54 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>,
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
Subject: Re: [PATCH v1 18/36] mm/gup: drop nth_page() usage within folio when
 recording subpages
Message-ID: <c0dadc4f-6415-4818-a319-e3e15ff47a24@lucifer.local>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-19-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-19-david@redhat.com>
X-ClientProxiedBy: LO4P123CA0587.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:295::15) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|LV3PR10MB8057:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c01b0a7-08d6-4abb-c8ce-08dde6514259
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ixjgp7QQqr+UHMcLyvNXTP/CfS2wxZ6aRULFE1+z1FPbptiyd6SbYzwliU6E?=
 =?us-ascii?Q?Cob3Y1mu7IE0iHGOsTP94DNO+p+Qo7TvHHyVYH80JQPfW8xYPVxO9g9Lw6u1?=
 =?us-ascii?Q?AQmf1s9LnTqu550h1XHN37QlPXP+mlb9MFu89kVwnzLbrgzcyql77sMte/Vd?=
 =?us-ascii?Q?28ty/5zyhVKVvKw8d64dv5G3y82QDv+RwH0qMi8G02NnBqjAz9oLgvjGkIdA?=
 =?us-ascii?Q?m75m1yBVTDtRKBReLFJt2m33PpVnuxWdwxrrqXFHdu9hu2InjbbwDnvNWQaP?=
 =?us-ascii?Q?Ha8zc5G5S13RjPmFnAxDBBM3uiGV5oAzyLI5U617NM7yuR5VfIGSxWQnfCeG?=
 =?us-ascii?Q?uPaEW6uS7pffiTVQMZe/PMgvt4238FMWQ4HoD5HTDRumng4JPnJRByPzk8LH?=
 =?us-ascii?Q?Tp7hR9akVXu2xN4/pzA2o817kwZ5mLT0C5ejpw0dw3Npr5C4/8KsrK6SNSPN?=
 =?us-ascii?Q?N99cxA9rmwPgUihkSE3+1Qq+KF1DUf1oa6TskvXCVnpmocGj9IUxUnQG6GpU?=
 =?us-ascii?Q?09ZXuuNLH4Y0M/aLHnEQBFst7DV3i/yo2HCy5dCWHPCXgZWTjLbMPRSrtHbg?=
 =?us-ascii?Q?hy8/UPANLV46WeHxJlWtWyBnyWjOEp6zFtOH2p1eNONuazb1XLNqFWETWqo9?=
 =?us-ascii?Q?Xnz78pww5XHcu5sDsXf/kPsRw/99OBSzgfOrTeX/WhMmRfiUOXjpuIxqoRoz?=
 =?us-ascii?Q?6x9RznLKofjuvuavnRrNAKsI5VsMCw3BWWGanLDGod7TsD3pqiqTwfjgYK5A?=
 =?us-ascii?Q?yc9TQQTad7dEkeNONHWFVj1shYlGue5l5yWfoaaDy7P+P6ArAo1R4zi7ZLgs?=
 =?us-ascii?Q?usCj4na9niTWNc1K0uG0/73P/Qb84bF6IsLsZGdb9k+bcOil3T39SH2yhPtt?=
 =?us-ascii?Q?a2FDchOPomSqg4WDEL70fUW+aO58cxGFN/cIEcx2uv47hxPyIaGrZszmMKLI?=
 =?us-ascii?Q?vHs5B3gPD/m4gwdG4cEAguv+e1R1iMFeCcYqSaV6PMTaKNtZQEzOELgwms+X?=
 =?us-ascii?Q?garn89CFISZ5kxvkhkWuSixWqq7K5VI7sqKv9FOuHSZDkTDCfEpwIC0yHjFt?=
 =?us-ascii?Q?/Mf5YPsm9J07DrjItlBBY4dS2nmOtKSmRArS2CXr9k0CNp9v0aYyk1IXSz3D?=
 =?us-ascii?Q?inirIwsuM6OCJJAkzO1WM99EThUXx3zniYqUBa7u/SYtUpSTYqzY2uKF4fTm?=
 =?us-ascii?Q?tg54jL0+Ojsl1uxEiS3zBOy5vA7UeK2eMh+iIyqDEqKOvGanllnbDR+ne4DV?=
 =?us-ascii?Q?vxmcLEdI55xMEJTEqkMFgj/IEjOZm8EHOEX/QWlVFAxIo9onB/0m/5G/3P04?=
 =?us-ascii?Q?FLyS8sLy2FCzNnebe0UFPyDTiQ7PaaIu7isQgrXWgluaeShAgDjCf8Y3xnRP?=
 =?us-ascii?Q?xrApe9H9Hh4EtHP1yWLI9lcy6WUtpWVcXyKDAtJr9rmCPPo9PA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fUCLcdt+0CfXTAN9SQ5d5mAQsra91mZlysVb/Xt83t+o0EYNHCpQ7jZxWhKR?=
 =?us-ascii?Q?lqlw1B57Z+AeACATEhCHEQmM9Gs3/hQDfe+guOy9fhcI2fekihv9L8B0Gv2f?=
 =?us-ascii?Q?MqvfD0bQoZad3IFB4yqV74Hs1zQfD1STAJEuAvNr6piqfGPQWenxV4LXzPek?=
 =?us-ascii?Q?wlOrSVzkbFkrc8aDaj7wxx91Gj6EgynJvyjH2gLld3i7pRVjvXTPR5orxkOF?=
 =?us-ascii?Q?Z8ZXApM40k1rwCPaB2UExqNH2xLJk4TOMBsNQSdR+GTD5QLGwrOficYFaIDl?=
 =?us-ascii?Q?pTvBrSxfnSvCj48Q50GCvIWpSTz0lZW6wllXPyOp2xOph8alH2GzOtPqIbr7?=
 =?us-ascii?Q?Ll1wuPgbVL4QZamseM1Vbi0N8msW1JEM6A2O01+UCk+JgHXfyNTApQzZqyzN?=
 =?us-ascii?Q?cD5y6vtOHRx5ABd1uhZL2troE8R78SRobB3cXXC3AFqueffAXfiHLQ3qJPDH?=
 =?us-ascii?Q?DPG5tUFhDVH1NF9O2ZELVOSvynUaZ7BtCb1hH1wLoOh1l6T9d6hJ05X2mRPr?=
 =?us-ascii?Q?Gbj1QO6yvyedZHkm2xljqczHojkQevivyzbHtThb7sMiJA4960jA6M5l2/Lr?=
 =?us-ascii?Q?eOGf56yA/eKG0Yk0dLQwKYrJl+XOvLDgKqjE7oC+a2zGFq0ttaJk3E3VyGTg?=
 =?us-ascii?Q?W6lLJcT3n1FpMLVJhojM0I9uKSdLq+loQC2nXjPsT2QNZkdZfHWWP5J/03Lb?=
 =?us-ascii?Q?lUIC35LrUYVr4Un0wn/fjM/ZomigrcR6RakQ/00H/T+8tobLExAgcMiNWvi6?=
 =?us-ascii?Q?xnyW/hwftQbFau1/AktSO5taizi0CyoycnUngLEJxw1GFnEN1YjPyrSvxZ6q?=
 =?us-ascii?Q?0lZgEBl6a0dH9SVnLNho8Nn2Oe1SUtUZBmTAGxGzzf5rqC1DL6kuJ17kHQHF?=
 =?us-ascii?Q?t6UXS6gI9oIrvkm8g5MLovolboqIJg2uv9i0wy6J+5dN4PIssQiqp3sQnGyz?=
 =?us-ascii?Q?oPxHqsERvJHkWZlePCvlQvxNfbVtbV7HYQ8TvKsGhlxR/nErj4x9YTchS4je?=
 =?us-ascii?Q?6FjD/pyw7LD46QVuKjy35gblvEWAuO4HiPksmkPRFcje0x7R0jwPr/C1o0hL?=
 =?us-ascii?Q?CpSHZQfRK6bhIDEIVxb6KVAOizPVipxL4TKapWLqRRLIL22vgSSxUVAsAYm8?=
 =?us-ascii?Q?AOW4WXSZxCvTxuOOe6fF1gHLblopy7cKwSMYMd14gwh1092KFEjbYDwHDfOi?=
 =?us-ascii?Q?mcFSq+n7y+CMlwGFst1oYC8NgRb+1puGrnE8ov9X8LITWm0ByEiq3QZN3w0F?=
 =?us-ascii?Q?54KKgP+W3EzC2FsMeTIF6l0i86uaPv2121wEU3Owws1k8lTOYLanlml98X6L?=
 =?us-ascii?Q?pIbujNaLEk3M7+kU9moVU/MsnjCuHxFamT23jrV3oHjCiS8qVm2F3LCW/keE?=
 =?us-ascii?Q?pjaHeY1cPiuRr1gGnYFHy7Ab+CtN95ldLfuT1QoReMcV6l62r19wrn2LL0AJ?=
 =?us-ascii?Q?RQBO5dJML6PAT92uxlxeyFB9jcMbqHpu6Qu7sBYnCcz/C+gIxuuIZ2ePVORr?=
 =?us-ascii?Q?bjABtx1j7nx4mRn0a2qtskccAi2Bu1Vz44LPDzO8UtWHfWrRU3DGgTyz2wYT?=
 =?us-ascii?Q?QNCcGmtBovz+9VOf8NOKQjtZCgXNpgii9mlED5ACe8ZdbZPysXtZGY5FihL2?=
 =?us-ascii?Q?pw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	AugVg74MaCjRsR/C79s9dkko+xF8aeuzlI6boZk55FOSeTLMKhELEn1d9S+7VzG6a6MGF6+1E7/Pcz25LM9Cs5fiZ905/1MYU8AbVelA21b6tj9akY9EZtCvPYBYSsY1a9aZfoH8h9aJ9Ul22/wBEsWPMdAGftZaOcQTqEfFnivTxcN5zpjwfPXc4naR1QGt74fU56zXd/Jem4DjqaZcY23/2zQSyt43vZmvOoSmdGqe1Uaba5Op7HXMAZaulnNRjI51e6jLvD3rFOLfPBAJqyX3CM7y3wGC9j/JLLDj6T/8K+Ncd21VpGI7325uN5s35cMN0JGIp03xxz/JCEFCSeMMsBj416Lp/Okm0Qjc8keOfqsM+/hkrbijMdRJENfWh3fyp8ETb2WULcjOUtZwWU4TTLcCppVghTS6QC4P+q3wHM5ePjIgTwMKSiPW8Xxqhzdy6Nl3bakjfFa/BcdSesxlKnF1LhydA57hAZfeq3fGX1mbl5e7h68JsoLKGf52glsDPhppYu+4G+tPxWkdYuPTqEzBBsqvCNL27/cQz6TbNW2yd+4TKYYF5oYq2epbwqxi4bG06VbCJo5N2tVwGKp5QXrOTBew7pFaW6SHSsg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c01b0a7-08d6-4abb-c8ce-08dde6514259
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 16:38:03.7162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sHgsaxWRWop3M5lv91eluvuzFtwsR7vEZFJt9anaO78vYiusNh1MNPe6WxBTiWKSdixFj5u/nIV+8xytPCeV4VJbTh7Xd0rqMqgxsRH858U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8057
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508280138
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxMyBTYWx0ZWRfX7iyMggHZcoqk
 QXKQ3UzuKAhX7Oz6W82jSFjrIdTxFO/gzWYz481kamWbsjPkbnEt2CE928dAyrtB5F2B+i3rmOY
 +kA+0lMb7KTP3cHHa+UqMeYiPsKet8HSHbh5C27kTJBJq7Q4WQln97y5GPqS/cjxPtmCzjdI/YD
 CWnlwuHwMA/2BWV/BCpYEE12HZT07IlzfNaHXk/cFRkvv57GJbi6+b3GGUOBFLYcDSm8Bzb7IK6
 i7EXnxA/oOWBnV7+Ijq7Qf0DNVntoixQs8srsIoNSLu234CHmGwz+gEu3926aFkXik/Oo2uj9t+
 KkMy0NGEo7NoTwGJcE06LOcP/qNgVFjJHffNyuX8LdhoPFYRiu8M60tZFv6kO6HHWLVioa54JD2
 XbKmOW7tZngQ57KBoO2et5z8LV9YCA==
X-Proofpoint-ORIG-GUID: Zyu2ANsSisFCOtkL3Zmq3ShMNybY-wJe
X-Authority-Analysis: v=2.4 cv=RqfFLDmK c=1 sm=1 tr=0 ts=68b085f2 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
 a=9QHQea2vdhu-3Q1MTM4A:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13602
X-Proofpoint-GUID: Zyu2ANsSisFCOtkL3Zmq3ShMNybY-wJe

On Thu, Aug 28, 2025 at 12:01:22AM +0200, David Hildenbrand wrote:
> nth_page() is no longer required when iterating over pages within a
> single folio, so let's just drop it when recording subpages.
>
> Signed-off-by: David Hildenbrand <david@redhat.com>

This looks correct to me, so notwithtsanding suggestion below, LGTM and:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  mm/gup.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/mm/gup.c b/mm/gup.c
> index b2a78f0291273..89ca0813791ab 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -488,12 +488,11 @@ static int record_subpages(struct page *page, unsigned long sz,
>  			   unsigned long addr, unsigned long end,
>  			   struct page **pages)
>  {
> -	struct page *start_page;
>  	int nr;
>
> -	start_page = nth_page(page, (addr & (sz - 1)) >> PAGE_SHIFT);
> +	page += (addr & (sz - 1)) >> PAGE_SHIFT;
>  	for (nr = 0; addr != end; nr++, addr += PAGE_SIZE)
> -		pages[nr] = nth_page(start_page, nr);
> +		pages[nr] = page++;


This is really nice, but I wonder if (while we're here) we can't be even
more clear as to what's going on here, e.g.:

static int record_subpages(struct page *page, unsigned long sz,
			   unsigned long addr, unsigned long end,
			   struct page **pages)
{
	size_t offset_in_folio = (addr & (sz - 1)) >> PAGE_SHIFT;
	struct page *subpage = page + offset_in_folio;

	for (; addr != end; addr += PAGE_SIZE)
		*pages++ = subpage++;

	return nr;
}

Or some variant of that with the masking stuff self-documented.

>
>  	return nr;
>  }
> @@ -1512,7 +1511,7 @@ static long __get_user_pages(struct mm_struct *mm,
>  			}
>
>  			for (j = 0; j < page_increm; j++) {
> -				subpage = nth_page(page, j);
> +				subpage = page + j;
>  				pages[i + j] = subpage;
>  				flush_anon_page(vma, subpage, start + j * PAGE_SIZE);
>  				flush_dcache_page(subpage);
> --
> 2.50.1
>

Cheers, Lorenzo

