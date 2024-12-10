Return-Path: <io-uring+bounces-5402-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 464779EAA39
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 09:05:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 029E82821F1
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 08:05:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B445F198E77;
	Tue, 10 Dec 2024 08:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="kcsGXfp4";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="dbZzUK6A"
X-Original-To: io-uring@vger.kernel.org
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CCE13BAE2;
	Tue, 10 Dec 2024 08:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733817938; cv=fail; b=dtVS5YRHXhRiA3RUoxqYCulAYSwvQ7zmWBN+/0KuojjWy8QTnE5NNNWywtWpHdqHkmPGH1g6cXri//WlmswfdoIeB6xB0uvH/a53eVRgCwHpG3MNI9D8FLlM/+lY23TlL0wOwQmAmbGhuYZQgxQYhyTsIdvv87D+93f1SrraFsA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733817938; c=relaxed/simple;
	bh=/oZMqTN+QVXtphZWveLJ6Fp6h6MwA1tfbNZYYdiEQ34=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YYK8culPQcDpvu3TeKCyskmVSouBzZY9/fTwARWvH+i3OP2ZgB3DxA0nXwrgCV5htFBQMzCMqxVTP1R+Q8CFJwRlIdsHeWb9yr08Bxp2Gd7VhZbCF6jqHN7530Y+VOseJIXkZ8iXhxNHJ4dvprhIdIC2GSSvzpzI0ssmKx5UT6Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=kcsGXfp4; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=dbZzUK6A; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1733817936; x=1765353936;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/oZMqTN+QVXtphZWveLJ6Fp6h6MwA1tfbNZYYdiEQ34=;
  b=kcsGXfp4NeHuWg+ONrq9K7L/AqN3DHxnFLlblSEevk7vA5W6Fut0tfY2
   9Mk9C2K5IluZlTfPhfEDx7ZfekXP2eqq3znsuUvY8MOU82i4lJyxRTJHf
   NkpPe9YcLGpXqwjx2H/+X9EzvrHuiyo9vJHuj/rClRYsqF9CBevDWpDEg
   IMt+AV3TkiuRdOxK1eTIX2jXayUdUwu3tGOs8CWb84pw05n4ZFzr94Rtg
   9r0x11PIvKwHpI03C42zWlQtweH65yejNwzHo5mjrAUW6elseMc9NIWbA
   QBcdD264k5P/oInHFRDsw9YE8aDP+qBwc0HNav1fbDFkL9bdz6FbNqJa3
   A==;
X-CSE-ConnectionGUID: 6l4P88EBROyRI26OHkLpwQ==
X-CSE-MsgGUID: w13utSFoR6GC1KP+Kgf3vg==
X-IronPort-AV: E=Sophos;i="6.12,221,1728921600"; 
   d="scan'208";a="34586345"
