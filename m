Return-Path: <io-uring+bounces-9418-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3119AB3A915
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 19:58:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ADF3B7A69C9
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 17:56:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BB81340D81;
	Thu, 28 Aug 2025 17:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SPHplOZ3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vmaMlLa2"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F276C279DDB;
	Thu, 28 Aug 2025 17:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756403880; cv=fail; b=TVBth7MFFgabrBtkaWqgs8bB+8O77rkb4V3vJhxfUXb/iQ0a+FXfffP5KxmDPi9tpPxG5/ILexNM8Bbt6jgQyoBxCtYhncIPbyQylGag2dN1u6Dl/8C+VDQ7Pi/yqBcr/nuHyLhsMxCWsdaoOgVQWOelDkUru5eKXqQ+5ITOXL8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756403880; c=relaxed/simple;
	bh=CnFvlia0VB9I9FWKW5/GsP7fb5rOdRsNcG+dQENurdI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=e11yzUq0iVLkIgflY9Z+xmGNB8TImO9KdTVruN1KJXjITyGqlJE2e46V64RSh0+5EHE08sF4yQRE6FaRb4IWrEGc07D495x9NsPd4o1lRrVMcyRBZyqBIiAyZKQcD/j/Oj1mgCWFH+qaoboRVIa9bKIyCJCojfmlTcolneiALRo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SPHplOZ3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vmaMlLa2; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SHNRVZ006087;
	Thu, 28 Aug 2025 17:57:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ZfzzjRi92NN1G9yBJW
	oPuafUcb18JJauRm7o52cmX94=; b=SPHplOZ3jizIV2PaJBBQWT2ggDSejNR3qw
	nQ8IwqVyks/FWb8fVhT+7B37Q97SCdVpEZ3TmHfDb1fdga/r3bm5KfNCVJD2tzh5
	i4uMyB0H65mesYDN/OhHPXyPjUC7r8m/tB3arlYaB72m5wiodtf5wneFYN1FV9xX
	JDodAKIKRYmt8Xycpv9rgQrfGP7jhNZKSmvZLnI3u9ifjWpTK7FqddBLhaEdW+9k
	/XrumMfu7O09XxT39Kc4VwnNuhyRxkKCHLP6+N0nNgwOykRZ2fDR/ydB4zx2KyHJ
	FMgQofqeT2mDGw5nxegJmBXI8KwSRZ/ZCZrsksr9IrMb7AWTWRww==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q67913b5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 17:57:07 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SHqATX005946;
	Thu, 28 Aug 2025 17:57:05 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02on2047.outbound.protection.outlook.com [40.107.95.47])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48qj8cf190-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 17:57:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c6mI9730cOHrqmJ4I1Aned9Osu8zlENyYNYtKZcNCE7XiYA1q0iLnqRwLHRV9sOsCeQ+luVvl3mYaNpLwIaOqjA1bg8TkpnoTPu/0yfzxcoWwzNuiZVDn4e7ugCwo7OaAWpu4fWdGHaP9/W5cAsysq68BXEv3D2T4JYMQ/bHpCOf0CMTHx8EgTHn6VwND1NchHFg0PFZ+/Tvk06IuGeVGwoDj1VszWe1ESSS9ArydBmXIpXcmkcd4B6mMEorYzOY79nmThG7rIBLtmj/6jWEXPBoBOD0b3plcj3iD32aspKKi1Ysndxo8PZ80wHwx/fgok8/G7cYPIES3vTFUDUI5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZfzzjRi92NN1G9yBJWoPuafUcb18JJauRm7o52cmX94=;
 b=sBb7Ak7+zj9pAkUiz0djip1LcIbe9PgnXgc4BPEkZOJEhhkbiY5L00vCo6f0vOptF0ugUGkpqKhvqltRgSGASRmpVCTh2FrizW67hRUt930s/xoKFAMdtdj+fCh3H2TDHxmEdreN1LjFGVyqFwSfmAor2M33ZVULCv/HPkMC2I6Yg3+hSDk9ZaGksmWqkmW8wiPxNlTB6RxL5A21h/Js2Za6g21+t7+S2zPd7blOAv5XYu9QaJZpnn4d3IFBem4l6vIaiUsUb3qXThRj5y2ERvpQ2dFEHES4wZPmUj9KmOPOdsHSlWwCCp+/5joB7MOSMVmUkkCnhJtEUNM+bB6LJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZfzzjRi92NN1G9yBJWoPuafUcb18JJauRm7o52cmX94=;
 b=vmaMlLa2Es6UmnTfiooq/86A1AP6WEQXaGsCREZpZJ+sxQ4U5onZGXrbEq441/5aRShblB50UM7O+VRktYdA6r4Wl5akw6i/3Gct6bRB9K6IdXvLN6lRmWhFMLcExxETI8JP8kVoJKM73t9UajZE8jO/iGCVDCUEgeD4IOgFOmU=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ0PR10MB4573.namprd10.prod.outlook.com (2603:10b6:a03:2ac::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.19; Thu, 28 Aug
 2025 17:56:57 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 17:56:57 +0000
Date: Thu, 28 Aug 2025 18:56:49 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>,
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
Subject: Re: [PATCH v1 26/36] mspro_block: drop nth_page() usage within SG
 entry
Message-ID: <1e64780f-b408-41a4-8cf3-376e5a1948ca@lucifer.local>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-27-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-27-david@redhat.com>
X-ClientProxiedBy: LO4P123CA0636.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:294::14) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ0PR10MB4573:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f09c2a5-82a2-49d1-89d5-08dde65c47bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?l/xGlueiRXDuNnHk/vmNVseA9OJsxtwuAmA05rRE61CBcJMiY7/q3eZSQ/ll?=
 =?us-ascii?Q?AD7ZswOrdLO7Aa3mvYtdFmYo28tQLmwVtHXoRPhwbtsiD3mGDh+R5ZBf+ro4?=
 =?us-ascii?Q?IixWvDi2/CYGIuC8geWPQiQouLPLFLI2LfGOXvZgHZ+jv+2TEa3Y6QpA6VK5?=
 =?us-ascii?Q?0G++h6hmYrZwTN8wzGwuvalVajPAeY2mE2sYSZm377nOAr/IsjXC+CSxxpGH?=
 =?us-ascii?Q?pB+GmZJoA1k/E50MNC2UAHf4cPc8BtfPxW+5KGpej0Rnz53uUD4xRnXkj1B7?=
 =?us-ascii?Q?rVoMo2JHO0+6lcq6QhVxDV07Gn18qOHKhzQ6+78sGtQDCuk7r/ggukLvRJ++?=
 =?us-ascii?Q?8+XsOnxrMhM0dwy0VlMlBy91WwjY0KMvyMW3tVWlxn2PTDuF+qW+pHbBbQPf?=
 =?us-ascii?Q?+7Ko19YcA+34gBopNUNneyLN2Uwt5uiNthN41pjqAeEenCpO9d4I/tp5oLjF?=
 =?us-ascii?Q?EKj6s+rVLuDxBcz3+sK5ewxRjxvi+501nN55nZFeJDKaBl8RpXi4RY0JjZSs?=
 =?us-ascii?Q?zDcBHPzXzSWdquuJdUaW2a9JE5xKkHG2T08/5QG2XwXmN95i932nAr5rtIlt?=
 =?us-ascii?Q?xuq25idTRQCQf4O5hR8p4XsJbNx2NtnPaWzjaGVjF9iLTonINo6zGwukFaSU?=
 =?us-ascii?Q?spegh8rSplxINyEIJc1zf0UR6jNyCMQegqHHZkCzIGOgzhcIJPxdStrYeWtu?=
 =?us-ascii?Q?SmJhSoMXcTm7QpShjKrQSMSxaNsELxSBwYiKQTsmFHSMFlqp8rUCiiLiye/j?=
 =?us-ascii?Q?/xBuK+RwKOa4fBzlFRluf1Deq0UZImg1JAC29gmiIOKKqWIVNmeMlyqp2287?=
 =?us-ascii?Q?3Zh0NadWQOaMMigwCS/GzgDV6/pqUygOQpaRYIe6ya+Q/n0K4o/GHPDrQ+M8?=
 =?us-ascii?Q?+8Ta6UTKBTufp2RbIabSbjN/CsF4oBaxBV+rTgT58XPsRcl3yX2k+/tHw14Y?=
 =?us-ascii?Q?lCF+g38h4VL3uZfR0dy45i43ppM4QQLpex5/BRl97m+PWqxXBxIVXmdCXhzt?=
 =?us-ascii?Q?LkgoW7P3GeUJlf9nhIwdDxt5YG6Dbs39gkYoOAfOwkeIMHkAvRrhoYtuT3hB?=
 =?us-ascii?Q?Rzkk4p8rLuqs2OU2LUzfI8S4wp5e+NDwJjhnNAk1BfV/TGqSVCL60fnafpF7?=
 =?us-ascii?Q?sH49hjGK5NF6T3otdZTFSiVBRGoT9lfXvvd0f3LV1TS72bdvkEjzgpBfe3uN?=
 =?us-ascii?Q?ZFfiYovbDsIs1x4ZPnNL78QpKAA06xuplQuuXd4P7QyGrhtku4SaH3RjJaQW?=
 =?us-ascii?Q?5NWfED/VUNqVEztpYI9u+3PUSbfZtlTI8UY1mzxZpUJqDd1ov4lV3iizA1eF?=
 =?us-ascii?Q?/ROKn2KmhBLZW87w2acLdXYwZHUbbCBmclSBPbPpdYW9wymD+yKr34nl9RGH?=
 =?us-ascii?Q?Fk9865cMn3CaTk9Zl+X0khvl22suWXGO0V9dT9WqPDesbj5qol2lp8tnpr7k?=
 =?us-ascii?Q?FWkTME7VTOE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?swVIqMy6S3xxendBfIuktA0LMcdj1I+kx3XngcXpHAA6Ir93quOtcf0xPY8p?=
 =?us-ascii?Q?D9avZJJitaMyr4rChOjXxv+KRkJSbp9QQRrfhrr5HS3xg3deVImXgcbLxEve?=
 =?us-ascii?Q?Bx+wOBRTTl8VVwXuiVp5zRucfqnu2cYtTO2F3B8TT+ysQoTnAHR6R7qyCT+D?=
 =?us-ascii?Q?gyQP2ikTmr9ALDZ1FCR6vAzW1lSTgx1JJ3iPXI38kIHDd/MBbFrhKXqxSQxH?=
 =?us-ascii?Q?KBvTKueAHN9N3YekFI5bevOpNDL2FtfOI0gDhpuToCKyCvdBMFztZYRDIFoH?=
 =?us-ascii?Q?OHMN1RKunahGRONiFtw8HghPCkDCu3I4r+uypG8ToEgEb8dOhXVHIcM1oa6p?=
 =?us-ascii?Q?Era5xKNWWex0hBnTDfayYzD3uCW04U8ddCjftSmP75cOwJLtgtGXqyHz8d2D?=
 =?us-ascii?Q?R66UU+Ibvs1rLHQTrkipDKjIKx+2VV+9Q/WmN7N8rebO2mvRdLoOSDuZVQGb?=
 =?us-ascii?Q?+jkVRtwyu4LAxaMMDfP22cvY6IXYYRlTrHqXdHSmdyMo+N2dvq3KIztrZieV?=
 =?us-ascii?Q?hyl9E4l8OZAsZ5803zsunI3qMDuQCPDyyQyPz2ae+tSJi+MnjO01NrsYgOhi?=
 =?us-ascii?Q?P4Wqwkn8effjEV2kqf7r5j+QcGmtGxoHxNd96RTLsVGEMog/1aqTS/CseyzO?=
 =?us-ascii?Q?ATS7LcBtUldaABu3/Zi6u3HFBXDhphkp/B5Y3Jfs6Q/zTDH65qpygy80jTcr?=
 =?us-ascii?Q?VDNXD2ivEjLeIg+41Lqeem/TZgKQ41mhV7qBUOnxd5MUH7ydy3rrNkQl+nk1?=
 =?us-ascii?Q?QUybqjRGDgcfKnYn9GYQIKryOwDYrSvPgY5N6N57RhX+LcPNnZr/5T69g4p4?=
 =?us-ascii?Q?xDgPm1oVbpy9iRqheyFWCTworM50YM+Fa0J2aRY8qFyJDV9y+/sXjIqOPnPB?=
 =?us-ascii?Q?eJKM3evBstXnrEmq3U4lTzuUF0N4q6D+hhhZcSSFx/VUU/RTbByWsbX4dyNZ?=
 =?us-ascii?Q?ayWXnx893mT0T8soCab0bSHL7F6mEYKBpEi1QgZVJSNjyhD4+8yci2QuPnM6?=
 =?us-ascii?Q?e7Wwvo0XNiVKRwpcavvoGsvMH3okM0e7X9Rz5rGou8p2UNqhJxXvXDHACeHe?=
 =?us-ascii?Q?tZliRN8NTcY8HLDn+7s9N7A8O9VGch9R/Zh77JidSwxgBlpsp4UBuWDZ4WtW?=
 =?us-ascii?Q?HeqM7fESYaJAeXdQsrSk+1ybnPxb0C1DfJ5SPHnrBEKTXPFsgDIzKYMW21xq?=
 =?us-ascii?Q?a6X63diY/MUxZqEHza4jgZq4gHzkhi7jJ0wG+0aRBZdrENrpuqxlM59Ha+6q?=
 =?us-ascii?Q?2K1EaWLI4YPvg2KnNGn0zmZixc57bgipcrXMKgPBgvTS2cVhmd34BDl8kSXC?=
 =?us-ascii?Q?Mt4FntkFEWJ6XryhmisNFVUhxQudR8bU9AKGDgyaQWjugxjolXJz7jBLj8dt?=
 =?us-ascii?Q?TONZL1GeyBmtnNWsps9zHcR3z7xsX8lPu62lV8Sz40B3qeoiFeobmB4Jttcd?=
 =?us-ascii?Q?+pWoXqAY/iJKI4ENYaLXpKxq4C9ZZRkEBTFtfD/CgDerhef+k+Fiss7qPiTs?=
 =?us-ascii?Q?3wcnXMzLCrRPCku9aARVJmAYKLrLuWL8mGiU7bfHOAVW26QgyqVcFDuu8box?=
 =?us-ascii?Q?TG3edSXSrcnYEZzHogySvlqEFaz/IJPTN2XHIf0V8iC+vs3M9GvC6zD3rjFL?=
 =?us-ascii?Q?2g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZTdIskAaRj6BSEdlRy7ZmbQinwOJGxQIJZfRJT5ZmpBKeVZw9HUYsG3ByyQ+b07wld791wmM3edEdZYNH+rxsdXX7KHyLdVQ1JvsdynsFta3C98+7n4YjlV5bEDV22E6PEmo+usC06R3zaETR3wq4PWwkyfvsteUDU9v8D0WTj9iv9X6mlWvsL2wdJ0neUgMS71E8lKNjNTi4U0vNC0xX3xr3My1h4koRIkKvipUWPb5qYxQ8owk1030brUh82fHU6mqHBL4nHY37xVf2V3hr0QAO7oDBWbd+LTrswBOoZ5CtQvzSLF/U7XUj+bcBmB5UCbbdAqFtZ7uhoFdgvpOFDzrUVtrIuNxLcRf2+9Vj0oi3tMuHojMv6AS4IxqlcT5WrhgS4pVfUtYwJyh86C2qbge/CmEnKH8BtHY/i/TBK3zJbiJyv28KVfgDbUGNnbMlBYB1gWQ3enn/iY1id+T+FEt/rjD4X6a/+mg8CDPsJnavIDof6YH0D/4ibPywyj0++kxr6W47L7IpANkrD+Ocv6smSLyde4bnjHDhuBaUSrCqyzBnp4JQyfvWr+VXaZ4Vy9bjZlIKCFxKQamDrpi58qFtWKy/Nv7oJ8lfawWdBI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f09c2a5-82a2-49d1-89d5-08dde65c47bc
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 17:56:57.2255
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mEtguQtg7+7LQX0EGg67DTZF5BgI2SGLw8HFhNz8ra7CEcXkE7tAkARYJb+0lYAfWX09d5r8Y2nKypdFk4nB4U68WLaNfJ5eJ7ZqdjbW2Sg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4573
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508280150
X-Proofpoint-GUID: vwNRsA0xGPkEFvULPYg7dtRsKoTAKUpl
X-Proofpoint-ORIG-GUID: vwNRsA0xGPkEFvULPYg7dtRsKoTAKUpl
X-Authority-Analysis: v=2.4 cv=NrLRc9dJ c=1 sm=1 tr=0 ts=68b09873 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=KKAkSRfTAAAA:8 a=pGLkceISAAAA:8
 a=CjxXgO3LAAAA:8 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=PrhKhS2d-JynFy5mqoAA:9
 a=CjuIK1q_8ugA:10 a=cvBusfyB2V15izCimMoJ:22 cc=ntf awl=host:12068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAzNSBTYWx0ZWRfXyQLxNoNHin9m
 sJ2mHGnvmiKWL9e/DXS3Rs2Ph32VVgH1chHsFxc4hazBf8jR+z1bKG7fO13NTytlpv3JoO4d59g
 coBJnMZnmUzkTNOxzPtyahea28Wp+hNwGwwI/aEbS5npqo4q5pOMntfEECn8jGvl1M42ZbQxrCF
 01dobcaJffjGPEJz489NCFK3nzSQoNvrOfwZH0BdYRmaYwQw0F0HdwnmCtUQyGi3Xy2M1IbI2SU
 pdMbAUkgLNgYlrKi/0DmqGtmGCJXwNSqGq/Nce31mKwzLYAT0O6nnOOFZ4Zvw7N1A6VERq+cpsH
 gDOBMJvZNk0bESST8TLrhrcugYiVtz6TqUHpX5pZgrSLDDOP0P1UI12pNYojRhw7gLPePNtiODG
 dNkPFrnOaHSWVoK1X4Cs1Fx3DPvmxA==

