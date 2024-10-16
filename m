Return-Path: <io-uring+bounces-3707-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 074DB99FD40
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 02:38:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 81D0D1F25418
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 00:38:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 927EC10A0E;
	Wed, 16 Oct 2024 00:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="DLByn9ZX"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139FB1097B
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 00:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729039131; cv=fail; b=PGcsw0IxU+Jmnn4DhxeBHOGKqu9umIj8H77BuVl5Q32YQrVMhoSeyC4hKwac8R2g7/LJEH/44YFYVBoWkWwE/EshJ9izavbAoloRWaue4Jx8+OIIvCugDMsaPEo6/MUh0UCg47tC46PgTHIx2Z9MwYHM7jgxKafF8VYhNV/4RhE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729039131; c=relaxed/simple;
	bh=JEJEokcOCc05jtJsubXuaCfG17CCGx3VZOLL4a2JKwI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=lgDToAY8lkSJ6wBtw3XdL1vN4a0ZcrBsegylrcqJbYXbVCJ7EH2ZFVdfxH56vMmNM7ynitTZO3jeLMs2Um4z4ceTk4FkLZpmant9swUsrc2vdubxUolYR4ydCEMYLHQskyFTv0M0kBbBDkMGHz7CNbVPv4NfGlwifX6dn0ws/Xc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=DLByn9ZX; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173]) by mx-outbound17-97.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 16 Oct 2024 00:38:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wn2h49Rqdd7phDBFZdx11PcMMXHWY47lXb6F2spItImBhZkRD8q/aUAk4eoiRvpJ306Gjl/HYZ2qPi28tigyCkB3fXnuH9oyTJROhNN8AHMrDIFWOZERiWcM2CfEUbsDUEZ3N2YGhrBJ3s1JNM3A1+tMnsH1LNfYigvoCi3wOaABBLE6O8uPFaXP74CqbAHaf4YcK47cfBAgwZ9P0wauA+YfsflsdNChHY2gkVe40IkMaPoNwGlDEDeXlPt+ut1JSc4+yCPkL/bw7Cgh5T7fs1sWvx/K3NA69XnOl10D/X1n0gi8iMdJWnokjuIitJPJXfO4r9IciBp+Ai6B3Fp4fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y4HGVIpBllPu0xVIkA4Sr+ZgSNQ3TER0bdtjkdpsSbU=;
 b=TJix/MqIXtu750sUku+RM7cFZRMBu5OasMrf4O1EoHfR705HcRvIYQj8XllSYQ8b4lRQ8pb1VueEW3oHM6UFpmXgE4kLMsSwL5LjwqurQaTW2BiEy5UY8gPxhwerwXo6l3GnFiwhDn68YLJyxELiQn9UMhHNKT1swUvGX5iIXX4QMSMb5QhJ9na/zWidveP+YL6me242/i4v03uRpg9wYWayOMGj5XiDBdNR9m8MqxpOyh7Dlp9kg00vg08mK+/pjloVPOb5ZUJs2Wu9G/rPVneFcxcxwryYYyJ5JYOVdIom3Giby591fFtejv4hHIkQ8aXWHcaCY6dr4ONn6JrB2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=ddn.com smtp.mailfrom=ddn.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=ddn.com; dkim=none
 (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y4HGVIpBllPu0xVIkA4Sr+ZgSNQ3TER0bdtjkdpsSbU=;
 b=DLByn9ZXN/yUQGdHIO6dBm/cv+f0Bjrz/zF4YlD+VYX4DvsLk5EdE3dwRBKAg3Ap5MI6aJmS0/hXYY4Gl/2yftQQgxWE1iOmbK3pT1hIq4KipqrRBhQ++EzFj/0RTlm2wQhsv0q94QDQ5G/WCMDhQi1KMYY67zcGQE7aLjNuWpo=
Received: from BLAPR03CA0106.namprd03.prod.outlook.com (2603:10b6:208:32a::21)
 by IA3PR19MB8592.namprd19.prod.outlook.com (2603:10b6:208:524::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26; Wed, 16 Oct
 2024 00:05:38 +0000
Received: from BL6PEPF00020E62.namprd04.prod.outlook.com
 (2603:10b6:208:32a:cafe::19) by BLAPR03CA0106.outlook.office365.com
 (2603:10b6:208:32a::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.18 via Frontend
 Transport; Wed, 16 Oct 2024 00:05:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 BL6PEPF00020E62.mail.protection.outlook.com (10.167.249.23) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8069.17
 via Frontend Transport; Wed, 16 Oct 2024 00:05:38 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 2EDEA29;
	Wed, 16 Oct 2024 00:05:36 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Wed, 16 Oct 2024 02:05:24 +0200
Subject: [PATCH RFC v4 12/15] io_uring/cmd: let cmds to know about dying
 task
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241016-fuse-uring-for-6-10-rfc4-v4-12-9739c753666e@ddn.com>
References: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
In-Reply-To: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Amir Goldstein <amir73il@gmail.com>, 
 Ming Lei <tom.leiming@gmail.com>, Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1729037122; l=1907;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=+fzHnSTkiWQEiYWdcON6N8NsnwP07vKgm8D+2K3HAhk=;
 b=lvykcPLOz0+E3lvcXwhaBJsNTfIWpVbAAgFu4RQ2eudgqOaPJRb/85cnvaK58SQsZu+F8MXoz
 GwppeW90uheAOxnHz2+hpInD/JOGPEnoAmzNiPwi/2gNUyf9rSYCUT4
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E62:EE_|IA3PR19MB8592:EE_
X-MS-Office365-Filtering-Correlation-Id: 204b4fc1-ad94-44fa-ab39-08dced764434
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cjB0b0hvc0hwWnlEb0NQd1dHellpdWF3VzB6SFBmU08zK0lGcHRzd2tSTUhq?=
 =?utf-8?B?NEJ3NFNDNjBsdDNIK1RBNnhpeGdqcElCclRTNzgwaHhmU2x5WmlobjJjWGp6?=
 =?utf-8?B?UUNHMW5FTmhKdHk4NHhzUTFhNEZQWHh3d3I5TFVSWEJ0MktZcExlTWFrZFJP?=
 =?utf-8?B?UDMrcjkyYit5eWRNaEg0NzdPanVoNFQ2ZldyQnJ3eHkwMzJ6cXYzNnNlb0VF?=
 =?utf-8?B?aGZPVWxKWlRMUWhOd0gycWl3TFFPa3NSdHhwUlF2S2lIVHpXY2RJSjZCTVIx?=
 =?utf-8?B?dWlQTTlnZ1dVT1pyMmt0MTJDaGh3WHpQYWhmbUgxVzZCMmFlZWdtaDVrRDdn?=
 =?utf-8?B?N2RXcDVBMHFMeFhHQnpESEVsck5uOXc2a3hEVmxHRDhnWTZFZTFkYTVuM3px?=
 =?utf-8?B?QzE5aDU0emVkY0ltWlMvRFNuSk9WQTdZcHh3NnU1QmE4RXV5cmdEMjQwYWZj?=
 =?utf-8?B?M1NBWC91bmJJcEVNZVU4djhEMWJKR2lmWEtEZGVOZWo3dmZPdHdGRnRaNm9O?=
 =?utf-8?B?elhDcThIdHhqYnlRZk1zcEZ5SDh4RTRNbXFBazdFK3BpakRCSlc1RTZKQ2cx?=
 =?utf-8?B?cUdyMGpkSnpPU0cxQjVlRmpKeEVQQU4wZzgwWFRPb2pyK1hrVy9FYUh1Nnd1?=
 =?utf-8?B?bHhWSlpSZHpuY0JORGhhbjlQdEZzMlVuZDNKQ2RTeDVSNXlOOXJTUE5JVzV6?=
 =?utf-8?B?YmFuMDZMVHMzOEoxaVZPSFFKcnV3ODlXVmwyRGYrNHgzUlc3MkMreFFNcG51?=
 =?utf-8?B?NGlCR2c4Z3hxUEp3bXRKSWFxNzlVMVNJVTQ0THVWOW1XZnJtVnNjY2xpSGxK?=
 =?utf-8?B?czJtcmV0N3NnV09lbVJDb2YwTzcvcjk4UHVtUWtiUURzODNGOE5jOFdab1pS?=
 =?utf-8?B?dFhwWVA2bkJkc1pXdkRuWnBRbTc3ODZLNkxQN21pbzBzVGZCeStOWGRWR2hp?=
 =?utf-8?B?ajEva21jWkxNY3ljYTRjTy9UYkFONUVpQVRONnlsN0NDUmF2ZkViR001cldj?=
 =?utf-8?B?QXNuYVAwSTNtOFNXR0k1UlJ4ejA5d1V1SWdKNis1dHNIWHlvTUxSWnF6ZkNi?=
 =?utf-8?B?ZWpiVzkxU1VQd0h0M1NHVlRQRWNXRER3aDZ2MW5XSWN1dDVQeFltc3NwZTNU?=
 =?utf-8?B?MkV2MHRrMHN4Y2VjYWNqcnYyeVQyTlh3c0l3WitWbDdTWFZSaVZYcWwxS2Ny?=
 =?utf-8?B?eUtVWHo2V3poTjl4c043Q1ZxNjhGOTVvZzRjWTdtTTJUR0Rxa0VIZVY3WkR1?=
 =?utf-8?B?eE1RL0dtTU1PdFNTVWM2WVJaVHJQbWRMTkNSWU1IVjFnWWU4ZS9SL09yT3Vn?=
 =?utf-8?B?bmtybXRLM1YzeUFLV1pNRjN0TXA0N1lOays0d2ZnTEdTQmZHN3Bwb0R1RURC?=
 =?utf-8?B?Z0w2S0hJZ2h5alFtL2lmMXdnTFRLK0tUZUdwQVE5K2o0MThoeG9uOE1QRXJn?=
 =?utf-8?B?cGQzMlJsZWJuQXU3MERIVnp6blE0ZFNCTXR1Y21qUmp2WWx4T0llc295Y1lR?=
 =?utf-8?B?eWJkQ2JMYytLdDNUT3Fta1NwSGQwUDdWU3UyWTdjMktiaVQxT3NwbStaVXB1?=
 =?utf-8?B?VmNVU1k2YU1XRFlLdGpzT2EwZ0VSYnhxMS8xVHcyOGNEenV2V3VDRDA1ZGt2?=
 =?utf-8?B?b3dYa2J0VWhnM3FaUFlTc25vc3JMWXRUKzZPSlg1bWk1WTdFNWp4Z3dGMjY0?=
 =?utf-8?B?MDdyNDVqK3dLSE9PaDVXZ3NsRG4ybWJ3enpuc3c3Sng0NUEvalE3dTRrSWxO?=
 =?utf-8?B?L0ZFaUh0WGxIYkU1UHpYc3pIR1BzNklrQ3pVWUVuM0VBK2g3YStxV21oTzlM?=
 =?utf-8?B?NkdTYnNXa1pWMVpCTGpMWDVoSTRzbG5FUEJnclRIRHBialNvNkF0SC84ZU1E?=
 =?utf-8?Q?tluh/w8Vgi88y?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VWoubJttg2/cQ4dbgRowpwZDZHCa0lO20d1mXi9QVNvl2RysZ+ZscgCmq0BkTjmFUdtnuqFClLVf1BFgyiABvgQpLTxGzY9mofKq4jV9LWh1GwMyDNs5B/RWaSOUJcj92zr82HqZfFlVur7A6UfAepxf2aRMVdIz8KPc3EkHPbsQHQfUkMYz1aJwBgEYoUxPAWaWn20gkVe8uxR0CAOgo3YDmzqn7MgxqQLgkdBZXL0sGEboO3hUfplPdiWqawoLyE552/sixqRhrEOb9NchM6i3P+LTQCfqytnUXepCTWjTZqEYLu0i4IE1eD2w09eiwhr+eI5yN56OWbt668H/ulnOEJQlupPS4WicilgK2dW6TFU4dPebTBigJ4JIj5jSzBGZyOD4daMtX3BCmw+PA+ZbLWt+26iUH6U8aYb3jhVf0cZIHYy32JnJ9mSasvOQEoixbDD+hl2Xge5L8MI7WWAQUm5gBFkjjYXQ73O/DRZ+fAUTFIO8Zu0lM8VK2Bb/KvIaQIMa3gB8HibQIPXtSHxfVE2xGRbRWSPa96eBQjjV1FVrQVi9ff9SBsshnDIAbbqR3ZbxGKVc8Xsxif4eFjwIlQg5W+jnpd21/5jvQy1c3qBNjYJA5UWPn2MbB+l6F97w6ErgR/5fbB5TBG5KOg==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 00:05:38.4587
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 204b4fc1-ad94-44fa-ab39-08dced764434
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E62.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR19MB8592
X-OriginatorOrg: ddn.com
X-BESS-ID: 1729039128-104449-26725-16014-1
X-BESS-VER: 2019.1_20241015.1627
X-BESS-Apparent-Source-IP: 104.47.59.173
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoaWBhZAVgZQ0NDYLMnIJC0pMd
	EizdLAxNLEzMTczNzQNM3I0tQ8ycBUqTYWAFYIL05BAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.259752 [from 
	cloudscan20-140.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_SC0_MISMATCH_TO, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

From: Pavel Begunkov <asml.silence@gmail.com>

When the taks that submitted a request is dying, a task work for that
request might get run by a kernel thread or even worse by a half
dismantled task. We can't just cancel the task work without running the
callback as the cmd might need to do some clean up, so pass a flag
instead. If set, it's not safe to access any task resources and the
callback is expected to cancel the cmd ASAP.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h | 1 +
 io_uring/uring_cmd.c           | 6 +++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 7abdc09271245ff7de3fb9a905ca78b7561e37eb..869a81c63e4970576155043fce7fe656293d7f58 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -37,6 +37,7 @@ enum io_uring_cmd_flags {
 	/* set when uring wants to cancel a previously issued command */
 	IO_URING_F_CANCEL		= (1 << 11),
 	IO_URING_F_COMPAT		= (1 << 12),
+	IO_URING_F_TASK_DEAD		= (1 << 13),
 };
 
 struct io_wq_work_node {
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 21ac5fb2d5f087e1174d5c94815d580972db6e3f..82c6001cc0696bbcbebb92153e1461f2a9aeebc3 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -119,9 +119,13 @@ EXPORT_SYMBOL_GPL(io_uring_cmd_mark_cancelable);
 static void io_uring_cmd_work(struct io_kiocb *req, struct io_tw_state *ts)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
+	unsigned int flags = IO_URING_F_COMPLETE_DEFER;
+
+	if (req->task != current)
+		flags |= IO_URING_F_TASK_DEAD;
 
 	/* task_work executor checks the deffered list completion */
-	ioucmd->task_work_cb(ioucmd, IO_URING_F_COMPLETE_DEFER);
+	ioucmd->task_work_cb(ioucmd, flags);
 }
 
 void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,

-- 
2.43.0


