Return-Path: <io-uring+bounces-9414-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B6878B3A815
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 19:30:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C20F51C229D1
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 17:30:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 907A033CEB5;
	Thu, 28 Aug 2025 17:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JsERbD3I";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YB+XsRZT"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B883314B7;
	Thu, 28 Aug 2025 17:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756402212; cv=fail; b=FBULCUlfhZoasWypQ/uw3heHWn3Jd3uw/4E9ATBgqYpkWqxxu8aUdcTzA+JwsWK5f5Zc/Nk+YlVAEhQ4WkDXzeEHw5XNiXyp0XFR3I3ppGK3p6+TdJZbH7LQY91nmW/wDaHAIQ+++U5wY+lJHj5UsGu1RSZpynu9xFu+JEU51e0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756402212; c=relaxed/simple;
	bh=J+T3JwLqucvf0xC7up6N4vbfqSsHPlM6210wd+ZUWhI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=o1m0No82Q65vzTMF7M5cbtx5TWF276nffhgNp8UCKROl0Mc3ymfI6FQNWQ9NivA/4Ji42X/GWkefkz4i9LbIu9LneijeHvg9qu2QERvfqqfgSKv11xigYa8vMMIR7dGJu4Yskb52lO3AaZRHGLT2giasK0h/PdmLjs9bRjA7+1k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JsERbD3I; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YB+XsRZT; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SHN8F9005462;
	Thu, 28 Aug 2025 17:29:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=TapbqgrrpmxfKpvaT3
	AtnRXyn57Ar30nmh28N+TqlhA=; b=JsERbD3I+tRMgVlG2uM1PhTZJzcb+ZG7j/
	FTqP7JT0HfBSL9xcIzzlPDZ2YnIgmlHB/wtHPB/gn7hTWT2py3q8+B4QMKOEh1Oh
	kj2d1aV5x9KJt6YqhKmAdrnWRrI6ANUpbQdbxXizNVwbyYh507POrUlCM8dORLFm
	+AUFdGiEMSOuhoqd3z6Nf9RU51o72y3fQ+OoZLuattw7gdgVt45fKoLlNHd+g9qi
	X+yhxMZjQcEKkKm4lFMuVdRTHMpWPnFDJj//5QJaHiacxBfMQxFY4K/edwnsxAN1
	tXY48yVJiPktBLsfNtcBMqqVSDVb0Pg23Vy9QzR4LKmPrWnzIKaA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q67911rc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 17:29:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SHM0j7005282;
	Thu, 28 Aug 2025 17:29:29 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04on2050.outbound.protection.outlook.com [40.107.100.50])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48qj8ce1cc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 17:29:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MrzV/SO4+BgQFo3FktHVwMufWBJE0ruzrTBi5qyB+NjopvuNC/CId2nwUQQ4zJXcmxGYepOhhOeswmLNjADKpFJRjYFEOaHhQqvyK2EK4q7eDX9Dzhe9PCW6mHLUzxJYSyregE2s0LQiNNYDNTmN2jZoKCS5iXxs+MQZjlffHy1/sE/Z9TdA9LOuQGs57+fi0uxh1hBliQLIe/7lnp5CVfnE03xuQBuzVqewnvnU2RS/hUfsQsmR3IcAMVjFLX/x/U/N+1E22Bk0bSvG3dsGqVARAaMj0wZPnB254WQAeAl9gXqgdYXOlmQDxauKqkLVdJkO07L1H8KdWxUEim8HQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TapbqgrrpmxfKpvaT3AtnRXyn57Ar30nmh28N+TqlhA=;
 b=WBvcKszbTR1Z3k811FmEcvmOpJcz4ODG4wpYmbNeeJ6XVbs0yh9PEAhZEX1aQaYquG4lZye2GEK69IWd8RlE1Gd9lfojxOEBF4YMXbuTK9YKS2ZzhysXIzVdy7o/Mjdr2XWszyjveZzqEBxzbBLpAeLYE9tH7Q23Fltnjr524eLfgKCSp+fpS/aRyyQDK9GFB/rEfxUn+cNy6I9RyJXCxTwrRuf2sW/K3cYovfa4wVmUnzebzoFr8JcKMvrRcaun7+Juspf55gRTkm0LZApO8pubgJybNfxufdJx4UDyTRD0A2XHV19lCNvQQv4XVnvQ5+9ErmzYCY/HmN0hdulPtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TapbqgrrpmxfKpvaT3AtnRXyn57Ar30nmh28N+TqlhA=;
 b=YB+XsRZTlhcL3/Qx0sKyAAmWc23SS0Tm6I0oU7selPqGVg80lLaDxb3KEW2bFS0NPoc6azsUCY10525VeKKChPRHtRVlw1eq8wa5L2NFZ+lwjCyFYlX+Tz4CD5f41eAVCj8ipArW+mdc4sDqP1COXMFYLXpJXQ0L5f11ZjKZ0nA=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BY5PR10MB4388.namprd10.prod.outlook.com (2603:10b6:a03:212::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.16; Thu, 28 Aug
 2025 17:29:21 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 17:29:21 +0000
Date: Thu, 28 Aug 2025 18:29:12 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>,
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
        Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
        Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
        Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
        Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
        virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
        wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v1 22/36] dma-remap: drop nth_page() in
 dma_common_contiguous_remap()
