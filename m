Return-Path: <io-uring+bounces-60-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CA0007E4AEE
	for <lists+io-uring@lfdr.de>; Tue,  7 Nov 2023 22:41:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8406428137C
	for <lists+io-uring@lfdr.de>; Tue,  7 Nov 2023 21:41:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AF222B2FC;
	Tue,  7 Nov 2023 21:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="H4aaLUmI"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D4D2B2C9
	for <io-uring@vger.kernel.org>; Tue,  7 Nov 2023 21:41:05 +0000 (UTC)
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4180B10EA
	for <io-uring@vger.kernel.org>; Tue,  7 Nov 2023 13:41:05 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1cc329ce84cso55987185ad.2
        for <io-uring@vger.kernel.org>; Tue, 07 Nov 2023 13:41:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1699393264; x=1699998064; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cSOXUo8OS6zelv94KUNMHN/MdPKo/PdzolI0dF5/1lw=;
        b=H4aaLUmIS+4Y4hXoazgXFgezUU9EPqRHsugsKsyqWgUZvUpX5Fro0yu3s5aQrHyFlI
         zHEQpUtKPb0Z0X0jYEiJmHIfHlxbZ4wuP5hypwbr/pL9T+TU/W7CX0i7bn6Cbemah+kt
         dol+6KjztBKNdmTgUFGFE77nAqscpB7K5S1nvN8g2vLc3mnKrisuP6NjjUU1Zy1n18Vk
         BAMIwSch2kJxDTMAMixrZ+k+n42sUfLUig55ySpejn0Y8yj/Mch1PU5RPkFqlenUSlFO
         cLIt1vhRInpEQHnaMpe+Nz9bgjqY93Ej1oonjF3p/iq/VC7KEb8a/d1xaegj7nqaIIh2
         6JxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699393264; x=1699998064;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cSOXUo8OS6zelv94KUNMHN/MdPKo/PdzolI0dF5/1lw=;
        b=vBiv054BHoHH4lmjC7VrOQ+/UYqPpvG5SctY2bkvFOy/qpPMH7VdGo+uZmx8yRNakK
         A3Lr7OgrQGnKG0rsQ0B4kbHpoYCd4I++zVyA+N9ryTflTr6JaTHm4o70Nlx7/jNPHmWs
         rDJ5lPNJajWyIw6/w5CtSXvydVCxt/2jaevV/Yqod0JdfGpYvyq+SN3D+C5d2hj+7GaD
         hl5yuR2No1g4TLaNPIltF7RWl4JloVAVU1ve/MotZYtCV21b0YOiZgmCRCtMGVKHUYhx
         9gf4cbaTV45RqW47Y/9dFhwmRs8zJKjVDjIilvYwqO6CO0J84SCSFjEyuuV7r8O8CtdY
         wkAg==
X-Gm-Message-State: AOJu0YwfidZoKBdTbHNhVd/CofSh5oKVheU6d05BctBp9qX3TOicltfY
	cMxkTLUubnUkuiRj7ra0Z6ui7WKqb4quijympzK1tg==
X-Google-Smtp-Source: AGHT+IFv6ru8WDfKAjNQ4Ab7cvWHWmt1HeHM2E4sGqiBQT2254a7GxveuXA00BgODy2WeqT1QkFRTg==
X-Received: by 2002:a17:902:9888:b0:1cc:54b5:b4fa with SMTP id s8-20020a170902988800b001cc54b5b4famr230582plp.18.1699393264581;
        Tue, 07 Nov 2023 13:41:04 -0800 (PST)
Received: from localhost (fwdproxy-prn-006.fbsv.net. [2a03:2880:ff:6::face:b00c])
        by smtp.gmail.com with ESMTPSA id u6-20020a170902e5c600b001b89466a5f4sm279147plf.105.2023.11.07.13.41.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 13:41:04 -0800 (PST)
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
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Dragos Tatulea <dtatulea@nvidia.com>
Subject: [PATCH 09/20] io_uring: allocate a uarg for freeing zero copy skbs
Date: Tue,  7 Nov 2023 13:40:34 -0800
Message-Id: <20231107214045.2172393-10-dw@davidwei.uk>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20231107214045.2172393-1-dw@davidwei.uk>
References: <20231107214045.2172393-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As ZC skbs are marked as zero copy, they will bypass the default skb
frag destructor. This patch adds a static uarg that is attached to ZC
bufs and a callback that returns them to the freelist of a ZC pool.

