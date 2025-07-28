Return-Path: <io-uring+bounces-8813-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B6EDB13975
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 13:03:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 145053BBB65
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 11:03:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2ABA25B1E0;
	Mon, 28 Jul 2025 11:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RI92G5kv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B28258CE1;
	Mon, 28 Jul 2025 11:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753700596; cv=none; b=jBXBQg6kkP1KwJNCMiU2W7F6Yrc87GzFnHI/3/gvbwXowB3PAHCKCYPwfMux+0GSEiVnRky+tkDNy9x8+iisQuqUJuZGkdfek21rr5kAuPDIzFeX/7m26yekt9lBbfnB/0Qo4y1uoAdT3RFuHkfurLF+lm6a8fR647HrR7vORzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753700596; c=relaxed/simple;
	bh=nt98/+dUvDaV3pmVfb4fvS7MDjaJqdIQxrJ94afFg9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L3BaJAEmxYxRnrSI4NB25MtehuXUpZ5K4ENvNl+HgQ0tUO7MCXOKLV2D2mGE9WDYokUY+pD18NgLroV2zoI0x26ATuJk5JmtTzwni6MqYOB672lbl4ue9BhMhPXmLFJhAOLftkSxzrUlWTSKxnqPBBuorauXOTio5okaqC2KMVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RI92G5kv; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-45610582d07so27357915e9.0;
        Mon, 28 Jul 2025 04:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753700593; x=1754305393; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4tnGyE7B6A5kamLsBFD83Ef/v+QAuu3xWVdVKx3sZHo=;
        b=RI92G5kv0RwLSXcNJavTPGGfEPjKTZgrC0DHt7HJJ/9z3WMvw7ys0t9kKIcOrknU4h
         woJLHH2hgOY9AJL323kO/PKgzPMrtBox/ynt4g1WxGMmGdfIFSsqXWiBfdNwRoem4x1I
         sqhafEvy9fziJP1DtAGDm9jYQHf33gwZGcf4qqIAZQrB/cihvJCRvCOX6zAxW4JmDuAZ
         akGF3RUGwA+rFqkNs5JNa8ekQ7vmu0hUHk3AH+y0fnxh1XNB+smBu/WHi1/D1AokqqCH
         mZy19ZkJ72rnUOR0P32Wa5LQXjbHB090WzpS+tHQbpa975YEhCsk0mh2q1Sl/6kNaY2l
         XMTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753700593; x=1754305393;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4tnGyE7B6A5kamLsBFD83Ef/v+QAuu3xWVdVKx3sZHo=;
        b=inZUz450Xz5+uyLvML11VEvKC9hMcgQJUpAZ+1s57YgnWDz8oe6Q7WIgInBGheq3EA
         rKhMCGJQafQfdoM8O/2bt/5WzMnhBEYcCoUM5K+KhaMZHGKexUhyJGEUjGrkEBL3qEUt
         xVP8LZzFyzQdnehGd4ivqSnHMnxE/59Th69TwUMDYhJyBGfDbIbM+q3LpfJzD4bHh8gD
         tRGEQo8dBhBRKrz6ZuAheu24kmKMsa6K3a/R/NBW2oHiupZ92V6lqsutICUNOJdblLbw
         rh44sJice2FIokFzlueFan5z6UroNk+AGrSldmiDUaxoKlpuSts2WAvq/fQCytX0o0+1
         8jrw==
X-Forwarded-Encrypted: i=1; AJvYcCWtegT8epMnpiPak9d0L0VWn/o4pFyATrSFkm5Z7OGiYlaSVo2P28k3YgiYo7MhLlGEIDEuzwdJ@vger.kernel.org, AJvYcCX4gkI3KuB8nlToa9z8I5scRmr+k1HfFJO9Ai15yD79cCjyaaVzwSgq4rHYfewEMGNu5iANo9xuXQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YztfpQZAtCWJ6m1xve9PJJ9vGN6siNyne1Vq5DCgX3gnHbuMQaI
	MdLAo0FIbY0yVVaMZwAznq3/e7QzFJx/26A7Yz/K04fmBhEh8yT1vUMA
