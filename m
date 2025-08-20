Return-Path: <io-uring+bounces-9108-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 05C4DB2E315
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 19:13:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 90A1A1C485FF
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 17:14:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02FB433472D;
	Wed, 20 Aug 2025 17:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pBKx8A6G"
X-Original-To: io-uring@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2062.outbound.protection.outlook.com [40.107.243.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1C52D372A;
	Wed, 20 Aug 2025 17:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755710021; cv=fail; b=es3JLkAR7x4mYSvLBgZSiklm/eZIq4r89DtGdNL0D/d9BPjVEg/6wV5+jg12pJdGP147/W7Bke/m0INHO2so4vAvQFahfivUBY/OP2sF9NF3BpVRO6cBsk4AqS28Ad2I0y1yKEpZtyc//a/uI1OY8ng9yWoQe6G/+aYinpvehFU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755710021; c=relaxed/simple;
	bh=7sE82rgasi2yPuvU1rsdtQH1IQJkeR8OJtIAhzLfMgo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fcX/GJ4tlVUA9HYcSXh0v9XUuB35Knvf5/0BdlWOpMcTaY3EpYifTziiXVINjSlYJKhFc1okNFNoVgU1Mpqz289N65pWsOSZUAJkwpRSeV77W5Yf9erFBcWhch6HLoKVbm8w21OEHQwRHB7x0vkvA7eaadK0qYaAYlFYMQhynRk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pBKx8A6G; arc=fail smtp.client-ip=40.107.243.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jF0W96IW2ZE4mxnEgS6QYUsJsZFoAOGT3yPPF5V2dSiay6w59bDhbm2Tn6oFtFsH5dj7Gk9gcKfQkJD/t1SupmNcZIWrSFG242W+sQjZHXMdVC4wlmSoKWZZSZ5D7GFthHvLqyAeKw4kuxRX2WU4JbKUNu2XIulb8rqLcmPggRDaADza4KA3jK3Xm1EHXIMQUEck2Gdn6lcZc1bKwvhWYFOLwb3bUJSXgkWgMq2k9lrWXNZPP1zigsMMBgDUsslyeXyss/WNr8e6f1IZ2bb6u8el4uC6NuKwLjdutYY5YNL4mrV1qvTBCEi/SacfiokCOOtI1/6BlT3wNgN4Ad1rzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XCXAoHFjFpaYyctbDX9Ip6+s8P/F2xUVdQyD2rhmQ70=;
 b=nufp6Q7yTHT3ZQrTtV3St1qoJD4VcN4ax4oVoLe+dDat58Vua21jSDkWYav2BqAXxHOb/IncIPVLR6CQeCpTlsmejBcdknuHpAZQQ2HM628ZrqOQTyxT/BbeFJuo/c/XX4hsH9glHMaEAYc7yG9kW/jVooG1bG6M1mUdJP79DwJl4o5qnF3KH+O16K1NNSJcHnhQa3c1MobyBHdLzc3cpS/66D/caX+ysAYbS8rNrpErYFHdsCHf6Vu8psu/czH5TYaFrOkJmoGuHJF6L0rzDJtMDXiNqWq4De6blYDh5KNYfZNaJXfN5rbwalXYlqi8IT4w7z+j0O/CqCSi9Nh/YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XCXAoHFjFpaYyctbDX9Ip6+s8P/F2xUVdQyD2rhmQ70=;
 b=pBKx8A6GmWL7ipGKPSgpduI4rS1E6CHVCeYcHXa8vV8N+n2YGUR6B2MXxrOod9fDgx8fcT0RoS1WJKKFofsLcRbTxii602+6qBfLHZz8uAX82e9wO+7J8lw6HbmF3t4wFSpmyqfPBhDG5oIOeQWo+3vTmID6zOPnZ928/t1VXyZJetLO17AV1UMpZssEY+oyVtbdo4ZeD1U5DLa2tsXH/BZsIrtNTB9SA6UJuGCno6gCsxV9BNZKqQ84TXr21Ycjj7vIH8XT5CY9T/ckziWo958IOOGlnqBPT3eijOa98F01S/j2aHc81whV7ZjfsvefOsQTd3UJGpsMiRmokKGp2g==
Received: from CH2PR08CA0018.namprd08.prod.outlook.com (2603:10b6:610:5a::28)
 by SJ2PR12MB8033.namprd12.prod.outlook.com (2603:10b6:a03:4c7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Wed, 20 Aug
 2025 17:13:35 +0000
Received: from CH1PEPF0000AD75.namprd04.prod.outlook.com
 (2603:10b6:610:5a:cafe::2e) by CH2PR08CA0018.outlook.office365.com
 (2603:10b6:610:5a::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.14 via Frontend Transport; Wed,
 20 Aug 2025 17:13:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH1PEPF0000AD75.mail.protection.outlook.com (10.167.244.54) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.8 via Frontend Transport; Wed, 20 Aug 2025 17:13:34 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 20 Aug
 2025 10:13:09 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 20 Aug
 2025 10:13:09 -0700
Received: from f42.dev-l-178 (10.127.8.9) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.1544.14 via Frontend Transport; Wed, 20
 Aug 2025 10:13:06 -0700
From: Dragos Tatulea <dtatulea@nvidia.com>
To: <almasrymina@google.com>, <asml.silence@gmail.com>, Jens Axboe
	<axboe@kernel.dk>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <cratiu@nvidia.com>,
	<parav@nvidia.com>, <netdev@vger.kernel.org>, <sdf@meta.com>,
	<io-uring@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v4 2/7] io_uring/zcrx: add support for custom DMA devices
Date: Wed, 20 Aug 2025 20:11:53 +0300
Message-ID: <20250820171214.3597901-4-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250820171214.3597901-1-dtatulea@nvidia.com>
References: <20250820171214.3597901-1-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD75:EE_|SJ2PR12MB8033:EE_
X-MS-Office365-Filtering-Correlation-Id: 410d77b1-bdc9-40c5-2320-08dde00ce531
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|1800799024|82310400026|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8x3tiOQrTxD0sQmxtQZgYjj7ouaiG0DgLdRIx15u9CZcRzBYN/1Y3K1vSckc?=
 =?us-ascii?Q?0U3yDdBZlmwwiHFMpc12cbb95Uyo64SKqIC+9GiyX/287BFI8zEBxohC/gsY?=
 =?us-ascii?Q?4GhwzBxowLSfaLvB8nXrDHLFwNhmdDow4Z01L5LyRnOt72dAFC/lJV5zaxjw?=
 =?us-ascii?Q?L4veFg5Miz5LGgV+pKq1WJR5SQX8oElMa1BdI8G6BdA4L3577IKR+Zi9aqxF?=
 =?us-ascii?Q?iwa4PCGJbR3qPpT+NTc0tvjra77O+aXIrzxS7eYqy9gV6KV9gSYFSfUMdX2v?=
 =?us-ascii?Q?txntVfM9gsZPx+Gu5S2G7HXy4lcMcRvnZkwLR3YBLcbQKE0GA1IJ//UDIzdr?=
 =?us-ascii?Q?txfVDwz4w0Pj5bvssOzNNsoybCZ0QUHORj8ctiYoaQXqT38quzOZ2zCZHJBd?=
 =?us-ascii?Q?1zn73KV/GFI9/FMZONKc4Ij4SW0bwMnWFwxb/JMQFyyunKS+CPZIIbxc0BFr?=
 =?us-ascii?Q?/oJB9XXDFB0x6ZRNJglzZNtnZsd+Pb784JqDzAA3/HDtTr/KgcPKaGtmebI/?=
 =?us-ascii?Q?aeKjHVTl8ap9kmtOAsZXEequi5KD5viFmT0JAev24L2TSYpWuSSnJcSVCi13?=
 =?us-ascii?Q?Jqlr1ujov45dD+wCxPwrqxRW8qKp+pZ4ZJqLugtGKPIIkKhz63jArpqSIaza?=
 =?us-ascii?Q?oMupoZbCKHCSmVnurVUdh9SB0/HdnwW2uVkFNUoY7owuMQFj6KL6AJOrfFhS?=
 =?us-ascii?Q?7YzMkJwLuXQBsM1+Cu0Ak/yggEO/ID6rgZPg4h7MCK7ZUegNj4PdbPhAoOON?=
 =?us-ascii?Q?eWnjo2qZe0z2c0RkkH6/uJswLZQISrHlr84T3sUovYORrlp38EJ7ukbfLG+p?=
 =?us-ascii?Q?2gNvRZc2VBSBQkLmFU1ZcOlpgXCMrAEJSzKuNPatjVPTkmR9S8pEPVlw+owX?=
 =?us-ascii?Q?eOs9y5Y8RNkggxdsD4oSimnKQcEOLHdmyyFQyADYW9SXui/x7X2CWNyxSABG?=
 =?us-ascii?Q?E/AKGW9Egwdt0xzX8gXpdF1ActoMg2Gr1OyIIZHXqrFRnItcf9jCJme0XJsI?=
 =?us-ascii?Q?Z0wX+QPyb+Kv5HbQh0g0UHdzrIyNOsVaMQmMTUOzqNuSdEczIKJR1fwdSzUA?=
 =?us-ascii?Q?DaaqLj/ZhDXh/hs48kIr++rBm1R8IRbT6a1jCSecVyhzmBUrfUp1pB/7ySop?=
 =?us-ascii?Q?8f+gQWwRTQaOWen7fsNowGtaxf6/R79e8nHbquVTuMNfktTtf9d/yqNgzx+7?=
 =?us-ascii?Q?pk1FPCjQPx4vSqVj2pS48/7wzD4HfkenNrWyBYnVbpSrm8UxJKKSIBAFKSWM?=
 =?us-ascii?Q?//Jzm0Xad9BvTuh9NGFlctwUuTR0jhpTo5pW2dtoHyKME25MD5XIflr3/EWK?=
 =?us-ascii?Q?dc7Di2W0wGvZPXe2wkuEuf81/IHrrlRPWKhaIghUqtm5Z34nFXheOSp62tq4?=
 =?us-ascii?Q?rRSJtc4yknA83c5d46n7ro3D0MlUtOhO4fPEjKUVkZsAc83+FD8FFXtG9OYy?=
 =?us-ascii?Q?YVN5/okhIU9BrOMp/tpPO1xe8mTTWedIKl4t0pvzjrNWPK8ZHZZ4TaFIAcjw?=
 =?us-ascii?Q?t2Dk5n2q2/UUMr98zI87nnGbMYVXmYfrN/3N?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(1800799024)(82310400026)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 17:13:34.4108
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 410d77b1-bdc9-40c5-2320-08dde00ce531
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD75.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8033

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


