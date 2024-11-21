Return-Path: <io-uring+bounces-4958-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8074C9D56A3
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 01:17:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 404BC282D14
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 00:17:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D46210F1;
	Fri, 22 Nov 2024 00:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="nZxeJPwX"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1874430
	for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 00:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732234645; cv=fail; b=oEsn6dDg8j7ko9/QO671mW313IX3njM/CrLInZWXNtqNJQ9QnnxjcbfJ2+vkSIS8clVpvTN/wL8OAjzVnKJ/5X/EpBpazs/NWIqrLXnHI/vbtunLiUXB6L+mf5T9hazr4xHlhrA9k40q/881q3heDYhyKMdW+0sgXQHbjHT6dUQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732234645; c=relaxed/simple;
	bh=RPMoUJAyGbvfklGj9MFjPFXF+FdPkav2oMR/f11YLFA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=eXzhlZDiKGGFJs4Dj7RknyRXfUYR4+sdDqLboq+0qrLMeW0ZvfR5z9j82pF04KeLe6Lgeq81BJnr40AMnthYIQJjF9HBX4lALObGglgz7Yh2cmM6Iwq2709DVVEWCpkhTEFw7eFZK9cNYXvc0u1IWDmInMGPKNNUuQQZs584Usw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=nZxeJPwX; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2048.outbound.protection.outlook.com [104.47.55.48]) by mx-outbound45-128.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Fri, 22 Nov 2024 00:17:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kSMoVPatx++FKZciwzaWelFqbn7Yhe0Zd2Q7d5fe2jj8oaAjt1GDM70OgTbwUkhgJLkiNoFn/shUKSXhAFR22v2GYiQU6aKiffPYKiJNa5r8zWoXgxjE1Y1Vq/yHpCmJXDwYjSkg6q2X+TQ3PUU6KL/GthV+rShyv/bWCdGB4V/phzYwHE5tgTl7r3w8vc5Hn7TkPUws1G//8WraDWt/1VT0uyuhvY4tNDbR0R865XQUNVA0ZDeXVGfVOq/9sLGiepNvTDbEoVMaZPPrllfYlHOFynjPF+x9v5YVbMMc4dewHLRSUn+dF6VME9q+OToczSTr0TJGGpFeN9/sCrTOlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bY/bc5cdfc1CLt9Gt+/8H+rAOdd42MJp98Xf5wUpVIs=;
 b=Na+xPN/bwAQwf7zJIX8WClAGbUc1yAe4YOv3rfGcLOmk071MlTwWCVmqOSKNOTHCMm53Wcyd7btfE67lO7TaPaKtf8k1hQJQPq1oMHzDsEbxcAaxWZmtQml3ezmRV+07J+jT8jGHSUd6gKQ4BrwwW1vfBgWVBZR81w2RJjrpTHii2VXJ/6C7SgZ7JB8gcDdVdKepNUufz8xb+eBelFPVelucYXSzmGciAy5rv1BLUu+Ex6QfWMcpZlRn/eDNm5DULckS6xfylgA0sDpg3nD5+MVY4HRjpxRb4udp9wqQ1yBOjGhfZR8+kcYhe83G7eKf7V+UxJng6HGO7ei7tntVUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bY/bc5cdfc1CLt9Gt+/8H+rAOdd42MJp98Xf5wUpVIs=;
 b=nZxeJPwXAHbT1mM/ujahLn/0qwztzqSVWd/zZQ4tunN6mLjryGyr7ESQGuTWPf8qAY0viQpDSNJ+mctkEqIY3AvY3/tzMY2W9gmS8FjcH4x7UD9PxcU0dFNwfUHqoiEZTzRecx4Jjw1wKIdLs7o5UDF0h2zuCj5Kfb2YP3njbCY=
