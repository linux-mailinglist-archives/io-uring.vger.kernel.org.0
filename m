Return-Path: <io-uring+bounces-9641-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91505B48D64
	for <lists+io-uring@lfdr.de>; Mon,  8 Sep 2025 14:26:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 29EE116BF06
	for <lists+io-uring@lfdr.de>; Mon,  8 Sep 2025 12:26:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98C3422FE0E;
	Mon,  8 Sep 2025 12:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Yq9X96wx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="IqeccymP"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761DC2FE584;
	Mon,  8 Sep 2025 12:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757334384; cv=fail; b=pK5Kd/MolQUce/LhTL3NSnPtU3Tdan2ddCaG7T/CvwPdv2YlAaRQq3pRBKE7Ux68a7L3YYl5c1oKkSQn317lnE5m/Pyy9gsCY9EdH3Ut0RvAyY4KtBeSm0pcGCQL1AKhaeifAGScH0Cppxfb9XmYZ/eQgZkfM1HTprbfWj7Iyes=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757334384; c=relaxed/simple;
	bh=PWlTAucxPAVOlCCmlL++NYWvuDpxDBKY5O4JQx9gP/U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=o02whl7tDyGkVFZTvLciEsNUN433yl+FUu16A3V2AWawG2tQlNv+s2eJoHdfLFHFC5bEMO6JBIWsP2htvKS3TAnVeg8xqjZ6XCz+o2mIxvoCsa2IEYfBAeGuJSCnogjlCRQyon3gl6ma0jJ2SvZDHak9yqO3XRAP+pEDx3+MeME=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Yq9X96wx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=IqeccymP; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 588CP7jD014784;
	Mon, 8 Sep 2025 12:25:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=53wKw2g6VGPUuZaRHC
	vrwdm1JFezKOAM+wGnQSwVruc=; b=Yq9X96wxA3CfzTABtseWQzsGSSeUCoft9q
	t6iAjhGycVuKAQULuJuZ2DYhI9WsQ7Z6oW3gel4eUbIEAc+5RRsx3xuJV+x4oy2W
	Eq5H6jFHKxisAyIlZqdCEFIUSOuovJ93u7YbREMZSAnHomJaGBHqQIBjsgYWJQMo
	i+d05KrG8kOPEyn7kuH2qeByDm0jKB5uz5CLDeBR4OmCB5anvniT/oGsudFftPyI
	npxKe6j5/R6Uam9Wr++GUkgRvAIMaiWS4F7+1agb02r4RtfQyaEo76flw0BGgXZl
	b7sw5sRo+7XD0P8yte4tHu2FNTDEhZHgDTCzaHP6udZBGg+ANRRA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 491y4br012-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Sep 2025 12:25:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 588C2iqE030831;
	Mon, 8 Sep 2025 12:25:40 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2089.outbound.protection.outlook.com [40.107.223.89])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bd83vx3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Sep 2025 12:25:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S2vDSYtXzyy/PPVJV60nIIDwcGTR8dzrbX2ADuOHUjcl+27+H2xUPowgm+VdbFPpTbNEoUR5sR7TSI0ILciU3BSchDAZJ7PAwlHX/sTUTNs98tGFWsSr/BHdMh/5fxX9HqvepaL+xHzjPZTmy/ka5tLrj6xWUYHCLmnYsbQQKy36Ax2KPRhj36pf2Rv7gMAFXT7qouwJmJvhBGT+lSppR+g7ec/7E5w5HyYVR4Lb3Ej2R6VcQYquky4nRHtaOfjqG28kpZ7UqglYjSNMERfW4kKxxP0xjORBwUmtaU6hZWB9I70K4Ydv2yj/CZvlaTscr9+aRa8Vlzx0J/9eCjbYFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=53wKw2g6VGPUuZaRHCvrwdm1JFezKOAM+wGnQSwVruc=;
 b=btkcrvhgapf9qsqCKrZVb9F67sQeQpZFaCRLtU4JrUKFWGOmub6MgNNyeXafmINNLbtNiVmwALTh2x2L5JZQacTDpy858FV2sPwB+m/5IIFI5Vn7VCZ5nRImz0bU6eOCMPubmxGlJ9tRGi/Pu4Nf09eQSdZlsKsiBOn/fm7uFJCpuHB3CCybl46ifQwQttDTZ+9zRNs1LS+pe4ZICntFf4KfKyYjYk1N9T9Msa4ki5AHYiaEy4WrSKa5R6F8vMYXIHupbFij+lekPT7BxITqxN1Bj8BzhKQvUJMotPxYB22LTLicsQgtAr3FqNCsFKnMox87SgHs0eUsomN6Y66M7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=53wKw2g6VGPUuZaRHCvrwdm1JFezKOAM+wGnQSwVruc=;
 b=IqeccymP58NxisIPZgsqinUw307nLpl2tVa6MYTpliL3sf7cqvj+JDiRW4eu2XiT0QdLjl2CgDWFPJ4HXWfYcjD8s//tBDuL/F/2ExV806Yy4sUCaNoWqiT3it8QpX5f5fOy8PllwrLPwGncvEtmW4XCUcHF3vfqllcCdh7gbxM=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CYYPR10MB7673.namprd10.prod.outlook.com (2603:10b6:930:cb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.25; Mon, 8 Sep
 2025 12:25:34 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.018; Mon, 8 Sep 2025
 12:25:34 +0000
