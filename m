Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 877877892FD
	for <lists+io-uring@lfdr.de>; Sat, 26 Aug 2023 03:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231625AbjHZBWH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Aug 2023 21:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231624AbjHZBVk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Aug 2023 21:21:40 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 554DE2689
        for <io-uring@vger.kernel.org>; Fri, 25 Aug 2023 18:21:36 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-68bed286169so1351556b3a.1
        for <io-uring@vger.kernel.org>; Fri, 25 Aug 2023 18:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20221208.gappssmtp.com; s=20221208; t=1693012896; x=1693617696;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tylFMBBlja4pnu4G0FtEa8rKWMH9hDK59r2ccjasHbc=;
        b=afkvQM3bl4EqltZqv1ipUMeSZgPncQVdl7gvVzkPGKTKcF+97lryLour3GboeyIlKZ
         RvXBLr5eWTNiOjfpGIO89m2DP2BANuGZpq7AKuWU5oi8z2++oBZVjkBB0QyqPeMOoFJA
         0YTaiRhHJzTH4/TqduI9UBzmQv6rzOF4G6JWNJYvcH4XxypuZDyeWOvzOxmMBFpE6Xqh
         GSD+xu1DEZ0Agt+QxlTLmi+C55k+I/+My7EsKIUUXuplQTWvukBbIb+fmvjOqQQ2IQiK
         KZihVUJDAMn14axGEQ0jJMdIzbHHIFVpjTpXF+HlMrzBNAz4ufcWzFXjX2syvWFeU4Pt
         h9wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693012896; x=1693617696;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tylFMBBlja4pnu4G0FtEa8rKWMH9hDK59r2ccjasHbc=;
        b=gQ6r6GGjeWV4Lojy4OoH9AwF+SDJ2fPYk2a3wkO7CYUEVsTGSSNUlkBXayVHhLsDCs
         AZhiXGNIszTcOFsZlSqwcMTprCnZo9h7pBHzIhmTCiJbLALQDspHEUQUl/857D1cPAxK
         FIHAqCurBfGbaOEDeXtOIA9mAVgPUnNtqnRXcj4KMtt4QFoUPYtJmZVfffwVM/wgVsof
         AFme79uoA9Nc9Whipkb62mvrTM0+m9Rn3pNfza6yOEBrx0BTCn95NqGmTcHMD9C4TC9h
         y20e6UF9uM+/8MqLOBGC32riuzF6Gnvgk5kl+uCxdgPaiPBnRauoMKFIWNyh5w0SQljK
         9BIw==
X-Gm-Message-State: AOJu0YztnUMySGtxM5EqCS7Nvu0Ad9NKtlWBJ60csL+1tk9Es/rk0Sgc
        MA0vHFUpCCzZL/MlsQLBia8zlg==
X-Google-Smtp-Source: AGHT+IEjiFq2VLUS7JjHkDnkb3/Kh/FZb/jcg+0xtPb+IbUjM75iF8xhj/xI0H7/6H49TV+4q5Si5A==
X-Received: by 2002:a05:6a21:7785:b0:14c:d494:77c5 with SMTP id bd5-20020a056a21778500b0014cd49477c5mr975470pzc.13.1693012895860;
        Fri, 25 Aug 2023 18:21:35 -0700 (PDT)
Received: from localhost (fwdproxy-prn-016.fbsv.net. [2a03:2880:ff:10::face:b00c])
        by smtp.gmail.com with ESMTPSA id jw21-20020a170903279500b001b06c106844sm2402215plb.151.2023.08.25.18.21.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Aug 2023 18:21:35 -0700 (PDT)
From:   David Wei <dw@davidwei.uk>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        Mina Almasry <almasrymina@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 08/11] io_uring: allocate a uarg for freeing zero copy skbs
Date:   Fri, 25 Aug 2023 18:19:51 -0700
Message-Id: <20230826011954.1801099-9-dw@davidwei.uk>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230826011954.1801099-1-dw@davidwei.uk>
References: <20230826011954.1801099-1-dw@davidwei.uk>
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

