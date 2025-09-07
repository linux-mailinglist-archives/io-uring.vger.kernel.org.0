Return-Path: <io-uring+bounces-9627-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C0495B4791D
	for <lists+io-uring@lfdr.de>; Sun,  7 Sep 2025 07:14:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 99ACD189DC65
	for <lists+io-uring@lfdr.de>; Sun,  7 Sep 2025 05:14:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D5511D31B9;
	Sun,  7 Sep 2025 05:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GJCW+3DS"
X-Original-To: io-uring@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2060.outbound.protection.outlook.com [40.107.243.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0688B15E97;
	Sun,  7 Sep 2025 05:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757222073; cv=fail; b=AcJa5xcUiBNXEvt4LoQBF/E7ysDbnM2ZXj0zbCzAyrYvCd4nh7mn2JBtrcQsrcEtRs/pw7EOCNBq0z6QvlP7/30wznU8PkDQn0xFk8eVYEf808Mp5IW7uOCuqs+V7XPwAOsgFnQ8GosIPsOdkK8AeeBwgbHAfm3m9bvphV5k/oQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757222073; c=relaxed/simple;
	bh=SHJz0LEfuLGtD4Td4sbFzxd3lMl+hj4GwUs2BOP5cVk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BnyS8NuwY7rLm0imEx2FTSg+QcimJZpuvStcfcKjzqeDAweiCl4KzMBxHA8PhKzzQPaqHAmDhXykmi0tVnjAfJoAP41hh1VJPU13gcxyL8YzRqfUSSEuWdxVCvvjraCE8964VbsZZU2vC6YXzN1PQ85RSxLeWorv5267V8PwyWk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GJCW+3DS; arc=fail smtp.client-ip=40.107.243.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yUBsZoa48ubr5UfQCm1JGG4S8RpaYQuK3qinFtfTVoIyblstuFvs1UtepWrL6qmhVxym1pIpbEsbMAvn8OLpFtnGKLdFRogzsXju1CrLLfxBypz+Hkszu+T6TOwyetB17oSLAcgJzki+fDcVYN+oiTtl/ehsF6gZlXmpmGbHNSDpgD44y8PNgeLafTwUoVPHuULARbhwZIgo3c8tKzUiTcLIbjk9SxJ0Ts4DKpyC1PPtY5Ts15C7DoSWyHHrOZcmwjhmNkBgLbdBHDWKr41d/hH0Iq4wl03K3165j0jxtSFnMsVtfLQLsKI5Op+VEBMmGm8nEPF6cEUtHrz9CFbJvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZBp52V91Gxr27f7RudT0aNk9Xj8vFIecZ5YmKsPh8yA=;
 b=GGSMAlpnRrdP4a44ktU29+KpniQMk+UW6Gda+8KCQog3qwPiGbBpp73s+/BJXgR5l5bJpq0nocNaVsitWzZ27gkvAs7+LxMqwmYUV2xlKVIBVq5LtnfXWkMzSe/DZQIkP8OYzgKltBhzt4+fC0FDtL1N5BxRrHQ6eiPyq6WPHX7Mw70yooOKJZYN8RX93Z/eXOoJCFvUeMmcLM1q/RmGzGzlKZ0t8Hie845b//12OtmTUXi4bBsLE8ZzjltETh8kwzNO/DLMfeCGMi39ZmzVvGlWny5kJms7IhwCe7n+ssvUIfmauKp8Nas/sp0t4pEIwgYbDOC5YTUN1q3j61eICw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZBp52V91Gxr27f7RudT0aNk9Xj8vFIecZ5YmKsPh8yA=;
 b=GJCW+3DSmriH1MADLp7VlsqRk2CVBWqYaaZCnkrNj9TbrTt6BEgQdv1kl/bPCLxxWONcA5b3HSE64EHr5tjCu6yjJpMegbjJgswtpzQdoqLvQOiiujYIZT3K0YBRTycLIXZ6Ou7WG3XMLHyTM/e0/txaULr9tJCar2wjSGunmmp/paDLnohvQsoxjL2yYEpwgWaCnYt3R61pMuTiBf7SZU14mP6PbMIiMe96MNr5AzKQ1lYjYeivnO3lExo92w7ONdvD0naIzzrKG43FmjQU26Y1sHC7eistWEzdn2W5ldnyprC9DRSDIom6a/g/qJD3t2BQfO6vC9HdWZQheuBdjg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5968.namprd12.prod.outlook.com (2603:10b6:408:14f::7)
 by DS5PPFDF2DDE6CD.namprd12.prod.outlook.com (2603:10b6:f:fc00::665) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Sun, 7 Sep
 2025 05:14:26 +0000
Received: from LV2PR12MB5968.namprd12.prod.outlook.com
 ([fe80::e6dd:1206:6677:f9c4]) by LV2PR12MB5968.namprd12.prod.outlook.com
 ([fe80::e6dd:1206:6677:f9c4%6]) with mapi id 15.20.9094.016; Sun, 7 Sep 2025
 05:14:25 +0000
Message-ID: <0a28adde-acaf-4d55-96ba-c32d6113285f@nvidia.com>
Date: Sat, 6 Sep 2025 22:14:19 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 19/37] mm/gup: remove record_subpages()
To: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc: Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, kasan-dev@googlegroups.com,
 kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
