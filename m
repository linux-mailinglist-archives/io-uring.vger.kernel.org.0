Return-Path: <io-uring+bounces-10827-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A128C90258
	for <lists+io-uring@lfdr.de>; Thu, 27 Nov 2025 21:45:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id CDCE3352A8B
	for <lists+io-uring@lfdr.de>; Thu, 27 Nov 2025 20:45:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D323D31A558;
	Thu, 27 Nov 2025 20:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wsilw5Za"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095003168E0
	for <io-uring@vger.kernel.org>; Thu, 27 Nov 2025 20:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764276276; cv=none; b=RFIxFN7713G56scJmG0cEzS22PI2+htJptWDIz9Q/kLXbV6L+SNsEqHyXB8st1uHnnti6CcSNx0IyY7fFAPCnYSkvAnAsI3BRVTeEXTu1J4EfH0deXQ1nAmvd/lLDK4U4gQFi0MyOn88iUaNxy8s3IkKBRAnvSLi8xqXLa/pmQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764276276; c=relaxed/simple;
	bh=YCXiESmxDru16OuSBpgWKD7MLSgAxyhCtNWm4oA5/Po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y1+YA6w5CgCJyRt8NSAHkvNOIpGGf+y1TTyWFzGlpNkhXALDd3aU+k1HXo4jK1OZ328f2zZTvk/vLge+IimUgSu0C1hplQq4Kal6kHs8eRToxUkv6NQun+kd1ELOg+ATjxWmyTsQmcayKOR0+ZLxFADvEaGsfiwDYwYhvhKg2FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wsilw5Za; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-477b198f4bcso7928645e9.3
        for <io-uring@vger.kernel.org>; Thu, 27 Nov 2025 12:44:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764276273; x=1764881073; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wxF93ks89kapv2UHbHs6Gp6gp3EbwDOqDtHBuiudG8w=;
        b=Wsilw5Zal1PwTwqGdBy/ll/skI7gC66j41e12RvZYN1jEEMB1b8w+emjzdf1qSEiAb
         NLU6TFQCMCoqAJYP529iwMT/InyNiFJlsKMzZ1dY6CbCQ+f3wAco//3/HoJgL63ewSqC
         bXzohjdK6eGJxx1571k0RQ+4QEyqAAfRVHcyDaq/1AF5lk7xn01A/cleYxiMDcDfes+s
         RKE624d5ixtc/gb7FJ7xKBEezyrdCwszyFCDab7mh6GDNSIJCQyUuB6WnZf+wq1OxFdL
         e28L1CCYA59ryqWeTQA2sacgIOrTGtoujsJlvcqwDIJxUAmTDyLJxGrdxUz/Xd4amzPf
         jhpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764276273; x=1764881073;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wxF93ks89kapv2UHbHs6Gp6gp3EbwDOqDtHBuiudG8w=;
        b=n5vfwPiWqvJIGSkOyS79jKKHXZ9RTEfrASgTo/7DzDyNthqqnMU7pOg5CdEb0yZAaW
         SWXJ0NX3bcM5GT5wRvXPrTik8KaWelGceIceeJg7gSm7PLHwmgpGLBc5yW8br/T62qYt
         5e4Y/5vceK2eWPm7MLkFTnkiDyXZx2LoGKc/hSBEvaZO08PKXibCQ56C/BaRTIljQ3Y0
         HTCNKb58dLCN2PEB+0MZXxGBJDnrImL6gnQM/k7Iw/vPvGjGIWLtocL5HEUwpA9RXA9q
         QhD7ZlP7Bt3pfH0fxiIL7IilCVGg93GX9onSfyOgUtYcDvZ1quzVu3/bwJTTY6BGwKjj
         BHrA==
X-Forwarded-Encrypted: i=1; AJvYcCVap+n24O1iLBcjH5LJuf+3QYv4IDa9cFya/YNCKmBlfaWx8flXI4QYpitZCR8jxHld9Phl6mgK3w==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzhcktnlqr5D+EMIm/3TjGmnx4ZktBsbkd96pnRDFMpeC4zIgsy
	uEoJG1PV66MRAbKE4CpneJZpj21axHYwdoXsajFd8oqzYaNOt3AS+wMI
X-Gm-Gg: ASbGnctV6vPsHAYfUbhPkqvTyQCtEd2EFpEFRi3MTQlweMI0unoA1KzvD62OjQJW0x9
	lopop8DOejsUitu8uSeWTSzeWQvn9wYvbXZ1jbDxu5eyXgNGWs2YKFyyQJb8ZkLJlJkVYtI6nuq
	45CLn5gxeIrKyO02fo6cJ9ko4WM4OM7KpytXihXpL8k/mDCuRpDRHv48SnsmZDLfGvfVUEUerNX
	LzrI11P2u/O8uouywjbO+PXeNSnrS+pqgsQSBFvCTA9EskYGBvajLCI98uHhWrkWG3xv8xjLVIX
	MEKbtqEnoXakEUnqQNzlQWsO1Bh1Uys+Ug3awSCBmssvySek/6MPNYs2Q2xRws4F9KAqyD3d683
	1JJibCR2YwIaWgRVR1WzE9QnrNyTV3NEtDkChCOnYXJW3slLwYY7ap1SNjKlUdOYQgByaRH21lb
	FdAXXR8wppgPlpWA==
X-Google-Smtp-Source: AGHT+IH1GkgX0eRSxmMDdZ7g/7AgTv8fnG0KEnbsq0aEMjYefG8hJDp/+kuxJRcP57+KR5Klf3SUYw==
X-Received: by 2002:a05:600c:1993:b0:477:9392:8557 with SMTP id 5b1f17b1804b1-477c01b495amr240147615e9.18.1764276273164;
        Thu, 27 Nov 2025 12:44:33 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42e1c5d614asm5346105f8f.12.2025.11.27.12.44.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Nov 2025 12:44:32 -0800 (PST)
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
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Simon Horman <horms@kernel.org>,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	io-uring@vger.kernel.org,
	dtatulea@nvidia.com
Subject: [PATCH net-next v6 3/8] net: let pp memory provider to specify rx buf len
Date: Thu, 27 Nov 2025 20:44:16 +0000
Message-ID: <9cd0f777a19d4b71bec1ee36d3cbcab89083ec47.1764264798.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1764264798.git.asml.silence@gmail.com>
References: <cover.1764264798.git.asml.silence@gmail.com>
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
index cd00e0406cf4..2e6bcec1e1e3 100644
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
+	unsigned supported_params;
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


