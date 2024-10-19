Return-Path: <io-uring+bounces-3835-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 66BF39A4ABA
	for <lists+io-uring@lfdr.de>; Sat, 19 Oct 2024 02:44:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ECC57283D8B
	for <lists+io-uring@lfdr.de>; Sat, 19 Oct 2024 00:44:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A989192D73;
	Sat, 19 Oct 2024 00:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="unFE9fTq"
X-Original-To: io-uring@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2073.outbound.protection.outlook.com [40.107.237.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E72192D68;
	Sat, 19 Oct 2024 00:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729298687; cv=fail; b=kuiHF+RKQHlPZzp8kIzn2j0c5S08rUzrYgs3T8gurs22WgivtR/ntFdZU5l5wZ06az15T2hH2K/Sm9FS3hht8TQ19sOc2UHmhTjjPIqMxUK/6gWCVRVR9jZ3USuW0xHjS3taQbb1Gv2zAwGF2wVNotNu+gzk0+Vt8BZlG66cmEM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729298687; c=relaxed/simple;
	bh=vGE/cke+/IjbK8GoaEcXtsK14Wbbg3/xBXXRMMgQslU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=M1H/tNst9BoDB7tdmHwxG15HXq8lTdpHU+0Ykhag/cDZSDhfStigL+JXrRfKnxZJzLINLlHBD/wBNDjzCZwwj2hrU16s32fJzT8LlnY/W8+StMJoditXxjaaddPB5YDMIJR4NcnstCK3ori3PeKj0ID7B3e+YL5nrHOj83N8Tkc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=unFE9fTq; arc=fail smtp.client-ip=40.107.237.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l9Zw6weQyfU7FBjtl7pFRtyz/kyf8byv7yNwRLi4qWZIw4R7SZhxfaPtTIAk0DcCpDkNSrzCkP7J+R9Y7X3qznhzpDHimH0Kssa8oEgDqpFZEnurWk6Qy8XXJJJL6ryoCYfmatUkNh1X3mzlb0cjWpZwaPUA9HcX1hreVeIUNvVCbuFN/Vxu1B76+sAg/ofSi/gsAbMIeDswz8Hj1YpPRCMedC+/5CotEpx1CKa6C68QafG8gJCZjtciwMPOeq3QINvTSkV2EumQ/9jxR4qZuwWByLzLZmq7uSi20Q5mz6/YSqnSqS859UHA0z9n9zLw5UDfhzfvV5LaupHdJ07hYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vGE/cke+/IjbK8GoaEcXtsK14Wbbg3/xBXXRMMgQslU=;
 b=FP8lgzOOwlaiHBXhlIUWpWXl/xroAnD4aJecOYb++IhqXz1/2UzAbPr51ZyfVIevRI1iaHYl5StRNcATYzGEoLlOTIqwoBLOxuKjyvoYLXlEW/GFlsfAUrYhnWvOv+Rn8O78lI4AfOrrgHoux7LFe3agL8KcrZBnJBiZNy9ii5HBxHpRDlAHOOjlYs4XGxgDSSBGZxYXkmO7Nkg2Jy856OscNxpn0dprb67lTK7r2pBYMAqwn0m62KwCLDqlk5Ex+HOUcDpYJcVWG4l83dt4WkweTGdChRFOc1ChsTjmBGPlQJrN8IWo7DLyp+vY32osjn6jjqO29alcWzxRg+tXNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vGE/cke+/IjbK8GoaEcXtsK14Wbbg3/xBXXRMMgQslU=;
 b=unFE9fTqJ8DaIe685eHbdNx4gzP4s8Wn/sBqkv2bQ5qipY0V+PpKUpgZyLYK9yNWJpy/ONe4x0O3fZaeTLsq2thm7deYkdZKcZnncfxgI4ksv0sKNV7TLY32xrUArQN2B1VCEynuOCZyKB/HQNAVooKzx2WJ9cysEuSfp8kacQ83rEJXuzRKYDkuRlNDpw2n15wbVXK7KtLtt+8n12SuDjsBSUCLYjzWp/50/BlbB+V5xxyk14zaL/bnOVonyW+k5ALNAz7TLKw/EWKH1NlZ51lKmQDVSC6l3heRfeV4EKz54XTWkMsnrZ1lbkFxwk/o6lJVOBHk+ad59yPR6AbjLg==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by DS7PR12MB6022.namprd12.prod.outlook.com (2603:10b6:8:86::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8069.18; Sat, 19 Oct 2024 00:44:38 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%5]) with mapi id 15.20.8069.016; Sat, 19 Oct 2024
 00:44:38 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Pavel Begunkov <asml.silence@gmail.com>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>
