Return-Path: <io-uring+bounces-12281-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oC67GzNKlGn0BwIAu9opvQ
	(envelope-from <io-uring+bounces-12281-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 12:00:03 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 08DAB14B16F
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 12:00:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C500C303C511
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 10:59:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F342132D7EC;
	Tue, 17 Feb 2026 10:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nauElvRP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8772332D0E7
	for <io-uring@vger.kernel.org>; Tue, 17 Feb 2026 10:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771325946; cv=none; b=CHfvsj2j2sqvT+vX6OS80dvnQ/GV65p7pWmV11D4O4modDpCWUZlSjk58GZ3tFqdORXFt270F077qcxnwidHffOSq+2ancvsnGQcpavvkenzRVgZuh7cUXnlIaVh5aPNvXEiIJQ5M4Ht4Iv3xd0GWxLNDxEkBqCzK3DzaLEzLKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771325946; c=relaxed/simple;
	bh=rujFLshEBYCF+dxgH8wBrozqwBMF9xzorg0zEleDY1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KEe+fVOF7DP1KmkP3Et1mtrZYvJ5kTHtTFuLAv7kRXW5Ib84omtq2JKLJy20p7gWwx2Yc30paCMuO3vAzZv8XBBUl0cFdvLJkQDEh4MbE63/piWNiZPGdR8mMCaL0XIoM4g7fHW0rw78apoWOQ3HvzQDixvS0k9BaIfDzGT8VHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nauElvRP; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4806f3fc50bso47817125e9.0
        for <io-uring@vger.kernel.org>; Tue, 17 Feb 2026 02:59:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771325944; x=1771930744; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6iEwlTOgVgiGxc+Y02bzMeecrqHf8O5ZZwVuSK3xfzQ=;
        b=nauElvRPay/4q2ZWaFM26bTb/eRdkFfoQQBcmWgMZGpdsz5vT9+XAp2tHzdAI9kiwP
         rvGJQA009b89vkN51hgItvC49ZWkOSsBicHmEulqWC69hTFlgTbjNTjNmSaYO2zKbIN6
         OX28NPNsGTlneERk5oP7Sjzdswng/2YEWxd4ocg7b/Mi93orMXb20/Ll15UAMt5blJ/h
         RZAhep612qHCn5ffAZ4IknpzTKTUyGCOe6PrgXpNeBj56AgfoEA/31gIduKWvxqRTrM8
         zaiosBaeQVeznf40oMDzU+uy5eVsGMhdq3V/mDafeWbmsigxM0crJc8fBCGg8Lv3X96p
         4cLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771325944; x=1771930744;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6iEwlTOgVgiGxc+Y02bzMeecrqHf8O5ZZwVuSK3xfzQ=;
        b=fuJ8iOfYJHGKBFmJnQA68AK5IjFruMpt/E011GbfTboHDDrY+NDjJcNspsoFWUpuZi
         qTCvVNAVJ6kbHz9bacn8RB+Rkpbu5gWRt3X2QH44tbBsIcJ/HTtGZYMUp+To+Pgx/Fsq
         499tL3BAJmKdUXSk8BusKCzyE7ofifiLIbS3t6rzKZHQNj20Ojio2NwT7pZfumngKfck
         20O5iEuizBy2G52/avM+CPrhAiZHZX4gCRN4dr5ema7abOXyi3GD/bRo3znpJn0VlFll
         VxNEVa8edAdWJcMuz4GdE0F+gdJKlk9LOalWJlHb5d4fijcex9Z2/a47ss+yAYCAedDO
         dPTA==
X-Gm-Message-State: AOJu0YwV3yFklrll2Oif9s9cd3k8sBSbWMcCLPrSj/HxWABRn9xKVrYy
	b4NZ/dN4wveWkVTaH1kVuhLz8+JiqbN+zU+IaYkTe8ZIWu7IFucc8RJ6cHVFrQ==
X-Gm-Gg: AZuq6aJIE6VzZWgd/rbCfDFd1yhj7wo7kKiOanMNUYdkkQ5sSEQQTp/7lqraKkMsR6M
	XeZcw5fVrKkMpqDtnsvkrez+0ZBLiSrnGY8BVSSmBj8FlxgOwAUNIoB7gJBwkiY0ZgCEAaSPT0q
	LWxnm3TlRhHjbkmz4WhkiEB4X6L8cGCCa602LDWe/Z7QxN5Fmy7DHS4Fvwa3VAXmOT3HlfXwgBh
	dFXY55X88ErXMBgTNeC95wwmSfr+9vNILFUklmqOiFrNtRLryvrtNtMSu7TLqnyyjZ/0Kp+ahiB
	CXEyFKa+CSd6pAI7Qnd6obYVxLmJzBGqg0hIWajB49XxHOycTtPQQwpe1yl3/rjd7S53TLKi8Bs
	gch4rIywg9v90Rp+cpjqEilyb4L1UBBII7n4l9n5Q4WgJxM28Nw3kZMyTQ19pRGfITJe4dOPJw1
	fpVMBsTtNEYTpeO6zgmyESwpCexaQlIMkEHIP6VNEx7arr237EHtmDe5pZmHKIJBLBN01BGh4k6
	rrOdKuupFQa7qJ2TAxV3CrgjzPyaQ==
X-Received: by 2002:a05:600c:470b:b0:46e:4b79:551 with SMTP id 5b1f17b1804b1-48379c01465mr201576245e9.31.1771325943530;
        Tue, 17 Feb 2026 02:59:03 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48370a78c89sm327759395e9.5.2026.02.17.02.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Feb 2026 02:59:03 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH review-only 4/4] io_uring/zcrx: implement device-less mode for zcrx
