Return-Path: <io-uring+bounces-10550-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A1CCC54DE5
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 01:00:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 46A4B4E0537
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 00:00:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D3931DED49;
	Thu, 13 Nov 2025 00:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hQLsYzTC"
X-Original-To: io-uring@vger.kernel.org
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010062.outbound.protection.outlook.com [52.101.61.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF96A136672;
	Thu, 13 Nov 2025 00:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762992045; cv=fail; b=hxWHHsNUnvNcOVJdrItwDbU2UBC6qXVC192YVqYFnwQnMW8+W6fU07qlKYVL94ziG9jjuIrmqK/QkcNaGzGI6RPNrmJmHbRXAetsgoiGHyinM3yvG+Bn+Ya+Ms60Vk4sgquyMtjgE/wmnntSnI3XZ/PkrP1KcEjYquksnQ5E8iY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762992045; c=relaxed/simple;
	bh=bfieta7j6WKZuzS3vcjWAIwdBPSakfsGsQSKDZu0qLM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KlVNKrPyPye8yIHIEEQma3wekyADxRTXCjJm8Wp25TwrrPuPae2xd2ROuxaH99JEkjCMnDUXK4aog/Oo/6vKlHj+ZPNFiCA/jsnokvVSWm8vIQQsanGI0ITd95/7HrqynNRDrEsL1LMXxpIWMFTzm+wHTi+9LKHLj7b97nA33zQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hQLsYzTC; arc=fail smtp.client-ip=52.101.61.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CpCK0OPC48qhZ6zofAM+tEvGue+OSf9mssZc9s9pyCobu2SxIxMkbQ9lXjK0uePv2rh3Xmgko5YJAVpsvdSxmer2XZi8EgqAkW5uf+LnnN6Xzpq3h5Pe6EXF+Bjhv0sSBDH0E2dECsgstokLYGaYzppNApQTQcVUBRxPYfUs37p8i2NGmi74qRRPsqkyw6wGVu/1lvpj7cCzIiXMUUt2nlHrDTrmQBfzm47vk7Dao5p/S1KyKMqdxo/LbYZUEJYx8ck7yXb1NyLIjXT339YUHPetRoYOfMPg2Ewfk2ngL89c2xZ3H3kyyu4Gg9QnkH2Ph17RgZapfuG4Xm/l7POGZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bfieta7j6WKZuzS3vcjWAIwdBPSakfsGsQSKDZu0qLM=;
 b=VQyNN3bfmaWI/mUUM2CRLf1VQ1iP7NViOL5/7LRrKKGlwT/K6GzzWvVzGKqL9bItHYXo/aqlekGIINQVC2N+5EgSlIp6yywbFX7uiUHFajOCZ2x/46q3jjbulZ4I4LEi5tQ6NFCH+XOA7UQljE6hbkXcu5+/CqaslwtwjHon/ip+fL5C2L/w34eVbsWQ8k7f7+kp3rmqSxrDxKgV7meUeysMRJ/PmS+VbE3VwsQu15PgB+9wCOuP7AzLhve/5R6rPoVSYvyXFFbXf3Rf1u+Kpq1G54Jsfrh9B7FRJKNgf2MwR7ZNr3QV1Vbk2x/qrn1uZCbS1ZULeoFyU4j/eRZkUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bfieta7j6WKZuzS3vcjWAIwdBPSakfsGsQSKDZu0qLM=;
 b=hQLsYzTCUFL5V30/36GduBRwPTkj+l6IO/tqRhx8MmwSmOxhrXdxJCQgkSftOdqTJLjI1rZaeGXrCSMkBZDE4nOnbELuYK0PonpHYTBCMgTmhIRR6kM54HU0imU+kkH5DCnM4Se+bkudXUXWF71JvuJ5nXNXnN8UCYp8GS71O9GEU+jqYxgIMmFzT1tCxJLhtsV8qqe1gJ36Q2banKm+gcDCKU0BpHNZKWVEEICXiSQskRF3pO9ZtAieUC70oP+mudNpg9VWxb/jirI4r8uuC/lFCeF+K27beDK2u9MSdY6AWdh+60SOyWA8o9rPC4KCIZMl1xFCIAgbeRXhzwlalw==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by LV3PR12MB9185.namprd12.prod.outlook.com (2603:10b6:408:199::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.16; Thu, 13 Nov
 2025 00:00:36 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%5]) with mapi id 15.20.9298.015; Thu, 13 Nov 2025
 00:00:36 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>
