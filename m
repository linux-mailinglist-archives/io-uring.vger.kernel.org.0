Return-Path: <io-uring+bounces-3198-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D099979E0A
	for <lists+io-uring@lfdr.de>; Mon, 16 Sep 2024 11:12:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9FFAD1F24DCA
	for <lists+io-uring@lfdr.de>; Mon, 16 Sep 2024 09:12:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2A5914D2A3;
	Mon, 16 Sep 2024 09:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b="Bkf/wCSP"
X-Original-To: io-uring@vger.kernel.org
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2068.outbound.protection.outlook.com [40.107.241.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 966C2149C4D
	for <io-uring@vger.kernel.org>; Mon, 16 Sep 2024 09:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.241.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726477867; cv=fail; b=Sn+2lml5kDdo0JtRyELM7kh+uxxwZwyTSkjjjirrTMDqCYhSRPXNx4Gmo++twguzOEX5Kt6Jy7LHyteBp0cbjZLVGfy1BvzqfO+StRZPyXaVtyRWmj0su/C8SdVMaUdXoyZF9RO+TiynF5o3S9R0WYJF9Ln7UeDK3e/qiYWMlKU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726477867; c=relaxed/simple;
	bh=/XMm2YwnJ7xWXtVy69qmMC2luB6h0bHWstabO/aRtEA=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dt66JyIokzWOSbwvRs11sU/SThSBam/vHoYqElDRkl61KuDwZmMvATrxWj9cVV1MRpPCnpFRiw/xUQYkez3nc1qXclo9tnwW5XORdfc6lS54OtLInjmhjfc7XLk2ylYmHsaKhk595uX2T+GZFwnibfPr+MgFBcIKBAwl0t6SEb0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com; spf=pass smtp.mailfrom=siemens.com; dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b=Bkf/wCSP; arc=fail smtp.client-ip=40.107.241.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=siemens.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fz/37tdNtmcOqWqlJ3CCfqz9cxL9S5ClSTuPgnXuRn9votfji5NOcjqDows8DpTtTVqO5c68pvsfdt7wfM23ZDQdWg9pdFT6ykHK4tm5jF2RN3KKixNSz/zXOVtkpQWlUpxvQyahJYPa/6D8suwOg6GO3XqbiQQhdSgqp+7u/qBHoH26L8eX0YEkYu60IzpCcucd+31ovS8U2ebNFm36cZbpKPviqvpC+Otz9pUzG3KiUyNwlC+VdUePsxyo3LhQU3gTuvzY2PoMqubpYrRd0/DkgZLKcCVWO4GmUxWzXzZ7ZAr8m2qxV9EBWeRBXCa/PCJXvLEBe2VmggyiwlMwPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/XMm2YwnJ7xWXtVy69qmMC2luB6h0bHWstabO/aRtEA=;
 b=Sz4y21HS3W8U2ZkqIofobcdanoec1NrvyzNU5GJAXlIF0I9O/G6radYwu7G0iLojJKC6ReeGSZxfHn/hiU4JMYDivSjDEuZ9L/FIJdZJBSJkaGm0HzOCwQ6HKK0HLkGOR2RZ+4kslDCS2w/xTPTP+KEtqfXyEFryxUhyPtXUE8eF3w5MqHrij9JY1Yqp4aG03aKplq56y3ScpmljqYxvaJch+veQoEJ088xr8Szg+895BSz6k1vRJpL4WHI4aqfIvz/loxX+MDPlRJQETK2IHHQlx1pEIOggmdJYxon5Za5r1XHTQ7lSobrrBBJemUS4IJsqgLblygpTcNVcUwFjJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/XMm2YwnJ7xWXtVy69qmMC2luB6h0bHWstabO/aRtEA=;
 b=Bkf/wCSPx2Ny/F1oB2WNfQqJ+M0Ms2o4bXkZeinWBDbZzZfBcmVdvtsWF+awF+/dR2ANnMBUcVt0t45nqRhPMOC77Zoro6ILjMmJikwf3H6YqCY2145+fb9I4SCMvoNe2YxCUKrSJQaZcBpbtqs1tIFHQYI9TJG57tqt2Wkp0XjwoNfMVvvnezrfgVKF+cSweydXBYN/4ydetogy2vsImaIYeF87tZO8UbMOvNdDeA3JU0ySc6dwh2Zm4PRbbNE0+cN/h/BKwE3dEHvldNZNKQN2Pwq+hww9Ju67lg1ovnIae6li2LzUF9GOYzk1j0YresZhTvF9EaZd18m/jIAqZg==
Received: from DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:47f::13)
 by VI0PR10MB8470.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:800:235::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.23; Mon, 16 Sep
 2024 09:11:01 +0000
