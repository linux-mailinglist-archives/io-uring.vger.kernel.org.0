Return-Path: <io-uring+bounces-9018-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E9DBB2A8BF
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 16:08:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B7AB683527
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 13:57:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7FE72C235D;
	Mon, 18 Aug 2025 13:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RYf9Rnmm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0292D320CD2;
	Mon, 18 Aug 2025 13:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525398; cv=none; b=G41LsP7fBp6KAfQrnO+DhkOB4yKRc1NsNy50rTSHmwjxufkNiaqTguanxe08fqmpEid9n65hqHx3nyccACqY/mcGvlgFQsXeVTSlH7tGKT7opnQGoqt1Go1CjJRWzh7NsaqPmvL/Vj9DUZLu+EvVI8r3v7ukewcvE/Zvl4dL7RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525398; c=relaxed/simple;
	bh=bqr/4FG2WJKztMJmWFJddItDYg3tny/KNXgD2iRgMFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oVhQUPJE1rhF0snw0sL2ysuGjdXrCXTq2yFDz4YbDA1TQGQdrQ0ol9U/QzIL5GhipvvkeqjzvbdFetJXlTwYFeJ2A0msqMalU/Ce01maZiHU52kfmRm6h2FNd8Xt6bbwq2j2Om1NVRO4amx4zK7mlgcDBzPtzq2yUHjjvPAyBAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RYf9Rnmm; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3b9d41c1963so2024222f8f.0;
        Mon, 18 Aug 2025 06:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755525395; x=1756130195; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cvm2UJ4oSeMfT196qjYy/oWetXEATWOESCbHdqLvAFk=;
        b=RYf9Rnmmo6FuhQkXs+7zcyDZJ/Zbph6jPGAdX0oApSx41+oNn2QhvbPx1Zs7td8VDk
         7PaBjddkIVGRBg9C8F/LVCiTZK2PbOw1pBqFlRF7HL8/EGLr5sNV9jwRilnxa9y7MC0h
         7zUHlorgGx8UIIxbOL73Cgv8RGERv9NiFX34JL4YULFOHTGlNtwl+mwBZzRgtvxE9pmu
         QBz36z2JXJcj/4hLr4Z60Xpu2VhcJeW6cfiF2ys1JgMNO3bY0N30CuWQ0hdGj656PHJf
         SmQoBCH+t8VbTrkkpPPQuVAxuWXfAfwIXib6AGA82wLN+UxLabUniKecL8goUULbJq7g
         YcVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755525395; x=1756130195;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cvm2UJ4oSeMfT196qjYy/oWetXEATWOESCbHdqLvAFk=;
        b=qA5VDwagtBi2Ngxruv9NBElqQ+XLFowZqoTH9erfdaON1LxtxYqSDsiq2YaDF3OYZZ
         Cep3q04L0RBLnQJku5yt+Qr2jK2ZaQlyc1KYFkNjgdn74nUXmcDYibzxMDynhTL1RIFK
         xZIL9K2FKhBm80uClQLES7iHdNUxcxMe1XpPmYiFRU3pgMInB+CrQwAi5uK+Wm9aTqxK
         n/MF4HCHU1U4AcGfeOE23JWWnH+FR1xvM2rtkjmQjpBh9bb04wltjKh8VJ/xlaJzntWk
         8+KDUECa34qZ/kkSA2Ny26adiah8IMkhPZIED8E09qsiiBdzjONkbMsJys7vIEVad2Oe
         RBeg==
X-Forwarded-Encrypted: i=1; AJvYcCVgSvkE+1e+OuuLCF8rJ7d75iQLX+147yBshujxX3wYcHItMj6v4rD7tvag02ZGjvyuBtnj7nQBCg==@vger.kernel.org, AJvYcCWazGoSxbUES0QVrXh+08gMJKaMp3zv6H0QD/1U1a6E70zd+he+QUKOHW0xxJIB+isJ94pKj/Cv@vger.kernel.org, AJvYcCWjALIUTEmncbWJR1TCF9vzJbG3eAChopnkLWWDJRHs8z1QErbFHFQOdCU8CvamitjoUStGM6iZzj3xyy7H@vger.kernel.org
X-Gm-Message-State: AOJu0YwEQ1pu5CKWPNDOtZSbmS0Fli2dp8g8wksQkMd0h95wn3bknc47
	AIW8iZDs4IWkNqqVsGAX0iewneMO8Pi4dhmeO640+vwZz/bGdeJJZvvXukacJg==
