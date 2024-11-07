Return-Path: <io-uring+bounces-4553-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C4DF9C0D16
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 18:39:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF85B2853B2
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 17:39:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3574A2161E6;
	Thu,  7 Nov 2024 17:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="OPx/gl/K"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF68E191F6A
	for <io-uring@vger.kernel.org>; Thu,  7 Nov 2024 17:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731001139; cv=fail; b=A6Eu0lYfwxe1wcgJ8vV5WmrHMDNuDrc8GKvhBdB6lpQp3EkfIEhGOyds/pf6IfY49Zypj72Zrq3pf3R6/i9V1JcmUBKVnbLNoKtv3G+fku3vvFm4NddpLM7jRz5kdx6WWl+k6aUd/NrNZ6gCvlVPmrnl/8Ur5gv0E29UJnn1jes=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731001139; c=relaxed/simple;
	bh=SZvuLq31UmsGrTKDikqryaQNQk1jcWp6aJ3JBJknMvU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WvEIyI266fKXGHbrR5MV4Byt4XDowIwaH70dI0ns+9IGtyKQ1KVDvzIzRbBCqnDKA7OdWfeAGjQ+tOk/+NRn/VHvH5NXefR3RxGd+RLASbYyUer9PrfnqHdhI4A2I09Gx9vZgSGXybAI2OmHiblSgFPgs+gn3xQQWBc1Vv/yaXo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=OPx/gl/K; arc=fail smtp.client-ip=209.222.82.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172]) by mx-outbound42-115.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 07 Nov 2024 17:38:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SuB19xSWGlcIW0Scv+de3RgXTnhsHnO9w75GwpUUxQQuVWvm9/P4B89rwDD+kiw0mkbF6cY2/KL/ooUv69mIZMbUHHHeIKQlfZEaL+sZmvkH7PUeAvJPG3dHNhoBuY2R6vtgLLFxg+2xSDFgjvVEdmx8TBGbQ9UOAZmZo+t2NqSyWaCDV3e+FjqJSn/3cnSq7NvWRk9xUAbAqLxbM+qI67V8rf8Cl4w422S7vjuCr0pZXxLyjUBrzWxmo0nDfVlWuFr0ZaTaf6UQrqYU0VfapqhaMATiOnxoZb4KyFMyJOqgo/eaPLX9u5KQIKXOu+iHoSkToLWC4+xBV5JZ0Cv85w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L7R7lCVAIXbEWxPc8BrPFnw9ed5q0EwTc5vypP/6XJ0=;
 b=xY3DbvlFTO85oHUSyV2XHRwRKF403vICD1YD3368GW74pGMhwtMme2+XxiKtiC8nYT4y6gExPwc8EFSdLW/BBuCJc4PAkvARdtmExmJQ1iCZtFlK0cRn9DrWAws7G3ts7XlHqHMMyrfGK7XNVLnimbLAHI8mPchOHRAAhrLd+floAUl3HvdTgzmr6wb4042lC4w66OJFivzJVUvnhPGNqyxUiZAaeT5bB/JNQtOZnq2dAg8WW/em4I+UCC3NoIklEQUKdHmx/8G9RtGgu+VpVJ9+/QR5Y8LXhAKk2Evt9PS4Fv67Tf1htVuUhgr+6p/xtGg6xTewYSDmXvMY/hXLZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L7R7lCVAIXbEWxPc8BrPFnw9ed5q0EwTc5vypP/6XJ0=;
 b=OPx/gl/KsKMoV3yo6DRPTDSWmWdfZfAn07WX29w17AW1RRDUHite2Dd7/Kwca71YXVXTkrYd00C829mltwSctx2GhxCbnwZPopUb6O0TdDOEguwBYvzhUhflDhEgeVZCKJ6cA8Cau1KGNvWuXW5IpaHwVBY53cAtBUOZI3pgzBY=
