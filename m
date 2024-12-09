Return-Path: <io-uring+bounces-5331-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AFA6B9E99BA
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 15:59:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A1BC284267
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 14:59:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70908222D6F;
	Mon,  9 Dec 2024 14:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="vtvVJORL"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C7D1F0E57;
	Mon,  9 Dec 2024 14:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733756230; cv=fail; b=PcXGqM8VQ8kkqVFE46zlbD+1j8zdszyb85pEpg/wcVS6vywO6R6GuSwjlAzUJOqsPAJtMJ7C5k3RFKR74A05YvjrIDhiwP/v1VKiZoj97/v3c2IiD6CmqQFCSv6nA8bylOzaJ+lI5dOHKkydqGC9RRqEsmf71K5F5+lBlUEcGQs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733756230; c=relaxed/simple;
	bh=rY2K7hsReI4pxpACbowihLqcyGYPxjsrm3vYExzWdPY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=UvXfADlHfwnHv2Ms7L0lbFF1my/iZpb1XbxbmTAWTeMvZE+IC8oq/NXXH66H8MCVZQvBJXdemN5EacgIg3YGB6VdmNqBSf8YAmilKZSXamER0jkGZPgH0wjkEfRYXYNw1LzFqP3cNs5tES1i65kU6IVBxPH7izS8bctNGq8yLbg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=vtvVJORL; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170]) by mx-outbound21-115.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 09 Dec 2024 14:57:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SgWIvT90Z0E8TY5yKw12DRx+HvToT34fqjW16UiHC36OsaJcKCs/cd4JTb18sN7kS6TTsn6NOw+oWYlePZv5XyeaOMPSjz5CKbCzhedqgipPsncVqRGxinFsbouzhyyq+v8JRUV822pEJ/uvY0LBMbt9fpa6C/2rRpFYJ9filpPSFDjZMYG+JeF38kcx7SaclyFXg9aVVPJIKATeyODSCuzX0m8/8zYyEHPsqbYCPbEPrM+Lr7VG3p5VtMa3rC75rac3iMMTjmQVJar39dpjZgBbD8mo0uyG506DiKV/W+5fV+7bWQ0jbFnVm80S3mW9B1hHahWyYmtRvYBrl++a3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HiqP9HlaxSiwtbtB7vX3vdAB0f3mcgYAOh3ghlZs1qU=;
 b=Vm1gCfsvG7x36/wVNHXL6uHmJRuFPijBgYz+a7nx2W8z826g7J2c1/hkFrA0HIHov7zhF2vO6Lw4cWOPiLZ3D+m/vOV15TxKR0ZxlZlCKS6z8BQFP8j6EeR4w3KJXb0ifRHD7MJCqw177o0PELF4oPdjJHT+8BvCqHLiAatQa+ykXEh84Ij/43thO55H+xsCIKWkij4zL4pkGeW4s5IX3ifY9vogCyVVVRTD7C3o/L4ry49J1bpBJ4uarpuEnPjCnJ+oyo2N3B6YL0IdNz4pH6dzgC0ofkgHWHZS1qL8p8rmrbu6yRNxmvySSHK0DPkY0PtiEJBsrde4V7YWNVSksg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HiqP9HlaxSiwtbtB7vX3vdAB0f3mcgYAOh3ghlZs1qU=;
 b=vtvVJORL0PC0SGeQ7O4JKMRORg6+HVeDaDzhFDbFHQgQRHFjqYUHBoDZo97hTsyp5zYgFRW4G+uElv1BZAwZGljsrCnJRItndEaJuBmwD75c4+bvLCgMm9JFHYfnV4BwucH2QYt/zcvvU1HWAYuk0F7/c2wKmHt1t5X1z0mNnY4=
