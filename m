Return-Path: <io-uring+bounces-4445-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C8D29BC0AD
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 23:15:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 438492835AA
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 22:15:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E71641ABEDF;
	Mon,  4 Nov 2024 22:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="ibEnkzNN"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701F32AF12;
	Mon,  4 Nov 2024 22:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730758551; cv=fail; b=u7WziuqhJ2i/CFTbskQG0JYVnJ9hmA/EWsjYivjM1qfo36DSlsXkvfamTxFGCtYMY1yF+2P8bSegHNKN1uaODdT8TWfv7qkuTMhBeV+2KB0N7xT0/1fVU0sujd/gMXy7BWNOaRcEA5f6dOOM9ynkNOmvMJY+KCZULE1E5yQhs54=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730758551; c=relaxed/simple;
	bh=oAcjGyDwPu+buy+x/ckmABMtZkAPFYPG0OvG1Dd+K7I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ddU5fPeTJikBnFuGL5DxO13suEsKB4jvw33BZHPSchSIL7M+p1oVT6XY4URcnRSlt04A3LW70DaSMpaV5QMl7PucY88p1LQQiRw3wuxa6JFgKVasIbwNSCyyM79LkLA8DxDCHVP+GNRo+6gzzrVwzahW6h4Lf6ezlSgdo0uvbWg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=ibEnkzNN; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2046.outbound.protection.outlook.com [104.47.58.46]) by mx-outbound12-135.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 04 Nov 2024 22:15:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VjTzW7ZdtpQnreRnDSuznvddqN+QNn5LPzNxucDdB9B+wxGkSSP5UMhsQAUpNA+Hev6IiDG5G4X0lA/eBISMv/DSHI2qay5R2xl/tJXlJec0LBDbbV7DZ3N+qbO0vvjz0zNeuDw/MSvz+2m+Vi9DZP9A8ozRsHvRUWojg6EjtBY0XNj3wc/hhW82ZmD/bXqDFFXeK9gvEzxKy91tTAKNE2KW98Kgm4mEkYcdehWj48nmhz/opbQMNWZ0cvMpFWpsP0BdOFPx5LmfZUZou0kK7WxRzlJUsBd0a1u81FjEtx9gjYamB7cLmLmrrP3rxxMFfzP3p+hoEK/OK/foMDkqIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oAcjGyDwPu+buy+x/ckmABMtZkAPFYPG0OvG1Dd+K7I=;
 b=Ik1SUOn20C35A8j/yspuLsdRsBZLmaORkN6Po/i/eJw7s9dzV0IF6lLp5RfA8IQAYu2iY/dcvqA5qeIEteQw7avcxPzU8Lye66sM/Rw2ktwTm2aPHXA7N06/ODLlruh5Udki6/w0N+GUjXfU2i4i9XTpZFlZA5zc8y0yoMxfwGBteHjgjub3YzBCRABpdJwLbeWtnfk/kQf/94VwoALq+kuvY6ctvshvWeJiKaDKAZNDEKDpFpzmS0cQp2gPIqodpFzZomD5zRSf2EIOHnHNTqfIB05rwmV3SSV2W6W8hqGNVd9F/yXxnsStGsClFmLnfHQpl68g4era0d3/MribmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oAcjGyDwPu+buy+x/ckmABMtZkAPFYPG0OvG1Dd+K7I=;
 b=ibEnkzNNGlzYgVHKyqhKvkRKCeV8G6m3gjq7K41l1X07Kq3RxRen8msXTfBYonEXLWkQabV+tTSAvrfNn2cb8nd7vM5xnvTMs7DTRlzb0p8uZ+fARO4rMSskWuIjxnuRMrYJZawQfkSJbmfd/5vD+TsbK/RokmgEQ5KM0HwmXgI=
Received: from CH2PR19MB3864.namprd19.prod.outlook.com (2603:10b6:610:93::21)
 by DS7PR19MB5783.namprd19.prod.outlook.com (2603:10b6:8:78::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Mon, 4 Nov
 2024 22:15:39 +0000
Received: from CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::abe1:8b29:6aaa:8f03]) by CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::abe1:8b29:6aaa:8f03%3]) with mapi id 15.20.8114.028; Mon, 4 Nov 2024
 22:15:39 +0000
