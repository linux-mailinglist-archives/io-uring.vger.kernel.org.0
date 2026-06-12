Return-Path: <io-uring+bounces-13709-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id Ak4GKox3LGrvRAQAu9opvQ
	(envelope-from <io-uring+bounces-13709-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 23:18:04 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 360D267C7ED
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 23:18:04 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Ie+Z6ShM;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13709-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13709-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=reject ("cv is fail on i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 7CDAB300DEF2
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 21:18:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6E693803F0;
	Fri, 12 Jun 2026 21:18:00 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011055.outbound.protection.outlook.com [52.101.57.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5860F305670;
	Fri, 12 Jun 2026 21:17:59 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781299080; cv=fail; b=Hv3cjShEz0/V7ZIP1yrYhR+3khYI7tg/dZVKJ7SvAOIYgAurp+gEyD2B7d1Rz4Y5zauZBvij6bH7rp/AxwgTV9HT2dpRtt2V318DJJgLVA9p9GaZ0tSYJlMKE56g9KY3QSUjmhidq97MB095KXmEVIEKEuYO5i5WXVFsgr5ocLo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781299080; c=relaxed/simple;
	bh=DvjA4Noo2mzPVeCeVbSnnPxE/Qcn8D5nTavDaGw9LaQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=CHFtra6yYnaPAzRGZnRmJeX77vGUaJq9YPUMfPal7RumHJlQN8CFeMabs2DReon9uMKrp8MR0oJqBz020dLkIAH5+d9SgD2oIkHDoSPX0n7okxE3hDNE+rDy7batXjHn7GPf8OnNLQukUNrcLLpf3UsXKr9UmkUSvkSPA2+04I0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Ie+Z6ShM; arc=fail smtp.client-ip=52.101.57.55
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=snjQloouv2G+R1O/v+eYc2o6HgG69TM3dYYO1jPHk56VY4WM5jfOIXPbuRVryvi+HsL2jsbef+XehJg3IPv//57d+Z1Nn1NnYzRrJL98+MIHK+hFHlnCwiTunop/TddnHuNtTjvSEIBQ7plBbfs1Jwr+gmohv/Tw8GJdt9UFM/Wqw6NoaUgRJzZFEAmbUMxUj1T33g0DLmwqWP9k3pXneduJuTFWuom/zGk2UJ6g1P6eut6+OHcHWVPkpcKE13Mh5JdFInSUgpGVse/aT/Dbwe8JqOhH721lCNDGkQuO5ALJfMsmVjYC7gFf3HR5FoXR5d8e37ueVZvu2XRYzmA3fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hc2kt0paB82DZ/OLs+P6F+e+xtNQRXfRd7xza1vic9c=;
 b=wIr6O5CpMbIY8K+jEoHEmyHCGOu6eLZBVlfEU3/kbp1gceD3gfEO7UfRTu/3+fmGJjoY1+WtYR1N17pyNviOBuxnfYCDgXdXBqq+PcT5kQFlOjJ6QT3I5b6mGMpsKRZ0hUaV7cdQMae7dceRWF4A7Ceex/+io7PV+M5EBjVVbjywa96FZhAiOx+yjKNamdghpsOsgmkmskXB8l4CEoxUXuHWXPIh4R2/1TryrAopF+48kG04VMGdE/kdYE9y0xIij6yun4qB89HrCGSPtdcF3eR4a45tT6BLwgTdXl9R+RkxgrHQAWtEecCCXc2Zng20pIst6PMDPz47J+dJIhFa3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hc2kt0paB82DZ/OLs+P6F+e+xtNQRXfRd7xza1vic9c=;
 b=Ie+Z6ShMfwcPd8XRMce5Yt65kPyNT4L1i/PKOplF9bu9GCtmzw1pRp8EUtea+VwQ9a6JN9ftsKecvkDebT+OO3MY2XEXfzRsfjHb3EcGJXsN0Yx22S7p/Rn7enReuQNNd6jFIhOVY782F5wdgn5lyv2GWbaEaOrnqYtSjnaiox9dy/iOSSRYr6QRqAs5nwhIQzGJQCdevrvF1z2e8L38bBYUAc2vYNV8hHwsKNJ6OatQfdzf5mZDZulXiScX9jkfDaDchrH8FokvUdw5CdF1MCHmhV+DGAdCz2T8+BOuJx0UE04N+w1tBse/wNTwYPXadYLx4d9QSaxNrz/eeRXawg==
Received: from SJ0PR03CA0074.namprd03.prod.outlook.com (2603:10b6:a03:331::19)
 by SA1PR12MB7039.namprd12.prod.outlook.com (2603:10b6:806:24e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.18; Fri, 12 Jun
 2026 21:17:54 +0000
Received: from SJ5PEPF000001F2.namprd05.prod.outlook.com
 (2603:10b6:a03:331:cafe::6) by SJ0PR03CA0074.outlook.office365.com
 (2603:10b6:a03:331::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.113.14 via Frontend Transport; Fri,
 12 Jun 2026 21:17:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001F2.mail.protection.outlook.com (10.167.242.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.113.7 via Frontend Transport; Fri, 12 Jun 2026 21:17:53 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 12 Jun
 2026 14:17:40 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 12 Jun
 2026 14:17:40 -0700
Received: from f43.com (10.127.8.9) by mail.nvidia.com (10.129.68.10) with
 Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Fri, 12 Jun
 2026 14:17:36 -0700
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Donald Hunter
	<donald.hunter@gmail.com>, Andrew Lunn <andrew+netdev@lunn.ch>, "Pavel
 Begunkov" <asml.silence@gmail.com>, Jens Axboe <axboe@kernel.dk>, Shuah Khan
	<shuah@kernel.org>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <io-uring@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>
Subject: [PATCH net-next v2 0/2] netdev: expose page pool order via netlink
Date: Sat, 13 Jun 2026 00:17:02 +0300
Message-ID: <20260612211709.1456966-2-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.54.0
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F2:EE_|SA1PR12MB7039:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d2bcc33-1af0-41a0-f136-08dec8c81125
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|36860700016|82310400026|23010399003|18002099003|6133799003|13003099007|921020|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	9QcagYBeFYmCx1l4zqjHDctnaVhrDa81Pbz0vUxFpfZKdrmYqtBIQUPhX1cZc/dlgSjfXLBA1QknFJhm/fOB7/WXH1YVycxsZZj0q0JCZLZhERqJKdCH13o7Wv+wApjZARxqqucuIKvhU+gxkieI5pjtmDNeUyK0q5J9Jxpo0V1A6k0/2xpotM6vgLXBQGMNTd4nHyS4PANLeyCB81XULPwgyekcERlq0paYLHTK1bJGIILlZF2KLqO1gDIaNPrn24Cnj3E4TZk2nJRAM3n8ANPDOzmUu0phEiA/0fVb1PMUA7Fu5wIyz+RC4ZTmarN2qsvcQHa+879Mn85XPvacUm5NpQcuKhpLmYyK7uEDZHXqgkuCJxy1/kWqwxWfLhaMAalyW1yECY2WktiY9dlwXtt26zsKhWVpzeKMJIsSvm0CRF+98VqU0HlHSDP/nm3cs00jCbDVGtSkv6Ay6YQ8YSlAm2oib7qEKytrURsrnek0eexMpSps3Pd123mkp5tE0OiYXZ2YwADwMepVaHlPCipOiHJNcvgz02sQWbSsblvdzy2Vp8cZDca6aV9lvi37l7ybht6LXC18Uo+d1fPsgjhFEb72g5qmSAspP4LYRb9YQ7FWQ9K+TIRPo3RNOyefHFxmNt3fhHdvUtaUo/S6nR/d1x8CftnB91Xr/2Z2IG0QX4mtNKHlB7nCYNrumvxNG3feV2NBKEmKU9XUaSXTlNfKaCx64yEFhdXZ2tt6FtgTaDqG5OUahNnokE3TV+KXoui9/bonkSpBFG+d/lwZ3jktqDR3wGywuU/R4PjrqTI=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(36860700016)(82310400026)(23010399003)(18002099003)(6133799003)(13003099007)(921020)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	JYS3PHpw+PEs3kGi7tLPKmnKiJlKIuwMk6GGw5Sw7yn23FtQMBsaqS4Cz5BwJWKaiWn+UdX8Lzyt9ycfMS9ZnnTe5ygx8NAxWDAkcivbaPwpAah9JnlPZ44Q7bK0C2PmQ1CAopo76sowKvgMkCYPToIdHBWhN9XrcxczQjydzENoq5HATwk7fSvViUhukEId1rxROk+m+7e/K8giI4gSq2WvCaubujvwyXzDk7KmNNZSLAC6TgTKO33377YOeISVZ0Od7f169Gr3MLTYPqCmtza0Q5dSdwO8omSDYOnNYif9O8TQVlxGgfB9X6VVYgBKI7K/vT7xizdD+nBgZrFNEZ39+S9xB2Kf3Wy9mQJhm4r3qXU24ZkNQDsP4ANnqxdeCfn44FGbe+uzqlV99A3rxZjGSfVClSiYg3QHnUMUW7OQIuoyLhd2dD1YtpGzmwJh
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2026 21:17:53.9127
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d2bcc33-1af0-41a0-f136-08dec8c81125
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7039
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.16 / 15.00];
	WHITELIST_DMARC(-7.00)[nvidia.com:D:+];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS(0.00)[m:davem@davemloft.net,m:edumazet@google.com,m:kuba@kernel.org,m:pabeni@redhat.com,m:horms@kernel.org,m:donald.hunter@gmail.com,m:andrew+netdev@lunn.ch,m:asml.silence@gmail.com,m:axboe@kernel.dk,m:shuah@kernel.org,m:dtatulea@nvidia.com,m:netdev@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:io-uring@vger.kernel.org,m:linux-kselftest@vger.kernel.org,m:donaldhunter@gmail.com,m:andrew@lunn.ch,m:asmlsilence@gmail.com,s:lists@lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[15];
	TAGGED_FROM(0.00)[bounces-13709-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER(0.00)[dtatulea@nvidia.com,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FREEMAIL_TO(0.00)[davemloft.net,google.com,kernel.org,redhat.com,gmail.com,lunn.ch,kernel.dk];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dtatulea@nvidia.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring,netdev];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 360D267C7ED

This small series exposes io_uring's high order page configuration
via the page_pool netlink interface and updates the appropriate
selftest to check this value.

---
v2:
- Switched from exposing page_pool order to rx_buf_len via nl_fill of
  the io_uring memory provider.
- Updated selftest to check rx_buf_len.
- v1: https://lore.kernel.org/all/20260611161235.3807332-1-dtatulea@nvidia.com/
---
Dragos Tatulea (2):
  netdev: expose io_uring rx_page_order order via netlink
  io_uring/zcrx: selftests: verify rx_buf_len for large chunks

 Documentation/netlink/specs/netdev.yaml       |  9 ++++++-
 include/uapi/linux/netdev.h                   |  2 ++
 io_uring/zcrx.c                               |  8 ++++++
 tools/include/uapi/linux/netdev.h             |  2 ++
 .../selftests/drivers/net/hw/iou-zcrx.py      | 26 ++++++++++++++++++-
 5 files changed, 45 insertions(+), 2 deletions(-)

-- 
2.54.0


