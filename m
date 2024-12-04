Return-Path: <io-uring+bounces-5217-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0E4F9E4290
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 18:57:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A8C56169B69
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 17:57:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 106E22144CC;
	Wed,  4 Dec 2024 17:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="L4wKlChl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B71B2144B3
	for <io-uring@vger.kernel.org>; Wed,  4 Dec 2024 17:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733332968; cv=none; b=JKsKxEbJwmvpkedJmwWKWqcUGshn/ufMfyYwyzaXOTWyH99UVGtvF0JiYu4CmPU/9Uk4h/4R6T2bidpC1Sj3GsySB+8g6sLMs7FrRvClJ+K3hhled5+gMTovcdTESvqI0w0rZJD9c6OEhYNxlIVApW/ic1bysnxkozY04K55m0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733332968; c=relaxed/simple;
	bh=P7m2r+GGyBrkWHJpfb3T2MQ50jGabcCk7WvGavxVWCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IsX2nMjrzN/9Ie364i4A9ozz3iOWRyJ7UTA8UqcobdRIjf/j0OdoBoHLcDdRHAeqzB0ifhKpu4HGlrnFS/ausWtMwoaXcCZkH7ukx3rc2Ji2L6DtTMQ1ZT9UKa9BONpccP+YofewVesOSQSrKBqkXFHGYYXDChdoDGaCE7AKEhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=L4wKlChl; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-7fc340eb006so38525a12.0
        for <io-uring@vger.kernel.org>; Wed, 04 Dec 2024 09:22:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1733332967; x=1733937767; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UAFZQHh3Txu/JunB7wOIdrBL3yg0y/5ImZqDpMhl7A4=;
        b=L4wKlChlne7SjUQA/cuIChLwVQE2Xn+SuaXU6hUSAeGkyVOKs7VmpuRja+i6qTHLG4
         Up0ezqegZNT1qbPmEgNRUoULn6hvSsWRm7SFOPSvL1Z/RCNVLmoKzsgDRf6LAQ5uj6qb
         rshnPg5qFY4TiRJ1v5TIBmTcECCZ5PWoFI8kPa+tOmt3cEPeG4C5sw4Gu7vX/ypH9lOa
         X1JyMI9uN44hsUxavD/CwqkhF0Fp6LDENOLj5gkXKmai9HdlYUjUBKeDcHWrNe6kldP/
         hgRuCArQSQAXMkaA4aDh7Jj+5lu2LF7G/0xETJ86iMKqZ3ppyv9DWuD1J9m5RnW1YyDV
         7A/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733332967; x=1733937767;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UAFZQHh3Txu/JunB7wOIdrBL3yg0y/5ImZqDpMhl7A4=;
        b=A0kn4amWF2VfXcabawIKnTlB3xEzCCBsTyVRS1wlqljTHmsu7l3Dhj/bQvSoVKKEFM
         94GA5ywRwwk4GHsYJlno+zmc2tH1D6pt/gtGe19i+oPj/ER8A4Gtb8EWZotEUNT72GVY
         EmbefA2iYVjQdQgBLLaOa10AzavwgDxkqsWT/2CBe1iqsAFNmlQ6MOyAhE5Kodsn9lY4
         w7R6gV5dfrsyLqZw4bEmmrvZ6pMGnhPXYUelIkPZASb72zMuh0eDvLUxI1e11+GtvY6C
         WRDa0jy4z42mwzTOdDmY4yj/CqE+vdOEMSJltOYmRop1vqTk2MTIgrIAT8Wdj1sB7XuE
         mQVg==
X-Gm-Message-State: AOJu0YwiDS7lqAqJNrxq6Li8N+CX6GIhdliSsoHHIv53AVfLjwlVwGYg
	K8uiXps7MaItEwmfdS4YpAJiUxxOgdRqlR9P6yxRGKipK5XXxIyYohPw6+9NrgpgwL0EEQ25kPo
	4
X-Gm-Gg: ASbGncsZGiDvF/BHyjzpUbV89CTTjJ1JODwxd0tOk8pf3ghFpSLAnRHvbETzz1Jl19d
	Xl9LnZGmYuRJBpAS72UqfJpnJPtEQvdrAf5ZKEcLGywXmfMJI8V0bNhOtMSxZuClxGfZMOmaSog
	sfe6SxQIZHbyqFZPxtbbHue3iEGxcWWRLGuckJutyD4GWr0m8Vw4KBiRVmenK3/2bgxPnunqYkl
	Xz9vwipY1R6eYU67Z2w3hwXjN68ROaI0WY=
X-Google-Smtp-Source: AGHT+IFVRKzIKF0vxlA7OrnnNXDfVXr1Fm5L5r0h9paEQoDxU+ErYnNastbW5tDfNZhy9/bW+sQkqA==
X-Received: by 2002:a05:6a20:2587:b0:1e0:d766:8da1 with SMTP id adf61e73a8af0-1e16541097bmr9838822637.39.1733332966818;
        Wed, 04 Dec 2024 09:22:46 -0800 (PST)
