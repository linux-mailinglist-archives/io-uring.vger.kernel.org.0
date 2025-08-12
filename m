Return-Path: <io-uring+bounces-8938-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E1C34B21FE2
	for <lists+io-uring@lfdr.de>; Tue, 12 Aug 2025 09:53:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C24634E4A6A
	for <lists+io-uring@lfdr.de>; Tue, 12 Aug 2025 07:53:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 239558248B;
	Tue, 12 Aug 2025 07:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="TqEeud0a"
X-Original-To: io-uring@vger.kernel.org
Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012010.outbound.protection.outlook.com [52.101.126.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8952F2D6E66;
	Tue, 12 Aug 2025 07:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754985212; cv=fail; b=BRSyzt1SEouSDTAkPDvC8hDeXU7Pdn/m1hGE+hXdUXMSVXw5ZkmdzRncGbDt9vDwTzHYqC9VQFlVd46jgJaGw9lp0tY64QzMvejMFYhXJQs3f8b4IH0f48tzOj/YjaxrpPyLDQKh2CDX083/1mqiZQ7UTK67B9ef5feeUS9XlhY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754985212; c=relaxed/simple;
	bh=XjgCMQMHMxeHA2j8HS8rtaVNENSuxX/s2mpNq/ydRlY=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=miCd/L60w46MWRsFBeR2n4lAI4exUL0+dzgRT6YcfpM0FwIZJ46xauvUBUCo6zi3VzkY9vuRkIgfPLW/jKLPVv4dxVKHxu9X7EQYqdHhsIoVu41OLcTYHQNB6gty5R6ISLo5WE+7BzAJrfgi09hroJIsngMPHr+Z/7pZrDlpVY4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=TqEeud0a; arc=fail smtp.client-ip=52.101.126.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pwMCIxrG957fZsY6+E5+b0g5uCbUlvN1uMOGEcPhaAncRBAvQoYl6dWvHp2bbkfxA9XvvqbgwIHcb7PuakWqYZMYUb98EPwTMzeWQy9FojmFEtQnhDXpDKDu4dbTYaiTH8OnoOOCEI285vhBqzXAuuxmgX8oQpaa/ShGGLuZ54LNQZ4rYMJtvncPYd0JFL4aO7gA5Hlx0L0mM1VcEeci89ftgyWEl3y6K0SG4jFwEyjGWpedVFqV+ov7Y/CLxH1mdBuhKPhQ3DVBoHxNGEoOMbJqr62YfJq1Irkcol2/YMz3qKRrVBxhOai0R7mz0xeUhmOaqEFsOmxYj7SjcNCHhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Fy0MopROTm9EIXSzdol2UFWgZMOjHHHYA2n3ei0cd0=;
 b=dgLLcgNHn5Dei3YDKUJQIH+01FeKmNhCDmISxoYbtaSX0YklSiZ571ld8BKb2EzEr2xbTehogFS0bCP9Q8inMHu88vqt/cIYFKYwc2PeYAU9791BvMCMeyaUxyRY6i7oY4U5j36MgrMZYKzV+38z2KtOb0IexZGdT9CB2N+XtULbnS/X3XH8Td/NINOkKdvjAw/QkeN1S0IICdEhEIaXfAg/adN36tnxNyPptevMvWn4kBRPYk7LPLoN0vsTBa6KjFYvchbi+H6Q9KJLmIeaeArGZUmIZZRlcCzJRno3dkeGOuW8t2hvxIFRNAGIEvpw0iJHlfByax7qFUUypl4SRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Fy0MopROTm9EIXSzdol2UFWgZMOjHHHYA2n3ei0cd0=;
 b=TqEeud0a/1BjIpLQheNMOuJljeSAqoDii7UNNvijjv6Krj0xELwHa/uCOXpevyaTsyUNiaWBILmS0A7pRdb1SybgLsAI+xrehEybMj2HeE6yGv8HlOF+e8I3FqQr1Bc46r+yw8qs2elPdRM1jyV3YBOFZ6RKq9t7LyP5hX6VIPrbLjiAsj0XVj87sS7BEKppPXJY6Db2eJXuPATCuHYYnop0ffPIKEEfVPDA1QH0Zfs3OWsJ9Ad3ic5ttmCD87TdzyinSCoc4CGGGTo0iglXnPHwRWEE6PNNNPZAqzASK/VvMHVnqBQ6x1YTtaqO092SahQweAu6ZmRUwWWqPS9JiQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6020.apcprd06.prod.outlook.com (2603:1096:820:d8::5)
 by OSQPR06MB7280.apcprd06.prod.outlook.com (2603:1096:604:295::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Tue, 12 Aug
 2025 07:53:27 +0000
Received: from KL1PR06MB6020.apcprd06.prod.outlook.com
 ([fe80::4ec9:a94d:c986:2ceb]) by KL1PR06MB6020.apcprd06.prod.outlook.com
 ([fe80::4ec9:a94d:c986:2ceb%5]) with mapi id 15.20.9009.018; Tue, 12 Aug 2025
 07:53:26 +0000
From: Xichao Zhao <zhao.xichao@vivo.com>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xichao Zhao <zhao.xichao@vivo.com>
Subject: [PATCH] io_uring: use PTR_ERR_OR_ZERO() to simplify code
Date: Tue, 12 Aug 2025 15:53:15 +0800
Message-Id: <20250812075315.6940-1-zhao.xichao@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0143.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:31b::19) To KL1PR06MB6020.apcprd06.prod.outlook.com
 (2603:1096:820:d8::5)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB6020:EE_|OSQPR06MB7280:EE_
X-MS-Office365-Filtering-Correlation-Id: 7795f186-ef90-4055-df2d-08ddd97551fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cwNADsnXG0lxI7q+yiDeY5sPJyPTKnS74ih5OdR7jKVAeWctQk5cY0LUmCAX?=
 =?us-ascii?Q?G9SUFZ1SJJXG0AqGxCxHpmHBHXekTg9Bh5gAlHuhIb+HxzA8BoMhont1z+cV?=
 =?us-ascii?Q?dksjoaak9MXc8OuFvN9uBGT6n48oMKHNGOpRLGANbHW6kX8yCSlixZJeqYg3?=
 =?us-ascii?Q?59xqY0hyiysBqWYGpdBatgWv1bwFagX3t6kZLe0tLfojnUeihvLcL2Ctqn8o?=
 =?us-ascii?Q?Bt+GyHTQGkHwpoG7DmmcGDkOGMzHAGN3k54j4kUtgYsusLoPYKOsxzsjjcGb?=
 =?us-ascii?Q?mbX2+1nauidY44CwwXEdbHUIzUIQmgnrsUVc69tCLy8Af8wZsje56fNvkunF?=
 =?us-ascii?Q?KXMNJ5b2HoFgwzX43KeADRV5M2+w+wHO9NVZ7I5jGzeCLqgn4RFGFjf21bon?=
 =?us-ascii?Q?mJIPrcTyrH8IZyR9ISDCneArmoFPMpSYcT2DLX4wCTpFT42TZ+IE3zTzQ5ML?=
 =?us-ascii?Q?x5RmA8mBjJNEH5Xg5Se3GJl2wQWo91fLoWJrF+9Q9hlAQsN1ydcjw6+j/tLf?=
 =?us-ascii?Q?3N/L2IM/GwN1CDoVQFZTPAWM1ywfAZEQCHr39FTioCpdSjPkVWZER9zp+HVq?=
 =?us-ascii?Q?tj5bt4oWa8QNrfIgOEkmP4ipMRb+tHHhofDdzWdnvHYVHHCuQSyztQ6Wdq+5?=
 =?us-ascii?Q?Vlgf2/2C7LQ5HNaKdhT08SRUktO9ba1PCot8TMlpRRMdYqRbZgwl2sWPQOGX?=
 =?us-ascii?Q?aZHR+GmqIg3OWwsldNdBwVlLL+dGZPWpU5/qpqzACDcWu3EDiXXBsh/+zx/X?=
 =?us-ascii?Q?Y4tdCZYdPKh+hlNg4HUzRx3NwsSpJ3yuk1s8Cz0zCHz/YvY4lfhpB1GXkLb/?=
 =?us-ascii?Q?RdwP+c7kKCkhie/Vz2DuWQ91zPxDsCkB1IRcRxMeMn16xJ+zjHs5kkWhv3vV?=
 =?us-ascii?Q?gCwkV+ICkwlbnwWaUOEKmyqH/RL62tjOkypzerpdpix7wm9LQAb2I+hZIIpa?=
 =?us-ascii?Q?cTwud0hj4JmR4EdWVY1S9gU/TxBV5TM/iwIyd2Y2Jea69WL16aw8AH/HQLHM?=
 =?us-ascii?Q?oMrkJiJ2f0iKfhpQPRZrARQDMRlzij6IjhatOw9QOhh9B6rJmpLDZXlRS9Jl?=
 =?us-ascii?Q?fV/S2C0ek2TwPNs3XCX7Z2tcaVu7GGQKLI0dNm1q+jOM4mlqMFg6bBYLzaNU?=
 =?us-ascii?Q?RZ0JTfoc7E8Z2n+iiGwDYhrywfhyhNIlpzCtS94IrzwZ1r9BHo0fH/OnBO2f?=
 =?us-ascii?Q?xDNErCJ7uXpwyn9xdoPjWq55TuN+XYN/bX2jW94iaw8XzlrEtJ7+6xjiIxEM?=
 =?us-ascii?Q?6OmndPE2F9gV1VldE6AUySs3a5TsFypKPF06NyHWcwvsyUhcD1qo3BqxGiGg?=
 =?us-ascii?Q?72Cl0XPZvKnInCkBTVaQTsgQ4kbccMJKsEk2nvDsrSqlo1OtEmn1WrDRcVOx?=
 =?us-ascii?Q?HruqEzUOLst2y8JCA/2PcD6FBGfM8J+phLS/8/OkGmnZM5MFzyRHA+afEeV1?=
 =?us-ascii?Q?3CV0SjiNo8r9oMe5gdCD7rsS1z3RxNs7HcxL2myQPIFAGQRHvJLfHw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6020.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(52116014)(376014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6N6KvjKlowd8jJJuzXeKol4UMjLr8gHaLw5rTgF8TpuH1tQkJpuMqz1qQUXH?=
 =?us-ascii?Q?XulLDZtuT8LNFKW6NJ9gldVIeAGbiq6D/tMWSW4uVFmWjN9TxbyHopIjnw6l?=
 =?us-ascii?Q?5vXTDYlfbTK6aHdVXsWNe5r1kAEJcXrYhHbGNdwf7RRWKBJPqCS88M7NkG3I?=
 =?us-ascii?Q?GYOw4VHiA8WrwHY87/3yxItXWbB9LBuA8T25QXGTuFplnngZZ5SB1ktR9unO?=
 =?us-ascii?Q?19nD+Rqv6QMPBuisr4tPLE/wbShh+74Ucrt9+115qw8yJwJEj2U38w/2bcXW?=
 =?us-ascii?Q?XpRFq3E0Apn2t3uVwbcdNsWm5PI7i26d163upas5M48DQZRHhss+UTdRkjzd?=
 =?us-ascii?Q?n4sKsZUkcEdndllWU9WQRcwuWCP9vX/3F0atxKwdsOe6ARsOP7SMRT98yx6l?=
 =?us-ascii?Q?q+wfjAXqPlBySH8jxNO9e/mvhc6b4RuHLF8O4jYoLr2FPcNvpqZC3etgXAJW?=
 =?us-ascii?Q?c+YO40dQcDSVRrkEqGB6TqPD2nDY+vX2I72HlDxI09TuNRfHnBPZFsUUfngj?=
 =?us-ascii?Q?EqkUQdHyAoT5YbLoOYd12K5dMQvzz5e9AbbvVgkX8ZbXfejYrHyvYFdJww+l?=
 =?us-ascii?Q?gZ6Pb+Q2yzaXmyY4TfcKkQeqfl/0XRWv7OWHEVCeMSXiHNrcQNGsoktBH2Xp?=
 =?us-ascii?Q?hSyvdnheF1/ouFW5HagMe2QlyX7TXPYDC4u4OcF/r6tm9n1tC5a8EkJCdVe4?=
 =?us-ascii?Q?S/8CDFpQN++NTxyZbWW33hm5ey7sfcSm30wTlSpEqW+0jKhEzD7popD60LUc?=
 =?us-ascii?Q?FbiJKNb1HvMIWqg3qIhHuJDXWPLW+QK03CM7B8v57ADGWBbdV0Vfb4Mu5Tui?=
 =?us-ascii?Q?GqJXQCgoqsY4/fwxUj6lmKXAB9AHF63VoHTaHFbPFSeCoovE9lXz/A+/ZrzS?=
 =?us-ascii?Q?3KaEoOynqUghpwR+Q58juR/MsVXNp3WLEn1PUAxiA1wFCBKLsCOLHSlrETfw?=
 =?us-ascii?Q?7CYAmeBpgamL2ezxyEMMXA0A5OrexT7JhNI+SkbcURpKGg8PTJEPCiTuZ5Cj?=
 =?us-ascii?Q?vwLJkrnVhAsNE9KX5FPQ3zCODH9SiEgVLbGxPcDP4/9OPD5PWgJiKAMn7hN7?=
 =?us-ascii?Q?roXGqvI27JaW+E+JukR8Xy4FIOaH91qiA9l8x6wJDmAIF6vGpwxA3aMYo7H0?=
 =?us-ascii?Q?4avmCRmoZR7Bgh8MyGCg/xvhE7lGPBGv0CA70dXt0VFLDje/TpOugXTZf5b9?=
 =?us-ascii?Q?1m/xhCZrze8WtcMSVYZLNhe6QZNxem5fgVqZc48dmGpim5c9gBZMniagLi/K?=
 =?us-ascii?Q?ax5znjLdu4XRnp2X+OCB+RAuBXcLhMa2RnmeL6ruma/OhJqIGU198kCHkCTk?=
 =?us-ascii?Q?IvExqQY/EsVKmkGX9sMYyCPcQq3S5yJg9ufnO2I/2cuqJSrUczBSBKf1i/aS?=
 =?us-ascii?Q?hbXzIkltLULF4AL5XMxF5UFzT7s+AmQTgsUQ7ZoDRVtk0aG0j79dNf5/mVbY?=
 =?us-ascii?Q?9uT4bBJ40ZrxznhYSNCICKNyB2ayIuuNjQKBOWTfrNJHDDHlDBmF0SphZJg6?=
 =?us-ascii?Q?jE2F40xVCxV3QYBkIWScGwTaO2FLHexodbt6ovQbOnITp/u3jBPigG4T+0Zi?=
 =?us-ascii?Q?vn+gi+bpmFFVSdkRx/JI3M3BRFiyFqz9aRG+/Peg?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7795f186-ef90-4055-df2d-08ddd97551fb
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6020.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2025 07:53:26.8563
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FhmdCNHO6cyHjGcRQTYgt74zB0ExYLh7JEilz3FUayMQVT3/+OKRzFrQUF9g7R3kmbgJ2raEHgE1qdncAPY4PA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSQPR06MB7280

Use the standard error pointer macro to shorten the code and simplify.

Signed-off-by: Xichao Zhao <zhao.xichao@vivo.com>
---
 io_uring/xattr.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/io_uring/xattr.c b/io_uring/xattr.c
index 322b94ff9e4b..d0720835a1cf 100644
--- a/io_uring/xattr.c
+++ b/io_uring/xattr.c
@@ -94,10 +94,7 @@ int io_getxattr_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	path = u64_to_user_ptr(READ_ONCE(sqe->addr3));
 
 	ix->filename = getname(path);
-	if (IS_ERR(ix->filename))
-		return PTR_ERR(ix->filename);
-
-	return 0;
+	return PTR_ERR_OR_ZERO(ix->filename);
 }
 
 int io_fgetxattr(struct io_kiocb *req, unsigned int issue_flags)
@@ -170,10 +167,7 @@ int io_setxattr_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	path = u64_to_user_ptr(READ_ONCE(sqe->addr3));
 
 	ix->filename = getname(path);
-	if (IS_ERR(ix->filename))
-		return PTR_ERR(ix->filename);
-
-	return 0;
+	return PTR_ERR_OR_ZERO(ix->filename);
 }
 
 int io_fsetxattr_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
-- 
2.34.1


