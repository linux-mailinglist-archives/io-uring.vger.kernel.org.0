Return-Path: <io-uring+bounces-5987-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DD71A153E2
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 17:12:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1DB6D3A793F
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 16:12:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 458F11A0B0E;
	Fri, 17 Jan 2025 16:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P6qutVqo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE931A01D4;
	Fri, 17 Jan 2025 16:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737130291; cv=none; b=IsB/tOlXtG5v1egW+UuvPy4pzlZE+n1kbqK55Dd6kQVUqyXbk6dyMUsrkzT/kqjUpIx5PMbZyuAIpogNOlxT5m3/iRUe6lUxiP/WQub7tSMAulwumGi1sclzvEUtNHUSnyJcroTi1En2EZY7fzkdY/CDa6MJIa3zpsxRqo3Hv9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737130291; c=relaxed/simple;
	bh=SB1uvCcLKvxV8PevAgK5gt5B+TT8KvSjoci9vgD8tcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T2HIcuxH37orQbd+8JXGjHv9V7T4FnlOPljuIkGl5yWnqfioNPRVhIYDTEwlBeI5HLibiZUSveLjacKvQw3DS+9UBzWmXsfeOeHLi8XfSj2yqQ/jYVAACd4/zDFW+peDiRD6vRiB74WwdmQSDg75vYystubfRv8VDNVwFvP9n3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P6qutVqo; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-ab2e308a99bso477338966b.1;
        Fri, 17 Jan 2025 08:11:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737130288; x=1737735088; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t7dfg+74umbk+ITjMhIMvDKTxg0EYGAZyZgxeW3moQQ=;
        b=P6qutVqou43oijhZ0palMomaNMotdioL0W2D8O4f9qxDUpSc349C8jqwSCmmmdDlwH
         iks8ip62IqKIm3X9B6367Ck7CH6gmmCDbR/93eDIPZK0Te8g+6AoHnvCVPN5rLwP4+Xt
         NiYRJJ5+2WtTyLcmira4hx4465PIcxa+m/HouDCBFx+jER+gTgzu0TyswsgiA4nclZuB
         hkHsg02Toog0S0pVYJiNFFqJNuxdYMF+nPrF8fXbS1/TyeO+sHL0sB3XamFIICvDN7RY
         BzwycPKFkzR7ozgBhY1m6f/O+19Wkfp3j9I5paUohC0Ks5YY8ZQ91d8YsgWKWs+BiWrB
         tsfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737130288; x=1737735088;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t7dfg+74umbk+ITjMhIMvDKTxg0EYGAZyZgxeW3moQQ=;
        b=I8PGmfU/f6hlDJLWLTy9S6+bRHkt9e6Q41WvDeX13+Pny/nwKZ01cdnbE33s9olZVQ
         gJH2vEi9cl7OycD+Tp/JAct9QJIjomjZOIZJcVl/410LEZBL1QsNOlJ6L0/vVbGRljhT
         /F6j0dQSvLXbChz6k0+O2IQlEvAjnukdi5XkU6lQMn3zQDmRQsGSam/LuaQ44TNgF6tj
         mZMRHb2Hwt2UFKlcVoGj1BwZXUaR31LVq7MeVoulqq1mcZsOGWThmNtSfLNUpru+Lscc
         7z9lLvDyAsKdLvYeP3wOLiWUssF3RokX3twneh+j/WLWiHS943HOwMehSASCrZQOhyic
         CoUQ==
X-Forwarded-Encrypted: i=1; AJvYcCV8GiIrYN5S+TS0cWMSpwiQHyeXc/jFbFe7Eoosg4fE+XWdYvZz67s+Arrovr8bpbA2MHqVKqs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMdz5ZAF/z4ICAb3swbVUn7bgLeBlW4itq3VmB98hoNtf3fRQW
	KEKpTJDZhm16gKADebqzwVp3hxEtp65NWg/LAhRxHwJIi/UxpUSGws8dHw==
X-Gm-Gg: ASbGncsjiY+yHbLYUUVRad+SvVOq1nkcCS93jyuR6PcB2/4EvWG3e9gL+Gw4qFAgbXW
	THFZyKgt3MX/6Ai72zdQISFfOLt3DNGmCPYHFxGhRLo3ve+znDse2nbLa+Q0xrAM1WGHlrBRoo8
	p/V9Zt0rBM80dWwr7zINZ1gjDn82VETOvJdeHJjXS9HhzRv/LPKsucL338ztwqCtm5jZKJKZ9Ma
	bRIVKpry6dwSam3trQT+3wYd73QTaYTIURE63uY
X-Google-Smtp-Source: AGHT+IGYFHbH2ri6ai17wNuYmsnebUXj5qhYaZNWRpGcMog9apppumAPuJgk1mnTbPfSRYY+DxiwhQ==
X-Received: by 2002:a17:907:9611:b0:aa6:9540:570f with SMTP id a640c23a62f3a-ab36e30b50emr624419366b.18.1737130287406;
        Fri, 17 Jan 2025 08:11:27 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:56de])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab384f23007sm193716366b.96.2025.01.17.08.11.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2025 08:11:26 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: asml.silence@gmail.com,
	Jens Axboe <axboe@kernel.dk>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Stanislav Fomichev <stfomichev@gmail.com>,
	Joe Damato <jdamato@fastly.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	David Wei <dw@davidwei.uk>
Subject: [PATCH net-next v12 10/10] net: add helpers for setting a memory provider on an rx queue
Date: Fri, 17 Jan 2025 16:11:48 +0000
Message-ID: <0ed20ccc0c99e8b729cfbde6fb3fc571fcf38294.1737129699.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1737129699.git.asml.silence@gmail.com>
References: <cover.1737129699.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Wei <dw@davidwei.uk>

Add helpers that properly prep or remove a memory provider for an rx
queue then restart the queue.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/net/page_pool/memory_provider.h |  5 ++
 net/core/netdev_rx_queue.c              | 62 +++++++++++++++++++++++++
 2 files changed, 67 insertions(+)

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
index db82786fa0c4..a13deedf6fc1 100644
--- a/net/core/netdev_rx_queue.c
+++ b/net/core/netdev_rx_queue.c
@@ -3,6 +3,7 @@
 #include <linux/netdevice.h>
 #include <net/netdev_queues.h>
 #include <net/netdev_rx_queue.h>
+#include <net/page_pool/memory_provider.h>
 
 #include "page_pool_priv.h"
 
@@ -80,3 +81,64 @@ int netdev_rx_queue_restart(struct net_device *dev, unsigned int rxq_idx)
 	return err;
 }
 EXPORT_SYMBOL_NS_GPL(netdev_rx_queue_restart, "NETDEV_INTERNAL");
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
+	WARN_ON(netdev_rx_queue_restart(dev, ifq_idx));
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
2.47.1


