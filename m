Return-Path: <io-uring+bounces-10297-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B343FC228C0
	for <lists+io-uring@lfdr.de>; Thu, 30 Oct 2025 23:24:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 95EA54E3566
	for <lists+io-uring@lfdr.de>; Thu, 30 Oct 2025 22:24:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DC9E3128C4;
	Thu, 30 Oct 2025 22:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="hiu+t/4Z"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11EBD31328E;
	Thu, 30 Oct 2025 22:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761863042; cv=fail; b=HivdFa+bmCnBSC3LFdWXavpr7Q7g7UMv76LLYer4cZlJiBrVhb7K5PhyLZvI+75LQRya4RZgQJGGeNrrRxaVYENmDfgNuTHeqGMGIK7ndj9WefKVUY3B/aXnwjCt/JsuYGQGNfYcAh16dFFAlmfQ67SluNv2/dwNoYmK9fJZu7Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761863042; c=relaxed/simple;
	bh=TIA8mAgr2NSFLdImqr6w/utKblLKdTe5+KwFKAUv0Mk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=o2dGN9bS3Al4Wj3RqBNKwXH0U0YPpiJyiabKRhjICMkHWW5UzqBYFqrn5snUsgBfpIe/B8K4+FEtQfW2cpDJOngP5SA0l+kcX8jzHez8GQ1rCxANGprNAt1rN5irthd82A8oCxCBMA+1c34waUUd1HwfC+u1Y8OCOwKE3qTi7Hc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=hiu+t/4Z; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11020100.outbound.protection.outlook.com [52.101.193.100]) by mx-outbound43-219.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 30 Oct 2025 22:23:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TYU8/rSRr300boJ5NVKmpS8u5TmakcXjKvzYD/39AxCYM7WvYvZHU7inI23D1OEsslwYuFiBKnR+QbnGmZn+qZWB/AzbPWU5hCdUGqjb7vYrIs416Se2GQELj+KvbT+AoFzIvLXVVgeGz6lMnJv87g0QC4guNgTknsxx4wlNsh+QV+6yA8wrgcwy2lFGLHnnHeKA+eZGRQhv/8Y5uZIuMDpqZR6z8sx3pPcm+DVXlCSHTrspGm9FpX33ZjAG3njy+94ifdOp/EFGmKvL1qxIfL7GKdNlVf4ysZjn7jxJSqqKCLOvTGnht2PhACfxFUU2ZlE1lOztDfBs2T3+fmx4wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RjFvUQOwfRwixtKbGXQJG/5yHyuoW554B1AiTxQ4jYg=;
 b=X+xAj+7WUKrdigwyguGJRwS7DC8BRQK4v7M5AZzEsYO37LjPJuQg7ga+5xTbzQYKK84MyroZXkUsxFYd7AQQyAVEVwSexFVCH1ZIfcr7pcDbiSonBwixPasXg3DhWHZijL6lxuUx2PT0LU1lAXYrv1ztZzL2C3d9xoGN5fjbW18A+9WVPlqCz3D5uIpTShM1QKJ6kmrhLforMCW9WNVuMVEcLW8iGaH21yce3uTOBNjBizuApYaAAGZB074FFGLsiTRret+qIKLqVFpNWXkCKdkLexn1ccmDcl30jeEOjgXebQ6PaTyOgOM4W46M0YMyOKPMp32LIxOT1rOxht2jyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RjFvUQOwfRwixtKbGXQJG/5yHyuoW554B1AiTxQ4jYg=;
 b=hiu+t/4ZkfLw4v67lvlRKVFYqnrV9wvPDsfidvDG/+MVbvAm9T+oXX874y0chBLNg1ag5o+FbPvA84u0QRxYH6j6xafqH1LFWHyXCetKEukgW4Ju2AeFuYIcTYyLudFassObQoW/tKFsdZAV5O3rw2TgZAoI0uPggH9+7nOHAv4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
Received: from CH2PR19MB3864.namprd19.prod.outlook.com (2603:10b6:610:93::21)
 by BL1PR19MB5723.namprd19.prod.outlook.com (2603:10b6:208:392::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.14; Thu, 30 Oct
 2025 22:23:42 +0000
Received: from CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::abe1:8b29:6aaa:8f03]) by CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::abe1:8b29:6aaa:8f03%5]) with mapi id 15.20.9275.013; Thu, 30 Oct 2025
 22:23:41 +0000
Message-ID: <96c4d33d-4f56-4937-bae7-9bda17f3264f@ddn.com>
Date: Thu, 30 Oct 2025 23:23:37 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/8] io_uring/uring_cmd: add
 io_uring_cmd_import_fixed_full()