Received: from CH0PR13CA0002.namprd13.prod.outlook.com (2603:10b6:610:b1::7)
 by CH2PR19MB3862.namprd19.prod.outlook.com (2603:10b6:610:91::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.18; Mon, 9 Dec
 2024 14:56:56 +0000
Received: from CH2PEPF00000142.namprd02.prod.outlook.com
 (2603:10b6:610:b1:cafe::54) by CH0PR13CA0002.outlook.office365.com
 (2603:10b6:610:b1::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8251.11 via Frontend Transport; Mon,
 9 Dec 2024 14:56:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 CH2PEPF00000142.mail.protection.outlook.com (10.167.244.75) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.7
 via Frontend Transport; Mon, 9 Dec 2024 14:56:56 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 654304A;
	Mon,  9 Dec 2024 14:56:55 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Mon, 09 Dec 2024 15:56:38 +0100
Subject: [PATCH v8 16/16] fuse: enable fuse-over-io-uring
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241209-fuse-uring-for-6-10-rfc4-v8-16-d9f9f2642be3@ddn.com>
References: <20241209-fuse-uring-for-6-10-rfc4-v8-0-d9f9f2642be3@ddn.com>
In-Reply-To: <20241209-fuse-uring-for-6-10-rfc4-v8-0-d9f9f2642be3@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1733756199; l=1367;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=rY2K7hsReI4pxpACbowihLqcyGYPxjsrm3vYExzWdPY=;
 b=OpS9qp9dTpSHCz/lTlfeHgurW9A6/eb69ZT/1aFTU5f3U1dsqRdnJrzXRzw7garMfAILNy15Z
 iRk+zfO0tzaB9oO9KtEOelzOX91aLF/GVBR5IgQAshkNqfEh1vJelav
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000142:EE_|CH2PR19MB3862:EE_
X-MS-Office365-Filtering-Correlation-Id: ba8e1bdb-245c-459e-c7f1-08dd1861b9bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?clJ4bm4rcytGN1cxdWtBZVJPS3FFQnRtSG5LZDRxZzI5TmRBT25sWE5DV2ox?=
 =?utf-8?B?eDRCQ1VCbWxTbnFoMVR5Mkpad28vT3ZjL0F0MGpPTjF1blkwU1RJNXVJaVBZ?=
 =?utf-8?B?Y2p4NmswZkI2eFJLTm8xK2IrZ1Y0RDBvQVBhaGR0MUdieE45VGp0STU4bnh6?=
 =?utf-8?B?cWlJd1lWQktqby85RUh2ODVKbnhJYmZGRlpiNjVpZFprOWt5Y3E5N3hBL0k2?=
 =?utf-8?B?UStHbndiQVZrMHpadktSRGphNG1CNHFDVmllTk1Da0kraUwxelU4Mys3ZitC?=
 =?utf-8?B?MkhtMDRtTjlPOTEwSHk3Z1p6dE12N0Nvak13UHdwRHlrRGwwbEhmUHJrS1l4?=
 =?utf-8?B?TFVHdVZvam41ME01ZUE5OVYrWGZTQy9yTjZEbkRrRXUxeU9ubkY1cEJhWm1D?=
 =?utf-8?B?ampaV2ZzQ09oTTA1WmNFZldMMTF1QUt3bnR2OGc4elhuY2VYWEYyYlZmVXVn?=
 =?utf-8?B?WGZWSUJ3ZVNjb1J4TWRrV3ZTaXgyMmhScW0zY2ZIUlhPUEpFcjJpY2p5ZFpB?=
 =?utf-8?B?cnlxZWl0eVl6cjdGMzZOcnVGMFZRcERUSnFmWHRSaFpBL2hXK2lnNjNrZnVs?=
 =?utf-8?B?dDJOSU5sUkJNQXVHUHA5aGVHU3JVWWdrdENoS3lUZVZkcGVJNnd1eVk2V1FT?=
 =?utf-8?B?R0RVZXJRVUpiYzYydlowdjFnbTZsZFJyL3ZEaER2TG1mbmdoZEMraWJLc0kv?=
 =?utf-8?B?K25wY202WDh3TUNkM2dwUVpNWUJwUzlvcEhCL0UzYUkzSVdFMDJFOFpHZHlx?=
 =?utf-8?B?QkJDMXhvVko0L2FZZU9jdW1GeWhxSWYrWkh4TVFwN0VGVGRpR0k2ZHhXb3Ja?=
 =?utf-8?B?cHdKNWFaUExSVkJ1Nm5VVjl6aUNmY2RjTXIxU0g0aXVvcUM2MUwrcFUrUjVE?=
 =?utf-8?B?YjdtSkhyU0NlSHBNTGF2Y2p6dHZIZUh6eGhLVGR6dlhpZGVUNmt0OW5DdFRp?=
 =?utf-8?B?Tm1SUnhKbkdINVZJaUl0UG40MTQ2SWpHU2l0ZlhCR1htTHh5YXVwYmRpNFVD?=
 =?utf-8?B?alJUT0ZUZkhNQjdNelF0bGRpc1ZFMkp3NDEveWU2Mzl1aytucDhKY0FlbXdv?=
 =?utf-8?B?T0ZTU0pyUXJwcVJUQVFPVlJjNFhHajNaVzhNazVzejRUZk5XMTNSVWFNaS95?=
 =?utf-8?B?Uzh4T0RmSGhrQVVtVE90ZVhiYjFITHBJUVRmU3lHL1BLNDJGOW9lZXZ0SkE2?=
 =?utf-8?B?cmhuMTJDY3RGQnZYeDFxRkNsd3ZoaWRNSXBRVUViK011c01NL0Y3Vk9QdUxS?=
 =?utf-8?B?RGxuUGhvdlJ2K2FWZHdRdEpQMnlVdVBjcys1d0k5MzVJVFRWM0RYYkRSK1JW?=
 =?utf-8?B?b0k1T3hLUGRiQVNQNjJQZlRRd283M0JsaHZpL3QvVGU5RVVTSmwwM2xxd0VO?=
 =?utf-8?B?cCtNMWx1eHhNeEhveHFvSVdaVkpycnl6cXVQSVhIOUhWWWdVVXd3b1k5NDNs?=
 =?utf-8?B?Vk1NdzhwYlVDZURMQ2Y2RGRLeS9Uc3Z6b0tzWGVOWHpWK0RLM0tMUXF6UE5U?=
 =?utf-8?B?c1lKOEswTXpmQmxrNmdqQ0RFTEZyV2o1YkxzL01mZzYxVWN6SUs4M3ovdnNK?=
 =?utf-8?B?c2Y2Ny9KSjB1Yjl3WTBqL2NNMENwMXc0aWZTZDJsazVpM3duVGFRQUNwYSsz?=
 =?utf-8?B?b3F1NVlTWk9oQkRnUHR5Mk1oQTM0QWNpUHVGTmwyZXNDS3VibkcvWFFZQTNX?=
 =?utf-8?B?eFpONEhwK3FZTThzeEU3UkV4cC9NTk9ydVNYMklJN29jbnhaM0ovSFJUbmR3?=
 =?utf-8?B?dHdydGdicytKcFBHY2MzM2tMNVE3ZkhiSFFVRklKTWdxRzRIQkswRGphY1ZJ?=
 =?utf-8?B?elFyY2ZGalNrSDI4V0JNL1lVbzFYenUwMTFXWmxUdHo5RVdFV3hGUitlZzJJ?=
 =?utf-8?B?S3pBN3BUMFFxcUVRWVNpeDNNaVRneUlBbTU2Z3M5S3JwOWhlc0EwZGZTeko2?=
 =?utf-8?Q?EgqeznHeBN6jOORC4fxx0RXCbKb7iIYX?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(7416014)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yGT/jvnq49P3e9MTy8aE3+y5O8AuUBav6dgLu6jrL7WcsvNHnGTDO6hk7uGcn5aMStg2OdekutMMtiTVLhS64O83YzZu7xeT1VX511c23ytbl4I1TfE+c8kN7DPGOqPe2sB4gmOZQB6rpW9o4T4I08MxgF0kV9WMKb6nJ9xAHcUUauostHt0+YFoeWo1Lg/7/VyCG3rYL0tn4r5e/MrqHYro2MhmKuPborNXiEY0FS/NOPRsfmnJddDr1Sx2YFUTOQI6NYdSbaHnntMpMPP45TpetV+9rRpma6WA37rCycMCjrd1phTvZDZK6H8Ng66RHKdWQK6IreWYM5h7jK41VajrI8rsAwjO9+s87b8waBn9avc7YnVw6Qq7J9JT9Rk1J5vDqSsu3EtJcMpufynYkDq9S5AlEwKwGQXv2ghvmFaztgRrsPMxiK3/lh/UoqI7F5f02sxKu3rfmnmQdrJLzlY4NuexvMcXtUIKPj1918mAJORr3sglbWPkUr7u063tsCMMiYLq7npzJLBB1ckV7p8mnOLr6pN9ZoT5D7TbxQ/BR/HjEp/IUEmcVqeiz/ceozlx6TaickNgBYwUuxlKBAe6UeJWslQgmVHt3R/xzZv0ZkdVqHQ1FOpm1usB0VeBj/haZDeE1E5hHax8LFVyUg==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2024 14:56:56.2320
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ba8e1bdb-245c-459e-c7f1-08dd1861b9bf
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000142.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR19MB3862
X-BESS-ID: 1733756220-105491-13364-2463-1
X-BESS-VER: 2019.1_20241126.2220
X-BESS-Apparent-Source-IP: 104.47.57.170
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVobGRhZAVgZQ0CQ5KcXQwNAk0S
	wpKdUgxdDU1NjYzCQp0SDZyDApOclUqTYWALAzpMdBAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260997 [from 
	cloudscan14-25.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE_7582B         META: Custom Rule 7582B 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE_7582B, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

All required parts are handled now, fuse-io-uring can
be enabled.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev.c       | 3 +++
 fs/fuse/dev_uring.c | 3 +--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 8f8aaf74ee8dfbe8837f48811138d4ff99b44bba..e2b1d7d6ff67c77e029383419783c46cbdb53e78 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -2492,6 +2492,9 @@ const struct file_operations fuse_dev_operations = {
 	.fasync		= fuse_dev_fasync,
 	.unlocked_ioctl = fuse_dev_ioctl,
 	.compat_ioctl   = compat_ptr_ioctl,
+#ifdef CONFIG_FUSE_IO_URING
+	.uring_cmd	= fuse_uring_cmd,
+#endif
 };
 EXPORT_SYMBOL_GPL(fuse_dev_operations);
 
diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index be7eaf7cc569ff77f8ebdff323634b84ea0a3f63..183917edfc1afe41e806528f762951a0233dd66f 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -1083,8 +1083,7 @@ static int fuse_uring_register(struct io_uring_cmd *cmd,
  * Entry function from io_uring to handle the given passthrough command
  * (op cocde IORING_OP_URING_CMD)
  */
-int __maybe_unused fuse_uring_cmd(struct io_uring_cmd *cmd,
-				  unsigned int issue_flags)
+int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
 	struct fuse_dev *fud;
 	struct fuse_conn *fc;

-- 
2.43.0


