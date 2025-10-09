Return-Path: <io-uring+bounces-9935-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 13034BC75C9
	for <lists+io-uring@lfdr.de>; Thu, 09 Oct 2025 06:21:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E24B84E3076
	for <lists+io-uring@lfdr.de>; Thu,  9 Oct 2025 04:21:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB320245019;
	Thu,  9 Oct 2025 04:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="i1DSKjuB"
X-Original-To: io-uring@vger.kernel.org
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013019.outbound.protection.outlook.com [40.93.196.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C701F2B88;
	Thu,  9 Oct 2025 04:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759983684; cv=fail; b=NeMRJDg063uy8DXKlXRflX5fK6hN5hY+cwrOOZQr3+2m4BO26iveL1qkOwr7u/Du0ttIRoHKm8nT71N+hZyP/AKyXupNW+D3uWC8mraPSPqU9443hocUh3P2LWX/Cedhg1fBkwh8+VN88RdkMK1cqB/Yp1eiPXA6nHf7qXZsCPY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759983684; c=relaxed/simple;
	bh=grCl1qBBKkH0+/sqQ4JO1//IG5ciajDqY6qV7xXUFzI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IqBWKfKlS/dg/cRb1e7t2rnkZO7/3C2b9uinAJJiAUJs7bOe+oJVzLR0QLdGrVTEqA0EcyOp4Y5zL/DFeDUyNnP4p3x26k7CMQxb5Q9i17G/nQFjpqCwyhHbWRp1wBzc6INwyDEs5pXkaNw5TnTxVlgnS/zcSHANs5bPJXNAZQs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=i1DSKjuB; arc=fail smtp.client-ip=40.93.196.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jgs3xYs2BEGarYrZED9NMzjEtR+1KFdbHtZJkh6OczvDjnfSFlZE7kVPTDmcys9C5VRwVRGmQZ9JdtP6TWISbZKFpFlwDjOCd+Ua/WXnF13Ke+t0bJUCaG57nae3Zt/C6SqCu3cErQgvrouEt3I1ZUFpikiYLTZ3jBhwSrBdvhNOdpMXMWUFq6aTgLYTLExdm9ixMzyoZRXYw1OfefOOIp/RhIxRbjVM//dPXDGUbhNjZoefmYI5SKWRr1TokWWo6TVapRqzOIyMYpK9iVydhjC5uR1vHmgiEsYngHi7kxlh2n4y3oDXNRP42zZL4+tSviqxtswMVKFxYPIE5ZFz3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9L3KIbazyGcaYK7/IBxNGZXoiyeDXpsA4ee8o3o3V+0=;
 b=Ok/SashdVy24ptqs/Cb1oWqrTAe9OSlnSFkIMVJV6f/CL3L/bMKE2CKlsUbtVKqSsP0UmeQEfCQrkR56/8EpFxnyzca97WNdt60znk5C5gkbiyagf0ahsbSI9hJsVU/pnXAOnXmWrm4XR6fk/3AqxReABH3EtESr8UgUjZa8+Dyi9WwvRcC7Jm5cK4R1KbvS5200a+hA55d7tWEQYJyUrFCvl7hEStnUN0/PS+2cQtxuJU/HcFG1mNjkkG1WP78af7LVA0i6Mer+bhwnNJxUPaO/wTQImBIwFGWPUOU5J2tcCNalRZUDAg9TG9I+KYvmf8yCG3waAPkz7lvTjCzJhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9L3KIbazyGcaYK7/IBxNGZXoiyeDXpsA4ee8o3o3V+0=;
 b=i1DSKjuBwuYdpm/BS7GQxFD90iw5IQVAUXN6UhsmlrBwoRIWjnWhc37FixOndU0yG+oFFQzTIGQUBBWuHiGUVijQmBm5qC1wfy2PdXvitcdhfkzMerNQCCio/c4yG9jGnwazBwlehTW3q7u2Tr2WOeY1Oj8tvM2wf5qRvhYOmf39sHC4zgPbg+JvlYCirinsqqJ70gSwpVVbIt+RoB9hw78p8O8E5+loirKuta4Hf6PP1HBPoo06IATTYJiPZ+2gQSlTNoCOvdD0plEe55kN7p0K0v+0C5Ec/A1c0Fov7Rq4i97yCAIA85YSV5QTG8avhdXDOH9Qg7p7OZtW63TMkA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by CH3PR12MB8331.namprd12.prod.outlook.com (2603:10b6:610:12f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Thu, 9 Oct
 2025 04:21:19 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9203.009; Thu, 9 Oct 2025
 04:21:19 +0000
Message-ID: <fa2e262c-d732-48e3-9c59-6ed7c684572c@nvidia.com>
Date: Thu, 9 Oct 2025 15:21:07 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 06/35] mm/page_alloc: reject unreasonable
 folio/compound page sizes in alloc_contig_range_noprof()
To: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc: Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 kasan-dev@googlegroups.com, kvm@vger.kernel.org,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Marco Elver <elver@google.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
 Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
 Robin Murphy <robin.murphy@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Tejun Heo <tj@kernel.org>, virtualization@lists.linux.dev,
 Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, x86@kernel.org,
 Zi Yan <ziy@nvidia.com>
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-7-david@redhat.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20250821200701.1329277-7-david@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR10CA0014.namprd10.prod.outlook.com
 (2603:10b6:a03:255::19) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|CH3PR12MB8331:EE_
X-MS-Office365-Filtering-Correlation-Id: f9f14261-b509-4115-1ab1-08de06eb4bc2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?c2MyVVVyaUt2aEcwRkI1Z0MwQ3ZJME1LSU85TkVHT3JCSitTbklLZUdHOGxv?=
 =?utf-8?B?T0tBa00yK1AyOC9hSUp3VnFsM0xKL3J4dzZDUFYxUURveWZqYjVJS1EzeWIv?=
 =?utf-8?B?STRIWjFIZEtBV1J0MlAvWkZacHhRVXdUdUZ3SHFqQlFIb3N3eTlZQWxkbDFG?=
 =?utf-8?B?VjkrVkd5Yi9OSjJpOUVBc1BmbzIxUlp4enVwYXRqVlNDbHo3czQ1VUJTYlJR?=
 =?utf-8?B?aG5Wc3hhUmNyazN6T3dZVXA1WDZNcHo2a3AyMnBhV0ZoYmVpYWdGcndWV2M1?=
 =?utf-8?B?d3g1cmo0RXppdEdEbFZhNFZVNU9qNWl0eTBaN1V5dWhxQ3lJK3Byc2x1aWJN?=
 =?utf-8?B?Tm5VVFdid3BSTGFVNm9ndGZHRVdwbjhCM2V2VSs0NytvMGZFaEtBMjVLYUg4?=
 =?utf-8?B?SXhFQmlWY3NwTms0V1VYd2ZpaVVHUFY0VjRpc0Z0M3o3QUpBUXdtMzc0dXYr?=
 =?utf-8?B?T2psTWwrb2lRMWJBU2dlNXpVTXZxb2U2Q2tydEFjbU8wUUY0SFB3M3lVNmh5?=
 =?utf-8?B?bElDenlnU1RnY3RqRTg3QnRYcFhvdkt1SHZMdGtwNnkrVTRYejJQN211Zm9Y?=
 =?utf-8?B?Q2hPd0c3VEc1Z1VnYmJMb3BVSmEvVjVtdm5FaDRaTlVsZWdtdCt6MHRQMWNO?=
 =?utf-8?B?SVJienRKNDEvQXFzM0NpNGMzWWd3VVRuTVZ0ZmdUTDVHRkJjMkd5UkZodXkr?=
 =?utf-8?B?VmRITEtvSmJReGJGTlQzZTE0dWhwRkdORkw2WWFkYlJjK3FFaWdiNkxoWHRw?=
 =?utf-8?B?eTRwbmZWSDE3blQ1QW9iaTZQY3RaR2xHeWR2NHVxNTB6LzYxdXZiWXpDTnlu?=
 =?utf-8?B?bEdhUDBCVjdqTWpxaU9yeC9tZ3NuTXlpVDNER1g1U0t5RDFvSzdyaW9TYmhL?=
 =?utf-8?B?RTA2VzViWXlpR2s0dTFrWlNWVFdsc0JTZDVKT1h0MTZhTUUvbXV5WjJHUVky?=
 =?utf-8?B?R3F5SmlXbjhQVGlFOWphNloxanBCcFMxc0hXUFB0M0wxZVZleWtVYVExU1Mw?=
 =?utf-8?B?OW9KVTVZL3MrcmovMW9PR1h5Y3BQS2dpZmRNK3hHK1I5ZUpOMUx6bFdpU1k2?=
 =?utf-8?B?aHcxdVV3OEhDN1M1MEx2ZytRS3BhcnpNV2NEeEJKOXg1R3ErLzhaQkl5VGp0?=
 =?utf-8?B?dXdZMzNJK1ZDWUo1Rks4R21jcitROXJGN2xGYWxMWDVGdjE5WmtXeTdua2JJ?=
 =?utf-8?B?L3dyckd1NWk0dlpGTEE5L0p0T3NpZDZCMGtKNjQyUDkxdlNjWC80TEFhOXZK?=
 =?utf-8?B?RDM1MW5ubTUvMUYzb2hwU3A4RGZFczNKYllnYnJVQjQ2WTIvaFEvZEU2UU1N?=
 =?utf-8?B?SGl4YnF3R3cwUzBjWHJnbnJxZklBNTVyQlFXWUQ3UUUzVEw2cXJIOGFneVFk?=
 =?utf-8?B?Vzk4UmFnSDBYVDVOVXFpV2NlMndxRnNubldzaTYvVEg4ZmlVcHlybXFQekMw?=
 =?utf-8?B?M0FucnY3cDNlcVp3dFJGNk1LRWNyc01yUzJUblBQS09OUndpVWFrM29PdFJN?=
 =?utf-8?B?R1d5NmJiMDlSby94d1FHMzFsZ1RCMFZVMVNjM2tIL2twNUsvMEJoSTllMjFo?=
 =?utf-8?B?RDBydkE3RG5QQko2TXZjbjBiYjQ2UXlrRDRzcHdDcWdFanAwQVpGaElOVGVx?=
 =?utf-8?B?V284eHU2V2xjNXd0Um5RNGJrdFQwU2NXQlRaN1V4TGpIbXhEemZRVi9zY1dG?=
 =?utf-8?B?aVU0R1VGYlJlRlppTDRnRGRQOVMreHFtSStiajFWSklXeWhWWm1lcWJ3TTRr?=
 =?utf-8?B?MFFQL09IeTBCQm12dkRIVWhwMlgrdGwyTTB2Qlo1Z1VGNU51aDJYeTB5eDVy?=
 =?utf-8?B?WlBBVFBBZUY1eklKY2lQSm1BSGVrM0M1bHFHWUZ3NnQzVURJYStLT2dXTXpZ?=
 =?utf-8?B?L1EvRDBmZDNON1pBcElwVFhZNVcwRUtyNS9TRU9VbVpKUnBBTTBpQ1ZnR2lW?=
 =?utf-8?Q?dQaf4LoS1+Hclrh20eZ80Iuhp0qvZe8U?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dm1yU3lCRTEyaEV3c2l3NVcwNWQ3eVpiTTQ3QzduQ01GUjVVMVlsL1NNSkZx?=
 =?utf-8?B?OFc2bDdoNG9xM3pOUGZOYU1oV2ZYY2pBS2IvVmJCcjRBWTVpdjZ1d3FOeDdO?=
 =?utf-8?B?dzY0SDRhb0JNNE9UbkcxTU5sRHhHZXFXM1R0MS9jTURpOXAxaFpZSFJtbEll?=
 =?utf-8?B?RG5RSGt6aHpYWjljdUtwVmc2VmMxeDhCcVgyemc4cWlpSGZpdGdCcUs3dzk2?=
 =?utf-8?B?WUgzZFFCVSs2VGhXZXNJNENLMncyTXoyWjlMTms3bktQSVJoaUVtbUQ1cGxr?=
 =?utf-8?B?NWI1aDRMaFpoSHMreEVrejFaZWVBVE4rRGV0Tk4vT3dTMEZUSlBxbDdJakl1?=
 =?utf-8?B?S0RvOWRYOFFwUnRwejY4VjBXUlIxR0QybGRYNWF5WUNiWnVDOUxTUDQ5VTBx?=
 =?utf-8?B?VWRkOXRiMTdIelBvdmE5enhsV2hNMVhQeTVaNG5HWFRKTEFIMUhxVmlIQklJ?=
 =?utf-8?B?bXhPdmJ0dVpIVDd1cndhN09KNmJQSkd3Ym5ubzIyR2JBSm1CbzBFajhTZXJm?=
 =?utf-8?B?T2p6eFBzQXl2by80SEJ2dnFyS2pWUG82bVR2TWJmM2JXL2xnWGZ0RU1RRW5R?=
 =?utf-8?B?Vkp2NytydTdWaVlkSWZvZmhUM2daSFlJSzFST2EyaW5ndnBkRFNQVy91T2xi?=
 =?utf-8?B?U0ZwM2h1aEdLSituVFhsb2YwQU1lTFhUS3F1WEN1ek0vMDE0QnI0Q2tna0di?=
 =?utf-8?B?RHNTais5SXNoWURCUmxmbmFzc3pmQ0JsV3VWS3pFQkc1WU5DZzR5WnVuWlhD?=
 =?utf-8?B?L0s5M293RERLa2lJYVFhVXhoOWNrRzNwek9kc0JnMWxZeUU3czBQRmpBcUpK?=
 =?utf-8?B?YU9nYUVGRytyVmMvSXljY0tEaE55Qm9qWTNoR2dzUkRNV0FteTZ2WjJuZkhE?=
 =?utf-8?B?L211cUx2Ri9sd1JPcmg3OVUyTWVveVZxaGFOSXQ3dmUrUE1xSmRQancwRCtC?=
 =?utf-8?B?L0RNVVNWV1lhaDQ1Z2RpSHprNC80cHJPTUt2cGpuVkJGYTdPbkZYWmNlWno4?=
 =?utf-8?B?U0RJMVF1SFF6TXRQaVBDQmN4TDdBMVFmN3VlcE02TVVsWWZFYUN2WWUwMzh2?=
 =?utf-8?B?eGlXdGt5QW9TWjliT3RwN2VrMm9pd09GVWxJZGV2ZE15bUdYRUc1a2tKN3dz?=
 =?utf-8?B?NDZSN2lmdkZwejhuakg1cFN2Sk5rRHZIR3FvVUJVcFVaTmxub1V6bE9kRnY5?=
 =?utf-8?B?TDhDa3ZFa1hvN1JYSmlld2JTbmtsOWJROWMvZHIxMzAralprbmgzRzV5UExm?=
 =?utf-8?B?U2Zwc3orWlluQ0x3NVh0MFZESnB4amo4aEJod2JoLzAwZUZnUFdXRG5RVW56?=
 =?utf-8?B?bEZ2d2Rja1RRWHNoMUtOaEZzNWRPTnlJNHVVQlUvcm5hRzZhbnF3UmQyVkdK?=
 =?utf-8?B?dG5nZ0NKdUlZWWtTRjFxUzhpT3hqV3NzU3dLNnRJZU45RFpYYWJEZkdIMmE3?=
 =?utf-8?B?UmRyQVdGMU4yTnppbXBzZjltcEJTK1lwM0FKc2Q0TWx3cElRWXdkTWQ4Qk1W?=
 =?utf-8?B?d0NEaDZ1QVd3NXRBRi9zRTd3Yk16SXJtbXBqVjRPVy9KZitpZEFWQ1E3SG5l?=
 =?utf-8?B?ZFRCQzBLeStmZy81dSs1V0twL3BwOVUrQWhOb0hPNkordWUwVDNMbkZwcXBj?=
 =?utf-8?B?aG8zd1NoKzd0L1pYN09oUkNrWFhWNHBJcEE2RlpVMHE5dDhVSlFQTGpFdkFs?=
 =?utf-8?B?VE1zSlhXTWVPYVFBTGhOZGMxVUZOUll1a2x0a3pESFFGVHFYNEdPN2hmTkZG?=
 =?utf-8?B?M08vamRuNUp0Nk9LYzg4UzZoTHhEbk5sOE1mNXF2ck1vTFpYRXB1NGpZeXd5?=
 =?utf-8?B?emtTdG9sRlNzMG82TFlzeGxiUVIxbHEwNzZ3cmFiSHZOTVhHalNKMENCUHE0?=
 =?utf-8?B?MHVZZkRnMjRFNlB2MDB4cFFQZ2p4K2tQeFd0aFdGVFpDK0d2SDVWb0pOUllj?=
 =?utf-8?B?c0w2dkFOTmxkcUlSNzZzVVN2cDZra0JkdWpaaEdHOVZYcEpSalk5cENuS2Rm?=
 =?utf-8?B?SGU2Ujk0cDZ4bTc4TGFjajhyN1d6WTJtV3RqUWNwQmZFcGd0aUp4N0diLy9E?=
 =?utf-8?B?eWY4RmpOb1Q1ekhDb0t3VVBPUEhnWTRxcGc1alRRUnROMWxuejF3cUl6VXEy?=
 =?utf-8?B?dzNlVFJ2OWRkamo5TjJJa3RzS2NqdUpveWp4RTZqSU0wTlloc1Jxc24zdEQ1?=
 =?utf-8?Q?bJtrBFWenpMTZbYy0A8lTcO7jqb2MYQcfdN6dfejNkVF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9f14261-b509-4115-1ab1-08de06eb4bc2
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2025 04:21:19.2847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2AEpnwc3+BotgA52RYKTON3+f19b59Fiq4FHb018blzYByIslGcDS3XVhqxq/0dQHMAB9RdV2K5F61NyEpKODQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8331

On 8/22/25 06:06, David Hildenbrand wrote:
> Let's reject them early, which in turn makes folio_alloc_gigantic() reject
> them properly.
> 
> To avoid converting from order to nr_pages, let's just add MAX_FOLIO_ORDER
> and calculate MAX_FOLIO_NR_PAGES based on that.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  include/linux/mm.h | 6 ++++--
>  mm/page_alloc.c    | 5 ++++-
>  2 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 00c8a54127d37..77737cbf2216a 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2055,11 +2055,13 @@ static inline long folio_nr_pages(const struct folio *folio)
>  
>  /* Only hugetlbfs can allocate folios larger than MAX_ORDER */
>  #ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
> -#define MAX_FOLIO_NR_PAGES	(1UL << PUD_ORDER)
> +#define MAX_FOLIO_ORDER		PUD_ORDER

Do we need to check for CONTIG_ALLOC as well with CONFIG_ARCH_HAS_GIGANTIC_PAGE?

>  #else
> -#define MAX_FOLIO_NR_PAGES	MAX_ORDER_NR_PAGES
> +#define MAX_FOLIO_ORDER		MAX_PAGE_ORDER
>  #endif
>  
> +#define MAX_FOLIO_NR_PAGES	(1UL << MAX_FOLIO_ORDER)
> +
>  /*
>   * compound_nr() returns the number of pages in this potentially compound
>   * page.  compound_nr() can be called on a tail page, and is defined to
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index ca9e6b9633f79..1e6ae4c395b30 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6833,6 +6833,7 @@ static int __alloc_contig_verify_gfp_mask(gfp_t gfp_mask, gfp_t *gfp_cc_mask)
>  int alloc_contig_range_noprof(unsigned long start, unsigned long end,
>  			      acr_flags_t alloc_flags, gfp_t gfp_mask)
>  {
> +	const unsigned int order = ilog2(end - start);

Do we need a VM_WARN_ON(end < start)?

>  	unsigned long outer_start, outer_end;
>  	int ret = 0;
>  
> @@ -6850,6 +6851,9 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
>  					    PB_ISOLATE_MODE_CMA_ALLOC :
>  					    PB_ISOLATE_MODE_OTHER;
>  
> +	if (WARN_ON_ONCE((gfp_mask & __GFP_COMP) && order > MAX_FOLIO_ORDER))
> +		return -EINVAL;
> +
>  	gfp_mask = current_gfp_context(gfp_mask);
>  	if (__alloc_contig_verify_gfp_mask(gfp_mask, (gfp_t *)&cc.gfp_mask))
>  		return -EINVAL;
> @@ -6947,7 +6951,6 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
>  			free_contig_range(end, outer_end - end);
>  	} else if (start == outer_start && end == outer_end && is_power_of_2(end - start)) {
>  		struct page *head = pfn_to_page(start);
> -		int order = ilog2(end - start);
>  
>  		check_new_pages(head, order);
>  		prep_new_page(head, order, gfp_mask, 0);

Acked-by: Balbir Singh <balbirs@nvidia.com>

Balbir

