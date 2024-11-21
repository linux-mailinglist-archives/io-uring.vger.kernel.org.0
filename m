Return-Path: <io-uring+bounces-4961-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 566079D56A7
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 01:17:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 16C97282CC8
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 00:17:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2017915A8;
	Fri, 22 Nov 2024 00:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="oEGM8LD5"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 524DB10F1
	for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 00:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732234673; cv=fail; b=Xl2Dh2DjIp8dRElzm8FIYC53ohmrqGJWxqtdDKdAVegVLeSrdKDwOE4X97CYQ301rDXTVwrCUf+GMT3mCxQ5JOqwabDTbOqXcm6K/QIeVjRsu5D6aFUr+cvLnkymWFpKZRw4yj7loa5FoUVnaGaNBuw0WBHQxIFdXBpC9YhWSx8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732234673; c=relaxed/simple;
	bh=9nUysfJUfbYWnpD6A+/FByuJ1TitHWotQTdkRx7URnI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=D1sKug72Xv31nheOKGCFNo8CF+zYW6MPzDxUaz9rEE3D7vtVUw+x3ihriz7/52QWyN6iIiPKx/nT9sUgDAHV47EXku9eHdrcQX1LNG4J0QrLLAES0R8O62ENcBlEFuGetyPXqgrg2zu4NxlCFBaouEQl+I4xHsmc4OydkblZu70=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=oEGM8LD5; arc=fail smtp.client-ip=209.222.82.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175]) by mx-outbound16-233.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Fri, 22 Nov 2024 00:17:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Tz3eusSambYjmIbTLDA1mizWmlAgNO12cGEGzsS0Q1jIx2160XxM2ae2nPT/ETwrvyoFOzk75UHuM+HQBW+KYlllL3QEtu2vBaBIJBoX6K+9rTBUiAn4TQ8uXLLOMOow9ekYFutA18/X6lphgkg0+/Q/7/NvncZqHspYNe5P8K9jiv3gjV7R8syNTtKKTmTl2gGqGBPUcJXvTIL/8D/F2gZrkqmQqfoI1VISNvItoUv7/tKqpcBXzCXF3ls6fTArbLYofwK+MiLWjj/lXMo4k6nsn6ACraTGVJaQ9eco/Uwd7//zk/n8VwdE/HTUZ/Mb6qs878e4WA9F/08b59RBxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=74kXzFNgXKq9vGFv4p3Y9Rxl5krqWGxnaq50CydloCo=;
 b=Eaiv00qdJW4745mS5p/4GYD4PaTisVmXztc39mg1AZqeTqvrBmbqW0WyXalSsrGXNwhxBuG++VxCajoDa2M4MGJRaIZ2aMBzRLOgshmL80c01YzpYxb/efrLBXH4ZyuNcySRpifhE0hqai2MTMgHvmzX9O6zbJmLHwpMWXTwfShpp6zqfuZW5NP/Sopcq1GVukD1c4sHYi8tMydrMiD4/t9EPWo8MSaFJRhprTqeHtAh125Fg9Zk7yKAU0C2ZaUohKsCzvLvzwc7dVb5OHogUDE0uR7BPpEObeG82h1xjU1AhVlrqHQ5CdNnkUsvtr1ptZJcmCwti9k91r2RLoHzaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=74kXzFNgXKq9vGFv4p3Y9Rxl5krqWGxnaq50CydloCo=;
 b=oEGM8LD592MzVRDrJhSLlk/rzjypDylcPVFAnUhLA6MJ0GABTp6J4d1UOkj5coCu2mJjVfq+zjW5CAMz6Y/1vBpTyjGDvJjSklJnjZJSsRy3k243yhjULqVwXdkKACEUaF1KJZCSxunXEuloPvwu3wQDrtqbDvYgMQ8H2fbyii0=
