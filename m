Return-Path: <io-uring+bounces-8631-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 51D7EAFE952
	for <lists+io-uring@lfdr.de>; Wed,  9 Jul 2025 14:47:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5768E3A7000
	for <lists+io-uring@lfdr.de>; Wed,  9 Jul 2025 12:46:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE6A3242D62;
	Wed,  9 Jul 2025 12:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ejkD5oxU"
X-Original-To: io-uring@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2054.outbound.protection.outlook.com [40.107.95.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA241DA55;
	Wed,  9 Jul 2025 12:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752065208; cv=fail; b=Ck1D7kqR5qls6daAK9XUK2UblfHVwAhCq6pAmETVpYvgrOmFQA4tts0rCMODi9KaiDokdfPiTGwArNPfywbPICFQv3XFUcOGX5c0kNO0M+DCSGYzLrPEOV7lkqsToO96QCT0JTEXlyMpZXHEBgcuRgyZzZtc9roP2g/0h9QdFtM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752065208; c=relaxed/simple;
	bh=WVaGEfOA1IuuFe1P0l6sM7sqCjf6Zow3/Po1ikWDl3g=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=CRVjd08XilOFL9gEg6nbjxO7hFqa4Ppbggwq/N9HwwWoRULWX5S8pkVUHynQQBurlFkoMyRSizjz7S/GnSk5Sb77b0Xo1Xfg3bEvZMa9gvIrJKJN4awECQgMNNA+BJs3RQRUEsDyoPtioqfbxRxPnhjYLBk3ol7rKUWxCfrciNg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ejkD5oxU; arc=fail smtp.client-ip=40.107.95.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nUCJk0k/ajHLLNclHeaK4IwQDgTMQjrgWDS/+qlvMpWSNRHya9ugBpThxPAMAvjGzf0hf4x2sLSazGyBx89F0szmhkmOOpwZKMIo2hifgApL8d+9iaUK4hu7I9iaNqtnytXrnCk/a2VWdpdW+jAW6AEgyDPmS0nAQQTF59P/gRIIgZbF2EjMLtx7ESjPdW3LkNmJSrNWUMxUpozC9pCDN9n0G4P2A6nyoCjCYlBA/V90lqwZkLcsBCOV2nefi2gitklttmBsKTHTWdehuUbo2WfQghJvFLrIc74clXlKGh5etJoQjku1dGY64S7sdYP+dpZO6v9UMaI7xGBybnGO9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dI+3L5Okwbiw0RIJA2GxVNY9Agl7UiyaPZUc7NF9A1g=;
 b=oT2ARQSC55J8HzBXxkcb45XHzteTvJvi3CIcYN2BpQy4BzxuMVpU2TAGbZ277OagoCoBSDxO7XsATEeuVmRqUJDNwRCJ0SQfv5eiNdAKAGk5YoffDYLD/rVrXF6iNwsU8EQ8nbeXMzWtNG4TVLYQ85WuHq93kcZpEM3FVMcHpKqMwxHKb105DWMHu4cEBUQIO+1qsC8qfrkrpERT8IdvHmDHtBUFKdNLHnyanEyYnnhtX6b/hmTRdhiDCq02lKFV1RE5gj/02ab1KOItfRBX7DNmM93UUJpU7vZyIXuDJNiB/8a8YUIbFLF12W1razCtlpw4cMHZOHqHAAU8aCbGJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dI+3L5Okwbiw0RIJA2GxVNY9Agl7UiyaPZUc7NF9A1g=;
 b=ejkD5oxUxoxlgU4F36jenzyMFtAa2P42o7Y1XnqLUojIhOfWpF/UUbrd0ykCh7yVvEjR5PD9I1sb9FRtJRPMpoULoxHMXT5xQHVviVkE3kqtRGnjjQVTDAgy+Dj1KnTZ7SFWxdeI+XLjKYvDY+yFyYXCmWOjTMblRAcsTf3R6soEmTBPnL8VIds/F/yKz4LIPBbJIRMNNvnLrXnHfyHpMoD7UyNSxXH92Xp790kjjyJoLkTgaHTQdHfuwF1SMHPW3eV113hql9H98zMMgg+TsiOf9oGxCVe29E5BoH4e2r/2YJ6KtIJpO7Xa2pr/LX/QZw1RY1U52GTIicEhEsiQOA==
Received: from MW4PR03CA0004.namprd03.prod.outlook.com (2603:10b6:303:8f::9)
 by SJ0PR12MB6901.namprd12.prod.outlook.com (2603:10b6:a03:47e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.23; Wed, 9 Jul
 2025 12:46:41 +0000
Received: from MWH0EPF000971E7.namprd02.prod.outlook.com
 (2603:10b6:303:8f:cafe::3d) by MW4PR03CA0004.outlook.office365.com
 (2603:10b6:303:8f::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8901.27 via Frontend Transport; Wed,
 9 Jul 2025 12:46:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MWH0EPF000971E7.mail.protection.outlook.com (10.167.243.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8922.22 via Frontend Transport; Wed, 9 Jul 2025 12:46:41 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 9 Jul 2025
 05:46:23 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 9 Jul
 2025 05:46:23 -0700
Received: from f42.dev-l-178 (10.127.8.9) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.1544.14 via Frontend Transport; Wed, 9 Jul
 2025 05:46:18 -0700
From: Dragos Tatulea <dtatulea@nvidia.com>
To: <almasrymina@google.com>, <asml.silence@gmail.com>, Andrew Lunn
	<andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Jens Axboe
	<axboe@kernel.dk>, Simona Vetter <simona.vetter@ffwll.ch>, Willem de Bruijn
	<willemb@google.com>, Kaiyuan Zhang <kaiyuanz@google.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <cratiu@nvidia.com>,
	<parav@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<io-uring@vger.kernel.org>
Subject: [PATCH net] net: Allow non parent devices to be used for ZC DMA
Date: Wed, 9 Jul 2025 15:40:57 +0300
Message-ID: <20250709124059.516095-2-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.50.0
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E7:EE_|SJ0PR12MB6901:EE_
X-MS-Office365-Filtering-Correlation-Id: 9fffd56d-8d06-420c-1f28-08ddbee6a761
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?39MQE0IcwC35P2jLSjCOAAC82/hYWKGg7id8HzEILhlW2Srr6LWOkuA0g+VR?=
 =?us-ascii?Q?i2jzQley2Ich6TL6t58HpslrSfljMWK8r7Lw0r9M+ty4zdsqp5zT6FHg9XXC?=
 =?us-ascii?Q?goOY32GxrrL7/JtPt4Gk7USKLbszIfZGrIzYG49INfoVmf6mvCQHyVZKQnpF?=
 =?us-ascii?Q?v/gENjq0f6b1SMpqbr7LxR+azQv8Ia4qepn4fA+GZe0C8rT+SWQkJHOU4tE3?=
 =?us-ascii?Q?NzgAA/eotScNmbWt2WosX+1mFNsii6BmhwsmitYKd2zNT8JvQ1fUj9bGwFbQ?=
 =?us-ascii?Q?V3Kje2xb/cSUJ6FNJis42MMWBFTUuKpNbaRZZTK/ZprQrzFIHfhRiB1eUmCe?=
 =?us-ascii?Q?3owBo8FWFFu80Tq0CzRTddbg1LU7inLagdC2FdCojz1FNbHr8YE9VNVPqeU5?=
 =?us-ascii?Q?g/F4Af7aquPGQ0OD4SusGM+deSMjEIma6uOyUVkAkn1nPEP0kV1MSZot7uYJ?=
 =?us-ascii?Q?y9WRLhS0EZ+qXaT2Z1KTNSKeqAHWQj6tjLDbn99DqXas9scNC2NXOZ5JNrkC?=
 =?us-ascii?Q?1NIN3qjKwWq6Dmjnn/B5/77niFDA/B46v82dsAJDDoB8dZSmM9hc8l1AHO8T?=
 =?us-ascii?Q?hgAkSWVetA5bxhRu4+3utJNBTYbeYcLkDlSi1e5zc9mOm8n24aBHdcvpk1YN?=
 =?us-ascii?Q?YgBjWLsaxls9GkOOKQYF0tteMbufmZHOy2UXvF++pFQd1it4et6/HzLxnkty?=
 =?us-ascii?Q?LgDVTzmRCi+zz01IIDCUhVk92fkj0LJesXbUGUdv4YC6QMdYJObabMo/14Le?=
 =?us-ascii?Q?4sAcOtn/NnOsdnEwfzJiVTo45neu4J9Pilov63ldqNXdVem2K+VPD9i4Ef99?=
 =?us-ascii?Q?ugVanhR5wfbU4zNsByDkW5Ro73f0+52YCsPNTScGS4erzMkNWpf+wenF6TRX?=
 =?us-ascii?Q?nCFPP+pM4PI1bOV3UWh/yyXnkHg18bpt4erSLvlf7NHWrxsIk8b7wf+rxIq1?=
 =?us-ascii?Q?bg3v6bjFs29KK5pJZBIBQW177u6uj9tYkqSxKaRZ1CqryZFDWCUa7FA1GJ1x?=
 =?us-ascii?Q?kkZE4syRtiWsSeZFGL4Kb2unO3QtLjnwNVviOyLKuCarLou/jOOIm8T8oWY2?=
 =?us-ascii?Q?hg9CQft4FktCOdchTjgR4+ePBH0rDdTmQQ8wmj3Wj0eUD6FEW8M02nltgI/m?=
 =?us-ascii?Q?19Knc4OAQSddcJmoOp1asD6PMPaAEKJsMDop9Xbnc4H5KdxP/1sSXukRGW18?=
 =?us-ascii?Q?OT4XyuUazjrB7tCHIcbdFwYv7AF5zxWWN/wcslXhkjIcYSTB3Yd6sSPOV8DI?=
 =?us-ascii?Q?AeerwEXCLNx9No5fK/HQLIFSQN9o099tAj2hMemJwsqwGAeW0xSB+ADKwVVx?=
 =?us-ascii?Q?NzRVuyxoUqvB7hpilquwuEu6C+BRb9MEVmWF8NiFJaDZ0+SeVl03jYYkkKR2?=
 =?us-ascii?Q?JjoqAJrG0Vb+hXsRl4qbUP/bfSGIItyeYzFt7S29uStpZrB5DcXnFHUEwAnd?=
 =?us-ascii?Q?rWZB7RSp/fg5rsdBBvl4hObgbPLoUunWnGRDO7ZPqNFTJfEQpoiddDXx+RwC?=
 =?us-ascii?Q?dii8ACUNBbjtuPZohS7a8PCN8MS9FhXfCdOA8G3lMzMkox/jzXTtUp9UqcCD?=
 =?us-ascii?Q?KH/CfBnVZanPR+2wINs=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 12:46:41.5466
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fffd56d-8d06-420c-1f28-08ddbee6a761
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E7.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6901

For zerocopy (io_uring, devmem), there is an assumption that the
parent device can do DMA. However that is not always the case:
ScalableFunction devices have the DMA device in the grandparent.

This patch adds a helper for getting the DMA device for a netdev from
its parent or grandparent if necessary. The NULL case is handled in the
callers.

devmem and io_uring are updated accordingly to use this helper instead
of directly using the parent.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Fixes: 170aafe35cb9 ("netdev: support binding dma-buf to netdevice")
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
Changes in v1:
- Upgraded from RFC status.
- Dropped driver specific bits for generic solution.
- Implemented single patch as a fix as requested in RFC.
- Handling of multi-PF netdevs will be handled in a subsequent patch
  series.

RFC: https://lore.kernel.org/all/20250702172433.1738947-2-dtatulea@nvidia.com/
---
 include/linux/netdevice.h | 14 ++++++++++++++
 io_uring/zcrx.c           |  2 +-
 net/core/devmem.c         | 10 +++++++++-
 3 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 5847c20994d3..1cbde7193c4d 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -5560,4 +5560,18 @@ extern struct net_device *blackhole_netdev;
 		atomic_long_add((VAL), &(DEV)->stats.__##FIELD)
 #define DEV_STATS_READ(DEV, FIELD) atomic_long_read(&(DEV)->stats.__##FIELD)
 
+static inline struct device *netdev_get_dma_dev(const struct net_device *dev)
+{
+	struct device *dma_dev = dev->dev.parent;
+
+	if (!dma_dev)
+		return NULL;
+
+	/* Some devices (e.g. SFs) have the dma device as a grandparent. */
+	if (!dma_dev->dma_mask)
+		dma_dev = dma_dev->parent;
+
+	return (dma_dev && dma_dev->dma_mask) ? dma_dev : NULL;
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
2.50.0


