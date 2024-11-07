Return-Path: <io-uring+bounces-4554-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A9C69C0D17
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 18:39:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7EABC1C209E3
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 17:39:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91555215037;
	Thu,  7 Nov 2024 17:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="HKShBWK6"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11094191F6A
	for <io-uring@vger.kernel.org>; Thu,  7 Nov 2024 17:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731001146; cv=fail; b=ePJRilwpTFMPTjJPwr4kkAIwzhr+wqTguSzWQpC57XjnMvpnF8d9+NItgixUuP9kkHcWOJKTkG1nzJPLIBVTNYtY0YUTdyYgpCjOwoStjeRgQ2DF6KwH9RTrzYRaHuGLxE3SrtsOwWaWO1V8bf8WBcOEDpYwjCu2BDyw1RypUG8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731001146; c=relaxed/simple;
	bh=pqs8+uHKychBzoVzjSd0VEAPsAXd/lQKOxkL96xcE3Y=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=cDzOgOkrUxPglRxXVG0AYiTdw5fjveumEKPkY5yMazIXtiOb7foAr4msq7UViTEO2BF1HMz5/XxxE0p4zCP0/PJc5p3UlOH5EPHCOHJeAqVjeN59JL83lxNLKezClKEaM8XJoH4UbjqSA5Xr+c6BKH9uxSKCrlMU347/+1FEwKI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=HKShBWK6; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170]) by mx-outbound42-219.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 07 Nov 2024 17:39:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MQuvNPlLduceWQLOWQDziLaH5DzrlZTfVVLRB+TGjRdtuj6Eh50Yzb2cX76vMIifxBP0ia51+D45qsAQpU9dPkB/oTlqickoPKpz6fklbc8z1Y99M6Pb7JVQpof98ouzuxsQA2TQTBYda2E/1h+3zupCif36SjK3gpLJXyV+1RrG1qqmVThfPQ1Dtyc2p0m7rehCJfnkqjCDLpMtNAS0F8V4NyKR7+VkHQM6FdcNsauL8Yopx5hktBlJawbw1ISaMBFih3Q9M8DAG5ReEExq86Qw2Te5v5u52qM2QZDNoetqh++W4ERTGB1MxONXaVU7zd2bSc1gaWKW+V0o1943zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IKZMT9i96rzTVaQaCIUyI8m+ttkF/mzRjtkzGqsuVRg=;
 b=WzWFKEDWNAQnpyXLUg5bicQzMKc8ZoZMHVaevySwUc+G6Z26AIvL/9yE+nTe5Y6mVaOqbPtygX7lNl6qfX1Iiz+rZPaWwr73dJA5eTgj2+YTDznzMJ/GZiezdbgXBti3Lg5D63TOHQQzhPznU7XwjEQc+Sa7GKix0v7xOw6HuyoQnDbdgxsqgqz5wuU3OEqJvBJNxKrDYqD2JeIflfKsHnLyNTlOjoqGRNN8r1Oop/lK77sCMi6rsvJTveOvB1hgDdIm2nT4gSxLvThUmTsFfsEjROZqFA2Yn2u97tqn9OoqM6BCC3IcdCLXRVDzL2LnMaBjBPUjaPKDI4NU5D5+rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=bsbernd.com smtp.mailfrom=ddn.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=ddn.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IKZMT9i96rzTVaQaCIUyI8m+ttkF/mzRjtkzGqsuVRg=;
 b=HKShBWK68mTaU6w4Ux3y8NZFlf+0BZjvn7ayTIhVf/apNlQtaFoKaffmwDqbhT6I2idQZvSXpzCnsGoa+gbuPd5/NVrp7pN98k15xY/+SzoUS5/V58ixnWyVmXW3P+bPSt5i01cAuqvtILaGfhd1kSVJTP5ZczVCLSmKY2m3H0A=