Co-developed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/linux/io_uring.h  |  7 +++++++
 include/linux/netdevice.h |  1 +
 io_uring/zc_rx.c          | 44 +++++++++++++++++++++++++++++++++++++++
 io_uring/zc_rx.h          |  1 +
 4 files changed, 53 insertions(+)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 624515a8bdd5..fb88e000c156 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -72,6 +72,8 @@ static inline void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
 
 struct io_zc_rx_ifq;
 struct io_zc_rx_buf *io_zc_rx_get_buf(struct io_zc_rx_ifq *ifq);
+struct io_zc_rx_buf *io_zc_rx_buf_from_page(struct io_zc_rx_ifq *ifq,
+					    struct page *page);
 void io_zc_rx_put_buf(struct io_zc_rx_ifq *ifq, struct io_zc_rx_buf *buf);
 
 static inline dma_addr_t io_zc_rx_buf_dma(struct io_zc_rx_buf *buf)
@@ -122,6 +124,11 @@ static inline struct io_zc_rx_buf *io_zc_rx_get_buf(struct io_zc_rx_ifq *ifq)
 {
 	return NULL;
 }
+static inline struct io_zc_rx_buf *io_zc_rx_buf_from_page(struct io_zc_rx_ifq *ifq,
+							  struct page *page)
+{
+	return NULL;
+}
 static inline void io_zc_rx_put_buf(struct io_zc_rx_ifq *ifq, struct io_zc_rx_buf *buf)
 {
 }
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index f9c82c89a96b..ec82fc984941 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1027,6 +1027,7 @@ struct netdev_bpf {
 		struct {
 			struct io_zc_rx_ifq *ifq;
 			u16 queue_id;
+			struct ubuf_info *uarg;
 		} zc_rx;
 	};
 };
diff --git a/io_uring/zc_rx.c b/io_uring/zc_rx.c
index 840a21549d89..59f279486e9a 100644
--- a/io_uring/zc_rx.c
+++ b/io_uring/zc_rx.c
@@ -46,6 +46,11 @@ static inline u64 mk_page_info(u16 pool_id, u32 pgid)
 	return (u64)0xface << 48 | (u64)pool_id << 32 | (u64)pgid;
 }
 
+static inline bool is_zc_rx_page(struct page *page)
+{
+	return PagePrivate(page) && ((page_private(page) >> 48) == 0xface);
+}
+
 typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
 
 static int __io_queue_mgmt(struct net_device *dev, struct io_zc_rx_ifq *ifq,
@@ -61,6 +66,7 @@ static int __io_queue_mgmt(struct net_device *dev, struct io_zc_rx_ifq *ifq,
 	cmd.command = XDP_SETUP_ZC_RX;
 	cmd.zc_rx.ifq = ifq;
 	cmd.zc_rx.queue_id = queue_id;
+	cmd.zc_rx.uarg = ifq ? &ifq->uarg : 0;
 
 	return ndo_bpf(dev, &cmd);
 }
@@ -75,6 +81,26 @@ static int io_close_zc_rxq(struct io_zc_rx_ifq *ifq)
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
@@ -270,6 +296,8 @@ int io_register_zc_rx_ifq(struct io_ring_ctx *ctx,
 	if (ret)
 		goto err;
 
+	ifq->uarg.callback = io_zc_rx_skb_free;
+	ifq->uarg.flags = SKBFL_ALL_ZEROCOPY | SKBFL_FIXED_FRAG;
 	ifq->rq_entries = reg.rq_entries;
 	ifq->cq_entries = reg.cq_entries;
 	ifq->cached_rq_head = 0;
@@ -466,4 +494,20 @@ void io_zc_rx_put_buf(struct io_zc_rx_ifq *ifq, struct io_zc_rx_buf *buf)
 }
 EXPORT_SYMBOL(io_zc_rx_put_buf);
 
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
+
 #endif
diff --git a/io_uring/zc_rx.h b/io_uring/zc_rx.h
index a3df820e52e7..b99be0227e9e 100644
--- a/io_uring/zc_rx.h
+++ b/io_uring/zc_rx.h
@@ -15,6 +15,7 @@ struct io_zc_rx_ifq {
 	struct io_rbuf_ring	*ring;
 	struct io_uring_rbuf_rqe *rqes;
 	struct io_uring_rbuf_cqe *cqes;
+	struct ubuf_info	uarg;
 	u32			rq_entries, cq_entries;
 	u32			cached_rq_head;
 	u32			cached_cq_tail;
-- 
2.39.3


