Return-Path: <io-uring+bounces-4665-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 207099C7E2E
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 23:23:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B2C971F230AA
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 22:23:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB38018BC23;
	Wed, 13 Nov 2024 22:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XZPWvhax"
X-Original-To: io-uring@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2075.outbound.protection.outlook.com [40.107.94.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537C0187FEC;
	Wed, 13 Nov 2024 22:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731536590; cv=fail; b=s/l8TTSgJhqgoBcWuWBllk/0UNTzmcrMUCnHvGo49Ya63XWz2f/1L2Lzhy9o5x8d3BeQ3MXv3KSIs7UqYGU8BA3/D/9aX2nYyPZJTN2wSx38LKlKOM09H8+lUoiSXnjuNSikjBR7f+20+XfPecZvOJvQ5PZo3Siue8C6ki7oJYs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731536590; c=relaxed/simple;
	bh=H2/6EY7bVKLV1OvJeeOigW0ya2M4b04IAMdq/gCi3Dk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=M8bexwdOV8l4fMYSmaV5RiurlJOvakpk0i74yXJRamJB50lIUyonVY5QKIojTgMRja3yYk+FR7O6gcyC9/hunJ1cAyXmuPq+sEPaLlESFgktQpU/ZdX/F5OF6mmuVpSWD3xaaaHNSg3aXkm9dZKnrKWAdYnnQbqwmnzuVY8vANM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XZPWvhax; arc=fail smtp.client-ip=40.107.94.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xAHCulotHKRDC5BIjum+cXrwug2RyUD8doBZ3pXg3urLWejJDDDFDNUWunVWDda+iZak61Zwz7vIKJt0X2rWTiNs6pug0EGN2oWNtjl4rKcezMAtkj2dF0j52QatlY4Ii2OloHGTShTANgHmiaZhrugGtlbgcLfb1KJUeFIep/Lk0XMYZN6/FPND0BbSAjGSInp2v/RPit2n7429IEpFpH5aqciiCMnwWh+LcIUHtjuu0leAvSfrRi0O3OkDDj/3mEy5+fWojD8qPktNlcyGGfuUEZOD7xpzHL9kWn48XG/z9Ccfreb0Qlb/fcBCa1DmE3BKEKzscTGBCsROZJoU5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H2/6EY7bVKLV1OvJeeOigW0ya2M4b04IAMdq/gCi3Dk=;
 b=rYWGZCe6bal9biV8QxdyAfvlKWl2Bv5DDJjCMgku/om/dsmrOWMOmC8MNwKHVhgxylLXuGze3yEX+TKYVBatKc9MCCbpPP2BzjWDy19avBbncC5WxF6wO4J/PMZWFNzlZeSWb6oSe7jdp8o066pikUAx7NQFHIQvqd+Mr7V06a0PVkVljljeVlmGMyBtAsS+vukRjgdC+pH5AL6g7WGlRciL+9JDMbSgFrQ/V6i/5XKygUdN7IQNpB81NXW16cwsAABZ+LWDBUsmXm3CwkgbBwgS/0rqTZQGa7w1g/LTvYZDNCW6skpjQ04aIGOPtpodKn1R4MVc4URi6JWC0I587A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H2/6EY7bVKLV1OvJeeOigW0ya2M4b04IAMdq/gCi3Dk=;
 b=XZPWvhax2lJh21YpuAiYl/oew05zWDh+RPmr/V1iDLycWvlv+rLc55UpjdVxfT0A12moMoJnMiMcJcZfJMhXGpjfyXs78EyyXwZdaW+BB/AyLwnNK+ASpjKt03nNiSdOXPKSjOwx8JuFwwi2/4OJ/4PzbOshEKTt87CxJ4f59ujB/5/Qfx9vUeZq6x5zvZYfCN2MJ0sFfvq8BYeysmm0vsnKo39k7dNE8sSEIcZkdVMwLNi8T/QMB13rDBBBBeT/8W+SWcXiIzTIcnGJHE40t1hrpj9HexZSVslKHuqAK8VcR2HMYZ6k354rnyLx4kXpBY+BX580GdIj0X1p5ft3aA==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by DS0PR12MB7728.namprd12.prod.outlook.com (2603:10b6:8:13a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Wed, 13 Nov
 2024 22:23:04 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%5]) with mapi id 15.20.8137.021; Wed, 13 Nov 2024
 22:23:01 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>
