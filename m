Return-Path: <io-uring+bounces-9398-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 052AEB3A22A
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 16:38:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B0C4F3BC48D
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 14:38:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2666B31354E;
	Thu, 28 Aug 2025 14:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="b2j5o+23";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="i6xeNvLr"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6882313530;
	Thu, 28 Aug 2025 14:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756391916; cv=fail; b=r4uAts+b5IfV2hzwIHcLfGNppFS2ln9v3AbLyUlvMsqyZ83Ee7givWdzMhJeb6yjdqZBsq8CLij0438HMW9P3p42GqXexvGvmhRJXxzGoW0rHI6Xs5qtL+5Lz5N4+iDIFk02dXaG0f5cWmA0RehLfCHN5saRnMMlwyYZZNmDBtQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756391916; c=relaxed/simple;
	bh=g03kjBCE1F3oZ8jhJBF25JKKzXWhzTQ5557Jyt9s2DY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Ou9F6mQiyfJETQPnHy50KIlWZGjOI0PzFTieftkDLmgI3i9blzQVYV9mEqgLDO3NQW0NWWHd0uZls5soFxpzS5q4gzRwP3n1sBtMZnyxSofXoSyCfvxcvnd3ol2q2/0slORO8bpuONB0x/0QyPQRxO2Z4P6U0Cm/Z13BIdvmBiQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=b2j5o+23; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=i6xeNvLr; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SEN3ec000406;
	Thu, 28 Aug 2025 14:37:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=b5tH1KF68LQjaOoMha
	Mize2UsFV2gZYrGIOvVBiOevM=; b=b2j5o+23N9sXcbftk32pa70wUzD14UX7zy
	Y3HQBbX6oerdjIGNHv6tZOWDfZ+bwj2EVZQNyxK8wf5V3ZaoO4LA2F7DKOT7M6k8
	/tw2zBcnzMl/5dSNEvcP3tkX/w1DkNAe92YKWsy3eab2BjpLxgnUMcfHXIjusr4c
	KBF3dqzZvrGucziiVT9RPcPiyoCj/snjATbnnTNfeUnbuR6JxAz3fghxDVDSyCaX
	c8pWIeoO2xIA3KekAF5/awKgnV+TPDp2PtlDEWe6TU48Ye7JFvGcMApPiUPF2KsR
	YXawhgL8NpY1wztJkKwrbcWNUydBpssDyf/ISaXxqfBq4p6g0EwQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48r8twfcqa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 14:37:52 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SEVXaE026713;
	Thu, 28 Aug 2025 14:37:51 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04on2045.outbound.protection.outlook.com [40.107.102.45])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43bufwx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 14:37:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a0qJ+Lg23t5waMA8DYkzTfSPnR4BRWBL0XR2Y51p7swZUDzbEUR9rkSNY2zmW0Zu3ooeWEcVHL2MLxgHh4VguXX47ulW9mgdlF9z2dYHeVqMmXWKE+FaVgR0KTVnvrr2M+TLMU77OprC6QBNiCFoWkhJEZsCqqtm/LBIoJe4Sm5NTozeCQI8BH5roJ0YU07+XvAGvxVd+1HQg7RhOqSTvFZUZOYtEPHNfxKpl/qLi1lHMZpiZI7I3nlmRz8Nnn3GLpmsOTOI+VoTAAX093KvniY9GK5y5yd//85/5HALuiLPCHnX4LhET8IWyadL7HXNdx9h6Gsy94BzVZgfLScP4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b5tH1KF68LQjaOoMhaMize2UsFV2gZYrGIOvVBiOevM=;
 b=gt46zDZzcG/zh4R05gbtofOLHONA1SFRAxeiDEeFhw1FyjZsscTgD5PIr7DnZ1XvmmOjvDkKCqffAGvwYY6BYHKjJ1I6gcCROQEWWMowVmfGuuJ0zxj9Y8aqjkvdybi6MFeBOQLVqgij4a2m7VI6EVHy3oIQol2YlJiXeQIEFW+PQ21ajZhruYCVQCqE07GJ71mUTEHMjYNjvo7wvRD/YMx3ffPfEWoZxEX+//L+zndkbbuBfIL2gG1BzYKWYGxxxdiTcdZr4lzkAbd7DzDQPSqPhzCexuVe/9y/kwJ76j9wrS9CSYeb7wxTsWhp1tPHmdmR5tGEo8FlqNsIMKvaUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b5tH1KF68LQjaOoMhaMize2UsFV2gZYrGIOvVBiOevM=;
 b=i6xeNvLrMCMP62yMNp/aEgB3Cu7hackTIle8ZWvopdHwhyFDVV7/qazZBfziP76zL9FhBHRB5YINWPUf1wHFNs2gnQe+nP9pnU/z/f6JvZ1904zlnU86AXaoiroacBE+eqgzIlTuXGn/vtA388x1Az7IWvfRNwv7AhKEDDOE2HE=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB4805.namprd10.prod.outlook.com (2603:10b6:510:3b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.13; Thu, 28 Aug
 2025 14:37:44 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 14:37:44 +0000
Date: Thu, 28 Aug 2025 15:37:35 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Zi Yan <ziy@nvidia.com>,
        SeongJae Park <sj@kernel.org>, Alexander Potapenko <glider@google.com>,
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
        wireguard@lists.zx2c4.com, x86@kernel.org
Subject: Re: [PATCH v1 06/36] mm/page_alloc: reject unreasonable
 folio/compound page sizes in alloc_contig_range_noprof()
Message-ID: <f195300e-42e2-4eaa-84c8-c37501c3339c@lucifer.local>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-7-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-7-david@redhat.com>
X-ClientProxiedBy: LO0P265CA0002.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:355::15) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB4805:EE_
X-MS-Office365-Filtering-Correlation-Id: eb9e2939-59f4-4e8c-45fa-08dde6407338
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?M7zGZc1w00WwNtxojrVZoPiF/vBUdFHsVZs1gX7G4vEVz7s9MRncG3Eo3vO/?=
 =?us-ascii?Q?sDtzyQxIbOT4Op9wCcsbRO7im1RBRWlp2BB4nTxIHluQfYokKcWjTRbZ4pHp?=
 =?us-ascii?Q?vuX/tvgUbU9zM8OXcfAJllBzSlPpLVjJle3IRkNY9aiMTAX7q3LIx8GuG3X5?=
 =?us-ascii?Q?mbeGVxfINcSKTRUvJDSVhIkSqlm1ij6LaqjcvTkMqFRXgl3GP5skgxge2D53?=
 =?us-ascii?Q?PVUT/Me7Tkz7VMN1ev3NPk8tV8OMdP8jyt0CTrxhcXLSwpMe65fkBE3B/lpJ?=
 =?us-ascii?Q?uLyO5oVnNRpNT76IXTL3wHAeQUDzynz60HVVpLOxpLKkqLzUEwDTZIAXqWTu?=
 =?us-ascii?Q?qH2+GW+Pae1YzJlh27EGJkn0HbnvfNKnjCVafbx1pUUbtgSyryV1ZowD8rf/?=
 =?us-ascii?Q?8oc05fhNq71ogpBXVYevt5daFRpI7ZarX650U5eBGSqhyRgw5mNTf3hV8yBI?=
 =?us-ascii?Q?zAhTJ7tvlbd5rBSolmpIxmh/i2MD62wxj/j6Rxz8AMkuV1BzpGODIRERV0IE?=
 =?us-ascii?Q?tGzAd9MxDxJuLPzpRoLWtVcbRWYYdFwK09LDc+7kF2OKPLzMfcdaUd3wjQh/?=
 =?us-ascii?Q?LdzeSBsccH3OSwe3m80AxgjqU9bJySoXdMWI+JtnfgWPVE20s6MuPC++URnV?=
 =?us-ascii?Q?uxNzK4v+BYUCShkiaNqGML/5lWWfM7/IqheY11HEzo62XwjF1ml1H58lEpO9?=
 =?us-ascii?Q?1SaWi/auO8y3sMIWxon6jsJZ+4hmh3LFF6BOefaEMPdQlql/x3MLmhHgSVds?=
 =?us-ascii?Q?YRO0Ch3IxwsK9tR0hNOGhsD3WZu8QMAhGlq0jjeGmlLCgxLlQPvV2qeFNxM2?=
 =?us-ascii?Q?BXMa6+l4V81T06PPO4z3tDR0Flj3zdWZVkiREpK1vgco88PUCpES/gjsXR6c?=
 =?us-ascii?Q?hSY+OMh+mCqKUttj7/BxNnNEOomw8Gx9ZM+VxkD3sSRbexSv048wrFZNgDO/?=
 =?us-ascii?Q?EcAZfT8VENlrQ9ohJGtD3M6eo66Ll5K+bjoSR+aJx0vOs8BohzrJN1DiSB16?=
 =?us-ascii?Q?MA9hI6m1DIdqxHlhsKESdkMAfTTa0u9T6Jok3mCocY2i+bfGUWdFuCXfVs/F?=
 =?us-ascii?Q?/7RdcIaAzJUlkxkqUuFei0rSkIX6M9lEZNirIfy75LZZNSJByNDfBDi74BJL?=
 =?us-ascii?Q?KRUJQKsDGiANgyR8MPu7WcgrPXo4ciKov3sdQcZq2LPT6QgVf2e1qqYaIiFC?=
 =?us-ascii?Q?2C1BIsM/B+5E1msIUej1UglhoDiZFSS5fSGOLL7kbbLb/Rf+uyICFivcY009?=
 =?us-ascii?Q?twha1eug5uI6oe2PQ+vytoKjs4ubSiiPqQmKmYUuw4ayNC55OUka/klP+pkJ?=
 =?us-ascii?Q?2R45ChtHxcIIxyexDZ+qxRPNWWqd4+mHv9vv8yNGnTjV2E50Stib3iNAKHAe?=
 =?us-ascii?Q?Ww/gWSrr+b1M2JqDcq/WLyEj2EqAJZtXoP2XxO0Ij4qpGHQbKc9b5y7wnUBW?=
 =?us-ascii?Q?WBdo62zLPDQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Akqa78VhwHUQ17KQPjFrOz7y+qII2Mkmog9vivy2SkU7BBF9nuKHaSG9M/5B?=
 =?us-ascii?Q?X1ho3QAErdGOtk0M34DnVgkly2pKJvicReXRzr3PdxCdFx8FugRoKllPkckE?=
 =?us-ascii?Q?9Bclirh6j75DsI48zu4b67Z//qsUgGy2igbxKICae70mDPTFtDUJ90G7x6tt?=
 =?us-ascii?Q?Ica/lfCD2X/VRB4B1QqXeMlrl2dTdutar30ik1kZR7DAkCN2Id1AbVUtLqdj?=
 =?us-ascii?Q?NMHdG3c29ZiwyCvXUp8bfLDAWf4B1rTyp8DosXWRZaaHaXdQ9NY6HNPYp74I?=
 =?us-ascii?Q?LZftuHaZsL69VxWFYKS1X/Ft2lv2qmV6kN1XpG+zhgAtHzHTvcMvIot/RfzP?=
 =?us-ascii?Q?yTusWszVqqMRK8W95XAPWL3Qd+i8bQT+AsB2sOKKHpxrfxfv1nCq3kMKTDkp?=
 =?us-ascii?Q?4OwJBdHJu7NIKo1I+IYZdhTrMMTFCFCIYX1czZGmESlX3MmIGnQeQS1tNBCw?=
 =?us-ascii?Q?mVuhGu7d/sDmmQKNCHcoP10NBf87nawmibR9X31M+CXJ7itFaUojTLCCYSzA?=
 =?us-ascii?Q?d6E4k7mjO0XGb8en9vgk5/omiDWlCUlC9IxE1tLaASZ46PUMKipjzr3PKC1J?=
 =?us-ascii?Q?XQijHDgqymfJq3D1KoXa7O+FGLYpRXRnnWKjvieuTti/MaiElrUwptC6Wtd5?=
 =?us-ascii?Q?9l8wIcmMXvZiaz6GL6CazNIYkrSf9zYNv8WyobU7ut/fz571M8naMtO0Pmi9?=
 =?us-ascii?Q?mSoOsmo9gNWsSbAGv5q6k8Keoug+MCUfCr+T/DuFSTLcT3YskyJ0NCvUYHAO?=
 =?us-ascii?Q?RHKP3xbXjYVDJnfj5vPFi+GcWaLjpAQ2YUzBj0bxy9h9+WPrC4tjtFJ7dIxP?=
 =?us-ascii?Q?lUxo9bLCxKTAa/GrU33XrlwSZd8sbRiQ6dNwpduiyZg8Bm0fKunjRAlS3A4T?=
 =?us-ascii?Q?zctx6vBbWDsne29FJyAyxkOqRHv8sieVahB/wcNsA+cLJeue2sl8U8XnN82j?=
 =?us-ascii?Q?DlDOdG9zehooJUnEpmTyK4w3jlSuB6Tb49rhs4H+5be9Jn77ouqK+S3NW5mE?=
 =?us-ascii?Q?OwCLp3g08UfJMAw71TwDuz9lPKG0GLJdLrrLgoz1kN+dLsjFUoigVR5LbPc6?=
 =?us-ascii?Q?hfa9kvSvrLBAh9KZ8YiHnhfkhSA/JbzOFposPp3JkGmFBLwpj0r7hkayeE66?=
 =?us-ascii?Q?z15j5WZVYVim4Fk8YBxTbGV36S6M2vDdXzu8f6PBLb9XtUrKwR0p8WBAyHAo?=
 =?us-ascii?Q?gXEq9wTG24wl/uGU/YUMLLmhTKQ9jLm7thZeNzhJtjpqagp2njuDSBx2IOBJ?=
 =?us-ascii?Q?c5eD0urm+xI90cDOuK+v72JEy+kL83BmNghi4+oqaq3rLDeBpZMOqNM2KV16?=
 =?us-ascii?Q?AYJV+fdTyJKw6tHY/Q/3FHHNUMFSJuu5CTIQmEJeHGnUaXJ+kygO7qRQB8Xl?=
 =?us-ascii?Q?y2+UKkQxV4bq7WyHeKmU9skA7ejg3zrS9HuKPWsFb033/ouCWmYBPrQFxu1a?=
 =?us-ascii?Q?5dypH/PUZUqDlgSN9lg+L3LPWK4Sq9cb/6GjNY49oQ5DpGGNRLNctovFRwuj?=
 =?us-ascii?Q?HxvTEqI2Cbw3hg7y+u2AUsRvtzwE+YMB6/84ZwI317DQZHgL6++RbnQaRLgv?=
 =?us-ascii?Q?fe+gMaeqBmFQE8mOB4bM0pjST6ggVDXGAsetc6ayRCfC9q+sgUPJZvC6anJp?=
 =?us-ascii?Q?JQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GB41Br72xk6xcT2SgiVZYaAHSIhTipPwhDktyaUU0My8xzjpyXNcpkLsasn+kf0bc7uUcjMvzTRxO6OQGs69XY/5CzWLUX4TXs1aYgiOTCqudrLbm+2PUYQ2i3NiCFs4/qvRBAI+g0zPeNTbaB5og1sbZuJYE9VWKUCLpD88U4G+/x6bahLee1G1mI0wmPD8W20TnMoN+tiNr59vroI5DdjObYKt94ZKhbq9s8ek1V187vlRo793ZynBznt21WICKHUXu6WquNq+u12rjFNPdggLwWCWxblhNApKPpRwxA2k0onZR6s+Te/XrI6Tb/QiGpBTh5Fz1IjsxNJXccCw3hxI0LBj0aujkt/QIxqTP+8+xwm6bQc1Hta40Uq/h2D+FXH1GmLGkeeBGP7/EUl9NqHdcKA3aCDt0cHdaxeimDPaKR7VoaGfT4e13ilxWqIh1igWIPbVQvALIBoQqUEISNVJ8VM0NhppgE6dzQfnUJ6WE1lsNFZBFIFQarP4XSNUv9V4i7XMbrzq4ZDRUvPuQI7AEZliWHYLyEwWYJMVeEEHjRpbu/I6cdMLCMyFMO9X7MnqdH6qIq8pafGmAdi+eWM5UK+VKXaZGGqJiN097mo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb9e2939-59f4-4e8c-45fa-08dde6407338
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 14:37:44.2450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DAxhMYM1RU26kcgJXOQLgyNf4FE65bGw1Gu3pURATNPhoOOyE5C+DMXTVHdaFQdVbxVrtDO+MqtD9akAIIzFT1kA6XqwIIE9QSxm8o0UY08=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4805
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508280122
X-Proofpoint-ORIG-GUID: wAZJjhuMqLkWt6-vx2lJZJ83hLBAGVAd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODI0MDE4NCBTYWx0ZWRfX4qtkk7sbDvE9
 gHA4uoQUCcz5YALuvEEnQlruQnzlvQDB+/rmpf4MxyWaQ5AVH30mpdBGId2AwGeNi6vpV9hYJJQ
 nyp4CDzJ5KOP8RzPb5QaiXFn1rhuugl1Zo/sR3XpPMQxOLXzLtZPFB0yMxvaMTCSEccGvjSD7Di
 gtOjXbjJghnSVvEoN+oD2Am5sdCRP4in3AU805OZIf/GpMLQfVaJbqS3ifquRIbhFsIrwlLP1ue
 sTkBuyYvL0WaYNxqBCLziXSdlp6xAGye4Zod+MuBvr70qihm+bDECB32BviQsC6qOomihPHg457
 Ol0RLAdzzELQmRCyQPtZyHCGgoH52GTHqncgItaxOW1NYU9eQL8k60x5Pi4VmraDJbLmntqZpEc
 MO/6aaKM
