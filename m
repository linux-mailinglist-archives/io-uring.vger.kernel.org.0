Return-Path: <io-uring+bounces-2999-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FBD29676B2
	for <lists+io-uring@lfdr.de>; Sun,  1 Sep 2024 15:38:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EDB841F21934
	for <lists+io-uring@lfdr.de>; Sun,  1 Sep 2024 13:38:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DDAF183CBB;
	Sun,  1 Sep 2024 13:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="2BfYJ+f8"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA86417F389;
	Sun,  1 Sep 2024 13:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725197843; cv=fail; b=snRpOJFcJl7xW1yCDDIBvBPN+sKZLuXpjCKfqbut/g7T3D7WN+Ro3qKYCjizJ/o4F8baiogPLRcR5WhJOMfA7YM94Az+NyjIbW4eOR3XCN52ubQbyNA2iWTY6yhlfBWe4cedGcuzPp3J8Dgxj3aIMpyeaO/jWg3P7XnfW2Xjuts=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725197843; c=relaxed/simple;
	bh=R/YQ5fAgxZSRo5nZQW3oRq/ADQN8D5FW6Yx0yb+KkWI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=cbJUsqTRk5mZfY67G4xii2IUZ1Hj4wFcB5jLzjvcXW7zn8uFSXYo0qH4shVvGYN8wJ6TjSMrB+t6sQV7s56t967mWzFZIbzCyPheQP/pcsRJGv2WCALH9K6Xb9iAP9laqUoL+WJD8oRDKDNxrAfyk1O0VsY4exYKzttDhyHr2sc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=2BfYJ+f8; arc=fail smtp.client-ip=209.222.82.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169]) by mx-outbound-ea22-15.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Sun, 01 Sep 2024 13:37:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VuCSfyaBoimPBiiFjaGtVuwdjvYgPkwGbV5RbWHy0GwBxP2wHAFcl4sVvMKkfSe+/UMyAISwVu2gsO19c03YMc4Z4CpekQtlNBGNwnKWSv420o9gfAbv9J3RGzSun+sMD+O7modda3x/UECmpE5AiiCDumOeDIVOYkT1ysCI+7CDLWnreJf8RgFoRgje7E54drmJQ+596svsdg/tYy1kGVk7oD0te72JxElm5kDsLOBTj9jU8NUOC2NQYNk3QY4NlYoT0Brjg4szrHFZucTFHog6a5aQjs872jG6tI7ZumpQLOkSzltYdMnsiNpk6jm4fSAS+ubPQr/o0k+utDLHkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0+rPJ9zlblzQhoHd87Myu37u7q09ruu0yH0U4YsKFZ4=;
 b=WD97bjs2DyutZ8mRjLCG8dEboKjPOKz/gViFJ0nOYcpA+/baP1Stf/R9cmfzBVLmRJLkdUO6HBxFkJcb3q5WJZbMs2bBPRqmI9KqmJcbGSv1kZ6bqvZQwlXm/fsxzw44QKQbReyulUjKAHec8gRhqxfZUa9Hs+pjcfk23muQDonnya1NwoVkSXBVEW05tbBpJrrf86AcL0hZcpH3XUciIE+hWQqMrqIkItJKit35VER8ZntszJrZA3bKWRKoMH5xskS45i+sejosdaJZxLJvKT3zzHw3R6Kzl4mvyy3TlOAjFW4QjL+/nUz5qyDvIr9rV0F6PX2HejSSoXw+/qdHYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=ddn.com smtp.mailfrom=ddn.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=ddn.com; dkim=none
 (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0+rPJ9zlblzQhoHd87Myu37u7q09ruu0yH0U4YsKFZ4=;
 b=2BfYJ+f8ufp1bEqT97brKBzkcgUBvBTuIJz2jMyznGpb4WeLu4llBrh2CEX9a0Jp/PLf/fl2n+otBbMfQW7yJzERQmQKMZKWAaDxKDVmRjn57pgdZPT+tcB82xXqwtoKnNmPg9SeZbiwG1X6nChXJ0L4dEZNU2pKoj1y5mQOk3E=
Received: from SJ0PR03CA0003.namprd03.prod.outlook.com (2603:10b6:a03:33a::8)
 by PH7PR19MB7147.namprd19.prod.outlook.com (2603:10b6:510:20e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.23; Sun, 1 Sep
 2024 13:37:06 +0000
Received: from CO1PEPF000075F0.namprd03.prod.outlook.com
 (2603:10b6:a03:33a:cafe::84) by SJ0PR03CA0003.outlook.office365.com
 (2603:10b6:a03:33a::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.23 via Frontend
 Transport; Sun, 1 Sep 2024 13:37:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 CO1PEPF000075F0.mail.protection.outlook.com (10.167.249.39) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.7918.13
 via Frontend Transport; Sun, 1 Sep 2024 13:37:06 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 7056BD3;
	Sun,  1 Sep 2024 13:37:05 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Sun, 01 Sep 2024 15:37:02 +0200
Subject: [PATCH RFC v3 08/17] fuse: {uring} Handle SQEs - register commands
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-8-9207f7391444@ddn.com>
References: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com>
In-Reply-To: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>, 
 Pavel Begunkov <asml.silence@gmail.com>, bernd@fastmail.fm
Cc: linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.14.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1725197817; l=12052;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=R/YQ5fAgxZSRo5nZQW3oRq/ADQN8D5FW6Yx0yb+KkWI=;
 b=8cnCkFt8LnAIiCeW0skvyCus40DnIYARC02x1jKidVeFs4Y3Bz4N8xkltx4ZHCRHvjUyMnHrl
 eaDGkJGnZSMD3iB/MP5grIwvaC8bges9zO104Q71dtPSHDeZNzqQLZs
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F0:EE_|PH7PR19MB7147:EE_
X-MS-Office365-Filtering-Correlation-Id: acae371d-0755-4cf9-3180-08dcca8b2bb8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RGx4bGhHek41aE4yVERBZk5qdUwyK01wYUt2S2ZUT3puTmlhb1JMUHU5aXdr?=
 =?utf-8?B?WlZqYngySkpTN3YvamZKbmI1MWhRQkNZbGw2SHRIaTYrRlRrRWtpWXluM2V4?=
 =?utf-8?B?eDF4M2NQUmxDMWJoK1RSRlJaZ1N6RTE3djhKdXY1aWlXQjNEY05IL3hDM21z?=
 =?utf-8?B?QisvTmltL1RMaGJhbzJvZXY0MXZaS09lb2YzRXIyOUpBZ0ZZczczWjIrazl0?=
 =?utf-8?B?aVFJaW9VZ0lGZ3ljOUtEM2lHWGR0NG1YRTg0elpMWDhhK2p6L0V4VCtHU04v?=
 =?utf-8?B?SHMrVzlPYnFrMmFsZU9CNkxtcUhsb1NmZVFXSHB2M0Vna3JYdjBWUCtXZHNZ?=
 =?utf-8?B?K3hvWUJnTVJtYzRBaElYdjV5WFFqYlM0UndyUktuL3lyWlRFR0cvTzRLYzJC?=
 =?utf-8?B?NHhMeTJPdkNGV2FHZ2xLWEIzUzRZZlVXNFI2QXFHUDJaWVBvSmxmZmVDdmw1?=
 =?utf-8?B?SWRrREcyWUtxYURkNFpmVkNEUkVBWk03Sy9PZWJQU2MrSzg5RWs4MkMrN0xo?=
 =?utf-8?B?SXJ5TERqU1FoTHI1TXFYVndxUk9yQ3poRXp3QWQ4WmxRWFZ5UnRFOHhzcHVU?=
 =?utf-8?B?TFZ6OUh6VG5yRDhzZDcrbW9IMk8zakVTVVV1TzRTZ001R3lIVUJub3lCaTkv?=
 =?utf-8?B?SDE5c0pSMWgrVFcrS2U5WjlzbGdlYlUzd1A0RlYxTEN1eUx1VlRPWGF1ejZC?=
 =?utf-8?B?RG13TmhnUnhSZ25nZU1oakk0bUZVUWQxZWRHL1pHSzFwWnNoVVdPUWgvOG9F?=
 =?utf-8?B?WjZSd1hVa0IxTWkwMzFLVWpUNW9aNFVtYWk2ejRqYWlPU29Pd002dlkzeUJa?=
 =?utf-8?B?ZHFCTlA4RnZkZDJiTkk0MU81cjZUeGd5U0JrMUN6ZjdlaWhnYUZuU0drUENL?=
 =?utf-8?B?VHo3TUFnamNrRmg1OTNZdjlSSnhmVy9DOWlUUWNvQnQ1LytOYWppRjIzL1Qr?=
 =?utf-8?B?T2RLQWE2T1F2dStyWmttUTl6L1AzQmhCUHVlKzZwZVdWZC9VTDhMQ0tnaGhj?=
 =?utf-8?B?eUx0eHpQYmlCcTg4dWc4MWFaNnZrcTRKTGJHcGxwYTFkVy9mSzN0RlQzMjVJ?=
 =?utf-8?B?djR3dnlZbnd4ZHJuZlpTMEI5dzZ1M21ld0RZUVc4bDhydHROZDA0STNSSEhD?=
 =?utf-8?B?VkFpR0ZaT04wdDFJS09McEZQTXhaU2ZvRnNDT2lHVkZRZWczSWgyMzVSTzdQ?=
 =?utf-8?B?dVZWQ0tmOUMwSVQ3cWZTb0l5YTdKSW5uUXBobjRkTkdTemlLYWJuQ0loaFNj?=
 =?utf-8?B?WTE5VEVQVU9lK0RuL2NaZjJ1d3c0bVRscWdidzhKYlAvaWthVHN4dzFaTzcx?=
 =?utf-8?B?TlBLYkZTaHhob29BbFVoU2RVOTB1WVJEUmw1WGI4Y2xKQzdRT2ErSlNFeUZT?=
 =?utf-8?B?cUExTWEzblhSaXAwNmxlakhER1o0Tk1XZ3ZLWnYyODAvQ2JqQWUvdTlXME9x?=
 =?utf-8?B?elBYSVZmZ1IzcE0wcTdsaHNkVVpkS3ZQakExOEJZSFY5VzBpUVVZOXFGY2g1?=
 =?utf-8?B?RzdlNUppSTM0bEhFRjBvMm1VYWUyNGtuZzVVVHF3OUNJS29OUWxiS0E5cjF1?=
 =?utf-8?B?NmVLTDlKS1FVeVRFeVQvejcrbExueHozc0JtUXBDaWljby9Ld0owRnFoNmI4?=
 =?utf-8?B?WHBncDRNT2pWa2V1eWlscFA4MWZJdWpheWQwcWhzQXFFOG5WaFZIekE1bWRV?=
 =?utf-8?B?U0F4Z2lWbmRuZkJHczVkazc1ZnhlZUVMQ0h3NDBiRlFTVEkzREdEbytidXR3?=
 =?utf-8?B?Q0ZoRmhmWUo4bWtVaWk0Q1BIOTJWbzZ5YjhCdFVidGNjdmVWd244UW5Jc0o0?=
 =?utf-8?B?cXliR2oxbm9vaXVINjZYZU1HMkFWTE5vdjN0MjVyTmtFVjh0SW1FQ0pJb0VO?=
 =?utf-8?B?WWk1UGNoMFVxc1BYcDBhc2dOUzFMZTVUczNvM0w3K1lCa1hGNURXSlNFbFVz?=
 =?utf-8?Q?Ty+WgF5Xbxfp7pzNKFCzBEO38hWhifE9?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	etnCK1aZauHTt5SqgJ7rgZ+Fi3dUovdQVHLXp6KBSqmBt5INR1FUjE+3x20iA1/T0+ZOjVXRJSblcT44xtm/nhEtUVUwufNvAaqflTVDf1MVxaU9CgSvoSNE0GzMLjjdkJ80e22Sj6A78lY3bW2QMEi91r3v68A1hyVWfC8ViwXJHovZccD3Yh/9Da79X/6uEy0uSuBhvBO70rKWkAZgNIsXGScfTeCSF8kfGhby10R3XB12hjN51QC/GHs47Moc75uTyg3OGMoBfNFv5/M5LKSNdffHEz9qP8Rq9Ai7ya1bkv0lUhpLpaTeGyrvHAVXO7YfWU8lHfSCB0/JIeodP5u3m6+q0pSLs9FFq+n78Yzl8rrUpSXKZWUnWCuuNaoY2/UIBTm2NZEgXWRjZjv6ntmnH9fWJaANvlRa5/TVJ7p98FkjLLW16wBR2GyexPg4rJ33gIRPN/jPqQ8RUtXsp2lcd5kuaA2RdX8RsnTadXb4MEXXk++JiKaSYXDt2hXhkg6iokBsrm8VfR/j1K1t9d+agUYKHcOfxiEICy7t/kKyak9VPEEyC314kNJgcKdV4LhtqNWmnMpp1ZKEQI+8sxm5EEXvulPadaigIGa2/ptfkQHHG6wT+4v4oO/vX9Jh5lXH1ww8jAiBPQgHWf5QYQ==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2024 13:37:06.1586
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: acae371d-0755-4cf9-3180-08dcca8b2bb8
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F0.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR19MB7147
X-BESS-ID: 1725197829-105647-4468-37174-1
X-BESS-VER: 2019.3_20240829.2013
X-BESS-Apparent-Source-IP: 104.47.57.169
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoaGZgYGQGYGUNQ4LdXcNNXY1D
	DV3DLN2DDFDEiaGliaAVkpSamWhkq1sQCH/KiwQgAAAA==
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.258743 [from 
	cloudscan16-251.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

This adds basic support for ring SQEs (with opcode=IORING_OP_URING_CMD).
For now only FUSE_URING_REQ_FETCH is handled to register queue entries.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev.c             |   3 +
 fs/fuse/dev_uring.c       | 231 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/dev_uring_i.h     |  60 ++++++++++++
 include/uapi/linux/fuse.h |  38 ++++++++
 4 files changed, 332 insertions(+)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index fec995818a9e..998027825481 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -2477,6 +2477,9 @@ const struct file_operations fuse_dev_operations = {
 	.fasync		= fuse_dev_fasync,
 	.unlocked_ioctl = fuse_dev_ioctl,
 	.compat_ioctl   = compat_ptr_ioctl,
+#ifdef CONFIG_FUSE_IO_URING
+	.uring_cmd	= fuse_uring_cmd,
+#endif
 };
 EXPORT_SYMBOL_GPL(fuse_dev_operations);
 
diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 4dcb4972242e..46c2274193bf 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -29,6 +29,30 @@
 #include <linux/topology.h>
 #include <linux/io_uring/cmd.h>
 
+static int fuse_ring_ring_ent_unset_userspace(struct fuse_ring_ent *ent)
+{
+	if (WARN_ON_ONCE(ent->state != FRRS_USERSPACE))
+		return -EIO;
+
+	ent->state = FRRS_COMMIT;
+	list_del_init(&ent->list);
+
+	return 0;
+}
+
+/* Update conn limits according to ring values */
+static void fuse_uring_conn_cfg_limits(struct fuse_ring *ring)
+{
+	struct fuse_conn *fc = ring->fc;
+
+	/*
+	 * This not ideal, as multiplication with nr_queue assumes the limit
+	 * gets reached when all queues are used, but even a single queue
+	 * might reach the limit.
+	 */
+	WRITE_ONCE(fc->max_background, ring->nr_queues * ring->max_nr_async);
+}
+
 static void fuse_uring_queue_cfg(struct fuse_ring_queue *queue, int qid,
 				 struct fuse_ring *ring)
 {
@@ -37,6 +61,11 @@ static void fuse_uring_queue_cfg(struct fuse_ring_queue *queue, int qid,
 	queue->qid = qid;
 	queue->ring = ring;
 
+	spin_lock_init(&queue->lock);
+
+	INIT_LIST_HEAD(&queue->sync_ent_avail_queue);
+	INIT_LIST_HEAD(&queue->async_ent_avail_queue);
+
 	for (tag = 0; tag < ring->queue_depth; tag++) {
 		struct fuse_ring_ent *ent = &queue->ring_ent[tag];
 
@@ -44,6 +73,8 @@ static void fuse_uring_queue_cfg(struct fuse_ring_queue *queue, int qid,
 		ent->tag = tag;
 
 		ent->state = FRRS_INIT;
+
+		INIT_LIST_HEAD(&ent->list);
 	}
 }
 
@@ -141,3 +172,203 @@ int fuse_uring_conn_cfg(struct file *file, void __user *argp)
 	kvfree(ring);
 	return res;
 }
+
+/*
+ * Put a ring request onto hold, it is no longer used for now.
+ */
+static void fuse_uring_ent_avail(struct fuse_ring_ent *ring_ent,
+				 struct fuse_ring_queue *queue)
+	__must_hold(&queue->lock)
+{
+	struct fuse_ring *ring = queue->ring;
+
+	lockdep_assert_held(&queue->lock);
+
+	/* unsets all previous flags - basically resets */
+	pr_devel("%s ring=%p qid=%d tag=%d state=%d async=%d\n", __func__,
+		 ring, ring_ent->queue->qid, ring_ent->tag, ring_ent->state,
+		 ring_ent->async);
+
+	if (WARN_ON(ring_ent->state != FRRS_COMMIT)) {
+		pr_warn("%s qid=%d tag=%d state=%d async=%d\n", __func__,
+			ring_ent->queue->qid, ring_ent->tag, ring_ent->state,
+			ring_ent->async);
+		return;
+	}
+
+	WARN_ON_ONCE(!list_empty(&ring_ent->list));
+
+	if (ring_ent->async)
+		list_add(&ring_ent->list, &queue->async_ent_avail_queue);
+	else
+		list_add(&ring_ent->list, &queue->sync_ent_avail_queue);
+
+	ring_ent->state = FRRS_WAIT;
+}
+
+/*
+ * fuse_uring_req_fetch command handling
+ */
+static int _fuse_uring_fetch(struct fuse_ring_ent *ring_ent,
+			    struct io_uring_cmd *cmd, unsigned int issue_flags)
+__must_hold(ring_ent->queue->lock)
+{
+	struct fuse_ring_queue *queue = ring_ent->queue;
+	struct fuse_ring *ring = queue->ring;
+	int nr_ring_sqe;
+
+	lockdep_assert_held(&queue->lock);
+
+	/* register requests for foreground requests first, then backgrounds */
+	if (queue->nr_req_sync >= ring->max_nr_sync) {
+		queue->nr_req_async++;
+		ring_ent->async = 1;
+	} else
+		queue->nr_req_sync++;
+
+	fuse_uring_ent_avail(ring_ent, queue);
+
+	if (WARN_ON_ONCE(queue->nr_req_sync +
+			 queue->nr_req_async > ring->queue_depth)) {
+		/* should be caught by ring state before and queue depth
+		 * check before
+		 */
+		pr_info("qid=%d tag=%d req cnt (fg=%d async=%d exceeds depth=%zu",
+			queue->qid, ring_ent->tag, queue->nr_req_sync,
+			queue->nr_req_async, ring->queue_depth);
+		return -ERANGE;
+	}
+
+	WRITE_ONCE(ring_ent->cmd, cmd);
+
+	nr_ring_sqe = ring->queue_depth * ring->nr_queues;
+	if (atomic_inc_return(&ring->nr_sqe_init) == nr_ring_sqe) {
+		fuse_uring_conn_cfg_limits(ring);
+		ring->ready = 1;
+	}
+
+	return 0;
+}
+
+static int fuse_uring_fetch(struct fuse_ring_ent *ring_ent,
+			    struct io_uring_cmd *cmd, unsigned int issue_flags)
+	__releases(ring_ent->queue->lock)
+{
+	struct fuse_ring *ring = ring_ent->queue->ring;
+	struct fuse_ring_queue *queue = ring_ent->queue;
+	int ret;
+
+	/* No other bit must be set here */
+	ret = -EINVAL;
+	if (ring_ent->state != FRRS_INIT)
+		goto err;
+
+	/*
+	 * FUSE_URING_REQ_FETCH is an initialization exception, needs
+	 * state override
+	 */
+	ring_ent->state = FRRS_USERSPACE;
+	ret = fuse_ring_ring_ent_unset_userspace(ring_ent);
+	if (ret != 0) {
+		pr_info_ratelimited(
+			"qid=%d tag=%d register req state %d expected %d",
+			queue->qid, ring_ent->tag, ring_ent->state,
+			FRRS_INIT);
+		goto err;
+	}
+
+	ret = _fuse_uring_fetch(ring_ent, cmd, issue_flags);
+	if (ret)
+		goto err;
+
+	/*
+	 * The ring entry is registered now and needs to be handled
+	 * for shutdown.
+	 */
+	atomic_inc(&ring->queue_refs);
+err:
+	spin_unlock(&queue->lock);
+	return ret;
+}
+
+/**
+ * Entry function from io_uring to handle the given passthrough command
+ * (op cocde IORING_OP_URING_CMD)
+ */
+int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
+{
+	const struct fuse_uring_cmd_req *cmd_req = io_uring_sqe_cmd(cmd->sqe);
+	struct fuse_dev *fud;
+	struct fuse_conn *fc;
+	struct fuse_ring *ring;
+	struct fuse_ring_queue *queue;
+	struct fuse_ring_ent *ring_ent = NULL;
+	u32 cmd_op = cmd->cmd_op;
+	int ret = 0;
+
+	ret = -ENODEV;
+	fud = fuse_get_dev(cmd->file);
+	if (!fud)
+		goto out;
+	fc = fud->fc;
+
+	ring = fc->ring;
+	if (!ring)
+		goto out;
+
+	queue = fud->ring_q;
+	if (!queue)
+		goto out;
+
+	ret = -EINVAL;
+	if (queue->qid != cmd_req->qid)
+		goto out;
+
+	ret = -ERANGE;
+	if (cmd_req->tag > ring->queue_depth)
+		goto out;
+
+	ring_ent = &queue->ring_ent[cmd_req->tag];
+
+	pr_devel("%s:%d received: cmd op %d qid %d (%p) tag %d  (%p)\n",
+		 __func__, __LINE__, cmd_op, cmd_req->qid, queue, cmd_req->tag,
+		 ring_ent);
+
+	spin_lock(&queue->lock);
+	ret = -ENOTCONN;
+	if (unlikely(fc->aborted || queue->stopped))
+		goto err_unlock;
+
+	switch (cmd_op) {
+	case FUSE_URING_REQ_FETCH:
+		ret = fuse_uring_fetch(ring_ent, cmd, issue_flags);
+		break;
+	default:
+		ret = -EINVAL;
+		pr_devel("Unknown uring command %d", cmd_op);
+		goto err_unlock;
+	}
+out:
+	pr_devel("uring cmd op=%d, qid=%d tag=%d ret=%d\n", cmd_op,
+		 cmd_req->qid, cmd_req->tag, ret);
+
+	if (ret < 0) {
+		if (ring_ent != NULL) {
+			pr_info_ratelimited("error: uring cmd op=%d, qid=%d tag=%d ret=%d\n",
+					    cmd_op, cmd_req->qid, cmd_req->tag,
+					    ret);
+
+			/* must not change the entry state, as userspace
+			 * might have sent random data, but valid requests
+			 * might be registered already - don't confuse those.
+			 */
+		}
+		io_uring_cmd_done(cmd, ret, 0, issue_flags);
+	}
+
+	return -EIOCBQUEUED;
+
+err_unlock:
+	spin_unlock(&queue->lock);
+	goto out;
+}
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index 26266f923321..6561f4178cac 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -19,6 +19,15 @@ enum fuse_ring_req_state {
 
 	/* request is basially initialized */
 	FRRS_INIT,
+
+	/* ring entry received from userspace and it being processed */
+	FRRS_COMMIT,
+
+	/* The ring request waits for a new fuse request */
+	FRRS_WAIT,
+
+	/* request is in or on the way to user space */
+	FRRS_USERSPACE,
 };
 
 /* A fuse ring entry, part of the ring queue */
@@ -31,6 +40,13 @@ struct fuse_ring_ent {
 
 	/* state the request is currently in */
 	enum fuse_ring_req_state state;
+
+	/* is this an async or sync entry */
+	unsigned int async : 1;
+
+	struct list_head list;
+
+	struct io_uring_cmd *cmd;
 };
 
 struct fuse_ring_queue {
@@ -43,6 +59,30 @@ struct fuse_ring_queue {
 	/* queue id, typically also corresponds to the cpu core */
 	unsigned int qid;
 
+	/*
+	 * queue lock, taken when any value in the queue changes _and_ also
+	 * a ring entry state changes.
+	 */
+	spinlock_t lock;
+
+	/* available ring entries (struct fuse_ring_ent) */
+	struct list_head async_ent_avail_queue;
+	struct list_head sync_ent_avail_queue;
+
+	/*
+	 * available number of sync requests,
+	 * loosely bound to fuse foreground requests
+	 */
+	int nr_req_sync;
+
+	/*
+	 * available number of async requests
+	 * loosely bound to fuse background requests
+	 */
+	int nr_req_async;
+
+	unsigned int stopped : 1;
+
 	/* size depends on queue depth */
 	struct fuse_ring_ent ring_ent[] ____cacheline_aligned_in_smp;
 };
@@ -79,11 +119,21 @@ struct fuse_ring {
 	/* numa aware memory allocation */
 	unsigned int numa_aware : 1;
 
+	/* Is the ring read to take requests */
+	unsigned int ready : 1;
+
+	/* number of SQEs initialized */
+	atomic_t nr_sqe_init;
+
+	/* Used to release the ring on stop */
+	atomic_t queue_refs;
+
 	struct fuse_ring_queue queues[] ____cacheline_aligned_in_smp;
 };
 
 void fuse_uring_abort_end_requests(struct fuse_ring *ring);
 int fuse_uring_conn_cfg(struct file *file, void __user *argp);
+int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags);
 
 static inline void fuse_uring_conn_destruct(struct fuse_conn *fc)
 {
@@ -113,6 +163,11 @@ static inline bool fuse_uring_configured(struct fuse_conn *fc)
 	return false;
 }
 
+static inline bool fuse_per_core_queue(struct fuse_conn *fc)
+{
+	return fc->ring && fc->ring->per_core_queue;
+}
+
 #else /* CONFIG_FUSE_IO_URING */
 
 struct fuse_ring;
@@ -131,6 +186,11 @@ static inline bool fuse_uring_configured(struct fuse_conn *fc)
 	return false;
 }
 
+static inline bool fuse_per_core_queue(struct fuse_conn *fc)
+{
+	return false;
+}
+
 #endif /* CONFIG_FUSE_IO_URING */
 
 #endif /* _FS_FUSE_DEV_URING_I_H */
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index 143ed3c1c7b3..586358e9992c 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -1247,6 +1247,12 @@ struct fuse_supp_groups {
 #define FUSE_RING_HEADER_BUF_SIZE 4096
 #define FUSE_RING_MIN_IN_OUT_ARG_SIZE 4096
 
+/*
+ * Request is background type. Daemon side is free to use this information
+ * to handle foreground/background CQEs with different priorities.
+ */
+#define FUSE_RING_REQ_FLAG_ASYNC (1ull << 0)
+
 /**
  * This structure mapped onto the
  */
@@ -1272,4 +1278,36 @@ struct fuse_ring_req {
 	char in_out_arg[];
 };
 
+/**
+ * sqe commands to the kernel
+ */
+enum fuse_uring_cmd {
+	FUSE_URING_REQ_INVALID = 0,
+
+	/* submit sqe to kernel to get a request */
+	FUSE_URING_REQ_FETCH = 1,
+
+	/* commit result and fetch next request */
+	FUSE_URING_REQ_COMMIT_AND_FETCH = 2,
+};
+
+/**
+ * In the 80B command area of the SQE.
+ */
+struct fuse_uring_cmd_req {
+	/* User buffer */
+	uint64_t buf_ptr;
+
+	/* length of the user buffer */
+	uint32_t buf_len;
+
+	/* queue the command is for (queue index) */
+	uint16_t qid;
+
+	/* queue entry (array index) */
+	uint16_t tag;
+
+	uint32_t flags;
+};
+
 #endif /* _LINUX_FUSE_H */

-- 
2.43.0