From: Bernd Schubert <bschubert@ddn.com>
To: Pavel Begunkov <asml.silence@gmail.com>, Miklos Szeredi
	<miklos@szeredi.hu>
CC: Jens Axboe <axboe@kernel.dk>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>, Joanne Koong <joannelkoong@gmail.com>, Amir
 Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH RFC v4 12/15] io_uring/cmd: let cmds to know about dying
 task
Thread-Topic: [PATCH RFC v4 12/15] io_uring/cmd: let cmds to know about dying
 task
Thread-Index: AQHbH18k5DcsQ3cILESkRv/PhXIC7rKmYjoAgAFtMIA=
Date: Mon, 4 Nov 2024 22:15:39 +0000
Message-ID: <473a3eb3-5472-4f1c-8709-f30ef3bee310@ddn.com>
References: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
 <20241016-fuse-uring-for-6-10-rfc4-v4-12-9739c753666e@ddn.com>
 <b4e388fe-4986-4ce7-b696-31f2d725cf1c@gmail.com>
In-Reply-To: <b4e388fe-4986-4ce7-b696-31f2d725cf1c@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH2PR19MB3864:EE_|DS7PR19MB5783:EE_
x-ms-office365-filtering-correlation-id: dcd20960-d6c8-4936-b422-08dcfd1e3701
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?ckNGa0xSMEFNMHBLbFlQN2oyZFRWQ2ZMb3lMcGVrcGhEN2Zmc253Z1lISERx?=
 =?utf-8?B?dmY5NGZiSWw0bW9MTDlKK3BwSmN2WXh4Lzg1c00zZDdTbE4zQzFPbU1JdlJz?=
 =?utf-8?B?bkx6RlAyTzM5ZndGaDFLeDZjUXhoUldKQ2hJT2NlMDZTNW5SRzBWNUc4d1A0?=
 =?utf-8?B?UDdUVU14WDhpMUMzczdEL0FTWnpZN1BQV0c4UTcyRFN1T2JlRHBkMngwTGkw?=
 =?utf-8?B?bCt5N3FsdzlNbkxZYjI0UXJWTXFNakVaaUpxa0JsVThPVmZpSVFZVEtVd2or?=
 =?utf-8?B?QzdwTkRKb2NjT2pHZG1waitJTTBER3I1R09JOUhwRFlJd0xqRmJxOFlUVzVU?=
 =?utf-8?B?Q2ZESWlSR2JTKzltdHVDVjNvZWQ1UVA2bCtyM1dkRTNKRlFsNE9XRWljNnNi?=
 =?utf-8?B?dTZlZHhYaWlDSStEV0VDQ3lvQldSZVV0dEZXMkw3NzdWVlU3QlVTaC9ZT1NP?=
 =?utf-8?B?VjZRSGtPblJvS2NIem9Rb1doejdlMTRxaTFFNWtTOWpQSW9QaVhiR0ZCbG5y?=
 =?utf-8?B?WFNoa0gwd0RCTFZPNEVkMjFlcWlzeS81QTFML20wTkxyRDRFcEMyL0lPL2cw?=
 =?utf-8?B?NiswRHlMcDQzdEN3WkhNM2xwWDV3SGpNWDNHWGxEbUJJT2RISCsyUUhUWkFs?=
 =?utf-8?B?TWxnenNFL0pUdnZnOVFxTUNXMld5cnd4ZFdMa3NqNW9zZVRKSEszTHpUVy9D?=
 =?utf-8?B?aXZzRWt2cmlBQUhqRkVGVWNXcXQ2cXg1d0pybVpxR3VkVVJjM3NjZzQvdnY5?=
 =?utf-8?B?T0lwNTFuczZRNEpLdHlyQ2lxREpGbGo4L1Y0elJlSWhJSE9RV1dhYkV5SXdQ?=
 =?utf-8?B?dzBHenJhQWRvU2oyQit0MHgxcHYrQWNnZWRjZjlMU09xVFZtUksyYjY5Qy9q?=
 =?utf-8?B?cHpiYmdqZStCVUF4UlgvV2lDZHVGcStFZ3NvNE1Vb2JnN0JHZ0N1YXk1T0xi?=
 =?utf-8?B?U0ZIaVZudkpLS2dGRXBZK0l1TjllN1FBWlN1b1RTS2grUS9KVE1HTUZPUm42?=
 =?utf-8?B?QndQbmlaVUUrQWc1Si9jRUJSY3ZodTZIZU9kRE42Z0hpaWxuOUZRRE80REVG?=
 =?utf-8?B?Y2kwWlNvMlk1MkZ0T3dBWWtqRmIwZFcwcytsMWVqOWtKNjBwRGQ5S012TVVZ?=
 =?utf-8?B?RGQxR3FjVlYwV29hVW0wRFJmMEt4b1FjUnVwMXJycVpkL0toZHJiN1FsM3lV?=
 =?utf-8?B?cGZlc0N0dmk5OGw5Z0lrMzFsSWNIV2RCRklCcEUrVUk3T0RUODdTTDd1U3J3?=
 =?utf-8?B?NFIvYTlpdUdTWGpUa3J1aGw4MHZmQTRQWUJ4cXpLaXByaTlUQ0JCcXJid29w?=
 =?utf-8?B?OGlsZ2JXVlYwVjdFY3gyUVpiUTNWVy8rWVdRRkcyelVJOW15dGFKaWhIOWJn?=
 =?utf-8?B?b0hYaXMwTUxaVktLZThWWkVRM2s4NDdyMkd0WUFtT2dWL2ZMRDdnY3poRmdH?=
 =?utf-8?B?TTNrMitpa3ZsTmg3UzQvcU9mem5YT3VYVStCMmVRSnU1cTl2NHVpL0c0c2Vo?=
 =?utf-8?B?aWFHT3h1SmlmVStTeG9BOHlhSTlwQnFScXNUM21YbDBLREhhR1JIWkM1TlNO?=
 =?utf-8?B?ckNTanlOTkkyTVpuVWhWQjFkQXBlWkp3QnpCT3hzQU5RS2wzM1RnZ0laVTFG?=
 =?utf-8?B?NldrbHB6cDNRQ0FwcDhLL3lkbXA1QzlUQUM0eEJRdWZMYjFIMDVpYXRSYkhJ?=
 =?utf-8?B?bkZlVzJUSEsxeGtOMXBCV2xpaXdEcHYxZldnQWNMS1BWNXhqcUgzRmdBTDBq?=
 =?utf-8?B?aWQ0a0RkS1EvSXhOWHV3b1Q3N3pZcHNVamhQNzdKdk1hdHlCaC8xWWJHWFdF?=
 =?utf-8?B?Vis4UURNSW9CaHczQU5zT3JFWm91cW42R1dtdEMwWFp3NnZ0cElIUG4rRGFz?=
 =?utf-8?Q?pyN/9mABrrVSm?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR19MB3864.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SlBxTk5jWC9hODJxQXdRL1RFWStMdS8yNDIxaGpSdGdsMFYvMFJWTnBqSTJx?=
 =?utf-8?B?Q2J3QmdkRjNOODVJaEhKemc1ZTBzd2d5TnZ4ZUtCYUxJZ2tMQm9FeHArenZr?=
 =?utf-8?B?eHltbzYxMDBXZXNkU2VMYjFCelBKanNtalB2NEthVGdLaTJHdit0VHNGSk9m?=
 =?utf-8?B?TTJ2QzNCRit5ekV0N3VlOVVGbDR5UVRWbWxXV2NPTlJpQ1VWSGxYcmpUMFFH?=
 =?utf-8?B?aEx0WGY2a2wrTnJiR1AwTHVONUFFSXJTMWQ0eDY4bTlybGJxUlhLSnkwQ0lC?=
 =?utf-8?B?eGYyM0txRTB5djQvYWs1NWVuMERKblZjOFVZa0tmWVFyTWNUU2FEcUVuMGxV?=
 =?utf-8?B?akhxaXdleXhkZzVSb0t3aGRiM1hVSFVjUDVtOFFhYVRkeXcyVDNMZEJsdlBW?=
 =?utf-8?B?UnR2Wi9NZFAvdU1rM2hKVFQwdmxQOFJ0ZDU5NFF3czZxM1dJWEJ3QWJCTmZo?=
 =?utf-8?B?RnF6bXlDeEZ5c3JyOWJHeFkzOVoyNGtrNytnWmU2ZUY3MUZUdXB6OUVXWGVB?=
 =?utf-8?B?U2VhNldvbU1xQSszSmZDbThJZy92andxbHpDNVdiVzV1d3NKNE9aaE5MNUhp?=
 =?utf-8?B?UFR3elJhK0hFeXVqUnpRNFdMZGlUc2hvdGh2WXJnb2NVZ1BjdEpDcWRjdERV?=
 =?utf-8?B?WHovK3p6dmFjTkVncE95Q00vdFl0U1lPOW5BaDdXRlhjNVZwQ3ZRZjNuUGFE?=
 =?utf-8?B?anlseDhkLzhTWnNxN1JIYzJ2OXc4Qk9aWHVMSlFNcEZLajdZVVZHT2h1Yktu?=
 =?utf-8?B?UXUzWFQvbS9NM2FCNkRQQVppbnBjb3ZKUnNHam1YYTM1bVdWVDQzRkZrdThv?=
 =?utf-8?B?QXp0dTRsRlVYdTFuaW5ZZTlRVkFDd3hWNG1hNGZoY1NWNXFDd2FhVmU4ZGFD?=
 =?utf-8?B?cVN3VjdpWTh6VXFGbWtBalhoaTFrdnpHcDdPbDRrMmJ0YVRqc2FMcjFwV3pT?=
 =?utf-8?B?c1RKYk4vY2JuL1lDeEpDdnZBaGNUS0pTNUhhTnlIRVJPY0ZycDNPVlVnNDB1?=
 =?utf-8?B?Vk1SZ25zZWNTYWhtU3JIa3VKS3dNL21xbE9laFJ1cm11N0w5NXdOTzJHRGxq?=
 =?utf-8?B?Q3FLa3MyVlZKc2p0Ky9McGRwZ0o3K1R5dWJEelQ1TmJIbHNvTWZ1MnNVTnR5?=
 =?utf-8?B?c0V0ZUJnaHp4M0U1VXpCMFdySlNIVGpWbnFYbGpZbjRnck1LM0l1NGZ3Mlhw?=
 =?utf-8?B?NUQxbzY3QUxhUVZrblNnUitDaTZoeGljR3M0SHYwaUplTHR4TWZ5K1pZK05P?=
 =?utf-8?B?anJCallCS3UweFErUUhEaHFPV3BCNld4cDlJRWUvcGVnMy9lSDRaQjJZcGt3?=
 =?utf-8?B?MXJtZHBML0wvRng3VmNPOG1nQWw2cVlucnNGKzdNQjlZM0Y4Z3NiRkowVG5v?=
 =?utf-8?B?MFR5eXZ3NGZCVnZ3cDZJYjNndVlhS2NtaVZiOFgxeVBUME5KSUJBL2o2aUdl?=
 =?utf-8?B?N1JSR2lDZjJOMTdZNEJzdFRYVG96ajgxZmZRaG1VNXhBcG5PQXRPam9mNEs2?=
 =?utf-8?B?WW5rNEtLVkhycm9rRjd2WVZmUzBxeW5oREo1M1hNaklFY0VpTFFwM0tmZlJL?=
 =?utf-8?B?UWFOMlpZK1lYOGhnSitrZzd5UDdtNWlCYVphc21URVJ6STFmZVlBbUR2UDRm?=
 =?utf-8?B?bHZMdUZHNnloOWxMQnNqbUQxaWxRdGI4bkpnVnJWNmRhdlNOTURYaUt4dGcv?=
 =?utf-8?B?NjczYTRQUjVGQ08rWGluWWt0d1psSU9Ga1doZlc4alJoUjU1RlAwdTZ5M0RM?=
 =?utf-8?B?MkhydmdPMzA2cDRZbnkyV0krRU5OSXVnZWFvaGtjQXV1bmM3VFdCRE9XV09V?=
 =?utf-8?B?OGd4eG5HNVFKM3JLVEwvc0pCbkdBelFKaTlPRllrMTVyeFBCVVpNZVpqcG1u?=
 =?utf-8?B?NnRFcWVEOHRjbWRSUVYxaFpXd3ZVQnlqWm5XVUh1WW1Tc2V2THUvVU1RUXVG?=
 =?utf-8?B?T0p6bDZ1UnN2OFp6WWlsWHM3emlWbE9jTDJwTzN3eGl2Njg3MmpPYjI4ait4?=
 =?utf-8?B?Y2xUQmxkRnQ3b1FsYTVJaldJSXBCYnZtRFBHR0F0d296eVdlMHlBbDFmOGpr?=
 =?utf-8?B?a3BEb0tuZlVFdzU2WksrYXNjZ0pOaFdUVGdHbXRIMUhyTTNPd3N3MW54eWw2?=
 =?utf-8?B?eHg0eVQwTmwyWUlJNG9EcUx6VDVBbEgvQ0YyUytPbUpOWnFSZXRFamlJUGZH?=
 =?utf-8?Q?58ROZSd73Z46hPNHMstZVUo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BA0753BC5171254388ECF0C62081C1B2@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	76nCY/YDBCHKLciDyUfM3pwSWhTjmXuo29HLEDXp3nFJ84f20Kxx1uMc2cS8n3C8jCJ/5CJ8TEHNeZctNlckySwnlbGvcgppRKzkrbG6KlAJXPZyoMGDSouUyopf2TUdYQAByXHtUF9d1No0aodQTcYhllTMaaw8DQUpvAJ2tu3G2kU19EptYmLvEDLKA+A+ypqE8jQ+Ua9juzYMer4xicm3Da25C63YKPhlQI2+7wJJolPObLkgwU41WBbB6lDAXjsuW+xZSqcxv1X52v+3jlMdCsrMEHjiIr0/GKr5oir9otOcEVqj0dvAupsrrNsCLelIz4ZWTqjjkdmwN0Wl9vrLerdKhGrtOTczK88i7zE/mcBrbRMd8GdsNP7r6oL51OREeKM5lnG3SLC8d6sRzeY9GpZFESFASfyUScezUEdM9TeROn+TZzv+0ATtRlRAE3O+06izlkbKOD+vigmKla5iu2gB2sZpBNK/lTu/Pu3KI+J2al0MblLD5aEyJeVQyFsoZ5rtQHCkv1NMHeKCsKNm+/XHRLSevoo9GbDxeGdfWR+/FHTTP0KrxYRgd/0+gxaz+qd9ebaL/PP++9QBpfrkON/GJq457LEqQmrnYZCiuaBcSqUBO6mbTgnSYyJFNb39HffWRV/s8OMaCMK5fA==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR19MB3864.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcd20960-d6c8-4936-b422-08dcfd1e3701
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2024 22:15:39.3229
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oG6aG56kqqa+H1RIX78P5lRm68caaVUPUYyJGaEqPLihN9PUvlZA8mRsUYF7NVyprr4liKdljrtZWrD6089Q9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR19MB5783
X-BESS-ID: 1730758544-103207-19346-26001-1
X-BESS-VER: 2019.1_20241018.1852
X-BESS-Apparent-Source-IP: 104.47.58.46
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVkYWFqZAVgZQMNHAIMnAwNw42S
	jNwDLNMskoOc3ENNnALMXSyNDU1MBcqTYWADuXW01BAAAA
