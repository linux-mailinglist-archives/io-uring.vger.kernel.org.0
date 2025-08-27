Return-Path: <io-uring+bounces-9310-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A14EAB3853C
	for <lists+io-uring@lfdr.de>; Wed, 27 Aug 2025 16:42:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5923A7B6797
	for <lists+io-uring@lfdr.de>; Wed, 27 Aug 2025 14:41:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20192221F2D;
	Wed, 27 Aug 2025 14:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Cta4up4q"
X-Original-To: io-uring@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2062.outbound.protection.outlook.com [40.107.95.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7633B220F3F;
	Wed, 27 Aug 2025 14:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756305708; cv=fail; b=u9OsK3AvvUknlv6CpI8IW0P/Lcl9/LXP4hUiUSqlHiT3Bav1MEzwlEdYp5+l2JQa2+L+s37j8NP5Hb2CuwWdGZHQmLE8ObyGrfN7GPAgP7AB2svYLadF27GJzsLcjeByTg5IWgB383U9YenQU5jv0FFWWmOadrWPKaFC0B89RtA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756305708; c=relaxed/simple;
	bh=7sE82rgasi2yPuvU1rsdtQH1IQJkeR8OJtIAhzLfMgo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OME+5UhdpOjCkJzp1ESl3ntOxrTFf4aLQMtlEFakKOIW/cB8Ke8f6E0LEHLFMMhWK3pUNeFoTL9gAT/zqbtgUnP2kYkD4KFMT2GvVszEalEV6SbKozYWnMzO8X2IgHo7+Jvc+qyx2lVy3g6fx2TjNE5AgZsZ/EYb3/zOXN6wPCg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Cta4up4q; arc=fail smtp.client-ip=40.107.95.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EWFhYyeOIziVOwNd3TbhnSlGQUswesc3GYTvKBb7m97JSnMLsWYU6HrDRWvc4g9b7wr12uBFJCPjUzRiuFyVdae6zAlUEqaAc1+CPJXsdDYOVN1C5khH+zd3W1xotBUJ6/+KZcyqEvyz45zPNoqpfST3onAL8w36oQiwdoZxn39gxajj0ELYMXVnE5PdTMhxYXDYh+WC5rcA9lDogQAGePEUAOp3JnfuSBifMQIymQSlsihKj0FC5AwB5qPdOofv9XzWZn2fkdiddPN9vL49F4/ROgiX8SOZ75gPOh9EK3M2mc3iSHwQVuwaYMECNLMJnH33djz4aR+s9ObdeMx/Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XCXAoHFjFpaYyctbDX9Ip6+s8P/F2xUVdQyD2rhmQ70=;
 b=X44wNAu5LMoWxwU268vMYwqfN0oLPcs4d/7t6/GW7hdCY8YvbawKJACy+ey4rEqzvm3Ppx8cia0VUoS8zwoBf/nifHDmD0whO1Blz7xEOsAH65XPVmqptXEYYyoNsnFmW0kQbH1tzAAzgFpiCOLmis653RFwx6CKNCUkB2ZskWF2a2UAKgAy739rVfVwchenkZne+SlP970qe5Zlj8TSiAhZf6GKVsxwJaX+H0w4YCTuKcvA6uFPq790wp6FtiiUaqR+xK1XUl07RkzUY3pbpfCf+YG9DDxZ49avllqla5yHLPYKS9APt4MySgcW1farS+Dp5sQhyissjUR1WanfwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XCXAoHFjFpaYyctbDX9Ip6+s8P/F2xUVdQyD2rhmQ70=;
 b=Cta4up4qql3Bc+9TBHxNW8XwmUJ5iFk9lfsaT5kaAburL1xDhpIgzS8sBwGsUfnhhd81VlKcLDoiPi0DDN76HhoQg87JTBgdmoomDZ5XFLmXyr7Hc4nBlC0vZbC0DlEZLi3yvO8vD7adLZy03Wt+dZIKG/fAi2mWPa8UW+QIaxSg3zhoR3AjPi1vrGtm8R2N9bDZTQ/D8kdJzzx6x/Pq/HIahsPf5mgyFoW4f2CrFQIIz/zsji7/WdVniaRhLBaqrHWgiz498ugXIGGgBORqkgJ/TxE/Jx8RiTFnFQ3Ub0uFZMhdSRDgpVbmA24yzcthqRs1A7nddsKCjz70t903/g==
Received: from BL1P221CA0006.NAMP221.PROD.OUTLOOK.COM (2603:10b6:208:2c5::22)
 by CH2PR12MB4088.namprd12.prod.outlook.com (2603:10b6:610:a5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Wed, 27 Aug
 2025 14:41:43 +0000
Received: from BN2PEPF000055E0.namprd21.prod.outlook.com
 (2603:10b6:208:2c5:cafe::69) by BL1P221CA0006.outlook.office365.com
 (2603:10b6:208:2c5::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.13 via Frontend Transport; Wed,
 27 Aug 2025 14:41:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN2PEPF000055E0.mail.protection.outlook.com (10.167.245.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.0 via Frontend Transport; Wed, 27 Aug 2025 14:41:42 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 27 Aug
 2025 07:41:04 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 27 Aug
 2025 07:41:04 -0700
Received: from f42.dev-l-178 (10.127.8.9) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.1544.14 via Frontend Transport; Wed, 27
 Aug 2025 07:41:01 -0700
From: Dragos Tatulea <dtatulea@nvidia.com>
To: <almasrymina@google.com>, <asml.silence@gmail.com>, Jens Axboe
	<axboe@kernel.dk>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <cratiu@nvidia.com>,
	<parav@nvidia.com>, <netdev@vger.kernel.org>, <sdf@meta.com>,
	<io-uring@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v6 2/7] io_uring/zcrx: add support for custom DMA devices
Date: Wed, 27 Aug 2025 17:39:56 +0300
Message-ID: <20250827144017.1529208-4-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250827144017.1529208-2-dtatulea@nvidia.com>
References: <20250827144017.1529208-2-dtatulea@nvidia.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000055E0:EE_|CH2PR12MB4088:EE_
X-MS-Office365-Filtering-Correlation-Id: e876d253-d8a5-4117-a638-08dde577d6ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YUYr23e0681iolBgIreC4mHaCxWeK7rdKvzsBxei0e/DVulaqTJ2ibrgVSK8?=
 =?us-ascii?Q?vUCwLlsKr4shCLcWMe0UfoZALIbYRbR0tt2Utm0QX1hXpEVoRoFi9Tf9PE2R?=
 =?us-ascii?Q?zNfPlb5BwzgWhrHJESciIW7nArrGB+ECjVjcnnLaqP0QUWbpYreGgYngrfIB?=
 =?us-ascii?Q?JaMuQj7yY9HnSBex9Y1Og+AHA2PvPGYvMkLKvscbLKQjzwt7CiHY/hNb0RpI?=
 =?us-ascii?Q?3NKa6NDFL/8DDFSac+G+pnGPuhfnuHVW/qmOQeCSPAywiiL5JtZ9I7Jx2Hza?=
 =?us-ascii?Q?3/l0cYCKISQJS65a5grI9zxPWCS8gG/V31owigik8mydWtNFb7fZByCeP3lq?=
 =?us-ascii?Q?ifKzG+kWwC+wXfmpja1Dd4gMEMKJSYpnqFVetbMKXogYsFfCPKaJhulDlTIO?=
 =?us-ascii?Q?kO+rN7MW8xxUTTkOxD40VBTn4xiwE5bJ/4Pa8wkP/tF/DEV51AZyu+UT0d34?=
 =?us-ascii?Q?8m+YO3XV9W8NzzpfIQNEVwfEhMwGva/9/uxIlT/ww2Gca6qN+qc2l8/D+UMs?=
 =?us-ascii?Q?HZEF2ErBkiMpbMP3vFcimutvhmkxLPhPq88Jy/X2OA6H/aKHUFmmkWKZhI6j?=
 =?us-ascii?Q?Xiwc4seiaL9hvgTgg6f/EFtzlt73i+vayTLre1xdSh/lUS6GdUKJlw/d2ui3?=
 =?us-ascii?Q?uIXrCpuwvxjM6aK63d8dG5d/ibz6k26opVITL8vw7SGIKvrT/8oFf94GgnO4?=
 =?us-ascii?Q?cR325E3D64zDegsQg+hIMqgt5lSbaAenaFyH2nWDW4gyJssNQpvQqxZkn+KO?=
 =?us-ascii?Q?DBZbRHC5ROKEI8PvNOeyPRyptyBwavm51UM53MZoTSqy7DEW6VejXi2MPzAV?=
 =?us-ascii?Q?MBeTmixYHAdUHiJcWJJH2OSTbDRPyjM+x6rTkc79BJb75FxMedQVurEdIU11?=
 =?us-ascii?Q?d+Vebmsf6cv4LZ8HGQyolM7QBwNIC9VDyHOQvMjs1pawvgwQfq3GEcxPgEZC?=
 =?us-ascii?Q?GIOXgaODK2DzQQDsN4iZa0oKSaEWkqqz2d1oPnbF/KyEejtA+AZ9bOssWdO9?=
 =?us-ascii?Q?7701dDfiwXMKZj13t/Mq1dYrfiAA930ELicjtDk5N2xBVvL/EtKgWGxGja5C?=
 =?us-ascii?Q?PJdfRk28YyrOjQ7MG7xx12IdMbzPGBEeoOlPXbAeuSMmNknYdtDF/qU2XLSm?=
 =?us-ascii?Q?qx/DwKRH9OlWeqB8F1Ym3Mw2hqZFD8QH6ohRUkUysQyo+qzGTbxx57G9Ktf7?=
 =?us-ascii?Q?ziv1fpO0uyzQ6kHfBfoUn0qzHiRxt//Z2S0yMYtVij+x8Ai64GvlxZSuzL+i?=
 =?us-ascii?Q?Vi/oKhpP7pkzdl+aiUrSUozklcQbNHlFkFgozHkltZkpvKxUWQNSPKyScJ3x?=
 =?us-ascii?Q?hjswddoJfw2FWvYSGjh0VSlW2eODQsBN42ehf9jexC4SV1mBa9gVPiVzZqxr?=
 =?us-ascii?Q?qdDpgT4KvnoRFa8WXhl/4JOLo1LxzqPSAQfLFotjczDkCUBcUIwhFOgr6xmE?=
 =?us-ascii?Q?WBgNanSHle1DdB6EiUZx4tDNSX+t3Pde5WtrwJvN12i6JpuJ/eHSOPQSmQka?=
 =?us-ascii?Q?Z8mTpkBIPZ+kswo+FEh/WZcskcoRVZJqeaNY?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2025 14:41:42.1802
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e876d253-d8a5-4117-a638-08dde577d6ca
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055E0.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4088

Use the new API for getting a DMA device for a specific netdev queue.

This patch will allow io_uring zero-copy rx to work with devices
where the DMA device is not stored in the parent device. mlx5 SFs
are an example of such a device.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index e5ff49f3425e..319eddfd30e0 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -12,6 +12,7 @@
 #include <net/page_pool/helpers.h>
 #include <net/page_pool/memory_provider.h>
 #include <net/netlink.h>
+#include <net/netdev_queues.h>
 #include <net/netdev_rx_queue.h>
 #include <net/tcp.h>
 #include <net/rps.h>
@@ -599,7 +600,7 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 		goto err;
 	}
 
-	ifq->dev = ifq->netdev->dev.parent;
+	ifq->dev = netdev_queue_get_dma_dev(ifq->netdev, ifq->if_rxq);
 	if (!ifq->dev) {
 		ret = -EOPNOTSUPP;
 		goto err;
-- 
2.50.1