CC: Alexander Viro <viro@zeniv.linux.org.uk>, "Darrick J. Wong"
	<djwong@kernel.org>, Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>,
	Avi Kivity <avi@scylladb.com>, Damien Le Moal <dlemoal@kernel.org>, Naohiro
 Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Re: [PATCH 1/5] fs, iomap: remove IOCB_DIO_CALLER_COMP
Thread-Topic: [PATCH 1/5] fs, iomap: remove IOCB_DIO_CALLER_COMP
Thread-Index: AQHcU6U2nMBhiPBc20OZP1KYy5TWPLTvuceA
Date: Thu, 13 Nov 2025 00:00:36 +0000
Message-ID: <a8748927-15ee-4636-a530-4f1e78570c2c@nvidia.com>
References: <20251112072214.844816-1-hch@lst.de>
 <20251112072214.844816-2-hch@lst.de>
In-Reply-To: <20251112072214.844816-2-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|LV3PR12MB9185:EE_
x-ms-office365-filtering-correlation-id: 45fe39a2-c6af-4c10-5ab6-08de2247ac79
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|10070799003|7416014|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?dzNDS0xmdVFBbXpmUmcwemliekZOKzZXdkpjbVJOYzMrbmk0VUxhenFYSEhB?=
 =?utf-8?B?YmJ4OEtPRVAzT1ZTbW1tT3ZFdFpGTGhMK2J3SXV5T1RSVWlTYzRBcUdZZTl0?=
 =?utf-8?B?U05zOWJOM2RxNmd4N1l1NGNwT0VUci94UTh1QTM1Ym5TWGxhRll5Mm1jNVN4?=
 =?utf-8?B?eW9NN0NueU5JQlJobHZyc0lZckhlTEVrN0tiN21wYXozNEpKK01Vb0FjUVl4?=
 =?utf-8?B?N3JxZmdkaEU1T1BZeWNJdklXem1wZTgxQWZYdWsxaUM0MXRnU3E5bk9DMlYv?=
 =?utf-8?B?QWQ2d1B0Q2IrZ3ZaMDRNNGNXYXgyNktGM2R1Tm56YkJFOFVQUUFBTVlpN0ZE?=
 =?utf-8?B?ZGlUSFBKOWVoZFlRNmV3b2hLVGdpTzJINytiTHI1TW5vUVIxMElrZW9yS1Jm?=
 =?utf-8?B?L0ZmaDdlSGRta2ttV2lCQVJzMkQ0Sk1ITk85Qm5hQXNTVWE4VXFVazcranJk?=
 =?utf-8?B?eWczR2hhYVlYemJCeXQ1dFI0Z0NQMmw1UFJycE5yc2k1UU44Zms5TG9HdmF1?=
 =?utf-8?B?SkQrVnB3dXUyR0luL2VnTU9BK1dkbUdHTmpSRXpSSGJEa3ozZ3paWlBVbFpO?=
 =?utf-8?B?aUp3YmRwejNFTmxKenIzeEdJSlAwZVVlR1BZeUxxRjFOQ3ROTmxOWjlyRlZP?=
 =?utf-8?B?dTNmMG1qK0VsV0JEWVVZUFBFTHRrVml6OHc1c3ZnYUNPRmFNYjliUlh3Unpm?=
 =?utf-8?B?bGkzU0tUcDZIeGtMUFcrNlpZdHpzKzNlNzIrdEtpaVBxeE5aeXl1WWd2TmJZ?=
 =?utf-8?B?OExoUUt0MjQ0Qms3WWs3cndKa29wYTE5eGJZRUFUVXpBUlNSMUJuRkdBRXVU?=
 =?utf-8?B?RlRaTWk2ZEl5TEI3bEpRaDdQaStES3ZEMnBXMGhKZk0rOUtyWlpVMlhIcDN2?=
 =?utf-8?B?cVd5VGxmRjQ2ZndhbTY5dXZJeDRVTDdPUVROcFJQUXZOajB0RlBER0N0Q0hT?=
 =?utf-8?B?Z0RaRVMvSXhadEFrTHRhNXF6NTFPeXNXRUNTQjhzemMrcWhlYzVCOEJ4QlJ3?=
 =?utf-8?B?ejhwYmlYZndlekpCMHJkL1ZRdFFmYVlIZ2FKTlhjQkZJdXJCMTNEUGpMWXJI?=
 =?utf-8?B?aEN2UlJJRThjVVlKQ1FndDV5bVp4Q3Fpa0EyYjg5cDh3QlN0R3FmVXA1djdC?=
 =?utf-8?B?bHpocDIrSjBNL2dEdW1ybDM1a2dJM0ErMUJwVGh3OW9HcExHdEJLL2hqZ3N2?=
 =?utf-8?B?NjBUYjZYb2FISTFzMTJVQ3RJdFZTU0huMjlLdjJmT25FVWF3SkFKbGkzejJB?=
 =?utf-8?B?NUtwREpQNVFsd0xvZUlxQ0k0YkVZSUp1NHhWRE9xM1hCRmgxcTVRd1Fkd1V6?=
 =?utf-8?B?RHc1NE5xcnR5WGVJN292bXpsbUkrT1VlbDBEcm8wcW5mQVB5My90UTRDd3R5?=
 =?utf-8?B?RVdWTjJaQXNOR3dPS1lMNnhKK1RZSjA2cUJIdFZ2UzFJcmtWS0RKdThXQ1ZU?=
 =?utf-8?B?dDIrMWllbS9SUVM4Wk1yVUwzYXBSOFNMZTFNMCtxZ2t6cEU2dnRGUWUrMURm?=
 =?utf-8?B?VnU2STNqYkltVzdxSU1jOWZVM3FQNkZwY3I4UHN6YWdvQ2x4NjlFaEczQ2NV?=
 =?utf-8?B?Z09tRnl1STVwYnRvenlkSVFmNmpVSGRaUnZaZ1l3VXc0TXRSY1p1cmxsMlJx?=
 =?utf-8?B?dVpFeTA4clY4OXFXR3ArN0FGS1R6N05nSzY5eGFvdDdBZnVPWEIxdmpTWjlR?=
 =?utf-8?B?blhpc3pqUTRicnpwTUZWUkNCZTRXUFRiMGpjY2ZDZkd5eDcrNkpMMS9pOXBU?=
 =?utf-8?B?cVY3RmZFbGtGS210RnZPR29yV0c0V2dqMllOZUd5T09uNHVPdXRLT0tZb3FM?=
 =?utf-8?B?K2IrTXBheXJnTmRCNk51WG1ERzlLaTFzZExvRlJkWFliWTBuYUY1UnRIczVX?=
 =?utf-8?B?VVdIc2V0Q3JjNVNIRTY2bEdZaGJmM0hWeXdjdk1IbU5ZSnFOcVArR3ZhdDUx?=
 =?utf-8?B?WmM0N2t5T3E4LzFldmUvRHZzVjhkR2htVlhqWXlYdjkrQU1oaTM0R0F3WGFD?=
 =?utf-8?B?Vy9uNEZSWHJPQ2hhdkRFemdvTFowTzF4U1h5WFBKdWN6OS9kWTh2L090OTdE?=
 =?utf-8?Q?JXZfOC?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(10070799003)(7416014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WHRCQVFYTmZpWTdVOFkzYjk4Rm9oS3djMGo0TXJpQjlvQWtDTUdYSmVwOWtF?=
 =?utf-8?B?SHhVVWpyNXpVTStuUzMrWDRIMTcrVGhaUnpIYS9rL3JKQlIrZDBSSUJzUSti?=
 =?utf-8?B?UURMTFkyUkwzeGZNcHpRU1h1dVlXY3FlT1dTVmQ2U2xPdUVJc00yRkV4Qmxn?=
 =?utf-8?B?TnJvbXIrMDJiMmJpUWFVaElvUm0ycENHWHFNVmZUWmxTM2doNVRIT083ck9Q?=
 =?utf-8?B?U0dxZmw5VVdVZHFkUFRqNHpGa2hqVDVkOEE3K0QwaVIyOTRTQzgzM0k4RG1G?=
 =?utf-8?B?a21oMjc3UzdEZWhuZVFLL2htK1ZrZEZPb1dqdU9TRFZtWWFWSzgrbGQzQ1Y5?=
 =?utf-8?B?dFNGUFRXcWt5MW40ajBEMGFiRUNKZ0t0enU3NE9XWE9VK1llZ2F4UzFyN1VR?=
 =?utf-8?B?U1JoWVBLMEQwVlIvYnZyVE1TOVRyQ2hta0xRNjh4U0dRRDFCa3hHSFcrTEFL?=
 =?utf-8?B?QVdIQUhBSXVVaC9rRm5yQ2Z5Zjh3L0VXcFR6LzRacGVZalZlaHhKdXdMNVlv?=
 =?utf-8?B?TGtNTDQzSjBINjVYVERLK2hMUXRwOWhoemd5dU1FRE9ETWpOQ3ZlRzZSQUNO?=
 =?utf-8?B?UzhGMTA5cEUxUlVWV2FnVGU4MTFVczVuN1lhS1IyU2hINmpIWGJ6bUE0UUxt?=
 =?utf-8?B?d1BaS3JQc2tVSFRRVENpR1A3N1VMc2ZSN2F6VzFmaE9PdU5JbVFVSHM3dmVB?=
 =?utf-8?B?ZDJuV3dJNHFvVWhwZjdlWDhGUzhTaFlRcVdMejlTblNhRUE3cnJCdXdvNnhv?=
 =?utf-8?B?NkxYY3MzV0tMSWpnL3N1c3VEL2FWM0JZeWFpS3JLQXR0VVVWbTRDYVhGYkJ0?=
 =?utf-8?B?a2FqL2MvTGFWN0IrajhsVldnK0NGZkxtTkxKRjdwK1NrSE5vNHhrT2RqRnNJ?=
 =?utf-8?B?ZlRCWCtycDhZS3FzNk9ldm1TcENxcmdVTEhZK3hqU0pXUVVhc3NpdU9ydTNy?=
 =?utf-8?B?ZHlWc3loMUg5UXRBa0JpTW5FVnU4cy91U1BlT2NyeHlvVjF1UEl3NlhtTmkr?=
 =?utf-8?B?ZHJpT2ZNWlBrWGxpNGVSM1RJcnZzM0FvYW02YWgyL0cyT3h4c2htVWhWdnAz?=
 =?utf-8?B?RFVhcFJpNWpYRmtkRnpUdms2MkdabTVQS1RGZnovN2dYcGFobnhIVEVEMTQ4?=
 =?utf-8?B?a3JZR1ZzRDlWTVNIbkEyTmNROWNkS1J1bVc5TWI4b1BjTHlrU1UrVUFzZXBM?=
 =?utf-8?B?bktWbitaUDNUMURpVGoyeVBVbU52NHRNWVNIQWtrZkRIenVoRE85S3F6US9l?=
 =?utf-8?B?TWlqSnZNbE1vSkdiSmpScUg2NnQyMlVTK0w3V3BLWU94M0k3RkZ6Qjd3L01R?=
 =?utf-8?B?ZFJZc2twaFcxc0gxYTlSYjNrUnJEUmVIUHNXeW1VOFZlQ25hN2lLckc5bTZp?=
 =?utf-8?B?QnRtTmZtbXRhY0RxaWFYcGxPa2s5REw1NTNlTkdNc2t2Y3ZnMm9sbkx2ZHI1?=
 =?utf-8?B?cUcrRytUL1lJU3F6SjlNNGRPWG9IMEJ0Q3lmZDFWdGFacFl1RVFSYVVNdjQy?=
 =?utf-8?B?RmFtaTFKZEtMd2FVbFBjc0h6M094K2Y3RHB2ZzRVTHVhM1JnbmFQdXVYY2E3?=
 =?utf-8?B?NnpINU5QYzNER1hUalZHcVVGc0VOd1NrRFUrS3VoWmMxMDd3WFVnb0xMVnhZ?=
 =?utf-8?B?U0ZvVjBuYjY4b1BvN0oxSUR4MUVPaktJSE5OZkNUUUQyQzJ5bjN2Qy8zWXMx?=
 =?utf-8?B?RlpCUVF4K2NTcnV4ampyYVdRLzgzcUxRZlNNREc0OURtd1NVbjRnZmtKRkZH?=
 =?utf-8?B?WGFuV1BlY081Mmw2Vm1HYmhaYjErTU5jWjNZL3VZalN3WUMwYXVVZkZxczNw?=
 =?utf-8?B?VmtWZmZtY0hvd01NY1M3VGNoU09DRytqNUhtQm5hVVY5cW5VcVczaDhSdmc0?=
 =?utf-8?B?QXo2ZVVhYVRiYUdOMUZjU09pRHNGWWZsTHZLK3hqOTh1blRLbHVYQndLOHB1?=
 =?utf-8?B?QWRoRDBnVTJJbG9saExMMi9ZYVBTMzQ5cTY1UkJFTzBySDUzRkkrTWF5K0RY?=
 =?utf-8?B?Q3BUaHErYlRBUXEvbzEvY2x4ajMvZVk4UkpkeExObUViVDNQQUFadDRodi9o?=
 =?utf-8?B?eEFMVUpRK3IwYytvYTV4V25qZkhLNXQwVkxvOHZRNzhYL2FwYmRsdFcxeDUx?=
 =?utf-8?B?Ump0MlAzOTYwazc0YXg2UmIrMFZTMVlVOTJwcWRnaEthUVk0SlR4OXNraGw2?=
 =?utf-8?Q?t9fyZdSIqhyDZun+xikudAk4vJeI6QBDVLnXHro7KyEk?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <28C55A9542527B4EAF24D1CCEC5838AD@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 45fe39a2-c6af-4c10-5ab6-08de2247ac79
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2025 00:00:36.4619
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zFFdrKnTLPP7pQEw3DJV0Q2FBF8JmD6TK2GJ5AqzMKBfd3Q16V4iFHPB+ceq1fJ7G00/yFfDWhsR+O3mnRSWcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9185

T24gMTEvMTEvMjUgMjM6MjEsIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOg0KPiBUaGlzIHdhcyBh
ZGRlZCBieSBjb21taXQgMDk5YWRhMmM4NzI2ICgiaW9fdXJpbmcvcnc6IGFkZCB3cml0ZSBzdXBw
b3J0DQo+IGZvciBJT0NCX0RJT19DQUxMRVJfQ09NUCIpIGFuZCBkaXNhYmxlZCBhIGxpdHRsZSBs
YXRlciBieSBjb21taXQNCj4gODM4YjM1YmI2YTg5ICgiaW9fdXJpbmcvcnc6IGRpc2FibGUgSU9D
Ql9ESU9fQ0FMTEVSX0NPTVAiKSBiZWNhdXNlIGl0DQo+IGRpZG4ndCB3b3JrLiAgUmVtb3ZlIGFs
bCB0aGUgcmVsYXRlZCBjb2RlIHRoYXQgc2F0IHVudXNlZCBmb3IgMiB5ZWFycy4NCj4NCj4gU2ln
bmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWc8aGNoQGxzdC5kZT4NCj4gLS0tDQoNCioqTG9v
a3MgZ29vZC4NCg0KUmV2aWV3ZWQtYnk6IENoYWl0YW55YSBLdWxrYXJuaSA8a2NoQG52aWRpYS5j
b20+DQoNCi1jaw0KDQoNCg==