To: Pavel Begunkov <asml.silence@gmail.com>,
 Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, xiaobing.li@samsung.com, csander@purestorage.com,
 kernel-team@meta.com
References: <20251027222808.2332692-1-joannelkoong@gmail.com>
 <20251027222808.2332692-2-joannelkoong@gmail.com>
 <455fe1cb-bff1-4716-add7-cc4edecc98d2@gmail.com>
 <CAJnrk1ZaGkEdWwhR=4nQe4kQOp6KqQQHRoS7GbTRcwnKrR5A3g@mail.gmail.com>
 <9f0debb1-ce0e-4085-a3fe-0da7a8fd76a6@gmail.com>
From: Bernd Schubert <bschubert@ddn.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <9f0debb1-ce0e-4085-a3fe-0da7a8fd76a6@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PR1P264CA0081.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:2cc::19) To CH2PR19MB3864.namprd19.prod.outlook.com
 (2603:10b6:610:93::21)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR19MB3864:EE_|BL1PR19MB5723:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ba81bea-6b6a-443d-a8f2-08de1802fb02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|366016|19092799006|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dkZVVm54UTFJaGxUM0dnOXNvUEdYZFFWd0lsQXdKL21tQ3NWT2V0ZVNFZHpx?=
 =?utf-8?B?Z2dnY1hIWHRndDY2dFkyclFaanh2dUswblZQSkk0dU16bzRsZjVHUWI4TTZo?=
 =?utf-8?B?NStScml3bTV6Ym1nUFpmTmw5ZnB1VTF1YXI1R3JjOTcxZVgrWHJkelIvUWRu?=
 =?utf-8?B?cEI2eGRrRjRQQW9tUHFCcVFnYUdyRUV1a0pjK290bzN3cGVOVndvemVVaW9I?=
 =?utf-8?B?bWlOQUIzM1pMQ01UbzJ6em9zVHBEbmNUREIxMEJkZFN0Nm0xeXV4YStXQWlv?=
 =?utf-8?B?b1NZSllTbTJmSVZPWVpwWXZPRDFibi9EdzNydVRtZWpId0pqNUh4YlpPK3Y2?=
 =?utf-8?B?eDhlSC9GQUNaYnN3enllUDlwNUcwUmtGQjczNTV3bDU2VmFOQ0dyK2RFZi9T?=
 =?utf-8?B?TEdEZnlkS2ZrdldCWngxN20yaThmdkdjVitNZUpFajFpWWhRZWRubE80QW5x?=
 =?utf-8?B?QVk5NDAzT3I1cXd1bmZOVXhYWHdUbXRMZE9jSE9TZ056eXMzR200RWgyaWN4?=
 =?utf-8?B?QUV5RUtWOHhmQWg5dTJmK1F2UytPbEFmanN1cHpTa2xVVU5VQkdobXhubVBo?=
 =?utf-8?B?SmFnemVzT29ScFpRZWZOaVdiWXFlNWE4RVVPTlVHbmt1aFBWUzcvUVdCWW41?=
 =?utf-8?B?UkIxMXM4REUzd2JFVUNINXVpZUFaRDlEWXZXOGpacUhZUityb2dkUWRRNDJi?=
 =?utf-8?B?T2tQN1VmeHlBTnRpK2ppTnBCbWhZeVl1RllQNnAzNVdpeE85b25BT2xzMlRx?=
 =?utf-8?B?RFhkSXpIRWhXekRYcFcveFA5ckROaE9JNVZlSWJ0L3Z5cWt2RkhGcEtrMThO?=
 =?utf-8?B?TFp3MDZyQUxFT2ozWCt1N3VWaVAxekdzZ3l3ZXJ3Nllna2M1QzQ1QitReUJo?=
 =?utf-8?B?K1VQM0pWZEQ2aW41eHhjYm9UdFAyaFZobzVtQkc3WFIzcDBNKzZVeUZhNUE4?=
 =?utf-8?B?NkJnUE13Wm5aSnZLRVZMalprU3FtVGJlUDI5ZUFTc3NOby96K3JCd0tGNTFV?=
 =?utf-8?B?dTRmelVmM2VvOUxMWnZpaVlkVjQzdEw2M1o1MDlHTGFtTTVaS2NmT09pSnp2?=
 =?utf-8?B?a2VrVmtNTzNPSXdsVUwvTzJTMnZObkxFR2NrOEV6SUJEb05iSTJiSmlTS0NG?=
 =?utf-8?B?T3hmVCtBTHdsdlhuWTNhSUs1MDFVSXJTcFBqS2FmbHA5dmdsYmtEM0dVUy9k?=
 =?utf-8?B?ajBEYXdzaVoxcGIvSlZvOE5JZWJTcEI5b1dqRUlFNktpbHVQQ0hxSUhJdEhB?=
 =?utf-8?B?MGJQemVKRjRFencwTTNmWlFLSGxvNmc3MVUyMjhabEdDaVRiTE0vMVlyOXhX?=
 =?utf-8?B?eEZ1dUwwYVREYm5nMHFBSXVjYmhJeWRuZi9OYlhUYzQySmY1dWQvb1hHdjlD?=
 =?utf-8?B?QVBTMDV1UU1kSndtTEJFM3ZzM2RWWW83S2ZTeEhIZkJ4YTd6ZmdHZWtiYjhh?=
 =?utf-8?B?b0tMYlJhUnpiV1RSR3VEc0IzWVdzVEFPcDFJNnFzaG9vNE1mMGFXWms0UmZ3?=
 =?utf-8?B?d0xzRHlKME5CajFvcEljVi80OFJqM3RmeGxqT2M4QytCVk9CY0ovZVhYSE5V?=
 =?utf-8?B?cjFoVkVORVRHV2MrWnFpOXB3aGxReS9ZMldXK2lxSWpCL2w1NHJGcTZ2ZmlF?=
 =?utf-8?B?cUNHVktXNGFWb2N0UDBCOGQ5WFhZWnpOTUVVajRkMXZrYis4S1NHdWx5T0VP?=
 =?utf-8?B?dExGTE9wenR3dlBnR3c1VjBLK2NyejNCWEc2SnkrQlFQcTVCM3NQVnhNeFo4?=
 =?utf-8?B?NkJiZFZWbkQvZHcxbUpRbWRUK0U0ZmhvTGhGbnBFMENFS042TU9UY0VmaU4r?=
 =?utf-8?B?NUszcS8xKzNkTlU2eno2SlI2dFJZc0Zscmc0Y2RuRW1IckdzNzdycHNOZjFr?=
 =?utf-8?B?R3dXcjIwZHdDWVlCYTM2bGtEQzhMajlKb0NsVlVuQ1NramZHZUtmMCthRTBX?=
 =?utf-8?Q?812iMhpGiuFC4rsMG7fGowaptVE7kd5O?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR19MB3864.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(366016)(19092799006)(376014)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OWNYMGgrTGdHekx1eEFvcEZVS1pzQ1J0YStDeVdyVlYzRXNxRjVwZWtFRDlr?=
 =?utf-8?B?ZFdhQ2w2ZWhPa0xSa2NlUjhRUjBlVGtJSHgvWGltNlk0eTVMcFFCdHNlZlcz?=
 =?utf-8?B?RXc2NWdxNjZteUkzV2x5cE4zRUdMamg1ckN0VjBidWN5eTBmMC8vOUh1ejFz?=
 =?utf-8?B?TWhsS01GRnBQRlNJUlhTanV5ano0aGMyL2xVRmNNRHlwMHdRMGtVTGo5aGxl?=
 =?utf-8?B?VW5KYVNHWlNaMnpNWUR0SHNWc2tQVjIzY2hUbFlqMkQ1eEdwV3l1OFJ5ZGpF?=
 =?utf-8?B?NzBEWmpncno4ZjZ2WFF4Z2dkVlU0cFBDcEFvbm54OWh2MXJTVDV1VUxWbGZr?=
 =?utf-8?B?b0JRNFVHbTM0Y3ZHcGlKbnZEY2J3MVV3U21vQWdtckV2UXd3Si9SUEk1UlJt?=
 =?utf-8?B?ekxjdENsVDg0NmMwbEgyOHRmamNmMU9NUFR2cWFuZnNlODZ5RERVK0RteGZW?=
 =?utf-8?B?UjJoYVFGSnhkenh0M2hrODZsNForY2gyUmRDMys4NDVsZkdELzdkTWx6amlG?=
 =?utf-8?B?RnRTVE4xZm0ybCtYSUZtVjdmQXdLa0JEbmhMRFVvSUxNTHIzMTI1OENwVWlt?=
 =?utf-8?B?dFFtRFpCZmxVSW1sZjZxb0pNNDVURXM2eUZxaG5qMnlTaldvWkFHa1ZQWWp4?=
 =?utf-8?B?Q2xocHpaVHNRVGgyTU5vSitqd0xJcS93U0x6aXNBQUhWOEhqdzV4WXZwL1g3?=
 =?utf-8?B?T3F1UlpscldGckdET3lkTHhlQkdOVjdQNWs5ZUlEZ25icG5raG9JaURlU3FY?=
 =?utf-8?B?TFJuaW11VEpLM1VudUgxWGNWR3RSZVErZzVmUDNpY1g5L0hWbU9DRnpHSkNL?=
 =?utf-8?B?VEJiYi9pMWh0VXRmdWthTnhrdkdON2tPOU5RRjhZK2VlMWZlWmx5N0g1bE9H?=
 =?utf-8?B?QTQyRUxFM2t1THllOGJISVZSSzZSOXZKWHlOcWcvUGYxRXVMU0Z0c3l1d0Zi?=
 =?utf-8?B?bDNBYVBHMENlR3ZCcEMyQ0ZzWEhHbktCN1MvRXZ2TGttZUdHT3A0eGo1Wmx5?=
 =?utf-8?B?aXI4d3RHZ0pIa3JmSmhXOVZZM2MvTXFFaDEzWG5wajd1WVYxWUsyYXd1VkQv?=
 =?utf-8?B?M2NMQVlnQWIrdnRFSUhBV1pSWnR5MmtpZmdvVkx0Y0taL2U2K2dBeTdDVUpZ?=
 =?utf-8?B?dUVkK2R6cmhmd05EZkxnNXVzSFh6eDVGSG9OQWxCUlFXS2RoaDN6YVpRTmJM?=
 =?utf-8?B?eGhjL2xhaVMweHNxbnBicjF1WWducEJRSHc2L2lPcDQ1bHlhR0xNMDZCclBm?=
 =?utf-8?B?VEI5V3h3TTQ1cWhtdFpnQ3E2UUdtTTNwV21tYnRCcGRjYXFBakJLb3hFdzd6?=
 =?utf-8?B?SnJ1ZU9jc0VSeTVEWmd4d09oalRnY0kzTzNpa0RoRWR5SjBwOHJYY3BTU3lJ?=
 =?utf-8?B?emoxaXN3ckFPOXcxM0xhVStQV2NXNXg5eklJVzBrZnZ1VTdiTHVjeFhPZU92?=
 =?utf-8?B?UEZHampiZlJVYlh4cDdxaGZWbnZQL3ZISHdYZXRqWmk5ODdwbGJPcXAyOHJR?=
 =?utf-8?B?UmZCdlM3am5XTkNyOTFKV2VTMmE2SHl4Zmhxcy8zMmczWWFGN3ErNzhGOS9E?=
 =?utf-8?B?bUprTHlTT2RNZ1UyWUkyVWRHa1NJOXlrTTZXY3BXVExxT1U5eXUyQUtRZUsv?=
 =?utf-8?B?Q0hEcDFva0xPUUUwZkYwRDlyVldPTkg3VFZBSzB1RDY3aHZvZWpEb3JNMjZu?=
 =?utf-8?B?dkZBUEJUZnJpdm1UVlBvRkE1TFVLbmU0ckRUNlJBdS9sY1NES1JpUHNlQUx1?=
 =?utf-8?B?bUJNLzBrY3VsZFowbUVMKzRyZTJBZTZuWk5RV3N1UldGUWQvSEEvQjR2eWZN?=
 =?utf-8?B?SXQ4VlJQTGoyNDcySmMwU0UwSDd6cFoxcEV4LzhRQUZuL2Jqc3ltaWFwRkhX?=
 =?utf-8?B?bmg2bFdUQVhpUkJvU29mTm05ZU8vMU0zYzVHakYzQXp1emFjcXNqSk9qcnht?=
 =?utf-8?B?QTRHcFhlUE5mZkVyWnNMcXBDS29zaXBpd1JtTGo1TVBRQkc5RmZWWWJ3RWQv?=
 =?utf-8?B?Tnh2SStzVWV4UDdhd05qK1NqNHQ0R2xZM0RWT2tLeVIrUzJYRCtCN3dReTk0?=
 =?utf-8?B?dGN0Sm0yOVdIT3l2WWhHbi9vMDhxQkR2WCtlL1BLbWw1VGVHNGRtVDU5eENn?=
 =?utf-8?B?K1JRVy9vcGdtQ2lpb3FvWExGcDRzTXltNGY0M093MGVVTUpZMkZsMXdWcE1N?=
 =?utf-8?Q?BY4NUXfY0kHx74laJqfZ9MpAbhEK0c4DvOqCCh2PjJ2e?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	o953rooxlPUho1xznjnX0ofKrjgnaHPRjxscDFmLqq0eo9BfD+ycSlF9+N6rLkMhNyBbCKJiilGzUrB1qHC6m/ZEQFAAThZEEux5TOMWlIo/XGM0M7tE5v0OW4cqmHO3ml1dx4NePBXvarLJzJ8K3z9vFB26C8zyqrccLMR73DWmLtVhq5IVTRDRMYvhK3XNUYMTnFnX+FDa/rL71wDAfkpd0osPJNpcmjGRICeP0O+hNNEH8NRypvH8OpdKEnk2IejkAIMqNE/f0Grld0ZDtNf07caOYCGY06PmpMnW05aZiaDtUEoGG0I8M+AbK+fwsy2ORc1HMB6uHyZA7Q1gDdc9rHKuo2iNo1ICYYytX/tELm44aD9Uk+0FCn2NW9K2iMx+3enknup7eCjTESXq3nGJZgpPM38SBB1qLL1ZD//zIbQXe1mcz8jNEmas18HLWvPbQKmvhQDleUEZXyG6eQNQ1xwwoGGQY9MjBqaTsreQtOtpjcTehS/KslVjYjY3xSExPQ0xbAZjLaOnRp8ezVFTiP47MewK/nyMNh6FtBadka9TyG/Hiin8kAWLKO/x8lqUSpJkwwyPsfAQHqsMf8dXCu1P9KpTGrs7OvRiFYgnWNsG+0W90qjNEgmwPomMg3RfgGkAaRovVPPmcTgShA==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ba81bea-6b6a-443d-a8f2-08de1802fb02
