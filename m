Return-Path: <io-uring+bounces-10863-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 63B16C95690
	for <lists+io-uring@lfdr.de>; Mon, 01 Dec 2025 00:37:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B29A24E05A7
	for <lists+io-uring@lfdr.de>; Sun, 30 Nov 2025 23:36:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B99572FFFB6;
	Sun, 30 Nov 2025 23:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QOK7YvSz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957E82FFDFF
	for <io-uring@vger.kernel.org>; Sun, 30 Nov 2025 23:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764545742; cv=none; b=pZDeJFCdJCJVNn1FsA9N0ArCQ7cgckHlhEtS7c8n12vxf7N2fFbmlxqVNkae8ABBSARnlr8292F+4psHVJ9JqB8NNsq0SWkBLbkcBV9iHK9sW4Yb0iscNzFUBo9WWoeT/zFBMFCmtYsbXOQzWScVFby+lEseaqchYGLRI4GcbfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764545742; c=relaxed/simple;
	bh=OGKzBuKu9HnGjv3V2KIOUMpBLQDNN5wbAGzT3ICtN0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vbk/pjTaG7WUWS6O0I4g7B0PT2bSL0WZYMXyewvuwMQ4b7zBzxM5ffOJgtMfVQkFOW31v8gpiszizvwx76vHLjZSsIuci/FNdYk4e/nQ6PjO964Dvq3lJkXs7uKXEru9hA85GIeQM0l3UfP8Cp0Rp0zoHyq/jFafr3bXGHQi20A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QOK7YvSz; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-477a1c28778so40741075e9.3
        for <io-uring@vger.kernel.org>; Sun, 30 Nov 2025 15:35:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764545738; x=1765150538; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Etzl3qXtEXxRUk5ZEMYr8GzSvCBjbQ/vWysP4cG19PU=;
        b=QOK7YvSzRpIM3bmocDTZSTJZ+AT8aIuEJ68zb/9IfM3EH8n+V3khm6fZ54vC6Yeg/d
         k27s32TTV9aqixkwBGJzPzJAgPR5m+Ln06/MJXEfNWwAP2xsMAPJaPngIyRIbYmUhSoF
         yhqSGo5Yw/mUTf1bO0IsrT1NapU8git1uef7ourInA0Zjb56atcsEq7D2tRD1syPvo7V
         ZQIZ84sAONRc5byf3x4m5Vfkgjx76wb/k3cuP5/N/nhBS7thhug/gLRKyVycUBxiSjOm
         67tCPQtPsZinagA6YJzGB5kInMI1PRxiTCe886LOiKyTD5xeniNRwhInzQnPKeVL6ei/
         ZwnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764545738; x=1765150538;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Etzl3qXtEXxRUk5ZEMYr8GzSvCBjbQ/vWysP4cG19PU=;
        b=XjaWPIF0Wm5XYwhzmPQLPmNbB3wZhjYdp9qwzvZCsEUSqe3FFXx+9DSbk45fJG73uE
         GV+jAKXYa0Cg2GcqeA7aylnhmghPp1rckoMPXyq7ba5q3JndHHSrpKJi0y7i+HpvQZZk
         uu3lrRMZep0Z4ov/siJejyWeFzJ6zjHbKstPD8d5kLPJ/iTaZJiobnOVwEXc8kLcQ7MV
         nehxvhFG2yVo0m64Mh/BC4BWuMWS1c5LV6bv7yLASlJ4QBH2IY0yHhNNaKhRWGNzj4fr
         ex5UK9CTnkL1QKbqSlzqyNjvoKsE4xcln3Z5nJKs0+qEwKf4ZA0UGEF2ljpkPuDJANK9
         Sk5Q==
X-Forwarded-Encrypted: i=1; AJvYcCW7TKLDy7ELaeH/Zbqhl+ZzGVSaaNHUfVmmgqRqTsoDhQUeYmupvFhrXFABCmQTS8Cxk1kVLYUJJA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/5vg3CtHis4yOxRJfbJfxf2HbGFW5vjwFgXaczCdUqD7dXeFK
	sL55wltzfMnfZv/jEMXfcs2Uf/X+42km8b/9o+uZ0ZAoBTHmVdCPjVwM
X-Gm-Gg: ASbGncuKfkmso4BS+/h0NgBfdtJLLxy6rFTTMdeXtXz2qIKLmydPbNL4GaPzV/j/Vqd
	cV02K4awVd0nDmmBYuXNDBWf7BeQiKsMD9hox66I56DHvflwu+rw2+wVf3YN9jYvhTa7b3Hxjjr
	mdwSAaHKzNg9EE3sVN+Pbab1lFiM5gji+GEsfaFpA65cWxEiccLa4MuRiPtqVqltdlw0Oruemcq
	QX8Is4KJLGU57foLm7vamllgGsJQehhzNOlBiLDZ4r7hyi8hWUHayDc10Qel6PURTEhn4qJQPRo
	7Qrxc2ro7aIsQx29NoFeY5xzLkG95RWFhV/qoxe6aCbQ6RFhi5GEH7JuBmUoo6V89wqcR9Or9sX
	A8x8qprNEvifKiEUPRgjsb5xFU1qpGqG3dk7EkA5F8DxKexLYrgAl3FwL2ycc6lZB3G/9TWHuyS
	wS6SxnxI+rP0yZSPkXDEADoGSyd+nG5PikAtgrM8lkYfAAXL2DNtFLVG5wxv0rrZqEnuSlow2y3
	Z7svl18QP5Mn3Kj
