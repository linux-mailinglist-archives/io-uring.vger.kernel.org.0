Return-Path: <io-uring+bounces-13720-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id t0JYHYxkLWrrfgQAu9opvQ
	(envelope-from <io-uring+bounces-13720-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 13 Jun 2026 16:09:16 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id DF00267EB92
	for <lists+io-uring@lfdr.de>; Sat, 13 Jun 2026 16:09:15 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=lmLqYVS9;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13720-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.105.105.114 as permitted sender) smtp.mailfrom="io-uring+bounces-13720-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=reject ("cv is fail on i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E95CA3010B83
	for <lists+io-uring@lfdr.de>; Sat, 13 Jun 2026 14:09:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3898230B53F;
	Sat, 13 Jun 2026 14:09:14 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010035.outbound.protection.outlook.com [52.101.56.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C8830569B;
	Sat, 13 Jun 2026 14:09:12 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781359754; cv=fail; b=au/mr6H3XIbpVvuHyCQPIjG+XZ5CA+YRyoFmJGM5zu5A6Dddd/SUmzNMXVIp8r/cJEdjzalHlxjimQLezS3sZcgbeMI8bhXj9LmzV0NwZ5em/MwoaXLtlm/Arar/G+DHybxBcUeDJJMqWTHf7mwsoNqIJp6z51Y/DH8n+I8OXWg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781359754; c=relaxed/simple;
	bh=vp7gvYy3w/uBLVdElypfV9pyAnK2OvcG/LBFnLUR1Mw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=G0dShpItagDIV/MoSGDAHF+y0otR5GNSOmKLVNrsfAVBGFn4fxsOUM1q0/kFRhGdvtu/KKPCcKUPEmtbV2O+eB/2GykIWQXT9NjGZMazfCRDb9hNF9dprEUSD12DVj3hGsa8tR91lul+fM/HfZ8LceOj1GFz93Od86YV0Ctje+w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lmLqYVS9; arc=fail smtp.client-ip=52.101.56.35
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BJqfuJGA61LuEdFSOjCiHxDvbspZdR9r0Vy8MybrHRwm6uyxlGNHT49I28eDFnQY2Za28Pxh0gIY2KTob5jr5lH+QqwqxNBFKD2jD8Z/qhwAHStSCj3KJz14L4AWPKgEqi/LXKW8r+XzHlwTVxlVouRQJlTnWEFxBwpylwdIaEAA/p439Hod1w6cyRdJQtJee63+zZs+AkfCXLHksF2aUEqToHopIaIHNdm/BoADmHRxAM19SuVjLbJvnQiwNvrDpsluxQx450w1KLPhSANFT9Pda5n84cZgISIjks0bFOurLd+HNf2QnXICvKbVikEqLoai5CP8GKAJCtFxM74Ppg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q2NsWITpygup/SU3igAg9H/sO7AuWweu/pR/vMvjOJU=;
 b=xyApkK19KbEnzFdB1gPfp9fXScsW8RC0dELg2DD5vg+NK5ig9fhewu7brt9sgtdzWntTNtjzt4LUQpnq1KbspIT11yme+ZBPlNAqfI5gMM3/5885nTnmIZP+mVqDBVaBzvRKCKiILwzYaXhcb3RzpZEj+0UJOV2uZPzNyuNdInuWc65YhjpsZ87KxgVljHjG4HSM4sh8Sf4dv9BhMN9HTpbvXiGiZRTfpVlIVzFFahcEsFfgTXDTa8VetGzRUD13e2QDCjGA8yWuJquRRWWaGJjMMasVVBh7TWZGZdPiLctIbft1UfsNg5UdbgULA6nWKL6wwv/jULgu4zIXP59HLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q2NsWITpygup/SU3igAg9H/sO7AuWweu/pR/vMvjOJU=;
 b=lmLqYVS9SG9DUgLn69Kmn+H7UmTynAAvAJEeluFF5uIEPLuo5Bsgr0XJLmOxKa8tZIGT71Wrv8xmaRXV2VJv6sdCNNkUfU+r6+9iOu0g0R5dSsxFP4gPS1HnAZmaFzNIGHX28ragjkK1lrVWPXD3jk8xkmZlTFIS1m2Vk5tR2IsFuyaIu6bZC8yedDxcP8vz3DWwpjg8mdgO887EGKIRcu5s0S4Ptny6D1/SpMIW1WdwFMw67jqU4tGrAPjaxWhZ/3V2I/wFHt1TM7rBmz9p2tdCO7LiRkQ8T2FaJmQQ/mncVVPI+VbqUDp9R+upuxbahc08pA0THY1+ymBAn90HmA==
Received: from CH3PR12MB8728.namprd12.prod.outlook.com (2603:10b6:610:171::12)
 by BN5PR12MB9509.namprd12.prod.outlook.com (2603:10b6:408:2a8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.16; Sat, 13 Jun
 2026 14:09:08 +0000
Received: from CH3PR12MB8728.namprd12.prod.outlook.com
 ([fe80::2641:1046:bdf3:93d7]) by CH3PR12MB8728.namprd12.prod.outlook.com
 ([fe80::2641:1046:bdf3:93d7%6]) with mapi id 15.21.0113.011; Sat, 13 Jun 2026
 14:09:08 +0000
Message-ID: <b581d253-135b-4c75-a50d-2049c6d6e249@nvidia.com>
Date: Sat, 13 Jun 2026 16:09:03 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v2 1/2] netdev: expose io_uring rx_page_order
 order via netlink
To: Pavel Begunkov <asml.silence@gmail.com>,
 Donald Hunter <donald.hunter@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Andrew Lunn <andrew+netdev@lunn.ch>, Jens Axboe <axboe@kernel.dk>
Cc: Yael Chemla <ychemla@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org
References: <20260612211709.1456966-2-dtatulea@nvidia.com>
 <20260612211709.1456966-3-dtatulea@nvidia.com>
 <d0401fab-61c5-43e7-93ae-d4757433eb7a@gmail.com>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <d0401fab-61c5-43e7-93ae-d4757433eb7a@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0160.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b3::14) To CH3PR12MB8728.namprd12.prod.outlook.com
 (2603:10b6:610:171::12)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8728:EE_|BN5PR12MB9509:EE_
