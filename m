Return-Path: <io-uring+bounces-4877-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A36CC9D3FBA
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 17:08:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 386921F21808
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 16:08:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6ACF913D638;
	Wed, 20 Nov 2024 16:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="Hz1CGu+J"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7EA44C77;
	Wed, 20 Nov 2024 16:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732118880; cv=fail; b=nQVKbwG8Vqoy74m19A+h+vfuRCj3aAwpA06GXiH1cU+SLWIHELbWjDpypUH+pgZ7PODuzSeLWn6k4iH/kRdSB4D04bHPI8/IMkMwE5zExQfu1L4ZClPwGuXiPMs+UjQHcyBPFcVqcAMsyiLAFj47wQtcIe57MptOyuBWdPFhefI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732118880; c=relaxed/simple;
	bh=v9xHs23n1ZFhNzxpU7bUMQ35SdkR+/hAGP3uA2iyCHE=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jp9YRAcf6vEvaNcotuxE1QY65VokYmtKzjVtxGXWqBBzsW8YkS+vAKUy+REUVvg4tPzgNbO26+pS1x2oq3CCiHjvOI2sGv3qL+SdOzd5t+bBqbugYPBEsQ9BbBeXRQ0kS5Zcfcg2hRZQillo6vRNoE3Cd02vGRir41XGGE9jRnk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=Hz1CGu+J; arc=fail smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.18.1.2/8.18.1.2) with ESMTP id 4AKEoXvY016345;
	Wed, 20 Nov 2024 08:07:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=
	content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	s2048-2021-q4; bh=v9xHs23n1ZFhNzxpU7bUMQ35SdkR+/hAGP3uA2iyCHE=; b=
	Hz1CGu+JjNWoi/7uPE9JiJsbTLjqBT5V8/6OD3UHB6ZYd93rD2FESZZipWQb+L50
	2DFyZ/IKyhT7nZHlJbrTPUVqQxwSznH7skPdSRrZo18soMGH7d6hIPdKQg7JF+tP
	rFRajbKQHH9Y0tXndofCP0RpeA9uFbyS1yss6waXjvVUISYxs6CPGoz/YybruBxn
	keLrF0yq2fBACb5HKtOXbVMpf05fmKFlCAi3/iJDxh09AzmUubZT6/0qTIF704MX
	VQbjV0MhPjorqscg/PbSaZf98SnGTRn2Ndvnq/38UOXe+0gka7MQZm+2x3A1ykkk
	twrOc6njgU08HKvfiepbog==
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2044.outbound.protection.outlook.com [104.47.58.44])
	by m0089730.ppops.net (PPS) with ESMTPS id 4315534aen-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 Nov 2024 08:07:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QxkUUjxLALIjbFTtRA/Hnfhb3Jw5EbTMe8HIW13UXUV2R66xcQjFp94myCDp230lCXIvaylZRq1BMlxXp6QPUiNcroZ2Sk/KcZFlpsoBDZGrdvmPxJmwFm7HpcnZMWVzZCRbmZgsXGtDdfGQekenKxh5eA+huSA+w9pey7qaSc6bbxKXuCwAohPQMrz9qD471XiNjebuUN6HrH+XovZ9bUwiR0fchgjKrjQmbJb20BfIIxQV+IMaq9wFs2WgfVZVi2a8jyGAa1nYE3Y85KR7Dz/6mGm4e1MGas7JylNTv1RduBnR6KaQwoWCJ50ug/hxRcv9hhruO6/NNuFlTAsU+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v9xHs23n1ZFhNzxpU7bUMQ35SdkR+/hAGP3uA2iyCHE=;
 b=wjCDDK242JTkzS00J4U1oI1wVBbcL5kdtycor9cAWVagILtbaq75hrXprCPyL3sPiv6Jdff8lmK5dUApPYymAjAvCey50kXIcsao3WaFiDWohyymAIQhs/E4mfxb+EHtLuw1TGtXljL/A5c/0Paqsu+Fs23ll8FIomaMf6aiar6/Iaut9B/g4knXZSWHEWvzX6Co38kfDBM1rDnun4tW8g8rVt28TLQ2hgJ6U6Ybf9q3NZ/ZgRbzgRz9PznrsDwHZxfDRZXmVDlgyiN+8+Lbfa7fTsuC4pINQa4p1tEx5AaS9m7gtR0bO4kllh1i3XNjpv4LWBtib8B9PFI/5tTrKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SJ2PR15MB5669.namprd15.prod.outlook.com (2603:10b6:a03:4c0::15)
 by PH0PR15MB4687.namprd15.prod.outlook.com (2603:10b6:510:8c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.15; Wed, 20 Nov
 2024 16:07:54 +0000
Received: from SJ2PR15MB5669.namprd15.prod.outlook.com
 ([fe80::bff4:aff5:7657:9fe8]) by SJ2PR15MB5669.namprd15.prod.outlook.com
 ([fe80::bff4:aff5:7657:9fe8%4]) with mapi id 15.20.8182.014; Wed, 20 Nov 2024
 16:07:54 +0000
From: Mark Harmstone <maharmstone@meta.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Re: [PATCH 4/4] btrfs: don't read from userspace twice in
 btrfs_uring_encoded_read()
Thread-Topic: [PATCH 4/4] btrfs: don't read from userspace twice in
 btrfs_uring_encoded_read()
Thread-Index: AQHbO2Wg6PLjh8GK6EKVQZgT8FEzHbLAVemA
Date: Wed, 20 Nov 2024 16:07:54 +0000
Message-ID: <b8f286dd-1c58-4222-aa00-978741e5b1bc@meta.com>
References: <20241120160231.1106844-1-maharmstone@fb.com>
 <20241120160231.1106844-4-maharmstone@fb.com>
In-Reply-To: <20241120160231.1106844-4-maharmstone@fb.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR15MB5669:EE_|PH0PR15MB4687:EE_
x-ms-office365-filtering-correlation-id: 0ad4f885-b16f-4271-881e-08dd097d7dfd
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|10070799003|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?UkZJdnFrZ2F1TmdUTlFFbDZBQm02K28xUDYybktrdFdoVUZDYy9hUzk2L09D?=
 =?utf-8?B?a3M3KytyaU54QVo5NWk2RWNrUGFkVTdxS1B0LzVXL0p4RytJTWMzUGRMVXUw?=
 =?utf-8?B?S1pPaHZrczN4WXJLT2V4Q0FuZ3Z2S0RPOEpMZ3V4Qkh0OGJ5dEdrc0hnUTFp?=
 =?utf-8?B?K2xLMVF3ZmhlYXdmYnlPdTNiMjBxMWFpMitPd044YUhCbVVzOGNTVzd1NnJT?=
 =?utf-8?B?WHFhVzE5d2s3RmY4aDh4UFFUWGtTTmZYSC9WdFJ4ejdVQ0Q0ZUwzSDNGcklx?=
 =?utf-8?B?TDhSSHpKSkpWZzhTWkZUVGdka2ltVjdKNG5ralc1YS9DaDFmMCt3dVFITWE3?=
 =?utf-8?B?SkJjQ08ra1hCQXROVlFlbmI4SXBkSWVVczVkM0FpNlNGd25zQmlGVGRscFda?=
 =?utf-8?B?aExzS3Q4T1d4dDk0bVZaNWlvc3lWaXFta0RadW5xWG5JNlBhaHYxQm8vamtK?=
 =?utf-8?B?VU1rR3dPZW5UbXMwQlpGZDkxcmFFZjNIRC9VT1FKWmZRWFZOdmRIZWdJSFpz?=
 =?utf-8?B?U0pvYUhaVTJ3TThIV2dmdEZEdFJBbUVobi91eHYwMGd0NFJJamM5WXR6cUNV?=
 =?utf-8?B?NU5UdFlwM3gyUVBEQTVLYmRXcXZYSHVnaHhGYkYxYW1pUk9JaDcxTnJPWGhR?=
 =?utf-8?B?UWV2U3lLaHpib3ArTFBYR2swa3hPUWdSRlp0SlBSbnZrSDRzWk5nVmk5WWxZ?=
 =?utf-8?B?WCs0emxMOGtWdVh3bk9CY3g5NEppalYvdzRZMXVRd3JXVmlNc1V0d0hjVVp1?=
 =?utf-8?B?Q29pczhjYkMrOFczNVVGdU0zOEVPVXJ0RjVIR0FISEZmT2tmVVFROHlrcFBF?=
 =?utf-8?B?bHNHZ1RkVllFYkdQaEp0Q2N4UjROY0tnNklhNjhGUHg2R1ZZUHk2d3NIeWU5?=
 =?utf-8?B?dXU1am9LUFNoZHpHT3Iwd2FUbU1VNFlTQXhQaFRxcUlNTGo2c2NBTHd5b1hU?=
 =?utf-8?B?UzBuSDRNaDE4S3F1QVY2UDVXR3RwYmxSM0t2WGQ2K09oUGx0L2EvVVcxeWFN?=
 =?utf-8?B?QWdXdEo2UEpRaFVoM1Fkb0tPVXJodndPVytVM0FlL3kzT0phelJBSFBJU3lv?=
 =?utf-8?B?RnZmMGJON3oyZm5JdkxzdjAvU01rS2dEd1ZScnRKOEZjSDJYTE9xb1dXeUVY?=
 =?utf-8?B?MDlZeFQ5cnRTZWVrdjNDNHRTZFVUWFFDUi9zcFhqMUh2Smt6NHFOTTdjbGxv?=
 =?utf-8?B?YlBrMkZuMmFnN0I3ZVIzc2czdlFkYnRDczRrd3JUTFpRbGVreGVoWFUxZ0d3?=
 =?utf-8?B?aS9tbC84ZnBsRGU3SnlaQ3RQdkRoMXpmRCtRYlB3MCt0NHJoZUdtR3Y0cTVk?=
 =?utf-8?B?eWQrcFdXRnpaUWJ1Rld3VGJMOUtUWENRaFUzeUNNM0xzb05VWWhmNlc3bE45?=
 =?utf-8?B?UnhkY0pvaE9tR1FOamo3RVhuMWdsbDZFUjJSRXhGTU93SmZZU0E3Z3hGTC9a?=
 =?utf-8?B?NHBFZEs1QTdjb3NsbzFDOVBXYjRianhFQXFoWFJGYmpTcVIzYlU4Q3hzaExj?=
 =?utf-8?B?aVhuWVh1dExRN3Bwb3Z2MzJCWEdJV2J6ZUVOSTJLdlZWUjVDTXpwMGFIdWNk?=
 =?utf-8?B?OUlWb0ZRMk9ySnFVMDlTaWQrZTNIdFVpcC8xaHNTTTBnSmtzNEQ2endnQ1dk?=
 =?utf-8?B?UjltWlQ0RVFTTjJZWVpOYjExNUsrYnJJcitDbWV6YUNHVFRQb1V3aEZtSFNj?=
 =?utf-8?B?T3ZwOW52VmJoTWVjTFRkakFEWUdnMlpPS2prMWZmbm5iSm9BV3cvZjVFSUZR?=
 =?utf-8?B?M2dqN1psejB0a3pHeUdNbXZ5STZsUWw3MHZSZTJ0N3lCeUFWWDlkZlRMT0Uw?=
 =?utf-8?Q?QXBf09bSjEtCJ30pOCmzPIHnkReDLhOFBs2Zg=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR15MB5669.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(10070799003)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?a3I5OGh5U1Y3RmpQNStJMHI5V0srdG9VckJjTXJLaWJuVGp3SEE4Y0NDTGFz?=
 =?utf-8?B?dnBsV3YxcGZtdGxqZVBCN09STGkwaktJWEpYdlFGekhuR1pTTWJqUDBIUnpF?=
 =?utf-8?B?OTdHWFJPbzRNMnFYM0RxZUk0eHltQW9vTE5GNi93bmsvT2RZUzZIR0ZudFBv?=
 =?utf-8?B?VS9GRmNpODNKd0s2TXQrVk0wZzA5ekVBdXJNNXllSEliaWpMeUE0YzlESndC?=
 =?utf-8?B?aGxEU01RaEdiOW9FWHZjRGNaazMvbUUyRmhxN1RYUEx6RTJJcEFHZXg3Nk9Q?=
 =?utf-8?B?TXptMjB3S2xkaENuSE80NUc2bHBYOUJwRkRCNTVjeDFYb05ySFNmaytBZGc2?=
 =?utf-8?B?NC9QUnluTTRTdkN6UmR6VmtUVW1ZUEpiTFFJYzFhUjQwUGg3a2xERzI5SXBp?=
 =?utf-8?B?YS9WWkVjU05TQ1BPSndPeXRvcDFCTTRnM0VsTElDNDIxamNXWDdjY3FiOWJu?=
 =?utf-8?B?Lzkwb3ZHWHVBeWpvMUdhTXViN3RySGs1a25sbTdNRUVkZkJrbUIrRVFWLzFM?=
 =?utf-8?B?WU5aOTZobTdzMEpNeElYemZMTndYMEg3eUM0YzBYT1Vxa3hlNVVzaVB4LzVk?=
 =?utf-8?B?aEgrKzdDbU5QdEZub2hCdmdiMDI0aWxadG43RU91b3NSeTlZU2k0QkRlc2Qw?=
 =?utf-8?B?R0RteGlIWlpCbFRaR0tqb2VyWkFrN1JCWDAvZFB0aVRXdTZFUU5XYWZwZXY1?=
 =?utf-8?B?UDVKbEdwZjA3VUZnTUtaZEo3WDdZRXp2SWsyQnJJcXFIWGlBb1BOV2ZQdnMv?=
 =?utf-8?B?ZG1YcTdsVFpueWNoQjFiN2lZK2JIZWVuUTI4ekViV1locFJveG1RMmN1M21T?=
 =?utf-8?B?anZJZkFFVG9HS3JrZHJGTjc5RGszVGc3TWs4ZnJYaXVyMVFPV2g1ZlpGakZE?=
 =?utf-8?B?T1lSQnRCbnpkTXJKSEFCK2FNWEpqamhXeVVmZzJONHU3bEFtbk8xdzZ5bURn?=
 =?utf-8?B?VTlETFVibFpUZWtlQm0zSWsxOTlvcU1ZcG0vT1c2UmoxcG5oWTFvSXhYMTY4?=
 =?utf-8?B?QmtMNUQ5VjEzcHMwRkIzSllzandXUW55bnhUTHJiQzlvQmF2TitIY2hYVmZG?=
 =?utf-8?B?Z3g1dlhqSzJ3S1VvTUxkLytUcjRYNjY0RGlDUnhkcHVRaC9KQWVWb2pQMHpz?=
 =?utf-8?B?UUJCOExJakxBVFNCL1VSWGVmbmRmYUZKR2JiMTRTVmxUdUV6Rzc2ZlhUMFNY?=
 =?utf-8?B?VExnNmVaQ3ZUakVtc2d1czJUQ2txU3dqKy8wWVFJZWJqeHVTeXBQb3Q0VHFk?=
 =?utf-8?B?RXBReEMwNW9LZmN5eFZrenh6NjVSaEZsbGN0bnd2ZXJBaCtJZlk5cHBCNmZT?=
 =?utf-8?B?UUNhTERUYzdyRzh1SDlFckZ3Y25UYXRYaXFxQzdlQzFXM2VXcW03THBtWGhq?=
 =?utf-8?B?dm5YU3FUVTU1NzJ2a3RKdWduWlpoQlRwd3NCMzJoS0tORGJKSkZkZHJuYktX?=
 =?utf-8?B?eGxWUENhRFI0dFAvaUk2R0xLdnI1c21MejNleW02RmRoVG9xRkFBalcvMEc3?=
 =?utf-8?B?clRjYWQrUFUzaGJkYVpzckZqLzNZR0xOclVuNStEUzlON2Y2RVpaVHlMTWF1?=
 =?utf-8?B?U1pUOU15cFQ2dDhxdWVDZk9ML0l2aEtyOXdZNFhJbU1waEs5TmpqMDlQZ2hU?=
 =?utf-8?B?WEZTaTZ0S3l1KzBjQ3ZyMU1GYVdyQ1l4dlByY3pJTTJVczBuL3ZUaGhxdkpm?=
 =?utf-8?B?ViszcVV1OW95Q08xTUdSQTJ2aDN1eElheHk4blNRdllmVUFwSXZoeGpHQkwx?=
 =?utf-8?B?T2xwTHk3QkJDSmFPRDROK0lzTk12RzJhR01wRHRnaTNvckhadEFaV3NMWjN2?=
 =?utf-8?B?cTN1TGprTkRmSWJUWFRDY1Rqay9GMzNHNTdjTHZjendiZ2g5N3ZCdkt3Z09U?=
 =?utf-8?B?R1RNdThCY2EzbERPcTR0OXdZVUZ4elFQZEdGdHRZQk1CN1MrYlZMUUkzeUZ4?=
 =?utf-8?B?Z3BXTWw4elExc2lNTkRLMUJ5STQrbjlRQjZ4aWJKQmpPdFh6N0FYcVZSLys0?=
 =?utf-8?B?eXk1ajhHRW1BcEZaVG4xcjk3QmdQM0VFTTk0QitsWWtjSWNkaFJvVFlhV0R5?=
 =?utf-8?B?QVBvR3BrQ28xZFZVcE1PWGg5d1RpaFVYUjRXVlg4eS85VlZHWGdXVGpZMWN6?=
 =?utf-8?B?bjVMWFliQmwvaS80QnlpbXpLZ2RvbWgvK0xhZmR3d2VTeFNncktJZktQOHdR?=
 =?utf-8?Q?EHkjbJ7Hbm1xkgV1TNRRO3U=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2BA4563912DB6C439D53C8EDD8C5D751@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR15MB5669.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ad4f885-b16f-4271-881e-08dd097d7dfd
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2024 16:07:54.5397
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iLfYAmAcoE8aFBNDldjby64JZhMmGPH/HInXmAavZzdexr7QZQVaiUWwuzaT6qCZrTCyXO1HJ+mKcf6smVv4tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4687
X-Proofpoint-GUID: Km396v8XqipyTMrF2ZeIfyffVi2YVepL
X-Proofpoint-ORIG-GUID: Km396v8XqipyTMrF2ZeIfyffVi2YVepL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

Q291bGQgc29tZW9uZSBwbGVhc2UgYXBwbHkgbXkga21lbWR1cCBwYXRjaCBmcm9tIGxhc3Qgd2Vl
ayBzbyB0aGF0IHRoaXMgDQphcHBsaWVzIGNsZWFubHk/ICJidHJmczogdXNlIGttZW1kdXAgaW4g
YnRyZnNfdXJpbmdfZW5jb2RlZF9yZWFkIg0KDQpPbiAyMC8xMS8yNCAxNjowMiwgTWFyayBIYXJt
c3RvbmUgd3JvdGU6DQo+IElmIHdlIHJldHVybiAtRUFHQUlOIHRoZSBmaXJzdCB0aW1lIGJlY2F1
c2Ugd2UgbmVlZCB0byBibG9jaywNCj4gYnRyZnNfdXJpbmdfZW5jb2RlZF9yZWFkKCkgd2lsbCBn
ZXQgY2FsbGVkIHR3aWNlLiBUYWtlIGEgY29weSBvZiBhcmdzDQo+IHRoZSBmaXJzdCB0aW1lLCB0
byBwcmV2ZW50IHVzZXJzcGFjZSBmcm9tIG1lc3NpbmcgYXJvdW5kIHdpdGggaXQuDQo+IA0KPiBT
aWduZWQtb2ZmLWJ5OiBNYXJrIEhhcm1zdG9uZSA8bWFoYXJtc3RvbmVAZmIuY29tPg0KPiAtLS0N
Cj4gICBmcy9idHJmcy9pb2N0bC5jIHwgNzQgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KystLS0tLS0tLS0tLS0tLS0tDQo+ICAgMSBmaWxlIGNoYW5nZWQsIDQ5IGluc2VydGlvbnMoKyks
IDI1IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2ZzL2J0cmZzL2lvY3RsLmMgYi9m
cy9idHJmcy9pb2N0bC5jDQo+IGluZGV4IDQ4OGRjZDAyMmRlYS4uOTdmNzgxMmNiZjdjIDEwMDY0
NA0KPiAtLS0gYS9mcy9idHJmcy9pb2N0bC5jDQo+ICsrKyBiL2ZzL2J0cmZzL2lvY3RsLmMNCj4g
QEAgLTQ4NzMsNyArNDg3Myw3IEBAIHN0YXRpYyBpbnQgYnRyZnNfdXJpbmdfZW5jb2RlZF9yZWFk
KHN0cnVjdCBpb191cmluZ19jbWQgKmNtZCwgdW5zaWduZWQgaW50IGlzc3VlDQo+ICAgew0KPiAg
IAlzaXplX3QgY29weV9lbmRfa2VybmVsID0gb2Zmc2V0b2ZlbmQoc3RydWN0IGJ0cmZzX2lvY3Rs
X2VuY29kZWRfaW9fYXJncywgZmxhZ3MpOw0KPiAgIAlzaXplX3QgY29weV9lbmQ7DQo+IC0Jc3Ry
dWN0IGJ0cmZzX2lvY3RsX2VuY29kZWRfaW9fYXJncyBhcmdzID0geyAwIH07DQo+ICsJc3RydWN0
IGJ0cmZzX2lvY3RsX2VuY29kZWRfaW9fYXJncyAqYXJnczsNCj4gICAJaW50IHJldDsNCj4gICAJ
dTY0IGRpc2tfYnl0ZW5yLCBkaXNrX2lvX3NpemU7DQo+ICAgCXN0cnVjdCBmaWxlICpmaWxlOw0K
PiBAQCAtNDg4OCw2ICs0ODg4LDkgQEAgc3RhdGljIGludCBidHJmc191cmluZ19lbmNvZGVkX3Jl
YWQoc3RydWN0IGlvX3VyaW5nX2NtZCAqY21kLCB1bnNpZ25lZCBpbnQgaXNzdWUNCj4gICAJc3Ry
dWN0IGV4dGVudF9zdGF0ZSAqY2FjaGVkX3N0YXRlID0gTlVMTDsNCj4gICAJdTY0IHN0YXJ0LCBs
b2NrZW5kOw0KPiAgIAl2b2lkIF9fdXNlciAqc3FlX2FkZHI7DQo+ICsJc3RydWN0IGlvX2tpb2Ni
ICpyZXEgPSBjbWRfdG9faW9fa2lvY2IoY21kKTsNCj4gKwlzdHJ1Y3QgaW9fdXJpbmdfY21kX2Rh
dGEgKmRhdGEgPSByZXEtPmFzeW5jX2RhdGE7DQo+ICsJYm9vbCBuZWVkX2NvcHkgPSBmYWxzZTsN
Cj4gICANCj4gICAJaWYgKCFjYXBhYmxlKENBUF9TWVNfQURNSU4pKSB7DQo+ICAgCQlyZXQgPSAt
RVBFUk07DQo+IEBAIC00ODk5LDM0ICs0OTAyLDU1IEBAIHN0YXRpYyBpbnQgYnRyZnNfdXJpbmdf
ZW5jb2RlZF9yZWFkKHN0cnVjdCBpb191cmluZ19jbWQgKmNtZCwgdW5zaWduZWQgaW50IGlzc3Vl
DQo+ICAgCWlvX3RyZWUgPSAmaW5vZGUtPmlvX3RyZWU7DQo+ICAgCXNxZV9hZGRyID0gdTY0X3Rv
X3VzZXJfcHRyKFJFQURfT05DRShjbWQtPnNxZS0+YWRkcikpOw0KPiAgIA0KPiArCWlmICghZGF0
YS0+b3BfZGF0YSkgew0KPiArCQlkYXRhLT5vcF9kYXRhID0ga3phbGxvYyhzaXplb2YoKmFyZ3Mp
LCBHRlBfTk9GUyk7DQo+ICsJCWlmICghZGF0YS0+b3BfZGF0YSkgew0KPiArCQkJcmV0ID0gLUVO
T01FTTsNCj4gKwkJCWdvdG8gb3V0X2FjY3Q7DQo+ICsJCX0NCj4gKw0KPiArCQluZWVkX2NvcHkg
PSB0cnVlOw0KPiArCX0NCj4gKw0KPiArCWFyZ3MgPSBkYXRhLT5vcF9kYXRhOw0KPiArDQo+ICAg
CWlmIChpc3N1ZV9mbGFncyAmIElPX1VSSU5HX0ZfQ09NUEFUKSB7DQo+ICAgI2lmIGRlZmluZWQo
Q09ORklHXzY0QklUKSAmJiBkZWZpbmVkKENPTkZJR19DT01QQVQpDQo+IC0JCXN0cnVjdCBidHJm
c19pb2N0bF9lbmNvZGVkX2lvX2FyZ3NfMzIgYXJnczMyOw0KPiAtDQo+ICAgCQljb3B5X2VuZCA9
IG9mZnNldG9mZW5kKHN0cnVjdCBidHJmc19pb2N0bF9lbmNvZGVkX2lvX2FyZ3NfMzIsIGZsYWdz
KTsNCj4gLQkJaWYgKGNvcHlfZnJvbV91c2VyKCZhcmdzMzIsIHNxZV9hZGRyLCBjb3B5X2VuZCkp
IHsNCj4gLQkJCXJldCA9IC1FRkFVTFQ7DQo+IC0JCQlnb3RvIG91dF9hY2N0Ow0KPiArDQo+ICsJ
CWlmIChuZWVkX2NvcHkpIHsNCj4gKwkJCXN0cnVjdCBidHJmc19pb2N0bF9lbmNvZGVkX2lvX2Fy
Z3NfMzIgYXJnczMyOw0KPiArDQo+ICsJCQlpZiAoY29weV9mcm9tX3VzZXIoJmFyZ3MzMiwgc3Fl
X2FkZHIsIGNvcHlfZW5kKSkgew0KPiArCQkJCXJldCA9IC1FRkFVTFQ7DQo+ICsJCQkJZ290byBv
dXRfYWNjdDsNCj4gKwkJCX0NCj4gKw0KPiArCQkJYXJncy0+aW92ID0gY29tcGF0X3B0cihhcmdz
MzIuaW92KTsNCj4gKwkJCWFyZ3MtPmlvdmNudCA9IGFyZ3MzMi5pb3ZjbnQ7DQo+ICsJCQlhcmdz
LT5vZmZzZXQgPSBhcmdzMzIub2Zmc2V0Ow0KPiArCQkJYXJncy0+ZmxhZ3MgPSBhcmdzMzIuZmxh
Z3M7DQo+ICAgCQl9DQo+IC0JCWFyZ3MuaW92ID0gY29tcGF0X3B0cihhcmdzMzIuaW92KTsNCj4g
LQkJYXJncy5pb3ZjbnQgPSBhcmdzMzIuaW92Y250Ow0KPiAtCQlhcmdzLm9mZnNldCA9IGFyZ3Mz
Mi5vZmZzZXQ7DQo+IC0JCWFyZ3MuZmxhZ3MgPSBhcmdzMzIuZmxhZ3M7DQo+ICAgI2Vsc2UNCj4g
ICAJCXJldHVybiAtRU5PVFRZOw0KPiAgICNlbmRpZg0KPiAgIAl9IGVsc2Ugew0KPiAgIAkJY29w
eV9lbmQgPSBjb3B5X2VuZF9rZXJuZWw7DQo+IC0JCWlmIChjb3B5X2Zyb21fdXNlcigmYXJncywg
c3FlX2FkZHIsIGNvcHlfZW5kKSkgew0KPiAtCQkJcmV0ID0gLUVGQVVMVDsNCj4gLQkJCWdvdG8g
b3V0X2FjY3Q7DQo+ICsNCj4gKwkJaWYgKG5lZWRfY29weSkgew0KPiArCQkJaWYgKGNvcHlfZnJv
bV91c2VyKGFyZ3MsIHNxZV9hZGRyLCBjb3B5X2VuZCkpIHsNCj4gKwkJCQlyZXQgPSAtRUZBVUxU
Ow0KPiArCQkJCWdvdG8gb3V0X2FjY3Q7DQo+ICsJCQl9DQo+ICAgCQl9DQo+ICAgCX0NCj4gICAN
Cj4gLQlpZiAoYXJncy5mbGFncyAhPSAwKQ0KPiAtCQlyZXR1cm4gLUVJTlZBTDsNCj4gKwlpZiAo
YXJncy0+ZmxhZ3MgIT0gMCkgew0KPiArCQlyZXQgPSAtRUlOVkFMOw0KPiArCQlnb3RvIG91dF9h
Y2N0Ow0KPiArCX0NCj4gICANCj4gLQlyZXQgPSBpbXBvcnRfaW92ZWMoSVRFUl9ERVNULCBhcmdz
LmlvdiwgYXJncy5pb3ZjbnQsIEFSUkFZX1NJWkUoaW92c3RhY2spLA0KPiArCXJldCA9IGltcG9y
dF9pb3ZlYyhJVEVSX0RFU1QsIGFyZ3MtPmlvdiwgYXJncy0+aW92Y250LCBBUlJBWV9TSVpFKGlv
dnN0YWNrKSwNCj4gICAJCQkgICAmaW92LCAmaXRlcik7DQo+ICAgCWlmIChyZXQgPCAwKQ0KPiAg
IAkJZ290byBvdXRfYWNjdDsNCj4gQEAgLTQ5MzYsOCArNDk2MCw4IEBAIHN0YXRpYyBpbnQgYnRy
ZnNfdXJpbmdfZW5jb2RlZF9yZWFkKHN0cnVjdCBpb191cmluZ19jbWQgKmNtZCwgdW5zaWduZWQg
aW50IGlzc3VlDQo+ICAgCQlnb3RvIG91dF9mcmVlOw0KPiAgIAl9DQo+ICAgDQo+IC0JcG9zID0g
YXJncy5vZmZzZXQ7DQo+IC0JcmV0ID0gcndfdmVyaWZ5X2FyZWEoUkVBRCwgZmlsZSwgJnBvcywg
YXJncy5sZW4pOw0KPiArCXBvcyA9IGFyZ3MtPm9mZnNldDsNCj4gKwlyZXQgPSByd192ZXJpZnlf
YXJlYShSRUFELCBmaWxlLCAmcG9zLCBhcmdzLT5sZW4pOw0KPiAgIAlpZiAocmV0IDwgMCkNCj4g
ICAJCWdvdG8gb3V0X2ZyZWU7DQo+ICAgDQo+IEBAIC00OTUwLDE1ICs0OTc0LDE1IEBAIHN0YXRp
YyBpbnQgYnRyZnNfdXJpbmdfZW5jb2RlZF9yZWFkKHN0cnVjdCBpb191cmluZ19jbWQgKmNtZCwg
dW5zaWduZWQgaW50IGlzc3VlDQo+ICAgCXN0YXJ0ID0gQUxJR05fRE9XTihwb3MsIGZzX2luZm8t
PnNlY3RvcnNpemUpOw0KPiAgIAlsb2NrZW5kID0gc3RhcnQgKyBCVFJGU19NQVhfVU5DT01QUkVT
U0VEIC0gMTsNCj4gICANCj4gLQlyZXQgPSBidHJmc19lbmNvZGVkX3JlYWQoJmtpb2NiLCAmaXRl
ciwgJmFyZ3MsICZjYWNoZWRfc3RhdGUsDQo+ICsJcmV0ID0gYnRyZnNfZW5jb2RlZF9yZWFkKCZr
aW9jYiwgJml0ZXIsIGFyZ3MsICZjYWNoZWRfc3RhdGUsDQo+ICAgCQkJCSAmZGlza19ieXRlbnIs
ICZkaXNrX2lvX3NpemUpOw0KPiAgIAlpZiAocmV0IDwgMCAmJiByZXQgIT0gLUVJT0NCUVVFVUVE
KQ0KPiAgIAkJZ290byBvdXRfZnJlZTsNCj4gICANCj4gICAJZmlsZV9hY2Nlc3NlZChmaWxlKTsN
Cj4gICANCj4gLQlpZiAoY29weV90b191c2VyKHNxZV9hZGRyICsgY29weV9lbmQsIChjb25zdCBj
aGFyICopJmFyZ3MgKyBjb3B5X2VuZF9rZXJuZWwsDQo+IC0JCQkgc2l6ZW9mKGFyZ3MpIC0gY29w
eV9lbmRfa2VybmVsKSkgew0KPiArCWlmIChjb3B5X3RvX3VzZXIoc3FlX2FkZHIgKyBjb3B5X2Vu
ZCwgKGNvbnN0IGNoYXIgKilhcmdzICsgY29weV9lbmRfa2VybmVsLA0KPiArCQkJIHNpemVvZigq
YXJncykgLSBjb3B5X2VuZF9rZXJuZWwpKSB7DQo+ICAgCQlpZiAocmV0ID09IC1FSU9DQlFVRVVF
RCkgew0KPiAgIAkJCXVubG9ja19leHRlbnQoaW9fdHJlZSwgc3RhcnQsIGxvY2tlbmQsICZjYWNo
ZWRfc3RhdGUpOw0KPiAgIAkJCWJ0cmZzX2lub2RlX3VubG9jayhpbm9kZSwgQlRSRlNfSUxPQ0tf
U0hBUkVEKTsNCj4gQEAgLTQ5NzUsNyArNDk5OSw3IEBAIHN0YXRpYyBpbnQgYnRyZnNfdXJpbmdf
ZW5jb2RlZF9yZWFkKHN0cnVjdCBpb191cmluZ19jbWQgKmNtZCwgdW5zaWduZWQgaW50IGlzc3Vl
DQo+ICAgCQkgKiB1bmRvIHRoaXMuDQo+ICAgCQkgKi8NCj4gICAJCWlmICghaW92KSB7DQo+IC0J
CQlpb3YgPSBrbWVtZHVwKGlvdnN0YWNrLCBzaXplb2Yoc3RydWN0IGlvdmVjKSAqIGFyZ3MuaW92
Y250LA0KPiArCQkJaW92ID0ga21lbWR1cChpb3ZzdGFjaywgc2l6ZW9mKHN0cnVjdCBpb3ZlYykg
KiBhcmdzLT5pb3ZjbnQsDQo+ICAgCQkJCSAgICAgIEdGUF9OT0ZTKTsNCj4gICAJCQlpZiAoIWlv
dikgew0KPiAgIAkJCQl1bmxvY2tfZXh0ZW50KGlvX3RyZWUsIHN0YXJ0LCBsb2NrZW5kLCAmY2Fj
aGVkX3N0YXRlKTsNCj4gQEAgLTQ5ODgsMTMgKzUwMTIsMTMgQEAgc3RhdGljIGludCBidHJmc191
cmluZ19lbmNvZGVkX3JlYWQoc3RydWN0IGlvX3VyaW5nX2NtZCAqY21kLCB1bnNpZ25lZCBpbnQg
aXNzdWUNCj4gICAJCWNvdW50ID0gbWluX3QodTY0LCBpb3ZfaXRlcl9jb3VudCgmaXRlciksIGRp
c2tfaW9fc2l6ZSk7DQo+ICAgDQo+ICAgCQkvKiBNYXRjaCBpb2N0bCBieSBub3QgcmV0dXJuaW5n
IHBhc3QgRU9GIGlmIHVuY29tcHJlc3NlZC4gKi8NCj4gLQkJaWYgKCFhcmdzLmNvbXByZXNzaW9u
KQ0KPiAtCQkJY291bnQgPSBtaW5fdCh1NjQsIGNvdW50LCBhcmdzLmxlbik7DQo+ICsJCWlmICgh
YXJncy0+Y29tcHJlc3Npb24pDQo+ICsJCQljb3VudCA9IG1pbl90KHU2NCwgY291bnQsIGFyZ3Mt
Pmxlbik7DQo+ICAgDQo+ICAgCQlyZXQgPSBidHJmc191cmluZ19yZWFkX2V4dGVudCgma2lvY2Is
ICZpdGVyLCBzdGFydCwgbG9ja2VuZCwNCj4gICAJCQkJCSAgICAgIGNhY2hlZF9zdGF0ZSwgZGlz
a19ieXRlbnIsDQo+ICAgCQkJCQkgICAgICBkaXNrX2lvX3NpemUsIGNvdW50LA0KPiAtCQkJCQkg
ICAgICBhcmdzLmNvbXByZXNzaW9uLCBpb3YsIGNtZCk7DQo+ICsJCQkJCSAgICAgIGFyZ3MtPmNv
bXByZXNzaW9uLCBpb3YsIGNtZCk7DQo+ICAgDQo+ICAgCQlnb3RvIG91dF9hY2N0Ow0KPiAgIAl9
DQoNCg==