X-Google-Smtp-Source: AGHT+IGIUBkKFTjVVCw8JO88WO04GjOPBXSs8x48lo+BhVoIg3ql1cUd33a7wo+Dz7e5cUTvz/0ZMw==
X-Received: by 2002:a05:600c:1c1b:b0:471:14b1:da13 with SMTP id 5b1f17b1804b1-47904aebebdmr257224895e9.14.1764545737736;
        Sun, 30 Nov 2025 15:35:37 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-479040b3092sm142722075e9.1.2025.11.30.15.35.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Nov 2025 15:35:36 -0800 (PST)
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
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Shuah Khan <shuah@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Yue Haibing <yuehaibing@huawei.com>,
	David Wei <dw@davidwei.uk>,
	Haiyue Wang <haiyuewa@163.com>,
	Jens Axboe <axboe@kernel.dk>,
	Joe Damato <jdamato@fastly.com>,
	Simon Horman <horms@kernel.org>,
	Vishwanath Seshagiri <vishs@fb.com>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	io-uring@vger.kernel.org,
	dtatulea@nvidia.com
Subject: [PATCH net-next v7 4/9] net: let pp memory provider to specify rx buf len
Date: Sun, 30 Nov 2025 23:35:19 +0000
Message-ID: <0364ec97cc65b7b7b7376b98438c2630fa2e003c.1764542851.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1764542851.git.asml.silence@gmail.com>
References: <cover.1764542851.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow memory providers to configure rx queues with a specific receive
buffer length. Pass it in struct pp_memory_provider_params, which is
copied into the queue, so it's preserved across queue restarts. It's an
opt-in feature for drivers, which they can enable by setting
NDO_QUEUE_RX_BUF_SIZE to their struct netdev_queue_mgmt_ops.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/net/netdev_queues.h   | 9 +++++++++
 include/net/page_pool/types.h | 1 +
 net/core/netdev_rx_queue.c    | 4 ++++
 3 files changed, 14 insertions(+)

diff --git a/include/net/netdev_queues.h b/include/net/netdev_queues.h
index cd00e0406cf4..45c1d198f5bf 100644
--- a/include/net/netdev_queues.h
+++ b/include/net/netdev_queues.h
@@ -111,6 +111,11 @@ void netdev_stat_queue_sum(struct net_device *netdev,
 			   int tx_start, int tx_end,
 			   struct netdev_queue_stats_tx *tx_sum);
 
+enum {
+	/* queue restart support custom rx buffer sizes */
+	NDO_QUEUE_RX_BUF_SIZE		= 0x1,
+};
+
 /**
  * struct netdev_queue_mgmt_ops - netdev ops for queue management
  *
@@ -130,6 +135,8 @@ void netdev_stat_queue_sum(struct net_device *netdev,
  * @ndo_queue_get_dma_dev: Get dma device for zero-copy operations to be used
  *			   for this queue. Return NULL on error.
  *
+ * @supported_params: bitmask of supported features, see NDO_QUEUE_*
+ *
  * Note that @ndo_queue_mem_alloc and @ndo_queue_mem_free may be called while
  * the interface is closed. @ndo_queue_start and @ndo_queue_stop will only
  * be called for an interface which is open.
@@ -149,6 +156,8 @@ struct netdev_queue_mgmt_ops {
 						  int idx);
 	struct device *		(*ndo_queue_get_dma_dev)(struct net_device *dev,
 							 int idx);
+
+	unsigned int supported_params;
 };
 
 bool netif_rxq_has_unreadable_mp(struct net_device *dev, int idx);
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
diff --git a/net/core/netdev_rx_queue.c b/net/core/netdev_rx_queue.c
index a0083f176a9c..09d6f97e910e 100644
--- a/net/core/netdev_rx_queue.c
+++ b/net/core/netdev_rx_queue.c
@@ -29,6 +29,10 @@ int netdev_rx_queue_restart(struct net_device *dev, unsigned int rxq_idx)
 	    !qops->ndo_queue_mem_alloc || !qops->ndo_queue_start)
 		return -EOPNOTSUPP;
 
+	if (!(qops->supported_params & NDO_QUEUE_RX_BUF_SIZE) &&
+	    rxq->mp_params.rx_buf_len)
+		return -EOPNOTSUPP;
+
 	netdev_assert_locked(dev);
 
 	new_mem = kvzalloc(qops->ndo_queue_mem_size, GFP_KERNEL);
-- 
2.52.0


