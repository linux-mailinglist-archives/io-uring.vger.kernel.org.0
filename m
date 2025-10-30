Return-Path: <io-uring+bounces-10300-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B64A8C22A76
	for <lists+io-uring@lfdr.de>; Fri, 31 Oct 2025 00:08:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 77BA34F05F8
	for <lists+io-uring@lfdr.de>; Thu, 30 Oct 2025 23:08:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE1F02F49E3;
	Thu, 30 Oct 2025 23:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="ddSu2IFT"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957CA26FD9A
	for <io-uring@vger.kernel.org>; Thu, 30 Oct 2025 23:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761865687; cv=fail; b=CnCyvUdkS3pncmHReyHuxnxRBNWDZHeWThfrADBZks/QxJ//F+4i0AbPBtnswnsECKVCS1FP56MXVGz/UkAYYhzLvs0v8bSpEd5vcN83GZb0l0OTB7TQY4Hq3mLa5GZek2B61Z/trJHXUpj52MLb0t79zpEINGAK/F3IVBiIh2w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761865687; c=relaxed/simple;
	bh=j5GduVofefqfrT1w+OyMLf9MO2ML8fYxeuxyLN2p9m8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UI5tARTNBbM9Vf8azn4F7G3V4jnLECEa6mNoWrhAiFCTEZqOLvi0gwze8WfZXGaihPLwcMGnDNwLETdzuagjclw7DrioVmGJTCVjbbSAP048GYpGgp8xlHYx3hftUVS/pfVBXgb9eBlXXOasSYZUPnmhA+bTgOO37IDwjXADM/w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=ddSu2IFT; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11023103.outbound.protection.outlook.com [40.93.196.103]) by mx-outbound46-114.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 30 Oct 2025 23:07:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xyg3or6PVJW0M8YiolUlyUNa1QOqYgBlB+FBJFndYo5m2dbeyneU1yJnykx0kvbTAQ8HPdb9EwF0HwtaLSQtLAG6pVZcVVxeWHXoXXYHwQ1Ckjgddr0+Wn/tYQ9nDczj287ztc4+HdDqynIg1xEuL30nAn/Bo4FONGR6aEwQ6Kqn3jEqC+tfizBCfzA1qh6Bg6QekwWKwBt2iUSMfnEiup1HOMYDq0p/dM9mcQNPCvu0paji22pk5zHyKjaKkWWegsv1pXlQBXgi8HuV9PUYGFgoE1uQzM370KN9ZjbuRyK9eMr4niLN58EpP8cTuQpq5yIqECaudIGfCxwpTxBYrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j5GduVofefqfrT1w+OyMLf9MO2ML8fYxeuxyLN2p9m8=;
 b=SrZKRQBLAMOUdQ624KST8UQ18ouGvLhHjNY/hRxTcEOHGFFN4xHz4pCkd/yb81jv5ZhojvaNDI0e1QolSD9e6Tksb/8LdeSqpDw1b3lsa31CY6IJeAltamm8c5kM0CrtqkUwsUwwOY43zD1wZVhJUEQpiiI4mmajcYiJM6dQmtiwzJ0TA0XHyXsVSEUYEj4ZoFG5p623MuS17Pz9WvW/+Q96Qm5NBnjf1/CcUrXmSUgBCZgwq1GLstBR8Pj7DPTxkiPEeyhff4IK9KZZnrgie5ugpF61UhrdKFe9jcQvDW+E7SIhlBpU/Jt/B8xKbJmLk4cfKFv9JiI6Rg0UVYclBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j5GduVofefqfrT1w+OyMLf9MO2ML8fYxeuxyLN2p9m8=;
 b=ddSu2IFTkR+Lln95BV1eTl9yvONMJChRKmRt2edJ2/mBtacKVmutevmODwGSRVx1MQEpoN2NDr9TevPSGDqhEZOWkmRwtykRfo3wVCmXKvJ7d4BfFVY5oYRdgQw0eQN32fnaC9tX9iUvpaniid3kNW+O5/XCzwPEcj2EfAzfFlM=