Date: Mon, 8 Sep 2025 13:25:29 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>, linux-kernel@vger.kernel.org,
        Alexander Potapenko <glider@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Brendan Jackman <jackmanb@google.com>,
        Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev,
        io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
        kasan-dev@googlegroups.com, kvm@vger.kernel.org,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
Subject: Re: [PATCH v2 19/37] mm/gup: remove record_subpages()
Message-ID: <727cabec-5ee8-4793-926b-8d78febcd623@lucifer.local>
References: <20250901150359.867252-1-david@redhat.com>
 <20250901150359.867252-20-david@redhat.com>
 <016307ba-427d-4646-8e4d-1ffefd2c1968@nvidia.com>
 <85e760cf-b994-40db-8d13-221feee55c60@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85e760cf-b994-40db-8d13-221feee55c60@redhat.com>
X-ClientProxiedBy: GV2PEPF0000662E.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:158:401::3c4) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CYYPR10MB7673:EE_
X-MS-Office365-Filtering-Correlation-Id: 5750c2a8-fab2-4063-4113-08ddeed2cefd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3tTs0cj4xXVauyOIAm2253fzIqp28Yom061AjUaHEoKmODlbhitru8APc/dw?=
 =?us-ascii?Q?W1XUYzMzUBaVB5uUSA6GGSlal5NOLjmgZCsDNs2sBcEFoqUIZvfTxzuObUem?=
 =?us-ascii?Q?I4Ubr5mNXhc6SHZzVthJBgPpZHs+JmWItvXnSwtGZCTtyKJCX74QlEsdfH8G?=
 =?us-ascii?Q?+lS2ccdYvladrZzKIEDIm9SkL0nOKqNWbItyfG3qTKkNbDGY0ox3bkhjgAVI?=
 =?us-ascii?Q?777l82kHfPGVGPmkuU7WQLyHw/Lm7cKkZlehYm9+SxrJY98B4meIQvzI1aQj?=
 =?us-ascii?Q?Md589xJBkG6pVXemkMVmiBUIROETa+D12vjdEd2AXGXPrIQduAfL3tFSlOiO?=
 =?us-ascii?Q?O/cEBlOnnQnXmbn9XjTblznxE+/TJ1J1PGLAbfQ648HsSqclGDKqltZd9q3A?=
 =?us-ascii?Q?N2wI1kcog3MrbJ3ramVuKDudOsvky+0NIOEDWwb0FpqcASGULsd5pX4Wh229?=
 =?us-ascii?Q?1EMJc9eO6fk44J0QCaYL2QyavuxTCibus4ESJcioiCtDXnIZ+yEKV5TopxK1?=
 =?us-ascii?Q?0jvoVgjM5YRfK+QZF1SfFAzG2HQ8AfO6ruwy4Y5AkmSVDNvxKRVLGYiSRA7/?=
 =?us-ascii?Q?nvT6nqsAq9worJWTaokgn64UNmNzHH+79y+ysLvLHU1QeLUwl7R0/Z2SlMEA?=
 =?us-ascii?Q?Gk/NjVfuHQgGWaPZUvAz/CyvI4JH1sDy7EPlRdZGs8Qut/L4Gn/USVB0AGT0?=
 =?us-ascii?Q?b7cLyO0qeK6hl6WagN17LOfqBAXKWmQvKCcuqca2U1qZr+1Z1RCPfMTdCAwH?=
 =?us-ascii?Q?Kv/h+UppwB4DfVqdYikcqk9/nxNFdBrJWqOVcaDoQKdEnBGm7+c62UifMCx7?=
 =?us-ascii?Q?qC3qZbGR7fEtVDKlUXuwrsPDJTCwEUX0wEEq7ZuuP8RDg8/lL1fvrUhel0Dc?=
 =?us-ascii?Q?2QkqkkQ5ek2yW5N84Ana/CRNSysizexaGpYK810xN8kaD9vOxgBis6TFf3tj?=
 =?us-ascii?Q?1U8IfMW4coeClTCPYve02bn3MXCEQo/3+Si2F1FQnm1bxchqS2uXrf7KZfyD?=
 =?us-ascii?Q?fRIwkjTH/2nTzso0t7cmYyFaK3xc7odmBngkb45HPrFBFboMyunlr4sgIbLl?=
 =?us-ascii?Q?J12+G9uCLOQHjh0B+D6+3bVjnPbRUV5hFcH8nmQCuWMZsZtUbkkyrdAnOZsQ?=
 =?us-ascii?Q?6UBoCAYNj3eYiA4z86w47LcP0wrjxoPB0W6hHkbv/d9rk40nPYTevnGNQ3vw?=
 =?us-ascii?Q?GiHC6zVs2wjQwD77cmUeGxPUeYkDsdzSuhaKy2HmG7tYZkzrXA7yfmeiMPZY?=
 =?us-ascii?Q?ZEfTyBlzktuRt0hNapf1fie866BGrtL4Z5zmfNdmtBHEOV70XXK5iCusvSgS?=
 =?us-ascii?Q?5ntrBjxiApLlCvZDtW9u8CgPofoZ71q9GUOa+OZ4daRvW/NnX81GRGboF2/7?=
 =?us-ascii?Q?BN0gHFyprod+a0k+60UYyr1B39BxRnt+I5TeYnxQPpkAJp11S+wbfVO5VSrB?=
 =?us-ascii?Q?O1XsXFT+ut8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?H7coq9Mqpm+ZLzgV+GEnc5CzkOphc6zI7U7YExlG3nPLk1l4Mpuv8BKTCdvg?=
 =?us-ascii?Q?CIdkfiYJONceg/JjQWy8mWPXlSPqRly2q6GlZsSFwKWzCpUwdmuPlCusHWyo?=
 =?us-ascii?Q?eLgk2BVjHfY1h8wh+umWuiFSjATmh9sDSzPmNhDa/ogA1RliA5ByYjXpAaHX?=
 =?us-ascii?Q?RRnyHqm46zaPOsVjeXW2MLk9/n4/WVFlsw+mt0Vkw14HTMeTbK8mpZjQvNLB?=
 =?us-ascii?Q?J8EQQ+y+6qyIghf87eQvIwl2JD31hABYQwFg9cM5ZKGxWwGs+dxlVsez1GGb?=
 =?us-ascii?Q?a1WAK+eWQL8zg1O7yjtBxbzxFmGnPMU2Ol6DKe2XZZFcpuIlWiMoSpZZV0ji?=
 =?us-ascii?Q?n/thfzusPMv4IMg6/TprXD0rQbdunFmdNIDh15z1ibCT0+uuR0OHYDh57FCN?=
 =?us-ascii?Q?P8CW+9xp9cmcNGkdsknaO+rgjqWl/8GzlCxr2zJVTlHmUOgvFDBlQf0V+end?=
 =?us-ascii?Q?byIxBPUmkpq6424KOS3KD66qbHO43iU5pQixvl6spAAJWeWnh9cL4U8MS6tY?=
 =?us-ascii?Q?1HzfSc5jCvnR3SE4mzfp5UH0OcPAUKfIiJQJA1SvgZ7f5qTBONRDhMh4zSv1?=
 =?us-ascii?Q?JXnw8c3MIClcGkBJCfEBISR086t5UGNQmp3ALqqEHf5yubGcnhxuPYh+pKUe?=
 =?us-ascii?Q?yyn0APYtVu8zqp5dujtwblN4g786G7YmuUdtgxo23kS0YRQwR8ovITegfRKO?=
 =?us-ascii?Q?3E0l4s+0/SnhOTzQZQglQcUS4xGRkPtAINKIQqmF0bggxWGF/j7C/Hb+QN4m?=
 =?us-ascii?Q?k6P19jpUF8Zz8QoMr6OSK7+AMPd/ERWYhooE/ypEW3rSTSgfxiVlhshhCzXV?=
 =?us-ascii?Q?ZNlWMfO5cyvbGFFmCSNl+HkIZcN2bIGoAjOp0qK/Vfs1rwyKg/W1GNDY4lxP?=
 =?us-ascii?Q?u/nwuL/lk4DxTQj9V4cjG9tOPOjzXnew6XR82yO6EInNvXkzBv73VoPvlMEP?=
 =?us-ascii?Q?05fCPQzLFkX9+q0SNoXDqZI8h/mddK0v5p95c81Bf2EX/5RbOnbXj+2CuNA/?=
 =?us-ascii?Q?pBPaGmBZiypz+owiyHFP/KcOEUWbnWbgnA5IST6bkIowdqfqYnaMSTtzdAzH?=
 =?us-ascii?Q?X7rWbwPoDI1Pcs8bBzDcS1i4V4+P8F+GIP6kcYOfGWI8/tSw3mRLdq7FiCz2?=
 =?us-ascii?Q?cNbOkQ8HVgDYT7Epr0wAVfmm5MLVzpkQjb6/XAul01xfli15LGhZmsJCJQ73?=
 =?us-ascii?Q?Aw34nkRdO0KT8srwhl4FobaC/0uABN25livuLqtXyB+SUAgCsDNb1xJqcoqi?=
 =?us-ascii?Q?NIf/dJ4C89xFvqlEzknu4VRZqoK07njyPyTOOxADI6rX0iGZH0jK0xdsis17?=
 =?us-ascii?Q?XWGVGQ9scDhsZMnqX7Rppq3yfzn2ORlb6s55lSa+RCY792XbM20ipwG/yROy?=
 =?us-ascii?Q?xQK5MiY6+2gYNh5YBbfsnty0CNDcOA9l9aLf92NVOe736HBrJihfWL9jivu4?=
 =?us-ascii?Q?S3ixDsYlzpmWr/Zw/nD1KeM/1/qvgEB3YtUql7k+YB+5x69Jni8AH9+pcQ2u?=
 =?us-ascii?Q?sxPs6amuFsCArO4wgWN72nGtKQh2didbfZCgciyj0FMnUTIKpxn+WhrJIZY9?=
 =?us-ascii?Q?hN2uafv8E8zNa+kWlbQQF5vHHs4LzsmhHtn/gN8CdhrvkHSZy7qaGBoKLXCK?=
 =?us-ascii?Q?uQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ac10MGhiqySDHa33095kp8FasLvKLi2Dj17881A2xt8O5ZvM2MvGoZMxGKvtvKsvQS66pZKg/i91VX12ZVulBvnLFZMzaFqL6RnR0+Jn4VBjIgFWYt4O1m/sFwuGrbBVTfUStp+wzx6a4jKnQ29f76k8hgmwHwfxn+dlOMWS8OzZxOkrmb+ZWaRZYzY3sMzYzJMGJc4n7lFlOgo/GS96ndQPuyKeI6BE53acI7FOb8xx/tKk5OcQnZySWy3XG4NdyawGFmuyOaAgzBMLF16muoJomFu1jIwQystGCRTgX5gWZSZZdyupK5JRwypZ6gMYvjIocdyqLIbM+CcREdBdxQhjVhu8CKrB0GofEliXnOLsiWGYtNqlNvXtyKoSbFpl3BriHkcwI0hxY7BPYs8qx2bkgxaM8oU8TGrb8VQPmhFpWFWqceNASrLBGsEOt5E/cSui1UVxoQqqNvO37w2z+SReWUkZiN4MFEiDPFwoEIJKdzFoBqgDlqW96k2u9uqL/dBm+p7eRVfe+sGKd6xZSGGvZ5nVyBg1U2+r8nvInyHYwdw2vTccL/uH0c8yM3y10xiIYEuOc0Bx7pkgehWOXoSya4KYzi0xfx0ggklSoG8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5750c2a8-fab2-4063-4113-08ddeed2cefd
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 12:25:34.1779
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sWGwxNqZpbEJ+4UAeXbj9YDKxHxK1P+ilMEvD+x1SMdvVH1ZyUqDj4AuTMNjyjU6WRWkFhDi28+WeJZy48q00NsI+gV2GLV0Pb2ke3xKNgk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR10MB7673
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_04,2025-09-08_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509080124
X-Proofpoint-ORIG-GUID: YgmznCMtqbhv5Z0yqJFXbP7wAIF2jrsu
X-Authority-Analysis: v=2.4 cv=ILACChvG c=1 sm=1 tr=0 ts=68becb44 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=cfmsvUbG8TYeAjVIuM4A:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDEyNCBTYWx0ZWRfX3gj54xl72R9c
 1Z2J0Fb7AC1lcJ9ITlao5qJf78fO1Jlg2+odNQgvSB6p+FvqK+4283VeDxDbaa9O1enI48v0FVQ
 ZDcs4VTkmoLj4JcGd9lbj80i7gTE3Ynsn9Ie55Q+5Syon01JjIo419OeGQsyLVcACCuQVeUBaIH
 lurM7RbxkElHeySN/GAAvsOWrfSkLu2vFJ1YJlx31G7WO6z5DjKhZKm2QZTRm9+vBlq+XWH5Wwm
 n8sditDcdPt4EXj448RPVUqtE1vKPf3S84Aso605cuu2NATX2bwECGJQVdoYVUJUPky2Sm0GCVI
 iLFv7xBxbWWMguBB45CmtVhNmPfTasztxoZQEVctCZsglRX0M9hvKSG98IiBtMYUsmbdAb5gvuK
 bzGm+Nv+
