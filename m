Return-Path: <io-uring+bounces-8973-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D259B27ECD
	for <lists+io-uring@lfdr.de>; Fri, 15 Aug 2025 13:07:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 636AE586FFC
	for <lists+io-uring@lfdr.de>; Fri, 15 Aug 2025 11:07:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20EE428000A;
	Fri, 15 Aug 2025 11:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="juWDb2mG"
X-Original-To: io-uring@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2073.outbound.protection.outlook.com [40.107.102.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527EF23B62B;
	Fri, 15 Aug 2025 11:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755256022; cv=fail; b=WDN4JXpaxhEnzaOt+3m/0OqxNJ8qDlmQsYykA8pkOoFoDQ3O/ex5AyNewkc5T9oG778iHnVr4VdHq6jdwqkqpsb2Y2G4/wRcPzEMHf8YqKnuunddLWECALQp7w033vsl02Nct1OzU/61owE3Fxvzkm0fF0ly2NCcLn4WtTFlfxY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755256022; c=relaxed/simple;
	bh=JvPpV2CTI7dIWgRH8x82wmiJ/kpjF0XdJufIU+vA/5s=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=EGAoRGtKY7FYZQp4n0/IAOhhcJTe+Gm4xYo9dRkzSfzkacBOiDb/6X3E/Edr7JKZa2KHpayH6M30CyRUGmjmGUaUDLo9qn/p955b745mE63Vl409TaB0zgU3DlWpbg3zjIUnOJyWXDnBwIHr2bjt3ttu88DQHJmg8ArNvwG/4Qk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=juWDb2mG; arc=fail smtp.client-ip=40.107.102.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fxVj7uPx1F7X/Ht7zOe3AOGx0h2PdhjNE4ya3gpTnvc2+/8W6RcRBI42P9shSzTzi3pKKo1N/CvfggXnh4ioDU+Z7iG0QJHVbEkRk/gWxB4vLD+pxB6+hSULRbXvhp7sWbFeUkBUJ5E13df1bITPIAmHDTSl2XZ0D0F6kuH41b6v30H5RkR22A3uMmW07ntg0nbUYMScHi72niP5Qxhf6tOVUvju9KsjpOmfvAVG+GXD6ee5GTqsAUTQu02dzIOOJr/+ySuO4CkjrufDibslCp35Q6OBSH4EhhgZpZj9oZlq5qkgawVYGgW9ufU/ViAa5rLH9GlAMWeW+GuekO4/Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MbLuC86yBa9zb1GYzGQxWEPrt0vtJg2hWuH4FzCXFz0=;
 b=TSKSqsRdwlk1wv5VVG9VQZrgYncK31bbVmYuMG0QXPOq7MU8jx855LJ0qvaGyPQjqjxD+u0veaxo4lydtfGCAia8q0xD69nqr4oWLu30U3zy7dQ+WvsBeyt71k7zGJremGoAUfWhKQ10hhBKRorhupOffoeqCN5Xs1o5DTi8SXwc8i1YnyAiiH+1OsEUeiJuuImwBOiXYGNobLPO30HNQMOgyKiNpTe8ooIYVB/1knRripXz3WtU9e9PzCOXWunpzihfcXwYEJ5oqmrmQsG7EN38Md+F+FESjTvAHCttqhxEw3lLSLPuIW80An2n5KSlWBKO/5jMzNQEPi2p8CifKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MbLuC86yBa9zb1GYzGQxWEPrt0vtJg2hWuH4FzCXFz0=;
 b=juWDb2mGMiW/pT/hjklPuqppOQS4C9F0+J6X6vBGVq5VysofCeuilBOZ1xjuH5hVGh6OLyZmSG+mwF3VJeserzWAKv0QtoaWUfVIxti1pBtmsnmwbHBDi3PjSBZYqJijOYhYHOvdS/PWT9fzqfPbSqjHKTQwxqVSOskr/MAAC6p6KdHMGI6xg63mnTOaW8uejJtDjSn6+Xyo61Gae5I+JNQ/ZHowZw8z9G1PBJLDlkF8nrNs+87AoOAAyYv25olRQKbFMMYLvXeP+oiEU/rGyAQyz1Eb/VFeedWrACmDWCcH+3+oJDqaaj/Bq9Oq3jr6IlDHQaZRUEV23ZKhTkHI8g==
Received: from MN2PR02CA0016.namprd02.prod.outlook.com (2603:10b6:208:fc::29)
 by LV3PR12MB9332.namprd12.prod.outlook.com (2603:10b6:408:20f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.18; Fri, 15 Aug
 2025 11:06:54 +0000
Received: from BN3PEPF0000B06F.namprd21.prod.outlook.com
 (2603:10b6:208:fc:cafe::ac) by MN2PR02CA0016.outlook.office365.com
 (2603:10b6:208:fc::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.19 via Frontend Transport; Fri,
 15 Aug 2025 11:06:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN3PEPF0000B06F.mail.protection.outlook.com (10.167.243.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.0 via Frontend Transport; Fri, 15 Aug 2025 11:06:53 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 15 Aug
 2025 04:06:40 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 15 Aug
 2025 04:06:39 -0700
Received: from f42.dev-l-178 (10.127.8.9) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.1544.14 via Frontend Transport; Fri, 15
 Aug 2025 04:06:34 -0700
From: Dragos Tatulea <dtatulea@nvidia.com>
To: <almasrymina@google.com>, <asml.silence@gmail.com>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
	<horms@kernel.org>, Jens Axboe <axboe@kernel.dk>, Saeed Mahameed
	<saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, Mark Bloch
	<mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Andrew Lunn
	<andrew+netdev@lunn.ch>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <cratiu@nvidia.com>,
	<parav@nvidia.com>, Christoph Hellwig <hch@infradead.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<io-uring@vger.kernel.org>, <linux-rdma@vger.kernel.org>
Subject: [RFC net-next v3 0/7] devmem/io_uring: allow more flexibility for ZC DMA devices
Date: Fri, 15 Aug 2025 14:03:41 +0300
Message-ID: <20250815110401.2254214-2-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B06F:EE_|LV3PR12MB9332:EE_
X-MS-Office365-Filtering-Correlation-Id: 03d49424-1ddc-4c8d-751a-08dddbebd79e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|82310400026|36860700013|376014|13003099007|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QoR/jFtMJxJIsk8dnnD4x+8PBu9kTCj25MyfXXR72c5rQrxXKwOoOvvivuF6?=
 =?us-ascii?Q?tMR/+etzSY2cLIfQn+dFCPfNU2iVlMb+Z/P4uf47SPoLMSdM0/OQ7Uc551ng?=
 =?us-ascii?Q?rhyDlnLKBB5quz5Pvv8LWMQHgqT921dvIduIG7yeMY5J3zHewhtoip6qE0Lh?=
 =?us-ascii?Q?vlye5M0H16kY44PT8QwnIZxGUSDE+Cc7MpnsjVsv+RatodKIWsx0DlncW5Bw?=
 =?us-ascii?Q?nbC4LlpMnMFPQ5ek973pVV4y4SndeilHpK/7D72ctXaVuoBxDS1ntpJLA+l6?=
 =?us-ascii?Q?Xl/w3CRAdlPOxBWog1hKTT1zS1isvR5T2OvTigdQdGplSF/1wJyomW2acub5?=
 =?us-ascii?Q?dSZfRou1LlR6q50oeBEXr3YOZORmVYp2MRgm6JiP/BjLgI1Pyh/YIRwf9hJt?=
 =?us-ascii?Q?OJHRbWAM+BJ1EExyw2iwm1P/wb92WZFpGHDz5/OQlJV8X4fyvemCDEsmLHQ3?=
 =?us-ascii?Q?tw5UZNJLnKyCVdKDp7ztALfgxRdc1g5WKzVkbOxeBZe/x9ILXPHjExVQFYWV?=
 =?us-ascii?Q?IcOa1xeIDk/IDZ89JbzcCDIOl0giTFzp+QA+O0oTria5aJb2fRXxN/E7xcSV?=
 =?us-ascii?Q?RtAb9GPYxqQYzhEui2fkIeQJj1Uszb4cTLR6VDF6TEp5cRY8tiVB3fVg82y/?=
 =?us-ascii?Q?ITC6q43mtqsdMpGyyn3PAN1K3v4Q1pfut3tz5E5M5mfJKV3env9d/S+L6Kij?=
 =?us-ascii?Q?rF0QixYESoNNA2Se1L57bjxfPxU64TxmY5wg5qyVe3WLZtPQyLal1IvUM6v6?=
 =?us-ascii?Q?Zm8rFj7HL9QaMs+OKOFrq3Wbl26H99NeGHme5zk2xdnTPnG/UtJWJvvDghS0?=
 =?us-ascii?Q?1JDDGvGBuAazhpQvlVzEfZec0btLLIdBUSphEShnqueHDckzAbDVDtrqEYuD?=
 =?us-ascii?Q?D4B8y6mxS6QcDGQTSowiC+inKjSs8laUXTITomgzYOYuDMIg7evYEmhP8rAS?=
 =?us-ascii?Q?Z3o5ecLYYSSb//PIwcKAr+Ztlz4fOAugdcwj7CFk7Jfa1xZAtVEf2pr8nv+0?=
 =?us-ascii?Q?2kOHl/2Tx3JAV2WLCcxjJQ/0e09+4+hBj/7QpynbCcXj0hQ/xXUMiqlX8cBJ?=
 =?us-ascii?Q?AKTPFRBALUaSi+nd9+0Xdgr1tFICF5bQPQDXtns95uKCYbVNHz+r/bv3IzIL?=
 =?us-ascii?Q?U6OpxR8G194lSnSV5jzuKWaoKVUtt7d9G4plqdNCdetYSzaJ1hQvOqPZfR1u?=
 =?us-ascii?Q?XnzdFcdapEiDxWf8uh35o/7kIjnPaD3VwANgIAfy1za8acPkt8NciDU427Tj?=
 =?us-ascii?Q?52A04ll5AEP9sTaMCpdTxxVdKUEIUtO3+pRQhOrgQ3ptEwggOIB8rs/AWyWS?=
 =?us-ascii?Q?ii/cnxxts5eUK65Dq3Jb2nwJmuwhqUY0fWMcS1nGvgUGiWRHGzSrzTzK+oN1?=
 =?us-ascii?Q?BOGz3HV5FKBCayOyav5KIya/hsCpDMC1jOdvIbFuBbKYzfEXvsjNfnLsSiE7?=
 =?us-ascii?Q?xkGOGgJgDJVtfJCxucszn3T6gL+snB7zRFZaYsr7AnwKb8y6HrxCqm5nkhhH?=
 =?us-ascii?Q?yA27sTHC+v40QP0bBF2PTB0omKkMhHbSG5HFDKxWClKYIu94VQcfb3sAWXVu?=
 =?us-ascii?Q?/ysDO+rxh6K5L/a33nI=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(82310400026)(36860700013)(376014)(13003099007)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 11:06:53.5766
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 03d49424-1ddc-4c8d-751a-08dddbebd79e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B06F.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9332

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
---
Dragos Tatulea (7):
  queue_api: add support for fetching per queue DMA dev
  io_uring/zcrx: add support for custom DMA devices
  net: devmem: get netdev DMA device via new API
  net/mlx5e: add op for getting netdev DMA device
  net: devmem: pull out dma_dev out of net_devmem_bind_dmabuf
  net: devmem: pre-read requested rx queues during bind
  net: devmem: allow binding on rx queues with same MA devices

 .../net/ethernet/mellanox/mlx5/core/en_main.c |  24 ++++
 include/net/netdev_queues.h                   |  20 ++++
 io_uring/zcrx.c                               |   3 +-
 net/core/devmem.c                             |   8 +-
 net/core/devmem.h                             |   2 +
 net/core/netdev-genl.c                        | 113 +++++++++++++-----
 6 files changed, 137 insertions(+), 33 deletions(-)

-- 
2.50.1


