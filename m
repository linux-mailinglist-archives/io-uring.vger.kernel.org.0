Return-Path: <io-uring+bounces-1826-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CB168BF950
	for <lists+io-uring@lfdr.de>; Wed,  8 May 2024 11:11:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2A7351F228CF
	for <lists+io-uring@lfdr.de>; Wed,  8 May 2024 09:11:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8CD17440B;
	Wed,  8 May 2024 09:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bX0bqgBf"
X-Original-To: io-uring@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2082.outbound.protection.outlook.com [40.107.220.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 038585467A;
	Wed,  8 May 2024 09:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715159452; cv=fail; b=C3Pp3MJgaZaOL6rk96IF5pH/iNSNOV0Tp5y9j8w+Giohe8yJ3aP7dGeEMKZ2dwrJzqYiwmRPYFJpCkMrWTe2ymSGXtdupXCUShc20KOur2STFZaBeU5OIiX0jMXwQe2iokthGf1z3puwDuehtU5MxBRJ5q6VcPYkqgdcyYckBfA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715159452; c=relaxed/simple;
	bh=02WweL0DaLOS4y2Bo4Q3EZ8A/11Dlp5zqGur+e0Ashs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kvM8sCGoYLHBW6KR1sgXYJIJp/uXK82Tz5BNQanlnNgQu+hPZY/7UDxvK1wuc6JypMKG7gX6eSAaGpgKDYTAKiDxBHuP/m+Y4qvmOpKkJk7h7fb6FPG234c8pRRJbW+rDUbPKIAjGDHzI/oD3BdTWdy7bUYUCbEMObjPlxgkbag=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bX0bqgBf; arc=fail smtp.client-ip=40.107.220.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=My5qhxAmzVmdgBh79qKVHVfMdJznU7H4jbVf33VvRviwNZasSFZ4kljcBllCYda8j8eQ3X7onCR2xjKB7iJA33MS0ZSFXHwt05q8XUJBF5Q4xXPWF1YzLzYhcsqDbF+2PjOLznUxwDr1R9ZLCDb5ufh7PEq2G91Xqgw/ya8hSMnsa7yQpRiVboQnMQPwHR9d6ngd4HfQLhuzXZv1y2jTQl3b2Gj9cZBhUk/7esOM17nqYXIqoWzzIFp8mjfCWomDmGk5owr+9fokbwdUhNNnnctJA2YFYL3um+vw8toxL2C+LsgAXEIOlORtTRp9t7fOgGx0OaQSN/EkTBGO2LS7Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UU6nmZFAcOIP94F1tbjaYt199MHcED5hdIHfXhKNcMQ=;
 b=IJL8VItat2AzvOlXG0PxNdGucQlU6vpCLAlEoVuHE+Xsi5UDasZ4yk9L2TklnneB4JKgfG70HHL7e9mHcYx8uCcN6WfM5s0JE7KrrSl4vGhbo+CrVU09m5qpBadLGRjP62ae2tE+IXVVJ0TI0ezuupChsrQP39LY9GOk+ZCkzbfMnSf3xsyl8gKXnIXrMJSCLnDg4+W9lvpGJaT+fbnizjPhT6BA4zIHwRQCnnYwkprlduT7OAIYjpTqX0PDngDMp/KnG5RiSvrmBEWsDX0ZKNWBoudCggqoZY7654/3YsndKr0Plis5GaT1ylWkwuTPWbqVyNRR4YWMuBy8K4BWUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UU6nmZFAcOIP94F1tbjaYt199MHcED5hdIHfXhKNcMQ=;
 b=bX0bqgBfVTGRRlZ2VTKzDrxJC7OoAjIDqc8KYgxNblspLyj8fu/q3jsTfSyqnqZ/9AJnyVuxbtucp2vlyns8Ek+skn4KUnYGfKBM3g1m8/2ZatadvPvYYXqrFCUxKWK5nK2h7LWdee0aVDRP45bCkw11P84lOTiAsnMmUBAQ6J4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by SJ2PR12MB7823.namprd12.prod.outlook.com (2603:10b6:a03:4c9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.43; Wed, 8 May
 2024 09:10:46 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::46fb:96f2:7667:7ca5]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::46fb:96f2:7667:7ca5%2]) with mapi id 15.20.7544.041; Wed, 8 May 2024
 09:10:46 +0000
Message-ID: <dab85d87-5b4d-400d-bf83-40008f053761@amd.com>
Date: Wed, 8 May 2024 11:10:38 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [Linaro-mm-sig] Re: [PATCH] epoll: try to be a _bit_ better about
 file lifetimes
