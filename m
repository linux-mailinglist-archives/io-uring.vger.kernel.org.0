Return-Path: <io-uring+bounces-9473-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A51FB3BEC0
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 17:00:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5737EA409B2
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 15:00:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D542E321F39;
	Fri, 29 Aug 2025 15:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ewkOTcT0";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="u7ws3C90"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E59031B13D;
	Fri, 29 Aug 2025 15:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756479607; cv=fail; b=nWKhw142QI3JmOjgv9QBWWGS35Cpb02I9eVPhKFmUIbzz6ptnmBGLy4jOLSh5KQEZmrGcqyPNNid8M0ehtUXeLJ++ZLBZQkRmBVNYkjKV0vjQGUXs+oYs1d+j4KCHVGvq2iZmVLoqMw9wTmc7oJVM4+bTfYf4O1Nqp8ISpevdY8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756479607; c=relaxed/simple;
	bh=/kU/2CktRxFb62Txrm6pPzDDN2dFpwRrohKNTEs/1z8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=VYlgd2qbROzxs6F/q1+r7qpMEVzIJbc+1mxngy7HkYK2rahEYDj7f1JtJoYZ+1o5nlmvsCeoqvxVsCfKAdaiFAjzbo8FIXIoVsu41jHGOCIdBG1joCVvSHM9PKIe7WnTYFrE4JgNHsqQm6NtLTivFLz97q21stJ1YtaOlJhlJFc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ewkOTcT0; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=u7ws3C90; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57TEuE4E007022;
	Fri, 29 Aug 2025 14:59:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=DKkmy55KzWdh6vlxLJ
	GJ2o+sAoN18fovhpyhpKs6M5Q=; b=ewkOTcT0sdAoy3d/RCDicS/hjzk8QpfS3C
	6qI3nNoap6CjD4Kh1N5FgUftJvzHo/Oiium/AQL0F7mD/B3ZI2Orm6A81/qGi818
	29nsNVD0lwDQId7ciGFK19P7aa2V2EO42ERzF7bFR+gTKGgzXmo6erMXLB3K/CmN
	qryTGiw3JJnEPqEGcbGI/Rszl1xwnJ2T2PPsndUQ4vgBuZgd7DKsazKKKGmfdVtf
	Gf2rP2hpMPvfgEqS+a1DrUURmoRKmrxFZOFShTdREMDw+qAcAz0MPvdRXtkqxqu9
	SyE3pDlPZaTLeBRh7j9KZ1yKq935b345GwfMS5pqyBeT/5BT59XA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q4e2asuy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 14:59:27 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57TEKu3J018954;
	Fri, 29 Aug 2025 14:59:26 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2064.outbound.protection.outlook.com [40.107.223.64])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43dawh2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 14:59:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YwrMcubHPX7kHcygubVTpmLo7L+diANz/eUpbmyW5BjbReqplwtCM/GmBuljs+tNr6Cao2APqd5ryUw0UX5Nj+3sCojs5ivFbJ3qgGBKehaek/PVoNBGM/rHkF4iFmWEQA8/16fETfMTJQB/6vcPPstTVPxzbgXM0S91UCB0MEwy5OInv5pPxpeM14jr9xZrvn+dYc0HHiGMS0AnOSyl2mgZaeUhINyX93HBxmwuzrdMISDMRtW/nism4jiv2LXj6kaTlc1MHIbJVMtut1xL91LmeO+TMGZqH7Uf3k2iRPfIkembXAI2llmr8GAyA9bnNdW7c8XfJ2ZtgXxBpyWEzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DKkmy55KzWdh6vlxLJGJ2o+sAoN18fovhpyhpKs6M5Q=;
 b=LltSKK/9lJ3lwMW/AfecPqec3RQjc7tqr1ph35w3qXE4Rr0OrORQz0T1ISdmkehqzPHgme79JllZwIryaZhIhjYDNLNSb6Hb5WL5a+bBJH8pZcOXnpCbVzdvKdtJQVJirzzcVjSr/z6dKZD5++8+03OT7dU+21NXg1OLXHijQSOFgg5KIv5FJKACEbe04hIyoRkrtwwkjOerylKq5UU+Xk8Shf+NA7A6LmFTpRY+QvUeNwKJCTVX+u5lUcVoMWUDmdxEe1xPkIJA2rKiyKMBa0qbZEtXQtdCELNXGidRLH3eEKrFRljFBBtHEMRvt5GO6JtBa4cTR9UT/uD+ZGLngg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DKkmy55KzWdh6vlxLJGJ2o+sAoN18fovhpyhpKs6M5Q=;
 b=u7ws3C90FnPCN+JMcqLI1HGxuAFylkPhgxUerpX5V19PRy5UHid3AdRb5UERSMzVMoP8bZStiyZlWDyha7E0IZ5Om3g57FTpwD61nlm1Uyj9gpgepQych2h0sFR5DoeuHFHnIwIs6msOUoBOT6f0IYdjUf55MvOxmOQ7DrnIisY=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by IA1PR10MB5995.namprd10.prod.outlook.com (2603:10b6:208:3ed::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.17; Fri, 29 Aug
 2025 14:59:15 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9052.019; Fri, 29 Aug 2025
 14:59:15 +0000
Date: Fri, 29 Aug 2025 10:59:09 -0400
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
Subject: Re: [PATCH v1 14/36] mm/mm/percpu-km: drop nth_page() usage within
 single allocation
Message-ID: <2vgbxodabnlvacqoiythb2jsvgp3mhgvkv6od4t6nw4unauhc3@vwqvplaiqk5f>
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
 <20250827220141.262669-15-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-15-david@redhat.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4PR01CA0166.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ac::27) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|IA1PR10MB5995:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e1cb910-dca1-47a5-5481-08dde70c9f23
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?r1pDy6tH3cTTJbptfckk/+WWxRtshZq+ThYUAfW5Ge7EUWIzfJNnZfyo3ZJs?=
 =?us-ascii?Q?k2clpRkT+W2HXtRFseI4B1KjvxChqvY4kh2GBO/fMvqjpGYol8TnPkrp3JAB?=
 =?us-ascii?Q?WBK7lsLI/lYsyDu1TXu1xLIE3uErz/oOFLgAuGw9e1KE96czZ/uPjvLR0Iy9?=
 =?us-ascii?Q?TYenC9p/WT6rsoaV/nUHqqqqBncbKI48vW9pRgZPumpAai8C6+RtLZ02Lhl8?=
 =?us-ascii?Q?j3W0fTvcL6A3LXYVf56E54fbclUQ0rd2Mo42G04ITldy/1DhDUQdquGOiTCy?=
 =?us-ascii?Q?lZzl1rF/ESXFRfYcnfs/RKl4liZKUowf5yWCV9n27Lc/Cc496BuDYYqVCesQ?=
 =?us-ascii?Q?8d5z1sgSK1rP1kd/1NbeQcJC66AoDi0mO9hShazGQGj9OilXmML32tI545Nx?=
 =?us-ascii?Q?hB3MDC6YFeYob1cHafa+vjmRiAMbIuGJhuNxcp11aAd8DhsChanGV0LKUf+Q?=
 =?us-ascii?Q?M6BgbcD6kXZlTth/X3WPrKRMsZgnBvLZFwLoeLTbfSwz+FfEqjvK7/BnQXlZ?=
 =?us-ascii?Q?RRgtkrajpNCHP4ykPnh7ctdDy5njjHRByrFa2QX9K3ex4t2Kp7s/6rs/4DzJ?=
 =?us-ascii?Q?v+0yEWTPecJcTfgyF/zUJcBTT/XjCZIXHV//BOYsOKBtUsQgthQORzkO9UV6?=
 =?us-ascii?Q?/mSAae4KqPZdP9zoIdRBxA8419BfzDWj3Vx6zeVEhZAlKOz1ChgmXw2+oCoi?=
 =?us-ascii?Q?ihoP5dbtn/ZvIVcNXkxL64KL+Z0kC8DcupcFyKLcKE/3LXYgYhharcfwaDN/?=
 =?us-ascii?Q?DVJdCcGUMxFVpR5fs5v5Uj99p97Vo1+vcAMFyEGufu/CF9psLDlbLsmqql45?=
 =?us-ascii?Q?HnAaf/Iy6fgFnJMx6zN2/18D08Qfb6fHR/d9+FLxKJapmW5JjeFIDcTesx93?=
 =?us-ascii?Q?tlfEajdK6UBAZ/EUnhme0kcB7qBYWVa+waECmhE2sXaLbDPuQyV+H7AQ5lST?=
 =?us-ascii?Q?Vqj2Q41Mv7Av+qNgmyJv/VTUKXN+ziQb3J9EI/GFtRP/T0bmxP10bYRIRyVo?=
 =?us-ascii?Q?8xRGAhYa51ZRthKADvrTXNE6q692bxKcYVTqYqkjEdhh4yNppxgRDTJAC+qO?=
 =?us-ascii?Q?kpI9l/DCinw3hUe+eN2SUSWzmyv2XRKmeCa9h64fADKjSAIJ68wKy4Jf9JFI?=
 =?us-ascii?Q?rx8QeqROZPkrEgaMYO4UAYD549DW0X+tmpT3VPwqtJutQLtORruhCcEGRN2X?=
 =?us-ascii?Q?nfzlIB4tdszLYXz0OTypF//5txplBI52YdQ4mW3XfgbsWoCGHqQUTjSSdDjP?=
 =?us-ascii?Q?LnERUh3SNSlLNKFC9iXFQhc1gUSUr1wXm8ZsQRFMFI9H0Ht4QnuutgQJWQFh?=
 =?us-ascii?Q?d6gvitLQ4Kgtskkx+6uh1Hjh97BqBPatGcoxkEtxJR1b3iuNI/XoUmPQt5n9?=
 =?us-ascii?Q?up6hhMLeEwHzsUobsoNhP7rjEWBfnvMmihy7JkJ641yEfCdILjrZyabBhR0H?=
 =?us-ascii?Q?RNrHe5jjCao=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pSAJ3mY1IjXktnwQecBFEfS0UYXhA957a33q+RmaO3PdSniocj/YLTTXDpUI?=
 =?us-ascii?Q?LkvvVJoBQXK0sxvAo/SjkE58k3OIZMAs1HMyUjoLba5UbFVH1yabKPW9HS82?=
 =?us-ascii?Q?QgiWnm/0KI87SCi3KFTOorcXFtby2j3Ng/vdd70CKdDVlDUfuhiMxbYO5UpS?=
 =?us-ascii?Q?wT4x+7lZj9mbxCyCygRs903Sy7fLe5DyEAwI3zcz4KKrgLupujB6W0nd8BTz?=
 =?us-ascii?Q?eL98KY3EjD0ZL7jNSTk7/HSrtwxoLJF5jYLo/VnwIrrOWTbAVy3MNGHOglhQ?=
 =?us-ascii?Q?nVcx+ZgunKJfS4GESKhbu/CubPP4oWqKUmpT+1GUPl4WMvqGCwJXpTApuyWI?=
 =?us-ascii?Q?QE4aoUwy9HMAXlxKWHdpwLgEm7f8etxifdCLWBrcAeJb+QZaGPGqazMI/Cn/?=
 =?us-ascii?Q?HBbhN/BNNGPD3ZShxuwUlRjn+4sTB1MYC2vtjpv3mOqEEfFND8smuaFcNnSD?=
 =?us-ascii?Q?XsndHUxf8SDmIipZbVqBUpLRL9jH9aMqe/jFTfOnagsZE4q4Ar0uWgLDNCV5?=
 =?us-ascii?Q?1Jj7TX8hAhNkEZepxa932IqDTOsaML7yPDtyPmE8cSMAykUkU7uOvAnbwdlp?=
 =?us-ascii?Q?Drycsd/TGCkViHn0sv/kxSt+LSKlyuEWqiwvmXPRH/gjd+TzZDTRABefZ0pX?=
 =?us-ascii?Q?QPMlpMNz3P+DmVpj8vkGi3HqKVwSfA+1t6fJZmImf1QiNRn4gbqSn1079YR/?=
 =?us-ascii?Q?iNFJZucZG+NvCdmzngpSLSjf9pDijaOmOcsguVWbDWNRlF8y2T+MH2ebR5+x?=
 =?us-ascii?Q?842RHDiAAuo/RdBYUkk7eulPit93p5g+O7GFqinRCrNclVPSKUy6e3DmP+hP?=
 =?us-ascii?Q?ZZs/FcMj3mIHPs8g4oDF0LBGKjeWysR9KgpaCNvReofIc7zTuaXKRve6gdmv?=
 =?us-ascii?Q?7g3n97iG/Pp8J5xgaX0biyLW2EFW9wKnC53tR3eSovqAM4gGzkUkMiEiIkla?=
 =?us-ascii?Q?gjD71kjahYn5h7lkoOjwgV9H5yNAGjSoLnaHMymFPtD939YxkbYg2VUPpxfW?=
 =?us-ascii?Q?T9UMCZevGQkVDLoQ+IlhT6AWyfb8quAACcLsJiFGldgI8deZIbWXZUW3AU9h?=
 =?us-ascii?Q?PGSRV9uOL1Af1xp4Cb1kdGulMVAoNggeiIW6brk9/ux4AByNR9za5qFZjxou?=
 =?us-ascii?Q?gvm2ktxh0mZcEnFU7f7NtTGXi8VsFHl8G8Ii4our/IiMoApcP+Kr42IaOZnb?=
 =?us-ascii?Q?bF5JKAdDpbfApWGUibLWrqVkIybK4W5DCksIR1wE0VZ5R7Bzxoy2tXuJxfWT?=
 =?us-ascii?Q?FKq7dBikfYtuAd+VwKx4eHF7cFYmNYQrDnXV3zsatJNfXHJccqenZ1jRzu7l?=
 =?us-ascii?Q?C/fTXQcEh+62zZ5aY1SQjki+NCCS2hMlgEtAiEY1FucQ6bWVxGr0NlLPtNSt?=
 =?us-ascii?Q?OzdoI44VH20NPF1Eo3UBq+xhzqZjn46bHhKCp5GrvcCWsI4p+GonY7CXRqLW?=
 =?us-ascii?Q?o+5vFwi1ltQY0b8aaKIs7cUT812d3Wc6hPXaYh88DrpWy3nMC3PEoWlOgdxT?=
 =?us-ascii?Q?Oj3UZBDz6LZG0EQuBpX+PhGJeWASYybV9qGZeZt/RCtfmQ5Cmz2Uzt2ahTro?=
 =?us-ascii?Q?T5cDma6N63sMua/Xt4jXPFx+BkIEhzxEIuSWmv5kGXcYmu5NKLW6WYQARzjG?=
 =?us-ascii?Q?ig=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vRqCBo+Amkm0pEXTVIwrEXo2JW9D6sQQT1Hdv1H3I1OQlzbj025mQLNNNaw9SZKVkTyUnuQ9GXNCcU2kcheLvqMPS24klv+qMILsMNxqEwrimHA92yaMfcEFafbj/46t7ZLqTkaCAUOb1v7hTUsOZj4k+Xuyjl4z2YQ2YEgLQ7ISWZ2wiMh1q7oe4oBOVsLol1NABp/EMvl1peA/vgwJTb20vTToDzOwqCBfDaR69nHAlHURY9mdffDIISq2qQfo5GV3Aot5+uY1HqcbTTsALE2UEm7Cpqnk33rXRA5WPijkXAPMAo1/NcUnbqr+J4ODVqMMHoHaf1iPfDBVdOBSkq6AkYYYxXU5UQq7lZyDzIXU8+VkEQ8YDwtiB85bzpAQrkXfJj+d9XP/m2RyfLw/EvUulwFX+Jtqf+fkXbC3XgqTpTq31O7u0maNDdLpvI61dBFvNkhP3NlWJLaG1DsIyaV0V5z6fQCbkeCf/1FWHM+pBiJVoz9i2xbNFgJVGAkLsFWXOLWKqeHOzlFYx2Kc5oByrxdsFoBqww9tWbOoUh8/ZUO7aotToJ+mRrSd5w96Oc0BAADyBVUVTHr3vdyLHpaxF92s01JViQLHYeJ6vPw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e1cb910-dca1-47a5-5481-08dde70c9f23
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 14:59:15.4009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QfqW8zwzccSdmU5XGrHkWRzMjKCDk5hek3lUH1eVNddzXCaN+g0aW52Fsnp8ymQYhqzKhIeiwoyhb2SOE4sMow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5995
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-29_05,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508290127
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxNyBTYWx0ZWRfX6e1njl9/17ww
 0AaSnfYhdVQAGgeVWCd29cWk5CjR/w/cLSeiCEYP24lVX2Rg8MbcNSCYT/1b3u1/CNnj7CUET4M
 Acb8BqJ3t0jjooJbe68fUlT62h372x6LCsTkliwsXqQYG0Cjk/PvVkUpsRVG0cmPt9gk7ph6Qvr
 ze4Pb0YVJ0Y47/XxuDXFtup5MSiuXtdGdmXVXjxheZVsgSe4SZc6rqm3HhgFaKOhuL+k6g6ZL7O
 8+50bjwPWmynbEtvWn1kk0myyoOL6RMh3nOSpSDj/yUoHH76heSovQTfZXo16H/cBwQZMqKfSmy
 Beop6vj1ppODnDpnO2YcUHpoGmSUErsCpBV/gAkVyIyKc5VaD2XUF10Zs6Nz76JfODgHjK03YnU
 uo07urZF
