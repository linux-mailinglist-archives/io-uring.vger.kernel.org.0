Return-Path: <io-uring+bounces-5065-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 27A199DA8A9
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 14:41:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D97802817CE
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 13:41:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B04EB1FCF79;
	Wed, 27 Nov 2024 13:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="Fto/n9ML"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8DB61922F2;
	Wed, 27 Nov 2024 13:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732714860; cv=fail; b=D8aRQHc69RrqJVrITJ/jGTrp4YYJSQkAyLsrfNGONgw8oKvalIiCgsJCaT6QEliyqiKNezMqgFAPu/ubInOnakBZ84rmS0QMUbLKpQOvIzMF/R7dQXjPwkRMW0PD1BKqniDofFowLH0LeT6eJ8LrL5m7g+maS+tCNZ6FX/N0Nzc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732714860; c=relaxed/simple;
	bh=cjaX2yx71YmzsueEF8hwSqP/9RlAZQ9UgtqGdFh+pVQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=AyL1ZjQ1IAanOkBsilZw7tgTgnDJ3Q5qgO+gmjwbkcW8M8S/KZ8ILSzSbLT6ZunghUOvkp/zYxNv6T6WthCutGVnuyuSb6mF9bPseQfU8HpV27HYpGcFXe5V7p3BYbnHz3gY10OMGODZZghXyn3EH5czWhbwfN9rd8KHkBrHkgE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=Fto/n9ML; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174]) by mx-outbound42-179.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 27 Nov 2024 13:40:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N184GB6CI1uN9KuuwY/wp+RCgOybQsc0YVIMQx50EiupzUmWKRZG5aunLaI+VOTMgJPY93cc6gnEoUcLrYiSR2B2Jjw+L+bvb6wzfrKcwRN+YBExrmPMc1r0hLdc9O/jY9xaFm83+Ps9axprs3vJZ/ntmwrSYFzXIjWxHCWINqPDGpUTbvCI9+FU5iuJ5TjgnwJhEdkjrXxeZIaIgxqQ8FC1Qwe1izKsvVB/cUkXmBMJKXelvZcx2ukS+P8CsGGoOBBFmJe5wMSUwqhHqF1l4jAlA1cfiXbwVtLxoL6v6IRbxgNJPoINFZ1mnY2NzSZnR5585c1Q31reISI12FbJGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jso3avSOXUYm4pkaE2qlAImfboDaTrV4lluhj8yB4rw=;
 b=Rp52weXimySDKY1gzU/4frSv2zZu0mN2cDSRHar70xb1x6yNtoebZlKpv7TX76ihteuExBcKVSjODGa94aRusHhYOaWC6DCtItgq2ETCXj2ZnA4jiCxGC4McB8doMEiqHUrR0YxG8NAPvchcjHA7aDqBYlGg9PLm15QqkQHG2DLhtBG5RYYrtSCcKftJO+C+PI0Mfl5tM9mruYOyZ9YHnmVKoIjMt7Im3G7B/sDGym+ocBfdU43yPhzy+oCw8OePB3DHGU0Bxz4UVx0KuXbkgyt5oY/DNF52aDmCdDjZgsU+4sZF1QVLI2Zqq6GvcgR5kIemTSYBr2QWQSeTimH+wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jso3avSOXUYm4pkaE2qlAImfboDaTrV4lluhj8yB4rw=;
 b=Fto/n9MLnr1o81/V1nKQbWfDbRvmdWp9E5CIPty3Z7xrQSdQEclgZszilRgTQcA311ibmf6u8ND4z+cmjagbXNDNuMFnbZzEoQU9AtuDvUMpGUiEShHPOrJ1bhGEERg/SXXHwj1CD42Fk5+mFMtyrpbH5Wfd1LOCABFdGr81GFs=
