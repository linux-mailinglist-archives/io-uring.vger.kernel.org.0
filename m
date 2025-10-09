Return-Path: <io-uring+bounces-9945-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D27CBC8780
	for <lists+io-uring@lfdr.de>; Thu, 09 Oct 2025 12:26:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7F3854EA735
	for <lists+io-uring@lfdr.de>; Thu,  9 Oct 2025 10:26:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EA782DA760;
	Thu,  9 Oct 2025 10:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="AEkkbBeT"
X-Original-To: io-uring@vger.kernel.org
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011061.outbound.protection.outlook.com [40.107.208.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB662D97B8;
	Thu,  9 Oct 2025 10:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760005567; cv=fail; b=jp0nxqlhHErqMD1saCRfkBy7VyrTCofNJvlIgj+QItpaZeMpgTpNd3F0y/gSL6EUOGdBztmYVMRa06CpTp3Oxf4QBsi8c6SwsE+K85VV2Jbm7QSBFEGEdQof9ZeRqvHlw/UHofMXcqunUkImFt0Xsvs3/vR0X9U9MTjXYnFKjGY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760005567; c=relaxed/simple;
	bh=Zm8J+WJ0C2kG5/trvCOVSGPxHmS1C2O8VAMzFKWuOKU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MWwr56nY9qR7oKaQm6kgp/HVVm5LaEBnPmVnia1HgpdRAb84qzKpw9mCaiZPkV86qBMW1P/sljDtAGl2M/rwZKsdQDqFKtEwAcjcJRpPAHZWHWv2xNTimr/EPsv4E1y0bQdb9icKNxMb+dYeJTHSFV0Ufsk7CcirRuoxpP08hH8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=AEkkbBeT; arc=fail smtp.client-ip=40.107.208.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LPJawCBvlNpu1oP6SlGKaWPBKvCgBaXt5knCw9W5wgVd4wWV/8/e41tFIaVtoi+DvySnbctSfvpq7CECOAGMhSQXGPyfG0dmZfULenc+8E/EbDX2c/JaEwDcWcCP/XJZ5N+a14wbVJTurk/LGUkmprOT8gMmrpszr1b0ZPZN6sUXDfMDdraTBYS194onXyzh33kANiy+N5W8iPhufLHhMyl2z64WF4KY3UlAO7/qMKO2ELzMOEDjHVLqa/HeHgtpvgDM7dlOEvWlbDSGlkiNkcHIXaSCgCsQP0lX7NnsC/3OPHks/xXQXgsCGJ+YTQaLanVWz/zIseYB+0qm6J7jTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=biWLAK0VQUxowCTa/aYyaJoQmxJX91FUNylh8OApvso=;
 b=tjsBr5Rnu5JUB2YChOCfBtXX1sASbxwpxG4kkVS/3ae+g8Ju5Kn9TG8CzxtNbWIAIFml5MdvccRpjTvwATmwbSlkEaqrtu92jb5mQsvvDu5ezwU8QbBAAzqZMvxmJz34C3Od8JUbZipM9hXblov1PorErrfKBa+xtpzUuA6vT4/XtD8l0xMqkJjQ7RhY/BQtCpgUM9U1R+YORnhMFuojrgNxUTVtqQzBsIW5+9emmTow1BETlURWrQ+fA4TWh0H1eTgs3miNOVB4nHwuxVnLAe+qjqgafrccFVwqktIW1+3qCLkaujFBiU5nDGg/sfs/TwL+Fz3y2zJH7Fk9fULZiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=biWLAK0VQUxowCTa/aYyaJoQmxJX91FUNylh8OApvso=;
 b=AEkkbBeTUwol5us3ROkbAmaPeGD0TxWx7uK/Xhn979IVUSv40JhSvCk/PHINPD0K4Yhh8kJOjqI6kChQWkCoEQSPnI7Kfmy41Dkv8SkFswT6QuT2zDqyxn+pVTWvvQEBprczJIxe/R9J+niSahd8ZULkHPDrK+/lKQlPQ5zS+DDNKxmAqQo5VoIpnMo3/7L5z9bDGcd/l5e9Jo0P9AY3J1J8kmIrRVgj58qDpngRt/xxtCA0UCWAVPWw8B0YPp96RNamkFAYdwcvp1DDofkmPEgFmzM+qKpm+GwU16NLEvkbwrf5EcL7eaes6mlWYrzsRybtxiOuHY9YWDkXMK4VCQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by PH7PR12MB7455.namprd12.prod.outlook.com (2603:10b6:510:20e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.9; Thu, 9 Oct
 2025 10:25:53 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9203.009; Thu, 9 Oct 2025
 10:25:53 +0000
Message-ID: <a04d8499-85ad-40b4-8173-dcc81a5a71bf@nvidia.com>
Date: Thu, 9 Oct 2025 21:25:42 +1100
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
 <fa2e262c-d732-48e3-9c59-6ed7c684572c@nvidia.com>
 <5a5013ca-e976-4622-b881-290eb0d78b44@redhat.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <5a5013ca-e976-4622-b881-290eb0d78b44@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0191.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::16) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|PH7PR12MB7455:EE_
X-MS-Office365-Filtering-Correlation-Id: fc042970-8d41-4fd6-bef1-08de071e3985
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|10070799003|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZUpVelpzcVYydjk3V1lyTVk2cGpJZmZuUUFOUnRScHhGUis1L25Ra3pEQVU4?=
 =?utf-8?B?L1BZREhsQ1o3WEc3VXdoRHIrMUdCeitRRmYxeTlONlhyRWFoYUlXQVNxVVE2?=
 =?utf-8?B?b1ZLaW9KR1RmUzA5bW5BOHdvTUt1c3h4a1F1ZUVRa0dUMCtjSjVmZjZsVGR4?=
 =?utf-8?B?WFJkWUZXT29IRUN1U2ZSMHh2VWlVMG9GSlM0MVVtYkZ3bEpER1ZTMm9jeWcw?=
 =?utf-8?B?RGVZakJ4bURmVGVJM05MMjgxT3FlTFlQNEY4SGtnM1F5ZEp0Z2Vjd0VQZi9r?=
 =?utf-8?B?cFlqMWt6bzRuQk5qdHZ2MGlVWkFBQmRVWjRFRUVrZ1d6blgxdlR4cDJhT3d5?=
 =?utf-8?B?Yi9VZVl5T1g2MUpHYm96N2c2M2tyS2djWDFoSENRTUpLZ3J3OE5qcElWQnlp?=
 =?utf-8?B?QjBKWnFwZ3E3bVAxOVM3WEhPVHhMQTNFV050aHdjalJMLzNQQnEvOXJ4c2lD?=
 =?utf-8?B?UlAxQTFaQ3krQTZiN25YS3duN3ZxclVUMjdINnQ3UGVUMzRFb0JHdGp4bjdE?=
 =?utf-8?B?Ym9wakZhQ1FkZlNBRGxhNmcwNHVDZ3Ywbno3bGIyZ3NUT1RBbXgxTmN0QWdj?=
 =?utf-8?B?OXRxMis4TWk4OUhPTHRTQmRld2FMb2FnYlZSN0J6L1Q5eUJ2Wm05RUdZdUhZ?=
 =?utf-8?B?ZXZadVVsdlJZUHVTeVhmNSsvdGY2eVJtbnVtQktsOWIxUHJiU3M2K2tPTXJK?=
 =?utf-8?B?a1YrVVcvS3RHZ21oSmgxYVZoZjBWRC9jY0ZlOXd5bFlyK0x1VVFHcElxejFv?=
 =?utf-8?B?M095d25yeW80R2x6V0JGb3c2WUhaa1JMaS8zbmg4ajM0dGZzdlZ6cDJuSjNJ?=
 =?utf-8?B?NVVoOFpKR0xlSnlaTmFJRURXNHdRdzRLRnduREk0eFVOcjNhaGVCcEQwZ0tp?=
 =?utf-8?B?WDhCaUFpZzlvQ0ZmQ2QyeGFmNm9uT2VhaC92SmJ3OFV6Vi93Mmx0d2FZeDU3?=
 =?utf-8?B?RzBTZHZSdVhtU3BnMHJKV2JpaVRpbGYwbVJ0REg5YVZ0MEg3cG5XVjJkY01h?=
 =?utf-8?B?c3hSMzVvR0Job2xVWlV3SElGVG84QytVUC8vbnF1UTFhVXExRCsrcVpTTTBv?=
 =?utf-8?B?SENKL2d5UnBLc3hjdWpsVjF5V2F0YjI5T2xsdzNIcGcxYlFqK09nN1pjdzhm?=
 =?utf-8?B?U1M2R1N3L3g4ZjRvajlwbXJxYmhKVW5ZRTVtRjRWb0Q1WnVJTmJWWXQvRjdV?=
 =?utf-8?B?TlVnWVRTWGdlTkUwS0F1ejQ5VWl6bkc5b0paREhLR3NFeWxJNTVSak8wSHUr?=
 =?utf-8?B?ZDVoMElwZzlSZmI3K05kNkQ4MFlKc3hxcDlNS0hyUFhCQjlMUzUwd1UrRHRL?=
 =?utf-8?B?NzEzcks2eU9jaFpGVkVTamt0Q1NwYzIrb1I4U1F1UU5HaVM3alNHTGhnaVYw?=
 =?utf-8?B?S0ZsUmpWTW9ZUUtHZVg2THVoTDRzVnQwS0NRSHlPZXBRYW5obmYrLzZPcGNm?=
 =?utf-8?B?MW40QXJLc1B3Z3dDRlN1aHNkZnFKNHg0VU5wYU9FT2xGbk9GSUlXM2RKclYv?=
 =?utf-8?B?MVA3cG03Q2xJeDEyZEtIOEwrYUlqbW5FS2w5ZkRuNkd3Zm9BTjNuWlFzZDVM?=
 =?utf-8?B?RkMyNjdIOGlTMWc5NTl2djNPRlZxY1hDZFJhRXgvV0REdDZITTg0TkE5ZC9D?=
 =?utf-8?B?WWdldmhzRVl1V3hmMVBGTjF4Y2thS2lrTGh6RjA2d29wNklCcUNaNE9lUjFk?=
 =?utf-8?B?R0tzQkR4bitDYUZwQVgzamNQTlVUUlBJYi96N1N0bTZEV2t5VXRRSjR4SHZ2?=
 =?utf-8?B?eTlUNmFyUWt0WnZDZU5kYWVRYlBLb0FTZVNlOEF2WWtNRTdUNWRVZllsbWp2?=
 =?utf-8?B?YUo0SVZuQTRkNWdLZUd4cy9rSHFMYUIwTFBkRGZENTZOdjU4UHl5L0I5N0hM?=
 =?utf-8?B?SWtGaGVLUXlMR0grcmd1a0dYOHZORHM3d3Ivbm4xSGpqM1F5ejE4S2tjSEhZ?=
 =?utf-8?Q?RIki05ZQBRLqC4OWQsYahsTOprT9c9ID?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(10070799003)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dlFSQlFOSzNOSHBwYXBRZm5xNWRYa0M0KzdRR0JoTzRaVXFPR2VFNmNHV2hG?=
 =?utf-8?B?M0t5WW03V1FvVnJKTXVWVDIweWt6cDJ6RmlrdnoxMGVpYjUxRXN4VjQxUU15?=
 =?utf-8?B?cTRFWWp5Ukd0azJmZ0cxTjdlS2JWR1YwVnV3VCtjSU9Qa1dwTEpHSW5EVDE3?=
 =?utf-8?B?Ry9GVUJ5eE5mWXpORnpHSUZLMHBRVmxDNTY4V2xjYjlZaXJqWEtEaDJLVGU3?=
 =?utf-8?B?NFNIbXk1MUh6dThIRkw4WmlXWjJLaVdaWDIxNlhMQ2wzVll0ZFg1VDVVOW5s?=
 =?utf-8?B?ZmNwbXorRzVoUzVZQWVJSWJ1RnpwNHozOXJ5ZDdhMDN2TzFyNjF0WFVrTnl1?=
 =?utf-8?B?N3k0UUdTMzQyT2lpMWJDRjB4S3JmMTVheWtDajA2M0RYeFhIYW5VR240dC9a?=
 =?utf-8?B?UVhjMlc2a2xaUHIvUjQyVGxOS01GaXJHdytlMEVyYkRtWXJCckF4SXlUMSs4?=
 =?utf-8?B?M0hEWStPWnI1Mlc2QmVlTTBhTC95VE4zZk5STE1pTE1aOWlKT1RXM1BvMTdP?=
 =?utf-8?B?RFFMSFlvT0tURmtaYzdEaVBRWmVTK2ZyNS9EU0dzQy9oUHZFVkN4QlIvaDVR?=
 =?utf-8?B?ZndBQm1vMnBjM1BEN0orZXNhcUdEQThxYzRQSTVhTUI2VkJHaCt0L1F2L2ZL?=
 =?utf-8?B?L1NNQVhSTlhRVUVXQTJOZUlrUy9KeEpKRnhIZ29wVzFvM0hXNDFiOW5mcEJ1?=
 =?utf-8?B?N056YWQxQUxHNm41MzIwSERsNjI3NG9OVGdMaWRJcjU1TElHY21acEFPclBB?=
 =?utf-8?B?NklLc2JrVzZVcTVLMWh1WVNxZ2JRMmJ5TXZvZ2h5bHliQ2pvZzR3RFdKRDBu?=
 =?utf-8?B?ZkZCb1N4TGt2MTEyWnBXTDNQaFZZc1VEaHoyb3paTGhQK1FkSHFsQzNHQ0Uz?=
 =?utf-8?B?WmN6eHZuMXdFU2dFeE9laU0zek1oZ0pMU3REaW42WkZJTWpQK1A2cDIvdDk4?=
 =?utf-8?B?T3pnZks4cThmc2pxZUY4UllZK2JBT3h4a1VMT3p5MVVrUGdHOEx3bDhyUnFm?=
 =?utf-8?B?U1pKQVgvUTdwd3d0Rm1LYkJ1RXJCejNOVlVvVmtlUDg2ZTVTU3ZBaVRJaGxh?=
 =?utf-8?B?RmFiU1RIOTVlR2diNi91UUFMUFhYWEJJcytlazdjbkJxRWJyRUVUMGtzUFg2?=
 =?utf-8?B?WG9kMS9aNkJybVRDNGJTUnFCd21TcjBFNXFFaUZHd0Y5cE5GUTNHVGtZbDRh?=
 =?utf-8?B?Z2h3d0dYUWg2MG5aZlBJTWpYSnJ6RGpoNXVjdTJ0NzlBQWRmaERvWVJYN25R?=
 =?utf-8?B?SnRnS0VXRjNkVndpQVFRNFg1YnFpak5aNTVZSHF2bDAwRTdlNWFxd3ZpYTNL?=
 =?utf-8?B?OUpPRVNtS1JyRWorL2RYWTlrYktzMmxlZWtzTTF4WW5TY1BpU3d6U2pvRFpT?=
 =?utf-8?B?bVNVM2lxaDl4U0s0OXlHODVQWS9GdjkrSW1LcW05bDROeHlqOE5tQ3EraERJ?=
 =?utf-8?B?bHp3VkFySnBHTkpYS1dYRHZvWFcxVlRibkZqZHEyMlo3dGNtazJGM2RxTkN6?=
 =?utf-8?B?MFFybFRoV2NjUXlhelRqTUlObGszSjcvT3ordnZrcGVKVmN3RUc3TzgwMjl3?=
 =?utf-8?B?SmR5SlhRU1pPZDJ6QWxaeHhqdm1oL1NEcEc3c2ErS2pjckFKV285bURldERa?=
 =?utf-8?B?aDg3TEltTHlQdFc2MTROVW9DUDN4OXArQUNVNmtveU5hZjlkRkwwQVRmcEgy?=
 =?utf-8?B?cmU0TDhVOWoxRUJqTlBXQ1o5eW5uMVEyaWZUamNOb3hQOGx6K2RwT0xpTlpT?=
 =?utf-8?B?VVBBNjBZN3h6TGtYL25VMXNkK1VnZVVzS2NZU2grZ1A0TytxT3F3MVhaWkpv?=
 =?utf-8?B?eHl0MElDN2UyNnZOaDh5cXUyMUp5eE1TQVN3TGhjOHJJbUpBNk1xWVpselFG?=
 =?utf-8?B?Tkp2cnd5U2dJSEU2ZkpIbzF3Y29pK3RVanRXVUcxRVRDeEI3WlBLb1N5bFpz?=
 =?utf-8?B?ZkRvN1FkYWNtMksvUUlveTRCMXdiRXgyalJRSDZnTmlWSU5JbGhFN1RiRWZx?=
 =?utf-8?B?TC9hRU9XWFVSTnZ5MnJ2YThBRG1EYjlyb0dtYm1EU0twUW5xMTlZODBjWHdk?=
 =?utf-8?B?ZVBQRmh5MVpweE44ZHNMV1dGZ09aa1ZPNHg4SE9iOENIbEYzSHlxd1RXbStm?=
 =?utf-8?B?K1phdm5PS2pQc2w3dFdMT1U1OU1XTlVUcVZHRHBMdzArM1hRS2RVYWhYZXk0?=
 =?utf-8?Q?efW3/6z1peeZJ05KBnsNhLkPgCVix25OmEHkOeTGaYh2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc042970-8d41-4fd6-bef1-08de071e3985
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2025 10:25:53.1264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L959gJC8jrvJvfIb4iQtdd7P0YXxd978MySa+fAzHqrX3t6Dj+mRSWeQoKjvNjEI4YvCngzAp2V3GSUCLThCkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7455

On 10/9/25 17:12, David Hildenbrand wrote:
> On 09.10.25 06:21, Balbir Singh wrote:
>> On 8/22/25 06:06, David Hildenbrand wrote:
>>> Let's reject them early, which in turn makes folio_alloc_gigantic() reject
>>> them properly.
>>>
>>> To avoid converting from order to nr_pages, let's just add MAX_FOLIO_ORDER
>>> and calculate MAX_FOLIO_NR_PAGES based on that.
>>>
>>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>> ---
>>>   include/linux/mm.h | 6 ++++--
>>>   mm/page_alloc.c    | 5 ++++-
>>>   2 files changed, 8 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>>> index 00c8a54127d37..77737cbf2216a 100644
>>> --- a/include/linux/mm.h
>>> +++ b/include/linux/mm.h
>>> @@ -2055,11 +2055,13 @@ static inline long folio_nr_pages(const struct folio *folio)
>>>     /* Only hugetlbfs can allocate folios larger than MAX_ORDER */
>>>   #ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
>>> -#define MAX_FOLIO_NR_PAGES    (1UL << PUD_ORDER)
>>> +#define MAX_FOLIO_ORDER        PUD_ORDER
>>
>> Do we need to check for CONTIG_ALLOC as well with CONFIG_ARCH_HAS_GIGANTIC_PAGE?
>>
> 
> I don't think so, can you elaborate?
> 

The only way to allocate a gigantic page is to use CMA, IIRC, which is covered by CONTIG_ALLOC

>>>   #else
>>> -#define MAX_FOLIO_NR_PAGES    MAX_ORDER_NR_PAGES
>>> +#define MAX_FOLIO_ORDER        MAX_PAGE_ORDER
>>>   #endif
>>>   +#define MAX_FOLIO_NR_PAGES    (1UL << MAX_FOLIO_ORDER)
>>> +
>>>   /*
>>>    * compound_nr() returns the number of pages in this potentially compound
>>>    * page.  compound_nr() can be called on a tail page, and is defined to
>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>> index ca9e6b9633f79..1e6ae4c395b30 100644
>>> --- a/mm/page_alloc.c
>>> +++ b/mm/page_alloc.c
>>> @@ -6833,6 +6833,7 @@ static int __alloc_contig_verify_gfp_mask(gfp_t gfp_mask, gfp_t *gfp_cc_mask)
>>>   int alloc_contig_range_noprof(unsigned long start, unsigned long end,
>>>                     acr_flags_t alloc_flags, gfp_t gfp_mask)
>>>   {
>>> +    const unsigned int order = ilog2(end - start);
>>
>> Do we need a VM_WARN_ON(end < start)?
> 
> I don't think so.
> 

end - start being < 0, completely breaks ilog2. But we would error out because ilog2 > MAX_FOLIO_ORDER, so we should fine

>>
>>>       unsigned long outer_start, outer_end;
>>>       int ret = 0;
>>>   @@ -6850,6 +6851,9 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
>>>                           PB_ISOLATE_MODE_CMA_ALLOC :
>>>                           PB_ISOLATE_MODE_OTHER;
>>>   +    if (WARN_ON_ONCE((gfp_mask & __GFP_COMP) && order > MAX_FOLIO_ORDER))
>>> +        return -EINVAL;
>>> +
>>>       gfp_mask = current_gfp_context(gfp_mask);
>>>       if (__alloc_contig_verify_gfp_mask(gfp_mask, (gfp_t *)&cc.gfp_mask))
>>>           return -EINVAL;
>>> @@ -6947,7 +6951,6 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
>>>               free_contig_range(end, outer_end - end);
>>>       } else if (start == outer_start && end == outer_end && is_power_of_2(end - start)) {
>>>           struct page *head = pfn_to_page(start);
>>> -        int order = ilog2(end - start);
>>>             check_new_pages(head, order);
>>>           prep_new_page(head, order, gfp_mask, 0);
>>
>> Acked-by: Balbir Singh <balbirs@nvidia.com>
> 
> Thanks for the review, but note that this is already upstream.
> 

Sorry, this showed up in my updated mm thread and I ended up reviewing it, please ignore if it's upstream

Balbir

