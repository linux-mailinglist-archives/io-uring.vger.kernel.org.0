Return-Path: <io-uring+bounces-5774-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AA744A067F5
	for <lists+io-uring@lfdr.de>; Wed,  8 Jan 2025 23:09:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3B7D8188A39D
	for <lists+io-uring@lfdr.de>; Wed,  8 Jan 2025 22:09:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB99B205E0F;
	Wed,  8 Jan 2025 22:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="LchMLp/P"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A3C204C06
	for <io-uring@vger.kernel.org>; Wed,  8 Jan 2025 22:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736374050; cv=none; b=mZ/CfVVdJNk3gRFOH/W8iQbMtmasxkW5CpTpfqbcBcKHvfuz3SUxlra/IV5gePdzuI/S43LC77XGSG7DcRJnVF1Zb6bNXYW2YuxH/hleBFaRP4H9DjwRo74qfESprMVCeZBpVnjx7xLXTO0T0bYlChQZFYZ2Se/fyiLqlNID8C8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736374050; c=relaxed/simple;
	bh=8WDGKnJjhLIfGvG3a81UX+B9IT5lnrkN7/jYE+f6kLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NeETpqfPog9myS7prdNQpWTcsXgnS2aEbvkLBXQMh4uM0een6SP8cs7TVpIslXof0P2N2Ea+aXNtuD1adjcx1Yn9hVbpJ0/7K8bUXKq+I13r+YW8p6ckmy9BGiKSYck4sAOceG799jD6OjM+jZKctWyuGp4EJUmrxHa/KpQ9F/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=LchMLp/P; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2ee397a82f6so491571a91.2
        for <io-uring@vger.kernel.org>; Wed, 08 Jan 2025 14:07:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1736374048; x=1736978848; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NZU9x/wqygrpt9DsfwnKD2FuRQQk1M2IBmyzCsWeZ5s=;
        b=LchMLp/PD9CKN6aNGjvdZBaUk9HvdN1iwpObc2P+1hEDK7QNsIYrfOOUI2ukJyt4zr
         ZkFUR6KPq29CIUqk+XRQx+k2QaI+G2PBkZq090i11VOBii0854CGrngrqA9/DU715EFF
         VLTD515ngWQ3y/EO1CAyrBAVqiTvSMOIU1vA7tBp5m3Ek/UTDQPU8BmHaH7HnCWFFr4I
         DAe1H6mTT9ObQvJIpsTBvIZELMeiOrNd5yS5chz8ogkxa4okCSXXeYRymKNE/Xfwp0C0
         KWpoKCm/J+r+E3whNJ452A11cnKr1CBMTtcY3OQ2KeSeGAycWnKvZzmmL+2SdRMBffvu
         Gu1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736374048; x=1736978848;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NZU9x/wqygrpt9DsfwnKD2FuRQQk1M2IBmyzCsWeZ5s=;
        b=vSRt70jLlQC8rJOuHKazEjntyQtmJZDp5Ixt22dOrDBjmeyW/h0orieSE4WchVIgqx
         uB/OsczZAjsoPeeRlSdlhSZ4B33dcI63txYV2IXyr6GxDV0M6przCbwZfxli/VGeKf5t
         pToqFr6kVNdjO6yAVmqdilV1zkK+ZgB4uiBZUI5Ylz8Ohei4rOc40BNs+ZtB1LEzCmq/
         IIOcMOVZ9W/AXB84NJoRson+rH97M0wGC6sFBPaOY6bRqTII6uzaP0sNxdWT7CvKCKW5
         rFtNDu9JcF2f+WTp9PqSwV08OX88lIAO7xJYX8WDeDxZvlhOUVlTQiggq3dEodkh4xYH
         /T6w==
X-Gm-Message-State: AOJu0YznBFj4TCazH0utIHHtfEuNJnJRlAU8DTQmWQcotO++5nIq0pAo
	fAz2vXdGM9lxhrNsrshckWFeqqOqaKx0WrmkpQRWAAZto3BAJYSOFduL45rJLvuWz43amXBsEcR
	N