X-MS-Office365-Filtering-Correlation-Id: 9da9e508-71a0-4427-e437-08dec955559b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|23010399003|366016|22082099003|18002099003|4143699003|11063799006|6133799003|56012099006;
X-Microsoft-Antispam-Message-Info:
	0ejoQjHFk75aBSPZmZlBd6Tt/s4YqVPlXkHjXRohZD4E92UPgjcdD5ZPjMDpuV89/cfgTzdiptM/kvDKy7KD9IZepceSqVw9V2UCRcb1BZFS1Qx8IDRmRG0n5FMstKR0aQTH2UHwB+3uEbLgrHysqZtKsalB/9wygINVE1e0eYtjz3wNQJF6yubDP8YH+KUSc1ycp1vlVnyik0ZWPWSe/rYrA4EWD9IeG3scJC29Ct3F6z7lzbb0HtkGtUiLbmS91ObEeKYZ8PnfZRGPWxUdOkC9uxL3P40i1ReUebIIdCO8hrr8Wt7+oFep5HD1MC8y6qAUY6usW8o/hOJrg/SkCR4/U2zJwi3w4UGlnxWmJQJnnOKWXkxj0+gHzSJrY0J3GtvjL0wsLlxKy7JMUj9QlryGIQ1o9S33tI++IzgvDA6FdQMfPMb4EJxPAiZgcKAN7BpdxLpn0snqbAfqhDnAAp2RMUM/TPByfv+mwl0qd7LZ+nhL589Hguy/SmHjJRmO6VIVhX30AREkU/4amyZBmfF3vCz2G9H6PN3Bzoy7oQE0ed6uFrg4H8+FydYcIcC+v2Qxr8kMgPz/ivHFqK5Cxpt2LJV/9b9rDkyJqKpwSc71xe4ewSO+zrZT0pr2woaeaH8Rr7DoTsECGHim1SXO5FwN3Aq2f+xxjfVxpNTKA9I6IZ36+EN7AMX2i8+rGaCt
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8728.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(23010399003)(366016)(22082099003)(18002099003)(4143699003)(11063799006)(6133799003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UjRYc3MySkdyMkxRQlp1YXRLYUVKVGZFVk95QTdXc0h5Q0RSa0FER1VBWE93?=
 =?utf-8?B?MDFWL0pMby9IZkI4aWluVjAxOFpLWEN6bFpMOXRuVEh2MjgwdXdDeVJDVVZx?=
 =?utf-8?B?Q1ptek5vT3pNZURTU3J5ekdsR3B1cHdncDREaHczbk53TzdjOHVOYnJybEZu?=
 =?utf-8?B?d2NYRG5lT3FvdmxHLy8wYXA0RDhwWm9ieVpRaEdVUU5tQmxSMDB2TzYwWXI0?=
 =?utf-8?B?SVMxUWc2TW9FaWxyT2JVNTRaWXdNa0tJRjhmTldGbXd3RXkya0lHbHBLQm5Z?=
 =?utf-8?B?TDQrdmZablF2TWdOYnRzdEJkdUU3ZVpGU0RVdVFXK3Y3T3djMzRRS0tnVy9U?=
 =?utf-8?B?a0dLTjZrTmlibDRNMGxWMDRjMGszeUEwa29YMU9WeVBtd3NQVW5CU05MT2FK?=
 =?utf-8?B?eFZ3YWovbndmN3hLY3VYUENkU1Q3Y3JaUE1JNGI2Q2dsaHZ6UXZpdEd6MjNF?=
 =?utf-8?B?cUEvVzFTUll0TjlWOU9UZXd3NlpvdTVKcGxGYktyQ21acUpHSm4zZ0NkVVJS?=
 =?utf-8?B?NTdXUGZ2dWhnWnVJNnVoZkNuSkFoTE9ESmkxZ0xiUEh0MHIrb2ZZSlE5dktG?=
 =?utf-8?B?M3R3MENpUmlvU0gwSVNwODlnWjVBWGxjNWxybnc0VmpmOFlUeC9IWG5ScDJU?=
 =?utf-8?B?QWhXZEVEVmlUeGQrL1hJOUFNWTJYMHJuRy9tYXlrb2FWV2Q1Y0NjUzNHZC9P?=
 =?utf-8?B?TDhabmhQNUJSQVNmM2o0Y1hnRTFnbzZYdTc4U3FRS2tuQytGeUxGTWJObGdM?=
 =?utf-8?B?cHgvN09VRDRYL2k5TW1sOEsydDlJYmNBYm9uNktLSTBnQlp4WWFBQXNjZklQ?=
 =?utf-8?B?YUN1cG12SzFTaENTbWQ1cjhkWUtrenUreVFmOEhadDZHVGxZUG5OTnkvWGhP?=
 =?utf-8?B?a1dDanJTSDJ2MzVTaVRZWkFBYmUyUUhyTjhVNGJVOFo4TDVQZWJEbTNqNHJK?=
 =?utf-8?B?d0Y2bnpoUmRIZjErWXkycEFoNXBjVHN1MkRwSGhzNk5qSFczN2RGRkI5Y2tU?=
 =?utf-8?B?Q3NEMys2NXl1ZG1abnVJYkIvRnF4b1Q5WFFGUlZ5OU05bjVZNVVjSnYrczJa?=
 =?utf-8?B?OG9mOEtGRUtQcmxQWE9rdG0zeHdyRmtiUm1nRHcvVnp4cEI2NS80WS9udFRn?=
 =?utf-8?B?QjBYb3cwcjUwSFJmUTFuaXlPNTdIUEN2ZXA4YzV3bk5KTFdibGVOS0dYMWlm?=
 =?utf-8?B?aitseVh6bCtyQTEyYmpBa29ObDB6WS9IYWc3YW5XNmVLVzI2d09zUUg1MHBq?=
 =?utf-8?B?elZFZktyZkpXSUl5aFY1aElGMjNIcFIwMzBXRFZYalNiSzlSdkR5VXZ0RXJX?=
 =?utf-8?B?aEZLNEhSRTI0MWtiWEdZa1RFSXBxTzJXd2V2eXRoUGI4U0NzdmRlbEYrTDdy?=
 =?utf-8?B?TGhzdDN3ZWg3K1RmN25oeDMzZEFsREhYZkh0RUp1M2hjUHpVVnd4WTFnOGti?=
 =?utf-8?B?SkRvcEd2SmhRajVSdSs2VExYVEZqRllHYUhVeDdGeU8xZFBWWWFBdmo2ODRI?=
 =?utf-8?B?RkZ2RVpxcm9JY2w1T013eW1DTHR1MXkwQjVoQUpGT1JlRm5kbmRrY1J1QTQw?=
 =?utf-8?B?VFB2cXZNR0gzVWpTeTFzeVQxZkxqUXd4ckg1YzZpVjRlOHFNZm8xK0p1VGJM?=
 =?utf-8?B?TkNsMkRRUW9oV00vRGhCWTIwZGJGS3Vib1NSSU9WbWtYaXpsbmpGb2tRTnVV?=
 =?utf-8?B?Vm5ZNTNrNy9CWFN5NXQ2MlB0YW8vY29MaHpvQXlNSHFSOTkvSEJsZlpaWXlB?=
 =?utf-8?B?QURjaGFpVFVsN0lYWXZvNHUrb2xCdElXWkl0Sjk2RmVYM0tuQlo0d0NJWW5J?=
 =?utf-8?B?L2l2VTF5MWx0QjA3Nk9XdFJrT1RsTUw3NkVaTHhpMEtYd0w3N2RHTXlQY2I4?=
 =?utf-8?B?aVJlNDhyM0VZYStza01HQm16WVZtTTlzVFlFdjJEWGQyeWR3eVVLR1lqSS8z?=
 =?utf-8?B?UUxFeU5HU0JuOGswcFJWRmk1T1MxZXZHTThLQjZZYzVweDZoL3d2T3VIbWox?=
 =?utf-8?B?MytLWmgrbEVnQ3RhZU5qTDBKanluQ1VwZERwbzM4UU9iUENEOTExSXByaVNw?=
 =?utf-8?B?MUdHa2ltakowWDhaVU52UUdQQ0hDcU5vdzNaNWh2YTc1S1MzZXNwOE05OGQx?=
 =?utf-8?B?SFRWZE95T2pZMjdVSjdQMTZuc0NMRmJGeEZzZW5vRGM4YTZ1K1NFclV4Ry8v?=
 =?utf-8?B?QUxhaHYrUWN0N0VpVkYvSEV6S1liczZ5REt0VkZoS1pBeG1nRGlKT0lYK2ow?=
 =?utf-8?B?cldPS0wrSFFsekxEOUFNZDhxRUFlZTVzRkIvN3c1SmUzQWdTZUR0NCtFS3ZU?=
 =?utf-8?B?VnF4dnQ5K0tZQlVLZUp6cmQxam5IS0RzOXZxU3FERWUrV1pFaVlCdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9da9e508-71a0-4427-e437-08dec955559b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8728.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2026 14:09:08.1457
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kb/6/1HrnZKUvh2rhbG3rNbpehT01Ken5Jzl0fxKS1bUOo/g4hfI3srjZMrVKeJWw1PLFCJp1bp8NQqO2y768g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN5PR12MB9509
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-5.66 / 15.00];
	WHITELIST_DMARC(-7.00)[nvidia.com:D:+];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13720-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com,kernel.org,davemloft.net,google.com,redhat.com,lunn.ch,kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER(0.00)[dtatulea@nvidia.com,io-uring@vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:asml.silence@gmail.com,m:donald.hunter@gmail.com,m:kuba@kernel.org,m:davem@davemloft.net,m:edumazet@google.com,m:pabeni@redhat.com,m:horms@kernel.org,m:andrew+netdev@lunn.ch,m:axboe@kernel.dk,m:ychemla@nvidia.com,m:tariqt@nvidia.com,m:netdev@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:io-uring@vger.kernel.org,m:asmlsilence@gmail.com,m:donaldhunter@gmail.com,m:andrew@lunn.ch,s:lists@lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dtatulea@nvidia.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[io-uring,netdev];
	TO_DN_SOME(0.00)[]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: DF00267EB92



On 13.06.26 11:53, Pavel Begunkov wrote:
> On 6/12/26 22:17, Dragos Tatulea wrote:
>> This adds observability for the io_uring zcrx rx-buf-len configuration.
> 
> It might be nicer to look it up in the queue, e.g. rxq->mp_params,
> and make it a queue attribute instead of zcrx specific one. In either
> case, no objections.
> 
In io_pp_nl_fill() or in page_pool_nl_fill() as it was done in v1 for order?

Thanks,
Dragos

