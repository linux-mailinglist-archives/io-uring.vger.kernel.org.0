Return-Path: <io-uring+bounces-12029-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id NgeeKwB6gWmOGgMAu9opvQ
	(envelope-from <io-uring+bounces-12029-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 03 Feb 2026 05:30:56 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 02048D4666
	for <lists+io-uring@lfdr.de>; Tue, 03 Feb 2026 05:30:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 631BD30131C4
	for <lists+io-uring@lfdr.de>; Tue,  3 Feb 2026 04:30:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C98D661668;
	Tue,  3 Feb 2026 04:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mNPpq0JD"
X-Original-To: io-uring@vger.kernel.org
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013060.outbound.protection.outlook.com [40.93.201.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F44F17BA6;
	Tue,  3 Feb 2026 04:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770093053; cv=fail; b=swIFNd6jlxIMI3O/RqcMMOPGAQC+FDDVZObMzCBNngentGfBXfsSV5azMenRFmMEgjlpZBphyVh8wieV4yMBOy7ySY+gjmQRISg+N8ToDjHzEDYqhsAtxHjDK4Ny0fUVsmw8SlOdJoxvDah5SW7MDhkAOh/+2Tjt0qxD3O3E1qQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770093053; c=relaxed/simple;
	bh=cRgtcQfXzzRTES3xqYPX6PjLPEH2YfNBCkSE3mCXeDo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NztIE7H3HxZFMal9K3BAbkXSc9wxMDURlrPzKjY6Cn4KnY7I3SQ76ej+mcbbfRJ3rgYOIMk17KLy/qXk1taxnDQoCk+fzjvgtqpY/+xSoy5X/D562bivrccIH3kI00fvjRPVmDanQYGvpX6Fbfj9mQxkyzWF4SwFtyDURyeEukw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mNPpq0JD; arc=fail smtp.client-ip=40.93.201.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AdX6Xq+UjMYfmUJ3JPPX/UtE2poT5PpN6A/Cxp8OLrHr/p2ilZYnr4vrMY0Y4NnNFzjtax461L4TKw5jbfMcpo1RgNRdEIGwmR3JMgY8G1BLmEdoc2VlSHEpCVuX5fxXPue68DzwcfxYtSITUQ97PXXD/tEsKSo76qd/nkmwTvq9FRuGQPC7MVHFnZYrdEt/J7PwsMQHj41GIwpkmj4hwZ4VbS0CszFxUQP5qcc1+LXumySKuBcTWg9QK7tTqtZa1mM8SL3Azq1H06hgeVquMZwGrd8dvHlf0OF0FXpikszOUTBDwhMo7z7/Cu6FmCQ6K60qGJHZfkBT+ILUcwQjxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mwimN59QKgqmw2X9znNvhOpg7DCFJPUFUWSQ1UwM3/0=;
 b=oHmQWvJtq3CL+xY7vSSUrNUdiC9Y0j5Rog+TVpJTzRLw7y6k8XjzU2yMk6Iq6vI+SHK67PqmhlrS+vDRiEPp0nL56lrXQxIsB4Q1tiY5pFa6n5GK/RMdcznDWZxogAmpuRW1d/A+wrZmdAuRe/7TpEMFXds4zZ+g6bFz1ikUZaKYhrj1lZsJ4eK9p9wa8JhZkFl77/aYXppWuqWPiRiRsxkC1yMWm84U9VgFvruhnXmksuFi7apsU/ZvYBqdlEL3TO7B+xsBRSNwIvE7oy9RjmtkYpLhZN8cfC9s7RHhADFOoXniOiOnBT5r0ZBwRKFNVzBVS8qyadzfms02vMxr9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mwimN59QKgqmw2X9znNvhOpg7DCFJPUFUWSQ1UwM3/0=;
 b=mNPpq0JD99Q9nWwhbIKgts28uuheWanpN/hAA/V/qKzyROt25mkhXBvqQHONdZ+2BoUjv0gbSThCuk99bO/x6VLjgEPmeTRdibdPWU4ycttXdV/9GruDnLi8V0hwnU06sx4q4JCh0wHhMbbrz9P5ktaBY9He+iNZt5Uw3uKK77Mr1dZDcM46kY5etVK77I7y/Tk85FOKnyBTekOBsmoaeIY+AEiu+nRICeEhguVJSrnyenOyf7K29V2pAiyjRaVP/ysgMUnPjDhaahLC36C8goFTipF6nc9RSAQQdJ7Immhb6Tm9tMbc/RYYGI15uPq0erpCwrwYC5cYxU//YVVaKA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by BL1PR12MB5873.namprd12.prod.outlook.com (2603:10b6:208:395::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Tue, 3 Feb
 2026 04:30:44 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4%5]) with mapi id 15.20.9564.016; Tue, 3 Feb 2026
 04:30:43 +0000