CC: Jens Axboe <axboe@kernel.dk>, Kanchan Joshi <joshi.k@samsung.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [PATCH for-next] nvme: use helpers to access io_uring cmd space
Thread-Topic: [PATCH for-next] nvme: use helpers to access io_uring cmd space
Thread-Index: AQHbIXkdjmTj/dnuaUqd8Al4etId87KNPTQA
Date: Sat, 19 Oct 2024 00:44:38 +0000
Message-ID: <b82b36c3-5ab5-4e99-941b-b099020d1b36@nvidia.com>
References:
 <c274d35f441c649f0b725c70f681ec63774fce3b.1729265044.git.asml.silence@gmail.com>
In-Reply-To:
 <c274d35f441c649f0b725c70f681ec63774fce3b.1729265044.git.asml.silence@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|DS7PR12MB6022:EE_
x-ms-office365-filtering-correlation-id: de8f71e5-c0d9-44c6-7788-08dcefd73637
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|10070799003|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?WVJYZGI0emJmQWMrUi83Y2U3bW85SnluYi9BK20wY1B3cWM5UHlta2s4Mkxz?=
 =?utf-8?B?OExZTmUrWTZ3ejhMK1EzOHVvMCtVTVVtSENJSVFPR2F4VUdLQU9ZWGxpV2Qv?=
 =?utf-8?B?Um90N1B4V255MDBuVjJ5bktGRGl5UW9QK2tXYWU1MldHRGpOVGlSSEpFVGZz?=
 =?utf-8?B?UkVhdHRaRTZuUWJ4bExXTFJqUkU4N25WN2tpZXhJU1lqaW5LU1Y0TDdLNDAy?=
 =?utf-8?B?c2htdnlnb3BTTGFFZXhSNmhFWkhPM24rYmtTUHlwa2FFM3NQRVA3QVkzNWJq?=
 =?utf-8?B?eXZnc0I2Zkdxbmo3VlhYNmRCY2RoRHM1b3NzMWNFMXF3TzZUSVFTUTRNcWp1?=
 =?utf-8?B?eUZhSXkxTzZ2ZXhzVkVBdHViMEN3NjQxWDBzN1dWeEtXM3NXdkdoOXJ1bFh3?=
 =?utf-8?B?MklxZ0F0WU1MM0U1NzNlWXM0MUdRWWdQSGEvQWRIUEdYYS9MaTdUQ1FlR25Q?=
 =?utf-8?B?WWNNdHZkeUZhSEE2SDlNTFJhcS8xczVVeXdtME8xNS9zeVhaSHB6VnQ1VHV5?=
 =?utf-8?B?STExYkI3bGwydWRRa3ZJSWtzR0ZmRkVBcGtPWVZvU0ErSnpnaTJ4SHVnNnEy?=
 =?utf-8?B?SGlHRmJiZFlKVlBYVlJaNTBpYi9oOU5Ga1BpR1MwVXg1ZFhjdHgzdWU3cytm?=
 =?utf-8?B?bFdhYUZjaGFwNUxDSWo2MmZ0YXB1cE8wWEJOdFhwbERWNEVWVStyZ1RZNEZr?=
 =?utf-8?B?OHRSVzcxdGlERDdjUHdVZlpWMnNseWJXYi9DRHZ3NS9jcUxCQTJZRjAyS2dY?=
 =?utf-8?B?T1BSTStiZWpHcFQvNDFVUlByeUVLbGF4Zm9pQ01xM0YwdjJDRllmM0ptNW1v?=
 =?utf-8?B?UGZKNjZ2Nzl4cmRQUzhiWExOWnRnTEpmZHpSOGtYVzBteVF0SVJ3QmFCTlE1?=
 =?utf-8?B?VWZqdVNlazhhZUxmaFZnQkNaOG5KblpwM2FQdko5c2ZnVWxlZTJtRkpNb1Vr?=
 =?utf-8?B?dGUxRnlWdytVVWRJUGpvdmpYdm0rOENBeHlad2JlTHcybUx5cjhMTnZaRHQv?=
 =?utf-8?B?TzFQYkhsdU54OHFKUFc1MVNGbDR4RHI4NUpjaUQxNEFobERxSTFmaytDNVcv?=
 =?utf-8?B?cUpYSG1QUGw4K25XeGFkZFhNeUl1MWZTdWtRNURmajU0OFY4QVBkUWZ6WFUz?=
 =?utf-8?B?TnJzYytRaGlXZ0NOYkttSnNtbmQvTmR4U0RWWDgyK0MyUVpNMEFZY2ZUYXg4?=
 =?utf-8?B?MzJIUHBMVmlmVmN6aUswS0JlTVFTdXNPL2orOCt4eVdLVktiblkvd0dzZ3M2?=
 =?utf-8?B?elFFOStpckxDVWQxZXl0UVdKd3AxZVJ0MjA5ckI4R29tTWc0dU1yRGxjM1Vj?=
 =?utf-8?B?VFdsekp3NnhjZEh6NldLaE9DTEkwRzZyUUgzZmhMNlJ2SXg1Q1Nkei9kT0lP?=
 =?utf-8?B?S0VwcXliTW95akRuSXozL0tvWXpLU1p2S3RwQ214Rk9kR3U5VWZBa0JERHNJ?=
 =?utf-8?B?SW1zV3RCSXZIS1lqMVROdmE0Z2UwajZCM3VOeFBpaWRCaGRDQ2hzZ0NFZndr?=
 =?utf-8?B?RjNxSnZmby9TUWdvNC9GMzROYlhPbXcxT1llUDFSMUlHbEZiM01adzFzMVlv?=
 =?utf-8?B?Y1JkaEMrT0kyWkJ5ejJ6L2lGMmE1dWR3TTNFNFFWREg3RC9TSkd6V2JSbkNJ?=
 =?utf-8?B?Mkg0a094Y0tQOWt2czQ0a0VFU2g3SWVxd3ZyWmNGelFIN0E1UWNsMElsSlNW?=
 =?utf-8?B?N2RwTER6SmpyS0JXQ1FCcXlsdndtSzNHK1JQRzYxNWYwVVI1alFVTTJXUUsv?=
 =?utf-8?B?VTNpYnBReGYzVHN2eHBVdktDMDh3czZUYisrR1oxUk5aT3NSeGhYSDVTQnVW?=
 =?utf-8?Q?nhnArSMgqy05mVMqemkY9eyUPcQsSDC9ZN/XE=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Q3hvL1p3Y3lMditrVFprN0JmUXk4UFVhWVl4OERpRVdNWlJSN0t6TURxTElJ?=
 =?utf-8?B?MFpNcVNHaXU0TGJITjI3TVhoUDBuSXVjaWVHaDVsbzhJM0VrNU9JQ1RuM0Qz?=
 =?utf-8?B?Y3lvSFBOQ251VE55MENJK2Z6cDRQM3Z3QTFZd2NvVWZVNW5ZaFQydWJpU04v?=
 =?utf-8?B?WmFlWFBjQUlYM1hyUFNIZDY1Q3kzM0lzWkNEc1JEYm9nSE8vbFlRcGJZbXR2?=
 =?utf-8?B?enBGQlcyZTc4YTdwZForRUVXZWpDcFNjUjdLZGhRaXl1SG1wOHhVT1JCb256?=
 =?utf-8?B?R0VJRFhYVGJVN20vb3RsQkVueUkzdGpJcUpqaEs0eDNycEEwTitlekdvUy9U?=
 =?utf-8?B?RUl3blJWcWsvQTkwRW5iZmR3MFFWWjM5VUJKNmNodFZ5eGNyV056QmVLYlFk?=
 =?utf-8?B?UnBIT1lPalNab2RtM0xVbG4xdC82OW1MblhTa3RGV1Q3UHVkaEVYQkFLS0h6?=
 =?utf-8?B?QVFSazBrWHkwMURJejhFeWdzdGpsVnBPdzVseGJZY2FYV0taNnJUUGdCSkph?=
 =?utf-8?B?dk0xWWQ4SmgvTTVHNGxlbjBhdW55Rk1SYVRRVUxkUHo5ZFlxRHV6d1l1WkRi?=
 =?utf-8?B?OVk2bGFTYlNaVHhtK09TN2JIL3JWdkR1bnFZQ29CZ0thK3VVekNFK0xqdy9j?=
 =?utf-8?B?QURWTkFFRENhb2RudjFwSE04S21iRVhhZGZyc2xnaHBMRVYrempScGFjallI?=
 =?utf-8?B?V2NHWFEzbUR4aDlOa2FRc2d1SjBhVldXanRiNE9CZVpYUm9mbjVMWWhVZmxw?=
 =?utf-8?B?VkhMbkxyVVM1eGIzMjFoemtYcGoyVjUzZkNreldnZjhxYlNwSTVaYmlIaVhO?=
 =?utf-8?B?dnFNMXFiQjlBYlR1VWhPLytlcmlVUmtFTjNkVGlTamhBdUZNL05rejZVa1li?=
 =?utf-8?B?dStveGV6QlJmMXppSk1yVzhIcVgveS93OUlNV2VKQkY2Y1NHMzRuYW93MzdD?=
 =?utf-8?B?VnVhNHZ1bVdVaHJkWTZDWGNmK09HSTRnM1JTN2ZTRkhGSU90elhvTlRwQnh6?=
 =?utf-8?B?WHB0K1dyajZGSFhMTUptMjMrRHA4dWpZVEtMUkk1cnNRRnl5ZXdrbDNHT3Jh?=
 =?utf-8?B?MFZpZ2VDQ2I2bzEyUTNRQlgwejNXQytjdWJKTmNIekgyR2hjZWF1ekZUMC9C?=
 =?utf-8?B?cStSYkt2R0JmcUZZYTE2ZkJjVmx2cGY0UmoxL3Voa3NiSkltanY4bUdFcURZ?=
 =?utf-8?B?YmMvY3JUaWxWdFp6Z090SCtQRjZSQk1uRWxjUmhIcmU1cE40ZjhkNmIxanlu?=
 =?utf-8?B?MUs2cmZDTXlQSCtkMkI0aldFOHBsdElCeXQ2TkYrV3ZlZG9QcG00UzV0QnVp?=
 =?utf-8?B?dVA3YkRqZjdvZUVjNWU2RzFWLzlZZForb0F1TWxacE1uOVBBVUJxRkY1QVJ3?=
 =?utf-8?B?My90ZzBNWENKMno0Rm1KdE03NnFmOU5YZ1RoTXdYMWlZYjJ3NE5DbXJrTW90?=
 =?utf-8?B?WnRpM21jQ2lCN3VnaFhidVlGSm1NYmZ3SUcvWkREbjl4SkFzTEFWNG9ZRzR1?=
 =?utf-8?B?bUg1cVRNQnZBZFZPVkZTN01wbUcwSlZodFppbU1FVEV6VXlITTc2dUE0c21X?=
 =?utf-8?B?ZXMwUU12aXdDUERsOHVYdHZMYWhEN2RiTkNYRkwwcDlaejkrU1JVY3ZwNG43?=
 =?utf-8?B?N1FLVGRLTGJhY1BKRVluR0xUR2cwQ1hoUVFnSk04OTRVRHFpUjl5L25aeFpU?=
 =?utf-8?B?cG0rU25LV2dFZjVwOUZPTi9jZzNMN2EveXRReEZDVUdOOExMb25ZakxnSkIr?=
 =?utf-8?B?SW1kWkt3dWlYUUtlcnNycXVaZDhEaEF4Q1JLYmpHVW5qcFE2a1o5WXVZakdN?=
 =?utf-8?B?OUpiNWVIYzVCeWF1UTMzeFZSNThkdmVocVBXTm5BMGh2WmtSbk9kSUtiekhi?=
 =?utf-8?B?aUNrRE1nS2tUb2JnaERjT1p3SVlBRjVZWGhqZzV0U1BMNjZwcGVJbTRGanA4?=
 =?utf-8?B?c0xXNitMbUNwdENoMEx0VWhpZzNXeGlKS0tZQTBXaXJoYzlTUFk1dnJWMXp5?=
 =?utf-8?B?TkxNakNyd3FKandFUGo4SW1tZ2o2YUllU09HOFdFQzYvMkUrYXk4NTFFcXRn?=
 =?utf-8?B?cjJFN3kyOHNYWWZlSlBLb1VLUER1a0UvcVBtZ3FvWnRjdHFtVWtoRnQyZUM5?=
 =?utf-8?B?azBJS0hWeWFvWUJmVVNJcERZcFRFNXZneWRQQnpQTzV0VEExVVQxSmhCN3Zt?=
 =?utf-8?Q?Max4qV4a4ZWNhqQX9byadcvLZQOm4jNVSdza5DPvoZwY?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3976205D52F0BB4BACC4C7581820C24E@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: de8f71e5-c0d9-44c6-7788-08dcefd73637
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2024 00:44:38.5976
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vdbwAKvi15Qngsu/k0JeqBPJwgxe7unw64MF42/fzBK3bXR5BSxjrbuAsiMJVXVH15tn60c1ZZMUBFNqe323ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6022

