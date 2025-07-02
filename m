Return-Path: <io-uring+bounces-8582-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3A1DAF5FF2
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 19:27:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 774D83BDBA0
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 17:26:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01CB8253351;
	Wed,  2 Jul 2025 17:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OBE855KH"
X-Original-To: io-uring@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2052.outbound.protection.outlook.com [40.107.223.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7C1664C6;
	Wed,  2 Jul 2025 17:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751477226; cv=fail; b=N+zXp27ll6CCb+s54jp7/d4kSRRcgESnO5/Vx6BttrnJ/GpcfLRLrV+JqkJLU9S3ZFcGmB4vjdZXZeyrIUJny4fUjoP0yRDZl4gEUTDth4iD6bjuuuX6tf6zfRGo+yj12hMx54fp+C0C8fd2lAVAFTb5vFR2gpoaV47oN8DpMrc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751477226; c=relaxed/simple;
	bh=Uj0/keuQaTQG0MCuK9lX8Ug3HyLCW38J8FAKxI6n/eE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Q5wF2RcVzPhNRvjhSMuxnI/+Sdxm4Eq0b9Znmmf2RYIjklBIFSIoIkRo8p4taP72PyJmQrB862bcU2ljG+WvAUos9JESIKvHr86z2njUbCfQw7qOM57dnrarZQ3GNttRb1I/mgSMble1N2dhFnytywYXSTdWvEuzOqq5Fbk9EjE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OBE855KH; arc=fail smtp.client-ip=40.107.223.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QxgUmTmuw6cpHPF4NtZIJi1uBT4l5QOA2PEpVd7dg7VHCvmzi7RUsyKn2az0SkutO4SB66nKYkf3aGKwictEy7BSp01nsGl+KubjznQDLXG3fXANs7p1MjM09hrwEWzbH3Mcizl9kxp52DITWsYJHWHZXqSH3m7eUxhThVeHk7XqULTIIsuNo0Up/NOyUrdVocQwMS1/woUwevLfSIPdnTDtRGECjNdSObF5ahvIexex3LWdEvdxbZSKDOmEnwJbth0IHJf1Wfp28NdL2yoLsb/N6mJOBH9dsaW1e8KD8/WTOaap7TvhGTyoLE6pYPT8MyWMF+nZccfzb+7iURsTOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dFWLzwxF+We65ejBgKtQ0ZK/Qzwfr+EZYdOVC3SRBwg=;
 b=G8E2FJEB7n1/CXirsPj/Nb/NT8SHzK0qOEEc311yBD3lA8482LJvSlinE0VCbV/saYyCLaRRTmJzw7db1b6pBOZ8rDCHAO/FIt2vvH/yf/6c0LcseG/dzZBj5EDPrxsSaSTtg0i40nLtEwKjDf0OOM5bCU691KjfKlpVTPJbg+GsVGanTOzmqVZ0UmfKhjPD8v508AuseGIgAnZ2kCCHEB9Lw4RxapI11XfAnO3PkM4JlqLZkfyzBqjRMKqgAOTpkUqtavjO/Qb2eGFylsye23PgrngQxDOZ75q0uPZQsdFWfvK88gv29VEMqIY+e4VYq3r9RY++sPHk/7Nt7Ux4eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dFWLzwxF+We65ejBgKtQ0ZK/Qzwfr+EZYdOVC3SRBwg=;
 b=OBE855KHx1auLjxQrnC1OhqadVvuJW7RkaBHZyJbC8jov7bTuBb3FBCY4vgAfPtT+88sPp2lU9ty8j/WAjuc3CHHQnUCOhug+rUtPdoyPYpK1K1Q0Btej773jOvo4Mou6Jn3Tw2o2PB3P4eoOuvzOn40UOMfleQujZ/EJXCx0cvZ768lFoItmlrV4kPoOaFFzabhqLaQBsfm/QS28NpymvJiamP231apwwLHthD7JAhw9STPn29NaZoyYUZEZQqpCDI152voFWh4MTozgxVoAQONwNoV01tzbSN4GKq294R2NBDN5ABvh8c0SnxHJTikdL4WOOM7Yu3oN1RYqTEz2Q==
Received: from BN0PR04CA0173.namprd04.prod.outlook.com (2603:10b6:408:eb::28)
 by SN7PR12MB7321.namprd12.prod.outlook.com (2603:10b6:806:298::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.29; Wed, 2 Jul
 2025 17:27:03 +0000
Received: from BN1PEPF00004681.namprd03.prod.outlook.com
 (2603:10b6:408:eb:cafe::56) by BN0PR04CA0173.outlook.office365.com
 (2603:10b6:408:eb::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8901.20 via Frontend Transport; Wed,
 2 Jul 2025 17:27:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN1PEPF00004681.mail.protection.outlook.com (10.167.243.87) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8901.15 via Frontend Transport; Wed, 2 Jul 2025 17:27:02 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 2 Jul 2025
 10:26:40 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 2 Jul
 2025 10:26:39 -0700
Received: from f42.dev-l-178 (10.127.8.9) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.1544.14 via Frontend Transport; Wed, 2 Jul
 2025 10:26:35 -0700
From: Dragos Tatulea <dtatulea@nvidia.com>
To: <almasrymina@google.com>, <asml.silence@gmail.com>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
	<horms@kernel.org>, Andrew Lunn <andrew+netdev@lunn.ch>, Jens Axboe
	<axboe@kernel.dk>, Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>, Leon Romanovsky <leon@kernel.org>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <cratiu@nvidia.com>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<io-uring@vger.kernel.org>, <linux-rdma@vger.kernel.org>
Subject: [RFC net-next 0/4] devmem/io_uring: Allow devices without parent PCI device
Date: Wed, 2 Jul 2025 20:24:22 +0300
Message-ID: <20250702172433.1738947-1-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00004681:EE_|SN7PR12MB7321:EE_
X-MS-Office365-Filtering-Correlation-Id: cf1e31ab-d63e-4769-b5b1-08ddb98da8c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|82310400026|376014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dgmnHkGxar6wFWnBYRzf66OmjIoUWc4UbjXkhGU80vHCToq5q9rOe345PJ8u?=
 =?us-ascii?Q?lLEMDayIxqyQe/t3BvEqN0szY0DNAFZMYDXlKBIcZegON1pexPqda3HZnSK4?=
 =?us-ascii?Q?6X5MKRfC7sD6tZnZLLcqNUGOiiN/9UwCSzgMhJBwziSdo5wATjc+DBbjRM57?=
 =?us-ascii?Q?UrOzMKjo+QyZ3z92kOCcBWdt/wpTr585KuRp9hQIznI7w+uKqhbmMpmQcX5k?=
 =?us-ascii?Q?H7itBfNJ68ZUFxfK/beP8MUszlYRplsy7R+hG1/obz3G7wyKuQkGY8D46fid?=
 =?us-ascii?Q?zy+9jO/l98iHat/gDfLW5rTTAcOtD2nFcf5s/OwexKKcfn1G63HWWSVsPHC3?=
 =?us-ascii?Q?P0XO1cXAzWNOIPy5SUjCo361sCgfbceoucZgy/+lfEcrcVG/zjU2JbCiTSGf?=
 =?us-ascii?Q?tE5n16PfA2QRatK7GpPLa3DdxEbxAf5iEVlj+vS0U8CUeMxIw3ejZoBOuk1f?=
 =?us-ascii?Q?xZnUirShlI7J2EfwJ6b1hNMMuyullqw06unFVIxuYIUGvixRnjp1cHEJl2lK?=
 =?us-ascii?Q?WVzyV2kl3qziB2GdMiSdxL52ZgBLFt8RJMSB+OCgy8TOfFN2h5PFrINUt1ml?=
 =?us-ascii?Q?RJOmAe67CoytG28MAIw9S3mRzyMyHy+qlaIzraUbA/EIA0ml76Es46jgo6JC?=
 =?us-ascii?Q?Bns6koahiO2D6LP9BjIXddnYfJh9GvpS14nDYsLu6WNPYXsuBXwSFHO+7A0r?=
 =?us-ascii?Q?fXM923CjngAZ/dP01/oYsGm96GbfaWVPEP4/DU2ELBblPrRaOVjvo7ok7E80?=
 =?us-ascii?Q?GaHEPBSiw+k+PMpcOJ38t15ZM3yXMv0LcESdJwV3OvK5fu2IrDBZh78+vGsH?=
 =?us-ascii?Q?9ZOc6c5wjYCUAD3d8/ChRD/xL3UpYWXra/YNZ0LQqE4eBpiRDjb9+YJqFv44?=
 =?us-ascii?Q?bh8x1X4JEzE8EZ5dBVq0JZArphYiXuuf871QGLod9MYt1ihSngDZ08T0SYTd?=
 =?us-ascii?Q?Xw8Lx4hh1zt8rPn3FZJuBk31sM/Gozzgj7aY3HwB8zAdVHNIRG/myisQnJ8R?=
 =?us-ascii?Q?fXHWXD+dLCJAx20ACvYKMnpk8XHKpoQfa3C9+qPukRLl/X7HRgXJ9YD86Vtu?=
 =?us-ascii?Q?DIVUgaPI+aFIfy6nkcf7hLSaIFCOkG1ckbQ5x4I6dgScORiDO94Am8/CYSl/?=
 =?us-ascii?Q?Y3VtMlFPuCMauGVL7mBUPMI43mPcI+kmycaz9mtWHCu1icO3VRRNrjVSGrMs?=
 =?us-ascii?Q?FiihHN4oiaFPNAAb7av1UjIOo+IyPsv/Ur2U9CCFusau/YH3t1XmFecMPA7x?=
 =?us-ascii?Q?D/15WxllgTt5UQDNUSrYDqDmwYPDN5qnyrLKzgeyS62VC0ACtVTzfcqts/Gk?=
 =?us-ascii?Q?2/zwSXJ2atHsbSyKzaggDLRUDFgCjX1OyI0ftGWeWL/+5z0Pv/4Vgm7S9DwV?=
 =?us-ascii?Q?6FlxJKuLdaCx1kBxxwCDw7qXoYZBl5tlGFjssRS/CjWiHzQ3Yw+q9TTvCSHt?=
 =?us-ascii?Q?DdCXM+3TdctcdMQBP4XoR+TxPDwwkRjAXMRRWjLQLr1F4Nuq7VlZcFndYsfx?=
 =?us-ascii?Q?sjfAa6iwIA2DDUN9wpSxjPQijJE3IGDqrqnc+VpN6yV5fl9USLmKa2gPPg?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(82310400026)(376014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2025 17:27:02.7960
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cf1e31ab-d63e-4769-b5b1-08ddb98da8c9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004681.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7321

The io_uring and devmem code is assuming that the parent device of the
netdev is a DMA capable device. This is not always the case.

Some devices do have a DMA capable device that can be used, but not as
parent: mlx5 SFs have an auxdev as parent, but they do have an
associated PCI device.

Also, if DMA is not supported the operation should be blocked. Otherwise
the mapping will return success with 0 mapped entries and the caller
will consider the mapping as succesful.

This RFC is supposed to start the discussion on the best way to:
- Block the binding operation early if not supported.
- Allow devices that support this usecase but don't have a
  parent device as a PCI device.

Dragos Tatulea (4):
  net: Allow non parent devices to be used for ZC DMA
  io_uring/zcrx: Use the new netdev_get_dma_dev() API
  net: devmem: Use the new netdev_get_dma_dev() API
  net/mlx5e: Enable HDS zerocopy flows for SFs

 drivers/net/ethernet/mellanox/mlx5/core/en_main.c |  3 +++
 include/linux/netdevice.h                         | 13 +++++++++++++
 io_uring/zcrx.c                                   |  2 +-
 net/core/devmem.c                                 | 10 +++++++++-
 4 files changed, 26 insertions(+), 2 deletions(-)

-- 
2.50.0


