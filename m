Return-Path: <io-uring+bounces-9277-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 249F2B3367E
	for <lists+io-uring@lfdr.de>; Mon, 25 Aug 2025 08:37:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D11FE172D3B
	for <lists+io-uring@lfdr.de>; Mon, 25 Aug 2025 06:37:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6E1E283CB0;
	Mon, 25 Aug 2025 06:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tfqq9XYc"
X-Original-To: io-uring@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2045.outbound.protection.outlook.com [40.107.244.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18ACA1A5BBC;
	Mon, 25 Aug 2025 06:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756103850; cv=fail; b=mMcv9ZfnyLFc62QxETmJV8fIJITlzdRqGVJzPm/lcDMwozUxQfT6jnQnhtm5/MCIZrbdUFZzJ42BqSIX7TsEaDUC/dCQDvWDUo72+2TNShBiG5rNXEP+zidcyUsQ/QtoaLNEaSk+PcI8Z9O/oEwq4JdzFm61J9N4Ohnr8XeeGCY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756103850; c=relaxed/simple;
	bh=EYZguowLrvAgMkWXKZFwNWnqKBDxH4xhHv/EM2AWA8A=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=t8E6UoRI8Jh5ODiO/aIs3FdjfezBqUSNgvkIw42npWKWgZQTEDX7PgdsJH/aHSQFtu+nEEWVwFDnfMBsSEZMH0rY+PMevi1kE5gdPp3NT33QZLdLUXkLkzZ12UeYnGq9eV4tBlvlebFYYWF03FEs6A3Im/5971lXCUbCBHaAlRY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tfqq9XYc; arc=fail smtp.client-ip=40.107.244.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K071x/ubCc8l0YowsUVPDXb+encny+rln6GWjjZyy7zue16vNh6oCtbikVF8W4aDCA7curEcTdle28l8IGqrP9WZIoJ/6KCOId15z2Jpkn/yO08MyuPbqVphB2w8jNNOACYTBC/JVd7VWJrh9+XG6VoZ+tXSPsB6ob33RBwGvhMZAmxhfcu9v7AqEt46zPDU59x6oAOs0dcAkJQydO8whyBC+xjQ7DwHRFMdVGMU0HB1dneU31g+90j5vX+ogLEkJTpyPxTbyLyizpsCgu/MP7Q8HIl+vW+JiHOPfLAXVqPFcbSv/zA3cQG2RsNQi0QLTcRKS0TRdI1NPuJG7JcWtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=smeNUjkNfrikTdCMG1dFtFlx08bvQ0mG9JlD76mnnxY=;
 b=Oiarr9hkgSqVO4rRPe9uiodP0Y5YdOkX2X63zh7WSFucos8FrzrFqtZ2zl2Udy3eyhBUP2JgRmeXbn/CFqpCPqUIDVXf/oQOyDAzPidgwp9LdR3j3+ON4TTa0MyeW2rdx4isYuy/p2D2k8vBLihZviydzaoSkF9eCmWvlDsypJDixXhTJYM23UFYI9pe5Ts51l+ADdyJJqLfID8dFMlMG2Is9ULuF4sg2Drsj9WzNz3pIB24pZj5jpxNJeYCiIFY6v0L03XVs8bUBinhHE6omfr/ggymRC8fUX3W5wcX2xAiAOGRgYuGVZsW4/1Tshj15NvFM2LQh7GQVYegmVhH6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=smeNUjkNfrikTdCMG1dFtFlx08bvQ0mG9JlD76mnnxY=;
 b=tfqq9XYcVnqhaHcyZF+iVoXymj+haWLNyt0mN3uXm257ComYLZt9k7dbfbiIuuq9SZ0RKGRla3Nw+dcB1Zl0lNvjdjEPe9fFsfNGTBm0QKpeFhZ6iM98YKo/apphu3Dgf3jTGXIV+axosSHhsc5/xKtd59mYH8PazrWbQt7FA4+NpAg88KS0ULpIHdf76xqibFMe9SLEssEnyfBDQr800PKfRpGPxYGdbWJ2tH9cCxDsCv5Tc/lvq7ffVhkmNEtlgiul/JhvCGOZvhLHfwZpM+pg12fPASEJEC2fNaPoSfbdmCYs39XpcaFMaFFRVa6sEscZy5Z+2Dk5/2qzgOHFzQ==
Received: from BYAPR11CA0061.namprd11.prod.outlook.com (2603:10b6:a03:80::38)
 by SJ2PR12MB9240.namprd12.prod.outlook.com (2603:10b6:a03:563::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Mon, 25 Aug
 2025 06:37:25 +0000
Received: from SJ5PEPF000001CC.namprd05.prod.outlook.com
 (2603:10b6:a03:80:cafe::10) by BYAPR11CA0061.outlook.office365.com
 (2603:10b6:a03:80::38) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.21 via Frontend Transport; Mon,
 25 Aug 2025 06:37:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001CC.mail.protection.outlook.com (10.167.242.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9073.11 via Frontend Transport; Mon, 25 Aug 2025 06:37:25 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Sun, 24 Aug
 2025 23:37:10 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Sun, 24 Aug
 2025 23:37:09 -0700
Received: from f42.dev-l-178 (10.127.8.9) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.1544.14 via Frontend Transport; Sun, 24
 Aug 2025 23:37:04 -0700
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
Subject: [PATCH net-next v5 0/7] devmem/io_uring: allow more flexibility for ZC DMA devices
Date: Mon, 25 Aug 2025 09:36:32 +0300
Message-ID: <20250825063655.583454-1-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CC:EE_|SJ2PR12MB9240:EE_
X-MS-Office365-Filtering-Correlation-Id: 42ea7447-b1e6-424c-6b37-08dde3a1dafa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|36860700013|1800799024|13003099007|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7JMBeMrsMYxgFtYGez1lqN+cdAMj+7+ezoBhekKCRi0tit7c4afWZjO1xZsa?=
 =?us-ascii?Q?DhWU8NtiQNX2+ZBKP2niXBvII0Fr0OI76T/l1ko5HB/HOChKqRUoA1LBebgn?=
 =?us-ascii?Q?WXTlFwPUuimUCFRh6YdKQT2ULsRK02g57GK7InHpx0lw/foQCCSHDOYWIDBW?=
 =?us-ascii?Q?cc9FVPZtN8uC0UD4dzGhoz/DxGZpgfzbfOvdg70pClL0AeLdoJUaIci57S5c?=
 =?us-ascii?Q?wLlLH7Js95I8ZvH1HST4APOou+yQV4aHI1OV3AbLGhOvM6RSyYztAmqqy+f4?=
 =?us-ascii?Q?z0AQPRFPRuW6MmS8IVTGFHkMyAzd0ei4DXNnI78okJzgJsetwJQe2VpuZahS?=
 =?us-ascii?Q?4rRE1tuZsh7ib17bhxlrXp5BkCBRdV77ENr8OFkFhxwuRjRu2fHBZDrKRQGp?=
 =?us-ascii?Q?NcKuj1ueMDcpmlDj+KLRrCv8FQvPNcs6EpNFOmxdmPuFFx3H8DLRmGpo25si?=
 =?us-ascii?Q?V8Gx6A/xYm7bYH3+M6Jb8rGw2r9cuWdhpansbvdfhONhNknoqfx1O3+YnoSF?=
 =?us-ascii?Q?V30y0Pi8rw8Jup/DRlRIKTr/JAj4hS+ye2VjqT3ypXcsUzqhQ+VThNh4hcPl?=
 =?us-ascii?Q?xOoT0sKjxkYTSOvzbT6Gjr7iXI1zRHTQoxJccfdYBz7YcDxjnKKuTozZJixu?=
 =?us-ascii?Q?pMG3u4oCKqMfUgQj+40bsmwuxyAOtW2ZeIm/ceV9U4ZcjD/yiJFCZvoDEhX9?=
 =?us-ascii?Q?7oYyyul8rMFHijSicC3iWYjyCtqDwFBG6OKtmeeqUCJfwaUA8WUm0msfiS/G?=
 =?us-ascii?Q?brUyG4l3RZ2LnH35nA434MbkZtay5OvSZjIpDuDxrqNTZGnzu3TCUQwhpjAl?=
 =?us-ascii?Q?BBhPS2FYz0P3Peid9PtBrZU99mEPU23pXZu0WAGeqqbnxJpD2objZFKKbs5T?=
 =?us-ascii?Q?hMNPpYchK+zoyOUjxYzNsJa/21guQmIuTn8s9g6fxqOjaJ7VEg22pUveaucd?=
 =?us-ascii?Q?MTpxNfKKnKRvONUstOzp00lepG4a5kZ06zRqSl1jqLzr4pbR05uYkF5MJiy4?=
 =?us-ascii?Q?AFUh4hYTy/VoUnLosHoNPxfmik943pzHbYGREwsZqig7IHREjBaswL2SjZ88?=
 =?us-ascii?Q?LCJ4m+2xLSfBtHog5MgozW3OzCLZE/3uTKclaYntQ2dvLwYXPoIOjjbOsR71?=
 =?us-ascii?Q?j2e3fegvDXLfXAg7JIy5U/QqEZYfHLtMsY6QsAhSQtEFAWNPBeIBIbukxreH?=
 =?us-ascii?Q?70MLXgP8mxsoMDAkfSIQPC6QX8m1NMtOi9bYJcYlhrBIAZ/sc8mXthO/4l1X?=
 =?us-ascii?Q?oMHoOwZRsNF2O14LALfmkXALcL5/4Te2ZcP1VGspybqcHYSpwGI7SNWvG5oz?=
 =?us-ascii?Q?H77zEtWllcYrDz9OqBTz0jVoSJTJ6Y4npfMLPNPMsVVAT1gxmHA9vjhvoWPV?=
 =?us-ascii?Q?3Hre/TKuR//tOCaD6bAVound6skH/m4XwCFc/mMmgRU7usPmGkQUCmgViS6K?=
 =?us-ascii?Q?C671ZGvkR9FnoovbFmscHBt1PEBWppImjcngOdWx/omYjztIYvYsUlo1r/ah?=
 =?us-ascii?Q?aNgohBKy+nWSimF9wqJk48HL4EhnWSu6LSYQvcSNozjAjBSL3QhABmqL3K8c?=
 =?us-ascii?Q?66uMi0Tw0QYHp1r74mk=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(36860700013)(1800799024)(13003099007)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2025 06:37:25.8274
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 42ea7447-b1e6-424c-6b37-08dde3a1dafa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9240

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
 net/core/netdev-genl.c                        | 120 +++++++++++++-----
 net/core/netdev_queues.c                      |  27 ++++
 8 files changed, 161 insertions(+), 31 deletions(-)
 create mode 100644 net/core/netdev_queues.c

-- 
2.50.1


