Return-Path: <io-uring+bounces-4960-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 082459D56A6
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 01:17:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD015282CD8
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 00:17:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C82DA15A8;
	Fri, 22 Nov 2024 00:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="j8pGNN3/"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34CD84A0C
	for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 00:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732234661; cv=fail; b=B98NMG5sNGE7q7YnZ0H6ACKVRyl88CdJJPn5w8i/OElg1zyUZTSxjb/rBKgs5lSjQIh7qIXtBpKmUB3fRZOB0kRB4WXDk+7P++flxRDOibDMX4W6vA5oAlEPaAFzcS/mQ7B1tOc+EZnok1Ph/JhDmhO3XJRY6rcj4gT2LfMuQis=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732234661; c=relaxed/simple;
	bh=5tWGsfFqIOTmbzCy1M1YG1Z+pGnTYUdhQKGU5bA4XN8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=s6JqC8MWWXMiP1zwg0eRDNgNRWQrnRdMxqkMX3/iI/4FtsZPYbquYt0FWtUhYhWB2gfJr0JEBaNx73bm9Rvtwk8w5aNRCmR+VNaJgVkQTcuzfu4SGCrOr1v3Qatst7xsGANm6IpzLmJaxVzgSBffcaxN9968mQoJravzppog5bg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=j8pGNN3/; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2049.outbound.protection.outlook.com [104.47.73.49]) by mx-outbound47-192.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Fri, 22 Nov 2024 00:17:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WJ3J2yk6S845xas7aiisHzTCX0vMg0Vq3hUadvIgE7uAhotfeL2juF3ZHkQPJf7aiePE+a6u8UXT8TO0m9V8/a2btp0fMQ8BxYgP2TcZkkUbdP2kGh8+Q++Nny9xRd23OodH1Rk7M1y1CDfqVjDaG2Yy3J771hqe7s2KZu+3dUrHG/2zuKx78lkoiKlQxTPfPXuN7sUUTVHcJSdjtt2AZiYM3ngVSckSqkfLzfw4VPVy3Y/xUQMxCB6WEeiBlpbvF1dWlfHN3hH7441pCeuz3ww1f1/G2GHbIeZfbPM/aKbjyvgUugSBHDPiEhDncjNm02AteKGEfMA0lOf7Opqg7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ic1lWTx2sk0ToMWueKYzM4z+GqjslhRxPuaqXsC8MHM=;
 b=abaj4uw9vx3g52m0FKik5bthz6afvGZijrKf56upoe9zm7aMY0SJrKrPYKKKa7+ZsxENJr7tKaTyckwdBQPOt9YJfB5fzm0MC/YmH5+ygBTKZEnYuFcwD3qZMnNx8mOiYog2EohLuxjHMh3YtKD1ghriMgYQB7RKCEwb+Zg2Qt8koXjZnPSqCrsqGKUIrDyaondm3aDjqlhKalTRbZaLyChuXHjqvJG4VgjO7vHzBofXgKF9GRO+pTAfzw6t/Hwy/zNXNbWZBBVCoRLPjPaIhZuIOpel9IAgZORQci3dFwd3ToQP8bi5yhKdXYlRJDEY47ubjB5ZDdDeHmDPKx7MfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ic1lWTx2sk0ToMWueKYzM4z+GqjslhRxPuaqXsC8MHM=;
 b=j8pGNN3/DSizrzIdSrcj9x1aULBR7laLyECgVWshkJ9pODsDzlDz4hNpCRalQ0rwalUCwhA+TTmlKHTWMoSFJcTyTu4lQ/xGSsY6kJ0gyi/OLmrkaM36GAF3qTurvxAGts/aJ8/L0Kk4v+IxwHzP/UqDcAHV3eQcTYEqSzQmco8=
