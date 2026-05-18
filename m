Return-Path: <io-uring+bounces-13393-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cOrfEKMGC2rt/QQAu9opvQ
	(envelope-from <io-uring+bounces-13393-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 14:31:31 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 41AF156CB27
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 14:31:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 3D62F3073339
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 11:47:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61D583F7869;
	Mon, 18 May 2026 11:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="IHcYgFMX"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168a.ess.barracuda.com (outbound-ip168a.ess.barracuda.com [209.222.82.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8BBE347FE1;
	Mon, 18 May 2026 11:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779104858; cv=fail; b=Os6Exy07SsBFS9nJkS95/Ka3+YVDfIhEwWwGb4yNT0p1YyoVVIOaQMTrvtFAONwRAvZO3IxECxU9I9SJBnl5ADfYRgxxt/uJkPDbr6fv/neEWwcOPPhvjzC7judBNJYSgmv6Hs/8sG5GY9rdnLH3OFEYHv1jacIGm/KmWqO2w3o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779104858; c=relaxed/simple;
	bh=V1Ndn4iXdEyN29gVBxNfJQSZ69wDLMTTMKgFVayT1c0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qR5Q8KzqofTBYdJfS6UdNyiPgZ1GTbVUGyriSfkQfKrftDxWexi+Bag+cnFtVdRiyJksHFJk1/M0QLRNchIc8IudcTq5OZueWBUafXz14JFrmyO1NkAacY7NFr8FFpNzb0QT6d85BW6yfQDiMcz96zkqoHgIG1H1/+XcsY4rrTs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=IHcYgFMX; arc=fail smtp.client-ip=209.222.82.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11022103.outbound.protection.outlook.com [52.101.43.103]) by mx-outbound46-18.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 18 May 2026 11:47:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=on4Qf6Q/UVe1EOPGkR4flm7ygGapeQDpbXJX7PVGpHDyeodqWda6sKvWvUoB0srGpVFgegWebzuEPRjIYBr6XLhnmGUn6gi9sI7HkdYobYR9ztH9HWZag9s8rCWuvjAqiroEmgI+ohBj4Al15tUjGAxhWvus5VWb4ew30UKPofu4w0WXOnRv3hSvKUB8qJq3JXLLccgmCwNRE8dK3bQcadfsJNpBjPgHndrFyaujPPHoaCGuaxhODlDJI6U/b0QhbtfLLZNZ5HoSfnhgMCkl2sAalzYimQQDn65JDy9c5MfjzLC7+5YDiU3e086Ww3bSAN5Kms6JHUmJenCdvHtsNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RbYkNzdUPLEFmc8scC/LoVsNf2BZUR9Kxloyp61cr5g=;
 b=geBod7qnJgjkfgCUaSI4PeTQow+OVOuV+wX85QQFX4UYd+sR5dp85OsD849KJcs/+Ve8G1ha7bPPQ8rw35a3onOu5foA/D43dgsyvNqZCgE4dZM+Q6PqMXKT5KdZMr8/KVujFVENvJqTBAst5wIhLIHKJrSVXPg61NsHv8apeYe+7miQ6bKA5q7C9DCAx3P215ZVtKptO0vCoJ9iIqYLc+3nR0wZYf67a1I/Ij1X6/5MYw/B+7ZnCwLvVF7YUqjQQskDkGyjMkjvSXkOOmmMGJj83iLtaRvTaqu+QBp/Y3ZfvY6RlyxmIAgQt+dHoDybeiwtouvmHbxDD6htu1raAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RbYkNzdUPLEFmc8scC/LoVsNf2BZUR9Kxloyp61cr5g=;
 b=IHcYgFMXplfv9dfZZ7J8Vd6zJljHy76vgBHLqe2HwNhNUccMq/x8iW88OwZr2l7BypQznNShRoVx3HhlG0PTO7jD9d62WuJ3iEq+EE5atoa3TzlfynwzME423ru2DfA2CGMs3dXfO3zN2BJeIl8AXvnYCmKvvSe/vWdNIlEjHQo=
Received: from CH2PR19MB3864.namprd19.prod.outlook.com (2603:10b6:610:93::21)
 by PH0PR19MB5647.namprd19.prod.outlook.com (2603:10b6:510:14f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.23; Mon, 18 May
 2026 11:47:08 +0000
Received: from CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::c2de:bba2:8877:3704]) by CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::c2de:bba2:8877:3704%7]) with mapi id 15.21.0025.023; Mon, 18 May 2026
 11:47:08 +0000
