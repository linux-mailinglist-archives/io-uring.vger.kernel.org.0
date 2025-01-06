Return-Path: <io-uring+bounces-5687-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FA70A0318D
	for <lists+io-uring@lfdr.de>; Mon,  6 Jan 2025 21:46:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 97B807A0103
	for <lists+io-uring@lfdr.de>; Mon,  6 Jan 2025 20:46:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F34521E00BE;
	Mon,  6 Jan 2025 20:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hpe.com header.i=@hpe.com header.b="QTzCTIyq"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2141DF988
	for <io-uring@vger.kernel.org>; Mon,  6 Jan 2025 20:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.143.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736196388; cv=fail; b=KYu0Fgdc/MnNIkBtsPdCfY14X/naRLPRD/W7x96NGRUP/T4cSwAkNKa6TDAOnGKJKYzoe7LhRP2TPgrxn1BZg+Jh7IBD3n0mc7bUTtotIhAn0Q8BUFesa2anNgfzyRfhVOC7vLhE2QFtliOOqn7JCPGubCv2X9E8fR2Xl+0JwuU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736196388; c=relaxed/simple;
	bh=B+oPuDnWCctw+81VqVoNZmb36Y4BfkW552WoE/d51Ds=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=FCWUk+5PBqO6fhZNYV37H/RP+1NX56DjaebU3yJVWT2RrdGqknPwgBYfwFPzn1EwW2cmkFUzdUq4X2IU2C5toyMbPi30fjTIfxxfsCVl5AtX/7YitZ7JD1j5p4HYj1SCob66yLr79C7+qmtfWzEPEr9h39J9popNp1gIvHvsNzU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hpe.com; spf=pass smtp.mailfrom=hpe.com; dkim=pass (2048-bit key) header.d=hpe.com header.i=@hpe.com header.b=QTzCTIyq; arc=fail smtp.client-ip=148.163.143.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hpe.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hpe.com
