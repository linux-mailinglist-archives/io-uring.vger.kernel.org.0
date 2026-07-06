Return-Path: <io-uring+bounces-13887-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id wyCJOztcS2pMQAEAu9opvQ
	(envelope-from <io-uring+bounces-13887-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 06 Jul 2026 09:41:48 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AA3F70DB04
	for <lists+io-uring@lfdr.de>; Mon, 06 Jul 2026 09:41:47 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=wdc.com header.s=dkim.wdc.com header.b=IYC65zCV;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.s=selector2-sharedspace-onmicrosoft-com header.b=feStfHNK;
	dmarc=pass (policy=quarantine) header.from=wdc.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13887-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.232.135.74 as permitted sender) smtp.mailfrom="io-uring+bounces-13887-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=reject ("cv is fail on i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 7A40B30CA885
	for <lists+io-uring@lfdr.de>; Mon,  6 Jul 2026 06:58:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51AC03E451B;
	Mon,  6 Jul 2026 06:38:53 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE883F7AA9;
	Mon,  6 Jul 2026 06:38:28 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783319927; cv=fail; b=oXJU7HHDbHKAEUBwaSaYHqGIBW0ebxxg6x/wHL0xuXuHN3KZQsT9sWcZrW2eLByzi5LJ5fI07q3YqQU1ak1Keu3fkD2LRa4E5NURR8qAqvfCm8qP1BV9FAfTJdguyri4S7+W2EP0oo4x/p6PP5siaedr46Nwh33xC1/pX01FqOw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783319927; c=relaxed/simple;
	bh=Drc/pYFTYWlIEWc25fC/A83AvRw0I7Q0rKICJSN3tY4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kfOvLW83D7xQCGfy/GLYxq/Accu7NWZA+THplHTe675i8Bjc346Fwb8nEQJnpOi6RlDcfNfQB0iB+uLe545sv+NPJKQ0rBqWd0uBjkz7nCVAlFlsN4L5MAkmcVUGYM9/EGPQQ16cJi9X1uHOwYpQs6U80FhG5Hb5upsdrTI7Cdk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=IYC65zCV; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=feStfHNK; arc=fail smtp.client-ip=216.71.154.45
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1783319917; x=1814855917;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Drc/pYFTYWlIEWc25fC/A83AvRw0I7Q0rKICJSN3tY4=;
  b=IYC65zCVbZ+y0niqbaf2rbC4A6o2ocNJorXBtEVXEg0J3oVN77X9T8eq
   wRCPz7qXCxyCKhKRR7Cwsf8qFLUa2f3mDdCwbu41+2/g6jom0WXv11j2q
   xWCy0N+N4gm1gAhlCPzp9QNdIOD/iBjhtZkJdEywdUSkMy8gpWXWT96rv
   mWdSPmxPtXAL5RM5suy62Eg23uW6Afjlj3v1RsS4EIx+9fIiatxmXUwpl
   FXQvoNpTcQIavYS/9+D5oK/3t9Ro0OwXY9mfPz+fTeiAJVsS2ULK0XE8S
   s5pHZ1LK4zVRWBP8kbq9E9p1JWWAfeGO76J3ohcmOKZH+efePe/uy00Z3
   w==;
X-CSE-ConnectionGUID: sAVVw4vtT32mTdNOpJU1gA==
X-CSE-MsgGUID: p0auosT7SVux9Y3FkCwlGw==
X-IronPort-AV: E=Sophos;i="6.25,149,1779120000"; 
   d="scan'208";a="148919721"
