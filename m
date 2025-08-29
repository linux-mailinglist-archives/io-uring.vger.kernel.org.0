Return-Path: <io-uring+bounces-9442-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EAC4AB3AFC3
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 02:38:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 120CF188CF46
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 00:39:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3850D13D512;
	Fri, 29 Aug 2025 00:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YUew2NLr";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nF/ZORMv"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B09484D02;
	Fri, 29 Aug 2025 00:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756427915; cv=fail; b=YKhCc2Zz74o3r3xU4cJB2n9HZLdcxsi4bi4cwysDt5egkVD0NhkmTHOEINFZUCfwc9w60DOyZjZEo1SNjNy9korazDscgo9yLcMjHhOIAMfDqtzH1farKQLjVh1eMV1vYdCHmIwDUE+Y3Ey/tHRqLg9EncY//uWUYSrord0YP5Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756427915; c=relaxed/simple;
	bh=5kUJL/cbFNde5dyJYF8B5bmcRDd6f0qtvDIXt9ti56I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ihgbN5wv5oeIjgi20LfWlne7Skxh9Qpg0tzrpAcpcURkCcZsIzNa/CBxcQK11bsObzolePqclXfI9u4jdOI1q51HM/Xm4EhRYy3UnRYCVQoOreBYbhvgck7eO2wH1wQMyiuxDIPWCABiYqMO6JU1LH0IsdLf72YNnaT32U1UK3Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YUew2NLr; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nF/ZORMv; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SLUtqs007182;
	Fri, 29 Aug 2025 00:38:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=yue49P/XvxbXInThM5
	YEfsE0AvY8XwhcrFZs+MVOTiY=; b=YUew2NLrY/WdB8TIyoJg9icuubgulX8b51
	EiByExEDbPIbfyeOj9xnuUSWLN5WvO0oGy3DcksJp0GC889GgR7H1ff00zkrmI6i
	ZRimBcRazeiTPQx486QT9e50xwod5RjV6hd4ObRlL1dl9DTyewG6Wf9Oc1vSfoUB
	EtI7Xc/JQVB+MXZJQQFpCif+E8AGDRTS53j2y24Zh23R7wWFCaRImtql7FVMSoOp
	8wVrcC9xAJVRwM0FFTFXqZtXbKhUlW2vvTZcfrEvGjwRXZa6/Tn/pWG43UV4FDVm
	cp7/wvBlg311yh4pt07L567o3s0Woj3UmqIC5lqQdEU40/TSHCZw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q4e29qdk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 00:38:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SNGEQV027115;
	Fri, 29 Aug 2025 00:37:59 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02on2057.outbound.protection.outlook.com [40.107.212.57])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43cdx45-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 00:37:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=huD2y9z7DaWKSr8Xuxy8/8Qdv4CWIL47nHN7PCBPAbSsqO1Y8WNO8DJzRhOeeo2Alz4hYpzjEGbo6gKTcMrrIHMCotQ6oM1MC1DPafOYSu1GzaDaB4Tcg0VONy75uV44rTyzDGCXXo2TMY9p91N5XSL3QQQvGBNnIfaa6xZ0juKzo351xEPk6Gs8DaECDN5z+yZr382B0zKFey5sl0tzh24grIrO9gJ+8wq227k6oF6KOwi6/W2PYdxaylO2133/t0aDxqGDD1jUfHnfS9MwlZ4HMz0MezmSm68wEhGetUfC7VwzSCmWp4scqvkGYqydMD2xBJFCZEIxmh+Bocsvsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yue49P/XvxbXInThM5YEfsE0AvY8XwhcrFZs+MVOTiY=;
 b=VY2bni5iXKYG8qyAeq1YH35eL2tR88mjWBP7cDO+C/PBBb5WIIs+XuAA5CIiltWvyXDKKK8RjOpNUkPCzrLJlknX63sFXnKS5CBJNxsn+vNIem3ycSiS1BlNJEakuOiEFROkAsCi5JAZ3eSqvvrnnqU8WiQDLyEhkR1X93N+1aHwHVocJutdiYAIEXX/mY1DjUbJXQQvILkXBEV+rDl9o5eJPOe9GBQlWvNfZMkoE9I+ooX8tNNP6NnpAo3U/z7W+lJsG4DWQv2nd6Kuxz4cwfsx189LibraGnPEsR3h7mLszF7ZkMvBZ2dZvn/F8QYCxJisVsdZFND0ql954uB0sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yue49P/XvxbXInThM5YEfsE0AvY8XwhcrFZs+MVOTiY=;
 b=nF/ZORMv2A7ulAJEJTWRC0FmTSUtGSsg3oCeZjFLM2RY85pY+P3QE43zvdoB1CoGgHDh+DJi6TgeisalL522EZw90HxotjjPQVJu3HQ6KEAH4vJwNK9V9RMvnSb86V0aOhr9M4mLT5dB65QKx5UsLRSjnQaKkv1EDsVQ7rtl8lg=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by BN0PR10MB4839.namprd10.prod.outlook.com (2603:10b6:408:126::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.14; Fri, 29 Aug
 2025 00:37:51 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9052.019; Fri, 29 Aug 2025
 00:37:51 +0000
Date: Thu, 28 Aug 2025 20:37:45 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
        Alexander Potapenko <glider@google.com>,
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
        Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
        netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
        Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
        Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
        virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
        wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v1 09/36] mm/mm_init: make memmap_init_compound() look
 more like prep_compound_page()