X-Proofpoint-GUID: wAZJjhuMqLkWt6-vx2lJZJ83hLBAGVAd
X-Authority-Analysis: v=2.4 cv=IciHWXqa c=1 sm=1 tr=0 ts=68b069c0 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=Ikd4Dj_1AAAA:8 a=VwQbUJbxAAAA:8
 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=W-idY8GWlPOdh4pKdRgA:9 a=CjuIK1q_8ugA:10

On Thu, Aug 28, 2025 at 12:01:10AM +0200, David Hildenbrand wrote:
> Let's reject them early, which in turn makes folio_alloc_gigantic() reject
> them properly.
>
> To avoid converting from order to nr_pages, let's just add MAX_FOLIO_ORDER
> and calculate MAX_FOLIO_NR_PAGES based on that.
>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Acked-by: SeongJae Park <sj@kernel.org>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Some nits, but overall LGTM so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  include/linux/mm.h | 6 ++++--
>  mm/page_alloc.c    | 5 ++++-
>  2 files changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 00c8a54127d37..77737cbf2216a 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2055,11 +2055,13 @@ static inline long folio_nr_pages(const struct folio *folio)
>
>  /* Only hugetlbfs can allocate folios larger than MAX_ORDER */
>  #ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
> -#define MAX_FOLIO_NR_PAGES	(1UL << PUD_ORDER)
> +#define MAX_FOLIO_ORDER		PUD_ORDER
>  #else
> -#define MAX_FOLIO_NR_PAGES	MAX_ORDER_NR_PAGES
> +#define MAX_FOLIO_ORDER		MAX_PAGE_ORDER
>  #endif
>
> +#define MAX_FOLIO_NR_PAGES	(1UL << MAX_FOLIO_ORDER)