To: Christian Brauner <brauner@kernel.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <ckoenig.leichtzumerken@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
 Al Viro <viro@zeniv.linux.org.uk>, keescook@chromium.org, axboe@kernel.dk,
 dri-devel@lists.freedesktop.org, io-uring@vger.kernel.org, jack@suse.cz,
 laura@labbott.name, linaro-mm-sig@lists.linaro.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-media@vger.kernel.org, minhquangbui99@gmail.com,
 sumit.semwal@linaro.org,
 syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com
References: <20240503211129.679762-2-torvalds@linux-foundation.org>
 <20240503212428.GY2118490@ZenIV>
 <CAHk-=wjpsTEkHgo1uev3xGJ2bQXYShaRf3GPEqDWNgUuKx0JFw@mail.gmail.com>
 <20240504-wohngebiet-restwert-6c3c94fddbdd@brauner>
 <CAHk-=wj_Fu1FkMFrjivQ=MGkwkKXZBuh0f4BEhcZHD5WCvHesw@mail.gmail.com>
 <CAHk-=wj6XL9MGCd_nUzRj6SaKeN0TsyTTZDFpGdW34R+zMZaSg@mail.gmail.com>
 <b1728d20-047c-4e28-8458-bf3206a1c97c@gmail.com>
 <ZjoKX4nmrRdevyxm@phenom.ffwll.local>
 <CAHk-=wgh5S-7sCCqXBxGcXHZDhe4U8cuaXpVTjtXLej2si2f3g@mail.gmail.com>
 <d68417df-1493-421a-8558-879abe36d6fa@gmail.com>
 <20240508-unwiederholbar-abmarsch-1813370ad633@brauner>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20240508-unwiederholbar-abmarsch-1813370ad633@brauner>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0291.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e7::17) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|SJ2PR12MB7823:EE_
