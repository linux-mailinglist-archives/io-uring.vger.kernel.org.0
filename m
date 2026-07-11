Return-Path: <io-uring+bounces-13980-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id XvjJJOgfUmobMQMAu9opvQ
	(envelope-from <io-uring+bounces-13980-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 12:50:16 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E6142741509
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 12:50:15 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=k+CqBuhq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13980-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13980-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1C59C302D5F1
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 10:49:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F0673BBFC1;
	Sat, 11 Jul 2026 10:49:36 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F723C0633
	for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 10:49:24 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783766973; cv=none; b=evbJvNG6pgFfCnqTTpMkmgCreaeScvJ9PQo0qml/JgzTxs6cZy8W8kC8en8OnriJSLt2KXGHNb/I2/xDHyYfbiebGKOwVrPJHNSA8EHRETG2CjZT0EAct0ZolvO1/7g7J9/03wZBCmC+phn18uX14/UdsmPKcvw964bOwIskSFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783766973; c=relaxed/simple;
	bh=OEvIyS+mKiIWCrKAbZR0LHE1ZtBrvPvlwVaplICVy9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OJy075F88D1+u1a6fgBMwRa9c9I/ptD19DEp/dnTokGUwMlWdyWYtOrGiyCZuneUMvTh0Vu5VLn39XLMmbhacVeNxiD8lltPG8QPEwhSRIReExCVdV6kh6gP71pzSfvzDq4AcxBUOaPE0HVRTjnO3njx0HuGniB3oo2pbyG4wkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k+CqBuhq; arc=none smtp.client-ip=209.85.218.48
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c15c257a488so250225666b.3
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 03:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783766960; x=1784371760; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qms3rEKyX2JB93BBm5Zfxr9oAEK8d+GwUbmaIMWOy7c=;
        b=k+CqBuhqSEJcdv+cz8DkxGumbr/AeR3jAllYDJEBl3FLs1JxuUVQ0kqqjwkfekFQed
         E/QRKBg6Azdu1Ouc0G/Zc1J+n/nm5VxyZKkIfuHaI/h9gpV082ZB9K1oeqs20XV1df/k
         ZMKdkRoNmUUN0c9Z9UxqV93qDWheSxemNf6RQkujlOkqU4f9cEWYZOXXKOUOw4WobXWH
         rqXVyrXZkhJZmJrNI0QcZxVT3fupdjnLlzmebZTxdeI46itJW1qlfI8O6l/vQxG7v1Br
         D6+RKMU6M2060XDplQ5xSQPhP/AjbDT2yqGqr7YtmHBebMz3GYfoZDGMpGOuTZ1Kb2Q9
         3x6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783766960; x=1784371760;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qms3rEKyX2JB93BBm5Zfxr9oAEK8d+GwUbmaIMWOy7c=;
        b=c5AgHLdfgIPLKFCCujPsa7dQh56g9mG22xuFzI0dff1lO//29TeIPFmq6goQt6A01x
         jMw3MepqbV1gqYfeV2F370fX8aSR4HX96JR5GykL8xJE4weTt05vj+UwFJITM+HlXFEa
         aVysiYGZgd91R8vEvlu2bFewOruH3HUn6R/vHjNvL0lzhQZqiU96yLYP2AmVY9JZSn/Z
         y14+rA7ZcKmQl7MoB8vUO0rTKIOvIemVkHAJnkAUggxfohUolSqr64vvl4DlRr1Qr23t
         jWM4XIF8vzbwdtuA24+e06DxVxtGhmbouRCQ9gEGBEl8TfXT69BGKK57d/brJQynhLwG
         ZvMw==
X-Forwarded-Encrypted: i=1; AHgh+RqQfIm6KSxJ7uzm2KfqEfW5Q5jvQoktLBfWF2Q+NuAbHR5yxlN/PzSQplzAPkMYdvkuUQ2v1Wpv6w==@vger.kernel.org
X-Gm-Message-State: AOJu0YyobvRy5RbXcSuWJM3gQJ9BqLH7/eEs7da9zVdBYtLBmkIT/9LX
	3hRC1En6lNUkSfbZUPk2o/UvoeZ5dpzTRAizS4biUPFUOXnqlyT1fzNi
X-Gm-Gg: AfdE7ckRTWlO5lH0Hcs+tEdPSvaOSVuynLXF6BLP3TvC2xaYCum3Am6iW8+Xj1xKA5P
	Hk6sUenFAJaA+B13f3tX5nuuvw1dFWL5tQ3makQnvxjFMOi7zGwLydavB7rvg3lK+E1gSUcZzpY
	6iH9QLp55lVz6BTTxoqg5FqDwdGO5knEAuiwWmtz7fMd1CY4/Fj/U/nvHrH1Eyg0SA4KVAqaUik
	vYPp692KCnXHeUasXgistNQLLbsXcU729fcl1G4VlW7zZt0l2RdezZo3oZsA7dWCFqmu8k5rb9R
	7XY/2OlHAXR2fZPfQ/6rGPhY7tX+9+7WwWtVIEkjW+j9ohab6cafSwEkMgPdYgLRDgQe1zlWegC
	Y78vYirxxY10hZFmDVs/Skq4ZMZAuzC5I1h1F0/ITRyS9lZ2D5WUtubHKJ18+EdvJnM6BInycce
	VkSAySTzD/O2HMQdgBQge+D26aHIL4JzYX2AE1l8xXEMgTjPhxlnZHS3X68AxHrSA4UKO+Zr4dD
	ifNC7vfNBfs6XD1MOqThc783XpRhsDDVudVRUQuna/ZXJixiFkqmlRm0ue5
X-Received: by 2002:a17:907:97d4:b0:c15:efb1:9ff7 with SMTP id a640c23a62f3a-c161e91a30fmr84454466b.28.1783766960456;
        Sat, 11 Jul 2026 03:49:20 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-222-132.dab.02.net. [82.132.222.132])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c15beb53b86sm609123166b.25.2026.07.11.03.49.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 03:49:19 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: netdev@vger.kernel.org