Received: from mail-centralusazon11010070.outbound.protection.outlook.com (HELO DM1PR04CU001.outbound.protection.outlook.com) ([52.101.61.70])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Jul 2026 14:38:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p9E1kjIwIHksW/FYPJZRrF6CaHAGV6p7n5C+aTG8zcbTGFYRptuxrZbglBJm/9SxADHenBuoSGVsxVL1kY6NMYaQmiayq94NY+G8Gn3S7fUlmwqOywhid2VQKZKknGzKYaXPbfRz36sUBo69S8YDUVeROVrR3xHeAcu8FFvtxQ1Y2mz42A6E6YLLlmSjQKejW3Y0ssw8zfQ3aCGAgz+sDaqsKbnC2VeFykeCzPWbid1f6ig3c2xLSypngI2auEHiF3M72Bhb4sJRPKpdKMfbwvIEfQAN06uCXYlVMjwEm1+mHYZfJvmZkdogN4M9tC97IXWASLMiT58a/3JEA2q7SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dq0TJQA4Nlowbiocfcd3Mf1QNcYb2VpVDSIQUZVTWos=;
 b=sZdHCSNGm3D2LlgnUnAiUymwGQPLUJ0xqcjHl2+2jlP2xP7SxrG0ASEaZUksfbeRmJtI/gp1gWauLnZO7EBjFMdb4aZjo013aVwOFr7ntLoi37iTY1LL+QeYb49kv/wY2T2WdUz6TaO1kqwEIYB+8kXPqeVAcyQmO+C2hi4cF3gwwkGIPbpqR/Bd+28r/sDWH2LCsGboS0bsloz7DsH/J2AGcHzFBcGlMQlwBLq33fzCeWd6/z1lhLz69NOgt7vGBo/mPMmUjIXrA/WiYt1Kjg5CdvOjBjHUzRcgeLVSFZKGg7gbCJ9u1/7GHe2ClGYJRyMoYDeamUcUOEpEbMQ34Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dq0TJQA4Nlowbiocfcd3Mf1QNcYb2VpVDSIQUZVTWos=;
 b=feStfHNKe4RLxkt7rBlaAeKLiOFh78ashghhf+0X4kygR7nmHVPPtwE0A6IV8fL+MyFXeffNfIy72wtOWtZWOZWKAW194jMijowg7++ZqZnikd1XDkr57P3ebtC9vpDRW4mKErvGK3h1cxdIVqviDpIlj8mFmfC+AwzLPkQs8us=
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DM8PR04MB8085.namprd04.prod.outlook.com (2603:10b6:8:c::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.13; Mon, 6 Jul 2026 06:38:22 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0181.008; Mon, 6 Jul 2026
 06:38:22 +0000
Message-ID: <8583b332-0d24-4f6f-8831-69e3aad936fd@wdc.com>
Date: Mon, 6 Jul 2026 08:38:12 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] block: split out a new blk_plug.h helper
To: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-aio@kvack.org, linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
 linux-mm@kvack.org
