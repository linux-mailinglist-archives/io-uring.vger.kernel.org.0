Return-Path: <io-uring+bounces-13889-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id FrvFAH9US2r5PQEAu9opvQ
	(envelope-from <io-uring+bounces-13889-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 06 Jul 2026 09:08:47 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id E612170D517
	for <lists+io-uring@lfdr.de>; Mon, 06 Jul 2026 09:08:45 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=wdc.com header.s=dkim.wdc.com header.b=Vcmv+wI3;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.s=selector2-sharedspace-onmicrosoft-com header.b=dQ3u2EIA;
	dmarc=pass (policy=quarantine) header.from=wdc.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13889-lists+io-uring=lfdr.de@vger.kernel.org" designates 104.64.211.4 as permitted sender) smtp.mailfrom="io-uring+bounces-13889-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=reject ("cv is fail on i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E437F3015C90
	for <lists+io-uring@lfdr.de>; Mon,  6 Jul 2026 07:05:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDFC3477E4B;
	Mon,  6 Jul 2026 06:47:33 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E800F44D6B2;
	Mon,  6 Jul 2026 06:47:18 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783320450; cv=fail; b=mRQpgS31u3jqIF+Pgf7kUVwUI4tR7PcvB8lAhl2zql2oyewqRugkoWfC019gG5Tu+xDof6290ttbn5geXD6gI2wSzgFezcwrJEn/Ch3IWjhFD293fpdCfaA5x10qsj/bQNs/IGGLBJHIMnAx/rOaJCJ+My7PCX9bMsOWH1zW+Ig=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783320450; c=relaxed/simple;
	bh=vTqIds18UBzmaVqkjahJWhDGr/u9SJdme48te8Y8Gj8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FUaz+6M/QKT6bxKBHkcoPaDCmu/V10tz7lRtcdzfYDM6OrF45zGxkqulqxCnWSCe/sh4tGIqcrl1n6H0hc8b2IFiU6grNNScG2w8jY3U7Nm4Iw3lQp4Oh8KFVzWMpxSPmkhViXq/8JStrfOABk3qRJIuM52d/KT7kA2JUG+AijE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Vcmv+wI3; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=dQ3u2EIA; arc=fail smtp.client-ip=216.71.154.42
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1783320443; x=1814856443;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vTqIds18UBzmaVqkjahJWhDGr/u9SJdme48te8Y8Gj8=;
  b=Vcmv+wI3kQHRS9n57b7G1nZhSx8B0Zul/KgvBqEje5TgBMKW4Jze/Cbb
   vLnsT/pnbEdYWH1mDHl7Brk3XlV2OC5xCtdNb75yittYR0KM8O82/+lJj
   LnThFMwNnHDRG66gOPkZ69voaACELI7wZaUFQ2AQCNlF81/n3JpBFjT+A
   PIMFxjwcsWYsAMUMUSwUpkc0HYRkiPXzzEwzFPerzJnBJxBNiKs02kwkw
   eOFluzzO18sDM5ezM/DIfwH/9i1uJQy8rqxFPK2Zgg5+OC0BHCKaV8qQb
   VADZckB50FxUjcKPGP5zo1e5P89kmNJAWT98+1KbqjXISbjw5W04/yyF9
   Q==;
X-CSE-ConnectionGUID: hZg1rIVYS1avvjTgM+pmaw==
X-CSE-MsgGUID: TD4A5mIcRFm1mCeJ9k6CmA==
X-IronPort-AV: E=Sophos;i="6.25,149,1779120000"; 
   d="scan'208";a="146292982"
Received: from mail-southcentralusazon11013071.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.71])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Jul 2026 14:47:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h6brQA9vtLHXIpZ1h3QDa7Pa3POIdE1oWJdgew7iOdM5IkrnqgpafpnBIS4oedhwTBFN9S0eafUSlq4o0dqKGhV0JGUrXvTTDtDCAJkilTmaglM1W092Ma1wTssTeqqz0uLjkT7L4B7/ZxlQecMyT/WywWviYlHcnhDJcJuBJkRlw+E0VGZg46oyASs+DXxZc4uW8OYszh1y3jkBl8rziTrej24kB4grEy27yfQskMdyXNs71sBwRC4QLcXfU38r2VBiBRLS184oSEW6aDp+OlniGg1jSlO/PQzwIlL6VlJt1GWKHqg/TuMeI46ZxQG+YwOYnmoU6k00TpK1VI2XoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ItddMh7QtoZjS5vILWI8C4XxIbFtqHyNGrTCnDBnuSA=;
 b=tc6k41ql/Lz+L4CspHrBzjKf6Dk/mPtIldYDX8nJICNFp1fFfH7Dg6mj2kw4MyBnlVOVJpqQfv1HSOoJ7v+6VjUDEq+SSgILNKwB32o2a6K0Oc78a+xgSC+L0CnNC2Ox8Y/qeCAU+jWHCONhRKTusDenjqjVtrks5p7zyGqlwZj6U2mWXdUa0aHfiUtnte6BNCsLiAeqPs0gKAWQssWsuY8a6VbPVMSn8FN5avBoxml+q60pIkdx+jxVT/yLf8aL5knMxGCa+Qdaba0Z5DAlcFnEEoi+5xGHWEGFV4RyZGCdpl9YU50zbgzwkaRVLffTxN8j+uJAAoysfVlEzmSBQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ItddMh7QtoZjS5vILWI8C4XxIbFtqHyNGrTCnDBnuSA=;
 b=dQ3u2EIAODfAjJeali3jNKcgjC7iNNMeRhvV4VlXXYeQ9fqYe0UuEqHPaEKzB7yERGxytuK/Ga9vawMfwTCoZ8B7tN9ShhGDvRdIR4qJvbgNrsULGrruPEGVYYKvb29z8G/l505wt8pU3aTDIzyBjWhXsOKDXd1XH00xtBquFsQ=
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by MN2PR04MB6957.namprd04.prod.outlook.com (2603:10b6:208:1ea::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Mon, 6 Jul
 2026 06:47:13 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0181.008; Mon, 6 Jul 2026
 06:47:12 +0000
Message-ID: <2147452a-109f-409b-81eb-4a4d3a83cbb3@wdc.com>
Date: Mon, 6 Jul 2026 08:47:08 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] block: split out a new blk_plug.h helper
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org, linux-mm@kvack.org
References: <20260706041125.642097-1-hch@lst.de>
 <8583b332-0d24-4f6f-8831-69e3aad936fd@wdc.com>
 <20260706064547.GA25268@lst.de>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260706064547.GA25268@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0230.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e9::20) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|MN2PR04MB6957:EE_
