Return-Path: <io-uring+bounces-5935-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F26FA14548
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 00:18:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 97ECB16B918
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 23:18:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DDBE244FB6;
	Thu, 16 Jan 2025 23:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="Rs06UutY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880272442C6
	for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 23:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737069443; cv=none; b=KPJ2B0a6P9Gwg8dW5qS2i9X3TNYAwTWEYVeEfcWU3pN5MHPQhQHXECRicPDwk/KqUeHP9XFr4Hlpy0x1JS07F66NmqBmnFFmAy91v4rzyYnwP0KH2BSZcjBN2NxFqYA4+WOB8ttBRD83l278cv4yjleIYFsaFNBOWRwb7Sj/Sh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737069443; c=relaxed/simple;
	bh=ni+GBCJpV+6e9Z3Jx+ASe5psY3mF/X+C2+8/GRsJcxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gojqX0XcYRRTT0J+1SHHcfmq0w82hErqRIb2VI3ip/mCVoOgLDnKGpGdU0dvnC6lF69fe30Pqv0CKTfTPSsnA9yYCY9f1zatTYdIdF28gGSN2QeSYXJ7dhM4BXvjukd5Y+fuHGAlDpwcee6Id9jGpPtk7sA+ZKW1+TEWAcBWTH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=Rs06UutY; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-21644aca3a0so34604915ad.3
        for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 15:17:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1737069440; x=1737674240; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kNe5O6sLZLRlzUpONmh0BhOdwH0c/mpvhiy7fWtyNiI=;
        b=Rs06UutYlsnhpgzvSNFfgyJIVRU4l0AcgCtBvZi09Wxd+e8cXken7IlHlEjKd60Auu
         5onojg0PGDSW3qSjuvrECOqkllCnwjAvEIkgLBmBwrP9U4x9+4neS/lyROHMZjj1uluI
         FxaHx49+DF5RcPd1LPF/qgMMv+Wa8tonaDUsZFAYdDXFFsCy4yayoJ++4eI0CruRVZ8n
         cQK3PgdawqfijStdqc2r9spxyzVrBd3eQrmhR6s58EBEvIvh2GeXcYQB/x4OWENB2/wg
         S8FWR4D54vPaJq2kWlByJDkZxGQfHtlXpaDrIOGZL+4BX4Rx2N3k4GeLWV5DgrG1BdBh
         VzbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737069440; x=1737674240;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kNe5O6sLZLRlzUpONmh0BhOdwH0c/mpvhiy7fWtyNiI=;
        b=jNpBgn5SgwmzKweXJ6gJkXb8I3iWQ1AE8Vpy1NhFjeP/8Sn5P5PP5j7nRwTWMwOZ+H
         FbWd1VyntUrEX7oe61iLHnqfkI5Fol1hgKLeuwh6xke12ARLHUV5H5of0R5FJFwsh3Rm
         HDMtfjoRKT8eUex5otsSCxgmF0LCejoNz+XjuwFanfcExT5xfjb0xOndFycF6w8zhQlT
         GgjJgcuERR20DEmkmWCCIONY6WJLnq+H2ntzk+NOAWAMgD7pWCEIKU5Xo0ff35z0ZHKl
         7aJI1ysm6PLgctwLr0oH2Edv3wQ1OfB+JSKhtGM7WPtlVmUh4jW4ndhhul4l2Y7CKp/Q
         UBKw==
X-Gm-Message-State: AOJu0Yw885dRIbgPO/baWDUKfArZtj+xQC8wSqMHY+gxbX0AqiQ0X/lb
	IB+FcUnU5/2my42oH4vQ7jpMh5XSx3WWUcVwj23taLfzr2LlZazGZJ06/coUYm5TiBzWUOzfc5p
	V
X-Gm-Gg: ASbGncva94QBuBuGmWvyYxJbrA4KRRqdXcnG4pJ2/BOacO+VndQ6Lg3Ne7Xpf6LZMR7
	F27/w0p22AkTNeQ6jltgNpCVbBmbSLxbOXlb8pTkZI1lR8lJH8We9SVf8LTV19/MK1MH+kdSGrB
	R+aS8EueW7NKWrF/iUMsiv2F8QgGHxBvno3SGthU63wCYmeXkmKqZ3gt+RFL8+9VcA9s1rkRmP3
	fQCvHTK2ClcjNmm0or0s36gZdAIC45mMBm3Kg7J//6f2l7lznE=
X-Google-Smtp-Source: AGHT+IFPCVAzi3Y7iLEYB+1MNFlWMBosh0pxQi8qGeMSUjYARBehDaU52qL2+q2dZYAo0YhvuCRF+A==
X-Received: by 2002:a05:6a00:330b:b0:724:59e0:5d22 with SMTP id d2e1a72fcca58-72dafba2625mr993459b3a.20.1737069439794;
        Thu, 16 Jan 2025 15:17:19 -0800 (PST)
