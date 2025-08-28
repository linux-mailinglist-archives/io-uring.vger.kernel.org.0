Return-Path: <io-uring+bounces-9399-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D2E1CB3A281
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 16:47:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 61E0F16BAF0
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 14:42:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 977A73176E4;
	Thu, 28 Aug 2025 14:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gBawt2+O";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="n9J/4jUl"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9664A315793;
	Thu, 28 Aug 2025 14:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756392042; cv=fail; b=Ipmu1fhChKv8eEAl8myQQXFNTRc3vkpa++K7devGYDQiS4aTyfw+8t452uh+K/roPGMW67HSQ2IBYA/VzFK4YP4qkvv8hzv2PH7K1kuQg8s0ODY1BeWcDfvzRyVfWAYWMXjtx2dw9Vfedmr3ED0pQFS6TAYpLGCgLDQu59jNVDY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756392042; c=relaxed/simple;
	bh=HI6yfxvQjY3D+ERlDp5ETEDt1J3t8cTgpetwoWt/+qg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=p98bCNFZ+I8vFVFCmt03T15xagqfjypp5fNFwp0FpeHAhowZWDBtbL8NLY2Fl2pkvTfdgSHFn5TgldoWD53T4WzFlreJxox+VMJ/uIET4A3i7JOgO7LAhdoizYxsUb0dmtQ8ccuPuNpdtAdQ3D6XY9nlsNq4fFRbleipjGxc8Bk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gBawt2+O; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=n9J/4jUl; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SEN2DY031230;
	Thu, 28 Aug 2025 14:40:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=N50lplQalaYtUkq42o
	AcoUX/HtYIfKFyHE/EIvZtsDM=; b=gBawt2+OZgq1Cm+HDHcoHbCJNTZo4d8LJL
	LDuIIvOb1CI6xkOck8XseQlfRQhxEjbS30T63odGnhZTAjxr0D+wQb8ySkqbhFyx
	SICCjo1VwhDuJpQpQqt8hvcJnp+RoNNW2L315TyWzDM0VR6zr3eXMHXO3LGYi09j
	vLI1atPGsw2Y/t5LPJsjj38vj4xLS8OWGzOf6W/xuXfu8RCHKlm+oCTVEXaJULYC
	9dncgWWtSsQPwKS/RfexUDIrgDXSnzTG0Ia7zOxtvEdA06jFe5yr04EDlzuk5fRV
	mMBZc+M0NCxWltVAUc1oT+Fd+I6/xOzRYEVmfmqC6RpAkM4qe3Mg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q4e28sf0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 14:39:58 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SDHmpH005431;
	Thu, 28 Aug 2025 14:39:57 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04on2058.outbound.protection.outlook.com [40.107.100.58])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48qj8c7j85-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 14:39:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J6aAj7YcFNullSjbPRgMGWLhSP0f2TKvmePvtQDyPCTwjRb6q5SuK0vG1NQ10FU26RyjndrmMryexjovmUtoNEESCPl+oM5KIiCouT75aA81NxMIQoilX+vy94HaLDVLVKZTzlyKSHqhGX+Nlt4js8DlLL66iRoVi0Fy6Ji93k/HDXPQZH2/vl3bVpQSffwQQddPnB8d+78PRL3Me5qFonWhGGLF1ZuKE4HKM6eFX9c3bb/DbwWqYD2lXAlfTt9VBlcJt9otu+BS61IxSsLZxRcHQ2cXLrOCODx9wDCSYaJBM+N7cwKdYwNdyaOT6EbTPBSjQuKQmwx4dR4kUwbHkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N50lplQalaYtUkq42oAcoUX/HtYIfKFyHE/EIvZtsDM=;
 b=T/wGARNrZMALU9z/W39ZnjFg1wvEh4WjQbbxG5Ami8IL+JYjCseGIdA1vo2kWr4a30D/gr7pjIuXrYhd+/lheM+RO1XHaYl1a8OKTY8h0CaG9qXWVcWsnA+OPy+t854zWfPJKYH8rvDdqBDSEWhVzGh5D8xgHsRUt1r1c9Mjf+NVKfjwgfx4jzA1dgC2Jsr8dNt6NwVyJPoAO20wCRZY3raAo/DwMU7dox9+8PflZCEU68E2eP4ANixzS8hdBwkTkkYW1tuk4hhQvesHlcN8N5LuE1UAOrZTYOqXYaEiRMdzcPDL62YQFyBmLCg9xzBz/kaYHwLjJ4cKGochlRiCmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N50lplQalaYtUkq42oAcoUX/HtYIfKFyHE/EIvZtsDM=;
 b=n9J/4jUlxLDz6YuXxeehNxu1banlN8/fhFRhSuMog9W+wH/7DJ4MtRbwkdFzo62LIjKU70YNOyDj5jJlogUHAkI/hXIsv0dMUrEPyUdDkC78xypwXgFt4GZzFgUPexvRQczXhWsmROizlRS5RUSC8Dw+WFtvy9tXTFsbFQt0LFc=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by LV8PR10MB7942.namprd10.prod.outlook.com (2603:10b6:408:209::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Thu, 28 Aug
 2025 14:39:50 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 14:39:50 +0000
Date: Thu, 28 Aug 2025 15:39:40 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, SeongJae Park <sj@kernel.org>,
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
Subject: Re: [PATCH v1 07/36] mm/memremap: reject unreasonable folio/compound
 page sizes in memremap_pages()
Message-ID: <29226dad-e119-4727-9e23-dc7c527e4281@lucifer.local>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-8-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-8-david@redhat.com>
X-ClientProxiedBy: LO4P123CA0542.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:319::7) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|LV8PR10MB7942:EE_
X-MS-Office365-Filtering-Correlation-Id: af3b516c-290e-4ee3-8a4d-08dde640be4d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?B+C1segH5/OQPp/OefEivMqfGyCCyqFI2tb5oy/2+ETXhd7EYxQ4mbhs13hw?=
 =?us-ascii?Q?djrzidoy16kw0fvEb9/CGFohHrf8uxFHShcCRO9YVtveDvw8rt1ch88o0kzr?=
 =?us-ascii?Q?qLH9FCR14XcFGwqxIaY5s7W6aGqfLbVDm9+ZknA+BCugjayOFchLTBTIG3o6?=
 =?us-ascii?Q?VZPyoSGgcYo2jdOcw45fkYAbl0GIH0XsaC2LoPJytvvN3am7LzrdaI2Q3ofz?=
 =?us-ascii?Q?VpfwNaB1B138RKv5l9op48dg/JKceQVrglDsLw93x9eALzdQ/ftDI1hH3Dy9?=
 =?us-ascii?Q?3SBN4oCP1+i8SO/YAADin//V61OrYvuV6OD3qakx8U2gsZrCC7NxkvI+zr9I?=
 =?us-ascii?Q?xf/3VEL6uNIH5n8EwGy1SXDPDPgreqjd0NTUapj6mJ0w1iu6JKXhioTfxV45?=
 =?us-ascii?Q?6c3uBlQkbH4vq3FurpxrsKfbekblzx1fwxt7fIqUL+yH5sLr3c9WSi/LnVj7?=
 =?us-ascii?Q?5KBiWy2vtjgn1rX6v6a/vuQEyYQHZzRxzUuaKZfh6Me6yhSCo971T2yWObr6?=
 =?us-ascii?Q?0WrAce77Beq9xX4z3MbQYQt7ZQqZr6tDHa+F8vp+dktINo1a59JhHx1Qw3zX?=
 =?us-ascii?Q?gFh9yzcAFyLMnS4cNytkVlb5VoEYqNV8BekCz0/4h8iAj+krrvy7s9C3EetC?=
 =?us-ascii?Q?RBPbcZVnz6bjgPTjlNGZ8YrU/fDJAg8Y8o4Au54KIVUf1ziuxI8kquRTxqje?=
 =?us-ascii?Q?BWhIzuUB2SpMrWGkJU9YskSpmJbk7tRSmeHae4WYYn4pfMs1TRSUh/T05BOz?=
 =?us-ascii?Q?Pd+pgu965hMn0fZZLkSL3YH6aQkoWJg7q0thk4I9oAf1LC/olfvQB/luqwto?=
 =?us-ascii?Q?XU8e577Q0BjL/wXEtyOPLXMq8BSdzf8stg7xgtg3VP6KsQP/+P+vUR6pqZrX?=
 =?us-ascii?Q?YRuLjhaDseTAnCiKA0+wga4oyE0YiBMxxQuNZWFbIJbDxy0yUM8zPoqyAVvQ?=
 =?us-ascii?Q?tqg/FTSiee5ndLZuw0y6iu8az0uybLoEtrXj0RqqbXaPnqFoRsjwSd1c8foy?=
 =?us-ascii?Q?ziBn15xuATTELi/9X/ItQ060aB37cDA2IJiwi9A+dbj50o+jNsIyw0TFamfU?=
 =?us-ascii?Q?p/j6AJJo4oFovyyDF+djzfA6itOwWlCHsUKEpE0Of9t0svau0fht006JghUT?=
 =?us-ascii?Q?FFwdH7QW2/161zYHcZmjxQ2BMuKxGdtsw541mEWKcpMN4Rn+neWC0bmQiA0X?=
 =?us-ascii?Q?5swoIwc6VMMmyOPbMFmqkN1680rqF8NRHoylbE2SF6kDSUNDGmyhCPP10zPh?=
 =?us-ascii?Q?L2Lx5DpaIgUdMx3rtUI42hdkVrBbBS1WN/qn2QPZKHhaJ48gkJkyqt0DORd9?=
 =?us-ascii?Q?/fRO63plFxZKBnZ6hggTlubyA9HRlNGVRZyI8FDB2zUZEJtPNNIwzmGOM0a+?=
 =?us-ascii?Q?yJQaenrqcJU0ZpkDApjI2RcpTuyf6YzSlofS11qRkAE30pgD0BAEWnIQjfhQ?=
 =?us-ascii?Q?9E0VbYbed2s=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jCX0U1cy2w+086zw4X6t7vf1KEyZBUFvBJUx57kOWQYCynYaOhI+Q7qjFtNG?=
 =?us-ascii?Q?CFn8TNwL4sbP+xjoC8jrAUS+GGXCvO5jk0MkR3mSyTwG+kr9r18ghvkDWzV1?=
 =?us-ascii?Q?wj7CFSWoxNEgKR+iTXLHc3CJo5z7Rwdpnuw7fL2OGuzGzoqoJOvAqOHkY9lE?=
 =?us-ascii?Q?Fh+rlmlSSqnH5X7QuUIp8n3PH/woVmVcMwl0SuHR6DcsX2pTgBp3j2sH+XXI?=
 =?us-ascii?Q?lWrJ5gWdLGNqnSqWS9n1M7y34uD+79C/jbWN/GbXOXVmKGjWLFfICx9S9g0Q?=
 =?us-ascii?Q?pSlY5Zk6L9zDw/mdJzPNWY2qeRJEnLVWF477OesuLZfRelatKi8aL1whHqKk?=
 =?us-ascii?Q?L1oRnQV2ot7VlRTsnuXXQC0yQjmwd9vE4ZUBBpa9y4D1pp7kb4AarfpesYLP?=
 =?us-ascii?Q?k2WZhyQ9wVZvzTLn8WbhMpdEFl4QQIQh61HFBarrJp1yA1H5f8NkXAoQujU/?=
 =?us-ascii?Q?bniHEtONL6pP4TCdcVKrbHbkm2oNVLI6FA5qmuC91E9Qj5wNLjiCmiqalXKs?=
 =?us-ascii?Q?x2zF6DQfe8yDjcilcKiVtCBnNFYgNVIV7ZFbvcHmrohjRZy5rgSwvB8c7iN3?=
 =?us-ascii?Q?P4HJOaotqzxOvZCl/sDAsmrUKjh/dds8F43/DrutCjdJ/VXqOOP1FCVyf7nx?=
 =?us-ascii?Q?1/9xQ2wzCjeoyPwKFTYL8TbZ19TRzrK1fiXss3IKPgFD89thJ3rqAnGwjty4?=
 =?us-ascii?Q?NYpaNLUfcH6fkCC3e9+g0Mn5jGzCKwxqg3mYHUWsRgoMvVnrV0yRuEpBhRek?=
 =?us-ascii?Q?w2rUmv5o6RtvHGbnXNviMO11NvW2zF2lyGpJlfio3KW6EGX6kVVY6+MiMC5D?=
 =?us-ascii?Q?oUYpkGKd8nGFmlgvu5XQbMPo5ApIfdWS415pRtMqz1gpw3MJuaKX9+/AkO4b?=
 =?us-ascii?Q?gWSdU23cI64TLr5CgECInnf/mRA/uF10jYGRau5oVRMmXIQuSih5oVjlhYdc?=
 =?us-ascii?Q?Pe9iiWzRfvngBH3hV3glNxuOCl0iblbTpdOJD8Aonn7j6OjNtaXgmxucTilC?=
 =?us-ascii?Q?kcpIk/919DCvIeIKAxRr9yhx59ylXb/2wTYyvQjzGaIJqT45atkoTFUl2t/I?=
 =?us-ascii?Q?aSZUjC2lB31r7kC3rbYY3JsA1q6OT06oqCjOIwzuSRJn57u23CEz+mZs/qXa?=
 =?us-ascii?Q?VFaSqMJXSFj+My+1S+f1YD50ve/e9nUhgvnxyt4m7v2cZe1OmxFBe0iQ7HZs?=
 =?us-ascii?Q?H53Lsqmqmwx1+vNJUebu8up4jgjprigeIfC1G8ToNYLMkSSLm1oUpWQ6Tzup?=
 =?us-ascii?Q?gK32V7yNp+V3yVdwwLnEb4TfRIj9t8BwEniK7tKdw6Vgok/cqj02IVlfG1fI?=
 =?us-ascii?Q?TDRiF7l3qrQj6DasCD74HONXz/ynBjKMvGRUZsOiBVU3mGfgqf6yjJtQxCBl?=
 =?us-ascii?Q?BHWA+dERdzMlrng3NcH/mdz8ByIn2pvgKEWcGTPbajHTtOSNUVaHTEJhesDz?=
 =?us-ascii?Q?dkMV68W4VOQmVctvraoEZeC69X1EMenoG83Bjtqax45ykeJkfCylT77qEimu?=
 =?us-ascii?Q?lynBxnb5uI8YWQrzBJ6XKSMKRU2lmCacv27XcVy2nTIKOPTe3/c09hgAzBDa?=
 =?us-ascii?Q?AtPTVWU2MPSuGn4Ozbvf9Bg76z/05vacKlJZlhzrPvQsBd547brpKBiOB5ir?=
 =?us-ascii?Q?mQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bcuxSLKqgwCs8udubwGe44F4h6EIQ8QA8qdJcD2pesjETeFrCp0fcvZE62ZYN+eXFi0PgBYlKpyG9+Fg3iQw61pgwAe3dv0gPoEWiNEgfURgHQE8ASNMoW+hGriWPzAjcutzN2xGfoMW6PgTO2oPbj/ZmJ0jRHeoIq4QMMSuolZGQ9EXOzXz0VVMMZquB4ZxeuwQInePp5PCdXR309CibszsmTDP28utJ0lU9WvZVKM/aOiCbkyECksCAPk7QOv65pLDplQqJKxmcDoNltJrQtLwoNCw0pNDfeFG3Cvn5IeN1VnVY0ksykXaLozN8aTh6/FPlXxjcftYsB0U4ksXzmQZsQkRsYmpXb6z3ld+1ujPed6MnuZ6/+0He2MSaNR8hcb3SiKmteJnYhoes4R0dqOwaVsEdN5g/XuuFfWuSx+Nui7y/cVxr4j/hAqj4nvWickE+B8ARsENMizDLRJMZUOEdKCh1zianhK68azLdHmvbzX4izJDOBodpUIf5CNmgvhilBPVo7ip6UXnZF4n2RKuoFAYsktqfDvQMvwQGPglpiBduVJTegtnR5rK9SFPuf7LdbsdDYwH8IpzXaOne1XlWXgKTnMLWxufgbtBXY4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af3b516c-290e-4ee3-8a4d-08dde640be4d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 14:39:50.3296
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0iHOdTKMjmHx6dRsh3l64+ZbMWuHqr254/jXQgKHuBK6BT7bPo/l/8oxpiBVDo+v72d4KaDbXnrDxJ1Vj2BajTtK03KDWU7kejizVeqLsik=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7942
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508280123
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxNyBTYWx0ZWRfX4kBAbNMJ6HpO
 vDax/GNX3ABJFDOYi1xUUrN4BlLwKBg5CpT2zqRR3420nhhIFteQ31ArMSFkYa+y9e+/WjcIz76
 m1BcVmmlm6LV/QqG5U94NpdpYR5pOdptqiOTV+K5AgQrPURd5ZfZ0+B8SonsPz7QB376N7rYtUO
 bYwpQH01PeN7KoF1MK+leOd8GyxYKUxueVOEGTcwdsPMhTi9a7bUrt6aJqA4Il0RW/7Vwx9IeMn
 xZ5MJYJAtGW0s1LWyI+uC83U785rox6nBB0GJ/kdsdDkFQw3RwlShxGQQG5EqPliGPC0XPU2jQG
 u+fO8+jk3Vfu8ZTzufuED2SZsl0aspMeBHz1HjCGvjLVGpacm+RxF+yuPObbTp9tFNgb1vh6uH9
 WOY6C15ZegHbFYtDM5vSPZZ2uy9iBQ==