X-MS-Exchange-CrossTenant-AuthSource: CH2PR19MB3864.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2025 22:23:41.6679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YGJ5N0eE4Rfpd7XwPSzmEOAXVr2ovZ7AsJaMDDA91kBoioIjKNmIsZLkloBQabx7wKssRnFwix6WXCGnbUFmzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR19MB5723
X-BESS-ID: 1761863024-111227-25360-22960-1
X-BESS-VER: 2019.1_20251001.1803
X-BESS-Apparent-Source-IP: 52.101.193.100
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVkYmlhZAVgZQMDXZ0MjEJCnVzN
	I0NdkyMTnRNM042cTM2DzV1CTJwthQqTYWAC6u1rhBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.268592 [from 
	cloudscan8-88.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1



On 10/30/25 19:06, Pavel Begunkov wrote:
> On 10/29/25 18:37, Joanne Koong wrote:
>> On Wed, Oct 29, 2025 at 7:01 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>
>>> On 10/27/25 22:28, Joanne Koong wrote:
>>>> Add an API for fetching the registered buffer associated with a
>>>> io_uring cmd. This is useful for callers who need access to the buffer
>>>> but do not have prior knowledge of the buffer's user address or length.
>>>
>>> Joanne, is it needed because you don't want to pass {offset,size}
>>> via fuse uapi? It's often more convenient to allocate and register
>>> one large buffer and let requests to use subchunks. Shouldn't be
>>> different for performance, but e.g. if you try to overlay it onto
>>> huge pages it'll be severely overaccounted.
>>>
>>
>> Hi Pavel,
>>
>> Yes, I was thinking this would be a simpler interface than the
>> userspace caller having to pass in the uaddr and size on every
>> request. Right now the way it is structured is that userspace
>> allocates a buffer per request, then registers all those buffers. On
>> the kernel side when it fetches the buffer, it'll always fetch the
>> whole buffer (eg offset is 0 and size is the full size).
>>
>> Do you think it is better to allocate one large buffer and have the
>> requests use subchunks? 
> 
> I think so, but that's general advice, I don't know the fuse
> implementation details, and it's not a strong opinion. It'll be great
> if you take a look at what other server implementations might want and
> do, and if whether this approach is flexible enough, and how amendable
> it is if you change it later on. E.g. how many registered buffers it
> might need? io_uring caps it at some 1000s. How large buffers are?
> Each separate buffer has memory footprint. And because of the same
> footprint there might be cache misses as well if there are too many.
> Can you always predict the max number of buffers to avoid resizing
> the table? Do you ever want to use huge pages while being
> restricted by mlock limits? And so on.
> 
> In either case, I don't have a problem with this patch, just
> found it a bit off.

Maybe we could address that later on, so far I don't like the idea
of a single buffer size for all ring entries. Maybe it would make
sense to introduce buffer pools of different sizes and let ring
entries use a needed buffer size dynamically.

The part I'm still not too happy about is the need for fuse server
changes - my alternative patch didn't need that at all.

Thanks,
Bernd

