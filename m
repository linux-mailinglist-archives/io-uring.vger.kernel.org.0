Return-Path: <io-uring+bounces-9456-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 18043B3BB23
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 14:20:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 69F7E1B21EB6
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 12:20:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F715314B64;
	Fri, 29 Aug 2025 12:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="D69yTV7p";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="iGj+sAuG"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807061D5CD1;
	Fri, 29 Aug 2025 12:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756470011; cv=fail; b=SqC8iHDt9ygjGYLrSi9lb1nb+n43P2Qe1yDYjxpxYZmMQ3w3wBrfHmCHg1T0030bdGJRawOhTK2BTkk9wZiRterdGQKIh8tAIP5LvP9j8t0AII5R8WrSgTtBmZwlk2QM63VADGScCiSfBlv2Z+DzZw0Tu5kwlBAru7GQJDiIjg8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756470011; c=relaxed/simple;
	bh=szZbKLqQmTdoQWX/C/hW87wXkC5RZ2G7wMpzLBFw4zA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SwTuwj5ubUKRPiWlOhBrgjiWBXLt0TANr//3XMCIld4fVF2zRVeh7l2D1luOcOMLsfolZY/DWL5fWr6Pe/ytL1WT3cxRKKBk7B43zoH0mGQpBZ4mhBCpywSQQSNiGXPiOaFCrKU0qJ6GRdqVQqWiStZTrJsro7I5H2LwxPew0ZQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=D69yTV7p; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=iGj+sAuG; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57TAYKWT009757;
	Fri, 29 Aug 2025 12:18:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=szZbKLqQmTdoQWX/C/
	hW87wXkC5RZ2G7wMpzLBFw4zA=; b=D69yTV7peKGea4Wg37i3vi/znWTCy8oc+4
	8JrOV6ltcFreGhXf20IIZOg2xyNjFLqCkaIuWhy7gI+IRvn3k0Oa8Y6S2git8iIl
	Yogpa6lphOdEe1I1kCFE/t4p/tDw4bbjNUwhynADNAxbNNj1fuB5S1+61kZFbFgZ
	Dey/fc/VeZe65x6WKrxE18eepqV+HamBBKJsKev7yPXXnBC02/NAlUZs1J/2I7ZS
	2qOrKHm3jL05R58jHR5MSs8ioRBQ0ppWvDm8bYVpFDK+xZgeLfcrJRtSgJGXKq5U
	S4geCzylYJ6vKPWrT0RjaHmFWckbFeTwmyO9m8d5ltXdQgwF/g5Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q58sac4g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 12:18:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57TA2RnB019683;
	Fri, 29 Aug 2025 12:18:48 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2086.outbound.protection.outlook.com [40.107.223.86])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43d5kh2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 12:18:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=czjjk2JId54PKbYZ/gKON+lBfi9e/f4kB9YPNguZC0RfWhDLGqFrFAT4mk5aYLWYwTqCnFlA2XeoTb3zqxjGYV01TVvigg9jo9KAESSMHKcz/kYIdI4sDbxGzxOnu7Xfy4sjnf/Asa7a/or9fTJZmd/89c8spowjTgEURZ1PEH4RnVrvaFQEOY3OS8id/cTbhwZTZ7g1z/wfnF936wqU2RvorYvYVoAzpejoFcPazXxXR4T8E8cOi5kuA0syQjDIideFctrEuLISAIp2mKl0ggn1L4ZluAmOEKXyGJMRb4Gkf+xi2O4Z/TP7wsoLNoFYC2HsoFt8008Do1t+NQ90MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=szZbKLqQmTdoQWX/C/hW87wXkC5RZ2G7wMpzLBFw4zA=;
 b=OYgjQP91yxNu0OLri+td1rsMiUZEBA6Swo8RnaMDgpCpIPzbDfC77a+v72CCpuBlYrTiQBvkIaSebRuCWFgt6s4gNM9f62oYQbDn4VDyQm2c676+WJqVqp6s1kLVMvmMdnhUbyH1kn3tKSa7tvTZR9/i2/uCcMGf1TlCLrUbrB7NTE+ss+cYn0Cq7Paegy6Ubu5sH3esvhD7zmftNtsJsoOGwYdUjpJ/5jk9mpRsHmxl+/UqW3Tcxt7SEfQ7V8aOl/J/hZ02BXBYQ0XisBqmUG0dMozXrZbgu2Fp96uf3YHaZ+xt2VBeRG8lVwBZEltpqnx0tRFzj8cv4J2wSvANLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=szZbKLqQmTdoQWX/C/hW87wXkC5RZ2G7wMpzLBFw4zA=;
 b=iGj+sAuGsgeC1CZm9iZl59CIrsz55jTUIhGQE0RkPP/jcegHLdvZDaq8WygHQI1VtyXkawC8R0l90qzvf2Q6z2btcIQ+jop7OmRABHCuCUStvJcKMNyFOpn1dAR633KU1yPt+OOFN6inpjdrjh/1ecIuvREK2YGfEHeAqZQMO5k=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MW4PR10MB6372.namprd10.prod.outlook.com (2603:10b6:303:1e9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Fri, 29 Aug
 2025 12:18:40 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Fri, 29 Aug 2025
 12:18:40 +0000
Date: Fri, 29 Aug 2025 13:18:37 +0100
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
Subject: Re: [PATCH v1 08/36] mm/hugetlb: check for unreasonable folio sizes
 when registering hstate
Message-ID: <c4a0764e-e9eb-4571-a7ff-c26e8bd07401@lucifer.local>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-9-david@redhat.com>
 <fa3425dd-df25-4a0b-a27e-614c81d301c4@lucifer.local>
 <5f6e49fa-4c1c-4ece-ba67-0e140e2685da@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f6e49fa-4c1c-4ece-ba67-0e140e2685da@redhat.com>
X-ClientProxiedBy: LO6P265CA0005.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:339::13) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MW4PR10MB6372:EE_
X-MS-Office365-Filtering-Correlation-Id: 57b40f61-d169-476f-7b87-08dde6f6308a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?62rm9jszp123Pv8DbtVYl6YJDyX9mq4ZxvW/2/rokx8C3zpSM34PfvPcao/q?=
 =?us-ascii?Q?FNkqL8VAgL4hIs7QOPjfENU5khdJfTGrI3JEu5SNSe0opUvS/lPJ1WIXH37V?=
 =?us-ascii?Q?fE6jIkfi6VYkDw+kiPX1gdKgsFDml5FJUOdsvZwLdZab/W7AmhoAkJN8YHrL?=
 =?us-ascii?Q?UlealKrXKKi9Xdff2owK9o+aDzdOymCZ7ymHQRBIhQ27mRiFS4EPxDpEtwpa?=
 =?us-ascii?Q?NqMRRduM0w53eGuFUZW/pVXFqOQLiNgX1cGACboqHiWL10ei+yEnYJK1Mz7G?=
 =?us-ascii?Q?MFH+jv3B7bJmkbDgd3iAjS/Zd+5/djpeN8MTsDK2aLYDYwCmQfw/1esefL5o?=
 =?us-ascii?Q?521ljeQTtvXWIZzh32vcWpkuBP7L4j9oCijikzOl3S/Zd8nsjq0fsrW0+Gm8?=
 =?us-ascii?Q?VmS6gfG2YylVqsaojvOm5bAvTPZlEQXWEYELYZOQJXcARHd8N2ZmEAbTpivq?=
 =?us-ascii?Q?YC0G9+iHP1pxE8CvwVT/pYNecJkrqTy9uhCi/hKF1GSQSqTLKZgihwsul7SP?=
 =?us-ascii?Q?spdHWM3LAR2iJmO/cQUsb+aUbE8NNhPksDINMV5xLKefaihmXP5qywsNkSH2?=
 =?us-ascii?Q?6voO23uHZ/vg5AzV4i3pu75ngtfDbnWXrUHOYa13e5Wfh6aM1B1Y0272p03h?=
 =?us-ascii?Q?SKXoLIVA93kxT5PY6xY0hFqG3jEBxZouP01yGy8gCuo818z2heDyTc/Frr4A?=
 =?us-ascii?Q?Sl20ADQBaNI616ZWGBfEfKcjVJTIYngZWcdw5VsHXINP9iRHIXK8muJhwKme?=
 =?us-ascii?Q?0Bv38ZsfwTxMFDRFGBowWe8BjNnvnMGZ+kJh08y6eKkOigjqrfO2FKz6AwuO?=
 =?us-ascii?Q?8PyRQSt3A/PTQPunauZ5Noa7vBkKDUE57nItJzRRaQ8CtlDeZ9zotZFxv2md?=
 =?us-ascii?Q?j6sEg/aT3Q4vj2NlUphS1FmgI/wFz7NFGlzc4+LfVJAECK8au1XtmOwOEXAm?=
 =?us-ascii?Q?uFVdjVQ9PJdMctoWMjACvR6fxn3HjcFQtP7PHET5UqvWH0vOsoa3QBsDS+lI?=
 =?us-ascii?Q?S1pt74lNCdZ4ZQgnFlJQZhwuBt9mLxtjcpKKmgzCWNYzYBVdQFii7Ps4xeZQ?=
 =?us-ascii?Q?99YcuA2SsJlZU3gVefxIYmZYYZemo+LDXVrKardCPEradIcNg2dAzn5RNWhu?=
 =?us-ascii?Q?u+tlBtUk/gUA91Lv5zlIbfWfMcthu6bxbbF7iDP2GPvtxoRCSpeUYCq5rdQd?=
 =?us-ascii?Q?jLPQpom6ogEGWgVprfZiafSHjJUaQLR4JMCadGmf1UzkbYkeLeCMDQq6cN/o?=
 =?us-ascii?Q?mY2umTaWbTWqfYUEwLYUrddwIcdO0YszkM1j5CnKBypJ1N3AuEI0+YUWwmY9?=
 =?us-ascii?Q?HebBaFhiWKFYWq/oxBLsKMU8DZDCjHfkD+TgLDkebyvA2ATj/kQFxvlhHFHK?=
 =?us-ascii?Q?kopfv3Xm7puDRpVI6BbGlrbXkLSQ1LRvLalvV36Sg1X+lXrv6/csBJm3BoB+?=
 =?us-ascii?Q?cv0Ul7MjQXE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?n2ormX92jQqCdWI+kdImCDwqRzomHxc18RiXEKyv6RbN32lesWVIZeW1nD5p?=
 =?us-ascii?Q?yUut70BdA4tKdFnZrJpzdE8eh/EAO4AlLye2hEIiwsWEmCzHyheNYf8OpmVG?=
 =?us-ascii?Q?Ho/8wLuNiSMqHBHgYRBnIhHjiKWASW4jpQ3T1n5en8tjAxbozm+GJ8D3i97U?=
 =?us-ascii?Q?azQ1LTQs8qUHjD4/JMH/qJQh64K4ICMklNvxyDcFI1AaWK3hsq/xX86z1+08?=
 =?us-ascii?Q?NihsVRRGSscea7o+FMVGqaCzgWYL++BCwsj8OhyH5JF4qye4Kls5ji5JGlr3?=
 =?us-ascii?Q?FdmYb6Z7rX6yIKaM82mrlAnVle6HQhY69ecLIvzTSgplKV7TpqZFYs0vMF/B?=
 =?us-ascii?Q?+mvwK0m/aZ0DoUaejmwxp+tcGYoeH6GwYdFZ7YHdCb4md6w7H4uJ5w+J6w1w?=
 =?us-ascii?Q?2z6JLPfe7s+xKVELT9JY0nb87jTS+NzixxE8lioP1rrPzWzZMtjTIAqn/bDS?=
 =?us-ascii?Q?8MgI1Gk5MlbWGJtq7So3qtmN9nDL5H4iKq+OsRoHHLv152BFq9QM1a/Zmp5Y?=
 =?us-ascii?Q?bI6KiBuejj4zkVXwcfQJMoOlvvrUhO1CSw/d91evVirPiRLQKKYJiTZW1uGl?=
 =?us-ascii?Q?98xr+MuI3/GEA9Hya8zht/kNf8GUupIhymYf0Up/fIQefl2x2FQhzHgHS9v5?=
 =?us-ascii?Q?qMO1sdrOrObKHd+iVRA+/+BVGpzx1chtlA408L+C2WDke1eUMYmVyDibFTdX?=
 =?us-ascii?Q?NMEvsJdrxiMIOYmpDvLTANbQYSW9Vs04wLNEJyKeQNxru+IW6R584yBnFcnA?=
 =?us-ascii?Q?ZE2frIXmN7VWCor540LueqV1tmTXX0MQUZn0dczUHCBCqMKxMRdD1ZKXDNZ9?=
 =?us-ascii?Q?VPzIlWKcEUqBD6xI0t9r9agyQKS5u0nPP394ycbQQhHruE2pb+65qCuCGNJ5?=
 =?us-ascii?Q?j2BDvE+l/f7+M7Q6GNWZrGev4dPwowjZ4QPq3XeufB/6ENn8bUyhcIPBH5jt?=
 =?us-ascii?Q?kCL7soxi38dTILXtTsRoptz/DXrTWbyI5nLTQfAa+ViN8+KpI7smVbX83x2E?=
 =?us-ascii?Q?RbpLiaeN6ubMXIZOiJhO5Cer1pSdpNUStTHGrSzi2SXZ3CLsclPZs/VrWOa0?=
 =?us-ascii?Q?60Nni3m30Fa2Oy111wc2qiTFhVXDRs93cjbD9IR0kFl6aGYobEtSHQJYW0Sq?=
 =?us-ascii?Q?lgxlrrf3KBzZV6SJdwyDKAkbofp8xqz1SgOPuhBbwim1DnwhjmWCy8Ti7p9b?=
 =?us-ascii?Q?myKrMmLpL3oSzL1ebDyD+sCnEuCF8SsCMlwBxMyghO8Q3fpx2AtZTbe/NHX4?=
 =?us-ascii?Q?f+049PaTMbC5kcmRRP3UoFdDW2GndKWqhXOukspLRMzP0XK0fEGiImU07sEQ?=
 =?us-ascii?Q?f+GFdcko+9VqjRmVmfHhL9npnWICsMUqriHMMDY/sALHbIRtFerZEatAULuu?=
 =?us-ascii?Q?HpkgPG1QyQnGZtfIIplWbTUR8y9F5h0GiWo6BmEn7/yEQvobgGKn9F4MhIg2?=
 =?us-ascii?Q?Ow4BQC+NUUnLtDCaNdiD+7lUuhISn0psr3qiHSsp9aEo0HMSIAj/g5v3FzR3?=
 =?us-ascii?Q?HzhXfxe3DU9RkpYZC9+hdfkUoZOObh7SI6fAcbbGfnvIFPBItEWEcLpxBDQu?=
 =?us-ascii?Q?q0Zw6WVLmlBOBQ2H1BgYJcj5E65Rejc6Wlt4f0n9uq7OiWnjlM70hBVAyvqF?=
 =?us-ascii?Q?aQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YghSLNB3EH8myGLlAO7yzX7duJQJXWN6A6ytiYVJ0NYC8mjlmwC0KjEwP/apdTtOfj7reY9jRzgiwIGnHEkD2y5g2gJ/ftXOn/aB8YUC8PSyksjyQheuoSfi4F8idbrKGpFsfKG53iQlj41zsvIwFmULMawlrZeJoMuRnOWP7Xnk5qKWhcH/RQ7nkERj3AtwnIP7zD7dvSuhBJ9FjbbYKCGkqVXppGgYlbo51okfcAKl/Tk5MAQl21rsIVn/ViXW6n98mW7BoCXCYRjgkzaO8yWFVHkQaS3QG1D7shDw6CU9zzguVfzVM7L32kn2JUqtR7ip5vTC931yBSXUqj8cA+hD6FzjmSy11FNtyb8Pi6DN2rgFJ3S0NEJKFt85wvpQ3HBWUwVARZ5l2d4bpz0G05svB1lpTyh28Nft4n8DiUGpW1RQFahYPGnQqsXV9lrq1D25HA0D+HD7Ysf488CXP0azlWBIrrULnQa4BlmSrlTmCQXHhMqMMTsOweJ5LjU765QGohNFlD8Pf/ll4lL99TWKuViRv1pcjujskD0AVT/ZC6OWDcqOTGL+COKDN3HJMsHm6vNZCbsCf10Y+eXO3GGFGmbd85F6h7oKP2v0+qU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57b40f61-d169-476f-7b87-08dde6f6308a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 12:18:40.7810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PbOHCFLrkEnpx4oo8mAoaeglQAXHZWxMcqXX60xa1olR4MGjTlJqADyelMYt6Uc2NqTZ6nx/xo5ZeNs4ijgOxMj4LCquSO4tLQnYjDUQjrU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6372
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-29_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508290103
X-Authority-Analysis: v=2.4 cv=J6mq7BnS c=1 sm=1 tr=0 ts=68b19aa9 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=PIS2792Bae3LS8-xHZYA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: MMBpRIbtL_YhtAPzWPFrGdxCWr-Bk5PS
X-Proofpoint-ORIG-GUID: MMBpRIbtL_YhtAPzWPFrGdxCWr-Bk5PS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAyNyBTYWx0ZWRfX4/6Mm8s/8e+l
 tyEKZdPQTkul+nxljDqSO2gKyPOvbkztUo64Uw0l4NQux8LB8ebrsWk5cut1MByy9JIRsZgmZAt
 a6Y7xDSvYL/ECmZhjifpkmrfhWlbLNvL/7YxDXzXBDUxgwSrfMnl2Cm6j1bNInlq0gM9EGq8y0q
 fqin3nYfQoLh0l8kLSCjfXs7RtmmlD7xAKuGo2vBeL4pYionZf8MLFoUE41M7TPzUnkzywlGp3P
 PHAeJxW3Gl4CZfL6vLcAj1oyB/2FE1X/mg6e9TomB9wNLFlAecTu4FtPxoSf+V78WPYXT0DCTOB
 Kk9ojkuSEkfpuVn9LlsFwvr/Jlo0OAea+UqX+xDj+ZKO6HKVINL6W7RlrS5uth9MwKMTBnClybn
 PJr/Yeez

On Fri, Aug 29, 2025 at 12:07:44PM +0200, David Hildenbrand wrote:
> On 28.08.25 16:45, Lorenzo Stoakes wrote:
> > On Thu, Aug 28, 2025 at 12:01:12AM +0200, David Hildenbrand wrote:
> > > Let's check that no hstate that corresponds to an unreasonable folio size
> > > is registered by an architecture. If we were to succeed registering, we
> > > could later try allocating an unsupported gigantic folio size.
> > >
> > > Further, let's add a BUILD_BUG_ON() for checking that HUGETLB_PAGE_ORDER
> > > is sane at build time. As HUGETLB_PAGE_ORDER is dynamic on powerpc, we have
> > > to use a BUILD_BUG_ON_INVALID() to make it compile.
> > >
> > > No existing kernel configuration should be able to trigger this check:
> > > either SPARSEMEM without SPARSEMEM_VMEMMAP cannot be configured or
> > > gigantic folios will not exceed a memory section (the case on sparse).
> >
> > I am guessing it's implicit that MAX_FOLIO_ORDER <= section size?
>
> Yes, we have a build-time bug that somewhere.

OK cool thanks!

>
> --
> Cheers
>
> David / dhildenb
>

Cheers, Lorenzo