CC: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>, Pavel
 Begunkov <asml.silence@gmail.com>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "virtualization@lists.linux.dev"
	<virtualization@lists.linux.dev>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>
Subject: Re: don't reorder requests passed to ->queue_rqs
Thread-Topic: don't reorder requests passed to ->queue_rqs
Thread-Index: AQHbNd+6y4TJCQSoD0abWWMVSd1fR7K1q6wAgAAESwCAABl7AA==
Date: Wed, 13 Nov 2024 22:23:00 +0000
Message-ID: <8156ea70-12a2-46f4-b977-59c9d76a4a65@nvidia.com>
References: <20241113152050.157179-1-hch@lst.de>
 <eb2faaba-c261-48de-8316-c8e34fdb516c@nvidia.com>
 <2f7fa13a-71d9-4a8d-b8f4-5f657fdaab60@kernel.dk>
In-Reply-To: <2f7fa13a-71d9-4a8d-b8f4-5f657fdaab60@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|DS0PR12MB7728:EE_
x-ms-office365-filtering-correlation-id: 78cb881a-a323-48de-f25b-08dd0431bc32
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?VnJCOFgvMVRYeDVGM3dnd3BIWFA3aWk2Nmk1QTJLU3cvays2YmorR1NHb1hG?=
 =?utf-8?B?ZEhBWGVnN1l2NmdHYTdaZjBVMHJ0aldvbE9NRjFMZitPTmhqcHlpalg4RE1R?=
 =?utf-8?B?VFRTa3paYWNjNGJ3bW4yZTN0ZTN1VDF1S0VxSlhRVHdrYURRWWpuSjgvQ0ZI?=
 =?utf-8?B?L0xCcWZzTzB3bFVBTXU2c2h5d2NDRTB4dDArNFNaVm1MYjJuV2lMaFBDd1VK?=
 =?utf-8?B?RjYyRnM1MU9OaGk2N05Ec1U1L01ySUtIVWJMbkNHR3k1VWh2c3RjNmdxVjFk?=
 =?utf-8?B?c0lkNGo3dFhaYTlJNjA3WExURlJ0cE11NWozRE5MaVE1WVJtUXNIU2Z4aHJ0?=
 =?utf-8?B?R3NHRFUwaE9DTkpDWGY0U2xLRTFXTi9zdEk5eDAxdWZEb0c3dDlDUHFlSWI5?=
 =?utf-8?B?NS9yYks4Q01Lck1KVURvTlpMRHRuYnVmejJIUVplVjhRMHJkT1BQK29aT3pD?=
 =?utf-8?B?eFMyTi80OExJSmV2MmpxdXNza25EVmN3aVZlVFNuZ01neWhDcy9TYVRxcWk4?=
 =?utf-8?B?dTdjdHFWSXUvdTVwY01iTkNzbzc4dEpmR2FrQWwyRC82R0RYS21CTWxXL3Rv?=
 =?utf-8?B?WVVEZ0kyRXFqcVF5V1hTdEp1Z093Y2x3aWQxL3BkNld5eVc0V2NxTEVTVklr?=
 =?utf-8?B?SlRQUnBLenBmZkcwdkF6ZEtkVXl6ODVLZUFHTXBKWFkrTGJHZDZQTlhzM1h6?=
 =?utf-8?B?dzB6VXdFRkowT291UUZsSnR3MEMxTXpkUW9iMFlEcUdDUVdBZlh5Q3pZaWpm?=
 =?utf-8?B?NGY2ZnEwZUZDdXVUaUIwU1RFQ3JjcmRhT2NOcUNzaURjV3dGSGJIZ0wvZkNo?=
 =?utf-8?B?c0dLbzc1bTV2RGUxUW04Nzl2NEl1dlk0bnBDV1FYM2trWGxjRmI1clNxOVFy?=
 =?utf-8?B?YmJHeUxXaTdMbVM1SVo4dHFMSWtDcXpxNnVMV1U4dlJOUlR2OVprd3ZWL3VM?=
 =?utf-8?B?WWdmZE1xaS9oSFlJT3RIdFdDSlorUzJnZUhmOFVqMFN4ZnhDVnVrWWRPc2hE?=
 =?utf-8?B?YTdLLzNVSGhKMS9wUlBvT3NMMStIa0ZHZTdkZjI3ZFhJMGhDM2tBSUxEVVVv?=
 =?utf-8?B?RVZBRyt1Y3RuS1hHa1ZLZTlWRVcrV1dWWm9OMytzNWJ4ZGIrUk9GVEJKcElw?=
 =?utf-8?B?eE1tR2w5MVpjTStBMzdOREJhbUNmemNHV3NRUUlaV0FMS0VGSHhxRW9lOExn?=
 =?utf-8?B?aUdySEhXUnZFZ2FlNDlValpBYXlyUnZGM3Y3QUZxL0NSWVlXbTQySTdmZHA2?=
 =?utf-8?B?eUZIZ1RIZWJLV1pVRWF5ODNkREhOcmpQcHpxUmpYbUs3MHRrSklhMEI0ejVI?=
 =?utf-8?B?UWc2MXByRGM0NzRCalJrUm1KcTRkek1UWkpLUmMxbUhWK1BkaWlrVDlkK0pJ?=
 =?utf-8?B?c3N6em5Qc3ZYV0NFVlhYdnQ0YmJSbmx5ZTkrb0s2a2NIV2dLL2c5eXl1cnJh?=
 =?utf-8?B?SFg1aEdYUEtHMjBDYzRGQ0gvVnNBQ3ZicjJIQTJQa3lPUlkrdnNFekRLelJX?=
 =?utf-8?B?VzF1akdNNVgrTmIvQmNuOVF3c2RyQ2NkbHhLNVlXUDN6VVQ3WE5ybzlGYjh6?=
 =?utf-8?B?VWRuRTZXSnpwaWJPbldzYnQybWRMYTFNQklFd1lyenZBVVJPOU5IYXVFb081?=
 =?utf-8?B?TitoZDlyakYyY0E0bEgyZVREU0xldUF3b0llSzA2d1NCUWVXQUlHZ1JDcFhP?=
 =?utf-8?B?bG5RNXlhQ1Q3SzM4dTViUWk4KzZJS004UWdhemtkNUtoTVVrOEtWQmNLREJt?=
 =?utf-8?B?Skx1MkhRVlBPcXNSamx2Nnp4dWlKQ3ZvMlNya0gwQ1loYnorZWNoTEtzeTlB?=
 =?utf-8?Q?ApZRAnYfyMOg+UQAcQDKbvr76JZeNQ9Efwwlo=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NWpaVzdPMStNWjAxMG9vRDNQQ0hqMEVjRGxGTHNWT2NQUzJlb1NCNXh2aXpS?=
 =?utf-8?B?TnlTSTRxajF3ZWs4TnRSdUZyTmlyRGtBZlFVWWdhYitWdmFUcXVVOXBGMm5H?=
 =?utf-8?B?U3hFZnlRSkxFYld2TDNnWVMzc0t0MXVkaWlxdkV6SzQwMlFTVDNITnZSZW85?=
 =?utf-8?B?NFNIQW5UTlh4OEhNWVJaZysxWktKTjZRTGo0dCt3MUppNzJRbEliR3M0aEtS?=
 =?utf-8?B?VGI5WDByc3NadFBheFZWVlA3M1V0TXZGelVTVlpGZDRIeDJ3OEhmYXlXT1Zw?=
 =?utf-8?B?NllrTHlaWENWRVNvUXZ5TnFSVTlFcDliZ3RWdzZsZ1dsazh0NDNuR3JSRzRC?=
 =?utf-8?B?ZCswQjZEQlIzbU5FZU8zc085QkdDalhjNXNUYTBZYWtXYzV0NjZZRFpYMGcy?=
 =?utf-8?B?Z0NLRFFGZEN6R3BrOVdGZjEzK0VVOVNFbjJJbUJrSkhORnpjY3dkc3A4ZVAr?=
 =?utf-8?B?R2RpOTNOOW4vMXhlTlV2ZHlBZVhYR3FkMERuZFJCVmFTKzRrZHUwMFJhdUhS?=
 =?utf-8?B?OWlmM2UzdjBGZGJZNXMrNnRqQ0Q3SGNoTCs3c25hL0pDelp6QU9jSVM5MFlh?=
 =?utf-8?B?dHp5K1d0U1J2VUVpNFMrdThsWld0MjREdFIzUVljY2xzZzlEZW4wZkptK1dT?=
 =?utf-8?B?TUlxQTNJaFRYM3Z2M1dXWmZNYW0ybUswSTBwSzN6RWgzQzVERHZQZDFXYVJP?=
 =?utf-8?B?VjNoSm9ESlpmNC85M1k0TWFQT0cwd2pnVFlpMFk3VTFHK0hlVzNxKzZGR3dI?=
 =?utf-8?B?MUtlczJTb1VqWTdHL1lUOVQ4QkYwRlZZNFJZZEpxYkhzTklhak9LSEFCcUgy?=
 =?utf-8?B?Sm1kT3ByME83dml5ZmhLT21aeFlrNG5kbEM1NzBKOGZLalBSVE1JU2JKNUVy?=
 =?utf-8?B?RkRQKzRybXhJUitMZlFCL3ZLdmp4M0xPWitkYU5mV2JtVzRzcEhPcjQxQjds?=
 =?utf-8?B?dHBqWWZVcytha0dSM05BMXdvbXJBVER1U29ONVgyVk0zVElzcFhRS1NrdFBw?=
 =?utf-8?B?UUNIQ3c4NytmeGNvQVNBc2M1aVdkRmFQb1ROVXljdFBzZ0hQQytROTNrVWh2?=
 =?utf-8?B?NE5LenNFL3hvbkhHbkFNQ0cwczEvanNabi9WMk50U0tCSGh6bXFpd1NTdDNn?=
 =?utf-8?B?MlA2OG12Q0dnZ3MyTzNLOVdZdDgrVG94SUZMUWRxZ0l1WEVONXFhcy9QZVA5?=
 =?utf-8?B?Y0locnV0aTEvRjEreFZFaUszemlucVpqWDNFVEZlTzVVeWNyRGJ4Ky8yUlRF?=
 =?utf-8?B?Y3FtZ3lhNG9NdEJQdmgxZXhSQVhBYW5sVHo2eFV5cmh4SFZEMm51SHVrNllM?=
 =?utf-8?B?MEo4ZGk5S3VySHB6a01USHIzbXMvcFlpTkk2bW10aFdFVE1xMVY3YnFmMTAy?=
 =?utf-8?B?UzVIVjMxcnFhazNFRzRrL0pmVVk3Z1FDY2N0angyYU0zTGpTWkdUMU56VFZY?=
 =?utf-8?B?aXIzcDRKQW1TMENCbWhLUHpLamhDTHZNM2U0dVR4bS81Uk94OUo3aUxQU0hy?=
 =?utf-8?B?NU56OUUrcDFNZmpMMVJqTnp6czhzQzdUclVsWWNxY1FMZ2RmRGdCdVRPUWtM?=
 =?utf-8?B?UnVUOFdSVXZNaDcveFJhZ3I1eThnclE2VmtCSnc3dkVoMzl4MEcyUnNqck5U?=
 =?utf-8?B?dlloRytQTWx6UWQ4ZHF5cjdEcWRqeTdad05SSS9oK3l2ckg3ZzVwb2VXSk4x?=
 =?utf-8?B?L0FBK2FybjVwYlM1WVVXRFVvTm1JVDU5d2s3V1hhSThLRGZlUXFwVlU3M3hJ?=
 =?utf-8?B?Y3EvYXZWcmZXVG5hZDN0OHoyc29VQjVlWHlMVWtFcmNyUDJQMldKeE5wdTFF?=
 =?utf-8?B?TlFvMlovYUk4STJZaWFMVTVvTVptT05sdUN2bmxMSVYrcUdWSjdKM2xVRC9G?=
 =?utf-8?B?a0dBQ0RmRnRGNzJWdnRYb1RuYnFhV2QyN2g0Tk9FSGhYMnV2akRHTjlQL21Z?=
 =?utf-8?B?YzBEaTBxZFYrcmRUUEcxdEQ2WU5HREZCNTR6T2FlQVpyZkRZVXJwYWFLZlhu?=
 =?utf-8?B?QkZWR2dlTzF1U0dyUHVYVnFVQTByRjJiOUtHRVp6UjF5bEtPRHM0a0N2Q2FG?=
 =?utf-8?B?L2ZHVDNVR1FwN1l0UlVVc1NOdzQ1NlMrcllsNTFKMTVWWUtEZ2FjNDhlTTZZ?=
 =?utf-8?Q?16Aa9aW3NpGH+hAS4fGTFSi80?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A5315A24EAEC56418737784CBD0AA9D2@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9404.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78cb881a-a323-48de-f25b-08dd0431bc32
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2024 22:23:00.9321
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 31deM6syI75bj6LsobemxDfq2afd0qcjF69QySmcpbBPa5a/20uuvQQrNTPoRPUasnOci5Q8a7TAuSgiRVE5LA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7728