References: <20250901150359.867252-1-david@redhat.com>
 <20250901150359.867252-20-david@redhat.com>
 <016307ba-427d-4646-8e4d-1ffefd2c1968@nvidia.com>
 <85e760cf-b994-40db-8d13-221feee55c60@redhat.com>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <85e760cf-b994-40db-8d13-221feee55c60@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0048.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::23) To LV2PR12MB5968.namprd12.prod.outlook.com
 (2603:10b6:408:14f::7)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5968:EE_|DS5PPFDF2DDE6CD:EE_
X-MS-Office365-Filtering-Correlation-Id: 89b9ab1e-80e3-48bd-897d-08ddedcd6976
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N3VhS0huWjQ4a3lsVHYzQ0ZwUFpBUjlPQjE2VXV6aS8zdmFuZzZLajVkaXpz?=
 =?utf-8?B?bEpMMWxBZ1BOWVU3QjZRaVpkNFA2dFdMTXJ0VmJCc0tSYmJTd1ZSQjhWS0NR?=
 =?utf-8?B?L2JCYU5wYXhNU2tweXhzcFUwQlVkSTgwQjRaSCsxUWdwSHpvU1NqYWo3eWlN?=
 =?utf-8?B?YWphSzhUcWxUU1dsY2VtdDdvZmRHRC92Sk1nSmZCeW1tTFQ3YUVia0pxZGtv?=
 =?utf-8?B?aTRMa2hmMEYzVEZTejRBck5nSXdWb2tHbnNaOWkyMDNmV1FTWUNYNVRHMmFw?=
 =?utf-8?B?cUJmdGM5WmJDTk1SWkREeTlUR2E5cFpRTjFDTHdkSFRLZ3FNNFVXQmtyMnZY?=
 =?utf-8?B?MlZCS1JScTJPWWNjaWRnYSt3STA1Nm94bGorSHlkZ05iM1RrQmNVaFRzRjM2?=
 =?utf-8?B?b0s5MnUwV0w4RVArdXVLcmFtUW9JT0VORFpqbEFOYnROZDQ0Uk1idHNnSnZQ?=
 =?utf-8?B?TzdIVHZpRExrMFRjV2Y0YUtKU0NJRnRxR3hhbHIxQ0RmNG1rczd1NWtDWVZs?=
 =?utf-8?B?ZTdJQTZGSmFHczhaWHRCVjVQWjdiVnA3MW9wdXNPQVp6djJVU3lFTTcybFNo?=
 =?utf-8?B?UFNHTkg3Z2RCZEYyTVVFSUVna2thM3Jwd3hZYkFuUm1oZlFtUDRnRTZxVGVq?=
 =?utf-8?B?N1ZDVjk0UE9seTRvTmxDTVYrUFJ0Uy9yV2xROEliWk51eEtDdXU0Z3pYWXJp?=
 =?utf-8?B?anBGUkt5bnRwSFo2a2ljNmVxTEIwKys2T2lQSFhwTkQrdkVvY2hxU0VUWThS?=
 =?utf-8?B?OHgweUV2elJuR2VmYU1kb0VBRHNnYXpyODFueFEzSktNQUNMTnRzTkRKbDdP?=
 =?utf-8?B?RlBvWGVvMm1uV0tlcmc4cTlRMllKTGYvUEpmMmVVTTNnWFJrMjhMSlRtNzBG?=
 =?utf-8?B?ZDArTVhwaHJZdXVoOXhFYXA1QVJRWFRJd1NkTnBmdngrWGxnVWNhUUVSUmov?=
 =?utf-8?B?K1RLQnNvQUM2NzM0WE1ONzNjUzdFeUl2RjB1NmFVRDR6VlJLTHpMdTNlOHNB?=
 =?utf-8?B?SVNXa05oOUw2UDhkWWZmZmpLd215c3lubnphcWUrMHpKSkxSR21MOEJDMllY?=
 =?utf-8?B?aWFVbEd2cnc4WGhkcEdMTnJKaVFBNHl0YVBVV0FxclZEb0JoVjlEV1AxNHFh?=
 =?utf-8?B?Kzh5d1JQcmNoRmlpalRrc2ljTGtKQVc2aUJJdlZML1pGVVVCZTByTGFFWW5N?=
 =?utf-8?B?eTRIOE5Nb2Y3OGFucVZSVGtMaW5xeHdwV0tad1E4cE9GUk12MDJOU0w1U25N?=
 =?utf-8?B?dDgrdzZWbUd4VjFXZTk1OFZMZmxMbi93cXp5c0Z2UHBWOXc3OHpJUEhCOHFQ?=
 =?utf-8?B?MUk5RG5DeWs1MXVLOHE5TTRCMkl3cXFTRHA0WWxxNWhVV0gwa3phRitqTlNC?=
 =?utf-8?B?c2pTdlpFdW9wblI3c3AyYmQrNDFvNWFYT0dzM3YwRnZXUk9SUHFEUTJqM1pp?=
 =?utf-8?B?M1FJRUVVOWpEd1hTOWYwUjAzVjJpcnlNZkhWTnhIdGJ4NzhlTGJIK2NabTgv?=
 =?utf-8?B?OGxGNUQ0cU43UTZuNXErdGVnanJuTEd2M0VFaTlDNzJOZXQwOTVYQ2tkWnlO?=
 =?utf-8?B?K0cyMEFKUGFzL1R2ZXlYLzVRbWpTNUZMeU5qSGVVYXpCOTV5OFcrdlFrL0JT?=
 =?utf-8?B?cEFROEViM1JtN3FySDd4b0xJbXpyemgyN0x6QmkxYWpZUlprU3VMR0oyYlVQ?=
 =?utf-8?B?M1FNY1lpVjhhYmlhVVl3U1JBTUJ4SjFVOUdURFZDVm1RdFB2Q1hMS0lCeEY4?=
 =?utf-8?B?NUtsMjNRa0NQUHJHU1MvMURkK3BEcEEzY0ZUcDBjR1N1Qit6RTJHU1kreEVr?=
 =?utf-8?B?MUxxZW11V1JCSGR2R0w0RTRzNENkeEc5dGtFWDZKanBZaGNGVDBsL0VjdzQy?=
 =?utf-8?B?U0FKMWs2N3lqR2txMkI0Sm5kMEdkeGpSN3U1dDhHZzg4Qnc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5968.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z2FmbGhrTlFWREJvWjdCU1VYNHgya0haRTlqdUtTa0c0Z2VPbG4rS3NOQ3VP?=
 =?utf-8?B?aTc3dURUbGo5WXg3ZXNRWEJQVWdabGRxOWw4R2RUS3UwczltdmtmdnZlUlRz?=
 =?utf-8?B?OVp6R3NaazB0RXVzZUxHTld4Ny9jU3BxMWd2ZVF6YlFhV2lYQnVrK3orK2pZ?=
 =?utf-8?B?aWMvOFN2UG1DTDVZaDFtUVVkQ3pRV08yTVNYRTdkMTIvbTB1OWh0Sm1HMCs3?=
 =?utf-8?B?WUpNTnVkSytmdHZmOVZvR2tVbTNxQjlkb29xZnB1bzhObzliaU84UG92RW9E?=
 =?utf-8?B?M0lzeXUvYnpkelJiQk1zLzhWazN1dThSN0JnRzkyQWZMSVdnMjY3cnViQjhZ?=
 =?utf-8?B?QkhxUVpFZHpGRDRObnkzbTA5QnJlMlhnaXYrSCtWMXBQZ0V2MktGVTJhbTRn?=
 =?utf-8?B?bGJFeU5EUlpPVGwyd3hxc0JSa3ZOUTh3NmxZdkkrOUZRVUR4ck0zVTh4dzlY?=
 =?utf-8?B?YTdUTXBtZHhMdUQxRzJwdDB1YmFiRUQ0YzFCa0JjQ08zU1V4N0tVUGJjTmVo?=
 =?utf-8?B?RE5JTUV5VFlOaVlTMEFzaU03UitTVnprSXZoOWxwU0doN0ZsK0JCRlJMaitY?=
 =?utf-8?B?UmFHeXV0ekg3QVZoNENJaEc2QjQ5WUpaMWp5bTBwMnllTGs1Z20xZ0x3a0Fs?=
 =?utf-8?B?Q2NKblU2NUVEV0lqQjZBUUYzN0w0RE9kUk9ySlM2eDVqTG1ERzlTOWUzMjJj?=
 =?utf-8?B?M0JrZXN1MmxoU1RLNFZMK0pwLzA3NHdCUTNmazZJM01zYTcrNGsrYXNIZWVM?=
 =?utf-8?B?TlBlT245aDZ1VHlVcVlDdUxEMWw2QXRNU1BFVW5UajduclBnenMrNXBRNUMr?=
 =?utf-8?B?NWFyQ3FsVzhuNGNmSnY1Mi9ISndPWjliWW0rS0xJc2V5QzVKSTRvalA2aFUw?=
 =?utf-8?B?SE1KTkVpTEVFQmtKUTg2VmkvbXF2L1NLdFBMRzNDS1I2MDAwKzZuZmtzd1FV?=
 =?utf-8?B?TjhreGszMlJkdFJyK3RRbnpQZ0RxVzEranZVNS9kRmNQUHIzNzBNNWVOUHVi?=
 =?utf-8?B?RGYyVU9qVStQQXUzR0lYaXlKOENCV0RWOFVDT1dOZ01tRGNRdHhVazNKKzdB?=
 =?utf-8?B?Q25OT3FaNThIV3RWVmVDV0paV2FJU01sb3IwTTVrRzZEaWRzY3pBUmJlRit1?=
 =?utf-8?B?MmhJbmp4ajI5OENiYTNra2RlaEZjRmhiRmFPVDZZdGN6YUFyc1N1MDlrVlJ2?=
 =?utf-8?B?TnpqdWJpVWxyRTFXN09MSDMvUUdjZ1lrdGZhN2xEeldEQjRGRjA1RWV4cGdS?=
 =?utf-8?B?eTBMZWRFU3NLMnYrTXdTMGFEbXI2V2M1SU1KZVVIVGF0dFkxV0xMNmdWNWhF?=
 =?utf-8?B?dDBUZ0l1Mm4zU3Y1UWR0dnVsWExuL0Z2bHVEQ21ML09TWlgwQXJRTzhaQTJr?=
 =?utf-8?B?SDVvQ001cFV1NmdNaGF0ZUJneEFlam1zWlAwY0lzTWVjelEzNnFscGhZbGtv?=
 =?utf-8?B?S0crbnF2MDc3U1QxLy9WS1ZvSUdqc0cyK2wyWk9mRnZXWGIxaGE5WWFwbWlZ?=
 =?utf-8?B?UjNMT0hIQTRhUHV3MFNVVFNjSEtmbklKamVzMDZpOVdNRGdnNG8wbVpKakdo?=
 =?utf-8?B?eXpGaDZobXM5NWVTZnY2VUcvN1dJek1YT0w1UFduazVqOUR2RjVHQ3lZOG5E?=
 =?utf-8?B?cHhzSHpmeXBQYmEvTHNEdWlFVjVtdTFoMzZpVVVZaGxQc2oxNUt4bFBIT0do?=
 =?utf-8?B?SEhDMDRJK2NHOUZpaVNqWkxxNFF1WkNRTlZ5amJhcXBIS1BDYzVhcnVVNUI0?=
 =?utf-8?B?Vy9vOWFWWG1HcHNOWEtCRHR5L2JqM2drU2pFSHZmcVJ0Wm53Q1NGdktNMDl1?=
 =?utf-8?B?dU9VUUdMaldtdkQyVTJRLysvR3ZKZHZmem85alRmUGtzSlQxZlFOdkZHVlJy?=
 =?utf-8?B?OHBkYTZ4OWdia2tXTXk5dE5EZkdTQVNrSmc5QXlDNUdDU1BQbmo2c3ZaNEY1?=
 =?utf-8?B?YTBlelUxU0F3Z2h5alpQNUdkM3pwNDFwSHRkV2lUbWIrTUVscVljeUVlbUsy?=
 =?utf-8?B?eWkwdDF1Vk5uUDB6N1pDU2UzSVVoZXUvU2JWRjhTK0NMZFppUzhLbEgrTkUy?=
 =?utf-8?B?NXo3KzBPdkFPNXpTSUZaY0R4Z2hMbkZpaXhpeWxCbzVhWExlZUtxUmM5T0Ri?=
 =?utf-8?B?NmNoNmZJdXZTRU04OGRJWjhMU1FDZTZDUGlhVHRxYm8zZzRVQWtQamFCdm41?=
 =?utf-8?B?a1E9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89b9ab1e-80e3-48bd-897d-08ddedcd6976
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5968.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2025 05:14:25.2162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nMH9E6FIAuGh537ODX0TA1FL8Y+H+9s2oVS0wOHG+o0yolAQXZ6PgvaRmfySFg15SGYvEm2Bjkc1N1v56jE8Fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPFDF2DDE6CD

