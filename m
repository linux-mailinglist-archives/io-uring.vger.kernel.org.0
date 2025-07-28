Return-Path: <io-uring+bounces-8823-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C514FB13990
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 13:05:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 74D891885EB2
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 11:04:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E435A262FE7;
	Mon, 28 Jul 2025 11:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K8hLTuEo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212B525A33F;
	Mon, 28 Jul 2025 11:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753700612; cv=none; b=lmg8pUKtdL7danP3EADFhoy7fH8BexW3xOJS0TFwgseZZQfUAqyF1Ep5NKmqPKm+LDUc6GWihsAl1uoSW2cb+BgdyEjr1q6tZbhAptj4SvRmvIsst7PNiHj+m09PQu6xHje1lgowx+un0OfFQO6E5NdKAT/QYA3UTLxHyqO8y/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753700612; c=relaxed/simple;
	bh=/RbydN0fLq3E9H+CpPbUeIqT0yfY0ANyDqk/hOaOyU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T41sx+gPJZHDx3+5N/chfrQKwEtHJbcubmYbDS313jumA1mK2uHhIbrze2PgcD0J0/+/vt6m+k2jxn91ejcOrpbF8unQRZDT9T3auu9nljSxe8Mq1dCa6r02SFsTmjOC1smih3xVoZujCJ00126GEdJr+V5MJAn5l7zY7+LJ5L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K8hLTuEo; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-45617887276so25038145e9.2;
        Mon, 28 Jul 2025 04:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753700609; x=1754305409; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9FQmZI+Yj180xqtxhNYw9x8ChNwMJ8USGmXaiHTDZcc=;
        b=K8hLTuEoGNtpantCv+nx+1jZ0zbRiLc+g+TXJXUfzBsZlZ4Hm1LRVpxPgbknfnXdu8
         MjozqPDwmxWgfxpGTL2+6z6dNfb72x95ml8+mKmT49zEyZ6nKc3A75u8wVZHUkw4nrUF
         Pi7FADg4Q0PzSmSia2IOEwBPUPqkoVO1N15dIGBtgyIY2SPKZhumAgCMsq0UN4zhBpkC
         RhOda0k9KlWSFnPZM98f/Zd6dQzonduT6D6+OlQOzW5oMf04RpwxkR6ACbDkO6MQ+K/I
         MTy3LN6e+2ZHuFlA4qFLk7OQey0T+Mkm48xHiqN48gkjI9uLlAWKP5MMwHyliD05ED4M
         /KiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753700609; x=1754305409;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9FQmZI+Yj180xqtxhNYw9x8ChNwMJ8USGmXaiHTDZcc=;
        b=qw0BfVtANGaK7kJdWp+y1D51QPwiKgJ6OjQBqjNdNHV5TacLvG/WoTSs5+GJcnJe7H
         7wEk/SQpT/h+Nwv/PG5WQdA4vOy4q7Pk5f8QMvsZ42NhUb62pT3Abu1ZDhNi/7kRSJkX
         iCVQxHQRqZXTbBpq21/Xr0oEXu908qROHXcJ8B6VyjH4e/gkRh6Kkd8C81dh1/RbYjcb
         uGmOXoSFwfiPXS5kRnyLY4LnRZ58s+nBZA0vt1NMvTtCiKZF1zXl0JBcifGwEAw7zZkU
         hw9D6J92wuEx7MvvfoDhHInFBJCDqF4IVIuwEIr4OsYgBlOPLc9x2qSxF0QAbeZ8hIIY
         wp8g==
X-Forwarded-Encrypted: i=1; AJvYcCWeyEsuBs+NfD/un9cCe1GNy9YGnSHKrhpll8vkqMK/y0QvLMilGqGHlrVKgeqezZGrogiOpHNEAg==@vger.kernel.org, AJvYcCXj8l1b4K8QTcBcgEWs5658zVc3rH1rXCClzHLrW/5IgdK9WVFI5kuG/9kc6cIonszaadVqSJAt@vger.kernel.org
X-Gm-Message-State: AOJu0YwqlIdjveQxN2Acyq7qkhPJ24cewtUTJH9ztsGEX6KY53ant7ed
	+1goTEFwTII9cuCeDnvsNCEvLO5GZH+EMweS2hlQq4xiXezX737G24x9
X-Gm-Gg: ASbGncvYQ2NTNusTWB7HFBWgYKybUjmSqJr+3PLx90PGTVi4RpqvyL9vo7sW9V2Wtf5
	2s21U24VyCa5O4FVcJhHq+L/OyMErCfHpkqt9xCFJ9zpt6FU+DWLovf/LptsbWvb16aXAv4bOS1
	LW/IlLZAnmWCcbWhl2CbPOqlaXgfDOwDLMQKkovak9qSF6LpxAYX2eyM7KjDaeA6w3WJmkNGksO
	4YbTPO/L/cSFPFWUYUyiFT2jyBOQ04jaDuHbTFEQ3QMOu6w2Oy294NSq1jXDEWpt95LiXD1U1Hj
	U9hNYivPQzJUJgPTRxTntXHOoWbs/7ZS00rMsNC8kND19C89mqoF/Hh/BMRRo/UtZiLWv4Rajw9
	M2Bs=
