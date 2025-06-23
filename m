Return-Path: <io-uring+bounces-8455-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E2F8AE5837
	for <lists+io-uring@lfdr.de>; Tue, 24 Jun 2025 01:56:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BD4F11BC6AFA
	for <lists+io-uring@lfdr.de>; Mon, 23 Jun 2025 23:56:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF2362253B0;
	Mon, 23 Jun 2025 23:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="w8Ucqyx0"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168a.ess.barracuda.com (outbound-ip168a.ess.barracuda.com [209.222.82.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9821B1AD3FA
	for <io-uring@vger.kernel.org>; Mon, 23 Jun 2025 23:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750722996; cv=fail; b=slL8O8OxYAqFK5SBEWs4iops1vuEPlEuWnTCthInomPkcYLtEXaIeqRvLETa5AIraxlG7N9ZHHpWOND9d+zlSqRYwQCqRkCDtx29DDz63KNcso8sw2AZ+BiW43eWmBlrzbWx6KD7DkGh4jAKKe//VUg+gRmZA2LSmb/0SHnd3sE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750722996; c=relaxed/simple;
	bh=1QsPtoT381upY50ufvMWVNAscSK64huApyRvv9MuTDo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=A4F3PACEQdUQx6AZeYlk9VzTOT21cWnEeFeJTeydT1Z+plWOVjOfJgRHQgvYD5TKBZM2OdTlm7TDlDBM/5R3fPYflg/+RCQKXklTsq0qMEBN6D29vq/VtZJM1yPY5x2tOd2INuMagDtc6eM8auX+Iij5XAwQOLyqyGrteo6FlSM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=w8Ucqyx0; arc=fail smtp.client-ip=209.222.82.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2101.outbound.protection.outlook.com [40.107.102.101]) by mx-outbound8-4.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 23 Jun 2025 23:56:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WAfynmI/wSYMGqrha4g8NXGQQyznAKjv1XyADwkBbGg4FyvjXu2o/PlJYKwpH5JKoHIAn3ZKqrFz7J9wkJ9x9OV+pneoNNjSnTkDiEHRewVRH9bkGs5Rh/iUVmGh/NIY+esTzk41C8GFDUKge6voa82sMUq4OGe7rknHiA41ahZsxkfS7Hwzte9Zj5SjF3DPRO14dnXN0EnDSViii2R0Gm7uVupwhpw+I/Y8cUu8HWkf5yTW25c2RSk5lmGT2pimT4R0TJ2lQu31jnKoGvcrAl4uQwVSvKxRXEGbWy8+H1+6JO7KFVpONkaWgB/LkDmiry4GKinC2y3qrbVZj3AR1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1QsPtoT381upY50ufvMWVNAscSK64huApyRvv9MuTDo=;
 b=nYkSoidi6CQMYKa9fSJ+ZYlIhZGefaitKr08DoHkNZdFzDfgLIhak4eNll/QYK+xPSvmpxS5UOhArDdmeyxifu7j8jc01bKyis2TZtor+OJhcngQdbbKphELf2QlPbQm6AuWvSdzFjda8Nfu/yyAPWD/CnxLfJYKOSIrXDdAKp9jpC+aWLFDFbydR9OtDMImdliArYVwtmH2ELvqt088Fhtdd/CC6GRW2x2WsmjQ2dFvaUSoAKkLpn7YmrrlyuSOEaI7rXWYgshN7ZT/UAEepehkb1hLQyRfradrsmlCTlrFpJroBi+2lZ6YZgCjCo4RNrkvqv15S6+FWySxoHrX9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1QsPtoT381upY50ufvMWVNAscSK64huApyRvv9MuTDo=;
 b=w8Ucqyx0fO7JkDvfWP+HUrrTLv/y/aBwMu6ivADoeMEeXcjJNgXs3DNKukI/QHHsBrWQZm+1lAnQc74yR+WamnaFGnVDmF78xQ6h/OO9LcCzF5tuvJiSA63/8qanu0dyRxiMymGincyvXBArE860s9IWh232Kxi+NkWIp1kYemg=
Received: from CH2PR19MB3864.namprd19.prod.outlook.com (2603:10b6:610:93::21)
 by PH7PR19MB6529.namprd19.prod.outlook.com (2603:10b6:510:1f7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.13; Mon, 23 Jun
 2025 22:21:23 +0000
Received: from CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::abe1:8b29:6aaa:8f03]) by CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::abe1:8b29:6aaa:8f03%5]) with mapi id 15.20.8857.019; Mon, 23 Jun 2025
 22:21:23 +0000
