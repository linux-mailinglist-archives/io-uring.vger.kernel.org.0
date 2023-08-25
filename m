Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E596178921F
	for <lists+io-uring@lfdr.de>; Sat, 26 Aug 2023 00:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbjHYW4q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Aug 2023 18:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbjHYW4O (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Aug 2023 18:56:14 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 801B9E77
        for <io-uring@vger.kernel.org>; Fri, 25 Aug 2023 15:56:11 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1bc0d39b52cso10638985ad.2
        for <io-uring@vger.kernel.org>; Fri, 25 Aug 2023 15:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20221208.gappssmtp.com; s=20221208; t=1693004171; x=1693608971;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tylFMBBlja4pnu4G0FtEa8rKWMH9hDK59r2ccjasHbc=;
        b=iGJLMBym/eYY5XsIDIij6pHp/I+90CAUSUwIdAf/QkmRCdsTGSF3jRjti8nTnFXzQD
         9UTVIR0GO2wIz9dmIZTATzvYcPou8U3pAQ+Dtp+anOPNj3skimaM1PscZlxLQh0MzI+0
         3ms3RFlVUg+GBQiN8O5SN5eeEdNbHvWMZyFuhpDdEivzipLS1m67fX/yrMu/3Fc1XJdN
         AO3a1397O7jS6d5yONG4eADfNjwUIwuyDxIFyx/2dZnQAiPAxlZ/D/mJmYk286i6DsEw
         Hg4udMos+I66s8y9rlxrA22RHwHD89Bz3+23RqKgKRWCyJQpo47xdekYBiCIGxkCzgsU
         6sDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693004171; x=1693608971;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tylFMBBlja4pnu4G0FtEa8rKWMH9hDK59r2ccjasHbc=;
        b=HNUx7VmSmGnYlIS/ymztD2WgfR2VMUgx/ApFrecnovdPozhPbaIOLL8lkoxKuu8bt6
         n4Ms0ZDQcBpb02O5ntL5d//DutF/8f4OVgy4j35Wb6LaSa/hRQ7v2jQDB0op5hkfsy4X
         ltktchSYXTdlarDnoK5g+jYH3ajSEU497FIRsHrsoKuexRcRsLygnxmgDINJjRpXQlog
         VfJN8xRz8Mk3qEvyIKD3T4GPDM48MCG3d4rxg3LxnEADYxB3Zo4t1Ozy272lyn6hMIl/
         d07kqV2mo0VGW78hPejtPv/lRTJzpzkAF6mm7zQaPbwR8M+5XJhAjAbQVVHZX+W9ED/x
         dC+Q==
X-Gm-Message-State: AOJu0YxpHDXbAd1TaQZ0tklGB3iHwfxC46HU4L9w94yfGxks95NendH0
        yFqWiUFwJbPWN1P61gfm1Jgjyg==
X-Google-Smtp-Source: AGHT+IFPtRu2U1Q0wEnM3kUaHBaVzZLqfwizTJ/gaT9FCselDRqvo1ok+1PMiBhB0GygFV+dygfkow==
X-Received: by 2002:a17:902:ea06:b0:1c0:a5c9:e072 with SMTP id s6-20020a170902ea0600b001c0a5c9e072mr10532116plg.11.1693004170989;
        Fri, 25 Aug 2023 15:56:10 -0700 (PDT)
Received: from localhost (fwdproxy-prn-012.fbsv.net. [2a03:2880:ff:c::face:b00c])
        by smtp.gmail.com with ESMTPSA id c15-20020a170902d48f00b001bbdf32f011sm2264875plg.269.2023.08.25.15.56.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Aug 2023 15:56:10 -0700 (PDT)
From:   David Wei <dw@davidwei.uk>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, Mina Almasry <almasrymina@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 08/11] io_uring: allocate a uarg for freeing zero copy skbs
Date:   Fri, 25 Aug 2023 15:55:47 -0700
Message-Id: <20230825225550.957014-9-dw@davidwei.uk>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230825225550.957014-1-dw@davidwei.uk>
References: <20230825225550.957014-1-dw@davidwei.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: David Wei <davidhwei@meta.com>

As ZC skbs are marked as zero copy, they will bypass the default skb
frag destructor. This patch adds a static uarg that is attached to ZC
bufs and a callback that returns them to the freelist of a ZC pool.

Signed-off-by: David Wei <davidhwei@meta.com>
Co-developed-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/linux/io_uring.h  |  7 +++++++
 include/linux/netdevice.h |  1 +
 io_uring/zc_rx.c          | 44 +++++++++++++++++++++++++++++++++++++++
 io_uring/zc_rx.h          |  2 ++
 4 files changed, 54 insertions(+)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 61eae25a8f1d..e2a4f92df814 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -62,6 +62,8 @@ const char *io_uring_get_opcode(u8 opcode);
 
 struct io_zc_rx_ifq;
 struct io_zc_rx_buf *io_zc_rx_get_buf(struct io_zc_rx_ifq *ifq);