Received: from mail-bn8nam12lp2173.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.173])
  by ob1.hgst.iphmx.com with ESMTP; 10 Dec 2024 16:05:34 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O669QgKRv5T9SOIYE8Wy87IkF+hR+opZw+YM6W1G3vy523hW0CCq2i6XPJqKt/UAjmVPS6A/I6OcOMk4m1UU/yehC0/IvWaSSvaKI/+75vc6T3/0c0JSgiYu0EXg3L9lagd566tpkZBtEfkDcvT/AuV9ir/Pdxgh/60CL4B5qjBKrkdcGPNl8IlumZBFsN7Av0uVEOYg5UzxTdR8mgRBzPaJSpZoCSCa2FzTUvdZVkpbYu9Y9Ov/i7i2Fz363NUTy4LYhFQ1HM/kVWOm1Y9GWTA6fceYvJnwC16Szmf6iv4l+0SCDLwEOb+7mUaWlsIbiKEdIi+h9LHKoSWhOSetnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/oZMqTN+QVXtphZWveLJ6Fp6h6MwA1tfbNZYYdiEQ34=;
 b=mX/s+xuCVcjfa9ZxVTzIOlkSs6oAIhkU/diVxe3u1Wg42Fcu68fDSjPz2WP5upRKX4MpddR2juzkGGLyUqrHZMfpGfzzYj/qeTPImsBw+nMzc1pt3f+ziaES0G0LuDY73MI85u+pm6YPD/RELgCiTK9wM52VUWjjnnBZl8QaWFoU+o7TsA4mzgskD5u+FXpUIhpFc4rYmZWHsjn48N53yqWUx3bMRBq8W3F1B6icRbqb54MPznZO/+f3QkfT24uZMKOGWjQ08Lk11EDw+oxtGT9ZynLvd5huWbDUgPZ8p8RqQsKql1c1xkm/pN9Awqm4s3KdkX/RSO39IQijRXGt3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/oZMqTN+QVXtphZWveLJ6Fp6h6MwA1tfbNZYYdiEQ34=;
 b=dbZzUK6A1S0iIGy4PdfskbJoAjDe447WuOkiL/itC8ex97tbWhP8dXLAgy8NMz/pdB2at6oP8UKbBM6Ehf1Sj6xkV13hPJ2E7WxW0OE29J3yhienttpO4VdAT4m3x4IvzWxBUwFSzyR9TS3vC8ZCkYRBVUD7wSM+TvRxTqK/tTk=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by DS1PR04MB9584.namprd04.prod.outlook.com (2603:10b6:8:21f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.12; Tue, 10 Dec
 2024 08:05:32 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969%6]) with mapi id 15.20.8230.010; Tue, 10 Dec 2024
 08:05:31 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: hch <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
CC: Nitesh Shetty <nj.shetty@samsung.com>, Bart Van Assche
	<bvanassche@acm.org>, Javier Gonzalez <javier.gonz@samsung.com>, Matthew
 Wilcox <willy@infradead.org>, Keith Busch <kbusch@kernel.org>, Keith Busch
	<kbusch@meta.com>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "joshi.k@samsung.com" <joshi.k@samsung.com>
Subject: Re: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
Thread-Topic: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
Thread-Index:
 AQHbKhYzHqfk+FHNy0OApJay8pJjFbKo4KEAgAN0q4CAASjNAIAAGeOAgAARnQCAAA29AIAAEw+AgAQahQCAAIoIAIABUSCAgAo6cKOACtLpgIABziIVgAEIhQCAABncVoALxksAgADTGs6ABvpcgIAADrSA
Date: Tue, 10 Dec 2024 08:05:31 +0000
Message-ID: <2a272dbe-a90a-4531-b6a2-ee7c4c536233@wdc.com>
References: <a7ebd158-692c-494c-8cc0-a82f9adf4db0@acm.org>
 <20241112135233.2iwgwe443rnuivyb@ubuntu>
 <yq1ed38roc9.fsf@ca-mkp.ca.oracle.com>
 <9d61a62f-6d95-4588-bcd8-de4433a9c1bb@acm.org>
 <yq1plmhv3ah.fsf@ca-mkp.ca.oracle.com>
 <8ef1ec5b-4b39-46db-a4ed-abf88cbba2cd@acm.org>
 <yq1jzcov5am.fsf@ca-mkp.ca.oracle.com>
 <CGME20241205081138epcas5p2a47090e70c3cf19e562f63cd9fc495d1@epcas5p2.samsung.com>
 <20241205080342.7gccjmyqydt2hb7z@ubuntu>
 <yq1a5d9op6p.fsf@ca-mkp.ca.oracle.com> <20241210071253.GA19956@lst.de>