Message-ID: <acgtr3jhbauka3qsov64y635rnw7elmyh5c6w3fvfvk4qnicvo@ybv7i5bzbvd2>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org, 
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>, Alexander Potapenko <glider@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Brendan Jackman <jackmanb@google.com>, 
	Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>, 
	Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, 
	iommu@lists.linux.dev, io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>, 
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, 
	John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com, kvm@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org, 
	linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Marco Elver <elver@google.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Michal Hocko <mhocko@suse.com>, 
	Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>, 
	Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>, 
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, virtualization@lists.linux.dev, 
	Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, x86@kernel.org, 
	Zi Yan <ziy@nvidia.com>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-10-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-10-david@redhat.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT1PR01CA0055.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2e::24) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|BN0PR10MB4839:EE_
X-MS-Office365-Filtering-Correlation-Id: 460836f7-c10a-458d-9cf5-08dde6944952
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CBD++BmXEQvlL/IUd0OglT7xlkt1kcKW1ezMPD3fX7mGLFUfdbkGhK0vVBpz?=
 =?us-ascii?Q?O99y3o9CtRS4uao/o4n8Tixoa86j6DcmPLjzCENJK3b0e7HkDnGq66ytLmQC?=
 =?us-ascii?Q?JZLjwPbGuRunpel9QdDzwDU8crNtT7GWArDPmRjXxaf0drM13ZKvxgFuu6Vw?=
 =?us-ascii?Q?JHAGH482iB9z6/qoriDVc4UavhojYPeZ41Q/xFWdx97zT5o3Jriy5r3qU76l?=
 =?us-ascii?Q?WgU8QN4w+kcmaR7JdyGx++R1alCIuD/596IySbhBC/JIvEUjVnudLYaNOalH?=
 =?us-ascii?Q?11O/2ynJ6CdkOeNnUKmuTa1aZwHumeULQILB+T3YGOL6UCOqjXOiUTzAg7vL?=
 =?us-ascii?Q?Jh6QEivT/rTT7qNTwyrVarQPGI73njiSDlnjUxgWhshCipf96AkbX7JitNyy?=
 =?us-ascii?Q?BMsT1+Bn/v9cnpyEDY9dIFPIU/hSrz3bSBFhwAzUla+vUMfw/dK1AoILrn9C?=
 =?us-ascii?Q?9zBq0pUxQEURL21JqMDQek5KZaCsLt8xO5UQXSebLHJ6xTgJaFYM00LJUDcT?=
 =?us-ascii?Q?HcIrJVlx8TWGl1mG7pLfvwyN6C4rPWIb9lVqFw2NV7Dk1O0x7iQK0TekAGP4?=
 =?us-ascii?Q?sdNnFEg659PUOCjoAc1hoi/91cdtFn4lMdUKmU6UuD17NgEoVHvT6jdMVvrG?=
 =?us-ascii?Q?mxK0UeRkrgds1oxfz8AWx/xVgWHEbesNuKsvqqHGpOdRIPo4wdfItLYHh9DY?=
 =?us-ascii?Q?K/du0c0MUumGB94q6V4rd1ZgDN2OFZz3cMossvPwgcvXgw5UqDN8jdf1hbXr?=
 =?us-ascii?Q?+Wy7Du5gtbtivWkqE2lVnx/vD98n1sJY8NzYRVhWumI+uHqxXIyQ6eMX3rRY?=
 =?us-ascii?Q?mOS8LwD7mLaAjGWyfOVrKTaTB2VknRkkeR6eZv1r6/hBSPKuzGuh79U5J3UX?=
 =?us-ascii?Q?uZRCFkZYgeqzHNWPLEzb0ZefSNkxbwFKx0dobzpvuxMgN5DPfrxNwsD4A8op?=
 =?us-ascii?Q?uAJU1yx15QzUg9MK+PYkt8x03A4KDmO4GY0iemNzvvXYmBs9/kN22gtuWjhq?=
 =?us-ascii?Q?rAYSldvdAwjGDHMuxGf+1aGFcZCu8GkXhzas6ubbo90hEtz8JnwUqhlzF2kV?=
 =?us-ascii?Q?Bg2KiRA2QfgwkI6YdJl8fY4XCByWv0cVg7K2KVXYdKU0pwCxQ5jxYtGJLch2?=
 =?us-ascii?Q?MhXYYAzPnEkrhOadg277DvbH4wIb1Mx9rKbF2DZm5JLSBLg52OdNVFq1gJom?=
 =?us-ascii?Q?48gmK4OIuXJKWvUq+VEgqzzuV5ayE88yU2Jnn1kzHU9UnZOq6iH+BqOm7qPd?=
 =?us-ascii?Q?l9dVBENWgwHhbnW5DBALOtR2G+xdpiuZPPX6AtKopVKdnP08AZLLyNIJNbDd?=
 =?us-ascii?Q?joCh5fZpqezvAn5s7f6LBqWUMIrmN8uP4Ov4wJrxRN/cTMROwmsGZ1TcdeyH?=
 =?us-ascii?Q?0g4TkLL/P4JvsP03t8xbqV00czEIDk0oXB5MPVm/ri7zLq5cC3eZYGDkmw9q?=
 =?us-ascii?Q?hK528B8yCaI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sQZ/zVgM5eg5pdJFlcdSj2aM0oH+CV62brZfds4TRUq7HbpPGWvvKqwUkSp3?=
 =?us-ascii?Q?3GYxHFmCd+oJvjuFww7B1J8id2+OoYxzChA9S94Sbarjy8Jn/q5l5sBS8EMO?=
 =?us-ascii?Q?KsyV6e1Riee9wl2WTZHQ6RPSXzlW8GoAAt33e8/PkySvUcjeaGKS5NxOLin8?=
 =?us-ascii?Q?IRsFnCCx5wbhf8HZfb2mxFUYM+2Gjao6Juz2hVbyrslIJqHMm51v81eCYHmR?=
 =?us-ascii?Q?b4fwaGSv17SVjbPB4r2B2nlBgBLKM+CtoKYkBRKsPXUWvb5iGWzN192ME3cA?=
 =?us-ascii?Q?VgpoqNIymj3/F+BWZJP0yRE4d5DNH82WtDdNcT/L2yVqC2bNBOAPu/ftAUOE?=
 =?us-ascii?Q?kfY0E2QfUd9YqdjQkDSnGqrws7oajUe1sS7C/hLxXASnsbs2k8EWhEGSIe1A?=
 =?us-ascii?Q?2sw/Q1qXpFuTdULgUehp31frAeO0SIsNlxqtemJHCiVp9v6cz9LLhRv0K5aH?=
 =?us-ascii?Q?tzZVc+gBS42M3HjVz4BAmgNc6CJlWK8rHYVAKt9ogJ4/OZR1dD7ZzttR2gXq?=
 =?us-ascii?Q?PKchMzCuh2WD736TIgsg6LN4xVhjV9iYOFaE7m2WZoEeaaemVwVIm3wWmmHW?=
 =?us-ascii?Q?0su0a/XPVGszw4akryRwKZWdNAl1i91r3x9nPFlmBCyJTnSbwsEXFnPwJCGq?=
 =?us-ascii?Q?4PIE/NjgX9yyPhEkFr/Fku/b5Z1G/vRul0Ex6eN/vhfL/yIlTgoUIVmBosxu?=
 =?us-ascii?Q?5JuvLy/nWIE+HZv3mYYLZLbi+UpSdDAG1Kry4yb8HPhKlZZQ5B+drklQ1wAI?=
 =?us-ascii?Q?cbVMWh/KKR1UWeflWDl5zzcO2y863fn2kt5pT6EebZ8TtLsuRZr0DdfLFb1Q?=
 =?us-ascii?Q?QDL0S+/jKIPHHgeq2SrGAfrb2fbXAf+MN7Mr9Nv6hhNCiQt/WTAqdu0rzEIF?=
 =?us-ascii?Q?qpo9ok9/dX86YVnzXfhCqj+rqiCHRrqKSRGQtQYt8m7o5oKv8i3PwB7x9hQ2?=
 =?us-ascii?Q?MJwczy68SgVBoVpl5UnZt3zB1M6n5d5iy/Zv2ohR8c7mPV/uZkVfyaNg9RVY?=
 =?us-ascii?Q?gAA+RwAM/SQfCeRVTTRci52x9pyoFjUZJRBRrWplWz6L8V4RQ9h8hsjv4OGY?=
 =?us-ascii?Q?OUySdHs4xW0TB47SNH3/HEknlXU61OHWc6oYtDyXOqjqeclL7jXZV8fjzM0b?=
 =?us-ascii?Q?h983k6mRxJ3hFdWT7rQBbII7E10rb1V6pylDTW32UUssFyAqMN2snI6ROcLd?=
 =?us-ascii?Q?8bU3KokKNbvOmE8E2xa/Almo2uNV1EhTmzHcBXWnQ1aVpsllCi/MCTrqUUUC?=
 =?us-ascii?Q?2HYJhrdd1jH7Tgd2Fh6V6ucUV4gUdXLo1Atc73Z38AnCST6FGm1MErTwSxhl?=
 =?us-ascii?Q?evdqfYmbwPlxi7BJuc400f6/o/NID+ZCDcSTSEFXmbg/neitFS3DIenOovEz?=
 =?us-ascii?Q?9aCg7vySF88g64P4rI2wDSy3MyJEw+z/kDz8TwRs+Kyj6cv7SeHxcwj5u/jI?=
 =?us-ascii?Q?AB7aNjg+RFyGG7leW5illPJjJpwFkhoffHXERhrCWcCHXoQHJFlK+CfDoNLj?=
 =?us-ascii?Q?b2LpnEZYFZi81x3n9z8baO9qFG4AZqAc6aaGIwI3EmSnrY0L24K2NbarK5pI?=
 =?us-ascii?Q?bwK1eyxzVtCUgTVPFdbo1ek4skItjTxNpPOvPBMh0XW+buvE3bpSe0LNpXEm?=
 =?us-ascii?Q?YQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HVeqQqE4Wkz5qjN3a9nuGTfBJPCJNLJDNEGYqRvFDNI4UZWAd3HaA12X4NV444updt+sC0lPTkgGaaYZVNJtqfSEXogBmJK9La40WQfBInNiZ2oYYtNH37PkY7WcTiKWRh5f9109APpxglPefUC7OZa6NFLnYLIF53QoTci46vltTRPBS0MIKQfg6mu16eS4r2x6dB/d0bdNFGZwB2s8HSgUvTwPsXs7s9vA1b8fgRo5Ca+15G9MAbr/dag3zFlzKkWdCAeaQ2SE+uL0G/c5P7PoiiOjgXs085UXRxqKW/pddhpXt11mel03g6a82ccY944+J6x69ILIrSXycq7LV/vyV+fEFfGm85Ww5axj5dGM2q/u97jVuzA6nOxbPWs2MwhotdpRlgEOWTxNmplxh068C53fVd/6xJPJuuHz0/FfnIxRoPTNxT7Ibln6/eTKrt6Pv/+IRxB7WrvCo63bfvY8EyBpENLjIz8n7NW2TMz+N2c+7b9wDE/6oRjZ0Pr6b/KtbhfTIK2MIZs0FxzRJuWE7LKXm8RStWWhscfe4i7rnhMAfe6GCCAdmoLkeZHs9SCFmwBfymIH76z9kgOgkESM8NrGHp5PPLYnDJ461ho=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 460836f7-c10a-458d-9cf5-08dde6944952
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 00:37:51.7843
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FySL3u6VjR3enSPljaYFmNkyrDATT9sh0UA7RBoa6oFvNoTpnjxz8HyoGYDiMbZaSC3pKt4fO/NQWDnQewBAHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4839
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508290003
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxNyBTYWx0ZWRfX6vSdGrztdTdf
 +HlzHU3b4AkyWhG+OOtpl3iwwmYNmLAfuh5pBF3fZbHws/hmVvGWyKLqZHEQft3LzqUonEdmzbM
 trfi48V3QtbNftwdi7uqKVESJb3IIaCcdTWABKSHCHxA1Kqg9LMDt9UZ9E3rI3J2FvldTRAId9X
 2k3YQQ24yy3bBkbrjTPtzIRKsfz79NXMrJKtFqHSq6omcZ3E1Ydp/uyisy/TyOPKK7BXD3kcKOS
 RmxXHq8B1c3poDuL6LsTvoEa0U0z4deQC1kon74/73pSA2C6HHufSbndL4CEquexvcUjMkj7ucb
 Z7mtjLY/fFIgyxgfR8Uk4nfrgEVFHWeLHoy+XzoME6p6EO3SmD/+MFeZjK56VgHnFLP7b1nNm4q
 QhGp7+u+
