Return-Path: <io-uring+bounces-6021-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 26E01A16527
	for <lists+io-uring@lfdr.de>; Mon, 20 Jan 2025 02:30:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 46E213A0591
	for <lists+io-uring@lfdr.de>; Mon, 20 Jan 2025 01:30:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DB3215E96;
	Mon, 20 Jan 2025 01:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="lXLjqOa6"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8D833E7;
	Mon, 20 Jan 2025 01:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737336603; cv=fail; b=d782KA259NyAuBQXrsIziP9sJG6w4QwlGhUQLOESo95+UcUBGIGXsV1SXvCd13+lL1lni4wMQEVOTcNYDZghMdXFKz+qphK1p1NmoLl226LKM3j4Z1oKFAMck2vGRO6qsPFAI2SuVeXUp5Me7o8SPCo9ulNUv24cJTb4WxayG/o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737336603; c=relaxed/simple;
	bh=1c8nwG+AvizMXYL6lMtMaTcWJG4uUtDdhcv5gi9lF1E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=a5yZEFZWTKfiEGAlYec6SJFrIb+WBbmdMlRroidDwQQA4BzKrun+4B83XOly0xppQ1EXrRfy0RNdrFm8t3RydYMLKcP//ugW+HrZEiMdbXdc243yvEQUT2vy/XdCZX58iiv1lm3O06NiqhEMOPrBfnMV+zs25sacLQm/PUQg2X4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=lXLjqOa6; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173]) by mx-outbound8-131.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 20 Jan 2025 01:29:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IfrsMI0DvJ01VgrHrR8mpDmMItfDtQ8+TXViAeuMHXeIbDdu1oDHB3YpBejhTyuA9QECBQNCcd9SpeSCKt1BRzvmyuh0yUgb5Vg4J7rWljYBP5riRLWIDDoZDZYZhIn0n1b5vlB54DzwcvLkZJuk6ZVw3GC3DX1QLUKRcgmLb+IygpJgSvwOM2+961lX51bV3rL34JUdyholDREIeBfHlJw1xjSQPbuoNm17ziZtq5p0RCwwG/KKloGoX5TAPd5PKbsDOUA7a65F/R3o2Z/LTqQxnh7ie34o88uKDrI6UrYDIcmMkvNM5cyixHzjYm21OQodUzVFPc2jBzu8LYwQ+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KUliw8EoMQP9g855liKYfhxuE58FbYehdsrFaAXSFjc=;
 b=nAT4F5WnNqPbWeM38xsXXr+k7zixmUyA9Ody6XNGvsbr96zugGs1osfc0CyoOJU3Z5wZ4ZB1J0gOaHuMPoofgL9dpQjNo2/k6jNfFBEvju8xGqbme3h/v2iNh3Rjyqd7AlVdXMut4CylP8uX1WuFKk4aAO07AENq0WbUKJNRLVFYbZ4QM0bqySjIw1Ws2blblLNA+2CFIT+a2lhpV8KZMidu7tFN51iKgpDWBNvFg/FngroMMDGqUujcuQRI/9zXheCHA4sIM7XxwGVnqKOH94MLqsjtRmpLLCBWh4BFXAs93lSKBgpdrQwHhKy2gcVgnnnund4NYdK0vExa+nBwBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KUliw8EoMQP9g855liKYfhxuE58FbYehdsrFaAXSFjc=;
 b=lXLjqOa6TZ8qNcCQ5M5JYWYyGIjyuCz1+hjfoHfxcxqrTBZX3MJAC1Erra8MeQEbMjbWgzK9Z+5+F6uucGQCVm0DRFYBMUIVALkZFAbx3jf9HJ0YHM8/HZeHJnChiRNaVjJnh/EpZlgym05ddQIMXlNj4d/84OCdV6+ykZ8+mgI=