X-MS-Office365-Filtering-Correlation-Id: 838e5af2-23e5-4d11-bab1-08dc6f3ebeca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|7416005|366007|376005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NjZrWkpCL0c1YXBYekpwUkdRRGlkWHRVSFJTMklHVTFJd1piejZZQVVhVlBB?=
 =?utf-8?B?Z1loSXduR1V1R1pXNWJXb3VFdnlnWDZaOGxsUzltWlZyMW5NUEFzWUlIT29a?=
 =?utf-8?B?ekFPa0w4T1hYaURXaFZLd2FUK0lQdm9OU2V6SS8rWVVXQ0hYc2VVNnNwdTBR?=
 =?utf-8?B?bDV3ZUErN2tJWlNkLzNpZC90blhoSmg2Y2xSODdEOWllNWxTaXo2ejU4S3p3?=
 =?utf-8?B?MzNOQU1ISUJFbHBmbjE5UUgzWGswa1EzaEQwWmdqOEIydG9KdGdxWVZ5dW1S?=
 =?utf-8?B?WlMreWUzMzZteEVDbTBZWjI2NGo2RWY5VkFJalg4SU93OGwwL1ZZZWFlN2l0?=
 =?utf-8?B?dDJuRE5nYUZVazErc2g2K3FrMnNWTmg1ZWltd0JyWWtObzZ2dXhObHVoK2sz?=
 =?utf-8?B?YllPbkhURW83bldPWFExVFVzV2lHQ0kycmhvWkZDNDBWSmNZNlpNOWdzZ2ND?=
 =?utf-8?B?YmljeDV2NGpPS3YrMk5LTU1rVUcxUTNScVppRTAzZGxFdzBlRnl1VkptVUo0?=
 =?utf-8?B?Q3BZUjhJT1FKYW1EbkhrbU0zRFhnWm85TVd3aWUvT0xqM21QNmpTRkRZT1dV?=
 =?utf-8?B?QmY4WVhNcHZYV2xWUWhEVHJlKzBMWHV0TFZ0cnJMeUpRdndtNWVBMDdaRHB1?=
 =?utf-8?B?RHVHM2NqVDlSU3ozdTdKak5KV3JlM05lbVNMNm1UTnd6SC8zNmdBWnpBV21n?=
 =?utf-8?B?L2ZMcVpBMTVyZGg2SlJhNUs5bm40bEZYaU1DZm1ub1NTODVyOVk4dFJaZzU3?=
 =?utf-8?B?Nk1MMW8xS1dBa3AxcGpSZlMrZE1FTTN4ays1TWJXd0k1cThwVDhKRVhPNXVs?=
 =?utf-8?B?MmZqcy9KSWxkSGd0UU5yREU3bzZFdW14ZUNEUTNDT3JHbWF2Um42djc1MTN1?=
 =?utf-8?B?YXRvNTVzSW5lSmpLTVdaRnlxeW5EN1d3REwxdlUrUFdkQWdDQmlKZHI2ekFQ?=
 =?utf-8?B?SVdqUVQybzRaU0Y0UCtmdFc0dXVIU3hxeGJFN3ZwTDhlT0Joc1RxczNhKzl5?=
 =?utf-8?B?eU1lWHQraGp3QmJjQ1lTNXFCQnoyZGE2VE1CV3RWODJxSytWVGN1QzdYemhI?=
 =?utf-8?B?UGM1ZllvMDFzUGhVcnNQR0lyNVpSaFZ6aDFmbmVkTnY3RWVwc2MwZC8vUFFL?=
 =?utf-8?B?eEJxNWNVWDBxM3lOblQyMUJzSzBqODRkWkhnejV6TlVkdGgzMUhxdXA2V054?=
 =?utf-8?B?VytvWHh3NmtVVEw3eS81RFhZS2tzRzExWEM1bWJpbHNySklRYUhaaDJQOWVt?=
 =?utf-8?B?R09MN0dXMlVDQ0pxSDh2amVBL0lSTVdvaENLbXFmVjNLbnhGeGhjeWJlaHo3?=
 =?utf-8?B?NzFFckVIR1huWFAwblZmMjhTRitKL2czUHVoSytzOHUrNk9xUDlpMnlsZDhr?=
 =?utf-8?B?UmhPd2ZHQUtzVVBWVlZ3RzFlQ2xVNWlaaS9uVkt1eTdpN2lnamtuMW1YWEZ4?=
 =?utf-8?B?cXpCd2xWVnBrZWNOTDNQWFJOZ1NhOXdqVi83MWVtQUx2WEdzWDRXSVlJblFI?=
 =?utf-8?B?ZHJQbk5HcVpaQXBWZnJSVlhvVFMvVTBjdDV5RHVBMnBYYXA5OXB4RkNndDQ5?=
 =?utf-8?B?VGhndGxpWCtXS01DMU9kbFZiTFNPYXIxemlyaEN1bHNsei8zZkh0Qy8xaVor?=
 =?utf-8?B?TEJRWlRUNk5nMnRpa2V5MHdwcWtjdGVCMXZFZXpJVko4UVNXSzNzdzdWSGxV?=
 =?utf-8?B?Rk5WOGVxYUhmbHVSYU9CUDlhNWVEMEV5UklRMlpJaGo4cm1sejVMM3V3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bVJ1Skt5b3UxU0dsQUZqam5GRC9FWnEvODUxWGR6bFhGMk1pbE5QZkYyb0hY?=
 =?utf-8?B?TmVhRExrMkpIbG1hT2NaWFNsREJJN25HZnJYZWVTNUNlbFVNbkVCNkpEY0wy?=
 =?utf-8?B?YUFxWjc1aUQ1cisxUmxZWHhtTjJjUkFLWVhScFE2NWllOFd5S0tkYUV6TVph?=
 =?utf-8?B?MUlxKzZGUU5KblJrUk1PRVRNMTJ5Z3hUWVA3M1JQcnZZemNWVnp1NmwrNkxC?=
 =?utf-8?B?N1JDZTRzZTdJRFBEYjFObHlhcy95R3gvZWZPMjJ5bGgwSVUxTmk0T0pmaFB1?=
 =?utf-8?B?Y0pXZ1J4TFlnVGRBaVg0RkNGRzhmWHFOS3B0bzM5ekdUdU1UQWlwODlBeFhx?=
 =?utf-8?B?RXhCTXRybHQ4SXBORG11WC9vaW5qYXY3L2gyTVo3V3A4bGdUSTZXTy9OQ1d3?=
 =?utf-8?B?TjhRWDNtREgraTdaNC9SNHZ5VUY4NFk0eEZ6N2J5c0FqdHdmVXMxMjVkbW41?=
 =?utf-8?B?SGg0TlpscUtuMHdPSFU2RzdVUUZkYW5RT29iV0FldlZCYmdnZGRjODhiUDdF?=
 =?utf-8?B?YXFxY2l2RzFkWjJidkxZZXNOYmlLYUJ1ODFrdE0rOEVzdE0vbWtRVVlqb0Fr?=
 =?utf-8?B?M0RIa0crelVsVzdyaWtzdWh4Q1BON1VjZzRlU0ZhOEpueVlFd2FIck1GWUNG?=
 =?utf-8?B?WitFalhjc01YVDB4UWVuTC9TQnZTSVg0eWhKbmJ6TTVtYVhpb2t2SXdoWURu?=
 =?utf-8?B?dXFzREp2UnNNWFRsUko4RGE1LzA5TFkxUTRrVndNNzA5bDI0VEhDN2JhM0d1?=
 =?utf-8?B?TlQ0MXdYL0ZtZHhNS0pqRTJJaXI3S1F4eUhuUUJuZW1sMzA3U2tlTGRmbjM5?=
 =?utf-8?B?NXUvelBpWlYzOFAvZVR2MGZKR25vMzJ5emduU2xPdWZ1Q2NpLzg2SllEcnc0?=
 =?utf-8?B?V05WKzJ0S1pubWdQSi9UNHhYR3RrSGR4THZyRGhEM2psVWViWEFoTlp5UkVC?=
 =?utf-8?B?UkJESUZsOExQS1NZdUtDZ3J5U1A0WEtib0JCK1Y5cTVFYzNYVjZienpINmhM?=
 =?utf-8?B?NWtTTXFxUW1STFFMMXFDcE9YaXF4bjVFUXNBZ2xlL3hvSlZDdURzZU0zekVJ?=
 =?utf-8?B?UkN2dEx5VFc5YTRQU0cwQ0M1VlcvcmNYUFNnTmJpQy8rcktiOW1lZ1czdzZD?=
 =?utf-8?B?ZnpaZERHVDI3bTF1ajBzdXZ6R3FUL1gzNzNhRzhQOTdtSHJWaGpMM3RJOTNR?=
 =?utf-8?B?NCtIalFBclp3Nmh1NXltT2ZjbkQ5R2hrSmYrYkVZd3FXeDdyOHB3TnltUzFm?=
 =?utf-8?B?bWQ2UTZJR1hQT21nU3JHTXZaWERXME04KzRMU0lIU3VxUjhMeEdNWjFsMnNJ?=
 =?utf-8?B?WUphSzFlR0haS09PT3RQRUtHR2FTZXlCMW1mVmVDZGYybFowVEJUOU1VSDlj?=
 =?utf-8?B?MUo4eGFqOEZwZXdadC91SGNVKzBnQ3dtWHdENkR3eFhTQkVKYkZ6YWRaVXk4?=
 =?utf-8?B?R2lxSDlURnZLL29SeUlwTjJ2VjBNU2hSb2NNNTlaemNFdFp4MVd5TC9wdS9B?=
 =?utf-8?B?bTlCVnROV3RFQUxKZStqNG81TEZrNWxrYVVjYTFCNjNsUlFLb0xyUUl4R3Ru?=
 =?utf-8?B?V2Z0MFRDUVZCaTFVSUg5Z1hqczRLcnhBV2xIODdaWW12enJtaWR6dVAraU1D?=
 =?utf-8?B?NU1OUDFmNkx6bk00b0EzUmJDelFKOE9PeW1XN2dWdmF3MXNDNkkvL2U0eCtl?=
 =?utf-8?B?TVVmOGZKaEtrY2FKSjFiSFVCS3B1RER5Z05CR1djRVdyY2Y2eFYxNHE3ckpm?=
 =?utf-8?B?Sndiek01bVladDY1WVoweThqcUpqUDZ2UjIxKzdnTzFvTE8xMjZKV3l2VzZo?=
 =?utf-8?B?dUpzNDZyMnAxVGt6N21jRHlrY3BleCtTSXVsL3pubkZPaFBlbzJaM0lwbnlN?=
 =?utf-8?B?M3RFcFlSVmd0ZVQvQTNVV3R5c2k1a2xIamdxNHQ3NlJuS1VLakJIbXl5UVpa?=
 =?utf-8?B?Qko3TnIzN0s5TWpjSkRLSWFic0V3SGt6VWVnZjBpc1pxbEwwT0dkMXZmQnE3?=
 =?utf-8?B?cUxXUXgzRXNib05HL0VGekt0MVBkZGN4dmRaeDdCVkhxc3IvUlFNZmN6WTRT?=
 =?utf-8?B?Q0djRFdVS1dhU3VwSE51dEFWTzNySUFsMmhrUmxodVEzT1hWVG8zb1l0YUJZ?=
 =?utf-8?Q?muW53MlUTzB9DpdAdoXPoFCDA?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 838e5af2-23e5-4d11-bab1-08dc6f3ebeca
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2024 09:10:46.0356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vovw0iRn1C7grfMVmfzmyZUXc6aEup11el3Tw+QGk91mpYGH+aCDh8Gq4Rbc1ksJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7823