T24gMTEvMTMvMjAyNCAxMjo1MSBQTSwgSmVucyBBeGJvZSB3cm90ZToNCj4+IExvb2tzIGdvb2Qg
dG8gbWUuIEkgcmFuIHRoZSBxdWljayBwZXJmb3JtYW5jZSBudW1iZXJzIFsxXS4NCj4+DQo+PiBS
ZXZpZXdlZC1ieTogQ2hhaXRhbnlhIEt1bGthcm5pPGtjaEBudmlkaWEuY29tPg0KPj4NCj4+IC1j
aw0KPj4NCj4+IGZpbyByYW5kcmVhZCBpb3VyaW5nIHdvcmtsb2FkIDotDQo+Pg0KPj4gSU9QUyA6
LQ0KPj4gLS0tLS0tLQ0KPj4gbnZtZS1vcmlnOiAgICAgICAgICAgQXZlcmFnZSBJT1BTOiA3Miw2
OTANCj4+IG52bWUtbmV3LW5vLXJlb3JkZXI6IEF2ZXJhZ2UgSU9QUzogNzIsNTgwDQo+Pg0KPj4g
QlcgOi0NCj4+IC0tLS0tLS0NCj4+IG52bWUtb3JpZzogICAgICAgICAgIEF2ZXJhZ2UgQlc6IDI4
My45IE1pQi9zDQo+PiBudm1lLW5ldy1uby1yZW9yZGVyOiBBdmVyYWdlIEJXOiAyODMuNCBNaUIv
cw0KPiBUaGFua3MgZm9yIHRlc3RpbmcsIGJ1dCB5b3UgY2FuJ3QgdmVyaWZ5IGFueSBraW5kIG9m
IHBlcmYgY2hhbmdlIHdpdGgNCj4gdGhhdCBraW5kIG9mIHNldHVwLiBJJ2xsIGJlIHdpbGxpbmcg
dG8gYmV0IHRoYXQgaXQnbGwgYmUgMS0yJSBkcm9wIGF0DQo+IGhpZ2hlciByYXRlcywgd2hpY2gg
aXMgc3Vic3RhbnRpYWwuIEJ1dCB0aGUgcmVvcmRlcmluZyBpcyBhIHByb2JsZW0sIG5vdA0KPiBq
dXN0IGZvciB6b25lZCBkZXZpY2VzLCB3aGljaCBpcyB3aHkgSSBjaG9zZSB0byBtZXJnZSB0aGlz
Lg0KPiANCj4gLS0gSmVucyBBeGJvZQ0KDQpBZ3JlZSB3aXRoIHlvdS4gTXkgaW50ZW50aW9uIHdh
cyB0byB0ZXN0IGl0LCBzaW5jZSBpdCB3YXMgdG91Y2hpbmcgTlZNZSwNCkkgdGhvdWdodCBzaGFy
aW5nIHJlc3VsdHMgd2lsbCBoZWxwIGVpdGhlciB3YXkgd2l0aCBpb191cmluZz8NCmJ1dCBubyBp
bnRlbnRpb24gdG8gc3RvcCB0aGlzIHBhdGNoc2V0IGFuZCBtYWtlIGFuIGFyZ3VtZW50DQphZ2Fp
bnN0IGl0IChpZiBhdCBhbGwpIGZvciBwb3RlbnRpYWwgZHJvcCA6KS4NCg0KLWNrDQoNCg0K

