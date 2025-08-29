Return-Path: <io-uring+bounces-9441-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 02CC9B3AFB5
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 02:36:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1884D188ADE1
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 00:37:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A2B618A93F;
	Fri, 29 Aug 2025 00:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Jwast5Nh";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="mw+y8Sz0"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB532AF0A;
	Fri, 29 Aug 2025 00:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756427794; cv=fail; b=XNkX6qEFUj3cDyXv6nkdOPpBePA7O8ekRojuC6PFsSEFZ48lFT0mp9Awl29Fe9+iWj/l+tH0qtqeKHnEQZcxeJuj2a50y346X09uFDwVVPwWNDFN3mdW5xI6CpsqgEbsWyczTwOkKaDateV3Odyqx7P8VHdE8+PrOWTIR77rysI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756427794; c=relaxed/simple;
	bh=f8n9FywV4Qh+Rniz7FtyuOv+9ThZOpyYl9GLqPoZuvw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dTbtIeJTb9o4EUN4wSInEmUs11u0cq+slO967DwsrwkXHc5qOTmylHYA56n/XzoDFQESWCNHsurppKrQmnf9wdH5zL2ds+1cNCPEgusx5TrRgJ6yWlv853NuZsLWjHrGVkz0M1fbSNzjJnnvMyg5J3Ly2Za7wWOq3MY4B2obkNg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Jwast5Nh; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=mw+y8Sz0; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SLUtru005652;
	Fri, 29 Aug 2025 00:35:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=JY5lLReL4QK1WmOOLS
	1XBIGxWxtWWcacEW0q4f+5Zic=; b=Jwast5Nh3vT9GdW0yPloLXnwGZYIFpWfVt
	zGYH4rvtxmDpZQzpm2uosab50sWLpnfL5EQ9ArEdknomyBXiZsKrxA1cFe/im2My
	SprH0ABXEgjTLLFBwizNlLnqL9tc6wRS8uLULl5PY5LhkcLKiVOo7zDAQQwfrirJ
	ipbhuzV4kaaVQ48qGRY1WF543zYAdfHbE0LwMXkWQ4xaxhO2jZMzJ/LTE1+mQ0e9
	Gf+s+7FJrdfOl+M1r4uaXdFNkS15Jfylk+Xy1Rto8ljextURIrSWYmC6Ysn3ZCyP
	ZSkQ0/5sgyRIg6YVlzDWZgBK9Z0ECpiqov+tzAJo2UIkBp0YW6MQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q4jasmbu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 00:35:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SLkRUb014687;
	Fri, 29 Aug 2025 00:35:54 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2088.outbound.protection.outlook.com [40.107.243.88])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48q43cj6dt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 00:35:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uvD0yRN93KQkHG/e66TjefKvXqrC4x9Xzl9WXMpvhFCskjHxC+/EPOSMboBHXyUj1d1niws5fTwID8DpHCDOP+kAnW+Y8ZlBRzRxWssJ/gqbhg0cPk8qasqU4DkgWMPfUJNZpcJWrloMVK526cfKmjM2WDPLxdxfvLN8uoPl27kF5QsVWOvwWqw5kYvf29kU4UdJylh75kGHpY9HjqAB/XXu1vbXzMVHR+6WBqi+8rTAyaypcUY99fo1LQyrsRMyRj/27BE73aM0gd3c3drEoiJ/tA3H17WXOhYVErokBnlAViRy36iII/fltBLw0OQ6dsAlSJDvippORHU2S4HBOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JY5lLReL4QK1WmOOLS1XBIGxWxtWWcacEW0q4f+5Zic=;
 b=p8yLkKpqmPMlRhv5IkUzHDNLhkq2OUX/OfYN14J0Hri6McYpQzsVs4wPnb8ij49GD68WN1eOyG3gJBX04BMmyRaQYgOpaIKXSSHDG6CNvbL//YOcuIhXzyvyM9Zo0gwd+NY5ogrxFWivJD79gL2dnRrnpBjvvbzX9IjThS4dAHlm/M9x97ox+V5G7WWt+2XuMbMyRFbvL3kNhlSIRykJvkZZ7uQbD8MZWUVuZATZQkDIfAxI785rWKkfuqUbh5/Vd0DF4ygk5+nCzosrGeAX9bggV3DOdKjpBjkBBhSAAr9HQyzsrWIiEHBtocFYhTJKIKcR/PHut1+v837/N4ZGhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JY5lLReL4QK1WmOOLS1XBIGxWxtWWcacEW0q4f+5Zic=;
 b=mw+y8Sz0jwMLx3NJ5KZFs+PEu89Z9MjJv28sR4W8iPm/D5omUAf8x7Frsi+rE/awdACMDQrBa/K249hyCmhB3BVc7pIcgw9FWrFetgKsVYK7TKwbZBnDVby3jqESLmpowi8PyIOdFIyWVTygLIU3JxqIAaQS5b4Wz+zURQWCSso=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DS0PR10MB7019.namprd10.prod.outlook.com (2603:10b6:8:14c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.13; Fri, 29 Aug
 2025 00:35:47 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9052.019; Fri, 29 Aug 2025
 00:35:47 +0000
Date: Thu, 28 Aug 2025 20:35:41 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
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
        kvm@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mm@kvack.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Marco Elver <elver@google.com>,
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
Message-ID: <3cw5er2nr2pnht456e6fh5lassb6y5z64xk3g7ffrao2glkmx7@os7byqmcuddp>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org, 
	Alexander Potapenko <glider@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>, 
	Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, 
	dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev, 
	io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>, 
	Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com, 
	kvm@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, 
	linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org, 
	linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Marco Elver <elver@google.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>, 
	Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>, 
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, virtualization@lists.linux.dev, 
	Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, x86@kernel.org, 
	Zi Yan <ziy@nvidia.com>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-9-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-9-david@redhat.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4PR01CA0207.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ad::11) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DS0PR10MB7019:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d0fa61b-d568-4d17-39b7-08dde693ff29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/PcrMbTe0MD344ttIR8VQnj0RFwsNC/LPi682L0KLYIUlqbnINqIm3jSqh/b?=
 =?us-ascii?Q?LHpbVPgPKOuQnnqE1Km+XF4uf0jjPCBYBxGSvc9rf/pp4pCObvaN7C3ugD48?=
 =?us-ascii?Q?tS+xYTZQt6g9/kMp/xcQJbe/KAcPVC76rMypaAGjBpEm+Yi26+VCpZo4eKo7?=
 =?us-ascii?Q?ZOyMr16Bpqe/AcmbbxTplsfsS8Htxwg4qAWIncEBAqf1chB6T2yLbubRfrH7?=
 =?us-ascii?Q?IPWIDGCzJTK+UzMm4nZnRV1qJWRZWgKP+JQd8WXbNqt0Y3j73566o5Hu/53K?=
 =?us-ascii?Q?WRYcnTZRsBAgTuc9k7BwrXZKKnj6qgc45m3WozKGKmE7kGrfhv1056F7fi7S?=
 =?us-ascii?Q?FpqvYPmWFJR9amnPwVLsfbonfKJM6rl8VureokwZZEX8Vn3Erjm+nwN0S8aC?=
 =?us-ascii?Q?JVqjiEg86yAAZHEUvQsRNkGs27axOmbaJ3aA059tZPSGGL/hN1KhogyNbCVs?=
 =?us-ascii?Q?ncIGWAKsOjwat5nfNPxl3cxy2zGc95HOj9lbJeBkKZWiK1U7VJmhTw9JGUHn?=
 =?us-ascii?Q?YDQ3CbghqkHZCBlR9ckBPsGCO57A2nbd36Zv5cU+5YK/Vad+YWDU4o8EUANd?=
 =?us-ascii?Q?sBPwUW45XkVnqwPQkKYmBoY8QSdBpzqwrXC5Ecexcoba2Z7YvcW1mkvObSTO?=
 =?us-ascii?Q?jQaAHAdP/SWq/p+c8GZEaXMwVpjZ+4KENhU0OQuErhWyQNILQyXfETsh1u2Q?=
 =?us-ascii?Q?IaRK7vCQVg0tea0a5tn75i0lvhp/JNGxxM9XuZ5ctMxi+ytY9GPf3RWmmSIQ?=
 =?us-ascii?Q?siuwHpQoKem4VPkiM6M1akFm4ZW8XJ8wmeVcljbdZJPcpKQreEbheXlJVJOo?=
 =?us-ascii?Q?S/ApakonOg0gUk78VmTX605HMm8m/BKttT8Iyoj7tjbM3scsWREyXLuZO5mt?=
 =?us-ascii?Q?VGE27LEalsiTf/Bgf5LgjmljOfl0N2NIyle4nli5JntMM8QsW8NZF4cvk0U8?=
 =?us-ascii?Q?kbtv/ztP3gEG+gw4CguTA4AdWAnE39aAia6ivGhp4nUJ0ORBIJxEa22aSjZ2?=
 =?us-ascii?Q?z2n5DbROp7/4W7MuAUjSsX3vnWLdJWBxCNRfxOSNOPp7m1iZw+w+d85M8b40?=
 =?us-ascii?Q?+x89sfmaGpdfpv7R/W4cc/CYnzm+SyFoKNZRyCbaLUQApcKZEmBEzZEv+RbG?=
 =?us-ascii?Q?PEOBW4OWuB89vH8gJc/m9uPETkKbNGj+uHHRhIAPOrttU33tB6IsC18WmRdC?=
 =?us-ascii?Q?vvQHvmCBJxl9H9PdsaSxVLXO+Zpyhl8UDGF2lwCUpauazs4ga4UJ68mS34Yq?=
 =?us-ascii?Q?nxACKthpO7i0U3JKPMDHSyII3CyP4UnzaGgst3x2mER6MBfi2MoFDgTNz87O?=
 =?us-ascii?Q?aTEJ65v5Jp8moN5t7FSu0YFGYSH3Q1qglJFg7//00Xea18mYxCsvlPztNQSR?=
 =?us-ascii?Q?quKtg8doJcQZEKL4PgNTK/XHEJC3nASIX0kPu6rKb1Gd0YykYkCwuQCmc7J/?=
 =?us-ascii?Q?xnv5WmEyFB4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?C1sQSCKOsXZJWxNZBUMUinYlWFAUHqo8EqWN/z23m8Ml9epOmBaUyW3RrN5Q?=
 =?us-ascii?Q?cMdEZc//4wYa6qC0eUijJhK9Pe+WtMASSa45jkWpvsHZQrokYMAYr7nxm3EV?=
 =?us-ascii?Q?sngfpZKX1hYUNs/ewFCSCVbpFLg4bJAhlD5htGUEkmELIvc0jaDkrcJRzUnZ?=
 =?us-ascii?Q?2vExLOnH29DWVxDqI1INTqv9Z9o5F93x0u/dw82s51+p7+IVXf5zkGHiw2Uh?=
 =?us-ascii?Q?oNh+XCJqZyujXZupsXU5/XuPG0pFdBKXaTCQ03Fq9Le27MLvNLt/u5nigx0A?=
 =?us-ascii?Q?OEq/PpCwLUvQbSQOYRJfLCsE6s5HK5yNCqswc5zoMzw9UXXeRbzAomgAmItK?=
 =?us-ascii?Q?C3wrAMK38ALL9FKc3tKK2nQvlgwTfaJGpMT3hXqXjLMTG4FJtV46S3IuJoED?=
 =?us-ascii?Q?qq7Jit7c1VB+Fo9UCuJcsrDNidQw/kO5fYwUhTB8/czL8u38JIV5IFgwifHW?=
 =?us-ascii?Q?pC09z/8BDty8sdpGSoL78ySGPRUvccCFo9Jd0XlXTwzURHPujHeDVE4Ybqcj?=
 =?us-ascii?Q?lrJfpbFJS1S12y7uhgQwCJ9juvymGwwbp3bS9sMI2xpmr7LDW5HFjn7o7pET?=
 =?us-ascii?Q?YNEM3428c/kqH5QbTKPWfXtcYMGZJKV0/LgBv9vs5VdzMRe5D0Lq4d3eesGi?=
 =?us-ascii?Q?p8IMmzz5UKREsoOK7YhMzWWLYofFFuJ/1MnUgsrk5wGBwD65+iSSyY9E1+T4?=
 =?us-ascii?Q?YzEXT69DqJFCkdqzgXghOXnKwlkhkWbteGsKA0Yu3SVrUgBcx2WaAjfKHOkg?=
 =?us-ascii?Q?ia8QdqwYQgU081nh80O60+z1kBeTEQtqEIJ/1+TbGCHgrZBIap5NXG4sZVM0?=
 =?us-ascii?Q?aQj2DnS/brnUQ2rN62Be8kZCeYUbAnI/RxejBG3bUNQDsTh/wkyeYK0wXu6M?=
 =?us-ascii?Q?EMFp50j2EUPfLPtMrBICoMPvAjM5wDwVOlo6W9fj7kDOpj1IcxDIpTfydbwu?=
 =?us-ascii?Q?mYI2SUIMikYoy1DV6OVdMwYsC0aeh7luHsTbkymOXuTilI3v53aeUnBL3Ebi?=
 =?us-ascii?Q?y0I0AmrZPWWWac0lwquMU0eSms4sTwvTJ9Y5WEa08wqBx9okfWxEB5cCtpe9?=
 =?us-ascii?Q?VhSb+q7YzyOHoGeyVLR1SD5Mp265Wu82T48kZo1rHfCGEBFNWx0NpNHdoaqt?=
 =?us-ascii?Q?d7xrbnLd9V4D4y5wNjIsOWnL/6/ow6Z9O+e46A9pzluWG+Bvkgcc9hKC1H/w?=
 =?us-ascii?Q?QW2WeGpI79DnHVPKyhIKbQWZr/851PwgVttX0Or8Pvs+ftXLhFGZUMbKNp/p?=
 =?us-ascii?Q?VZCxI5F8Cj/6l/PQZfJOUssUaQNFYNRkXX7Tb0JPNsK2KnpudieKEnMKMmpc?=
 =?us-ascii?Q?oHuCeH7j2EsVRPlgH0Ml91+E63fBSL6qM0dY93bz22+MAr3aWOuUrEfvUF6g?=
 =?us-ascii?Q?rhqt/h1OX3AwIIeeH6U3SiZ62Wv9Ze6FdUpxQMYjX2JBnbtHeLJ3R++fGg/L?=
 =?us-ascii?Q?KHGriwUV2rKnB/y7/OG3ZeiBGckJLHZYtZvQOcVF6fwE8i2lkxIqLiyowA6N?=
 =?us-ascii?Q?kjdA4HFHgq4OJIezcgy2IfW1d8zDcQ2diE3hnloVbIH6ReBPyT2G8aQVDePu?=
 =?us-ascii?Q?MsuPAyj6gmNc1DqFj6M0qpukUf+/PjUrtqHxYc1GR1C6BKb6UQmrf+hlIU8s?=
 =?us-ascii?Q?nw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9SEWmVAhsXB+5+H3Ylb2HzJLi7lFoepzsEYAZ0UFe0JKum3KizJNfLoW5vRcGhdpTqhLyxYjgUUor1Xegcf/kqm7TFFHcADwyfdsU3LRBdUmgIxu5ZG4y3q7inVtpAqNdXdjkSuUki47tE6nOZOEhC6gt/KcE72pyPQ7r7oHlLs5iBZdKIiczu9saGw/TPQyUE9pJxPI2XhrdvjtDFVh/Sx8Imqhe/kF2pw0c4ASoBc0MTiBhaAlnw4J2CJ+XqzSAXVc31mIs94NYtXZ99MzLhJBtjKp2Zw5nKCcCsX9ihN7Pbo16EeYNWF0be5fPPw84wBTQViOYmf4iBHfD9RzujyGkJbP90UpYFOLGc0vIK3CFSy9wV0TTAQRt5FQMeBdt5mfnhdkZ5kXbeOQ11MfYKWMZuZ69eRckbZ7TA4bc0RkXvUmOxuwTlYvvZWPekBuj2A0qeJaggcJxdRqHKyvl2VJ5Zb0SCQetHXKJ1h/buPG46xiUkERRbDy1rfCpM9Kd5U3SJCRp9R6GS/CmXxr2tKQDkNL+YxkqiWDUQGqrhefwCzyi8nxKySwN8uzh0h7Te5GrURJJwxe5mZnGMQ5s8eFdIMlom8s6ncwz8qIqrM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d0fa61b-d568-4d17-39b7-08dde693ff29
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 00:35:47.3991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D+SZE7rGo5Xv0s9qXGGZKDPNCQTe8/bSGhddnOGO+TCnYkN1NWUzRtBTF0tTrhkj/NDoKz4Aorja6LeZiiQXUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7019
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508290003
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxOCBTYWx0ZWRfXxOLQ7SOnSsnk
 2R9SgVDK0RloF1B4C+hg/3nD9PizBCBGxkSjFG82+yAgvQtgWn+KBN9t7IblRVtCi4xnTfhr773
 dArD+zAL9TQYjxxMC9GE2EX4MuVIXmbIENzMCTP69XjB1ViccYo0cp0ZhyPE2nXM4tnDJtst5NG
 3gYIWqsrIwg4Av5r5+Qur60907T8tEY7+uN/hWjSMpE9s8ScTKMf7lssZ9wQIk+HVBX86T05r6Z
 EfQevZ+jcXJZN/k6JLimrPeGMyh5wVH3H3NEwHcF5C/tp+xW3Wn0PkACY4ioMPkApNXKNhSl+d4
 L5c8zgijW9Zmh14jqxz9MqFIaJWaXQgvKUB0prDHHLnZ/H19JFQEK2Beol0U9q87iwyinFfzWNU
 lUgKLTuRbdjnoKV81s0ZM3wOJPPaKw==
