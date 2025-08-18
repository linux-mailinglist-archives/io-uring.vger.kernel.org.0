Return-Path: <io-uring+bounces-9037-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2994B2A940
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 16:17:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A354A625DB5
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 14:04:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A073F322C8A;
	Mon, 18 Aug 2025 13:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WIdky3NO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D069934575B;
	Mon, 18 Aug 2025 13:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525435; cv=none; b=ZDaH6Cjnkw4YPGo641JtDqnt5BB+jCwZcG6WczpuwYC54yBZ/7ObMfWtplJKrGwMaiYFjsAV/6T1Rxer/7qb22wsjZIpgUZ/KPt5nsWz7mpIoJDuQxfRnLFuSpZawQYhsfgxlFDICwAfih0ircEg7T++2cU2w7E8eLmT7u6bqAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525435; c=relaxed/simple;
	bh=kvdcNejWK/mOk04H688uEbaA/cC9mhfBNv/gUTpRf6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UmBTAn5QA4+I8GaoMMzgxmggjX4h6U2apaYUZ0XEuxYhrqHjhHBEpOIfwAqJZJaMAd+fkPTnS2ejA4W5vwTMxtLpu/1jO93jdRrqrUUV71wuP0bn0j3XbOclfAYfoKhZO1Sp3gKRSpNu1kj0+xtCygCQRz8OnyKaFPzml6UmtK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WIdky3NO; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3b9e4148134so2044027f8f.2;
        Mon, 18 Aug 2025 06:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755525432; x=1756130232; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8P7N+yGyf3ZHVe543mLefJ6kNjA/6azjCaZxnGN+ZPM=;
        b=WIdky3NONvYBlGtlBbIBgLKYrY9LsPUTI8k+SBuHWqs9JFozSr6oKzd1ESOrhX5rLA
         tNykC3vaN0gLqqvsCkE+2au8OjVSlVmlbaO0edI+jS2ghlqPxoWnlajtT6HAhlkg97ok
         aDQFmKHB7q09M8ChhhJlqlx7Bwx5MmtDccyIH6U9gXo5ckrBOLPN/CLJzAeNdslG22EK
         NqjMr4av/hB2IRuGncgkoGnK8B+nUS3BU/0ywipbJu0dp8RuacBD7GHyMcAvXr3EHfUn
         7Wl1IW+J6TvrNCkWiU4P1+DqJF3qj56GxHzsNheKwfnJlP+v0OcV0rYwu074dzC/mU+x
         I6ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755525432; x=1756130232;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8P7N+yGyf3ZHVe543mLefJ6kNjA/6azjCaZxnGN+ZPM=;
        b=b4hjcAYLMIe9LrQ3KYuUAF+EJFlAokNIiQC5OYNRe+3ognhIx1SsTZWsqVvXHhtY6n
         qQvhPWcestMWKUr+zRwKiovSXDyyvjHfu3p6sXlkELM88XSEQyR7cUXY5uJASz/fn8TH
         GcxIyvW3OnKJAUC+KrWe6edpgVCjxjZ19G77/slL39WJwA/g1Y9pQJUqPPnC624LGBGx
         jzFTgd1Wbuxp0pA/zebURpG68h00X+p+rCHe3Z4mvGHcyH1xHwQ1lmMTby3HD6FnjJ8d
         JsEgMnZanrYlr4B/y89VqMb/aSdlcHBDKbkKxaiTYK3UlHreLNPevsECDXUtaq6UzPSS
         PC/g==
X-Forwarded-Encrypted: i=1; AJvYcCUuk3DxjnPZ8RDxmgbT9fCkr+hTt27mekTnulbMaMB3+OTdGVH2qAYT/Ke4Ys0twYgZEO+PJ25pC+ADz3HI@vger.kernel.org, AJvYcCVgb/pD/DCboky7D00CExCiNeXb9JmHjk672wPBWLGeXTth3raSGNWic9KN4NhXFtLXS/m8brrG@vger.kernel.org, AJvYcCXCA7jdIGSDYCAf/65nw/NwEn48DjELfekaqRbEIHSb5CV2nMEXPV4cybmV3WkGWtW0KG/okk/RVw==@vger.kernel.org
X-Gm-Message-State: AOJu0YydQwUZyLSmqI6w7vjzyi27HD3UkrJUL0+woUjNYw4Zor408awj
	fXvFe2NIiDOAQM0aIPyU99W7UUTwV0lq2to5lqYrl7gOQp1Sc88h1onK
