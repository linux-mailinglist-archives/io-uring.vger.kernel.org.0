Return-Path: <io-uring+bounces-4552-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D9869C0D15
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 18:38:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 40BF41C20823
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 17:38:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09F93191F6A;
	Thu,  7 Nov 2024 17:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="yzwfEhyc"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C20215037
	for <io-uring@vger.kernel.org>; Thu,  7 Nov 2024 17:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731001120; cv=fail; b=OyqpCvSAF03m3qd8ioA3YJaXFZgkNYI3BxXpcKPim5Laaj7NyAbWG+wa+4bkQ5YUa2KTJ7xKo5pOBQ0n1Y/+zpdJHDK+eEVIo4QnP/VFaAeWDRBKNnQr/elHoZCCc14QkMumPgR09E9JSXkBZCjKMyjMReB8uFDdbH/Czf+tFDo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731001120; c=relaxed/simple;
	bh=Dhyra5ZisXo3/fGDB7AdDHYq1p7jMsd1intWqgr6dCc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=oTrbtWg5a0Ua3ryRBIpzSOKY1O602jyJ4uvFCgMmdajrrxXAshVUzmb/663k9ASj0YD6CXZcs7k8ygDambKkya2FlhcGNxWrBVFi5rV/vr5w/LQnLzW078axJcqYLvYOQXLOiPXGmLca8tR+wPNZieaGf+gKR/oZfrX7cWiToQk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=yzwfEhyc; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2046.outbound.protection.outlook.com [104.47.58.46]) by mx-outbound23-71.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 07 Nov 2024 17:38:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H7zerXG87dP8g8h5KbBHwhTJiChgyC8TP9cqBEoKvvCZgPNVFC+FTMXT+maR5sp7ERpSr0NMzQi6Wc7O+eYolMLchQbBX/Qsnk9054zVJP4QlV/G8bph34nTSSbOqmUGyUhoouKsYkkIcIk+ILGY3lH2JlsaO5xSgSnkoQMIhz3Q/fH1dxBA10a9bJOC1ydAuLbzc4GeMuLzU+G3QY4YfHuQMZBpTBCjgYFT037o0bMgQFIGr8ohCZfg/sVsj/JLQ5gV77RABGFjadqTNYeKV/PdbPuB8ObufYBUm8SE8gV3pbqGDpoaBC//nsAyifVPpyamqtv953sl2H/EQ2TtMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XY+gSkD3xQJFGPDuPOW2IchQVCHmpEJB0oJ0sto/azo=;
 b=KuStIlHEiK50vGJgAFi1xuo83XMBFCE7PBm9QnJXvcxODK28ZVpkmO2huCupDF1LiOOohiYi1xzju2rcf6ofS8VwdEo4WTePl4DvqYjEAqtsoHgI3O44TMIuDEXPiizj6Kl9ma8aOkJWd39KordKgA+S+pZ7fcLo4qHxAnulYOcc2ajfeURUFOGFwiAOZJ2S6pA1QO+GAeRgCoMlbXZlDF9MP7WcfMPCy9vtA6ltxF+2UkxOd5DjPXrVQyEhQpZhEUggvKi48AGvYbiyw6Q554npsLAIntVOS1e7U/u61zsEOGVuK081ALRAOF2FWIlWL0yY+JxxE4Hbqc0LU/amOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XY+gSkD3xQJFGPDuPOW2IchQVCHmpEJB0oJ0sto/azo=;
 b=yzwfEhycnam9EQIvmijNkbaBDvmP2+zIzJs6yJxUtd1YzHjqAoqBZdRGXBGu3M/lkAXvGWChgIjNO11XSiTi5M7IM42ESNcaiJ6cmRxlKJpoIVASdAhBvH2/96bxHAsPRAd0rMlZc/wd9VNkORPQTB+VNAwbaEmIHdE9WbRdDTI=