References: <20260706041125.642097-1-hch@lst.de>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260706041125.642097-1-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0234.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e9::18) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DM8PR04MB8085:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a5af553-51d6-4473-ea6e-08dedb292c72
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|19092799006|376014|23010399003|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	S9lAMdoaBcZmApS4lNChfKLI3R4BEaJtiMSDdSmDnm6T0ywgf4BJmu9ZSNBjwR4cMwAMFE7EcHikMbxeWDvdpQgYdXu0PrusOUD6qiLPhJ+cEKKYaMflAzlBi4j1BV1lk3BRxj570ymL+bJ2nZ1TXx13S5gSnPp1DS6msm8u/4IgPpi0KnnkIImmbKX3Cv84TMysywfgnRDJGSy7M6UkswG61aMe5l4YdLKY49SxVszLEZy5AeHh57dMRsTQo4aoixxo5d96N8fLn9bJI3YcmT30W33ksbHxLpoQE3Sa1cBbOP9jF5DxNJvgFfp/uWmEOnuKNWc9iSDjMP6J1tLCnj2I6MzxpY6kqWVB6pIT4qXKhI8iL46viyjV6YvZAEkGpIkWqfuoSLMc3ekk7tgYz1KTGrfHBujdPka7IZrdSMptMFXsRsbgQOhCJZI+T61iDWUBrHKoyjPLCf/kxweZEuhKFiqfhXrY2wEN+AxMUgphRWK7im8g8wSVcfGtPfe1ET/Wt8WhoI09+rk1/bW/Y+2FEb2W8TNbh7X7BzHJlhikdF7F8U8RBVnZog0AYfkCN96G6roaj4iOgWuL/ck1qY45xZ91vyyHtPnzqVfc7lXB5WxUTBxieBEGquZYuvkrL3iEcsYmQKsywo49MiIIp/wMPhz9PrXPZv0ZfOivHRo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(19092799006)(376014)(23010399003)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SGduNHNoMUdBWWF0WmNHNDdOaGFmZThUVlV1bTNtZnBZWjdXMjFwYUhtZTFz?=
 =?utf-8?B?cHRlOEpUTUxRUCs2Wks1dXRVVHhGZFZRUGZ1SHJHbEN3ekQzOXhJZ1I2RXBw?=
 =?utf-8?B?alBxYkdYQWpDSXJQei8yZ1FkaFllMmlacTNWeGllZnJhS0Njc0FzVExLRjdT?=
 =?utf-8?B?MzlXQUtHb0JFdHpuMXhqQVk4MjhOQTB5MHlsditpT3RDbjEvc012dnYrRmhU?=
 =?utf-8?B?TGtYeHBtOC94TGdRYkhLSkxnVWNDb2dCZ1Izd3NFbHJCcE1pbkc2SmhsYjha?=
 =?utf-8?B?N1B1YWtkWG9SS00wVVdFMVBuckpiU1JuSU1EeG5nSFdBa2dVa1doM1FEclFl?=
 =?utf-8?B?c0pCbGl3Nlc0VGVzY29JME1yN2xqS0dOdndUcFhkblFTaEFBNWRZQ1d0eXVl?=
 =?utf-8?B?KzFqaWdibUl2dGlpNThUdzhKdjRHWHZBQVVtbFMrb0RSZ3d3N0lKNDJ6ZHR3?=
 =?utf-8?B?OVJVUmFrblJJQmNxTGZXTkJpZGRRYTdiaWNOQmlCR2g2L0JyeHhoU3FLeGFl?=
 =?utf-8?B?Y0Jrdjd0Vy9mUXZ6M1RGK0ZsaFpieWhGMTNnZFJ1Z3JrMVVlc3p6SE1hV3Rt?=
 =?utf-8?B?U3YwM0JGMzZzUHlhRVp2My81a1hTZkdOQUFkbFBkQnFiTWhmQVdleld4WEFT?=
 =?utf-8?B?ZVdScUNBdHRhOWRUUjlQUkN6WW5Qd0tHaCtUL3pCKzk5dHYweTVwZ2ExTWxO?=
 =?utf-8?B?ZVNzSXJRbk5FVzByQUt3anhVOC91aUVFckdRUkpEbGJMNC9xL1U5T0hiSUx0?=
 =?utf-8?B?ejdSWk1seUxQVHZZVDE2ajlkTGdWZ1M1cjFaV2g0Q3JBb2ZaY1RyTXRFZHZD?=
 =?utf-8?B?aHNlblYvMVVlOVU1OUFPOUs5a1RTWWk5K0d3eTE0Rm8vcGtBQlRCNkFuQ1Bw?=
 =?utf-8?B?Ykhsa3ROL2IyUFNPcUg5MFlqVGhzYnBpYXlDcXFMbEVHSHRCczdTQ1NuQ3Y4?=
 =?utf-8?B?eXkxMFdhYi9MRE9BM3JTc2ZkTis4Qlh6WVA2eGpaZVZDV2dxZHVWL2VxWGdo?=
 =?utf-8?B?SmFaSEsvR09TYlhGVnJmVFhjT3p0akt3Q0tPeUR2eFNMMnFLQnJhdUxzWG9E?=
 =?utf-8?B?OGprMG9FaVQxZVVqWmV4UE9UUlhaR3ZlbG84SXRPY2VoVUpNbDlKTUxQN3Q5?=
 =?utf-8?B?eTJJdzYwYUlEaXJ0ZTFRcDVFSzlyNlVLem1xVnF2TDErOU0rTGVpcXF4K0lq?=
 =?utf-8?B?eXdTMDh6Mm5idXlJS0FvZGtTSlNXUS9wQTBtK0JjMWdWWnU3ZFlVTnZzOW1N?=
 =?utf-8?B?NTN1cGhqMkhzQ2xCYWZjTEJZZXRwc0pwYnZDWmNmSnB5SlM3c3VTcEEzd29i?=
 =?utf-8?B?ODQzODZDbzErc3lzUzFwSWVhU2xOVG01dExZTzFMZVNRYng2bWRQR3duby9v?=
 =?utf-8?B?eHg5cldFemZQNkFiUWIyRENscW5UOWxod2dDYzJsNDRtN0tXOVlGcXNoRSsx?=
 =?utf-8?B?Y2lWTk12bHNMNzBMamVFUjcyeWhqbTF5UEtmQk1vbVJSOWR6WUIxOEI2NjJG?=
 =?utf-8?B?UUtvdElOcndZWndMZk92V3NLdlNISWVCRHJoMjFFbnBya0tRSDFob2ptTmpW?=
 =?utf-8?B?bWpkSlB5WGxFQ2FjTTNtZGJQNzJFcm9zZFNWWTFoYkxrWkV1SzdnQ25Wakwy?=
 =?utf-8?B?dE5BRDdVYm9Kblc4UDltVWpWNUJLaG1pUGRGL1hEMXVTa2g2OXdXQlZRckE3?=
 =?utf-8?B?N0tROHc0bjFKTWN1a3NrRjEweDhOUmZCQWxJZkg4bUlQNVBqa1ZsWlh5SUU2?=
 =?utf-8?B?SmJ3MHJHS2RGQTRwclRMeDBSYVFnR05LRmRPWUppWXIyeXcwQlczU2NTUjh0?=
 =?utf-8?B?L2JsT3N1cXlVZEx5V1grd29NS0I2bS8vZEh6bzNHTW5YZUNIQ0dPNUdaNGJI?=
 =?utf-8?B?L2xkdzlaSENZcExRQTV5TzhDeDNwVHZVRmRGT3JSZEtWejd2RWNXNkhBbkZp?=
 =?utf-8?B?MFV1a3NqdXI4YjdNby9Ld3p5RnhzdVBFdUZTS3lJaUZMdlRIanVQZUltZ3Er?=
 =?utf-8?B?SzZITFFRdmkwNkNLcG1DTU5STlhOc1ZvVG1pTXZXUTI2cXRpQW80UlZOOTN3?=
 =?utf-8?B?bWo2Mms0MlRzcE93ZlVtdm5YZ29wSS9neEVtdkhqcGljQXBVSC96UTYrMzF1?=
 =?utf-8?B?VU5aQUhjMkI2Ly9iR2VjMUhlV05USUxFc0R2aXBmdkl1cER0U2FaemlpL0pu?=
 =?utf-8?B?MnVqUU1ITlRoK05DZTI3bXU3Q1BBNXhzQ2YxRHQ4TlkxS093cTZYSWRvY3ky?=
 =?utf-8?B?NGprdVY0amJFVnhrdmFXaks5ejlYUTJtSlY4dEtqUWRCdm5BQjBIQTdEQWJK?=
 =?utf-8?B?V210MGcxRzY0TWRXS3NtRmVEczJKWmJydzhkSnUzeFBxZXZCeG1oblhzU1No?=
 =?utf-8?Q?ITaSJYkWt7cGWmp8=3D?=
