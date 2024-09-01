Return-Path: <io-uring+bounces-3001-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F25159676BC
	for <lists+io-uring@lfdr.de>; Sun,  1 Sep 2024 15:38:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1EE3C1C20DAC
	for <lists+io-uring@lfdr.de>; Sun,  1 Sep 2024 13:38:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0538018454E;
	Sun,  1 Sep 2024 13:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="Ug/gHyoK"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C4D18306E;
	Sun,  1 Sep 2024 13:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725197846; cv=fail; b=UHeHpQ0Q1/+sQZWBpkoaovYmM6MR1vJQN7FFOJp83dmaookG3j17IYxHGvjuA6V8vrvDU3E74FVn6dk9IXGCjMctfx1XEm4BsYwac+lCGlHEeIGTW2RMNRp61tprFdQbA2KlYLKwj+umaIMtkVgBvz8VcsUY7VHwyHUcCb4OgQ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725197846; c=relaxed/simple;
	bh=pHDJTeiI/wATKGBye8CuRLq1KZTYS4o1p+0q2EJuG/o=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=pMmcGM28GeogypKyuwC3EEXtFtS3gOF+YJs4p57EXxVfFAayAMbJ5nInSpWdKJh/YPs0BXSsXZ6QnlIhdWBzr7bMv1x3PQUjZ056hdsgEbmyFwHzXnXWPmkolh1ykFgz1CWubR0Em/1SRJgwYDGPE+fndlC6UvT8ZLXAXy/cBpo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=Ug/gHyoK; arc=fail smtp.client-ip=209.222.82.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174]) by mx-outbound-ea22-15.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Sun, 01 Sep 2024 13:37:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o6NWtIRXFPH3yeuhu6oEOJVX2V5UALyoyXXPI6leFGjA4i24wvH9slgy8aAmI5WALxS8vYgUpymFRFqL5VcuG76pyOKoBoZ70FZebtIaZ722sEogVoRJbsOfNPAWCoY1A8/w1uIrJM2M7Oe5wbjZBNbHqRh/+uNNFExbAJ8mqdHdur8m54a5dCmRRYON6YlKHFqFoLlx34wKs2LCzdZCK7S7XcP/Omk7Ol4DBQ+QqntmuDwNxu8V2yCd2uA5MpAhmNOoT5MB1L9txKlOgHlH4dd8VZiJnrbtmAafX3/CoahYhQmQsHAumnTRAtiO63VekQIhnLCFVC6dtfVxf+HmLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GNAPuSxJyn5kGTojJW8+xT4Kscme4HWuBlvVW+TyX+c=;
 b=mbqZt/fCa8GKVtWUD6ztYcfD560s0n+EqfxAAjhjqgR2aNuDISL73c5yHbVIKcQafySFzODwf6qm510AUBnN/Mny6Qd9qwWg127TWBIJbNfUpshU9xTDdtJvzmQ69c+RLUsWreBmJ4KfxrGS6WSWvQnjRhWRThpVYBWQW/CjdZ3BnenjrE9eg65zjDODH03g+cXlwddWNqu0XYaFudxxT/UNvGVTiwlH3lAaQ1oujPdBMhPQASjFiKudD5KanozRj2Q2Dg6erkAGm9a8o4y3ZUnkHHcYtkBMayQ8Ry5i/3ujD5A6sAByTCsO45ip6sa1wKd9pft7dxhXyDxVTGtOag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=ddn.com smtp.mailfrom=ddn.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=ddn.com; dkim=none
 (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GNAPuSxJyn5kGTojJW8+xT4Kscme4HWuBlvVW+TyX+c=;
 b=Ug/gHyoKc8mRf6Q9S+Tq56S7sXDWd0XbjMwjQVKv3BZmcXvjkpIbtlCb4Emgw117kWSwd0aXGX/rqKyqfcAJAEAuhyU/1DEHWKvQ0PShn/wcHoFFT0HCt0dDEysm1dI1J9T5eCj8oAJiOBN/XIlkD0mhvjGiKrNT21q1dpN3wm8=
Received: from PH7P222CA0030.NAMP222.PROD.OUTLOOK.COM (2603:10b6:510:33a::13)
 by MW4PR19MB7150.namprd19.prod.outlook.com (2603:10b6:303:219::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.23; Sun, 1 Sep
 2024 13:37:09 +0000
Received: from MWH0EPF000A672F.namprd04.prod.outlook.com
 (2603:10b6:510:33a:cafe::20) by PH7P222CA0030.outlook.office365.com
 (2603:10b6:510:33a::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.23 via Frontend
 Transport; Sun, 1 Sep 2024 13:37:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 MWH0EPF000A672F.mail.protection.outlook.com (10.167.249.21) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.7918.13
 via Frontend Transport; Sun, 1 Sep 2024 13:37:08 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 61A96D2;
	Sun,  1 Sep 2024 13:37:07 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Sun, 01 Sep 2024 15:37:04 +0200
Subject: [PATCH RFC v3 10/17] fuse: Add buffer offset for uring into
 fuse_copy_state
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-10-9207f7391444@ddn.com>
References: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com>
In-Reply-To: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>, 
 Pavel Begunkov <asml.silence@gmail.com>, bernd@fastmail.fm
Cc: linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.14.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1725197817; l=1631;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=pHDJTeiI/wATKGBye8CuRLq1KZTYS4o1p+0q2EJuG/o=;
 b=uU2ftzmp17X8OcPLRfclSU1nV4S9TfavdkuFAoG+cMX9F4qfdJYR+YpfPi3KJXwPgpc0An2AH
 RsygxXPiz8hBEA8wu+Gv7svXKmT2/gRnEZqseJNpntP4loeWLq+cA0Q
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A672F:EE_|MW4PR19MB7150:EE_
X-MS-Office365-Filtering-Correlation-Id: f1a0c551-9662-4f6a-d3f3-08dcca8b2cf6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SEowQlJjZVl4cnpNN1JSKy9ZeUVCa3dvRFJyUHllcmV2VENrSWIvS0xuUFp6?=
 =?utf-8?B?TVFSY2dyRzk5MndxbnR0WXJaeWM2c2NCaE45c29GVDZUOUFwRHBNd0lkTjlB?=
 =?utf-8?B?dGJtdnhySW9SY05jWXZrMnBmTjRoV2pvS05FeHk2TFFxcng3QVJsdHY1ZVZ0?=
 =?utf-8?B?SUVMVGlaYkJsa3EzREZLRno0ZU84UHZVT2RKbDRucGhpNlhMQ3pmL1I4WDA1?=
 =?utf-8?B?bWEySkNMK0RvY0RqdHJReUJDU2ZhZXFERFRwcFl0ZU03aHNQdmFzV3A2MUdW?=
 =?utf-8?B?UTNkQ3hCUUlOclBMMWIyUU5aZm1lV3B6SjVyNGRFSkp0bkxQUmFPVEFnRkd3?=
 =?utf-8?B?OGc2Q2NTSzlDYTRTUG1TOHdsN0s3a1hzbFdpLzVHS1JSemNKeHZlMHB6VldT?=
 =?utf-8?B?dWhFbzhlRzUxRTEvbHl2c2ZMNG5LS3hFSDBqSzY2S1l1NWs2QStpQXZDSDJQ?=
 =?utf-8?B?UExOcHZiOFhNb3dhQnpVL1FXRGlUcmV5VC9VNmt6dUR3VWVYMzFJOERTanZp?=
 =?utf-8?B?RE0rSmMrUGlFVDdxMTZlSUVGWEZaRFB5OU05Mjdjcm8vT0xnV2VjMzRyTFZk?=
 =?utf-8?B?SWU3TXFFQVFUb0ZHcUh5VlRqV1o4eXMrbnZ3UXJkNTJzbFkxQkxGalQ4Q1U5?=
 =?utf-8?B?MFd5ckV3aXFGWmhJZHJ6U3FBNkRVVFVwVUtFTWZsQU1ySmJUVi83WVhVSCtt?=
 =?utf-8?B?Q2MzS0hWdTUvdkV4WXpidU9ETTNPa2RVOG5tb1hPK1FLUmtQZ2VJNE9MRHg0?=
 =?utf-8?B?dkQwR1lESTA5bU5FVDFkSGV6Y2J6RFRFWld2QWo2cVBIUlZKU1B3SEs0c1Vi?=
 =?utf-8?B?SlBsem5obGQ2MU5XZTFmODFFQ3BFNzVNVmdzaUxBejl5LzY0S3JHdWZIL3Jq?=
 =?utf-8?B?OW5TcEU1cEp4N0FodDFjWEdZcGczMG96aXZjZlpreUsyaEMyRE14UGFPVWtw?=
 =?utf-8?B?VjZETjZ2d0t3NWdaY3lYSzI4TnNtdFFybU15RS94NGJIekxtNGFQV3JpNnRQ?=
 =?utf-8?B?Y0R5Ukc3S1p6Y1ZmOCtXeVo4KzR2S3V3LzRUdC9helVaL05WejlUOEFxQ2hD?=
 =?utf-8?B?TVhDWjM2WW52YUhoemp1aEhsOEpaZEp4aVFRRFZSd0tEUTBVSmZ4U1U2RnVv?=
 =?utf-8?B?T0hvWnViUkthaGJaNlhmVmF0Nmttdm1kbVlreG91dHJQOEFPRWUvQmprREVh?=
 =?utf-8?B?Q2x3RXM5STE1eHc2bTlPOVZDZVo5cGdTdmJ4RkJrUzlSSS8xOVlGUE1YQWxD?=
 =?utf-8?B?RGJiMm8yQmdzeUZHa051VzV1VXFUTjV4QndQYjVwSW92NmlKL0Zad3VhQmxw?=
 =?utf-8?B?Y2ZQcmJaV09QLytxRXl6TTFoSTR2dFdjS3ZxWjJydDFibjYwR3ZDSTZycWpz?=
 =?utf-8?B?ZDJLbjhuODU4Wm5RWVdVVlpPVEoxbkt4bzZCTXliaHhSeFU3YnZZR0ZuMHZk?=
 =?utf-8?B?QVZiNGcxZ3ZDZFRVcnQrVHJwTXVzQkJDMmxiTitPdkJWWW4zMC9mUDZ2VThI?=
 =?utf-8?B?eklmOUhjSG5nYTZISTUwNmV1aG05SThqRzlVbEVWMDBuMEduR2l1SE4yZGV6?=
 =?utf-8?B?alY2YXp3d1pka3FuZlRueXpQbDFGNjY4Q1FIYnkxQmZITVN5b28rQ052ak41?=
 =?utf-8?B?OVhMcUI0VEZKVmxKVlBlUUxMbkxuYStEdG5EemcrTkQ5T0pSaHhNQ1NMYlky?=
 =?utf-8?B?cEIrR3JSQm1iY3kwemFadWM2SDR4elNOL29sT0dQRG5jWUVmcUlickdYYmRE?=
 =?utf-8?B?THRuV0VVQ29wNm1JbW9TQWpwMzhHQ1kxTUg5TmNZTWlrUFp1aUxINjJTYjgr?=
 =?utf-8?B?UXYzNTB3NXExQ1RVMGx3ai9IWFBwSW1obnZaYmliT0NJSFdPd1JPeXdVVHh5?=
 =?utf-8?B?QkRaaFU2OFRrdXNoaDhvQmh0dGlIL0hBNUNIZnlQL2JGTXhzTDlIeTJtUWVJ?=
 =?utf-8?Q?OTYRyHnbws0fByCtbAQCumATHDwXGrgZ?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Gm9GtNIjp3MneZCgSWB8lj8MNAb5cF0LVBt2ASNv6q6l8al+uvKWvwOWiwhcbv5II5A2c71krJZlDTj2UUBL9vxXLIc1KqFkhSOmhS+s6cyHlioFhycTBIXqHbRrfzkKNNcbtElEcZuUfgJj2ieMRIG9GUOWIv6Ot6wBcnA+uCKyL2iTXZy1AmeyRF4rSNy811UQpIR8GJefLTX+G83DnxPZP6BOHGFuEh1QVSLm8uXVCwrp1dxWKuq/uRV8DkNInDl7e2fb7msTHvtjm8Ib59+FYuh/7lOI80nQHv/MoU7p60sLq4ybfCOwAs9AI+aNlWMBjDPZkSSOeaMfu1BI01aVt71PO1lMj1XsW+g1mG9/P5b15acYuHVUtoyCaoKYGndjCElZAPG3qDhQMyfq0WGsy3eXoa830AAChEQ+++wS+JHqNxvS7ATqzqpURpyS+lFnlwfBTM9F2bEAwEY5wlzJ8AML5G+tzXA2hwqu+gUZK+Y8AmFR2Q63yowH0DXiNEgAN7S+8mRL78s80OKxJgFIKVs33upVHruON/kz44OFXOSd8A8OZp10rYDZiCFnm1RzIt84CNXylrbgIfQ71LNlc/i5i2tli4t2FlYwUJz8l29hsAbh2J6dAC1N6kmpkSdpJAjWTXHUDqKKlyctcQ==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2024 13:37:08.1375
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f1a0c551-9662-4f6a-d3f3-08dcca8b2cf6
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A672F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR19MB7150
X-BESS-ID: 1725197831-105647-20973-54398-1
X-BESS-VER: 2019.3_20240829.2013
X-BESS-Apparent-Source-IP: 104.47.56.174
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoam5iZAVgZQMCkpycjEyCjNKD
	HRLNEoKc3CLM3EzMAsOdEkKTXFIMVUqTYWAIkwLMJBAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.258743 [from 
	cloudscan17-123.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
	0.50 BSF_RULE_7582B         META: Custom Rule 7582B 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND, BSF_RULE_7582B
X-BESS-BRTS-Status:1

This is to know the size of the overall copy.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev.c        | 13 ++++++++++++-
 fs/fuse/fuse_dev_i.h |  5 +++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 9e012c902df2..71443a93f1d4 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -745,6 +745,9 @@ static int fuse_copy_do(struct fuse_copy_state *cs, void **val, unsigned *size)
 	*size -= ncpy;
 	cs->len -= ncpy;
 	cs->offset += ncpy;
+	if (cs->is_uring)
+		cs->ring.offset += ncpy;
+
 	return ncpy;
 }
 
@@ -1863,7 +1866,15 @@ static struct fuse_req *request_find(struct fuse_pqueue *fpq, u64 unique)
 int fuse_copy_out_args(struct fuse_copy_state *cs, struct fuse_args *args,
 		       unsigned nbytes)
 {
-	unsigned reqsize = sizeof(struct fuse_out_header);
+
+	unsigned int reqsize = 0;
+
+	/*
+	 * Uring has the out header outside of args
+	 * XXX: This uring exception will probably change
+	 */
+	if (!cs->is_uring)
+		reqsize = sizeof(struct fuse_out_header);
 
 	reqsize += fuse_len_args(args->out_numargs, args->out_args);
 
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index 0fc7a0ff7b1c..0fbb4f28261c 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -28,6 +28,11 @@ struct fuse_copy_state {
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