Cc: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	io-uring@vger.kernel.org,
	asml.silence@gmail.com
Subject: [RFC 04/10] io_uring/zcrx: prepare areas to be exported for tx
Date: Sat, 11 Jul 2026 11:48:33 +0100
Message-ID: <60d1b1b7b56986791e4975c79632c42d15c2e57f.1783614400.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1783614400.git.asml.silence@gmail.com>
References: <cover.1783614400.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FREEMAIL_CC(0.00)[davemloft.net,google.com,kernel.org,redhat.com,mojatatu.com,vger.kernel.org,gmail.com];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-13980-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:netdev@vger.kernel.org,m:davem@davemloft.net,m:edumazet@google.com,m:kuba@kernel.org,m:pabeni@redhat.com,m:horms@kernel.org,m:jhs@mojatatu.com,m:io-uring@vger.kernel.org,m:asml.silence@gmail.com,m:asmlsilence@gmail.com,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: E6142741509

We're going to piggy back tx on top of zcrx, for that we need a separate
niov list without the pp field set and make sure net core can reference
them via get_netmem, which pins the zcrx instance.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring/net.h | 10 ++++++
 io_uring/zcrx.c              | 65 +++++++++++++++++++++++++++++++++---
 io_uring/zcrx.h              | 10 ++++++
 net/core/skbuff.c            |  3 ++
 4 files changed, 83 insertions(+), 5 deletions(-)

diff --git a/include/linux/io_uring/net.h b/include/linux/io_uring/net.h
index b58f39fed4d5..19f31f0d38d5 100644
--- a/include/linux/io_uring/net.h
+++ b/include/linux/io_uring/net.h
@@ -2,6 +2,8 @@
 #ifndef _LINUX_IO_URING_NET_H
 #define _LINUX_IO_URING_NET_H
 
+#include <net/netmem.h>
+
 struct io_uring_cmd;
 
 #if defined(CONFIG_IO_URING)
@@ -15,4 +17,12 @@ static inline int io_uring_cmd_sock(struct io_uring_cmd *cmd,
 }
 #endif
 