X-Proofpoint-GUID: YgmznCMtqbhv5Z0yqJFXbP7wAIF2jrsu

On Sat, Sep 06, 2025 at 08:56:48AM +0200, David Hildenbrand wrote:
> On 06.09.25 03:05, John Hubbard wrote:
> >
> > Probably a similar sentiment as Lorenzo here...the above diffs make the code
> > *worse* to read. In fact, I recall adding record_subpages() here long ago,
> > specifically to help clarify what was going on.
>
> Well, there is a lot I dislike about record_subpages() to go back there.
> Starting with "as Willy keeps explaining, the concept of subpages do
> not exist and ending with "why do we fill out the array even on failure".

Yes

>
> :)
>
> >
> > Now it's been returned to it's original, cryptic form.
> >
>
> The code in the caller was so uncryptic that both me and Lorenzo missed
> that magical addition. :P

:'(

>
> > Just my take on it, for whatever that's worth. :)
>
> As always, appreciated.
>
> I could of course keep the simple loop in some "record_folio_pages"
> function and clean up what I dislike about record_subpages().
>
> But I much rather want the call chain to be cleaned up instead, if possible.
>
>
> Roughly, what I am thinking (limiting it to pte+pmd case) about is the following:

I cannot get the below to apply even with the original patch here applied + fix.

