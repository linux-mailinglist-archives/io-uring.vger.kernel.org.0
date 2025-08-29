Return-Path: <io-uring+bounces-9463-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 93392B3BD79
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 16:25:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B00A17C311
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 14:25:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06BBC320CA8;
	Fri, 29 Aug 2025 14:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="l3p29884";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="SiMfdLO5"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC113203B5;
	Fri, 29 Aug 2025 14:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756477519; cv=fail; b=uRrt/LSN2gWbxN239TdeSg3MQIV+00ayFO3NBtCsqnfBoyY7N+F4ayD9BdhW3Yq2EcHFjm9Nt+KGm7coYFFsjwpp/d2AzaFXZ5GZCHZtSzOoqhQF7cRQl3vaJZwnIJMndy64af+1xC+q/4NYAZu6zOyEAFWjPM0n2BgJKzpKCys=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756477519; c=relaxed/simple;
	bh=HwFLEuxcdfQagW2VH0xa4FoKmcEHFZCM1Rp4qDxEd3M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=r9hRUURVYMdRLic9xXh8vfT3v7x3YFanlO/eSoNkxN01M+rbH3zclNVbvYlniY5Zla/PtcWTaG7aW6vHMUUt9tjrw6PqtmGyDeG8hJ0hhKUdMC+1feERd/PKTNzfo6Yx9Tn7ZqP9hwLFD4UY4Shv/T3TiwJrBELl70LJpDR+gkw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=l3p29884; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=SiMfdLO5; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57TCtksT014769;
	Fri, 29 Aug 2025 14:24:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=gZGfXDjbyb+OGF3VAj
	ezv30Z9Vthn/0XzhQZTeuKsS0=; b=l3p29884uuI03vBX88YWABqTh6KGqczV85
	Hd18eDi/29qctKgaSEsYP52CExC7qbDxs1WC0GNzrPOJM2ZTCWlDa/fFNEKtDIFH
	lYEOIoFO0bmbbHqI3DDPI7J3dO3Pd8umBD7ENQjr8jBMsKxzVNzsDrAMSQcr0lXt
	7Me6caAjssLNUauHCA+52x28xwXV3vN9eBXmelymH2qJirgfH/d7N8785/HQcSon
	6JrJz47X6VDhgQU1RzG+LcWBoqkN7FIwjlOUhKYLRGR24VpANL+PXGL1jEmhC8LI
	Et5SzWXJa1qfj3cn/qxaWN1HWpsA8pnJ/BI4ZqgApATdCV1NhTkg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q4e2aqus-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 14:24:39 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57TCY1xm004977;
	Fri, 29 Aug 2025 14:24:38 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02on2064.outbound.protection.outlook.com [40.107.96.64])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43dacuc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 14:24:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o2Sw2zVb0Meb+WiQuUojbg21yXN6CAoNmRy3Onc/Dt5leXuauReVCUSoTEuDqE+KlyRTRfgmO8swTCy++i4DWzyR0Le6bVFEZgFbslBOUfQMo65Onag9t2kp2TyVl8d+nGQxl2PMqykr/8HJE7XMvuQKSLazu6QYVu40kek/0m7uDO1ruWIKOHBACrV414MMHtROkZ2v6lurCvzGeOHO42x4wrIErWLjaGCaTWqMbyLvq660xGraYxpj2BzCmNJhxXMkniC/1Yy2tpFy6Bg5jnXktVf2onoZxSZO5IsJkStWRqJZh2ZKqj1syk3BsX+QLZgtMKFamkd3rLOs275zxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gZGfXDjbyb+OGF3VAjezv30Z9Vthn/0XzhQZTeuKsS0=;
 b=ozewxpmTo8KK3episWScMRMswbDAXZHDkB0N15ktkAGfK9YUyPXeXjYQYaB53UBUI6oVs64XE8Tux1Q87KB8rsA2svGdvyD4/saPH82cZaRedIEBggFxIvcAQRmnfQphunnpAqlzH09BduacPH2DgmBhcd02L8x97qJaDhKhpq76ExA7sqoBqz9ucQaybfOUYf++PqSn4/cX9PNORbar1rmEwKTK5vvrSBlS0GCLcvMlwXUEI7ZbjOy5KeN4yU2Z219gmM8h2SQQFChrCvJQRj9KKujbqJbkiPQHBd9Mmahsv92f/lUnhpI1kSkFFlKBghR3ZuTpYcY4IyBgcmS5kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gZGfXDjbyb+OGF3VAjezv30Z9Vthn/0XzhQZTeuKsS0=;
 b=SiMfdLO5nxDSBrKsKp8xkm4z3E61NoYSRWwJvd58biiCZZe2gtafCLMzSOcoCv4WlNQZDCET+1ArnAZU3dKUMVyBRcAkxVQ7SyKktOvtFnpjPzHhO/LzGna30IyyUerYb3U8NFQs158b4jpv5rLUbvf4rzlM1e6wLkrS8QGywtQ=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DM3PR10MB7970.namprd10.prod.outlook.com (2603:10b6:0:40::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.16; Fri, 29 Aug
 2025 14:24:30 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9052.019; Fri, 29 Aug 2025
 14:24:30 +0000
Date: Fri, 29 Aug 2025 10:24:10 -0400
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
Subject: Re: [PATCH v1 10/36] mm: sanity-check maximum folio size in
 folio_set_order()
Message-ID: <fbfswjohgqohj32ibefqp22rz5xvbwiry6nxusgtjoxm6waqal@4mo4gske35eu>
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
 <20250827220141.262669-11-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-11-david@redhat.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: MW4PR02CA0024.namprd02.prod.outlook.com
 (2603:10b6:303:16d::9) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DM3PR10MB7970:EE_
X-MS-Office365-Filtering-Correlation-Id: 52d091dc-a522-4740-ff5f-08dde707c46e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4wectUMaFmYqYWV+o1aiRksy3eIZ8zl56VzHcOsdfZmkM//I81/dN3a/dGNg?=
 =?us-ascii?Q?JoInkDJBHbyZg7Nut7egzdNdFErfc0LAec5ufzy2IBMa+T5SpCdMPqOLtURw?=
 =?us-ascii?Q?5zR01a6yApX7LRIxBWqvKwaCkA7TnFVmHJYiKiSEf+7tgdvRNsLBZwgoYibu?=
 =?us-ascii?Q?gh71rjQl0FHCPCVPOtFeRIaq3S5fnY4ltIw+A/QSgAA9Z53/EnaPVmBR7nEV?=
 =?us-ascii?Q?pCitbA2msNY4hAqmpSwsN2RPD1VT64qMUuqeex8TdkPJhck4ydQ+E8BTOEy6?=
 =?us-ascii?Q?iiQFM0Mv2inp5nIbi1/FoMIFXRrMjhX69A7D+y4bcJfWn0Jdt1jXsxq8HjUf?=
 =?us-ascii?Q?iLYW6FAckZiVUe7RTppZMZp1WioWtnJyPNwzfqt5SIqwYwEmuwQXMuNmFTI9?=
 =?us-ascii?Q?mpnWpRuTV9NIUBHu2RLlaIPRKZlVcvS7sJsYLlxKP7M6NwPd2mC/dnikC/3l?=
 =?us-ascii?Q?RAhjLVOx2YiupHMS3AXz8gkVVEo+EzQncHQqulW4iUqNh7gwEw+EKZP6Ugyd?=
 =?us-ascii?Q?9K6o+sTriY4t2wsEzzseW17gxZDhQgOurlaVW1Od4prL438Io+jwR/7iWLGa?=
 =?us-ascii?Q?hPkIcpw+RcC/pE3Ianvnk/5fXPjmVAdY8LHOjSg7Sl32DRZ+VTkqhyheoKY+?=
 =?us-ascii?Q?q5eix4EKUr3vNcrFwC7lYEmkeRZF/T/hykB9hrt+VjFQnAYzOcTqKGRTsY0L?=
 =?us-ascii?Q?twZu1apAmyOgbAz9bIOSykZthCWXFDxS9WSRQhvvH97sZOJNvltEQ03E/+5u?=
 =?us-ascii?Q?6ooUkzQYo2kE51I38Z6WEHq6+JqMAva9tl0aKZfVJ0ukIfqdzT3OWm4QGtN1?=
 =?us-ascii?Q?UqEuyFW5NxYIFVtbtfph/xPqRYGWvbvAqDe/y+YiBqYY/NsQgh67dPSn/dA/?=
 =?us-ascii?Q?N1auCk5kpzOWgFr/u4VqSAnkm6ObuR0IwnoKFwGzJP6zDTBuKNmKLwFgiK7k?=
 =?us-ascii?Q?s3CUKJOTcj0aLyTn23VScQoS2Db7wxi53+K/W3bEs/S6BYgh5sJMyA10lz86?=
 =?us-ascii?Q?Gp82M142mM9aEkOMAd7nc6LgvEli+HxA5mwulGXzo9vQO+dDNGit+WWOf36o?=
 =?us-ascii?Q?YLgMpvQyQ6FUxRHdVxUShvjG8PzWNOwp1Cs6fYuuLdRw+RknZDoG98MMi0t7?=
 =?us-ascii?Q?javnxRC3IOsUlFYBZLWe036kjPdUOWe+rjdzYtHCcltdEbV/37lNZP13D/UE?=
 =?us-ascii?Q?hsZE0lpqX9nw+d5xcoonqMp9q2E0z0PSDzITD+eZbhNHVfwfrynuGO6CzIbi?=
 =?us-ascii?Q?a2+irtuaTvSq9B/vHG5dby66bwq5r7NqoWPISME0p/V+Aap654lCYVZfZqNn?=
 =?us-ascii?Q?Hr2QZd3C8sEVBtG4uyrIAZ73uJid92I31gsU6l9jO3GqOap1isxrKEGpPXn/?=
 =?us-ascii?Q?2Z0t494ZKBwprGrF2MoUrJ1KH4byRPVtJxzOEvsiBwpSdouzdn3VzyYbs31/?=
 =?us-ascii?Q?toJK+jiCq44=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sdcCm/2E+uwce1L6BovuRZrZslHBsLQYyDlzqHgk+bhzschxXtWTe0S9bTl0?=
 =?us-ascii?Q?Vq9sl/hVQFlJxOufSbnGzTdXb/W2MP3xweLP9cTjDmyx9Kft09/caboC2Edn?=
 =?us-ascii?Q?lq9RUOJBYz+vxYP+GzN34sqkUMnsy8g3b64t++gguBbhBr0t+oj5r5sPZ3QK?=
 =?us-ascii?Q?z70dimOAmFUBTOsLr7PHUXLOdQ7QrcrbjK0tLV8YwQnrLxM+nIGA+9PSuL86?=
 =?us-ascii?Q?O5OR39ti6gCk6ffAyFjWDUieh8KilV/tUC/0yoebH6Lc9Cg7B5mnL4oKR+Vz?=
 =?us-ascii?Q?g71LlUrcVQ1+1LnkQT8e0Mj02iQSsBmSHCIPSeMCLz6iI+URcP164w68Wo+q?=
 =?us-ascii?Q?FyE91OEZI6Iga1sN8RG/BVOikwWgcplHyAjCatm+fdb5exmyFMiPYVOkwRsq?=
 =?us-ascii?Q?dDrove8aKAy8O1aAfClBYsBAxo/CmyHRHIvFM392DcGeuwFzOPdlummnXgkk?=
 =?us-ascii?Q?B0kAlwNdXCwQ1LD2MQ4ZsK7ayt7LdnZ9nZNz6DZXYoYuxbseSfx19R7Hby0E?=
 =?us-ascii?Q?RWlxyUGrWZ7tkd8Y5rx9/WJoMi063Dtsj+SjZpFyYY/AEvVOfyBVJnkkeVSI?=
 =?us-ascii?Q?djxn1sjnEup4KSEHGSAFWbJNoz91aVEnAoEW2WfHfOYDYPfBLw+1r74o/xQu?=
 =?us-ascii?Q?mxw0irhdpOE+ioLtwfqyQWSk7SPBaUqDdTdQzmaJDmpuqBUZfC+VwHRDOL6c?=
 =?us-ascii?Q?TiZQMH4SEoNDlY42UY8jnShl8kEO//zhHPC0FNSQS4FVGFPDvQB9/R7n75YX?=
 =?us-ascii?Q?U2prIEj/+mbbU5ve99hK7iMVLMnkANHF7TlF3+YdGIcx46CIO89OXbFnciQj?=
 =?us-ascii?Q?RynPJky1Lkbg8OWl6aXYOBuNGKjSPwCdLpcMkgCLqOPuLWJdVCkCq2WrpshR?=
 =?us-ascii?Q?Coqr4LGt1gucg7kt1MHLB4dKSG6aAOVOxJM5LBwdlPImFTxFAM48fHSkEmzl?=
 =?us-ascii?Q?wI/Yff4IHSV8BH7VkNRNOc/98lnv70vz8qAkjYG1qMcYRVkp6VgH9gFItX3J?=
 =?us-ascii?Q?Evnn/grhM0LoJnO/kp5NXgiJSB/kmOsMmkyf7S+HtHGuqsGO6uHwUH6Zvljm?=
 =?us-ascii?Q?CtNo8r6ivX9OqIdSeHmgk5s4/eLEgDdbhwLKsTAH3XhwwMa/wsq3gBVJNVcC?=
 =?us-ascii?Q?SiqT+Nx1TOPDZ+3E3hGYDcM64xcZdkpYTgChz4973mVWFlHf5HmajSFhZKcs?=
 =?us-ascii?Q?UT08KVGaCF1tYPNU7mbzztNmGj3LpNLfxKRFeuoRBu8spJWJ+DUs3f0a6JlC?=
 =?us-ascii?Q?bFbsqDQXfRFgtWSp/AShwCFC66tdsTDHi2f703x6aLJlsyFsBlMjznz4rclJ?=
 =?us-ascii?Q?5uUpJ/95X7KiUJiK/Kutmdx/jJ92446iMixe3YjeT9I0LvCE9pGE950qGAsw?=
 =?us-ascii?Q?wrNv16pjNT75E7hnhKbxvSTTZmPkr8EI7cD68stISvaoCn0LOTNaCP4m/u8V?=
 =?us-ascii?Q?ulsdUEVh0tR/ZL+7I0pajiIlmZHbTAb4XGqSV9qyysrjeN6EEomhLR65QgRk?=
 =?us-ascii?Q?ChVh70Vbrr7goiDcxItG4H5jiqsABl2UJXGg0iuq8QkBbZzrK5LIoXgCCxMu?=
 =?us-ascii?Q?UmSpmK+JMtSc3kRs6krZUxaIgSKB3xskHErLHl48dtBDgyLoEDeSXkZ5T8At?=
 =?us-ascii?Q?RQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YBa8ZvktNmaxKQkTgGwQGQq1pr3JI8CoI3B6YDnR1oaupgeU6qzodXmOR+hawRlQRkgYcRUajBt8geNkyuC7ZlXiYwU+AuE1uJ7p3c1m5PFeg2MYbokPtL6Y/g/qXlmr00EBtVBUlyQ5ftVor9mlHFQ4LnMqBG4YKg4dDUlTYsXExEzibDR8gQn3W9h1Fw0Eem5nu4a3BzMr8cKJ0YrQkxUrTSZWzCzX9xPN1pe9MSMqeW6S9CXM9P/BWXJ4uMG5IoBqshZczVrjMmEdsLkt6NG+wne8cZAX3N9I17gkBpRf0dgxNhj+sDoCh8n3dmS9PqgyyCmIc/6kCjDkrMYhbW2T+ZM2vJunMT7La0rk+b9fIryxK8dO1G4Il4T9pAOypKYXemCUeiAW1xi6NFYObzHCloLUb6IYYeUMs6bF7xsOAX8/OMY2fO2qLzf5uzQReCU7Cwq3y0JyzMYJ15o3CxcuyfKSq29rfBuV4WiRwNyjScVS2WBCnz3EkputRNtihwRJOKDJVe4jmC7yJBJPhJfmkaz8hI4dpeXzym8mI8CoUqwRne7FUJGVZXjE1UZ8rp98jMMi6UKnryax3BoySr0pBjIpQEPyrGz8ptTcbZU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52d091dc-a522-4740-ff5f-08dde707c46e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 14:24:30.4571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LhZm1Iaek/a1MhLPzRXX5DlST8hrcFJdugqmzsj2cMZ5q5LnswYFMo9JoVjBOOjd5+EnuebgURU36lwlCCL22Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR10MB7970
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-29_05,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508290121
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxNyBTYWx0ZWRfX6fyMu0StlB9j
 AVpkjLHIDVwe186EyDOTuv9VWa611XjG2z9qCA2jYQm5fyXRCEru/XoUCKGoiIps5Yirfd+3WlO
 hhbqE7Y2jKTwQZoM0duQeFgja/0oMdMf99gt0quDnWCFADihZ5cQJmQVoCVlMcmT+xvx7lab/QO
 jO4XIPPlxjvxE/37nxnOG0hmtEA2af5pJ3ogD50t2ideAsuE/NqfRPYFbs95k4Unsk7/7GoSmUX
 6NJ66C7NPWPIGmT6Vz7M6ED2RRiBeecCi1yg/TWRJ5hS/c8qVutVuIzUcTS7MAjm5gMm/DfvMGT
 E09aWcLdKmX8CoZ7t0u+YFBOmYFtF5ISgam30b2WQVDonzEj7omJzrY6nI28vnFRrhnmjO2ccBI
 FLtNiono
X-Proofpoint-ORIG-GUID: 9SMIN6-sVjjCbHbjwd4dIYLLyTe0Whk7
X-Proofpoint-GUID: 9SMIN6-sVjjCbHbjwd4dIYLLyTe0Whk7
X-Authority-Analysis: v=2.4 cv=IauHWXqa c=1 sm=1 tr=0 ts=68b1b827 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=Ikd4Dj_1AAAA:8
 a=yPCof4ZbAAAA:8 a=SJHYMh_qAkJed6OffD8A:9 a=CjuIK1q_8ugA:10

* David Hildenbrand <david@redhat.com> [250827 18:05]:
> Let's sanity-check in folio_set_order() whether we would be trying to
> create a folio with an order that would make it exceed MAX_FOLIO_ORDER.
> 
> This will enable the check whenever a folio/compound page is initialized
> through prepare_compound_head() / prepare_compound_page().
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  mm/internal.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 45da9ff5694f6..9b0129531d004 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -755,6 +755,7 @@ static inline void folio_set_order(struct folio *folio, unsigned int order)
>  {
>  	if (WARN_ON_ONCE(!order || !folio_test_large(folio)))
>  		return;
> +	VM_WARN_ON_ONCE(order > MAX_FOLIO_ORDER);
>  
>  	folio->_flags_1 = (folio->_flags_1 & ~0xffUL) | order;
>  #ifdef NR_PAGES_IN_LARGE_FOLIO
> -- 
> 2.50.1
> 
> 