X-Google-Smtp-Source: AGHT+IEheOkBgjM5R8mDEHeOr96JDidOqY5XBOSqiRWS14d8gGpt8E/S4EcFg+fPiVqMmLJ1iSkSjQ==
X-Received: by 2002:a05:600c:468d:b0:456:1752:2b44 with SMTP id 5b1f17b1804b1-4587654e5fcmr71846345e9.23.1753700609244;
        Mon, 28 Jul 2025 04:03:29 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:75])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458705c4fdasm157410235e9.28.2025.07.28.04.03.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 04:03:28 -0700 (PDT)
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
Subject: [RFC v1 12/22] net: pass extack to netdev_rx_queue_restart()
Date: Mon, 28 Jul 2025 12:04:16 +0100
Message-ID: <0d35354649ce2c3b1c665f27913cc663ed8646fd.1753694913.git.asml.silence@gmail.com>
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

Pass extack to netdev_rx_queue_restart(). Subsequent change will need it.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 2 +-
 drivers/net/netdevsim/netdev.c            | 2 +-
 include/net/netdev_rx_queue.h             | 3 ++-
 net/core/netdev_rx_queue.c                | 7 ++++---
 4 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index c3195be0ac26..b5f7a65bf678 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11518,7 +11518,7 @@ static void bnxt_irq_affinity_notify(struct irq_affinity_notify *notify,
 
 	netdev_lock(irq->bp->dev);
 	if (netif_running(irq->bp->dev)) {
-		err = netdev_rx_queue_restart(irq->bp->dev, irq->ring_nr);
+		err = netdev_rx_queue_restart(irq->bp->dev, irq->ring_nr, NULL);
 		if (err)
 			netdev_err(irq->bp->dev,
 				   "RX queue restart failed: err=%d\n", err);
diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index 03003adc41fb..a759424cfde5 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -800,7 +800,7 @@ nsim_qreset_write(struct file *file, const char __user *data,
 	}
 
 	ns->rq_reset_mode = mode;
-	ret = netdev_rx_queue_restart(ns->netdev, queue);
+	ret = netdev_rx_queue_restart(ns->netdev, queue, NULL);
 	ns->rq_reset_mode = 0;
 	if (ret)
 		goto exit_unlock;
diff --git a/include/net/netdev_rx_queue.h b/include/net/netdev_rx_queue.h
index 8cdcd138b33f..a7def1f94823 100644
--- a/include/net/netdev_rx_queue.h
+++ b/include/net/netdev_rx_queue.h
@@ -56,6 +56,7 @@ get_netdev_rx_queue_index(struct netdev_rx_queue *queue)
 	return index;
 }
 
-int netdev_rx_queue_restart(struct net_device *dev, unsigned int rxq);
+int netdev_rx_queue_restart(struct net_device *dev, unsigned int rxq,
+			    struct netlink_ext_ack *extack);
 
 #endif
diff --git a/net/core/netdev_rx_queue.c b/net/core/netdev_rx_queue.c
index d8a710db21cd..b0523eb44e10 100644
--- a/net/core/netdev_rx_queue.c
+++ b/net/core/netdev_rx_queue.c
@@ -10,7 +10,8 @@
 #include "dev.h"
 #include "page_pool_priv.h"
 
-int netdev_rx_queue_restart(struct net_device *dev, unsigned int rxq_idx)
+int netdev_rx_queue_restart(struct net_device *dev, unsigned int rxq_idx,
+			    struct netlink_ext_ack *extack)
 {
 	struct netdev_rx_queue *rxq = __netif_get_rx_queue(dev, rxq_idx);
 	const struct netdev_queue_mgmt_ops *qops = dev->queue_mgmt_ops;
@@ -136,7 +137,7 @@ int __net_mp_open_rxq(struct net_device *dev, unsigned int rxq_idx,
 #endif
 
 	rxq->mp_params = *p;
-	ret = netdev_rx_queue_restart(dev, rxq_idx);
+	ret = netdev_rx_queue_restart(dev, rxq_idx, extack);
 	if (ret) {
 		rxq->mp_params.mp_ops = NULL;
 		rxq->mp_params.mp_priv = NULL;
@@ -179,7 +180,7 @@ void __net_mp_close_rxq(struct net_device *dev, unsigned int ifq_idx,
 
 	rxq->mp_params.mp_ops = NULL;
 	rxq->mp_params.mp_priv = NULL;
-	err = netdev_rx_queue_restart(dev, ifq_idx);
+	err = netdev_rx_queue_restart(dev, ifq_idx, NULL);
 	WARN_ON(err && err != -ENETDOWN);
 }
 
-- 
2.49.0