Received: from localhost ([2a03:2880:ff:74::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72541849c1csm12572290b3a.200.2024.12.04.09.22.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2024 09:22:46 -0800 (PST)
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
Subject: [PATCH net-next v8 04/17] net: prepare for non devmem TCP memory providers
Date: Wed,  4 Dec 2024 09:21:43 -0800
Message-ID: <20241204172204.4180482-5-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241204172204.4180482-1-dw@davidwei.uk>
References: <20241204172204.4180482-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

There is a good bunch of places in generic paths assuming that the only
page pool memory provider is devmem TCP. As we want to reuse the net_iov
and provider infrastructure, we need to patch it up and explicitly check
the provider type when we branch into devmem TCP code.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 net/core/devmem.c         | 10 ++++++++--
 net/core/devmem.h         |  8 ++++++++
 net/core/page_pool_user.c | 15 +++++++++------
 net/ipv4/tcp.c            |  6 ++++++
 4 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/net/core/devmem.c b/net/core/devmem.c
index 01738029e35c..78983a98e5dc 100644
--- a/net/core/devmem.c
+++ b/net/core/devmem.c
@@ -28,6 +28,12 @@ static DEFINE_XARRAY_FLAGS(net_devmem_dmabuf_bindings, XA_FLAGS_ALLOC1);
 
 static const struct memory_provider_ops dmabuf_devmem_ops;
 
+bool net_is_devmem_page_pool_ops(const struct memory_provider_ops *ops)
+{
+	return ops == &dmabuf_devmem_ops;
+}
+EXPORT_SYMBOL_GPL(net_is_devmem_page_pool_ops);
+
 static void net_devmem_dmabuf_free_chunk_owner(struct gen_pool *genpool,
 					       struct gen_pool_chunk *chunk,
 					       void *not_used)
@@ -316,10 +322,10 @@ void dev_dmabuf_uninstall(struct net_device *dev)
 	unsigned int i;
 
 	for (i = 0; i < dev->real_num_rx_queues; i++) {
-		binding = dev->_rx[i].mp_params.mp_priv;
-		if (!binding)
+		if (dev->_rx[i].mp_params.mp_ops != &dmabuf_devmem_ops)
 			continue;
 
+		binding = dev->_rx[i].mp_params.mp_priv;
 		xa_for_each(&binding->bound_rxqs, xa_idx, rxq)
 			if (rxq == &dev->_rx[i]) {
 				xa_erase(&binding->bound_rxqs, xa_idx);
diff --git a/net/core/devmem.h b/net/core/devmem.h
index a2b9913e9a17..a3fdd66bb05b 100644
--- a/net/core/devmem.h
+++ b/net/core/devmem.h
@@ -116,6 +116,8 @@ struct net_iov *
 net_devmem_alloc_dmabuf(struct net_devmem_dmabuf_binding *binding);
 void net_devmem_free_dmabuf(struct net_iov *ppiov);
 
+bool net_is_devmem_page_pool_ops(const struct memory_provider_ops *ops);
+
 #else
 struct net_devmem_dmabuf_binding;
 
@@ -168,6 +170,12 @@ static inline u32 net_devmem_iov_binding_id(const struct net_iov *niov)
 {
 	return 0;
 }
+
+static inline bool
+net_is_devmem_page_pool_ops(const struct memory_provider_ops *ops)
+{
+	return false;
+}
 #endif
 
 #endif /* _NET_DEVMEM_H */
diff --git a/net/core/page_pool_user.c b/net/core/page_pool_user.c
index 48335766c1bf..604862a73535 100644
--- a/net/core/page_pool_user.c
+++ b/net/core/page_pool_user.c
@@ -214,7 +214,7 @@ static int
 page_pool_nl_fill(struct sk_buff *rsp, const struct page_pool *pool,
 		  const struct genl_info *info)
 {
-	struct net_devmem_dmabuf_binding *binding = pool->mp_priv;
+	struct net_devmem_dmabuf_binding *binding;
 	size_t inflight, refsz;
 	void *hdr;
 
@@ -244,8 +244,11 @@ page_pool_nl_fill(struct sk_buff *rsp, const struct page_pool *pool,
 			 pool->user.detach_time))
 		goto err_cancel;
 
-	if (binding && nla_put_u32(rsp, NETDEV_A_PAGE_POOL_DMABUF, binding->id))
-		goto err_cancel;
+	if (net_is_devmem_page_pool_ops(pool->mp_ops)) {
+		binding = pool->mp_priv;
+		if (nla_put_u32(rsp, NETDEV_A_PAGE_POOL_DMABUF, binding->id))
+			goto err_cancel;
+	}
 
 	genlmsg_end(rsp, hdr);
 
@@ -353,16 +356,16 @@ void page_pool_unlist(struct page_pool *pool)
 int page_pool_check_memory_provider(struct net_device *dev,
 				    struct netdev_rx_queue *rxq)
 {
-	struct net_devmem_dmabuf_binding *binding = rxq->mp_params.mp_priv;
+	void *mp_priv = rxq->mp_params.mp_priv;
 	struct page_pool *pool;
 	struct hlist_node *n;
 
-	if (!binding)
+	if (!mp_priv)
 		return 0;
 
 	mutex_lock(&page_pools_lock);
 	hlist_for_each_entry_safe(pool, n, &dev->page_pools, user.list) {
-		if (pool->mp_priv != binding)
+		if (pool->mp_priv != mp_priv)
 			continue;
 
 		if (pool->slow.queue_idx == get_netdev_rx_queue_index(rxq)) {
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index b872de9a8271..f22005c70fd3 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -277,6 +277,7 @@
 #include <net/ip.h>
 #include <net/sock.h>
 #include <net/rstreason.h>
+#include <net/page_pool/types.h>
 
 #include <linux/uaccess.h>
 #include <asm/ioctls.h>
@@ -2476,6 +2477,11 @@ static int tcp_recvmsg_dmabuf(struct sock *sk, const struct sk_buff *skb,
 			}
 
 			niov = skb_frag_net_iov(frag);
+			if (net_is_devmem_page_pool_ops(niov->pp->mp_ops)) {
+				err = -ENODEV;
+				goto out;
+			}
+
 			end = start + skb_frag_size(frag);
 			copy = end - offset;
 
-- 
2.43.5