From: Bernd Schubert <bschubert@ddn.com>
To: David Wei <dw@davidwei.uk>, Bernd Schubert <bernd@bsbernd.com>,
	xiaobing.li <xiaobing.li@samsung.com>, "kbusch@kernel.org"
	<kbusch@kernel.org>
CC: "amir73il@gmail.com" <amir73il@gmail.com>, "asml.silence@gmail.com"
	<asml.silence@gmail.com>, "axboe@kernel.dk" <axboe@kernel.dk>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"joannelkoong@gmail.com" <joannelkoong@gmail.com>, "josef@toxicpanda.com"
	<josef@toxicpanda.com>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "miklos@szeredi.hu" <miklos@szeredi.hu>,
	"tom.leiming@gmail.com" <tom.leiming@gmail.com>, "kun.dou@samsung.com"
	<kun.dou@samsung.com>, "peiwei.li@samsung.com" <peiwei.li@samsung.com>,
	"xue01.he@samsung.com" <xue01.he@samsung.com>, "cliang01.li@samsung.com"
	<cliang01.li@samsung.com>, "joshi.k@samsung.com" <joshi.k@samsung.com>
Subject: Re: [PATCH v9 00/17] fuse: fuse-over-io-uring.
Thread-Topic: [PATCH v9 00/17] fuse: fuse-over-io-uring.
Thread-Index:
 AQHb4E5PyV/4SSROOkOLOMqeWrk3ALQI5QKAgAAmU4CAAjx4AIAGBW2AgAAFPgCAAAc3AA==
Date: Mon, 23 Jun 2025 22:21:23 +0000
Message-ID: <ba778991-c195-49c5-864d-f5278dfbd4f4@ddn.com>
References: <aFLbq5zYU6_qu_Yk@kbusch-mbp>
 <CGME20250620014432epcas5p30841af52f56e49e557caef01f9e29e52@epcas5p3.samsung.com>
 <20250620013948.901965-1-xiaobing.li@samsung.com>
 <7f7f843e-f1ad-4c1c-ad4b-00063b1b6624@bsbernd.com>
 <f966d568-f47d-499a-b10e-5e3bf0ed9647@davidwei.uk>
