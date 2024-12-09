Return-Path: <io-uring+bounces-5334-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B0399E99C7
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 16:00:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B424A167F4E
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 15:00:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FBDD1F2C49;
	Mon,  9 Dec 2024 14:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="aXNW/ew7"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D46FE222D6C;
	Mon,  9 Dec 2024 14:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733756233; cv=fail; b=NVvHNSZIpzV0FGPFWZ51zrbfJii8fSOnGBf5GuoVQTyefk18EaYqXKaEC6YCBEPKNUkBD4GI9Ezc9SFrYQymMUqjKI4Lfr8/gG3IuBALqM8g4ZjWDGPLnUgYDSz9qwyQogCkhjT+ElXvJGUN33yoL/c+g0d3FBb81t6WW1b0ZBE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733756233; c=relaxed/simple;
	bh=CZr3S7iiYqHqnIv3eTleEfD+5LU4X0VMvfqqhWyF0kI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=UI89LPMB4Wnmg25cYE7Dw1QRX1oA8u1tQZ2Eg1haRq4GC+5YktnDcfT3/qz0UW0mFAMYaW07LJ48abysWbuVYTCUan+vs8ljB+Pm3VmMn4GkFSogL/l5omHgBTeFlHcJHxrg9WVxBzpRhMTaqoRwetovFOD1D2fN323Q/BDM4JM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=aXNW/ew7; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168]) by mx-outbound19-223.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 09 Dec 2024 14:57:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QCIN4Mj+k/4s+P+upM2iTMqWgWalXOGM3h+5ozsTD+hrauxChRFGXf1Nhe25XEu5C8a0jc49VMw/1GI1rtwgRL9JlV+KrCK/VPFL4ofZSLyyQxqkUztSBotLCdq+szxLuzWgRkeYCM8pjJfXSt9mLkaAv4lI+cxRDdeuS8vmut1+HOiz9JoGGNpnVAI8zy3+zFfUlKR9UMF5cYWe5MGfND16OLNo1EwBj8c/epQaePSn2E7AQtT+MY9XRUoBD8Z08KaDpq9T9hfN7ooNvLqjXf5nYyW2/EFUR21eoua9k4z1SoDcyi++6HvZT7+upFJdMiqiiZbyTVu1T2PX5WeEEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J7Iq7p4MbRs+sH4wgNVtfpwoxwBVqkpF837dtxkSE+4=;
 b=njwdknqXiRvE3R7/qh40gtxoEOFR53YG1P0R1cVmkRKP7kxeKWOC0pk7SamnWqFR+jJCgHU0lh5JWPf02+YEAMUMwVHo90Zj7LYNcao6LaY8Ixs0zSjtXvGLYoJNF0zD6WTkB6O13eTTNebBD6Fuw/lLkxf59uL6gzKOD5cgXLCSqssUNzFkEMBaj2LK+FddQ7pSytM9XMRsU+itDCHr8jfLMoNKs/3E5f/GiE5RDa6bWy2GhQooQnkbMEt/QZsF4ZI44wQZKosddFU8A0nUGbnAdFROVaFFLCgJmYO0jkI5E3IOxKRh1ZYmM75p4j7cvddnBZCBRj3XC6H0PKk6YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J7Iq7p4MbRs+sH4wgNVtfpwoxwBVqkpF837dtxkSE+4=;
 b=aXNW/ew749hpdE0XoNNc4DilT897qVDVcLtWxhFlnUDeP7IBJ7fRz7f4+q8RMjldij5OZeYuu0ltuam/MuT+DK51novGqUJQpZVnIpVUuDMwzLdhy0ttlhBOvxv6i+N4Y6Ho+MEJhYUaqtL1Ct1zZqd9M1vT8CCYutiucfGAZCw=
