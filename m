Return-Path: <io-uring+bounces-8583-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E9274AF5FF8
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 19:27:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 18CF21C43293
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 17:27:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49F4E30113F;
	Wed,  2 Jul 2025 17:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gf+uUwOs"
X-Original-To: io-uring@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2082.outbound.protection.outlook.com [40.107.92.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7B1307AC9;
	Wed,  2 Jul 2025 17:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751477234; cv=fail; b=dzbrK1h8cMiw1DCatsDSkrM5j46bDBGwWoudyqR1cIX0Vu5yTWyjupfkVvquuu9be8q0JBw/XezbbKL1aj8oT8LunWbCpZH3Qy7TrjZaUdc2j1swhQ0m+7p5/Juqz6V05jLMxJ5BVh6IPlwcw3o/bTJVs3SZPa0SexlIVIHGzoY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751477234; c=relaxed/simple;
	bh=Qdj+AnKGitgM2MeOKVox3GYfZrRJJ+49jRj1cZhz1ng=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M1EtPpcJIfxrx2WoMyUZ2vdV83J43w4yEyRDD9kWPMQGri9G4uG1ejTRXPBIRNKjOEAke6gpEFuthcbq55f4Q2KNnWJsSHIUXxCqMuhUnF2e6BMt2TZTlPpbWw28hgc5A5YJMI0IrziBZ9PbIl2+R7MdWLR5xMwhmwUDHS5hJpw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gf+uUwOs; arc=fail smtp.client-ip=40.107.92.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GHDaJHBt1Eb6e7sqHCq6HdjgR5ziL9fqOIG4DfW1N1BWonAXgvdPw8DYNVQHxmsgLk/YBb9CcVzVdKEwKbLDXBtY97Le4IrvNsoP9seM3pwHxzd+1zUkcDoLx9k02jHyeWTmyoxv24zgB5HCS/K6/Sv7rN9FWHqPezeRc8GbqIKqFzMI08cg6ndu7am90M5lCx3fLuI7ZYu2hnG2LQKmIz39GwvpnC8FdGNIE6uaUMUKT70iueMmUa/XrFJSU0eOYtL8NZIovfF1F54ujsrAcs5u/JSQM4uG5l5MUZnXixU0sYjQJfRGicSn4+nPK2JSc529X0Yj8YM9DqxlBnPt1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h1ZbKCUzw48yP8VGHXotWnsxNAEeAeMBke+5ZYf2Fnw=;
 b=NXxobzUr91MG0n8V39KxtniKf7tI75yrSZ88zUALGBZF5r3SVP0PJ3JLIDKKyANzDAJh3oO4TVd6jAzuQfOZoGhKSLkOrflTCaZjHSgypcH9NrvyfLfs9qHuXr5pwz8ZmJ+Jkh8Ye44Iyr2d1qzaqa1LJlwq6/ixQtN9bMZ5IUa24rV0i/P/UtP73ygpRfnsSQM/nK2ZCOW7OUMoNtdEePBXUbN+I6UJRP26puetQJ9bXSnf/M7uRjje0TXwuYGEYtX6mkAzpg6D+YXuKFkyrB3VruhJmvX4kmhIUkPCRN5EcZg+RaYIElDpu1gpddwih+AxpSF5LDXnswvsX1Bdtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h1ZbKCUzw48yP8VGHXotWnsxNAEeAeMBke+5ZYf2Fnw=;
 b=gf+uUwOs6I0c/wjfH80hl5D1Ljiu+bFQRH0GsKdGh82bEVCbJAdoWgBYsFwLZfftIcednG29uFQ5DSP5/p/OeMZ1kY3YEcFnYx07MCdap47ifFWu4F3E7Q6gwig/Sck0HRmQ++0T7iD5ajITpXZRmOKHFLPX0pfd7TFOynlZ8sphJKvYU3NCANMKQPcmdCXzeaXY4iM6/OrDQKMm0IUeEbWdl8MkaLhT+pIm5sgxMR4qy9VCSqtAK/ZgOA1NqRJ231arK8jP+xescqn0OHVG/sHh+npj2nWj/Ro9mLKsFy8Yg/IlvxKi3Xsk8MlUqQE3A8hFAvai8BNwSLAKediSbw==
Received: from MW4PR02CA0028.namprd02.prod.outlook.com (2603:10b6:303:16d::7)
 by IA0PPF0C93AC97B.namprd12.prod.outlook.com (2603:10b6:20f:fc04::bc7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.27; Wed, 2 Jul
 2025 17:27:09 +0000
Received: from MWH0EPF000971E5.namprd02.prod.outlook.com
 (2603:10b6:303:16d:cafe::82) by MW4PR02CA0028.outlook.office365.com
 (2603:10b6:303:16d::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8901.20 via Frontend Transport; Wed,
 2 Jul 2025 17:27:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MWH0EPF000971E5.mail.protection.outlook.com (10.167.243.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8901.20 via Frontend Transport; Wed, 2 Jul 2025 17:27:09 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 2 Jul 2025
 10:26:52 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 2 Jul
 2025 10:26:51 -0700
Received: from f42.dev-l-178 (10.127.8.9) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.1544.14 via Frontend Transport; Wed, 2 Jul
 2025 10:26:49 -0700
From: Dragos Tatulea <dtatulea@nvidia.com>
To: <almasrymina@google.com>, <asml.silence@gmail.com>, Jens Axboe
	<axboe@kernel.dk>
CC: Dragos Tatulea <dtatulea@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
	<tariqt@nvidia.com>, <cratiu@nvidia.com>, <io-uring@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [RFC net-next 2/4] io_uring/zcrx: Use the new netdev_get_dma_dev() API
Date: Wed, 2 Jul 2025 20:24:24 +0300
Message-ID: <20250702172433.1738947-3-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250702172433.1738947-1-dtatulea@nvidia.com>
References: <20250702172433.1738947-1-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E5:EE_|IA0PPF0C93AC97B:EE_
X-MS-Office365-Filtering-Correlation-Id: b371239b-b38a-4588-d2aa-08ddb98dac90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uH4Jt1kRV+c6JiOwtpDvd0HsZgFlWKYyAMEzGAFLqCwQOPjn8qGVo0MH11pT?=
 =?us-ascii?Q?/jjyJHEaqViXUwo4gwbOAfkR4ZK1zGT6ngv7NoGc0bOByqj9SYJM8OrZB6x8?=
 =?us-ascii?Q?EC6AQYaYcupIAwcNgI/rfEFKGrbBul/Vh/tw/4xYvTfqTJmiwTLaa76BefUJ?=
 =?us-ascii?Q?sRx9/R/vJaVtaZo3Gn6GiymuvNYoLfyy/df8kKA0Z7NYUTU9XE+4YV/LG23f?=
 =?us-ascii?Q?6rPn+eW2fNE2ShrDb0bfEIslp94fRjizkue8aVadyX7Zx0DO5jHkkBi5HgxH?=
 =?us-ascii?Q?aZ77oiPeuKWpIEIEQR8Bs+RPpX/ip63SV9gfrdRl8p1G/nCuvXqrxiTezRDU?=
 =?us-ascii?Q?HF3s156v34Rn3K7jvl0Ipiwqf9MeWehXBU2Sxf2XIUTl2dHBDKLIbLm8IGCn?=
 =?us-ascii?Q?ylCo+u7Dz3L6JcKrSE0tGuvTFcVmrKw5zp6NJGEMy8uzALQxH5p2FwmN1qjx?=
 =?us-ascii?Q?nW6VcZIpfVrZXEac9zkRXvodBeBrV/yShoGJfTqEcJdacSinzJ3cWBi/LpVl?=
 =?us-ascii?Q?j+FizVoGQLdR/x1xoBdvlOSGa9LLIE2wPhfE/nLuLIx+Rie9wy72TDfXKY9b?=
 =?us-ascii?Q?Wx4yyYUIqDzStIbhT1X719sikFVXBgR8pbWj2rAMQL7jUxOJpuNLtkoLg7mb?=
 =?us-ascii?Q?soYBN1wsJcA7J+YlQRc/xyQfnbeXv+5R7FbyFi9ESWmNo/+Z3mytTLSv4y2a?=
 =?us-ascii?Q?qVf2Uly8hnN5eye33YzQ/Rt7bMRZ4wjmMMrDk5U7JQtE6LTOEF6DBJYA43u0?=
 =?us-ascii?Q?WQmt8dFyxX/CsymlxUCIM5zg98lK4jPBm45os28YbFk94DACyERGOd8r2sgB?=
 =?us-ascii?Q?hrZTLLq8ya2K5HoNbpKx6uyQk17NPw67+ZW7Ugf16cxBf2SIdij3ux8yqT2Q?=
 =?us-ascii?Q?YCH8qBrrZ2w5kzcNG40p0d0p/sjtwU2cpRAR3Z1ugVrDuBvKVCuxS1BOoGL3?=
 =?us-ascii?Q?g1bgYWW/sOPQ6MlQMrZCPcJD/3qxc9d6mBRNa9blnXMONiV/x/TCcdHS8gmB?=
 =?us-ascii?Q?Cz/5UF5zjEQqIWoBUHb6mffqtNfA6ILHQwnD+T2s6PSlkR+sd+fVRAD5TRoH?=
 =?us-ascii?Q?3Kfcn+zFClVPIIvRxhmM4ivmdxuMNKgF/wzbg8CKSO7CJyFbf/HPgNh9Mc8q?=
 =?us-ascii?Q?WsS4iVn8NrtfcvnseqPtePaT5CsKH2epJAbV1acBzrn8WZ1P93tggV9CWBwO?=
 =?us-ascii?Q?UxMD1rhn2qSSGYDLUXepb+ujs56h/ZerICsfN/Gt01Ys6OGYmVvFziwgtXtp?=
 =?us-ascii?Q?He8zfq8aeW6DyiAdqSvBCT0CaDJBGk0vJ6X6jFcl0XyQZvrBMeEVVUCXfZ0C?=
 =?us-ascii?Q?V6Wc4BJiRdUHM4EqHA9f2EXwS4akjF/OF7s5HQdcS5/as/6TfUIkl+MnQIOi?=
 =?us-ascii?Q?2sZu5O2GbjTmCDlTKUKXBMsHk4AlydSTx/k7jCV6WIAVb9Iih35BuFiFov7Y?=
 =?us-ascii?Q?B2HMzF9BvitDNwODYQ58q016gF5PSiRy7EOYORVJcohLgbcNCYO0rtxNeKnz?=
 =?us-ascii?Q?PTekSJWG187nojHRBNF9eFEy/QsHxbg7/uYI?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2025 17:27:09.1784
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b371239b-b38a-4588-d2aa-08ddb98dac90
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E5.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPF0C93AC97B

Using the new DMA dev helper API, there will be an early failure if the
device does not support DMA.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 io_uring/zcrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
-- 
2.50.0