X-Exchange-RoutingPolicyChecked:
	QDgp/jnQdpPdAoXTBK3xMKPSI7FY547kZeD5tQhFlpIsfoOQ2My40I0dI40mYxMM3KutTG8EhVlSoG6oP1S0zmkBdwW1zNlrvRCYDaXAtdVDnAgaQlIh9HNxIsrrBn5PoQRoQuKjzN5CdfML2gnezjhvQTG++2y7ezny2OcvzmTO88YR4DUnd6OxjE2iLj9yCBSFhbVKVJLmkbP9Go0czohDYgxf0CSzsxU7GrOI3wdSO7N4HDIO+PrTTg0UUS7YqfLRU8LlSkWPwK6ZfhYNjxMJaiL73yCTDRCJ8qeZ1P6DF9dHFgKB5hmfyet3o8Ha4O0EwqjmGX8SzoM2c4Xwcw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uWwBRZEGdu5Wt5XOA5GrACJXVNHBQRdU8Rqor1lkWTeorlg2KnnwRoUPFWoAr9zcH/0ldeD6XBrRNNTydJ8IPrISPOxOzwGjqdqAIZgVLvHfNX6SW4peCqnAGbtiW8Ou5U3HJVpYOLWcAJrpHHk2IO5d/qdtRQY+eIDgePNlZznn1eNx3ZwLO/Cbr/VFWUo1CP5fhcj/MbgQyoO9f0pnNdE+Tx0SbI6MDKU+Bs0X6UHagEuQF16AMlXRpDT1Q/1FtNagHUwK95cTm0hSBt8jbaLxB8A1d31VNHwwztN+bhHLwckS/jbZNi2gtzaQwV1zM6dOe2OwVofvDW991IkeQxbvWo6Vnn8aQg5AzRbXYQIYEu2PkHxnS8cWPoTvPbGKSqd13BIpmQ5mHxLE7t5XsqUg4LJXMF7gTRSaFVva7FvIi5AEMJKgsywsrKHBIK4hzZ1KTaTkyFh7yyWhGINT5l+MytfHoIqpHPJvEGNtldsFjHGEsmTI9+k0VVxaZnpXp0ButaJH2ffk7TR+csg2cPEaPDxLz1KVAu7Nfbl7xssMRjnr7I9F9hUjYSRIEsTYmOiLwWiM44qcCmr0LgIBy8DKPnoqrnjmU1s+JEJQoQi/wosoaDSsOzRVEJLm8oS9
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a5af553-51d6-4473-ea6e-08dedb292c72
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 06:38:22.1435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wTKSfJys1EzufEikFkhFmN8ZN8mzLqPyMTaV2+TrL3wETXsww7RkLdtwhFvV4GRNs5Lx/zdgU+if3lVEc64k0W44wvc5b3NPLfpS9dpfi9Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR04MB8085
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[wdc.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[wdc.com:s=dkim.wdc.com,sharedspace.onmicrosoft.com:s=selector2-sharedspace-onmicrosoft-com];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13887-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sharedspace.onmicrosoft.com:dkim,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,vger.kernel.org:from_smtp,wdc.com:from_mime,wdc.com:dkim,wdc.com:mid]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 9AA3F70DB04

On 7/6/26 6:11 AM, Christoph Hellwig wrote:
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 9213a5716f95..20cb8ed7d987 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -7,6 +7,7 @@
>   
>   #include <linux/types.h>
>   #include <linux/blk_types.h>
> +#include <linux/blk_plug.h>
>   #include <linux/device.h>
>   #include <linux/list.h>
>   #include <linux/llist.h>
>
I know it's a lot of cross subsystem churn, but wouldn't it be cleaner 
to not include blk_plug.h in blkdev.h, but patch the update the 
consumers? A quick grep shows 68 files that would need updating and some 
you already  have updated.

