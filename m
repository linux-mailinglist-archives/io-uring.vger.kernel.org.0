Return-Path: <io-uring+bounces-13710-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id uD7CL8F3LGr/RAQAu9opvQ
	(envelope-from <io-uring+bounces-13710-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 23:18:57 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 388CE67C810
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 23:18:57 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=LrJXqKru;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13710-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.105.105.114 as permitted sender) smtp.mailfrom="io-uring+bounces-13710-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=reject ("cv is fail on i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9267D3115A59
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 21:18:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EA543839AA;
	Fri, 12 Jun 2026 21:18:19 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010001.outbound.protection.outlook.com [52.101.201.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46795305670;
	Fri, 12 Jun 2026 21:18:18 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781299099; cv=fail; b=Snr5uQq/9XgBYZrmgJlHEmeH2kf54bivUgw2EruBA1C6lRO3NyqWXfcyR34dRuSXCGYJ6+Eyj3/LUh7BdBjXoPn38n/fUYLrYJX8J9YOZ3TPxuAKrNOzYyrixSAUdcSQunNtAHphGUDfCcdE89kc8Sv30I9VRta4SF/1U0+A3vA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781299099; c=relaxed/simple;
	bh=zUEordkfHOPlQQCS1NT4GG7o1iEyVLpL9+EZfzLxY04=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AL1eSLfAZoq4SXl8+ogm6UnTWuz3HDLH7g0f8HlW+TrsC/RTvmk0Zk2ORdYGiweMm9t9cWjprfwBvaKBJGkrRxmrc7L3xlhnd79A82Su8wIUyIONJ5ifQToCVTwJEv9ZYnXKxYLaOveNeQqeSFOrpTTDjIUnF3cjnbEBc3YIFp8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LrJXqKru; arc=fail smtp.client-ip=52.101.201.1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PWdo2tXt44fhj9+zINqmApSN2QJ7pwgS5RICwOO7bJt4qYhkc+pfb5JV+ju30NeWArN5hgmS4V657g5mF7+lv1bWTRNJF8vgZc3TlV9d93rPqbpjlyCr/pL4Ku7WqWKyg9GCA5YltihVL0ljq7IpVesR4pOKSZhvu++1yeIn4GXRlInN2iKBlCMGZ48U+AEsPKtDV+n9i+m07er8aIEaW3ruF//D4XeX25tMFHoIUTCCb0DmX19hlGJVMKA2Y9l1HPP41Hy/9/K2xiPjb5N4kqXes5F0ovGoFFcpAi2NLRrcsKxfXAkGpWsKbOM7ElIp5/z5oX0XsAY7T75tamFkAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9/Za4TeeTDZ1c2KanDXcZ/aigpHJMwhapX1Vbas6pFQ=;
 b=hUjAQ6nMim2Cu2rpIfI5bj7JnCPh62j6NbQ07jFJBtcFq1A/ZsDyaunz1Fvhe49c3Qo+e6SSBtjKLZ8u1TPg2QHAojIZ7D0y2ZBJeHU5mcMujYU8aQNBpqe+kQR/wRmEYZ1qTBnnjMC3AHL3OX/CZfZk+cPFrwxK0MqXKRaAR5xik8hVRwj9jXLHkesZxisjf2VsL35A3lnyLqPj3B9zereh/GklvIi955NPRDfqena8dvnAhg1znqe2TrI5qozHhkqMWERsHHG8hQM8rp3DHghS1zs3ZndP7/p1vuTKDJTD0S1Irj0OKnCKH2VcF5KaZE/JUOTcWSoXF50DhAy+cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9/Za4TeeTDZ1c2KanDXcZ/aigpHJMwhapX1Vbas6pFQ=;
 b=LrJXqKruu4skFezvnvIvrZygJDWXBqCaXnnq9T9sfRgp+qyZCJDVnsXcfU23+15k5eoIRioq7PBUA8DejMaU+N0ckXFw/tTO1ypax3DviWZyLsDSr/LqEZXN74vetzcml7l62oEW/8603f5vfil2TlOh5FwQg2FUNbNTDuN6CVeNlp0uS0eguGNzztc7L2RYBO0NsJa3GxZBuHJBEN6BpbwwXZhKyIjZ75HVWsja8Aoe7uIhx/oEddybmZtQJ970uZnmQThfrOysPqDPFOF8wMfH2MaOulRkSXWOBB6tVOq6XJZ58m0i3v/1reglMcuR20aCw56D8H0eFR1mlHO+ng==
Received: from SJ0PR03CA0073.namprd03.prod.outlook.com (2603:10b6:a03:331::18)
 by CH3PR12MB9343.namprd12.prod.outlook.com (2603:10b6:610:1c0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.11; Fri, 12 Jun
 2026 21:18:10 +0000
Received: from SJ5PEPF000001F2.namprd05.prod.outlook.com
 (2603:10b6:a03:331:cafe::79) by SJ0PR03CA0073.outlook.office365.com
 (2603:10b6:a03:331::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.113.14 via Frontend Transport; Fri,
 12 Jun 2026 21:18:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001F2.mail.protection.outlook.com (10.167.242.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.113.7 via Frontend Transport; Fri, 12 Jun 2026 21:18:10 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 12 Jun
 2026 14:17:52 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 12 Jun
 2026 14:17:52 -0700
Received: from f43.com (10.127.8.9) by mail.nvidia.com (10.129.68.10) with
 Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Fri, 12 Jun
 2026 14:17:48 -0700
From: Dragos Tatulea <dtatulea@nvidia.com>
To: Donald Hunter <donald.hunter@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Andrew Lunn
	<andrew+netdev@lunn.ch>, Pavel Begunkov <asml.silence@gmail.com>, Jens Axboe
	<axboe@kernel.dk>
CC: Dragos Tatulea <dtatulea@nvidia.com>, Yael Chemla <ychemla@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <io-uring@vger.kernel.org>
Subject: [PATCH net-next v2 1/2] netdev: expose io_uring rx_page_order order via netlink
Date: Sat, 13 Jun 2026 00:17:03 +0300
Message-ID: <20260612211709.1456966-3-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260612211709.1456966-2-dtatulea@nvidia.com>
References: <20260612211709.1456966-2-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F2:EE_|CH3PR12MB9343:EE_
X-MS-Office365-Filtering-Correlation-Id: e8eff030-4231-4d8d-6cd5-08dec8c81aca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|376014|7416014|1800799024|82310400026|56012099006|6133799003|18002099003|22082099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	ExxYjqC0aAuNBR9EDnd7WVZPPQl++Ov/Bzeb0GGY5Nzm8h6WBuPfkz4ooTqoxbize9Bfr0NlldMRV5xkKF46skxuVoBIimpIFxQKJbDZpF+vmEyOGSeISsDF5GJiWtJwBpOBv5iEEFSUwLgvdALxMQLMHPdDD5OTyFv5RMbnowHbvRhbjkXC32YXe3teLoRQc3Zoc2UPHp71C8soY580cnMl+G4EjY/B5QJeSv8OaIoxru+obr5lMXf9GOC/vcZpbGrBMEVrqourpOP5rrdyvEonbeMC/J+KSl6yLo7YHPcVwoigjkjuRtMmGKe8phvlHIzKspq6df2MCBu06OeCjV6nBHoZBRue0SABSzmsC1xH6L1uQYrr0zOxP8qjrKXpdRAm+IpoYmOpHlyT/SygjkP2a0ZUc/q2WEl2UipnNa82Jy0g8lDCKv99pg3NN3kvaKJt/Rr0peSsB6LTBIn0ySa3sW0UXaY8LgsC4RLto3TlxHXu22vKPUKpCwJnEEtUyJyishU9l3OE9Z4Sl2HicmM62tt6C1RO8O+9G+OFWPR19UTTf6zbcvCDLTN9idqbw++wfXQmxB0vbbXLxszBLY509vKfouTaDnJpUpatB9/Vis6/O3oAme/8ZwOANLORgNagEWSq0QpbFV3OUxsKE2CFenvuN8inGuvGc7SSIjfiIh600izRwpUmn+JfAYnzZdZjngmMLco0lz8HZx3SVXE41MNMEYEtnnf2p5CnkHA=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(376014)(7416014)(1800799024)(82310400026)(56012099006)(6133799003)(18002099003)(22082099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	HTwOTFMGv5t7lREF1N9MKrKKCx3nr9PFUanJ3/MxR5P1IbUPeBSzbve9YNKGL+kVjLlMN+lT+8yZUuE4gko72w0v3E4ME9s6bb2AQ4McESK9rWbq5XXRX4NX1MY0akMP9nZhcm8aHVKPqgKS94/5cIOKCFVdWMNIgFc8Fbcd9JjwZ5idrjZDjdloqfQBr+ZSCMliG3sMra2jp2QFzI5Apxb9+mJTp6YSbpb4X48Tk8NMrQfzxCe60zNVMjFb9DY40sszsmNDk8f8zJzKoUADylZgSSicp0YTNkSP4km7k7nkxgRwgcR1FPTZucK80wbaOEro8yHEW6VT+wHTJLbPXvR019QSVLzx50zWnFNdQdprg9dlrI70OdyQ5nn3LnCS5ZfOww2bcA7pAWmsHVTLqMAXVuANXckZdARArjJ6B5AAEBUm3b1zNcfQXjpKE3qG
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2026 21:18:10.0324
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e8eff030-4231-4d8d-6cd5-08dec8c81aca
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9343
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.16 / 15.00];
	WHITELIST_DMARC(-7.00)[nvidia.com:D:+];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS(0.00)[m:donald.hunter@gmail.com,m:kuba@kernel.org,m:davem@davemloft.net,m:edumazet@google.com,m:pabeni@redhat.com,m:horms@kernel.org,m:andrew+netdev@lunn.ch,m:asml.silence@gmail.com,m:axboe@kernel.dk,m:dtatulea@nvidia.com,m:ychemla@nvidia.com,m:tariqt@nvidia.com,m:netdev@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:io-uring@vger.kernel.org,m:donaldhunter@gmail.com,m:andrew@lunn.ch,m:asmlsilence@gmail.com,s:lists@lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[15];
	TAGGED_FROM(0.00)[bounces-13710-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER(0.00)[dtatulea@nvidia.com,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com,kernel.org,davemloft.net,google.com,redhat.com,lunn.ch,kernel.dk];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dtatulea@nvidia.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[io-uring,netdev];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 388CE67C810

This adds observability for the io_uring zcrx rx-buf-len configuration.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Yael Chemla <ychemla@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 Documentation/netlink/specs/netdev.yaml | 9 ++++++++-
 include/uapi/linux/netdev.h             | 2 ++
 io_uring/zcrx.c                         | 8 ++++++++
 tools/include/uapi/linux/netdev.h       | 2 ++
 4 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/Documentation/netlink/specs/netdev.yaml b/Documentation/netlink/specs/netdev.yaml
index 49862b666d7d..5f143da7458c 100644
--- a/Documentation/netlink/specs/netdev.yaml
+++ b/Documentation/netlink/specs/netdev.yaml
@@ -127,7 +127,14 @@ attribute-sets:
         enum: xsk-flags
   -
     name: io-uring-provider-info
-    attributes: []
+    attributes:
+      -
+        name: rx-buf-len
+        type: uint
+        doc: |
+          RX buffer length in bytes for this io_uring memory provider.
+          Reflects the rx_buf_len passed at io_uring zerocopy rx
+          registration time.
   -
     name: page-pool
     attributes:
diff --git a/include/uapi/linux/netdev.h b/include/uapi/linux/netdev.h
index 7df1056a35fd..2f3ab75e8cc0 100644
--- a/include/uapi/linux/netdev.h
+++ b/include/uapi/linux/netdev.h
@@ -97,6 +97,8 @@ enum {
 };
 
 enum {
+	NETDEV_A_IO_URING_PROVIDER_INFO_RX_BUF_LEN = 1,
+
 	__NETDEV_A_IO_URING_PROVIDER_INFO_MAX,
 	NETDEV_A_IO_URING_PROVIDER_INFO_MAX = (__NETDEV_A_IO_URING_PROVIDER_INFO_MAX - 1)
 };
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 19837e0b5e91..c7b167c2d4e4 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -1156,6 +1156,7 @@ static void io_pp_zc_destroy(struct page_pool *pp)
 static int io_pp_nl_fill(void *mp_priv, struct sk_buff *rsp,
 			 struct netdev_rx_queue *rxq)
 {
+	struct io_zcrx_ifq *ifq = mp_priv;
 	struct nlattr *nest;
 	int type;
 
@@ -1163,6 +1164,13 @@ static int io_pp_nl_fill(void *mp_priv, struct sk_buff *rsp,
 	nest = nla_nest_start(rsp, type);
 	if (!nest)
 		return -EMSGSIZE;
+
+	if (nla_put_uint(rsp, NETDEV_A_IO_URING_PROVIDER_INFO_RX_BUF_LEN,
+			 1ULL << ifq->niov_shift)) {
+		nla_nest_cancel(rsp, nest);
+		return -EMSGSIZE;
+	}
+
 	nla_nest_end(rsp, nest);
 
 	return 0;
diff --git a/tools/include/uapi/linux/netdev.h b/tools/include/uapi/linux/netdev.h
index 7df1056a35fd..2f3ab75e8cc0 100644
--- a/tools/include/uapi/linux/netdev.h
+++ b/tools/include/uapi/linux/netdev.h
@@ -97,6 +97,8 @@ enum {
 };
 
 enum {
+	NETDEV_A_IO_URING_PROVIDER_INFO_RX_BUF_LEN = 1,
+
 	__NETDEV_A_IO_URING_PROVIDER_INFO_MAX,
 	NETDEV_A_IO_URING_PROVIDER_INFO_MAX = (__NETDEV_A_IO_URING_PROVIDER_INFO_MAX - 1)
 };
-- 
2.54.0