From: Bernd Schubert <bschubert@ddn.com>
To: Berkant Koc <me@berkoc.com>, Greg KH <gregkh@linuxfoundation.org>, Miklos
 Szeredi <miklos@szeredi.hu>
CC: "security@kernel.org" <security@kernel.org>, Joanne Koong
	<joannelkoong@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Pavel Begunkov
	<asml.silence@gmail.com>, fuse-devel <fuse-devel@lists.linux.dev>
Subject: Re: [PATCH 2/2] fuse: wait for aborted connection before releasing
 last fuse_dev
Thread-Topic: [PATCH 2/2] fuse: wait for aborted connection before releasing
 last fuse_dev
Thread-Index: AQHc5f0ab+Kc+AhELUaTC1v0iClq0bYST98AgACrHICAAJHXAIAAH06A
Date: Mon, 18 May 2026 11:47:08 +0000
Message-ID: <2889c98c-21e8-47eb-903a-ea40bf5c8c04@ddn.com>
References: <20260517095846.fuse-iouring-uaf.dc5f5dbb71dc@berkoc.com>
 <2026051703-equinox-multitude-91e2@gregkh>
 <20260517-fuse-uaf-cover@berkoc.com> <20260517-fuse-uaf-patch2@berkoc.com>
 <08d3f6e0-7745-4084-995a-95ddb77f7f11@ddn.com>
 <177906678512.922207.11821272786828738648@berkoc.com>
 <fb437530-94f1-4f06-98d9-a252e4ff1315@ddn.com>