Received: from CH0PR13CA0043.namprd13.prod.outlook.com (2603:10b6:610:b2::18)
 by DS0PR19MB7719.namprd19.prod.outlook.com (2603:10b6:8:fc::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.12; Mon, 9 Dec
 2024 14:56:52 +0000
Received: from DS3PEPF000099DC.namprd04.prod.outlook.com
 (2603:10b6:610:b2:cafe::f5) by CH0PR13CA0043.outlook.office365.com
 (2603:10b6:610:b2::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8251.11 via Frontend Transport; Mon,
 9 Dec 2024 14:56:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 DS3PEPF000099DC.mail.protection.outlook.com (10.167.17.198) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.7
 via Frontend Transport; Mon, 9 Dec 2024 14:56:52 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 7C26155;
	Mon,  9 Dec 2024 14:56:51 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Mon, 09 Dec 2024 15:56:34 +0100
Subject: [PATCH v8 12/16] fuse: {io-uring} Make
 fuse_dev_queue_{interrupt,forget} non-static
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241209-fuse-uring-for-6-10-rfc4-v8-12-d9f9f2642be3@ddn.com>
References: <20241209-fuse-uring-for-6-10-rfc4-v8-0-d9f9f2642be3@ddn.com>
In-Reply-To: <20241209-fuse-uring-for-6-10-rfc4-v8-0-d9f9f2642be3@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1733756199; l=1912;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=CZr3S7iiYqHqnIv3eTleEfD+5LU4X0VMvfqqhWyF0kI=;
 b=5SvKvr+oNHrrErmPGprJTijJglJmlo2AWPzoQKirNNLA2de7tNW2u1+4GY/Z4QQY93XDiLR4o
 fcaaZ/KfUa8CK62MZGMnjzabgG5yVbgs6n2NNT3ptPMNtRKc7439aY/
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099DC:EE_|DS0PR19MB7719:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d03c427-78a8-4a8e-73d4-08dd1861b75d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|7416014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Zm53T1FFMWVtemJvcmM3aC8wU1Z6WWFRdUpmdktlM3FRKzMwbDFGVG1USWd0?=
 =?utf-8?B?WkVKL2pYZllJMXR6OU5uY3hWMURBZnVLaW1mUVJ4VWNnOEtpeitud21mWkFj?=
 =?utf-8?B?R2VDMEl6MHAwVmM3MmZDSnJITFRXKzhwOHQ0NWgrYXZOL1k0SHA1SkYvdFZF?=
 =?utf-8?B?MjRwaWFGM2V2WDMwV2h5MnNLQWlIa1ZpWGR5SG5saXdUbVdBOFFEd1NiOWN5?=
 =?utf-8?B?TDBJcTdUNVhMTzFQYlg3RnIrcmJTcnkvM0RXdjFIVDNQcFN0RWFaYng1KzNx?=
 =?utf-8?B?M1J5ZWpaMEpyQWpDV0dJdDhrSWoybUVZbDhiNzgza1kwUDZ5dFlvV2FtUkpY?=
 =?utf-8?B?cUU0bWVzOThDN0E2UDcwRDF2RDBUUE9TZ01GMDduSzZ0cVpueUx5VXVGVFFI?=
 =?utf-8?B?Wm00U0liS3Z4WHRWdHVMelRaUFMzc2tGYjZOWE56WGFRMVRHRG95Ukl5Qi9h?=
 =?utf-8?B?M2ZNM01HakQ1NUZIeXlrQkZEeXMwMVBGMnZmbHFwR2czQ1NSWmlLa29OSmJj?=
 =?utf-8?B?eTQvc09xMmlid1E5c2FqTWkvSXFlWTNOc2M1ZGhydVhIdGt6UlljenJXSkM4?=
 =?utf-8?B?bW9wY0U5QWZudFNxTnB2UDc3c3pOUDI2WjB5U0RNMzBMQUNWT0lZcFJaQkx3?=
 =?utf-8?B?bGpaVHBHc2U5c0kyZGRPR3ZxS2F1Y1lNS21MTDhhTDRQQlB3Nzk0K2hoR1ow?=
 =?utf-8?B?eldpSThLckhJUDU5dnEydHFJQmJ5aEMvZWtINjRESDdaUndQazJXTi9mQm5t?=
 =?utf-8?B?Wll0aVNXM1EySXp0WWJDMzVqSk5FTXpKbS9GYWlUaVZvS3lwK2JDRUVNYUM2?=
 =?utf-8?B?dEJ5a3pEV0ttNDJyK2lvbzVQVmdCVG9IdW5EanhlUTkvQWwrTUxXa1dDL0J4?=
 =?utf-8?B?bUljWkI0TzdFRUgyK2VxTmFRT0pjdWRUVnVDcktEQzhjc2pjQTRXNkxoa0tZ?=
 =?utf-8?B?RUZFbTVrV0dCMmU0V1VQU21WRFdtWDhqZ256QUZpSWJ6UTI3Q3c0SFhtblAx?=
 =?utf-8?B?MGkrSGNzSzFVTitGUktmT0lpdHlTQjZqVXBHczJpSkdWWDBCeG5zRk1OVEpm?=
 =?utf-8?B?V3pBTFYydGNzMURBM0dRU3RsWks4K09ic1h5eG52Q2FXOVUvQXMvY2FrVDhK?=
 =?utf-8?B?VmRmdjhrSlVVSjB2aGJoTElYRDZSWDA1MTk5ZzdxNjZkcFdyK0NMeE9FNmNI?=
 =?utf-8?B?OC8xV2MyaXNpYUZzcHFndEQvU2FXeWttMWZzOXJ0RUNzazhhSlhLUWtnWmxs?=
 =?utf-8?B?Q255cmFMbkhQcHl0cUU5M0NQcU40UmpyWnFYMlgxU0E0cUJsY0xBUHRXcnZy?=
 =?utf-8?B?enZvRm5GaElTMXZkeGtlaUtDak05VUZnY0tjQ1lOTGJlV1oza2NLaG1VVVVU?=
 =?utf-8?B?WkpyTk1hMGpySFB5SXF4cnl6K2ZtYmRLMml4VVVVeUFSZXhkWnppOHI2ZFdI?=
 =?utf-8?B?bWRmaXdybnJuUVZad3FzcVFZSGNEZm5Hc2tEeHoydFd5UEFJWVFMSUI0Tm9E?=
 =?utf-8?B?Z0NvaG94RG1pbEtuWDNtMkhEQXpibVR1UHErUGpUYS9PN1k4WlB0K0IwQ0hF?=
 =?utf-8?B?UURJZGY1MHNGZEltRm0xY0oycy9ubVREQ1dNOWxUa3R5aHkrU1RIWnR4dVMw?=
 =?utf-8?B?SU00eUxRWmhuTzRGNmlaNFhsMCs5b1RlVVh1S0hZZHd3TzRvLzlmWWRDalBx?=
 =?utf-8?B?M0FpejhLN21idWZRTFdHb1NJRDZUWGU1eDNEcU5YV1ZOT2tEOEoxUHcrb3Vj?=
 =?utf-8?B?L054L2l5RTNadUtOWXZsQlZSYWtseHB3d3pKekpHZVM5cUVGQ2V3L1ppSHlM?=
 =?utf-8?B?YzgvOUIrMnlxaTBwWm5IUDhYcldMZUdlTkk0N241MTNteXNTclRCamprSzg2?=
 =?utf-8?B?U21peUx2OVBhK2UxeVFKT1Bra2s5WDcxYUhNd0IxTXVWQWNtdG5xWlBwNnJJ?=
 =?utf-8?Q?0hEH3NPFHs4N8klCmGQqBvWqx89TNi0E?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(7416014)(82310400026)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	exUCp/fQWHHvHKA9/dhof20C5s2KJvoJu88Uoygl7cSnGgTWLoySUwQ25KVv9570Ir/ORuBshXWYnEEkTEP7MyJX3A2v9XclUQRa746OdEDThzUVLXyHIo3RzdHZoZgjanjz9XmvRhSsPcktCiIuBoHqls+EmM0MOIPPgTIsg5CLC27FMivA2aE7U8mOui1K+DNX0R47qTouipuGmzvm6Gp6T5OCBmWeO7CqHvTbqjwZ3dC8xv1Q13crqQB0Rori5iENuAjL80rJYzSzzW3Q7ACgNTXwyrLG29k56NOm4t/DQnL8OLkFpAspwZa62ejMCD3pcMCJT6IrACJlGMESi5gHv08310zXVhtuf2mKXwPcW/G03cdb+bXSzKzba8dL4dLTDhoGDz2L01Sw+6BYDMWv5iAzvjw4ye0HgjkbwmI4xVUmTGGpOBAOlCuPbX1kkMNSd+hbg4o2GU9xtpJ4xo1j25ZXybmb9HHNdq8GZEH9IYopRNXQtqf4iSDfqRCmLKLdqaUtDviVGxHvAsYQ1qnczLbk+lQO6MMRTS0PkLzsFnao+3JScNGVtYnWKg8uIqIbfSWXzIALNrZ17BR9pAtDz+RfDtpTZeFbqKEGY10tJh+6KmP3ZCXZHxWnn2/I8DfCdT3q0NTX0c053C9e/w==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2024 14:56:52.2165
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d03c427-78a8-4a8e-73d4-08dd1861b75d
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099DC.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR19MB7719
X-BESS-ID: 1733756223-105087-13364-17990-1
X-BESS-VER: 2019.1_20241126.2220
X-BESS-Apparent-Source-IP: 104.47.55.168
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoYWpmZAVgZQ0NTA0tg4ycAiKd
	k8Mc0izdwiNSUx2TLNyCg11cIoOdVUqTYWAE3yzCVBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260997 [from 
	cloudscan15-202.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

These functions are also needed by fuse-over-io-uring.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev.c        | 5 +++--
 fs/fuse/fuse_dev_i.h | 5 +++++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 8da0e6437250b8136643e47bf960dd809ce06f78..71f2baf1481b95b7fe10250e348cfba427199720 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -237,7 +237,8 @@ __releases(fiq->lock)
 	spin_unlock(&fiq->lock);
 }
 
-static void fuse_dev_queue_forget(struct fuse_iqueue *fiq, struct fuse_forget_link *forget)
+void fuse_dev_queue_forget(struct fuse_iqueue *fiq,
+			   struct fuse_forget_link *forget)
 {
 	spin_lock(&fiq->lock);
 	if (fiq->connected) {
@@ -250,7 +251,7 @@ static void fuse_dev_queue_forget(struct fuse_iqueue *fiq, struct fuse_forget_li
 	}
 }
 
-static void fuse_dev_queue_interrupt(struct fuse_iqueue *fiq, struct fuse_req *req)
+void fuse_dev_queue_interrupt(struct fuse_iqueue *fiq, struct fuse_req *req)
 {
 	spin_lock(&fiq->lock);
 	if (list_empty(&req->intr_entry)) {
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index d7bf72dabd84c3896d1447380649e2f4d20b0643..1d1c1e9848fba8dae46651e28809f73e165e74fe 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -17,6 +17,8 @@ struct fuse_arg;
 struct fuse_args;
 struct fuse_pqueue;
 struct fuse_req;
+struct fuse_iqueue;
+struct fuse_forget_link;
 
 struct fuse_copy_state {
 	int write;
@@ -58,6 +60,9 @@ int fuse_copy_args(struct fuse_copy_state *cs, unsigned int numargs,
 		   int zeroing);
 int fuse_copy_out_args(struct fuse_copy_state *cs, struct fuse_args *args,
 		       unsigned int nbytes);
+void fuse_dev_queue_forget(struct fuse_iqueue *fiq,
+			   struct fuse_forget_link *forget);
+void fuse_dev_queue_interrupt(struct fuse_iqueue *fiq, struct fuse_req *req);
 
 #endif
 

-- 
2.43.0


