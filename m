Return-Path: <io-uring+bounces-9419-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 69C35B3A924
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 19:58:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 26112A04450
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 17:58:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32DDB340DA0;
	Thu, 28 Aug 2025 17:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fF3JHBLp";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="KCjkhwdK"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FBD4326D53;
	Thu, 28 Aug 2025 17:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756403913; cv=fail; b=f9XI9U2284XMCi6RGaoln0HYJBryc7Jn3XYy0x/uNl6IjbX1ETZg6nZdLJKS5wo+RMZTgy2eRO4QqZdjOh0ExhIkjGaX+pjOK4Cuhcf27xCuqd9WOUX2LGh6V2bw8TZzs/+ORTbejyA5dEpDMnd2J/nBXk79HVYnBA+IuAvBCMo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756403913; c=relaxed/simple;
	bh=YHZjSGF46WTDO4AHodFISJI623nNF+Y7ln04X2LyuCA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SSjSGFFENxQPo8MetQylQPEr7RhLe02EVneVcVC2fbjpNjqtW4/fgXa0DSHr1MLH8IUta3jSbuh6m4vjtmpM+2hqDKjfSDVA44TIOv74CRR59ZsG/XZNE69xCkbllE+JooLbuMbHbGAyRH8maxgS1G1vcBAt6i0TrHcbnnilnb0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fF3JHBLp; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=KCjkhwdK; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SHMqSp006543;
	Thu, 28 Aug 2025 17:57:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=9cZrz3QvCmIxE0hfAp
	tkXfPVqLUI6aLgQLEHim68YPY=; b=fF3JHBLpWk4aLCQIRs3Gkjwu1wXwoEK+Ax
	7bffsDvPgF5j4oDcfqBWMjWTG4kEJRmm3AcWZmuaKXStwKBpO1k28ziZREBg4TCO
	OhhBaqg2UHX6FQjl72IMXlgkTUw3rzgMq8mj+CX88Rx1LgM5yyWPMzgyFkWPDNi5
	FpkkaupzVBsHpY+Q8BMDhopa9TIoPj2oU5YHIBj91d0C/EU6+ZhI9T4aHNfuH5Iq
	dTGtDIjr5XP+Nl7YLfXC/PfJ6L7kCDBR/jirWAJH4m0Ozye6L4ft2AMWP8dwlcgS
	SiYqNvY42kOYcAtBrYZn4DLIgpOYPiYvRp8a9BXWChhKUT+F2btg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q42t8xgk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 17:57:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SHHdQQ014629;
	Thu, 28 Aug 2025 17:57:55 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02on2077.outbound.protection.outlook.com [40.107.95.77])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48q43c71av-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 17:57:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yQlvnE9y2Tpj6h2H/uz85ZgHvkN3OeF2hKR7WdcOYdzzyO2x23C5ogmTsvfoSB/A0Amqg7KITbKJgu4/GoJr+Adw2rNdO+NElkDB7zeQHNeZcg3UUYNTuUvY13i2dIMhrYHuChm2wNSZpARYQt/itXGedSITDa2lq9iKijol/YJsv2q1i2jtRFGwdyyAku9qE1Jrpa1XoFJ2LePgvOuKy5szOH1RyQreW1SoJTXB/uJEW8k6ZXXvIFJIiHH//0svIlTU2qxbTwHZ7JGQSEkP6h2SAwtWmkLbfOzhO3OLikP9yc7RKTQgdLN3jdks5takjp/dZHZEYPKnUwYP034q1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9cZrz3QvCmIxE0hfAptkXfPVqLUI6aLgQLEHim68YPY=;
 b=TJAp0z+onAKoHgwyZ33EqwOYW4r9/L+0+vy6c8lLFtz9lX5fKRIMrPWQR5w7cU6M5v1Ro+JxXoaAGLjXIUQa3BE1nhroEcQAcRHZZLKKHzH06Qs/U5de6iK/YKHdBWckmKzUiqyt/a+bcX/DzvNOFAUtmKXU7rz/BhtcxCIMR5qKrPZV1I0eD0GdFHbMGhhdm94WX2R2kOCEVw/FV6j+QQtlbghkFtWvnJGvtNbFSi4TzeezoqVBrucxilabHwZ/XVI6VT+tI4xoht/qZKhnHEQE+5OMqNX5VB++WkRYtONW+YjLlLIvLlhDZsVfIDjTUL+zXn9huhePyGwhuXZ7WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9cZrz3QvCmIxE0hfAptkXfPVqLUI6aLgQLEHim68YPY=;
 b=KCjkhwdKt1HUJso/tmYu4XWDkBEcUo45DOlSmn4KO9ui3HMjgZ/lYcM+VwLFbFbFHnqY4qA6vkts1tMi5AjC3CCwyHYJjduKM8qylGPgzLeewhteqvpaxlh9Lp/s9e6clScoB+A83lcP8almKeYaygvhvePNycXVWOViFs22Dso=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ0PR10MB4573.namprd10.prod.outlook.com (2603:10b6:a03:2ac::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.19; Thu, 28 Aug
 2025 17:57:46 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 17:57:46 +0000
Date: Thu, 28 Aug 2025 18:57:37 +0100
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
Subject: Re: [PATCH v1 27/36] memstick: drop nth_page() usage within SG entry
Message-ID: <b86e6769-18e1-4bb5-b9b3-cd11a72e3f2e@lucifer.local>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-28-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-28-david@redhat.com>
X-ClientProxiedBy: LO2P123CA0045.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600::33)
 To DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ0PR10MB4573:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d6536ce-176c-4285-81d7-08dde65c650c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WaM5wlBTDp+s7i+OTEIyAvluZZo9SB443jpRt+pUW7wc4usiRya4Yfa+IhtI?=
 =?us-ascii?Q?1kyS1m4Ikte7GjuWPGZZXojWNIpdAOdRFRuG6atXDuNfVQrZvpnSPlhT7XSG?=
 =?us-ascii?Q?2Lm8Zjys6Q7Iu1vaQx7rgdeeSO90bikvoo5qES67J5WvCvdY/HLRKxqHXH54?=
 =?us-ascii?Q?yKNMJR/gptu0J/zZL7dsjLYrw3NpFJ5zAEGda0hMbEZbBpqoYDGe/OzZ6sm8?=
 =?us-ascii?Q?NTmrkPGQb8OxID2kbhypRSTrhhI4GhKNtU9L2Cx57iSf2OPJ6Uh/LAsz/cEA?=
 =?us-ascii?Q?r0+JBgie9hikO4KHpxSwzlli9p/sGnxJva4+VWX/JiTqvQzWOIbQ5abWTJ+6?=
 =?us-ascii?Q?P0p2VST0tjm/lKlCvyVAQ7QG0Hh+eSuDt9ZR7pVHSruwserxDDcKjM7ThJDL?=
 =?us-ascii?Q?9ta0+FoRyANBZcuwO73yVBYqm07Anfo6Qgbshshz347H0f3/gprskZfg8fkR?=
 =?us-ascii?Q?WEgrivfgXO6ku9EwKrI4KQeU2Z88UgwfeSaGQCgusLqWxK0lOH4A2XnzXJ/z?=
 =?us-ascii?Q?LhxtRAhLVKZYAE1o30UEXAUedhcvW0ldehJC4d7DH00Gb/epPMPV8VT8irs0?=
 =?us-ascii?Q?/EwI/DqiIiDE5LNQvPSi4qHXJmb9wNcX70KKS4om+u9jvsVUWNjnIzqjhdBY?=
 =?us-ascii?Q?SnCFZASnJsa4My4f7/B/I1NULcexrf7WBOxmtZV0FH+YV3hpg+choDpqpqas?=
 =?us-ascii?Q?++Q7Lt1j4rDVtIiel8XRpDLTtGOHwi4xEfPgxvkl1+KdETusD8Hk0n3Charo?=
 =?us-ascii?Q?ZkPxxIw3qQJYF8ketP0yiZTWJrgyoq51m4myJx8mgB1q+4NLJ0uQuML/ELfA?=
 =?us-ascii?Q?2VI9KpmQoIT51Wr4+2pKWG32IbCze8OAN4a914AMY92g/xo8mywLktu5sSPV?=
 =?us-ascii?Q?nz1x+ZoGFOx3rorEoVYFGZJFFz5mg6NLMSXiyj22fv6x/+mwNcX/FPATntUT?=
 =?us-ascii?Q?t2F8jj8jyt+qj/BIOmPSCyCCDCBkZtS/P2Pli/KDTpGgvd2VgJFN7kmOBLgC?=
 =?us-ascii?Q?QFW34Mi6O+3BuXJE2Aa1m4ZyLKtzhGXrOsvkM2LvEwlsTG58eJZv9juhVIkP?=
 =?us-ascii?Q?XnyMmNSM5BWjNRCe2UTMv8K+fIlIHFCgB+x6sGtu/JfYMhMkh+5X7TbltrYT?=
 =?us-ascii?Q?sz2r+zz8NQR8yrrDYL41Jwdfw9cDTk61+SBsAEj1pvbEw8jvPvD3lZZAp5Bf?=
 =?us-ascii?Q?KrYDuFgiZXggUi6NqfJA7LyytY3ArkGu2qocs9XKVmVuMewG6tFMfNUQDV1W?=
 =?us-ascii?Q?pCc07ypN/sJKBtVuZwYy/R/CFKwELu+V4kb9RMReGq2oCPKeJUBq6c6jyiJF?=
 =?us-ascii?Q?Qxr95D3m0h6ctFdRq0VC+GygLE9XjRWFVvLt37q2fFFl0FmQZguXVhhU6MyA?=
 =?us-ascii?Q?d9+5bu9s0foGkW03D+N8tFxka23eAl1EbMmsd7Mafz0Q0DMMUJOc4s649Vdu?=
 =?us-ascii?Q?VyFf7VdXzjs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pdamH6iUfxgFH1js9efUYp61jt150pJKqjVi//S9E87hPTRpJv/sOP8Sgzlw?=
 =?us-ascii?Q?MK1AYbxFBsEdvEouHjqEBJWeHxZdjCDULAYPLbpYBnv9rxVsxMTagaJhcdfa?=
 =?us-ascii?Q?6UQPpmWyOnN/EHvb2GJPHd6L2Bdr6YL1lKmozaNNgB2isCh8xbFzVktR4+nQ?=
 =?us-ascii?Q?dnYCQWjL/IBiaE7+CrUXxcXE7x/oSfDnOq5W7qzUjvmD5v8tMCcTRXVEBk96?=
 =?us-ascii?Q?/KDL+yrIlgzaDP1YdRZ+SaratSIncEPtJ27OO2OBmmlBCunsNFXUlS2uJuLD?=
 =?us-ascii?Q?62SkJhw4E9f8IVpcIlAzKBWV1xlnfsDijAf0UYW1RrUATQO7DACOhZt9VOXd?=
 =?us-ascii?Q?L1tIYs+vU9B2236Vjvh4ehNj7QiL9yAB+HSYyOEp1qQDK3kYtgFbWlETiGIi?=
 =?us-ascii?Q?MXRepf4B9c+aBkNnS8pQB9fsCSm85ezqUr41Enj1ZP5efdnOlUnyTvpV8At7?=
 =?us-ascii?Q?XiqNpCWWGJt6Ud7Mp6eQvQ3iOy2+aHcAV7WzVeYoyRsZgxpeWD6Wzp9rIB1w?=
 =?us-ascii?Q?/Vb5+kDAcq5/HnSlOQjdTN866KlBAQuz+Mpsr55HfKPfO7/Tj+d8IdkvWZ7F?=
 =?us-ascii?Q?LWBqG5p3yAXjw58BAwSMK+84JcitjYZy9FVx+tfQtxj5ePAJ8NSphMltvNmU?=
 =?us-ascii?Q?ECWaerH63C4la39sZ3l8GYV18Rr88Vw1GnR8jIGvRvohpvILRH8ZCBN3bwIg?=
 =?us-ascii?Q?1sKFIMNVEwcgXWRS+jBnYpVFVi4ve01MArYX7EGl4JVCjRN2nTdZ5T/ffRtq?=
 =?us-ascii?Q?ZHTFbC7XHRTFiOiZHBSlDSfxboPJLaOmYWtJeDuFhXw0sx72XKxKd6e45SLd?=
 =?us-ascii?Q?zxIgMNnspZiyDdZw5XoH96R+dV32lzi1FYtgCvwK4BhAA4Jh9pIWbdqHYwyi?=
 =?us-ascii?Q?HBwn8Ly+wVoO82gtlS+e9ltSLH8wz1h/vn2aDyhz14melp2eoLSYjqbPLhzc?=
 =?us-ascii?Q?LU9HRGjmTyx/LnMqFF9qGN+MyZdaRIR/gRXWhI99D/vdQXeB/pYw88EgQt6J?=
 =?us-ascii?Q?8GM/Bktft54InqQo4A/TqjTZtvxNWC+IYKqisNEAkB3RhmKBgodCUA0/7ia0?=
 =?us-ascii?Q?0r9rBbRlrRiGHOXQWd16Rk6J3n2Nh8Fwre+d4vJ+PzqWcGgBnGfgiGGeQ7m+?=
 =?us-ascii?Q?hQY7FGm5HWZG/Y/zr5judAwfe6dZH2haOmUC7q3YiCtU3g9zEX3MVXxKC0bE?=
 =?us-ascii?Q?rSy2Iy/5k5YttoxchzuyWv6rz8y/vCra3/wnrffjc9zPgRY6Pa15TK9TrxQv?=
 =?us-ascii?Q?pDmMfBqZHFcn4/VuVNlzkgRi2QUx74bzx7qcoDt3T+/4T0IuIbkTjudxBr8O?=
 =?us-ascii?Q?xtTPYgwFA6v4ywWUUVkuJQg/CvOJmvakUH4WcZj1owF1ksKvO4rPTQbLgMv/?=
 =?us-ascii?Q?u7oLUTzjQewRvsA3F5KmnrVweXpvBI4bzvjWn2lmX4KxJBnZmiQoCv5Tf6gd?=
 =?us-ascii?Q?0Lliw4Uu9lWNzkeru2Jc9Wl/QAJuUoTdE6+ys4ud7E1JxZ50Qpx405NIWsvM?=
 =?us-ascii?Q?nbgve01qwlsLNxQUvVhXGXQBHnP7Ak+VMqrnb3Do7jShVt5CVemPH/VChjFE?=
 =?us-ascii?Q?VuYh6Yu/ElehWaXfTwq3h5HhVyXvA8aa7kQrpbf902+bdqc8M0srK6QmeOs9?=
 =?us-ascii?Q?iQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VR2OgddmozllL5PJlKtaBAC5z4YoP4pB7dFj3tCKTgOZqZzSXkrhSOCcE8iFWeC38O8FlDjv0THF00TdhRlmd5CL6h9TC9mL5Zc9jfUMlP/Wjqs54rzGvhx5GpWbbtrb+QsKVuC7kG0vBHwxppHfw9W9tlpXXHt/v8r0USK/4Bh4Ez2hPR8/VIWxjubjWAVAQuXM61nwJfUA6N3k2ZQRZbd8HVYcylLPcZXoumZhx/xIF8L8UHtTa7Y0PiKSrkmcz6ofDFekKHr26X97uCVXaZ/SxFxh18M3QIl/gkX26UcITVohWyObbrdLdSOl+MMD3AVTzV3VFLtT5SgYpeNiLAAW6Hhwihv7c7N7HpC4mlZHcEn5WrwGdyOL2+f3yisDHhhxfqZ3sb6kDN4IhzobgFY0c5H1Sp/TN7z/VNI0vnTZ863WgcE1pISUW0u+5kp7L4SCFG2OBjaKv4mpFhRbKXMn6ZWiUcHwRsJnfH6XUQCj1NgQORHp+fXQICF38OuuIZSG33U/eOktuQFISheqWHU06lfwmBFojYCKa/eKZRHvTo9vT8QFCkmPGc6sCwpsebKMKbusLx7Fy5WG1mp0vaMZp3slpp5l/bNsbE7I+KY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d6536ce-176c-4285-81d7-08dde65c650c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 17:57:46.3867
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oyzNSG/kmQUyXNkZKL5BaNMcb+lmS4t4goSzlQYYCaRArqJ81mXV7LQUwgXO4NjE09Oce7JTTTwwBNyTb05hXeWb8e4Xxr1zbwdO+qluaAM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4573
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508280150
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxMyBTYWx0ZWRfXzi7lE6e6xBEr
 14BPdHueeigaJzvE9Eg62I+AHaMPJCgNCwASbwbXMQhyl2QIykh4c3n2yciZKUntj0U02d8KrcR
 1AnhweCS4m4XA6SRTm3CiGQPwr4njGZyS5dwjlXRhGerYAeCFT2LCMnEp015kuw6GpQdV1p7BdX
 Ndgi6M8/dw9GeA/YslFXQAU4yDsNckgp0yHZHzn8qJiAoZtX9H3o5QIz388enXcut40A7TCdi/o
 payKNAn921fxj95qYX1pBC7ncIRSwb96snSncYNkLHUIRl4SveRwLdKl3pUxv5OF7IVbSaFPjQe
 7Tb1tlnBoWoeZS2lW+4gpxBpbWdXNlqfRtPuUrw34dsLIFBvQpykAbR5mDIFUtYe5hvvvsN1to4
 97sYA+kYKinGjhE+quf7npz/uMH/4w==
