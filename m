Return-Path: <io-uring+bounces-11739-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BE000D2681F
	for <lists+io-uring@lfdr.de>; Thu, 15 Jan 2026 18:35:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9CB683133C84
	for <lists+io-uring@lfdr.de>; Thu, 15 Jan 2026 17:13:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D08E23C00B8;
	Thu, 15 Jan 2026 17:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="arbDkq1S"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com [209.85.128.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 710313BFE3D
	for <io-uring@vger.kernel.org>; Thu, 15 Jan 2026 17:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497155; cv=none; b=F/sRsd3j/hpjCs7b3l1pvUJcF/ZYQz/3XPBJe4ZZ7P5kOCsON+aV60PrPJYCW5y+p0fDEmE2ITxcK5NWZKAUQdEFxPYs9TDIrtvJ5+bKakjfh/vi8NngDqUdmN+9WXPhkptRHuPvJKmeT5u2i6YDtAXOqABH3nupWiEn+KLA7PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497155; c=relaxed/simple;
	bh=hKOxjq4fxJ+iQfib8Cm75gZgmDPHfB9Dr0qLWGLYXFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uQrkYlfeBCznswMP3kQn0U7zLwJy53mdNaPvUXTXaAJnpzhRkvmyTCaW7WFrIxg3CP2knBUumitg7DAOySQ3lSnXExTEUpSlxesv0m/zqfnqsNTEV2O1nPeO6NW8f0TNp5c6Wu3vbtHIm8tSGt1AOXr2eADoxLmOyu7bXQID1ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=arbDkq1S; arc=none smtp.client-ip=209.85.128.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f66.google.com with SMTP id 5b1f17b1804b1-47ee4539adfso10843525e9.3
        for <io-uring@vger.kernel.org>; Thu, 15 Jan 2026 09:12:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768497152; x=1769101952; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TWL7hbAkNRsIM9hHu4g4BkFlYyqPgZDU68a7iQIhzDo=;
        b=arbDkq1SNOq8FIwZsavNxMCRr/WUD0TzmJLcXHaBmHUBRQyb25O9fL8k1r4DrSpQCn
         AYGA64CE+H4VU8dMWaXw0ghqO0pBUgjkVGpyQWFPCE3/ddhtTQH0fybqWyQgRLPHf1sF
         SQXjBsBWv5d5q8rcSO9IVGarTW+Qfr2a5gv9+4KiW0bLYQRlweBJO+mRjEHMzQDXl0Ed
         DMO9MNpUnEz70qYWjqUmFX/X1bygvefxpWGaWcT7GByruIJKfRc5sl2jrFrhiXAjxM8l
         IbK8gUaOWgs85gDH9KhfdXYoPKGT+kuYV+or2fWM9BriRH/C4XBYBS6XFI+peVZAW2iV
         DMLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768497152; x=1769101952;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TWL7hbAkNRsIM9hHu4g4BkFlYyqPgZDU68a7iQIhzDo=;
        b=BFUvGQZ5litqX4LFlOWDLiQXF5BigUUZC+g5hU2Kd/vmR4s9jnKsMmAR46JON3P5li
         Fz1/4DNPHU9qZsFd3nDY8sIhkV9szmlpRD+Bn4bgf5+wqjnohOcIF3Ucg1qwqumI09xs
         eXlLn4PUbIx40ZR91NlzY7VkoNhDvvWLpD2pR18lItGEINslmtfD2MMsIe6YYQ75IihP
         Zr0dD4FYS19O4r8rkfAwox5+bKVP8YdAzHRY0fR5ID5xnsXuYjBAbbQZHbsXt9DNZqRg
         j5O0TWeuXTYhWAWvKG6zyfpw93nh4/nUfTmcm+QzmQcUv2DujTEeJbFeCDnCGBBfzH+G
         eyHA==
X-Forwarded-Encrypted: i=1; AJvYcCVjxJhEue6OQ2gvJsxL9yAq8t8yI+vbubemZGj+ecoTfhR7YPxMPRAsK+2EDowkkgsTDHymmRDWAA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzKnG5uRxLr6Fo6fmCibPH50kNFOeqjz3dAek/6Ia7LrFbPKuRn
	IPb3xX/eIrXNw80iiTG6thT6b+RqOYcRyKKf+1GV8l6lT8PitRiZiWW7
X-Gm-Gg: AY/fxX54w7TTWrNW/Xp+u/5A1TnGuIVJhwYoUZxe9ZVoEMlHzucTteOhEdEELZNUdQi
	1Ow0HFf/WPeK1+02AGgl1IEoGRQ3j5OAFgZvT8stxJaFwRwjp9yiaBFMpn9VjKH2vMUnYEk+aVt
	IoOouVQXv8WCCt+GGu0D3sHN/hAUCLA2cYJFA4SvOkNuPj5y0Z8DnpgqgiPcq3ho7am3gRvkaAK
	WVEBmwaaw6i4Gdb2X3m5+zBCs/qaVin1fHYY3qsF0p3i4pVngMIJR9mHsafIQ4iro6pA3y7Fgmv
	rlYUWxB0SyO1JCu3v7qrgfcU6RSbg3y2jiJWBhLEEdcVkg2kJFJznh12eTxRqVoRdeHdOmnxDny
	ZWPTjwcpk3rmDExoMm0NSttX9E/UwbBV+z0CuKhZGYyi70FUcgjzOiJDl/IMYfamoetGc3kVbS8
	2NZdZ5RO44wXKSy65+fb0Er0zAjIl0aNQmZb1OYnjb1Nv+ZZiElb4wA+ooO0dVyDc/Q5M/SHuyo
	6k+a0J5C7ZkKE3VqQ==
X-Received: by 2002:a05:600c:8718:b0:477:76c2:49c9 with SMTP id 5b1f17b1804b1-4801e2fb9e5mr6717845e9.2.1768497151701;
        Thu, 15 Jan 2026 09:12:31 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47f429071a2sm54741645e9.11.2026.01.15.09.12.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 09:12:30 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: netdev@vger.kernel.org
Cc: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Michael Chan <michael.chan@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Joshua Washington <joshwash@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Alexander Duyck <alexanderduyck@fb.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Shuah Khan <shuah@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Ankit Garg <nktgrg@google.com>,
	Tim Hostetler <thostet@google.com>,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Ziwei Xiao <ziweixiao@google.com>,
	John Fraker <jfraker@google.com>,
	Praveen Kaligineedi <pkaligineedi@google.com>,
	Mohsin Bashir <mohsin.bashr@gmail.com>,
	Joe Damato <joe@dama.to>,
	Mina Almasry <almasrymina@google.com>,
	Dimitri Daskalakis <dimitri.daskalakis1@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	David Wei <dw@davidwei.uk>,
	Yue Haibing <yuehaibing@huawei.com>,
	Haiyue Wang <haiyuewa@163.com>,
	Jens Axboe <axboe@kernel.dk>,
	Simon Horman <horms@kernel.org>,
	Vishwanath Seshagiri <vishs@fb.com>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	dtatulea@nvidia.com,
	kernel-team@meta.com,
	io-uring@vger.kernel.org
Subject: [PATCH net-next v9 4/9] net: pass queue rx page size from memory provider
Date: Thu, 15 Jan 2026 17:11:57 +0000
Message-ID: <c0b709bf438ba9d197d369f55e4a97603fd4a705.1768493907.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1768493907.git.asml.silence@gmail.com>
References: <cover.1768493907.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow memory providers to configure rx queues with a custom receive
page size. It's passed in struct pp_memory_provider_params, which is
copied into the queue, so it's preserved across queue restarts. Then,
it's propagated to the driver in a new queue config parameter.

Drivers should explicitly opt into using it by setting
QCFG_RX_PAGE_SIZE, in which case they should implement ndo_default_qcfg,
validate the size on queue restart and honour the current config in case
of a reset.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/net/netdev_queues.h   | 10 ++++++++++
 include/net/page_pool/types.h |  1 +
 net/core/netdev_rx_queue.c    |  9 +++++++++
 3 files changed, 20 insertions(+)

diff --git a/include/net/netdev_queues.h b/include/net/netdev_queues.h
index f6f1f71a24e1..feca25131930 100644
--- a/include/net/netdev_queues.h
+++ b/include/net/netdev_queues.h
@@ -15,6 +15,7 @@ struct netdev_config {
 };
 
 struct netdev_queue_config {
+	u32	rx_page_size;
 };
 
 /* See the netdev.yaml spec for definition of each statistic */
@@ -114,6 +115,11 @@ void netdev_stat_queue_sum(struct net_device *netdev,
 			   int tx_start, int tx_end,
 			   struct netdev_queue_stats_tx *tx_sum);
 
+enum {
+	/* The queue checks and honours the page size qcfg parameter */
+	QCFG_RX_PAGE_SIZE	= 0x1,
+};
+
 /**
  * struct netdev_queue_mgmt_ops - netdev ops for queue management
  *
@@ -135,6 +141,8 @@ void netdev_stat_queue_sum(struct net_device *netdev,
  *
  * @ndo_default_qcfg:	Populate queue config struct with defaults. Optional.
  *
+ * @supported_params:	Bitmask of supported parameters, see QCFG_*.
+ *
  * Note that @ndo_queue_mem_alloc and @ndo_queue_mem_free may be called while
  * the interface is closed. @ndo_queue_start and @ndo_queue_stop will only
  * be called for an interface which is open.
@@ -158,6 +166,8 @@ struct netdev_queue_mgmt_ops {
 				    struct netdev_queue_config *qcfg);
 	struct device *	(*ndo_queue_get_dma_dev)(struct net_device *dev,
 						 int idx);
+
+	unsigned int supported_params;
 };
 
 bool netif_rxq_has_unreadable_mp(struct net_device *dev, int idx);
diff --git a/include/net/page_pool/types.h b/include/net/page_pool/types.h
index 1509a536cb85..0d453484a585 100644
--- a/include/net/page_pool/types.h
+++ b/include/net/page_pool/types.h
@@ -161,6 +161,7 @@ struct memory_provider_ops;
 struct pp_memory_provider_params {
 	void *mp_priv;
 	const struct memory_provider_ops *mp_ops;
+	u32 rx_page_size;
 };
 
 struct page_pool {
diff --git a/net/core/netdev_rx_queue.c b/net/core/netdev_rx_queue.c
index 86d1c0a925e3..b81cad90ba2f 100644
--- a/net/core/netdev_rx_queue.c
+++ b/net/core/netdev_rx_queue.c
@@ -30,12 +30,21 @@ int netdev_rx_queue_restart(struct net_device *dev, unsigned int rxq_idx)
 	    !qops->ndo_queue_mem_alloc || !qops->ndo_queue_start)
 		return -EOPNOTSUPP;
 
+	if (WARN_ON_ONCE(qops->supported_params && !qops->ndo_default_qcfg))
+		return -EINVAL;
+
 	netdev_assert_locked(dev);
 
 	memset(&qcfg, 0, sizeof(qcfg));
 	if (qops->ndo_default_qcfg)
 		qops->ndo_default_qcfg(dev, &qcfg);
 
+	if (rxq->mp_params.rx_page_size) {
+		if (!(qops->supported_params & QCFG_RX_PAGE_SIZE))
+			return -EOPNOTSUPP;
+		qcfg.rx_page_size = rxq->mp_params.rx_page_size;
+	}
+
 	new_mem = kvzalloc(qops->ndo_queue_mem_size, GFP_KERNEL);
 	if (!new_mem)
 		return -ENOMEM;
-- 
2.52.0