Received: from DM5PR07CA0094.namprd07.prod.outlook.com (2603:10b6:4:ae::23) by
 BLAPR19MB4563.namprd19.prod.outlook.com (2603:10b6:208:293::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.14; Thu, 21 Nov
 2024 23:43:58 +0000
Received: from CY4PEPF0000EDD7.namprd03.prod.outlook.com
 (2603:10b6:4:ae:cafe::7d) by DM5PR07CA0094.outlook.office365.com
 (2603:10b6:4:ae::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.24 via Frontend
 Transport; Thu, 21 Nov 2024 23:43:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 CY4PEPF0000EDD7.mail.protection.outlook.com (10.167.241.203) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8182.16
 via Frontend Transport; Thu, 21 Nov 2024 23:43:58 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id B75542D;
	Thu, 21 Nov 2024 23:43:57 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Fri, 22 Nov 2024 00:43:24 +0100
Subject: [PATCH RFC v6 08/16] fuse: Add fuse-io-uring handling into
 fuse_copy
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241122-fuse-uring-for-6-10-rfc4-v6-8-28e6cdd0e914@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1732232629; l=2481;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=5tWGsfFqIOTmbzCy1M1YG1Z+pGnTYUdhQKGU5bA4XN8=;
 b=pp/s7/6N4RG2lCoxWv1Xyaw1skp6Bq41fEnqQCizgByQlJG+DVCRO1TdySkBA5gx9WbnaizSO
 SYMdaNysGOgB5dD1JaYIk98em59/DC9pShRQktkPG3PR2ZtaYQnxjzc
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD7:EE_|BLAPR19MB4563:EE_
X-MS-Office365-Filtering-Correlation-Id: 749dd6aa-4728-4794-e2be-08dd0a865e99
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RVl3SnZzUWgxalZmRkpicmNwK2M1d3Z3cE45V0tUOVZLL1hPcFdjSXRzMmdV?=
 =?utf-8?B?ekxpanhzSklJV21WT3dQNUdkN3czYmo5dmQrWUFhSHJmeFJJYTRaY0V4NzNB?=
 =?utf-8?B?bDk0dWQxWi90TmtvN2FGUGorMTFCNU5uN1J2Z1djZmFiWjI3dmVzeGU0NzFG?=
 =?utf-8?B?MzVqeklhTE9vcWVMMmU1V0kxVXZYZ0lkb01Ea1EyRmZwMDNMaytpZE1NZGQ4?=
 =?utf-8?B?b0h4Qk5tTlJtRXd6SWxnWHJDVWUvR1J5VXVZRFhCdEg5SVRoWklyaXRodHBn?=
 =?utf-8?B?RVU4QTNoZHlBN0l3aWhqNm9DWlcxeFZBN25qamxRNnd0aGlIWUMzWXZDUStN?=
 =?utf-8?B?Y2E5a3cxbWNwY1ZQSDcwd2NkeTEzNTdqaFFrYW5FUHBLWkFGdmE2bjNDY21G?=
 =?utf-8?B?eEp4aFZOMzVlR3RRMTNoUll3NkFpaGNGMGZmcHMwWWZDY01Wb3ZSQUw0QUFV?=
 =?utf-8?B?NVhhQThZSzRkWndvc0VZaVNTK0dKcXVTSk05NDYrQzRidjBST3paNVVBRzRF?=
 =?utf-8?B?TnRuaTJJQ2xRSTB2SWl4VlBLYmM0ZHlUc0tsOGhKenorWVFsOUloYXEzZnpR?=
 =?utf-8?B?OWVLSW96V0pLWk5QdU9CNHJDYTVYT1BqQUNlNC9YSk9aZlNtMkMwV0M4bDd4?=
 =?utf-8?B?Y1ZXaSs2WnZRbDNDWERIYzU3VkNvVEZjZ3lTYkVPU0svZXBoTXVla053RGJu?=
 =?utf-8?B?QlhTTlVLTTBEOEo2czRFSDJTcERsNEtWRDlWL0hBUGRTQ1ZTUWQrZmp1YXRa?=
 =?utf-8?B?SUpLMFhYZVJwTW04VGRabDlUN3dYZ05aT2xYUThsSHJqd3RXZFFyZ25iaUtG?=
 =?utf-8?B?NkZmb1FmMVBpTTRtQTlqNVZHYnhYdzFkQXJISXpHcXc3K2NBcTN5RW1PKzNn?=
 =?utf-8?B?ajhmekxHekRJc01RMjg1OEZjVjkvWlNZK0NENEhKQWpEZllIMVBSN1V4WHd4?=
 =?utf-8?B?ajhWM0Zyc3JnREp3V2Foc0hNVHp4c1lKd2crMmV4K29XZk1FTU5wdWpDM1kr?=
 =?utf-8?B?R1RVd0YwczRkcFd4bUFWYzkvMDBtbXhPMkNadFArdFFNV1RJdE1YazBlbTl4?=
 =?utf-8?B?VGVwb0Nrd05YbERMZmxrOW1Yc2hSbDJkQmhrZVVjOGpkbzNGMzllSytIVUp0?=
 =?utf-8?B?S2J0Z2cvS0J3a2VLU0sxOTQvRkJUZUMxcVNsVW1xSDQ5aFJGZWlmenRORysz?=
 =?utf-8?B?ZnVEN2pOeDhHUXZXNXpSQmRCVXhhRzJjVC9aZzlzV1d2cDcxMjhLanRiTytk?=
 =?utf-8?B?clFUR05rYWlYWjRmcWNKYldaY3JIRmcyY0xoc2g5TzE4ckRKSWExcnE2N05M?=
 =?utf-8?B?cTFpQjR4aDhBQVlVV0Q5TnE4cGtKRGpLTVk1MVVhNnA1dHRldkdDc0wxcVJs?=
 =?utf-8?B?WXlDaVVCUloyY3ZpbHRSc1FySC8yU3FuaDI2cXY2OUxSdGNVajl2amhkTll4?=
 =?utf-8?B?cVBxSnZQY0RLR25IeDk2WTdlRW15OC9DUHRwS0VjSWRkL1lqSEdFZkZGMXVB?=
 =?utf-8?B?UEF1UFRTZys2QVZJb3UyNnRZUDl3OXVibnQ5aHNJeXpRWmpreW1TSnVyN0pF?=
 =?utf-8?B?VkJFYUNpeHFUUzlUdm5jclJJNklEMWpPSnpmNXVzaEVleEo0enhpUE9vWnlJ?=
 =?utf-8?B?RkhFc1dUKzJ6Vnk2VjZpMWZYNDZYU3N4RGhONEN0MFdkYTc4NGJ5aERtYmZ3?=
 =?utf-8?B?WDN1Z2t6Uy95cW14VjJVRXpmMVMxZEV4eTJDQmFnZE9oMTRNOHJ5L1JHVks3?=
 =?utf-8?B?RXV3MUtTNVY4Z0lzZ0NoWjJyTE5wS2dZVWk2K2dKbGZwM2ZrRmp3OVJTVElV?=
 =?utf-8?B?Z2N4ZlVCSVZJUWk3OUNtTHZ0bVExNi9kdGpaT3Y2US84M0lzampWYXVrR2ZB?=
 =?utf-8?B?U0dtOTRNNWRGUjRrc0puQW1IOFQyODh0aWdPRVFHZVE2elE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(7416014)(36860700013);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vdjrY47o74wleiFj9FxxZNRLQDovu0JsbIIxgVKRGEjwja0+WN8x3DUfOPX7Qgmhsn7fqt7ieF1nGbH+zdQmbHpjklxUwqllT0b/X+7f4zfywU6L7LcXEACI8DMXe2zD2vDyDboUQrAGrh8R80V6xMZJeBekPfSlHrlibLrYJGL+VrpRdx2JcFmyLhtaZKVKaxOowoTPIvec3VyuxaxMalagR3MLeBXxT23NNy5PZpNirGisshvHgM6dBW3nGjvclQtnuwotfkdTtO5GFDQ8h1mA+2RzZ8k3tX9Mntt4BHIRdLqaFPFHzV6DgYJnyfjyVFFvkPNrtGLl5AnkWktWsYAVc0usN6/h67xwQkhTDf92MpaVcgdDPxOWHjFjPAatZBvhF7SvAqfiGwGmkUxKd3B7ukg5+F8/e0F0B4Q5dqIlyE96y0GBiXP1MR8Xi43RPSp+l2lvaswp+so9/YlUb5cFryz/8iY+zkdvwyOrGoMLryr8hxSMYwDP3dxZteCf98dM1fkBJoXSmjAGSM1lvZvjLRhn9neAYCeOTqaSITdBxNeMjOtkz+9Er5EDnLI/EoUIB4BeT3YT3k9C1lpwPTIPamMv84J6WCOAu+M52lAEQZSQ+J/eJwQ6AoJec62P4ORkmxcKLIcrW3mowAnv4g==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2024 23:43:58.4892
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 749dd6aa-4728-4794-e2be-08dd0a865e99
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD7.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR19MB4563
X-OriginatorOrg: ddn.com
X-BESS-ID: 1732234658-112224-6322-61285-1
X-BESS-VER: 2019.1_20241121.1615
X-BESS-Apparent-Source-IP: 104.47.73.49
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVkYmBkZAVgZQMNU0NcXcxNLIwt
	jCPDE1JSk5KcXSJNUiOTXNxCzN0jBJqTYWAO1Q/MZBAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260588 [from 
	cloudscan13-134.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_RULE7568M, BSF_BESS_OUTBOUND, BSF_SC0_MISMATCH_TO
X-BESS-BRTS-Status:1

Add special fuse-io-uring into the fuse argument
copy handler.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev.c         | 12 +++++++++++-
 fs/fuse/dev_uring_i.h |  6 +++---
 fs/fuse/fuse_dev_i.h  |  5 +++++
 3 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index aa654989d768df3dd82690ef071bbe0aa87817b0..ad65ede9c7723bb6f3589e64b8eef7429fa4b488 100644
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
 
@@ -1926,7 +1929,14 @@ static struct fuse_req *request_find(struct fuse_pqueue *fpq, u64 unique)
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
 
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index fab6f2a6c14b9de0aa8ec525ab17e59315c31e6a..17767e373d31969fe2987fed31c66b5077f209c6 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -14,13 +14,13 @@
 enum fuse_ring_req_state {
 	FRRS_INVALID = 0,
 
-	/* ring entry received from userspace and it being processed */
+	/* The ring entry received from userspace and it being processed */
 	FRRS_COMMIT,
 
-	/* The ring request waits for a new fuse request */
+	/* The ring entry is waiting for new fuse requests */
 	FRRS_WAIT,
 
-	/* request is in or on the way to user space */
+	/* The ring entry is in or on the way to user space */
 	FRRS_USERSPACE,
 };
 
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index f36e304cd62c8302aed95de89926fc894f602cfd..7ecb103af6f0feca99eb8940872c6a5ccf2e5186 100644
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