Am 08.05.24 um 10:23 schrieb Christian Brauner:
> On Tue, May 07, 2024 at 07:45:02PM +0200, Christian König wrote:
>> Am 07.05.24 um 18:46 schrieb Linus Torvalds:
>>> On Tue, 7 May 2024 at 04:03, Daniel Vetter <daniel@ffwll.ch> wrote:
>>>> It's really annoying that on some distros/builds we don't have that, and
>>>> for gpu driver stack reasons we _really_ need to know whether a fd is the
>>>> same as another, due to some messy uniqueness requirements on buffer
>>>> objects various drivers have.
>>> It's sad that such a simple thing would require two other horrid
>>> models (EPOLL or KCMP).
>>>
>>> There'[s a reason that KCMP is a config option - *some* of that is
>>> horrible code - but the "compare file descriptors for equality" is not
>>> that reason.
>>>
>>> Note that KCMP really is a broken mess. It's also a potential security
>>> hole, even for the simple things, because of how it ends up comparing
>>> kernel pointers (ie it doesn't just say "same file descriptor", it
>>> gives an ordering of them, so you can use KCMP to sort things in
>>> kernel space).
>>>
>>> And yes, it orders them after obfuscating the pointer, but it's still
>>> not something I would consider sane as a baseline interface. It was
>>> designed for checkpoint-restore, it's the wrong thing to use for some
>>> "are these file descriptors the same".
>>>
>>> The same argument goes for using EPOLL for that. Disgusting hack.
>>>
>>> Just what are the requirements for the GPU stack? Is one of the file
>>> descriptors "trusted", IOW, you know what kind it is?
>>>
>>> Because dammit, it's *so* easy to do. You could just add a core DRM
>>> ioctl for it. Literally just
>>>
>>>           struct fd f1 = fdget(fd1);
>>>           struct fd f2 = fdget(fd2);
>>>           int same;
>>>
>>>           same = f1.file && f1.file == f2.file;
>>>           fdput(fd1);
>>>           fdput(fd2);
>>>           return same;
>>>
>>> where the only question is if you also woudl want to deal with O_PATH
>>> fd's, in which case the "fdget()" would be "fdget_raw()".
>>>
>>> Honestly, adding some DRM ioctl for this sounds hacky, but it sounds
>>> less hacky than relying on EPOLL or KCMP.
>>>
>>> I'd be perfectly ok with adding a generic "FISAME" VFS level ioctl
>>> too, if this is possibly a more common thing. and not just DRM wants
>>> it.
>>>
>>> Would something like that work for you?
>> Well the generic approach yes, the DRM specific one maybe. IIRC we need to
>> be able to compare both DRM as well as DMA-buf file descriptors.
>>
>> The basic problem userspace tries to solve is that drivers might get the
>> same fd through two different code paths.
>>
>> For example application using OpenGL/Vulkan for rendering and VA-API for
>> video decoding/encoding at the same time.
>>
>> Both APIs get a fd which identifies the device to use. It can be the same,
>> but it doesn't have to.
>>
>> If it's the same device driver connection (or in kernel speak underlying
>> struct file) then you can optimize away importing and exporting of buffers
>> for example.
>>
>> Additional to that it makes cgroup accounting much easier because you don't
>> count things twice because they are shared etc...
> One thing to keep in mind is that a generic VFS level comparing function
> will only catch the obvious case where you have dup() equivalency as
> outlined above by Linus. That's what most people are interested in and
> that could easily replace most kcmp() use-cases for comparing fds.
>
> But, of course there's the case where you have two file descriptors
> referring to two different files that reference the same underlying
> object (usually stashed in file->private_data).
>
> For most cases that problem can ofc be solved by comparing the
> underlying inode. But that doesn't work for drivers using the generic
> anonymous inode infrastructure because it uses the same inode for
> everything or for cases where the same underlying object can even be
> represented by different inodes.
>
> So for such cases a driver specific ioctl() to compare two fds will
> be needed in addition to the generic helper.

At least for the DRM we already have some solution for that, see 
drmGetPrimaryDeviceNameFromFd() for an example.

Basically the file->private_data is still something different, but we 
use this to figure out if we have two file descriptors (with individual 
struct files underneath) pointing to the same hw driver.

This is important if you need to know if just importing/exporting of 
DMA-buf handles between the two file descriptors is enough or if you 
deal with two different hw devices and need to do stuff like format 
conversion etc...

Regards,
Christian.