BIT()?

> +
>  /*
>   * compound_nr() returns the number of pages in this potentially compound
>   * page.  compound_nr() can be called on a tail page, and is defined to
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index baead29b3e67b..426bc404b80cc 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6833,6 +6833,7 @@ static int __alloc_contig_verify_gfp_mask(gfp_t gfp_mask, gfp_t *gfp_cc_mask)
>  int alloc_contig_range_noprof(unsigned long start, unsigned long end,
>  			      acr_flags_t alloc_flags, gfp_t gfp_mask)
>  {
> +	const unsigned int order = ilog2(end - start);
>  	unsigned long outer_start, outer_end;
>  	int ret = 0;
>
> @@ -6850,6 +6851,9 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
>  					    PB_ISOLATE_MODE_CMA_ALLOC :
>  					    PB_ISOLATE_MODE_OTHER;
>
> +	if (WARN_ON_ONCE((gfp_mask & __GFP_COMP) && order > MAX_FOLIO_ORDER))
> +		return -EINVAL;

Possibly not worth it for a one off, but be nice to have this as a helper function, like:

static bool is_valid_order(gfp_t gfp_mask, unsigned int order)
{
	return !(gfp_mask & __GFP_COMP) || order <= MAX_FOLIO_ORDER;
}

Then makes this:

	if (WARN_ON_ONCE(!is_valid_order(gfp_mask, order)))
		return -EINVAL;

Kinda self-documenting!

> +
>  	gfp_mask = current_gfp_context(gfp_mask);
>  	if (__alloc_contig_verify_gfp_mask(gfp_mask, (gfp_t *)&cc.gfp_mask))
>  		return -EINVAL;
> @@ -6947,7 +6951,6 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
>  			free_contig_range(end, outer_end - end);
>  	} else if (start == outer_start && end == outer_end && is_power_of_2(end - start)) {
>  		struct page *head = pfn_to_page(start);
> -		int order = ilog2(end - start);
>
>  		check_new_pages(head, order);
>  		prep_new_page(head, order, gfp_mask, 0);
> --
> 2.50.1
>