Received: from BY1P220CA0025.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:5c3::12)
 by SA3PR19MB8167.namprd19.prod.outlook.com (2603:10b6:806:397::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Thu, 7 Nov
 2024 17:04:17 +0000
Received: from CO1PEPF000044EF.namprd05.prod.outlook.com
 (2603:10b6:a03:5c3:cafe::2a) by BY1P220CA0025.outlook.office365.com
 (2603:10b6:a03:5c3::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.20 via Frontend
 Transport; Thu, 7 Nov 2024 17:04:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 CO1PEPF000044EF.mail.protection.outlook.com (10.167.241.69) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8137.17
 via Frontend Transport; Thu, 7 Nov 2024 17:04:16 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 2B8617D;
	Thu,  7 Nov 2024 17:04:16 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Thu, 07 Nov 2024 18:03:50 +0100
Subject: [PATCH RFC v5 06/16] fuse: {uring} Handle SQEs - register commands
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241107-fuse-uring-for-6-10-rfc4-v5-6-e8660a991499@ddn.com>
References: <20241107-fuse-uring-for-6-10-rfc4-v5-0-e8660a991499@ddn.com>
In-Reply-To: <20241107-fuse-uring-for-6-10-rfc4-v5-0-e8660a991499@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1730999049; l=16666;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=SZvuLq31UmsGrTKDikqryaQNQk1jcWp6aJ3JBJknMvU=;
 b=93vcld+n+XDvSPzc4XrtS3gDbSO2Jtqs1D7O2auCh0pwPxi/zlkZJem2OlgmMih3xakiK1P89
 lQr88oSEri/AZUhwQJa2ps8s+2TuR/W55XofxpjEjqIT8RZS0oIgaDi
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044EF:EE_|SA3PR19MB8167:EE_
X-MS-Office365-Filtering-Correlation-Id: 30b612f4-38a2-4ce8-7d41-08dcff4e36aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MGdCc2hvVmd6Wm1WV3cwK0VMK3E0YUpRdDEwUU1HZHZ2dXlHOEZFOStkaDBP?=
 =?utf-8?B?OHdCdmRFSDFFYUlCYmc0TXhDOEFRazdQUEI1TnBaemdRVmkrTlhQaWhxZTFK?=
 =?utf-8?B?a24wbjFhK05lbjUzdStZdjEyYkwyQTZuS003a3hUcUp6Rnp1cUtUSjUvTlRN?=
 =?utf-8?B?NUJRRHpCN0ZSNG9wZWhNNWFvUXJKa0VEdGJScUFqeTV0c1hjTlI4akpuRllX?=
 =?utf-8?B?UC9zVDV6UW1ldnR2MkR3MytwYzhuc3FFTVRaVUNKRGVDK0xEdWV1b1NScWVr?=
 =?utf-8?B?Nk9VaGJGbEZiSnZYSVdFS3p2ZEdoTHJMTVFLNWE1cm9PT3E1eVVsU0lGUUVw?=
 =?utf-8?B?cUZyWm44MThUM0xMdmlJMi82Zm1JaEpxVXdIRWY1TDduOFYvSldYY3o2REdi?=
 =?utf-8?B?bmdhSVg3cnF2N3ZyWXpheUU0WFNiVlU4b1U3SUxqdDd0aFRnbkZYMzF4UThL?=
 =?utf-8?B?TXQvS3JNS3dkSkdxaUYzR0hERFcwZU10amNtVW9XZGpkTGx1NDFVWUFyZnVn?=
 =?utf-8?B?MnZDQ0h6cGRGdXQwcERXMnB1UTE1WitXalo4VUFtNTNjb2drVGNpTzJpaU5V?=
 =?utf-8?B?L3BsMHo5c0tMY2xiNlBPSlI2c0kyZGFlUzFFMHkrbFM4L1dGUVJtbVY5Qk1H?=
 =?utf-8?B?cTU4YVY1RTljRW56emwzRE95cldScFBQSStIdkM1MGVZSzQzQVdtTWxYNGt0?=
 =?utf-8?B?bjZ3RzlFTXFxWHgvZGxyWkM2NnZ1bTYreitzYStiSkJRY2ZZc1dDNEhEVlNu?=
 =?utf-8?B?citqRzNBNmNNNW1LcnpDQ3V4b0dTMmdoUFpwQlFDVGRONjB1UDBTUklWdk1q?=
 =?utf-8?B?VW0wajU1RjhidmZqZHJqbGtQUHlxWkl3MEUzVjJudlBCQVRGalR6enMzMzdZ?=
 =?utf-8?B?Wjc2eFB0VlFyUkNaTGdsMzQ0STVYWHFYQ1lXOElyQ0Y1R1kvcEFyZm5lUGY5?=
 =?utf-8?B?QjlYVmZQOGpLK0xuMjJHSjlDZzFJR3phbzdIZnF1cXVhMTRpZmZZZ2VRckE2?=
 =?utf-8?B?OWpKamY3bjlBbkpwM0FVdHR3NlRBWEt6bStBQ2ZaTlNURVNSbUR6aHByT0Ju?=
 =?utf-8?B?NzlkcXBka3EvM29Xc1dVRGRzSmtRNXZDcFkzV3kzL2VvNmdIR3V1YnNva2hi?=
 =?utf-8?B?QkZ3SFpwOEFuYUdSRFNDYjNDT2lILzNsT0xFRUNSeUlIR2lBb1RXUDN6L1V5?=
 =?utf-8?B?Y3AxUXR1RmVxZ2Q5Qzd4N0NaZ2hnQXQyUEcxcktPQ3U5bUF6dm1uVUNZQnNs?=
 =?utf-8?B?V1orZVNGd0NYSTV3UXN2ekxRMG5qRmFSZVJwN2lqTHk3aFdwaDZ0RENkMy95?=
 =?utf-8?B?akt2Rkw0RHhnUmNOaXVKOWU5aFM5TkhhOXlET3VLbnpKaEUxRjhMd1drenZJ?=
 =?utf-8?B?dmQra2ZMQ0EyRFFjeDNabG9LaXFTS01mMys5dEVzaHlMb2FzaEk5RGwxWGhr?=
 =?utf-8?B?UE9WZWFiaUFrNlBmOFBJR3ovdFhHMG8zQ1dMMGpTWVRaZWVsOWV5S3JBdU5M?=
 =?utf-8?B?MHd6RjhNWXJBT1NJMklnYVpTNndNdHI0UHNmRWZOajVCMmh1c2lxU2prbUlx?=
 =?utf-8?B?TzVGeHJ5azFNSUxndjMxNkRmRi9xUU1xckxYWm1OU2EwZFRrTUtQKytVd3lO?=
 =?utf-8?B?OWo4anAydlM1SmZWeVRlYWlJTmtrbkZQalM4UCtoMEg5WXJVNDZDalFabG1H?=
 =?utf-8?B?N1piNndEYVZvR3VJK3hWT2RFSUpOVVFNd3FWemRXWjJxMVZUV05XTEQveWVY?=
 =?utf-8?B?SEQxWStmOEhFMjBMN3h5bkVzV0pOQ2F4R0tySkRrYTdUQXNMQm1SbXd3TXBa?=
 =?utf-8?B?MHRNaUFhZGg0cnVMRWNFYkJYUzBGYUFTTFJhWjdHQ3hENTdIK2hTaUN0dFJO?=
 =?utf-8?B?TnUxazh2aDZJR0pDY2gzWjE1NlIxSFZ0WlpiblpmUTNPUHc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(7416014)(36860700013);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9dZsKQLOFxBRT+liYNq8mA7vfQ4gBpYVeBxTMarj3TD3qHuod+MATBFJkTuo/b8QJOueK3PydtVWf1e3TOj0ofacskbrzb6pqOn4nG1yFz7c5rMk22PMgmrrx80LBwo0eU5JF2JKggPu3QtaksZSm6e0PZg6upPbekq4HkufRghzXGfSX1uUOaZRlanWTnFMQyGDUQ/8vhFvdO+97sjBonsPrRoXPQkQ67VDye8HV0VL7TFGTnIIV2hVCOEA9MOaVLuIYWe6p9kInGv2gWm9ASVdgmPDGxT84qjjdkjg3s2+iGFow63NtwdS3m185ixQOJvaDZFfK3d4NS3tfXGfYc+Vo5ZBnPYt8wTHWrMtOE7TFhGg4Q93I/CUzGqLxt5j8vDWm7LNYgOvVlKZPWxgrNYwuUYUhuLTM3xVjpnVGt7eVQ1npBLtH5O7GNwmGKIJxYJw4KYCw0cvPqZTQCABABW5ujBlTFi9FPjoUkOTDxF3WjkQ9nKpY8ME8hlzyzWGKFdJVEgte50DC51cXzNcjM4ELGhJykcjUBJ1PsMNZgNbRhVPevPR/OIgtqg+7DLngcMEJH999FDGJtksbfjVaLkW9APl6KQqeNv7GF9/SoHpsZmVZT+EbO4u+gYBoMvLHd5yys5WNXT41UZac1sjgw==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 17:04:16.8505
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 30b612f4-38a2-4ce8-7d41-08dcff4e36aa
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044EF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR19MB8167
X-OriginatorOrg: ddn.com
X-BESS-ID: 1731001135-110867-12751-15389-1
X-BESS-VER: 2019.1_20241029.2310
X-BESS-Apparent-Source-IP: 104.47.57.172
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoZmBoaGQGYGUDTF0DDN0NAsLT
	nR0MzEMC3FLC0lxTLJyMLQLCXRPC3VUqk2FgD0VmqwQgAAAA==
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260269 [from 
	cloudscan22-13.us-east-2b.ess.aws.cudaops.com]
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
 fs/fuse/dev_uring.c       | 349 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/dev_uring_i.h     | 108 ++++++++++++++
 fs/fuse/fuse_dev_i.h      |   1 +
 fs/fuse/fuse_i.h          |   5 +
 fs/fuse/inode.c           |   3 +
 include/uapi/linux/fuse.h |  57 ++++++++
 9 files changed, 540 insertions(+)

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
index 6effef4073da3dad2f6140761eca98147a41d88d..d4e7d69f79cec192cb456aedfb7d4a2a274fea80 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -6,6 +6,7 @@
   See the file COPYING.
 */
 
+#include "dev_uring_i.h"
 #include "fuse_i.h"
 #include "fuse_dev_i.h"
 
@@ -2414,6 +2415,9 @@ const struct file_operations fuse_dev_operations = {
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
index 0000000000000000000000000000000000000000..ce0a41b00613133ea1b8062290bc960b95254ac9
--- /dev/null
+++ b/fs/fuse/dev_uring.c
@@ -0,0 +1,349 @@
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
+static int fuse_ring_ent_unset_userspace(struct fuse_ring_ent *ent)
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
+#define FUSE_URING_IOV_SEGS 2 /* header and payload */
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
+/*
+ * sqe->addr is a ptr to an iovec array, iov[0] has the headers, iov[1]
+ * the payload
+ */
+static int fuse_uring_get_iovec_from_sqe(const struct io_uring_sqe *sqe,
+					 struct iovec iov[FUSE_URING_IOV_SEGS])
+{
+	struct iovec __user *uiov = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	struct iov_iter iter;
+	ssize_t ret;
+
+	if (sqe->len != FUSE_URING_IOV_SEGS)
+		return -EINVAL;
+
+	/*
+	 * Direction for buffer access will actually be READ and WRITE,
+	 * using write for the import should include READ access as well.
+	 */
+	ret = import_iovec(WRITE, uiov, FUSE_URING_IOV_SEGS,
+			   FUSE_URING_IOV_SEGS, &iov, &iter);
+	if (ret < 0)
+		return ret;
+
+	return 0;
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
+	struct iovec iov[FUSE_URING_IOV_SEGS];
+
+	err = fuse_uring_get_iovec_from_sqe(cmd->sqe, iov);
+	if (err) {
+		pr_info_ratelimited("Failed to get iovec from sqe, err=%d\n",
+				    err);
+		return err;
+	}
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
+	INIT_LIST_HEAD(&ring_ent->list);
+
+	ring_ent->queue = queue;
+	ring_ent->cmd = cmd;
+
+	err = -EINVAL;
+	if (iov[0].iov_len < sizeof(struct fuse_ring_req_header)) {
+		pr_info_ratelimited("Invalid header len %zu\n", iov[0].iov_len);
+		goto err;
+	}
+
+	ring_ent->headers = iov[0].iov_base;
+	ring_ent->payload = iov[1].iov_base;
+	ring_ent->max_arg_len = iov[1].iov_len;
+
+	if (ring_ent->max_arg_len <
+	    max_t(size_t, FUSE_MIN_READ_BUFFER, fc->max_write)) {
+		pr_info_ratelimited("Invalid req payload len %zu\n",
+				    ring_ent->max_arg_len);
+		goto err;
+	}
+
+	spin_lock(&queue->lock);
+
+	/*
+	 * FUSE_URING_REQ_FETCH is an initialization exception, needs
+	 * state override
+	 */
+	ring_ent->state = FRRS_USERSPACE;
+	err = fuse_ring_ent_unset_userspace(ring_ent);
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
+/*
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
+		if (err)
+			pr_info_once("fuse_uring_fetch failed err=%d\n", err);
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
index 0000000000000000000000000000000000000000..11798080896372c72692228ff7072bbee6a63e53
--- /dev/null
+++ b/fs/fuse/dev_uring_i.h
@@ -0,0 +1,108 @@
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
+	struct fuse_ring_req_header __user *headers;
+	void *__user *payload;
+
+	/* the ring queue that owns the request */
+	struct fuse_ring_queue *queue;
+
+	struct io_uring_cmd *cmd;
+
+	struct list_head list;
+
+	/* size of payload buffer */
+	size_t max_arg_len;
+
+	/*
+	 * state the request is currently in
+	 * (enum fuse_ring_req_state)
+	 */
+	unsigned int state;
+
+	struct fuse_req *fuse_req;
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
index e2d1d90dfdb13b2c3e7de4789501ee45d3bf7794..91c2e7e35cdbd470894a8a9cd026b77368b7a4b6 100644
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
index d08b99d60f6fd6d0d072d01ad6bcc1b48da0a242..2fddc2e29f86cec25b05832ae7a622898a84b00f 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -1186,4 +1186,61 @@ struct fuse_supp_groups {
 	uint32_t	groups[];
 };
 
+/**
+ * Size of the ring buffer header
+ */
+#define FUSE_HEADER_SZ 256
+#define FUSE_IN_OUT_HEADER_SZ 128
+
+/**
+ * This structure mapped onto the
+ */
+struct fuse_ring_req_header {
+	union {
+		char ring_header[FUSE_HEADER_SZ];
+
+		struct {
+			uint64_t flags;
+
+			uint32_t in_out_arg_len;
+			uint32_t padding;
+			union {
+				char in_out[FUSE_IN_OUT_HEADER_SZ];
+				struct fuse_in_header in;
+				struct fuse_out_header out;
+			};
+
+			/* fuse operaration header */
+			char op_in[];
+		};
+	};
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
+	uint64_t flags;
+
+	/* entry identifier */
+	uint64_t commit_id;
+
+	/* queue the command is for (queue index) */
+	uint16_t qid;
+	uint8_t padding[6];
+};
+
 #endif /* _LINUX_FUSE_H */

-- 
2.43.0