KyAobGludXgtbnZtZSkNCg0KT24gMTAvMTgvMjQgMDk6MTYsIFBhdmVsIEJlZ3Vua292IHdyb3Rl
Og0KPiBDb21tYW5kIGltcGxlbWVudGF0aW9ucyBzaG91bGRuJ3QgYmUgZGlyZWN0bHkgbG9va2lu
ZyBpbnRvIGlvX3VyaW5nX2NtZA0KPiB0byBjYXJ2ZSBmcmVlIHNwYWNlLiBVc2UgYW4gaW9fdXJp
bmcgaGVscGVyLCB3aGljaCB3aWxsIGFsc28gZG8gYnVpbGQNCj4gdGltZSBzaXplIHNhbml0aXNh
dGlvbi4NCj4NCj4gU2lnbmVkLW9mZi1ieTogUGF2ZWwgQmVndW5rb3YgPGFzbWwuc2lsZW5jZUBn
bWFpbC5jb20+DQo+IC0tLQ0KPiAgIGRyaXZlcnMvbnZtZS9ob3N0L2lvY3RsLmMgfCA0ICstLS0N
Cj4gICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDMgZGVsZXRpb25zKC0pDQo+DQo+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL252bWUvaG9zdC9pb2N0bC5jIGIvZHJpdmVycy9udm1lL2hv
c3QvaW9jdGwuYw0KPiBpbmRleCAxZDc2OWM4NDJmYmYuLjZmMzUxZGE3ZjA0OSAxMDA2NDQNCj4g
LS0tIGEvZHJpdmVycy9udm1lL2hvc3QvaW9jdGwuYw0KPiArKysgYi9kcml2ZXJzL252bWUvaG9z
dC9pb2N0bC5jDQo+IEBAIC00MDQsNyArNDA0LDcgQEAgc3RydWN0IG52bWVfdXJpbmdfY21kX3Bk
dSB7DQo+ICAgc3RhdGljIGlubGluZSBzdHJ1Y3QgbnZtZV91cmluZ19jbWRfcGR1ICpudm1lX3Vy
aW5nX2NtZF9wZHUoDQo+ICAgCQlzdHJ1Y3QgaW9fdXJpbmdfY21kICppb3VjbWQpDQo+ICAgew0K
PiAtCXJldHVybiAoc3RydWN0IG52bWVfdXJpbmdfY21kX3BkdSAqKSZpb3VjbWQtPnBkdTsNCj4g
KwlyZXR1cm4gaW9fdXJpbmdfY21kX3RvX3BkdShpb3VjbWQsIHN0cnVjdCBudm1lX3VyaW5nX2Nt
ZF9wZHUpOw0KPiAgIH0NCj4gICANCj4gICBzdGF0aWMgdm9pZCBudm1lX3VyaW5nX3Rhc2tfY2Io
c3RydWN0IGlvX3VyaW5nX2NtZCAqaW91Y21kLA0KPiBAQCAtNjM0LDggKzYzNCw2IEBAIHN0YXRp
YyBpbnQgbnZtZV9uc191cmluZ19jbWQoc3RydWN0IG52bWVfbnMgKm5zLCBzdHJ1Y3QgaW9fdXJp
bmdfY21kICppb3VjbWQsDQo+ICAgCXN0cnVjdCBudm1lX2N0cmwgKmN0cmwgPSBucy0+Y3RybDsN
Cj4gICAJaW50IHJldDsNCj4gICANCj4gLQlCVUlMRF9CVUdfT04oc2l6ZW9mKHN0cnVjdCBudm1l
X3VyaW5nX2NtZF9wZHUpID4gc2l6ZW9mKGlvdWNtZC0+cGR1KSk7DQo+IC0NCj4gICAJcmV0ID0g
bnZtZV91cmluZ19jbWRfY2hlY2tzKGlzc3VlX2ZsYWdzKTsNCj4gICAJaWYgKHJldCkNCj4gICAJ
CXJldHVybiByZXQ7DQoNCkluZGVlZCBmcm9tIGlvX3VyaW5nX2NtZF9wcml2YXRlX3N6X2NoZWNr
KCksIExvb2tzIGdvb2QuDQoNClJldmlld2VkLWJ5OiBDaGFpdGFueWEgS3Vsa2FybmkgPGtjaEBu
dmlkaWEuY29tPg0KDQotY2sNCg0KDQo=