X-MS-Office365-Filtering-Correlation-Id: aec89f1f-c2ff-4330-78ab-08dedb2a689d
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|19092799006|1800799024|366016|23010399003|56012099006|11063799006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	8XgjJ5gCoRvKS6rlwEP4yobp+8QzQ1G6LL5Y31javczvm+jYU0WibBMv3mXupFXnKt42FwozkxgcZaIn+lfp6DOMPxKkf5IBGfmrpXjUz0uemS4zUIyFfufSFG9UTt4rg6AkYoovXuiVXqWqVpo+BqWYZ8gBDQhrQGjdjeTfbddX6bMEnAk7vf6JpGqyYtbkgCtxdDUeQ8VNtFKyNqjuw/IFFQBsSLFLIAIxyFoEH0CJHA2FoK3WMipkwgMW/ho9fv6mY0iTlzLmBM3hYG93ybl1kUULQKVhyivL43e6Kci4MJb6/UuI5KQUbo1IYKTg8LXQx4AW7EHYYNqpslSOy32b7H38V6yKWoq0ZYRU3zrLjdMioKfzYvfIe7eU6s2gvSwzdtuD16gk5Erb+G+TqK6mWPDJJDS3mPwNYR653EfVnbENT1MCXJ5JTSeWyEQ68prHKQrfdTbMy6r28FgLOvBlSGFX94KAgJQDI06fBJThqTDWHlbauMac7qWm5m+oPhxwRYcpqTh5qy4/EoCtHZ9iPTzrjDEzhyXYjSzP0rdqRVsBt0/ACkG6zxqsRbgY4EGgaOAep2DNx2ZnV+2hbcqF+wklf6cm1xXARUXePOvtRXu99JDUlO6BuPkeGOpMwLMKlAQ6jSimFI6vQh0g/9yuG6ZfN8oIm8Svca+pxH4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(19092799006)(1800799024)(366016)(23010399003)(56012099006)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a1ZKT2ltbTdobFk1bFRWWmJTMU56VVl2UXlqOGdRUDdoMW1EYm03bHBLNTc0?=
 =?utf-8?B?V2VINlNEck9MRHV0MGJja2ovWEtLT1BVQk9sdHo1VmpNZGVzRGJCclJEWnNT?=
 =?utf-8?B?VFFYVjVTdTcvQ3I3eU8zZ2FDZ1YrVmdzSkdvRFJGaFBGaXMvY3RSSG81d2JU?=
 =?utf-8?B?V2I5SjY1dThFUWV4UVI0QlVGVEprSW5pMTl1MHoyV0krUU9ZeWxJRXNQUXVu?=
 =?utf-8?B?QzRGREhGc1A4VU1UTW5NOC8veEtZejg4ZGhHYVM5NXlKYjJwcnJOVTd4SkFQ?=
 =?utf-8?B?NzdZYUVyUE50cXdmSXRrQkhPbkhrU1dOOTNmVWZ0Wi9sM2Zwb2FhU2pFZllJ?=
 =?utf-8?B?N2tpL28zR3Y3WFVmQlRlcXJ0TS9CNUdaUi9UNjVZQ1hHT1VxTnRrdE95Wmxv?=
 =?utf-8?B?Ujg2ckhOVXZqNWJxd05vaU9YeVhkRkpGZ1Zlc1NkTnNYVjNFMGwxbmVsbzZS?=
 =?utf-8?B?czNkdFdHcGp5ZDNNN1FhSEUzWU5FclpjUUdwQVg4S1owYmsxdlV5S2VEN2Ju?=
 =?utf-8?B?ZFBWcmd0UktLb25pd1B6MWRySTVsdUpjeVZzbE1NbjVNV2lLTmpFYnNNU0l1?=
 =?utf-8?B?bEdEMFVnSUxKN1R6aGNhc1BDVEgvZmtiT1VkOC8xTzA3aW9wY1dvakVRUldx?=
 =?utf-8?B?V3hJRFUrT21FclROM0xOWjFuU0QxOWFUY3ZEZW9CRjRGMWU1WTYxVEhINmc0?=
 =?utf-8?B?UnZaSlFwN2FOQ3p3VkcwRkZxSUVxS3VGLzFCSXI3YlBjc1BPZEZKdWlhZjE1?=
 =?utf-8?B?OE1ZcGk5dHJLd0M5UGg3RVJEb3VLMWVWeG9RU1F0TGVLQXFjeHFWRDNjL09r?=
 =?utf-8?B?ZjNhcnUwYU8yUm1FYXdMMTA0U3FsOHJINjZDL2lMRUJheTBDVjNkazlWNFZV?=
 =?utf-8?B?ZEpOam5jemZZaFQ3cVRTbng1QmV3RnladjNOcW1JM1pJb1BsOTA4NStKeEEw?=
 =?utf-8?B?T3NHZlBMUGhlQ1F3Y0I3OTViR2V6ZzZSTmxjcTNaOXB6NG56dklWR2s4NmM2?=
 =?utf-8?B?SmFtYjdVNTN1VEw4R3ArTUVTWC9Wc2tzYW9MODJVTTBwdHNVT0J2ZU1BWU0r?=
 =?utf-8?B?dE52alNYTDBqM0tsejlyczFidGxCYjhJSzNVbERtaStwcjZYUHA4VWJ1WG4y?=
 =?utf-8?B?UFNleHNpRDV4eUpjRlNqMmJRaUlJOHlkSS9lSXFUVENTRVRYRzV6SkErVzk4?=
 =?utf-8?B?ZGN0WUF2ZDhQQXlrNVBVN25LdE4rWWVUYkNVdktvUFYycGdzMjNjY2tYQkxi?=
 =?utf-8?B?QjNlNnpKZ0RDMXJDM2lJZzFBbUcrM3BGRmprc2NTcGcwU3RVSi9EVkRZOWFx?=
 =?utf-8?B?YThNcmJtcDVKdGFoYUpEVVBpMjhTZm1HV0ZUZmE4ZmhJL2k2UVYyaHgzNXMz?=
 =?utf-8?B?amx0bTRGcVVKaWFuYzFZTTU0Q3hzbVlJM0FhN05xd0dPR1RHQjFGMjRkMlFt?=
 =?utf-8?B?M1FoaGZ2Z3kyM0gzWWJueXl6ZkRSbWZrVExaQVh2NHpMRnNNaWh5OXlPdURI?=
 =?utf-8?B?OGROU3daT3pHdThKRmtncmIxajFQTnZBUXVoRFpIVXZhMFBrcVoxRjVlVEdV?=
 =?utf-8?B?MDdsd3J3dVBMamZWZXFOVmQ1OW40TkEwWnRyOGFLZlZ5RDJXY20raEoxNjJ6?=
 =?utf-8?B?NUtzK0FVNG8zUzVpVVhLUEpvbU9ZRitRcUhPYzZhMHhyL3RGaU41M0FRdVRB?=
 =?utf-8?B?NlQzSlZxdktqZmF2WVRKV3RYZUJUWEVJNDdyYkdtNGVwUmNzUUVvYlA2TkJw?=
 =?utf-8?B?Yk5Qc1hTNjFtYko5cWd5bjh4ekY4cFpHNDVqeksxYlZWbjljOWtwdnViRGM0?=
 =?utf-8?B?OVdTNFgxbGIzK3dLeThrTExaNGIzZTZJMVQyNUZQMDh0V05WRTY2VGgxUU9l?=
 =?utf-8?B?bVNreWdRRllWQWtvUVlWbkpJM21oRTB3QWl0dGRVSFdhYUE3UnNQNWxGVjMy?=
 =?utf-8?B?bHVqNkxCYkZtdEt5amQ5MUZXRHhUOFpzNzh4aGVtWVlUMWUvcFR3K1pvbzZk?=
 =?utf-8?B?cFl3LzIwM3VQVytsWmRERkZWZ0haYWgwZDFHeVE5U1RlbGV1UE54bXJnQ2wx?=
 =?utf-8?B?SjZ6NnJsZ1daNU5GdVRrZVRyTEtuc2pUZXFqcll0QjY0K01qSFA5K2x6NC9t?=
 =?utf-8?B?TUdjaUl5dFdWZU5MSnZIUGRNRFFzZlgvbFJkRlNBVTNJbE1OZTE3UWFhM1kw?=
 =?utf-8?B?MjZRdmVmQ1gyRTBycTJKSCtpWHNCaU56TGNtVUx6d2g5aEpVUmx6ZTBPb2xp?=
 =?utf-8?B?cWZvYW5jYlpqYkZlZlVHK1lVT0VlUDByd2dScFhMWFZkcWhtTC85SDRmRDJl?=
 =?utf-8?B?S0R1aWRrTWltZ1RZZVpCUmRLTWxnN25PQlY1OWY3TEVDQ0Y3OElaRFRkVWR0?=
 =?utf-8?Q?dG6CtYkTkGKPwoFc=3D?=