Received: from pps.filterd (m0150245.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 506K2KTY019759
	for <io-uring@vger.kernel.org>; Mon, 6 Jan 2025 20:04:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=
	content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps0720; bh=B+oPuDnWCctw+81VqVoNZmb3
	6Y4BfkW552WoE/d51Ds=; b=QTzCTIyqGNKh+4h/8foTNN9dk337G96UbNtzJyUX
	7iIgTwv2aB5C68dOSu0eQjQE38j2M8cZtK6GG84W87Kv5K3aFYKfG3RFjUkiliST
	oXfSu7RNnRwxHbWUrUFabUmp7MPYQy03WXwPnpxRbwz1kR8ZhcEm3tLA0jhJfHXR
	Db42/HFNc3ikTDNuLludoloQg3JgKLEF4NSGh5lE18VtUnMZqa+OPY6mUcHqX6P3
	X+1mDIPyoSyFvwp10iRUqjXXTX4QUBVybc6MDacIeqX7m6iA4ONAVVrrOgQ6u8Ii
	ChdWz8189xlbkPYPLzpGXLMbdte9W8pxmAbFTV8vdW2upg==
Received: from p1lg14881.it.hpe.com ([16.230.97.202])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 440mg88hf1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <io-uring@vger.kernel.org>; Mon, 06 Jan 2025 20:04:06 +0000 (GMT)
Received: from p1wg14924.americas.hpqcorp.net (unknown [10.119.18.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by p1lg14881.it.hpe.com (Postfix) with ESMTPS id A25C2804DE1
	for <io-uring@vger.kernel.org>; Mon,  6 Jan 2025 20:04:04 +0000 (UTC)
Received: from p1wg14927.americas.hpqcorp.net (10.119.18.117) by
 p1wg14924.americas.hpqcorp.net (10.119.18.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 6 Jan 2025 08:04:00 -1200
Received: from p1wg14919.americas.hpqcorp.net (16.230.19.122) by
 p1wg14927.americas.hpqcorp.net (10.119.18.117) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11 via Frontend Transport; Mon, 6 Jan 2025 08:04:02 -1200
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (192.58.206.38)
 by edge.it.hpe.com (16.230.19.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 6 Jan 2025 08:04:02 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xC+19vtwQcUbe+dT9kI8YjMwH53J/YIOWnC53iZTLCUpWFZv7nG7HRu2s6dROIsTqfORkFa/KFHberi3YNzknTEaIe2ZR8la7qPzsBqkD1urIj2ph0sHk8xAmVNDEx+hZlUTss46jao5FnHbB4RQgI0jQdaZpflwE7smXkRbwQZTpFNu39Ru9UBXbkbIhUQdbxlveeGwTv9t6ZUfvEW73fg434YGSpiSlGreC1+BuOv5zwYYqEc2hwwqWUErR4/teEdQ6xrLrQn6h7qkBGdrZd57ZYQ2i50QKX1ffg2kOht6FQyZXx/VN+4CQ7o2icjKN8PMyhXHnZLR244k5LrX7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B+oPuDnWCctw+81VqVoNZmb36Y4BfkW552WoE/d51Ds=;
 b=hLK3G8l7jd+3Fse40lI5R+qEMj5xSPLz7ulWI+Cp5kCzLwTgVED/Ua4ZfkP/FQ/Ut9eK8aZT3r/802705RzAZMBQkHNIMhNgoIuCyKyKP9KtP562gX8CkXaINgkWiS0oVJkueBefrshmbWvuJ9/3l3J1laxy2GeSerqatFA5YvjY5XNxjZ6TDfdCtQu/3rZuZ8POHUZ9tTSnGLppy77ZDGBSV7JLhy1BzbPqtsXs8+OSHyH87ukyxUf93or1CfIe6UrQ5sRRZwRjRfo+X+HOG/UpDC2hx41jiR61v7AofgoIR0QyUwPwypPQGc/Bw94STKqNV2fBqdwDJALNVe7xgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from DS7PR84MB3110.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:8:9a::7) by
 PH7PR84MB1678.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:510:151::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8314.17; Mon, 6 Jan 2025 20:03:55 +0000
Received: from DS7PR84MB3110.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::2d35:fec1:e913:c9d3]) by DS7PR84MB3110.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::2d35:fec1:e913:c9d3%4]) with mapi id 15.20.8314.015; Mon, 6 Jan 2025
 20:03:55 +0000