+struct io_zc_rx_buf *io_zc_rx_buf_from_page(struct io_zc_rx_ifq *ifq,
+					    struct page *page);
 void io_zc_rx_put_buf(struct io_zc_rx_ifq *ifq, struct io_zc_rx_buf *buf);
 static inline dma_addr_t io_zc_rx_buf_dma(struct io_zc_rx_buf *buf)
 {
@@ -123,6 +125,11 @@ static inline struct io_zc_rx_buf *io_zc_rx_get_buf(struct io_zc_rx_ifq *ifq)
 {
 	return NULL;
 }
+static inline struct io_zc_rx_buf *io_zc_rx_buf_from_page(struct io_zc_rx_ifq *ifq,
+							  struct page *page)
+{
+	return NULL;
+}
 void io_zc_rx_put_buf(struct io_zc_rx_ifq *ifq, struct io_zc_rx_buf *buf)
 {
 }
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index a20a5c847916..bf133cbee721 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1043,6 +1043,7 @@ struct netdev_bpf {
 		struct {
 			struct io_zc_rx_ifq *ifq;
 			u16 queue_id;
+			struct ubuf_info *uarg;
 		} zc_rx;
 	};
 };
diff --git a/io_uring/zc_rx.c b/io_uring/zc_rx.c
index 14bc063f1c6c..b8dd699e2777 100644
--- a/io_uring/zc_rx.c
+++ b/io_uring/zc_rx.c
@@ -44,6 +44,11 @@ static u64 mk_page_info(u16 pool_id, u32 pgid)
 	return (u64)0xface << 48 | (u64)pool_id << 32 | (u64)pgid;
 }
 
+static bool is_zc_rx_page(struct page *page)
+{
+	return PagePrivate(page) && ((page_private(page) >> 48) == 0xface);
+}
+
 typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
 
 static int __io_queue_mgmt(struct net_device *dev, struct io_zc_rx_ifq *ifq,
@@ -59,6 +64,7 @@ static int __io_queue_mgmt(struct net_device *dev, struct io_zc_rx_ifq *ifq,
 	cmd.command = XDP_SETUP_ZC_RX;
 	cmd.zc_rx.ifq = ifq;
 	cmd.zc_rx.queue_id = queue_id;
+	cmd.zc_rx.uarg = &ifq->uarg;
 
 	return ndo_bpf(dev, &cmd);
 }
@@ -73,6 +79,26 @@ static int io_close_zc_rxq(struct io_zc_rx_ifq *ifq)
 	return __io_queue_mgmt(ifq->dev, NULL, ifq->if_rxq_id);
 }
 
+static void io_zc_rx_skb_free(struct sk_buff *skb, struct ubuf_info *uarg,
+			      bool success)
+{
+	struct skb_shared_info *shinfo = skb_shinfo(skb);
+	struct io_zc_rx_ifq *ifq;
+	struct io_zc_rx_buf *buf;
+	struct page *page;
+	int i;
+
+	ifq = container_of(uarg, struct io_zc_rx_ifq, uarg);
+	for (i = 0; i < shinfo->nr_frags; i++) {
+		page = skb_frag_page(&shinfo->frags[i]);
+		buf = io_zc_rx_buf_from_page(ifq, page);
+		if (likely(buf))
+			io_zc_rx_put_buf(ifq, buf);
+		else
+			__skb_frag_unref(&shinfo->frags[i], skb->pp_recycle);
+	}
+}
+
 static int io_zc_rx_map_buf(struct device *dev, struct page *page, u16 pool_id,
 			    u32 pgid, struct io_zc_rx_buf *buf)
 {
@@ -268,6 +294,8 @@ int io_register_zc_rx_ifq(struct io_ring_ctx *ctx,
 	if (ret)
 		goto err;
 
+	ifq->uarg.callback = io_zc_rx_skb_free;
+	ifq->uarg.flags = SKBFL_ALL_ZEROCOPY | SKBFL_FIXED_FRAG;
 	ifq->rq_entries = reg.rq_entries;
 	ifq->cq_entries = reg.cq_entries;
 	ifq->cached_rq_head = 0;
@@ -407,3 +435,19 @@ void io_zc_rx_put_buf(struct io_zc_rx_ifq *ifq, struct io_zc_rx_buf *buf)
 	io_zc_rx_recycle_buf(pool, buf);
 }
 EXPORT_SYMBOL(io_zc_rx_put_buf);
+
+struct io_zc_rx_buf *io_zc_rx_buf_from_page(struct io_zc_rx_ifq *ifq,
+					    struct page *page)
+{
+	struct io_zc_rx_pool *pool;
+	int pgid;
+
+	if (!is_zc_rx_page(page))
+		return NULL;
+
+	pool = ifq->pool;
+	pgid = page_private(page) & 0xffffffff;
+
+	return &pool->bufs[pgid];
+}
+EXPORT_SYMBOL(io_zc_rx_buf_from_page);
diff --git a/io_uring/zc_rx.h b/io_uring/zc_rx.h
index b063a3c81ccb..ee7e36295f91 100644
--- a/io_uring/zc_rx.h
+++ b/io_uring/zc_rx.h
@@ -3,6 +3,7 @@
 #define IOU_ZC_RX_H
 
 #include <linux/io_uring_types.h>
+#include <linux/skbuff.h>
 
 struct io_zc_rx_ifq {
 	struct io_ring_ctx	*ctx;
@@ -10,6 +11,7 @@ struct io_zc_rx_ifq {
 	struct io_rbuf_ring	*ring;
 	struct io_uring_rbuf_rqe *rqes;
 	struct io_uring_rbuf_cqe *cqes;
+	struct ubuf_info	uarg;
 	u32			rq_entries, cq_entries;
 	u32			cached_rq_head;
 	u32			cached_cq_tail;
-- 
2.39.3