X-Gm-Gg: ASbGncv9szUSkTorFrpq7rHXDgOEWqkdJ0PT05r54Ht5+4iMVwVvMkPjGhl4eZRewNY
	nuQMnNyEW0tlLCF3W8hVYgOq+bSDwOu4dStxFGql2l+lzy2i6B/LsDbSlc/byWdeTTxdHdDaKcT
	9mvKOSsu7RPetzOxle6Yg/rkHJrvhhQSTWqjtIk5NwMssI3wic0HIwKFR6gaTIcRiGj+qa7R2dk
	1kiVAKKxWZb1dJxeVYPnjz1brUeDAUDuABsiDCnooc4FBdAzuujMtc+LPwY7A0V7t+sA3S+IZ0W
	tM/OfVzINTbi8vZhQfGAnPUe302QuTsZbPZcsFR+VvpZLagfy3h/ZYl/eP0KiZqnLe8CajrPkLE
	gkzR2tor80QeOvKAhfNnwxf8b1VZ4yMFG4A==
X-Google-Smtp-Source: AGHT+IGWcAV4vtQFInltL7YhCyhg4u98E5AGYiBsEz3MCfv8Oh389GRDiiy5jbzrpgyxE5yXbUIyig==
X-Received: by 2002:a05:6000:2893:b0:3b9:48f:1960 with SMTP id ffacd0b85a97d-3bb692bcf88mr10059635f8f.49.1755525431897;
        Mon, 18 Aug 2025 06:57:11 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1b899338sm91187345e9.7.2025.08.18.06.57.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 06:57:11 -0700 (PDT)
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
Subject: [PATCH net-next v3 22/23] net: let pp memory provider to specify rx buf len
Date: Mon, 18 Aug 2025 14:57:38 +0100
Message-ID: <65819c0768920744b4f388a154ea7b8e7c4a85e3.1755499376.git.asml.silence@gmail.com>
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

Allow memory providers to configure rx queues with a specific receive
buffer length. Pass it in sturct pp_memory_provider_params, which is
copied into the queue, and make __netdev_queue_config() to check if it's
present and apply to the configuration. This way the configured length
will persist across queue restarts, and will be automatically removed
once a memory provider is detached.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/net/page_pool/types.h |  1 +
 net/core/netdev_config.c      | 15 +++++++++++----
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/include/net/page_pool/types.h b/include/net/page_pool/types.h
index 1509a536cb85..be74e4aec7b5 100644
--- a/include/net/page_pool/types.h
+++ b/include/net/page_pool/types.h
@@ -161,6 +161,7 @@ struct memory_provider_ops;
 struct pp_memory_provider_params {
 	void *mp_priv;
 	const struct memory_provider_ops *mp_ops;
+	u32 rx_buf_len;
 };
 
 struct page_pool {
diff --git a/net/core/netdev_config.c b/net/core/netdev_config.c
index c5ae39e76f40..2c9b06f94e01 100644
--- a/net/core/netdev_config.c
+++ b/net/core/netdev_config.c
@@ -2,6 +2,7 @@
 
 #include <linux/netdevice.h>
 #include <net/netdev_queues.h>
+#include <net/netdev_rx_queue.h>
 
 #include "dev.h"
 
@@ -77,7 +78,7 @@ void netdev_queue_config_update_cnt(struct net_device *dev, unsigned int txq,
 	}
 }
 
-void __netdev_queue_config(struct net_device *dev, int rxq,
+void __netdev_queue_config(struct net_device *dev, int rxq_idx,
 			   struct netdev_queue_config *qcfg, bool pending)
 {
 	const struct netdev_config *cfg;
@@ -88,18 +89,24 @@ void __netdev_queue_config(struct net_device *dev, int rxq,
 
 	/* Get defaults from the driver, in case user config not set */
 	if (dev->queue_mgmt_ops->ndo_queue_cfg_defaults)
-		dev->queue_mgmt_ops->ndo_queue_cfg_defaults(dev, rxq, qcfg);
+		dev->queue_mgmt_ops->ndo_queue_cfg_defaults(dev, rxq_idx, qcfg);
 
 	/* Set config based on device-level settings */
 	if (cfg->rx_buf_len)
 		qcfg->rx_buf_len = cfg->rx_buf_len;
 
 	/* Set config dedicated to this queue */
-	if (rxq >= 0) {
-		const struct netdev_queue_config *user_cfg = &cfg->qcfg[rxq];
+	if (rxq_idx >= 0) {
+		const struct netdev_queue_config *user_cfg;
+		struct netdev_rx_queue *rxq;
 
+		user_cfg = &cfg->qcfg[rxq_idx];
 		if (user_cfg->rx_buf_len)
 			qcfg->rx_buf_len = user_cfg->rx_buf_len;
+
+		rxq = __netif_get_rx_queue(dev, rxq_idx);
+		if (rxq->mp_params.mp_ops && rxq->mp_params.rx_buf_len)
+			qcfg->rx_buf_len = rxq->mp_params.rx_buf_len;
 	}
 }
 
-- 
2.49.0


