Return-Path: <io-uring+bounces-8974-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 615D3B27ED2
	for <lists+io-uring@lfdr.de>; Fri, 15 Aug 2025 13:07:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A5B941CE6785
	for <lists+io-uring@lfdr.de>; Fri, 15 Aug 2025 11:08:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56F9E284B58;
	Fri, 15 Aug 2025 11:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VFi1poyQ"
X-Original-To: io-uring@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2052.outbound.protection.outlook.com [40.107.95.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77A53009FC;
	Fri, 15 Aug 2025 11:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755256033; cv=fail; b=upnsFITm8ZMpXRUNv4areJnjV9jHk7lOMFpcYWLVWov3u80af3MBZxaLfKyx0TaRmY65gFm/M/ivL4eZxPfCB6zVZSueaiVE/hTxQZ8XQs4aGEtUC4R6lkBSy4mhEnYuAcNiDA5n+GnaNS4/q2rGK+t+NQuzVYKQMKhRDYqVBew=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755256033; c=relaxed/simple;
	bh=Ea2weUBvSqtHmZdSxN7CYxAQ6tjVWDJt6cwFCUSZRTM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ki+Sm+5vjtelASDyUfd6vMAAuAvw0mREFIRD5SGRc3dGahc4Knfj4ObUxZNYyyVqNudjchRh1AZxyw7O/1SyDyiZL4eP2Ti2dMkVEPEHGPQ3/nsad8uVaAPQ3879Eb3+839b+gnq1UGNZKsvvhH47HL9XnCzl28RKMwoYaDv0YA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VFi1poyQ; arc=fail smtp.client-ip=40.107.95.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iDxGbZZ/AXWFmoR3QbMrkE+3wqQTfZIbIL+2+5dBNhqSazKNZ9I5Bap8k+/LX6XhoKVlBZ0F0Mzb7RbZ1esA/zaBgQ4kK6E8pMKgGLLBPdd6IYX1lE0pRsqPR95bk+fbFO0FEEGIF7ExSezLncSoxAAiMWfEWDWv/YDb+u6ojV4Du6P7zPY25wTjGH+UER1SHthJjgSXrknpY5rE+nAMvSzEDQx5E9APbuIobE5Krv0bT5pliZbr9ui4elPb7Va1NrjpVV6kXHHVVIfGaRrCTrVJVTy9NAGib/BrFEvvuz0TiEk+F6QTR9fEC9x5RtVzBbsIz7IYAEGobpgJzqAPxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RpfieKjo6B7PUBVdG6CI7iAQwkTSmihTvDGHw5kdMys=;
 b=a6XcqrDa7texCY9huEnHTpgloeU70f9pgRBI/pLEZ7mjn5ynmAB9tiJWMEfNqhqNt4l8srYBkDcTKitgu7gW62Ux+CKuPFZ83u548oLCLXxAkkzgCcv5nUUxQIG4FxR0Us8efLRcR/o3OpfNjgG9PK//QyZsE3LRmzqOmwoCnQ3Kdk8q1QysnQIYNMI7S2HFaO24vpTc2UXJnQPLBZgzlfxs3KZBqE/MYsRJT6LDaDE/gDdWqAX+Sf06Uh82IF1x0V4aXeZhU6v9d513C70m7w03ri0/Zgmr4an6RXPye7H3gxGepVWdXOTvEUwD/qd3ChnxggW7NZOnNIWbu5gTRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RpfieKjo6B7PUBVdG6CI7iAQwkTSmihTvDGHw5kdMys=;
 b=VFi1poyQif4HzBvrnxUgGIMyToxeoPGImiRR/XidCNWnUwZnGd2Cct/ubU1YfIRTBdwljEFyPGeUC4wehCia/oiPGNSwGRFjXQPwQIKJNeVQVDr1zs3bGiZOFsKLhmaDHAxV7erUCV/ngBAbM+rDqIBdVSgwvaL9kWteXIkYPQXKQjKp/qfiq7Pyogxic8GARqr/wd7roDKeeRJW14Rvypyowo7XCh174uP6vAx7WWCBWpdlXAhmYhyE3e70Xh7WVzuxxj/koORo0P2HZoM4bI0Q/OVDHVtLajWtThU2tY8rUdcQFuXGVdpwSURzGbvAv/vGcF3Uktkuai31t5tKkw==
Received: from MN2PR02CA0002.namprd02.prod.outlook.com (2603:10b6:208:fc::15)
 by IA0PPF002462CFE.namprd12.prod.outlook.com (2603:10b6:20f:fc04::bc4) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.35; Fri, 15 Aug
 2025 11:07:03 +0000
Received: from BN3PEPF0000B06F.namprd21.prod.outlook.com
 (2603:10b6:208:fc:cafe::d2) by MN2PR02CA0002.outlook.office365.com
 (2603:10b6:208:fc::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.19 via Frontend Transport; Fri,
 15 Aug 2025 11:07:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN3PEPF0000B06F.mail.protection.outlook.com (10.167.243.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.0 via Frontend Transport; Fri, 15 Aug 2025 11:07:03 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 15 Aug
 2025 04:06:51 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 15 Aug
 2025 04:06:51 -0700
Received: from f42.dev-l-178 (10.127.8.9) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.1544.14 via Frontend Transport; Fri, 15
 Aug 2025 04:06:48 -0700
From: Dragos Tatulea <dtatulea@nvidia.com>
To: <almasrymina@google.com>, <asml.silence@gmail.com>, Jens Axboe
	<axboe@kernel.dk>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <cratiu@nvidia.com>,
	<tariqt@nvidia.com>, <parav@nvidia.com>, Christoph Hellwig
	<hch@infradead.org>, <io-uring@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [RFC net-next v3 2/7] io_uring/zcrx: add support for custom DMA devices
Date: Fri, 15 Aug 2025 14:03:43 +0300
Message-ID: <20250815110401.2254214-4-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250815110401.2254214-2-dtatulea@nvidia.com>
References: <20250815110401.2254214-2-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B06F:EE_|IA0PPF002462CFE:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f336f0d-d929-47a1-4823-08dddbebdd7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4Lhc3BCT6sqGlfBSKGWkEzK0Wy4giIWH6aJBpeBpffB9iQnHzIimzZCFkWCq?=
 =?us-ascii?Q?GrC1Xvlp5WAHxQvb8Mwi1AcbF02gwqDWov+23oeDFpn4DHrUZZOCyZJLr1Q8?=
 =?us-ascii?Q?XQzg4P5/GdRgR+bVKH6crngFt8TMd8fvn7y88oVppVi6qi0PlnGk/TAXiQpC?=
 =?us-ascii?Q?BP47GL6XXfBmidU9xS5R0ij/eO7Mfe3ttdO/wOnzLiMQcJp1Hnq6Fhftrxvs?=
 =?us-ascii?Q?k8LlXBPxtkz/0DS2VAFf+fhxkTGGW8JdYXHPdMQNCtsY9CpPAZl4ujmq9vZ1?=
 =?us-ascii?Q?jgt2pHoOWZb+dFk9TGB191A9fMaiH4M+VNp+Jc1qPwWTdx6Nj7eb4wKasoij?=
 =?us-ascii?Q?qWOGp2h35kzpxU6uNCO9EGrLzygfUR635FZfnrJaviUODBF123q5eTKpUwPf?=
 =?us-ascii?Q?Uv26/Zf/BrA+wenM0eaUg8vx0+TuiCaDgIYC7g0DsXKN7lJhv/AvOV0McGUh?=
 =?us-ascii?Q?k0C+9umGqcj7XGB63UeyCDFW/pJlIU2xGsVirdd/ps59EPNdZRPn3rhIzG7c?=
 =?us-ascii?Q?FO5U3n4rvvbi9guEGrUAhfrioltg4sxeD/dRGHLEbQoylpK9cR5KCV29VyOU?=
 =?us-ascii?Q?gamW3eNujJ0aReI8uImcrT8o4urrBw1sR0ECvM8NsWX8V0p5sSrsWi5lVKil?=
 =?us-ascii?Q?AJM8/NJUTVCKkkrXuBakjeok7ZgtuTM3LU5w495nEga15j1+L4DoAV+htBpy?=
 =?us-ascii?Q?zxQujyhi3BwT9Stzqk2BRioIJdiJFilc8tCDERP/9EtiB47KuRyADofHFtp5?=
 =?us-ascii?Q?auda0US4wOcIqM2qbIMjj6dchtQuGfnHRE29x2Jpx8agYwmCSjnousvcOdr2?=
 =?us-ascii?Q?eYDWA5+3sPKj/+9zWYplWj/hNrfih71hniQ7HZK+yCdzuMTm/y0GwJmGYfHS?=
 =?us-ascii?Q?01Bj8qiAF4b4nFnXVsv8QTCJLg/061G4GlYpEX1RmTAOretg/Of3UnbD3WiD?=
 =?us-ascii?Q?nJ+x4XQLwBJKh+YsSotSVDNdw2MY98Tt0Ufw6wyvnzw9qYRUwXll5pqNqATe?=
 =?us-ascii?Q?R8sMhE1j6wm9TFmePFgmStSO9QWXwNCo+mvAt9p6mxxqGPXX/KquLyuMVKdI?=
 =?us-ascii?Q?6jjvv+whhedRJoOYu9thJNiu8O8BZ9YXSZE3ixTArg2u1AMD0GMabu5PCF3W?=
 =?us-ascii?Q?h827JtdH0KTWf6g1VBfUwHOHX5beY/qmX9Di3sW+cA36Rn9Y8xFfcJhJSVzf?=
 =?us-ascii?Q?52fd2WXLvJZT2vfRbpyZ+QTFRqFLPMaFBsz7h2XNMEAYk/KjnsNWs14okLIa?=
 =?us-ascii?Q?PczH5bi38BTZ63bBKuHiT0qqAltilT3x2lfxd6vMJivjaenr2vmUK426Kk2S?=
 =?us-ascii?Q?/yPLq81YICKnncdZXCwFNwEXtGJ37upbg0CH1AwiB6HtcMM7b62UO3FqCpxA?=
 =?us-ascii?Q?j04sRCV/9pBbQhEu+W3Gbs73Hyc2?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 11:07:03.4573
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f336f0d-d929-47a1-4823-08dddbebdd7e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B06F.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPF002462CFE

Use the new API for getting a DMA device for a specific netdev queue.

This patch will allow io_uring zero-copy rx to work with devices
where the DMA device is not stored in the parent device. mlx5 SFs
are an example of such a device.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
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