Received: from BN0PR04CA0119.namprd04.prod.outlook.com (2603:10b6:408:ec::34)
 by SA6PR19MB8651.namprd19.prod.outlook.com (2603:10b6:806:413::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Thu, 7 Nov
 2024 17:04:26 +0000
Received: from BL02EPF00021F68.namprd02.prod.outlook.com
 (2603:10b6:408:ec:cafe::b0) by BN0PR04CA0119.outlook.office365.com
 (2603:10b6:408:ec::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.20 via Frontend
 Transport; Thu, 7 Nov 2024 17:04:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 BL02EPF00021F68.mail.protection.outlook.com (10.167.249.4) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8137.17
 via Frontend Transport; Thu, 7 Nov 2024 17:04:24 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id DE9127D;
	Thu,  7 Nov 2024 17:04:23 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Thu, 07 Nov 2024 18:03:58 +0100
Subject: [PATCH RFC v5 14/16] fuse: {uring} Handle IO_URING_F_TASK_DEAD
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241107-fuse-uring-for-6-10-rfc4-v5-14-e8660a991499@ddn.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1730999049; l=1124;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=pqs8+uHKychBzoVzjSd0VEAPsAXd/lQKOxkL96xcE3Y=;
 b=U2yofiJxigmBdRtzuP/z3XSnvYfzHfGfK4SRjk+kFOswXtvCjs8DOd3kmwc/bz2wwlouOd1nh
 slUfrIJ0eD1DMdGHHy1os1RN7KEwu6dre+4qQVeYnqK+R4XFRqI1UW3
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00021F68:EE_|SA6PR19MB8651:EE_
X-MS-Office365-Filtering-Correlation-Id: 82f95f39-b217-4dd5-670c-08dcff4e3b7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|1800799024|82310400026|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M3BYV0VTSUtXT2dTd3ZpVzkwZWU5eldGNlVTSzhzRlh3RkVESXVJWDJkNTRv?=
 =?utf-8?B?VkpIVWNrQXNldzNpT1pxd1ZTand2S1o4Qkl6YXVxZHNrLys3bFc4Zm1FMUs2?=
 =?utf-8?B?bVhVcWJGdzZtOXdJVUl2VmVJV1gwWmlQaEZSclM1Z1NnUTdpcVVlMzA3R0xz?=
 =?utf-8?B?SnRjWVd5Z0ptem1sTGZEV2FEZG1Fb1NMODgzOUlWUDRPRlRBRWt5RXZ6TzI0?=
 =?utf-8?B?b3Bic3BaOW1icDBZWHdZZ3Z2cjdzbjV4ZU56T3lzdUk0U1IzUm9CMFRLbktL?=
 =?utf-8?B?bVlaaFFabVlCbDZYbGhWZzBDbVZhbkFiWHJqZElGYlZBc3FMUHRoaDhmZzUz?=
 =?utf-8?B?SHdwRkg4ZUpEeUE2TlZqZ2Zjb21DSElmTU12MTVsZnl5OE9JOUU4RmNaQmxi?=
 =?utf-8?B?QTNOSllyM2lwY0FJeEZLM2Q5YXo5dVAzWmJaTWt6bkJzeFNMU3ZmZE56S2Ez?=
 =?utf-8?B?RDFpdEt0a1dxUWNad0llcjVLKzJUckFEZHhhMGJEZmVVdWtCY3JXaGsxc2Rh?=
 =?utf-8?B?YldwQTNTNkVoZXpBL09FeDNiQmlKclByY0JsS21KMkZLeTZMOURyUTV4VFdU?=
 =?utf-8?B?U24rd2pXcVcrZ2xwYXVxMHB3a2xXazBlMlU3Vi9ZVEE5cGVaV3dCWU1wY2NG?=
 =?utf-8?B?TGhXWkNaTlZkOE0zcDY4bHNYMlIveEhtVVNjTCtjeGZNeTE0emh0T29EOHR1?=
 =?utf-8?B?dzJERFJkYVUxY2FvQ3dmYTE2ampwMFY4TG1QdDV2d3k2aWErVzIzSkFqamQv?=
 =?utf-8?B?dnZiRjltN2FGeFRqSDFJRC9vNXpBS2w2Q2RvRXM5cXcxVUUyNjc4ZFdBa2lV?=
 =?utf-8?B?S2pySkJ2ZnlUMW4rTW80Z1JFNlozaDVvWDdnTTNKVElEYXpCNWRIeGp2YUdh?=
 =?utf-8?B?ZFhjcDNWbTFwYXNPL2RiM1pQdGpQTmFDSUJOVHdLejgrTC8yeXo4MVJJVXpQ?=
 =?utf-8?B?N2VCZFBEN3VaRS81SDhna2llNk4yb21GWmFESUhxOGpacjhXVGZZckdWK0Jr?=
 =?utf-8?B?aW5mcEY0Zm5ycTF4RXdZK1FML0dpNHB2WXAyUzY0cmE1NTh6Q0dRdjVab01j?=
 =?utf-8?B?eUVNcnBZclE3MGx3QzdqU21qZnlUbjVpbFJ6NHV5TEU2SjBtTWROZFBtQUhs?=
 =?utf-8?B?dGZSMmFVZHBZSlFUTkg5NzJtaW9tRGt5OWJvVGxLK0JRdU90N2E0NU93Wnk5?=
 =?utf-8?B?Vk9nV1N4WnlTUktyRWttR1lRdE9ibkprK1Q2dHYxOVQ0VWFJanlVNGNldE1r?=
 =?utf-8?B?VEl2RURSbHN3YW1sN2VYVXhWZmJyanpzTkhhTU53b2xTVlhPVHNwM3NxYlM2?=
 =?utf-8?B?bHlCYUNYZW9pV2lJeFk2SmJLbjN1ZzB1T3pLZTZ1ZGZMK2VJRFlqY2MyQm4v?=
 =?utf-8?B?UmtIRWhtY010dUViV3hqelZLakdVYTNUemY1aWN3NWpNeGNtQlRNY2ZIZXBh?=
 =?utf-8?B?TFNsYzh0VUZpRW9Ga2kxbFBmYVN0TzV6cUduSGJXb1dDRWgyOHFrVGZpWkF2?=
 =?utf-8?B?NEJMcE0yckxUUisrY1NZRnpMaFNrQ0tXYmRraDZ3dUQzc2l2Sk4xNWc2UjE3?=
 =?utf-8?B?VjRGb1hGNGtvM1hTMlpoK1l4dG5ndk1Pbklzd2pqcFl1S0JxOGpBVllLV2k3?=
 =?utf-8?B?dlhTWm9lSU5QY3l6SUZqd1FTSzFEL0JJUUM0RWNkUGtESDYrS1YvZVhaTGNr?=
 =?utf-8?B?OGYyOXNPN1hPVmJtT05tdXZZVGhTTGNhbFhkelFIekh2SmVWSGpVM2o0K2JT?=
 =?utf-8?B?VXZwL3VQdkpsV2pIc2w5VHFia2oweTVnZTRVOXUvOFh0bFhCVXhQaGh6ZlNZ?=
 =?utf-8?B?SVg3Q1lZSi9jRG56K3VJMjZablE0NER3RFFYdVp0c0YzLzdQa0lBS3I0anVk?=
 =?utf-8?B?aS9FYitIQWtPbDNpV0l2R3FnKzFrQlFmVjN0dkhNa25JMmc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(1800799024)(82310400026)(7416014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	m8tIJXzj308u3r1tBNIsRfllS3p+feoFPs8L3atARE3HHFbFgfov5GsfGW1raJDcV3REVv1sG1Ugw+UrCXcmpCeCfo/tBn/6NfUs/bZPucUUI4YyNSPRpB/5LiXVJ8x6PYSRX9Pp68QDRfYXGh+OWwJY8OH3cxzAOJsFb3lcSlLTrOu622EGKf3ywXCCkK2meshtnRZF0ohGXf7JsmgwpKbK5tKYoljZtbceuGS+5C3OwhN6Xe1ZpRS6414jJZQ0VkSphThS8Qz5X38amoKOvBBErt46qZC4b5laAyFLMYJKFGd0Z9Wys5Xh0optnVpXdbs67EemG9BSWJUJnP+OOtSYcTgLii657a0EKFhsa1KhhiccTve8Bp91D6hrWZ9MXoqXhqdImCSQU+/Dc1KRzEDzozScurYxKZ5eCK/TmlRccT+Ix1iv4gVyMq8yIZCzg4MnPOIiokQaocHG8ZMW9JW/cJ5w2Xl8fXkShcBprp9r9oABB8CsN5oBsekhwAWaPULIAgfx2Sm1vSyurgsN9a51AI2ZFd01a2vOyMUo5dO1of+efIbjHIw7UWXS/fZwBmIcoqQrcT16LWcgClp4vF2abbLO+V76NzhwTosyqlpSLqzYiGftBM5MDfPf1me+doadEBPm5SWHokdTad6GhA==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 17:04:24.8524
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 82f95f39-b217-4dd5-670c-08dcff4e3b7b
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F68.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR19MB8651
X-OriginatorOrg: ddn.com
X-BESS-ID: 1731001142-110971-12665-9614-1
X-BESS-VER: 2019.1_20241029.2310
X-BESS-Apparent-Source-IP: 104.47.55.170
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoYGFqZAVgZQ0MDUzMQ0MS05xd
	jIwigx0cjSIMkk0cw4zdzS3DI51dhMqTYWAItFu/lBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260269 [from 
	cloudscan13-184.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_SC0_MISMATCH_TO, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

The ring task is terminating, it not safe to still access
its resources. Also no need for further actions.

Signed-off-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev_uring.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 5cd80988ee592679d9791a6528805f7dc8d58709..6af515458695ccb2e32cc8c62c45471e6710c15f 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -1062,16 +1062,22 @@ fuse_uring_send_req_in_task(struct io_uring_cmd *cmd,
 
 	BUILD_BUG_ON(sizeof(pdu) > sizeof(cmd->pdu));
 
+	if (unlikely(issue_flags & IO_URING_F_TASK_DEAD)) {
+		err = -ECANCELED;
+		goto terminating;
+	}
+
 	err = fuse_uring_prepare_send(ring_ent);
 	if (err)
 		goto err;
 
-	io_uring_cmd_done(cmd, 0, 0, issue_flags);
-
+terminating:
 	spin_lock(&queue->lock);
 	ring_ent->state = FRRS_USERSPACE;
 	list_move(&ring_ent->list, &queue->ent_in_userspace);
 	spin_unlock(&queue->lock);
+	io_uring_cmd_done(cmd, err, 0, issue_flags);
+
 	return;
 err:
 	fuse_uring_next_fuse_req(ring_ent, queue);

-- 
2.43.0


