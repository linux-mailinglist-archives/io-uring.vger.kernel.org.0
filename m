Return-Path: <io-uring+bounces-9472-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91DCDB3BEAC
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 16:59:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3AC175865FB
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 14:59:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36857322A35;
	Fri, 29 Aug 2025 14:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="owuBOFsL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BXQLqVNu"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC8F6322742;
	Fri, 29 Aug 2025 14:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756479538; cv=fail; b=LI43MhmuKpn/NKerneZ5bLai8c8hJ8kHcKOs+uLr2b0aaGNb78fkREGNzAOpaMf+3ij01nTcs305myP6LMX6yzwF5q73dWGPBWyM7bQEClhrHcie0ZG30VkvZuUQYJdlodCJqbmijQB1lT9OqHjDt7R00lIqt1ypuXRMtt9/sik=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756479538; c=relaxed/simple;
	bh=1QEaXDQ1ghKkIbIB/Tjztoy3J37PLS3dbzYCeeBdQhQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Pd16O7lz5O2VSKi3MRyXk6lB4IkTYxp27oVyRI/Udtzraw6/nxe94fcVWtglHHeUuKZYDRnoa/rrU1xLFFuBwrcsATRo0axI0SJ4XH0Cnm33RF5jy4veIM31V6Imi2kQGPHB/D8KXwqfpUCX8CN6AXWBCd92C/LBdbUlcCUFzrs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=owuBOFsL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BXQLqVNu; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57TEttRb016844;
	Fri, 29 Aug 2025 14:58:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=XjSvybiV1mCOOWGFdc
	8HrWCkb2mDcOiNM0aLbHSizfg=; b=owuBOFsLvfdU/m/xCGcw4QsxAvxw7x3KoR
	S6ntR0IB5mluQhnMVY41t2/Sk5JSBd9diLs6Ikkfgj4EhvTY6Ooc5GB4QY74ugWc
	NWYU7/WwlsjbZxS+OJQg6+vY0K8AM71XQIJbZs4L8iJ+pJm4xD6jut57AvowlJS8
	Wyp3HnlAKyVZ40vbev2zLbww7RC63U7/wBrIRPFQ5zmBb4THk9JujiiGYWdnL+6/
	vq9FR3dYRUPwWkr6VSCcLsD24iL20N98unxyAJiejzNKuHzkJJlwTSu1WY48PNDU
	GvBdZ3jfVhufVeADCrC1kXbDXzItBNVvyulUI1QeSF5QdzqUr3iA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q6792nr1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 14:58:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57TEgW0d026711;
	Fri, 29 Aug 2025 14:58:14 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04on2075.outbound.protection.outlook.com [40.107.101.75])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43d3dhb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 14:58:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dDh5kooa7f4wWTvCAOHiZHHeAWm82gbR8iqRBCxPaebLN/PflxXvlwkf40gE+GVzw5FZHgOio+r48OahgNsOLWbHfdjFYttwwdjGr1pzF4BimprMcGFoFnSsyfTW5TLWjv0xS0zLlzLvpju8oGAXL39uQFGuHG+ASvBZsGTcrSQYogSsUTxTkfhy98fJdT9kxsSeqWuXCG8NZatoETj3oyvjrsaAQNfwD/XJf+XobDvp314evz1eN5/6dO91X0QB5u0Ok1zZOblhP96Bm3/81oj+Cs8l1Hhm6FSy7LCuhZ/+zxT128JpWkfMmInf+jTPuXwwMNAf2NumQ1Wkdp7DOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XjSvybiV1mCOOWGFdc8HrWCkb2mDcOiNM0aLbHSizfg=;
 b=O7EWZWHO+7pHvCeiYl+zLm7JL1ztY746GyMkE47ZcFL4HFXdtZM66qjDfeYHObAt5NP4+iX9onkfFe5JnFZdovoOHuXv2qXOIehgSVFaGjt7uVoX1SO0OMivrOlyTAeor6LD5/u0mqJFus5piMe08BffK00V60hLOCaw3Ecoa77Rf/E1HVlkgf+cuZvkBtTxZVBwqAq1d9c3QsDiDskfjFaAEGZt+fnXwobnmkuS2taTXCHiC8qDfR3rkEKi5bDhcLVLaNP0UYR0Zr8IibPpQn5wulK8OleGK3rpBmVXUjfr7Ff7dGryJK/LPD1IbqyGUlu94QaFL+J0rFQ8D9MeeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XjSvybiV1mCOOWGFdc8HrWCkb2mDcOiNM0aLbHSizfg=;
 b=BXQLqVNuwv3OyNwtMGNRdYhJbb5pAYQWxt9IKmZFKZDAQhWHguYWPs+OVZ8uDXjLZWMfiVmP77FzhKEcma3q15vgh0jYAaJTxj99dZsnBAurXU7bD/AuZ5caMGmkWf1q788zhBBUI4tTl03G/zZ8U+1zf39Y8xhWEMirhLDZeFs=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by IA1PR10MB5995.namprd10.prod.outlook.com (2603:10b6:208:3ed::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.17; Fri, 29 Aug
 2025 14:58:06 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9052.019; Fri, 29 Aug 2025
 14:58:05 +0000
Date: Fri, 29 Aug 2025 10:57:58 -0400
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
Subject: Re: [PATCH v1 13/36] mm/hugetlb: cleanup
 hugetlb_folio_init_tail_vmemmap()
Message-ID: <fwvaz54goiitgwt2xiomominm5bnxga7ce24b3rpslg34alnvy@6bvpfuoic5dt>
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
 <20250827220141.262669-14-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-14-david@redhat.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4PR01CA0178.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:110::22) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|IA1PR10MB5995:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b286188-a1f9-46cc-1698-08dde70c7594
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qLUtPcwt5F49mN9Tb92NK9/OHP3eFALu55sQmqn13+AoChsge/Lq32RF72+Y?=
 =?us-ascii?Q?kTkIvr0eqPv2Vv/32E044TK/zg4b3csUVMsXjboM68GTC/0wBgYz0WcoYOV9?=
 =?us-ascii?Q?kdUxD2jR9AfQ061ROHAIOKJzAT1fqg9I3zgivJk3cXXLNAdnZy8O6FgjwqiO?=
 =?us-ascii?Q?uEWGmRdVvARZ/lKSKCWapfY53zvUH6+n2SCoYhQWAsNfGbHTthVyKDVzpSZN?=
 =?us-ascii?Q?QIT+6xaEFNeP7pSppT3RLTXJ6xuQ89UnkdqY4Koas2qrKb1BDvKp0IDS9L8Q?=
 =?us-ascii?Q?r8lCVK5NEciQnvyRhZ79kzR/faTQQ3psJBoxi0aLUkTsmMDDO8nBjtgmzEFv?=
 =?us-ascii?Q?WVCNT/18p7OgrLvrv3mJyJ9tVjqOoDZR9netD65Vmtco3oGf4dTUVUmA3ViJ?=
 =?us-ascii?Q?rgxOs2aZ7L+oEOGdLGzCn5vQNXiuPU+R6b4cjHWcJdzHGsvwivTNAXsJx62J?=
 =?us-ascii?Q?cT5UK+Of+rYT/22Tf5fkhMwYPK2GMLcGRFc8JdayiVu9kDLpoS1uhrIbjweu?=
 =?us-ascii?Q?sDaq1+6LqG8OfuxcCpfRftJJ/w9tR193boCWN5qIJ5+RaZNCGQs/4rlBwKHx?=
 =?us-ascii?Q?V2HWFY2cO8bPcSltj32czL+cyLD6BsXcI3PPURRF+M2HV63ZKYRlmTPUauYV?=
 =?us-ascii?Q?olnF1Z9VR9pxZ7jipaVWYd4AOjufL6yoPlyPGNv3xRswjHG4KnlaXPXxA7Cj?=
 =?us-ascii?Q?e6piVmcXbrUsTKfakZwbwlcDpt2TGSEJu0hUsWBM2DecUbelqwYcqjdyBhWE?=
 =?us-ascii?Q?mFpDhl8zjvE8+Ath5FuC4TCT5iS8ALxk6aELdmQqPVziLLD+63126iF0rhRy?=
 =?us-ascii?Q?OtAFEbld8F3MJzVNrJwzocORBmrwRXdbG08CiQVPzwxXb3naCEVQAnu/hhvT?=
 =?us-ascii?Q?iNs/nfQONoU7SMxkrQ/UUU+nUPZEETsMPXC+gyloUDjhlaE5Edh4yKgwHE0d?=
 =?us-ascii?Q?9yHU4mtnxcc3loFs9jiemECsAW6AgSUrsioOhNpY+f6SV+A8nwXRZqrJfBbw?=
 =?us-ascii?Q?hoVozi/yddiO+LrAOJk7vucy2uvYOodbm1I/bzu6i71JBfULJMaTLwpzadzJ?=
 =?us-ascii?Q?e48HFkq4yHRNZ1Y0UwY1UbIbqHYUJwAyKpLWbNtOySe8NlYArXZKOrmKwg8t?=
 =?us-ascii?Q?3ZqYYGV1hGdQ75hF2f/GF9CEGTsZLMI5G7Lc+3DqnsY+u2BFusQZ1vmUW5Hg?=
 =?us-ascii?Q?dWE9u2nVNP7uP2cWO/GIC0/ZbUn1uw0GUYMo8E8hTIXugB3zPZSIb5kjTlaK?=
 =?us-ascii?Q?3njJfrFZB+XaNDvy2u/4SuUCMI+ihKfUtYfClGMHsMFbzvULfGeZQgYSGJy4?=
 =?us-ascii?Q?F0lCsxDnmG5wYQxFw4m+Z8to49EUGn2zG+JF3bjy/t5Bh+0obFJAjtGiEOKa?=
 =?us-ascii?Q?CtdM4OmuNtVh+OJqWKAASiGYpS2kolMPrTvng6x3Ic2NC+LErw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aU6dIUeBVfoHtP2xWmmI7dd4wWc1GdHMo49kzEpq+BIbxD57wiUml48otp/0?=
 =?us-ascii?Q?vq0KSJetIezeSOoA4zRqbCvh7IupQuB8sfO6ecdO+57qLnCb/fgIPHriTLqn?=
 =?us-ascii?Q?yO4xMFBsNnL+c/OVFN9wD77FZG84ab4Mlbq0M93YNt9Mx3cobN/ukFrOGIoF?=
 =?us-ascii?Q?z5eqtT7SUhWWcEkI639QXQtfDwFQwN2NHOFSq0bOJtW0p5srtTjvWfjTcWCD?=
 =?us-ascii?Q?AL041byWQ+TO1CWwOrciAPvk633qvTV1nreEl41c/Mllxmz4RRtr2cspinjw?=
 =?us-ascii?Q?vdAcD064jTGosz/Y8C61JpPaPLE1vyZQ8T5f6jkB7ksRoYhd7J8ThrAx1plq?=
 =?us-ascii?Q?UFkQ8OMXIkXdx9v3C3I7bZeGCY9aHz33QTZl50ZFcHflFxtdaXci1FWubZVr?=
 =?us-ascii?Q?9ga1vRkEOtzoOBXuCUdsNYEbhCnOaSvlkGnhIkntVeUnqwOvYS7lcod8ukCn?=
 =?us-ascii?Q?O95tQifjmeczeOGXnKTaXnqAJRAS95tA3egBS7Sf1GVA03P61MBRC6DOjDAG?=
 =?us-ascii?Q?ySQ2cCm1i4eQSxWNNabuSlHRpV20t6PrVvAFGPGu0xnT9PcyDAGxbWYidxcE?=
 =?us-ascii?Q?AHuYeRrEfeTut5Mwm7fycF+fBHg+fBHecrlhUWJTKG4hfpHeIfV6ppb3dnpC?=
 =?us-ascii?Q?1v6NNZRZoSFMAQMZWNajwstrc3/FhxWbH5bQ5+Tgn+B4NY3TvqdUyQXQAByy?=
 =?us-ascii?Q?ELsBXwRnJocW0keg2SrA+jFKTrr+YGtuTU2lMS4lBJx+GOJzcLKISwf+mihA?=
 =?us-ascii?Q?juuPQY8TTGXeCzcVtgcOdXf2WX3j3roCpT9egdYQDEKijqk/MYfR86h6C77O?=
 =?us-ascii?Q?nPfKqvyBkWPZFvWaUv/HR2JhyLaLUB6HuFkpIIQQdBQhFahtMOsuKkMblzub?=
 =?us-ascii?Q?A9A50PjhhLxdwevYYNMVrurQZNgKQHrb9n2ySiYHCmzo/Cmv0s7dYIjv3EKO?=
 =?us-ascii?Q?Z6+DQHDWQ2ySLsoniDAVtBArWvTlbwZLOpeejNYaRaRdEPf87II412E4iVmM?=
 =?us-ascii?Q?gkrLokON4kZ79naN9wWg+zwIOcnL1KWCbdiMPaNG+AfVC7lAODNOwmx+ieEG?=
 =?us-ascii?Q?/Pgq7aZmA8sWQknZt/kstuORHd9QpLhuypNKdtnhTjuBJ7dXqfOj8x/c14ru?=
 =?us-ascii?Q?6TwPWS47orMz6jS1lIRPiLdiu1GRy87Hvfw0gUd5N4IVMoDfBHeILt58jUlQ?=
 =?us-ascii?Q?pG8KcUGmz20Wzclc4Ov6+SsuHDrG0jx5JZAAaRlWqVR4jfJ3JexQbvcC1EDc?=
 =?us-ascii?Q?iK3qX6rpesxr6Pia6eP35JNOvRbznQwzkvKbnJly5GOM22JG4yRAsrGTBnf6?=
 =?us-ascii?Q?eDgzIDJ9omnFvRv57DtIE/7N668m13a0rAJ9aVdXMOpHwPrPUSaXbWlb3kCA?=
 =?us-ascii?Q?DS+UuM4Eyd3oR2Z9UpdiflNPqZG8K8igXU0aMwesd/jHT8veBscNcBWV+NcL?=
 =?us-ascii?Q?8PxF6qZFypp9v+akkvXYUlmiLW3LKs6nNd/z91nqCFkW1oiMmWnFjHj4jroH?=
 =?us-ascii?Q?XIZDrCXmt9BYxRJ+8PgCj6tqalWn0yBsTZ/Q6qVhCqM9YHjVUg9yjzGAN45U?=
 =?us-ascii?Q?pjoTDO7IiXKmkswlBv3LTLiM2fln75MG+kqFiilyBUyV+IysDZt5RYrzq6If?=
 =?us-ascii?Q?9A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KBdXMSAwx2b0O+YCtN6THgq54RGz4ub1+4yKYSOJt1iFVGbyMfvYIz2tYpaUqDtygCL7ZLP0sD9wY/UYDbPCwoKPggf8/JKaI00jFbM71VBoVVl0PUPzyMGaUxsBUfv+Xpxw2J42fV9m2hUhfvjo6io3CtRZTMfCc1bSKeZ5VTU4SdD3OaLIshP3LqsbGtmyPNq6utGAuFtkEWCVNinHa0+vwDsU3xOifRKPfJaA3fD36v/SNRZVGx742mrf67mDfBN3nWbanE+ys2gqfIIknWH+lMTKijmgKY3ccqBnp8GmAOFhzDfLbn/QSQX5AqLmvTonseiE6hVioMcwjMUTtjNQSlXAYTXgMkaWF3zBKfLSXwAAjgHCI/zEUAre1ezQCL2RGv+RtrBtf129uXfvGend5mCKwC64rEFiCId5fl8WyGmxUsb8wfWssRySdzzRGZY8SOCDfYrcepBMipkXsI1qAwlMOqLQn1hniX8bESLClwcXingPfIA8HOBQR2/c3jQ1vwyiVJxaCTk5DJKJlwpW/OiO7Vpp6VywW6RcW7WXBkc775oI2ngz9hsN6rDpN/uRiJUe5mbzMh4s6ATohPZDYPaMQCHU2LY6RoAytz4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b286188-a1f9-46cc-1698-08dde70c7594
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 14:58:05.7586
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2PUHfCtyeEBo5LvaQmTzuHNeExU9bUO+KbP5iCnS0FSHOTthY5pFbiHq3O6BWpfL8cVHAuZWciQASpyoAqw40w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5995
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-29_05,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508290127
X-Proofpoint-GUID: z2JNVAFN9hu4bcZxNt77D86Df8DLqfhZ
X-Proofpoint-ORIG-GUID: z2JNVAFN9hu4bcZxNt77D86Df8DLqfhZ
X-Authority-Analysis: v=2.4 cv=NrLRc9dJ c=1 sm=1 tr=0 ts=68b1c007 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
 a=OwKwoeAsxoJlhwySqCAA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAzNSBTYWx0ZWRfX2zKwua/jNUWd
 rYxpgCYtBuYUITqpz6780dDRwDxEDfSfRTapkgMG4WUM9j618HdWv3rSLHMuyCrQDdEFS+b5ebM
 qsNyOqvWzvdcmqx6ivE1EonqNvSWlnLxLYrRsgv29IiGwsbYtP8zWWuWJE1K7rtYIedeXlwlHLA
 ZzkdNX/E9oTT44Gc3SbecAYzKFuOWyJJXAK3F2IU2zN14qU3kjexlFIIOSkQXkyjyslFSNLu9Ks
 +TcD44qIoBEuRWPD/wbyJ41T2FYTuDKDJ4i5zvqfUkczZ2yNpJHkibVTN2EBSiNE9+y+0aDzciM
 qlFqgAXb09zO81CNYTxkg3Y0WonHD4RCyFVEs8tPIbo7CKh2IS4VCey4fIXww6GN3PtYSFsQvLa
 ERhnIlm6

