Return-Path: <io-uring+bounces-9475-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6299AB3BF12
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 17:21:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B0F9216D350
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 15:21:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91CCB322C63;
	Fri, 29 Aug 2025 15:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kDcHY6VP";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="l6gg32ah"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B896C314B82;
	Fri, 29 Aug 2025 15:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756480875; cv=fail; b=vF0RvhrcMSFRNRIzrZsVUuIZKhURuEIi9tIebssaYLrtrolVjNxZS4ScZKINP2e1VcIICGL+V0WR9l9f1L/LuhHfUe0nsGYXKBmDNAucgl40MMQHX8kBb191hJATdFWaZZSEHG/3NfN0vuaqpcBK0wOjEktwi1sCcKSM3moBPt0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756480875; c=relaxed/simple;
	bh=RchDma/6ZXQ93oR9FwEd1N30TfO3J5r6ZikZT/Z6c3U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=YJyShau1Y3j5SpK4YvJnNh45Ip155cFq85HJMF1/ZnBbzey6SP4XYPZ0VQ2WlD8JPmLa3oNdz2EzNzlGJd1s9unnmQqtnLUn4ZXiA2ztV3UUgmUlNfTancYEsc6AGtRGRC4YCm1hgf9gV20HqGYcextyYNRY6CWNYpZ5dNC1JKo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kDcHY6VP; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=l6gg32ah; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57TEu3ud025034;
	Fri, 29 Aug 2025 15:20:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=/8Wdl+tIRENNwPyvXp
	ggQVYfdKbMAHKO4ptq2zrin1M=; b=kDcHY6VPsU4XZKf7pQfqw2pMqEU2+Lyxpy
	5OMzO1S+Mm80V4I7Jdoy2CjhzvU2KmeKFBuPoYb3zm2yDD0jm9MTDBOxw/JM3ATA
	dJPTbMuGLyT0RL/Oot8/HDX4Y3rafWGseztC8/C9A9Xy/IWdsUbK5RVyU7eYuNZW
	7ml5zePfABuuUZrVLlU3g/dKt78kBl+D32E0pG/ovP28sJIMrlrV2xRHPx2wA2FZ
	dAXUYwv4lq7q6ZYGIMNHVsoy3vxdgjq6FbcwHiNwfn2pEYJY4oAUWUuiLgeb7zFj
	OQzOs9O3EorIM3+XjercTDDb/wyTUq+WLmaCFfqzJeKkbBRFkxsQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q5ptawfu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 15:20:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57TDaSoA027035;
	Fri, 29 Aug 2025 15:20:00 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2078.outbound.protection.outlook.com [40.107.237.78])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43d44pg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 15:20:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ceWDDGaxLoKTat1IldSxboVs84hlCrCqRZcu6Jz1oIgL3Scc8A6pPer8BFasl5r/HsVl6CQG0ryRjKOsv00k4yK85yQuho6uDfAVmEnfYyyXIaubTlbhFhXQsluA+FZTIQ81J/A6HKqwegMfjZlzrejlct6TM57sACrNuARQJxl/RQjSUo/EXOVXlDHXV8ti+IgfSMhH6A1RjFrXXGI5tbEp/Gq0xTBU7aBhIZXAVjOAjzEb27a4YL2A68MCNAs08WFZlUXwePTA4AxnxiQKEgb7wJMhxHO7Xjun87B2AdpeqgVfiV+lLMArA4HiMD3CWoRZVNKnOP3J1I1kRiwMmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/8Wdl+tIRENNwPyvXpggQVYfdKbMAHKO4ptq2zrin1M=;
 b=hIbPF+q/HdN9rQQAkb/LPGTy2Mnxa2sK8MFS1sOizNoPVvFRK4dv9PQc5f7c2bHl6AAWhO+CgXAfVckcHO4/1b7xWLPWWWsu4czbF6b1sPfzgFIDQthxw5gmqHRD9JAvD/uBqK9yHkd4/wUpfSHPYmfrUQ/CsE9HFTuk6/bgObNfbOlTLdZbY9gTnXhYJA5/+VAE7u09ZHVZtyLK5xVw7jsFVkR9TBA+mxtnV5zlwbSvgIgr3VjeTnFDYzg1QIXEv07RNpO6bLIhTtj/3iKY81xOL6UE30JekgLZvbzrl0HbjQxnu8p7lAKIfAOGQJ6u3VQw5VpZ/Ocx0NbAYBDxrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/8Wdl+tIRENNwPyvXpggQVYfdKbMAHKO4ptq2zrin1M=;
 b=l6gg32ahgLXBhxF1xEUzEdWR1rFm1xMXSsi68BlxME/llIoUFziVrmudMBcz11ewWPtvvqKbJb6cNpzeDJJ2U4HCePw1ziNpEmItMlxR4gyFbWkSEiZpVIM/PBIGbo8PYP+wOJE21OEPveGSSgDPFPFGyET50ATNWCGNMxrQoJo=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CY8PR10MB6609.namprd10.prod.outlook.com (2603:10b6:930:57::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Fri, 29 Aug
 2025 15:19:52 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Fri, 29 Aug 2025
 15:19:52 +0000
Date: Fri, 29 Aug 2025 16:19:49 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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
Subject: Re: [PATCH v1 18/36] mm/gup: drop nth_page() usage within folio when
 recording subpages
Message-ID: <8a26ae97-9a78-4db5-be98-9c1f6e4fb403@lucifer.local>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-19-david@redhat.com>
 <c0dadc4f-6415-4818-a319-e3e15ff47a24@lucifer.local>
 <632fea32-28aa-4993-9eff-99fc291c64f2@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <632fea32-28aa-4993-9eff-99fc291c64f2@redhat.com>
X-ClientProxiedBy: LO3P123CA0012.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:ba::17) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CY8PR10MB6609:EE_
X-MS-Office365-Filtering-Correlation-Id: 1581d4ba-4cbe-47b6-2739-08dde70f809e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?r/UFyrKH1pOjSoj447o4N4TxZ20Yt77+wuSknVeL06NYG7I6lWuvau+WIYnH?=
 =?us-ascii?Q?XTTsalHmTv5t8kdgANb5Xk3tS2fOZboThLFofA59X3C+Hza4FRiebB2p8nQa?=
 =?us-ascii?Q?kTaUbnfMWmGGcy2pS8ckYdGqGmkufCQ7w4TEnPpUXRbkfWJ3KpWmoR09yw8Z?=
 =?us-ascii?Q?OXZP09Sr+OzbQH3o3V+bHVpUYw3pDvDtwBsSlyRD/tEG3REmAXC2FJAW9PVV?=
 =?us-ascii?Q?2bHDmZ/omglENDFSitf2lvztYZTfx7SGesz2MVQeX5nu7ccz+qZbhwRQ9zN7?=
 =?us-ascii?Q?fC2800gp8rt722J5JweUCOrcPla81O7uyBdJBdYqYXV5eswkkEizW1YpbxkU?=
 =?us-ascii?Q?JXdjOUsmtDniHC8pjSU4Pd6GChmhRK2vfH4w0dgBp39oLn3QWCm6n5oZxaN3?=
 =?us-ascii?Q?DOZTz0bGDC5X9sN7GfesYG6M4JjoFoQ4x95zg0xZ3/TF03f8e7YnunLP7SA1?=
 =?us-ascii?Q?s8eczcEG2z7gGHDBfcSHnO1SKw6+KPBylTGof9cuJtqNjuwB1Q8BPIcRD/8t?=
 =?us-ascii?Q?DoeJFGxF5XXXNdEs0xJT90r483pdcQS0Q195XX+bSonnMbFFSD/ckUHuHXkz?=
 =?us-ascii?Q?jihZcB02OtXPWDen8tqruroWHdGCgTeD+pB0cmik+/3/kIB9pNXxvesbGvYT?=
 =?us-ascii?Q?f/HU2NSmNIH2xhgLR/qQ9rah8uQIzalHN6S5zFWi4HKD6cFVuGaVlmNLc06B?=
 =?us-ascii?Q?dU0CXab+WeUfDQlz6hDSTZnpy/QHxjR7DfsoT+9gWYwqcQ4WEjRTkiDECvb2?=
 =?us-ascii?Q?CtnCRIgC6Vd0qaORj8K8LWWqDx1tnm6VDmIHaKrgAouY6lxmmfAiSv62jezq?=
 =?us-ascii?Q?e0nmEcRlYz+qZEPojLBNsa6tWnXmW7vqdkMKQgyUIa/Ez5w6f4ON9Q6QgEo0?=
 =?us-ascii?Q?WAhC/irgTrNYirdu5d+MMa/LAWWoHXhpdtIJextLXy9wxGDnBkAmuui94XFG?=
 =?us-ascii?Q?8u+D7VGtuoZedq9skuqY7I6G1Wee+axADtZhI6vMZUkUDsGeHEI5EwQYoE4L?=
 =?us-ascii?Q?zX155SKklnS5A9iHXpbmH5vOAeUlRI4M+9XdviFzjkmxt6dX6gxqjUncyroL?=
 =?us-ascii?Q?NqZr8QjktKth+E0R0s7WGOIo9b5O4weuEpSLiwY5SLvDIqi4Xd3vmB91DtkQ?=
 =?us-ascii?Q?+aMf3m10+B3rc398Ub7Bxhgov6y2SRK98t16cuynDq/N71AN/0orX/m+W9rl?=
 =?us-ascii?Q?z3BSYjwepHN7LxJchaLW4EY7aX/Qvl9KeiTmUrXI9VPirjpY2p63DzRGhq02?=
 =?us-ascii?Q?7YHKm54uCrqhWaeKurPF8kduG8fd4S6SnKNls+9YK67wo8ZEZg0hmWZ8UOwc?=
 =?us-ascii?Q?ZATI1QRZSfiSJaVzqAKMOD3TqFPsCozgiRu79OzF2GKZADAW1gARSqmH24sk?=
 =?us-ascii?Q?NXBBy3MpboF2rCymLWZbFV1su7P5PYBvRO1eqMmVL/SSdDBF4Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yMeEvCaehRDdlFr2in2MUkFMAy4CC0xvtpIan5eEp9Jy/wRJ2qGo5pIAsL8a?=
 =?us-ascii?Q?9kFFEMjX6OLc1Jg8eM/ADyuC3WX61gtEy4aFXTahMB7sec/3xpCERb6Ocb6C?=
 =?us-ascii?Q?mabP/2e3vZ5wT4C1clxjmNbjFjDXGOFWBYOCMWGYtCKrIGgq9LnPz+AwOD/j?=
 =?us-ascii?Q?C9qSZR6YFc243AgK6UG3B33jaOpmSf855lK7s5xDF6Vvyt7bM35Hx0dHSCvE?=
 =?us-ascii?Q?rFRYh8hMI+0winIFwguJEsWt3kWxEEmQXQly61OobzLxIqYi4g0xvs1JD9G/?=
 =?us-ascii?Q?3v7fE/nfufdQWjxYqrfSAfCTiqL7uwEPxID9vkuZMjq5m07KxH+JmcHn7qFW?=
 =?us-ascii?Q?Xmym2SDuQfwozG+3Y21pbNZ+cR4Ce/7hI3qXLxd3K3F4ihCgPCRAOENa2WL/?=
 =?us-ascii?Q?bCz7PIg4LwRendU8W3dA8fjQjscKX2DrPK2lCxJwQvhyGUm11tQURdnGagYg?=
 =?us-ascii?Q?AfHDXvKnX+w0qYzcCyCh6dz4+RlQDLv7BnuAw2BD2CM8QWQAKgzW/4mgIMl0?=
 =?us-ascii?Q?ttzsuKUsxRdhyTevs2Rutbd/R42auwzhWvU2BVuouuivyyp4hAOQ1mr7Mmyp?=
 =?us-ascii?Q?9dxyrX9TT3ENAjWBVQpWhrA9AC6mBUDY4m/Dn9l09m2epl6c8y0NqwRxWrIJ?=
 =?us-ascii?Q?9CddN/k0MKm6lB8deLi8FpW2jVqXJgq0tkBMCuWX7f+HuwjB5AbiftyhEeEo?=
 =?us-ascii?Q?GT3lLXsJFotHjUvykpX4JD2CIYT5BkvKRJ29WBe3TGgOwOHZik9djTJv5XXZ?=
 =?us-ascii?Q?/ak9fh5fF+y6l9fqPno+cB/6dn+/fb0YTOY/3QMKLVXh1DZSYfhHaXtDHFhw?=
 =?us-ascii?Q?edUqWcSCokhwylyCsWMHcRfl7r0FgjK8gDl8u4KZptZdWgWWFHuZQGnahbak?=
 =?us-ascii?Q?pF9VqXtTP/coDMmGgoh/Pc7AHYLtrIX6rbapcobaubdee5MKFOs9M5Xepsj8?=
 =?us-ascii?Q?gvY5HrQAAXLRoQ9Zp9JgEGdKafduDBp0D7gQI68oHQJ/5CJLq4TGdFeDCZRw?=
 =?us-ascii?Q?mIHA8qpFQxSRAd4icZPVyjRhZFQcaYhvqeIfAP+FNsDzbTMOO+jOgJy7pLXJ?=
 =?us-ascii?Q?GxRiUD8vf9HHpwoysbnITBNIOUC14IvqmK3U+GcNWMbanqZ8w9GP0Ardw5FD?=
 =?us-ascii?Q?9+FKs5Pufl8A+maVHqSTV+9rhvrtfrbxJmnFdCQtaFXw0IVpvUZQJ87XYOn3?=
 =?us-ascii?Q?h1OkrdIvjckQ4Oy6slEgfYEbU8OhbP4bOBvC6AMWala8Z2ZsCXBQR1lEYHbk?=
 =?us-ascii?Q?u2MFhEHJqfkYe1JGfS72pMcS8LCF0yJ15CdPx9BCyNGKmSilT60iO1g5gQgC?=
 =?us-ascii?Q?Q/lgAU2rkH1LhZrmRdrmRIxkJ4tYZgA0HrPt0uB1P3nvIoDJkRgeYCz+jZdC?=
 =?us-ascii?Q?5x1Ojoqwnj4RCOP7l+pyRDYPp18cJxrQfZxfAHQLZVOUMPirroSNGp1yJu8j?=
 =?us-ascii?Q?KekVpzfd9PQuVVFCESTeH/SEEkOtwiF4U6yyyPYqYzyF173Xn0HU4Ae/HC0l?=
 =?us-ascii?Q?/2Fr7jEznh0ujc1NFnq4LH/cFQ4LhjKxWUIkgS9esLmqnOtdoJ58LRjXrkfC?=
 =?us-ascii?Q?QL6KDKOpKVgidRKPrd1hu470syaTfoTYbA90Sr41qgpW2zrKxPel6rXB3sRl?=
 =?us-ascii?Q?jw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6caG3aH7lVEHtGeLn9kTAgsWWRPtEorvhnJ9CWvETCeQteSA2eH5kuKEdbHubtmPUzHAEKigfGnE2iRa8HhiMnQvDfG2lOQpV7lpfhzF3jg64Kuj3TmCpYCz/cdnwHLelG/SGMhTBKcEzzT3hTidrcFP1e1Yoa5arYdqB8CNwDbIYzlNx1lZKL8sFza0rc8oELBKjMJFXz2qTQ4boZC1vyNJrwqIwMbCWCn6a1h0nWQSKmUL4i9qS2BQf3tULdveMxBDoJAkRFsFQo4C0Fj/ChwcQgBpYNGGPZjtn5QYrcbmiyrcElV7Wx6BvAQjJRyZefC1mtVYkq7SsdQlUk5ZlDWGLuSl81nb7qBJxye5vTXQEGJyBLql3fLsXlmE7aVBOcu3W7KjCaL6ts648vmZKsIehDGlhgrffUAomkrYrLv6PwzxR+etTroRAjnZkJFDAmeG7kSKm63NIc97uRXywp9U9IpOByjnB7s8bDmXm8wGvSI7ImHghlBLtyKOyZxqt10EV3jmTBpsDcx6qyCXNlsG5MEiBYNxj41wEop0+owbOWF8BRieIEe5LIvTXq99JiX55BimSkRdI9eEwQv/UbDi27ZSxzFY0VbaiUISN8E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1581d4ba-4cbe-47b6-2739-08dde70f809e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 15:19:52.5499
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JKY8HW/+eGEWXwEvmEMbiIoaYqvIEJFmP/0AMUrI0rlLe6rMq3Wiae6qoLT6OBVHmpIwvtV3nu38GcsAKLA51kkgTeRHyI5q1EVYkVD5LvU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6609
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-29_05,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508290131
X-Proofpoint-ORIG-GUID: 9mqwbTOysmSj1PF-Vt1qH8pzf05R0pme
X-Proofpoint-GUID: 9mqwbTOysmSj1PF-Vt1qH8pzf05R0pme
X-Authority-Analysis: v=2.4 cv=EcXIQOmC c=1 sm=1 tr=0 ts=68b1c522 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
 a=DlHhZv4coUNNdZr_9G8A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAzMCBTYWx0ZWRfX1NpIuEdXDIxu
 pT1ey33FJpUg5uQJRSkqKMPS3wfv8nMB42ZsL8BMvDbgcUdRcDKHSwKK0hQYjUJGa3ove4qkKtn
 JTOq9ffTS1o0dDwA9Swt4lkz3eVZ1yTVuWOdViId7dAtvOT2llk6t/HnnULDOUjooCYe86BjYdT
 WpR6w+g3O9cenMfUa9F7FxhVNeqNMv4xNvFS6q6tf/lmoi3eArY++TYeIN51gtCEiafPMUEd2ZT
 JLKK7khEZVnPjUGsF/F6A3wDsX+1Q4bFSRf0HwuStXd3/tAywaIkfSwMCNSrcmVMeJhNq4um17f
 3A6yh8AM1YCyfjK6stJHQzaDrr7h5uoO6wl7WOgUp7z6rv0o4KgGa7aSA+DgC9Q6VLSrHv93VUw
 lZG0e13J

