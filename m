Return-Path: <io-uring+bounces-3711-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A673799FD44
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 02:39:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C9E341C215BC
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 00:39:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E38A10A1C;
	Wed, 16 Oct 2024 00:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="kVxv9VTO"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A2AE574
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 00:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729039167; cv=fail; b=qBNzh+s3ojGP0JLw2SdpU/MRch2N1ZKmHNtfAXRH8do9knLW7cKUEwykc9KPUE5UxdFwsE4CizWm8kdQ6zXHxfDOeXRGe/Tzf6ztr2U7HDdI9Lkq1sDG+CxBnz2xUZm8HJvLBlz0FzG41VKu093zJHx/0DnhAFBifVxSuqwRmAs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729039167; c=relaxed/simple;
	bh=7Xi4hyG04KMKxPwnWaeikRjAaezWNIGfJ7G/TvVGmzw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=jYGk3jCorbGjFrwQ1jnYUDqZhe+yCo368HWsQWLfK7jGB7ZdQx3t+3lK+UIYaFii7hHuJriRve4saLqzkSSIdRSbgrnBcOovxFGzBQuarcfRasKQJgTI4di9NeuxR0toKCOo4/0bwcoH+cMjopyalYYnQTJzbUBM2i9TVEtEntI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=kVxv9VTO; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170]) by mx-outbound14-248.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 16 Oct 2024 00:39:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IG66XH/Gkh5rz1qerzi5qpbwhEDuJ8Vjvp74s36OWvgJ4HaQjuohhNt2pztwImHxGAkdNWjgvczpkp+TRh/9KzEXrrlCF+Codffijp0796DbXnmNxAi7z2cPKd+v78LzudAJZ2dNPRv2Mrr8aOAfazmUyRdcV5ey0hBXaTV0yP8EislwCvFRERmfIYKygEiYoSEpNBiHJGfBQ8/uHc/Te1kOOAZHk/Eqko3/4A7FlwcJ9inLegJFg5aDx26npzwMaSoRi5fHdQwPuf6PW8ZF1dWUCU5U+jMY98m7y5FXcm+hMKWx/S1Xuv2mbR+iOJ/lpQGbbitURmMYffXTM8gkHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oJZGXDrF/qYt5U60QDosKDvI8xNwlWRog24xMY9CxGo=;
 b=CRs5XWWZ7KkqwVjXwoWDeLgPCrmv+Tob1LrcAnOURSX4QD/vgFTpTbH0L6gNz0qpgbheNN5cRWlXKHmNMm9HTMs9Vcbjz99LLIqdM5rEag2FL+kiG3gQst+Cq/TU/RriCWCweGHTW8/1kU1SpQ9pxjsrXsVqzK611YtONl2pMez1mvv1MpBjA7XlXw7ZerOiq6KS/C10dib1/Ea4mT8IhJUDIbY+/L+RQtVldpRIC9Tr2NxaNSBfNvcbQSEqdHxKtfwlC1pjKGO4UManxubJlIc4VZJzTMPCnNBI/KA8hxENTMirJeUY5WHBEU8ylt7ta+B+XZM/lKaFnWtnTHkFGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 50.222.100.11) smtp.rcpttodomain=ddn.com smtp.mailfrom=ddn.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=ddn.com; dkim=none
 (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oJZGXDrF/qYt5U60QDosKDvI8xNwlWRog24xMY9CxGo=;
 b=kVxv9VTOBhtirCxVXsj5Ojpq4fxblXAAWlfqNmCt5lz263GQpZR5y4Pfu4oqs3T1ELTV52B6G7ancrLHshIm+lfJYQgWjqdMgg8gbVdbYM3G8TVBW1UpJ5iWpEkOm9RvrKhHhMLRtb5uUupScPjr6JDU368FLOFVw+jUQF6LtLY=
Received: from MW4PR04CA0256.namprd04.prod.outlook.com (2603:10b6:303:88::21)
 by LV3PR19MB8559.namprd19.prod.outlook.com (2603:10b6:408:276::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26; Wed, 16 Oct
 2024 00:05:25 +0000
Received: from CO1PEPF000066EC.namprd05.prod.outlook.com
 (2603:10b6:303:88:cafe::ee) by MW4PR04CA0256.outlook.office365.com
 (2603:10b6:303:88::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.27 via Frontend
 Transport; Wed, 16 Oct 2024 00:05:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 50.222.100.11)
 smtp.mailfrom=ddn.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ddn.com;
Received-SPF: Pass (protection.outlook.com: domain of ddn.com designates
 50.222.100.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=50.222.100.11; helo=uww-mrp-01.datadirectnet.com; pr=C
Received: from uww-mrp-01.datadirectnet.com (50.222.100.11) by
 CO1PEPF000066EC.mail.protection.outlook.com (10.167.249.8) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8069.17
 via Frontend Transport; Wed, 16 Oct 2024 00:05:24 +0000
Received: from localhost (unknown [10.68.0.8])
	by uww-mrp-01.datadirectnet.com (Postfix) with ESMTP id 0224D7D;
	Wed, 16 Oct 2024 00:05:23 +0000 (UTC)
From: Bernd Schubert <bschubert@ddn.com>
Date: Wed, 16 Oct 2024 02:05:13 +0200
Subject: [PATCH RFC v4 01/15] fuse: rename to fuse_dev_end_requests and
 make non-static
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241016-fuse-uring-for-6-10-rfc4-v4-1-9739c753666e@ddn.com>
References: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
In-Reply-To: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 Joanne Koong <joannelkoong@gmail.com>, Amir Goldstein <amir73il@gmail.com>, 
 Ming Lei <tom.leiming@gmail.com>, Bernd Schubert <bschubert@ddn.com>, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1729037122; l=2183;
 i=bschubert@ddn.com; s=20240529; h=from:subject:message-id;
 bh=7Xi4hyG04KMKxPwnWaeikRjAaezWNIGfJ7G/TvVGmzw=;
 b=b/qp7uxA3T36qHfPHiK/6tX0mpbOZO9fujfnh38DNYTX+PSapF/B+UPWSibLQMat3ZDLE94vd
 plR3rRkTr6gBso8MiRz6hxKCNsYaLRoZdoOPgSLKIaBrk0uU9gJhgqn
X-Developer-Key: i=bschubert@ddn.com; a=ed25519;
 pk=EZVU4bq64+flgoWFCVQoj0URAs3Urjno+1fIq9ZJx8Y=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000066EC:EE_|LV3PR19MB8559:EE_
X-MS-Office365-Filtering-Correlation-Id: 567784a7-cd59-40e3-46bf-08dced763c1e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dXgrM1pmeVVtem92UlJTYWhwZmtnaDZCajhqYjl3bnRsUkFXUzF1QW9Vai84?=
 =?utf-8?B?L3BIcmlBME1MSWFBUlA1VkJ3YUFoTm5FYWZHMUQ5V29IanRzUlZqVTlOWUIz?=
 =?utf-8?B?MVJVcFNZNTJmeEN4djh3WTI0OWlhNVVZSlVodkE3a2dhZWlmcFhXZ3VTZE8w?=
 =?utf-8?B?TWJtU3AyN2hHcXJBYnM2TmxLQXcwZjNZcHJiYi8xVEI0eS9VZ24xYTFaTll5?=
 =?utf-8?B?d1RWcVFzTFFZNmxnMkV6UDA5VEloR05pZ0ZlSnYzYVcydEo0aUVwU1FpS0Zz?=
 =?utf-8?B?KzFJMC85WWZ2VndrSUxObEEyTzRYOU1KVW9JTW9aWm9JTlg5R3I3aGVoTk1h?=
 =?utf-8?B?VittL0ovdkxvUCs3UGZyTDFwbGpiNWNQc2d3WlRVOHlHOThNclFGL0QvZW1B?=
 =?utf-8?B?QmdvU3E0S01GclhDOTcwWVNiMStQUkY4WlJkZmZFVWNYQ3dBeVdZRHV4TW9i?=
 =?utf-8?B?Y3psdkppNElOTWxUVVBzWitQa2FoY0RvSWZ6U1NKcDJscWFKNVRFK3hqbTFk?=
 =?utf-8?B?MG9DdG1CRCtGSzgzUjNnSVhxTjIwSi84Rnl1elZxWHNzNFV6b2d5Q0JqWEV5?=
 =?utf-8?B?YXN4Q05PRTFPamN0OFRnZW9pcDZvdVhkaTh4QkdsbHNaS2hNRml1R04yazlP?=
 =?utf-8?B?ZFVSeFlld0RpVXlLcFpPYld5UnFxN3Q2YnRKU3pIQllLY0Q3d0tuaXd1Qk5l?=
 =?utf-8?B?UnJWdW0vTTZ6MTJtTGQrdUk5SFh3Rk5HS1drRFZxYVk0S0tvdkZhYmY2cFJE?=
 =?utf-8?B?U2tKWFhYbjFyVUZrb2ZTcmxkS2swcjBKMnladW9CbXdYNUliS2FGQXhHYWdR?=
 =?utf-8?B?bnR1MllkRjJNV1p1QnpyeFlpVkJYWTdMMElVMm8zbzRGRXM5cVNQTzVleEZJ?=
 =?utf-8?B?ZEg4a2ZZRWQrSHBQZUpxcmsyMmZNMGtXd1pzcFVWVnF6Qm9yZ3J0a1krYXAy?=
 =?utf-8?B?NVErMnpRc3RBMFNPcGxiZ3RSRklJM2gySmRoYjBQbVk2eVRRTHV2YTFHaE9p?=
 =?utf-8?B?b3h5U2JXZi9LZU9YRTR3bzdObW85UG12cFlmSkU2Kzc2OCtGZlZrazJ2N0ow?=
 =?utf-8?B?dE9mWkNUd0M0VlMzQktRQlFsWTEzRGx5dkpkUzBMMHoyLzZHVFB0eUdTbTNk?=
 =?utf-8?B?UnF1ZWhXNFczenhkOUNTT0s3SnhIUVdCUVczc2xNZS9WRVUwTkw0ekFGczYx?=
 =?utf-8?B?V1FaUEJ1bldtbXpzQWd5MVl5aExsUDlpVmZQck1sQXp4ZTJ0bmhWSEVJQ2Nm?=
 =?utf-8?B?Zytrc3ZyZEh0M2RoMWNRU292SjBxTmUzVlJVaGhyYXRJUTU2UGwwY1JiMStx?=
 =?utf-8?B?OWc2dmEyRmp3d0hmenJicDFOMnN0Zm1XMms2UU52NGpmM3ZkZGQ2U2hoMm1r?=
 =?utf-8?B?cGNxOVQzRzVXME1YVWVqdE02bGovbkhsTzlKbVd5S0VwQUVkNURoVWk5aUZ0?=
 =?utf-8?B?c2tsdUgxYmVrZXJOeTRUUFJBc0xpMDVzSzBnLzF3UDU3cHkrQzRCaE1SUlZS?=
 =?utf-8?B?ZkRQTitYVlZZbzZQSWRKS3ZaL2d4NEp6U0VvRGlCRmU1VGx5amI0TWVhQnhz?=
 =?utf-8?B?TjduZktuZ3g0UDhDb0NBL2RUczI3MVpSZVhDYnRaa3AzR2wxeXNmbkFQelJ6?=
 =?utf-8?B?Qjc5UXI2K2ZGSUJPWW5ZMTB6UWNxblE4VjRiVmJWOHhLUnNJNEMwM2cyazRZ?=
 =?utf-8?B?UFdVR3N6RXFjTGc2VmNjVk14ekZMRGVZR3FLZXkvcFhyQWVUUXozc2x4YXY1?=
 =?utf-8?B?QTRTWEVJVkcweVlWTEJuSEM3a2tvVnZ0Rjd5bTNVV3FvekRrZW1pYVcycDZF?=
 =?utf-8?Q?bbVbuFvfU9MguLdh8YDg3DFH5Qx5LIp31VKtc=3D?=
X-Forefront-Antispam-Report:
	CIP:50.222.100.11;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:uww-mrp-01.datadirectnet.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	te3/hcKOYr6mXlcavF2CGGkko1wQl0eSuUo5p3SBQW7fJmEp2ioEOimj2VJuAtYKmkLV6QdAfIvXqKzeYk91VFO1amUU9xxGQT3hDHbZMRzWFILwylx88+p+k0KE+9AJ3XkFEfumz66R4mOESUk9Mpa2JWUJUERqO2WoJLD64rxkuycsOzffLxel9l/4XEn0gCU2Y/CZabf+tAz3/9+5ITmhYkJGVgAb1qx/ER8KzsEOruT2SuH/kNNJsjX+rMIG40o9oe5XGCdcFa2ERhLwrmdQPT+LOFcN4R5HT0g3YRMv1W1knFRg9HJpltY1G/eia8qaU39m54NUVQU5i0ZgsTvRy5j6HUjJn2hCDU70QwKbeG7XZTMIcXxCnSVLaaL6yJcYig4CSjF/1qnF8Ha5h+XR/6S6DDOvHC6VvdDGzRUPb4vDR0zb7hDISWPVFi0db90pwhNseEgWbk27noquPnm/LujnSwY44b/BCmSF6wkW7bxfiVeUg3ulKkOOKp4LVaPApbouJSOr8eyTbIjijxvChWB/hdlunA0Qt/l1gxd/M5uz8IxUg+LpPAv2osp+TPRtcc/PA6MMuiKCkXHyHyvQ2kXl6e4ugsdcAvf21OE7qw5tQq+wOxV5w6sQqqUdYw1MW7Lkk56s1A6naKUnnA==
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 00:05:24.9527
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 567784a7-cd59-40e3-46bf-08dced763c1e
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=753b6e26-6fd3-43e6-8248-3f1735d59bb4;Ip=[50.222.100.11];Helo=[uww-mrp-01.datadirectnet.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000066EC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR19MB8559
X-OriginatorOrg: ddn.com
X-BESS-ID: 1729039163-103832-12774-12547-1
X-BESS-VER: 2019.1_20241015.1627
X-BESS-Apparent-Source-IP: 104.47.56.170
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVkaGhgZAVgZQ0MLS2DLN2NLQ1M
	TcMNXcyNwoMcXY0jzNJMnA0sgsJdlUqTYWADHjmkBBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.259752 [from 
	cloudscan17-118.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_SC0_MISMATCH_TO, BSF_BESS_OUTBOUND
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
index 9eb191b5c4de124b3b469f5487beebbaf7630eb3..74cb9ae900525890543e0d79a5a89e5d43d31c9c 100644
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
index 0000000000000000000000000000000000000000..5a1b8a2775d84274abee46eabb3000345b2d9da0
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