Received: from DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8198:b4e0:8d12:3dfe]) by DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8198:b4e0:8d12:3dfe%4]) with mapi id 15.20.7962.022; Mon, 16 Sep 2024
 09:11:01 +0000
From: "MOESSBAUER, Felix" <felix.moessbauer@siemens.com>
To: "axboe@kernel.dk" <axboe@kernel.dk>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>
Subject: Re: [PATCH] io_uring/sqpoll: retain test for whether the CPU is valid
Thread-Topic: [PATCH] io_uring/sqpoll: retain test for whether the CPU is
 valid
Thread-Index: AQHbCBfVn3rIkz/csUue+4cH53HPPbJaIIEA
Date: Mon, 16 Sep 2024 09:11:01 +0000
Message-ID: <6c5bf2c20fb540ec3e3790f67b1f728f24d552ee.camel@siemens.com>
References: <36b09a00-9f72-4ef2-8f73-79b2ba99b11c@kernel.dk>
In-Reply-To: <36b09a00-9f72-4ef2-8f73-79b2ba99b11c@kernel.dk>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.46.4-2+intune 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DU0PR10MB6828:EE_|VI0PR10MB8470:EE_
x-ms-office365-filtering-correlation-id: ff64d45f-6d8e-46cb-0bbc-08dcd62f7bf8
x-ms-exchange-atpmessageproperties: SA
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?VHFQRnlYK2FyS2FtblN3SnJkTXEwN21jOFVCdHAvNWEzSnNtZXpjSE9WMGRk?=
 =?utf-8?B?WC9uM1dwL1dQa3dRN1YxYzlsbndhcWlsVWJEaGtQRkRKbjhkbGpndGxUVzFl?=
 =?utf-8?B?bVpzdnJMWlZlNFVMb2xDYnp0M3JXT3UydDYyR3NCRUJ0dVBVUXp4TWNQdklJ?=
 =?utf-8?B?MmY4ZlRicTZDUFl1VkVCL093TnJTMXFSYnBxb2dYdWRwVWgwclAyaEFva0cv?=
 =?utf-8?B?YnNTNzRCTUV0ZmJWQVB0SFh0QTFmY1ZDRGducTZTbytNUXJWUzVwamdoY2xP?=
 =?utf-8?B?c2pxMzEvYVFhMzE0UUp5ajNuUlN5Z2R6bkM0dmZ3aWNWejhaa2dIUjF2R2VT?=
 =?utf-8?B?dHhyQU55YVpONEo1ajdaSXlndmpRWnJZWUN3d0UrNjVKYnBBZ1A4eTZsY0g2?=
 =?utf-8?B?Q012Y1JQRk5WV1RHV0lCdlFkM3Rjc0lxNkNXSEdqUTVGaXpRT1NEYVFDTUVZ?=
 =?utf-8?B?cEFpaWs4eG9aSnRlNjBscHg1M0RZaDBLUWplWTQrQzNYTno5QXV0Z3RnS0o3?=
 =?utf-8?B?LzJSMW5NUThOR0FIVDVaUmJXUlBUYUROdDRTOHh0bVRaVUllR1RRV3BPamZ2?=
 =?utf-8?B?dE56eWZPQTVXcXpJNDlKaCtEUFJBaVhtNXl3Zk12VFdIR2RrQ3lGU1VMaVZ4?=
 =?utf-8?B?WHdWY1ZZbzl1elpKaVVyUkhJYnYxOWhmakdVc3hNRXpNQWR4QVdkSFk3azJE?=
 =?utf-8?B?bUp5bnpKeEJtRHpqbTFrdC83RndhWEtIUlM1c3VkV2wyYXVLNnAzMlRYZ09y?=
 =?utf-8?B?NTVLNFRDdGdjRUMrK00zUDVsUG9xSGZZSDBRSkZTdVBJN1JSZzhXWW5oL1hN?=
 =?utf-8?B?bGpNY0grS3Jma1hvTWEvMERXa01Qc3dLMGpqV08raitWQndQWGYwUUlORDgx?=
 =?utf-8?B?TWR4K2cvU3IrTGRTMEF5d2FtOGFmNkVmaU5hd0ptdkQyczRpSnhIbTJvbTJu?=
 =?utf-8?B?STNxWmhVRngzTHR0UjErSGNaOVN1OEVISUJaUEZtVUdNVlRMc1kzSXdMMG12?=
 =?utf-8?B?eHErNndJWnNkQjh2eUZwK2ZnNGhpQjNLUjlIY0k1aVJxV3QrTzk2RUY0Y1kw?=
 =?utf-8?B?SDhsWXVCbk9ZVHJ5a2tkdFlSQ1dodDhlWndWMVFudUhicm1YRGNJZzhSdEI1?=
 =?utf-8?B?U1dVUmJSNHVQNUlJbHd6bkIxeE44clFzbGV0dFdjTHBhM2xTRVhnTmdiei9T?=
 =?utf-8?B?endqVUJ1eUNuVjlRZ1dkOHc2d21vaFd1SnJkQXZ3VUw1ZFcxMjU4M3kxRGJI?=
 =?utf-8?B?NE55QnFBSXJZWW9PUU44blhEMWRCUS90c1h5ZXZhQU40WnorTTVzWEJlWGVY?=
 =?utf-8?B?YStVbGYvajR2VEV4d2xJSkFEOVpMRUJHOVNJUjFWYmdEOE5sdjJIYzh4VkYy?=
 =?utf-8?B?SDY4MXd0Vkp2VUI5M1RZK2NnVGl1dmF5eEFEMm1WbU4xR1V5bUVWMnF2cGhX?=
 =?utf-8?B?UlVpNnZ4bGQ4VGNWMVE4YVh6by9FQlFxUlZhTVg3VEJvTEZXbmE2MmV0V1Mz?=
 =?utf-8?B?WVpITVp3ZlErQyt5RVNuSUQ1ZWdvcmtuRjNrcVFPRk9vczBpZCtnLzc0SVBU?=
 =?utf-8?B?WWpvUHVtRmVyRERsamt3SzhieUdkYmp5UGdUV2lHb0FaeWpicy9FMEhPMTBF?=
 =?utf-8?B?djZ2b2lISVRjVzhKVlF6Ni9ZdEwyVS91ajE5aG5vQjBxTDhJKzVRaDl3ZEFn?=
 =?utf-8?B?ZVBMRkRGMlQzTHNma2JQTWUveGFncVdJNzdRKzQ0WjI4Y25RLzlMK09TSkJm?=
 =?utf-8?B?MmtQUDJuSFVGWmlqc0Z0VU5TbVpnZTZ1Vk5BR2FyOE1xajhkK21FOHBJa0dj?=
 =?utf-8?B?UkZQNXdxK3JSM041alZ3cVg3RCtFU3lkVUZtWFJhQXIveU5UcDFFTmJZc2l5?=
 =?utf-8?B?OXBQbXBVanBRMEVYSWRoSHhxV2pPVnE5VnNaZHZUSWpaU2c9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?QXVQTlZvdy9JcjhXeHc3SVZ1dkRkRFFjSm80ejJSSXEwN0xtWW50eTNqUXpi?=
 =?utf-8?B?REVITXNlQzJ0eWpOclJNd1V2ZGZGaWhSUFViSWNDaFBnS2lEazBRaE12R1lJ?=
 =?utf-8?B?YThsRTZYdzhaTU5hdTFNQWo3QU9raHJtejNZcFloa2N6c1h1WGFQanhRTmJt?=
 =?utf-8?B?ZzNTckJDeTR5b0ZGL3F1bHc3REpKOEd0RHFBazM4ckhEeXFvMVNrbU8ySmtu?=
 =?utf-8?B?NWFxdEN5QXNUR3Q0dEhBNkZqZ1VDZk1DMzBKNFdaY0NLSzBrWGFPRHViMW1K?=
 =?utf-8?B?dGQ4d0lmZnBGWEJoUUxGY3lKKzlHUzJVT2N2ZTJYTHlGUmI2L3p4WncvenB6?=
 =?utf-8?B?UUJVUUw5clNuNnFiWEk3bjJJYi9OVmVzSUVHOU9lQUt0dkJyaEYrVURlbTVP?=
 =?utf-8?B?OTBoajRubHRoMUFYZlNzNndzbGRjdTVFd2E3bVlyWXl0OU1JY084OGJYR3RM?=
 =?utf-8?B?cjkybjIyRVlpSm9ybFRsUTNCQU1MM1BjSE10blFJVzljT1c4bEM0Y1hEN0lt?=
 =?utf-8?B?OTVyUGhYT1hTcE1QbHc2SmdnSUd5YjNLMWo1SWwrZVc3MFJVOUFBTzJDSTd5?=
 =?utf-8?B?WWNEWmFvZCtkTGxTZ1h6WmV0OXJqelQ5dHBnc3QzSDZ0aG5pOUFPWG14MnUz?=
 =?utf-8?B?RUN4UHJQZzlQRU1VejBsVXRqdHo2MnRueVRra2RucEtYUzJibThSVTRMV3VX?=
 =?utf-8?B?TE01WHQvc3ZqSkdmdVRhdkFydkVVUXZiOTgrNjJsa2k0RlcvUkozMmV6SE55?=
 =?utf-8?B?SjE4eWxwRHBPb3J1T1QwV2VMSkJqRXNtRmtGWEV2V01KaFM0VEl5T0dDaDgv?=
 =?utf-8?B?d1NBRjdUL1dKSk5IMTBYRzJMQ0w3NkxtUUJQZ0NPTEhPYkpHL2hGekJYeUNq?=
 =?utf-8?B?NzRGd1FoVEpxVXBqT1J0WFhGSUUwUlZMdzRaTERUUS9Yb0RBK094VTVjUmdr?=
 =?utf-8?B?b1BDMUZiTUVRL2xxU1VHUjVTaUNHdWpKR29ISnZHbDFGSlVkbkFuMGZVL0E2?=
 =?utf-8?B?MDQwZjdTeG1qRE8zTEFSVkNTc3BqM3VPNzFqR0MzeHVmUTd1YVpsYzVHdWsz?=
 =?utf-8?B?bUc1aHdGOVFpdE9JN1oweTYvcS9ORHdVTFdDYTYyell2bWpGR2VaeTIwc3ZC?=
 =?utf-8?B?VUpYTTJwQlF4U2E4cFg3RG52R1lmalN0ckFYNWI3VVcvRGxDUUtoTjlzR0wr?=
 =?utf-8?B?cGpyOW9WeEhScmR2SjdQT0NDS0h0TVFFY3hxNisxeDdjczREcWNNYUpaS3R1?=
 =?utf-8?B?YkMydFdFTmVTRWRSSVRKR3VuSTA5MEZtbDJXTVZ0Vm9pUWh6RXFCWVJ2MUdF?=
 =?utf-8?B?YVl1Y1NKL2NWNk8zckhWY3c5OGorZzVaWjlDYmF3cDIwUG1leEtsRkFRUGcy?=
 =?utf-8?B?WkhRay9QMFJoTUFSWmUrZ0xuaElKNE1LYXNuUW1wbTEybEtTMnljaEs2Z0Qv?=
 =?utf-8?B?VkRQU1IyOUdsR2NDSytTMVlmNGxGZmFNTWJ5SWJvRHZtZlRJenowN3UyZ1J2?=
 =?utf-8?B?Tjl0Vm4rVDh0a2xaTU5uUDBFSWFRZWlSSTREL3BpbkluS2phUTVCWnNkMUtZ?=
 =?utf-8?B?RlJWUlh3UzJ0WGJiR0E5aCsvYXJqeEtoeTdibUp2VGUzcnpEQkJaNmYvTWht?=
 =?utf-8?B?QkhOSkZNQlBEMWRNNVFOSFQxVkRZSkpzOWd6dmlGdjhhRzBFMkhUcUlkclN6?=
 =?utf-8?B?Q1locVR3R084cUZlVitSTWd1Tjl2YlhpTXBnSlBiMTN3Q1hTZHVlM2lKUm1Q?=
 =?utf-8?B?RTk5L1lpSFpEdUo3RzB3TzhzNHpJVWwzeTRXeWxNREZpTGtPWGhQOTFVNm51?=
 =?utf-8?B?cVNDZHpPZzVnUEJVTzNIbzlpTVhoUmtyRVlpRFVKQkwyNGd4QjQxWW8ySDZi?=
 =?utf-8?B?ZHVWQVRwMmlZdFU2T1RFRk56TEJsUFFYeDV2d0ZKTmp4L1ZnbDM4YVY2VUdk?=
 =?utf-8?B?Y0NseXI1MDBKVVl2SzVFUktlekMwM2FBdEdYMHpaYnNSYkJVWTZ3elFjL0NY?=
 =?utf-8?B?aGk4QUREMktZNzhTLzRaV2JWMDVpOWVETVRzNEt5NVVHY1Q5UlhmWkdwQlN1?=
 =?utf-8?B?MlZSUzBSV01XMmlMdWh6L1hGYThoeHFEUGZ0Y1JaWFhyTi9pZVVRU3pMc3ZF?=
 =?utf-8?B?dEc4cjU4VTl6SjFBMFNnbmNkckhXRFMyR0ZLYnNSWjc4YVVHZHBGdHhJLzV2?=
 =?utf-8?B?T1hiY0U2RjBzZi80VTU4eVVDUUlqWjUvVzhYaU8zL1NVenhTOGJMdDFtcUlk?=
 =?utf-8?Q?x12MWCqM09mTy/CjYg6G8t3BZ1Gg8aIst4jr+UjaG8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F14CA8D7D32AB04F86DA585389DED668@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: ff64d45f-6d8e-46cb-0bbc-08dcd62f7bf8
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2024 09:11:01.1224
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mdLJMgl4ODQR2bAgTTkZcgpaHvLW07TmbC2zpLg1x5vOXuE8lWK4eIL85tXNIEThYnHT0THc5+y1cVh8DLKjFl5cn4lVAXn2b1/6XXTPbLA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR10MB8470