X-Gm-Gg: ASbGncu4c7tPeha/fB7Nf4VvROqsFPlR+TYxntvMuBwbHJZ1M/bYlpRsiy4DtkF4xBI
	NjsuOZCG7j1QvpCskXs217LHXNAPSTaCVUQghHY8uv7R/d8u8xRGMXLzO3T4H+GFqM72/WgONXj
	wMG91FowkWvb4uPt6OsRUfzb9Fg5fuzVKe/NuaPPx55AomjiEBgBy0+j/YgkCa/9s7eFp9v2ROa
	2lmnTEjwd9xwg4m4p1L/es0wpynFlQpv28U8wuTU/SjwtW008w1NRkBLEwzXDQOgRzP1r2uo63a
	g36NWhWTGSibZXXSPMz8ChR/EgP2F/mb/40qzlFBsCpQQ5qJiZsP4JSiejmo/P2y4LQBfg8kv64
	vgqHQZzwpfu/hBUzUXHsWYEO7D7AL6cfpJQgq32RA9tCG
X-Google-Smtp-Source: AGHT+IGlEZyDVaR4a6eFUw2ewS03D+emdOqr8pwqvhUlZLQvyIp8DwaBRWOYPPldumCrU2IMssDrGg==
X-Received: by 2002:a5d:5f86:0:b0:3b8:d15e:ed35 with SMTP id ffacd0b85a97d-3bc68b89f7amr6506927f8f.23.1755525395142;
        Mon, 18 Aug 2025 06:56:35 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1b899338sm91187345e9.7.2025.08.18.06.56.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 06:56:34 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>,
	netdev@vger.kernel.org
Cc: asml.silence@gmail.com,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	andrew+netdev@lunn.ch,
	horms@kernel.org,
	davem@davemloft.net,
	sdf@fomichev.me,
	almasrymina@google.com,
	dw@davidwei.uk,
	michael.chan@broadcom.com,
	dtatulea@nvidia.com,
	ap420073@gmail.com,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: [PATCH net-next v3 03/23] net: ethtool: report max value for rx-buf-len
Date: Mon, 18 Aug 2025 14:57:19 +0100
Message-ID: <d25ecf7a633d5ec6d86e667ef3f86a13ea1a242b.1755499376.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1755499375.git.asml.silence@gmail.com>
References: <cover.1755499375.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jakub Kicinski <kuba@kernel.org>

Unlike most of our APIs the rx-buf-len param does not have an associated
max value. In theory user could set this value pretty high, but in
practice most NICs have limits due to the width of the length fields
in the descriptors.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 Documentation/netlink/specs/ethtool.yaml                  | 4 ++++
 Documentation/networking/ethtool-netlink.rst              | 1 +
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c | 3 ++-
 include/linux/ethtool.h                                   | 2 ++
 include/uapi/linux/ethtool_netlink_generated.h            | 1 +
 net/ethtool/rings.c                                       | 5 +++++
 6 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/Documentation/netlink/specs/ethtool.yaml b/Documentation/netlink/specs/ethtool.yaml
index 1bc1bd7d33c2..a88e3c4fcc6f 100644
--- a/Documentation/netlink/specs/ethtool.yaml
+++ b/Documentation/netlink/specs/ethtool.yaml
@@ -449,6 +449,9 @@ attribute-sets:
       -
         name: hds-thresh-max
         type: u32
+      -
+        name: rx-buf-len-max
+        type: u32
 
   -
     name: mm-stat
@@ -2046,6 +2049,7 @@ operations:
             - rx-jumbo
             - tx
             - rx-buf-len
+            - rx-buf-len-max
             - tcp-data-split
             - cqe-size
             - tx-push
diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index cae372f719d1..05a7f6b3f945 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -902,6 +902,7 @@ Kernel response contents:
   ``ETHTOOL_A_RINGS_RX_JUMBO``              u32     size of RX jumbo ring
   ``ETHTOOL_A_RINGS_TX``                    u32     size of TX ring
   ``ETHTOOL_A_RINGS_RX_BUF_LEN``            u32     size of buffers on the ring