X-Exchange-RoutingPolicyChecked:
	mlg/qZ3cj0K+j2yMWTXynLoCq4DdrG8vk3kqtUT3X45iYUDSuiGrlPfi+881FaaMrTCn/fDsJpfhcgHBBCDyWYuUtwg70mZRyx0x9Cj0Lium3hCTuWSjfMk7K/chyZOKAwohls8Wpa7eigEZeQgA2cAd5PUOPWE9+MkvPy2PWCH5icpvE19dfs1CuGhX3zTQTFMa9i4vOrnslVWnRupgkg3h3Si5/7/wnIqSaPmBHjjbv7hXOoOQy5ME+jFytYcEFNue9s8XFFy8m6nUOPS7mxQrZt6rcL4VjbDq2eiLmj6QUZJTXyBrX70IwDtrniuvI0K5Yd4WT6O4sqNx0F0buA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JE0NzH9DK78pVP6GCB7DITIqzOyvmTA0DiQ0FWSnRVIFJ8AKoDt7eiQWLk4kFOQ8atABP9552f3wMmqMSmdR259ZEx8o2PxY//4da1hIvFIUzN1h8VKg6t9RBfLvmp2gpJFnJ7enlWn0J1k68HHTZi+QMjFB66xnkWfF0a/W7gTeyj+ZpcvvABr2oHsvmihuAlvRwwI3Wwn6iIO1luOCfH+wJrqqFfww3QcFp8Ya3zIItoB/XiKBVxyKuDjmNtr+FEcZTU6XWaaO3Xv9pWDgUL1mHp8J0C7BHj2f3Lllb2uWKTdXWTUm7dnaJy+HIJq/GxFJ6YdxBQb/INrlaNHPwdcHJZ1dTX1S2VhNrcl2dthiIRkIOpaRiOfEXEk7D46/dVR5QNG6Xl8f9TGsCZNz1dDqpgEyHgxiIXyx07nL8JqGMKh3qFBLPWRFrqdb1RozpNS+Gb20HWwR9kohSplQx84jjgjpXQWmwA2SyeoMERV8RAgYdlUJZ+FENibUBL9M3DGgVgTOy46SpbkOX4tUwv7wX8i9vIfPBGEYKtT2RZDck8Y+ozcWpfIPbaiUFkKb5h8LzG0g+CaIU7OtceAYLJ+tFvRjqMi+lhE5g7T28MvboLXxgOBYN0GMJ5tfFxLr
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aec89f1f-c2ff-4330-78ab-08dedb2a689d
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 06:47:12.5223
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t9mlx44bkQDRtZrnVGGKQwWp3e7blpSDGC1xSMcDO2UPEuJwkZJCiZeDVJpCAGPtrt5jcin367KrUwMDeR7BR8SR4ZR5simXTLlBhdJMGS0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6957
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[wdc.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[wdc.com:s=dkim.wdc.com,sharedspace.onmicrosoft.com:s=selector2-sharedspace-onmicrosoft-com];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13889-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:hch@lst.de,m:axboe@kernel.dk,m:linux-block@vger.kernel.org,m:linux-fsdevel@vger.kernel.org,m:linux-aio@kvack.org,m:linux-kernel@vger.kernel.org,m:io-uring@vger.kernel.org,m:linux-mm@kvack.org,s:lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER(0.00)[johannes.thumshirn@wdc.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	DKIM_TRACE(0.00)[wdc.com:+,sharedspace.onmicrosoft.com:+];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[johannes.thumshirn@wdc.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[wdc.com:from_mime,wdc.com:email,wdc.com:mid,wdc.com:dkim,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: E612170D517

On 7/6/26 8:45 AM, Christoph Hellwig wrote:
> On Mon, Jul 06, 2026 at 08:38:12AM +0200, Johannes Thumshirn wrote:
>> On 7/6/26 6:11 AM, Christoph Hellwig wrote:
>>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
>>> index 9213a5716f95..20cb8ed7d987 100644
>>> --- a/include/linux/blkdev.h
>>> +++ b/include/linux/blkdev.h
>>> @@ -7,6 +7,7 @@
>>>      #include <linux/types.h>
>>>    #include <linux/blk_types.h>
>>> +#include <linux/blk_plug.h>
>>>    #include <linux/device.h>
>>>    #include <linux/list.h>
>>>    #include <linux/llist.h>
>>>
>> I know it's a lot of cross subsystem churn, but wouldn't it be cleaner to
>> not include blk_plug.h in blkdev.h, but patch the update the consumers? A
>> quick grep shows 68 files that would need updating and some you already
>> have updated.
> Right now blkdev.h needs the rq_list from it.  So we'd need to move
> that to linux/types.h or something first, which feels a bit iffy.
>
> And no, including blk_types.h in blk_plug.h is not a solution,
> as that is still touched far too often.

Ah sh*t I did miss rq_list. Fair enough.


Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>