In-Reply-To: <fb437530-94f1-4f06-98d9-a252e4ff1315@ddn.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH2PR19MB3864:EE_|PH0PR19MB5647:EE_
x-ms-office365-filtering-correlation-id: 57afa0c3-0d84-478f-0e96-08deb4d330b2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|6049299003|19092799006|10070799003|7416014|376014|4013099003|4053099003|18002099003|56012099003|22082099003|38070700021|4143699003|11063799003;
x-microsoft-antispam-message-info:
 UOcp8xVCPZ8N6d2+faju6E1vE9KQbJeGAaQvLOGNTcIJahTCOyvIXIpJfs34X3sCtgN7azIDLskG6X7o1Zww/pARivSrzDSSY4HtjRUPFX403dCA1uwS+oHwSDJ/OlnJKBCb/Wt2ZSOgnP8Ciq1rzDy4D8FDsmTCWgQfRjL3GGbXWVz5T/YQvIKstNvw4uI+dDaDRFSniKab7O8N/bYiIzuXPA7Nt6GG3rc0WqbVQJPCJbukRL3s6HYTA/s/i9tEYgDb1GMbgLMPa7FVOMatVBOMVQIRafwEkKF3CGFrtpNQkQAmRRMFnxQMVYTJ5p/Fum4ayJ/9AtXWT9qu6zqQWZYlar+/WWJ7L+DAsY2w8ae3htvs84MSyZibnZZP5ow/Hp0c0qx9ds0Xcva3o599gcZgmobBmqAZU6++L2ITm2644lYtwGJjM63CHyqj+vM35jlcrRkmZFY/SgvVk9rWfyiaiT5u+Eb8U3juafIOdBNFVB7Qf7g/TaKj8uvkM116c6TWD9AkDKRky7yXmtaZL09M7t7F14TgeHTjWhQlFwAksoHBOAcbQ4TqVDZeRHfqP9J3MJly7dJ8nZn4L3zH5iq6tXPZy2BE7GqMkxKfhLtrOh/uciJbTeQccJuDeiNN/PIn1Az/vwPKT8kaA4E6dkDuYnV0ubsgcF1NdpQ4AzBh8/d+n6SgBZbbZCXYoBzikM49DjyHWWNefx9DcJObclRVjKo8VqNP2M3a1Bt+3lVMfLJQUbomhsxPppemDGJQ
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR19MB3864.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(6049299003)(19092799006)(10070799003)(7416014)(376014)(4013099003)(4053099003)(18002099003)(56012099003)(22082099003)(38070700021)(4143699003)(11063799003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Z0NlYkFGZzJTdmh2cFNVYmJTSCtWV3FjWnVtQmdHdmxpNU9zNFpoMDRLcGJO?=
 =?utf-8?B?WE95TjlqNjI0VTAveVpKS2FacEJoZk5wa0t6M3c1K0sxM1B1c1htTEVnUEFU?=
 =?utf-8?B?OGU2bE4xVUxVSkVBL2FmME1GN2tHaHJrczNsRmNpbmlJRTd2V0NnV0NjVHVC?=
 =?utf-8?B?VGgxcytNYkVlQktFOHA5MzRoSG5wVEdSaDkrTTg3OHR1eEgwdXJGdkV6VjJS?=
 =?utf-8?B?eXdYMDRjOFl3NXhwUm93am9rRXA4Q3B6TWNxWmV5U1huVjIrRkJoZzl3SmI4?=
 =?utf-8?B?bnFzdTZlSkZFM2xuUUIrOEZUSXBVVFhvQTF6SHNOUjB5ZSt3WlRQWHBFQXVP?=
 =?utf-8?B?My8xSnVPWVBRdW1zRzVIWGlVT3QyOGl3UmhEbTBjc1RFVjZ0OWJ1UGdHTENZ?=
 =?utf-8?B?MUpnY21MSFNBZy9VNWxaOEhJcWtQUFUxcG5vMW5PVFRHS1IxMCtoQmpoNWtQ?=
 =?utf-8?B?L0tjUFRlaGRud2xaVVBETWoxUjFzeEsvekd6QklLVHgwNEl2eDU3aFhQWE5y?=
 =?utf-8?B?UERlbnNYU2VPMHhOWG10dHF6NFlpaFlYU2NMTjR6elJXc0NkYkdUVGxrSFZa?=
 =?utf-8?B?Ymp0Yzd3MmpNdHV5VE80R3l4MXNnUldrOEVkVmxreXUxSEFqWVVtS2tSei8z?=
 =?utf-8?B?aG5oYjY1TFJvK3hUYlZRSWZXYTJiUXlYTzluRzlGc0lCVkVod3h2UnI2T2g0?=
 =?utf-8?B?T3JVbVltRnlBN0s4L2tsTlBVMTFDdUwrdit0MWJZZzlzUjl0bGFsTFN0eU9a?=
 =?utf-8?B?SFFHSS9CS20wRmNXNFhPemtHczY1OTJGcjFXWmMyNlJqUGlDaEY4QUJHL1pI?=
 =?utf-8?B?VVdOKzV4NDJjaUFSMElLdGE0WDc3ck5FUmIvSG42T3N5NVBVeHRzcVpseTdN?=
 =?utf-8?B?cm52dS9uZmJyWjM0NU4xMDlSekJTc1JuWXUrK052WGR3a3JEWnBFU0FkRXVO?=
 =?utf-8?B?NlR6elFwWTl6eFZISFBwTkZtQXNzc2FHU1BNOUUvSytLNmw5SklNMFZnTStl?=
 =?utf-8?B?dHM0R3ZYTW9OWVdIdG1IQkRFNy8zcHlVdnM3QUU0YUp0ZUZNM2pLaGNnd240?=
 =?utf-8?B?aW44VS9TZnNXMkdRem5mOHUvb21IeWFsV3NMeWswQytLR2N3MG10RHpkaDBo?=
 =?utf-8?B?T0pPUXpSeTE4dzF5M3pDSGZaVHBnOUl5dVV0TDZReDBRZkFvSGRxSHgxckF5?=
 =?utf-8?B?N0lpRCtNRWlVejd6TlRuUUVjTTByVUw5cHp0RU1DUXEreUpBeDNPSzJiRTR1?=
 =?utf-8?B?dWdBSG1ZUE1vMnNtNFpvZ1RvVUdCenlXNFFUL25IQ3AvNTVsZUJ1SzY3NDN6?=
 =?utf-8?B?V0MzQk9FMEdyenpWVWpxOXFPR2FWSzF0N3UzWGVKckVpTm9Ucmcxcjg3eXdF?=
 =?utf-8?B?ZVlhbmRlYXpObkhtczAweVd6Nngwd3NjK2ZkVVRJRDJyZnQzVGhQLy83L0xE?=
 =?utf-8?B?WDBiSGxpZm1IK3R1aVFtckozYTl5Rmp4cFA1cUtKYTVrWWlpejAzeEdYL2Zq?=
 =?utf-8?B?am9LU2RsQ0grcTkvcCtIWWcxOGFJTFd0OWgrTHlWdmc2eTBGWlE1Qm9NbFND?=
 =?utf-8?B?dEUrcG9ZQ0trdm9FcUMvY2ttMDhvUVNsVytWYUlqUWw0YlNtNzVITFNkNTlo?=
 =?utf-8?B?VGRyK2JubjJKNnhJMUJzNnF3VDZtb0xTZHJzR1BucSswUTBxVzdrREdJUzRH?=
 =?utf-8?B?aDFrQmIzbFFDR1VLTHpzbkhFQlFXWFlEYnN3KzlWZkdGMlBKa25EbnNPaWtH?=
 =?utf-8?B?dFJ3YmpkQWgzSlM1V1JmZWtCN1psMDZlK3VYU0xPelNGYXcyMzhkbTJzak9I?=
 =?utf-8?B?VGtVd3Fsc1IrVXZLZFA0ZEQ3bGV4VDNNN0NpRlB3K3pGcVRpdHI5VVBSRHFz?=
 =?utf-8?B?RmpvamtEWno1TzlVUy9iVGlSMGZXdHQwMElFdUxQaWZ0SzRlTXU0MzdpRGR5?=
 =?utf-8?B?TXRaZ1UxZm9pbUJ2enFLL2h4b1NzdFh0dHd4cmN4d3ErQmR0eE11M092SlRa?=
 =?utf-8?B?STRZMng5a2Eybm4yekFmaS9XSTFmVWllclNUQldNNjQrUlRNSTFBbkNWSzJi?=
 =?utf-8?B?ejZ6T1JIak5GTUEzNFZEVHdJMGtWRkRFY2FDbkx6OHUzVkRMOVJzQnBBbnF5?=
 =?utf-8?B?Tm9TakZYNFp0UHVUNmpFMlZHY0RiMGZDWDFJdW9hRGdTU1JGUm1uckQydFEv?=
 =?utf-8?B?eUtEYlVlTFRLUWp3dmo3QzQ1ZjlFTUs1MzlhREp1MUkzaFZFN3F5NnV0cmsz?=
 =?utf-8?B?QlpHNkZDdEt0cUpSQitDSVN0SFlUVzhJRDB3STI5Y284NjBlMjNxU1Iva0Jz?=
 =?utf-8?B?S1llZFFkc2tQQjkrSzljdU02OGI4Mm1LWjlUMVd0NXVUWTNBcXIyUTlFRTNB?=
 =?utf-8?Q?Kw/s0RDHWoULZxnltilZmTa/IiNKmHaq1UW4D?=
Content-Type: multipart/mixed;
	boundary="_002_2889c98c21e847eb903aea40bf5c8c04ddncom_"
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	kQVn/oem9JbUpX3dDfNxwvWK0VD3WiFxo+H/Xu/VtCqqamSfQw3bc0EyQHsKW+N/Qu+5+S0CU4bOtCcbkfHHElTIJfj+ZodHXIbqly/NhPFTI1jixe9CqVvdbrQe88mHFNlH4kHi7DUeThHFp2IrRFdoQLHSgsU7BWSteOznSH3QRROs/7LyqgZPeKLUSDFf5HcULVabzZWHnEB2Otfmm8mMcYXSHEd5/xCxx65Vs7gwpMYd208ZdiJn5+qwmcKvUen3ZTtaT45T2Kx1dyPnQLGXG21ltRszrvU/eSbMWrlVXQgo7k+NhljhP5bkLZg3y1PoNw1YyNZ2aObWGf3qNg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	p0TZxP9a6+4kAknbZyCApjii8PQNcC20z+YNEedhcTvjCfmfLPJemhDAjGFFIHZCOKFEal2UekDJFwVkNV8IRaAACDRD6fv1ABaVhsZzBbURmzCMcBVoV8RCN4aa0lHQt+zwWVrXwTaniOhDX6e11Zl4cBmN46Jd0g34BaGITwLQJuiRmFPi1GGxaLHgCOct2zjxqJiIrUfuwpLrvqzTdYy4D/pcGbVQQtrxJuAAgotQo0NXVGJB5oLppUMzFH+szi4nwxQrLtbQB6GZLBaoaqVzMPYine/RNE/mqYd920IYawpFt+EvZ1PJsuundt3LVaugJeXXhPp2uuFPsOaaU6r6O5A4qx+B+Xdq8QZ0qnSbrofafRirdaAhWYHbz7om+f61ZJzqRcpYZ2xSrOo2obRTNk6lmml8yDKQtAf3wcOHvzjvQFdRT/hLfd+i6RnbmssYRIs8Iia0+oRHRoggYHLA5Dww1J6pJBvOgsiLtUdnXez5C0nOq8kqv72yffQj/iZwyr+J9ILy8+SEvqCB028leVdrKIxTed4Sw6ZWIyOZqT5HZljzTkAjXt0vZlGofByD9XnxsNV2rEo3t28N5ih0hfzabheqEAdciwKTp1//Z252c7DoRfgKEg1Br7Pc6tDzjRbsOBopRtGiuZ15yw==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR19MB3864.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57afa0c3-0d84-478f-0e96-08deb4d330b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2026 11:47:08.0660
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0wmEg7EU17jl5ba3Zp4sRkyEODU+eBwZ4jLMJtj2q/qsPWmK+Ghg2G4dUOT3yc13pl5sIs0A+FiljohFlTg1cQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR19MB5647
X-BESS-ID: 1779104831-111794-7685-2420-1
X-BESS-VER: 2019.1_20260511.1731
X-BESS-Apparent-Source-IP: 52.101.43.103
X-BESS-Parts: H4sIAAAAAAACA2WLsQ7CMAwF/8Vzhzi2X5r+CmKwSyw2Bjogof47WZi6nE4n3e
	1L43PQRsfkQq83bVUrpj1nLIBGsAavotaapIxIG267KLzTuVx/NpT/X+KRGTFc2GGovT
	XbO0w9OLHSef8BeDK+d4EAAAA=
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.273289 [from 
	cloudscan8-160.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1
X-Rspamd-Queue-Id: 41AF156CB27
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [7.44 / 15.00];
	SEM_URIBL_FRESH15(3.00)[berkoc.com:email];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	SUSPICIOUS_URL_IN_SUSPICIOUS_MESSAGE(1.00)[];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	MAILLIST(-0.15)[generic];
	MIME_BASE64_TEXT(0.10)[];
	BAD_REP_POLICIES(0.10)[];
	MIME_GOOD(-0.10)[multipart/mixed,text/plain,text/x-patch];
	HAS_LIST_UNSUB(-0.01)[];
	DMARC_POLICY_ALLOW(0.00)[ddn.com,reject];
	MIME_TRACE(0.00)[0:+,1:+,2:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	R_DKIM_ALLOW(0.00)[ddn.com:s=selector2];
	TAGGED_FROM(0.00)[bounces-13393-lists,io-uring=lfdr.de];
	GREYLIST(0.00)[pass,body];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,vger.kernel.org,kernel.dk,lists.linux.dev];
	HAS_ATTACHMENT(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bschubert@ddn.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[ddn.com:+];
	RCPT_COUNT_SEVEN(0.00)[10];
	REDIRECTOR_URL(0.00)[aka.ms];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_SPAM(0.00)[0.473];
	R_SPF_ALLOW(0.00)[+ip6:2600:3c15:e001:75::/64:c];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[]
X-Rspamd-Action: add header
X-Spam: Yes

--_002_2889c98c21e847eb903aea40bf5c8c04ddncom_
Content-Type: text/plain; charset="utf-8"
Content-ID: <9A2D9C861B469449B679A3C29756FCB4@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64

T24gNS8xOC8yNiAxMTo1NSwgQmVybmQgU2NodWJlcnQgd3JvdGU6DQo+IE9uIDUvMTgvMjYgMDM6
MTMsIEJlcmthbnQgS29jIHdyb3RlOg0KPj4gW1lvdSBkb24ndCBvZnRlbiBnZXQgZW1haWwgZnJv
bSBtZUBiZXJrb2MuY29tLiBMZWFybiB3aHkgdGhpcyBpcyBpbXBvcnRhbnQgYXQgaHR0cHM6Ly9h
a2EubXMvTGVhcm5BYm91dFNlbmRlcklkZW50aWZpY2F0aW9uIF0NCj4+DQo+PiBCZXJuZCwgdGhh
bmtzIGZvciBwdXNoaW5nIGJhY2suIFN0ZXBwaW5nIHRocm91Z2ggdGhpcyBhZ2FpbnN0IHRoZSB0
cmFjZToNCj4+DQo+PiBmdXNlX2Nvbm5fZGVzdHJveSgpIGluIGZzL2Z1c2UvaW5vZGUuYyBjYWxs
cyBmdXNlX3dhaXRfYWJvcnRlZCgpDQo+PiBiZXR3ZWVuIGZ1c2VfYWJvcnRfY29ubigpIGFuZCB0
aGUgZXZlbnR1YWwgZnVzZV9jb25uX3B1dCgpIChmcm9tDQo+PiBmdXNlX3NiX2Rlc3Ryb3kpLiBm
dXNlX2Rldl9yZWxlYXNlKCkgaW4gZnMvZnVzZS9kZXYuYyBkb2VzIG5vdCB3YWl0DQo+PiBiZXR3
ZWVuIGl0cyBmdXNlX2Fib3J0X2Nvbm4oKSBhbmQgZnVzZV9jb25uX3B1dCgpLiBUaGF0IGFzeW1t
ZXRyeSBpcw0KPj4gdGhlIHJhY2UuDQo+Pg0KPj4gT24gdG9wb2xvZ2llcyB3aGVyZSB0aGUgbGFz
dCBmdWQgcmVsZWFzZSBJUyB0aGUgbGFzdCBjb25uIHJlZg0KPj4gKG5vIHN1cGVyYmxvY2sgbW91
bnQsIG5vIG90aGVyIGZ1ZCBvcGVuIOKAlCBleGFjdGx5IHRoZSBQb0Mgc2V0dXApLA0KPj4gZnVz
ZV9jb25uX3B1dCgpIGRyb3BzIHRoZSBjb3VudCB0byB6ZXJvLCBjYWxsX3JjdSBzY2hlZHVsZXMN
Cj4+IGRlbGF5ZWRfcmVsZWFzZSwgYW5kIGZ1c2VfdXJpbmdfZGVzdHJ1Y3Qga2ZyZWVzIHJpbmcv
cXVldWUvZW50X3JlbGVhc2VkDQo+PiBzbGFicy4gYXN5bmNfdGVhcmRvd25fd29yaywgc2NoZWR1
bGVkIGJ5IGZ1c2VfdXJpbmdfYXN5bmNfc3RvcF9xdWV1ZXMNCj4+IHZpYSB0aGUgdGVhcmRvd24t
aW50ZXJ2YWwgZGVsYXllZF93b3JrLCB0aGVuIHJ1bnMgb24gZnJlZWQgbWVtb3J5Lg0KPj4NCj4+
IFRoZSBLQVNBTiB0cmFjZSBhdCB0b3AtZmluZGluZy9rYXNhbi10cmFjZS50eHQgc2hvd3MgZXhh
Y3RseSB0aGF0DQo+PiBpbnRlcmxlYXZpbmc6DQo+Pg0KPj4gICBmcmVlIHNpdGU6IGZ1c2VfdXJp
bmdfZGVzdHJ1Y3Qg4oaQIGRlbGF5ZWRfcmVsZWFzZSDihpAgcmN1X2NvcmUNCj4+ICAgdXNlIHNp
dGU6ICBmdXNlX3VyaW5nX3RlYXJkb3duX2FsbF9xdWV1ZXMg4oaQIGFzeW5jX3RlYXJkb3duX3dv
cmsNCj4+ICAgICAgICAgICAgICAod29ya3F1ZXVlKSwgcmVhZGluZyBlbnQtPmxpc3QubmV4dCBm
cm9tDQo+PiAgICAgICAgICAgICAga21hbGxvYy0xOTIgZnJlZWQgYnkgZGVzdHJ1Y3QNCj4+DQo+
PiBZb3VyIGluLWZsaWdodCBjbWQgcmVmIGludmFyaWFudCBob2xkcyBvbiBib3RoIGZpeGVkIGFu
ZCBub24tZml4ZWQNCj4+IHBhdGhzIChub24tZml4ZWQgdmlhIHBlci1jbWQgaW9fcHV0X2ZpbGUg
aW4gaW9fZnJlZV9iYXRjaF9saXN0LCBmaXhlZA0KPj4gdmlhIHRoZSBpb191cmluZyBmaWxlIHRh
YmxlIHNsb3QgcGlubmluZyBzdHJ1Y3QgZmlsZSDihpIgZnVkIOKGkiBmdXNlX2Nvbm4pLg0KPj4g
QnV0IG5laXRoZXIgY292ZXJzIHRoZSBnYXAgYmV0d2VlbiBmdXNlX2Fib3J0X2Nvbm4gKHdoaWNo
IHNjaGVkdWxlcw0KPj4gdGhlIGFzeW5jIHdvcmsgYW5kIHJldHVybnMgaW1tZWRpYXRlbHkpIGFu
ZCB0aGUgUkNVIGNhbGxiYWNrLiBUaGUNCj4+IFBvQyB0b3BvbG9neSByZW1vdmVzIGV2ZXJ5IG90
aGVyIHJlZi1ob2xkZXIsIHNvIHRoYXQgZ2FwIGJlY29tZXMgdGhlDQo+PiBsYXN0IGNvbm4gcmVm
Lg0KPj4NCj4+IFRoZSBwYXRjaCByZXN0b3JlcyBzeW1tZXRyeSB3aXRoIGZ1c2VfY29ubl9kZXN0
cm95IGJ5IHdhaXRpbmcgb24NCj4+IHJpbmctPnF1ZXVlX3JlZnMgPT0gMCAodmlhIGZ1c2Vfd2Fp
dF9hYm9ydGVkIOKGkiBmdXNlX3VyaW5nX3dhaXRfc3RvcHBlZF9xdWV1ZXMpDQo+PiBiZWZvcmUg
dGhlIHB1dC4gVGhhdCBndWFyYW50ZWVzIGFzeW5jX3RlYXJkb3duX3dvcmsgaGFzIGZpbmlzaGVk
DQo+PiBiZWZvcmUgUkNVIGlzIGFybWVkLg0KPj4NCj4+IFRoZSByYWNlIGlzIHJlcHJvZHVjaWJs
ZSB3aXRoIG1kZWxheS13aWRlbmluZzsgd2l0aG91dCB3aWRlbmluZyBJIHNlZQ0KPj4gMCB0cmlw
cyBpbiA1MCBpdGVyLCBidXQgdGhlIHdpbmRvdyBpcyBpbiB0aGUgY29kZSBwYXRocy4NCj4gDQo+
IEkgdGhpbmsgSSBzZWUgd2hhdCB0aGUgYWN0dWFsIGlzc3VlIGlzLCB3ZSBuZWVkIGFuIGZjIChv
ciBpbiBsaW51eC1uZXh0DQo+IHN0cnVjdCBmdXNlX2NoYW4pIHJlZmVyZW5jZSBhcyBsb25nIGFz
IGZ1c2VfdXJpbmdfYXN5bmNfc3RvcF9xdWV1ZXMoKQ0KPiBydW5zLiBQYXRjaCBmb2xsb3dzLg0K
PiANCg0KV291bGQgaXQgYmUgcG9zc2libGUgZm9yIHlvdSB0byB0ZXN0IHRoZSBhdHRhY2hlZCBw
YXRjaD8NCg0KDQpUaGFua3MsDQpCZXJuZA0KDQo=

--_002_2889c98c21e847eb903aea40bf5c8c04ddncom_
Content-Type: text/x-patch; name="fuse_uring_async_stop_queues.patch"
Content-Description: fuse_uring_async_stop_queues.patch
Content-Disposition: attachment;
	filename="fuse_uring_async_stop_queues.patch"; size=1561;
	creation-date="Mon, 18 May 2026 11:47:07 GMT";
	modification-date="Mon, 18 May 2026 11:47:07 GMT"
Content-ID: <4F51A2F94FA1CF488A247619333F17B1@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64

Y29tbWl0IGI2ZjYzY2MxZDJmN2I4ZDY5MDgzNWM5NjVkNjAwZmRhNDdmZmQ3OWIKQXV0aG9yOiBC
ZXJuZCBTY2h1YmVydCA8YmVybmRAYnNiZXJuZC5jb20+CkRhdGU6ICAgTW9uIE1heSAxOCAxMzoz
MDozMCAyMDI2ICswMjAwCgogICAgZnVzZTogQXZvaWQgdXNlLWFmdGVyLWZyZWUgaW4gZnVzZV91
cmluZ19hc3luY19zdG9wX3F1ZXVlcwogICAgCiAgICBmdXNlX3VyaW5nX2FzeW5jX3N0b3BfcXVl
dWVzKCkgbWlnaHQgcnVuIHdoZW4gdGhlIGxhc3QgcmVmZXJlbmNlCiAgICBvbiByaW5nLT5xdWV1
ZV9yZWZzIHdhcyBhbHJlYWR5IGRyb3BwZWQuCiAgICAKICAgIEluIG9yZGVyIHRvIGF2b2lkIGFu
IGVhcmx5IGRlc3RydWN0aW9uIGEgcmVmZXJlbmNlIG9uIHN0cnVjdCBmdXNlX2Nvbm4KICAgIGlz
IG5vdyB0YWtlbiBiZWZvcmUgc3RhcnRpbmcgZnVzZV91cmluZ19hc3luY19zdG9wX3F1ZXVlcygp
IGFuZCB0aGF0CiAgICByZWZlcmVuY2UgaXMgb25seSByZWxlYXNlZCB3aGVuIHRoYXQgZGVsYXll
ZCB3b3JrIHF1ZXVlIHRlcm1pbmF0ZXMuCiAgICAKICAgIEZpeGVzOiA0YTliZmI5YjY4NTAgKCJm
dXNlOiB7aW8tdXJpbmd9IEhhbmRsZSB0ZWFyZG93biBvZiByaW5nIGVudHJpZXMiKQogICAgQ2M6
IHN0YWJsZUBrZXJuZWwub3JnICMgNi4xNAogICAgUmVwb3J0ZWQtYnk6IEJlcmthbnQgS29jIDxt
ZUBiZXJrb2MuY29tPgogICAgU2lnbmVkLW9mZi1ieTogQmVybmQgU2NodWJlcnQgPGJlcm5kQGJz
YmVybmQuY29tPgoKZGlmZiAtLWdpdCBhL2ZzL2Z1c2UvZGV2X3VyaW5nLmMgYi9mcy9mdXNlL2Rl
dl91cmluZy5jCmluZGV4IGU0NjdiMjNlNjg5NS4uYzk2ZDcyMjUwODMwIDEwMDY0NAotLS0gYS9m
cy9mdXNlL2Rldl91cmluZy5jCisrKyBiL2ZzL2Z1c2UvZGV2X3VyaW5nLmMKQEAgLTQ2NSw3ICs0
NjUsMTAgQEAgc3RhdGljIHZvaWQgZnVzZV91cmluZ19hc3luY19zdG9wX3F1ZXVlcyhzdHJ1Y3Qg
d29ya19zdHJ1Y3QgKndvcmspCiAJCXNjaGVkdWxlX2RlbGF5ZWRfd29yaygmcmluZy0+YXN5bmNf
dGVhcmRvd25fd29yaywKIAkJCQkgICAgICBGVVNFX1VSSU5HX1RFQVJET1dOX0lOVEVSVkFMKTsK
IAl9IGVsc2UgeworCQlzdHJ1Y3QgZnVzZV9jaGFuICpjaGFuID0gcmluZy0+Y2hhbjsKKwogCQl3
YWtlX3VwX2FsbCgmcmluZy0+c3RvcF93YWl0cSk7CisJCWZ1c2VfY29ubl9wdXQoY2hhbi0+Y29u
bik7CiAJfQogfQogCkBAIC00NzcsNiArNDgwLDkgQEAgdm9pZCBmdXNlX3VyaW5nX3N0b3BfcXVl
dWVzKHN0cnVjdCBmdXNlX3JpbmcgKnJpbmcpCiAJZnVzZV91cmluZ190ZWFyZG93bl9hbGxfcXVl
dWVzKHJpbmcpOwogCiAJaWYgKGF0b21pY19yZWFkKCZyaW5nLT5xdWV1ZV9yZWZzKSA+IDApIHsK
KwkJc3RydWN0IGZ1c2VfY2hhbiAqY2hhbiA9IHJpbmctPmNoYW47CisKKwkJZnVzZV9jb25uX2dl
dChjaGFuLT5jb25uKTsKIAkJcmluZy0+dGVhcmRvd25fdGltZSA9IGppZmZpZXM7CiAJCUlOSVRf
REVMQVlFRF9XT1JLKCZyaW5nLT5hc3luY190ZWFyZG93bl93b3JrLAogCQkJCSAgZnVzZV91cmlu
Z19hc3luY19zdG9wX3F1ZXVlcyk7Cg==

--_002_2889c98c21e847eb903aea40bf5c8c04ddncom_--