+  ``ETHTOOL_A_RINGS_RX_BUF_LEN_MAX``        u32     max size of rx buffers
   ``ETHTOOL_A_RINGS_TCP_DATA_SPLIT``        u8      TCP header / data split
   ``ETHTOOL_A_RINGS_CQE_SIZE``              u32     Size of TX/RX CQE
   ``ETHTOOL_A_RINGS_TX_PUSH``               u8      flag of TX Push mode
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index 998c734ff839..1c8a7ee2e459 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -377,6 +377,7 @@ static void otx2_get_ringparam(struct net_device *netdev,
 	ring->tx_max_pending = Q_COUNT(Q_SIZE_MAX);
 	ring->tx_pending = qs->sqe_cnt ? qs->sqe_cnt : Q_COUNT(Q_SIZE_4K);
 	kernel_ring->rx_buf_len = pfvf->hw.rbuf_len;
+	kernel_ring->rx_buf_len_max = 32768;
 	kernel_ring->cqe_size = pfvf->hw.xqe_size;
 }
 
@@ -399,7 +400,7 @@ static int otx2_set_ringparam(struct net_device *netdev,
 	/* Hardware supports max size of 32k for a receive buffer
 	 * and 1536 is typical ethernet frame size.
 	 */
-	if (rx_buf_len && (rx_buf_len < 1536 || rx_buf_len > 32768)) {
+	if (rx_buf_len && (rx_buf_len < 1536)) {
 		netdev_err(netdev,
 			   "Receive buffer range is 1536 - 32768");
 		return -EINVAL;
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index de5bd76a400c..9267bac16195 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -77,6 +77,7 @@ enum {
 /**
  * struct kernel_ethtool_ringparam - RX/TX ring configuration
  * @rx_buf_len: Current length of buffers on the rx ring.
+ * @rx_buf_len_max: Max length of buffers on the rx ring.
  * @tcp_data_split: Scatter packet headers and data to separate buffers
  * @tx_push: The flag of tx push mode
  * @rx_push: The flag of rx push mode
@@ -89,6 +90,7 @@ enum {
  */
 struct kernel_ethtool_ringparam {
 	u32	rx_buf_len;
+	u32	rx_buf_len_max;
 	u8	tcp_data_split;
 	u8	tx_push;
 	u8	rx_push;
diff --git a/include/uapi/linux/ethtool_netlink_generated.h b/include/uapi/linux/ethtool_netlink_generated.h
index e3b8813465d7..8b293d3499f1 100644
--- a/include/uapi/linux/ethtool_netlink_generated.h
+++ b/include/uapi/linux/ethtool_netlink_generated.h
@@ -192,6 +192,7 @@ enum {
 	ETHTOOL_A_RINGS_TX_PUSH_BUF_LEN_MAX,
 	ETHTOOL_A_RINGS_HDS_THRESH,
 	ETHTOOL_A_RINGS_HDS_THRESH_MAX,
+	ETHTOOL_A_RINGS_RX_BUF_LEN_MAX,
 
 	__ETHTOOL_A_RINGS_CNT,
 	ETHTOOL_A_RINGS_MAX = (__ETHTOOL_A_RINGS_CNT - 1)
diff --git a/net/ethtool/rings.c b/net/ethtool/rings.c
index aeedd5ec6b8c..5e872ceab5dd 100644
--- a/net/ethtool/rings.c
+++ b/net/ethtool/rings.c
@@ -105,6 +105,9 @@ static int rings_fill_reply(struct sk_buff *skb,
 			  ringparam->tx_pending)))  ||
 	    (kr->rx_buf_len &&
 	     (nla_put_u32(skb, ETHTOOL_A_RINGS_RX_BUF_LEN, kr->rx_buf_len))) ||
+	    (kr->rx_buf_len_max &&
+	     (nla_put_u32(skb, ETHTOOL_A_RINGS_RX_BUF_LEN_MAX,
+			  kr->rx_buf_len_max))) ||
 	    (kr->tcp_data_split &&
 	     (nla_put_u8(skb, ETHTOOL_A_RINGS_TCP_DATA_SPLIT,
 			 kr->tcp_data_split))) ||
@@ -281,6 +284,8 @@ ethnl_set_rings(struct ethnl_req_info *req_info, struct genl_info *info)
 		err_attr = tb[ETHTOOL_A_RINGS_TX];
 	else if (kernel_ringparam.hds_thresh > kernel_ringparam.hds_thresh_max)
 		err_attr = tb[ETHTOOL_A_RINGS_HDS_THRESH];
+	else if (kernel_ringparam.rx_buf_len > kernel_ringparam.rx_buf_len_max)
+		err_attr = tb[ETHTOOL_A_RINGS_RX_BUF_LEN];
 	else
 		err_attr = NULL;
 	if (err_attr) {
-- 
2.49.0


