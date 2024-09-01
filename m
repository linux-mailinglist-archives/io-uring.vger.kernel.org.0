Return-Path: <io-uring+bounces-3006-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B765967728
	for <lists+io-uring@lfdr.de>; Sun,  1 Sep 2024 17:08:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 843981F21717
	for <lists+io-uring@lfdr.de>; Sun,  1 Sep 2024 15:08:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEC14446AB;
	Sun,  1 Sep 2024 15:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="JDUR1uE5"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46AB3CF7E
	for <io-uring@vger.kernel.org>; Sun,  1 Sep 2024 15:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725203320; cv=fail; b=GGXcA1E+4Rf1o9OCvF3MS4/mS1+uxPUD240pqwr5+izCV3H8EfRR9QEvri/hGBPZFaSwlWaSSSSrDt9ttzyGi2ny48iVSoW0QDblcmbXUDgk+AnY9NfpWTSPiWbK8HKX64Z9qi3Y/wEw+7JD98wUTVAT8PKuL1CEFPkhDf/ifQI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725203320; c=relaxed/simple;
	bh=WO9U9Vi16OvjSCHwWmwvrGaz8Wfi1w9JwEePyqVl2RM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=YWb7Z0mKP9fxXsMbXCgOcSgZWsmpM+kBVzgGbcvjsO2YkkKSlNcUpFhmt+JNmHELPD5OrTSjB9qlJwIbbmPUDzuHEVNRk4ekhHKGiTTaD+eus5wpafLhxcYPO3NbeucIYeXEO9VzFvTKVX8CWT5uz6a4mBFlZJdOUqCFeMuGK0g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=JDUR1uE5; arc=fail smtp.client-ip=209.222.82.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176]) by mx-outbound-ea22-15.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Sun, 01 Sep 2024 15:08:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XPWtx0VrLiuPirkA5+dpxK4vwjVdGbAXlUnimWwc8UhQD6GJERLp+EF7oECGO8eE1p0wsw84M4u3hIxklyOeaDxnHudVKXpJkxOFDNwTKBQgrs/RaZnQ5m/+1d55yV33NM/3LDOWkKPWMnm/8MCwferPaL/Tor2aMzILBKs5YhPpPjGXAlfugwQS9wGDz5IHOaJevUH1L4RQoZ6LWK4zAmze0lLGTSMAomiK82Hurk7I0+lENRSz3zof8qDM8Kjh29npHsC5gsTKCsFDehH6UF/cbvOtE73YlKGA3OQMkCbYLtVobb4X/KucbsmKHtTSJRxcy+CviwWOPExf+xOttA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OIjNG6O4yUAaaqOK6KfuqMs34g2ZILTtn10ODN8wnrs=;
 b=Igbxq10XmsVtgerYH/acdmqLM11R++tHxTeYgGzzBGtEBuj5TqQ3c/GkDqEI/WWFqEizfkKq41TvB1CsuL0+HtYAY8m1pX7a943BdtUrQkysr5IYSvyAHQaJJCm3+v4C2gF20N7F/MNPHEVm0rz3T2hVphVgXyW3MryN29uLCpIUc1JbNVzt5rH3wBMheGpkoKIZBJ6abWRbIND01WrJowPDrH8OI8zcFFAzpm8bvdMuNwvY1d3LIZcJLWTzQmDSTbl7NtQXdCnnXxMBHaFJZ8iMXEkvO/rp0MVSPvc1ECkiXRFDT0eykYLvv5uZ4qhwJJLssJzH3+MDtYgnCqfi2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=ddn.com smtp.mailfrom=ddn.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=ddn.com; dkim=none
 (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OIjNG6O4yUAaaqOK6KfuqMs34g2ZILTtn10ODN8wnrs=;
 b=JDUR1uE5gvFESm2k4jvmSSLoVHWLiMU+ULSE0sCsiNip+6PGHPcpuWkyoBE/y7jRUZx78BT4wjM4BrxpZVTBuypp/QZ+fMBiY9qghzp27lCVXeJwEiWlX4urYQXiTxp62WB9+McKq+hQF7y+h3I8DlHlXihOmrnxwvNpT3UL6s8=
Received: from BN9PR03CA0718.namprd03.prod.outlook.com (2603:10b6:408:ef::33)
 by CYYPR19MB8118.namprd19.prod.outlook.com (2603:10b6:930:ba::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.23; Sun, 1 Sep
 2024 13:37:12 +0000
Received: from BL02EPF0001A108.namprd05.prod.outlook.com
 (2603:10b6:408:ef:cafe::8) by BN9PR03CA0718.outlook.office365.com
 (2603:10b6:408:ef::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.23 via Frontend
 Transport; Sun, 1 Sep 2024 13:37:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 BL02EPF0001A108.mail.protection.outlook.com (10.167.241.138) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.7918.13
 via Frontend Transport; Sun, 1 Sep 2024 13:37:12 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 43430D0;
	Sun,  1 Sep 2024 13:37:11 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Sun, 01 Sep 2024 15:37:08 +0200
Subject: [PATCH RFC v3 14/17] fuse: {uring} Allow to queue to the ring
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-14-9207f7391444@ddn.com>
References: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com>
In-Reply-To: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>, 
 Pavel Begunkov <asml.silence@gmail.com>, bernd@fastmail.fm
Cc: linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.14.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1725197817; l=6166;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=WO9U9Vi16OvjSCHwWmwvrGaz8Wfi1w9JwEePyqVl2RM=;
 b=MppN/AaMBx4+/71Sx6awxzbkOjqZrbPK5/XFhLto0Dh6mNAvKY3Bwxx41CaFDG13F2TH6rOeT
 QhNo8hYDDh4BAiEeUAswXM2QP1a78Iks7FhTAGiRLG7NUctT+q+vgtT
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A108:EE_|CYYPR19MB8118:EE_
X-MS-Office365-Filtering-Correlation-Id: ea8ecd73-19df-4c3f-8cac-08dcca8b2f4d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZkM4ZVcvUzJ4ZGZaazdDaTlaQkNNV05Qc0xicm1rZDVvaHlQc3VoK1ZCUC9l?=
 =?utf-8?B?MjBUNTVGbUNJaEtFdEFBYkpPN1MxUFBKdHRMVkQzbW5XZHltNXBvaE5adXMv?=
 =?utf-8?B?ZEgrQnAvQmFrcmxvZWVNK0QwMXQ2TFhnQUkyQmM3ZE1zM3dKRnlRcHFqQWtX?=
 =?utf-8?B?eFdZcWlYeGdmYzdraW8va3dSZ1Z0Nk5XeUlQN3F5SHNIYTVUMnZRSUxxbE9K?=
 =?utf-8?B?aVM2dUJDYmJBRnJ0OXRLMGM4Vjc3ZmFneEo4R1hmQTQ3dE0wUUF4ZFcvb0Ja?=
 =?utf-8?B?eDdWOHY1S21ta3hvTXg3WkpxZmpuOFdkT2dwV0dWZHNnc0VuM0t5NGY1RTFO?=
 =?utf-8?B?b3l6TnA1YmFweFY1ZERiZmN4bjNwdzFqbUpQSVR4QkpDQzIxMnJOYldJVXNW?=
 =?utf-8?B?Y1hISTg5UjBzR2VjSmZqM0RNMnRralZiTXlHTThISVJQbThGM29HblJ4Y2dl?=
 =?utf-8?B?anRVYm5Ha0RZL1hZWURGQk50RkF3RlRIQlRaWU1LZnZLMnZYMXRrbGpnOFdL?=
 =?utf-8?B?ZDQyVCtUakxrVzBkc3cyZnYybndQU3lZSkp6R1lkQjJNd0xFbTY3RWpXeVhq?=
 =?utf-8?B?QWJKZW5Cb29oV2RCRVduK3VUUVZRL1pKRjdnTjRHVUNqcEFSdFR0M2FUaGVa?=
 =?utf-8?B?V20yQjRUTTdOeGxzRlczRlo1dWdDU1c5bVVxVS84WWhmUTNScFRPUnBVOUhi?=
 =?utf-8?B?YkZRbXdhU0Zaa1hpQVgyQjFlT2pWM3VWUWNXUnhkd2syMGFFQ29FTWFOUmdp?=
 =?utf-8?B?SWJlWmsvNVdzRlJjdGQxUEJlaTB5V1lTaWJ2VTl1eXVOckduc0wyc1hCa282?=
 =?utf-8?B?QjN3UW1sdHp0K0pGY0tQRVdYRHVaUnpnclJLQVNiaUtKaWkxcXc1RTZLdSt1?=
 =?utf-8?B?ckl0UFJoMDhTeUdlVmt1MGRQK2NpUUY3MFdjaEtaZDlhbzc2TGtYaDVjWDg3?=
 =?utf-8?B?T1dMbDdkWmdmR1JmWTZPRFZFMW1WWGhmd0djM2xwdU1Tc1UwM3ZtMlBpRUVa?=
 =?utf-8?B?T20xVEVmZXVaVzIzcGoyckdieDdFSFJrNFh2bVBQQ0hPL1c3b0haL3VrRVRN?=
 =?utf-8?B?ZzYrM0JFbFJZbmlTNUwrNHVqclFLR1h3R204UW1HYWZhQ1Q1OFdUQ2dRMUR3?=
 =?utf-8?B?b1RRT3B5aGpya0V2WHlWY3l5cXlIdEZsbkxRNmhNVHJVaWY3a0h4elVCVCtX?=
 =?utf-8?B?dzRjZHR0L00xTWdCSSsxUklTTVNpNnE2NU01MDVwYmpmK2hXR0QvZzAzMmJW?=
 =?utf-8?B?SmZyaFJjb2l0Qk1mS2YyeDg5MXNpelVYekJ0b2RJTlFtVGt2ZkFXR2pIWXAy?=
 =?utf-8?B?c3MzMHFQUnNYSkt2QWwvNmdTcitldzdYSmVvckpaME4rbENsU0Y0bFpNQ2ly?=
 =?utf-8?B?S00vVXA0cHV1TWNGeXBnbjRFOGxXQmZuMHBvVEwvdWVTSEhHZHJyK0lFTldo?=
 =?utf-8?B?VVE3MUs1T09QVzNaNWhWUm9jZ1MrL2hFZndVQ1B5WmZmZXFPRjJTeHlRUHFL?=
 =?utf-8?B?NUZFUTh1UFUzbkZnVWtkbzdCZk0zYlZ0UVVCU2NLVFNTc2F2aU5yci94Qk8w?=
 =?utf-8?B?bUxWZ3ZlU2RYUS9nTFhIaGh6VDkwdXYzTXlkNWVSQ2FBZFRRNFl3ZWZQb1pC?=
 =?utf-8?B?RkkzU0tPYVArREJmekMzbkN3c0pvR2FBbnl2L2lHWUMzKzBHSmt1VzZvc1du?=
 =?utf-8?B?TUNLek9wY1ltbEljRmp2ZEc4aDI0QXNBUURodjMwWlFLZmNaVVl2MDNRNVVx?=
 =?utf-8?B?YjBDbnZrUElUSkFTOGF1YWVNWlpmWnY4TStBMFFMYkdxc0ZGWmJiQ3BZY0lq?=
 =?utf-8?B?dHhSYzhXaFl6UElUTXFETFN0VS8yeHRwSHNDbGlBaU1CZ2cxYUxYaVZxOFcx?=
 =?utf-8?B?VG5SWXNKVmxNL0Ivcnp6Umc4UVNEZkgyNWhsUDhQZWpHKzA4c0dtanRkWmda?=
 =?utf-8?Q?gNODxvlNyTSWc+xB/rsawiuQVUDDrOW1?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	AjuGvfZ20iz6E99QspcBFEfqYllqFSgpM8LCB66LkS4bT8Kg1KXb9FJtxc2+igPN9y3E/cL4rADHAXGYguu/GMEsQXKJOttd/kWeMI5DlL+NH5gUkifGqToj8acRgXHlh4OIUSaeHbPeIlB6BzSGBMsPDUQT2rKKzeNnUMcOEIYPHCMrmWn3a8OlcsX4A5N57JjdYcSVxlq/97ltncmYs4w4eEo4BrARwaNhcLIpL1qC/U4NjXsQ0K3Vw7O1tNTvBcN9J4OAvan6ElAhP4jjo90c3ibsqxdUth0+OfG752QdbkX2mOcc6BJJ26XASvOTJ2oD6wQ+7cxqE4uJG8H7GRmSLy6aVGu0B8xGmlcUDWrpHth2kZ9d9DE7asZMJricMJhQaOBPEHjgWZ2WYn4T8A7l8d5L5OH4hXX+tKwybTSJjbYFVyDaQzj40U/1NDgQfbopWZoIDMM12itpMDB3jNPenojaB5EVMwhVap7hAv/KXAot8j2DqWXUMSxU5F+QvZttuLrA6rw6csh6d4w4L5T2wJmJ0KD74HDNVQowDGdwNiu4lyWyw3n8AJSD+eLzsv/3MnS5wob450mmhgiiGz2DOyUhcnRQxXV7Jc+7STogwfK/waD4FYewEh1poBeHiTgUU4S3VxlfhVzund+D9w==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2024 13:37:12.1237
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ea8ecd73-19df-4c3f-8cac-08dcca8b2f4d
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A108.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR19MB8118
X-OriginatorOrg: ddn.com
X-BESS-ID: 1725203316-105647-24686-26161-1
X-BESS-VER: 2019.3_20240829.2013
X-BESS-Apparent-Source-IP: 104.47.56.176
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVqaWZqZAVgZQMC3NxDIpLTXRLC
	0lxdLU3NA0LSktJTEt0cLS3DApMdFAqTYWAO1YKwBBAAAA
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.258745 [from 
	cloudscan10-26.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
	0.50 BSF_RULE7568M          META: Custom Rule 7568M 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_SC0_MISMATCH_TO, BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

This enables enqueuing requests through fuse uring queues.

For initial simplicity requests are always allocated the normal way
then added to ring queues lists and only then copied to ring queue
entries. Later on the allocation and adding the requests to a list
can be avoided, by directly using a ring entry. This introduces
some code complexity and is therefore not done for now.

FIXME: Needs update with new function pointers in fuse-next.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev.c         | 74 +++++++++++++++++++++++++++++++++++++++++++++------
 fs/fuse/dev_uring_i.h | 10 +++++++
 2 files changed, 76 insertions(+), 8 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 3485752e25aa..9f0f2120b1fa 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -218,13 +218,24 @@ const struct fuse_iqueue_ops fuse_dev_fiq_ops = {
 };
 EXPORT_SYMBOL_GPL(fuse_dev_fiq_ops);
 
-static void queue_request_and_unlock(struct fuse_iqueue *fiq,
-				     struct fuse_req *req)
+
+static void queue_request_and_unlock(struct fuse_conn *fc,
+				     struct fuse_req *req, bool allow_uring)
 __releases(fiq->lock)
 {
+	struct fuse_iqueue *fiq = &fc->iq;
+
 	req->in.h.len = sizeof(struct fuse_in_header) +
 		fuse_len_args(req->args->in_numargs,
 			      (struct fuse_arg *) req->args->in_args);
+
+	if (allow_uring && fuse_uring_ready(fc)) {
+		/* this lock is not needed at all for ring req handling */
+		spin_unlock(&fiq->lock);
+		fuse_uring_queue_fuse_req(fc, req);
+		return;
+	}
+
 	list_add_tail(&req->list, &fiq->pending);
 	fiq->ops->wake_pending_and_unlock(fiq);
 }
@@ -261,7 +272,7 @@ static void flush_bg_queue(struct fuse_conn *fc)
 		fc->active_background++;
 		spin_lock(&fiq->lock);
 		req->in.h.unique = fuse_get_unique(fiq);
-		queue_request_and_unlock(fiq, req);
+		queue_request_and_unlock(fc, req, true);
 	}
 }
 
@@ -405,7 +416,8 @@ static void request_wait_answer(struct fuse_req *req)
 
 static void __fuse_request_send(struct fuse_req *req)
 {
-	struct fuse_iqueue *fiq = &req->fm->fc->iq;
+	struct fuse_conn *fc = req->fm->fc;
+	struct fuse_iqueue *fiq = &fc->iq;
 
 	BUG_ON(test_bit(FR_BACKGROUND, &req->flags));
 	spin_lock(&fiq->lock);
@@ -417,7 +429,7 @@ static void __fuse_request_send(struct fuse_req *req)
 		/* acquire extra reference, since request is still needed
 		   after fuse_request_end() */
 		__fuse_get_request(req);
-		queue_request_and_unlock(fiq, req);
+		queue_request_and_unlock(fc, req, true);
 
 		request_wait_answer(req);
 		/* Pairs with smp_wmb() in fuse_request_end() */
@@ -487,6 +499,10 @@ ssize_t fuse_simple_request(struct fuse_mount *fm, struct fuse_args *args)
 	if (args->force) {
 		atomic_inc(&fc->num_waiting);
 		req = fuse_request_alloc(fm, GFP_KERNEL | __GFP_NOFAIL);
+		if (unlikely(!req)) {
+			ret = -ENOTCONN;
+			goto err;
+		}
 
 		if (!args->nocreds)
 			fuse_force_creds(req);
@@ -514,16 +530,55 @@ ssize_t fuse_simple_request(struct fuse_mount *fm, struct fuse_args *args)
 	}
 	fuse_put_request(req);
 
+err:
 	return ret;
 }
 
-static bool fuse_request_queue_background(struct fuse_req *req)
+static bool fuse_request_queue_background_uring(struct fuse_conn *fc,
+					       struct fuse_req *req)
+{
+	struct fuse_iqueue *fiq = &fc->iq;
+	int err;
+
+	req->in.h.unique = fuse_get_unique(fiq);
+	req->in.h.len = sizeof(struct fuse_in_header) +
+		fuse_len_args(req->args->in_numargs,
+			      (struct fuse_arg *) req->args->in_args);
+
+	err = fuse_uring_queue_fuse_req(fc, req);
+	if (!err) {
+		/* XXX remove and lets the users of that use per queue values -
+		 * avoid the shared spin lock...
+		 * Is this needed at all?
+		 */
+		spin_lock(&fc->bg_lock);
+		fc->num_background++;
+		fc->active_background++;
+
+
+		/* XXX block when per ring queues get occupied */
+		if (fc->num_background == fc->max_background)
+			fc->blocked = 1;
+		spin_unlock(&fc->bg_lock);
+	}
+
+	return err ? false : true;
+}
+
+/*
+ * @return true if queued
+ */
+static int fuse_request_queue_background(struct fuse_req *req)
 {
 	struct fuse_mount *fm = req->fm;
 	struct fuse_conn *fc = fm->fc;
 	bool queued = false;
 
 	WARN_ON(!test_bit(FR_BACKGROUND, &req->flags));
+
+	if (fuse_uring_ready(fc))
+		return fuse_request_queue_background_uring(fc, req);
+
 	if (!test_bit(FR_WAITING, &req->flags)) {
 		__set_bit(FR_WAITING, &req->flags);
 		atomic_inc(&fc->num_waiting);
@@ -576,7 +631,8 @@ static int fuse_simple_notify_reply(struct fuse_mount *fm,
 				    struct fuse_args *args, u64 unique)
 {
 	struct fuse_req *req;
-	struct fuse_iqueue *fiq = &fm->fc->iq;
+	struct fuse_conn *fc = fm->fc;
+	struct fuse_iqueue *fiq = &fc->iq;
 	int err = 0;
 
 	req = fuse_get_req(fm, false);
@@ -590,7 +646,8 @@ static int fuse_simple_notify_reply(struct fuse_mount *fm,
 
 	spin_lock(&fiq->lock);
 	if (fiq->connected) {
-		queue_request_and_unlock(fiq, req);
+		/* uring for notify not supported yet */
+		queue_request_and_unlock(fc, req, false);
 	} else {
 		err = -ENODEV;
 		spin_unlock(&fiq->lock);
@@ -2193,6 +2250,7 @@ void fuse_abort_conn(struct fuse_conn *fc)
 		fuse_uring_set_stopped(fc);
 
 		fuse_set_initialized(fc);
+
 		list_for_each_entry(fud, &fc->devices, entry) {
 			struct fuse_pqueue *fpq = &fud->pq;
 
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index d9988d4beeed..f1247ee57dc4 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -260,6 +260,11 @@ static inline void fuse_uring_wait_stopped_queues(struct fuse_conn *fc)
 			   atomic_read(&ring->queue_refs) == 0);
 }
 
+static inline bool fuse_uring_ready(struct fuse_conn *fc)
+{
+	return fc->ring && fc->ring->ready;
+}
+
 #else /* CONFIG_FUSE_IO_URING */
 
 struct fuse_ring;
@@ -295,6 +300,11 @@ static inline void fuse_uring_wait_stopped_queues(struct fuse_conn *fc)
 {
 }
 
+static inline bool fuse_uring_ready(struct fuse_conn *fc)
+{
+	return false;
+}
+
 static inline int
 fuse_uring_queue_fuse_req(struct fuse_conn *fc, struct fuse_req *req)
 {

-- 
2.43.0