X-Proofpoint-ORIG-GUID: mQqz7s-_-VIjjDMV_8ME-x4ZBBKsAA3q
X-Proofpoint-GUID: mQqz7s-_-VIjjDMV_8ME-x4ZBBKsAA3q
X-Authority-Analysis: v=2.4 cv=IauHWXqa c=1 sm=1 tr=0 ts=68b06a3e b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
 a=yPCof4ZbAAAA:8 a=8oFh84jD8XJEb2fWN4QA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12068

On Thu, Aug 28, 2025 at 12:01:11AM +0200, David Hildenbrand wrote:
> Let's reject unreasonable folio sizes early, where we can still fail.
> We'll add sanity checks to prepare_compound_head/prepare_compound_page
> next.
>
> Is there a way to configure a system such that unreasonable folio sizes
> would be possible? It would already be rather questionable.
>
> If so, we'd probably want to bail out earlier, where we can avoid a
> WARN and just report a proper error message that indicates where
> something went wrong such that we messed up.
>
> Acked-by: SeongJae Park <sj@kernel.org>
> Signed-off-by: David Hildenbrand <david@redhat.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  mm/memremap.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/mm/memremap.c b/mm/memremap.c
> index b0ce0d8254bd8..a2d4bb88f64b6 100644
> --- a/mm/memremap.c
> +++ b/mm/memremap.c
> @@ -275,6 +275,9 @@ void *memremap_pages(struct dev_pagemap *pgmap, int nid)
>
>  	if (WARN_ONCE(!nr_range, "nr_range must be specified\n"))
>  		return ERR_PTR(-EINVAL);
> +	if (WARN_ONCE(pgmap->vmemmap_shift > MAX_FOLIO_ORDER,
> +		      "requested folio size unsupported\n"))
> +		return ERR_PTR(-EINVAL);
>
>  	switch (pgmap->type) {
>  	case MEMORY_DEVICE_PRIVATE:
> --
> 2.50.1
>

