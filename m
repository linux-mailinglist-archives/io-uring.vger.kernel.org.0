Return-Path: <io-uring+bounces-9396-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 02C63B3A1C0
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 16:28:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 08350188F23C
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 14:28:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA7B43148CD;
	Thu, 28 Aug 2025 14:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nz4SMjIr";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="mlzkQhPX"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06C721D3E2;
	Thu, 28 Aug 2025 14:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756391220; cv=fail; b=M3Tks3P3WSdnHTuxxz/TuJ0HG9Mj6W62fggC7dSr6YflppJlulOTjmU+/5dM2fok9+pMA6eZ5D5MwLmdWn06Yp6aFXslcaJHQ7Joq4Obal0EUcQ1DpaYuRWW2kMTD7Kfp8R/STa3ox+bRPd4CGCV/CJXLE5akmbYfwgZBS6TRQM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756391220; c=relaxed/simple;
	bh=qiNjVn0CVTZM8fnllP4+nBSpWOjuyFTS/NijDL4KY9s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nrV8a3TnxQ+1twt0t0O0ex5t0GCk8ayL70Eu2KlrWthS9U+pKSPj/PUGcEHjdmuxC31gW3U7xktrDv9JkdJLuUmM0RZAoknbtIHsT2r8gP7pnHsEGal2xFfM9ZOGLz5KhNyERIHL1pDMtTD9VWQ8nJ5eAu/2dx21Epv4CnMye54=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nz4SMjIr; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=mlzkQhPX; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SEN3D5014331;
	Thu, 28 Aug 2025 14:26:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=0BagwJgUB5R2MrxEqo
	urDxBoXPn8q1doY1t41uvd6/8=; b=nz4SMjIr2HCTYBs8ZkczTwnL9HEAePHQWf
	VWr2aHWtQyuCQ2neobFaBMj7xvt+kRKz8ZpZB4m/BS92MTC3DsVeBmH19QDBX+Y+
	0o3lIQwtNDyhxAyjc9L4O9fZnlFdgwc5P5H641I4Jg5UdXlitwYaK5pxjl+/buOV
	1sNnpv8fm5tdBN+mPcVfvNqalQrKkQbj9bklHtVWOSJAkL6NQQud7vHAD6i5S6Qj
	E8pblWnw9BYRSVM4LWmPELN9q6BlGFr3jVJG/yfbnvL/tzey/ZQY3AcFukXgjKET
	MbIcA5gM3WBVceGmQj0ZSkfq6LcuAfoJPmWgh1aXN854/e+BqIGg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q6790n7n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 14:26:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SDt4vG018984;
	Thu, 28 Aug 2025 14:26:00 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2079.outbound.protection.outlook.com [40.107.236.79])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43c25jr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 14:25:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lopXeuCiCsqyWfgMtrkP9RrKZdwarJr95n3eLGtN4JAExglkSQB3ucMVxcdtqLq/81tKj/XB7Mu9g4YznJdfQ5GT5VPKPnsLLBJH2KuH6c8Lx0sL1aXhBPD6XnMUVbgvgu4RfxJbPcyZIj9T8ucpy4iCsoqYjh++iwEacUWVox5e1bVQ9EJAXYuwkiHbYD/rWEG1p08YQXs6g0LAEZ5yJwJlSkPNTG0eXT31KfIlWi3o/zF6wa+65gliBsHhj+2TP2GN6s90gnzoyOdjjynuWDK3loClKgdsoWo7j9/P8Z4Gpo74AV4gy3FSClPlVPFApiuHLsOHodiN+Sug00Dl/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0BagwJgUB5R2MrxEqourDxBoXPn8q1doY1t41uvd6/8=;
 b=hpVol9J1iBIYtXCC5ALOqKx2A2KtKjGeCvurQjaRJIMDCxNdTR5RKJFCMqFQQlWaXEf8dyQUfpoCW8nuLhJbKIpsWUWa5U9Z9ywdzxk8GamHgbREqGIIvDr3SFUOB7rhIYuMm00GpBlxlYOhqfC4jMOEUxJynO52fd5caWHPkrFIfjGPm8Z+dy7If1l3+wX3fjVboxX9mCcBmFoB1n4PUc9ORc/2Z4H7KyikkPlVfZTL22kjo67BlMV9UEGAv/eSo8iltbTEjAO9uTPded3SC3A0OdrVIFELIgp0oa/sJd3N/7unHkOpy76Ku7GfJk3Cpfl9mrsVq5DJ4ls7xK0+tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0BagwJgUB5R2MrxEqourDxBoXPn8q1doY1t41uvd6/8=;
 b=mlzkQhPXzJSAKj3Zimjs/MSEL5igVkkL72VVjdJCvt2qin0r+qxwfjESkWULThgcCUQhatsf8O3OQeV+oxxDz3U/ENiKxPFPdCmX2O2CBYbTcsyiGweEvIZCWUGnTx/TwQGaJ6kuIyNMQvVN2hLkZ736DR+CIrdOh/Ry25sIr7k=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA1PR10MB7596.namprd10.prod.outlook.com (2603:10b6:806:389::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.18; Thu, 28 Aug
 2025 14:25:52 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 14:25:52 +0000
Date: Thu, 28 Aug 2025 15:25:44 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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
        kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mm@kvack.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org, Marco Elver <elver@google.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
        netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
        Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
        Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
        virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
        wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v1 04/36] x86/Kconfig: drop superfluous "select
 SPARSEMEM_VMEMMAP"