X-Proofpoint-ORIG-GUID: nNCPq1jAYO_y1o6SCMdGl3sW9Ap6CGoH
X-Proofpoint-GUID: nNCPq1jAYO_y1o6SCMdGl3sW9Ap6CGoH
X-Authority-Analysis: v=2.4 cv=IauHWXqa c=1 sm=1 tr=0 ts=68b0f668 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=Mn4A5jqT4tQqSS8XF3wA:9 a=CjuIK1q_8ugA:10

* David Hildenbrand <david@redhat.com> [250827 18:05]:
> Grepping for "prep_compound_page" leaves on clueless how devdax gets its
> compound pages initialized.
> 
> Let's add a comment that might help finding this open-coded
> prep_compound_page() initialization more easily.

Thanks for the comment here.

> 
> Further, let's be less smart about the ordering of initialization and just
> perform the prep_compound_head() call after all tail pages were
> initialized: just like prep_compound_page() does.
> 
> No need for a comment to describe the initialization order: again,
> just like prep_compound_page().
> 
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: David Hildenbrand <david@redhat.com>


Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  mm/mm_init.c | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 5c21b3af216b2..df614556741a4 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1091,6 +1091,12 @@ static void __ref memmap_init_compound(struct page *head,
>  	unsigned long pfn, end_pfn = head_pfn + nr_pages;
>  	unsigned int order = pgmap->vmemmap_shift;
>  
> +	/*
> +	 * We have to initialize the pages, including setting up page links.
> +	 * prep_compound_page() does not take care of that, so instead we
> +	 * open-code prep_compound_page() so we can take care of initializing
> +	 * the pages in the same go.
> +	 */
>  	__SetPageHead(head);
>  	for (pfn = head_pfn + 1; pfn < end_pfn; pfn++) {
>  		struct page *page = pfn_to_page(pfn);
> @@ -1098,15 +1104,8 @@ static void __ref memmap_init_compound(struct page *head,
>  		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
>  		prep_compound_tail(head, pfn - head_pfn);
>  		set_page_count(page, 0);
> -
> -		/*
> -		 * The first tail page stores important compound page info.
> -		 * Call prep_compound_head() after the first tail page has
> -		 * been initialized, to not have the data overwritten.
> -		 */
> -		if (pfn == head_pfn + 1)
> -			prep_compound_head(head, order);
>  	}
> +	prep_compound_head(head, order);
>  }
>  
>  void __ref memmap_init_zone_device(struct zone *zone,
> -- 
> 2.50.1
> 