Received: from BN0PR02CA0035.namprd02.prod.outlook.com (2603:10b6:408:e5::10)
 by SA0PR19MB4382.namprd19.prod.outlook.com (2603:10b6:806:90::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.25; Thu, 21 Nov
 2024 23:43:56 +0000
Received: from BN1PEPF0000468E.namprd05.prod.outlook.com
 (2603:10b6:408:e5:cafe::2c) by BN0PR02CA0035.outlook.office365.com
 (2603:10b6:408:e5::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.15 via Frontend
 Transport; Thu, 21 Nov 2024 23:43:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 BN1PEPF0000468E.mail.protection.outlook.com (10.167.243.139) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8182.16
 via Frontend Transport; Thu, 21 Nov 2024 23:43:55 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id CEBD532;
	Thu, 21 Nov 2024 23:43:54 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Fri, 22 Nov 2024 00:43:21 +0100
Subject: [PATCH RFC v6 05/16] fuse: make args->in_args[0] to be always the
 header
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241122-fuse-uring-for-6-10-rfc4-v6-5-28e6cdd0e914@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1732232629; l=8701;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=9nUysfJUfbYWnpD6A+/FByuJ1TitHWotQTdkRx7URnI=;
 b=hGFVLgMRV1e+kbc1b77p7PqP+IN2hcbVTzIII718GoTe5qaXdpM63xU7sLrvCV8LUiLV9/3Rl
 0LUXP0HWuHVDaptfqaNXVyzvgxEbboKjyhh/fUgVb6L/JEA0aD0mnh0
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF0000468E:EE_|SA0PR19MB4382:EE_
X-MS-Office365-Filtering-Correlation-Id: 93b811ef-6573-456b-cd0f-08dd0a865d2b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|376014|7416014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
 =?utf-8?B?MWVSd1llT0ZKclZNeUZoKzN5NDJiOFFoemFjSVZ4b1doL1FpNlNuMW5mSkNK?=
 =?utf-8?B?Nkx6YmNOa2ZJSUZ1VUsvVmQ3K2E3clMwQmZHa2creUM5QTdDWVY1djlFL2dS?=
 =?utf-8?B?VDMrVFpTeDUxcmVjRXVtVEdxTXVqVWJhUzhnbEowVUJXdUhyQ1ZldDBYTjEw?=
 =?utf-8?B?eVpwOVRBZUJuNUlLeGRLNGZXdXYwSEVVMG1CaEgxUURUb0RVc2Fmb3U5TlQr?=
 =?utf-8?B?cW03dVIrZ3JJWUFjWGpEd3VIaWpjTVhpdWFyL3ZmbU1Ib0FZNS8xUkFsRCs3?=
 =?utf-8?B?cHJDeU83anlKcWVRUnBmWVlHb1MxODMwY1RNK2ZmODV1dUpnRTUxUkNGdEN4?=
 =?utf-8?B?UjdEOUMxZzZTSTRodEdteCtlL2VLaUVwVFA2VFFGQlJiSHQ4blEwYldRMmZq?=
 =?utf-8?B?OGNvYStiU0p3VlprcDRscDRQYTRGK0MzNDVIdEViZktBYkV0cVdwTnBtN2hD?=
 =?utf-8?B?OW1wMU1TSnNUN1BVTm1iU1NkR3BYNEVUWkNqR2l5ZUJaTTd0WXMwT29hZ0N4?=
 =?utf-8?B?eFNDT0FnR2U2VDYzeGhUb1FVMUNESzZ6VC9NRDJ0cDh5aDJPODYxUnZzS3dH?=
 =?utf-8?B?VEJwRktQSjltWWxxN0diSDc1b2w0bm9hRmd3dnM1ZHdVNjNnSTlKdWZsQ043?=
 =?utf-8?B?UGNJVEpDdXRJbjV5d2hNdWh3dUZ1cWh5Y0JKOWIzSnFNS2tLQitDQW1xdHpU?=
 =?utf-8?B?a3ZuV1pDVHhXcDRnWGNDVEtrNFZXK1VCS0NaVHZIRjdjZzdHcjV4MGxkdnNP?=
 =?utf-8?B?RXNPeVFuTHJsMXpEY2lxRlZwZWo0UzQ2cFl6eEltZXhQNDJHUWFyVUJ6S1d0?=
 =?utf-8?B?eFQyZDFxRk9qOW14aHJaSUhzcFV5WmJUbWVXS0U3Z3pza1hPMFpsWStPMkU1?=
 =?utf-8?B?UTMzNE9lZDJyTFZSbG9yaHoySzVaRHdoMWNFYkNJcElhckh1OEJFSXd6dGhG?=
 =?utf-8?B?b2cyTzZ4bnVydURQcXFQbDlxNEwrU1J5QUtpYzM1NzB5OU5ybmI4dWc0cHhG?=
 =?utf-8?B?cEtVVVV0SXFPMHZsanRtU1BKckIrb2pOSFZTU050a3hxbXh4S3hyU2V4Rmg4?=
 =?utf-8?B?WVRkd3JPR0I3YnIyRExTS0ovVDZBYmhOdW1NRUJJczNvUk1tajN0eGw2SzRy?=
 =?utf-8?B?VmVXTHRDM0JWOXg2dFA1N2g1SytwRXBqUGRDK1Rjc2RqMXZYdTB5TzQ5MGZ1?=
 =?utf-8?B?N0JKV2NOSWZKbERVT2JQRkQ3Umx2ODA1YklwTktiRTZualJGNnNlRWJyUmY5?=
 =?utf-8?B?NVdKQUhNRjNoQXFIWk16aVFQM3VoTDFXQS9HckN6WFBOODJxcGF1SGlObm05?=
 =?utf-8?B?RUd6aUpzTFZOY09jdEozY0RxTlBwV1ZMNmpmbzZMb3B2ZG9PMHM1bUtmMWpL?=
 =?utf-8?B?YXdjNlpSWHNaYTRJaVpMOUs2NExheE85b3YyTWlNWHFIeTBwQzNpYU0zZ1Mr?=
 =?utf-8?B?c1hBQlFaNmhteGhqbHVWMmxIVGJUOUVZRzNmTXRFZkhlK2pxQkFicmlKOFRi?=
 =?utf-8?B?NUk4cUltcUl0QTlPa3dpVFgwU0MvL3NPMGZFbE4rUmg1Nm9LbVI4WFU4bHRz?=
 =?utf-8?B?WlZsS0plcnRsMjMyV3NUeUxtUVc2c0xuQjk1bkFQK05qZ0poNXkyeGY2ckNv?=
 =?utf-8?B?R25MeFBpS0JOQXFuYkZoZ1VCTE1jNWw3UXNUdm13NU8weEwvS1dIeHVYaEU2?=
 =?utf-8?B?SVdRZHVXTFF3d1NLWHBqU0hEQ1BrcHZKWEY1aWVZcDdPN250cFpMTjlJTnh2?=
 =?utf-8?B?V05KcHJlalZhZnVraDRCS0ZmTTZXcTM2YkF0eUdIS2pDL09zL1psM0Mxd0oy?=
 =?utf-8?B?cGUxa1htYzN3UEJSdTBOSWxOSUxIUjlBOVJ2c3FCbjJLT0VyUTZxa0s2NkZ0?=
 =?utf-8?B?SGJTVHkvSU1nR1E2dTIzb3ZaYkVhWU1Nd21rUVpDY0ltbEE9PQ==?=
X-Forefront-Antispam-Report:
 CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
 nVwDaZmUEhwUt/9VRqb2xiII3GplHLwiJAtqMd6wlIOEc49pZFIZCK4A5HXzCFwwnyFMLxJHOZuY4Gn1gDSeHBBBbqCzP21cLso3oCIEeviok3WR1z4k9qVlNqd2HDvwVPbtO4CKg8bWBBdF+Zy3qc4xBq3hALewGnL5zfh5bMmSdDELX7rWfo5tZEvd14QB/PzlyoxYJq6PUx0FI86ID0NQDxAeyibv0Hm/0SaYrqfyL0i/vicAYeNGE5HliWstaFxEWpmP1p1RygfPUTXC9Kevi2BOMORJnyJIiBa6EctZVWWO4QUDOsI+1OHRkmvryCT4mwDMiB3TBrEcF/QCMmahGYdsfn81fR1FMBaT4eJc/ED5UjrOMBce1vplSZIoNhVlX/X1NSM4djKv6gHvKfT3gLHczO3E0YSDoml7AP7sgfGnJfmRJ/uvuE0feAOQuWAzexeaK8CQTefVWAvNExG/TO/6i8eim0xKXlFeKenckEYWJj4zcf5AQCTbUFugxZ+JWZ6dn2od4NMA5S6dVGsfh0GHMboIFaSI2mkkr86zLchRPJuAwu59PJ6RMwsu3NeMycyK2CGA0Duh1PbdrAr5LiXstZlOnqlg4+YxT27JEERHHxM8xDWnxttcaDNjzAD2T4I7bpNSjpWaQOLRaQ==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2024 23:43:55.9025
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 93b811ef-6573-456b-cd0f-08dd0a865d2b
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
 BN1PEPF0000468E.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR19MB4382
X-OriginatorOrg: ddn.com
X-BESS-ID: 1732234669-104329-12090-15644-1
X-BESS-VER: 2019.1_20241121.1615
X-BESS-Apparent-Source-IP: 104.47.59.175
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVhYmphZAVgZQ0DjNLDXF3NA0Nc
	3S0ijF2DjR2Cg10dgi1SLZNNXEJNVYqTYWAM4sfFZBAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260588 [from 
	cloudscan13-132.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_SC0_MISMATCH_TO, BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

This change sets up FUSE operations to have headers in args.in_args[0],
even for opcodes without an actual header. We do this to prepare for
cleanly separating payload from headers in the future.

For opcodes without a header, we use a zero-sized struct as a
placeholder. This approach:
- Keeps things consistent across all FUSE operations
- Will help with payload alignment later
- Avoids future issues when header sizes change

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dax.c    | 13 ++++++++-----
 fs/fuse/dev.c    | 24 ++++++++++++++++++++----
 fs/fuse/dir.c    | 41 +++++++++++++++++++++++++++--------------
 fs/fuse/fuse_i.h |  7 +++++++
 fs/fuse/xattr.c  |  9 ++++++---
 5 files changed, 68 insertions(+), 26 deletions(-)

diff --git a/fs/fuse/dax.c b/fs/fuse/dax.c
index 12ef91d170bb3091ac35a33d2b9dc38330b00948..e459b8134ccb089f971bebf8da1f7fc5199c1271 100644
--- a/fs/fuse/dax.c
+++ b/fs/fuse/dax.c
@@ -237,14 +237,17 @@ static int fuse_send_removemapping(struct inode *inode,
 	struct fuse_inode *fi = get_fuse_inode(inode);
 	struct fuse_mount *fm = get_fuse_mount(inode);
 	FUSE_ARGS(args);
+	struct fuse_zero_in zero_arg;
 
 	args.opcode = FUSE_REMOVEMAPPING;
 	args.nodeid = fi->nodeid;
-	args.in_numargs = 2;
-	args.in_args[0].size = sizeof(*inargp);
-	args.in_args[0].value = inargp;
-	args.in_args[1].size = inargp->count * sizeof(*remove_one);
-	args.in_args[1].value = remove_one;
+	args.in_numargs = 3;
+	args.in_args[0].size = sizeof(zero_arg);
+	args.in_args[0].value = &zero_arg;
+	args.in_args[1].size = sizeof(*inargp);
+	args.in_args[1].value = inargp;
+	args.in_args[2].size = inargp->count * sizeof(*remove_one);
+	args.in_args[2].value = remove_one;
 	return fuse_simple_request(fm, &args);
 }
 
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index fd8898b0c1cca4d117982d5208d78078472b0dfb..6cb45b5332c45f322e9163469ffd114cbc07dc4f 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1053,6 +1053,19 @@ static int fuse_copy_args(struct fuse_copy_state *cs, unsigned numargs,
 
 	for (i = 0; !err && i < numargs; i++)  {
 		struct fuse_arg *arg = &args[i];
+
+		/* zero headers */
+		if (arg->size == 0) {
+			if (WARN_ON_ONCE(i != 0)) {
+				if (cs->req)
+					pr_err_once(
+						"fuse: zero size header in opcode %d\n",
+						cs->req->in.h.opcode);
+				return -EINVAL;
+			}
+			continue;
+		}
+
 		if (i == numargs - 1 && argpages)
 			err = fuse_copy_pages(cs, arg->size, zeroing);
 		else
@@ -1709,6 +1722,7 @@ static int fuse_retrieve(struct fuse_mount *fm, struct inode *inode,
 	size_t args_size = sizeof(*ra);
 	struct fuse_args_pages *ap;
 	struct fuse_args *args;
+	struct fuse_zero_in zero_arg;
 
 	offset = outarg->offset & ~PAGE_MASK;
 	file_size = i_size_read(inode);
@@ -1735,7 +1749,7 @@ static int fuse_retrieve(struct fuse_mount *fm, struct inode *inode,
 	args = &ap->args;
 	args->nodeid = outarg->nodeid;
 	args->opcode = FUSE_NOTIFY_REPLY;
-	args->in_numargs = 2;
+	args->in_numargs = 3;
 	args->in_pages = true;
 	args->end = fuse_retrieve_end;
 
@@ -1762,9 +1776,11 @@ static int fuse_retrieve(struct fuse_mount *fm, struct inode *inode,
 	}
 	ra->inarg.offset = outarg->offset;
 	ra->inarg.size = total_len;
-	args->in_args[0].size = sizeof(ra->inarg);
-	args->in_args[0].value = &ra->inarg;
-	args->in_args[1].size = total_len;
+	args->in_args[0].size = sizeof(zero_arg);
+	args->in_args[0].value = &zero_arg;
+	args->in_args[1].size = sizeof(ra->inarg);
+	args->in_args[1].value = &ra->inarg;
+	args->in_args[2].size = total_len;
 
 	err = fuse_simple_notify_reply(fm, args, outarg->notify_unique);
 	if (err)
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 54104dd48af7c94b312f1a8671c8905542d456c4..bea9fba2b1473750c70a1c336d695c5c205d9c07 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -172,12 +172,16 @@ static void fuse_lookup_init(struct fuse_conn *fc, struct fuse_args *args,
 			     u64 nodeid, const struct qstr *name,
 			     struct fuse_entry_out *outarg)
 {
+	struct fuse_zero_in zero_arg;
+
 	memset(outarg, 0, sizeof(struct fuse_entry_out));
 	args->opcode = FUSE_LOOKUP;
 	args->nodeid = nodeid;
-	args->in_numargs = 1;
-	args->in_args[0].size = name->len + 1;
-	args->in_args[0].value = name->name;
+	args->in_numargs = 2;
+	args->in_args[0].size = sizeof(zero_arg);
+	args->in_args[0].value = &zero_arg;
+	args->in_args[1].size = name->len + 1;
+	args->in_args[1].value = name->name;
 	args->out_numargs = 1;
 	args->out_args[0].size = sizeof(struct fuse_entry_out);
 	args->out_args[0].value = outarg;
@@ -922,16 +926,19 @@ static int fuse_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 static int fuse_symlink(struct mnt_idmap *idmap, struct inode *dir,
 			struct dentry *entry, const char *link)
 {
+	struct fuse_zero_in zero_arg;
 	struct fuse_mount *fm = get_fuse_mount(dir);
 	unsigned len = strlen(link) + 1;
 	FUSE_ARGS(args);
 
 	args.opcode = FUSE_SYMLINK;
-	args.in_numargs = 2;
-	args.in_args[0].size = entry->d_name.len + 1;
-	args.in_args[0].value = entry->d_name.name;
-	args.in_args[1].size = len;
-	args.in_args[1].value = link;
+	args.in_numargs = 3;
+	args.in_args[0].size = sizeof(zero_arg);
+	args.in_args[0].value = &zero_arg;
+	args.in_args[1].size = entry->d_name.len + 1;
+	args.in_args[1].value = entry->d_name.name;
+	args.in_args[2].size = len;
+	args.in_args[2].value = link;
 	return create_new_entry(idmap, fm, &args, dir, entry, S_IFLNK);
 }
 
@@ -982,6 +989,7 @@ static void fuse_entry_unlinked(struct dentry *entry)
 
 static int fuse_unlink(struct inode *dir, struct dentry *entry)
 {
+	struct fuse_zero_in inarg;
 	int err;
 	struct fuse_mount *fm = get_fuse_mount(dir);
 	FUSE_ARGS(args);
@@ -991,9 +999,11 @@ static int fuse_unlink(struct inode *dir, struct dentry *entry)
 
 	args.opcode = FUSE_UNLINK;
 	args.nodeid = get_node_id(dir);
-	args.in_numargs = 1;
-	args.in_args[0].size = entry->d_name.len + 1;
-	args.in_args[0].value = entry->d_name.name;
+	args.in_numargs = 2;
+	args.in_args[0].size = sizeof(inarg);
+	args.in_args[0].value = &inarg;
+	args.in_args[1].size = entry->d_name.len + 1;
+	args.in_args[1].value = entry->d_name.name;
 	err = fuse_simple_request(fm, &args);
 	if (!err) {
 		fuse_dir_changed(dir);
@@ -1005,6 +1015,7 @@ static int fuse_unlink(struct inode *dir, struct dentry *entry)
 
 static int fuse_rmdir(struct inode *dir, struct dentry *entry)
 {
+	struct fuse_zero_in zero_arg;
 	int err;
 	struct fuse_mount *fm = get_fuse_mount(dir);
 	FUSE_ARGS(args);
@@ -1014,9 +1025,11 @@ static int fuse_rmdir(struct inode *dir, struct dentry *entry)
 
 	args.opcode = FUSE_RMDIR;
 	args.nodeid = get_node_id(dir);
-	args.in_numargs = 1;
-	args.in_args[0].size = entry->d_name.len + 1;
-	args.in_args[0].value = entry->d_name.name;
+	args.in_numargs = 2;
+	args.in_args[0].size = sizeof(zero_arg);
+	args.in_args[0].value = &zero_arg;
+	args.in_args[1].size = entry->d_name.len + 1;
+	args.in_args[1].value = entry->d_name.name;
 	err = fuse_simple_request(fm, &args);
 	if (!err) {
 		fuse_dir_changed(dir);
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index e6cc3d552b1382fc43bfe5191efc46e956ca268c..d9c79cc5318f9591c313e233335d40931d6c7f58 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -938,6 +938,13 @@ struct fuse_mount {
 	struct rcu_head rcu;
 };
 
+/*
+ * Empty header for FUSE opcodes without specific header needs.
+ * Used as a placeholder in args->in_args[0] for consistency
+ * across all FUSE operations, simplifying request handling.
+ */
+struct fuse_zero_in {};
+
 static inline struct fuse_mount *get_fuse_mount_super(struct super_block *sb)
 {
 	return sb->s_fs_info;
diff --git a/fs/fuse/xattr.c b/fs/fuse/xattr.c
index 9f568d345c51236ddd421b162820a4ea9b0734f4..c26afacbe53c1a164e27d6253360e0e1808e2ea6 100644
--- a/fs/fuse/xattr.c
+++ b/fs/fuse/xattr.c
@@ -158,15 +158,18 @@ int fuse_removexattr(struct inode *inode, const char *name)
 	struct fuse_mount *fm = get_fuse_mount(inode);
 	FUSE_ARGS(args);
 	int err;
+	struct fuse_zero_in zero_arg;
 
 	if (fm->fc->no_removexattr)
 		return -EOPNOTSUPP;
 
 	args.opcode = FUSE_REMOVEXATTR;
 	args.nodeid = get_node_id(inode);
-	args.in_numargs = 1;
-	args.in_args[0].size = strlen(name) + 1;
-	args.in_args[0].value = name;
+	args.in_numargs = 2;
+	args.in_args[0].size = sizeof(zero_arg);
+	args.in_args[0].value = &zero_arg;
+	args.in_args[1].size = strlen(name) + 1;
+	args.in_args[1].value = name;
 	err = fuse_simple_request(fm, &args);
 	if (err == -ENOSYS) {
 		fm->fc->no_removexattr = 1;

-- 
2.43.0