It looks like (in mm-new :) commit e73f43a66d5f ("mm/gup: remove dead pgmap
refcounting code") by Alastair has conflicted here, but even then I can't make
it apply, with/without your fix...!



>
>
> From d6d6d21dbf435d8030782a627175e36e6c7b2dfb Mon Sep 17 00:00:00 2001
> From: David Hildenbrand <david@redhat.com>
> Date: Sat, 6 Sep 2025 08:33:42 +0200
> Subject: [PATCH] tmp
>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  mm/gup.c | 79 ++++++++++++++++++++++++++------------------------------
>  1 file changed, 36 insertions(+), 43 deletions(-)
>
> diff --git a/mm/gup.c b/mm/gup.c
> index 22420f2069ee1..98907ead749c0 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -2845,12 +2845,11 @@ static void __maybe_unused gup_fast_undo_dev_pagemap(int *nr, int nr_start,
>   * also check pmd here to make sure pmd doesn't change (corresponds to
>   * pmdp_collapse_flush() in the THP collapse code path).
>   */
> -static int gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
> -		unsigned long end, unsigned int flags, struct page **pages,
> -		int *nr)
> +static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
> +		unsigned long end, unsigned int flags, struct page **pages)
>  {
>  	struct dev_pagemap *pgmap = NULL;
> -	int ret = 0;
> +	unsigned long nr_pages = 0;
>  	pte_t *ptep, *ptem;
>  	ptem = ptep = pte_offset_map(&pmd, addr);
> @@ -2908,24 +2907,20 @@ static int gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
>  		 * details.
>  		 */
>  		if (flags & FOLL_PIN) {
> -			ret = arch_make_folio_accessible(folio);
> -			if (ret) {
> +			if (arch_make_folio_accessible(folio)) {
>  				gup_put_folio(folio, 1, flags);
>  				goto pte_unmap;
>  			}
>  		}
>  		folio_set_referenced(folio);
> -		pages[*nr] = page;
> -		(*nr)++;
> +		pages[nr_pages++] = page;
>  	} while (ptep++, addr += PAGE_SIZE, addr != end);
> -	ret = 1;
> -
>  pte_unmap:
>  	if (pgmap)
>  		put_dev_pagemap(pgmap);
>  	pte_unmap(ptem);
> -	return ret;
> +	return nr_pages;
>  }
>  #else
> @@ -2938,21 +2933,24 @@ static int gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
>   * get_user_pages_fast_only implementation that can pin pages. Thus it's still
>   * useful to have gup_fast_pmd_leaf even if we can't operate on ptes.
>   */
> -static int gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
> -		unsigned long end, unsigned int flags, struct page **pages,
> -		int *nr)
> +static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
> +		unsigned long end, unsigned int flags, struct page **pages)
>  {
>  	return 0;
>  }
>  #endif /* CONFIG_ARCH_HAS_PTE_SPECIAL */
> -static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
> -		unsigned long end, unsigned int flags, struct page **pages,
> -		int *nr)
> +static unsigned long gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
> +		unsigned long end, unsigned int flags, struct page **pages)
>  {
> +	const unsigned long nr_pages = (end - addr) >> PAGE_SHIFT;
>  	struct page *page;
>  	struct folio *folio;
> -	int refs;
> +	unsigned long i;
> +
> +	/* See gup_fast_pte_range() */
> +	if (pmd_protnone(orig))
> +		return 0;
>  	if (!pmd_access_permitted(orig, flags & FOLL_WRITE))
>  		return 0;
> @@ -2960,33 +2958,30 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
>  	if (pmd_special(orig))
>  		return 0;
> -	refs = (end - addr) >> PAGE_SHIFT;
>  	page = pmd_page(orig) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
> -	folio = try_grab_folio_fast(page, refs, flags);
> +	folio = try_grab_folio_fast(page, nr_pages, flags);
>  	if (!folio)
>  		return 0;
>  	if (unlikely(pmd_val(orig) != pmd_val(*pmdp))) {
> -		gup_put_folio(folio, refs, flags);
> +		gup_put_folio(folio, nr_pages, flags);
>  		return 0;
>  	}
>  	if (!gup_fast_folio_allowed(folio, flags)) {
> -		gup_put_folio(folio, refs, flags);
> +		gup_put_folio(folio, nr_pages, flags);
>  		return 0;
>  	}
>  	if (!pmd_write(orig) && gup_must_unshare(NULL, flags, &folio->page)) {
> -		gup_put_folio(folio, refs, flags);
> +		gup_put_folio(folio, nr_pages, flags);
>  		return 0;
>  	}
> -	pages += *nr;
> -	*nr += refs;
> -	for (; refs; refs--)
> +	for (i = 0; i < nr_pages; i++)
>  		*(pages++) = page++;
>  	folio_set_referenced(folio);
> -	return 1;
> +	return nr_pages;
>  }
>  static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
> @@ -3033,11 +3028,11 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
>  	return 1;
>  }
> -static int gup_fast_pmd_range(pud_t *pudp, pud_t pud, unsigned long addr,
> -		unsigned long end, unsigned int flags, struct page **pages,
> -		int *nr)
> +static unsigned long gup_fast_pmd_range(pud_t *pudp, pud_t pud, unsigned long addr,
> +		unsigned long end, unsigned int flags, struct page **pages)
>  {
> -	unsigned long next;
> +	unsigned long cur_nr_pages, next;
> +	unsigned long nr_pages = 0;
>  	pmd_t *pmdp;
>  	pmdp = pmd_offset_lockless(pudp, pud, addr);
> @@ -3046,23 +3041,21 @@ static int gup_fast_pmd_range(pud_t *pudp, pud_t pud, unsigned long addr,
>  		next = pmd_addr_end(addr, end);
>  		if (!pmd_present(pmd))
> -			return 0;
> +			break;
> -		if (unlikely(pmd_leaf(pmd))) {
> -			/* See gup_fast_pte_range() */
> -			if (pmd_protnone(pmd))
> -				return 0;
> +		if (unlikely(pmd_leaf(pmd)))
> +			cur_nr_pages = gup_fast_pmd_leaf(pmd, pmdp, addr, next, flags, pages);
> +		else
> +			cur_nr_pages = gup_fast_pte_range(pmd, pmdp, addr, next, flags, pages);
> -			if (!gup_fast_pmd_leaf(pmd, pmdp, addr, next, flags,
> -				pages, nr))
> -				return 0;
> +		nr_pages += cur_nr_pages;
> +		pages += cur_nr_pages;
> -		} else if (!gup_fast_pte_range(pmd, pmdp, addr, next, flags,
> -					       pages, nr))
> -			return 0;
> +		if (nr_pages != (next - addr) >> PAGE_SIZE)
> +			break;
>  	} while (pmdp++, addr = next, addr != end);
> -	return 1;
> +	return nr_pages;
>  }
>  static int gup_fast_pud_range(p4d_t *p4dp, p4d_t p4d, unsigned long addr,

OK I guess you intentionally left the rest as a TODO :)

