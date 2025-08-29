Return-Path: <io-uring+bounces-9474-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F064B3BEEB
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 17:13:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id CFBCC4E15B0
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 15:13:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BB4932255F;
	Fri, 29 Aug 2025 15:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oiwh4Q5W";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="unkb7O9E"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B1A2853EA;
	Fri, 29 Aug 2025 15:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756480380; cv=fail; b=TyhRnNcQuZjGYCy8TAkB53xByLNKdG7J3kCxoKz08Z5de5IM71kIeTYpZ3mVY7BO1MlJq3ibenAnYYdxpw/vpwZT459wjRtf2cqV/kYJ37T7EYKmF8BTXxH2ylS1n3FpveiKtFMG53kmkavTxJLwIwXOHvrF5UULYpmNhc5Qpa0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756480380; c=relaxed/simple;
	bh=I5hGZ3dHIqntjXcXz35N59yYKYAzpd94DEbvZsuS/8Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cM2ovnvhVWH2Sr4yf86uyt95rFmznHnnuTu0dSTsjXeiTgfPq5AZBFn7/I2Rgt39PLc1ts3p1r4SL8gTYqbSl+Mq3REuKa3r3vlm9guFTYo1a6YC2GA8EQlVS0BDmmIP1Dx7lBcCc1moLRdCZ9Semax9lNo+cAzrD8NFp2NAFR8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oiwh4Q5W; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=unkb7O9E; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57TEtxJP010044;
	Fri, 29 Aug 2025 15:11:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=kXj9ChDTNPS9HqzKLa
	6MB2DeiHA0qhtBDRHqVSm6ga0=; b=oiwh4Q5W+/6c5E+CAU3QefHehUWcmuwH/J
	8h1+tschBhAVpGEgDmuCWVeiTS1JJxiOWQNKuXmjkPqsFgGBaxcomrGx26icgMtX
	CqLBoNLYix0OuMongJdwcC5suWA23jA6mBvwUl4127Ot+mjH5PSzli8V2vpcqTGI
	HQDMzwCQg7KLb8HFqrDqCCH0MgDwkXYTrYWv84HfDFThEnykCYOZz41j/FOh4TS8
	CaRuBw5cVFVKy0wL8aEHMG0H8tVdXn7cfnMn5WQ9MRum4wE+e/hqf2EB7AX5xkEu
	9AP028xqsoeYNLCJ9qdwCogLEXCIVx8jrgiS6NwP1Q+yOIcR31JQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48r8twhcw2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 15:11:19 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57TDpbPA005007;
	Fri, 29 Aug 2025 15:11:18 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2087.outbound.protection.outlook.com [40.107.236.87])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48qj8dgmbv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 15:11:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iKmLu8vOygr6KfHsvLTIZJ5eGEOtLjxgiOauFJJD6VAgSJxTfG6dDOJk+/jPkLT3CS/gNGuKsyP/S5qOw5jpVCj+w4TqtlNMHZnwu7Ch6ozmC0muyX2sLJFl1pti4ws33L2PMjDZhh7RCq5hkicEeTWlaXUqomw3rd4Z6HTooNaDZP5qKJaVcL3m4VwAlYBr7eIZDuEaXJPefjrOeyD5BmUln0l/MSLfwad2giTUwD4OsgF92K3M87y51i5XxZpYf1iKGHRa3qSL4RAeOn4AxKsZXOxxTY6CHMR59E0i6n3nC1n0RIMfYQBF4XXR4K3Mi6ohZNiz9DvKBoKyaiy1sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kXj9ChDTNPS9HqzKLa6MB2DeiHA0qhtBDRHqVSm6ga0=;
 b=uLqmeLWKw0I7j0gaOwBEcTtyq0uRL/MZiVRQT96iXhSGPwE235OavQZ9AMTS4259m/RbeNVbFdx2oDMesQg7EQc4RtQ+3Bkwj4Ev34F//Uu8Fx7oJAMQ6MA8vIsgo0mrKRUY1lXAOlIaYQRC5scI7NBRJbUrq7eFpnSdDk623pZ6s1GdX4harMKxocwhF8niVPYv03M9GJ+VWWjii5BLj7lrvMtY+Qg8su5oIbz45DebdsEoy3MxOSnQMnR7jkuK2duf+JDUUuP/sjnp0NRJW6c4Tqd4KDT0+fsnCgjAw+aeAmHO3UtEtAIG87xOyQpIuXZXqwEwGd7FZSe1mQRWRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kXj9ChDTNPS9HqzKLa6MB2DeiHA0qhtBDRHqVSm6ga0=;
 b=unkb7O9E0svz4fp9w34LdpFAaw1F7TiP5wFXLphKuTO05+AClwQkx/+Fp3MrWCl0sQPOPEoGrc8ATBGSFDfhX2NlEeXBoKu/t3FklTUGECTgIsQRhLssFMELZgYP+TaAqh8jCmHbkdBeYLrkIoF0qND0jwmr5xIavyOBtgWRai0=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by MN6PR10MB8047.namprd10.prod.outlook.com (2603:10b6:208:4f2::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.17; Fri, 29 Aug
 2025 15:11:10 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9052.019; Fri, 29 Aug 2025
 15:11:09 +0000
Date: Fri, 29 Aug 2025 11:11:00 -0400
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
Subject: Re: [PATCH v1 17/36] mm/pagewalk: drop nth_page() usage within folio
 in folio_walk_start()
Message-ID: <6mckxk4fnam3hxhpvdhyeelu2bbut3xbtmwni2oixfgffzox2m@lnod3lwxkb32>
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
 <20250827220141.262669-18-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-18-david@redhat.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: MW4PR04CA0224.namprd04.prod.outlook.com
 (2603:10b6:303:87::19) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|MN6PR10MB8047:EE_
X-MS-Office365-Filtering-Correlation-Id: 328ab90d-7bbc-4f01-8b0d-08dde70e488b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hpcIabUV2Dq0jVu7uim9aj93c9k6m7Zd+YhvZvBr0XHrFK+0LAULPNJPeWIH?=
 =?us-ascii?Q?T1wgFXsfDkhDw46ey05XF+D+pmKmp50KIcV6nHrGvX1cIPod0ZrXTusGlE4N?=
 =?us-ascii?Q?TSIlZxRcXbNJMEhkxirQRAkNftIJurxNLX5ZBbWQWQAR+YIslCoRAxIMnihK?=
 =?us-ascii?Q?lgynbauzoicw7bgc3pYFOfjiwgu35usdb6MjxAzIlfk9335kUc3JUs8OYp7/?=
 =?us-ascii?Q?r1HaBjIMsjNRHV1t1/U7ujHH3OmFZL5cQxtoodBpD9ajeSBUhGG8kUBt62fq?=
 =?us-ascii?Q?eV5VIsXwaAHotHd/g7VEZLN092mDSNIISW833QGYfSdq1SSaMqBikkmyJGxN?=
 =?us-ascii?Q?nC8U90AyiG4d1whym1r9b2xdAMNYlWVYs5Q7zkv1W1DdKbslPSCQcomysTCP?=
 =?us-ascii?Q?/3GP+M6t9pVHVVTAGN41anKya2zFZuLMjUgCZGY1fAlJQk3DazY6ACgL0aul?=
 =?us-ascii?Q?MK/ynnRxahey6c/1jTawaWObiM93TINWmxdqVYl/Kbp9FsrcwNH6Yy/r1oDt?=
 =?us-ascii?Q?D1p90pzvF7kHUMHXBg6vafPaYEjtiFGaZO6nzvOz2ee24nDtJA3CFIsLe9rK?=
 =?us-ascii?Q?Imyof4/OBZ7ASamHbvHM7ndeP3WFQawDm3v/Z0Uu4Omd8HlSGqgNiU6/oqK1?=
 =?us-ascii?Q?2YIRYqESETHSKClXPRRS8P076XSwsnot4pR4ImR/pyRcCFGFWCcc2Z7QmlUr?=
 =?us-ascii?Q?CRwkM74AMAg4o4K+AC6LeL4kzrHGsW/GcR52RWA1ouGrZ5/trrn1S4e/sr1O?=
 =?us-ascii?Q?wt+xJvGBwOfKADB2Nw86gPc49VP+ib/49evSvj5ra+1g/LUYXiz4iTcbva4A?=
 =?us-ascii?Q?uHMWtkUbw43v2bCU6mkBZR9RpHP39/ukzYcQwHy3yKecidb8JFCAHarte4Qc?=
 =?us-ascii?Q?NA1QfFZsjniiIHe9TqmdERurxCphpSDQPMAedEJLqLr2BCulppBSGOQdfXb7?=
 =?us-ascii?Q?kEyAEXWmq6VmEqdj+g+uoGNOQKU40BTDPUb35Ya0qRO9qHSyBP+sJx7GO19B?=
 =?us-ascii?Q?a1Z3awX3D3sM6DRU7IAeQSLgahP0CbkH9l5EZ3BVX8z4qFJLle/pMygNamiW?=
 =?us-ascii?Q?2z6kbCNIUd1lLdOgjEgfOKx/NXhpzhEDZTQqfWxeatjsdHwe6NUXLkuRrsx6?=
 =?us-ascii?Q?gUzgNtiarFuIKOiBEG5xUAKiJ83w5IO7xLgjbdTPfOdv0vy/i5l6lMCCcU2d?=
 =?us-ascii?Q?wtRBYkl8S70shiJHdZHL4ityukwL4diIq25VHRG/hd3sa9mFkxm47cr4DKrw?=
 =?us-ascii?Q?L2zjdlxe2Z+Bxh8oYeatN4srnk02g1MP2DPX928QNiSffjzYrfpYjMmifBuR?=
 =?us-ascii?Q?vwisl1HyFPaCHpH2SJCqir2cSFBy2NZyeGJKZObZakpYqaa3rSbRVIugH8XT?=
 =?us-ascii?Q?DlWWOsmEgX0kkYVNUkFGYK9+K0oDG7Cc669dIIP7X6w4vRCdgA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AkWJWasUnzh8qJgqN1hRKeOVYuDcdZFr+Xg2f7irfDcCV6g4nwWjutxXRmax?=
 =?us-ascii?Q?LTQxBtHPj+8YpXjw0hWYJMW0VGhtW+PAEgJE6qMqbvVpUn4b2/msT6y5Q7Fl?=
 =?us-ascii?Q?LQjfVntiIp281jApgOLWD2nzU5nnUN4b0qfCrfV4bjXCy/QYBBnssotPWqwq?=
 =?us-ascii?Q?ekd3ZcWf2/jzqqblU43TjOzURMxYmqkIAxQ5vvSv4HqUC6jKhlzoDBpTAXFI?=
 =?us-ascii?Q?u3uaXvxVYo4DKBBeOGI3tnsR0kpvHY0cvdHXLe0E1SHAbx/9K/Xf7LOS3reA?=
 =?us-ascii?Q?3Jbn8DNj7ni5JepthXsCXzTNHSPkKs8W5DbNqEU1maLcZn9EdNvzVHbdDMxq?=
 =?us-ascii?Q?w12bhV70UZh7N2FK5GqFNpnnk4aTs0Brq7aychMI/VAtqA7QaDZvKw+9wJx6?=
 =?us-ascii?Q?QwW9I/dlyVb+fjP98NeAU43edJpr524lU+ywaM80DoBncOE8i7oZbUDh6vBV?=
 =?us-ascii?Q?GMQmzdTu2SZ/1d+zt8u0oviLWAVgrSdwh+/1mCEBT11IGidr09iQX7rr7Ykl?=
 =?us-ascii?Q?ddJoQUbCnOKKKPhAp6bwWqzHf8DxRmdaHGX3ZWSC+m57djgF7uMq7DdWHPto?=
 =?us-ascii?Q?Ze/OCzOq1S+GvQX5HSVLxa7MzpQpT0UUaFkpYHCzZUVMWZwDiLSfxgzbtJdC?=
 =?us-ascii?Q?aFgIkVcVibaevGrsgCHQYimnOm3GNgWPMTNb3oVsAffQYlw5bOMlRAsbdcpT?=
 =?us-ascii?Q?XibRlnp5CeR9D/5+DWXJMtIoIcjzxph1Tx+HyFXgN1dM5+tSaDyZxETTb1aE?=
 =?us-ascii?Q?lJ2G/1v4ZTdgehEAXcirj+t/KkOCAFvkoN4sUF1gMgNvfoMZSIPuOREZtsrN?=
 =?us-ascii?Q?T7AVkrCooGBGaYp8QYn7QbPw8YWLuK876PryJXcRfBasMWIDwJv/YK9TUUtF?=
 =?us-ascii?Q?jjrjtm/LY6Zo7mQO6zkq8OEPePQ4G+NJtmlg7tA2TVqxINB3WfI+hEOEU574?=
 =?us-ascii?Q?dm7UOCnM96PZk5qmIcFNMORO6eWeL4hO9qeRDDh7DlWzyIa3x8epRdxoWRKf?=
 =?us-ascii?Q?K7+GNmEeE/i0jOFABEt83NU9S6L4p7wcNi+okHeP0jzzb14PDyN82DiWfab9?=
 =?us-ascii?Q?ZRBu1yWrJ2zOAbxIxz/jp/9uWgA0lo2CDaRQ6dQK3ID99piQSurvTgbmavBK?=
 =?us-ascii?Q?hx0jAg3oLlfEUgojqaJb0upMkkHabnKkBLcIKckplGacyqvPwURdSIqe1YVZ?=
 =?us-ascii?Q?LRI65LWJfzD7M/wPExeW+ei34fKJtPzmitcgDezOy6061PUaZDNjSG65Mcq4?=
 =?us-ascii?Q?KImiXJPhEhUlhJKfFtIIc448Ba3/KfhIAUOgBC9jPDYUzgrez632GLt6AwNH?=
 =?us-ascii?Q?oUSFH4KoC1wP45L55FYlHacxWEpAVzj2yYgk0bPHEIn2UHKTc1vLkbndLf3U?=
 =?us-ascii?Q?gmXpPkE2lVlx9YU1tY/KPL9nYIluAQLjS/lnKBXgLTOnCVFIbxXsRQWT6DoB?=
 =?us-ascii?Q?SCIrVNBJ22Z9019mNRp4NX2TlowBja5vhrh1v2vWkfBnSnmgaXDvFGQOx/DP?=
 =?us-ascii?Q?p29op39ie4O++6ffDKnasFaWzJBHNvHo5zLYCFd0cP+TKsMseCUZ7BoC9iN7?=
 =?us-ascii?Q?Pbi7x0S+yrvZ8QEPAVr6b8b8CfyQrxNVehnfxzpFK0/2Ci92eFKqUIfijevu?=
 =?us-ascii?Q?Rg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	S5EUHZ8N654ID7LfWixkMJERT+miJR6BctMLlL4YgYNvNqCIaXiMMglf9Lrc0dW5WSoP/dUBCy7Za48XP6HYFkVdbjNCwzTB92exrzIRhkOJui+xulor/9rSO0Ks6dje6HhRIEqsifLhZU4QYfOThSDThBnx+FQGWbeVGvH5Q2NzNQ/4KbluzIeo1oQ7p39h6006NO8Cu313SMd2A8PxiHUyGcBFA9gR1HbBuFoFni9NAOK5UQM0AHyZ+vshVrTir5l4TzXxR7oiGeBjivYaOPXlkWuBZ5vBjXbleHiRtdTuXdDeMhRAazn3hThZBVQPtLFuPRHmmHWQQvCoduGfbilmR1BZzs2F83w2dtC4kuvf+EWMw/mQdQRR7Wy6qK89JJchkTtsAqWxfqo6H6CB8g9TOEV3SBg/IO5HZ3IqsKauXYxcfGJE8Ua+cFiJBEQpQ8smmYKDvvZ/hxirbkdcCOVls5/uc45r93ZHcV4ysOBMB0nqQncr5xbXnvtSf/7kTEuIJDmNdxGJda2uO2tEdeTZCKGk5T5lhtjM2veaPwChalqii3/L+VH00cvhETJy6Yz8oYmK4uVhX26Wk7KSPRZd+m5ripusOC0xuKfBmJ8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 328ab90d-7bbc-4f01-8b0d-08dde70e488b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 15:11:09.1058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ga7seJEj6m0F+TpbdU4QKsY9pGH46FhXC4jLGLp/+QrEZZkbrK8bPj1XWReQZkwrH6W89iItOH1/7WO+O/sPZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB8047
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-29_05,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508290129
X-Proofpoint-ORIG-GUID: jQWHJx5FhBrVM-tfUYi2ZZi6FkQ7Fztu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODI0MDE4NCBTYWx0ZWRfXyOlUvq0luDL0
 ml+qnnYnXJ1CuSawVX7WlUKp7i4/oahlFOtiJpqYdTZ/ujPLKET5+ouC8SEzT8eubDKWmE/LJLc
 MbUXPgEDYd2d/jd4yKQ2dwHLEq+AEZIA+cKmsv79vVrkq0107J5jS+QKr/gUsk7DtDux5UtvOt4
 dMqdSBpeCxgMC7W/IQhplmZihYbD9LGobZquP/sldonH7F1310Sxq7F/rZwkneGRIwW8jhHYXPK
 PYXCbOkqaW61oKs60qhsNcbpJ4xa6gKFgtcXW3SL36wbfpiWO1GhwpfgC+6P9uqJYMlVxwlK8y6
 T2veWYja4mLYm2Y+nkvgNhSqZiIWnyWN6dlbseA4pK0m0cEuWkDxzBW1ZVmv5DcbiVkNz8lyUPP
 SHLdmcgRo0sDquw/hjQXCvrt97NTIQ==
X-Proofpoint-GUID: jQWHJx5FhBrVM-tfUYi2ZZi6FkQ7Fztu
X-Authority-Analysis: v=2.4 cv=IciHWXqa c=1 sm=1 tr=0 ts=68b1c317 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
 a=r7k0NuWjBar0K7GxAEYA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12068

* David Hildenbrand <david@redhat.com> [250827 18:07]:
> It's no longer required to use nth_page() within a folio, so let's just
> drop the nth_page() in folio_walk_start().
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  mm/pagewalk.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> index c6753d370ff4e..9e4225e5fcf5c 100644
> --- a/mm/pagewalk.c
> +++ b/mm/pagewalk.c
> @@ -1004,7 +1004,7 @@ struct folio *folio_walk_start(struct folio_walk *fw,
>  found:
>  	if (expose_page)
>  		/* Note: Offset from the mapped page, not the folio start. */
> -		fw->page = nth_page(page, (addr & (entry_size - 1)) >> PAGE_SHIFT);
> +		fw->page = page + ((addr & (entry_size - 1)) >> PAGE_SHIFT);
>  	else
>  		fw->page = NULL;
>  	fw->ptl = ptl;
> -- 
> 2.50.1
> 

