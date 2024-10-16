Return-Path: <io-uring+bounces-3710-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0561D99FD43
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 02:39:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 29B641C20F7B
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 00:39:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BE0D1097B;
	Wed, 16 Oct 2024 00:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="MKKUikkY"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81DFFE574
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 00:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729039163; cv=fail; b=JiNC0lVY7eI7jaDMKvQWqxpAihyvXw4CyoqnBVY/X+lJ/zihDY2917EgxO2gBRxREhOEbhPO4a9uexV++LpWcYVwHOVAotM53WZgEP6po6IbJIoIPtGeYpFXXbWGM7BD9A3SnKYeYULI67W6aUqCuyqTzzdah8U2XS6HhYT4K/w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729039163; c=relaxed/simple;
	bh=qp3XmdsI95RnpqhMvcQU6Y6BK+0DGMicc5TzsLF6qBE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=BWBps1sxg/TpMWsx34bI+Cn35nZVZJk6pxqPOnm2b96YsrEBHsHea1oHk4LFizeRMGzncG2kxkeMktiMuRTwc3Ta4mMLPK9O1oSTR4FHKagpa5mRZbIRorjn0NGBktvWkpyt2ipCq4Uaj5+G5MJ2KFj46sGOgh4TUzmDh4HI894=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=MKKUikkY; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176]) by mx-outbound46-22.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 16 Oct 2024 00:39:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ndH9+fqyDQqxrzpvWUaPCRBGeO8VHy9tqFRnn8G1fawhAwcgy3B8yzaIu+vJzJrpT0aHwOBVsA6b5N6jj1y25cLAx6AzxSBdU8JyQgCs2TzERNAwQP8A/izchMsS+NfyleuV5Tr5xUy8s7QhFTMkFD7xDygViuN05gldMf5cCwEXryBXOKUMI7tmkk69AohzeMBymO5v8zXgTeNBs5tT5Zbn07wcNf1WPPke1qRB19rk5Y7acVsNSQoUkM8Ddrj2N6tZngSkdKTerxQaarMvQFuZeRrdt7w1iOfKPowGRF8a+hMAqTO4g3Zj87lC2Nji+zOiEkyrn4hyusNMdQghyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/oNa4TMLLXFZIwEaJyUIRnKy/4MYwHse8Yj0xKhVyRI=;
 b=DNri+EmxjGZcMpDIm09aIavZj3noiYYq8dG8jrWIVZuN4/DB2FQiGHUQBDbHscLYLZH72ahHb476N4V8SvbxsnSQ/ggsxEtJGECsxz/yN1f9Kco5j3vS4FMB20CenCrw5rgNBR8rJEyfXloWVa697iHLedfv8Zl/q/5aaVEfot9GCasBnKp9Un68Olf/PUvHRJ8qckHGujJZviNuXVlBVeWf3iY2mJJaM9blUI9pM1EDVbZcBYODI4O7A3EgVi6s8zI61JcLcpBbhdU0YhHWk4GHqwuukXm6msfTPZU9ykZFRnJ9jjlZLsLts1BudXrRNtxmN3TiBueFHq0i70wdgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=ddn.com smtp.mailfrom=ddn.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=ddn.com; dkim=none
 (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/oNa4TMLLXFZIwEaJyUIRnKy/4MYwHse8Yj0xKhVyRI=;
 b=MKKUikkYMEcbU7JiOkJfsSWXKPh9XSgk52+9FhRWkpw24DIwrjR/4LqojjMnOj7H+d6qc9yBZsE9awGuT/9ncYF6bmD3yU852jqD0Tad2sRoQ1sxeQgVD3DNhkpdtb8RHBvLxdMwsx8qpM6GA2OXN3NUn5eyNcPbG9qckHI0sMQ=
Received: from MW4PR04CA0374.namprd04.prod.outlook.com (2603:10b6:303:81::19)
 by SJ0PR19MB4541.namprd19.prod.outlook.com (2603:10b6:a03:285::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.27; Wed, 16 Oct
 2024 00:05:26 +0000
Received: from CO1PEPF000066ED.namprd05.prod.outlook.com
 (2603:10b6:303:81:cafe::a3) by MW4PR04CA0374.outlook.office365.com
 (2603:10b6:303:81::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.27 via Frontend
 Transport; Wed, 16 Oct 2024 00:05:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 CO1PEPF000066ED.mail.protection.outlook.com (10.167.249.10) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8069.17
 via Frontend Transport; Wed, 16 Oct 2024 00:05:26 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 1B59429;
	Wed, 16 Oct 2024 00:05:24 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Wed, 16 Oct 2024 02:05:14 +0200
Subject: [PATCH RFC v4 02/15] fuse: Move fuse_get_dev to header file
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241016-fuse-uring-for-6-10-rfc4-v4-2-9739c753666e@ddn.com>
References: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
In-Reply-To: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Amir Goldstein <amir73il@gmail.com>, 
 Ming Lei <tom.leiming@gmail.com>, Bernd Schubert <bschubert@ddn.com>, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1729037122; l=1579;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=qp3XmdsI95RnpqhMvcQU6Y6BK+0DGMicc5TzsLF6qBE=;
 b=cMsrnJE/o1Cdv6LzMMt9fU2+MlEdeth7Q4ZW73Fm6IXyn/rPydinpw0LU/3O49pmNMkpUp55z
 zUou4mOq/q6C8pfmr1tKM6bFsu8qJQBTesZFAfxoep9B3bC2Hr7Hj5T
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000066ED:EE_|SJ0PR19MB4541:EE_
X-MS-Office365-Filtering-Correlation-Id: f07dc235-1e56-4b6a-bd9c-08dced763cd9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WHhmMWdicTFUbVl0b2xwTHVjU3gvdlBEcmRWU2pRVE9JcVRZMWh6VUM3YkJH?=
 =?utf-8?B?eEpVTkJ5eGp5OGlXalJIL0NFSkl4U2YwY2dPL3BEOGt2ekpQYVJWVUdRZzFz?=
 =?utf-8?B?NnpHbXdIZkRoZ3RHQlpycUt0dzk4OU5PZUJQUmtPajFhV3l5QzVxZGlrRmlE?=
 =?utf-8?B?NDZ1SloxZEwrdVd3U1F3ZW1JZWcxSys2cXhFWURPRUJXZkZ4dU1kdjd0ZXlR?=
 =?utf-8?B?YS9oZjR0ejdVNTF5TjFlazl5WldsYTM1N2U1MkVGWmo3QXZxVENhVDM3ZWJw?=
 =?utf-8?B?RFZ5TGVwZlZVeGN3bXVBMmpuTTlqaWZVWDlKaGNBZnpPcnE4YzlMbUJNTERo?=
 =?utf-8?B?MVZwOWRzeTZnWG03NzFLOUtQZ0cyeHNEWEVQaHRKYVJWYVAxK2xSdlRDRFU1?=
 =?utf-8?B?V0I3czh1SHc1Tkp2NTBvZGZKSzZwZmt5Yk1pU2tFU2hGS3NROWU3UmdDWmx2?=
 =?utf-8?B?Y2REUWdPRjRKelFNc1MvdlkvbVRDZFFlQ2g3dEcvL3hkdEh6S1JMQnFMdzRt?=
 =?utf-8?B?QVpBTy9UYVlBNHp3TW92ZlJFSmpJcDN2THg3WW8rSW51U1FMRUU0OEJDbUZK?=
 =?utf-8?B?UDQzNENnemoyMC9xOHJSeHBLbVczT080TGRVOFBuRG04OVRFbjZiRWpnZ1Ft?=
 =?utf-8?B?REJHZjlxeXVqUWVLdnArVXp1MjI5dU1ETVlFenNUSE5uazlaUnF1UVl3TURp?=
 =?utf-8?B?MlU1M3VIL2hqSUI4Q1hmZ0F2dlJxVWphb2NJcU1hbFNmdnhFZm95ejZJbTFr?=
 =?utf-8?B?d25XcS9MS0ZtbGtSRlo0WlhoUXBmdHNTRjNPWEdLaTVEVG5YRzlESEwvaGEy?=
 =?utf-8?B?VUwzUHpxZU5Fd1dqRy8zQ0ZnOUFHVGxVQ0JSZldNQUFTVm5sUjd2bmxSMVJa?=
 =?utf-8?B?aGx4UFVVeFZhUnNqMjFZS0JXbGl3eGdwcmhqd1E1N0N3VFd4cml5ZndrOTFm?=
 =?utf-8?B?ayswL1gxR2grRDRienBVWjRwZmNnTmFuZU1jNHRDYm5DRmorMFBIZjdMNVhM?=
 =?utf-8?B?QzhaQUdVUVZFWEt4Tm54SnZWZm94eldZOWRwSGJTekhOcElja01NVkNaNThE?=
 =?utf-8?B?aU9FSk53STN3Y0ppVnY5akZ2NmZuaU5LZVUxaVkyV3ZaOGdqc3dvRnpyam9o?=
 =?utf-8?B?aXQwNE5tZTVTcWkzSTlxQ05QVjEwZlJmdElGSFAyekhUcU96b1RSb3hTd0pT?=
 =?utf-8?B?Y2V1UThtbGtRVW9nRGhiU3VPeVIyeGMvNFp3MStvVTQ5SXlXVkRWeFdvWmlh?=
 =?utf-8?B?MDAyTXM3bnhaVjN0N09aVjFWZGYveDFRUXpSTHRxNkN5bUhJdGxmOTF1Sm9i?=
 =?utf-8?B?Rk5GYkkwZmQ4RGZaTnB1dVZmSk1nMU5zZ3JVbmQ4QmtSSnNEUGtPMEZIL0hj?=
 =?utf-8?B?dXBTTkZuY0dTWUlZVlIrZHUvdkNoVWh4Ni9JQkxsVUV4bDRtVnplQklINmZW?=
 =?utf-8?B?TTUvR201c3k5WEVtQkNMaFFIZm1IRTJQMThxaDFkNkFFVmdVZnJ2b2Z5bVRm?=
 =?utf-8?B?V0w2MnFVUERGZGFLQy9aQ084VWU2VWdkQmd4Q2JVdXc5VmxHSXRiQXlXbXJi?=
 =?utf-8?B?YjM1Y2ZpelJMTEl3QmRBK3p2dkZqWDg1dlUzTndJNzB4bk5wSkZoNUh0MXNR?=
 =?utf-8?B?SUtkTFRwRnlnODFPTXl4QzdFQk9rZkhvUU9Hd0VpYVoxMWJrNGwzTFZRa2tJ?=
 =?utf-8?B?L04vTGhlclExdkRtVVBZWDNwTkdPWVJZc21VaHUyVGhTMldjdHViQ2wwdkli?=
 =?utf-8?B?MmViWmtLNXNNdU5BQlpyTlkvMTl2bmo1Y0k2NytDMVI4TWFnV21IcG1RL0dW?=
 =?utf-8?Q?j/UuTfFZGrOsRezXDq+ALnRL/GKBP8eo4stn0=3D?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0if7ZEiultOILlT4fKZy2Ex0W2xbhz/2YAcK9861VyNV2jmE/yXHt/mLyzA+IvjibOL24eeqfeKY6In5RMGxnGbpb39bSr4A3DxGyN/lH4J2IbrjMBvE/SW/HP2QbXm4dMrXxviT4MydNo4DrBk5sjeBo/j6TM23sc9hwrCdibKXNFSIDNKln2POi35W52qIk2ai8F6vV+Ys7+WjGiwMZrviLKBDKnZBH1hfnIpjHWf0/GdGFvsZsq1NB6zNeVjlsHD0Le0RXHQ5TJS8l7SykDUtKJO1fs6YO+/VAK388ZI6qE9mnfBpcmaJ7taaLfLlSoVApzdo0Fv3bDgY1xWxzJzHnyeuCQRCiGUfUACGD8QPzxpyzbUGry+4KLObk1Mz7PKa7npg0i8+Fxu9ubILcTAMZH+f26k5PXvpueFbd11oxpuzNrocvDZc/TbgwTkQNS95MVOB7zoN2p+U+8mPxw/fTIum+QMCmkzI5Ju9FVSwAUKvT3nn3QNgKKOmnxPb/n9w3Vv5efAzh3JS5H8Xs9gwg3/EZV9hulu9JkBwbUsJdBmuTHw4sNS7B/G/5q4Rb4z8xa4Ovr0MLauwsHOd+9/3856tiQAmO1Pg/PQiZGZmeNnpmmCxANo8q00hMK23n7lHtYiyhMNLZfRnjx8NAg==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 00:05:26.1656
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f07dc235-1e56-4b6a-bd9c-08dced763cd9
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000066ED.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR19MB4541
X-OriginatorOrg: ddn.com
X-BESS-ID: 1729039161-111798-10775-61145-1
X-BESS-VER: 2019.1_20241015.1627
X-BESS-Apparent-Source-IP: 104.47.58.176
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoamRuZAVgZQ0NzY2DzZLNUyyS
	DV3CIpNdk8NdEixSwxxdjSNMXE3CBRqTYWAE+IqGRBAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.259752 [from 
	cloudscan13-183.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_SC0_MISMATCH_TO, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

Another preparation patch, as this function will be needed by
fuse/dev.c and fuse/dev_uring.c.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/fuse/dev.c        | 9 ---------
 fs/fuse/fuse_dev_i.h | 9 +++++++++
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 74cb9ae900525890543e0d79a5a89e5d43d31c9c..9ac69fd2cead0d1fe062dc3405a7dedcd1d36691 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -32,15 +32,6 @@ MODULE_ALIAS("devname:fuse");
 
 static struct kmem_cache *fuse_req_cachep;
 
-static struct fuse_dev *fuse_get_dev(struct file *file)
-{
-	/*
-	 * Lockless access is OK, because file->private data is set
-	 * once during mount and is valid until the file is released.
-	 */
-	return READ_ONCE(file->private_data);
-}
-
 static void fuse_request_init(struct fuse_mount *fm, struct fuse_req *req)
 {
 	INIT_LIST_HEAD(&req->list);
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index 5a1b8a2775d84274abee46eabb3000345b2d9da0..b38e67b3f889f3fa08f7279e3309cde908527146 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -8,6 +8,15 @@
 
 #include <linux/types.h>
 
+static inline struct fuse_dev *fuse_get_dev(struct file *file)
+{
+	/*
+	 * Lockless access is OK, because file->private data is set
+	 * once during mount and is valid until the file is released.
+	 */
+	return READ_ONCE(file->private_data);
+}
+
 void fuse_dev_end_requests(struct list_head *head);
 
 #endif

-- 
2.43.0