In-Reply-To: <20241210071253.GA19956@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|DS1PR04MB9584:EE_
x-ms-office365-filtering-correlation-id: 2be4c5d3-d1c8-4cc1-4709-08dd18f16b18
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|7416014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?Mjk1aUp0YjBNZ2lQNXFxTkIzcjJSR1RXZmFUSlhvOHYwcU5ITmRZbm9WMHZU?=
 =?utf-8?B?RXRjQzR1dU5mVVRYcW0rTzUxcS90NlhVaXRqUkFIeGlEZUVhVVlIZ2VVWUxG?=
 =?utf-8?B?L2VhZkZ0b3BVckV2cDZiOFYyK0p3bHRNODExaXFQSjhCd1ZOWGFKZnRpUmpJ?=
 =?utf-8?B?dWlid2FUd0pQUUF0Y1BDd0c4WnFPZ21hSXlSc2ZJeDBobkdsaUlYcHNVNnVv?=
 =?utf-8?B?ZWlZRlJFUzF4VnBkbDRrQm9vNVpFRFNaMjE2ajhQdHNEb1djV2JLaVNQb3JG?=
 =?utf-8?B?NWRTeVFUMEI3aTBHMWdOTjZVVE9KTEZGKzVrMkFLM0VmMHp5ZGU3VHI1dHZO?=
 =?utf-8?B?ZlRHWFdwdWVIOUlDWFRKalVZMEVldkdoYmpXU2lNckRZOEJZVnBRTkJPSktn?=
 =?utf-8?B?V3NqR25SSEZyY01tbTRNMGpqN1l4VkhSSHdBRFlUYUxmRUIvQ0hET2hrWk96?=
 =?utf-8?B?cVlwN21PMFZkV1g4czFocG9zSVpQeUFUaEp4Rm5IZmZjYks1NDZlS1Y4WjBi?=
 =?utf-8?B?c01iczUySk5XZUcyRTNXaWcwaGdyb2RCV1ZjbndIem9KVTRqWnh6RzNjSi9v?=
 =?utf-8?B?SlhwaDIvL0pGVW5DM2lnUW16OTJYM0ROaTBIN3NlaFZHRXZuTWZNWHdwSS9i?=
 =?utf-8?B?L25sRkpxMFhONXBzZXdSQW5EaS9GM2xjdkJkSDNMc3YwTVJ3T2hjRXBGZ21s?=
 =?utf-8?B?UndYMExESHBsRHdLa0Y0elRmcmc2amltN210THQ2emJnZm43bHlOakFsaEt4?=
 =?utf-8?B?Y0Q4a1BqU05Rc09lV0xWeUNSOG1PVDAzR0VrU3M4NXh6MUwwdklsOGdVZ2Fo?=
 =?utf-8?B?NjBoS3JQWGRIY3RoT1hJWFVFTXF2ZlVla0VHZnZYRTlBb0FIMENUclBKTEN4?=
 =?utf-8?B?WGhneC9pM3ZPTzZweFdZZVlwamQ5NEdwTGF6Tld1WWFoUEs1OTY3UFNxUk1I?=
 =?utf-8?B?TVhmQVdjUkdvYjczbWF2dXVaNlIvdkNGajFNdUFjeVd6SExBZHpJNGtqcnY2?=
 =?utf-8?B?V2QrbjJ5OUpETjBINWpBeEpEelZNVjlZZVBlVE1kS0hkQWQ5aDI3QlhnNkZZ?=
 =?utf-8?B?SklqS2taTnpMS3hVMGNkbjJldG5WNmYrN09reXZxV052TTNGdHJaNzI1MG5P?=
 =?utf-8?B?T1k2VnVDSTVRU3lrK1g1Q3lmdGxiYkdzVmZza2lCeVJvckUzRmM3blpwaCtm?=
 =?utf-8?B?ZytETlhIem1DSElCKzBuWFdvUEZXVkRRR1dsLzU5NG9UMDQxVEVhSXRWb2pr?=
 =?utf-8?B?akZQZ0UzZmczRVNTQXQ2ZFR0RlpZcGdWL1dUZ296aHpJSWg3RjBrWEZreU1u?=
 =?utf-8?B?K09TMi80NXo0RVVEWmdFaFB1eVZtYUlHMnB1dGkwNUluRk4yeDZDbWV2U1V5?=
 =?utf-8?B?cnAvcFRtb0ZITFJhOVNGK0RMNm5MKzBNVkVxTTlxQnl0SFhnTTMycElRZ0FZ?=
 =?utf-8?B?YXJGMVYzUXVJbFlSYzA0ZjRxUlpKZUpabzZpanVmQURhdnF4N2gwUmxaZG8y?=
 =?utf-8?B?SzZsR2FNTWRIL2RybFM4UTA0Sy9lcDVNa1lBdUlINmxCTkM0cDJnODl4ME9n?=
 =?utf-8?B?b0lxK2lkeGJLWVZJR0NsYXhJV3gyWm5JZ2ZPZm4zcnVzMmQyVjVTbnVkNEg2?=
 =?utf-8?B?Zm1nWWhxemNTbTNqMExRMmc5RzNTV2Fwd0tiK1Y0cGMyaEsxQVVXakJ6dnVN?=
 =?utf-8?B?ZUpvK1JCNFA5MnNoVk1RdzFIbGVGcnRDTHhLMXdJekxuNFJPRjlkczgrS1J3?=
 =?utf-8?B?L2haMWFOejZUMm0yK09IN2hMZGxSUktCTzd1cmZGeHJLUE9OWGV6ZzhLdGRt?=
 =?utf-8?B?SXRwREI0ODVpNERoUUhTaTZIQytUNEZmRTcyeFo2amVIc0R6WjRKcE1zclAz?=
 =?utf-8?B?Z0tKWDIyRCs1c1UvemxWUFp3dEpKYXkyYXYxMmNmTzdkR3c9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MTlQcmN0NGhaR09ielRPYVpzN25KbmJ5MXZzS1FMVlEra3BEOG1pTTdpNDR2?=
 =?utf-8?B?ekRzR2pPUFZZdThPNEdqenRURVArZFM1N200OFdpM2xZajNVQUs0cnlZSWw5?=
 =?utf-8?B?d1dLelZtelNaZE1CdWJXYWJ1QXJrSlI4Q0hyTTBVdlREYk96czBqVnBiQjRl?=
 =?utf-8?B?aUxqTG1Zb0J6dis0eE53K2srU1VIcHliaXdZNWNOdC9zLzVURFdMdCsvQjU5?=
 =?utf-8?B?TnpQMmdaSDJQTEZFa3Q0cmF5a2ZyL0pwL1U2QnZpUFZ1cVNWcVJjbUhQbFA1?=
 =?utf-8?B?YWFZWDVucmpnaGdWUDhuajUxT0xDSzdpWWphU1hpdDE3aXVQeTY1R2JwMlJP?=
 =?utf-8?B?WXJaYjV0QUNQRWl3cW5YVDZPaGw4dW51ZlRUWUtUaTRFdG01OWNFVjdIOTgy?=
 =?utf-8?B?LzFEVFNyQkNnZm50YWx4MmEyQWUzY0VBd0ZWNmRRcTlSb091Y1E3NGhmTm9B?=
 =?utf-8?B?aW5iVjg1eUtBRzRjRE1ud0x6aEd5akt4VXBaTWQxVFN5R2NMVGtKaG5KYTdD?=
 =?utf-8?B?YmNIYlNMb1RMK3B5OVFMQ2NuMlNrZUZHYm5rK1djUGt4T09WTExzQ0xMYzdN?=
 =?utf-8?B?b1ovMTl5UVhwOG1Hby9MWCtZK1h5d1ZadXBLRy91ekgzTXdyeit5eXN0Q2Yy?=
 =?utf-8?B?TksxR3JnOWRyOWcybUZ4NndWYnoyV3IyMHRXQ01vaTAzU3h1bTcxZDIwZndY?=
 =?utf-8?B?S1BEWHlrbS8xUUJPaUdONWN1WWNrWFYyRTRyRU9EcjVnSWVHM1ZORXl2YnZ1?=
 =?utf-8?B?UXlwMWFPUHJDYWFGS0pGeXU0aHdIQ01uUjNrZG5BdC9lR3c5R2VUY0VyS3RC?=
 =?utf-8?B?Nk4yVkQ1Mk96Qk56OGZlTW1UT2g4WjRzSGcwZExEbGdINTl1bUppQU9UcXMr?=
 =?utf-8?B?aHZhUkNUeXdHODBNeHRadGZiczdJV2RsaGlVWTlYVUthYXZVaGJMUXNPbnBY?=
 =?utf-8?B?U2JUR29wRW5lbXJaVXZxOEtCQnRQb0JUMG1oazlRS21RT2lBa3NWMmg1N3Z0?=
 =?utf-8?B?dG1keVRDeDhxSGFPZDZvbmhQclJ0UE5YVE5NQUFmRFpHajVQcEV5RG0vLzNi?=
 =?utf-8?B?dDdZRzlGa2hnZ05uOVRhanEwTm5mTnJITUhJMy9VK3JWWmIzbWoyYjdHcGVU?=
 =?utf-8?B?c2pRMGUyUTFCYjFiczZrVmNEUUV3VUpQWXdTaU1HS0JMVEZhU2lXSlk1QlNu?=
 =?utf-8?B?TkoycFcrT0tVNVkrYTlwN3hwNEdsdC81UmpEQkplVzdOUWQ1amtsTnFpekdG?=
 =?utf-8?B?cHRkclpwWTJDZ0FpTWdtczVVVy9mWm5qVXhwR3BZdzM4VlR4b01kQkNiTUZw?=
 =?utf-8?B?Y3B0YzFBdFN0N3JDT3ExRTNiS3I4NEU3Uys5citQYTdlVVZEVmQ0THhzUDhT?=
 =?utf-8?B?VjRKTW10NWY3UEVFVXN3RmhhZzJJODhaeitFZmhFVmF2U3FwTDF6Yml0eUxT?=
 =?utf-8?B?aG44QUJvSmNzMDBjWjd1bTQwaktnUW1DOURBb2ZtV1owNWljR1JST1pXREU1?=
 =?utf-8?B?cTZHZnBaN1V5bVVGcUtlWWgxdytUcXlDa2RYSm1vbVo1dTNTRlBQR2ovSWRz?=
 =?utf-8?B?YjVaMkRIUnVrd0NtSUgxaHRwang2TkZPd2E2L0RwM3Fna1dGdFJyMVVpcDdF?=
 =?utf-8?B?cGk4dlFPTm5hamRuK2s5bFRlYUs3d3EzY044VnJvZmNWZkh1RUlnbDkvaHk5?=
 =?utf-8?B?RXY5VlBiWjZEWGxiMWlGcFhScU44VHdLS2M1aHYxUVJEQVMxM1BBWkJPR2dW?=
 =?utf-8?B?OW9ZWDYwaG9lb1NnMXA5blJFNEpEYnV2UGR4U25DY0pYQlVpcmJuT0o2cXlP?=
 =?utf-8?B?NkpxalZBM2J2MFVHZkdBZmxsa29RVVNoWkI2ZlU1aGxUK0pyOE9mcUloU3FQ?=
 =?utf-8?B?ZTZtVXN4dTN6KzZaK1RuUWpOWFZJNmxSYi9VSUZiUTIrS3ZLNnM0WEM3NEFm?=
 =?utf-8?B?aW5xamN0VHlxMExLek9Nc2lGWXhKVjNITTRUSUxFYTUwM1pPMGVKT1pUaW9Q?=
 =?utf-8?B?M3ByUUtpcjdZUWVXeHhZMlZNeTNCY3pOT1J3U3U0NEhlUUtsandQNmV5ZFVx?=
 =?utf-8?B?cm9yMGh3RVg0STZ4ZDZkVWFJK3J3NCs4aGhRNFFuS1hkS3AzYnM3Q1UyYnZC?=
 =?utf-8?B?cmpFS2NVNGcyWG1nZmJwNXFVKzNBQ1hXZUtsOFNlRk9tWVVKcjNJdWVsMkIv?=
 =?utf-8?B?b2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9775A6F73DD63141B3DB7675AC4ACFCB@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0Xm4eSSUPNUcE7DabRDrKxZYKQIIETbVNojJvqNRtRVQQpfXvmi9Em5NJXwJMzxtqvpBElDIL3+PTYmaTYwGGxY+2GuyLNnFfF3iyLkE9TyCl3HbjFzJy0vPAqZNEsJh3ZxNwge9N/UzktTaw4B3sn/FP/bkWpJ7DZ5UjSUpW47gX4ZUbRnPEqp7Mln71p9GIJ8VBwk8es07e3hkb1sfUxHHzJyZsNvBaEt5iAVQXFO9NH09+EKq1qNqXyt+1Q1IYGv4bzmFROeurwIdjQdieuUbKTVfpTrAW6dniYrH4wiT/x17RzYnF7oC1oCbkKiSNY8BA5QNUiEk46gqto6/amaKSkHQ2XAknKUywdxxFWXpjoBNmSCn1s+porY0cjvFuSq+EQrA4iQ6fB457O9iwcJ+WtU/PefmHcvdZdnZAipymN9shn6B5EVJXPfAGhglEUdtLNBzr2FyBjQk5HL4Rxtlgah8BOw/K6YjGR+jAQq6oC6PncwYetuUryWLH/SwjIoC3byxjmkAorzO+3yoMgPEzriPyh9Bdlc5ebzqQ2jvexBo8R+wMKbmTCB7c91S73JMZvV0FFLaVkEucbKbpmcVDuhbcrpg4RYc7P0H21H0mXKnpIQQsVJtxK7mZ+Am
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2be4c5d3-d1c8-4cc1-4709-08dd18f16b18
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2024 08:05:31.8975
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z2hvGKQME29TDz5v0QpXMDcBmMkXOrHFsVm2djuae+Y/KODbFPOkmqNT3lwDJhuxUtajLA2WhQRWuUF7SLRxBOoTAVWv8+Ezl8/2jySkgPQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS1PR04MB9584