+#if defined(CONFIG_IO_URING_ZCRX)
+void zcrx_ref_niov(struct net_iov *niov);
+#else
+static inline void zcrx_ref_niov(struct net_iov *niov)
+{
+}
+#endif
+
 #endif
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index f501fc75d7b6..28398f0d0014 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -9,6 +9,7 @@
 #include <linux/rtnetlink.h>
 #include <linux/skbuff_ref.h>
 #include <linux/anon_inodes.h>
+#include <linux/io_uring/net.h>
 
 #include <net/page_pool/helpers.h>
 #include <net/page_pool/memory_provider.h>
@@ -100,6 +101,8 @@ static int io_populate_area_dma(struct io_zcrx_ifq *ifq,
 
 			if (net_mp_niov_set_dma_addr(niov, dma))
 				return -EFAULT;
+			if (net_mp_niov_set_dma_addr(&area->tx_niovs[niov_idx], dma))
+				return -EFAULT;
 			sg_len -= niov_size;
 			dma += niov_size;
 			niov_idx++;
@@ -118,7 +121,7 @@ static void io_release_dmabuf(struct io_zcrx_mem *mem)
 
 	if (mem->sgt)
 		dma_buf_unmap_attachment_unlocked(mem->attach, mem->sgt,
-						  DMA_FROM_DEVICE);
+						  DMA_BIDIRECTIONAL);
 	if (mem->attach)
 		dma_buf_detach(mem->dmabuf, mem->attach);
 	if (mem->dmabuf)
@@ -162,7 +165,7 @@ static int io_import_dmabuf(struct io_zcrx_ifq *ifq,
 		goto err;
 	}
 
-	mem->sgt = dma_buf_map_attachment_unlocked(mem->attach, DMA_FROM_DEVICE);
+	mem->sgt = dma_buf_map_attachment_unlocked(mem->attach, DMA_BIDIRECTIONAL);
 	if (IS_ERR(mem->sgt)) {
 		ret = PTR_ERR(mem->sgt);
 		mem->sgt = NULL;
@@ -226,7 +229,7 @@ static int io_import_umem(struct io_zcrx_ifq *ifq,
 
 	if (ifq->dev) {
 		ret = dma_map_sgtable(ifq->dev, &mem->page_sg_table,
-				      DMA_FROM_DEVICE, IO_DMA_ATTR);
+				      DMA_BIDIRECTIONAL, IO_DMA_ATTR);
 		if (ret < 0)
 			goto out_err;
 		mapped = true;
@@ -247,7 +250,7 @@ static int io_import_umem(struct io_zcrx_ifq *ifq,
 out_err:
 	if (mapped)
 		dma_unmap_sgtable(ifq->dev, &mem->page_sg_table,
-				  DMA_FROM_DEVICE, IO_DMA_ATTR);
+				  DMA_BIDIRECTIONAL, IO_DMA_ATTR);
 	sg_free_table(&mem->page_sg_table);
 	unpin_user_pages(pages, nr_pages);
 	kvfree(pages);
@@ -310,7 +313,7 @@ static void io_zcrx_unmap_area(struct io_zcrx_ifq *ifq,
 		io_release_dmabuf(&area->mem);
 	} else {
 		dma_unmap_sgtable(ifq->dev, &area->mem.page_sg_table,
-				  DMA_FROM_DEVICE, IO_DMA_ATTR);
+				  DMA_BIDIRECTIONAL, IO_DMA_ATTR);
 	}
 }
 
@@ -494,6 +497,11 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 	if (!area->nia.niovs)
 		goto err;
 
