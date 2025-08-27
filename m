Return-Path: <io-uring+bounces-9309-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 506F2B3852D
	for <lists+io-uring@lfdr.de>; Wed, 27 Aug 2025 16:41:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8DF497C0FDF
	for <lists+io-uring@lfdr.de>; Wed, 27 Aug 2025 14:41:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 959F2205AA1;
	Wed, 27 Aug 2025 14:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bX/VOT3S"
X-Original-To: io-uring@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2058.outbound.protection.outlook.com [40.107.95.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B4D17A31C;
	Wed, 27 Aug 2025 14:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756305696; cv=fail; b=TDOeitcD+nSpxSXztqC5t/nIDFygjRbvKsB5eFjkBKxdwXOdPTGpJEb/NMXJFcHG21+F8FC9HTwP5vp+uX1sp3q6BacuJFpFXT9ShO5UURMtDkeNWolrWxiYa04rSEDk00tdNGUU/iUvp4iFKD657qdf5yK1ZRc3WO0mZfsWvoE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756305696; c=relaxed/simple;
	bh=S/lXpoFib5RJOmdiiiitQD4JeaBTOpCKNfm+6SeJ9Jc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZCO0mlu7y+0A+cBmLfkhXGpfszeEQjH/fcjpihV2Wtes8ZzYHPBJFGx4j/pu9oW2PUS3l/Artqffq5U8JfJaeBlykYuYHylaLmLZG0gKMLK6NPlSsKKmVYQVmWSQGxfRjvQEQRv62iO2DMb4EZHn2Dp79Nq9JMIhAvJesGAXnSc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bX/VOT3S; arc=fail smtp.client-ip=40.107.95.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D91vdcz+eiQ56Dh2RYX++kS4kulKNt5KpL+5NfG/PfzpKjgNVCejm/YLyfKjvdxWmKY0TGBRro1vDVb7UVQzRkUP+qgXsdTGD2X6stuf5doV/pOZg+b76518l/+/zDiDg/SmkpHgmWvgXMWIgTndnvO3oqRv32Dq9iuR4coGQGxY3pSqDxhvnkdz6DkD5+5p0tH/4ZcpPWv8ti6Pd05Lq4sx52SSKSSFP3WlJ3AGHzCm0iNQgQxKEL6ZpfXI2YIeYDvaewfa3RHjAS9OlcmvQZmzqZI5qi5sB7Kh72lTHsMqc7LocutSuFZCVO9F9X8/22xQLglAC6MC+ME/H5ra8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BvOBQnx5tyhdqpS4k4sZlZE2NrnlhLTAI4DFDiM0qf8=;
 b=lHgV4sagp3SIS02oRyoxMYt8+k0MHTRXDxa7KFFGvXup7xRt9UsGI2HVh10WSXalUajhkb3lchYLr8UmecHprjgj2utar6qRewYuY3EddyAZ8Or7n9TXxm6zy19afus0IOSoCFgovYx7VdNMKVbzP/yTpnvELeDI6tGwG7yWRRHRmnOeiU+qRCym39WTxzo7CIp0xNhbrSOjOpJ5SNswbWJmxhDIVpAkJ48MOGpLKGIghBlHsUK7A/obqaMrdP+MfdqmwETJMtJtJq1dHvpJTS4NrewgQp+/5tugQcmYSC1adPQ2LBMwiE8Kgw7raJEupBUvvD2d2UmeW3eqHNXdcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BvOBQnx5tyhdqpS4k4sZlZE2NrnlhLTAI4DFDiM0qf8=;
 b=bX/VOT3Ssq9JMjVZ3HAeZOqmBaiQR6BJ4vbqchqKyea/mCml2VBwykqozBK+2zeyFgS7S4rifArhhieaITIm4xOT4ANgupd3fHbvnhrB1UWxuXsT/pHE+cmNPRxm2Krv5TcGxjGPFLW/IxLW2iYKzlGQtOmrJz4FSQNwPtW3csb5ByEnETF6HKC807lEQYodrAeEq9dWBzxGNXXPWb/ofO07E0gYSpeb67fkRbu56Ktrwd9Tgpg3VKD5HsO821221uGu9AP6hlKQve4fBiLUz+dH0xrA2NOr+DdmTX85qeYcqDd3tg3bFEjSZc1gUYmU9AEIFlLtQPEmHb4ngQEK5g==
Received: from BN9P220CA0022.NAMP220.PROD.OUTLOOK.COM (2603:10b6:408:13e::27)
 by MN2PR12MB4333.namprd12.prod.outlook.com (2603:10b6:208:1d3::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Wed, 27 Aug
 2025 14:41:31 +0000
Received: from BN2PEPF000055DA.namprd21.prod.outlook.com
 (2603:10b6:408:13e:cafe::55) by BN9P220CA0022.outlook.office365.com
 (2603:10b6:408:13e::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.14 via Frontend Transport; Wed,
 27 Aug 2025 14:41:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN2PEPF000055DA.mail.protection.outlook.com (10.167.245.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.0 via Frontend Transport; Wed, 27 Aug 2025 14:41:31 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 27 Aug
 2025 07:40:55 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 27 Aug
 2025 07:40:55 -0700
Received: from f42.dev-l-178 (10.127.8.9) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.1544.14 via Frontend Transport; Wed, 27
 Aug 2025 07:40:50 -0700
From: Dragos Tatulea <dtatulea@nvidia.com>
To: <almasrymina@google.com>, <asml.silence@gmail.com>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
	<horms@kernel.org>, Jens Axboe <axboe@kernel.dk>, Saeed Mahameed
	<saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, Mark Bloch
	<mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Andrew Lunn
	<andrew+netdev@lunn.ch>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <cratiu@nvidia.com>,
	<parav@nvidia.com>, <netdev@vger.kernel.org>, <sdf@meta.com>,
	<linux-kernel@vger.kernel.org>, <io-uring@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>
Subject: [PATCH net-next v6 0/7] devmem/io_uring: allow more flexibility for ZC DMA devices
Date: Wed, 27 Aug 2025 17:39:54 +0300
Message-ID: <20250827144017.1529208-2-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.50.1
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000055DA:EE_|MN2PR12MB4333:EE_
X-MS-Office365-Filtering-Correlation-Id: f6cbce3b-5b63-448a-bd9d-08dde577d069
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bieDuA5z4xDwUAIJGYSdFTspeeRCxbIjHHAXIdqsd7T0PIDUEpjiY3m69jfz?=
 =?us-ascii?Q?SrTj/TUPEOyOXGQRZmT352e8/ycecI1djd9NfJTVnrrZtnD4bIHKwCn9DOZI?=
 =?us-ascii?Q?Gijd8L+HusXKzI5kzMQkkrEpvg0sKocCyr9LaDMvIF92RgNZyPlDXwGCvJ9q?=
 =?us-ascii?Q?W3HSd7T0TUKuJ160ATbtrYBCn7I/hFm+IeuepPYcwrzXYadlcQr2mQ1DVXvf?=
 =?us-ascii?Q?tkpc2xny2we9MxISLXZnfWDJg3PiTYzpciwWmSP9BgA0lp/GBWGbMiVbHgyi?=
 =?us-ascii?Q?zBdPRF8GkSCAeb7zMsoR7ziAAZ+gBCgicoYzyVALoItvhtU8ZWMD3AuV1mne?=
 =?us-ascii?Q?6HWgqBBaBTq1Hu8kmuLYgUoATHanOP+EnVESrMkLmsfTgeY7tTWbf/+GptqJ?=
 =?us-ascii?Q?1mOAzXzqKr3P1gHgDIUbVoOV9xuabijX0IQznZSSwAPwQyfvdaAHpv87alEl?=
 =?us-ascii?Q?fSNlKhg0cK1Tnl8CVHWiL+yCgMBUlUB0cSYOzYrZ7YERYKVQuoR8kCCNGgFi?=
 =?us-ascii?Q?FrBGosbOAQUYZMQndnrQgoaUgQWFs6ESkahek9y2XYPE98CuMykCu6bkZvQD?=
 =?us-ascii?Q?5Wf9rFlXlYweiwWU/PexhE8C6ceooyhI1FBLLudO6D0vf/So26OftLEco4VE?=
 =?us-ascii?Q?0b7YqPHRUHv7mYcxHCoE/fiZ3oaCjM8oxN2P+XifMqiXXj9gTxRpyq0gTk+o?=
 =?us-ascii?Q?u/dAF42DX2ted30oBkeHEoDcE2N9vqGxD0nWU5FbC4IuVxeGfF+qa2IV74dL?=
 =?us-ascii?Q?lTjEL2pe1r0hqMM6o5j6y1If/FfCDa2jU4TG4L/vLhzBC0wJZkSBa4MnlwW+?=
 =?us-ascii?Q?3tCc+JR1RhGaQg9es3eBa1wBRnRHblU3kznK0vUg3VkJch6f+htFgqh6ZpvE?=
 =?us-ascii?Q?KLPtr+8xtoGCjPjChtEH83aJv79Uhyk1mM2NqQD3unNhbQWQA4X7G6juuZo2?=
 =?us-ascii?Q?md/ic42UFY0C7YP/n0Ltaj61ChNdYm6tlVPwOPao2KGFigZLEQhMvSy7sKCH?=
 =?us-ascii?Q?fIbfaz1DJ/ury1+bqeOeVjdLufwNI96H2BkW6DLTTOM2O1jtZU3p87inbiJu?=
 =?us-ascii?Q?jsxI/gJ68wbSGr0sl2yeymBDdkB6BpLu1oenqI2N9xf+GEGiyKLBIexXkUcR?=
 =?us-ascii?Q?WFVeX5q0TsOPIKq6q5SfBli95bdUnnVrdSdCV0opEQZtXjnm8GtYNZHuHqcw?=
 =?us-ascii?Q?YOpUPhH3NMmZb0WZf9F1/iifHVThc9VZCxKKFHmQc7Ql6BH3tC8yQA7s3PgU?=
 =?us-ascii?Q?fUaRL2Fg1r4clCeuKpqfSR1D8znir7bC5KMXGFZ7LMn3kFDPUT8VUiHxVUo3?=
 =?us-ascii?Q?Qwbxvxxgg1dWeIxoqCp1Vnq4zrGopxkoTwerkEVTZPXJ5c9/0h41ZeULgNus?=
 =?us-ascii?Q?HQUjzng22MunOw7LnVT7OzHI6Rc5hSitDKJRJomPOA2pYMwUbYF6XflTa/Dh?=
 =?us-ascii?Q?d87SIyzJaaentGqbZGOve4CHuIRVavfb+zih8oV129d5zBdrRskE1EpA7wIx?=
 =?us-ascii?Q?L1bN3lzjR7y7nGTVEzTZ9739vGoTGvAo1d1VmEAh3hMah6Bz8LR1R55rbuwp?=
 =?us-ascii?Q?hwwLJEvW6I5zV6o5BP4=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2025 14:41:31.2210
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f6cbce3b-5b63-448a-bd9d-08dde577d069
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055DA.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4333

For TCP zerocopy rx (io_uring, devmem), there is an assumption that the
parent device can do DMA. However that is not always the case:
- Scalable Function netdevs [1] have the DMA device in the grandparent.
- For Multi-PF netdevs [2] queues can be associated to different DMA
  devices.

The series adds an API for getting the DMA device for a netdev queue.
Drivers that have special requirements can implement the newly added
queue management op. Otherwise the parent will still be used as before.

This series continues with switching to this API for io_uring zcrx and
devmem and adds a ndo_queue_dma_dev op for mlx5.

The last part of the series changes devmem rx bind to get the DMA device
per queue and blocks the case when multiple queues use different DMA
devices. The tx bind is left as is.

[1] Documentation/networking/device_drivers/ethernet/mellanox/mlx5/switchdev.rst
[2] Documentation/networking/multi-pf-netdev.rst

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>

---
Changes sice v5 [6]:
- Added NL_SET_BAD_ATTR for incorrect rq idx. (patch 6)

Changes sice v4 [5]:
- Dropped EXPORT_SYMBOL of netdev_queue_get_dma_dev() (patch 1).
- Fixed nits, typos and line length issues.

Changes sice v3 [4]:
- Moved ndo_queue_get_dma_dev() from header to own file (patch 1).
- Used rel_num_rx_queues for queue bitmap (patch 6).
- Allocate zeroed bitmap (patch 6).
- Validate queue index (patch 6).
- Dropped rxq_dma_dev check (patch 7).
- Fixed incorrect handling of extack message on bad dma dev (patch 7).
- Added conflicting queues in error message (patch 7).
- Dropped RFC status as feedback was mostly positive.

Changes sice v2 [3]:
- Downgraded to RFC status until consensus is reached.
- Implemented more generic approach as discussed during
  v2 review.
- Refactor devmem to get DMA device for multiple rx queues for
  multi PF netdev support.
- Renamed series with a more generic name.

Changes since v1 [2]:
- Dropped the Fixes tag.
- Added more documentation as requeseted.
- Renamed the patch title to better reflect its purpose.

Changes since RFC [1]:
- Upgraded from RFC status.
- Dropped driver specific bits for generic solution.
- Implemented single patch as a fix as requested in RFC.
- Handling of multi-PF netdevs will be handled in a subsequent patch
  series.

[1] RFC: https://lore.kernel.org/all/20250702172433.1738947-2-dtatulea@nvidia.com/
[2]  v1: https://lore.kernel.org/all/20250709124059.516095-2-dtatulea@nvidia.com/
[3]  v2: https://lore.kernel.org/all/20250711092634.2733340-2-dtatulea@nvidia.com/
[4]  v3: https://lore.kernel.org/all/20250815110401.2254214-2-dtatulea@nvidia.com/
[5]  v4: https://lore.kernel.org/all/20250820171214.3597901-1-dtatulea@nvidia.com/
[6]  v5: https://lore.kernel.org/all/20250825063655.583454-1-dtatulea@nvidia.com/

---

Dragos Tatulea (7):
  queue_api: add support for fetching per queue DMA dev
  io_uring/zcrx: add support for custom DMA devices
  net: devmem: get netdev DMA device via new API
  net/mlx5e: add op for getting netdev DMA device
  net: devmem: pull out dma_dev out of net_devmem_bind_dmabuf
  net: devmem: pre-read requested rx queues during bind
  net: devmem: allow binding on rx queues with same DMA devices

 .../net/ethernet/mellanox/mlx5/core/en_main.c |  24 ++++
 include/net/netdev_queues.h                   |   7 +
 io_uring/zcrx.c                               |   3 +-
 net/core/Makefile                             |   1 +
 net/core/devmem.c                             |   8 +-
 net/core/devmem.h                             |   2 +
 net/core/netdev-genl.c                        | 122 +++++++++++++-----
 net/core/netdev_queues.c                      |  27 ++++
 8 files changed, 163 insertions(+), 31 deletions(-)
 create mode 100644 net/core/netdev_queues.c

-- 
2.50.1