Received: from MW4PR03CA0006.namprd03.prod.outlook.com (2603:10b6:303:8f::11)
 by DM3PR19MB8337.namprd19.prod.outlook.com (2603:10b6:0:49::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.24; Thu, 21 Nov
 2024 23:44:07 +0000
Received: from CO1PEPF000044FB.namprd21.prod.outlook.com
 (2603:10b6:303:8f:cafe::dc) by MW4PR03CA0006.outlook.office365.com
 (2603:10b6:303:8f::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8158.23 via Frontend Transport; Thu,
 21 Nov 2024 23:44:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 CO1PEPF000044FB.mail.protection.outlook.com (10.167.241.201) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.0
 via Frontend Transport; Thu, 21 Nov 2024 23:44:06 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 7981832;
	Thu, 21 Nov 2024 23:44:05 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Fri, 22 Nov 2024 00:43:32 +0100
Subject: [PATCH RFC v6 16/16] fuse: enable fuse-over-io-uring
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241122-fuse-uring-for-6-10-rfc4-v6-16-28e6cdd0e914@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1732232629; l=830;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=RPMoUJAyGbvfklGj9MFjPFXF+FdPkav2oMR/f11YLFA=;
 b=q2nPWX9ypTPCTXtOFudBUgw1AmGc3syBba6f7a9Uqu0X2LEfJkEOKcKZfcAKbx+W/zxD43pPh
 xHqMux5081QCstx4Cl+wXDYwXQClPkfGAaf0pAdrvw6G7meeVpesriq
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044FB:EE_|DM3PR19MB8337:EE_
X-MS-Office365-Filtering-Correlation-Id: f81ff883-d2e9-49ab-4d6a-08dd0a866357
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|82310400026|7416014|1800799024|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
 =?utf-8?B?L2YxNC9pUFgxTCtoeFZaeGJhbG1EUEpkK1hxUmJkV0JWWmZRTDFUbnlCQ2FW?=
 =?utf-8?B?UlRITkRDczU5MUp0elMrb1NnVzh3cFZnUXdHcXBEMlVJRmwxMUZqOHdTeTFq?=
 =?utf-8?B?R0ZvcW10Tm81UDd0cXc3emMvWHRyemp3ajJ0L2pEUDJ6ZVIxMEFFU21kSDhp?=
 =?utf-8?B?Yi9NWVE5RHRESTBOZUh2aFMvaDljRU5SNGdvRERYbFpkYm8vRUJRd24zRlhN?=
 =?utf-8?B?TEM2d0dCdUdKVmtNcHlHcC9kRitRaGw5alcrTEJrRTRHVVEyc1BMV0hIRldv?=
 =?utf-8?B?YjU4VWJEeXpMaWo2anhIRmsyMXAxOFd3a2UzQXZBS2VhaEtEd2EzV2hNd3dI?=
 =?utf-8?B?dGlmZWhTWmZFM3ppNWVoZG9DNHdodG5qNmF4dE50aFo5dkllcjJ2QXVkSU4z?=
 =?utf-8?B?anVNTTVVMWVLTFd0ZmxxblFzTlNrMEpoZHZJNm9mM29TN3lpbDJrcWNYT1R4?=
 =?utf-8?B?UWQvc2xsTDZWdCtCRkdObGRQSXdzN20xSG8zWUFaTXFXU1NHckg5OTFaanpU?=
 =?utf-8?B?TXFQZyt0Mm1Mb1JtUXVlMmNxeGhoSlFCcWZYTVlZSUl0N1Q1YmZRSkxwK3RN?=
 =?utf-8?B?YWNMK3Z1eDhxYjMyOHhvYUZLTnM4cUpKNkZPU01KcjM4MnMydjA1OWhoN1Ay?=
 =?utf-8?B?L2pOVUV4UXVRbWY0SUJWWERCTVhoR0ZlNGFodHNlMVIzZzNjYnBQdXFXMnBm?=
 =?utf-8?B?UFZEc0hPYi9UOHFoZTRjTklMZ3NxZ0E4L094NHlHd2lNbGdTaForR2xrZGtW?=
 =?utf-8?B?dVJJYkFXcC90UE1wbnFIL3p5NCt6c2wvQldSS2dxMm1lcTJyYzc3SHhGc2pV?=
 =?utf-8?B?SVFoSjZYOXgvUG9TSnNVWFFZM1NhU3gyYis5cWhZSGxMMmtHQm41aVFwM1d2?=
 =?utf-8?B?K24yalZ5V1I0aEdTREwrNFZNNzNFU0M3c3E1Q0M4TnF4QlFYaGZIMzA0eThJ?=
 =?utf-8?B?V1o5SjBUMnc3UEg2RFJUcVFSUDZEWWFjUkJZYW95RkNicVQ0Ti84VWl1WXU2?=
 =?utf-8?B?LzJiNElwWFlBeWx1Qy85a1ROR2NqdEpJeGJjTTFEc0s3R0lqdXptcVpEVTlX?=
 =?utf-8?B?TkJrWm5MV3RRekNEc1A2ZlFhNTZTR3A2ZGw0SGh3UGVUOUF5T1NYbkdsbmY1?=
 =?utf-8?B?SU1vditDcjdmcVdSMUxxRVVTcERCNGQ2TFE4aVhlb29TbHgwVTVhK09nejZx?=
 =?utf-8?B?bnhOVExFajFrMXIxbFdrbi9JL0I5OXNWb1BCQUptWDJKcHlVcjJBOE5pWllF?=
 =?utf-8?B?Uit2RnVxcWhaYzhBNGpMYXpTZUJ4UHVSRlRDam9Ud1BnMGlDaEkzeEdLL1BC?=
 =?utf-8?B?YWpOa2hmRTZhVU1XdWZPTnRMem5yK0lkeE1Eejg1bUxscjFRdHViSUlPTkYz?=
 =?utf-8?B?MFdrb004L1dkemVnaXZGbUNrTlFPci9sMFBmc2lvYkFyYW10RlM3QkRMV3dR?=
 =?utf-8?B?cUhFR2VxL0VMZkE0aHhjQ2hIdWRxeW5IVnlqcUlZWmpZM2tkQVhZNW1pa1RK?=
 =?utf-8?B?N1VHdG56a1RzQzF5YmN0TUJhdHZOQ0lmMGdMaHkrUy9YbC9kWGtQdldWaHFY?=
 =?utf-8?B?SkhNWUE1cmFYek9vMFJFOWNmczhkbGlRa0xIK21WWXpuWHlTWWp4UlhUQ0Ri?=
 =?utf-8?B?QW1KblprWkIvalJ0RWI2ckdtUVVEaFhETWJFcHpralAvWm1HTWxvbCtLazMz?=
 =?utf-8?B?Vk9VSDdQZytOZENmTTJJNkU1U0FITEw3MitLMUhhekh5Qi9UazRyU1JpVnor?=
 =?utf-8?B?VHBRYytFT3c2VWtObWY1bWp1MHJmWXliaUpibEFEc3JzZ1JIZngrZ0ZIYjRW?=
 =?utf-8?B?L1RRK0FyM3cwMHgyV0Y3eUhRWW9TU3l5MjhTWGRBZnNJTGx3ekZSdXQ0TTVo?=
 =?utf-8?B?MWt5elBMNUcxQWFvckVvb2JOZmVKQjg0V1FSMkFwaUJ0QVE9PQ==?=
X-Forefront-Antispam-Report:
 CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(1800799024)(376014)(36860700013);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
 fA4FTlXbL7KTwMZvgMzvVmhBajv/yVJfZLekhDY3p8ErA8xBgTJel4OkOA5LCpXCkOrU64XAXcbEkhO/H80767X8tZ3n9BtrL4gcrupXGZMCFTlbuqdGZboFgGObJp7AZnVOkFRsvp4k9lee/PF0yt1zDGcROPwbRZL59AAL/qpivj/9CmiI7WOOKc/rVtWFlkCXj4v6ebJoR9voZfukVFr5eZ8BP8MkSwAXvnZkBgdJyC1mUpVX1Cm2JuXQYjt84JAT13t+tfZquXDysHKkQFjbd0UbxmXN56PTmljX1A4p7qAlxKQfUibXOleyDd+v7ODlFMdbqwwSKvlX9yuE3Qnza4GxAhpCFhBxS2RiuJCr6qQKxUnZrl3adRfajb4AoP6iRJV6oNFEI2iiUXjNoTQ/PsVPVLa4YSyURPIfI6oAf6EzeQQ1gxfVBlqKE54cldIBHWKxhlN8ZMl5FY5MPxMUGHxPi6TY2lrE1p4OlMEj9GWCcu2XeKrnQs8N89neYTVsie4SYKwFyBavFB001325mMZiaA724qv6i3f1DSEuQL6sGCyqvYaCzJFXCFuXfxPYmNu+RVifJkZEcW3K+rU9dJ5t1yHrnLDlFToLSv/RgWbFFPrloXMZTIDD2YawWC+zi6CTKTnWzReNWs/VaA==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2024 23:44:06.4102
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f81ff883-d2e9-49ab-4d6a-08dd0a866357
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
 CO1PEPF000044FB.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR19MB8337
X-OriginatorOrg: ddn.com
X-BESS-ID: 1732234642-111648-7014-28551-1
X-BESS-VER: 2019.1_20241121.1615
X-BESS-Apparent-Source-IP: 104.47.55.48
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVhYGJkBGBlAsOdHAxCjZ3NAyJd
	HI3NAixdjA0jApzTjZ1MIk1djI2FKpNhYAOP1GQUAAAAA=
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260588 [from 
	cloudscan15-143.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_SC0_MISMATCH_TO, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

All required parts are handled now, fuse-io-uring can
be enabled.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev_uring.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index b7a6c3946611a9fdecd4996117b45b3081ad6edd..91105b8f674baacbd3b16bede8678686ff2c1896 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -1122,11 +1122,6 @@ int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 	u32 cmd_op = cmd->cmd_op;
 	int err = 0;
 
-	/* Disabled for now, especially as teardown is not implemented yet */
-	err = -EOPNOTSUPP;
-	pr_info_ratelimited("fuse-io-uring is not enabled yet\n");
-	return err;
-
 	pr_devel("%s:%d received: cmd op %d\n", __func__, __LINE__, cmd_op);
 
 	err = -EOPNOTSUPP;

-- 
2.43.0