X-Proofpoint-ORIG-GUID: 49VPKPdu7WFsfaTDL8lydvjguw7SHGas
X-Authority-Analysis: v=2.4 cv=RqfFLDmK c=1 sm=1 tr=0 ts=68b098a3 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=KKAkSRfTAAAA:8 a=pGLkceISAAAA:8
 a=CjxXgO3LAAAA:8 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=0XKWupS24O7JAqhbPLcA:9
 a=CjuIK1q_8ugA:10 a=cvBusfyB2V15izCimMoJ:22 cc=ntf awl=host:13602
X-Proofpoint-GUID: 49VPKPdu7WFsfaTDL8lydvjguw7SHGas

On Thu, Aug 28, 2025 at 12:01:31AM +0200, David Hildenbrand wrote:
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
>  drivers/memstick/host/jmb38x_ms.c | 3 +--
>  drivers/memstick/host/tifm_ms.c   | 3 +--
>  2 files changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/memstick/host/jmb38x_ms.c b/drivers/memstick/host/jmb38x_ms.c
> index cddddb3a5a27f..79e66e30417c1 100644
> --- a/drivers/memstick/host/jmb38x_ms.c
> +++ b/drivers/memstick/host/jmb38x_ms.c
> @@ -317,8 +317,7 @@ static int jmb38x_ms_transfer_data(struct jmb38x_ms_host *host)
>  		unsigned int p_off;
>
>  		if (host->req->long_data) {
> -			pg = nth_page(sg_page(&host->req->sg),
> -				      off >> PAGE_SHIFT);
> +			pg = sg_page(&host->req->sg) + (off >> PAGE_SHIFT);
>  			p_off = offset_in_page(off);
>  			p_cnt = PAGE_SIZE - p_off;
>  			p_cnt = min(p_cnt, length);
> diff --git a/drivers/memstick/host/tifm_ms.c b/drivers/memstick/host/tifm_ms.c
> index db7f3a088fb09..0b6a90661eee5 100644
> --- a/drivers/memstick/host/tifm_ms.c
> +++ b/drivers/memstick/host/tifm_ms.c
> @@ -201,8 +201,7 @@ static unsigned int tifm_ms_transfer_data(struct tifm_ms *host)
>  		unsigned int p_off;
>
>  		if (host->req->long_data) {
> -			pg = nth_page(sg_page(&host->req->sg),
> -				      off >> PAGE_SHIFT);
> +			pg = sg_page(&host->req->sg) + (off >> PAGE_SHIFT);
>  			p_off = offset_in_page(off);
>  			p_cnt = PAGE_SIZE - p_off;
>  			p_cnt = min(p_cnt, length);
> --
> 2.50.1
>