In-Reply-To: <f966d568-f47d-499a-b10e-5e3bf0ed9647@davidwei.uk>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH2PR19MB3864:EE_|PH7PR19MB6529:EE_
x-ms-office365-filtering-correlation-id: 374d94cc-d03d-428e-b1e6-08ddb2a4498c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|1800799024|376014|366016|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?RGFSQm50V2ZLMnRZS1MxeHJJRHFHVVRGelFSa25RbjRJcW1QWnZacDVoVm9K?=
 =?utf-8?B?ZXRkckpvVXpla2NFUEZ4V1lPNW1NZjNBMW05UnVNYWNmbHhNQ2owSDNxN21n?=
 =?utf-8?B?Zjh2ekxzalNaaVFhQnBPZFQ0MUJvY1VFZlVBekx2d1BPSVNuaFFWR0dFVE0x?=
 =?utf-8?B?N0QwZTk2bFozTmh0akZqOHg0UXMzK3pMajlKaWN0L1B4VlFZNTlOVXZyVVBB?=
 =?utf-8?B?OW0zVllzbTdrODFBaGUwbmFlOHF0YkJoNENDRmlxbjlKUmZPNnd4MGFaSGR4?=
 =?utf-8?B?WndBeHpYRys1aWRMQitKYXoyS013Y2hFZTJXeXFyVUFHWnlQMUVDSjJKL2dE?=
 =?utf-8?B?elkwTEs2ZTgxenpDUWtqUzFXM0dQWVFmaW55bmhITEp6QjBTOXFoNlZWVFhI?=
 =?utf-8?B?VTRxRVJvVW42M0dVMkNOVUtPK3dFUEtoUVgrYTdOSnRTMXNDMlBnRlJPYkU2?=
 =?utf-8?B?UTVWMTZaR2dvWmoraDlxOXRUaW1va3pZbFYzdUI3NC9UQTNGQ2UyWm9WUHl6?=
 =?utf-8?B?OTRjcVgwdEFYNnVOcHJ1V1JtU21DQkZZdjA1SHkzbi90MUp4TDQ2WFlJWGVF?=
 =?utf-8?B?ek1DQkZmaXZHVkxqSXgwQzFYbitJYTNKWGFzclVzbkx4SWo0RVlEZTNHSEVv?=
 =?utf-8?B?ZW1RN1ZIVm9PUUNwK0xhWUt2cVhMajJCVUFISmRlL25hYmloeksxQ2FpejAz?=
 =?utf-8?B?T29TWGVWcWw0Z3dQN0Z2MFhhbm13aGtJekVmWTBCcXBFR2NxaUpNRUppNnMy?=
 =?utf-8?B?ckRZcHArNXpIMDVRUVBNUlFmVXhudGxPdDVVak1zUk50Y3REaTBRRE1pcmdz?=
 =?utf-8?B?Rmtsb0x0MnQ0YWlVaHpPSFYvaXg0dDcrSGJGc2VLQVVpeHBPZHg2bGhJMHc2?=
 =?utf-8?B?ZTJESXUvWHZIb2tTNC83SlhaeFAwclpyelo2TlBPa1c4WkJkOFRYZy9aN0d4?=
 =?utf-8?B?Qnl4enVIQ0JDN0E0TXVta3hDS0wyTkJCQXlUbHp5UG1jZkFkT2RCUWs5Z1dt?=
 =?utf-8?B?UUlNWHpmZ3M2dlhaWG80K001SFZVTjZqc0tUMkJ5aU1lSXBCSHpKUldqUUxO?=
 =?utf-8?B?VHhUekM4QWhpa0xCVXhqL2dvdGMxZTFVODhiS3FJOUxFVmVKRkxKbEE3QkhN?=
 =?utf-8?B?TjM5K3lxYWhRQ0N3czZZM1FVNlhma0REcDM1MHlpWmUvZ0hXMGFDRVVaSUVN?=
 =?utf-8?B?VHFRZDd3Y1ExZTFCUnpGWmdEQzl2WHg2Z2dnZ1pNQ1pwaG1jWWNMdDIvU2JM?=
 =?utf-8?B?MWd4YXhaaDF5TzlzamhDOFFGcTd5dm9oeGRwU0h5QmFUVm9RclJJM3lqdUlY?=
 =?utf-8?B?MW02dmx4ckFKRjVGNVFGK1JUc3dKOUd4RkNZOUNsV2ZOaDJWNk8ySW5BWmFB?=
 =?utf-8?B?QlNtRU1wR1JBbTRnOXYzQ2tiT3BGNCs0ZUd1RzM2QVA0OXNmZFExdFJXSHJ5?=
 =?utf-8?B?TW5EZFBXRzJFTzV2Zkdpa2Y2OHJNTFJ4LzYwdHd4bkpCY1d6MmFLakRXU3By?=
 =?utf-8?B?bXB6QS9sakxlYm9lbDVXeExGWnFHY1FPa3VvV2ZqQkVpSTNGcldLTnRwSXYz?=
 =?utf-8?B?WGRQc3B2U0YwUVhoZWhGMllLY3BaeHdTM3JtTVREWjRPVUJwRXJqbnQzV1dp?=
 =?utf-8?B?aWUyOXBVR3pnbmRQa1R4WE5FTWtKekw2YU4yVE5BVDdFd1lRZUNHWXBsMHpM?=
 =?utf-8?B?ZGk2NzNobldVYjBpWWZMTDl5R3YrN3JoYVZROTExemZ1N2NESjZBbVFkQXc2?=
 =?utf-8?B?NDZXR3k1eS9xcEFha0RIcHdvSy9relBIaDU3Mlk1NWlwc3BZbDFzUjdpY1NI?=
 =?utf-8?B?Z0xvTXI2ejNWSnhPazFlaHZMMVZ2c040K0pkaHdYbFNMbnV1M0dnZVVzc3Y3?=
 =?utf-8?B?WkdjYVNNZ1U0L3c0VjBHdld4K0VHc05VU0Z2UGExWW5RWmd2QzBpZXdZcGF0?=
 =?utf-8?B?c2hjYlg2SHo2RW8zS28vTWt1MzJaMlpEamh2WWxLOWw0UElnMWVNd2lwQ0Y3?=
 =?utf-8?B?aERlWWw5SnFnPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR19MB3864.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(10070799003)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MC9BVGZWOW0yU24zM0xyUSsyMWF0azhlazQxN05MNGRQdmlyV3VZaG5zQ2RP?=
 =?utf-8?B?VzVvRENtOHBPZmhSb3JpNDVhOEwwTlVpcythNExvMzVZTXhXMzlhdzVqOUpl?=
 =?utf-8?B?MmJBY095TERqaTRmOHA5bWs5emIrYmN2cUJwOWtyVTZRUTRSRENIbnRRWHZv?=
 =?utf-8?B?RGJMalNwTTRJZTVISWRFTWw4OEZkZHVqaVRqRVFQOHVvaXpmdS9USVJHaU1a?=
 =?utf-8?B?QmE5WSthV1ZIRDQ3djR1NkVBQ2xPU2xMMzBzbUJrZWNVaXZKMkRRWGFGN1lB?=
 =?utf-8?B?aWErMFMwcWpnUGhnYXZQRy9sSmZaTFd1TlBtSnNlV0ZrVU0zV3VPYVc3bEts?=
 =?utf-8?B?UGNQV0Y4RGVSZzlqVUpCcWhNeVk5bEtuV3ZzeFZkelIzcDYwQS9oT2MxeFRJ?=
 =?utf-8?B?bW0yMlo2c1dXTTZ6L1d5V2RzZ3AvNWRDRmJ3eDIyTXZhdFpMam5YdUkwemJP?=
 =?utf-8?B?R2RWdWt1d3BmZHFoNXdZWWtvSklNLzF6WWVmdHF4Vytaa25MejQ0eVo3UzZy?=
 =?utf-8?B?am5JNm5LY3VQNi9mQ1ZtTVQrc0xiNzJtelVpejRka092dEd2ZmRBQVlPTHdT?=
 =?utf-8?B?VXdScG1xMjhPNENrNlBkTjNKdVJ0U3hHclBQL0Vta3ljaVZBMmVSaG1HWGVG?=
 =?utf-8?B?NDByR0J6NTlqMEQzeWZvcVRDUCtIZXViSFZtTWgyVWc5RWFQUUNGdGhPQk51?=
 =?utf-8?B?QXM3RU9CbjdUM3RoMTMzb2dQMVJtQmJ4QVRGaW9DelY5R0NWVFprQ1FkUmZm?=
 =?utf-8?B?dGgvZ0g3RG5wK1RjQ2o3UGxxaWdRbmZtRW1RVXQ3azF2VmtoaldVR2VEb3Vv?=
 =?utf-8?B?NGgxRkI2dVRJRUZSU3UrUjVtYWZrZUpYbzlPQVhyMWk1WFgvaEI1V3NhbG81?=
 =?utf-8?B?MkdEVU1ZK2l5eGlhYTc3dFJnblVJOFlRWlRRdjVnWjNGOGJWa3hDbmhvZFp3?=
 =?utf-8?B?eHk5UG9yUUV0Y01VTWExY1hGWmJNd2dVOTVhdE9UalVCK2d2VXRHMS9WZXho?=
 =?utf-8?B?cUJRTFdURGRreHh5cEVsZG9sUkRZRkVCUjVkaXdmcjVCMmJLUFhibkprLzQw?=
 =?utf-8?B?UWptb0xudWJqWkF4RmJKeVVtamxQanNNdGN5dlV1TklMYWdwWjRleHlSeHVh?=
 =?utf-8?B?eGtwcmwxeEQ2YjU5Szk1QWdvMytVcGx4cjBvK3FrejFkN1B3UkhUek5SRUFN?=
 =?utf-8?B?ODJwVkN2MEJuUVU5S1NwTlE4T2VFaHVpSUZ1bnBFT2I3eDljQzhzL0kxZ2RB?=
 =?utf-8?B?eWhON3ZIZEdvakJObzJkemsyWlNEZGMwU2dqSTZFWisycTZzV2hmYkxzTUUz?=
 =?utf-8?B?WUFpVXJMbk1PZkt0bGVKZEhNRjdlT2tPKzA2ZXRwYi90NnRkNG5JQklDb1FS?=
 =?utf-8?B?dFI5VEJYeitNaHRhTVliUmJIRlNRaWpDUGcvOGFZdnRYbUF5S1hmdkdRcGpy?=
 =?utf-8?B?UzJKL1R5UnQ2NWFJeWdpcFNBL24yaEJZRFJJYXBpb2IvNGo0VnBnYm92TlVw?=
 =?utf-8?B?dXNudWhGNW5QYnd1ZGNHdDBoNUZObW9CSmlzdWQ2UWlxQ2NRWGNJWmxlOW5o?=
 =?utf-8?B?dTFmQ1JLMG5oR0IwK2Z4VUFtaVZwRGh1ODBQM1BBU0lHSHAzejZDNzVSRnIr?=
 =?utf-8?B?b08rbzJSSzE3RGNia3BlV3lQTVluY09ocDljTmMrQjZ2TTlZaXhlNWdPT0o3?=
 =?utf-8?B?RjlLWlhKQVJQL0xCKzRneHI2SjRRMi9ZcUwrYmZYdTl2ckJpRm5vdVFvaXFw?=
 =?utf-8?B?VUpESlI4a3N2dXdCdTJjNVA2ZWxidlM4M2phMU9FSDBCVlQyYW1yajhZeURL?=
 =?utf-8?B?UUNIZ2xsaVptSjY3YXRzN0ZhblBncUpiRUsramlaZDgvSWV5T0FiQTBoRWxJ?=
 =?utf-8?B?UDFkdzcyS3QyKzNwckt0NTFCcDJTQ0QxMndJMjhDRXZ1R3pUQ2xkd2xzZERZ?=
 =?utf-8?B?L25QNDZDUkZpUGlCb1BFRlhDRm5MOFBYaU1GcDU3Z3I4dEduRnFpUnVpR1Bp?=
 =?utf-8?B?UHFZK3BaRWlPNDZ1YzRpdml1TCtxbENDNWd2eWFKUC96VFRYTkd4QWNFTGds?=
 =?utf-8?B?ZlBCTHk2eHdGcUYwTGdzdmxrdTVuRmNuVnR0anJZUG1CdGFvWm1ybW9GaHBi?=
 =?utf-8?B?VVg5c3YwTnZxdTRXWGRMU3dGem02U3lYMUZRYUN5cFQxZGJpUUJaR0Joc01w?=
 =?utf-8?Q?nRzVPGdbUIZvzA8g+lMzG50=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <97074BB779051246934C4006BB1B2782@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
 cYOhI7GNPI9f39ZVUs/ZrAv5z+12SNwIk6/Ui3gJYbsDHV42pVqBg5fd3HKZr7uH19zGKutZI0pUGG9dy8VCIcuOuj6zC38jIh2UcsO+Qxn2vfynyf5V2f+5Hn9Q7koWvecS7US7fXa9N4xRQ2F6vb80/a5e4adihJq/21PNlx+tLvoGGWrNlOQK7YcURzG6K70kpn6kG86CNi64yzTfbBFQMJK/9s7yo72icW15IS6/4a76rl5E+jpNrbl9d8c7X0VRf20Q820yJxUMd+bgz1I8ZivA7SkKy9cb/nk+bwp6ZIjtogJRm0kxsGul8pSOrkwPeBb/oCEJnNd28vOv+XEQ7CSmIOWySHUqjffvY1Z7spKnDyvErn0GzIBhJFJQsmxfVLxP3WKlHVXAy8W4DwapvxsKamB3mMoMYTuvJ64iMXP77hA2QOaGWsf4wynmZW5KElJA21qqOZ/5Y2umHm5kMkwixfk0wdLGEQjmguJZDzUXEBKY3EUmLC0NdGffirRdyEELGd3BTqVZ7S2yDQoEEaSUfkC8onq/LQvnDgZ9k+VRqA6gzOQosjH5wG8Zu5CLTVRoRhGtuTsklH7DRRVUiSGqCiG5BGKyCe0Q0kQ6ymYTnJ+I+wsqdSpUSvkADVmmEZLrhgveJZH/WOd3kQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR19MB3864.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 374d94cc-d03d-428e-b1e6-08ddb2a4498c
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2025 22:21:23.4027
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1cFeqqbYuaOkDKV3fIbOETd58gSUYxhSUcuUqQwZbkkxdReFVtsFdZHk79hYHWsnAH7+Q5kemLhLo77/2grzcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR19MB6529
X-OriginatorOrg: ddn.com
X-BESS-ID: 1750722991-102052-21464-41197-1
X-BESS-VER: 2019.1_20250611.1405
X-BESS-Apparent-Source-IP: 40.107.102.101
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVkbmpoZAVgZQ0NjSLNUiMTXZ2M
	TQ0NzIwjzRxMzUNDXFLNko2dzAxNBcqTYWAIn+I0xBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.265552 [from 
	cloudscan16-159.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

T24gNi8yMy8yNSAyMzo1NSwgRGF2aWQgV2VpIHdyb3RlOg0KPiBPbiAyMDI1LTA2LTIzIDE0OjM2
LCBCZXJuZCBTY2h1YmVydCB3cm90ZToNCj4+DQo+Pg0KPj4gT24gNi8yMC8yNSAwMzozOSwgeGlh
b2JpbmcubGkgd3JvdGU6DQo+Pj4gT24gV2VkLCBKdW4gMTgsIDIwMjUgYXQgMDk6MzA6NTFQTSAt
MDYwMCwgS2VpdGggQnVzY2ggd3JvdGU6DQo+Pj4+IE9uIFdlZCwgSnVuIDE4LCAyMDI1IGF0IDAz
OjEzOjQxUE0gKzAyMDAsIEJlcm5kIFNjaHViZXJ0IHdyb3RlOg0KPj4+Pj4gT24gNi8xOC8yNSAx
Mjo1NCwgeGlhb2JpbmcubGkgd3JvdGU6DQo+Pj4+Pj4NCj4+Pj4+PiBIaSBCZXJuZCwNCj4+Pj4+
Pg0KPj4+Pj4+IERvIHlvdSBoYXZlIGFueSBwbGFucyB0byBhZGQgemVybyBjb3B5IHNvbHV0aW9u
PyBXZSBhcmUgaW50ZXJlc3RlZCBpbg0KPj4+Pj4+IEZVU0UncyB6ZXJvIGNvcHkgc29sdXRpb24g
YW5kIGNvbmR1Y3RpbmcgcmVzZWFyY2ggaW4gY29kZS4NCj4+Pj4+PiBJZiB5b3UgaGF2ZSBubyBw
bGFucyBpbiB0aGlzIHJlZ2FyZCBmb3IgdGhlIHRpbWUgYmVpbmcsIHdlIGludGVuZCB0bw0KPj4+
Pj4+ICAgc3VibWl0IG91ciBzb2x1dGlvbi4NCj4+Pj4+DQo+Pj4+PiBIaSBYaW9iaW5nLA0KPj4+
Pj4NCj4+Pj4+IEtlaXRoIChhZGQgdG8gQ0MpIGRpZCBzb21lIHdvcmsgZm9yIHRoYXQgaW4gdWJs
ayBhbmQgYWxzbyBwbGFubmVkIHRvDQo+Pj4+PiB3b3JrIG9uIHRoYXQgZm9yIGZ1c2UgKG9yIGEg
Y29sbGVhZ3VlKS4gTWF5YmUgS2VpdGggY291bGQNCj4+Pj4+IGdpdmUgYW4gdXBkYXRlLg0KPj4+
Pg0KPj4+PiBJIHdhcyBpbml0aWFsbHkgYXNrZWQgdG8gaW1wbGVtZW50IGEgc2ltaWxhciBzb2x1
dGlvbiB0aGF0IHVibGsgdXNlcyBmb3INCj4+Pj4gemVyby1jb3B5LCBidXQgdGhlIHJlcXVpcmVt
ZW50cyBjaGFuZ2VkIHN1Y2ggdGhhdCBpdCB3b24ndCB3b3JrLiBUaGUNCj4+Pj4gdWJsayBzZXJ2
ZXIgY2FuJ3QgZGlyZWN0bHkgYWNjZXNzIHRoZSB6ZXJvLWNvcHkgYnVmZmVycy4gSXQgY2FuIG9u
bHkNCj4+Pj4gaW5kaXJlY3RseSByZWZlciB0byBpdCB3aXRoIGFuIGlvX3JpbmcgcmVnaXN0ZXJl
ZCBidWZmZXIgaW5kZXgsIHdoaWNoIGlzDQo+Pj4+IGZpbmUgbXkgdWJsayB1c2UgY2FzZSwgYnV0
IHRoZSBmdXNlIHNlcnZlciB0aGF0IEkgd2FzIHRyeWluZyB0bw0KPj4+PiBlbmFibGUgZG9lcyBp
biBmYWN0IG5lZWQgdG8gZGlyZWN0bHkgYWNjZXNzIHRoYXQgZGF0YS4NCj4+Pj4NCj4+Pj4gTXkg
Y29sbGVhdWdlIGhhZCBiZWVuIHdvcmtpbmcgYSBzb2x1dGlvbiwgYnV0IGl0IHJlcXVpcmVkIHNo
YXJlZCBtZW1vcnkNCj4+Pj4gYmV0d2VlbiB0aGUgYXBwbGljYXRpb24gYW5kIHRoZSBmdXNlIHNl
cnZlciwgYW5kIHRoZXJlZm9yZSBjb29wZXJhdGlvbg0KPj4+PiBiZXR3ZWVuIHRoZW0sIHdoaWNo
IGlzIHJhdGhlciBsaW1pdGluZy4gSXQncyBzdGlsbCBvbiBoaXMgdG8tZG8gbGlzdCwNCj4+Pj4g
YnV0IEkgZG9uJ3QgdGhpbmsgaXQncyBhIGhpZ2ggcHJpb3JpdHkgYXQgdGhlIG1vbWVudC4gSWYg
eW91IGhhdmUNCj4+Pj4gc29tZXRoaW5nIGluIHRoZSB3b3JrcywgcGxlYXNlIGZlZWwgZnJlZSB0
byBzaGFyZSBpdCB3aGVuIHlvdSdyZSByZWFkeSwNCj4+Pj4gYW5kIEkgd291bGQgYmUgaW50ZXJl
c3RlZCB0byByZXZpZXcuDQo+Pj4NCj4+PiBIaSBCZXJuZCBhbmQgS2VpdGgsDQo+Pj4NCj4+PiBJ
biBmYWN0LCBvdXIgY3VycmVudCBpZGVhIGlzIHRvIGltcGxlbWVudCBhIHNpbWlsYXIgc29sdXRp
b24gdGhhdCB1YmxrIHVzZXMNCj4+PiBmb3IgemVyby1jb3B5LiBJZiB0aGlzIGNhbiByZWFsbHkg
ZnVydGhlciBpbXByb3ZlIHRoZSBwZXJmb3JtYW5jZSBvZiBGVVNFLA0KPj4+IHRoZW4gSSB0aGlu
ayBpdCBpcyB3b3J0aCB0cnlpbmcuDQo+Pj4gQnkgdGhlIHdheSwgaWYgaXQgaXMgY29udmVuaWVu
dCwgY291bGQgeW91IHRlbGwgbWUgd2hhdCB3YXMgdGhlIG9yaWdpbmFsDQo+Pj4gbW90aXZhdGlv
biBmb3IgYWRkaW5nIGlvX3VyaW5nLCBvciB3aHkgeW91IHdhbnQgdG8gaW1wcm92ZSB0aGUgcGVy
Zm9ybWFuY2UNCj4+PiBvZiBGVVNFIGFuZCB3aGF0IHlvdSB3YW50IHRvIGFwcGx5IGl0IHRvPw0K
Pj4NCj4+IEF0IERETiB3ZSBoYXZlIG1haW5seSBhIG5ldHdvcmsgZmlsZSBzeXN0ZW0gdXNpbmcg
ZnVzZSAtIHRoZSBmYXN0ZXIgaXQNCj4+IHJ1bnMgdGhlIGJldHRlci4gQnV0IHdlIG5lZWQgYWNj
ZXNzIHRvIHRoZSBkYXRhIGZvciBlcmFzdXJlLA0KPj4gY29tcHJlc3Npb24sIGV0Yy4gWmVyby1j
b3B5IHdvdWxkIGJlIGdyZWF0LCBidXQgSSB0aGluayBpdCBpcw0KPj4gdW5yZWFsaXN0aWMgdGhh
dCBhcHBsaWNhdGlvbiB3b3VsZCBjaGFuZ2UgdGhlaXIgQVBJIGp1c3QgZm9yIGZ1c2UgdG8gZ2V0
DQo+PiB0aGUgY29vcnBvcmF0aW5nIG1vZGVsIHRoYXQgRGF2aWQgc3VnZ2VzdHMgKGF0IGxlYXN0
IGluIG91ciBjYXNlKS4NCj4gDQo+IFNpbWlsYXIgZm9yIHVzIGF0IE1ldGEuDQo+IA0KPiBJIGhh
dmUgYmVlbiB0b3lpbmcgd2l0aCBhbiBpZGVhIG9mIGEgc29sdXRpb24gdGhhdCBkb2VzIG5vdCBu
ZWVkIChtYWpvcikNCj4gY2xpZW50IGNoYW5nZSBhbmQgZG9lcyBub3QgZGVwZW5kIG9uIEZVU0Ug
aW9fdXJpbmcuIEkgdGhpbmsgaWYgaXQgd29ya3MNCj4gdGhlbiBpdCB3aWxsIGJlIG1vcmUgYnJv
YWRseSBhcHBsaWNhYmxlIGFuZCB1c2VmdWwuDQo+IA0KPiBJJ2xsIGhhdmUgc29tZXRoaW5nIHRv
IHNoYXJlIHNvb24uDQo+IA0KDQpPdXQgb2YgaW50ZXJlc3QsIHdoYXQgaXMgdGhhdCBjb25jZXB0
Pw0KDQoNClRoYW5rcywNCkJlcm5kDQo=