X-BESS-Outbound-Spam-Score: 0.40
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260205 [from 
	cloudscan16-58.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.40 BSF_SC0_SA085b         META: Custom Rule SA085b 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.40 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_SC0_SA085b, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

T24gMTEvNC8yNCAwMToyOCwgUGF2ZWwgQmVndW5rb3Ygd3JvdGU6DQo+IE9uIDEwLzE2LzI0IDAx
OjA1LCBCZXJuZCBTY2h1YmVydCB3cm90ZToNCj4+IEZyb206IFBhdmVsIEJlZ3Vua292IDxhc21s
LnNpbGVuY2VAZ21haWwuY29tPg0KPj4NCj4+IFdoZW4gdGhlIHRha3MgdGhhdCBzdWJtaXR0ZWQg
YSByZXF1ZXN0IGlzIGR5aW5nLCBhIHRhc2sgd29yayBmb3IgdGhhdA0KPj4gcmVxdWVzdCBtaWdo
dCBnZXQgcnVuIGJ5IGEga2VybmVsIHRocmVhZCBvciBldmVuIHdvcnNlIGJ5IGEgaGFsZg0KPj4g
ZGlzbWFudGxlZCB0YXNrLiBXZSBjYW4ndCBqdXN0IGNhbmNlbCB0aGUgdGFzayB3b3JrIHdpdGhv
dXQgcnVubmluZyB0aGUNCj4+IGNhbGxiYWNrIGFzIHRoZSBjbWQgbWlnaHQgbmVlZCB0byBkbyBz
b21lIGNsZWFuIHVwLCBzbyBwYXNzIGEgZmxhZw0KPj4gaW5zdGVhZC4gSWYgc2V0LCBpdCdzIG5v
dCBzYWZlIHRvIGFjY2VzcyBhbnkgdGFzayByZXNvdXJjZXMgYW5kIHRoZQ0KPj4gY2FsbGJhY2sg
aXMgZXhwZWN0ZWQgdG8gY2FuY2VsIHRoZSBjbWQgQVNBUC4NCj4+DQo+PiBTaWduZWQtb2ZmLWJ5
OiBQYXZlbCBCZWd1bmtvdiA8YXNtbC5zaWxlbmNlQGdtYWlsLmNvbT4NCj4+IC0tLQ0KPj4gwqAg
aW5jbHVkZS9saW51eC9pb191cmluZ190eXBlcy5oIHwgMSArDQo+PiDCoCBpb191cmluZy91cmlu
Z19jbWQuY8KgwqDCoMKgwqDCoMKgwqDCoMKgIHwgNiArKysrKy0NCj4+IMKgIDIgZmlsZXMgY2hh
bmdlZCwgNiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+Pg0KPj4gZGlmZiAtLWdpdCBh
L2luY2x1ZGUvbGludXgvaW9fdXJpbmdfdHlwZXMuaA0KPj4gYi9pbmNsdWRlL2xpbnV4L2lvX3Vy
aW5nX3R5cGVzLmgNCj4+IGluZGV4DQo+PiA3YWJkYzA5MjcxMjQ1ZmY3ZGUzZmI5YTkwNWNhNzhi
NzU2MWUzN2ViLi44NjlhODFjNjNlNDk3MDU3NjE1NTA0M2ZjZTdmZTY1NjI5M2Q3ZjU4IDEwMDY0
NA0KPj4gLS0tIGEvaW5jbHVkZS9saW51eC9pb191cmluZ190eXBlcy5oDQo+PiArKysgYi9pbmNs
dWRlL2xpbnV4L2lvX3VyaW5nX3R5cGVzLmgNCj4+IEBAIC0zNyw2ICszNyw3IEBAIGVudW0gaW9f
dXJpbmdfY21kX2ZsYWdzIHsNCj4+IMKgwqDCoMKgwqAgLyogc2V0IHdoZW4gdXJpbmcgd2FudHMg
dG8gY2FuY2VsIGEgcHJldmlvdXNseSBpc3N1ZWQgY29tbWFuZCAqLw0KPj4gwqDCoMKgwqDCoCBJ
T19VUklOR19GX0NBTkNFTMKgwqDCoMKgwqDCoMKgID0gKDEgPDwgMTEpLA0KPj4gwqDCoMKgwqDC
oCBJT19VUklOR19GX0NPTVBBVMKgwqDCoMKgwqDCoMKgID0gKDEgPDwgMTIpLA0KPj4gK8KgwqDC
oCBJT19VUklOR19GX1RBU0tfREVBRMKgwqDCoMKgwqDCoMKgID0gKDEgPDwgMTMpLA0KPj4gwqAg
fTsNCj4+IMKgIMKgIHN0cnVjdCBpb193cV93b3JrX25vZGUgew0KPj4gZGlmZiAtLWdpdCBhL2lv
X3VyaW5nL3VyaW5nX2NtZC5jIGIvaW9fdXJpbmcvdXJpbmdfY21kLmMNCj4+IGluZGV4DQo+PiAy
MWFjNWZiMmQ1ZjA4N2UxMTc0ZDVjOTQ4MTVkNTgwOTcyZGI2ZTNmLi44MmM2MDAxY2MwNjk2YmJj
YmViYjkyMTUzZTE0NjFmMmE5YWVlYmMzIDEwMDY0NA0KPj4gLS0tIGEvaW9fdXJpbmcvdXJpbmdf
Y21kLmMNCj4+ICsrKyBiL2lvX3VyaW5nL3VyaW5nX2NtZC5jDQo+PiBAQCAtMTE5LDkgKzExOSwx
MyBAQCBFWFBPUlRfU1lNQk9MX0dQTChpb191cmluZ19jbWRfbWFya19jYW5jZWxhYmxlKTsNCj4+
IMKgIHN0YXRpYyB2b2lkIGlvX3VyaW5nX2NtZF93b3JrKHN0cnVjdCBpb19raW9jYiAqcmVxLCBz
dHJ1Y3QNCj4+IGlvX3R3X3N0YXRlICp0cykNCj4+IMKgIHsNCj4+IMKgwqDCoMKgwqAgc3RydWN0
IGlvX3VyaW5nX2NtZCAqaW91Y21kID0gaW9fa2lvY2JfdG9fY21kKHJlcSwgc3RydWN0DQo+PiBp
b191cmluZ19jbWQpOw0KPj4gK8KgwqDCoCB1bnNpZ25lZCBpbnQgZmxhZ3MgPSBJT19VUklOR19G
X0NPTVBMRVRFX0RFRkVSOw0KPj4gKw0KPj4gK8KgwqDCoCBpZiAocmVxLT50YXNrICE9IGN1cnJl
bnQpDQo+PiArwqDCoMKgwqDCoMKgwqAgZmxhZ3MgfD0gSU9fVVJJTkdfRl9UQVNLX0RFQUQ7DQo+
IA0KPiBCZXJuZCwgcGxlYXNlIGRvbid0IGNoYW5nZSBwYXRjaGVzIHVuZGVyIG15IG5hbWUgd2l0
aG91dCBhbnkNCj4gbm90aWNlLiBUaGlzIGNoZWNrIGlzIHdyb25nLCBqdXN0IHN0aWNrIHRvIHRo
ZSBvcmlnaW5hbA0KPiANCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvaW8tdXJpbmcvZDI1Mjhh
MWMtM2Q3Yy00MTI0LTk1M2MtMDJlOGU0MTU1MjllQGdtYWlsLmNvbS8NCj4gDQo+IEluIGdlbmVy
YWwgaWYgeW91IG5lZWQgdG8gY2hhbmdlIHNvbWV0aGluZywgZWl0aGVyIHN0aWNrIHlvdXINCj4g
bmFtZSwgc28gdGhhdCBJIGtub3cgaXQgbWlnaHQgYmUgYSBkZXJpdmF0aXZlLCBvciByZWZsZWN0
IGl0IGluDQo+IHRoZSBjb21taXQgbWVzc2FnZSwgZS5nLg0KPiANCj4gU2lnbmVkLW9mZi1ieTog
aW5pdGlhbCBhdXRob3INCj4gW1BlcnNvbiAyOiBjaGFuZ2VkIHRoaXMgYW5kIHRoYXRdDQo+IFNp
Z25lZC1vZmYtYnk6IHBlcnNvbiAyDQoNCk9oIHNvcnJ5LCBmb3Igc3VyZS4gSSB0b3RhbGx5IGZv
cmdvdCB0byB1cGRhdGUgdGhlIGNvbW1pdCBtZXNzYWdlLg0KDQpTb21laG93IHRoZSBpbml0aWFs
IHZlcnNpb24gZGlkbid0IHRyaWdnZXIuIEkgbmVlZCB0byBkb3VibGUgY2hlY2sgdG8NCnNlZSBp
ZiB0aGVyZSB3YXNuJ3QgYSB0ZXN0aW5nIGlzc3VlIG9uIG15IHNpZGUgLSBnb2luZyB0byBjaGVj
ayB0b21vcnJvdy4NCg0KDQo+IA0KPiBBbHNvLCBhIHF1aWNrIG5vdGUgdGhhdCBidHJmcyBhbHNv
IG5lZWQgdGhlIHBhdGNoLCBzbyBpdCdsbCBsaWtlbHkNCj4gZ2V0IHF1ZXVlZCB2aWEgZWl0aGVy
IGlvX3VyaW5nIG9yIGJ0cmZzIHRyZWVzIGZvciBuZXh0Lg0KDQpUaGFua3MsIGdvb2QgdG8ga25v
dywgb25lIHBhdGNoIGxlc3MgdG8gY2FycnkgOikNCg0KDQoNClRoYW5rcywNCkJlcm5kDQo=