Received: from MN2PR19MB3872.namprd19.prod.outlook.com (2603:10b6:208:1e8::8)
 by DM6PR19MB4215.namprd19.prod.outlook.com (2603:10b6:5:2b4::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.15; Thu, 30 Oct
 2025 23:07:46 +0000
Received: from MN2PR19MB3872.namprd19.prod.outlook.com
 ([fe80::739:3aed:4ea0:3911]) by MN2PR19MB3872.namprd19.prod.outlook.com
 ([fe80::739:3aed:4ea0:3911%4]) with mapi id 15.20.9275.013; Thu, 30 Oct 2025
 23:07:46 +0000
From: Bernd Schubert <bschubert@ddn.com>
To: Joanne Koong <joannelkoong@gmail.com>, "miklos@szeredi.hu"
	<miklos@szeredi.hu>, "axboe@kernel.dk" <axboe@kernel.dk>
CC: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"asml.silence@gmail.com" <asml.silence@gmail.com>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>, "xiaobing.li@samsung.com"
	<xiaobing.li@samsung.com>, "csander@purestorage.com"
	<csander@purestorage.com>, "kernel-team@meta.com" <kernel-team@meta.com>
Subject: Re: [PATCH v2 2/8] fuse: refactor io-uring logic for getting next
 fuse request
Thread-Topic: [PATCH v2 2/8] fuse: refactor io-uring logic for getting next
 fuse request
Thread-Index: AQHcR5E1GpY/EJeQkUuq0zXvgqsu9bTbVN6A
Date: Thu, 30 Oct 2025 23:07:46 +0000
Message-ID: <481f7dc2-e6a3-4bfd-903a-9e3537f7a468@ddn.com>
References: <20251027222808.2332692-1-joannelkoong@gmail.com>
 <20251027222808.2332692-3-joannelkoong@gmail.com>
In-Reply-To: <20251027222808.2332692-3-joannelkoong@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR19MB3872:EE_|DM6PR19MB4215:EE_
x-ms-office365-filtering-correlation-id: 654b61e2-84ea-48f4-575e-08de18092393
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|19092799006|10070799003|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?RVkvbXBSM2hrRlhFVGlIOEQzMVhYVGh5WFRnZS9TZ3BmcGRQYmZKNVVDbjZa?=
 =?utf-8?B?a1BETlhsMnFvOUg4SXVRcXJQODh0dUdEUUFrVWVPZTh0ZzJRazlYTTR2V3Y3?=
 =?utf-8?B?VFJxQU9lMVpaUlMwZVpZZ3lZanBxL1hFZ0Y2TWNUbk82TG5Wb0YwdXY1QllG?=
 =?utf-8?B?OW52YnVuZjJEQzFUYkg1eFMyZXhyR0RRVTFUUCtZQTRhL2ZRUzdQK3VFRVZL?=
 =?utf-8?B?eGdzZG85OE5WWE1TSXpWdUVIWXgwQVMvaVJtdlJQVjB0Y3VYYVZVcGNIWTcy?=
 =?utf-8?B?THlxNWJSV0NvZTZnQVFpaU11Rmg3dnRFYll5a2tXSndHVGtuWTZTVmlMck1H?=
 =?utf-8?B?ZkYxRnhoMXIzNFpKSzdkRW1qVlk2YkZ6NmZFMFc2bjROZXdtenFOSHNiNFFZ?=
 =?utf-8?B?eFFwdWVPSDVvblBBY3JuNW11ZlBCZzZpWDJiUzJmTWl0ZkJnL0FoanNjZ0VS?=
 =?utf-8?B?V1gyV2htampuVUZiNVlnOWQwa0l1d3JMa01xaWhMVU9sK2JNT2MyQkZJYmVS?=
 =?utf-8?B?OVdyalVMSWR2UkRTR3p2V0l1Z1pYbzZEdGpjV2k0UlEyZllMUjFVcU9wUytH?=
 =?utf-8?B?UzMycUUyRVFuSFJtNHN3QzlWa0pHZ2Y0dFhJQzNlbHFRcnNjL0xCR29hZmt5?=
 =?utf-8?B?WHlidmdiVWZJVWc1dWV0aDdFMUV3SndUckhPVmJlWmg2aTRGeEtLNGl5aklx?=
 =?utf-8?B?ZGlHajJreEcyK01mOFFId1dOcDNTamhoSTFoTmRZcDdhdVpaeXdPdHRSeTNH?=
 =?utf-8?B?cjViL0pMQ1Nqd0VJM3lYTXN5d29kM3R1d0FvS0xtMUdFMVZVUFVKV0g5b2Nr?=
 =?utf-8?B?OTFzS1lhZmhrTnIxMEI3ZklQTUJ6NzhQK0FQbmg0Y3Ztb1pmK1oxZHUyZk83?=
 =?utf-8?B?T2s4L3NlS0FPWXdzMFFQVHhxeXB1VytVRUluUXJlRzcwT1c0MHU5RmNXajFq?=
 =?utf-8?B?bzI0NUJWcEdHYm0vVDVUYnRHQWdhdGd2eEdvUGVSU1h4OEl5NnR3OGlWUGpN?=
 =?utf-8?B?dUFLbG8wT0RHWkRHT1p2S1VORlJxM1dxSTRPUUdwbGxZZ1RYZzZjR09sT2d6?=
 =?utf-8?B?Z01qVlFNUVFNZ1pNeEE1ZHUzNGZZVWZsMllsR010ZU9nZVFCMGNXMjcwOVdo?=
 =?utf-8?B?RVdLcEpWZ0Q3VDFKejVwVXBVcHJONHR3NWF0bFdXYVgxWlhHcDE5ZGZjcEt4?=
 =?utf-8?B?cU1NUmJzTHBoNXExNTdselVvelJCdVJJZStSWVU2ZHhjL3hGUWdhRjRuRExK?=
 =?utf-8?B?VUFVazQrZGVQYnBScDdLdDJYNzY0YTN5ZTRRMUtITDFsbDhnUlFqTzdSNzN1?=
 =?utf-8?B?NFl5UzVHaDhyeE9kbDZ2Y3RXM3FKTWZkNThCVS9zdDV4WWpxQTU2eENmelha?=
 =?utf-8?B?OFRTN2ZlTnlkQmVYSVBVV1VkRnJoNWZVSzk4djVtdk1DN2dxRVFZbytQN25Z?=
 =?utf-8?B?M1pib2ZsalZsR3kxVzVuRlpCTWwzektMUzNzeE9xSnpCek5CNCtzZkJoTHlG?=
 =?utf-8?B?aUptWlBvaFFNM05seFJDUkpSdGREaXdKcnB2ZzZzTXREc0pOS3JjbytVK1Bi?=
 =?utf-8?B?WU9FayszMnBCaW51VHZmdndocVB0emtOV2FIZnNrVTZWNFVnMmFUcXdwSkR3?=
 =?utf-8?B?YUxhSzZ4aElQVTV2bDJRNGxkazdkemgrK3Y1TDV6c2FTQ3c4NHJocUZIYkxi?=
 =?utf-8?B?bVZXaTdkbWJpNEFJb1NRSE1qVmRaVW1XVFFFbmQ3emcwcDM3NVRpSHRCb3JW?=
 =?utf-8?B?Rmx6bVhOaUx5K2s0RUZsWjRpNXRzSm1zZm1neTZQM3NoUFBNdW55QU5yeGo1?=
 =?utf-8?B?NC9LWTljYmtxcVJrRlV2VjcvZG0rWEFvM010aHVTWktBdFFabUNMZ0RHSGFh?=
 =?utf-8?B?MGJycGJKQ2xXUDlwQlRPY2hSUGIvTTlZNDlGaC9TRTZobDN3b29yZmdONkt2?=
 =?utf-8?B?NzBTR0oyZm5PUWh3eWpra2lCdEc2U0U0WTVuK0xUb3RHWlVnSjhheHFRVDdY?=
 =?utf-8?B?ZDQ2TlF5UE5YbW1XdG5kWHEvSHd3ejVYaU83bFFpUXNtdFFXMlZHU0FOYml1?=
 =?utf-8?Q?uDxQGV?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR19MB3872.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(19092799006)(10070799003)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?K042NHIvL3ZsQlJEL21TOUF0bmN2aDhNeUgrazViMlh6QUdzSDZreENHUkUy?=
 =?utf-8?B?OGRrdUFwaTBjMHRmS090ck9YcGlLTXBUU0JLeXZQYnQzTGRSTmx4Rlc2VnNp?=
 =?utf-8?B?M0lhZkIwdmZGODJQa1oyL3JzZ1lkeGtudVRSYWZvd0QvWlpGNmYyWDFubmkz?=
 =?utf-8?B?VzZqZnZlTUovNncxL1N2U2hjMGtpd3diTDVJRzE0VzQ5U2FvclppVDlYSUFx?=
 =?utf-8?B?a0lxalRxelZHUGs0UFZWYjVJd3luQURyVGI3VmdCNWNKQkZCVC9QK2puOU5M?=
 =?utf-8?B?T1YyNmJVamNPS0N5aEduYUFkbEI5N2VOVnlUdFJhSVdNSWlDc0E4TTc1WFhZ?=
 =?utf-8?B?RVNjR2xaQXRwOU1kVjE4bS8wTlR5eVhkOHRkTVZJalVrdjI2UHJvbXMraG1o?=
 =?utf-8?B?djNZbkpmREdBeTFuLzRodFdFanh2VXJxLzN1eVdPejQ4b2UyVXFKQS9VU21i?=
 =?utf-8?B?QjQ5UytENTM3UXlJQmtBNWZweHNLZ3ZPd2c1QTZia0EySG1NN244MjE4SmJa?=
 =?utf-8?B?Z1YrVG9kTnFTVG43Mi9PTHlmbzEvOStlcGdJZDZyQjdzOW1nT2Y3UTUxRmpx?=
 =?utf-8?B?c01XVkxpcUZWKzB2ZFNpb08wMiszdHI2VVJRY2EyVFI5UGxpMVdWclZiS0ln?=
 =?utf-8?B?WFRybkkwQnZqbWdadGc4S0M0ei9PZDk2QkkxaTlPalpQUmtQSTlsVmoySllk?=
 =?utf-8?B?cjRpT3dhdWpZZy9TajVxT0FVRW5Td3ZyK2FPa1ZMVzBuSUlvdm5oZTVubTJH?=
 =?utf-8?B?ajNpaWIyTTdKdG5qS2xFenpWSWJMOXAxcVB2U25TZ1JZTnRTRnltcVNDM2k5?=
 =?utf-8?B?SmJnMzNNTnIwZ09iNlZKMXA4NWZoTElqOGxoMUY5bXVYRW9XNVQyTkxOWk1L?=
 =?utf-8?B?MU9LdHJDc1BDeEJWMkxlUGpmZVg5aS9hb1BmYjRiQUJXVGNUdld0dlV6NXo3?=
 =?utf-8?B?U1phdnArTDVRalJ4V1ZjTHJPWnRIdXpDU29hNzRGWUFJU0FwN0RiZ0xsaEhy?=
 =?utf-8?B?NytqdTdzTXFjSVNBamY1Zjh0S3hYNWZYb1U3eXgwS0dXR1hOL2paNFR2VmN2?=
 =?utf-8?B?aFBJUDVZQnNTZTl5T3VxcXJvUVV3dmx3Y2hQeFY2SldGQzdrNHFGbVhiaFY3?=
 =?utf-8?B?aEdmRkQyTHRKUkx4WnQwbWQrKzJ5dk9yVkpVZDMydnpjREhOSklpR2ViQWNV?=
 =?utf-8?B?VmNYM3JoSFJCTVFBSmlOZEI3MkFibkZ0dEw0NGxrM1hRL3VNbEVtMXZzUTFO?=
 =?utf-8?B?OWJ0WkR4dzZQR3FvWDdvV2JqNzlUMWpBc3FwWDRwcnFmMGQ0V29MdlMyTHIr?=
 =?utf-8?B?SmNJWnJ6aUFESFZXdWFYM3Jnd0xUR1lKSlAxeGpqQXhVMFh4RlYxd040Yklx?=
 =?utf-8?B?SC9zbnhJMGdzUG1RYXRKUTcvWTAxMjlldWlsRWxodkRpckx6ZG16WEZ0SnZJ?=
 =?utf-8?B?cVhkbXZkWFM4U3ZsOTBDNS83NXdNOW83Ym93V1o1MW0waldsKzJXYTYzWFIz?=
 =?utf-8?B?TDgydDhQbFMvV1RVTjQyMkNnWGcvc245dlNPdFQrdUVQOUk2WFh1MW1xQzF6?=
 =?utf-8?B?cVdHZndPRnZEbFBFVDYxa2dYeVRvMDEvVmsyY3JUT1NoZlVIQWVqZ3lZMmQx?=
 =?utf-8?B?TWZRY2MxQS8rYTNVSFh2STZRNEdTVnFwUXVGMzYwVkhuemRGbEZoTTNLUFZC?=
 =?utf-8?B?TXZ3bVRDSVllWkZZdWdFa2FqUGFvdCtpVklaZ0FVTUtNdjR1Rlh1aGtUdVpk?=
 =?utf-8?B?b0VOWmY4aCtqQzFqZ0RFNldEYjN5NTJsdTZUUzhVUEFndUlUcUtjM3BsbS8y?=
 =?utf-8?B?TWhRTzRobC9PWXZjKzZDemRkeVdJdzkrcFZqNXhwU3lTejlqeGgwNXEvVGI1?=
 =?utf-8?B?Y0JvRG1OVHBJREZzMERPVzJlcG52N0J3L2JlRVhiN0s0WG9Ja0ZiZWo5VjZv?=
 =?utf-8?B?YkRxeDlCaWlDb01FTjZzQTB4cmdDS3FlMEhYKzdITkE4enRMKzBkUnhWN05B?=
 =?utf-8?B?NjErdjdyeE91TUgwV0lZdGlrS0NqcGpNelhhR2dMWUE5N0pRMVlISnhFcXZu?=
 =?utf-8?B?bWI3QnhDMjVIZFdud0NMdy9ZaVFWZ3V1WlFGN1NTOFViYVc0MEhJaldlSWQv?=
 =?utf-8?B?NllmQzJIajk2NkFpYXBpUHBCUWhxejdIMzkzQnVBNWZkWTA1eFJIY0xhZ2NM?=
 =?utf-8?Q?BY1CtZIxIIw6a4xqB8ilyMk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F99AD32392EBCB499849110EA7054C06@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Z0is09nlJH1nPXadSnE7EoUrcGgJivtkOLEUIR5t5Ut6b6tUGC0ujzSZDsGaGuo8FDI57DJhAYtPMeyjFHz7Js847iRp/WqpUwmwruXco3ocye2T1NXddAknmIwYWKeHAwHb914xO5KO5IzpyYa8xlUCVmC932YAlodQU0hFsVsrDDP89hCMa94k5Lh9FNFUm1egPYH4B18dQL1L6kk41RBmGqHzG/LYHn5TkNlLZW0rqGjeYC7w4VAvO5FAr1mSAsxXAdv/Kr/B0Nhe8QP05mkboSKP6cN4WFVCNtVKa3qvQjzSMH1unlBvC/vkggB9QBLN/M5ASdP9RsF3qxkZ7wYp2+6Sq9yVvyWdDGPD2yKXSWyCZoRjPFmOaHHlTeLmGkJ7k2sQ/PwONBfGWxOOQ4YihNJJJXxAEgqpCVK3m+j22IsBPbF9Cs66IHFM0YY6cR75pNleKNNJIfq/GtUohv4nJCrgyvJY+U8PzYic7Pv+NioWHrXbhLyV/2lEsWfMy+K5CmCHmbL1KIALEpLOSi8rpIz0sJOknpUymdlwrEoeZwrI7Bu9nzSJqy9ocalt2OYTr1SNlJMCHMvZADgvKKdREKqfN+IaqiYAG+55Rpdh+PSXnKtTHU8sPxWE0j1GMMGTatyTczgqXrGVUkR8xw==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR19MB3872.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 654b61e2-84ea-48f4-575e-08de18092393
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2025 23:07:46.3698
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qZ1fx6SMbFY+W3bK4enw5mt6n8FGn/a2tGNCsAX/Qhgw1IVrdn8b55npwrqvooTRbBH1Mh6Cwj05V7qxwhW06g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR19MB4215
X-BESS-ID: 1761865668-111890-23126-2664-1
X-BESS-VER: 2019.1_20251001.1803
X-BESS-Apparent-Source-IP: 40.93.196.103
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKViYWRkZAVgZQMNUkNTElLS0tJd
	HU0CItyTTV0NzQ0NQk0TQl0cDC1CJVqTYWAPUsc1NBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.268593 [from 
	cloudscan13-197.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

T24gMTAvMjcvMjUgMjM6MjgsIEpvYW5uZSBLb29uZyB3cm90ZToNCj4gU2ltcGxpZnkgdGhlIGxv
Z2ljIGZvciBnZXR0aW5nIHRoZSBuZXh0IGZ1c2UgcmVxdWVzdC4NCj4gDQo+IFNpZ25lZC1vZmYt
Ynk6IEpvYW5uZSBLb29uZyA8am9hbm5lbGtvb25nQGdtYWlsLmNvbT4NCj4gLS0tDQo+ICBmcy9m
dXNlL2Rldl91cmluZy5jIHwgNzggKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMjggaW5zZXJ0aW9ucygrKSwgNTAgZGVsZXRp
b25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZnMvZnVzZS9kZXZfdXJpbmcuYyBiL2ZzL2Z1c2Uv
ZGV2X3VyaW5nLmMNCj4gaW5kZXggZjZiMTJhZWJiOGJiLi40MTU5MjRiMzQ2YzAgMTAwNjQ0DQo+
IC0tLSBhL2ZzL2Z1c2UvZGV2X3VyaW5nLmMNCj4gKysrIGIvZnMvZnVzZS9kZXZfdXJpbmcuYw0K
PiBAQCAtNzEwLDM0ICs3MTAsNiBAQCBzdGF0aWMgaW50IGZ1c2VfdXJpbmdfcHJlcGFyZV9zZW5k
KHN0cnVjdCBmdXNlX3JpbmdfZW50ICplbnQsDQo+ICAJcmV0dXJuIGVycjsNCj4gIH0NCj4gIA0K
PiAtLyoNCj4gLSAqIFdyaXRlIGRhdGEgdG8gdGhlIHJpbmcgYnVmZmVyIGFuZCBzZW5kIHRoZSBy
ZXF1ZXN0IHRvIHVzZXJzcGFjZSwNCj4gLSAqIHVzZXJzcGFjZSB3aWxsIHJlYWQgaXQNCj4gLSAq
IFRoaXMgaXMgY29tcGFyYWJsZSB3aXRoIGNsYXNzaWNhbCByZWFkKC9kZXYvZnVzZSkNCj4gLSAq
Lw0KPiAtc3RhdGljIGludCBmdXNlX3VyaW5nX3NlbmRfbmV4dF90b19yaW5nKHN0cnVjdCBmdXNl
X3JpbmdfZW50ICplbnQsDQo+IC0JCQkJCXN0cnVjdCBmdXNlX3JlcSAqcmVxLA0KPiAtCQkJCQl1
bnNpZ25lZCBpbnQgaXNzdWVfZmxhZ3MpDQo+IC17DQo+IC0Jc3RydWN0IGZ1c2VfcmluZ19xdWV1
ZSAqcXVldWUgPSBlbnQtPnF1ZXVlOw0KPiAtCWludCBlcnI7DQo+IC0Jc3RydWN0IGlvX3VyaW5n
X2NtZCAqY21kOw0KPiAtDQo+IC0JZXJyID0gZnVzZV91cmluZ19wcmVwYXJlX3NlbmQoZW50LCBy
ZXEpOw0KPiAtCWlmIChlcnIpDQo+IC0JCXJldHVybiBlcnI7DQo+IC0NCj4gLQlzcGluX2xvY2so
JnF1ZXVlLT5sb2NrKTsNCj4gLQljbWQgPSBlbnQtPmNtZDsNCj4gLQllbnQtPmNtZCA9IE5VTEw7
DQo+IC0JZW50LT5zdGF0ZSA9IEZSUlNfVVNFUlNQQUNFOw0KPiAtCWxpc3RfbW92ZV90YWlsKCZl
bnQtPmxpc3QsICZxdWV1ZS0+ZW50X2luX3VzZXJzcGFjZSk7DQo+IC0Jc3Bpbl91bmxvY2soJnF1
ZXVlLT5sb2NrKTsNCj4gLQ0KPiAtCWlvX3VyaW5nX2NtZF9kb25lKGNtZCwgMCwgaXNzdWVfZmxh
Z3MpOw0KPiAtCXJldHVybiAwOw0KPiAtfQ0KPiAtDQo+ICAvKg0KPiAgICogTWFrZSBhIHJpbmcg
ZW50cnkgYXZhaWxhYmxlIGZvciBmdXNlX3JlcSBhc3NpZ25tZW50DQo+ICAgKi8NCj4gQEAgLTgz
NCwxMSArODA2LDEzIEBAIHN0YXRpYyB2b2lkIGZ1c2VfdXJpbmdfY29tbWl0KHN0cnVjdCBmdXNl
X3JpbmdfZW50ICplbnQsIHN0cnVjdCBmdXNlX3JlcSAqcmVxLA0KPiAgfQ0KPiAgDQo+ICAvKg0K
PiAtICogR2V0IHRoZSBuZXh0IGZ1c2UgcmVxIGFuZCBzZW5kIGl0DQo+ICsgKiBHZXQgdGhlIG5l
eHQgZnVzZSByZXEuDQo+ICsgKg0KPiArICogUmV0dXJucyB0cnVlIGlmIHRoZSBuZXh0IGZ1c2Ug
cmVxdWVzdCBoYXMgYmVlbiBhc3NpZ25lZCB0byB0aGUgZW50Lg0KPiArICogRWxzZSwgdGhlcmUg
aXMgbm8gbmV4dCBmdXNlIHJlcXVlc3QgYW5kIHRoaXMgcmV0dXJucyBmYWxzZS4NCj4gICAqLw0K
PiAtc3RhdGljIHZvaWQgZnVzZV91cmluZ19uZXh0X2Z1c2VfcmVxKHN0cnVjdCBmdXNlX3Jpbmdf
ZW50ICplbnQsDQo+IC0JCQkJICAgICBzdHJ1Y3QgZnVzZV9yaW5nX3F1ZXVlICpxdWV1ZSwNCj4g
LQkJCQkgICAgIHVuc2lnbmVkIGludCBpc3N1ZV9mbGFncykNCj4gK3N0YXRpYyBib29sIGZ1c2Vf
dXJpbmdfZ2V0X25leHRfZnVzZV9yZXEoc3RydWN0IGZ1c2VfcmluZ19lbnQgKmVudCwNCj4gKwkJ
CQkJIHN0cnVjdCBmdXNlX3JpbmdfcXVldWUgKnF1ZXVlKQ0KPiAgew0KPiAgCWludCBlcnI7DQo+
ICAJc3RydWN0IGZ1c2VfcmVxICpyZXE7DQo+IEBAIC04NTAsMTAgKzgyNCwxMiBAQCBzdGF0aWMg
dm9pZCBmdXNlX3VyaW5nX25leHRfZnVzZV9yZXEoc3RydWN0IGZ1c2VfcmluZ19lbnQgKmVudCwN
Cj4gIAlzcGluX3VubG9jaygmcXVldWUtPmxvY2spOw0KPiAgDQo+ICAJaWYgKHJlcSkgew0KPiAt
CQllcnIgPSBmdXNlX3VyaW5nX3NlbmRfbmV4dF90b19yaW5nKGVudCwgcmVxLCBpc3N1ZV9mbGFn
cyk7DQo+ICsJCWVyciA9IGZ1c2VfdXJpbmdfcHJlcGFyZV9zZW5kKGVudCwgcmVxKTsNCj4gIAkJ
aWYgKGVycikNCj4gIAkJCWdvdG8gcmV0cnk7DQo+ICAJfQ0KPiArDQo+ICsJcmV0dXJuIHJlcSAh
PSBOVUxMOw0KPiAgfQ0KPiAgDQo+ICBzdGF0aWMgaW50IGZ1c2VfcmluZ19lbnRfc2V0X2NvbW1p
dChzdHJ1Y3QgZnVzZV9yaW5nX2VudCAqZW50KQ0KPiBAQCAtODcxLDYgKzg0NywyMCBAQCBzdGF0
aWMgaW50IGZ1c2VfcmluZ19lbnRfc2V0X2NvbW1pdChzdHJ1Y3QgZnVzZV9yaW5nX2VudCAqZW50
KQ0KPiAgCXJldHVybiAwOw0KPiAgfQ0KPiAgDQo+ICtzdGF0aWMgdm9pZCBmdXNlX3VyaW5nX3Nl
bmQoc3RydWN0IGZ1c2VfcmluZ19lbnQgKmVudCwgc3RydWN0IGlvX3VyaW5nX2NtZCAqY21kLA0K
PiArCQkJICAgIHNzaXplX3QgcmV0LCB1bnNpZ25lZCBpbnQgaXNzdWVfZmxhZ3MpDQo+ICt7DQo+
ICsJc3RydWN0IGZ1c2VfcmluZ19xdWV1ZSAqcXVldWUgPSBlbnQtPnF1ZXVlOw0KPiArDQo+ICsJ
c3Bpbl9sb2NrKCZxdWV1ZS0+bG9jayk7DQo+ICsJZW50LT5zdGF0ZSA9IEZSUlNfVVNFUlNQQUNF
Ow0KPiArCWxpc3RfbW92ZV90YWlsKCZlbnQtPmxpc3QsICZxdWV1ZS0+ZW50X2luX3VzZXJzcGFj
ZSk7DQo+ICsJZW50LT5jbWQgPSBOVUxMOw0KPiArCXNwaW5fdW5sb2NrKCZxdWV1ZS0+bG9jayk7
DQo+ICsNCj4gKwlpb191cmluZ19jbWRfZG9uZShjbWQsIHJldCwgaXNzdWVfZmxhZ3MpOw0KPiAr
fQ0KPiArDQo+ICAvKiBGVVNFX1VSSU5HX0NNRF9DT01NSVRfQU5EX0ZFVENIIGhhbmRsZXIgKi8N
Cj4gIHN0YXRpYyBpbnQgZnVzZV91cmluZ19jb21taXRfZmV0Y2goc3RydWN0IGlvX3VyaW5nX2Nt
ZCAqY21kLCBpbnQgaXNzdWVfZmxhZ3MsDQo+ICAJCQkJICAgc3RydWN0IGZ1c2VfY29ubiAqZmMp
DQo+IEBAIC05NDIsNyArOTMyLDggQEAgc3RhdGljIGludCBmdXNlX3VyaW5nX2NvbW1pdF9mZXRj
aChzdHJ1Y3QgaW9fdXJpbmdfY21kICpjbWQsIGludCBpc3N1ZV9mbGFncywNCj4gIAkgKiBhbmQg
ZmV0Y2hpbmcgaXMgZG9uZSBpbiBvbmUgc3RlcCB2cyBsZWdhY3kgZnVzZSwgd2hpY2ggaGFzIHNl
cGFyYXRlZA0KPiAgCSAqIHJlYWQgKGZldGNoIHJlcXVlc3QpIGFuZCB3cml0ZSAoY29tbWl0IHJl
c3VsdCkuDQo+ICAJICovDQo+IC0JZnVzZV91cmluZ19uZXh0X2Z1c2VfcmVxKGVudCwgcXVldWUs
IGlzc3VlX2ZsYWdzKTsNCj4gKwlpZiAoZnVzZV91cmluZ19nZXRfbmV4dF9mdXNlX3JlcShlbnQs
IHF1ZXVlKSkNCj4gKwkJZnVzZV91cmluZ19zZW5kKGVudCwgY21kLCAwLCBpc3N1ZV9mbGFncyk7
DQo+ICAJcmV0dXJuIDA7DQo+ICB9DQo+ICANCj4gQEAgLTExOTAsMjAgKzExODEsNiBAQCBpbnQg
ZnVzZV91cmluZ19jbWQoc3RydWN0IGlvX3VyaW5nX2NtZCAqY21kLCB1bnNpZ25lZCBpbnQgaXNz
dWVfZmxhZ3MpDQo+ICAJcmV0dXJuIC1FSU9DQlFVRVVFRDsNCj4gIH0NCj4gIA0KPiAtc3RhdGlj
IHZvaWQgZnVzZV91cmluZ19zZW5kKHN0cnVjdCBmdXNlX3JpbmdfZW50ICplbnQsIHN0cnVjdCBp
b191cmluZ19jbWQgKmNtZCwNCj4gLQkJCSAgICBzc2l6ZV90IHJldCwgdW5zaWduZWQgaW50IGlz
c3VlX2ZsYWdzKQ0KPiAtew0KPiAtCXN0cnVjdCBmdXNlX3JpbmdfcXVldWUgKnF1ZXVlID0gZW50
LT5xdWV1ZTsNCj4gLQ0KPiAtCXNwaW5fbG9jaygmcXVldWUtPmxvY2spOw0KPiAtCWVudC0+c3Rh
dGUgPSBGUlJTX1VTRVJTUEFDRTsNCj4gLQlsaXN0X21vdmVfdGFpbCgmZW50LT5saXN0LCAmcXVl
dWUtPmVudF9pbl91c2Vyc3BhY2UpOw0KPiAtCWVudC0+Y21kID0gTlVMTDsNCj4gLQlzcGluX3Vu
bG9jaygmcXVldWUtPmxvY2spOw0KPiAtDQo+IC0JaW9fdXJpbmdfY21kX2RvbmUoY21kLCByZXQs
IGlzc3VlX2ZsYWdzKTsNCj4gLX0NCj4gLQ0KPiAgLyoNCj4gICAqIFRoaXMgcHJlcGFyZXMgYW5k
IHNlbmRzIHRoZSByaW5nIHJlcXVlc3QgaW4gZnVzZS11cmluZyB0YXNrIGNvbnRleHQuDQo+ICAg
KiBVc2VyIGJ1ZmZlcnMgYXJlIG5vdCBtYXBwZWQgeWV0IC0gdGhlIGFwcGxpY2F0aW9uIGRvZXMg
bm90IGhhdmUgcGVybWlzc2lvbg0KPiBAQCAtMTIxOSw4ICsxMTk2LDkgQEAgc3RhdGljIHZvaWQg
ZnVzZV91cmluZ19zZW5kX2luX3Rhc2soc3RydWN0IGlvX3VyaW5nX2NtZCAqY21kLA0KPiAgCWlm
ICghKGlzc3VlX2ZsYWdzICYgSU9fVVJJTkdfRl9UQVNLX0RFQUQpKSB7DQo+ICAJCWVyciA9IGZ1
c2VfdXJpbmdfcHJlcGFyZV9zZW5kKGVudCwgZW50LT5mdXNlX3JlcSk7DQo+ICAJCWlmIChlcnIp
IHsNCj4gLQkJCWZ1c2VfdXJpbmdfbmV4dF9mdXNlX3JlcShlbnQsIHF1ZXVlLCBpc3N1ZV9mbGFn
cyk7DQo+IC0JCQlyZXR1cm47DQo+ICsJCQlpZiAoIWZ1c2VfdXJpbmdfZ2V0X25leHRfZnVzZV9y
ZXEoZW50LCBxdWV1ZSkpDQo+ICsJCQkJcmV0dXJuOw0KPiArCQkJZXJyID0gMDsNCj4gIAkJfQ0K
PiAgCX0gZWxzZSB7DQo+ICAJCWVyciA9IC1FQ0FOQ0VMRUQ7DQoNCkxHVE0NCg0KKEkgaGFkIGFs
cmVhZHkgc3RhcnQgdG8gZ28gaW50byB0aGlzIGRpcmVjdGlvbg0KaHR0cHM6Ly9sb3JlLmtlcm5l
bC5vcmcvYWxsLzIwMjUwNDAzLWZ1c2UtaW8tdXJpbmctdHJhY2UtcG9pbnRzLXYzLTMtMzUzNDBh
YTMxZDljQGRkbi5jb20vKQ0KDQoNClJldmlld2VkLWJ5OiBCZXJuZCBTY2h1YmVydCA8YnNjaHVi
ZXJ0QGRkbi5jb20+DQo=