* David Hildenbrand <david@redhat.com> [250827 18:06]:
> We can now safely iterate over all pages in a folio, so no need for the
> pfn_to_page().
> 
> Also, as we already force the refcount in __init_single_page() to 1,
> we can just set the refcount to 0 and avoid page_ref_freeze() +
> VM_BUG_ON. Likely, in the future, we would just want to tell
> __init_single_page() to which value to initialize the refcount.
> 
> Further, adjust the comments to highlight that we are dealing with an
> open-coded prep_compound_page() variant, and add another comment explaining
> why we really need the __init_single_page() only on the tail pages.
> 
> Note that the current code was likely problematic, but we never ran into
> it: prep_compound_tail() would have been called with an offset that might
> exceed a memory section, and prep_compound_tail() would have simply
> added that offset to the page pointer -- which would not have done the
> right thing on sparsemem without vmemmap.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>

Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  mm/hugetlb.c | 20 ++++++++++++--------
>  1 file changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 4a97e4f14c0dc..1f42186a85ea4 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -3237,17 +3237,18 @@ static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
>  {
>  	enum zone_type zone = zone_idx(folio_zone(folio));
>  	int nid = folio_nid(folio);
> +	struct page *page = folio_page(folio, start_page_number);
>  	unsigned long head_pfn = folio_pfn(folio);
>  	unsigned long pfn, end_pfn = head_pfn + end_page_number;
> -	int ret;
> -
> -	for (pfn = head_pfn + start_page_number; pfn < end_pfn; pfn++) {
> -		struct page *page = pfn_to_page(pfn);
>  
> +	/*
> +	 * We mark all tail pages with memblock_reserved_mark_noinit(),
> +	 * so these pages are completely uninitialized.
> +	 */
> +	for (pfn = head_pfn + start_page_number; pfn < end_pfn; page++, pfn++) {
>  		__init_single_page(page, pfn, zone, nid);
>  		prep_compound_tail((struct page *)folio, pfn - head_pfn);
> -		ret = page_ref_freeze(page, 1);
> -		VM_BUG_ON(!ret);
> +		set_page_count(page, 0);
>  	}
>  }
>  
> @@ -3257,12 +3258,15 @@ static void __init hugetlb_folio_init_vmemmap(struct folio *folio,
>  {
>  	int ret;
>  
> -	/* Prepare folio head */
> +	/*
> +	 * This is an open-coded prep_compound_page() whereby we avoid
> +	 * walking pages twice by initializing/preparing+freezing them in the
> +	 * same go.
> +	 */
>  	__folio_clear_reserved(folio);
>  	__folio_set_head(folio);
>  	ret = folio_ref_freeze(folio, 1);
>  	VM_BUG_ON(!ret);
> -	/* Initialize the necessary tail struct pages */
>  	hugetlb_folio_init_tail_vmemmap(folio, 1, nr_pages);
>  	prep_compound_head((struct page *)folio, huge_page_order(h));
>  }
> -- 
> 2.50.1
> 