On Fri, Aug 29, 2025 at 03:41:40PM +0200, David Hildenbrand wrote:
> On 28.08.25 18:37, Lorenzo Stoakes wrote:
> > On Thu, Aug 28, 2025 at 12:01:22AM +0200, David Hildenbrand wrote:
> > > nth_page() is no longer required when iterating over pages within a
> > > single folio, so let's just drop it when recording subpages.
> > >
> > > Signed-off-by: David Hildenbrand <david@redhat.com>
> >
> > This looks correct to me, so notwithtsanding suggestion below, LGTM and:
> >
> > Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> >
> > > ---
> > >   mm/gup.c | 7 +++----
> > >   1 file changed, 3 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/mm/gup.c b/mm/gup.c
> > > index b2a78f0291273..89ca0813791ab 100644
> > > --- a/mm/gup.c
> > > +++ b/mm/gup.c
> > > @@ -488,12 +488,11 @@ static int record_subpages(struct page *page, unsigned long sz,
> > >   			   unsigned long addr, unsigned long end,
> > >   			   struct page **pages)
> > >   {
> > > -	struct page *start_page;
> > >   	int nr;
> > >
> > > -	start_page = nth_page(page, (addr & (sz - 1)) >> PAGE_SHIFT);
> > > +	page += (addr & (sz - 1)) >> PAGE_SHIFT;
> > >   	for (nr = 0; addr != end; nr++, addr += PAGE_SIZE)
> > > -		pages[nr] = nth_page(start_page, nr);
> > > +		pages[nr] = page++;
> >
> >
> > This is really nice, but I wonder if (while we're here) we can't be even
> > more clear as to what's going on here, e.g.:
> >
> > static int record_subpages(struct page *page, unsigned long sz,
> > 			   unsigned long addr, unsigned long end,
> > 			   struct page **pages)
> > {
> > 	size_t offset_in_folio = (addr & (sz - 1)) >> PAGE_SHIFT;
> > 	struct page *subpage = page + offset_in_folio;
> >
> > 	for (; addr != end; addr += PAGE_SIZE)
> > 		*pages++ = subpage++;
> >
> > 	return nr;
> > }
> >
> > Or some variant of that with the masking stuff self-documented.
>
> What about the following cleanup on top:
>
>
> diff --git a/mm/gup.c b/mm/gup.c
> index 89ca0813791ab..5a72a135ec70b 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -484,19 +484,6 @@ static inline void mm_set_has_pinned_flag(struct mm_struct *mm)
>  #ifdef CONFIG_MMU
>  #ifdef CONFIG_HAVE_GUP_FAST
> -static int record_subpages(struct page *page, unsigned long sz,
> -                          unsigned long addr, unsigned long end,
> -                          struct page **pages)
> -{
> -       int nr;
> -
> -       page += (addr & (sz - 1)) >> PAGE_SHIFT;
> -       for (nr = 0; addr != end; nr++, addr += PAGE_SIZE)
> -               pages[nr] = page++;
> -
> -       return nr;
> -}
> -
>  /**
>   * try_grab_folio_fast() - Attempt to get or pin a folio in fast path.
>   * @page:  pointer to page to be grabbed
> @@ -2963,8 +2950,8 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
>         if (pmd_special(orig))
>                 return 0;
> -       page = pmd_page(orig);
> -       refs = record_subpages(page, PMD_SIZE, addr, end, pages + *nr);
> +       refs = (end - addr) >> PAGE_SHIFT;
> +       page = pmd_page(orig) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);

Ah I see we use page_folio() in try_grab_folio_fast() so this being within PMD is ok.

>         folio = try_grab_folio_fast(page, refs, flags);
>         if (!folio)
> @@ -2985,6 +2972,8 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
>         }
>         *nr += refs;
> +       for (; refs; refs--)
> +               *(pages++) = page++;
>         folio_set_referenced(folio);
>         return 1;
>  }
> @@ -3003,8 +2992,8 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
>         if (pud_special(orig))
>                 return 0;
> -       page = pud_page(orig);
> -       refs = record_subpages(page, PUD_SIZE, addr, end, pages + *nr);
> +       refs = (end - addr) >> PAGE_SHIFT;
> +       page = pud_page(orig) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
>         folio = try_grab_folio_fast(page, refs, flags);
>         if (!folio)
> @@ -3026,6 +3015,8 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
>         }
>         *nr += refs;
> +       for (; refs; refs--)
> +               *(pages++) = page++;
>         folio_set_referenced(folio);
>         return 1;
>  }
>
>
> The nice thing is that we only record pages in the array if they actually passed our tests.

Yeah that's nice actually.

This is fine (not the meme :P)

So yes let's do this!

>
>
> --
> Cheers
>
> David / dhildenb
>

Cheers, Lorenzo