Date: Tue, 17 Feb 2026 10:58:55 +0000
Message-ID: <4ae848e20e008a2496c4dd2710c50b15035a92d0.1771325198.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1771325198.git.asml.silence@gmail.com>
References: <cover.1771325198.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12281-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_NONE(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 08DAB14B16F
X-Rspamd-Action: no action

Allow creating a zcrx instance without attaching it to a net device.
All data will be copied through the fallback path. The user is also
expected to use ZCRX_CTRL_FLUSH_RQ to handle overflows as it normally
should even with a netdev, but it becomes even more relevant as there
will likely be no one to automatically pick up buffers.

Apart from that, it follows the zcrx uapi for the I/O path, and is
useful for testing, experimentation, and potentially for the copy
recieve path in the future if improved.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring/zcrx.h |  9 ++++++-
 io_uring/zcrx.c                    | 41 ++++++++++++++++++++----------
 io_uring/zcrx.h                    |  2 +-
 3 files changed, 36 insertions(+), 16 deletions(-)

diff --git a/include/uapi/linux/io_uring/zcrx.h b/include/uapi/linux/io_uring/zcrx.h
index 3163a4b8aeb0..103d65e690eb 100644
--- a/include/uapi/linux/io_uring/zcrx.h
+++ b/include/uapi/linux/io_uring/zcrx.h
@@ -49,7 +49,14 @@ struct io_uring_zcrx_area_reg {
 };
 
 enum zcrx_reg_flags {
-	ZCRX_REG_IMPORT	= 1,
+	ZCRX_REG_IMPORT		= 1,
+
+	/*
+	 * Register a zcrx instance without a net device. All data will be
+	 * copied. The refill queue entries might not be automatically
+	 * consmumed and need to be flushed, see ZCRX_CTRL_FLUSH_RQ.
+	 */
+	ZCRX_REG_NODEV		= 2,
 };
 
 enum zcrx_features {
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 4db3df6d7658..3d377523ff7e 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -127,10 +127,10 @@ static int io_import_dmabuf(struct io_zcrx_ifq *ifq,
 	int dmabuf_fd = area_reg->dmabuf_fd;
 	int i, ret;
 
+	if (!ifq->dev)
+		return -EINVAL;
 	if (off)
 		return -EINVAL;
-	if (WARN_ON_ONCE(!ifq->dev))
-		return -EFAULT;
 	if (!IS_ENABLED(CONFIG_DMA_SHARED_BUFFER))
 		return -EINVAL;
 
@@ -211,11 +211,13 @@ static int io_import_umem(struct io_zcrx_ifq *ifq,
 	if (ret)
 		goto out_err;
 
-	ret = dma_map_sgtable(ifq->dev, &mem->page_sg_table,
-			      DMA_FROM_DEVICE, IO_DMA_ATTR);
-	if (ret < 0)
-		goto out_err;
-	mapped = true;
+	if (ifq->dev) {
+		ret = dma_map_sgtable(ifq->dev, &mem->page_sg_table,
+				      DMA_FROM_DEVICE, IO_DMA_ATTR);
+		if (ret < 0)
+			goto out_err;
+		mapped = true;
+	}
 
 	mem->account_pages = io_count_account_pages(pages, nr_pages);
 	ret = io_account_mem(ifq->user, ifq->mm_account, mem->account_pages);
@@ -446,7 +448,8 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 	ret = io_import_area(ifq, &area->mem, area_reg);
 	if (ret)
 		goto err;
-	area->is_mapped = true;
+	if (ifq->dev)
+		area->is_mapped = true;
 
 	if (buf_size_shift > io_area_max_shift(&area->mem)) {
 		ret = -ERANGE;
@@ -482,9 +485,11 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 		niov->type = NET_IOV_IOURING;
 	}
 
-	ret = io_populate_area_dma(ifq, area);
-	if (ret)
-		goto err;
+	if (ifq->dev) {
+		ret = io_populate_area_dma(ifq, area);
+		if (ret)
+			goto err;
+	}
 
 	area->free_count = nr_iovs;
 	/* we're only supporting one area per ifq for now */
@@ -816,6 +821,8 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 		return -EFAULT;
 	if (reg.if_rxq == -1 || !reg.rq_entries)
 		return -EINVAL;
+	if ((reg.if_rxq || reg.if_idx) && (reg.flags & ZCRX_REG_NODEV))
+		return -EINVAL;
 	if (reg.rq_entries > IO_RQ_MAX_ENTRIES) {
 		if (!(ctx->flags & IORING_SETUP_CLAMP))
 			return -EINVAL;
@@ -851,9 +858,15 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 	if (ret)
 		goto err;
 
-	ret = zcrx_register_netdev(ifq, &reg, &area);
-	if (ret)
-		goto err;
+	if (!(reg.flags & ZCRX_REG_NODEV)) {
+		ret = zcrx_register_netdev(ifq, &reg, &area);
+		if (ret)
+			goto err;
+	} else {
+		ret = io_zcrx_create_area(ifq, &area, &reg);
+		if (ret)
+			goto err;
+	}
 
 	reg.zcrx_id = id;
 
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index 0ddcf0ee8861..db427f4a55b6 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -8,7 +8,7 @@
 #include <net/page_pool/types.h>
 #include <net/net_trackers.h>
 
-#define ZCRX_SUPPORTED_REG_FLAGS	(ZCRX_REG_IMPORT)
+#define ZCRX_SUPPORTED_REG_FLAGS	(ZCRX_REG_IMPORT | ZCRX_REG_NODEV)
 #define ZCRX_FEATURES			(ZCRX_FEATURE_RX_PAGE_SIZE)
 
 struct io_zcrx_mem {
-- 
2.52.0


