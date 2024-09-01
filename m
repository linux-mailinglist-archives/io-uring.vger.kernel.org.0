Return-Path: <io-uring+bounces-2996-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B1B749676AC
	for <lists+io-uring@lfdr.de>; Sun,  1 Sep 2024 15:37:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61698281B65
	for <lists+io-uring@lfdr.de>; Sun,  1 Sep 2024 13:37:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A5A818306C;
	Sun,  1 Sep 2024 13:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="e1wAqozu"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B195158DB2;
	Sun,  1 Sep 2024 13:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725197842; cv=fail; b=bPJQGlcg0JeSuhcCj4B2+91ik9OiGfgwDWP/bK8I+lPyHc3k3+KDMXslAGIITBCWqS4vexIOvJJjz4WQzDXkwlKDWxSSYE5SShEeACiOehxXep3031QJVdNNxkIZyiHmbqnNSr3MAv+JXqoSBUwPFUrRkf/dMS5OO4DPqIr9NRw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725197842; c=relaxed/simple;
	bh=3mCTEEHA68u9oTnOirv0IWKrlahncnp6c005tOkLWpY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=hSSFvMBeZ6T3lb7akl16cl5YE1XiO7i+2oZOWhPURhAkP8NymKtS8SxQTKs06RVnFMESrwk+Y/FVP4maASTb0st8Nr7UmGwbX4F3CR1/6RNho0DDrQdz9ZJ6bVCQoAwqzfWKTHkXle7bLPsbcJG04uGymhl6WZPcbqGCN4w/8F0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=e1wAqozu; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2048.outbound.protection.outlook.com [104.47.55.48]) by mx-outbound10-30.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Sun, 01 Sep 2024 13:37:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Aqyt8GxaMSDceryuJX2ivs606CXGdGbfNH0YEMqeby8MpWBF3l8aO9PLGahYvqLEnl2w8pKcqIbS48S40+x8cW/lrR1tujcDV6iENSnU3CK1AYOLZCn5ubVymz2UumWQNYDCXn+0tag0b9twvkDxFzw8KhYXeovjKevAybUldizrfqYBwfDB2h88jANOjy/zgjE6URJBEBi/lMp92vZY3/0HBlefO3anJDAVOPS3rO6PzR0J/NtMsu6r/3wKiyjjtvmceWNo0BfVlQT+wUvi6sg/pa5FhvLqgoFpJ4+S86UK7O0HIwaxdMzGQGKiPsRK5uIRkV5Y6FUvUnwdbd8Kpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QqxCiT+OsF5fNZGoDOBZ6cH6vumq+2fSSzT/25hideM=;
 b=DixlW17VPie83vU6mIWSsGNTgKmWlVH27zPcbM8TdvICvOqsYKbk3bR7cr5WbPIE8dN/fV56b3333PVJmjqVNc9KhAy+0VhGE+EabGrJzjomTZU9mlYG0lulgx8/jvCMX8IWMLgqr8w9GXtSTV/h0/XAnPSCA5Z7+qFsMEn+7UE+Wskct/XA+HHOVSuOHt4qcbiRg7lh3w2L0BKWfAPopCC3ooB/EG6AT5OZJQb874PNTAOJ7eGt5YmGYe9nqeEgdg0JBgNya/5XWC4eYvWjebHjRTc2Owf3lyP9vCbI+biDZhPZFkeWgQE/nbwwS7WHHFq+4DiLaXlnGggzzVkKyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=ddn.com smtp.mailfrom=ddn.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=ddn.com; dkim=none
 (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QqxCiT+OsF5fNZGoDOBZ6cH6vumq+2fSSzT/25hideM=;
 b=e1wAqozu27myqcrxPXILF92f9BxR944yNouO0Zs0YiDKxo0KGYE70AbR2bgLyFOJ582kb9n+Hq6/Vf2tHUW/9PHAZ+yfotvBd3/uf4um8BZL9lTdMHG0gqqIdyDD206D5z6BcokIqQiRa++8+C6jUKzEssBBC+PQtc/2pGOsfrM=
Received: from MW4P221CA0017.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::22)
 by CO6PR19MB5356.namprd19.prod.outlook.com (2603:10b6:303:147::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.24; Sun, 1 Sep
 2024 13:37:01 +0000
Received: from MWH0EPF000A6731.namprd04.prod.outlook.com
 (2603:10b6:303:8b:cafe::bf) by MW4P221CA0017.outlook.office365.com
 (2603:10b6:303:8b::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.23 via Frontend
 Transport; Sun, 1 Sep 2024 13:37:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 MWH0EPF000A6731.mail.protection.outlook.com (10.167.249.23) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.7918.13
 via Frontend Transport; Sun, 1 Sep 2024 13:37:01 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 95951D0;
	Sun,  1 Sep 2024 13:37:00 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Sun, 01 Sep 2024 15:36:57 +0200
Subject: [PATCH RFC v3 03/17] fuse: Move request bits
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-3-9207f7391444@ddn.com>
References: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com>
In-Reply-To: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>, 
 Pavel Begunkov <asml.silence@gmail.com>, bernd@fastmail.fm
Cc: linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.14.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1725197817; l=1214;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=3mCTEEHA68u9oTnOirv0IWKrlahncnp6c005tOkLWpY=;
 b=rumk+d/5/shsGZ+z3AwG94byRgiTSP+pfup293w+WYCeKc5Zj6JV8uV6oaeTBkv/JnuWEe+Mh
 jI4YZ1A6wGnB6CD3JOSTaa+gtaDb4m2zcFH5AmbNzAxeaqGoW1E8707
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6731:EE_|CO6PR19MB5356:EE_
X-MS-Office365-Filtering-Correlation-Id: 1780a3f7-42f4-47ee-c4e9-08dcca8b28d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZTB0cE9QK1QvclRneVdXWjZkUTI2VnZseG5qcmlCa2E1Z2orRGxyeU9HbmNQ?=
 =?utf-8?B?NmcrRFprYzNydWtOamtMczVOMGxiUXVsM0VpZCtxbFR1TFBmTlppYm91MjUy?=
 =?utf-8?B?cUhhMHU0dXJOSzBOdUc1OXdUUzArSWZ4VmNxbXowRzlPazU3L0UvdFBsWXRi?=
 =?utf-8?B?K0J4SGp0bndiNlJjQmNPZ0d0SDlCK0ZTNGZMTTNKK09YVVZVandFd1BPQ283?=
 =?utf-8?B?MXZEUmlmeUp3V2RQYUN4RG9Ic1piRmtNeWEwWFNIV01oNjJOUUY2Q3gxMjZ3?=
 =?utf-8?B?SEZid0NlMGRLQUtWaURiNXVWOTEzMGNYeVNEMlpDeXdEUUNtTmRkcnJROVdG?=
 =?utf-8?B?azRoQThwQy9wUjBGK0hIblNYK283Q0RyQ2EyL1QwNEJ2N0NndkFvL0JxYU1U?=
 =?utf-8?B?VDlLN1picDg4Nk15U2s4bmtWS1ZxdlEyZ0c4QmxJU09tNmN3TFk5TVlZSVhB?=
 =?utf-8?B?RFpWSVpjZWdkcVhVNGRvbi9hRkZWTTFrYVdOVk5oeG9zT05WWWhrWFNxRzFF?=
 =?utf-8?B?clg1SlR3RjVlZ0ZOOVNtb0IwRVlkQlZYa0N0V3JHRzFFVWt6Y0ZuQjdLczNq?=
 =?utf-8?B?Q3g2ZDVKdHVMTm1jSlM1OGI2Z1gxak1OL0hCVWRZNzdJbXFER1VmL1d0N2lu?=
 =?utf-8?B?ZDlPY2RTNW5XN29SQjBHUmJEVkdkTDlxNzV5dUdMdnlRTlRWK0xLbkp1eEdP?=
 =?utf-8?B?TWVyRXRWdmFQSE85M29nL2xNdTRiN3RxWjFVcTlhNVBYa1ZacHk2MjFXSi9B?=
 =?utf-8?B?cGlTcytUVUhuQWRmREhhUFZtRnF2YkF6S0VXUExnTkVJbEpiWTlqODRranhy?=
 =?utf-8?B?OURKbTNmTEtYMS9idlcxajkreVV0WVZQRjZBWEQzSHdPaXBScHV3dkxQZ1BK?=
 =?utf-8?B?RFpKeDNqMTlqWS9RZ0U2TWZVYUVBUHhHTk5lZDJ2REdmckVXYjNIa292K1c2?=
 =?utf-8?B?dDRscFpLaEpaREdhTU9pVUNJOHRodnVOVkMyU2pIaGEvUFhvczZLQkdKSThX?=
 =?utf-8?B?NFJkUElHeVV4cHpTN2xycG9MenhBeEM4N0NjVCtMZDAzUjhUVFdJalVsN1dD?=
 =?utf-8?B?bm1pcTJWQUdXV21GcWxyM003Vm9jZ0JFcHcxL0tidUlIajlCVStNcXJsYjRY?=
 =?utf-8?B?Q1M4cGMyWThaeGlzaUlxMFBDSlpzZGExRTAwT1l4WEJCYkhoZTBDQTd0ZU9w?=
 =?utf-8?B?bUdIK05RVVJmSjNiOWwwdHdkWkFBemJHT2pDNE9aWXl0emlYck84ZzA3V1pJ?=
 =?utf-8?B?MTgzTkNUZWFkS1VpUTJjWDdDN1JacG5pK1hLVVJUeGF0N3BlUEZNSGtKdUs5?=
 =?utf-8?B?TEQ5ak9EdTZES0UvQkpTMjNYaEJDN0Vsc0NycVAxWVhmN080NFdWVW4yaTE0?=
 =?utf-8?B?a0NrbjFTVU5QUXppa3J4ditwUHRjMXlLaHY1clIzbnArMTFpYjQzOEQwUkVY?=
 =?utf-8?B?NjBKOWVUcytKY21wWXhranpGLzNwaTU3R3lERzhINlZoTTdtOTd5di9oSmg4?=
 =?utf-8?B?SnJURi9JQld0YWo4c1NndHhsTDhzcjdmUyt5TGFhRVgrdG1Gb2I2YU1jUVNx?=
 =?utf-8?B?S0x0amZyaVFDSWxqelhKeHV6djA3Zll1RlA3NWtobSt6WG0waTlvOGVQSVY4?=
 =?utf-8?B?MUttbW1RYythYmsrcjVhRG1NSWxab09OU3VOTmRhYk9rYS9XTUdYZTUxM1Jv?=
 =?utf-8?B?ZG55ajlwMFIrc1FKUlp0SFpWUUh5M2tCWEkwMFU5bGdQQkZKWVBNQXpBeDJJ?=
 =?utf-8?B?YlJLUDdwYUxoNkJhVjZSRE1mdmJPUy9kY1ZCQjVPbkZ2QmFLSlFKT25xMUc3?=
 =?utf-8?B?NWZsQ2ZhK01TSVF4WjNOdVI4VXB4TS9uUFBDL1RGZ1lKemhBeEFLdEJYY2Jp?=
 =?utf-8?B?WUNsY1NheUJmSXIrZU5SSkVmWmFyNFhZSmIrWFloeVhwTGdGakV6Yk56WmVR?=
 =?utf-8?Q?Fui23YV8Tt0MkxQ9pzV4NTAhkrqAgQbV?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hycbEm6uUNAiXOuOsrVva1BcEmcp1mpVCkLRe2aNtgCQH2kWQPnzl/n7LF+I69GpjaDaJPT2HvZGmab74MwtFeRdrveCWkfr1GHJVgR5NpvgrSCieANIhkNzad3My5h6EjgkG3c+GCk5lQ65fjWSK8iHg6nOzbzaoooECFIoOabKEudJpyMF2XTTLuC4oNlF1c5ceXQsUcR3UyRAodaZ31BQqX33FN0GOKHf1F/NDPjuWRgNAGuMLU/kzuqcP2izo4Q8fh2Dozfw7jmTZG+jPPdBxiC7wU+EcOBSg9fZglQpYupXE7NT+E6wZQ7Hj9dkXyenutgv9KZaVS3T/CXL13e0cD9iCjk8kqDEwjjzPntwJADMXDQBeeaRxi/8GaUWjc+spwMYxFMT+vukF3juYPb7GeTzo2DjI6ZFQh+r8XYW9iJgTlhXyAW8K0ZFYs3M2m3gFQpfrejNTkC4P4ITHoFQIyqrAsRqrR6sDdC2ggz1ORDd7xbzBjWeQ9q3VbrIYWkYCbBGKdoSYYynBRrvGWG2c1G1MhBkmoqQeNBpoH6/M3TKDuRKAtGmjeMGTdTciQFsH0swWZfrmQg61jWRV6LaPG5CaTaioJLrWkafiXwMCD+A0R3KeMms2ZMWKlHMKqZO9WkdUu2akOeQjCgvXQ==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2024 13:37:01.2865
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1780a3f7-42f4-47ee-c4e9-08dcca8b28d0
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6731.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR19MB5356
X-BESS-ID: 1725197824-102590-12630-7736-1
X-BESS-VER: 2019.1_20240829.0001
X-BESS-Apparent-Source-IP: 104.47.55.48
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoaG5sZAVgZQ0CTJwtDMwCTZLD
	XFICnN2MLUKCU1MTXJPCXNIs3SINlCqTYWACZ/iBJBAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.258743 [from 
	cloudscan10-236.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

These are needed by dev_uring functions as well

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/fuse/dev.c        | 4 ----
 fs/fuse/fuse_dev_i.h | 4 ++++
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 9ac69fd2cead..dbc222f9b0f0 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -26,10 +26,6 @@
 MODULE_ALIAS_MISCDEV(FUSE_MINOR);
 MODULE_ALIAS("devname:fuse");
 
-/* Ordinary requests have even IDs, while interrupts IDs are odd */
-#define FUSE_INT_REQ_BIT (1ULL << 0)
-#define FUSE_REQ_ID_STEP (1ULL << 1)
-
 static struct kmem_cache *fuse_req_cachep;
 
 static void fuse_request_init(struct fuse_mount *fm, struct fuse_req *req)
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index b38e67b3f889..6c506f040d5f 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -8,6 +8,10 @@
 
 #include <linux/types.h>
 
+/* Ordinary requests have even IDs, while interrupts IDs are odd */
+#define FUSE_INT_REQ_BIT (1ULL << 0)
+#define FUSE_REQ_ID_STEP (1ULL << 1)
+
 static inline struct fuse_dev *fuse_get_dev(struct file *file)
 {
 	/*

-- 
2.43.0