T24gTW9uLCAyMDI0LTA5LTE2IGF0IDAzOjA3IC0wNjAwLCBKZW5zIEF4Ym9lIHdyb3RlOg0KPiBB
IHJlY2VudCBjb21taXQgZW5zdXJlZCB0aGF0IFNRUE9MTCBjYW5ub3QgYmUgc2V0dXAgd2l0aCBh
IENQVSB0aGF0DQo+IGlzbid0IGluIHRoZSBjdXJyZW50IHRhc2tzIGNwdXNldCwgYnV0IGl0IGFs
c28gZHJvcHBlZCB0ZXN0aW5nDQo+IHdoZXRoZXINCj4gdGhlIENQVSBpcyB2YWxpZCBpbiB0aGUg
Zmlyc3QgcGxhY2UuIFdpdGhvdXQgdGhhdCwgaWYgYSB0YXNrIHBhc3Nlcw0KPiBpbg0KPiBhIENQ
VSB2YWx1ZSB0aGF0IGlzIHRvbyBoaWdoLCB0aGUgZm9sbG93aW5nIEtBU0FOIHNwbGF0IGNhbiBn
ZXQNCj4gdHJpZ2dlcmVkOg0KPiANCj4gQlVHOiBLQVNBTjogc3RhY2stb3V0LW9mLWJvdW5kcyBp
biBpb19zcV9vZmZsb2FkX2NyZWF0ZSsweDg1OC8weGFhNA0KPiBSZWFkIG9mIHNpemUgOCBhdCBh
ZGRyIGZmZmY4MDAwODliYzdiOTAgYnkgdGFzayB3cS1hZmYudC8xMzkxDQo+IA0KPiBDUFU6IDQg
VUlEOiAxMDAwIFBJRDogMTM5MSBDb21tOiB3cS1hZmYudCBOb3QgdGFpbnRlZCA2LjExLjAtcmM3
LQ0KPiAwMDIyNy1nMzcxYzQ2OGY0ZGI2ICM3MDgwDQo+IEhhcmR3YXJlIG5hbWU6IGxpbnV4LGR1
bW15LXZpcnQgKERUKQ0KPiBDYWxsIHRyYWNlOg0KPiDCoGR1bXBfYmFja3RyYWNlLnBhcnQuMCsw
eGNjLzB4ZTANCj4gwqBzaG93X3N0YWNrKzB4MTQvMHgxYw0KPiDCoGR1bXBfc3RhY2tfbHZsKzB4
NTgvMHg3NA0KPiDCoHByaW50X3JlcG9ydCsweDE2Yy8weDRjOA0KPiDCoGthc2FuX3JlcG9ydCsw
eDljLzB4ZTQNCj4gwqBfX2FzYW5fcmVwb3J0X2xvYWQ4X25vYWJvcnQrMHgxYy8weDI0DQo+IMKg
aW9fc3Ffb2ZmbG9hZF9jcmVhdGUrMHg4NTgvMHhhYTQNCj4gwqBpb191cmluZ19zZXR1cCsweDEz
OTQvMHgxN2M0DQo+IMKgX19hcm02NF9zeXNfaW9fdXJpbmdfc2V0dXArMHg2Yy8weDE4MA0KPiDC
oGludm9rZV9zeXNjYWxsKzB4NmMvMHgyNjANCj4gwqBlbDBfc3ZjX2NvbW1vbi5jb25zdHByb3Au
MCsweDE1OC8weDIyNA0KPiDCoGRvX2VsMF9zdmMrMHgzYy8weDVjDQo+IMKgZWwwX3N2YysweDM0
LzB4NzANCj4gwqBlbDB0XzY0X3N5bmNfaGFuZGxlcisweDExOC8weDEyNA0KPiDCoGVsMHRfNjRf
c3luYysweDE2OC8weDE2Yw0KPiANCj4gVGhlIGJ1Z2d5IGFkZHJlc3MgYmVsb25ncyB0byBzdGFj
ayBvZiB0YXNrIHdxLWFmZi50LzEzOTENCj4gwqBhbmQgaXMgbG9jYXRlZCBhdCBvZmZzZXQgNDgg
aW4gZnJhbWU6DQo+IMKgaW9fc3Ffb2ZmbG9hZF9jcmVhdGUrMHgwLzB4YWE0DQo+IA0KPiBUaGlz
IGZyYW1lIGhhcyAxIG9iamVjdDoNCj4gwqBbMzIsIDQwKSAnYWxsb3dlZF9tYXNrJw0KPiANCj4g
VGhlIGJ1Z2d5IGFkZHJlc3MgYmVsb25ncyB0byB0aGUgdmlydHVhbCBtYXBwaW5nIGF0DQo+IMKg
W2ZmZmY4MDAwODliYzAwMDAsIGZmZmY4MDAwODliYzkwMDApIGNyZWF0ZWQgYnk6DQo+IMKga2Vy
bmVsX2Nsb25lKzB4MTI0LzB4N2UwDQo+IA0KPiBUaGUgYnVnZ3kgYWRkcmVzcyBiZWxvbmdzIHRv
IHRoZSBwaHlzaWNhbCBwYWdlOg0KPiBwYWdlOiByZWZjb3VudDoxIG1hcGNvdW50OjAgbWFwcGlu
ZzowMDAwMDAwMDAwMDAwMDAwDQo+IGluZGV4OjB4ZmZmZjAwMDBkNzQwYWY4MCBwZm46MHgxMTc0
MGENCj4gbWVtY2c6ZmZmZjAwMDBjMjcwNmYwMg0KPiBmbGFnczogMHhiZmZlMDAwMDAwMDAwMDAo
bm9kZT0wfHpvbmU9MnxsYXN0Y3B1cGlkPTB4MWZmZikNCj4gcmF3OiAwYmZmZTAwMDAwMDAwMDAw
IDAwMDAwMDAwMDAwMDAwMDAgZGVhZDAwMDAwMDAwMDEyMg0KPiAwMDAwMDAwMDAwMDAwMDAwDQo+
IHJhdzogZmZmZjAwMDBkNzQwYWY4MCAwMDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAxZmZmZmZmZmYN
Cj4gZmZmZjAwMDBjMjcwNmYwMg0KPiBwYWdlIGR1bXBlZCBiZWNhdXNlOiBrYXNhbjogYmFkIGFj
Y2VzcyBkZXRlY3RlZA0KPiANCj4gTWVtb3J5IHN0YXRlIGFyb3VuZCB0aGUgYnVnZ3kgYWRkcmVz
czoNCj4gwqBmZmZmODAwMDg5YmM3YTgwOiAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAw
MCAwMCAwMCAwMCAwMCAwMA0KPiDCoGZmZmY4MDAwODliYzdiMDA6IDAwIDAwIDAwIDAwIDAwIDAw
IDAwIDAwIDAwIDAwIDAwIDAwIGYxIGYxIGYxIGYxDQo+ID4gZmZmZjgwMDA4OWJjN2I4MDogMDAg
ZjMgZjMgZjMgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDANCj4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIF4NCj4gwqBmZmZmODAwMDg5
YmM3YzAwOiAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCBmMSBmMSBmMSBmMQ0K
PiDCoGZmZmY4MDAwODliYzdjODA6IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDAwIDAwIDAwIGYzDQo+IA0KPiBSZXBvcnRlZC1ieToga2VybmVsIHRlc3Qgcm9ib3QgPG9saXZl
ci5zYW5nQGludGVsLmNvbT4NCj4gQ2xvc2VzOg0KPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9v
ZS1sa3AvMjAyNDA5MTYxNjMyLmNiZWVjYTBkLWxrcEBpbnRlbC5jb20NCj4gRml4ZXM6IGYwMTFj
OWNmMDRjMCAoImlvX3VyaW5nL3NxcG9sbDogZG8gbm90IGFsbG93IHBpbm5pbmcgb3V0c2lkZQ0K
PiBvZiBjcHVzZXQiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwu
ZGs+DQo+IA0KPiAtLS0NCj4gDQo+IGRpZmYgLS1naXQgYS9pb191cmluZy9zcXBvbGwuYyBiL2lv
X3VyaW5nL3NxcG9sbC5jDQo+IGluZGV4IDI3MmRmOWQwMGY0NS4uN2FkZmNmNjgxOGZmIDEwMDY0
NA0KPiAtLS0gYS9pb191cmluZy9zcXBvbGwuYw0KPiArKysgYi9pb191cmluZy9zcXBvbGwuYw0K
PiBAQCAtNDY1LDYgKzQ2NSw4IEBAIF9fY29sZCBpbnQgaW9fc3Ffb2ZmbG9hZF9jcmVhdGUoc3Ry
dWN0DQo+IGlvX3JpbmdfY3R4ICpjdHgsDQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoGludCBjcHUgPSBwLT5zcV90aHJlYWRfY3B1Ow0KPiDCoA0KPiDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXQgPSAtRUlO
VkFMOw0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlm
IChjcHUgPj0gbnJfY3B1X2lkcyB8fCAhY3B1X29ubGluZShjcHUpKQ0KPiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBnb3RvIGVy
cl9zcXBvbGw7DQoNClRoYW5rcyBmb3IgZml4aW5nLiBJJ20ganVzdCB3b25kZXJpbmcgaWYgY3B1
X29ubGluZSBpcyByZWFsbHkgbmVlZGVkLA0KYXMgb2ZmbGluZSBDUFVzIGFyZSBpbiB0aGUgbWFz
ayBhcyB3ZWxsLCBhcmVuJ3QgdGhleT8NCg0KQW55d2F5czogVGVzdGVkLWJ5OiBGZWxpeCBNb2Vz
c2JhdWVyIDxmZWxpeC5tb2Vzc2JhdWVyQHNpZW1lbnMuY29tPg0KDQpGZWxpeA0KDQo+IMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGNwdXNldF9jcHVzX2Fs
bG93ZWQoY3VycmVudCwgJmFsbG93ZWRfbWFzayk7DQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmICghY3B1bWFza190ZXN0X2NwdShjcHUsICZhbGxv
d2VkX21hc2spKQ0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgZ290byBlcnJfc3Fwb2xsOw0KDQotLSANClNpZW1lbnMgQUcs
IFRlY2hub2xvZ3kNCkxpbnV4IEV4cGVydCBDZW50ZXINCg0KDQo=

