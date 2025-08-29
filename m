Return-Path: <io-uring+bounces-9468-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E07FB3BE41
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 16:45:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 70DD51897CBF
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 14:45:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DF46321F23;
	Fri, 29 Aug 2025 14:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZhRBgO9L";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="AQzInVdn"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202588F58;
	Fri, 29 Aug 2025 14:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756478540; cv=fail; b=iQHIyaFJVkXCsP1qDlZlSOaq2v6ISl8PDJzPr5bz7nIFaPql0jEAmo5+m+HQJRb6NYxn7ydKYnHEAe6j1l79SpSAOmb9QyFHVE2cwBLVx09GrjBqbWn3J1+GYTqib4qB3rEDTaxCbLPPKzCAGzTg9DnmYha5m1H79Zyo8yxPJfk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756478540; c=relaxed/simple;
	bh=9p1zQz5auTBGtEADpmr4qFyvh85+Q1VNfu3D4j32mhQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=VdTLPaiSyWXiroBSfI0a8gmdXJ6KSHL8FuPMJeALljg9ZLYc0zeMOf7mZ+MuEbJmWH2MbEhmoFEdi2dcz7+aVhQx5O58HsPHBIrrE8iyUHkmbORYBXFUxr6wzXxUq59jMIVEKkcHcsALZrqaPxWNW7Pdyy2euXuvmoSe3o/cAiw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZhRBgO9L; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=AQzInVdn; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57TCuDFY023080;
	Fri, 29 Aug 2025 14:41:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=CHBK/yCd2y9Udi776w
	itkoyMBgpaQNnNAyTnYZGtC+w=; b=ZhRBgO9L4CU6FdPF46LiBMLA0bs1bWEs3m
	1scrsn8hnzxOn3801ewzdgkC5ZcVUbWYJntraNtUU1ZpgmQpHAVyi+CMt49m1AkP
	98EZRywpCwTyugFI3YLlWJjJ5teJ+9JPzaSVIINhAoHB/bjL+fjOzz19xEzF6IO5
	GsrTeA1upyqJ5vEEKJaTyhM3OvUahyvfAhKL9ZAKw9s7RUZ+4aXy9qbj7nQn2WyZ
	UsWwAI8C5QuTdzrQ26NYVYLBAY4h1cT9DTmUNIU0blaBjlB1W/rR9BLaunmo9Khg
	J9Np4+N5K6V6Hrauhg0WAQt2OMutkGHV1PzWXJXRiDxkAN0H4YmA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q4jatnbu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 14:41:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57TDD6iQ018993;
	Fri, 29 Aug 2025 14:41:32 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2055.outbound.protection.outlook.com [40.107.93.55])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43dabpk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 14:41:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i12ZsvQcHat6JWmW6NbzA0nEZCvK8WaY19xRM9xW/qAV91RJJ5DGdFTCTgiQsVRCGY5xkNgWUS1nOZdJ/x0K42D1+HSXW/FUFZEnLfkfwlLv59TecMaMI7CgBHPzF9mRRxez5LYjVP3eQMGu7u7+8YGBhbR2Z+fWBQCQwjcXO3o9FqRuU3CBFFpb4yfzDBrmIxOhcdP/2TSglKw5kQG18zQbQtd9YL1Z5rlLTcHX2p6geSyuu6OdZJxPKcRC52SAHjev2yiET13Ghv2SYZnhsjC7804WIE3p+KIwzBnvhUjP2ei2PgEzIQhal5YQ9i2XM1qLACGRPmD67KVMcLolEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CHBK/yCd2y9Udi776witkoyMBgpaQNnNAyTnYZGtC+w=;
 b=jvH292nK9gK5RlI018Cr7e0rpa1qrha52Kj/yLtNvZ4AC0G1BoP5rKkQpQullRtq06yEX+ims68M853mUNJFv8juSisESbxeQ1KgQ1iIsHvlzcwczFU06xl3tcaGktEGPl0vqvbULxXGWZNTWsW4dRtWvJXt4k+6McCVCgcqwed8WvoIg4oD914ki0G6ebTkoMGSftjcwgwseYmGU04vW9hF7pqo1HFeHvI4v7odyQxRRtMtcpZLM/8s82UVzQySC+9kZfQ6+1K5cnt5DbTOgkRf1a8dB/VqyQiE842jn13FunE7FIVcjrpCHOy/71fu691crscFXJve0t4ZNraT4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CHBK/yCd2y9Udi776witkoyMBgpaQNnNAyTnYZGtC+w=;
 b=AQzInVdnAY60aolg6YLtoDoRMB6FjTOr1d0A4J+/CZXKOGckI7bA/17HBq7fkO7aDd+fAi7Ab0aptK9UX0FhkAxaLj/FpeGn84rMZPRu8yjNGNvTmHlJsoF9IGPeFAUnxxuuWqtZsaC3UCbdvHJgHdG0MAK3VjGar+uHN+Ubfyw=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DS7PR10MB4928.namprd10.prod.outlook.com (2603:10b6:5:3a1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.13; Fri, 29 Aug
 2025 14:41:24 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9052.019; Fri, 29 Aug 2025
 14:41:23 +0000
Date: Fri, 29 Aug 2025 10:41:16 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Zi Yan <ziy@nvidia.com>,
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
        Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
        Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
        Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
        virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
        wireguard@lists.zx2c4.com, x86@kernel.org
Subject: Re: [PATCH v1 12/36] mm: simplify folio_page() and folio_page_idx()
Message-ID: <oinnsfpimax75klq74eb3orjaoipl6szcjlfhfes6gvnmyvb4m@xdpb7l3igqt3>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org, Zi Yan <ziy@nvidia.com>, 
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
	Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, x86@kernel.org
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-13-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-13-david@redhat.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT3PR01CA0089.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:84::20) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DS7PR10MB4928:EE_
X-MS-Office365-Filtering-Correlation-Id: e0169503-5758-4f9a-60c8-08dde70a1fea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?N/wuaz7jp/N1IXtIg41SSxEOZIl2Jsi4hG199GMn3DuVopZybGA/g6G6npU4?=
 =?us-ascii?Q?T5+AW0iLm8xEuiSfhGvcRs18LzjB7jFad650At5UtGw7zPOgxTsqdDb4NkyV?=
 =?us-ascii?Q?2bLSs0zTHDAuyuOl6LIydQq8yFMQvkgReA9MglLZhqRb2miruSZU0zLn+NhD?=
 =?us-ascii?Q?RcQYJIabkVPPphiEE9/xzQgDXSudqhNG+9tF4m1j2FwiWJ/Md3ATB7jPg3mt?=
 =?us-ascii?Q?KxNUbGvnLzmQOdxjeFOJri+9gw79BkmB+FLS41z41O/ah3KK2bSoc/l9OrgS?=
 =?us-ascii?Q?r70qW7QToEMrl6iYnigVj+6/CxIn3duLp/FSG1sIgLp5wlPsr39fz5GBVZ6a?=
 =?us-ascii?Q?AJFIfXWoTivknkk8S8ZjF5HzkwGYEd/LKWgvS+hJaWF1JCukeRY4qaOrXldP?=
 =?us-ascii?Q?KD/ZoMDBdRVGSmp0p4X70NcVZA16v6ugrFgz2KNNswZXN3wpD8kvCf3YpDBP?=
 =?us-ascii?Q?Uj6WjO3UJ34GOLqZclIUrSf+VJi6GijXNkqkrwk8WZWlG+dfyxwYXS+HlhZw?=
 =?us-ascii?Q?FWioXssObwBnztduIFp3EOTTET5ZTk2fKuJs2iMHsp9gjiGgfq1S4LyEW0lg?=
 =?us-ascii?Q?ryA0Lq5H7qAGO5azoj+f0cNZ/OkJYl68UyD2v9guMQE04I73Hl8umrSyHIFx?=
 =?us-ascii?Q?ikgZYvwjngRHpxfNuu4dHaTB0UJcNP5ltgU69W2+1nqKLCM7LwJjN3TTPiLU?=
 =?us-ascii?Q?Im7UzNZ/V1uw0B/ADcMOENRdml97JD05s5ycoO23/FpK6tnt8owGK29hlIvw?=
 =?us-ascii?Q?hqguq/lVFRJGZAhflF9vqbckJBC8CtIjSbNXnNvnZ+gdhsuEmjZzE+mWnxEW?=
 =?us-ascii?Q?0doE3h4cckQ43wHtcsacs5WKutIyq9vh4POYjQEhsHZeWCHbgs0V1bTVUV9S?=
 =?us-ascii?Q?aHCWq6mPUIAy5YTeynPXUzoT8Km0sCkTWY0DLdsfyHMB5g0xmeN+uQdtiKD0?=
 =?us-ascii?Q?n3TAdlt4BvqAK/ExE6+SoKg033AU5gdbkmEKVB61ZPlZ6pNOzqAsJhgCL/IL?=
 =?us-ascii?Q?bwtio5G2mn6aL9/cQKJwYRPDj/j1WFT7EkoOqVOJ8Tp3ACSGcNQDym8GoWOF?=
 =?us-ascii?Q?ec9Z4taxAuxPufrPaDQtl59hiqMnKoKn6Cskk1BEO67AcJuSRP7vDH6Z7liH?=
 =?us-ascii?Q?fnHvU/6rTm1OiRzlZQRApHLsgue08sibH/+Tlmrt2O78bgT5WZohLH64dRWw?=
 =?us-ascii?Q?fPmFjHeVNwDf2U4MUfihzDyTjJaxKuNNe90vV4mwM3Kj5nvXmolZX+RD/9IA?=
 =?us-ascii?Q?6tPjT3I55gBfrPmTsncNhreBfQ9ekGo4Ba1kk4vDWMU2JiwozTkUcaATLKNy?=
 =?us-ascii?Q?QVpMgY7BGQlTWG1O2jnyZvaSZpWuVLUSptLToaVoKfbLr/8FPmP6eTaXmbQt?=
 =?us-ascii?Q?dx1plocNWS2Gx23A4+Vmqr1nib+0SHcA/jc8iVaRTzh+4EJikpHLcRgTpEzv?=
 =?us-ascii?Q?NRNji/o2vDk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dNxd3tP1q3UBS2PB2/5qjKXvPWH3Y5YXoeC3b3HNm5UMdlmh3+nMfmBXHEAG?=
 =?us-ascii?Q?cWzLRD7/0WFqitzFr84xEFoGsCmmtcOgXVv3ZwyCO6SdVvgIofnKUHE+xY+8?=
 =?us-ascii?Q?Z+cDrwA8my60IYGQRZeY0MDGOCXLUcwwmQEYkNN5YCIgKDK3i+mIVQw2vC3A?=
 =?us-ascii?Q?dhSTpytX5UI30D+TKy1VbXiOY4LHnNrnIaeimtJD/2aLAFSg5RDghD5hvoLD?=
 =?us-ascii?Q?DWwkmkiptSCYrUDUu7m+6OQLMdEAl3NSTPFwJ90S5hxGKdxq3AhlxROYIPTj?=
 =?us-ascii?Q?y7+Q6tsZcz+XlJFeZXH93vjAsGcflJhAIuSlR685Mzd4kieu1AM5PBTL+NmU?=
 =?us-ascii?Q?Dri1xRmD0Oot39kubsFeswVlrFPBm3mGa3SkJXhYqwk76p7QIhGfqdtvqngx?=
 =?us-ascii?Q?3XQfWOkw2KoQo3Gqel5kBw20/Arq53TI/1nX56TNDr8Dt7rZpexijitgTPgm?=
 =?us-ascii?Q?dPmi5BgFa1x+XynBsR42NBUsJusc4lFl0XHZmRPbDYuInnmcvyVqwMKt5E4R?=
 =?us-ascii?Q?HqLVVuKUdeam0PMO5qAEP++swYDCPeO10X5KFXhvztsQadIbSsZPz9V/hihd?=
 =?us-ascii?Q?18c3cX6cdwrsHo60YBYDoIFvo9lgCu0TG82V4+X7domZ62GnTq70tWR4mLx+?=
 =?us-ascii?Q?3VsP4bnI8ZdDidwLm16aCGCBGff+r1+9v/YeT3Uquvq4uC9i6Exa9YBiWAe5?=
 =?us-ascii?Q?djx7NbCykd/mJDog3Clb4IAG8tGUa2ssVN3W1VJFMzew3SiUcswQvrCMwGs2?=
 =?us-ascii?Q?U/IFE02wb3jcsvRqoMHGoOTsU0yBD6c9iPi4iWaPG2Pss7LO6+jHrC237s1C?=
 =?us-ascii?Q?unrlq3b/xN6vwionb5VLxCLQuy+ovodE6TqLB+4xOTYRPMUCYFFVXrLPD7s5?=
 =?us-ascii?Q?RTSWxW/hRo3G4Krq/zUo3AA3/TopghEmGJFf8Ip2c1bsNTiLCfLy8yAUGX6r?=
 =?us-ascii?Q?5mLNd+urP2fx1mtcWzODg2+yO/nCgFyxGNgnvIfSOq5E/IApVjaTzlLxx00S?=
 =?us-ascii?Q?yFT8Gnz10yoIw3fkvoOdxB9l+o0ZKy8JRq+CxX87pt4Jr3kqqQOvbr8ekLPf?=
 =?us-ascii?Q?vRis0YvLkUk2SyZYh+JvTg+xSvODj9JxKtNyGN1QQqHTner+5yfhfpe1ctnw?=
 =?us-ascii?Q?IzTgJ2ILKT6d5AFv3gaplIuZtp0tKEZmzENtpQdTGgAO17YhpY/QWYPBADdx?=
 =?us-ascii?Q?JvXgnVRwGjOv16XOJz10x9X/gmxqOHaIoNfnvShcBO079sHKSZwyfucpU9dW?=
 =?us-ascii?Q?tPGoE6cK7Itw2AplS22cetJr4Q4o3ialEbTNzicu08crJGSMW0k17VIAtMtB?=
 =?us-ascii?Q?bmfl9oy2PjMtyl/Uywrj+Kq3qYe2lptdzVovCgAYrsrizL9Hs9IqXVGt6L/8?=
 =?us-ascii?Q?0E+jnsI7CfrbtE6sv8FyJKUWdFJI5KtcscPmEGFp5K3lZgaDEmd2U05xwvb/?=
 =?us-ascii?Q?blT3kJbHxlvwY8ENbkhRhc9Qw1+dD75Yx/0S5KIazdOIPyLrL8nU94JnzDKW?=
 =?us-ascii?Q?7IfxBpGS1/DHvNd9hH3Gqj5m0GhHp+ZdSRupT47p1Hghwy6yj3anZqZCtsnn?=
 =?us-ascii?Q?I15i88YQ7n5tBGkaLfEt7luBHxDcFXa0Vcx1BkZC4MUdM8+D9iPvsz0Qfm0L?=
 =?us-ascii?Q?WQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6GiuuMB13CUwzIm0LYJIs9umdinpazr9oTzAOH2w+PS6OMaBHt2UX4mXWAIpmRamETf5662MI8q4msAJRpd0I3Va0q2HH5elAudxaM13rNcrfb/FzFJRmwJPBD9KBvGjTkvq4of6H6Cl2PrFkeRnMr/LDiFgLWq3Vkr/eSXyX0OklSyNMCwyOK3mG97hUUfhkcjuHqCZnAC//MqirXYx6/mrlAd5ANcs0FsnKs3ykXLMBtl/ZbwJgaKFNKOjt4avbQvIUpDyF+9q0g7q/dCxgM3TDN5yFb6OCRRp981WN1t/iTqFJ9V6jKQaBoN+mstBOl7FGAQjN9BmZa9jjblVEDeKEkX/rPJufPSC1K3CYGI35EqrLgYv7H5fe9avX6+/Qt88PyqCm/px8qIJODjVIhl/rTfPGjk8IPm8P2JKBwSgfMDTYmIaxXdu0cd/YHtijYSlF5IZnO9zAZodWdi1EEvxZf5JnuNsq2m6cEwThRMIveJqduwaiaX8fRxt3Hu4UNwUBn36+xLaE+lDYhYsK1lf3lhkdaiFYaGZui5BwELtycuGsy2qnGf8E1BdOztCPS0mNuFMNtI7UHCvnErl2sHycRCcYbwy+suHpv+Dufc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0169503-5758-4f9a-60c8-08dde70a1fea
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 14:41:22.9856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sE185fl/rrcNYjNJ2YBR+wuAF6OEfLr+9fcS6SeKOQg/N9ATV/iSLBfs9GgWWvVkP+p306AMGEFkt2DILb/cnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4928
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-29_05,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508290123
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxOCBTYWx0ZWRfXxWdzdUe2K2Uf
 jCfcu+ZfuSc56wZ5YeDqiD1pUfhYsuEJmdvJkN0K1000M0L+bact4dxkNRrW3S0RkBsiAR4sljP
 qnj09p44RVwRd6Cy68B7RerUkz0pb5mI78/F5U9wi2mgrg/46rmYhEbyVEoKPCmXRRCRPh0/yeE
 V+xZoz/BCJeCLUZ1AhNimZuImBze80JobeLHWAynegJ9Hw/Py18XXTi6h0MkJzyoSyhSqGqQWzw
 Ehj+K97caxMsYgBhzUpmoF53E5GYQYKmBBWyBp5/UwBJdiGX84UnlW0riLCDYgGXohLnvyiSblf
 SHgAhaBcMUrrxuFFc3ohV76UReV/1CwMc4VXeIz/xOn6PEQCTBh0mENtxZnLmw1tP2K3uMtoP37
 lg8gOAYh