Received: from BN0PR10CA0016.namprd10.prod.outlook.com (2603:10b6:408:143::23)
 by PH8PR19MB6788.namprd19.prod.outlook.com (2603:10b6:510:1bc::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.20; Mon, 20 Jan
 2025 01:29:14 +0000
Received: from BL6PEPF0001AB73.namprd02.prod.outlook.com
 (2603:10b6:408:143:cafe::dd) by BN0PR10CA0016.outlook.office365.com
 (2603:10b6:408:143::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8356.21 via Frontend Transport; Mon,
 20 Jan 2025 01:29:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 BL6PEPF0001AB73.mail.protection.outlook.com (10.167.242.166) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.8
 via Frontend Transport; Mon, 20 Jan 2025 01:29:14 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 8FC0134;
	Mon, 20 Jan 2025 01:29:13 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Mon, 20 Jan 2025 02:29:05 +0100
Subject: [PATCH v10 12/17] fuse: {io-uring} Make
 fuse_dev_queue_{interrupt,forget} non-static
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250120-fuse-uring-for-6-10-rfc4-v10-12-ca7c5d1007c0@ddn.com>
References: <20250120-fuse-uring-for-6-10-rfc4-v10-0-ca7c5d1007c0@ddn.com>
In-Reply-To: <20250120-fuse-uring-for-6-10-rfc4-v10-0-ca7c5d1007c0@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com, 
 Luis Henriques <luis@igalia.com>, Bernd Schubert <bschubert@ddn.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1737336541; l=1912;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=1c8nwG+AvizMXYL6lMtMaTcWJG4uUtDdhcv5gi9lF1E=;
 b=eV8hMKVCtQcZZPFw1YuocAHHIHOgx9yIE9SUNYYxbxOflm/Rnhvm3C8Ocg1NpuCzQhOkDpx0o
 NMMcVkJGiESCZ4anlt1cRQhoQcApAp/ZeuK0IFsPBjuk/FFXi7GJ30q
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB73:EE_|PH8PR19MB6788:EE_
X-MS-Office365-Filtering-Correlation-Id: 27ed0c1e-c8e9-4481-c910-08dd38f1d9a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|7416014|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Mm1ReHkrcURwT3B0b2g1QXlzWjhnMGJXOUVkcFBoNHU3RWkybiticGlHZDZ0?=
 =?utf-8?B?emd4dnBVZW5yRityQStkRjBlcGsrRnlrZmVDOFlBMXhxQS9kdUY0ZHVBRWkr?=
 =?utf-8?B?TkM5TlpmT2pLam5INUFKTG8zVmJyZ08xczZYMnRtZzF5dHJhT2RISE51dWor?=
 =?utf-8?B?dGpYK1NUWnQ3NTB4dmxwZmY2MmVxZm5RWjlqamFHTHF1NFVtNm9lODE0RGlq?=
 =?utf-8?B?VFZHbzN1djUrcE1YenZWQ3FsaXF3cDBaWmNWZ2hYVUMyWjBVTjdQSzFvS2N2?=
 =?utf-8?B?YVdLb1hsN0dnbFZ2TnUvSloxV0EwSHJ5c25RalBRMVVGOWF4YmhmY1lUdVdZ?=
 =?utf-8?B?SzFEaGMyamNHSzZzc1MzMVR3Sjl1RTZrcGpXQ3NkT2YyUzdmdEh5M0dGSE93?=
 =?utf-8?B?NHRzZEVncC80Mld1RVlGaXR0c2hKcUhEelZmdEJkUlRueXVvTjJUelBHV3Fy?=
 =?utf-8?B?dEEveHNuVGM0dU1XeXBlWUsrcVRkNWNRdGtCVFVabGo4ekszemNJRWY0OXk1?=
 =?utf-8?B?dE9DdHR4OCttay9OeW1RckV0MjMzY2wzVDJlSVZtdk9xYm5kd2JEZ0poTy94?=
 =?utf-8?B?a0x2VGw4VUJIVHFqUjVPNEdHc2xpWHBHUE56Vi94Zm4xTCs5RmdzbzRKUUpL?=
 =?utf-8?B?d3UweGtlMzFsT0U3Y3orTWNRY1liR3NQU2Y5TzNCV0ZkUjc1UklJWDdMOVU5?=
 =?utf-8?B?aEY0L1dRdjN3K0hWZVpidm9pU1RhRGJIY3Q4WkV6bjVqZFRpLzVNQUlQVlpN?=
 =?utf-8?B?S2UzU0lqTWVXSWFhRE5xTE0raUZ5UENQYlIrL0VuTGoxL1d4WTVLcHlCZm1Z?=
 =?utf-8?B?ZzlDYU90QTFXYjh6cXhZQ3FVZy9wZlgrZzVsalFIdmNYVEtRNEIwblVWZTNI?=
 =?utf-8?B?MUhMbURPYjZTOHdTMzhCaG9PZERFM1QrTWFXMG42YngydzFNbnZSMEVtUGJx?=
 =?utf-8?B?SUFaNktrZE9JR2swSEtRZDE2OW0xbmdoNWVpVmtydVZLS0dGWGZyUTl0WlNY?=
 =?utf-8?B?aGtRUWxEZk1jc2JycHF2Rk1mV0t6UXhQMFV6bXIyZFVqckdsb2kxckkvM05s?=
 =?utf-8?B?Y2Y3VjF0YUlWNkVicmkrWEY4Y3pxbFRpUklrZFpveUtYLzBLWGxVK2s4K2lt?=
 =?utf-8?B?MkhnYWVsYk44NGZYbmwwVWRlRHhNTk81ZmFuaDRBQ1J2NWtsYlpsSmFuMnhK?=
 =?utf-8?B?Sy9HS2FVUm1yTzlvWmM0YUVobkd3NmtCZlUrQlRUNG9IRXArc3hnb3RkSTlF?=
 =?utf-8?B?TWRaSHAvQmxURHRTRE1ydU5lclRBNzZPZUprZWYvNlBhVElha3JjcTlud2F0?=
 =?utf-8?B?YjhWMVhuQWdLcmFudUNJU0VDV25wVW9hUjlUOTJmYXUvVnV1Y2Z3dlJabStm?=
 =?utf-8?B?Q2gzTHdBVlhrNXR4U0dDNjNsWjhnSjBnaitMdmpLSjJEem50K1kvVS83U285?=
 =?utf-8?B?ZlRiZ1FNanNtekNoampTU1pzdjZaTk5vM3Q2akw4MUdzZzl1WFR2NXpjL3oy?=
 =?utf-8?B?MmpTV3ZaRnVLdExtOFNkWDl0UlJibmpOL2tOUm9ubFZod0lIeUhja042TFJP?=
 =?utf-8?B?NlIrVktBVHArcFBNaFAwZGl5SnZ3TkVMNkVkTEdNZUNFMlptWHdOMkEzMjVs?=
 =?utf-8?B?N3dTOEdhVmhYbnFFL0d2YzVHRW8rM3dJL3l0ZkpVdnN5UGJ0VjdpaEw3OHgw?=
 =?utf-8?B?enFqQytaaWxaUWwzWHhVcDNxa1B6YUV3M0JiaHRTRWlJY1k5c25UZkxHbFYv?=
 =?utf-8?B?bjUyT1MxcldJaVQyRUZJc20vUU92a2RoQU9WVzhxR3lMZXJKL2RxK0pJa2lE?=
 =?utf-8?B?LzBtcFBicWw2MGNhUjJzQThndmd2TnRYY1NkT2lkVkJHaEI4c01kbjhCVG1x?=
 =?utf-8?B?YTB5TnBveTM3YW93VjVjSjNxc2dLMW1TbkI3b2dzb3dXLzN6WGo5eU04NDJk?=
 =?utf-8?B?UXNUakRVWXFHTGxnUzhtWmVFREpjb3g1ejRlUkpYNFAvVjRiTzRnckZsd1E5?=
 =?utf-8?Q?tcTr8yeuGyk2J/NwYO10dBIlMUWbP0=3D?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(7416014)(1800799024)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nozewRCkwqkXvoqc2NYxN2shXShJ9UHzbY/yEFNN77upBv9dJYPbfk3iFgocRUguyieKPq1f/n+s8QPZpaeOIgOpWyQ9lSst7x4fctEdyvJsJIPwre07idxRAyg28hmhpBoEvI/6espKLSlOnyd95WJImXX77r1BOujf5IHSmbqoXEWTkpT8iInzL9pO1FbzEhrRD7p0b4jqHLFdZ1UiVaJsSjgvKhQE3NXjTfeBgAdxM7lddtB4PG9bvYlUFw5CRuLvqSxXRAnordLsrIn5hkF0COWaPCxHTvNHx4xJ8bQNuE8FjKVUeJ695jj5peLpiVDssxp3Z576iRnVsLO3OWdXl4PpSv+eC0aGUeMzlNYLezMsdV6xKHplaNleE5zRO1OeeQCwHlMZJgG2lkI19Uyz95+GzM8q49P8oLSSUaSxP8/sZr/hu6TZtXZG0vwk+3LyNRYBzUI9qWrl876q1ggIdU5XstoHCphdJnrHL2FVg7TqrLicUv6yJX/Tw4krp1opJOWBQ3ep9BhoSfCuxHzO+sBd3IR2x4qWYdhB2gKQTWPWDAHfn8AJ0MgdDjKc3BNtWbcGiQl1rWXjBqt/U9l0aF+3wdoEOC26gdXoQc5tmFH7H+jcOo4Ijhf071suiyTon5EkjZujLfFUn8eNhA==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2025 01:29:14.4841
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 27ed0c1e-c8e9-4481-c910-08dd38f1d9a7
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB73.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR19MB6788
X-BESS-ID: 1737336558-102179-13330-11601-1
X-BESS-VER: 2019.1_20250117.1903
X-BESS-Apparent-Source-IP: 104.47.58.173
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoYWpmZAVgZQ0NLM2MDI0Mgs2d
	Q41dgkzcLCwMAkLdHS0sA4zczUPNVYqTYWAOzGOQdBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.261928 [from 
	cloudscan18-185.us-east-2b.ess.aws.cudaops.com]
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
index 1c21e491e891196c77c7f6135cdc2aece785d399..ecf2f805f456222fda02598397beba41fc356460 100644
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
index 599a61536f8c85b3631b8584247a917bda92e719..429661ae065464c62a093cf719c5ece38686bbbe 100644
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
@@ -57,6 +59,9 @@ int fuse_copy_args(struct fuse_copy_state *cs, unsigned int numargs,
 		   int zeroing);
 int fuse_copy_out_args(struct fuse_copy_state *cs, struct fuse_args *args,
 		       unsigned int nbytes);
+void fuse_dev_queue_forget(struct fuse_iqueue *fiq,
+			   struct fuse_forget_link *forget);
+void fuse_dev_queue_interrupt(struct fuse_iqueue *fiq, struct fuse_req *req);
 
 #endif
 

-- 
2.43.0