Message-ID: <c56903b1-c71b-40d4-8f89-5c2ea34fb90b@lucifer.local>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-5-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-5-david@redhat.com>
X-ClientProxiedBy: LO4P265CA0220.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:33a::18) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA1PR10MB7596:EE_
X-MS-Office365-Filtering-Correlation-Id: 90001cd9-b3c1-4b27-7998-08dde63ecb07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/82FkIh/B3diHcRlsGbgrwNaRuxStL1mbU0OSN/RL4fDORUL9rrzMIL/aFOB?=
 =?us-ascii?Q?ja2HYvCHt4JaR/RekOnidEJvHLHwdBZ3boZSCCNnjtnkBjkiUfmiAuT7dVLV?=
 =?us-ascii?Q?XExW9TeM7QpuBpyWANSJHTSlkl7AINu8aCXDjwCIbgjuOvMNCfn3WG5kY7ja?=
 =?us-ascii?Q?/NFLSHfZrp/ftN5d8UfMnylegW5XskV++9gQKKEyytdt7EucjZgd+ldEIi6n?=
 =?us-ascii?Q?fakKd4NUV6AHy/fJwL7tiRlFSXIpKZELQMnIxKB84VZYyQ4iCZeXSjXpqScc?=
 =?us-ascii?Q?lTL+hisA90Pit66/fnDuAG24Nw49HHreHvHj79cr4oRHwAyqRYOLtptec6RT?=
 =?us-ascii?Q?wzDIWRHqlGNPeGNYT/2KXBXzRRbhqRZHX/nw4GUH3PpF1E3hDjVKix4yGmwO?=
 =?us-ascii?Q?8vGq5XU0UTz0MiZwVQdh8WGTbLxAuVvYk04onbPkM8li7wZiB5oj3/C2FD1C?=
 =?us-ascii?Q?FPS5x9fBoXzuJu1G46snG93/4KYMpOQf+Mop1RfXwjNBvvk18ITA1WSUhrRY?=
 =?us-ascii?Q?GgEsZ5h014t2+EwDKKVyaDEO3AObd4RR8NDFfGMQLZevlSmtMFQQrLbpDRZC?=
 =?us-ascii?Q?5QWkg4RECWeLXIwTpY7yV4HrqZFWy0cfZ4/RFNUM2vC7a3oK1G/A+EaeICiI?=
 =?us-ascii?Q?k/snLvTSKXHsI0gA9CdccxXzTFZg7YduirmqOu4CMgEQNzqSmvWo+adUqwTu?=
 =?us-ascii?Q?qiU3o/iE+ueKhEzMRZ0OP9eY8/lCwvI3X7pZUEhXdDr9xHhip+tplN+oMOhA?=
 =?us-ascii?Q?kMcnv5XV4hrAd5TT/SnJaiKdCi1zNi5ltHGtoxl6xXnZOiZy1eEDjm/ua+mi?=
 =?us-ascii?Q?TVwooGblyl3ck7FsBMeA6HdTgHF4y1Hqw4tH4VHWWBdpoGqIsVurXrZxPCMD?=
 =?us-ascii?Q?v7zbwhT1mgnt+KQ3CE/Ed4D3VDnaOEsIMA95y2mDuQxwN4hCPYO5HKsJClDU?=
 =?us-ascii?Q?TXLDHAGqMnesOiaARb9McHEVohUOMrve0dXzg6qwpD8eCHOLh3a1Xkc7VrxB?=
 =?us-ascii?Q?DliaP1jdYMNqzIgMqFPXk+4qgnbylLTyZFqLlMaDdqaJhKAIwMx7zWgwD7lE?=
 =?us-ascii?Q?KMLp3lH8yQFkHhgTYMBcP5PC7Cd0p9u/8YAD6qD/Zob73EnayiW1Gi+Lhwvu?=
 =?us-ascii?Q?KsysoXCE5UdKqHrjazWuvBr3BzQS3HSPKLKiUJOon7QKWQQ35t1U/h1Qq6eF?=
 =?us-ascii?Q?lTX7er1EYhqIrK3lLVqMMGdml1elm+NpHfg5Sunx97+NCRiVv3WEgmYQCMFJ?=
 =?us-ascii?Q?yVVvw3taTf5b6kEmaCH0Qdlb2mzNoOEpb1XPQFxvmeyPR3cknyXZAkotTEGS?=
 =?us-ascii?Q?yPKGxqA2pNda0vne5Ow4KwCfPZe34qrdeTz8DBNs8/tntcSm2Uyfb4fma440?=
 =?us-ascii?Q?jO2pJIposFhrIqnQqVfQK8pw51Icl80QWpFHdpeAIiB4CfagusbG40IgMboD?=
 =?us-ascii?Q?IkFos81KXys=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+lBujI3EEyvMztCeZmTe5YvClAOfTCF05YKQLvejabBH7UeoCmEoAZ4kPfG+?=
 =?us-ascii?Q?4sbTS56Imh2pmHazktTLnR0ZoxJCvD84eR9rKJLKWpMShItvD4Hwenl5qg0y?=
 =?us-ascii?Q?emYsaryxTESP5O7kcBHRgEtQ2Emo5W5gI0IEwbHbzSzW+i7cIF8dQPGorJ8v?=
 =?us-ascii?Q?fEMio37Eh2HLnqbOCLXCRwQZ0YULTnKvJKDkaH02pIYln2MHgGpa+TAO246a?=
 =?us-ascii?Q?B/W8fpUV5RSHKslqtjG2RGf5WVc6Hi62DSwtT+M3jMRub1Ic+NdAcbyPH2ti?=
 =?us-ascii?Q?za7BpW0MyzlOm0XvUq85fyIO8k1bM4nCu6mMpkfayWUGxO4GZWYqh4TAh3cv?=
 =?us-ascii?Q?CSJSllAvoKLG2kziDHE9IRKngqz8u1SpDDzx+zNo+YwUosl4BMRtN4DPTR0l?=
 =?us-ascii?Q?eNOrYm/sjRWxWq7sB30mAWxzA2VwAGen0ufmRB5lgia0Cc9ITSfmQMpfYOiA?=
 =?us-ascii?Q?zAvpdO/O4chtlwyJZU/CaywGvhK/vdny/UWaJWT2UANWJ7aeYPe4gKOnkowf?=
 =?us-ascii?Q?d3C/fKhtpsrj0JI8iNwYWD5hIZmh055tJj2crM+00DYn7REX+YRyBWxv5040?=
 =?us-ascii?Q?vzoaD6ucRF3k3OOlH1R0orouCzrDJ7DqugYbEmQNwE8z6sBeKma5+ra2EWhm?=
 =?us-ascii?Q?R+4f4NjLCW2qu4ak2wKM8iyGKEoJUoOe6NX+QqO4COwfNHREH2PSRQTh2tpA?=
 =?us-ascii?Q?lyO8a3rfKjvgrVkgWfQI7ayih6Tn5wthBWdtKyDn617lx9tLcmC270buYd7X?=
 =?us-ascii?Q?tmOMFyKPpecLyL0nZJWRCEJPkUVvu+ZXjAH6V66hS8uhUIRunHYgpzNuQT1V?=
 =?us-ascii?Q?xleSIC0tOCZHNNBosrBkCyDFku7ASj0CStACtHAEVKnq3AlvZL6oh9P6zd+D?=
 =?us-ascii?Q?GKtWIqNZMzcxK+3MCH4lJ3mEa4D2m94SrzeuZzqBOgPNN+ZX92wXredBA/vC?=
 =?us-ascii?Q?Do3Lax+l+UrTDBdIUNsXKDTSG4oZ3qsnmVf6xv81A8Fl/9j0C7OAdT+96e+7?=
 =?us-ascii?Q?gBjYeMDQ2vLUJ+H50IIT31qSrgTd70slmQJpoYsG0efYjjNZt4TcJAtN/MJH?=
 =?us-ascii?Q?JbUuDa6Q7auke2ZdK6fczZjZd0Umli+yik8EZR3dmFRSiRac3K4NJ9TVExQN?=
 =?us-ascii?Q?qe5Q5e2J8FpxcEvujkJEcdGZdaZ7yO4jwmgwLWSQUCARVnefLZsLlkcOePL1?=
 =?us-ascii?Q?zWwkjc9L3MPrP/KAQ6akieZXbw8b5l87MTKtEG28ofIxUQ/09CdgzAmcwYcl?=
 =?us-ascii?Q?qeHo5f55SeZTlxvdDQDHid5154SGiLW+pgvbMXF+7dykd1Tt8pCok1KQ12ku?=
 =?us-ascii?Q?8y0cwtEvkVWBwrtfnUiyGwIWksL9ZVfISVH5aKdV7AiNanN1zhuwmBFmtYqY?=
 =?us-ascii?Q?lmZm0D/sBBjVnGka7bF5+bmc+lsYm0vgTpfosDYXVKcrJaGzEmv90LdqgOQg?=
 =?us-ascii?Q?9NykBQ9HavivvEiI4+uXvbwlWIV4JTEzhY6Y9FWs9Ijcw5s7+cMmleCa8Lt4?=
 =?us-ascii?Q?Egc5RalxlSJD1Q+6PqP/Q08obPv8w64xqvFeeGUp/FHMwvvmevYIJ1TdqIL2?=
 =?us-ascii?Q?sfmWHGs99qAu0/bX9fkyCZ6jRV6NUOcpnDuqKs6y94BXuZWqYBuJ9CZkmCXj?=
 =?us-ascii?Q?yg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	F4HbgbiP887jhOv6XWBP+9NPdhRGJjEzpC++U56pSxYPt+cV1tsx20/7t7NtIWSjCb3I6CdAwPZ7IiBQQAFD+2huGHUVRvfnsJsrDfTFhwmM77owTGFEWiEvVjQ7hRu78a88fo622njsRQeNfY8AKP09ogLkBCSyb86jA23MWO+zyLGOgzpZ0Km97ECC80QMjqEs327y43TBQ520d/VipTK17HoL8b5zashXEpy4OD1R0FbaMoD95qe4y02DK9jBW4qsSsuY6f9JS3fOZr9qebP4GoNCyqcD9z5WmQVfsg+G/5/hvPSYACX9YkCAw7dcN50m1M7QIKr/+v8/J5WYPb3luCvol96K10SFptNcZ+Ww3P/nG0h6gwqeUM/BRi2pIr+1/w/Kq8i6NUe8ZiYJreTv55/giDEk8cYe311phuA5TdcLCGaukb6BVa3Os9Jbr6MN6/njnX16C2r+KQfdmqy5KVwOJMNK4DB5NSrjynQxnmnB6BQVZ8VlzvyHLZxXtDeSuv410FsAklBaWB7hqjuojoRyUOrwPLMEWgEBCcAQ0m/LRCkfWwmpR8rnb5t7uO/3qcHA7zqatv0Hgg8sEYrwt5D8R7oM/Xo1BoQ+qys=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90001cd9-b3c1-4b27-7998-08dde63ecb07
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 14:25:52.5800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WqgQDKIp8jhpZovbKO3STLAmPbLMklbajvhCetbd1d0C286uOo9D99BmWfUycVuDqU5415I25j+nUqWvpBMxDojRFvSnwrFU6RIO4gRKZC0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7596
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508280121
X-Proofpoint-GUID: Tkj6-kHL8pTa5Xeup3tpDpCnQBfdu2n1
X-Proofpoint-ORIG-GUID: Tkj6-kHL8pTa5Xeup3tpDpCnQBfdu2n1
X-Authority-Analysis: v=2.4 cv=NrLRc9dJ c=1 sm=1 tr=0 ts=68b066f8 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
 a=QyXUC8HyAAAA:8 a=yPCof4ZbAAAA:8 a=8nvh8GlS9YkaXg_skGUA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAzNSBTYWx0ZWRfX4xJzx3smPoHL
 m37rwjn6T0U2YsOISwnFN85jYkwjUP9qU7mfIC2mROHL+ej800qt2ILXovMkqUm1lXdLf82W7vH
 Sk1MtSF1Tb+LloG/udAgOXEdpmWnSccSNQazBC7KURD7usrFgLkBWERorIT2qaZiWNGrEygebwD
 33nPerpNDzS0CnJF5pwF8o9OiPBu7xvc9/Zohwxv8tQ/hVHKtzd9qVn7KOnl89A4Yc8yyeUTy/b
 Pb9ijtNK1ZcXL9klpcwRPzWlsIQr9v8nL61GK0q6Y3Xw2YixyIPKQ5AHwwDs35tvRUaXYtdHf8k
 hNtzduRVsVUAOuuSIwKOIh+YA/NcWzVPM5jsO8nGDuG1C1VBdmJ2MppeekjKPY2HoZA6We8GfeW
 4SN11BWh

On Thu, Aug 28, 2025 at 12:01:08AM +0200, David Hildenbrand wrote:
> Now handled by the core automatically once SPARSEMEM_VMEMMAP_ENABLE
> is selected.
>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

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

