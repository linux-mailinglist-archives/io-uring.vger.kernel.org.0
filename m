Return-Path: <io-uring+bounces-9107-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 327DAB2E313
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 19:13:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4214AA21DC5
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 17:13:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3A6833473D;
	Wed, 20 Aug 2025 17:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CXeS7/eP"
X-Original-To: io-uring@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2049.outbound.protection.outlook.com [40.107.244.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 349943314DC;
	Wed, 20 Aug 2025 17:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755709975; cv=fail; b=X4aYMitIgmK15ONQaiZkwqDyX1uNG+FFDRdcpLaTG4pJrbH8XD64PX2SMtGiqzeqn1JXk2FvFTwYcYfZ/IbvVSMuxMOHAdkmdkEWW7n3iMpPWiGhKsICd01aoa18xOAf9pGpbnMlHDTlR/Xzc85XEl3jL2n6z/eny6V7QIhL0Lg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755709975; c=relaxed/simple;
	bh=cUuX8ujmedt/EeuG13BYq2JXLddUYJ2LiqE4121618g=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=BeI5dwv7xub7HfQ5r/gGzSOhQCwAtEcb6/9DECttjcoYCRxQkHHeEyZ+1fMHhxP9KcmCHIvczPKng/HnDJ0UOp5DZMKR7uPXs08r2aHz7qk4A0/FEF2cwieaZ1D7o+KnlIvsrb5SdlUTk8CcccScsz1gQGAG/l9mRBxnLt9iHXw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CXeS7/eP; arc=fail smtp.client-ip=40.107.244.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sxFQrFKOJLq/0IeEph4s22jAz7GQ9nmrbR5qYFnQzf+NtWyvEOl5R/dggJf4kMJN1sD7tW+/mJ4ej7rAifqImZ/EaN9b1ihVxs/BaPEDzOWKCdCa8BmMYfOKDOxKWDJQR1K3yn8SIgmBE0hfsOR1eaA1D06a0ajJQl7s8u6a9GTpOCh+56fkBazDVm1etSmLswxaQj9c/+gDMiANR1lKIYxBKkFrvRsj+6AvBgH2U5bVBnrHej502D8kxk4dLcgeojKnU+K+ZGvFTSHO6a/RCA07Pato40keUXZ8W0LLP51Ua4jGIP/4aym/rYOXChMfEWtA30S/A9vWASZjr6foig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K57w/4XjGEhIh7fhk39AfV+lRlzGSf3PZDEo7ZjIU+Q=;
 b=C+r1sCqmoIoNDEceKqNvV6AVpLgp0j4u6Zh+Y0YU5U7rLOZjeF7Z0KE7rUqrfC469Wsmn2Y4EDTU4gP+zVXHbf/VMABHlPWeWcnvIgYd2uAkxrBRZh+DJ4cAThFrYgvoAL/n5sr/+QBqXA86dPV2zRYBVsGTw5hfQBBR5K8Nds1TLzvHUjgTW5NQcSdrKR0O/tGzm0r0zks+FpkZ5WZhsrGSMT+SyzjkXZhzzumqfXF9St9bj3P0vAELiJJVvHfTZsVSRA7A0TDYOH2pA5wEEw9mo4OdOpEpC6YkeA74hodfdNrwRg8Ld7smgkAdRwPWGn1RgopwpRXw1XxTlgxqww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K57w/4XjGEhIh7fhk39AfV+lRlzGSf3PZDEo7ZjIU+Q=;
 b=CXeS7/eP6rstBaMhoKJDnaRp7f227PoBKWD4JkKGOeGKJV5l8cPOQsEpjOwflJJ7lKheEt1pJhsRw+yfCpgHWhcJReF5cvp6xgAEwfr4vNoVS6tP8rh3Unx4BOCayk5L5YV3fzzk35P4eacWMUslCHwhLrms07uVCf/M333DfQ/LNzjk5uXs1kAI5hOaXqTnN/IenpTUj5TVmurKqn03ZOksjJ/xw4C2fb9OFCXJakNmCSBSsPGQtq3/59yzMX7eS7hgxvApTavxAYFVFG6Seaxuw5S82aCmmO2GoMG/9dn/sddwqbA5PuY7slp5DQAgkEZKQAodvOjuujsPCATGLg==
Received: from BN9PR03CA0156.namprd03.prod.outlook.com (2603:10b6:408:f4::11)
 by SN7PR12MB7227.namprd12.prod.outlook.com (2603:10b6:806:2aa::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Wed, 20 Aug
 2025 17:12:49 +0000
Received: from BN1PEPF00004682.namprd03.prod.outlook.com
 (2603:10b6:408:f4:cafe::51) by BN9PR03CA0156.outlook.office365.com
 (2603:10b6:408:f4::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.14 via Frontend Transport; Wed,
 20 Aug 2025 17:12:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN1PEPF00004682.mail.protection.outlook.com (10.167.243.88) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.8 via Frontend Transport; Wed, 20 Aug 2025 17:12:48 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 20 Aug
 2025 10:12:24 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 20 Aug
 2025 10:12:23 -0700
Received: from f42.dev-l-178 (10.127.8.9) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.1544.14 via Frontend Transport; Wed, 20
 Aug 2025 10:12:18 -0700
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
Subject: [PATCH net-next v4 0/7] devmem/io_uring: allow more flexibility for ZC DMA devices
Date: Wed, 20 Aug 2025 20:11:50 +0300
Message-ID: <20250820171214.3597901-1-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00004682:EE_|SN7PR12MB7227:EE_
X-MS-Office365-Filtering-Correlation-Id: f80f701a-3421-44d5-f1b0-08dde00cc9f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|1800799024|82310400026|13003099007|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4PunLWig/winxx8MJrcduDWHS/HZR5KnHPjvtw2RAZjyIyRai0mVoIpmhgVt?=
 =?us-ascii?Q?Ge5jD9lEiQU0JnZekjFfGG1D7Y78oF/AX7Teh98NI6pec72X19xQiwN4tBCP?=
 =?us-ascii?Q?eH3j3k4Gs1L+3oPUAat7cC3LQGLK3WekWK32Cwq7atqVMcq0rWvnLl0Ur6QW?=
 =?us-ascii?Q?zYjJJ28CrrZ0ajhjyhmCm5/HU5GS7dyMWjQzKj6/Dqt1X3j31TJ4bkmUYIAq?=
 =?us-ascii?Q?CPX7u4mpWUqo0jeWuqYby6UL4ei8GH3JqkL8ztzwHUses5AOPV90Z4rqcVW0?=
 =?us-ascii?Q?8CCk4nY5OyXzJyIeBB413DiH/7Yzw1HKd39HzsvO9JrKGWLS/x1jkvkUwFvw?=
 =?us-ascii?Q?etqgwT5kvyMltBM3jGShQnyrByU7wgUxzKIduuPTogrocacXwzv/xqlvLXyG?=
 =?us-ascii?Q?+xolrGhcS/JC6qHVLfK/yS46iRXSxWQM/mLygW6vfkzlTR52Ty/pewjYeG18?=
 =?us-ascii?Q?hdOXeRhGQR1/XMAYyehmSGFsb9HjIt8G6ddEp0Sfm85oUx0XxZCxboJKJvE/?=
 =?us-ascii?Q?SBG38+quKO2QXw/FQUd+4qTi7ot2Ao9CkgXazWnxkJaXQtUJY8ESd4ihVn5g?=
 =?us-ascii?Q?b+PZQd2AKolCSdAW3QamcLCEROcqT8w2YSPxz5DmZ8aiEHhY6Y4ccvlRLvtV?=
 =?us-ascii?Q?tRwJH3ZotAI/LoEs+AyoIarXD6EgxRvV0u2arnqzos25GPnaggWNFdGMRes3?=
 =?us-ascii?Q?u+gyPN1Uv1mzr9uo1vbg1ra5PKMAcjRGu+U+SZm187G+7+HSLHmcFOFIXog7?=
 =?us-ascii?Q?tltfSty3NJnJa9RB2HNELJr8N2lh+E0bQE72BNdKPzXBL3TSzhqIztS88FkV?=
 =?us-ascii?Q?ehSXK0jyd0Z/vB7x9dHWU5lExB0IZT8te33Opn48AfRba3InbHMN6QWlonQd?=
 =?us-ascii?Q?uuXbHyqCFR+/37HAM2TSm0X/4PO4ow1SqBMKSzQ9eyu5WokOTrZVRQ6nZ8JP?=
 =?us-ascii?Q?6T9yso2zSz6l5LSnNI0Ydbf7pD+KCtmNPNbsPA/0xGBQc7XWw0im5GC13UdW?=
 =?us-ascii?Q?B2oFkLyc7xaZDNTwPE5LHPEVZ+GDylhS87oTd9a312DrhI04JJJG5BLLSH7u?=
 =?us-ascii?Q?3CZba8uwkM2GWZhwIX0/h/3K9OFM20ZVIdhWjTk9iPuKavXv7cgRKpG3GyxA?=
 =?us-ascii?Q?8a8T//tho6Ukt47+2kcL6AUMnAUOMvPEE4jyBeOWIodV4/3epYt1EulZjcaq?=
 =?us-ascii?Q?pf30g7kPk8E2jehaPnLnuOIz95lm5t0Okx2jvEhGf8RNbxF6n3ntBfg6cQH+?=
 =?us-ascii?Q?5hCyzIcwxAWWAI62bgaE02GWv2untsZlngWlv/fgrMhITBk4MNdBhtgARCpy?=
 =?us-ascii?Q?+gtOBkcJObhwdcsCKhbfy/XuxHrBKc14afszfvZMNbku00AlHcLUi7TKt+Gb?=
 =?us-ascii?Q?CQC57vcVpV+dyHT1WzxxUFvHjflbVR/LzDStdFJvv6VFwdjNO4WVNAtF/ui8?=
 =?us-ascii?Q?Cy3cJEu4HDRR0CTKxfjjFYyqree8JbjdI/5pxRBclrRSUTabieNTBa1r8u/y?=
 =?us-ascii?Q?X0YzHb/6947YkLFwijncEKF+5VdUBftO2KlDnp6wpxlqbSKAM3PmKw3T6JwA?=
 =?us-ascii?Q?MiUOcWdTaFxHB11bymA=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(1800799024)(82310400026)(13003099007)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 17:12:48.7273
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f80f701a-3421-44d5-f1b0-08dde00cc9f8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004682.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7227

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

----
Changes sice v3 [4]:
- Moved ndo_queue_get_dma_dev() from header to own file (patch 1).
- Used real_num_rx_queues for queue bitmap (patch 6).
- Allocate zeroed bitmap (patch 6).
- Validate queue index (patch 6).
- Forward errors from netdev_nl_read_rxq_bitmap() (patch 6).
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
[4]  v3: https://lore.kernel.org/all/20250815110401.2254214-2-dtatulea@nvidia.com/#t

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
 include/net/netdev_queues.h                   |   8 ++
 io_uring/zcrx.c                               |   3 +-
 net/core/Makefile                             |   1 +
 net/core/devmem.c                             |   8 +-
 net/core/devmem.h                             |   2 +
 net/core/netdev-genl.c                        | 123 +++++++++++++-----
 net/core/netdev_queues.c                      |  25 ++++
 8 files changed, 163 insertions(+), 31 deletions(-)
 create mode 100644 net/core/netdev_queues.c

-- 
2.50.1