So I'll wait for you to post it before reviewing in-depth.

This generally LGTM as an approach, getting rid of *nr is important that's
really horrible.

> --
> 2.50.1
>
>
>
> Oh, I might even have found a bug moving away from that questionable
> "ret==1 means success" handling in gup_fast_pte_range()? Will
> have to double-check, but likely the following is the right thing to do.
>
>
>
> From 8f48b25ef93e7ef98611fd58ec89384ad5171782 Mon Sep 17 00:00:00 2001
> From: David Hildenbrand <david@redhat.com>
> Date: Sat, 6 Sep 2025 08:46:45 +0200
> Subject: [PATCH] mm/gup: fix handling of errors from
>  arch_make_folio_accessible() in follow_page_pte()
>
> In case we call arch_make_folio_accessible() and it fails, we would
> incorrectly return a value that is "!= 0" to the caller, indicating that
> we pinned all requested pages and that the caller can keep going.
>
> follow_page_pte() is not supposed to return error values, but instead
> 0 on failure and 1 on success.
>
> That is of course wrong, because the caller will just keep going pinning
> more pages. If we happen to pin a page afterwards, we're in trouble,
> because we essentially skipped some pages.
>
> Fixes: f28d43636d6f ("mm/gup/writeback: add callbacks for inaccessible pages")
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  mm/gup.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/mm/gup.c b/mm/gup.c
> index 22420f2069ee1..cff226ec0ee7d 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -2908,8 +2908,7 @@ static int gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
>  		 * details.
>  		 */
>  		if (flags & FOLL_PIN) {
> -			ret = arch_make_folio_accessible(folio);
> -			if (ret) {
> +			if (arch_make_folio_accessible(folio)) {

Oh Lord above. Lol. Yikes.

Yeah I think your fix is valid...

>  				gup_put_folio(folio, 1, flags);
>  				goto pte_unmap;
>  			}
> --
> 2.50.1
>
>
> --
> Cheers
>
> David / dhildenb
>