Received: from DM6PR08CA0051.namprd08.prod.outlook.com (2603:10b6:5:1e0::25)
 by BY3PR19MB4883.namprd19.prod.outlook.com (2603:10b6:a03:36d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.13; Wed, 27 Nov
 2024 13:40:48 +0000
Received: from DS3PEPF000099E1.namprd04.prod.outlook.com
 (2603:10b6:5:1e0:cafe::47) by DM6PR08CA0051.outlook.office365.com
 (2603:10b6:5:1e0::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.12 via Frontend Transport; Wed,
 27 Nov 2024 13:40:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 DS3PEPF000099E1.mail.protection.outlook.com (10.167.17.196) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.12
 via Frontend Transport; Wed, 27 Nov 2024 13:40:47 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 1D1CD55;
	Wed, 27 Nov 2024 13:40:47 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Wed, 27 Nov 2024 14:40:25 +0100
Subject: [PATCH RFC v7 08/16] fuse: Add fuse-io-uring handling into
 fuse_copy
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241127-fuse-uring-for-6-10-rfc4-v7-8-934b3a69baca@ddn.com>
References: <20241127-fuse-uring-for-6-10-rfc4-v7-0-934b3a69baca@ddn.com>
In-Reply-To: <20241127-fuse-uring-for-6-10-rfc4-v7-0-934b3a69baca@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1732714838; l=1731;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=cjaX2yx71YmzsueEF8hwSqP/9RlAZQ9UgtqGdFh+pVQ=;
 b=RVitUnNpORwtqn0U0xAfaK06SA8BygOFgltSbmHtl0w+Mdpl96cu8o0wLFdvHChJpwQRHBg9P
 8AWl9k/zbOUD7SVRQfsRKiS9sPe8rISgNYKiX3GZMEpuJc6h3en23fs
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099E1:EE_|BY3PR19MB4883:EE_
X-MS-Office365-Filtering-Correlation-Id: ffb1d979-138c-4d34-8a62-08dd0ee919bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SnZEVnVMNkpXUFZtOGNWTzdUY3Y2ZFE4blkwN3pwVk1kN2xwdHdEWDVwVTU4?=
 =?utf-8?B?YjF1dnlsZ0lyTWdNd1R2Y09xbVBLakJIWTVRVDUrWklnQkcvK0c5VElFTVZL?=
 =?utf-8?B?bys0Y3pGMXhDbGVneDR2bjNJRURkK2R0em43L0twRERQOXNUVm1oWW9WNFpB?=
 =?utf-8?B?UHhTUHpxWkFLZis4MzRmUU1qN25lZll1eGR0bDZjWHFrS2huNlBpQ0dJUzIv?=
 =?utf-8?B?b2NITHpTMWRmRzZtVXlpL0J5VXRWRDIzZHBPdHRwNXRpQjZrSVBCd1pNWlp0?=
 =?utf-8?B?b2pqdW1rTkJWc2NReHZPelZ1dU94NzVnUGtHWkJWRFFNckRtdUE5YzczNlRU?=
 =?utf-8?B?LzBCeFdFWHFycCsrU3h0TFhyRERoaW5OUGRvc1NpMEt4dXkxTFk3RWdLRUtr?=
 =?utf-8?B?azN2WGhKMVZ3K1E1cXZMRkh6Zk1lYnpiWE5rSmFncXZMQnhWcW9LSzNzTTRq?=
 =?utf-8?B?bjNJeGRzSmxpOHlNbWNMd0piemIvNi83VWtKdzNscnExczZad1F6Z2VMNTJj?=
 =?utf-8?B?aTN1Y0VjcHV1OVpadG82bTFyRFg5bUlMbDZHQzVMc1ZwNzJDM3l4OE9vcm41?=
 =?utf-8?B?OHR1ZXA4SVdaRGoxc0RSYU9QZ1ZyZjIvUzVNcnRhUFhjM3ByelpXYTNwQ0JV?=
 =?utf-8?B?NUY4ZWtCV2pvSmFLQ3dpSzBVeWQ5anNrd0hIK1BjTjFLcVQ4czI2UTJwc2pB?=
 =?utf-8?B?SzZockh1TkRyYTJKdFVVWUsrNy9Nc3FlWDk0RU9hWXZ6dnhnRWZQejJ3QXU4?=
 =?utf-8?B?QVBTcm1DMW1BQThBYkhhTWpGcXpuQXp3VjZ5Zk5wYklmMTdvQVZXb2dndGV4?=
 =?utf-8?B?RkhnWjM4dkE5YUtjRURBT0tERlAwVUtWT1djNjJFU2FNYzF4dzdQRWJGbWVF?=
 =?utf-8?B?bWJ5dUVzRFR5K1VJNm5JTHo2a2xYYWk0NGx2SlNSOTNaMExndFhFaXZVTU1L?=
 =?utf-8?B?eVQxTDJvMXYvbExaeDJ4NFhtdjhsenFRZmREMnlxRjNpVUxYbUU0Yk0vZmV4?=
 =?utf-8?B?U2VIVTYvU1MwenVybGhvQmJhRTZ4bHdSR2JPc3R3UWZzbzFpWk96b0pJRnB0?=
 =?utf-8?B?UW1kZ2l3c0JrMllPNkY4ZEg1VWQrSWsyRHVieEhBcEl6cE8yU3F6TnNjb2Z0?=
 =?utf-8?B?WTBwd0dDcWRnRG8xYXNnVWJFNlJSem9zT25LblhxT3RPcFJ4eWJzZVgvOFA4?=
 =?utf-8?B?bEFKem13S2Z3eFdnWUpCN2ZrOFYwSHVaN2ViajlEbGJ2V3cxQ2szb0hxTUxU?=
 =?utf-8?B?R2NrS1JTaGtoVm5LamM0Zk82Z2tuQVdRN1J6TUJWdUFTTGRKeWFSS2dVRmk5?=
 =?utf-8?B?bHh6NmF3Mk5Nb2JDbHc3Rlk3ZXBLdHllY1prSU1nUGRFaGJFbE81bGJVSjEw?=
 =?utf-8?B?VjF2SzRHMkRZQWZYcG94Ylg0amExczA2YUN0cW43SCt4VCtPUUVmRkNtbFNn?=
 =?utf-8?B?b2wzQkl2Vy9OWVNUcVBzK1JJdDZteGplN1VkdDRxeVcrcUhxeXBxVm1UTFpX?=
 =?utf-8?B?RkM5UUkvNUJCcjIxeVdWK3NEYzJIVFBmWFZmMmxGNDRnUzZOZHlIUG5MVlRh?=
 =?utf-8?B?WG9EeUF1cjZjdys5R3ltVVhHTktWaHIwY1A3aU5VWG5vbjFwbldqc3RZSGNO?=
 =?utf-8?B?NHB5Rm9Pamh1WkdxZ3Y1dzcycGNRbEtrdnVOUTJiMkw2YjYrNDMvb0QxMHFz?=
 =?utf-8?B?VFF1Y2xUdmdJaXFVN1JqNy9vR1hWRVFCNnd1Z01la0hERDdlM3A2QXdxMVlv?=
 =?utf-8?B?Y3ZXWiswd29sTUt2K05kaE5pRTViMk5SYjlFVnQ3cEpLdkl6Ulh6dGdiV0VY?=
 =?utf-8?B?MmNnazRLVlEzTWs4ek1sSURsRDFEelMxQW1mS2ZRTGZBazc5alRVN1VoN0Zr?=
 =?utf-8?B?T1J6UlF2bzdUWmlWbHYrRWNPcnBWUVN0VnhRUklNT0x2OHNkQzRySkVIYXJz?=
 =?utf-8?Q?FvfmlD64wcJ8vVCnWtv6/QdCH3aUuyYK?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(376014)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8PjmUQ9s8xxq3d/PF3vqO9k8UAnV1uzRqdnrzNBUl4QaQqjQRl/j+O5BHeX/jz/upk+3xtxEzXNjpPU/DybcWc/xkC6ju7CmuylsaDG612WET1ap8i0BysK3HTwt/40AhtxZQQ0B4QkB8xzhoHhA2SBFtnMba1NgLGCbGVbMJIu219hVAjsEXC2NBeBy88HWx8D8INn9heHfO74gYcIaZZ5PDZsXg1fJDfvwsb/9KLz/FimqwFOdP9c44GuAmORr8/TLJnUUjRrjJRsn2PnUP44/oNoGur1ZrM6rFlvu2skDqQFblTltomSDc1VQlUa+BUWg1XuvgmSfgHAc+dCBYnJb7wllGbkMsOHGDar8sS4rNxKXaj/I9LH2lTI8b0TqZGIgs3ga8UxBrYUe3JSeXtVXf8eYRNZay0dvZf+raZ0sleoOTAM+B8KYl1Jhk08+rjR4evQRqF8JsjG8m7Mw9+W08j3VpGAa8I/joDiYX0Uzd2NqWmq51GSOsRyQvvGw8iLYG2Ivm6kxg7Cuin7RQJETT/ZIpGU+M1TDR9tmEQRWnKyQ286Mz10EfaSHXZbSR1LZJmvBjQoZpr5RWLlYwzXIPbe25ieuMs6MX9X39y9T/HjJfCLuvuWVDOVEeABpzlstCR441kp2JIHEg+Z6zw==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2024 13:40:47.7380
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ffb1d979-138c-4d34-8a62-08dd0ee919bf
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099E1.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR19MB4883
X-BESS-ID: 1732714851-110931-13381-12308-1
X-BESS-VER: 2019.1_20241126.2220
X-BESS-Apparent-Source-IP: 104.47.55.174
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoZm5iZAVgZQ0Mg00dgk0cw8NS
	052cwiKQXIsDBITE5LNk5OMbQwN1aqjQUAHN3bbEEAAAA=
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260718 [from 
	cloudscan13-101.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

Add special fuse-io-uring into the fuse argument
copy handler.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev.c        | 12 +++++++++++-
 fs/fuse/fuse_dev_i.h |  5 +++++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 94314bb61ea16b1ea4a42a1a4b36fbf5cbf7ef70..51d9c14a8ede9348661921f5d5a6d837c76f91ee 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -787,6 +787,9 @@ static int fuse_copy_do(struct fuse_copy_state *cs, void **val, unsigned *size)
 	*size -= ncpy;
 	cs->len -= ncpy;
 	cs->offset += ncpy;
+	if (cs->is_uring)
+		cs->ring.offset += ncpy;
+
 	return ncpy;
 }
 
@@ -1911,7 +1914,14 @@ static struct fuse_req *request_find(struct fuse_pqueue *fpq, u64 unique)
 int fuse_copy_out_args(struct fuse_copy_state *cs, struct fuse_args *args,
 		       unsigned nbytes)
 {
-	unsigned reqsize = sizeof(struct fuse_out_header);
+
+	unsigned int reqsize = 0;
+
+	/*
+	 * Uring has all headers separated from args - args is payload only
+	 */
+	if (!cs->is_uring)
+		reqsize = sizeof(struct fuse_out_header);
 
 	reqsize += fuse_len_args(args->out_numargs, args->out_args);
 
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index 21eb1bdb492d04f0a406d25bb8d300b34244dce2..0708730b656b97071de9a5331ef4d51a112c602c 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -27,6 +27,11 @@ struct fuse_copy_state {
 	unsigned int len;
 	unsigned int offset;
 	unsigned int move_pages:1;
+	unsigned int is_uring:1;
+	struct {
+		/* overall offset with the user buffer */
+		unsigned int offset;
+	} ring;
 };
 
 static inline struct fuse_dev *fuse_get_dev(struct file *file)

-- 
2.43.0