Received: from localhost ([2a03:2880:ff::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72dab9c9462sm547474b3a.100.2025.01.16.15.17.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2025 15:17:19 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Stanislav Fomichev <stfomichev@gmail.com>,
	Joe Damato <jdamato@fastly.com>,
	Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v11 10/21] net: add helpers for setting a memory provider on an rx queue
Date: Thu, 16 Jan 2025 15:16:52 -0800
Message-ID: <20250116231704.2402455-11-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250116231704.2402455-1-dw@davidwei.uk>
References: <20250116231704.2402455-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add helpers that properly prep or remove a memory provider for an rx
queue then restart the queue.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/net/page_pool/memory_provider.h |  5 ++
 net/core/netdev_rx_queue.c              | 66 +++++++++++++++++++++++++
 2 files changed, 71 insertions(+)

diff --git a/include/net/page_pool/memory_provider.h b/include/net/page_pool/memory_provider.h
index 4f0ffb8f6a0a..b3e665897767 100644
--- a/include/net/page_pool/memory_provider.h
+++ b/include/net/page_pool/memory_provider.h
@@ -22,6 +22,11 @@ bool net_mp_niov_set_dma_addr(struct net_iov *niov, dma_addr_t addr);
 void net_mp_niov_set_page_pool(struct page_pool *pool, struct net_iov *niov);
 void net_mp_niov_clear_page_pool(struct net_iov *niov);
 
+int net_mp_open_rxq(struct net_device *dev, unsigned ifq_idx,
+		    struct pp_memory_provider_params *p);
+void net_mp_close_rxq(struct net_device *dev, unsigned ifq_idx,
+		      struct pp_memory_provider_params *old_p);
+
 /**
   * net_mp_netmem_place_in_cache() - give a netmem to a page pool
   * @pool:      the page pool to place the netmem into
diff --git a/net/core/netdev_rx_queue.c b/net/core/netdev_rx_queue.c
index e217a5838c87..e934568d4cd9 100644
--- a/net/core/netdev_rx_queue.c
+++ b/net/core/netdev_rx_queue.c
@@ -3,6 +3,7 @@
 #include <linux/netdevice.h>
 #include <net/netdev_queues.h>
 #include <net/netdev_rx_queue.h>
+#include <net/page_pool/memory_provider.h>
 
 #include "page_pool_priv.h"
 
@@ -79,3 +80,68 @@ int netdev_rx_queue_restart(struct net_device *dev, unsigned int rxq_idx)
 
 	return err;
 }
+
+static int __net_mp_open_rxq(struct net_device *dev, unsigned ifq_idx,
+			     struct pp_memory_provider_params *p)
+{
+	struct netdev_rx_queue *rxq;
+	int ret;
+
+	if (ifq_idx >= dev->real_num_rx_queues)
+		return -EINVAL;
+	ifq_idx = array_index_nospec(ifq_idx, dev->real_num_rx_queues);
+
+	rxq = __netif_get_rx_queue(dev, ifq_idx);
+	if (rxq->mp_params.mp_ops)
+		return -EEXIST;
+
+	rxq->mp_params = *p;
+	ret = netdev_rx_queue_restart(dev, ifq_idx);
+	if (ret) {
+		rxq->mp_params.mp_ops = NULL;
+		rxq->mp_params.mp_priv = NULL;
+	}
+	return ret;
+}
+
+int net_mp_open_rxq(struct net_device *dev, unsigned ifq_idx,
+		    struct pp_memory_provider_params *p)
+{
+	int ret;
+
+	rtnl_lock();
+	ret = __net_mp_open_rxq(dev, ifq_idx, p);
+	rtnl_unlock();
+	return ret;
+}
+
+static void __net_mp_close_rxq(struct net_device *dev, unsigned ifq_idx,
+			      struct pp_memory_provider_params *old_p)
+{
+	struct netdev_rx_queue *rxq;
+	int ret;
+
+	if (WARN_ON_ONCE(ifq_idx >= dev->real_num_rx_queues))
+		return;
+
+	rxq = __netif_get_rx_queue(dev, ifq_idx);
+
+	if (WARN_ON_ONCE(rxq->mp_params.mp_ops != old_p->mp_ops ||
+			 rxq->mp_params.mp_priv != old_p->mp_priv))
+		return;
+
+	rxq->mp_params.mp_ops = NULL;
+	rxq->mp_params.mp_priv = NULL;
+	ret = netdev_rx_queue_restart(dev, ifq_idx);
+	if (ret)
+		pr_devel("Could not restart queue %u after removing memory provider.\n",
+			 ifq_idx);
+}
+
+void net_mp_close_rxq(struct net_device *dev, unsigned ifq_idx,
+		      struct pp_memory_provider_params *old_p)
+{
+	rtnl_lock();
+	__net_mp_close_rxq(dev, ifq_idx, old_p);
+	rtnl_unlock();
+}
-- 
2.43.5