X-Proofpoint-GUID: vzdDKTQMx4pht5xG15m8FNFbD4iyyO89
X-Authority-Analysis: v=2.4 cv=IZWHWXqa c=1 sm=1 tr=0 ts=68b0f5ec b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
 a=AC1hTx7W2U6TmaToLwYA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13602
X-Proofpoint-ORIG-GUID: vzdDKTQMx4pht5xG15m8FNFbD4iyyO89

* David Hildenbrand <david@redhat.com> [250827 18:04]:
> Let's check that no hstate that corresponds to an unreasonable folio size
> is registered by an architecture. If we were to succeed registering, we
> could later try allocating an unsupported gigantic folio size.
> 
> Further, let's add a BUILD_BUG_ON() for checking that HUGETLB_PAGE_ORDER
> is sane at build time. As HUGETLB_PAGE_ORDER is dynamic on powerpc, we have
> to use a BUILD_BUG_ON_INVALID() to make it compile.
> 
> No existing kernel configuration should be able to trigger this check:
> either SPARSEMEM without SPARSEMEM_VMEMMAP cannot be configured or
> gigantic folios will not exceed a memory section (the case on sparse).
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  mm/hugetlb.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 572b6f7772841..4a97e4f14c0dc 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -4657,6 +4657,7 @@ static int __init hugetlb_init(void)
>  
>  	BUILD_BUG_ON(sizeof_field(struct page, private) * BITS_PER_BYTE <
>  			__NR_HPAGEFLAGS);
> +	BUILD_BUG_ON_INVALID(HUGETLB_PAGE_ORDER > MAX_FOLIO_ORDER);
>  
>  	if (!hugepages_supported()) {
>  		if (hugetlb_max_hstate || default_hstate_max_huge_pages)
> @@ -4740,6 +4741,7 @@ void __init hugetlb_add_hstate(unsigned int order)
>  	}
>  	BUG_ON(hugetlb_max_hstate >= HUGE_MAX_HSTATE);
>  	BUG_ON(order < order_base_2(__NR_USED_SUBPAGE));
> +	WARN_ON(order > MAX_FOLIO_ORDER);
>  	h = &hstates[hugetlb_max_hstate++];
>  	__mutex_init(&h->resize_lock, "resize mutex", &h->resize_key);
>  	h->order = order;
> -- 
> 2.50.1
> 
> 

