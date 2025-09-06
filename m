Return-Path: <io-uring+bounces-9614-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 81966B467B2
	for <lists+io-uring@lfdr.de>; Sat,  6 Sep 2025 03:05:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 332DC1BC5517
	for <lists+io-uring@lfdr.de>; Sat,  6 Sep 2025 01:05:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F4A4487BE;
	Sat,  6 Sep 2025 01:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BpCj3rnl"
X-Original-To: io-uring@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2081.outbound.protection.outlook.com [40.107.244.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD11B315D3C;
	Sat,  6 Sep 2025 01:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757120731; cv=fail; b=dmNSz8dUMz/zwStVtlU06kYco+c1lXK5KSo0x/JAU6TtxQj2ns5XOjjB0alB6/b5d6AmRpjL/lelvvRhX456cAATjiUfZcIwybfpurR8LMwtb4izEhGY1uEtVWq1zrM4e9IF5b16wauF1ZIS+cKUfQo0ya9VVd8g05wnf9Z+AQk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757120731; c=relaxed/simple;
	bh=5es34Yn6TDnGHFr+HzcE3EBjQbzygEhMahg3cGtVLkI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Aqv4tfm//FfQ2WGJP240m8UFrdmX4EukK5kyT+wmSrUMbKzTNNUsVNToNMlfBOJcTs9lDUN9j2UH21+h8rimQDiIvJIospV6erSoVGz/RfHsaAAdcN+ZIYYaWxRnBzPwxNGmzweTf2jNc7DTlvAgqS+Cq9lROND3rl0BJQdmb+g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BpCj3rnl; arc=fail smtp.client-ip=40.107.244.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MqkbB6StSne28owvikLsjAi64NBTS0DJxXDYR82NPm81Dfmz0yCI8onJbKLsaPd9AwpVlbLoh+VhZtM3piLpt4kmwaE3/uQQmH0kzK3zYtzPDnN6rJBbXl8kZ+Id1vH08t7Pjv3T7K18T5bjsPaK3btlPmuL6/9TYtE/8qbhBAg4nGgM9YmRdAHD5GKiwYPloDUDMBeVgTSBpeJ/8bem5C6Ik9gjjiUpySWu22jTTO3E2kHLNxpBn8eh/PylT1tXWH5EAvExttAgxsYGarLpb5mN/si4NAi98M0AurMoJ7YqMeulN/lnVpKl0fbMsr14TpMf4IDb1UCnbwqZ0DnLOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qmNEjp4wJqKTIanwJekG5BKHGlxuhcysz2RSi1jiRbg=;
 b=O1MTW8e8YU+D+YGUzTk3UG8zD/KNd4eF1Q18jXFhEmiIL1IcMUKiOfWyAFUMLEwkKGP8hsuugPuI3TgabCXHIkjzvmvBhqPSItaYizcRlhJ9XjhVOjnjReVt0YPZHUoQSXRXEKqQrmxVGP95rU7le7syfDcpEJsO0aiGwyzrZte+3DkF81bd/E0UM2Xh8ZEq0bGO6goU8LhXa+zTEOnGuwpcz41jn9m41vKQvhv6iNesryBJvqJXOCMiyfv61CxmapsVQQaGJYph4LBCx/LllhP2j95qHG2x4Movf+ai+HWAMB6mBzN7DxwwXv9iHGXKm5cLq+YRrqNZIYwwGJ4WCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qmNEjp4wJqKTIanwJekG5BKHGlxuhcysz2RSi1jiRbg=;
 b=BpCj3rnlKit5YpE6JoxZjQdmLBHHtB17RpTV79tZpLIUZQdYTyLuUFKWayfczIHI1O9MazYN3vUvLLvLXSx9tHWVpmadtp/UNDyY4KmJX89HbXCJAfFyFnUDdQm8WIJxVT2y22wIvpkIerKF/xYHJK/iNQT1u9J4025VUWz+VgVa8lMw/tEyZ+SyBCX9C060sY+YK12/03ChqA+2X/o5Nv1q9+fckWRmwtACBtIVb7Gc4fDZj4sX4ks2l1KZGw3J8lniTa95l+ACuJ1W6qCn7GMVwdljddhHtoRwqXgtphh7Z3XEasApliUGu40VvJAgpV29dmAc3TDPD8u3k8LE4g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5968.namprd12.prod.outlook.com (2603:10b6:408:14f::7)
 by SA0PR12MB7479.namprd12.prod.outlook.com (2603:10b6:806:24b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Sat, 6 Sep
 2025 01:05:26 +0000
Received: from LV2PR12MB5968.namprd12.prod.outlook.com
 ([fe80::e6dd:1206:6677:f9c4]) by LV2PR12MB5968.namprd12.prod.outlook.com
 ([fe80::e6dd:1206:6677:f9c4%6]) with mapi id 15.20.9094.016; Sat, 6 Sep 2025
 01:05:26 +0000
Message-ID: <016307ba-427d-4646-8e4d-1ffefd2c1968@nvidia.com>
Date: Fri, 5 Sep 2025 18:05:21 -0700
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
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <20250901150359.867252-20-david@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0205.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::30) To LV2PR12MB5968.namprd12.prod.outlook.com
 (2603:10b6:408:14f::7)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5968:EE_|SA0PR12MB7479:EE_
X-MS-Office365-Filtering-Correlation-Id: 61650efe-33fd-403e-2700-08ddece176ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MUVHMC9aQ2NWa0MrQTFBY0FZeXlwRlN0c1U2SEtrTWk1UjdzTEJaM091TFc5?=
 =?utf-8?B?dHJKQ1lPT3FSeE4rSVp3VWQvak41cC9uVmlXaUQrcW1yYU5MTmw2Y24wc0xi?=
 =?utf-8?B?cnBGL1BZZTZhNUxhUDhaWWZhaUIwQk85a0FBd0M4UlRsV2RTVEVSd0VQYjAv?=
 =?utf-8?B?K2N4R1RXQVFKUGw5bVVPN0pXZ2hXWS9wa1hhK0szbFZpT3QzMndxRzVkL1JJ?=
 =?utf-8?B?ZXFmaXNFWHgrcm5IanhmSE8vd3ZuWWF6N2xxbEliYzdHVHMxUG9QVGhjYzJX?=
 =?utf-8?B?Y1JUWkNWaFVvSDV1aHpYaG5zSFk3dk42UEpaby9telVicW1KMG4xWnpzc1JE?=
 =?utf-8?B?N1hUakxjdUdwaW1vWkxpQ1lTK2wxMjRsaDl6VzUzdGswaEhjeTFsd2FyUS8v?=
 =?utf-8?B?VXkzTkFYY1JrcTdXclYxMFFVZVRPbHdYZjdIbTAxVExKSk51UHdRT09jZndX?=
 =?utf-8?B?V3dJRWU3Nzc4UWZrTTBFTW9uSGFqRUNFTEY0NXZnWE1meHpTN0hyMDltNWJt?=
 =?utf-8?B?Wk42ZlZJa1RUZFR3eU1pWkFKQkV3bFJJWXNXV1EwTkJQSklYVHZwaVpMNDh3?=
 =?utf-8?B?aTNwZWJhUWw0SHdWalJtelQ2dFphaGlmVHpyY0FNZndWS0hEeEsvY0dmOHdK?=
 =?utf-8?B?NEV4VlA1NWFwUzRoQndvVHhlcXFRaGJKWW5HT0hWZGk5eUR0UzNVeWkwQmxp?=
 =?utf-8?B?SFM2K2xYRDJKN1VITkZMOW5CNUFVV2ZZbDZuNVlOcDRUQkVMQ1N4TmFTcFF3?=
 =?utf-8?B?VE1HRWhjSGt1UTJ6SjA1eUZndEdxTHAyY25SNWxBbExwSG00Rm5pbFBibXl4?=
 =?utf-8?B?RXdvalFsU1dqUVk1QXdMYVZBM1NFcEpUMWtzV1lWTDNTb0YzaC8vcXNnOVM5?=
 =?utf-8?B?L1FDM0tXYm14YTFzdFU1TWgxYWY1ejhYUHRYMFJvdEFuenR2aFNzK2E0QytG?=
 =?utf-8?B?V21JTmwxelhOWUlGMTJ2K1FoY1ZSZk9EL3BVcWw3MVkvOUoxSVIzOXE4REJQ?=
 =?utf-8?B?Ky9yWlBaaHJGNUh4SEErdnRXNE1XSUdUNkNqY1dlSE15QUhseTh4azVXVmwz?=
 =?utf-8?B?Z2IrNnFCbk9HY040MnE4STNXTFJJSDgyYWltTnU0c3B0LzRETDlPRDJIbEV1?=
 =?utf-8?B?dExaaWxzcXEvTjNuYWhXb00zdXVSNHQrMEVCN3JtcnVGVUFoVWszSi9XS3gz?=
 =?utf-8?B?THQrckdLNjhhbXo2YWkyNTJzV3VUNzh2TWUyZlVwdC9EdVZXRzFXdjV6R2NS?=
 =?utf-8?B?UE1mWXJ6Rkx4cVdjS2hzaHlneEZ6blM0MzVJQ2xFZVdzU3dZYzN0ckQ4Q0xM?=
 =?utf-8?B?N3FXdFBmelVXVTVkak9MY3BHamJ1UWhEZzN4V0F0eDZTNnJnZ0djdFU4OFZB?=
 =?utf-8?B?L28vZHRXZVorVm5DWDMzbDJtN3dHT3JucWx0b3RTZ2Zkd2IydXdnbGliR3ls?=
 =?utf-8?B?MGQwNUpyTFJlSTJweGpqclJadXF6VDRnK2ZQNWhSclRwejZoVTJVcHBDZGZC?=
 =?utf-8?B?RzRQY2hpbDJjNUJtaXZMSjlpb05md2g5WC8vdEgrT0JWYlVkZCtjL2ZHQjlq?=
 =?utf-8?B?WjhiUE8rTCtmN2JCaVVnNkdvQkVaRVVKRjd5bTJLbURncGJqM1pWQ3VrZmVt?=
 =?utf-8?B?Z0lCdDduZFFkYW11czFremV6RHN1OWVheENVMExHSVpNeGZXN2ZtbklDUGZU?=
 =?utf-8?B?TWhQMkhGLzBxandrN0dOWGpqemRTWCs0TlFNdm1makg3b0RDcEQvMmdIQjVr?=
 =?utf-8?B?eEJnc2xnSWE1K1kwb3RZaFB0dzBoYUhRZUFYeThuR09CWE5QVkNlanJPczQ0?=
 =?utf-8?B?Q3FEdXAyVWRhamRTaW1sckdqQ0d5MHkwbmxObGY1N3ZwNVhtSUp0Wm84Sm1S?=
 =?utf-8?B?OFJKeldCMTlsVFNEbHQ5b1BKMXlaRFFOWkdKR2w0WjhlaEE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5968.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z0VaUEgvYjVMZkE1Rzd4NTRoaVhWU281RTFZcklIb0FNbC9Hb3dJdDdLM0V5?=
 =?utf-8?B?aytHdlpnZlJFUmZoQTVZRU1takd1RFZxUTRvMFdLRVZmRkpCa0NyME9RK1NX?=
 =?utf-8?B?TDU4aXZ2ZXFYYnRzUU9jSnpXYmJhSjFMeTJudjFtQlNHRFl1UzRvUmphYkY4?=
 =?utf-8?B?SFBOWlpobnRheXdpNHFmWGx2Y3V4VGNoL0R4TlNmOENIQ3dtMXFXSHhNUlpM?=
 =?utf-8?B?d1AwTXMzRlRSUEV2SXAxcW9hV3plN25RdjZGbEJ3YlFVUVFBL2RmVUx5SUMv?=
 =?utf-8?B?YnI3V0M0S3BwK2dIeWhmNXFFS3Q2TEhCa3I5Z3JubVJpUWhqWm1rNkVCUDlx?=
 =?utf-8?B?VTRPUWE1K3VMNTF6bmdsWUxiUHg1UGVKb2J4bVZFeS9oN1A5ZWxPdW9vK254?=
 =?utf-8?B?VEppd0FoV25wOUlXMlJNcFJTR3hTVVJ3N1lVdTM0QW1wb0lkZms0UkJJc2dx?=
 =?utf-8?B?dzZyLzJVNUw4K3A0eXpkVHg5QmM5b3lKVFdFaEFPZEtkdnBTSWRWMDJtRFM4?=
 =?utf-8?B?bC9qRVo0RFN5MFRlUlJTSVIyWkdtR04reUJpUHl4T2JFeFF6Zk1JZU5CMnBz?=
 =?utf-8?B?N1lpZEIzNzdnb1U4ZWNUd1MrdCsvZFdZYVI0OUpTRjlHNmhIZnA2QzNGMEd1?=
 =?utf-8?B?Y0h3Ri83SGdHQXdacjVwQitqaDFLZUM3ZkRKK3dhUEJHKzlLVkgvWW9xUjNT?=
 =?utf-8?B?aHBnaTFyMjVMTmVwRWVRNDIrVTY1MVprZjRBYWd4UkpVUFlOMFZCMFVRK0l3?=
 =?utf-8?B?cDB5dWZjNkU0R04wcmFycW52Uk1LcEYyekNaQ3c4d0U1d3FrU1lsWGJ0Vy9a?=
 =?utf-8?B?dEQzNkgrVTZjRlIvOUlIVWNsdENvTFE5Tm5jbi9QSG4xN21WWEoxUFNIT29L?=
 =?utf-8?B?UVlRWGMyU2FQMWFKbi9vbGRES0gxZld2UTdUYzJqc20wNjFtT1pkRXBmVzAy?=
 =?utf-8?B?aFM5MVdXVkl3OUtQUnBUVUl4dFlrU0pLOWN1R3kyTW80K1laaDZKSlZjK2N5?=
 =?utf-8?B?WjhQc1RIQ3grNzMvNUdUOHY2aFNwMURnNjdTcWRuMGY0WTNjc2ZqcXN0QlRG?=
 =?utf-8?B?QVdQbk93cDZYZGNNd05GbUVjdU5ld00vdVlNVHUxWThlM3F0UDVQU1d2Q2Ew?=
 =?utf-8?B?R1RHdHhRb0VSUnZiYjc3d2RCaTBjSG9INXN1eVVtNERQc0tBVE9xNzNpcGxU?=
 =?utf-8?B?b2lwSmZHdTNydXFJck1BOVJDcktKUEJ3UmR5Z3FKMm50TndodkRSb000U3p4?=
 =?utf-8?B?TTVwSjZwRHJmRDcyUS9iZFI2V2ZsL3luSkJRTDF5ZlBvTU00eFU3TVpTR1dl?=
 =?utf-8?B?aFZiVDBtSUtVKzRhQlpnWm0vUUNkeld3K2pDWEViSFJpSG5kU0RZK2Fyd1Rj?=
 =?utf-8?B?RnlJSjM0T1l0L0dUMEM0dHY1bkhYZm1wVVFKMGpUVkxxQ2pDV05ZZ3lNb0Vt?=
 =?utf-8?B?M3hDVHZrelpUSzRpcTkzQloxejlSV3IzTktZRFBLU3VKM3p0eDZlUXV3RlZq?=
 =?utf-8?B?MnlHTDl5SWE1MVptQUxIa0JUWVE2KzR1UzZSc0c3N1lmVHY2NDkvZnhxeS9h?=
 =?utf-8?B?c1JRb1piTi9wR3NDWWJXVWRFNjVZUzIxUWVvRVpyMVF5Q0xSMlhzMDlBN2Fi?=
 =?utf-8?B?ZWFkM3dicytDR2JkNk1MWkd4UzNYVGs2MGF3N3dMbWhCQ3FZZnRUVWh1SXNW?=
 =?utf-8?B?aXZROFFmTVR0cVZjNlgwN1dzbWJpaGxnUjAzNlhkVmsyZVBwVVE3R1I2djk3?=
 =?utf-8?B?M1lhWDRDVlZScU92UEY5Wkprb1piUHdEZkE4STdBWERmYmRqWlY2bHZHM2wy?=
 =?utf-8?B?WEttRXBiSkVnRGo0ci9SVUZWYnpRWGk0MFNEbVRmYldTY2lzYml2NmFQUzFo?=
 =?utf-8?B?R3V4d2FVMEZROUhaVVE0TEVlU3VjdTJWakJMQUtDS3VSdlNYWnRNWjNDR1VM?=
 =?utf-8?B?TUJ2dmp1TkpqdDFEempoTVFTL0FzVk8zQm5hKzR6Q2x6MHRxNkZoSkZ2NEp2?=
 =?utf-8?B?ZGtUdGp4Zlc4Q2luODNmSWdqQjhwWVhqVS84NGVHNjNGVDY2cVRWYXJ2bzg1?=
 =?utf-8?B?em5XSWcrL2dKNjIxR0Y3ZkdGbWFkak10aWh2QWJYOUpqMFR4bFZ4d1dJNndX?=
 =?utf-8?Q?3h13tEnKqa8tV44hmzJKkEJS2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61650efe-33fd-403e-2700-08ddece176ce
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5968.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2025 01:05:26.3811
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uf3O0ZJFuEbXVLypywsJNCqDz+wgeCuhr6ze1GG/5gYI7E64YgDaDhkKq51vcMr5G3zgZbO3N1fcV2W8gz30bQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7479

On 9/1/25 8:03 AM, David Hildenbrand wrote:
> We can just cleanup the code by calculating the #refs earlier,
> so we can just inline what remains of record_subpages().
> 
> Calculate the number of references/pages ahead of times, and record them
> only once all our tests passed.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  mm/gup.c | 25 ++++++++-----------------
>  1 file changed, 8 insertions(+), 17 deletions(-)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index c10cd969c1a3b..f0f4d1a68e094 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -484,19 +484,6 @@ static inline void mm_set_has_pinned_flag(struct mm_struct *mm)
>  #ifdef CONFIG_MMU
>  
>  #ifdef CONFIG_HAVE_GUP_FAST
> -static int record_subpages(struct page *page, unsigned long sz,
> -			   unsigned long addr, unsigned long end,
> -			   struct page **pages)
> -{
> -	int nr;
> -
> -	page += (addr & (sz - 1)) >> PAGE_SHIFT;
> -	for (nr = 0; addr != end; nr++, addr += PAGE_SIZE)
> -		pages[nr] = page++;
> -
> -	return nr;
> -}
> -
>  /**
>   * try_grab_folio_fast() - Attempt to get or pin a folio in fast path.
>   * @page:  pointer to page to be grabbed
> @@ -2967,8 +2954,8 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
>  	if (pmd_special(orig))
>  		return 0;
>  
> -	page = pmd_page(orig);
> -	refs = record_subpages(page, PMD_SIZE, addr, end, pages + *nr);
> +	refs = (end - addr) >> PAGE_SHIFT;
> +	page = pmd_page(orig) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
>  
>  	folio = try_grab_folio_fast(page, refs, flags);
>  	if (!folio)
> @@ -2989,6 +2976,8 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
>  	}
>  
>  	*nr += refs;
> +	for (; refs; refs--)
> +		*(pages++) = page++;
>  	folio_set_referenced(folio);
>  	return 1;
>  }
> @@ -3007,8 +2996,8 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
>  	if (pud_special(orig))
>  		return 0;
>  
> -	page = pud_page(orig);
> -	refs = record_subpages(page, PUD_SIZE, addr, end, pages + *nr);
> +	refs = (end - addr) >> PAGE_SHIFT;
> +	page = pud_page(orig) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
>  
>  	folio = try_grab_folio_fast(page, refs, flags);
>  	if (!folio)
> @@ -3030,6 +3019,8 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
>  	}
>  
>  	*nr += refs;
> +	for (; refs; refs--)
> +		*(pages++) = page++;

Hi David,

Probably a similar sentiment as Lorenzo here...the above diffs make the code
*worse* to read. In fact, I recall adding record_subpages() here long ago,
specifically to help clarify what was going on.

Now it's been returned to it's original, cryptic form.

Just my take on it, for whatever that's worth. :)


thanks,
-- 
John Hubbard

>  	folio_set_referenced(folio);
>  	return 1;
>  }


