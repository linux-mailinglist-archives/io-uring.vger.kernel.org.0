Return-Path: <io-uring+bounces-4964-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1162E9D56AA
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 01:18:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4DDC5B2148B
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 00:18:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28EFD15A8;
	Fri, 22 Nov 2024 00:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="mOvk1by5"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8273510F1
	for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 00:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732234723; cv=fail; b=C+6FvqNOXyzkSc1HtWHmy+mjqQZM2vH7pnMxnJtJg0iJEB+c0VaXNlqbYFtIwujLvbYzbjl4YFfqURls/l4yechaRJ8Jn/BpdtxWiZWN9D7EeHb6FodumhF6jg/fPqLFvY5vm2ItQ6E9uKu5FNtKOUo9zN5YhHlp+yjwtUHWlHg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732234723; c=relaxed/simple;
	bh=uUXs1hSMjDEi/7Epvfs44qM9emPwLUYdDB03mRcLkH4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=XdLHvCkEGGiITA91pjL52MdsIM/CZEAxA2QNkHYVowMpWdkfDxYs2s9uDoJ5iRLyCS7DCZNy12DMUfCqvFhN+fypBzejKBDaORBdBi++icC9YOWTJBpjuRrHiz2tsWw4/peLmWchjL8dluXzcXt7yieZKC8cQFtCr4ecawIouUg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=mOvk1by5; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175]) by mx-outbound20-244.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Fri, 22 Nov 2024 00:18:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jeSWMaXNj+2rQm2H2hq0Y3FLsRecSrhucsvphRbTrdnD7lOjoUE4OQUXGHtxDkopaDI8g+IS2hZZggZQto/U30XkLVrcEjCtFRvlkwRMObjD98/Tlnc0iXUC1dbnO3rwV8655rwnZd0wzdV5d7X+n2YfAYDdvg2VXOr/+FMiBMWXI1ePO30MOUMV5yLl10sdg1fxyDLcMVBawntXy094R9vIdy/qLlyDO3W9Bir9Aul6+htgFXz00/wckUzoMEVfTGQzfVCloKNTdJ36W3mfT9dUZYMX8usM37e8q9VSfEnDGkzGPRLpCM6NEGHBVfKgwC/w7w4yRi8ZXQXTTO7ziA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rdyDw2y5vJF6YtfioCiYZQ1YHjH3jaK/Nj7D6eeI1eM=;
 b=UCkhnJ/WP0eW7A8pDiTZfTVd4fwR5OtM9xrvkVlYUijb+Hbh3dZfN3uWdJUOWynXE3B5HqjJ/nzx27GCHnjlngSnHbAK5o09B3NoDPYMmqW5EfkdmANrCYqNvyaqfkTw8PawGgG7HrMGR+qrkSGp5na+XdxY82hyA/P+XLPA8Yo+18rCL5SupmKKbheqFj+8uBYEMYvPHoeihvv2HfR9v7gzYfdKJd4i4mSz/8bdx0owea6OvWdokokxxtVNYlvC//Jnc/OPoejvfs+rfzyXK6LMQNn70feELsxYAqI1LOoTV/Vsh1ycalGSskPu0mXRNFtiTaKBQUwrdbSf+mE/Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rdyDw2y5vJF6YtfioCiYZQ1YHjH3jaK/Nj7D6eeI1eM=;
 b=mOvk1by5aLHUwiesV6ZZx5v9tfBthzdNgTJwEdFW63I8DLToPqY/WuudQ6Dvz4rBURWjHMSUjEFVvKBYGlS/G1ZbP9f5vQX8DP1M8M2taQBA4fMFhZ3kpRII7/jXh8ESv4lsYEWcFGrSXT1xtK6t8g8CugRQ0z0uLcfBBvEfQfQ=
