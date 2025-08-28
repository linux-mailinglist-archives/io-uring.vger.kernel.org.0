Return-Path: <io-uring+bounces-9407-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F1C96B3A4D9
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 17:46:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8CF4A367028
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 15:46:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D01BF24A078;
	Thu, 28 Aug 2025 15:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CrjAqlr9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hJ5AliGo"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3776624A051;
	Thu, 28 Aug 2025 15:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756395998; cv=fail; b=W9DtwvDZ+xvbUx1aO3baM78SsMbOPBUh79ehEb7iExndC3fRBCHUtoF7p3NRWWzhqyYCFIOJacVL+8SPwTJeno+Fgk5FNOTblVQgob8TlpWFOs1geMvB4Iwm/gTi7OwFpJiU9weacZf0uqL+7RMaAnGLehrDqcfl1CAJgMFOSa0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756395998; c=relaxed/simple;
	bh=K8a1nm6tNnFcGYoZGtEomAyYFujMOlaC9A5uRYaqGTw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=DWmtTYOZpSAGmFsFFCdHNIL4ZmUkO4HBqs9fBCufmJbJiNvexSzI6id83Bv9QRMKPK0aU9lKP5hQu97qwQZYrp+L4YBU1iyBvtEnj5XNaBWvwGvwqh3wy+N/o3FOmarRMckxx6TZdXnRNBqOhKw1Gq2P4/l5HwIsFVKM3pUCK+A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CrjAqlr9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hJ5AliGo; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SENHww001544;
	Thu, 28 Aug 2025 15:45:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=mp5vJj3kSZ5b6CV9Wc
	FfnJvbkDtqUnazQgYHEAagk5A=; b=CrjAqlr9rTyxpPWm3REVs0gXQijXPZNOVa
	4k9CJtcSiYHYfETs/vn7+3DnkBlmLmx2mOh9g7jum57suN2P2VRC7YyfjYAr56sl
	9GmF3/MlMcVLzQwvO+CStIf/7egvZFeBK0QT/iIaPCqavQPnzKUb29lz8XWY5+pL
	3x9JzI8i7FZcP1Qy0QNs5fHzWv4O4sYg62dYTba3nD+FH8A0syqJsiqQgc3fEJTY
	hmC7Ey8kFpnK49S5fOO0Kx2+s7/kDBpepf4wSaOlG1Iz7o8QLxfBoavefcGJYBTQ
	hXE9c/AdF3xuAIcdtH2a4as/xaiTJB3/giQ3Uee8vYzsfuQdxhQw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48r8twfh68-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 15:45:59 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SF17dW005115;
	Thu, 28 Aug 2025 15:45:58 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2061.outbound.protection.outlook.com [40.107.220.61])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48qj8c9ug3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 15:45:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J1LQ+ekynYYFNAeHN53zplcIn575JL4QlfeTrxv399WZbloDENCpHdKk9NKAibSRs68qvemnugzwGFjjdn0SL7UU/V3NrblDC+LgWf4Ldd5dJ/kPBWwfyAyKImF1pByrvz2zG3cDSs3ex8388a7jf1APMTOAjt0XCwNpZPar41L0P5ME6xCDszpsastFY3kAtr+p2x7t2ew6zpeVCdYkW1+a/hq/KiyI3I779QIxfytbWBtBneg7KwdWwOE3UdagR4gi26AyUt9j0OBny4gb6FmrGUY5RXyvPdbJgg792IaRJ600r3GzwBETRikWCs44IU7wPTVHSpcLx2L/zc0cUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mp5vJj3kSZ5b6CV9WcFfnJvbkDtqUnazQgYHEAagk5A=;
 b=RKq3pTCQXVjlQndvg3WH5CgCgAmveXdHjr/My5bygrQQsFAdLcqCibnLFIOrLQ29YbH2cEQyY55VA6ku9A9xG0YD/tNv/l68Kukvsjs9oio/9QhONgTnw3GbFrBrUnM6u/pwh7WzS0fOtgaxlO447tWp3KYJNiuUUaUwhFAZJJOjApGC95p6wJt/vkcSRlPc4ef+E2RdwUcd1pQpkKVkzT3PWx2E9epFDOccqXUKtOz6UAzOdGX4nobDCo2sxMdKnrqQBNiLkiCQzBoPfdbsxf4nS9mu6dvFQ097RSX4fxUBFFBMX4oRuUXPmzOf2zENm56b6Ibxo2ywnsJ4hc/6Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mp5vJj3kSZ5b6CV9WcFfnJvbkDtqUnazQgYHEAagk5A=;
 b=hJ5AliGo829pBPAb8Vs2bapvUIEwI3hE+FhkmJIdoXSwUigxPzwytiPt2/ViGN48VUGyRu+xE30QqRtw2TqAPOWFAMS8xr8SJgNGpaLRsUnAvy5TcUsDoQyLeHX5buKiJSJpa7TYhVAznZD5PHfDjFi97l4uOsTD69LLFaovomw=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH7PR10MB6674.namprd10.prod.outlook.com (2603:10b6:510:20c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Thu, 28 Aug
 2025 15:45:44 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 15:45:44 +0000
Date: Thu, 28 Aug 2025 16:45:36 +0100
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
Subject: Re: [PATCH v1 15/36] fs: hugetlbfs: remove nth_page() usage within
 folio in adjust_range_hwpoison()
Message-ID: <1d74a0e2-51ff-462f-8f3c-75639fd21221@lucifer.local>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-16-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-16-david@redhat.com>
X-ClientProxiedBy: LO4P265CA0117.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c3::20) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH7PR10MB6674:EE_
X-MS-Office365-Filtering-Correlation-Id: f40dac56-85cb-4a0a-c252-08dde649f35e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5gaUm1am1Kx1+kENUuViyH4ALBSg6ccW/F4Gm52JfY/DRn/DJZwdnbxdff34?=
 =?us-ascii?Q?Fv6seR5eb3WoWuoYo2CT3R8hgd1ElRAhjyF4K+9/TpfxVGFBvJKPZVzK3x9Q?=
 =?us-ascii?Q?DeYYgI77uLGUW/fLlX3O6/qM1rOwYIMlH+pzV6RgxLRxEzUY6OdV/8HM+d6E?=
 =?us-ascii?Q?bKPapwLHkFMdpPL6MvZ6WAsfCnkamvUStFybwvilri67hjcPuRUsanEZkOkU?=
 =?us-ascii?Q?D8QlDEa+7xBgsBYW091SFXpmJCSjXWNWgu++00h3AfgGybwabWLK4ayoZi1V?=
 =?us-ascii?Q?HleGLnsvkFi/y7z2raZju1S7+lQNaWnrQ6ZRpo3Yew0zl6nGX13y5Ib5ZVqW?=
 =?us-ascii?Q?pti4R2pg1Bqzsa/jBv/CcsQLblHSnh/iBQIEGVinItgup3SRFECfs3a+lMXO?=
 =?us-ascii?Q?Tzk1bB28X6yk1UtWD9GEJbsf6dDG78+ZMSkINR4biGISIwZxEYa22eQ3JdPo?=
 =?us-ascii?Q?p+AFAFtjxyzJjaGYr45DF6dn2q9gx7WfwiouPHIVeyatUQqExkvcrp7qgj8d?=
 =?us-ascii?Q?nW1jTVm5svFZU4qOmzOt+A7DiRpg5qhl72XFGvksEJBdMK1rNxWM1orxYxBO?=
 =?us-ascii?Q?1hNh9Ne8hX3/Bu4fbwgNhgmo+CeAcQP4g7K+OJtuTLfogH+Afb89jbqquacR?=
 =?us-ascii?Q?Mnkc81daQJs9hxTztj70E9WGIH5jeb/0yHpqpm3vW/W7bY8Fy+y93fysMuF+?=
 =?us-ascii?Q?Vt32ZFbcpq4O4z4JuQxCVjuLqQUlDYDeWHrqVTJPI3DT9M17fov8WaUo3gdE?=
 =?us-ascii?Q?vtQX6oObdYYrpdoxqMiT22eM6PzerbtXQHcrSyCYWlyhCJkOiQz4J9WAp8sH?=
 =?us-ascii?Q?3+jSuL7q09c+9Mwa1X3xepO0+HLeigg5s4oozHgneP41zbGlS6sf2tGA3jtg?=
 =?us-ascii?Q?WiMljRDOkaK2SJ+jTBj6UCfRNzNd5DDIyVhzItxoIZIXm5K62oQGaMoOTFfx?=
 =?us-ascii?Q?06fpQA2PFsYARX0lxJRHZKNOz6M2cpiPKcOWYhM0A/8Nr7xXfaixXHHxYb27?=
 =?us-ascii?Q?/NVsxHIFk5nJG/z3CobKvkB3k5y5aAD/oYNiYJ/rHujITGwdMg02vQi/9w6/?=
 =?us-ascii?Q?D1oMzlKu3gebByXaQ3d8+SMERfAjtelU4HJ/j0cbu/lmzdWe1GhqKzgLSAlV?=
 =?us-ascii?Q?EBj+nGOpax/R0pLuy4/CsuDFNMNBWMxf+AiVznIHqfAugjfXpzNXEmLgWHHn?=
 =?us-ascii?Q?NdtSO2nZK/dTXD66yJWDGUPPydVYBIAWtIxr7Y7dV0nqu71tSmHEN7e/mhJI?=
 =?us-ascii?Q?cQDm146lclSS6JSpoKHcjqJAfKurRemDBCma14ScAUxb2PdjDBjcqhbi3Ad7?=
 =?us-ascii?Q?4jHK1oxVXYHLbzLxUQk4ZJGqLGcKRVQrDlen5FFZMJNom/Ut/4uperbBUZ+R?=
 =?us-ascii?Q?JF/iZY5bRQi9svprjiksBv87Lkil/dYnpLvXzaGV1gr/wL4PwA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9At8MnUw9itGRNqhIh00whh5jglQtopI5WMGEFh6H5cLpM6/4GV4GxJ1KvmY?=
 =?us-ascii?Q?FaIGUoJV9m3lqxOzDHLRH1MzfLLWi0VAUhC2PKEpsiAmM9T32eJh20pjOb3i?=
 =?us-ascii?Q?ud+Tm2zB7ZRO/sIYTR7oS70H0vxx81JailtAj/k5l9/qedKuuf829ZZ9Tl3r?=
 =?us-ascii?Q?5JRrf1QxpSkk/QhNxef0X01k47QGyw1/JgqvkkCjn95mOm1A/TsFN9zXMBDh?=
 =?us-ascii?Q?i8mwmlGzp+ttmhtfeskmBHxSNUR/vYE/ZTr36/41MjzbguyVoQu+CCCszp3w?=
 =?us-ascii?Q?G3SlAx9OXOdWgKCigR8L9+ptPKMuVR12yty8ue7KmEXMvkuMBD6LsQdoQmGf?=
 =?us-ascii?Q?6d05NTCUBA1kZ/q8UE4/7jCDgKDKg25fd1jVococUJNJgldZkV1dUnpsS5w6?=
 =?us-ascii?Q?BUXBjdL9AGa6zRvAvJ7QDZ4aOPkMZd1lp92qy1btM9Ol1ncBn5XdId9DC+UA?=
 =?us-ascii?Q?/GCJOB3mqW8DeMoNDH3ElAwHnd7l2rjxM2bO6XM7yrNR1ko7mBnaYnEEXKlv?=
 =?us-ascii?Q?D4oEudlAQmRBhtN5sFLDyffy29dmyVDsR5q6gIQ/HjMXzQhJLPTfwt/MXwFM?=
 =?us-ascii?Q?aU+o1hu8TlQ3QXBqRaHT0ljjMXiokcrSR89palWgrBQAEFzt/StxhDilhWrw?=
 =?us-ascii?Q?+COgG/9CgK8/YRjlemhrs6ELHZ67pvqDSuhJ/EMX+VMMW3gmKQteU5biWdIJ?=
 =?us-ascii?Q?Gk1JH29V8NyfLNmL4vzpKByH0z33YIan6whQO580REGibtJqwmVy7aNxWxaM?=
 =?us-ascii?Q?EDdB2+MoWMza4OWN5sDZVEF4amMucY3YNRNe4sGtRMuOxZcvpuhe431H5JRW?=
 =?us-ascii?Q?rGPt/W+3rKlV8Efbx2HKqh79eBsAj2k2GEvqO4LCzaOGkN+ZFQ6n0eMPd0iZ?=
 =?us-ascii?Q?ocCWw74Yb68lRt2Sj1vSr5rITKoygqx018or5xYeqmilGm4NmRXuhIUzblt1?=
 =?us-ascii?Q?f38FTBsoU1wG8MJYsN9bLfqiH2wHkV2FFCHijR34wIx+wet46Nwqa22ShUZU?=
 =?us-ascii?Q?EJe7x49VyOjZVHMcJCaBUF0p/kd7TEhadyjJagQQ7uWyN0qhmJSioO0DrHu6?=
 =?us-ascii?Q?9NgoGzR0EPKzweqHOU0JC70qf918YAO9+7EPORvqTS6AFM6B+GFN5dvqwgpI?=
 =?us-ascii?Q?Pq6mD3kRMtzjw+ctelKpf+8OtPp43ULvJ0s25FoykVOX6LRQkHOzUPDNP1oV?=
 =?us-ascii?Q?zafEPnyyjBjOxuuJ64d42W/N9g/UkdCIJbvoARLRGjRX6qJUegK8oF95NQ0z?=
 =?us-ascii?Q?kvBHTpCFZ38dHKtjT2Q54IV46xZ5J1JiyE3RqW8AtVLnX4H25A8HoWue0nW0?=
 =?us-ascii?Q?zOAI/gM1slJDoj5mL8G8XEP1XBKUCb6GhBq7S4m3Lln0vmX9MsD27hZUYDJM?=
 =?us-ascii?Q?8ohQEwdBNBsRJUbDW1C8EW9Y5PhY9oVgVVuqRwdHAuvHff2Fp9bnoJA/6mMo?=
 =?us-ascii?Q?dELY77arMFLWs+aOZOg/5N42im478NGEuu8q0baX2Z0ljn5De7OXTUrZiFEP?=
 =?us-ascii?Q?PAs+Kihbss2U0hdR2aHbmUkC0RzgCK04MbpuPU5dPfWJsmWUtB8vcpCsu79J?=
 =?us-ascii?Q?LzTGz2/dkKq6eaB/MCdDPkyrGpuveP9Rpq5l5cSwv20nzzxe7t0VuDHzGyXj?=
 =?us-ascii?Q?Gw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	oPJ6T2/ittV4vgsQnQPw+p0xB4j2w2vHoln4P4VasSDkvyD3vWFEcckU4DPpEpvVJ2jHewmaDeqeYkhD/ZDfa8rz/jJl1RX5rFtpMOgnKRXvTWKCy0VYPwS14Ce4ciB8yBw2yJUwnNIxj8nca0lzTmJZwa4kYh/ikQhGs/Wx8b4LfSavG4yz2zcuG3yQd62F677geGZGDYm6/nD4GRXtfESVvM9c9txY0PqxbRGs4xPiVjZcIaQEbtGj32BM/MDEeDYbSFG9KHy1aY8awmaWiDe0dTd9PJunx7O2KEB8886EmhZM6Q5HpdKmbzVrZBXRErFbZ9RpNWgeZ4q/SDFb6B+xuVIC4h2naZS/Aixu5AsDskg17DPhJDssKEMYKnpB2a55Qvonwn5LrTgJ25KQ4tI7PGWb6taRHd12eO9nhslzup1wUq5Bk9cgEwFGx6mtG71A/bi5s9lVWtSsWtbsxSuvQaghUlcIzghwHPMWzkvTMCiwdmr+tWx89Oiu9ueFUYvBYryG7svLaaeIh3+tU94hArXVSqc5yVQBeuDilzSD9biEjGFxbe0Rhr4I7pg2/dEv5WJlv4HTEXeD7quUtlR4yFcyyD+KbB9g+4CPP3c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f40dac56-85cb-4a0a-c252-08dde649f35e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 15:45:44.7326
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZXLGCb4noF6YrSZGyB+mdvW2mwYpg/j5be5wGoxE7I2GtrMMuGsj8+h7daX5jVscCImo8kQ80qLxW1kMkalSfNehk6RVicsPUm7ICDYXVzc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6674
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508280131
X-Proofpoint-ORIG-GUID: 4h_jOq_f-gSghy12tmQGtR9CNs_-JYxU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODI0MDE4NCBTYWx0ZWRfX2iy2UPGDP1Kz
 QKSHjk6jimAoZV46xDAey/kd57RvtvWVcfzuFAB/BkGQENL0DGRgJbB9aNij5bl8VreG+RCLHfF
 aRy+F584GaTk4cWcaM/Vwgsu0wiYJ+ipu4WX9DC2IV3O7vAYmmZB2h1WoEeATmUnwilreled9e5
 sR6Nv3fYLuv+uLGNkj55Y+o8MW6FOCkitRO81ntCED3INRTi76TpEq5VLwAy1cziZrDJOw4RZpQ
 By4xu2+aaAnyv9DdGycy0LSyTt9yaALKYin5Ayew11VpqaDrhvHsd63tIygCOW9vK22XQIMkuyE
 QjNwL31IOQHGFe5FEsBhOPRtUW67jpkPAfo8GdQkUaRfN1SD0vh45fAD4MR4bU4vnN/RQZPfnhi
 vpO5/8i+h/GLmbPt8lRM1kbmOC+sXA==
X-Proofpoint-GUID: 4h_jOq_f-gSghy12tmQGtR9CNs_-JYxU
X-Authority-Analysis: v=2.4 cv=IciHWXqa c=1 sm=1 tr=0 ts=68b079b7 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
 a=Bl31fZ5Oqo-2sH_beBMA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12068

On Thu, Aug 28, 2025 at 12:01:19AM +0200, David Hildenbrand wrote:
> The nth_page() is not really required anymore, so let's remove it.
> While at it, cleanup and simplify the code a bit.

Hm Not sure which bit is the cleanup? Was there meant to be more here or?

>
> Signed-off-by: David Hildenbrand <david@redhat.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  fs/hugetlbfs/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 34d496a2b7de6..c5a46d10afaa0 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -217,7 +217,7 @@ static size_t adjust_range_hwpoison(struct folio *folio, size_t offset,
>  			break;
>  		offset += n;
>  		if (offset == PAGE_SIZE) {
> -			page = nth_page(page, 1);
> +			page++;

LOL at that diff. Great!

>  			offset = 0;
>  		}
>  	}
> --
> 2.50.1
>