T24gMTAuMTIuMjQgMDg6MTMsIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOg0KPiBPbiBUaHUsIERl
YyAwNSwgMjAyNCBhdCAwMzozNzoyNVBNIC0wNTAwLCBNYXJ0aW4gSy4gUGV0ZXJzZW4gd3JvdGU6
DQo+PiBUaGUgcHJvYmxlbSB3aXRoIG9wdGlvbiAyIGlzIHRoYXQgd2hlbiB5b3UncmUgZG9pbmcg
Y29weSBiZXR3ZWVuIHR3bw0KPj4gZGlmZmVyZW50IExVTnMsIHRoZW4geW91IHN1ZGRlbmx5IGhh
dmUgdG8gbWFpbnRhaW4gc3RhdGUgaW4gb25lIGtlcm5lbA0KPj4gb2JqZWN0IGFib3V0IHN0dWZm
IHJlbGF0aW5nIHRvIGFub3RoZXIga2VybmVsIG9iamVjdC4gSSB0aGluayB0aGF0IGlzDQo+PiBt
ZXNzeS4gU2VlbXMgdW5uZWNlc3NhcmlseSBjb21wbGV4Lg0KPiANCj4gR2VuZXJhbGx5IGFncmVl
aW5nIHdpdGggYWxsIHlvdSBzYWlkLCBidXQgZG8gd2UgYWN0dWFsbHkgaGF2ZSBhbnkNCj4gc2Vy
aW91cyB1c2UgY2FzZSBmb3IgY3Jvc3MtTFUgY29waWVzPyAgVGhleSBqdXN0IHNlZW0gaW5jcmVk
aWJseQ0KPiBjb21wbGV4IGFueSBub3QgYWxsIHRoYXQgdXNlZnVsLg0KDQpPbmUgdXNlIGNhc2Ug
SSBjYW4gdGhpbmsgb2YgaXMgKGFnYWluKSBidHJmcyBiYWxhbmNlIChHQywgY29udmVydCwgZXRj
KSANCm9uIGEgbXVsdGkgZHJpdmUgZmlsZXN5c3RlbS4gQlVUIHRoaXMgdXNlIGNhc2UgaXMgc29t
ZXRoaW5nIHRoYXQgY2FuIA0KanVzdCB1c2UgdGhlIGZhbGxiYWNrIHJlYWQtd3JpdGUgcGF0aCBh
cyBpdCBpcyBkb2luZyBub3cuDQo=