+	area->tx_niovs = kvmalloc_objs(area->tx_niovs[0], nr_iovs,
+					GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	if (!area->tx_niovs)
+		goto err;
+
 	area->freelist = kvmalloc_array(nr_iovs, sizeof(area->freelist[0]),
 					GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 	if (!area->freelist)
@@ -510,6 +518,7 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 		net_iov_init(niov, &area->nia, NET_IOV_IOURING);
 		area->freelist[i] = i;
 		atomic_set(&area->user_refs[i], 0);
+		net_iov_init(&area->tx_niovs[i], &area->nia, NET_IOV_IOURING);
 	}
 
 	if (ifq->dev) {
@@ -741,6 +750,13 @@ static const struct file_operations zcrx_box_fops = {
 	.release	= zcrx_box_release,
 };
 
+void zcrx_ref_niov(struct net_iov *niov)
+{
+	struct io_zcrx_ifq *ifq = io_zcrx_iov_to_area(niov)->ifq;
+
+	percpu_ref_get(&ifq->refs);
+}
+
 static int zcrx_export(struct io_ring_ctx *ctx, struct io_zcrx_ifq *ifq,
 		       struct zcrx_ctrl *ctrl, void __user *arg)
 {
@@ -1817,3 +1833,42 @@ int io_zcrx_recv(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 	sock_rps_record_flow(sk);
 	return io_zcrx_tcp_recvmsg(req, ifq, sk, flags, issue_flags, len);
 }
+
+int io_zcrx_fill_tx_skb(struct sk_buff *skb, struct io_zcrx_ifq *zcrx,
+			struct iov_iter *from, size_t length)
+{
+	int i = skb_shinfo(skb)->nr_frags;
+	unsigned niovs_emitted = 0;
+	struct io_zcrx_area *area = zcrx->area;
+	unsigned niov_size = 1U << zcrx->niov_shift;
+
+	if (i && skb_frags_readable(skb))
+		return -EINVAL;
+	length = min(length, iov_iter_count(from));
+
+	while (length) {
+		struct net_iov *niov;
+		size_t offset, size, niov_off;
+
+		if (i == MAX_SKB_FRAGS) {
+			percpu_ref_get_many(&zcrx->refs, niovs_emitted);
+			return -EMSGSIZE;
+		}
+
+		offset = (size_t)iter_iov_addr(from);
+		niov = &area->tx_niovs[offset >> zcrx->niov_shift];
+		niov_off = offset & (niov_size - 1);
+		size = min(length, niov_size - niov_off);
+		size = min(size, iter_iov_len(from));
+
+		skb_add_rx_frag_netmem(skb, i, net_iov_to_netmem(niov), niov_off,
+				       size, size);
+		iov_iter_advance(from, size);
+		length -= size;
+		i++;
+		niovs_emitted++;
+	}
+
+	percpu_ref_get_many(&zcrx->refs, niovs_emitted);
+	return 0;
+}
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index 205b9b40c74d..406e0399bd7b 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -32,6 +32,7 @@ struct io_zcrx_area {
 	struct net_iov_area	nia;
 	struct io_zcrx_ifq	*ifq;
 	atomic_t		*user_refs;
+	struct net_iov		*tx_niovs;
 
 	bool			is_mapped;
 	u16			area_id;
@@ -96,6 +97,10 @@ int io_zcrx_recv(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 		 unsigned issue_flags, unsigned int *len);
 struct io_mapped_region *io_zcrx_get_region(struct io_ring_ctx *ctx,
 					    unsigned int id);
+
+int io_zcrx_fill_tx_skb(struct sk_buff *skb, struct io_zcrx_ifq *zcrx,
+			 struct iov_iter *from, size_t length);
+
 #else
 static inline int io_register_zcrx(struct io_ring_ctx *ctx,
 				   struct io_uring_zcrx_ifq_reg __user *arg)
@@ -124,6 +129,11 @@ static inline int io_zcrx_ctrl(struct io_ring_ctx *ctx,
 {
 	return -EOPNOTSUPP;
 }
+static inline int io_zcrx_fill_tx_skb(struct sk_buff *skb, struct io_zcrx_ifq *zcrx,
+					struct iov_iter *from, size_t length)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 int io_recvzc(struct io_kiocb *req, unsigned int issue_flags);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 18dabb4e9cfa..f871e3f2299b 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -92,6 +92,7 @@
 #include <linux/user_namespace.h>
 #include <linux/indirect_call_wrapper.h>
 #include <linux/textsearch.h>
+#include <linux/io_uring/net.h>
 
 #include "dev.h"
 #include "devmem.h"
@@ -7476,6 +7477,8 @@ void __get_netmem(netmem_ref netmem)
 
 	if (net_is_devmem_iov(niov))
 		net_devmem_get_net_iov(netmem_to_net_iov(netmem));
+	else if (niov->type == NET_IOV_IOURING)
+		zcrx_ref_niov(niov);
 }
 EXPORT_SYMBOL(__get_netmem);
 
-- 
2.54.0