X-Gm-Gg: ASbGncvaAvmFdDWgO8HnJ1WTMXVzHNCpcqLpdznh4pfQ3wcit8oBna7N89a8pTL76Bp
	ipehkQ2mfmm6NwT2lPmbI3BqBjPfpDi8HvQV8HS/MbPwA9RG9KRxWEWt1+Icwu2DmQhUoFAQt+Y
	wvGmWKU3MDbXiosqj2JDFnNiw6lj6OTNxEiB/0YTJzJ2lGws0rT3bq2TcM+w4qdDJPYdtvSspB9
	WLQcy8I9UoYzaBm95XQgWJJzryMJmWadE/zn6sl
X-Google-Smtp-Source: AGHT+IEFqwpe6FeB+6UwmdaptfVGLFGNuJHWyasVbPZIIprT0ltZExx3+7vFesafv0j8PfnoNnpLcQ==
X-Received: by 2002:a17:90b:1f91:b0:2ee:f46f:4d5f with SMTP id 98e67ed59e1d1-2f548f17310mr6093970a91.6.1736374048356;
        Wed, 08 Jan 2025 14:07:28 -0800 (PST)
Received: from localhost ([2a03:2880:ff:7::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dc96e85csm332166945ad.61.2025.01.08.14.07.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2025 14:07:27 -0800 (PST)
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
Subject: [PATCH net-next v10 20/22] io_uring/zcrx: add copy fallback
Date: Wed,  8 Jan 2025 14:06:41 -0800
Message-ID: <20250108220644.3528845-21-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250108220644.3528845-1-dw@davidwei.uk>
References: <20250108220644.3528845-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

There are scenarios in which the zerocopy path can get a kernel buffer
instead of a net_iov and needs to copy it to the user, whether it is
because of mis-steering or simply getting an skb with the linear part.
In this case, grab a net_iov, copy into it and return it to the user as
normally.

At the moment the user doesn't get any indication whether there was a
copy or not, which is left for follow up work.

Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/zcrx.c | 121 +++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 115 insertions(+), 6 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 0c737ab9058d..b5ce336fc78d 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -7,6 +7,7 @@
 #include <linux/io_uring.h>
 #include <linux/netdevice.h>
 #include <linux/rtnetlink.h>
+#include <linux/skbuff_ref.h>
 
 #include <net/page_pool/helpers.h>
 #include <net/page_pool/memory_provider.h>
@@ -143,6 +144,13 @@ static void io_zcrx_get_niov_uref(struct net_iov *niov)
 	atomic_inc(io_get_user_counter(niov));
 }
 
+static inline struct page *io_zcrx_iov_page(const struct net_iov *niov)
+{
+	struct io_zcrx_area *area = io_zcrx_iov_to_area(niov);
+
+	return area->pages[net_iov_idx(niov)];
+}
+
 static int io_open_zc_rxq(struct io_zcrx_ifq *ifq, unsigned ifq_idx)
 {
 	struct netdev_rx_queue *rxq;
@@ -165,6 +173,7 @@ static int io_open_zc_rxq(struct io_zcrx_ifq *ifq, unsigned ifq_idx)
 	ret = netdev_rx_queue_restart(ifq->dev, ifq->if_rxq);
 	if (ret)
 		goto fail;
+
 	return 0;
 fail:
 	rxq->mp_params.mp_ops = NULL;
@@ -473,6 +482,11 @@ static void io_zcrx_return_niov(struct net_iov *niov)
 {
 	netmem_ref netmem = net_iov_to_netmem(niov);
 
+	if (!niov->pp) {
+		/* copy fallback allocated niovs */
+		io_zcrx_return_niov_freelist(niov);
+		return;
+	}
 	page_pool_put_unrefed_netmem(niov->pp, netmem, -1, false);
 }
 
@@ -700,13 +714,93 @@ static bool io_zcrx_queue_cqe(struct io_kiocb *req, struct net_iov *niov,
 	return true;
 }
 
+static struct net_iov *io_zcrx_alloc_fallback(struct io_zcrx_area *area)
+{
+	struct net_iov *niov = NULL;
+
+	spin_lock_bh(&area->freelist_lock);
+	if (area->free_count)
+		niov = __io_zcrx_get_free_niov(area);
+	spin_unlock_bh(&area->freelist_lock);
+
+	if (niov)
+		page_pool_fragment_netmem(net_iov_to_netmem(niov), 1);
+	return niov;
+}
+
+static ssize_t io_zcrx_copy_chunk(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
+				  void *src_base, struct page *src_page,
+				  unsigned int src_offset, size_t len)
+{
+	struct io_zcrx_area *area = ifq->area;
+	size_t copied = 0;
+	int ret = 0;
+
+	while (len) {
+		size_t copy_size = min_t(size_t, PAGE_SIZE, len);
+		const int dst_off = 0;
+		struct net_iov *niov;
+		struct page *dst_page;
+		void *dst_addr;
+
+		niov = io_zcrx_alloc_fallback(area);
+		if (!niov) {
+			ret = -ENOMEM;
+			break;
+		}
+
+		dst_page = io_zcrx_iov_page(niov);
+		dst_addr = kmap_local_page(dst_page);
+		if (src_page)
+			src_base = kmap_local_page(src_page);
+
+		memcpy(dst_addr, src_base + src_offset, copy_size);
+
+		if (src_page)
+			kunmap_local(src_base);
+		kunmap_local(dst_addr);
+
+		if (!io_zcrx_queue_cqe(req, niov, ifq, dst_off, copy_size)) {
+			io_zcrx_return_niov(niov);
+			ret = -ENOSPC;
+			break;
+		}
+
+		io_zcrx_get_niov_uref(niov);
+		src_offset += copy_size;
+		len -= copy_size;
+		copied += copy_size;
+	}
+
+	return copied ? copied : ret;
+}
+
+static int io_zcrx_copy_frag(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
+			     const skb_frag_t *frag, int off, int len)
+{
+	struct page *page = skb_frag_page(frag);
+	u32 p_off, p_len, t, copied = 0;
+	int ret = 0;
+
+	off += skb_frag_off(frag);
+
+	skb_frag_foreach_page(frag, off, len,
+			      page, p_off, p_len, t) {
+		ret = io_zcrx_copy_chunk(req, ifq, NULL, page, p_off, p_len);
+		if (ret < 0)
+			return copied ? copied : ret;
+		copied += ret;
+	}
+	return copied;
+}
+
 static int io_zcrx_recv_frag(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 			     const skb_frag_t *frag, int off, int len)
 {
 	struct net_iov *niov;
 
 	if (unlikely(!skb_frag_is_net_iov(frag)))
-		return -EOPNOTSUPP;
+		return io_zcrx_copy_frag(req, ifq, frag, off, len);
 
 	niov = netmem_to_net_iov(frag->netmem);
 	if (niov->pp->mp_ops != &io_uring_pp_zc_ops ||
@@ -733,18 +827,33 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 	struct io_zcrx_ifq *ifq = args->ifq;
 	struct io_kiocb *req = args->req;
 	struct sk_buff *frag_iter;
-	unsigned start, start_off;
+	unsigned start, start_off = offset;
 	int i, copy, end, off;
 	int ret = 0;
 
 	if (unlikely(args->nr_skbs++ > IO_SKBS_PER_CALL_LIMIT))
 		return -EAGAIN;
 
-	start = skb_headlen(skb);
-	start_off = offset;
+	if (unlikely(offset < skb_headlen(skb))) {
+		ssize_t copied;
+		size_t to_copy;
 
-	if (offset < start)
-		return -EOPNOTSUPP;
+		to_copy = min_t(size_t, skb_headlen(skb) - offset, len);
+		copied = io_zcrx_copy_chunk(req, ifq, skb->data, NULL,
+					    offset, to_copy);
+		if (copied < 0) {
+			ret = copied;
+			goto out;
+		}
+		offset += copied;
+		len -= copied;
+		if (!len)
+			goto out;
+		if (offset != skb_headlen(skb))
+			goto out;
+	}
+
+	start = skb_headlen(skb);
 
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 		const skb_frag_t *frag;
-- 
2.43.5