Received: from BL1PR13CA0285.namprd13.prod.outlook.com (2603:10b6:208:2bc::20)
 by SA3PR19MB7586.namprd19.prod.outlook.com (2603:10b6:806:31c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.20; Thu, 7 Nov
 2024 17:04:22 +0000
Received: from BL02EPF00021F6A.namprd02.prod.outlook.com
 (2603:10b6:208:2bc:cafe::ac) by BL1PR13CA0285.outlook.office365.com
 (2603:10b6:208:2bc::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.17 via Frontend
 Transport; Thu, 7 Nov 2024 17:04:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 BL02EPF00021F6A.mail.protection.outlook.com (10.167.249.6) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8137.17
 via Frontend Transport; Thu, 7 Nov 2024 17:04:21 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 030EDC6;
	Thu,  7 Nov 2024 17:04:20 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Thu, 07 Nov 2024 18:03:55 +0100
Subject: [PATCH RFC v5 11/16] fuse: {uring} Add a ring queue and send
 method
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241107-fuse-uring-for-6-10-rfc4-v5-11-e8660a991499@ddn.com>
References: <20241107-fuse-uring-for-6-10-rfc4-v5-0-e8660a991499@ddn.com>
In-Reply-To: <20241107-fuse-uring-for-6-10-rfc4-v5-0-e8660a991499@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1730999049; l=4829;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=Dhyra5ZisXo3/fGDB7AdDHYq1p7jMsd1intWqgr6dCc=;
 b=/jsz8YFvAg6/Y9j8vqwGrrD3+pEyKC90DuRteYdeDMOo+AaO6q1VQ18Aw1S0fOFT2tMgGdRG2
 1w0BmzeN84+ATIJcrzRV0cnyGCfJlXTgVP8UFZc1yBk3WEqEciAqhhR
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6A:EE_|SA3PR19MB7586:EE_
X-MS-Office365-Filtering-Correlation-Id: f232172b-6368-4cd3-d760-08dcff4e39bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NitBMHhwU01ZalFJWk9DK1ZVUkp6WXRzbE90bVhZZWQ4VDY1aS96dXk2VlBI?=
 =?utf-8?B?VDAvN3ZYU1RKQ21PbDlBNGdRKzVpZE9PS01wQnlFQ3JCNk41TVMrbUlLRm93?=
 =?utf-8?B?S3JTNmVpdm1hbG1kdVplcWkydE1KdlQ2V1ZKUkt5azNNMUdPR29qTXZHVkN6?=
 =?utf-8?B?cWsrL1lqSTMvVkFCZDV0NThIbmxKS2Y0WEZaSnRza1ovclVXbWZjOUNla0da?=
 =?utf-8?B?Q3dYT3hLdDE0V0hmbGtJaS9SczlHYzlYYVVJUFNpalRXd21HNC9KUGk1cVhx?=
 =?utf-8?B?bVNZNWx2VjVtOVJPUEZVNGY4YXEwdVpIZUhINlJxMm53WnZRcWk0bVh0RlhH?=
 =?utf-8?B?NXRzM3R4dEZHVjNva3BMMXdHNWNlcE8rZ3JkdVRmaTVGTVcrRC96NGhTY3pj?=
 =?utf-8?B?amZPSWZ4MjBRRHpUYW5mOGtnVjdZdzljbUpBNUhYTmpzUXplK3d2NWIrSlNv?=
 =?utf-8?B?QjR4SzVneGV2NzB3YWQrbVVISnB0UlV2RExtc3FQVWkzc1JZWElWNUJZaEwr?=
 =?utf-8?B?M2JSQ0UxOXJtbk1CSGFjZU9QTEw4TGNsbHBOTVgxN1g0TjNpcDdZY3Z5dG50?=
 =?utf-8?B?eVo4aDd5WE5CZkh2MnNTOGJzQzhBdkRBdDNOWUt0SWhkZk9jRFQ0YWRLczZu?=
 =?utf-8?B?bGdwQy9wTVVlNlVvMzJtbC9JWU51VVphNjIxVGE5OENnM2t5UUkvWjNscnB3?=
 =?utf-8?B?SHVONnNhRGVnNlF5Tm52NHBTSVdKSmVCeTJHcTdvVnltdVBjblMvQUpDc1hM?=
 =?utf-8?B?UGJmcEpIMzdXR2NtTG41TVIvMDFLV0RwY2ZtUE0vYkJXSklJNFdjaGNTSU1K?=
 =?utf-8?B?VHIzazU5WTBFcmMrUTlrajdkaFk5L1pJcFg2ZHhlcWhJUDBjU1lPSE0xaUN2?=
 =?utf-8?B?RVRBQ3hTYzQwWUlna2twUTFTYVhlSEIrakdPd1B5MURiY056LzhkM0VsT0xR?=
 =?utf-8?B?VHhPRlFhOVR2VU9zMnlvaXljeEZDZWVoUmRRb1g1a0tVVEpYcnJlWk03RlY0?=
 =?utf-8?B?VmRkKzB0ekF0WSt3SHVvbURxZG9OS1pFbm1KdlphNUhqQitXNkQrSFZBME9k?=
 =?utf-8?B?VVlKaytsTkFPT1ZkdjkwOHY3S1JQbU9EajN1L2RsTk5sQXBIb255QzZpTFVU?=
 =?utf-8?B?REFieEdmejJINEg5N2VOeWwzKzh2QUFvNElXUTJJY0owVXRoUGlWTGIxUTZp?=
 =?utf-8?B?TjIzelFlSVR4RitPNmUvK1I2eDBHdmVZV1dCK0RwWWtpMzkyN2crZm05ZmRO?=
 =?utf-8?B?MlFHZ1o1Z0s1MkJ0R0RZVit6M3g5OTVsNDlFNzNmZkNseldaUk5OWnZhWjZS?=
 =?utf-8?B?YWtidzRjU3BmMjB0KzNTcklMVXd1R1ViMWhnbVhsaDhCc1AzTHNZQmh3ZzB2?=
 =?utf-8?B?TFlKOFNqYmwzSDVNY1pHNEp6cVdpY05kbXNaZnhoOExta21hUEVWNklSRGw1?=
 =?utf-8?B?WGhZMGozNVBDelNlNU1tY2wxNWxzSTYyRFdna1JqZnM1QlJqMHFqek8rekpX?=
 =?utf-8?B?WEM2R0FpU3lzWUQ0elJZWCsxOHNMRjhBRkVzaFozUmpiTXhOZ2ZmdjB3QTBs?=
 =?utf-8?B?MFBzOTFjNnBUN2o1VnVzeUtLd0xqanV6ZnJVUkxiZjdIMmJYRDlqZm5VLytU?=
 =?utf-8?B?YkFMbFlQd2xwVkJTYmdCM25Ucm1OSElWL3JpQUFLNjhZRk8yRElUdkJXNDhi?=
 =?utf-8?B?UVRBSytqcXZ2VUlRTXlJUjh1azNFOGd4ZmV4RWliN0FTVytCWEpKTW9jYzl4?=
 =?utf-8?B?WC95eTFLdWFsRlpNYVhTaC9nZ1dUYTBoc0dMUGJINWg5b1krWmZpc0RxdG5l?=
 =?utf-8?B?UE1CcmJpZGZ2aUdvdzZaRFlYREREZzJpRU9la0g5UFBGV1I0ZzJ0Z202ZVNY?=
 =?utf-8?B?QStvd0x5eDh4cm83Mk9nOHRxWmV1NTN2bzk0RCtSYmNsZFE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zsB4AJC2e7SVq7bDUxT//ybRyc6INtHWqsVxw0ZDIDQr/O44oXr8k9eP3gnNjIopkikbPBFY5bH2ADO1w09Izi+cIrfJW8G0KYSSUN5F8++YiJ5s5mzEpSZm0ryCMkdbw8ApBYtROt7TNGPwKEYBcOagzcJUfVK6P/FnG76fXkzcGKOfLqsRfum1t38py07VdoriJh3VLNDqbzrZEuErYNO0TRMLR4fb6cR3L9YqHf/0iwYKzJJeEyierbEm6M2aruYcQuHARFX2JSccP59EKOV9nZ8X+QHi9eB1wmtMOErbTrIoxRUN1FBjIAedT6Sln+1sPpCX3/7HGGtZr4nYrzN2r9utBarfJyckfJefsE9kxWkennVSN048DKlkNkbdMT3EZW1sxdcbniuqIM+JRZj+nkb2lV3WgLZNr7fvaUmiEXGvVmbT9a/cqyth7ww3iZjaf0qQgLADTIucNGGXroVVgld+OpaJ7e44nmZXM+wY8vAHbfCFPXsuxfnJSEddCxhVHKOX6P8Gl/sfbixc+a0dO4pTxpA5m/iKSR0eCDCo58cZqMjpIn6I925J1k6QsWIFd6ojEVmk9KY7Evu8IorTwbAN3SJG7cpCfft/wnWsgzHuvM1gkuSjArx/NAuUYPLeNO7Iq6G7Wdk0XQ1Ekg==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 17:04:21.9414
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f232172b-6368-4cd3-d760-08dcff4e39bc
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR19MB7586
X-OriginatorOrg: ddn.com
X-BESS-ID: 1731001117-105959-12853-12874-1
X-BESS-VER: 2019.1_20241029.2310
X-BESS-Apparent-Source-IP: 104.47.58.46
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKViZm5hZAVgZQMM00KTU50cDEzD
	TRLDk51cgyySTVOCUpzdgw2SLVLClRqTYWAISggnBBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260269 [from 
	cloudscan19-37.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_SC0_MISMATCH_TO, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

This prepares queueing and sending through io-uring.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev_uring.c   | 101 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/dev_uring_i.h |   7 ++++
 2 files changed, 108 insertions(+)

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 2f5665518d3f66bf2ae20c0274e277ee94adc491..84f5c330bac296c65ff676d454065963082fa116 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -21,6 +21,10 @@ MODULE_PARM_DESC(enable_uring,
 
 #define FUSE_URING_IOV_SEGS 2 /* header and payload */
 
+struct fuse_uring_cmd_pdu {
+	struct fuse_ring_ent *ring_ent;
+};
+
 /*
  * Finalize a fuse request, then fetch and send the next entry, if available
  */
@@ -1007,3 +1011,100 @@ int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 
 	return -EIOCBQUEUED;
 }
+
+/*
+ * This prepares and sends the ring request in fuse-uring task context.
+ * User buffers are not mapped yet - the application does not have permission
+ * to write to it - this has to be executed in ring task context.
+ * XXX: Map and pin user paged and avoid this function.
+ */
+static void
+fuse_uring_send_req_in_task(struct io_uring_cmd *cmd,
+			    unsigned int issue_flags)
+{
+	struct fuse_uring_cmd_pdu *pdu = (struct fuse_uring_cmd_pdu *)cmd->pdu;
+	struct fuse_ring_ent *ring_ent = pdu->ring_ent;
+	struct fuse_ring_queue *queue = ring_ent->queue;
+	int err;
+
+	BUILD_BUG_ON(sizeof(pdu) > sizeof(cmd->pdu));
+
+	err = fuse_uring_prepare_send(ring_ent);
+	if (err)
+		goto err;
+
+	io_uring_cmd_done(cmd, 0, 0, issue_flags);
+
+	spin_lock(&queue->lock);
+	ring_ent->state = FRRS_USERSPACE;
+	list_move(&ring_ent->list, &queue->ent_in_userspace);
+	spin_unlock(&queue->lock);
+	return;
+err:
+	fuse_uring_next_fuse_req(ring_ent, queue);
+}
+
+/* queue a fuse request and send it if a ring entry is available */
+int fuse_uring_queue_fuse_req(struct fuse_conn *fc, struct fuse_req *req)
+{
+	struct fuse_ring *ring = fc->ring;
+	struct fuse_ring_queue *queue;
+	int qid = 0;
+	struct fuse_ring_ent *ring_ent = NULL;
+	int res;
+
+	/*
+	 * async requests are best handled on another core, the current
+	 * core can do application/page handling, while the async request
+	 * is handled on another core in userspace.
+	 * For sync request the application has to wait - no processing, so
+	 * the request should continue on the current core and avoid context
+	 * switches.
+	 * XXX This should be on the same numa node and not busy - is there
+	 * a scheduler function available  that could make this decision?
+	 * It should also not persistently switch between cores - makes
+	 * it hard for the scheduler.
+	 */
+	qid = task_cpu(current);
+
+	if (WARN_ONCE(qid >= ring->nr_queues,
+		      "Core number (%u) exceeds nr ueues (%zu)\n", qid,
+		      ring->nr_queues))
+		qid = 0;
+
+	queue = ring->queues[qid];
+	if (WARN_ONCE(!queue, "Missing queue for qid %d\n", qid))
+		return -EINVAL;
+
+	spin_lock(&queue->lock);
+
+	if (unlikely(queue->stopped)) {
+		res = -ENOTCONN;
+		goto err_unlock;
+	}
+
+	list_add_tail(&req->list, &queue->fuse_req_queue);
+
+	if (!list_empty(&queue->ent_avail_queue)) {
+		ring_ent = list_first_entry(&queue->ent_avail_queue,
+					    struct fuse_ring_ent, list);
+		list_del_init(&ring_ent->list);
+		fuse_uring_add_req_to_ring_ent(ring_ent, req);
+	}
+	spin_unlock(&queue->lock);
+
+	if (ring_ent) {
+		struct io_uring_cmd *cmd = ring_ent->cmd;
+		struct fuse_uring_cmd_pdu *pdu =
+			(struct fuse_uring_cmd_pdu *)cmd->pdu;
+
+		pdu->ring_ent = ring_ent;
+		io_uring_cmd_complete_in_task(cmd, fuse_uring_send_req_in_task);
+	}
+
+	return 0;
+
+err_unlock:
+	spin_unlock(&queue->lock);
+	return res;
+}
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index c9497fc94373a6e071161c205e77279fd0ada741..c442e53cefe5fea998a04bb060861569bece0459 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -123,6 +123,7 @@ void fuse_uring_destruct(struct fuse_conn *fc);
 void fuse_uring_stop_queues(struct fuse_ring *ring);
 void fuse_uring_abort_end_requests(struct fuse_ring *ring);
 int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags);
+int fuse_uring_queue_fuse_req(struct fuse_conn *fc, struct fuse_req *req);
 
 static inline void fuse_uring_abort(struct fuse_conn *fc)
 {
@@ -165,6 +166,12 @@ static inline void fuse_uring_abort(struct fuse_conn *fc)
 static inline void fuse_uring_wait_stopped_queues(struct fuse_conn *fc)
 {
 }
+
+static inline int
+fuse_uring_queue_fuse_req(struct fuse_conn *fc, struct fuse_req *req)
+{
+	return -EPFNOSUPPORT;
+}
 #endif /* CONFIG_FUSE_IO_URING */
 
 #endif /* _FS_FUSE_DEV_URING_I_H */

-- 
2.43.0