On Thu, Aug 28, 2025 at 12:01:30AM +0200, David Hildenbrand wrote:
> It's no longer required to use nth_page() when iterating pages within a
> single SG entry, so let's drop the nth_page() usage.
>
> Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: Maxim Levitsky <maximlevitsky@gmail.com>
> Cc: Alex Dubov <oakad@yahoo.com>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Signed-off-by: David Hildenbrand <david@redhat.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  drivers/memstick/core/mspro_block.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
> index c9853d887d282..d3f160dc0da4c 100644
> --- a/drivers/memstick/core/mspro_block.c
> +++ b/drivers/memstick/core/mspro_block.c
> @@ -560,8 +560,7 @@ static int h_mspro_block_transfer_data(struct memstick_dev *card,
>  		t_offset += msb->current_page * msb->page_size;
>
>  		sg_set_page(&t_sg,
> -			    nth_page(sg_page(&(msb->req_sg[msb->current_seg])),
> -				     t_offset >> PAGE_SHIFT),
> +			    sg_page(&(msb->req_sg[msb->current_seg])) + (t_offset >> PAGE_SHIFT),
>  			    msb->page_size, offset_in_page(t_offset));
>
>  		memstick_init_req_sg(*mrq, msb->data_dir == READ
> --
> 2.50.1
>