X-Proofpoint-ORIG-GUID: lCFW6i2xfqlzLumsVnhrL0UTvuL052M9
X-Proofpoint-GUID: lCFW6i2xfqlzLumsVnhrL0UTvuL052M9
X-Authority-Analysis: v=2.4 cv=IauHWXqa c=1 sm=1 tr=0 ts=68b1c04f cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
 a=Z6Izld4-BmxqAlGXBmUA:9 a=CjuIK1q_8ugA:10

* David Hildenbrand <david@redhat.com> [250827 18:06]:
> We're allocating a higher-order page from the buddy. For these pages
> (that are guaranteed to not exceed a single memory section) there is no
> need to use nth_page().
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>

Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>


> ---
>  mm/percpu-km.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/percpu-km.c b/mm/percpu-km.c
> index fe31aa19db81a..4efa74a495cb6 100644
> --- a/mm/percpu-km.c
> +++ b/mm/percpu-km.c
> @@ -69,7 +69,7 @@ static struct pcpu_chunk *pcpu_create_chunk(gfp_t gfp)
>  	}
>  
>  	for (i = 0; i < nr_pages; i++)
> -		pcpu_set_page_chunk(nth_page(pages, i), chunk);
> +		pcpu_set_page_chunk(pages + i, chunk);
>  
>  	chunk->data = pages;
>  	chunk->base_addr = page_address(pages);
> -- 
> 2.50.1
> 

