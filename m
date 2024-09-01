Return-Path: <io-uring+bounces-3002-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A6431967703
	for <lists+io-uring@lfdr.de>; Sun,  1 Sep 2024 16:10:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CFA951C20C8C
	for <lists+io-uring@lfdr.de>; Sun,  1 Sep 2024 14:10:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27D5317CA1B;
	Sun,  1 Sep 2024 14:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="p8isiqkq"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9CF14A4FF
	for <io-uring@vger.kernel.org>; Sun,  1 Sep 2024 14:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725199824; cv=fail; b=o/sJAcmBwi7bl8rmiuEgUuomtQCORxpLjmVXAKba+ySW6Gk8sZt0g9kYnlp3hzf8cDFv12QOWiO0y+NgwM40Pa1AQWPpHzSs+DzyZIb/8yXh0BJBd1j3+q7SO9zJSCdJiW3Pl42O0G4HFoGevSed/On4jwoA1cEKedz3tn6Rfuc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725199824; c=relaxed/simple;
	bh=xGBbWgo2hG/E1txkE9HfWsjbQKcS3FLe2casQepXLZ4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=l2PXhNRbhpcpF0Ek8KJvkZYkQwmwx2PImosp36zNk+YzI9EBBe6WDCw+q6ecj257Fwxpdxww2GGOPHJs7WHxvZsoB3ymXxIjmkVWnAc4HNZ9hM1LEswwohYXoww0mv9k5EaTzMT366QPMDW0hSigr6jLZmPYxtcNTyEFR5B3VEA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=p8isiqkq; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171]) by mx-outbound20-213.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Sun, 01 Sep 2024 14:10:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dr9jVacMTY0Q915L3iVmnWdc93sf4vENJwm+srspocrcy5XO6AWbQF4Gu1C/kxehYk/Gk0v2JgNMQYqJ/d2giMS0Hr0Tcj4hX5uRpUrxpyDAj0ywpIk7fnMqCeW53l//abb5UCt2rPH1exucPZ7JkCZkTqUya4Mb5QfBF+mfh+wNerIIbe6xURdI2WlXpw2zwGdoJalASUo6fn2oWvb9nmLfLDaBKuDqWY7u853qsFeV9eX+5G3/iQs8q7+PqyB5IRBoFs7Qb1HPFyn5yNB5YHgDrXWXBbQs0Z5Fz36uWkD81GeszRQ/u3y7+0EjLlfaUd5dPfJqv3caREq+x49Srg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EB2+Qa7oMm5M7WYKiLV8TBlwCE4F85ZJ3yzFcpM2wd4=;
 b=pG6YoiUAeWBuf7HOijLh76aOf7bnA9Q2B8cHxHC5ro+d+6YSMoye1ciWDZz41aGAGlvZ6FSD6nHdInxy/XnvvARxLcbXVtrIz9rqEAz90E7PeTKyXqpxtiV3bgITgjJlw+gNoesfhlKkVr8fODXnWa2xrYv569+oZkD58B4Re/RNOZsUxHW8oCRt2mv6T1XudK/3JE/nKi31Q/y+v6jVrSkZPXD5taz5JdcRXvCxfuQIm7Q+UepKrAgZKAVkP+89dDR4clsBbCJMbK08lBBd2ux36Ni7t0rWFwqIeXyVXiy6DOfj6fkfFqxWS9Tt/mev3l5yTFtdLJXIe2ECEG9JYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=ddn.com smtp.mailfrom=ddn.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=ddn.com; dkim=none
 (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EB2+Qa7oMm5M7WYKiLV8TBlwCE4F85ZJ3yzFcpM2wd4=;
 b=p8isiqkqcmUtJzhIDY9RZRw/NTFtR6YSdnxxLrEmr2fw1/sVWHwgjnhvTfEE24bCLCcJaSt82/YL1DXx15nG+VRVSXeqMSBQmnEC20Q34Pm5SaAULpVYRKop/dtwCWvDhyHOIt59sHMFVJCpyAjo2Fjpy74Amzl4BhsxOGX1XfE=
Received: from SA9PR13CA0023.namprd13.prod.outlook.com (2603:10b6:806:21::28)
 by MN0PR19MB5970.namprd19.prod.outlook.com (2603:10b6:208:37e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.23; Sun, 1 Sep
 2024 13:36:59 +0000
Received: from SN1PEPF0002636A.namprd02.prod.outlook.com
 (2603:10b6:806:21:cafe::31) by SA9PR13CA0023.outlook.office365.com
 (2603:10b6:806:21::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.23 via Frontend
 Transport; Sun, 1 Sep 2024 13:36:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 SN1PEPF0002636A.mail.protection.outlook.com (10.167.241.135) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.7918.13
 via Frontend Transport; Sun, 1 Sep 2024 13:36:59 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id A4236D0;
	Sun,  1 Sep 2024 13:36:58 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Sun, 01 Sep 2024 15:36:55 +0200
Subject: [PATCH RFC v3 01/17] fuse: rename to fuse_dev_end_requests and
 make non-static
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-1-9207f7391444@ddn.com>
References: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com>
In-Reply-To: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>, 
 Pavel Begunkov <asml.silence@gmail.com>, bernd@fastmail.fm
Cc: linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.14.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1725197817; l=2071;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=xGBbWgo2hG/E1txkE9HfWsjbQKcS3FLe2casQepXLZ4=;
 b=mpDC0wEjjky3LWI4I97s9WlGciUPSc8VEiW4BEW7ZxxvWuoyU73TDMeRjo4ANaTwn6sMrjyQu
 /JS5MHeZHlkDDPq16SQKdZsq/UjCXi4RQ4Wj6FMtVa6//j9isJwi69m
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636A:EE_|MN0PR19MB5970:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ce9707e-d654-4dc0-b470-08dcca8b27aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TDdQcXRldXlZcmFpSlJjZ2N0SlJZdDNnTTJ1MjVBc29sMXd4a1lRZXNnMkF6?=
 =?utf-8?B?MXdlS0pza3JZdVl4MWFSQnlGUzRtSm5ENk5xQ3p4NTdVMXQ0d0ZYVVRPNWhK?=
 =?utf-8?B?NENjRUVybVpYanRmbkVUb3J4RzhDMitiZXJ0dGRGbnYvakVQT2RxYVZPbmdF?=
 =?utf-8?B?SGhNVGpHRmp6K0RrOEpwNTVOTVRkVG5hZ3J4TkJad1lOUk9vTnhxbUw5bEZ0?=
 =?utf-8?B?SlBGV2NOZGFBcmhSZHorQnVKWEFOcWkyazE4M2p0Um1uRVJkN1Y3Y0VNUitV?=
 =?utf-8?B?K21CWFdDZEQxblJGSUtxdFNzZUEyS21ydHVHaDFNNnFBblVucklqN0dRNGdo?=
 =?utf-8?B?bk82cXlmdlJUcHF1MjBxQjVDa2JyaXd0Q2traUhJZE1UMENPVDJIVElSQ3pk?=
 =?utf-8?B?L3hqMVR2cG1SZk9yTnQ2a2ZUQW1xamVHQ2VNQlltZjIyWTZlS1BFbFZoK21j?=
 =?utf-8?B?dVJoSUFpVmlmd3JtbVhzZUpRZkZ3SFhENkZZVGt5djk4T2c0a3lQMURrb3hp?=
 =?utf-8?B?QnQxTTdpQms5aHRIQmpGckI1eXcwb0RubXZaVXhNb04wRytVOWF6QkhXSGZL?=
 =?utf-8?B?bjNYcFdaLzFudThqN1FYNVdmSFcwVlZkTG5jbGxxc2hQZTllTTRyaVVNT21S?=
 =?utf-8?B?UGVaemxkdjN6MHBkMURFV01Pa1BSTlhxZVNwaEJOa2dNeGI0NEQ5RmtJRWhC?=
 =?utf-8?B?aTFvYzIzczRic2RiQlVuSTJ2dVlycTVaNTFhU2I2TS9mYlNTT2V0bXRRTWZ2?=
 =?utf-8?B?TnpaY2Y2OG1KRHVadmxjbGxvKzNQa1BsRkJBdmxjaUxzREQwamo0WG5ZMWI4?=
 =?utf-8?B?N21abDZrSFFVVU1VMlVzNWZaQ1U3WFhVQUhhR0xBU25DdU9mQnFDRWI2Tml1?=
 =?utf-8?B?aEwzeWp3TDQxMDh6SHY2TTVZM2RSUmxwa1ZyemRpTXdNZjVEYis1cVNlNzRk?=
 =?utf-8?B?d2ZlVnNIV2hUR1hrRS9SSFllQnZ2MlRVR0g3dEtkdWZ6eUhzMU1sNzV0cVNx?=
 =?utf-8?B?VjFxb21LVHRIWmQ3YXNLQUNkVlBjNy8zbHhzK1dZZFJKMm9FU0JzMXg5UG1p?=
 =?utf-8?B?RTdwei9HQmthS1dudlF3RXZVd2NVUG9TQnh5ZEcxeStTNXU5anl6SElBUURT?=
 =?utf-8?B?UXFmM0VWVGxBcUNKUXA5Y0ppVFcrTmg1dWx0cjV0T3pJaitsOWNWQnV2ZUpY?=
 =?utf-8?B?M1hwYzZ5eXFVY0ovcXQ0cDVsVG5XVFlCRzZMZVl4Z0dacmpuUXJiNzg0RUUv?=
 =?utf-8?B?VFBSbndVNGZyVE5tVXcyOHRNNEloSXkyQVA5cExmY0RPLzZoSDFKL0N2TmNk?=
 =?utf-8?B?VDRIbW4rOHRFVEdoODdITnRSN1IyVi8zMFlYS2d1bjZ4dFo0VUoxSkREZEU2?=
 =?utf-8?B?ZExOaVhxeGFzZjdMYmtGN2dZbDdXSEZMNi9hWTN6a0RNVXh6N1dEZ3kzSW1S?=
 =?utf-8?B?ZlY5NTFxa1FwdXZvUExhMkoxUkpsMGsvNld3MUxoMHpmYS9kSUk3TSs0RkRR?=
 =?utf-8?B?cGRweWFqeUJwL0RDN0JvakVZZmVvSEgyek9FMXZEVHhIckRwUkNnZmNhZ2ox?=
 =?utf-8?B?TXdDZXpWV3BoajlsZnp4bEtZa240NE53dERhOGplNjFRYlU2SXI5UmNmczRh?=
 =?utf-8?B?bUdDUm1NUUM0YUcrWTZ1bmRoVWh2UUNYWDN1bHdSb1lORENwWmVkWFdMYWJM?=
 =?utf-8?B?V0c4WXR2NDBMaXQzMy9qZmV5M21YVFJQM1hQWGNFeGExanRkc3R1Y3U2bWxv?=
 =?utf-8?B?Zit0WmNaSHhsbVZQelNldWpRQkxpczNZaEQyMXZMS09NNTY4UytjeSsyVEM1?=
 =?utf-8?B?eCtaaURXRnJnMkZMdGRXZklQRDZSczVMcUFydTlCZGx4N051U2VrRERwNUZr?=
 =?utf-8?B?UUFIZ2p0eEIrV3ZyTk83eE5LL2lyRWpublg4djBtZVpQd2F0TG1WR3JKQjBo?=
 =?utf-8?Q?oLDAhp6uoMltGw/NZqe+/wbpctRhQQyM?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nGtuNHZ4xPxSa7uXAWkQy5o7SHTIT+aqUhvwILPOnCR0T/2MJ0DEYIFDOH4mPqU0UA36lopZNTZ2yArbMlJbsmTGzNEqU1tCXMvkU8MJYze3AwhUIRLVrawqCo+gRSrWUeygZ1Ebqz7g8qys1PZeNMRDRK6VzC1smp5PWyfBGzmpD6BK9+vmnq17BQ5TqtXRwI/p/kwZpA22r439bSIeRdQ6Bc3CfVSh4o0W+rgh2cg9MpFqAl4inVamHq3cjWjCdoeaHL+0Qw6yiZvozbr9JivE+WLZEfzyGGghMss+6jnLjJ5CAwKwngQo20Kj/p+WkbzIYofvlDTyttiIWEiuM+hYUhJz1evBYXME//Zq881UyA6RavluQwsl5W7KM9YpRnLxoiw/3U2Apy0Km47063ce8rhKDJnZeIjYuL5ZD/+7Hr/+N4n9qEtPsRv1agZFlIrO1eWxUO+XGSPJ5M9u/G6mEmg/JiYdg/FazdWNTDcPmD058C4v3lmDGIuONMuPzEtXCUUqdzNwHbIB7pT+WCwA9c484ct3lltUwXfSbbVaz8IYUupOJiI7PctEkOTUOA8hWXBqi9GwVlo55oGaLxf0KMn/C9CimkyhGTqsm3pCIvQ9gRhL/0EMDJwCLeD6+8TgWycnSnIAilmYLS351A==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2024 13:36:59.3750
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ce9707e-d654-4dc0-b470-08dcca8b27aa
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR19MB5970
X-OriginatorOrg: ddn.com
X-BESS-ID: 1725199820-105333-12934-692-1
X-BESS-VER: 2019.1_20240829.0001
X-BESS-Apparent-Source-IP: 104.47.58.171
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoaWlhZAVgZQMMk0Odk4MdE82S
	wt2cA4Mc0s2SDZyNwIyEo0TjRKTVWqjQUA2BoRZUEAAAA=
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.258744 [from 
	cloudscan19-239.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND, BSF_SC0_MISMATCH_TO
X-BESS-BRTS-Status:1

This function is needed by fuse_uring.c to clean ring queues,
so make it non static. Especially in non-static mode the function
name 'end_requests' should be prefixed with fuse_

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/fuse/dev.c        |  7 ++++---
 fs/fuse/fuse_dev_i.h | 15 +++++++++++++++
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 9eb191b5c4de..74cb9ae90052 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -7,6 +7,7 @@
 */
 
 #include "fuse_i.h"
+#include "fuse_dev_i.h"
 
 #include <linux/init.h>
 #include <linux/module.h>
@@ -2136,7 +2137,7 @@ static __poll_t fuse_dev_poll(struct file *file, poll_table *wait)
 }
 
 /* Abort all requests on the given list (pending or processing) */
-static void end_requests(struct list_head *head)
+void fuse_dev_end_requests(struct list_head *head)
 {
 	while (!list_empty(head)) {
 		struct fuse_req *req;
@@ -2239,7 +2240,7 @@ void fuse_abort_conn(struct fuse_conn *fc)
 		wake_up_all(&fc->blocked_waitq);
 		spin_unlock(&fc->lock);
 
-		end_requests(&to_end);
+		fuse_dev_end_requests(&to_end);
 	} else {
 		spin_unlock(&fc->lock);
 	}
@@ -2269,7 +2270,7 @@ int fuse_dev_release(struct inode *inode, struct file *file)
 			list_splice_init(&fpq->processing[i], &to_end);
 		spin_unlock(&fpq->lock);
 
-		end_requests(&to_end);
+		fuse_dev_end_requests(&to_end);
 
 		/* Are we the last open device? */
 		if (atomic_dec_and_test(&fc->dev_count)) {
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
new file mode 100644
index 000000000000..5a1b8a2775d8
--- /dev/null
+++ b/fs/fuse/fuse_dev_i.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * FUSE: Filesystem in Userspace
+ * Copyright (C) 2001-2008  Miklos Szeredi <miklos@szeredi.hu>
+ */
+#ifndef _FS_FUSE_DEV_I_H
+#define _FS_FUSE_DEV_I_H
+
+#include <linux/types.h>
+
+void fuse_dev_end_requests(struct list_head *head);
+
+#endif
+
+

-- 
2.43.0