Received: from BN9PR03CA0031.namprd03.prod.outlook.com (2603:10b6:408:fb::6)
 by SA1PR19MB4880.namprd19.prod.outlook.com (2603:10b6:806:1aa::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.17; Thu, 21 Nov
 2024 23:43:52 +0000
Received: from BN1PEPF0000468A.namprd05.prod.outlook.com
 (2603:10b6:408:fb:cafe::bc) by BN9PR03CA0031.outlook.office365.com
 (2603:10b6:408:fb::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.16 via Frontend
 Transport; Thu, 21 Nov 2024 23:43:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 BN1PEPF0000468A.mail.protection.outlook.com (10.167.243.135) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8182.16
 via Frontend Transport; Thu, 21 Nov 2024 23:43:52 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id EC5C332;
	Thu, 21 Nov 2024 23:43:50 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Fri, 22 Nov 2024 00:43:17 +0100
Subject: [PATCH RFC v6 01/16] fuse: rename to fuse_dev_end_requests and
 make non-static
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241122-fuse-uring-for-6-10-rfc4-v6-1-28e6cdd0e914@ddn.com>
References: <20241122-fuse-uring-for-6-10-rfc4-v6-0-28e6cdd0e914@ddn.com>
In-Reply-To: <20241122-fuse-uring-for-6-10-rfc4-v6-0-28e6cdd0e914@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1732232629; l=2733;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=uUXs1hSMjDEi/7Epvfs44qM9emPwLUYdDB03mRcLkH4=;
 b=yOS0tjfGNPy9fEvTuavjFUWWyFUkiDcMWd/gPLwRRaWZcsBqKmMmVNC8cNYfSOyvdLGTriRRi
 wyfg2yFvOyDA71N8ASUXW/fp4Cz11JiMNUGO47guXsHh+1dYnm3RB+J
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF0000468A:EE_|SA1PR19MB4880:EE_
X-MS-Office365-Filtering-Correlation-Id: 48376ed9-ddf2-41ca-689a-08dd0a865ad5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|7416014|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
 =?utf-8?B?ZGVPdWdhWVRESCtRc1lpY0hWRExMSnJCb09YTnR3SnMzeTJrdGxFZUtqUnhM?=
 =?utf-8?B?U0xrWHB3SjMzOUhMcC9VMlQ0QkRtWFQzb1FwUmlQdThTSWg1Z21wblJ2dUF3?=
 =?utf-8?B?NTd4VmVUSFA5bkp5QVdCUkhXaVZ4aWIzbUJLeDFJa2Y3bEw2SHdDVVN6RDRC?=
 =?utf-8?B?V2xuSThRSjNZSFN0WHpza2JtbjNrOWxqRFczcmNoRmt0UnJyYWRYSjVkVnNU?=
 =?utf-8?B?T3NaR2Zsancrb2l6VCtTQW5jRmxpQ0Jzb0lSbTJjeGx6OTVZQktxUW84NW5I?=
 =?utf-8?B?WjVORWVGZ2tDSUNJcHAwaC9FeWppMm1IOGV2Y1RudGRZRnEzRlVaV3NGSUw5?=
 =?utf-8?B?WXl3Z2tPSDY1dlplRkhUVFB1R21FbDBVTnI5K0xTVlhoRkMzNEh6M3NraE1N?=
 =?utf-8?B?VmNzaU9tRFpNd09jR2dLR3J4WFkyUVlLVkpRblhzaU5PRk8xS1hZQXVEdjQ0?=
 =?utf-8?B?S0VwY0dvVEhjdTM3WVVTQVNKS25Mb3Nub1NVNFJ3UUlqbjJhZE9DQnJ6djJz?=
 =?utf-8?B?NFpicjhyVklaczZaNU55ZXpSVWM3UWlvL2haNkJkWlM3V0t2d2dqUzZsQWdq?=
 =?utf-8?B?WUZySlZqMTNLajZscVB5aGhpbE5jQmo4MDUxcGI3Tk9XOU5yNTFENDM4MWow?=
 =?utf-8?B?eVE0bk4ybXJYRGpVd3NGN3FkcSs0L0xoTHIwL05xTTliZlRxRUVDZ2ZnMnlT?=
 =?utf-8?B?aTh3K3MrcktDSy9XWUFQd05HdndWUUpJOFl0VmlDYjlqVmJwRmJPTzNKb2NZ?=
 =?utf-8?B?WGVnUE9ZSmlKMTBKVXB0SmhmVml0UW5BdHJ1WlNtdUFiVDZlbFBvbExHQjBs?=
 =?utf-8?B?NkNnMjF6djA2Nk1KakRuaG95NGw2UXlvMy9RUGdid1VNdjVRSm16ZGJhNTlt?=
 =?utf-8?B?Ym53emFCaHFCWUd5TE1DeUNkRE1GcGZnSUdrSjljNy9DWENKR1prTGh5SWFi?=
 =?utf-8?B?ZURORkpHamVwZUh4a3dmMDYwTmRXa01YRjJWVDlKMkZxUzVJcXh4VUg3alE1?=
 =?utf-8?B?U0JJM1djVGptb3NncUt0alphVDBVZW1iT3A1d2oxWnhrT1hCYmRaRVJteDhM?=
 =?utf-8?B?UFUxbDNZZnlhV1VoRnFxellaeHIxUjg5dmRVY1Q5T2lEcWg3VkFlRUFiZFJB?=
 =?utf-8?B?MmF0cjZhQkdTQTI2bHY3c0tzWG1rMzdmeEcyUmxrMXNZR09Ud2FVMlFQYUFB?=
 =?utf-8?B?SHMxbEVvaWpPUERnMTJ0SDk0TGt3TnB6bzJmOFBkOTJ2R1pELzNnUmQ2b1Fa?=
 =?utf-8?B?L3VQU0drTWdmTmZ2Z0wrZmloWmF5T0h3VDZhR3I2cHVUTFNnajdnSVc2azFG?=
 =?utf-8?B?L2k2bE1rNXhqVWZQM1IrWVdHNzFyUEhJYlJlc1h6bGVPcWR5VU1OU0dXRFM1?=
 =?utf-8?B?VlpueGprc1pTT1VjSjk0bTgycGRHSk51TWxlakRURHpucHNHeEhZNkNRTThF?=
 =?utf-8?B?alBkRER0WnFUTDkyc0QzUmpvSXRPSzJrMkowb3lxeUlwODRtZ3NtSDB0Y3E1?=
 =?utf-8?B?bUxtVWRNeFBlWE1QMXk5RkZ5bVROZ3o2N0wza2JSTnp2aW5idnNnQXlJNnJC?=
 =?utf-8?B?amh1ZjhLY1UzcWswYitMWThmOWNLYXFQV2dTc1BrZHU3amdjVVViV3UrUjFl?=
 =?utf-8?B?Witsd0ljRXN3aFp3eTMwcXhpaUdQU0loMlBiVHlnb2pRbGNDTzErRXZxeDBU?=
 =?utf-8?B?YmZ5d254dnBSaTQwc3ZsZjE4R3ZYU2diTnlsc3JtQVI3dDhPME45OHo5MUJP?=
 =?utf-8?B?SjhSYWFJQkhKbk1zREYxUnVsMVJiQmg2NWFPNDZwbzdiVVcyOXdnOXBFMDlQ?=
 =?utf-8?B?U3BxSm9pTXRlVjlqK2VEZlBOTnoxWE1kdForOWpETVdxRFlvRnZNNGd0bjla?=
 =?utf-8?B?cVVzTG9aQ0s2OHhCT1RKbnRTTDZ3Z295UFNURldNb0EzcHc9PQ==?=
X-Forefront-Antispam-Report:
 CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
 +wiY5czHwJq1Vc7RRU2ToWIHnsed19vIgJqsImZnvj4eGrmeKqU3qjJKRGSV/0qVsNqJ7VnbOHsxEgAF/aH+BZ1Jb9b/67Impn+7eTEbGp/pHXewdO/qAlSPBv0yfe5xuDKt3pwHunPCvZP9qX28JGc+69nhYj8ZOYc4w5gqZNM+8YoslDVM3rlfpcSVziC8ZntOxp65XDMP88gOW6UCVnYaElut7VUGvSP4NV5niJl3u9k1bzmoYFB45K9WN4D642MYXuxHYOAp8bS11kSNzWDVSA/IGb4j3Gck55Ip4dExBfbh+lKGHZftCBWUDmek0MBitIWojkgxv4RIP7BgydZOdiwAAL0iLr8AFVjr7IofBPuxoyKkatX+acUCcXqgxBG/jKgA/nhovXSySK5uaIuWH1+UXRC0GcBZdsXuUlDj1rId/D897ofXTYUIPesPyHUwmUFm1tghpK6Fu6SrokQXNi83foSQqNg6Yo0r4lq2CZNvrjfTINYtl2PSw1AvO3NZDza45N0W/ruuNa2gSTIARR4kbsIBSCJwJd10Cwa/0McMzx6SlcSMQWI7pveGKakSF7+SRWR+DIXXtL7be4PIL/NfiPgJ4E0hGKJYiLMSDcdCgYD99tgBXKv5XEQ40tje7tmxp4e33SEqK8rXOg==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2024 23:43:52.0903
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 48376ed9-ddf2-41ca-689a-08dd0a865ad5
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
 BN1PEPF0000468A.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR19MB4880
X-OriginatorOrg: ddn.com
X-BESS-ID: 1732234719-105364-29565-6323-1
X-BESS-VER: 2019.1_20241121.1615
X-BESS-Apparent-Source-IP: 104.47.57.175
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVkZmJkZAVgZQMDXVyMDEJDHJ1C
	zZNMXMOBVIWRgnJ6VamJoZpKWkGinVxgIAekW70kEAAAA=
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260588 [from 
	cloudscan12-172.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_SC0_MISMATCH_TO, BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

This function is needed by fuse_uring.c to clean ring queues,
so make it non static. Especially in non-static mode the function
name 'end_requests' should be prefixed with fuse_

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/fuse/dev.c        | 11 +++++------
 fs/fuse/fuse_dev_i.h | 15 +++++++++++++++
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 1f64ae6d7a69e53c8d96f2e1f5caca3ff2b4ab26..09b73044a9b6748767d2479dda0a09a97b8b4c0f 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -7,6 +7,7 @@
 */
 
 #include "fuse_i.h"
+#include "fuse_dev_i.h"
 
 #include <linux/init.h>
 #include <linux/module.h>
@@ -34,8 +35,6 @@ MODULE_ALIAS("devname:fuse");
 
 static struct kmem_cache *fuse_req_cachep;
 
-static void end_requests(struct list_head *head);
-
 static struct fuse_dev *fuse_get_dev(struct file *file)
 {
 	/*
@@ -1873,7 +1872,7 @@ static void fuse_resend(struct fuse_conn *fc)
 		spin_unlock(&fiq->lock);
 		list_for_each_entry(req, &to_queue, list)
 			clear_bit(FR_PENDING, &req->flags);
-		end_requests(&to_queue);
+		fuse_dev_end_requests(&to_queue);
 		return;
 	}
 	/* iq and pq requests are both oldest to newest */
@@ -2192,7 +2191,7 @@ static __poll_t fuse_dev_poll(struct file *file, poll_table *wait)
 }
 
 /* Abort all requests on the given list (pending or processing) */
-static void end_requests(struct list_head *head)
+void fuse_dev_end_requests(struct list_head *head)
 {
 	while (!list_empty(head)) {
 		struct fuse_req *req;
@@ -2295,7 +2294,7 @@ void fuse_abort_conn(struct fuse_conn *fc)
 		wake_up_all(&fc->blocked_waitq);
 		spin_unlock(&fc->lock);
 
-		end_requests(&to_end);
+		fuse_dev_end_requests(&to_end);
 	} else {
 		spin_unlock(&fc->lock);
 	}
@@ -2325,7 +2324,7 @@ int fuse_dev_release(struct inode *inode, struct file *file)
 			list_splice_init(&fpq->processing[i], &to_end);
 		spin_unlock(&fpq->lock);
 
-		end_requests(&to_end);
+		fuse_dev_end_requests(&to_end);
 
 		/* Are we the last open device? */
 		if (atomic_dec_and_test(&fc->dev_count)) {
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
new file mode 100644
index 0000000000000000000000000000000000000000..5a1b8a2775d84274abee46eabb3000345b2d9da0
--- /dev/null
+++ b/fs/fuse/fuse_dev_i.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * FUSE: Filesystem in Userspace
+ * Copyright (C) 2001-2008  Miklos Szeredi <miklos@szeredi.hu>
+ */
+#ifndef _FS_FUSE_DEV_I_H
+#define _FS_FUSE_DEV_I_H
+
+#include <linux/types.h>
+
+void fuse_dev_end_requests(struct list_head *head);
+
+#endif
+
+

-- 
2.43.0


