Return-Path: <io-uring+bounces-9437-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B7495B3AF65
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 02:30:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 990D5686F68
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 00:30:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 490363D6F;
	Fri, 29 Aug 2025 00:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Wz/kH8sF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xqReKaMf"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9204614EC73;
	Fri, 29 Aug 2025 00:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756427390; cv=fail; b=hNExGursuJo5IpCrAvum0bVKOG31a3OfYyg0R/ABoh+sEoiZs8APbq/9K/7ME1CrXVY7hXuWJY15CFP70ZTy7Dle1qCnuWUtT6IwzO4M9pmHyMZThXbKG1T4wXt62VJFv9xOuClhrzpL8n4XEAXeo9qCqCZdFuzmGa/wb6NyOjo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756427390; c=relaxed/simple;
	bh=PQmw8J3pY75IdXEiZp7cdbgLRWdTKg5MS9BWura5jJw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=X6IyoWNip3I1htTZL20HOH5h8tmp/6mvqR4YyeLSVkB6n9b/mUxLNCv4/tUf0GeL3cZekgF2kUlYsfYRAc8TK/Dzhy/LFD3EPvNEyJLHOSnerDFtgpcYWsZJwFjhaPLWCAcBodSsj21oK5XbNH/TcytfuE3rWLLJ12TgDGflmqQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Wz/kH8sF; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xqReKaMf; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SLV1K4009002;
	Fri, 29 Aug 2025 00:28:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=srwzRoN58V9ToTyecc
	qGBd1eRJ6mFEYscdWymDdwC4U=; b=Wz/kH8sF2wqXP1bd3XTlei0e85gitCQpCU
	gYU+IshJ1it0fB1xaMr8s/Eaqg9xEynGEpIJQRDNSlSyzzId70m1lNdCB1rA5KZe
	UpYXtN/Z7emIv91YPTk0zgeDmhcib375SM/FxQr/2kNTp8Rs5dYWHNeFZcpjjAAZ
	IYnezlFaFYeCW3vNZcAWde6bq2lm4BakyuCkA1F7SlS/fOsKZbBnEWXQVdSNT5uS
	byg3O67S8c5nfVxOgxdwivv+GIWMgQs1Fq1bdlTnTZbm+v7qUDtWdQTHbZq7dL7H
	sDOFrrUnUu+V5+r9Udm+meZvZR76gAWwDh4TaKtIOaX0J1a41xHQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48r8twga6s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 00:28:51 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SNZbCr012476;
	Fri, 29 Aug 2025 00:28:50 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2058.outbound.protection.outlook.com [40.107.93.58])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48q43chbjy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 00:28:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kny1IndrSRvW3PRe19im2dfhwLxZIxAh220VGkoAfyhLk6KzG5yoAKRA41G3xwEDTcROzP8wpMN1fMeI5vr9DQ/Kx6As9ak//yBj/wwNysbYDEp89ZgN0UdkDvUVqRaJp55nWoh9lCKqof4evAWXBUkWZmzhqReRSGnWXf1awmIg/5hAvx6tTroiWVEoAhh8H8Ip+UGi/PykiBdipN5GVJEuSc2N/UFMPXmQdwrajyrXMhZY5gwZ4HDwLHs2Cba7VGrAiASg0H1pOpwGYur+wbwGEXDd51ZTQy8dcI32638pfis9exKr8PLdzfLacX32odcf1NwsUNOInWsTqGFsRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=srwzRoN58V9ToTyeccqGBd1eRJ6mFEYscdWymDdwC4U=;
 b=PFknR0E6FIVyu6C8hp2BLM4B9+pmrV7KVM+PMeyLzw7A9Mme7L2YLMDOCkAGVPRleaTaiYSDYubs4SgbmVb9xa6ogLt+9eFUwY1WMtPcp/jeJQGg8EP3qT9fFG7mlsdsqxdtSN3s07Fm4wCKdIeBim34azHWiu5HuGvxT6WNDXaYMSvczK2+jNZOj7IK4Dd4mPG8jd0yWi6NPlIchyjanDeceGEt6L2kHkkG0kcppHV90speRB2PkvQjFV5+F5boC/hO13jTtbZAWXKpx/QBuzneaOoLlxizCHDUbTbA4YUBs9DowAa20zIscCnpqMTC58iiz0gJFtO22nfO1gZx6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=srwzRoN58V9ToTyeccqGBd1eRJ6mFEYscdWymDdwC4U=;
 b=xqReKaMf8uG/YWplCa2P0ib4bYeVq+yxDqoFQHEY5uAm0V813vC/BP8jSmyVBD99J1j/kfx4eEDJxuUFDNhqXp4xqbenwiSYqyCgZJvLY9EmjsEIlo1aw55XpcrOukT4Bp+PQrANNkX1pMLF1462p4ljkFkamvxohXJf7NSOmGo=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by PH7PR10MB6481.namprd10.prod.outlook.com (2603:10b6:510:1ec::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.17; Fri, 29 Aug
 2025 00:28:46 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9052.019; Fri, 29 Aug 2025
 00:28:45 +0000
Date: Thu, 28 Aug 2025 20:28:37 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
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
Subject: Re: [PATCH v1 04/36] x86/Kconfig: drop superfluous "select
 SPARSEMEM_VMEMMAP"
Message-ID: <27leccakrwk7gwupltma5f7enjx4vt4utxdcitqpirx3fpnpd4@ythmris3c25e>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org, 
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Alexander Potapenko <glider@google.com>, 
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
 <20250827220141.262669-5-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-5-david@redhat.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YQBPR01CA0140.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:1::40) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|PH7PR10MB6481:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c5ff747-94df-4d41-2f27-08dde69303cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cplHuPfUxmkrNJKuAL80x0p4p0mHfxaLRrHd1a+OOtRKdOHcWVnv0L0W5RaU?=
 =?us-ascii?Q?r4Svaj4O+XtVOEb99/ZkwUmqc0/mO/l1+hdZw4WdW+nMN9OooiH2jPBbu4mi?=
 =?us-ascii?Q?KOiZYfx84+CtPfui9ZUOPZ8Lg0zAmiWZ9XpDbobqMQhuSvfzngLgLLEEiYhj?=
 =?us-ascii?Q?DTIj1mNvSp/hYOEgSHO2zG0LjrOyDzkWVImplWKEJ6NPy7cHmv9qPFXk701T?=
 =?us-ascii?Q?wkBIQ2vE96xPNHHin4eyKwuVWFcTpsNudsXJF5UldPiR1CUuQHM0+8jT/HQm?=
 =?us-ascii?Q?okN9ykVrKvov7o0SGc0jW6INOnEFEUCMbODwkfLfo0NpXl6P+UoBuNelCLKt?=
 =?us-ascii?Q?UAY4ChW37xI5TAN1Wsv2zI/SaURR7DYtCJkMQIrZYEQBenBu76MN3k44QoU5?=
 =?us-ascii?Q?htB5gkKUXdIWmltWUlRaZXBPLknXdUy8USZ2vqRKp7BI0U7Z7xfoXNNwGAKf?=
 =?us-ascii?Q?aZ3Pbkdqehw+NlEBm9k/88N5pj0B3aHuxR/cxjUt2CCchGSCMMkTitTOpP/b?=
 =?us-ascii?Q?rx7jUb9utOiSejQIs9D8h/twvFA6L83nUaInD8v7LljkCx62UtiTUs90VZop?=
 =?us-ascii?Q?bTrobLemrznJu+GfUI6b0oXoK+G3paMS5z/POKkysGWLP+HyqLNncXqh37V3?=
 =?us-ascii?Q?FxfHbyrCvTCN/O2SuDWxDNqwcp4cnf06Fu5n7fGMWkun6B7C2vlf0l5VPxjs?=
 =?us-ascii?Q?rQ+K8BgPELkzS3Lfac7io0qy706ZtIX4em9UZXnAU/QFhOjRf2IuUZ2bGUn7?=
 =?us-ascii?Q?ngT+PBvWeejXFw5GyrJv0qQecelJylT/megCeFpypUyu1IbPqoVPnzzYagvU?=
 =?us-ascii?Q?tzgLrxflhuvNkE9preE+IQyxEDhUYIomuyGpFmIa9lWJSrsqQPNUsHXvRKpk?=
 =?us-ascii?Q?AZN1fs1Taz1NFgh5mQOEQp//7IOwe4TESY5TtIJojni2UjcwCczBylvyucxe?=
 =?us-ascii?Q?n2FSfNzUcMsdENOcYU2anyl1nKRAxreMmhJVr6Au2Z14Cb9HJnh3cJ48ereC?=
 =?us-ascii?Q?zSb8Rx0+DhTEWs+EmJbe/hPYWKAF5av/iW+hsXcu7k8qd2OxP1LhBwnypOAS?=
 =?us-ascii?Q?4zzhoJi6mGkPGHbirwXHTq+tigOqy2+TA6HK+JUHda8tj+HLomClIYRUydgi?=
 =?us-ascii?Q?H29YvmaBAiTSnP8WkCtH9MLqRyENAeW96+ijBOXvXYxZHaVOXmB+kStH+JJO?=
 =?us-ascii?Q?Tfc4KItInAOWgRHEDyzdrnqOrfawkue5EfZIazfL6lDBWPScZaLPTain2jwr?=
 =?us-ascii?Q?6gWikC40DMsKoZubGOEekWnJFTy+E+odUjEYQ6oNfkTMmhqhuQhM8NV4j9w2?=
 =?us-ascii?Q?Cjz7k2jYMrg/wiMTf1qa+gc7+4mKvUBI2vXDcCavDcIfoj8Yn0IUAag9wbdT?=
 =?us-ascii?Q?+WP+8TkooP0QlYUeRb8C4eqIVoUu9Nd7kt737QhbOCQPkAsZuA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xozonNPcvxncmo0uErmvURwOgX9vd1R6EqSTpBU/PlNQB56H/RMVJ4vT0F8G?=
 =?us-ascii?Q?Pl9NMBlg0NRJxzSIpbainwBwHe5p/2/CcqYZ/wGQKa1/s0lV1wB/dZFVuwAL?=
 =?us-ascii?Q?XgHp6vXQIH8XwSonLHrknWH5Eyw76d9XdLyR7I8w2jrTfRNIwlHViPAWZ/Ag?=
 =?us-ascii?Q?i1uQt6QpBWC0PtNI2cuSWdyMwwr7o9tuuFUbnB0n50J3Ptb3j3ODd5pZESVS?=
 =?us-ascii?Q?BpPvsc8sBH1QVrHtYxd6KVTIRSuotB3qpAVSGY/0bIroBXPoyR81lFUjH+VH?=
 =?us-ascii?Q?v2iqJ2/3hTDIhMM6qBwjMaMQJx/empBMToFnx+Vz3Rz/DXP3o2X80fv6nHQp?=
 =?us-ascii?Q?8ASZ2FbE7ROsksrhMLi8PYTwYezOhBBQJw0uUunxyUmzU9Ys1ISE2jMP0OlI?=
 =?us-ascii?Q?1f8/sazdJ9UFMCDA+IxGWUFeb4vnXbMgz8zDG2iRA+/6m1pgLqdbdwaJz/BF?=
 =?us-ascii?Q?EqeiNNY4uFCd6lbA9II2M4Qr7FV9gr2ruRn6vvIMpF0gO5rqmGlTQ+slY95j?=
 =?us-ascii?Q?q0JRZChj9qXvnRqbLBybZKSD4iwnR5pI1dy2i1qwgqfvE8hi/jcI6a5uK3zS?=
 =?us-ascii?Q?bAdq+3HEp63nZqzK/Pfvpxwhp/WFzVCTE7QVoWHMGQzO85MD8ZlUUy3obpxQ?=
 =?us-ascii?Q?IC2MrYWrxSSWY/ozLp5sPCh/aOsceHqVm1tJkvOKORLW1jKHE/UyIF6wXWro?=
 =?us-ascii?Q?HBds2HN/iqpkvIKVV/QYHp4fAN65KmKODNlyPBcXwlCV1s3VrikGyycenMit?=
 =?us-ascii?Q?Pr5n4mFvH9RgnL8bYSc1fpG3g2ZjM+DmByHGw8tLzhNK0wxcm2VW7OZCGKAb?=
 =?us-ascii?Q?jrR2agOCgYXnOrnYouSWSJsvxt4M6HGFZtYhmWTbhCfpzj9p5lc8EqOBLnOM?=
 =?us-ascii?Q?dcXZVmsY7WQfRVl4JNmErLWW8Rf8ZLpmUzVjfAWn654vPjcDk4D/c3+T3KG+?=
 =?us-ascii?Q?cm5IkIHWVe6jpEsofBVyoaLYgANO6Wlo+mEe/TEiTEnkWw7z+5JbadTUPjTz?=
 =?us-ascii?Q?mDBudm4OZaKaDqGke6eTfhfw7eTuLVnwQL+ffn0IOXmxWypFNEDPaOfqvCu5?=
 =?us-ascii?Q?qrsBNDFPrO7F1hvizT5VvwMJeoUADZhmXIctFajRwhUJfITp0OHa7Ylexmt4?=
 =?us-ascii?Q?ZVN+uYKNEpz9iq11G3xZZZDq8XirWAT3EBTv67OHy5WOhVv2Ujln+pntg7iw?=
 =?us-ascii?Q?CFhgSbVsya0UMsBbo7/Q1hn2J9YBC6i3ld9d7+c3YEccTpQBhLqxbX+/8zP/?=
 =?us-ascii?Q?oRl4z/+Qopn+5QgBJuCRZC+q3U4yV5iHABd/S8mtSgBW1nVaF2LkSnCHlpN+?=
 =?us-ascii?Q?GLDNbtfOqRceP8R8H7C7ba1pkCQi1eSLFS7V45kkMdBXzrRideWGocG4mnVP?=
 =?us-ascii?Q?ct9kL3OJtIyiubUUu/jM29SevNbC5ScG9pt1TlYCdo1Y3fIDpLHgmAkcXySF?=
 =?us-ascii?Q?RHhEbcJ1gssR2Tt9Z/6kg0XD6s5uOMWDVky9b81ykoXQF9YitF98tnFH16Eo?=
 =?us-ascii?Q?eDstMOVDE9KxjIGJK4OOQcY6H4SaMRGsSHL+lQKMfZGHhS/4Z4CTU4b42ys3?=
 =?us-ascii?Q?xpNDIVb6rzIuANELPTF9Zwx/gV1Vg73p9u+OMsHftlpfn3sHK0VBuHlCPx3D?=
 =?us-ascii?Q?xQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kEgeBYDpy4tyZ1xNkWDkvb6oSqW0ddH/o+vcN1Kx2E4dVGABBLleYn4wNaUJ8zIgEnJYZ/v8WDxJgimqae735/ubcaF+JOXz3me7+47caglEkkmD7OU3a1YLFJ/iXmo4JlcmjVIISnbvMuxo7CAHLsNsbf9AzbOn1Jvi1JBQm5eenDPxHYiuPqlTFQJlPcv5ja65GUIG6ohchvjOw+RzWZvpZ16JjdY+o3Ba+4HV79dcFgtFOcG9mF/8Sx3giUniGvMhg688GNlgO4XU5RXsizE7pvOawhPQYhBtgDbD5JN3HCtS/mI6dyqx5S9t6sJQrwwzPamUkH3KWYveu815vMzcXmLGbyD7MOjxZZp2VtpR0sTUuxzLBtN1YkFOW38H0ZKAkOSUoBt9v7zIqSGym6RdLGA7lwGCaFEO45InhdfMghsjUT8cnR5KQK0KcRx6xxRYt9s6XKOD10E37/suEHd5Lf8h/6h1s/JsupviCAGp9NuWbSWpsiCC0g2It3WEkek4R7wqzwxsd482QjdbOC70wlN+f3vRjPk3fer24/LurB+uQbh4f0kssrTeR6f8EC0FStBDlDcKH0beTKr9cdwwqcJMtF03KxtHvciwhSc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c5ff747-94df-4d41-2f27-08dde69303cb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 00:28:45.7995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9R9Lf1AvVzUcaGG9o30SGUSel4mhMP0A4aHcyLtqMtB0fjkx9bRZDdBDJ+QHBWhh8BAbAl0PPA15geUbtuRccg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6481
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508290002
X-Proofpoint-ORIG-GUID: ojt70pwjmTsRqbU3llsrlQqXhxKS1ByQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODI0MDE4NCBTYWx0ZWRfX8ZsBpSS/7TvV
 zT2IDL3laERBuZtVjjsS+LA2J0byhTYdD4K2rdY5TkaOBkkcyV03udFPD7RFd9KJQhhFT/DO78h
 ZHGIjX4evi5BsHw16XozRM4Z0KgZQ1m62TcCnb3t2dCVHk67L/b1Yp+TVWljiiQsEoEgGTfJqcc
 titS1MYRNHq0V8FLixgK1B5t8zQ4O0z0r9k8uHU4YoqziqDv4f3Thopx5oCnqeOaJSyLLTZGFZY
 QHHOXoyZ03PKknum6xHh6H6ifIOp12N8qUzS03XQbnlDuMrhj/6KX4j/Yo7496YEBOB0rzaU4vg
 wGBxCMw4cwWNBKcnCy1CKuP/ZHWil8BAHQkhz2Ws9iqUcTmfO3vs1vCK6JvLZB/hgNPMQTmksmM
 tUXZitZ/ScAElg6c/N2LB7GBcTdidw==
X-Proofpoint-GUID: ojt70pwjmTsRqbU3llsrlQqXhxKS1ByQ
X-Authority-Analysis: v=2.4 cv=IciHWXqa c=1 sm=1 tr=0 ts=68b0f443 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
 a=QyXUC8HyAAAA:8 a=yPCof4ZbAAAA:8 a=_GGLgWR2cNAeYbTUaCwA:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:12069

* David Hildenbrand <david@redhat.com> [250827 18:03]:
> Now handled by the core automatically once SPARSEMEM_VMEMMAP_ENABLE
> is selected.
> 
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  arch/x86/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 58d890fe2100e..e431d1c06fecd 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1552,7 +1552,6 @@ config ARCH_SPARSEMEM_ENABLE
>  	def_bool y
>  	select SPARSEMEM_STATIC if X86_32
>  	select SPARSEMEM_VMEMMAP_ENABLE if X86_64
> -	select SPARSEMEM_VMEMMAP if X86_64
>  
>  config ARCH_SPARSEMEM_DEFAULT
>  	def_bool X86_64 || (NUMA && X86_32)
> -- 
> 2.50.1
> 