Message-ID: <7cfdbb15-72c1-47e7-b5e0-b8a243f2a516@lucifer.local>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-23-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-23-david@redhat.com>
X-ClientProxiedBy: LO4P123CA0305.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:196::22) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BY5PR10MB4388:EE_
X-MS-Office365-Filtering-Correlation-Id: ffc4ef2d-6805-4ecf-bc8d-08dde6586cea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NPD79wBXeHtrfYMsCs7+Y+bvxbGES2eU0cLdHeh2xruoKvj3fpWzxdRlXrJL?=
 =?us-ascii?Q?hmGyhql9jnnzgMLR0am0vkwRoLwmXbrAy45oT42SfKWQPFPxRfbZZKvwROne?=
 =?us-ascii?Q?L14QW8JS1KWA4+jc5/OGF538wMeAKMYmQWTDsAK7iwpRRilgtiM9J11WKKHP?=
 =?us-ascii?Q?fxAaCWHh2tr69LgC3fjLmj96CkUKVfyASkVfSGp+qwBwYURdGgGWW08RMB/B?=
 =?us-ascii?Q?FKLvlYsqsGv9YQE0f+Mm80KpN0Via4LASvODgBKIZl7Yyi446Dxr0dHxJBy8?=
 =?us-ascii?Q?mM4RIYXwdZ1uaWZBZ5KxC+iWorqkXgM89+H1/QuGjeBtmdD7GpBJOZLmWSEC?=
 =?us-ascii?Q?fAZ8usTsfUg/YTSOlSRHgVYnBWRgeQ6Pc0jrUlUP3d5+pRr2epcVEpAYtAz3?=
 =?us-ascii?Q?o+m/RgP7ZGbKBD1b02S0zvFNND2LpxWJxmOIdLjym1MliDYu7SVJMtFRdRex?=
 =?us-ascii?Q?XFDJbwTwPT7iKIE7Ju1EVaSbe9ZyttfpeKok0Jwnt/aSNWkDhH6N4ApbQ/2u?=
 =?us-ascii?Q?IiksZwCPbkskkcmWwAJf1iadAVLHz5htG4WoNeHkQRb0T/tco+jCGRvrDjK9?=
 =?us-ascii?Q?GEGWT6Fp2JZEvFAag1mODEjTwxr2kGfDPBJBKqw6VnNNdBqcPoOEJbMXcFtk?=
 =?us-ascii?Q?gHciGxYqn23CF9o5rXrlgH8wjcBBVYSmbwhndJ6uaKUnBkIBtEo26IUUlSYU?=
 =?us-ascii?Q?DChq0Sgblabqc3twE2/+u+OdKea0WSGAbC+c6GCECsCrQ0MLWrBlBNwm3wkO?=
 =?us-ascii?Q?zy2SsCUHd7oOxvkwej3KbD5DbmiF+TuxHECBKXkTprdlclzxs+5J+N/VWCwB?=
 =?us-ascii?Q?TXzniuxPOeYBN/PjLS7NCaWmO8wCPgoss7Lvy2mVNlxkla9eWae5yyW8X7O+?=
 =?us-ascii?Q?Z0Gq+T+1hQjO69enDHZfYbiDe9tsKG1v7y87jBcSASKVT+QsSVC/uf469iu6?=
 =?us-ascii?Q?v7L49i/KzjN81r+I20gjHY8FpirD4z4dlao6AIimGqpR+6vd7dzIfVyKthk2?=
 =?us-ascii?Q?afqd1c9SWfTSjiEtlkuV4Zqo/sGOcSYgbR+M2pW13l3ZT8kqurr/r8PLNE1H?=
 =?us-ascii?Q?B4jC/bDejlCyBRAv5oJp3HjCFK0FjGu26V+dQrwHG9Q2qTUwkXKjeg+4+1mG?=
 =?us-ascii?Q?ULKiW4GBr08V4VUnpGFGn/I+M5qpVhQPihwLjHhddmJya0U/AVXHT8k8MnXC?=
 =?us-ascii?Q?ykkKT+zENGEYYYko+vHh74xRpWRLrUZAjnzI4JYBEhtx2Uwq2hKE9K44Zlrk?=
 =?us-ascii?Q?LmOqVfjxv8L9jXSJIR0vjFtIn/eNUzWoL+6f8rqY/8GNVJTQalDXpNkRDGSd?=
 =?us-ascii?Q?C5bFaYUg+Ji7Pmyv6/O/xy3I7rXlLq1s/Xnz5HjjAfYjTCmwee2CyHhSiCSM?=
 =?us-ascii?Q?ypXyJ+crXugKSW73M4Zg66F/Ib+DuiT0fVweBbOtQEYjr2tFXcikmLN7XSME?=
 =?us-ascii?Q?oYV3K0PH9ik=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YTxSn/OxHzdlkn3Z9CUlLrLDCh/E3dhD8/FDv3TNvGs99HLNh1nTecZ4fXNd?=
 =?us-ascii?Q?pTS7BokIpZVQ+GMqfc8Gs+qUsFzncyHrw0M4cnpJT3s0Kelk8ZD4k3Pwxris?=
 =?us-ascii?Q?u0OM7sRCQTxUW3/T3RSQK59IIA8CWgFhuW5gwlhFZqrt3+3xXwxaObeup5mC?=
 =?us-ascii?Q?TcqABDV7eKEMkM13iE0JO+pANXuxucRqNKKZnn76FJH0PquOUsO6QZFbcfPj?=
 =?us-ascii?Q?FFZYmS+UG1NFGgGZLB/2SCCiy5iH7fhNwLcnjLvFP6yQvIKgTMh0YgodfTXa?=
 =?us-ascii?Q?U9b+isCCu6CiB/UlMryVC+1Rpe0YgekhWydfTWw/rA2hfzJi8w4wHMUWE9Wm?=
 =?us-ascii?Q?P30JDTtRJ4W9i/uZkWczzUtZFh7vLwEjaJfG7CBh38LCWPHedgFLLGyJMX2X?=
 =?us-ascii?Q?tspWE4fmg9PTFBGw6jDOdtEfvT3p5pHva/ZqQpBXO3ISCMCg+d/syOy91P1d?=
 =?us-ascii?Q?KSearcCm1Ex+/jF70NRQOU5WwAoi7aC81zC1YeRAohyz2O/MdfQtfmLm/xU3?=
 =?us-ascii?Q?B2Y9/HmlHJp8c7kIwAEyqwFDuLCbJMgJigQ9rEKpTfKyE32R9LQM3b84pLUF?=
 =?us-ascii?Q?ViqJWUYKwc4KdbGfWIxfTPBmzSLEzO5sd2JWbIlzMoHU7vUBeOfVmX50vu97?=
 =?us-ascii?Q?eC4g3AH+0RqUZFq9kQO9D+KtwWMo125yaaCezngOvnQjU8bNGjuiVlcWZ7t3?=
 =?us-ascii?Q?+eEOxmTbMIJwMmWk0lyl2nygkBmQwQGrbFC0Qt7CDAZ8uW5gWirTnyf6DSaS?=
 =?us-ascii?Q?azaf8pu+tnzE4pxZCkIc+LB3/47aG9nlwwue/rTwFptXVC9PFTMeai1jYeZ6?=
 =?us-ascii?Q?CUxaNjU/8kc3R+tK+mBczHOftwF5z6g/WY/bX+WeWo+m5tyQxxbQE0Fa6jK5?=
 =?us-ascii?Q?Dt+Ad1tJG55ejRe1tLm+ryt+mWwvFOS6TuRGX5MsgBRzNlsBlzK/Bdr+rFxM?=
 =?us-ascii?Q?4R794ETCqtx6T7sdR4zP0F0fSSTiYb3EfTolotsjjjTAVwcBfVoDzRmQCmPZ?=
 =?us-ascii?Q?NRd9zwj6lPmM1Nj4qJcqG4ah2d4mfZUcwQqx2xz1IRGfb2rZ4Xqy5u5tW1MA?=
 =?us-ascii?Q?4tJRiORvK1vcnzNAIPHIQBzGPXUbwti8HiavMSaj3b2EDdQA71yPEWdvyaJ1?=
 =?us-ascii?Q?R8ZTau6RI29ZK4I55QvGysYJrOJ/hNx8wV2OVkiNKtLVN9iknlyNHCVdW01D?=
 =?us-ascii?Q?hjcYjsNmxu8s6wlL0Q3gILoHfGZcYERcRn5JPbQAKf45qHakLHC7rL02405f?=
 =?us-ascii?Q?pi4inF4YOq93ibit7RojrV/jl0gLIbYg12vyPdsYOunainU/vJ9sMa9hYBQW?=
 =?us-ascii?Q?HBWe2RmaZFYQsMdgo1E9yZ6iQvJcyH86wxAf9cdsjvUYhTiC4ri/b9I8IVhX?=
 =?us-ascii?Q?iBKX8f51jLCRu0yXbxQxWYVOKVGHNGi2kOD1ES9gAuj6jLy4XYJi3KS302e9?=
 =?us-ascii?Q?qjkz1V+/HRhkMp9NzQ6cVHWDyF1NBrT/i1YcuHUrJy7Hhrb3ADtJmp8wHqwv?=
 =?us-ascii?Q?xZDNV7SgLrD1JPDxfhEDTFj/w2wUAREHWG/WWazseSUSw0U26uh8VFKsVcgS?=
 =?us-ascii?Q?xcAQkQzeGbJlTYfbXowryC4E/q/xWhXOR5YSPbkE8w1A7pDGQ3iH0SbSsw7Z?=
 =?us-ascii?Q?MQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TrcL4+W+nzOLW+zrBSxMMuC94H6tqZeL1DKUv9slXVxywE2pVBrHGrwaddFnv+x5B1VHNkDd4LYb2SUBkuFCy3oGv1Remr7pOc2lJ9KyXiLyvNNjAHsjAMD/sU6masjSVTgCkWUO1ckJ0dDEod7YZ0hURTFynU3oJDtcREQSJEBs9ZEhLzi7unILCxYLlzOVP3eJ1B8BOpisxui8cwLvyGr/WN/0b/Uh5EX9cF/YeGRkCMJ0ltG16cERcGW43/kYFaO4PcZLwk/vtZWdzN8PRGQolpsSrOIB9Ez1bGR/DjntBQWN/47W6w+Xza7pOgG6qiOVd/Ihq3tIjT535IuZmhSRMdoXjjEzfpgZeA+2wp/Nmy0VmSyaDbRLW7mxjQUiQNL+fB8eIjn9mOmM9E6HKBlqZ/jiNTFLWQ47gMt/HcS+pYlVi5F2XoSXvqdZj69jrz+f9O6cTnDVq+qCej2oDRtLG8/6q1qjvutGuDYLCrORYULPe0XeJlr2RcKCTrxoi1FuA3wq11zZJPOWlKJ0FH4t7/g/sWxF/wsC1bsjA91uY6veqjBS63IHMVbtT1J47JBBZL5tp3DCJjdUeYWJJ2I76pzHAlp5feEeOIYCekw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffc4ef2d-6805-4ecf-bc8d-08dde6586cea
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 17:29:21.5911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MijRJB2MsjIHV76EsCrzinBHU6Kgrv6qDGiSPD/daKk6Tfxw6hV5eEy/ohO6UYqlifc9X6SEKxYYRoV5y+QTSrJcOfn7WoaW/BKGpu0gxYA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4388
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508280146
X-Proofpoint-GUID: Ts-36qijL1syMGnzqCdNQqYjf1ur9OgH
X-Proofpoint-ORIG-GUID: Ts-36qijL1syMGnzqCdNQqYjf1ur9OgH
X-Authority-Analysis: v=2.4 cv=NrLRc9dJ c=1 sm=1 tr=0 ts=68b091fb b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=hD80L64hAAAA:8 a=7CQSdrXTAAAA:8
 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=7cRu4o-oBh6fblPocasA:9 a=CjuIK1q_8ugA:10
 a=a-qgeE7W1pNrGK8U0ZQC:22 cc=ntf awl=host:12068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAzNSBTYWx0ZWRfX6DCfHiWxinNh
 KTsvvKMF/z656Mo1L39S3KAr/+Y7lWMiAs0r/TqODpE4kSsXrbHCDMgABZTHPxvVKiKR/xZ3JbE
 NWR874p9rDZVrIjBDcb/ZIhrGJWlo4cWigc6vZbw3eMIIi2OwCPPLA1VqHX8bciK62DVU19zn8w
 bGBxJ8EIHaH5JHMkMbDw6hgzQ+C7PiTEU47k33IqgqXxbTNrDZpeRYwbs5YzSQehum0ouzzBbva
 gWZPG88b9ecl2TSiGgO2aDQ/kkeLN5NNX0aX//RkI8Ga1eY1bpYLoY0uDKtJpYk85Cxs24gTmqE
 /5imAiUSTCu/mJGDyKa7vKPbZXkAgCtNnM4myKkPF2szH48ak0ydLCrddV73QFpQUY16Zbmk5NC
 4LrhyaDtA2scxw1mwu2AggUHF0ZavQ==

On Thu, Aug 28, 2025 at 12:01:26AM +0200, David Hildenbrand wrote:
> dma_common_contiguous_remap() is used to remap an "allocated contiguous
> region". Within a single allocation, there is no need to use nth_page()
> anymore.
>
> Neither the buddy, nor hugetlb, nor CMA will hand out problematic page
> ranges.
>
> Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Robin Murphy <robin.murphy@arm.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Nice!

LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  kernel/dma/remap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/dma/remap.c b/kernel/dma/remap.c
> index 9e2afad1c6152..b7c1c0c92d0c8 100644
> --- a/kernel/dma/remap.c
> +++ b/kernel/dma/remap.c
> @@ -49,7 +49,7 @@ void *dma_common_contiguous_remap(struct page *page, size_t size,
>  	if (!pages)
>  		return NULL;
>  	for (i = 0; i < count; i++)
> -		pages[i] = nth_page(page, i);
> +		pages[i] = page++;
>  	vaddr = vmap(pages, count, VM_DMA_COHERENT, prot);
>  	kvfree(pages);
>
> --
> 2.50.1
>