X-Proofpoint-GUID: cKFhcsBQfgh6ud7DwqlZobdMJMRfsl69
X-Authority-Analysis: v=2.4 cv=IZWHWXqa c=1 sm=1 tr=0 ts=68b1bc1c cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=Ikd4Dj_1AAAA:8
 a=yPCof4ZbAAAA:8 a=0J61nuS8Vg-Uhu75psoA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: cKFhcsBQfgh6ud7DwqlZobdMJMRfsl69

* David Hildenbrand <david@redhat.com> [250827 18:06]:
> Now that a single folio/compound page can no longer span memory sections
> in problematic kernel configurations, we can stop using nth_page().

..but only in a subset of nth_page uses, considering mm.h still has the
define.


> 
> While at it, turn both macros into static inline functions and add
> kernel doc for folio_page_idx().
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  include/linux/mm.h         | 16 ++++++++++++++--
>  include/linux/page-flags.h |  5 ++++-
>  2 files changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 2dee79fa2efcf..f6880e3225c5c 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -210,10 +210,8 @@ extern unsigned long sysctl_admin_reserve_kbytes;
>  
>  #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
>  #define nth_page(page,n) pfn_to_page(page_to_pfn((page)) + (n))
> -#define folio_page_idx(folio, p)	(page_to_pfn(p) - folio_pfn(folio))
>  #else
>  #define nth_page(page,n) ((page) + (n))
> -#define folio_page_idx(folio, p)	((p) - &(folio)->page)
>  #endif
>  
>  /* to align the pointer to the (next) page boundary */
> @@ -225,6 +223,20 @@ extern unsigned long sysctl_admin_reserve_kbytes;
>  /* test whether an address (unsigned long or pointer) is aligned to PAGE_SIZE */
>  #define PAGE_ALIGNED(addr)	IS_ALIGNED((unsigned long)(addr), PAGE_SIZE)
>  
> +/**
> + * folio_page_idx - Return the number of a page in a folio.
> + * @folio: The folio.
> + * @page: The folio page.
> + *
> + * This function expects that the page is actually part of the folio.
> + * The returned number is relative to the start of the folio.
> + */
> +static inline unsigned long folio_page_idx(const struct folio *folio,
> +		const struct page *page)
> +{
> +	return page - &folio->page;
> +}
> +
>  static inline struct folio *lru_to_folio(struct list_head *head)
>  {
>  	return list_entry((head)->prev, struct folio, lru);
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 5ee6ffbdbf831..faf17ca211b4f 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -316,7 +316,10 @@ static __always_inline unsigned long _compound_head(const struct page *page)
>   * check that the page number lies within @folio; the caller is presumed
>   * to have a reference to the page.
>   */
> -#define folio_page(folio, n)	nth_page(&(folio)->page, n)
> +static inline struct page *folio_page(struct folio *folio, unsigned long n)
> +{
> +	return &folio->page + n;
> +}
>  
>  static __always_inline int PageTail(const struct page *page)
>  {
> -- 
> 2.50.1
> 
> 

