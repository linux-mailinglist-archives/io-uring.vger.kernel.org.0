Return-Path: <io-uring+bounces-3714-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BC3299FD49
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 02:40:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BB3C91F258C7
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 00:40:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E48571097B;
	Wed, 16 Oct 2024 00:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="lCv3C0dG"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044D31078B
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 00:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729039209; cv=fail; b=QxsGlgI6YCiBEWypc0SVSvuyHizhBl1ZjOdKzWdoH7nGw8cM8onz3HmNLU+O4qaWHOJXf5f/fUYlGWSncFDpbg6L1ehLxqloeP3RNKW1PO+IzJ/FR2y0SyDSDu8gBnigI1+9UD35aKzlPcvcOTAm39pCGjCWllfGPTs2AK0pVqI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729039209; c=relaxed/simple;
	bh=bMP2JIFlayPyBgELylas5hqmzcJTK3hYSmxuEgReymI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=dyERXgcD6LSEcgGOVVndlEC2CMaidsF1kUCt0YTHC6NH214Mpti8HgPZ5lPo3USUMlXf/dxomtvrLvibmwSYGBX0Rjge+lulKSXY6cPKsppi8j5fu7/AdlNhxc+s79SGJftJFCGQ+YItjdtVFxHgYnKHXKTZ+lxt1SOy8YTjwSY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=lCv3C0dG; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48]) by mx-outbound46-22.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 16 Oct 2024 00:40:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v0+nPfW6FzgO8SxD7XmejIULNysL6PAXAZgKoCpfF4pPN0M053yLnYhrzGvVDVvEBn5uPnxqQJU1gkT4yDL6o2krEtQv1dlEL8173l0NPMR65K2B+rzzYCt5CAABAw5Py7HkZie2OPcT9htzSsXBipKHvxVCZCTauNzKznLdHn2BLca201SdDdyxYcB2JgqTe3cF7TB86zh8/03nWcotBFfm0N4UtoBh+j9O6PNr7OfFOGz+S/PDvSDwficnoLxzR8Yn2nuqI9CYxaYXivjQsVQd0bKpUd4KEXcqJZweE4lqb4foyHJ2qayBrZ8/Zh8r50pIKi2DBztZZw1KaGa35Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O+4PJU9GrAmjg23YbohJMHlXW+2NaOlc5yOcApaQ+/g=;
 b=edZySJREB3U0k8ixPYPBndgXuVnKylZgA2rDRT374hr8E03F3dfPp7EITWMU7eY7YfPc4Wbq2LwUwgmge4ZB6d82LrZhAXiQt4NBRG3PxjGoOFRsf/IhtjklkIrC+boGda6juXT/mbA2Lm3Nx7v511cf6KXa1UJXgN7GnGNCwIwH0pVKQunHCFi2cR3pdT4ibirRN/cACJ3j4aV+50xPATKGZUUkDCihiwCD13mvxIQRXC/pSuUhH1bGZwQXaYCLBfgwS0XG58lhGMCdSOTb54/jPcmZTfPOdEcuK45koTQmjjpbIb8LxIsAN7MWZAyK21bTE+N1Q8n+VwA2uDCazA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=ddn.com smtp.mailfrom=ddn.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=ddn.com; dkim=none
 (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O+4PJU9GrAmjg23YbohJMHlXW+2NaOlc5yOcApaQ+/g=;
 b=lCv3C0dGzxCH1M0nDck1lwthNJ+rgtU2Pz2bMF4ZorG0FqUKnjAv8bn2wFQzLdKkD1isw24YVxg/Gs9tu+44BRfl0vQZepYkaSQBFgie0r5rSMQpDNI4/EAL3UU3LAQWG2/vx6SZYBNo5NnWMQsKSp4R100QaQ/bd7Wa7ccg/TM=
Received: from SA9PR13CA0033.namprd13.prod.outlook.com (2603:10b6:806:22::8)
 by CY5PR19MB6267.namprd19.prod.outlook.com (2603:10b6:930:25::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.17; Wed, 16 Oct
 2024 00:05:29 +0000
Received: from SN1PEPF000397AE.namprd05.prod.outlook.com
 (2603:10b6:806:22:cafe::8c) by SA9PR13CA0033.outlook.office365.com
 (2603:10b6:806:22::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.17 via Frontend
 Transport; Wed, 16 Oct 2024 00:05:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 SN1PEPF000397AE.mail.protection.outlook.com (10.167.248.52) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8069.17
 via Frontend Transport; Wed, 16 Oct 2024 00:05:29 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 6CB047D;
	Wed, 16 Oct 2024 00:05:28 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Wed, 16 Oct 2024 02:05:17 +0200
Subject: [PATCH RFC v4 05/15] fuse: {uring} Handle SQEs - register commands
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241016-fuse-uring-for-6-10-rfc4-v4-5-9739c753666e@ddn.com>
References: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
In-Reply-To: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Amir Goldstein <amir73il@gmail.com>, 
 Ming Lei <tom.leiming@gmail.com>, Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1729037122; l=15621;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=bMP2JIFlayPyBgELylas5hqmzcJTK3hYSmxuEgReymI=;
 b=5ZKkP74CKZQZrhpe7lko48Ifu8wmnlkl/g06xtUVICQasihxiNV6PxRxH3JOXsHM9jpElF3ng
 p0vGexU8uLQCHpen5jN7Da21ablPxENNZ/dCW3wj6DgSkwev5suV7DR
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000397AE:EE_|CY5PR19MB6267:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ea3c45e-3985-420d-d6f5-08dced763ebb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bmN0d0VoRmFQT0Rwc1JRbFlPbklxc1JieFRLRFhRMWJjWS9ZNFNseXZaMCtr?=
 =?utf-8?B?WWN5ekFBVkdld0Q1aWFxakhpQnlqL043UHM1S01jelhLbytBSXVYdXpIdEZ0?=
 =?utf-8?B?eXN6amt6MitNSGxEN1pENHdLMHZsdWdKU2NjSFZxR1VlVDY2UWtxMm1PN0p5?=
 =?utf-8?B?aWlTZ3VnZUIwMWZvY2s2NzRQM09uV3J1aDdkUFpCU2IrMnVSMTJoa2VOUGdk?=
 =?utf-8?B?enhCRzRKdXlSWmJNa1p4M09Ca1FaVVg2anBrSk1iTXJUeFZWUjJVZklZSEJG?=
 =?utf-8?B?MFlGelI3NXJ4cFJqR1pXWGpTWWMxWmVVd1RDNkJNQ2I3Q1JuV3JpUVJxSWlU?=
 =?utf-8?B?eEhaaWFkZm9aTlppVzFqYmF1NjFQK1BrZ09heFNlUEJITTVkclN5SW5jYlZn?=
 =?utf-8?B?YkdzK3hrcDJySGNFS01LL0hoUE9yZDlabkpJZUkwSnBiMW45NkppVktWWWs0?=
 =?utf-8?B?Z0lFdjdQem5sUGlBc1VlT0lwUHlxeE1jUG1wdVV4MlJ5b1F2d3h1ekJibzJj?=
 =?utf-8?B?R3Z4UHA3eDBiYnlDdURpYnB5K2JTYUNyWTcxUnZ3ZnFGR3V0VmExcG9hQkpt?=
 =?utf-8?B?aWtBeTF4NGlwQ1pGUFpwb3daMVN0TE15aS9yTXVIYzFmTnRpM1Jic3ozN0gv?=
 =?utf-8?B?TmwxYlFWWlZkYU1nM0ppaFJmSnh1Y3FBd2ZxZGpFVmc0aUo1NUsrQ2pRdExH?=
 =?utf-8?B?S2VRWHVzajcvbGZORGg0R3NZWDlxdTcxQmd1bC9GMkxlOUZxb043RVdweEM4?=
 =?utf-8?B?US9Mc0tkbUZkSURwb0NmUkJPejc0SWU3YlRqeG9VQkV1dmljMkFuZ3lVWlFB?=
 =?utf-8?B?SUZ2TkE2WCs4Vk42SUNFT0k3VnNYM1dPNDB4Vjl6U3lqWEVoWTFDTnBJbjVl?=
 =?utf-8?B?MVh4TURkN1VFQ0RJUjNadHdtMDNPb0d1cCtZOFRtVFlMaGhtc1JTNU5XQnpW?=
 =?utf-8?B?ejJXbVpORGQ2UUkyM28vN0lCbmJYSHJzak55NGhvOUVrY0JGRVpySS80eGZP?=
 =?utf-8?B?Ry9kcXF4REE1bzcxMHh2OG80OEkzMVA1bmVNN00xZndjdkJTZGRFTzNNNjBT?=
 =?utf-8?B?ZGJnOWVrVmVVMzdRR0Z6UlMwOWQxMDdURUh1Y2JzTnNpOXgwbHk1UDA5VEZm?=
 =?utf-8?B?Sm5MazFEb3pIT1drdFFaL0IxcXNKczVVcVBFeElWOXhlZW1RUS9YMUg5U3RJ?=
 =?utf-8?B?aUFpYjlxYUNJOEpBLy8ySmt3ZTFIZXM0dFRoanNhS3hPNHJlUDEzbWI5ZThz?=
 =?utf-8?B?Nkw5VTY3NGFJanVLVVF1VzhlbzBOVHMzcFpOUURueFlDc0Zqcm8rOXhpeWVv?=
 =?utf-8?B?ZlVrWjNYdXQ4clljQlVCSXN1dkNlbjhJSFJsTGVnMFk1T1RQTW5rSTRla1VW?=
 =?utf-8?B?cDRnayticUsyZWtadlpUTXJMeVZac3lNcXEvOVAyT29Sc01ZRTBZOXdqQnZE?=
 =?utf-8?B?dW5ua0J5QU5hSmFNRmc3cTBzOWVaZDBuNFNJMjRzY3d6TFJXMndYZ3VqWE5G?=
 =?utf-8?B?MzFTRlhvTGVsckRaVW83QjByYVFIRm9wNlhOR0FuS0dkL2R1bWVRREJEdDNy?=
 =?utf-8?B?UnVyWFN1dTloN2ZOUDJqeC9MUHBpRlloQkVLWkVFdk5Fc09tMFdYTWdVMzlu?=
 =?utf-8?B?azQxbDV2Tnd5NGZTWmRTcDdSQ3gzcno0dXRrcFRQZ2tWWVNSZVFsUnlsaHhs?=
 =?utf-8?B?VW1uSHdZZkVhb0hHYU5QRGQ2OEhjTk0rdXNVL2d1SEw5YXJteTIyRVpuVStY?=
 =?utf-8?B?UVdsZ21VY09FUU9naGtSUXJOMGtSTDk3cG4vOFZJR1hETWJXMXNDbzMyVm5V?=
 =?utf-8?B?T0UxRnoxUWdULzJ6NTlvZTVLb1FPcVY4UFlEcDBWUzhBTVMyaXRwUVl5ZjZ6?=
 =?utf-8?Q?eNE8KCOtXTZ+B?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nJxTEUE+FmeMJ299o1WNLLcFOvjpRSpwvx7o9CBI3hlRCuw1Xks+LTeYYRbRiFSKGGHQLpX9dDvPpVxQl6yw6jjsgzUXDej7CE687YPiGjcdS9D1w7oCSEKlkXE4l8mBlhfFz/vN5NAst7OZNv1ErtnhB5bf/8ya1ZxROYEuydYz85QQo/8GrHifai46gyFy497LCjZC7OtL1OoY7PD5b/XqIs4OyKjYYbGZxiC8kytV0tPPs76Jt9f2kE8Esdg5RwID8qJ/ciPWkRnvH8RvcaZMJBDrCKt4rIlaRoO63hO2JsDr6DLoCDmurRpTkCBh1cajM6yi0M1TDlT+8AhdiiRt1rtNpAfQqiAX9FdWNogqZQW9oV3kvn41d+iVWS59lsOScpjk2FP3VgDtMgS/edMxYdjdLwPhaZg9dYxAaBbB1XRjFE1oNDylILL8P+rwFlCeB6C24mE6iiAqUP2YcWV92H+uvonI7rZpdKo0XrZNuofjBE7GQulPQxyix71ChqJDVJp2ytl8q0K+Gu6UxvjRFB3n45i6WixP6+JBaELK5rH8d5BdFAcK8FW78kVrQ5IfRArwYpz/w0rdZtTHvI5chCeksA9VodxHbY5Oo+mDksUiJKOkeECV9sDJdYFKbd4rVpdcEf/3omlpT2Yaeg==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 00:05:29.3251
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ea3c45e-3985-420d-d6f5-08dced763ebb
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397AE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR19MB6267
X-OriginatorOrg: ddn.com
X-BESS-ID: 1729039205-111798-10775-61302-1
X-BESS-VER: 2019.1_20241015.1627
X-BESS-Apparent-Source-IP: 104.47.66.48
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoamBgYWQGYGUNTMJNnE3NwkMT
	kl2TLZKNHc0DTNMNnC3MzIwiglxdLQTKk2FgCc6+8CQgAAAA==
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.259752 [from 
	cloudscan12-129.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_SC0_MISMATCH_TO, BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

This adds basic support for ring SQEs (with opcode=IORING_OP_URING_CMD).
For now only FUSE_URING_REQ_FETCH is handled to register queue entries.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/Kconfig           |  12 ++
 fs/fuse/Makefile          |   1 +
 fs/fuse/dev.c             |   4 +
 fs/fuse/dev_uring.c       | 297 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/dev_uring_i.h     | 105 ++++++++++++++++
 fs/fuse/fuse_dev_i.h      |   1 +
 fs/fuse/fuse_i.h          |   5 +
 fs/fuse/inode.c           |   3 +
 include/uapi/linux/fuse.h |  70 +++++++++++
 9 files changed, 498 insertions(+)

diff --git a/fs/fuse/Kconfig b/fs/fuse/Kconfig
index 8674dbfbe59dbf79c304c587b08ebba3cfe405be..11f37cefc94b2af5a675c238801560c822b95f1a 100644
--- a/fs/fuse/Kconfig
+++ b/fs/fuse/Kconfig
@@ -63,3 +63,15 @@ config FUSE_PASSTHROUGH
 	  to be performed directly on a backing file.
 
 	  If you want to allow passthrough operations, answer Y.
+
+config FUSE_IO_URING
+	bool "FUSE communication over io-uring"
+	default y
+	depends on FUSE_FS
+	depends on IO_URING
+	help
+	  This allows sending FUSE requests over the IO uring interface and
+          also adds request core affinity.
+
+	  If you want to allow fuse server/client communication through io-uring,
+	  answer Y
diff --git a/fs/fuse/Makefile b/fs/fuse/Makefile
index 6e0228c6d0cba9541c8668efb86b83094751d469..7193a14374fd3a08b901ef53fbbea7c31b12f22c 100644
--- a/fs/fuse/Makefile
+++ b/fs/fuse/Makefile
@@ -11,5 +11,6 @@ fuse-y := dev.o dir.o file.o inode.o control.o xattr.o acl.o readdir.o ioctl.o
 fuse-y += iomode.o
 fuse-$(CONFIG_FUSE_DAX) += dax.o
 fuse-$(CONFIG_FUSE_PASSTHROUGH) += passthrough.o
+fuse-$(CONFIG_FUSE_IO_URING) += dev_uring.o
 
 virtiofs-y := virtio_fs.o
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index dbc222f9b0f0e590ce3ef83077e6b4cff03cff65..8e8d887bb3dfacec074753ebba7bd504335b5a18 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -6,6 +6,7 @@
   See the file COPYING.
 */
 
+#include "dev_uring_i.h"
 #include "fuse_i.h"
 #include "fuse_dev_i.h"
 
@@ -2398,6 +2399,9 @@ const struct file_operations fuse_dev_operations = {
 	.fasync		= fuse_dev_fasync,
 	.unlocked_ioctl = fuse_dev_ioctl,
 	.compat_ioctl   = compat_ptr_ioctl,
+#ifdef CONFIG_FUSE_IO_URING
+	.uring_cmd	= fuse_uring_cmd,
+#endif
 };
 EXPORT_SYMBOL_GPL(fuse_dev_operations);
 
diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
new file mode 100644
index 0000000000000000000000000000000000000000..724ac6ae67d301a7bdc5b36a20d620ff8be63b18
--- /dev/null
+++ b/fs/fuse/dev_uring.c
@@ -0,0 +1,297 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * FUSE: Filesystem in Userspace
+ * Copyright (c) 2023-2024 DataDirect Networks.
+ */
+
+#include <linux/fs.h>
+
+#include "fuse_i.h"
+#include "dev_uring_i.h"
+#include "fuse_dev_i.h"
+
+#include <linux/io_uring/cmd.h>
+
+#ifdef CONFIG_FUSE_IO_URING
+static bool __read_mostly enable_uring;
+module_param(enable_uring, bool, 0644);
+MODULE_PARM_DESC(enable_uring,
+		 "Enable uring userspace communication through uring.");
+#endif
+
+static int fuse_ring_ring_ent_unset_userspace(struct fuse_ring_ent *ent)
+{
+	struct fuse_ring_queue *queue = ent->queue;
+
+	lockdep_assert_held(&queue->lock);
+
+	if (WARN_ON_ONCE(ent->state != FRRS_USERSPACE))
+		return -EIO;
+
+	ent->state = FRRS_COMMIT;
+	list_move(&ent->list, &queue->ent_intermediate_queue);
+
+	return 0;
+}
+
+void fuse_uring_destruct(struct fuse_conn *fc)
+{
+	struct fuse_ring *ring = fc->ring;
+	int qid;
+
+	if (!ring)
+		return;
+
+	for (qid = 0; qid < ring->nr_queues; qid++) {
+		struct fuse_ring_queue *queue = ring->queues[qid];
+
+		if (!queue)
+			continue;
+
+		WARN_ON(!list_empty(&queue->ent_avail_queue));
+		WARN_ON(!list_empty(&queue->ent_intermediate_queue));
+
+		kfree(queue);
+		ring->queues[qid] = NULL;
+	}
+
+	kfree(ring->queues);
+	kfree(ring);
+	fc->ring = NULL;
+}
+
+/*
+ * Basic ring setup for this connection based on the provided configuration
+ */
+static struct fuse_ring *fuse_uring_create(struct fuse_conn *fc)
+{
+	struct fuse_ring *ring = NULL;
+	size_t nr_queues = num_possible_cpus();
+	struct fuse_ring *res = NULL;
+
+	ring = kzalloc(sizeof(*fc->ring) +
+			       nr_queues * sizeof(struct fuse_ring_queue),
+		       GFP_KERNEL_ACCOUNT);
+	if (!ring)
+		return NULL;
+
+	ring->queues = kcalloc(nr_queues, sizeof(struct fuse_ring_queue *),
+			       GFP_KERNEL_ACCOUNT);
+	if (!ring->queues)
+		goto out_err;
+
+	spin_lock(&fc->lock);
+	if (fc->ring) {
+		/* race, another thread created the ring in the mean time */
+		spin_unlock(&fc->lock);
+		res = fc->ring;
+		goto out_err;
+	}
+
+	fc->ring = ring;
+	ring->nr_queues = nr_queues;
+	ring->fc = fc;
+
+	spin_unlock(&fc->lock);
+	return ring;
+
+out_err:
+	if (ring)
+		kfree(ring->queues);
+	kfree(ring);
+	return res;
+}
+
+static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
+						       int qid)
+{
+	struct fuse_conn *fc = ring->fc;
+	struct fuse_ring_queue *queue;
+
+	queue = kzalloc(sizeof(*queue), GFP_KERNEL_ACCOUNT);
+	if (!queue)
+		return ERR_PTR(-ENOMEM);
+	spin_lock(&fc->lock);
+	if (ring->queues[qid]) {
+		spin_unlock(&fc->lock);
+		kfree(queue);
+		return ring->queues[qid];
+	}
+	ring->queues[qid] = queue;
+
+	queue->qid = qid;
+	queue->ring = ring;
+	spin_lock_init(&queue->lock);
+
+	INIT_LIST_HEAD(&queue->ent_avail_queue);
+	INIT_LIST_HEAD(&queue->ent_intermediate_queue);
+
+	spin_unlock(&fc->lock);
+
+	return queue;
+}
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
+	pr_devel("%s ring=%p qid=%d state=%d\n", __func__, ring,
+		 ring_ent->queue->qid, ring_ent->state);
+
+	if (WARN_ON(ring_ent->state != FRRS_COMMIT)) {
+		pr_warn("%s qid=%d state=%d\n", __func__, ring_ent->queue->qid,
+			ring_ent->state);
+		return;
+	}
+
+	list_move(&ring_ent->list, &queue->ent_avail_queue);
+
+	ring_ent->state = FRRS_WAIT;
+}
+
+/*
+ * fuse_uring_req_fetch command handling
+ */
+static void _fuse_uring_fetch(struct fuse_ring_ent *ring_ent,
+			      struct io_uring_cmd *cmd,
+			      unsigned int issue_flags)
+{
+	struct fuse_ring_queue *queue = ring_ent->queue;
+
+	spin_lock(&queue->lock);
+	fuse_uring_ent_avail(ring_ent, queue);
+	ring_ent->cmd = cmd;
+	spin_unlock(&queue->lock);
+}
+
+static int fuse_uring_fetch(struct io_uring_cmd *cmd, unsigned int issue_flags,
+			    struct fuse_conn *fc)
+{
+	const struct fuse_uring_cmd_req *cmd_req = io_uring_sqe_cmd(cmd->sqe);
+	struct fuse_ring *ring = fc->ring;
+	struct fuse_ring_queue *queue;
+	struct fuse_ring_ent *ring_ent;
+	int err;
+
+#if 0
+	/* Does not work as sending over io-uring is async */
+	err = -ETXTBSY;
+	if (fc->initialized) {
+		pr_info_ratelimited(
+			"Received FUSE_URING_REQ_FETCH after connection is initialized\n");
+		return err;
+	}
+#endif
+
+	err = -ENOMEM;
+	if (!ring) {
+		ring = fuse_uring_create(fc);
+		if (!ring)
+			return err;
+	}
+
+	queue = ring->queues[cmd_req->qid];
+	if (!queue) {
+		queue = fuse_uring_create_queue(ring, cmd_req->qid);
+		if (!queue)
+			return err;
+	}
+
+	/*
+	 * The created queue above does not need to be destructed in
+	 * case of entry errors below, will be done at ring destruction time.
+	 */
+
+	ring_ent = kzalloc(sizeof(*ring_ent), GFP_KERNEL_ACCOUNT);
+	if (ring_ent == NULL)
+		return err;
+
+	ring_ent->queue = queue;
+	ring_ent->cmd = cmd;
+	ring_ent->rreq = (struct fuse_ring_req __user *)cmd_req->buf_ptr;
+	ring_ent->max_arg_len = cmd_req->buf_len - sizeof(*ring_ent->rreq);
+	INIT_LIST_HEAD(&ring_ent->list);
+
+	spin_lock(&queue->lock);
+
+	/*
+	 * FUSE_URING_REQ_FETCH is an initialization exception, needs
+	 * state override
+	 */
+	ring_ent->state = FRRS_USERSPACE;
+	err = fuse_ring_ring_ent_unset_userspace(ring_ent);
+	spin_unlock(&queue->lock);
+	if (WARN_ON_ONCE(err != 0))
+		goto err;
+
+	_fuse_uring_fetch(ring_ent, cmd, issue_flags);
+
+	return 0;
+err:
+	list_del_init(&ring_ent->list);
+	kfree(ring_ent);
+	return err;
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
+	u32 cmd_op = cmd->cmd_op;
+	int err = 0;
+
+	pr_devel("%s:%d received: cmd op %d\n", __func__, __LINE__, cmd_op);
+
+	/* Disabled for now, especially as teardown is not implemented yet */
+	err = -EOPNOTSUPP;
+	pr_info_ratelimited("fuse-io-uring is not enabled yet\n");
+	goto out;
+
+	err = -EOPNOTSUPP;
+	if (!enable_uring) {
+		pr_info_ratelimited("uring is disabled\n");
+		goto out;
+	}
+
+	err = -ENOTCONN;
+	fud = fuse_get_dev(cmd->file);
+	if (!fud) {
+		pr_info_ratelimited("No fuse device found\n");
+		goto out;
+	}
+	fc = fud->fc;
+
+	if (fc->aborted)
+		goto out;
+
+	switch (cmd_op) {
+	case FUSE_URING_REQ_FETCH:
+		err = fuse_uring_fetch(cmd, issue_flags, fc);
+		break;
+	default:
+		err = -EINVAL;
+		pr_devel("Unknown uring command %d", cmd_op);
+		goto out;
+	}
+out:
+	pr_devel("uring cmd op=%d, qid=%d ID=%llu ret=%d\n", cmd_op,
+		 cmd_req->qid, cmd_req->commit_id, err);
+
+	if (err < 0)
+		io_uring_cmd_done(cmd, err, 0, issue_flags);
+
+	return -EIOCBQUEUED;
+}
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
new file mode 100644
index 0000000000000000000000000000000000000000..9a763262c6a5a781a36c3825529d729efef80e78
--- /dev/null
+++ b/fs/fuse/dev_uring_i.h
@@ -0,0 +1,105 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * FUSE: Filesystem in Userspace
+ * Copyright (c) 2023-2024 DataDirect Networks.
+ */
+
+#ifndef _FS_FUSE_DEV_URING_I_H
+#define _FS_FUSE_DEV_URING_I_H
+
+#include "fuse_i.h"
+
+#ifdef CONFIG_FUSE_IO_URING
+
+enum fuse_ring_req_state {
+
+	/* ring entry received from userspace and it being processed */
+	FRRS_COMMIT,
+
+	/* The ring request waits for a new fuse request */
+	FRRS_WAIT,
+
+	/* request is in or on the way to user space */
+	FRRS_USERSPACE,
+};
+
+/** A fuse ring entry, part of the ring queue */
+struct fuse_ring_ent {
+	/* userspace buffer */
+	struct fuse_ring_req __user *rreq;
+
+	/* the ring queue that owns the request */
+	struct fuse_ring_queue *queue;
+
+	struct io_uring_cmd *cmd;
+
+	struct list_head list;
+
+	/*
+	 * state the request is currently in
+	 * (enum fuse_ring_req_state)
+	 */
+	unsigned int state;
+
+	/* struct fuse_ring_req::in_out_arg size*/
+	size_t max_arg_len;
+};
+
+struct fuse_ring_queue {
+	/*
+	 * back pointer to the main fuse uring structure that holds this
+	 * queue
+	 */
+	struct fuse_ring *ring;
+
+	/* queue id, typically also corresponds to the cpu core */
+	unsigned int qid;
+
+	/*
+	 * queue lock, taken when any value in the queue changes _and_ also
+	 * a ring entry state changes.
+	 */
+	spinlock_t lock;
+
+	/* available ring entries (struct fuse_ring_ent) */
+	struct list_head ent_avail_queue;
+
+	/*
+	 * entries in the process of being committed or in the process
+	 * to be send to userspace
+	 */
+	struct list_head ent_intermediate_queue;
+};
+
+/**
+ * Describes if uring is for communication and holds alls the data needed
+ * for uring communication
+ */
+struct fuse_ring {
+	/* back pointer */
+	struct fuse_conn *fc;
+
+	/* number of ring queues */
+	size_t nr_queues;
+
+	struct fuse_ring_queue **queues;
+};
+
+void fuse_uring_destruct(struct fuse_conn *fc);
+int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags);
+
+#else /* CONFIG_FUSE_IO_URING */
+
+struct fuse_ring;
+
+static inline void fuse_uring_create(struct fuse_conn *fc)
+{
+}
+
+static inline void fuse_uring_destruct(struct fuse_conn *fc)
+{
+}
+
+#endif /* CONFIG_FUSE_IO_URING */
+
+#endif /* _FS_FUSE_DEV_URING_I_H */
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index 6c506f040d5fb57dae746880c657a95637ac50ce..e82cbf9c569af4f271ba0456cb49e0a5116bf36b 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -8,6 +8,7 @@
 
 #include <linux/types.h>
 
+
 /* Ordinary requests have even IDs, while interrupts IDs are odd */
 #define FUSE_INT_REQ_BIT (1ULL << 0)
 #define FUSE_REQ_ID_STEP (1ULL << 1)
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index f2391961031374d8d55916c326c6472f0c03aae6..33e81b895fee620b9c2fcc8d9312fec53e3dc227 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -917,6 +917,11 @@ struct fuse_conn {
 	/** IDR for backing files ids */
 	struct idr backing_files_map;
 #endif
+
+#ifdef CONFIG_FUSE_IO_URING
+	/**  uring connection information*/
+	struct fuse_ring *ring;
+#endif
 };
 
 /*
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 99e44ea7d8756ded7145f38b49d129b361b991ba..59f8fb7b915f052f892d587a0f9a8dc17cf750ce 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -7,6 +7,7 @@
 */
 
 #include "fuse_i.h"
+#include "dev_uring_i.h"
 
 #include <linux/pagemap.h>
 #include <linux/slab.h>
@@ -947,6 +948,8 @@ static void delayed_release(struct rcu_head *p)
 {
 	struct fuse_conn *fc = container_of(p, struct fuse_conn, rcu);
 
+	fuse_uring_destruct(fc);
+
 	put_user_ns(fc->user_ns);
 	fc->release(fc);
 }
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index d08b99d60f6fd6d0d072d01ad6bcc1b48da0a242..b60a42259f7f735f79e8010e5089f15c34eb9308 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -1186,4 +1186,74 @@ struct fuse_supp_groups {
 	uint32_t	groups[];
 };
 
+/**
+ * Size of the ring buffer header
+ */
+#define FUSE_RING_HEADER_BUF_SIZE 4096
+#define FUSE_RING_MIN_IN_OUT_ARG_SIZE 4096
+
+/*
+ * Request is background type. Daemon side is free to use this information
+ * to handle foreground/background CQEs with different priorities.
+ */
+#define FUSE_RING_REQ_FLAG_ASYNC (1ull << 0)
+
+/**
+ * This structure mapped onto the
+ */
+struct fuse_ring_req {
+	union {
+		/* The first 4K are command data */
+		char ring_header[FUSE_RING_HEADER_BUF_SIZE];
+
+		struct {
+			uint64_t flags;
+
+			uint32_t in_out_arg_len;
+			uint32_t padding;
+
+			/* kernel fills in, reads out */
+			union {
+				struct fuse_in_header in;
+				struct fuse_out_header out;
+			};
+		};
+	};
+
+	char in_out_arg[];
+};
+
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
+	/* entry identifier */
+	uint64_t commit_id;
+
+	/* queue the command is for (queue index) */
+	uint16_t qid;
+	uint8_t padding[6];
+
+	/* length of the user buffer */
+	uint32_t buf_len;
+
+	uint32_t flags;
+};
+
 #endif /* _LINUX_FUSE_H */

-- 
2.43.0