Message-ID: <70e06ac9-5cbb-4616-b20c-33f5bc1601e6@nvidia.com>
Date: Tue, 3 Feb 2026 15:30:36 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/5] Separate compound page from folio
To: Zi Yan <ziy@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
 David Hildenbrand <david@kernel.org>, Matthew Wilcox <willy@infradead.org>
Cc: Alistair Popple <apopple@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jens Axboe <axboe@kernel.dk>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <20260130034818.472804-1-ziy@nvidia.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20260130034818.472804-1-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0101.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::16) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|BL1PR12MB5873:EE_
X-MS-Office365-Filtering-Correlation-Id: f8040536-2003-4509-ff42-08de62dcfe99
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eko2KzFSMk0vRTZLZm5NSHF2VDlscjBvdlF6M2hqWjdBVVRVREJJVlZCZzlW?=
 =?utf-8?B?ZFZFYkE3L0tGVVR3SUNNSEZMaVJMenNsYXJpajNzRWhuWm5LYXZFUGIzQUNG?=
 =?utf-8?B?bDVpeGlxcmxJMTVUYXZhdzNWLzNkMDlBMFVQa3RUOGlza1hTUHYvaEh1Mk53?=
 =?utf-8?B?MnVsbVA1dk9XTmRJWUpqSWIvSW5naEcwSXhZZTZLV3lnelQzUnpucys1Vk90?=
 =?utf-8?B?aDJaQ2c3RlRUMFBrU3pBR2laU1IydjdnVXA3bSsyN3h0aFp2ckhNSnB6Y3dj?=
 =?utf-8?B?L2diWXcrem42ZFRBL2J5SW5KZ2drSjBMbndZVGF6RzlHcG44N0doaVcxeEF4?=
 =?utf-8?B?K2g3dXFZeENzdnd6djNXQ2FDK1E3L0RYTzgzWnJTTkJuUkhTMmVUSGtRZWQ1?=
 =?utf-8?B?MXE5ZC9zNXpPbElKaDRmUTduMUdkNEdmcTBnbStUS3lqaFBxdjlYSEIzNUJG?=
 =?utf-8?B?eXZFZzZKVGhISURDbTF0WGxnRU1RSGJiL1BvblZEQW1mV1FiYjdxdjFkbUR1?=
 =?utf-8?B?YlRrQjlGS1dQWFdXUmxJR1pRRC9hNCt1ZnlOQktqUjNDV1M1ckxDME5RQmt1?=
 =?utf-8?B?bWhvWFdCNzNwY1RpUnphS2xKTXN2TXJYZjQxeUU1U1MzdnVWbDduOUNjaEJM?=
 =?utf-8?B?RytnTkJMb1ZIaU9yaHBta1dyWkllUmFyVlczL3Q2Q05KQkV1aitZcHoxWHhw?=
 =?utf-8?B?djdQcVQwY29keU84ZFBtMU9kYjNoV3BMVWFiSUpRWjBXR0I4Q2tXNHU3QUtm?=
 =?utf-8?B?L2F3cGJmNVN1QkVRRnBZTGJjeVl1amtVTWhZUDNwK3orMHJhS2RiUzFZd2lB?=
 =?utf-8?B?NW42Q3owWXQ3U0cwQzBiVVh3WkRRVGh4Skt2RjlCbzJUT053THczT0o2c3A0?=
 =?utf-8?B?NVZ6WFhCdDRpWUVZYTNMd3h3eXBldUFWOGNQckVYcTQ1QkpyNnRud2JYTktB?=
 =?utf-8?B?SkpNSTZGNzQyeHFGM1ZRRi94c0Y1Snp2TjVkbFpnSUErMG1vOGRaQitXZngx?=
 =?utf-8?B?elFpSnVmWjc0dUp6dVI2b2JyYW1tOGtKRU55QnVrTlFZYXQyV3FOTFVIeUcz?=
 =?utf-8?B?VnJQWFZSMnRCeGZZVDE1enlZN1lsanB6dW5JNjVIVXdaOGhycHRLMml3dkJG?=
 =?utf-8?B?cU9SVUU4NEZGT08xbkM4S2dUY0htaU45N2E4NmVqNXdualFuaUZpWDRiT3ho?=
 =?utf-8?B?cXFJUEMxQmVCank1TzdUd2VrOGk5cFpNbzVjWXRzaUNZZTdXbzV3VUtoYkxR?=
 =?utf-8?B?MjZCd0U5SXpjTkRUaktPeG5uZmtwNXFxOXpKTDFTS1o2YUdsZ1kzTFJTei9B?=
 =?utf-8?B?WmR0UHVONWNRSW9aVFBGZC9IVUpxTVJaUWZidjZHL293TkJSRWY3ZStKeWRD?=
 =?utf-8?B?aXBwanZ0QmN3SXc3eDY2LzIxLzJhdGg5QmJSZytWYjAvMEZlWDNDSVZnckdB?=
 =?utf-8?B?VU80dHZzMjVhZ1pDQ01oQ1FqdGVaN0pranVaYktLQjNXbWp1eHV5RnRsOGVy?=
 =?utf-8?B?ZVR5K3BXNzl6cG9tc001SmRFbStwanZFR0tVckhUeWhJV1lmSTNraGR2RGVB?=
 =?utf-8?B?c0JRczFvVlZrN2NDUXBiY2JUMi9VdGZhcjFFcllaMjBvUjgvcTNZVTc2K2Nk?=
 =?utf-8?B?RE8xb0FzRk1SUHVYc0V1QThoV1NyUXpObmJaU1UvL1JrWEtleGZlNGo4bWJN?=
 =?utf-8?B?anNwQkVSdDlYVE1yandRVWtjWDBiQm52Nk1ZK1diOXJtd1I0RElnQmp6cWZO?=
 =?utf-8?B?SXc0dEh6VVV0dFlGKytYNXBYUE5OLzJ2T3l4OVFWdVRERFBzQUtLdE00alli?=
 =?utf-8?B?UEoyZWE5UlBaaVk3aTVSckErbGJZVGVUQ2trRWhST3VuM2lyaTZseHAzUldF?=
 =?utf-8?B?WTJWNUNpS091MGp5aU9uUjVDOFFSUVN1Yjl0bldQYzFRelZ6cHVRLzV3dk9S?=
 =?utf-8?B?cEkvZ1lSazhwWmsxU0tKZWtsQmo5amVFNms0NFlsVmdJZU9RcUw5cTlpd0pi?=
 =?utf-8?B?N0Z6cGN5Q3MwRlJUaWIwdVIwUEdlblBJcEdINzdWN2pWZGNNNVE1REhqNVVn?=
 =?utf-8?B?TEdkSGpQL1V0QWFkWkROWndudjBlUlNsdkE1anZSczl1MzRPUi9DTnNNcENK?=
 =?utf-8?Q?A1lk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YnA5dWpGL1RDUTRmYWVCeHJSL0crTDYvVHFWa3R5OEVacG9sTUh5c0xGeWNz?=
 =?utf-8?B?bVlPV2NuNlNpYUlXMVFLWituVDJQWVNTSlZXTmk3VUpsUjFpc1VWaGxxNEdt?=
 =?utf-8?B?YzdSTTNFNVk1NW9pQjRTRWRtQ2NFUk5lQUs4dkFFQ3RlSFFQK1RRUFpxazND?=
 =?utf-8?B?ODExM0JPcVUzSTl4TFB5ZnVGQjVEdkR2TTNyNENJaFNQU3d6d08ya2ZGZ3RJ?=
 =?utf-8?B?NFV4eXZ0eHpBWXpiY0Vxd05TVDVmTER1clplSXRMbFU1Rlg1SkhlZUQwZ25D?=
 =?utf-8?B?VVlhR3JVbnFQNlFmbnA4MXNhVXhrbnhtMjYvUVVMaFNWMHlPZFVlSDA4SG9p?=
 =?utf-8?B?SG92RGpWVEwzYkhoZG8xcXZjNG54VGpXTDJ0OTluVGJrOWRmT2lNT2NCdjd6?=
 =?utf-8?B?bGFIY3VVVVljS2NONWFzS1BJZUFpYjlLTjhxUnNHQ3UyRnE5elBqSE1tTWZl?=
 =?utf-8?B?YjkyWlErcm0xLzU5eHNVWUttRUxhSXZvVVdwSDRaMC9yWnhTdW5NNG9lYlFV?=
 =?utf-8?B?KzdBUVVSeGRwUTQrUFR3VWlyMGpnQmlkZVl1ZDNRRHBBdnhtTTRmSklBTnFE?=
 =?utf-8?B?Z2FxMUZscDBjcjI3S0pOdkE1anFqbUJCeXRrRUhmUG1vRXF0bXVJMkgwYlJY?=
 =?utf-8?B?SG9MZjQ5TXZ5TndUYms2c2tvZy9iVTBIS1hxOTNKSGJOTmg4QWMwVjFCaVhl?=
 =?utf-8?B?ZENUbkZDdGdENUgrU2UvSVpqYkdqeE9Tb2FWckJ2QTlzb3RRTnNGOTVGT2gr?=
 =?utf-8?B?aFNRY1FNemEyMkRkWEFqeG82QTZORGtqd0pkVkhoNXc1VERrS3gyM3JUekxB?=
 =?utf-8?B?bzR6L0ZQblVId09HaHJRaCtCbTFkdFluZE9MWXZOSE1UaEZHN0FYZFJISGI4?=
 =?utf-8?B?SWZoTGFMTk9seVhjT2hmdnJqTTQ5MlUwaHd6cFBsSkF3OVFlY1Z3RVJ2QURE?=
 =?utf-8?B?ZjNQbEQ4RnVBTTI2VERsUFhLc0ljUVlzS2N5YVd1MzZsOExyVWlSTFYra0l3?=
 =?utf-8?B?Y3dSeHFnRUU2Z0JlMmNZM1NzMUpPcFN0aTZsMDRueGl5RU05S3owWFd4eFBk?=
 =?utf-8?B?bG4wSVFqQXNHbXFCKzlEd21PcW5vSjBBUWdFdWFCWmFsMFpXL2FhcXQ2ZmFM?=
 =?utf-8?B?TS9qS01PRzZuc3hyclh6V0kzNTNCczRZK2RZRS9ISjBmbUZ1MlVhL0FrQjl2?=
 =?utf-8?B?OUdsemdSK0pOalFtRktoS3VBdms5Uk5OeDhFRTJzQm5VeHlQcGI4ems5TzNq?=
 =?utf-8?B?RWdOalVqUzVYZ09LNUl4QTJZS0FHQm4zRlJnVjNBZVFkd0NzWWhQbUI3WFBE?=
 =?utf-8?B?TnpLZVRIVzZQRDJwMXoyaXY2UnVEN2s0SmRNN3lIM21TenF2N2JBMGpTMDZk?=
 =?utf-8?B?SVFIM09LdGRQNkpCem5wdHhva0FDdnk5cFNCZzhRN0R5cE1rYXM5SEhuZTB6?=
 =?utf-8?B?Y0xDS1JxeTE0QmhhU0t5dkRSeXZpeFphKy9Fc2Qxcjc1YWF4VG9kZFNva3p5?=
 =?utf-8?B?SjVxaUZCa040OVBnQ0lKSzJuRi84ek1rUk9LYnVKdnZjYitYeEdwdFkzRUZv?=
 =?utf-8?B?UjBDbzVsNUwrRC9EYkUxNTVpWFd1dGlJRXVpQnZtUDA2TUdHUWIrZUh2ZCts?=
 =?utf-8?B?UmFjWU1vUkpaQXgvMjdNb0xLVDJmcVhpMmd6U3F3U3RVTCtjM2FDUjk2RUxj?=
 =?utf-8?B?WE5udjJ2ZkdxWlpQdElhUkwwUCtNYWdWaG9IOEVZaXEyU1VSUk8xcDljUW1s?=
 =?utf-8?B?akpWSnpKUkdpeEd1MUN5QUhGVWpwaEVvM0NDWmxDWmZwcE5mc254UFFiUVlJ?=
 =?utf-8?B?ZGZCbEVGQ3dZSnNzaDNZMEdDQm04MVdWU0hMaFNmZ0JPK3JFeE9HYVVKTFdo?=
 =?utf-8?B?UDI4N0k0RCtYZkdIdDdrbTBnTEdvUkJ3Z2l3cW4xYkpJOU9iT1JwVGJCUGVx?=
 =?utf-8?B?b0NjQWkzOTl4TTcrKzdjUW9xMStLT1NVZU9Fa2luVGxiMnQ5cmRVN0hMMTRP?=
 =?utf-8?B?dHB5STVhNHhjVHIwei95RjN1UGtJK1U0a3VzWWUwUDRGcEtrc1pZZDdmZUoz?=
 =?utf-8?B?ekVxZWdjZ2JlV3ZtK2lDd1JKYktZMDY2ZGVHR2w3N3lGRDBRbktDWVZmZVJB?=
 =?utf-8?B?ZjkvdnowY1UxZ3NXN052OE5waFM1T3JsVTMremo0QldNcGxzelR0ZFE3Z1lB?=
 =?utf-8?B?eC9oK3JmN3locitMZlRDYVptT3R3TUNrSnozVGhUVmwrdCswTmtob29CcWxK?=
 =?utf-8?B?YTZtY2p6YlE5NzlON0M2a3JQWC93dmRDeWw4MTlXL05QQWNYeGw2enI4b3I4?=
 =?utf-8?B?M1kwVmpLNW1XcndRalk2TDNPL0tlZVB0M05MUGJXWkZTNGx5aVIxM1ZwVVNE?=
 =?utf-8?Q?7Gjc2lTM54UVeRxSOt1jBJ+0qtGxLoK3VQTGP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8040536-2003-4509-ff42-08de62dcfe99
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2026 04:30:43.8688
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L857FWHR1zszBO/fEfZneCeE9UjQLhun7xJW15O6eUtYvtQqLNlsrcPmHcAqzCGEbwNAc4qijqV6D4W7PNOlEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5873
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12029-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[26];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[balbirs@nvidia.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[nvidia.com:mid,Nvidia.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 02048D4666
X-Rspamd-Action: no action

On 1/30/26 14:48, Zi Yan wrote:
> Hi all,
> 
> Based on my discussion with Jason about device private folio
> reinitialization[1], I realize that the concepts of compound page and folio
> are mixed together and confusing, as people think a compound page is equal
> to a folio. This is not true, since a compound page means a group of
> pages is managed as a whole and it can be something other than a folio,
> for example, a slab page. To avoid further confusing people, this
> patchset separates compound page from folio by moving any folio related
> code out of compound page functions.
> 
> The code is on top of mm-new (2026-01-28-20-27) and all mm selftests
> passed.
> 
> The key change is that a compound page no longer sets:
> 1. folio->_nr_pages,
> 2. folio->_large_mapcount,
> 3. folio->_nr_pages_mapped,
> 4. folio->_mm_ids,
> 5. folio->_mm_id_mapcount,
> 6. folio->_pincount,
> 7. folio->_entire_mapcount,
> 8. folio->_deferred_list.
> 
> Since these fields are only used by folios that are rmappable. The code
> setting these fields is moved to page_rmappable_folio(). To make the
> code move, this patchset also needs to changes several places, where
> folio and compound page are used interchangably or unusual folio use:
> 
> 1. in io_mem_alloc_compound(), a compound page is allocated, but later
>    it is mapped via vm_insert_pages() like a rmappable folio;
> 2. __split_folio_to_order() sets large_rmappable flag directly instead
>    of using page_rmappable_folio() for after-split folios;
> 3. hugetlb unsets large_rmappable to escape deferred_list unqueue
>    operation.
> 
> At last, the page freeing path is also changed to have different checks
> for compound page and folio.
> 

Thanks for doing this! 


> One thing to note is that for compound page, I do not store compound
> order in folio->_nr_pages, which overlaps with page[1].memcg_data and
> use 1 << compound_order() instead, since I do not want to add a new
> union to struct page and compound_nr() is not as widely used as
> folio_nr_pages(). But let me know if there is a performance concern for
> this.
> 
> Comments and suggestions are welcome.
> 

What does this mean for treating compound pages as folios, does this break
code that makes any assumptions about their interop?

> 
> 
> Link: https://lore.kernel.org/all/F7E3DF24-A37B-40A0-A507-CEF4AB76C44D@nvidia.com/ [1]
> 
> Zi Yan (5):
>   io_uring: allocate folio in io_mem_alloc_compound() and function
>     rename
>   mm/huge_memory: use page_rmappable_folio() to convert after-split
>     folios
>   mm/hugetlb: set large_rmappable on hugetlb and avoid deferred_list
>     handling
>   mm: only use struct page in compound_nr() and compound_order()
>   mm: code separation for compound page and folio
> 
>  include/linux/mm.h | 12 ++++--------
>  io_uring/memmap.c  | 12 ++++++------
>  mm/huge_memory.c   |  5 ++---
>  mm/hugetlb.c       |  8 ++++----
>  mm/hugetlb_cma.c   |  2 +-
>  mm/internal.h      | 47 +++++++++++++++++++++++++++-------------------
>  mm/mm_init.c       |  2 +-
>  mm/page_alloc.c    | 23 ++++++++++++++++++-----
>  8 files changed, 64 insertions(+), 47 deletions(-)
> 