X-Gm-Gg: ASbGncuaw251cFQokLUfW15FgQ2/7JYX8omolppambBbXDHrWqvuej9HXaFJtv78VzA
	sI/37hxyBFIxo16XXVCvSdEhirDX/KCylO9QpThyuYNaHCGy8O8RVDVpLbHxQcuYA06ki0OCopx
	Ke561MYQf+eTcLqJL1cWIZPcXmDgnMIvzCOQ41xUjmsS0mHlQ34CgM23nkRH1qAfYbkKbJPN1i0
	sA1ZeGk8feR6CKepaLhvb9A75VcxgbZUdLZxbP4P2kKYrll1SkRMsnsOXJdRt5iiztoI//1AX0h
	Lv/zGC+RktV06DloDzCk2SwfuM0f4Mrm/5XDSCXf+jte+1NnNNRn3aKpxXLk7YtC3EOEGpreJSC
	dv0QaCUMUK8NpSQ==
X-Google-Smtp-Source: AGHT+IHxceVoBwbFQdV7xUw1zCgTTtIsmKbiSs4gxuYIZiirRWhGPVJ0mla4HEpxcnu0oqsOdGy9IA==
X-Received: by 2002:a05:600c:3144:b0:456:1b6b:daaa with SMTP id 5b1f17b1804b1-4587644b039mr78380855e9.29.1753700592760;
        Mon, 28 Jul 2025 04:03:12 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:75])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458705c4fdasm157410235e9.28.2025.07.28.04.03.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 04:03:11 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>,
	netdev@vger.kernel.org
Cc: asml.silence@gmail.com,
	io-uring@vger.kernel.org,
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
	ap420073@gmail.com
Subject: [RFC v1 02/22] net: ethtool: report max value for rx-buf-len
Date: Mon, 28 Jul 2025 12:04:06 +0100
Message-ID: <6a3c35ea36adc1ee8fc3ae7a53c80d33cb903e2c.1753694913.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1753694913.git.asml.silence@gmail.com>
References: <cover.1753694913.git.asml.silence@gmail.com>
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
index 72a076b0e1b5..cb96b4e7093f 100644
--- a/Documentation/netlink/specs/ethtool.yaml
+++ b/Documentation/netlink/specs/ethtool.yaml
@@ -361,6 +361,9 @@ attribute-sets:
       -
         name: hds-thresh-max
         type: u32
+      -
+        name: rx-buf-len-max
+        type: u32
 
   -
     name: mm-stat
@@ -1811,6 +1814,7 @@ operations:
             - rx-jumbo
             - tx
             - rx-buf-len
+            - rx-buf-len-max
             - tcp-data-split
             - cqe-size
             - tx-push
diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index eaa9c17a3cb1..b7a99dfdffa9 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -893,6 +893,7 @@ Kernel response contents:
   ``ETHTOOL_A_RINGS_RX_JUMBO``              u32     size of RX jumbo ring
   ``ETHTOOL_A_RINGS_TX``                    u32     size of TX ring
   ``ETHTOOL_A_RINGS_RX_BUF_LEN``            u32     size of buffers on the ring
+  ``ETHTOOL_A_RINGS_RX_BUF_LEN_MAX``        u32     max size of rx buffers
   ``ETHTOOL_A_RINGS_TCP_DATA_SPLIT``        u8      TCP header / data split
   ``ETHTOOL_A_RINGS_CQE_SIZE``              u32     Size of TX/RX CQE
   ``ETHTOOL_A_RINGS_TX_PUSH``               u8      flag of TX Push mode
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index 45b8c9230184..7bdef64926c8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -376,6 +376,7 @@ static void otx2_get_ringparam(struct net_device *netdev,
 	ring->tx_max_pending = Q_COUNT(Q_SIZE_MAX);
 	ring->tx_pending = qs->sqe_cnt ? qs->sqe_cnt : Q_COUNT(Q_SIZE_4K);
 	kernel_ring->rx_buf_len = pfvf->hw.rbuf_len;
+	kernel_ring->rx_buf_len_max = 32768;
 	kernel_ring->cqe_size = pfvf->hw.xqe_size;
 }
 
@@ -398,7 +399,7 @@ static int otx2_set_ringparam(struct net_device *netdev,
 	/* Hardware supports max size of 32k for a receive buffer
 	 * and 1536 is typical ethernet frame size.
 	 */
-	if (rx_buf_len && (rx_buf_len < 1536 || rx_buf_len > 32768)) {
+	if (rx_buf_len && (rx_buf_len < 1536)) {
 		netdev_err(netdev,
 			   "Receive buffer range is 1536 - 32768");
 		return -EINVAL;
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 5e0dd333ad1f..dd9f253a56ae 100644
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
index aa8ab5227c1e..1a76e6789e33 100644
--- a/include/uapi/linux/ethtool_netlink_generated.h
+++ b/include/uapi/linux/ethtool_netlink_generated.h
@@ -164,6 +164,7 @@ enum {
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


