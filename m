Return-Path: <io-uring+bounces-12094-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QAMgM2aziWkUBAUAu9opvQ
	(envelope-from <io-uring+bounces-12094-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 09 Feb 2026 11:13:58 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7732510E07F
	for <lists+io-uring@lfdr.de>; Mon, 09 Feb 2026 11:13:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 615443009B33
	for <lists+io-uring@lfdr.de>; Mon,  9 Feb 2026 10:13:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC927366069;
	Mon,  9 Feb 2026 10:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4p7IOS2d"
X-Original-To: io-uring@vger.kernel.org
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012004.outbound.protection.outlook.com [52.101.53.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B88365A19;
	Mon,  9 Feb 2026 10:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770632029; cv=fail; b=ZIE0ISIrFbpIwqKWJ1GaY7TsdfWvKKuTtHgKAmyGTThOH/YK7kGi0qpChUOxG21HqIt+9L3T5QzOpEpPLxSrdw5lZHUcTqkPCu+JEbPe9fOVld1vOVwM30DOoePcQTTIQR/UjKPocrPHBvDhhfK6mZpO02xtV0OCcoXzo2jtZZg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770632029; c=relaxed/simple;
	bh=ksPqFIocF4335PqyMQIt6nvnGF8FvN09LfJvAK8Joz4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SLj34zFwLVbEQuGBBLW+ct0JYdFXI5tOubilu65LHGL4PTuUzY1d9Z2mt0IqFHG5zS92IUX52eo4CLrxz0tjKVz5XQsq5N3nb3w5HsqEwSpBHRBbrZKORjqE+BOsa3VnGRGRf9z/bZSa8FaMdAyiqeYKNeCNdmGHKjGFHS2uCPo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4p7IOS2d; arc=fail smtp.client-ip=52.101.53.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qOgIKggA12jSYlPC/QiVIY1BaSEdAkWRmqGeAKtWBx2scoJ+Q3lr32QQ1pvX6kjO2yOlXv1AS0DxIeJCelfUAaG91WmH1wchK4etw6IURDyJFdrzqf0VPMVpRkTP1WdzkJXuxmPcrpgjEDlQvsM0FNqda7xkSus1biWH0nN1o1NJa9r08hYP188FT4EnntzLmLrbJqSANQV3VXnOjcsut79f7E1e36lw0UNpyCroxob79skDRIF8g/rzM5gB17vhA+Kl2v6pMAHRy6R9Qk3xdcg7wqiAVr2jDMYReA+lrElBzuPpGxvFtgjfBHPadJ8mM5rWIoLjqBGtGdk+JWogEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2hvJrAFTVHHZFlLDMVS2zXfMsW8tEOtHGD4zbnGFpmw=;
 b=xArPi9ylWkVaP2BzHZepyewCesAXQ/BzCJsQe03AlzVBf88sMi21STMrxyLlOzVBd2q1tgNqinw1OhdVtFnUXbcGVueitMnkEZdfbXKz6DMYf4UOlvlYar5O8WeUl4iT0HESEJ9owsGZBFmpqg5vbBiKlHEycD4lvFu0WPltdmR4NtCyyLDAwhRKAE19hkTkNnoUtCXK4n5ilF6ZW+o0xRQBUpnb+tPOZy70Eas513+1blBvuv/I5oUliEGB7+jrQJQkeeT8GaRaqTGgR/FxlS/YCVhFCSmNmFay4eSIU2OCq80AjzUQTv7iI7205ZgC6eHXEUWo+XNOecPq15leQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2hvJrAFTVHHZFlLDMVS2zXfMsW8tEOtHGD4zbnGFpmw=;
 b=4p7IOS2dz+g9VQ1HoLHZFNmab4Lv+2Wb353rur4ksdE+P1loi9r2zCd3ohMzOWdrgMaHlKJ/LDlBIAg9/EZ9Cmga6yeoT0KjhvBGwu8ZG3AMw8bQDET5ID8zz0BABe4VJSyjbTMhIa2HpF5s/hwK0/2czDKCHRxVU7YGSfqEABo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by SJ0PR12MB5636.namprd12.prod.outlook.com (2603:10b6:a03:42b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.18; Mon, 9 Feb
 2026 10:13:46 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%5]) with mapi id 15.20.9587.017; Mon, 9 Feb 2026
 10:13:46 +0000
Message-ID: <b69f230e-717c-4ad4-b086-ea480cf39b88@amd.com>
Date: Mon, 9 Feb 2026 11:13:42 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] dmabuf backed read/write
To: Kanchan Joshi <joshi.k@samsung.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org, io-uring <io-uring@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 Christoph Hellwig <hch@lst.de>, Anuj Gupta <anuj20.g@samsung.com>,
 Nitesh Shetty <nj.shetty@samsung.com>,
 "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
