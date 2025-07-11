Return-Path: <io-uring+bounces-8645-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 675ADB017AA
	for <lists+io-uring@lfdr.de>; Fri, 11 Jul 2025 11:28:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 209FD54393E
	for <lists+io-uring@lfdr.de>; Fri, 11 Jul 2025 09:27:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0424279DB2;
	Fri, 11 Jul 2025 09:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pGfk/dKy"
X-Original-To: io-uring@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2087.outbound.protection.outlook.com [40.107.92.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D2226D4F1;
	Fri, 11 Jul 2025 09:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752226088; cv=fail; b=mJWvXb5G66ymOy0x9XCZc6NwZeaKR/VyWtBTH9yjjHKXbrHvcfZPvVDOa2L4IyMaBGX+R0KjPOHt3jXiamrCGTkR3cHCe4yo6tlClfi48s4VTVHKNZpqL7J5jdPwkGbDlyye1XEzEI2+bOrecJoUg4NaMoeXYLM4efqEeKN6WRw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752226088; c=relaxed/simple;
	bh=ENzdGdh+hdgRfESHVabyyoybodtXs7CcJMqesE/8Kyo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=tllQ0CyWo7RBE1AAbTrGulB4ykrfmUkvG6WyF6e2mwjRDsnG1lYrnzM08UXG8eWQpBJzMxrJK77V+YFUeCp6dy7YjMBgptxWB4hd07sXdnb5oQcmltBFATfRyIkWTxlJCbGGaBr54VGOy4ObXOhNKXs5DgWTNDBa66UzPFtMupc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pGfk/dKy; arc=fail smtp.client-ip=40.107.92.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MTGhQ6FND88UWNZ6+UnmH4/mJZvoPVynHvWEGFvSrbjzRugmPU9B0hh6ode2Y6HibH3YV5Qn1FbNBHLtt+xeaPlrmliHQ3KiTGhjQmvDFYvu7imtb6Pq6uY8+69ln/p/R/vUpdksVboBQ6xINp+miciJngFBdLuVuZXfgXuXoYy4YutXLKN2yBdwmxF0WGfo7d8uTSoQ/VxihQn5qY0ZXcWDc1UZnQw7uvlIPc9HnjWhKWyA+5VkZNe5BM8NN/Nx9EAGBFZY3BSYyoJ6vdsfZCOzuR1uJlPQdwNroGEVCwDn2QkL7bbQhxwLT7jzstm9mBJ0Xw8f4mgUCTiPYb/Kkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BnNUUO7ZOjyiOxEqrt3lOyMf/QW5pZzdyNFioe2DbD4=;
 b=gkYktbR8L5CryZIT+QAT0nJpm9/zJPX3Cer/akiEvIgm8lhsOtw8NGn+cUcI9YYcbQOKR/s8faGBkvKqGeJg5lPpt7Ye6ILexoxXnt9z9wRRjyVM68F7yyYSCew6SEiFTj9UTgksjIRrv8G+flPZLX7bta1p1ezeKb0soc1oXcG8GBd8ivVpJg8aXWmKVmGfIVYPiADrFFiK3r+l+O74a2wcOc/KNmeb65DcnLGj4gkFXFY+9H/hCFDQ/onErLH48dnb4Su6ltBPOIzIHXI7VNq+xgpYMVIfuPyaozsNsfbtumRPU9Hlvz74tbSM58JIN1DjMTNgaN7+kM/LyYFDDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BnNUUO7ZOjyiOxEqrt3lOyMf/QW5pZzdyNFioe2DbD4=;
 b=pGfk/dKyi051OX2h7q6coGEawQNgAP8Fc10EZqj10yccIV+WEjJXldVsoGQyVuIdTm8aI4hxIEYNO+SgCaKU75HPj1HplW1mCtzAje754Ahfa2zU4QYiMuLseafSI1PC8x8RZycCKUqO4sS4UyNgGDgMJH6UDIXrZQl4lS7sywBEvofMifd4fXECdE1yG+RHbi2/KylqoumN/pPCnKCUsied7Ow4pX0/+vqlhQws2EZ808ooED1oGHpAfgcF1DauIpswHCCQ8WJAytWTKOnK2PNWaUHj15/WEo3AI+coYTlYE0c4eubNIoGsiGdTH/BzUDa+Ub2aLSISvZUp5O8jMA==
Received: from DS7PR05CA0002.namprd05.prod.outlook.com (2603:10b6:5:3b9::7) by
 CY8PR12MB7146.namprd12.prod.outlook.com (2603:10b6:930:5e::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.19; Fri, 11 Jul 2025 09:28:02 +0000
Received: from CY4PEPF0000EE34.namprd05.prod.outlook.com
 (2603:10b6:5:3b9:cafe::27) by DS7PR05CA0002.outlook.office365.com
 (2603:10b6:5:3b9::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8943.7 via Frontend Transport; Fri,
 11 Jul 2025 09:28:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CY4PEPF0000EE34.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8922.22 via Frontend Transport; Fri, 11 Jul 2025 09:28:01 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 11 Jul
 2025 02:27:49 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 11 Jul 2025 02:27:48 -0700
Received: from dtatulea-c3.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Fri, 11 Jul 2025 02:27:45 -0700
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Andrew Lunn
	<andrew+netdev@lunn.ch>, Jens Axboe <axboe@kernel.dk>
CC: <parav@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>, Cosmin Ratio
	<cratiu@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, Pavel Begunkov
	<asml.silence@gmail.com>, Mina Almasry <almasrymina@google.com>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<io-uring@vger.kernel.org>
Subject: [PATCH v2 net-next] net: Allow SF devices to be used for ZC DMA
Date: Fri, 11 Jul 2025 09:26:34 +0000
Message-ID: <20250711092634.2733340-2-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE34:EE_|CY8PR12MB7146:EE_
X-MS-Office365-Filtering-Correlation-Id: 307290d3-911c-4efd-5f6e-08ddc05d3b4d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|36860700013|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7HGFA3q33AIAdkstuuqd5TYY8c4oF+4vH0dL9j7gsPh4qHCfJn6JKohdyr0n?=
 =?us-ascii?Q?3kZpyEDM3ty3xm0zi07u8jHj6j7RbNc/WBYsCZvGw1rREM/kEyXWiPKzA7Jr?=
 =?us-ascii?Q?kGSliaol+V/E5QO2VdXvYZbe8p7INaml1Z+MJSGhryT87ywgIqfqj7Mh9vi1?=
 =?us-ascii?Q?Zi+ApHFB7HymFDg5SGAWRoAbE2zO0kXPWKKMrMfXdmnslidrD8r0Y6X6JpLm?=
 =?us-ascii?Q?H4uD/pgweylbySmUPA118XMJoAqfxN1hNJZr4uxYH4U6+3etkfQ562u6MUIE?=
 =?us-ascii?Q?TDBX3Ln7x/rcJEwm2Lcdgqen0Ru/+X9VDI6105q8g4cEY2jZ18pOSvY6kdDt?=
 =?us-ascii?Q?8gA8gGUtUlfhfuA34IVqhnr38I9VK2vKgngdvjOuBMQxEArtSuRdtMNUK1hO?=
 =?us-ascii?Q?kqggV6HW6QUBswPLmYhkonCTTULelQIPnexYdWvSsUECGH5Il4IrvWqvzx7J?=
 =?us-ascii?Q?qHMe34VKCHXoDPsT5VtfVbrq1+/NcWid9IuyUpakeuM9dD2IZWQFCuyAkC5I?=
 =?us-ascii?Q?qYxhlj7bQpSaD0fKOr6cgoIhXD5URa/EmD8NTm00jdleEfWnCneuUpX1pCk/?=
 =?us-ascii?Q?GYqNiiW84P+IaApz1LE2ns3vcr7sNWZVUreuKWIVBIE72dMWWw6KLGlXX44m?=
 =?us-ascii?Q?Ug7GCiIuBiffHz9VN5sDW6E+KU9s2lUnNkYnH5bYK6vqccIGJHl3h6nHrS5O?=
 =?us-ascii?Q?RHDNjfq7Svu9W2VPTvJ5+o5IV5FjN+0g/0TpWtORRZKCBUh/yh7mTFDye47e?=
 =?us-ascii?Q?qqChqnJXor0YZ11IHGR9zvAGVRsPb8uWLz4goYNEb2s43M+axYhtQ780xFvU?=
 =?us-ascii?Q?o5YsQ0EM+XCXlO5JbCWIs7HfsadeRWbOf5bS0pPZr5cJ14woR7ibd1lc1Tch?=
 =?us-ascii?Q?PeTQl/52c8DSk+BKSI5l29ubNPKbOMpuXR561gZYKeiGAutk14zElOPy9gI1?=
 =?us-ascii?Q?5baM0/+mdlqTzg0Yw9/KF+6Il4iWHte9rJfJvgK22w9l36gHh3HgDnCUa6+S?=
 =?us-ascii?Q?RQAWF9XaVx6VHx7sQj1m3SmeNM91zNsFBB9f/c3zhMxdy+6HlKxjlxZ4SFHp?=
 =?us-ascii?Q?kkKVhkH3mWzlypd8F62LC1MsYhnf0PryF297bhNR/eQOhahj6vadM9m0Z2oD?=
 =?us-ascii?Q?3YgL5MlMCcxhkdOpCFfBmv2e6qM4zfUBCbD7Lc6nnRjwUeL2+t3Grj8aiegi?=
 =?us-ascii?Q?nLD8fJwQhWJEqaQminmFA0plcwGc85rB8e6fPrrjQUgfCjTlOmB2zztDVzxF?=
 =?us-ascii?Q?42Uz4gl78fWzohtHeexrawvXbH+4kZZQpzWRbbRbdN2d+Znn55IXBqe6RBmO?=
 =?us-ascii?Q?V37WM89tPTXWBArOy7qEmRbfzW045klLtKxxeqOPPJq/HJNPiWDINDp42oU3?=
 =?us-ascii?Q?8iVmQ3jYEh4DcL5dcc7bGer69bc9H67RLdn19MSBElCA/DOjPD5B/wcnPyz/?=
 =?us-ascii?Q?jhZed4LSHvmA+fbujL8hUem1l44EKtixEGM7t7s/Wcwf+iGy8xO3iWP5IWQg?=
 =?us-ascii?Q?x+cx5ssyJdMXP+EX9w5Ko3pt5k7pc/K/8BXoeNSChdXtqLTH43J0t53DWQ?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(36860700013)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2025 09:28:01.4219
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 307290d3-911c-4efd-5f6e-08ddc05d3b4d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE34.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7146

For zerocopy (io_uring, devmem), there is an assumption that the
parent device can do DMA. However that is not always the case:
scalable function netdevs [1] have the DMA device in the grandparent.

This patch adds a helper for getting the DMA device for a netdev from
its parent or grandparent if necessary. The NULL case is handled in the
callers.

devmem and io_uring are updated accordingly to use this helper instead
of directly using the parent.

[1] Documentation/networking/device_drivers/ethernet/mellanox/mlx5/switchdev.rst

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Cosmin Ratio <cratiu@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Reviewed-by: Mina Almasry <almasrymina@google.com>
----
Changes in v2 [2]:
- Dropped the Fixes tag.
- Added more documentation as requeseted.
- Renamed the patch title to better reflect its purpose.

Changes in v1 [1]:
- Upgraded from RFC status.
- Dropped driver specific bits for generic solution.
- Implemented single patch as a fix as requested in RFC.
- Handling of multi-PF netdevs will be handled in a subsequent patch
  series.

[1] RFC: https://lore.kernel.org/all/20250702172433.1738947-2-dtatulea@nvidia.com/
[2] v2: https://lore.kernel.org/all/20250709124059.516095-2-dtatulea@nvidia.com/
---
 include/linux/netdevice.h | 21 +++++++++++++++++++++
 io_uring/zcrx.c           |  2 +-
 net/core/devmem.c         | 10 +++++++++-
 3 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 5847c20994d3..53aa63d6e5a3 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -5560,4 +5560,25 @@ extern struct net_device *blackhole_netdev;
 		atomic_long_add((VAL), &(DEV)->stats.__##FIELD)
 #define DEV_STATS_READ(DEV, FIELD) atomic_long_read(&(DEV)->stats.__##FIELD)
 
+static inline struct device *netdev_get_dma_dev(const struct net_device *dev)
+{
+	struct device *dma_dev = dev->dev.parent;
+
+	if (!dma_dev)
+		return NULL;
+
+	/* Common case: dma device is parent device of netdev. */
+	if (dma_dev->dma_mask)
+		return dma_dev;
+
+	/* SF netdevs have an auxdev device as parent, the dma device being the
+	 * grandparent.
+	 */
+	dma_dev = dma_dev->parent;
+	if (dma_dev && dma_dev->dma_mask)
+		return dma_dev;
+
+	return NULL;
+}
+
 #endif	/* _LINUX_NETDEVICE_H */
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 797247a34cb7..93462e5b2207 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -584,7 +584,7 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 		goto err;
 	}
 
-	ifq->dev = ifq->netdev->dev.parent;
+	ifq->dev = netdev_get_dma_dev(ifq->netdev);
 	if (!ifq->dev) {
 		ret = -EOPNOTSUPP;
 		goto err;
diff --git a/net/core/devmem.c b/net/core/devmem.c
index b3a62ca0df65..881044e0ae0e 100644
--- a/net/core/devmem.c
+++ b/net/core/devmem.c
@@ -183,6 +183,7 @@ net_devmem_bind_dmabuf(struct net_device *dev,
 {
 	struct net_devmem_dmabuf_binding *binding;
 	static u32 id_alloc_next;
+	struct device *dma_dev;
 	struct scatterlist *sg;
 	struct dma_buf *dmabuf;
 	unsigned int sg_idx, i;
@@ -193,6 +194,13 @@ net_devmem_bind_dmabuf(struct net_device *dev,
 	if (IS_ERR(dmabuf))
 		return ERR_CAST(dmabuf);
 
+	dma_dev = netdev_get_dma_dev(dev);
+	if (!dma_dev) {
+		err = -EOPNOTSUPP;
+		NL_SET_ERR_MSG(extack, "Device doesn't support dma");
+		goto err_put_dmabuf;
+	}
+
 	binding = kzalloc_node(sizeof(*binding), GFP_KERNEL,
 			       dev_to_node(&dev->dev));
 	if (!binding) {
@@ -209,7 +217,7 @@ net_devmem_bind_dmabuf(struct net_device *dev,
 
 	binding->dmabuf = dmabuf;
 
-	binding->attachment = dma_buf_attach(binding->dmabuf, dev->dev.parent);
+	binding->attachment = dma_buf_attach(binding->dmabuf, dma_dev);
 	if (IS_ERR(binding->attachment)) {
 		err = PTR_ERR(binding->attachment);
 		NL_SET_ERR_MSG(extack, "Failed to bind dmabuf to device");
-- 
2.43.0


