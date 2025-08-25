Return-Path: <io-uring+bounces-9278-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D80E4B33685
	for <lists+io-uring@lfdr.de>; Mon, 25 Aug 2025 08:38:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 19B752009F3
	for <lists+io-uring@lfdr.de>; Mon, 25 Aug 2025 06:38:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCB31284B36;
	Mon, 25 Aug 2025 06:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="I4LnNiLr"
X-Original-To: io-uring@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2063.outbound.protection.outlook.com [40.107.94.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28209283FFA;
	Mon, 25 Aug 2025 06:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756103870; cv=fail; b=lMMJgfRZTNjGIIJ/oL1mumPeCpk7F9io8QOzcM0IlB0e4F3t5Ljmha6vdV87dSb5wLTyV9CF6OOBj+Gjrc9MPQyyoZ7WoErZv9cBRPAxLkN8mxnm31RARWpkpuZNiJAq9xel8Sgn5bkpp8u3lEA4EQRVG0cyOPyvEO3FmUxqqOo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756103870; c=relaxed/simple;
	bh=7sE82rgasi2yPuvU1rsdtQH1IQJkeR8OJtIAhzLfMgo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cSQzZHCw4ayzZSJQzfokDIfYsm5R+pGuWVR2Rte/VBiokZl/CONWulOLFJaIKBh+WeVwSJLe0qXBhpZQvmginCichU22piaEQSTDzyZgqiwxh+8PlmnWm9ZFHxqlJS5dzn2m9Yaduj6irlg9Aqf35E+7SsqCd8lTyjfk2NKCH6o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=I4LnNiLr; arc=fail smtp.client-ip=40.107.94.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wKvoUU1instsH6Pl9c91pi6dRZrQPUlbbL6gLJ0LRXWv8pLuDGguzBtVDEmM/wpOPsYG0IMIV3nTjbcbYqQh7PuWnhwiNjQE9r2ThBglHyMbOJofoo/t+W8Xq/FcRH+5uoG+koLVxAi//kHC79UFpL4J4gx7tCwDmbUqGxXoiE0fx6bSH/wJTdLj8s/EPCuHd840VxLwR6cNO349UbCychrsoECX6gAqpBL6yqKk9KiaKOwrIdGvT8QLzE6/dKeXbwp6rMsfLcIZzy3qsa6hgSl/mNOtxRpe2XHgWPiSryzdpFK8UmT88e/8JK1dYTRKQjwcCh+WZJe2k5ulMvGuEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XCXAoHFjFpaYyctbDX9Ip6+s8P/F2xUVdQyD2rhmQ70=;
 b=VSG1p1IkUVt6J73OKu9HZfksYXoMEQE5z6kZXSFMK5btb3c9C5LqrBnZ5n++g1/7d3Be6Ax0Vj55PD3uq3Yq1bin/afKUcekY8stCmiV57zVpdwqttpaeMH6yD53/chfgVqqVx55XA3MMOLxcmSuQ84KuTGpxtVG4ptfpB9A7D+VWkX5U/dDfTy24F13EL73Xxb+NBULdOkyb2ypHHnLtnthm6+4RvlZ1DuVAQoZbNPlh1nOJeDmfo9slixqEnR4gUjCnlmoZc/ZibQGpgS+VSSzpqlZ7Y4D3ZCN1ajeCi+56a1aG75Rx5vmCQvrvMTXnp8GE2FWsW6COt1IemQgLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XCXAoHFjFpaYyctbDX9Ip6+s8P/F2xUVdQyD2rhmQ70=;
 b=I4LnNiLrdf3MjHQlLHEfqOP3e/TBjNNzctdcRzvfVFtJc2CMm6NJwlgROKYN7TYbMp39q4NxbtLaAUkFjDVRlT9hm3MVYJehf6QHeSxX/K6JQ9vPJVMQN5SCHavdoofH657e+y3o758jNSQ71L+DezAEo0TjlDo77GKcSThV6tRI44gFUWarm2pvQEDBpAUvKf83nRct/zLiE4NFNRXUwOvfUN+8XpPaiEgp8MVBnmjyppSSa8xmoXG/LH1WaswxcGSKZvefm1/SD6PRfPL4+sYHX/S+MWS1wRY0B4Z2q1Ed0ZDD55f3rWM4zbU8wn0j4dpbDYcfJqUrdvRdbv6SDw==
Received: from BY5PR16CA0023.namprd16.prod.outlook.com (2603:10b6:a03:1a0::36)
 by DS0PR12MB7946.namprd12.prod.outlook.com (2603:10b6:8:151::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Mon, 25 Aug
 2025 06:37:46 +0000
Received: from SJ5PEPF000001CA.namprd05.prod.outlook.com
 (2603:10b6:a03:1a0:cafe::ca) by BY5PR16CA0023.outlook.office365.com
 (2603:10b6:a03:1a0::36) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.21 via Frontend Transport; Mon,
 25 Aug 2025 06:37:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001CA.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9073.11 via Frontend Transport; Mon, 25 Aug 2025 06:37:46 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Sun, 24 Aug
 2025 23:37:28 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Sun, 24 Aug
 2025 23:37:28 -0700
Received: from f42.dev-l-178 (10.127.8.9) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.1544.14 via Frontend Transport; Sun, 24
 Aug 2025 23:37:25 -0700
From: Dragos Tatulea <dtatulea@nvidia.com>
To: <almasrymina@google.com>, <asml.silence@gmail.com>, Jens Axboe
	<axboe@kernel.dk>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <cratiu@nvidia.com>,
	<parav@nvidia.com>, <netdev@vger.kernel.org>, <sdf@meta.com>,
	<io-uring@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v5 2/7] io_uring/zcrx: add support for custom DMA devices
Date: Mon, 25 Aug 2025 09:36:34 +0300
Message-ID: <20250825063655.583454-3-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250825063655.583454-1-dtatulea@nvidia.com>
References: <20250825063655.583454-1-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CA:EE_|DS0PR12MB7946:EE_
X-MS-Office365-Filtering-Correlation-Id: dc13217c-4794-4cbc-4791-08dde3a1e731
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?S/ZnrN7SnfBXkgQZ2JB6qlBk4Iu7iJgZlsV+iLTPhE+7ja09jj+bYjs97Ga/?=
 =?us-ascii?Q?j7bN+bf4qBQai8MYTILRH3EjftuTcLLDntda1f2o9MSIYfDRkLiZ/toFf7fq?=
 =?us-ascii?Q?9VlxjSWWD857ynO7YyFnN2QH6LDC4we18d1sWRK5Y9j+af3T40h/2dklACw4?=
 =?us-ascii?Q?LDu/6Pj31UWdNtBnPWFO5fTg3Sq7hNnrLHPJApmRIVpiOqEc1XKWiJmFhyBJ?=
 =?us-ascii?Q?XaSa+yR1pVzga3LdOCi0Jw9seLwlzQ341C9vBPxF1yciWi58g89kfdpnpryy?=
 =?us-ascii?Q?Hc76t6ATzMASKElIbif5WKJuUFSokCPc19AIe9cyVi47g9PkDnbxf0DNsDBo?=
 =?us-ascii?Q?mssNkXkrnmU0J8NrSJHIJuBONAqKSl3wQ7a1qnZj/XAWXsX59xMgPIczuWsf?=
 =?us-ascii?Q?wySD15Bn46faX0bchlHxs9hkcQYpauwgWarSVL1gH9zjsklCQwUuaKTLS9sd?=
 =?us-ascii?Q?wj6y2aUfe/7fVZkN1eApGzAeiuxR+VQ+OVjkl9kLkik8HqZPHUh5W3EUU5Vx?=
 =?us-ascii?Q?zMfDwQU1rLetNHKBEW9gKfF8Z3ePE5hu8V3VCHTTPtS0ZuQEUXC9HLunANW5?=
 =?us-ascii?Q?pgviE47nsNcBe+VBwEk58QnJAx5cj2qx5L+WC3+WGOSjTssAB+xgypVdxb2V?=
 =?us-ascii?Q?LDYwpLNAu+UzKSvTV3rYSgvgNCkMCrJ0hF9w8xjcDJh0Ni+oeDsiH2sTz+NP?=
 =?us-ascii?Q?Axk0Wjq3nG/bJHs/y+QCXs0P9I2nmJcKAlATdWm4G8A8Fu2ueUp6du8/NOCS?=
 =?us-ascii?Q?X1+LPK4wBUfGfVvTMrZGjFiCt5mLNmDOVvi2uHMIRGGIsvhs90KvK4vntHIh?=
 =?us-ascii?Q?O6MnOvNgiqo/RbMP+cQpbISln9jv0cys3z+5DKjuE0Dn+cQ0IpLjub4lVnpe?=
 =?us-ascii?Q?pFjdrsUkcgj1h0Y/6K4QWeXbjpW37YI2HsImRjUh4QgizvvkjbvZiAQVGrzs?=
 =?us-ascii?Q?NCUp+eFPKgViROGKWqvY50OSyuqIt4rMGptpbwwXC3kIqibINg6CJ8DGBgUE?=
 =?us-ascii?Q?1+i5CEnCLxZJ9tqnhfF5UH5YTxVdOswBsRfc2ofjfHKlijkcx05CeL4wZj6B?=
 =?us-ascii?Q?od9QfBvMXeLi+DFaifqNaXIfEf6ekGgRnJ43o0uNlsojXuQMq5xyCNxFSvbW?=
 =?us-ascii?Q?b8zYqVlKFOYnbV8pBA7RM5Mx8qQ9V0kERmpMkd0p7eMZanqPsACt9E+UzM2c?=
 =?us-ascii?Q?RBRWCyacZj0d5a6QWy+eY2pAfuxD9GyS84rAYGALZ9TkMrcwil0Pr7R3623X?=
 =?us-ascii?Q?dfXkZB3BMT2fmGPS1nyHHsTPXQR+i6FnmRxh9Omr3N4Lvm+6zXBPbtwrrjhu?=
 =?us-ascii?Q?82ttQ2biTmAjIFcyo5GmLbcWM2sjARY0ROxcjxUZ1PEWtnJYbaNji8KYL1cD?=
 =?us-ascii?Q?134FPrs7xgWsnGJpXh/WYWU5Gj8QKjI/hsgZOcsrw0+WAREb/oYiifx3JSA4?=
 =?us-ascii?Q?qMN2VAlFqTLWtis32t4d4X0ORqRrfBnuirdczuZ/HqgIw6LAYugVUmMnNK5q?=
 =?us-ascii?Q?SPSwGYU3/v0iU/fVo0/KwltubPGGlBQFzq5D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2025 06:37:46.3028
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dc13217c-4794-4cbc-4791-08dde3a1e731
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7946

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