References: <4796d2f7-5300-4884-bd2e-3fcc7fdd7cea@gmail.com>
 <20260205174135.GA444713@nvidia.com>
 <dbcc2912-e1df-491d-b1e0-7812279297de@gmail.com>
 <20260205235647.GA4177530@nvidia.com>
 <3281a845-a1b8-468c-a528-b9f6003cddea@gmail.com>
 <CGME20260206152216epcas5p293f71122593a41954f8a92bff170202e@epcas5p2.samsung.com>
 <20260206152041.GA1874040@nvidia.com>
 <4068f00e-e84e-49b2-b1ac-72180ba19558@samsung.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <4068f00e-e84e-49b2-b1ac-72180ba19558@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0092.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9b::16) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|SJ0PR12MB5636:EE_
X-MS-Office365-Filtering-Correlation-Id: e07a441d-a16e-45dd-99d5-08de67c3e938
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bE5jZTNDNkFSWWxBcXIzTzJvRmMrNGtHNWRpMDBFODIxak90byt0QXppWlNq?=
 =?utf-8?B?MlNFb0N2SjNJc1Z5WlMrVGZVSkx1TTdLK3k2RmdjeWlkdTUvdU1INkwvS3Q3?=
 =?utf-8?B?eEgxNTJjU0xMb3J0THBxMzVpRTN3S2gzUlZEaDdHeENtbnhWbXF4N3BNN211?=
 =?utf-8?B?aEFvTmVvUGx0NnBpUVVkS0F3UGNLWHkveFFjWGh6RlQvVWFuUFZ1OFdLQ09F?=
 =?utf-8?B?bDYvZHA1blcySFlQb2RIQ2VUSFRPMUNabEc1czhQeG9TRDU4dS9ZcE1xa2lR?=
 =?utf-8?B?OHlRaDJEbXJZM0k4SVg0dnJldjgzdUlSeDdKa0pwUE84VU9mVDNlcVVJeHdh?=
 =?utf-8?B?TWRRTXhnRU5TVmFwZThZNWFvV2lYYzR3aDVuTnZ4dEM5VzJ6V2t1Y2R1UWNT?=
 =?utf-8?B?dW90dm8zYkdGeVFDd25xbllRclEyS25UY1FVVk1nc20wVlozVUg1dm5JV3BM?=
 =?utf-8?B?MDhYeGFVOVh4U3JIWGNyWVJoSjRNNEdSTGZvbVY0MFRiNno0clp1cXJwRFJH?=
 =?utf-8?B?c3k5OG1hZGN4U0RjbUF3aTh3RjVUdWV4WU5wMDlRdWVmTG83eEVwUFNjOWJj?=
 =?utf-8?B?dWQ3SncxY3luYndqMmYrdnpuOUowSDJCSnFqeTV4QWpaTmw5MCtBN2tVZTV0?=
 =?utf-8?B?UitSS252MkRiZzI5RjJXdmIxSkpKRHNubHg4TTRFckFIdE1haDZzYzROM05i?=
 =?utf-8?B?ZXBCL2pla3hrSDFzUFY4SDJoZFlRQkg2QWpZcG5XbXlwTFFIUkxhQ0pCeVl2?=
 =?utf-8?B?Lzc5dHdReUNUb2xaRGFNaWNJc2lpdnZoSnh3Q2VrRnZuMElFS0cyZ2ZTWi9W?=
 =?utf-8?B?RWxSYWswQndvK1Y2b0h0ZXM5Q0prdmZ4LzZsV0NGVUI4RE1hMDY2TkttRGpl?=
 =?utf-8?B?Ym9pU0xDRjZpeVVrSGVNUitudzZva1pSdWhhdzVxTmdrMlRHdWpKaDlXbkNq?=
 =?utf-8?B?Rk5uOUdRTktkVjlsY1BkME1INkNRb2paTUF4ZUhFaGpOeHoyUHRjcjJjcHZW?=
 =?utf-8?B?ejdQR2pSMkhnWDdhVDRxbW9wcTVDalZ4VlkzVzkzTW5yZFB6enhZTXBLQTdI?=
 =?utf-8?B?bEtFck5DYlp2VEVwek5HYnFDeVA4Qk41RFpza2MvanJBTUNaaW1WZFNuMWll?=
 =?utf-8?B?Q2hqZkYxYzFER1Q0bmxhRE1EamgrVTFCeUw2dVFxUzNnMGdVYmdQRWE2YkNs?=
 =?utf-8?B?djJKbXBReHdNSVhUSHB1NUIxd2ZHWFNvMVY1a0NqbDVCKytpemVHMU9KdGRv?=
 =?utf-8?B?eUVxcmpqb0RSTmk1a0dUWEkwTGYyRE02Vmh0b2Rpb2pTQ3ROQ1UyNktnR2Np?=
 =?utf-8?B?aW55ZnkwQ0lpWE12VnYyOFQrNkJGZ0REQTJaTUZhd05uSjRXKzN5VEhkRVNU?=
 =?utf-8?B?RWJqUkZjTVlPYVRzcHJrd0JzSDdET0VtaC9yRjFjSU4wTFZFc29WUThhYlRF?=
 =?utf-8?B?WEx2RDN2cFFRZFV0MzAraklOeHdqK0p2cGlnYlZVWkRtK0ZURzN4WTBDckFW?=
 =?utf-8?B?UHpRc3ZEM1dLdk5RQ2p4aGxublBUSzhEVTRyY2pOWXlFamwvNHMzelNXWDMr?=
 =?utf-8?B?Y1RsMWMrZFp3WXRET2VqT0dxS2RRdmdISXFrY0FHbVpzbG0xMm4zRjRxdW85?=
 =?utf-8?B?Wm5zUGpSditaREkzelJERVpEaGUwQTlTMkJrVEVFK0JFN2pjU3ZONlNZZVNm?=
 =?utf-8?B?MGtYRE1QTitDQktVQkppYmVYT0crbnl4NS9veGw4bWRiL25yN0Q1U3d5c0NQ?=
 =?utf-8?B?TDJKNmVoOFk4bkVJMDU0MFNYL2pJSUU3RkNTdERxa09HemRqV3QydWUzMHpm?=
 =?utf-8?B?QmFlazBjRWQ2OUNiMzJXVEs5N0NGckwyWDRJcUtoeXpWdkdmSDQ0YmRHaThO?=
 =?utf-8?B?MGFTZXA1RjBDakRlK014K3BRcUpoRS9pWFdBd2trZW5FRk1LUThQaXU1VDJN?=
 =?utf-8?B?SUdSb21RY3cxa0d2VjVRbnlaZEovQWtHMGtjQ1lYTmdKSlZQbVF1dVplakh1?=
 =?utf-8?B?VEZsY1ZBVVZZY2tZdXBtU2ZhL0dQc04wQXdoNTk4OTc2cDBxc2pEVG1MbllJ?=
 =?utf-8?B?OGppVEt5TTNVQ3NQVTlYdlQ3Szd6R1lQdUFKSVYwYS9qV3FuREpZYm1oVklJ?=
 =?utf-8?Q?3vb8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dWE1R2xCRkJGazNCVGdNY1hwc2trbzQ0N3puRENaL2txL0NTZEx1ejRtbm9S?=
 =?utf-8?B?aUlDcDBJT1VBKzNWZ3JoWVFjWlFqQzgyL3BVMkxSTXRLbVc1NTdOT3JPZEVi?=
 =?utf-8?B?RzI3V1lDc2JJT2RpMGg0OGx5R3lDMithclREejBNcGhGeGMzTTRqM0UzSWdZ?=
 =?utf-8?B?NjJqRURqNTl2SHQ5alg3MUdmdHlkekJhdWNqaVZGTUljQ0hYR1NwbkZPKzhT?=
 =?utf-8?B?bFFqQThnNlphZjY4Z0VYRTRUV3p3WGlJa29pb0FBK0UyZXBvMytLSEdPSXhW?=
 =?utf-8?B?eE5ZQ05yQytFTWJnTzg5Tm5ubk5IMGUxNWJKVjZDTHNwY2UxOWM3U3JkVTN1?=
 =?utf-8?B?V01KZkNXWGhaeXNTQWp3NVJBY0RPMUdERFFIeE1YTDVrNFIvT2RJOHdydXg4?=
 =?utf-8?B?VTBPWkp2bjNOUzhveHhWZzFLTTV2ZUJOaVVEVzdNQ1pxZzluMTVUYm13Qkxp?=
 =?utf-8?B?eENObHJIZ1Zwa01heUw1VTc5NVY0a2hBOHl0amE2Y3NkRThRQkhDQyt6TnNh?=
 =?utf-8?B?ZnhpNWNLZDk3VTdYN1MrbWJ4elNieFhHSTVmS252TUR5bWFZYnhtc3lsaU9u?=
 =?utf-8?B?VVBzN0x2d1ZBdTMyRDBuMUFUUnFKWnN4b3lpOE54TEloOFJYQTVvZzZqL08y?=
 =?utf-8?B?TWg3aHlUU1o1ck01UWdGWmI1b1U3a3FlZjRJb2xsbDIyN2YyM2ltNUtvWStG?=
 =?utf-8?B?a2xPUnF3Z2dITVBwbWt2V0Nlby9EK3R3RzlxcTdvREszY3NhVFFOcGlqT01N?=
 =?utf-8?B?TFVMemF1YU0yQzc5c1dEQkU4c2NVOXppTWM0ZFdmby9tR1QvYzc1dVk5RlZH?=
 =?utf-8?B?UHk4Y21IVFJhRG9EaUxYZ1YrbTd5NjNGc1VxWldPZ0dvZFZ4ZzhJYmc5MnZm?=
 =?utf-8?B?N0hoZldDdlZjVU5RZk5wTTJIR3FESk91dDRYZ1hkNVNZSlZtMXN6YjkwQVc3?=
 =?utf-8?B?R2JkbjBKUHgvWUthV2xnbnNXaFJEUTdZTWJzaFJSSnlQV0JGaktpZnlyZUdV?=
 =?utf-8?B?WVhXaEFNNDN0UHhSeEIzMkVhWlJJUzFuZWV5TGRzUkJCL2FHWnlMR0hSV1dw?=
 =?utf-8?B?QTBIL0lUdHhCeVZpaXdvVUphZ0pxVDlNV3JHTlp5eURERWliVGZFYlVNM1c3?=
 =?utf-8?B?dU5qNGhPcksvV1VhRVovV2JVemFIRmw5TERUYTEwalVmQmo3T3ZiSEMvVzdT?=
 =?utf-8?B?b3pYOUU0djMvTHJlcmVQSFZsNFZoOXNIWFZCM1pqYy83cEQvZFhXdDUvTkFH?=
 =?utf-8?B?Wk56dDRMWHdOZUp6REw4VE4zOSsrSXpnblUveS9MQlQyNWlNQWx6OFhTVjg3?=
 =?utf-8?B?cHJUTHA1WnphVXo3NGZrS3BxeDNac2JsTkxiMEd4S3NMYW5XdnBaOHlkeHBj?=
 =?utf-8?B?VFRySDZCYW51U2pGL3c4anplclhyT3dBNDc2MHFWYTQ1cWpEQTdSbnl5VmVZ?=
 =?utf-8?B?SFdKamVHYUpBWlNseVJsb0pPd00vRGZDNWwxL29QQXMvWnFOVVFMcWJURVIx?=
 =?utf-8?B?cGk0ajgvU01SYVI0Z2RzSmFHYWExREdNRHowbTZFdGpGWk44UjQyVmRnT3VR?=
 =?utf-8?B?RElKNHdId0c1UzRZS0doQUNXOGNMaHRGWWc1YmVRc1QyVlZFd1lqSitrRTdF?=
 =?utf-8?B?dTg4eGEwd1AvallDQUhGOG1ZUWxqd0tqdGtNUHBkRXc1aW1kQWtNeUl5Qk1p?=
 =?utf-8?B?bHlQcEIwaVJ1SnVFMWZOZ1FCUlV4RER0M0VFcnNBRDdadEZaOWp6d2dWY0Z2?=
 =?utf-8?B?emUwMlFHaWU3eVdwMEk3SHZDbmsveXhzM0FZY3FKa2dTNW1LYWFJYkVObzZX?=
 =?utf-8?B?M3FPZFRDR2Y3SmpoTEsvOTFNbWdXVU92L21LUFF3bUY2YktTZkpaYkxPdWtI?=
 =?utf-8?B?T3FMVXg5Y3crZThTSTErcHRHVEsxYlFsTXNSOFNxMU9ITFZ5ck5EN24zTWVq?=
 =?utf-8?B?eXNub01IemNMQlZvRzdpM0ViNWxOTTh3c3hKOUdiVDVSS3ZkQllZZzY0SWNJ?=
 =?utf-8?B?STlXcHBidlF2dnFmUVdueW12bnA1VTY0N3hOaEcyamJqTFpOeTVSYitJK1hV?=
 =?utf-8?B?Y0hmOXpuQllYaHh3ZEQwdzRwQm9vWkdJNGlicC9lVTV1V0Q3Q0hBME8rTTRT?=
 =?utf-8?B?dzU2d0EyR2dYSVhWODc0a1BnTGRaT0JEYitJaGIySE5yazFvc0JxNVRtbVRZ?=
 =?utf-8?B?NExDa3RsZUJRdjVJY2FmRURQeGpRS1pQTHc5MEdPTHRYZ1FUREJIbktmVWpK?=
 =?utf-8?B?RTE5eFZRQ2M4TE90VXlBQUpHdWlBZERhYnF4K1ZqYU02YTMrSWhDbmRGZVZl?=
 =?utf-8?Q?oLnimT9k6BAVLb0HmA?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e07a441d-a16e-45dd-99d5-08de67c3e938
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2026 10:13:46.4199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xuGj7ZmdLE6k+z4LiRGdNPwN+B1T/2YXm7EWjHEq9t9KjQqXUDEdD8cAInSAX1W7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5636
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12094-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[samsung.com,nvidia.com,gmail.com];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[christian.koenig@amd.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[amd.com:+];
	NEURAL_HAM(-0.00)[-0.968];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 7732510E07F
X-Rspamd-Action: no action

On 2/9/26 10:54, Kanchan Joshi wrote:
> On 2/6/2026 8:50 PM, Jason Gunthorpe wrote:
>>> I'm actually curious, is there a way to somehow create a
>>> MEMORY_DEVICE_PCI_P2PDMA mapping out of a random dma-buf?
>> No. The driver owning the P2P MMIO has to do this during its probe and
>> then it has to provide a VMA with normal pages so GUP works. This is
>> usally not hard on the exporting driver side.
>>
>> It costs some memory but then everything works naturally in the IO
>> stack.
>>
>> Your project is interesting and would be a nice improvement, but I
>> also don't entirely understand why you are bothering when the P2PDMA
>> solution is already fully there ready to go... Is something preventing
>> you from creating the P2PDMA pages for your exporting driver?
> 
> The exporter driver may have opted out of the P2PDMA struct page path
> (MEMORY_DEVICE_PCI_P2PDMA route). This maybe a design choice to avoid
> the system RAM overhead.
> As an example, for a H100 GPU with 80 GB of VRAM and a 4 KB system page
> size: we would need ~20 million entries, and with each 'struct page' as
> 64 bytes in size, this would amount to extra ~1.2 GB of RAM tax.

That is a good argumentation, but the killer argument for DMA-buf to not use pages (or folios) is that the exported resource is sometimes not even memory.

For example we have MMIO doorbells which are exported between devices to signal to firmware that a certain event is done and follow up processing can start.

Using the struct page based approach to manage the lifetime of such exports would completely break such use cases.

> At this point, the series does not introduce any change on the
> exporter side and that is a good thing. No?

I need something like a free month to wrap my head around all that stuff again, but from the DMA-buf side the last patch set I've seen looked pretty straight forward.

So yes that no exporter or framework changes are necessary are definitely a good thing.

Regards,
Christian.