On 9/5/25 11:56 PM, David Hildenbrand wrote:
> On 06.09.25 03:05, John Hubbard wrote:
>> On 9/1/25 8:03 AM, David Hildenbrand wrote:
...> Well, there is a lot I dislike about record_subpages() to go back 
there.
> Starting with "as Willy keeps explaining, the concept of subpages do
> not exist and ending with "why do we fill out the array even on failure".
> 
> :)

I am also very glad to see the entire concept of subpages disappear.

>>
>> Now it's been returned to it's original, cryptic form.
>>
> 
> The code in the caller was so uncryptic that both me and Lorenzo missed
> that magical addition. :P
> 
>> Just my take on it, for whatever that's worth. :)
> 
> As always, appreciated.
> 
> I could of course keep the simple loop in some "record_folio_pages"
> function and clean up what I dislike about record_subpages().
> 
> But I much rather want the call chain to be cleaned up instead, if 
> possible.
> 

Right! The primary way that record_subpages() helped was in showing
what was going on: a function call helps a lot to self-document,
sometimes.

> 
> Roughly, what I am thinking (limiting it to pte+pmd case) about is the 
> following:

The code below looks much cleaner, that's great!

thanks,
-- 
John Hubbard

> 
> 
>  From d6d6d21dbf435d8030782a627175e36e6c7b2dfb Mon Sep 17 00:00:00 2001
> From: David Hildenbrand <david@redhat.com>
> Date: Sat, 6 Sep 2025 08:33:42 +0200
> Subject: [PATCH] tmp
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>   mm/gup.c | 79 ++++++++++++++++++++++++++------------------------------
>   1 file changed, 36 insertions(+), 43 deletions(-)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index 22420f2069ee1..98907ead749c0 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -2845,12 +2845,11 @@ static void __maybe_unused 
> gup_fast_undo_dev_pagemap(int *nr, int nr_start,
>    * also check pmd here to make sure pmd doesn't change (corresponds to
>    * pmdp_collapse_flush() in the THP collapse code path).
>    */
> -static int gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
> -        unsigned long end, unsigned int flags, struct page **pages,
> -        int *nr)
> +static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, 
> unsigned long addr,
> +        unsigned long end, unsigned int flags, struct page **pages)
>   {
>       struct dev_pagemap *pgmap = NULL;
> -    int ret = 0;
> +    unsigned long nr_pages = 0;
>       pte_t *ptep, *ptem;
> 
>       ptem = ptep = pte_offset_map(&pmd, addr);
> @@ -2908,24 +2907,20 @@ static int gup_fast_pte_range(pmd_t pmd, pmd_t 
> *pmdp, unsigned long addr,
>            * details.
>            */
>           if (flags & FOLL_PIN) {
> -            ret = arch_make_folio_accessible(folio);
> -            if (ret) {
> +            if (arch_make_folio_accessible(folio)) {
>                   gup_put_folio(folio, 1, flags);
>                   goto pte_unmap;
>               }
>           }
>           folio_set_referenced(folio);
> -        pages[*nr] = page;
> -        (*nr)++;
> +        pages[nr_pages++] = page;
>       } while (ptep++, addr += PAGE_SIZE, addr != end);
> 
> -    ret = 1;
> -
>   pte_unmap:
>       if (pgmap)
>           put_dev_pagemap(pgmap);
>       pte_unmap(ptem);
> -    return ret;
> +    return nr_pages;
>   }
>   #else
> 
> @@ -2938,21 +2933,24 @@ static int gup_fast_pte_range(pmd_t pmd, pmd_t 
> *pmdp, unsigned long addr,
>    * get_user_pages_fast_only implementation that can pin pages. Thus 
> it's still
>    * useful to have gup_fast_pmd_leaf even if we can't operate on ptes.
>    */
> -static int gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
> -        unsigned long end, unsigned int flags, struct page **pages,
> -        int *nr)
> +static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, 
> unsigned long addr,
> +        unsigned long end, unsigned int flags, struct page **pages)
>   {
>       return 0;
>   }
>   #endif /* CONFIG_ARCH_HAS_PTE_SPECIAL */
> 
> -static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
> -        unsigned long end, unsigned int flags, struct page **pages,
> -        int *nr)
> +static unsigned long gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, 
> unsigned long addr,
> +        unsigned long end, unsigned int flags, struct page **pages)
>   {
> +    const unsigned long nr_pages = (end - addr) >> PAGE_SHIFT;
>       struct page *page;
>       struct folio *folio;
> -    int refs;
> +    unsigned long i;
> +
> +    /* See gup_fast_pte_range() */
> +    if (pmd_protnone(orig))
> +        return 0;
> 
>       if (!pmd_access_permitted(orig, flags & FOLL_WRITE))
>           return 0;
> @@ -2960,33 +2958,30 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t 
> *pmdp, unsigned long addr,
>       if (pmd_special(orig))
>           return 0;
> 
> -    refs = (end - addr) >> PAGE_SHIFT;
>       page = pmd_page(orig) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
> 
> -    folio = try_grab_folio_fast(page, refs, flags);
> +    folio = try_grab_folio_fast(page, nr_pages, flags);
>       if (!folio)
>           return 0;
> 
>       if (unlikely(pmd_val(orig) != pmd_val(*pmdp))) {
> -        gup_put_folio(folio, refs, flags);
> +        gup_put_folio(folio, nr_pages, flags);
>           return 0;
>       }
> 
>       if (!gup_fast_folio_allowed(folio, flags)) {
> -        gup_put_folio(folio, refs, flags);
> +        gup_put_folio(folio, nr_pages, flags);
>           return 0;
>       }
>       if (!pmd_write(orig) && gup_must_unshare(NULL, flags, &folio- 
>  >page)) {
> -        gup_put_folio(folio, refs, flags);
> +        gup_put_folio(folio, nr_pages, flags);
>           return 0;
>       }
> 
> -    pages += *nr;
> -    *nr += refs;
> -    for (; refs; refs--)
> +    for (i = 0; i < nr_pages; i++)
>           *(pages++) = page++;
>       folio_set_referenced(folio);
> -    return 1;
> +    return nr_pages;
>   }
> 
>   static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
> @@ -3033,11 +3028,11 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t 
> *pudp, unsigned long addr,
>       return 1;
>   }
> 
> -static int gup_fast_pmd_range(pud_t *pudp, pud_t pud, unsigned long addr,
> -        unsigned long end, unsigned int flags, struct page **pages,
> -        int *nr)
> +static unsigned long gup_fast_pmd_range(pud_t *pudp, pud_t pud, 
> unsigned long addr,
> +        unsigned long end, unsigned int flags, struct page **pages)
>   {
> -    unsigned long next;
> +    unsigned long cur_nr_pages, next;
> +    unsigned long nr_pages = 0;
>       pmd_t *pmdp;
> 
>       pmdp = pmd_offset_lockless(pudp, pud, addr);
> @@ -3046,23 +3041,21 @@ static int gup_fast_pmd_range(pud_t *pudp, pud_t 
> pud, unsigned long addr,
> 
>           next = pmd_addr_end(addr, end);
>           if (!pmd_present(pmd))
> -            return 0;
> +            break;
> 
> -        if (unlikely(pmd_leaf(pmd))) {
> -            /* See gup_fast_pte_range() */
> -            if (pmd_protnone(pmd))
> -                return 0;
> +        if (unlikely(pmd_leaf(pmd)))
> +            cur_nr_pages = gup_fast_pmd_leaf(pmd, pmdp, addr, next, 
> flags, pages);
> +        else
> +            cur_nr_pages = gup_fast_pte_range(pmd, pmdp, addr, next, 
> flags, pages);
> 
> -            if (!gup_fast_pmd_leaf(pmd, pmdp, addr, next, flags,
> -                pages, nr))
> -                return 0;
> +        nr_pages += cur_nr_pages;
> +        pages += cur_nr_pages;
> 
> -        } else if (!gup_fast_pte_range(pmd, pmdp, addr, next, flags,
> -                           pages, nr))
> -            return 0;
> +        if (nr_pages != (next - addr) >> PAGE_SIZE)
> +            break;
>       } while (pmdp++, addr = next, addr != end);
> 
> -    return 1;
> +    return nr_pages;
>   }
> 
>   static int gup_fast_pud_range(p4d_t *p4dp, p4d_t p4d, unsigned long addr,