From: "Haeuptle, Michael" <michael.haeuptle@hpe.com>
To: "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Bug? CQE.res = -EAGAIN with nvme multipath driver
Thread-Topic: Bug? CQE.res = -EAGAIN with nvme multipath driver
Thread-Index: AdtgdgRGzetgECR+TH6K9ws7LfEKsQ==
Date: Mon, 6 Jan 2025 20:03:55 +0000
Message-ID: <DS7PR84MB31105C2C63CFA47BE8CBD6EE95102@DS7PR84MB3110.NAMPRD84.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS7PR84MB3110:EE_|PH7PR84MB1678:EE_
x-ms-office365-filtering-correlation-id: 3b3b976a-bb2b-4aa5-90d9-08dd2e8d3ff5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?WmJkcXkzVXErbGVmU2hiM0JhQktCZ0xvMThodThrYzMzb20zbnJYR01MR0hu?=
 =?utf-8?B?TGVTREZYU28rdGRZbGhrcjBaRHZxTFVIWjl1dVprdkErM0NhdjRDMVRWa0hU?=
 =?utf-8?B?NU5FK2pIWldIaERSeElyYUtIRFdGbE1ZMWJtd1dmUWVETXBWSG44MitvaURp?=
 =?utf-8?B?QVpRamlBZy9VRjdod3RudkpOWTBFOE9JNGI0OWRsTUFSNWM5YzE3L2RyL0VZ?=
 =?utf-8?B?UiszekE1QjFDUXY4bEVGSlhsM1hjMWJpYmdIbDBERXZsTTlHdDNoY24wSlNC?=
 =?utf-8?B?VFZPRld1TmRFSWZJNjJZU0J6dkhmejhKTVB3QWdMc25scnB2UWdFcHBRR1Nu?=
 =?utf-8?B?WGNiY1QyTGtGM2dOa2N3T2FKcUx2ZE1wNnlIMlA0RjQwS2sxd2dFNnBxWmhO?=
 =?utf-8?B?VWU4a2lYQmJNOEFNemlNeVNyUkh2cDJHMitCTlBINFNJZ3B2UWwzMi81QVlm?=
 =?utf-8?B?Zmc3eWduMlBXYnpaYWJ5VzNTZkt0TUM5a3ljQ1NtTmI4U0R5VmdoVG5ncU5p?=
 =?utf-8?B?U2ZvSjF6UTVETkt3elpsSHlWcEVSOFJSQWQwRTA1QzFBaUNtcXRZckhBT2ZS?=
 =?utf-8?B?RkE0NkN4TmVIaW5Zd2hnbUdCaGJOeGRSWEVzUmM5TkhqMW9XWXh4VExPTlIz?=
 =?utf-8?B?cjFsenkxckdKR3cxKzFNK1VmUVk0VlZ1TVVsSWh3WjZodlF1QmVQaEtaMXFH?=
 =?utf-8?B?bGY0UWhsVitPYjkzYjZKeGIrT1djcW8vNW5UWC9hN1J5eTh4NzF2WVc4TGZJ?=
 =?utf-8?B?K1VpV3ZtMHMxSEY4Vy81bVkwa3EzTVBaVXZiWjJCTWlwUzVvL0FISHhoZjZw?=
 =?utf-8?B?MzkvTlBZa2RpeFcydzZFUXdoS2h4akk1WmhNUzlySEpHeTBSNSsrSVMzYU5U?=
 =?utf-8?B?RmpQK1QycStDN3FVVlltUFB6akovaFZqUmJSMXpEZngyUVNFbjNpNEkvUzVZ?=
 =?utf-8?B?Z2dYYzNzc0VjS1Q4cGJNN2QrQno5N29rTDhXdU5JSDhMeXNrZ0hZazc5d2M2?=
 =?utf-8?B?SUVDSTFuSXRYOEk0emRieVVZbzBLanBEdHRycFU4cmRPRFJHNFUvem9jOVQ0?=
 =?utf-8?B?a2c2ZklBUENjaGE3M1dEd25yY3BJNzVaVVpXc0ZFU2k0eHJQUUdGU2pyVVI4?=
 =?utf-8?B?RTV0Q2pRaWI3Um5PeGo2OXFiU1VNaXFQYk52UnQ3dDBwM0NXdFpjNzN2T05a?=
 =?utf-8?B?SHJIc01xRU5RTWNQeDZsdFV6VCtXN3VFdFJURW8wNzRObVJ4emhJdlFLN29n?=
 =?utf-8?B?MFArRG95MUhkMTBwNzR1dW1hN2lwWUI2SENOZkhtdk1PMTJ5QWgzNVQraXpo?=
 =?utf-8?B?d2VvVEpVZ2k5dlN6M3R6RGxRVDhJeFRjR2lLWGVmZ0hCN1Vvay92VkRETE10?=
 =?utf-8?B?WlA5SVFOdllzcUZsZGxrQksyK0ZXb29lbXlZNVpuUmg5N2VIWmdMNWNLNnV4?=
 =?utf-8?B?aytZS0lYRVY1Q1pmUWNrZEdVRlBrdzZEditkekpTT2swdWNtby9hWnRTOGxq?=
 =?utf-8?B?bENFOEY1L0hZSlVsNUJpd2txZDdHeUczT08xTFZhWm9oZC94azhSV1A2Q3l4?=
 =?utf-8?B?L05KejZsSW9Vb1pldW1oQWZySmhDZnc5NFdhaXlHWmt0emVtTkdnbGxHYmVJ?=
 =?utf-8?B?aXdnZW8yS3lBM0hPSE1nbU9odTRES0ZTQ29mQnRSanB4UzloY2hibmptOFFo?=
 =?utf-8?B?UktsenZGd2N1WTZsRlV3V0hIaVVid08vUHhrdlNYK0owNGlhanl0NkFvYmVi?=
 =?utf-8?B?WWw0ZVJWSWNWM3d0NUx1bi9RQmhzNjRpczlCQlNtSVAxMEFLVmduRjFISm1J?=
 =?utf-8?B?c0hsSkg1czBWQzlUNmtNc0xuZ1o1aXUvbi9BRjkybUI1Y2JuRU9zUEEyT3NI?=
 =?utf-8?B?VFhob2MwRFVWNjk1L1NNb1JLcllPUTBmTkFZUDFWb0Qrbnc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR84MB3110.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eVBNUGpGYmkvMkFTaXNRazhSMDh4TjdpMWdadTBRU3ZzVkdrRmh5VkFVblJK?=
 =?utf-8?B?bzFuQ0Jpd2VpTVFyeWM2clpDT3hHUm1Qb2NqSm1Fb1pOa0tESVJwUTUxSmdi?=
 =?utf-8?B?NlFxVlk5Z2hZN2dWZTJwZW5KaGM4U2prbnB2MGpENGYvbHkyOG9RdzhuWnRU?=
 =?utf-8?B?dGV4Q3V5cHVUVzlRWURRTXZNQkp2WTFKU29sSnc5K2RxNFN6ZmxWSDFqMXpQ?=
 =?utf-8?B?SjNjU0IxMmhMbzh0ZCs1Y3kwS2hwMUJkaSs4WXBJUURNOFl5ZTIvdFBKUnpk?=
 =?utf-8?B?Sjd4OEFwdm83RnFFV3dkZVB3VU5uemlIOXh4TDhTUmZWc1plL3VUUDBpZk9L?=
 =?utf-8?B?TDJTZzhOa3JVQ3Z1bkV1NmZuTDBFYk1rMi9pcCs1ejg3WGRWcC9qamhFcXJK?=
 =?utf-8?B?emZKQUFhazlqWHQ2dzViUzBUQmVOZDFXcWxpaXhtc0twZkQ0WUswVzlDTlYr?=
 =?utf-8?B?MldFZXFXTnRkMzNFZ01VVzVZU2FNdmE5aGdKNForMTRKRVlWUnAwaXh5WVZt?=
 =?utf-8?B?anJuVHpwbWgra2dvaDB4SkhOa2ovR3FuT1dxMmhXMWlMem5sYjhvdU5maEhy?=
 =?utf-8?B?MHNpWEFtVDRad0pKdWFRbisrWG5YTTh3YVZpUkxGRG9HRFVwNHFkbHdBRFJs?=
 =?utf-8?B?L3pMZHh0dnVWTzdJU1NQWkMzMjA0Nit2M3BNcXFweElxN1RYWnF3ZFZYbE9s?=
 =?utf-8?B?d0taV25TSWRaQTlwSzlLWFAwR0pqazFBeWJFMXVqUU5kNmdDcU9IZVFrREhU?=
 =?utf-8?B?YTFHcmNLRkliS1dtTTI2dExYR1RpeEs4OUFaeEY1VFlmRTRYbXpKYm9CS2wz?=
 =?utf-8?B?T0N4MzMyZWN3cTlIVmpwS0x0MU8yOHpmemNZSjF1RGUrZmcxbHFwQnF3Mlcr?=
 =?utf-8?B?MHZKclIvYndLZ3pEVUJqelZEclBsYjh4bm1CR0lsbnFuUUE5QUpDRGI4Rkc0?=
 =?utf-8?B?NUVHeGhkMDUwQUFuOGcwOVQxU2RHRFhxYmZqQktuTFlibmVCTk9ad3RxS2s2?=
 =?utf-8?B?SW95c0FUUWh4Q3hKbEQ0UFFkdkNMeXEyNHZCOG0rZW1SUjBsMnVSdE9VU1po?=
 =?utf-8?B?NXFqdjk4Vm1haG1pdXp0NDdCNnAzWXg1SHdmY0Qzc1JqMElDNi9pSHZoN1NT?=
 =?utf-8?B?RS9ldDl2SmdVQjl1RTdGU3pDVGk3YVVBMXNHNytRZVJoaWVnUDJtc3lQMW56?=
 =?utf-8?B?Z2hHR3dZL0tYcExWM1dZK0NlaWxyQ213dk1QYWVqTjNuNmNUSTJoZm9TWVM0?=
 =?utf-8?B?Q01pbHhOa2I3N0ZiNC9ZL1FiL1pUY3NoZHVrTW5GaXNtK2h6a2xEQUtud3JK?=
 =?utf-8?B?VkpZS1pOdktzakt3T3ZqdEdzN1ppdXpLYVFKMDhwUmxGNFZpdWpVZmJSWTl0?=
 =?utf-8?B?L29wTlJsSWhVV1pyU0dNL0NwZnB5TVFNazdGbHhHbWpSa2h3R2dkY2NuRHJx?=
 =?utf-8?B?NEROWEcwZWZVQXdHd2xPREVPeEgyem9JTWhrdWwwMTRZMDJxMFhqRjV6QlhR?=
 =?utf-8?B?SkpHK2NCUk56cjZkM2hmNHdsVGtiV2gzSlkyYVREbmlqRUhMRjFoZlZ5MlVn?=
 =?utf-8?B?VVJYb0ZISmxFREFwZFlqQkpXTU5nMXRqTU94SWRaYnNiK09PTXcwVW9MdlRS?=
 =?utf-8?B?K3JQWFZ5NWpZcnFndTZ2QkVUQkVaRm41ZDljenA4aWR0amVEZWF2bnBqVThU?=
 =?utf-8?B?OGtaZ1lySXRRT3pBK0NkeHEzVmUvL1FvaTJRUFNGQWJpWVE3ckVld3hwbTBy?=
 =?utf-8?B?QXl2bVhROXV5N0FGaDR4WXNJcm9QOWgxdjdNVW5lbkovODIvMlN5S3Vzd2gw?=
 =?utf-8?B?NnMrZGVTZ0Jod0c4Mk5lWDJ3QXFSOWdhclMwdXBjZzJyazZLbCszZ3BjZ1Iv?=
 =?utf-8?B?N29HWGFGRHdQZkszdTlEakU4aDBza2UyMFhjdzc3VHY5dmNmUFpabldmL01u?=
 =?utf-8?B?QUtUZTNGODgxTXlyS1U3amZ4THZOTFAxUEJ1ZFlidzlIbTFQSVFuaitaTFlO?=
 =?utf-8?B?ek5RWUJYNHZHMEpyL1lEWDFyY0xsbm9sT1RsZ3daM0U0Q1JUQjFNblk5V3pR?=
 =?utf-8?B?RDZjajJHRmc4Zm1HRzRoT1RYSEpGRHpvNGZGRHMybm90bmFibFFETEJmQjVU?=
 =?utf-8?Q?e+8/FB9oLIJxTuGHOMSI3PCz5?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR84MB3110.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b3b976a-bb2b-4aa5-90d9-08dd2e8d3ff5
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2025 20:03:55.4284
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jujOHVXrlmEVrPJ6ynTcEoOPnKw/d+Hkan23t9t2aek4O3LHcdQx5rJuxi7cd2OsuGzDLvWsJ9U5L71XvFwfje///AVJlFZBMUUtxpWWwmc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR84MB1678
X-OriginatorOrg: hpe.com
X-Proofpoint-ORIG-GUID: JE5pBWS1Q13Pe4L27i2pdz2X8Q4EMtoP
X-Proofpoint-GUID: JE5pBWS1Q13Pe4L27i2pdz2X8Q4EMtoP
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_02,2024-10-04_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 impostorscore=0 bulkscore=0 lowpriorityscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 suspectscore=0 priorityscore=1501
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501060175

SGVsbG8sDQoNCknigJltIHVzaW5nIHRoZSBudm1lIG11bHRpcGF0aCBkcml2ZXIgKE5WTUYvUkRN
QSkgYW5kIGlvLXVyaW5nLiBXaGVuIGEgcGF0aCBnb2VzIGF3YXksIEkgc29tZXRpbWVzIGdldCBh
IENRRS5yZXMgPSAtRUFHQUlOIGluIHVzZXIgc3BhY2UuDQpUaGlzIGlzIHVuZXhwZWN0ZWQgc2lu
Y2UgdGhlIG52bWUgbXVsdGlwYXRoIGRyaXZlciBzaG91bGQgaGFuZGxlIHRoaXMgdHJhbnNwYXJl
bnRseS4gSXTigJlzIHNvbWV3aGF0IHdvcmtsb2FkIHJlbGF0ZWQgYnV0IGVhc3kgdG8gcmVwcm9k
dWNlIHdpdGggZmlvLg0KDQpUaGUgbXVsdGlwYXRoIGRyaXZlciB1c2VzIGtibG9ja2Qgd29ya2Vy
IHRvIHJlLXF1ZXVlIHRoZSBmYWlsZWQgTlZNRSBiaW9zIChodHRwczovL2dpdGh1Yi5jb20vdG9y
dmFsZHMvbGludXgvYmxvYi8xMzU2M2RhNmZmY2Y0OWI4YjQ1NzcyZTQwYjM1Zjk2OTI2YTdlZTFl
L2RyaXZlcnMvbnZtZS9ob3N0L211bHRpcGF0aC5jI0wxMjYpLg0KVGhlIG9yaWdpbmFsIHJlcXVl
c3QgaXMgZW5kZWQuIA0KDQpXaGVuIHRoZSBudm1lX3JlcXVldWVfd29yayBjYWxsYmFjayBpcyBl
eGVjdXRlZCwgdGhlIGJsayBsYXllciB0cmllcyB0byBhbGxvY2F0ZSBhIG5ldyByZXF1ZXN0IGZv
ciB0aGUgYmlvcyBidXQgdGhhdCBmYWlscyBhbmQgdGhlIGJpbyBzdGF0dXMgaXMgc2V0IHRvIEJM
S19TVFNfQUdBSU4gKGh0dHBzOi8vZWxpeGlyLmJvb3RsaW4uY29tL2xpbnV4L3Y2LjEyLjYvc291
cmNlL2Jsb2NrL2Jsay1tcS5jI0wyOTg3KS4NClRoZSBmYWlsdXJlIHRvIGFsbG9jYXRlIGEgbmV3
IHJlcSBzZWVtcyB0byBiZSBkdWUgdG8gYWxsIHRhZ3MgZm9yIHRoZSBxdWV1ZSBiZWluZyB1c2Vk
IHVwLg0KDQpFdmVudHVhbGx5LCB0aGlzIG1ha2VzIGl0IGludG8gaW9fdXJpbmfigJlzIGlvX3J3
X3Nob3VsZF9yZWlzc3VlIGFuZCBoaXRzIHNhbWVfdGhyZWFkX2dyb3VwKHJlcS0+dGN0eC0+dGFz
aywgY3VycmVudCkgPSBmYWxzZSAoaW4gaHR0cHM6Ly9naXRodWIuY29tL3RvcnZhbGRzL2xpbnV4
L2Jsb2IvMTM1NjNkYTZmZmNmNDliOGI0NTc3MmU0MGIzNWY5NjkyNmE3ZWUxZS9pb191cmluZy9y
dy5jI0w0MzcpLiBBcyBhIHJlc3VsdCwgQ1FFLnJlcyA9IC1FQUdBSU4gYW5kIHRocm93biBiYWNr
IHRvIHRoZSB1c2VyIHNwYWNlIHByb2dyYW0uDQoNCkhlcmXigJlzIGEgc3RhY2sgZHVtcCB3aGVu
IHdlIGhpdCBzYW1lX3RocmVhZF9ncm91cChyZXEtPnRjdHgtPnRhc2ssIGN1cnJlbnQpID0gZmFs
c2UgDQoNCmtlcm5lbDogWzIzNzcwMC4wOTg3MzNdICBkdW1wX3N0YWNrX2x2bCsweDQ0LzB4NWMN
Cmtlcm5lbDogWzIzNzcwMC4wOTg3MzddICBpb19yd19zaG91bGRfcmVpc3N1ZS5jb2xkKzB4NWQv
MHg2NA0Ka2VybmVsOiBbMjM3NzAwLjA5ODc0Ml0gIGlvX2NvbXBsZXRlX3J3KzB4OWEvMHhjMA0K
a2VybmVsOiBbMjM3NzAwLjA5ODc0NV0gIGJsa2Rldl9iaW9fZW5kX2lvX2FzeW5jKzB4MzMvMHg4
MA0Ka2VybmVsOiBbMjM3NzAwLjA5ODc0OV0gIGJsa19tcV9zdWJtaXRfYmlvKzB4NWI1LzB4NjIw
DQprZXJuZWw6IFsyMzc3MDAuMDk4NzU2XSAgc3VibWl0X2Jpb19ub2FjY3Rfbm9jaGVjaysweDE2
My8weDM3MA0Ka2VybmVsOiBbMjM3NzAwLjA5ODc2MF0gID8gc3VibWl0X2Jpb19ub2FjY3QrMHg3
OS8weDRiMA0Ka2VybmVsOiBbMjM3NzAwLjA5ODc2NF0gIG52bWVfcmVxdWV1ZV93b3JrKzB4NGIv
MHg2MCBbbnZtZV9jb3JlXQ0Ka2VybmVsOiBbMjM3NzAwLjA5ODc3Nl0gIHByb2Nlc3Nfb25lX3dv
cmsrMHgxYzcvMHgzODANCmtlcm5lbDogWzIzNzcwMC4wOTg3ODJdICB3b3JrZXJfdGhyZWFkKzB4
NGQvMHgzODANCmtlcm5lbDogWzIzNzcwMC4wOTg3ODZdICA/IF9yYXdfc3Bpbl9sb2NrX2lycXNh
dmUrMHgyMy8weDUwDQprZXJuZWw6IFsyMzc3MDAuMDk4NzkxXSAgPyByZXNjdWVyX3RocmVhZCsw
eDNhMC8weDNhMA0Ka2VybmVsOiBbMjM3NzAwLjA5ODc5NF0gIGt0aHJlYWQrMHhlOS8weDExMA0K
a2VybmVsOiBbMjM3NzAwLjA5ODc5OF0gID8ga3RocmVhZF9jb21wbGV0ZV9hbmRfZXhpdCsweDIw
LzB4MjANCmtlcm5lbDogWzIzNzcwMC4wOTg4MDJdICByZXRfZnJvbV9mb3JrKzB4MjIvMHgzMA0K
a2VybmVsOiBbMjM3NzAwLjA5ODgxMV0gIDwvVEFTSz4NCg0KSXMgdGhlIHNhbWVfdGhyZWFkX2dy
b3VwKCkgY2hlY2sgcmVhbGx5IG5lZWRlZCBpbiB0aGlzIGNhc2U/IFRoZSB0aHJlYWQgZ3JvdXBz
IGFyZSBjZXJ0YWlubHkgZGlmZmVyZW504oCmIEFueSBzaWRlIGVmZmVjdHMgaWYgdGhpcyBjaGVj
ayBpcyBiZWluZyByZW1vdmVkPw0KDQpUaGFua3MuDQoNCu+BrglNaWNoYWVsDQo=

