Return-Path: <io-uring+bounces-7775-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CD08AA0060
	for <lists+io-uring@lfdr.de>; Tue, 29 Apr 2025 05:28:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7360F9227F7
	for <lists+io-uring@lfdr.de>; Tue, 29 Apr 2025 03:28:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 918D62750EF;
	Tue, 29 Apr 2025 03:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fZ1bMPt9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF982749E1
	for <io-uring@vger.kernel.org>; Tue, 29 Apr 2025 03:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745897219; cv=none; b=OuCJbDfFNS6P6z4Hh1qX4LuYWqrn+RVfKSA/RpwXUp7XoMYXmh8FUieB+3s8i2XRGFM5/6Gc1vXjutj52gckexWIfG/OmyBc7PO5Ukeyw79wQQwRS+R3qAqhxzLyp3QYCljL0K8fUUugwYf7ofxoyvpT2SS2Mwzc/usDF9eUS9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745897219; c=relaxed/simple;
	bh=0gLPoyPHQBfVqS9dILrKd3grPAVGe/kFH9Z4t/k1Mts=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mLyZ9Y7uKg5eXsoGdNm8t8b6KUMKTYHd6aZcANw4E2KEEdn+cVQzAwpPTd9pjMXHcVNMyuz1VFC0pNUUSPRNRCd9hgVcSU9ZoH2b3zai+EWP72b2w9ZX6NFa/lTRKnhe0G4xR789XqZgR1ZTRI5GVdUVNz+mDZ2jiC7BLVQrkrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fZ1bMPt9; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-73c09e99069so5586922b3a.0
        for <io-uring@vger.kernel.org>; Mon, 28 Apr 2025 20:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745897215; x=1746502015; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OouznsevJPqsgtkjMkDZWDZLny6VMnksVypaDuixiGQ=;
        b=fZ1bMPt9MoyLyBGStlpXUAdDULTeMMSCyuQenj4HOEzY5gXq3rM77q/qL3wUn66ef2
         GY3uLj+uuKH6H44StpD5Z81kOiu66dRM+gtnzMXMeUZTgQBaxmx/r6oklo0obvolxe0u
         65wpD1I3QRJh8CinzgGZ5EWBzYLKpdurZwS27s/X7zxkqsmVppR3wIBWzdfBq4hNK9GY
         kqg0sgBM8etfg29VIrIbxfnagj7xymM9cNHHlA2TH7mlPLxBHfvSwpyx7luFHgJo8ThF
         O4tMJKtjzKOwJvsu8LYSyCJyAK8xBZoWcSd6dWpodYXEQ1RxIUPM7HegFGdTJB86An9A
         8sTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745897215; x=1746502015;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OouznsevJPqsgtkjMkDZWDZLny6VMnksVypaDuixiGQ=;
        b=V6/z5/HAnUbfakkYXthOMebLpfW6z4GRcmUKV/1RelMTmRK3Y69KDnSNIqsYDi1pe0
         uOYQyMr4EYHHKaQf4YfxzW08daxC95ZnHXbEQckyqfUfrXksz0sJfvatH0IRSE19GLg7
         FCk+mKCJomFo650saC3ctf9d5xhbVGYsRXId0C6WHMeGIhFOcj6ArUFqUCze69pOX1Bh
         ORFQwxs7aXUrJaq3h+QM4uRMEIls5KQTVlf49YuK2HgY9ZtN2xWHixLKECZsq4SEWe32
         oeL686TPCB1b8sI8LH3efuxVv52jT5uRoEhCdBzKNTztUPqU/zn75Dsp5Bo/l5mi7ROD
         sdrg==
X-Forwarded-Encrypted: i=1; AJvYcCWVYZEmbxw84DbRZWnvAyTa6ZapHuncMWM345eo52qC877xqq8T96zi+xwB5kPDUpR635Bq5h9mQQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyVLPTzlFX+SAsQtmaMUCdJsEpLSUG3b80k+XCiG4KJcvv50sBi
	a3xaD2FZM3WCr4DhqkSe5K3MT8tfeiLlefk4XUv/8IC1m0nj9/rbpidlpYje4uFcu6mzXUmp428
	FcavwV7fBmmmqnq1XrmSAGQ==
X-Google-Smtp-Source: AGHT+IFjNDRxIX/e7WpoO2X52CPI5XWj/z1yuclrGBu/QIfvd7kRr1pQRYMcOl90e4ZlxegULhXdKCloMBMKKb0IpA==
X-Received: from pgg18.prod.google.com ([2002:a05:6a02:4d92:b0:b16:87c2:f3f9])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:e608:b0:1f5:8655:3287 with SMTP id adf61e73a8af0-2093e528f9bmr3309833637.40.1745897215123;
 Mon, 28 Apr 2025 20:26:55 -0700 (PDT)
Date: Tue, 29 Apr 2025 03:26:40 +0000
In-Reply-To: <20250429032645.363766-1-almasrymina@google.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250429032645.363766-1-almasrymina@google.com>
X-Mailer: git-send-email 2.49.0.901.g37484f566f-goog
Message-ID: <20250429032645.363766-5-almasrymina@google.com>
Subject: [PATCH net-next v13 4/9] net: devmem: Implement TX path
From: Mina Almasry <almasrymina@google.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, io-uring@vger.kernel.org, 
	virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: Mina Almasry <almasrymina@google.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Donald Hunter <donald.hunter@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	Jeroen de Borst <jeroendb@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, 
	Kuniyuki Iwashima <kuniyu@amazon.com>, Willem de Bruijn <willemb@google.com>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, David Ahern <dsahern@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	"=?UTF-8?q?Eugenio=20P=C3=A9rez?=" <eperezma@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, Shuah Khan <shuah@kernel.org>, sdf@fomichev.me, dw@davidwei.uk, 
	Jamal Hadi Salim <jhs@mojatatu.com>, Victor Nogueira <victor@mojatatu.com>, 
	Pedro Tammela <pctammela@mojatatu.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Kaiyuan Zhang <kaiyuanz@google.com>
Content-Type: text/plain; charset="UTF-8"

Augment dmabuf binding to be able to handle TX. Additional to all the RX
binding, we also create tx_vec needed for the TX path.

Provide API for sendmsg to be able to send dmabufs bound to this device:

- Provide a new dmabuf_tx_cmsg which includes the dmabuf to send from.
- MSG_ZEROCOPY with SCM_DEVMEM_DMABUF cmsg indicates send from dma-buf.

Devmem is uncopyable, so piggyback off the existing MSG_ZEROCOPY
implementation, while disabling instances where MSG_ZEROCOPY falls back
to copying.

We additionally pipe the binding down to the new
zerocopy_fill_skb_from_devmem which fills a TX skb with net_iov netmems
instead of the traditional page netmems.

We also special case skb_frag_dma_map to return the dma-address of these
dmabuf net_iovs instead of attempting to map pages.

The TX path may release the dmabuf in a context where we cannot wait.
This happens when the user unbinds a TX dmabuf while there are still
references to its netmems in the TX path. In that case, the netmems will
be put_netmem'd from a context where we can't unmap the dmabuf, Resolve
this by making __net_devmem_dmabuf_binding_free schedule_work'd.

Based on work by Stanislav Fomichev <sdf@fomichev.me>. A lot of the meat
of the implementation came from devmem TCP RFC v1[1], which included the
TX path, but Stan did all the rebasing on top of netmem/net_iov.

Cc: Stanislav Fomichev <sdf@fomichev.me>
Signed-off-by: Kaiyuan Zhang <kaiyuanz@google.com>
Signed-off-by: Mina Almasry <almasrymina@google.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>

---

v13:
- Fix unneeded error label (Christoph)

v11:
- Address some nits from Michael. Whitespace adjustment and remove local
  var. (Michael)

v10:
- Make sure to release netdev lock if !netif_device_present (Jakub)
- handle niov->pp == NULL in io_uring code (Pavel)

v9:
- Use priv->bindings instead of sock_bindings_list. This was missed in
  v8 during the rebase as net-next had been updated to use
  priv->bindings (thanks Stan!)

v8:
- move adding the binding to the net_devmem_dmabuf_bindings after it's
  been fully initialized to eliminate potential for races with send path
  (Stan).
- Use net_devmem_get_by_index_lock instead of rtnl_locking

v6:
- Retain behavior that MSG_FASTOPEN succeeds even if cmsg is invalid
  (Paolo).
- Rework the freeing of tx_vec slightly to improve readability. Now it
  has its own err label (Paolo).
- Squash making unbinding scheduled work (Paolo).
- Add comment to clarify that net_iovs stuck in the transmit path hold
  a ref on the underlying dmabuf binding (David).
- Fix the comment on how binding refcounting works on RX (the comment
  was not matching the existing code behavior).

v5:
- Return -EFAULT from zerocopy_fill_skb_from_devmem (Stan)
- don't null check before kvfree (stan).

v4:
- Remove dmabuf_tx_cmsg definition and just use __u32 for the dma-buf id
  (Willem).
- Check that iov_iter_type() is ITER_IOVEC in
  zerocopy_fill_skb_from_iter() (Pavel).
- Fix binding->tx_vec not being freed on error paths (Paolo).
- Make devmem patch mutually exclusive with msg->ubuf_info path (Pavel).
- Check that MSG_ZEROCOPY and SOCK_ZEROCOPY are provided when
  sockc.dmabuf_id is provided.
- Don't mm_account_pinned_pages() on devmem TX (Pavel).

v3:
- Use kvmalloc_array instead of kcalloc (Stan).
- Fix unreachable code warning (Simon).

v2:
- Remove dmabuf_offset from the dmabuf cmsg.
- Update zerocopy_fill_skb_from_devmem to interpret the
  iov_base/iter_iov_addr as the offset into the dmabuf to send from
  (Stan).
- Remove the confusing binding->tx_iter which is not needed if we
  interpret the iov_base/iter_iov_addr as offset into the dmabuf (Stan).
- Remove check for binding->sgt and binding->sgt->nents in dmabuf
  binding.
- Simplify the calculation of binding->tx_vec.
- Check in net_devmem_get_binding that the binding we're returning
  has ifindex matching the sending socket (Willem).
---
 include/linux/skbuff.h                  |  17 +++-
 include/net/sock.h                      |   1 +
 io_uring/zcrx.c                         |   2 +-
 net/core/datagram.c                     |  48 +++++++++-
 net/core/devmem.c                       | 118 ++++++++++++++++++++----
 net/core/devmem.h                       |  61 +++++++++---
 net/core/netdev-genl.c                  |  71 +++++++++++++-
 net/core/skbuff.c                       |  18 ++--
 net/core/sock.c                         |   6 ++
 net/ipv4/ip_output.c                    |   3 +-
 net/ipv4/tcp.c                          |  50 ++++++++--
 net/ipv6/ip6_output.c                   |   3 +-
 net/vmw_vsock/virtio_transport_common.c |   5 +-
 13 files changed, 341 insertions(+), 62 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index beb084ee4f4d2..5d62e8e77546c 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1710,13 +1710,16 @@ static inline void skb_set_end_offset(struct sk_buff *skb, unsigned int offset)
 extern const struct ubuf_info_ops msg_zerocopy_ubuf_ops;
 
 struct ubuf_info *msg_zerocopy_realloc(struct sock *sk, size_t size,
-				       struct ubuf_info *uarg);
+				       struct ubuf_info *uarg, bool devmem);
 
 void msg_zerocopy_put_abort(struct ubuf_info *uarg, bool have_uref);
 
+struct net_devmem_dmabuf_binding;
+
 int __zerocopy_sg_from_iter(struct msghdr *msg, struct sock *sk,
 			    struct sk_buff *skb, struct iov_iter *from,
-			    size_t length);
+			    size_t length,
+			    struct net_devmem_dmabuf_binding *binding);
 
 int zerocopy_fill_skb_from_iter(struct sk_buff *skb,
 				struct iov_iter *from, size_t length);
@@ -1724,12 +1727,14 @@ int zerocopy_fill_skb_from_iter(struct sk_buff *skb,
 static inline int skb_zerocopy_iter_dgram(struct sk_buff *skb,
 					  struct msghdr *msg, int len)
 {
-	return __zerocopy_sg_from_iter(msg, skb->sk, skb, &msg->msg_iter, len);
+	return __zerocopy_sg_from_iter(msg, skb->sk, skb, &msg->msg_iter, len,
+				       NULL);
 }
 
 int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
 			     struct msghdr *msg, int len,
-			     struct ubuf_info *uarg);
+			     struct ubuf_info *uarg,
+			     struct net_devmem_dmabuf_binding *binding);
 
 /* Internal */
 #define skb_shinfo(SKB)	((struct skb_shared_info *)(skb_end_pointer(SKB)))
@@ -3700,6 +3705,10 @@ static inline dma_addr_t __skb_frag_dma_map(struct device *dev,
 					    size_t offset, size_t size,
 					    enum dma_data_direction dir)
 {
+	if (skb_frag_is_net_iov(frag)) {
+		return netmem_to_net_iov(frag->netmem)->dma_addr + offset +
+		       frag->offset;
+	}
 	return dma_map_page(dev, skb_frag_page(frag),
 			    skb_frag_off(frag) + offset, size, dir);
 }
diff --git a/include/net/sock.h b/include/net/sock.h
index e223102337c77..f266757a37c87 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1851,6 +1851,7 @@ struct sockcm_cookie {
 	u32 tsflags;
 	u32 ts_opt_id;
 	u32 priority;
+	u32 dmabuf_id;
 };
 
 static inline void sockcm_init(struct sockcm_cookie *sockc,
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index a07ad38935c86..0c64129f5d50a 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -810,7 +810,7 @@ static int io_zcrx_recv_frag(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 		return io_zcrx_copy_frag(req, ifq, frag, off, len);
 
 	niov = netmem_to_net_iov(frag->netmem);
-	if (niov->pp->mp_ops != &io_uring_pp_zc_ops ||
+	if (!niov->pp || niov->pp->mp_ops != &io_uring_pp_zc_ops ||
 	    io_pp_to_ifq(niov->pp) != ifq)
 		return -EFAULT;
 
diff --git a/net/core/datagram.c b/net/core/datagram.c
index f0634f0cb8346..042a7dceb85ad 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -63,6 +63,8 @@
 #include <net/busy_poll.h>
 #include <crypto/hash.h>
 
+#include "devmem.h"
+
 /*
  *	Is a socket 'connection oriented' ?
  */
@@ -691,9 +693,49 @@ int zerocopy_fill_skb_from_iter(struct sk_buff *skb,
 	return 0;
 }
 
+static int
+zerocopy_fill_skb_from_devmem(struct sk_buff *skb, struct iov_iter *from,
+			      int length,
+			      struct net_devmem_dmabuf_binding *binding)
+{
+	int i = skb_shinfo(skb)->nr_frags;
+	size_t virt_addr, size, off;
+	struct net_iov *niov;
+
+	/* Devmem filling works by taking an IOVEC from the user where the
+	 * iov_addrs are interpreted as an offset in bytes into the dma-buf to
+	 * send from. We do not support other iter types.
+	 */
+	if (iov_iter_type(from) != ITER_IOVEC)
+		return -EFAULT;
+
+	while (length && iov_iter_count(from)) {
+		if (i == MAX_SKB_FRAGS)
+			return -EMSGSIZE;
+
+		virt_addr = (size_t)iter_iov_addr(from);
+		niov = net_devmem_get_niov_at(binding, virt_addr, &off, &size);
+		if (!niov)
+			return -EFAULT;
+
+		size = min_t(size_t, size, length);
+		size = min_t(size_t, size, iter_iov_len(from));
+
+		get_netmem(net_iov_to_netmem(niov));
+		skb_add_rx_frag_netmem(skb, i, net_iov_to_netmem(niov), off,
+				       size, PAGE_SIZE);
+		iov_iter_advance(from, size);
+		length -= size;
+		i++;
+	}
+
+	return 0;
+}
+
 int __zerocopy_sg_from_iter(struct msghdr *msg, struct sock *sk,
 			    struct sk_buff *skb, struct iov_iter *from,
-			    size_t length)
+			    size_t length,
+			    struct net_devmem_dmabuf_binding *binding)
 {
 	unsigned long orig_size = skb->truesize;
 	unsigned long truesize;
@@ -701,6 +743,8 @@ int __zerocopy_sg_from_iter(struct msghdr *msg, struct sock *sk,
 
 	if (msg && msg->msg_ubuf && msg->sg_from_iter)
 		ret = msg->sg_from_iter(skb, from, length);
+	else if (unlikely(binding))
+		ret = zerocopy_fill_skb_from_devmem(skb, from, length, binding);
 	else
 		ret = zerocopy_fill_skb_from_iter(skb, from, length);
 
@@ -734,7 +778,7 @@ int zerocopy_sg_from_iter(struct sk_buff *skb, struct iov_iter *from)
 	if (skb_copy_datagram_from_iter(skb, 0, from, copy))
 		return -EFAULT;
 
-	return __zerocopy_sg_from_iter(NULL, NULL, skb, from, ~0U);
+	return __zerocopy_sg_from_iter(NULL, NULL, skb, from, ~0U, NULL);
 }
 EXPORT_SYMBOL(zerocopy_sg_from_iter);
 
diff --git a/net/core/devmem.c b/net/core/devmem.c
index dca2ff7cf6923..88065e5ef6511 100644
--- a/net/core/devmem.c
+++ b/net/core/devmem.c
@@ -16,6 +16,7 @@
 #include <net/netdev_rx_queue.h>
 #include <net/page_pool/helpers.h>
 #include <net/page_pool/memory_provider.h>
+#include <net/sock.h>
 #include <trace/events/page_pool.h>
 
 #include "devmem.h"
@@ -52,8 +53,10 @@ static dma_addr_t net_devmem_get_dma_addr(const struct net_iov *niov)
 	       ((dma_addr_t)net_iov_idx(niov) << PAGE_SHIFT);
 }
 
-void __net_devmem_dmabuf_binding_free(struct net_devmem_dmabuf_binding *binding)
+void __net_devmem_dmabuf_binding_free(struct work_struct *wq)
 {
+	struct net_devmem_dmabuf_binding *binding = container_of(wq, typeof(*binding), unbind_w);
+
 	size_t size, avail;
 
 	gen_pool_for_each_chunk(binding->chunk_pool,
@@ -71,8 +74,10 @@ void __net_devmem_dmabuf_binding_free(struct net_devmem_dmabuf_binding *binding)
 	dma_buf_detach(binding->dmabuf, binding->attachment);
 	dma_buf_put(binding->dmabuf);
 	xa_destroy(&binding->bound_rxqs);
+	kvfree(binding->tx_vec);
 	kfree(binding);
 }
+EXPORT_SYMBOL(__net_devmem_dmabuf_binding_free);
 
 struct net_iov *
 net_devmem_alloc_dmabuf(struct net_devmem_dmabuf_binding *binding)
@@ -117,6 +122,13 @@ void net_devmem_unbind_dmabuf(struct net_devmem_dmabuf_binding *binding)
 	unsigned long xa_idx;
 	unsigned int rxq_idx;
 
+	xa_erase(&net_devmem_dmabuf_bindings, binding->id);
+
+	/* Ensure no tx net_devmem_lookup_dmabuf() are in flight after the
+	 * erase.
+	 */
+	synchronize_net();
+
 	if (binding->list.next)
 		list_del(&binding->list);
 
@@ -131,8 +143,6 @@ void net_devmem_unbind_dmabuf(struct net_devmem_dmabuf_binding *binding)
 		__net_mp_close_rxq(binding->dev, rxq_idx, &mp_params);
 	}
 
-	xa_erase(&net_devmem_dmabuf_bindings, binding->id);
-
 	net_devmem_dmabuf_binding_put(binding);
 }
 
@@ -166,8 +176,9 @@ int net_devmem_bind_dmabuf_to_queue(struct net_device *dev, u32 rxq_idx,
 }
 
 struct net_devmem_dmabuf_binding *
-net_devmem_bind_dmabuf(struct net_device *dev, unsigned int dmabuf_fd,
-		       struct netlink_ext_ack *extack)
+net_devmem_bind_dmabuf(struct net_device *dev,
+		       enum dma_data_direction direction,
+		       unsigned int dmabuf_fd, struct netlink_ext_ack *extack)
 {
 	struct net_devmem_dmabuf_binding *binding;
 	static u32 id_alloc_next;
@@ -189,13 +200,6 @@ net_devmem_bind_dmabuf(struct net_device *dev, unsigned int dmabuf_fd,
 	}
 
 	binding->dev = dev;
-
-	err = xa_alloc_cyclic(&net_devmem_dmabuf_bindings, &binding->id,
-			      binding, xa_limit_32b, &id_alloc_next,
-			      GFP_KERNEL);
-	if (err < 0)
-		goto err_free_binding;
-
 	xa_init_flags(&binding->bound_rxqs, XA_FLAGS_ALLOC);
 
 	refcount_set(&binding->ref, 1);
@@ -206,26 +210,36 @@ net_devmem_bind_dmabuf(struct net_device *dev, unsigned int dmabuf_fd,
 	if (IS_ERR(binding->attachment)) {
 		err = PTR_ERR(binding->attachment);
 		NL_SET_ERR_MSG(extack, "Failed to bind dmabuf to device");
-		goto err_free_id;
+		goto err_free_binding;
 	}
 
 	binding->sgt = dma_buf_map_attachment_unlocked(binding->attachment,
-						       DMA_FROM_DEVICE);
+						       direction);
 	if (IS_ERR(binding->sgt)) {
 		err = PTR_ERR(binding->sgt);
 		NL_SET_ERR_MSG(extack, "Failed to map dmabuf attachment");
 		goto err_detach;
 	}
 
+	if (direction == DMA_TO_DEVICE) {
+		binding->tx_vec = kvmalloc_array(dmabuf->size / PAGE_SIZE,
+						 sizeof(struct net_iov *),
+						 GFP_KERNEL);
+		if (!binding->tx_vec) {
+			err = -ENOMEM;
+			goto err_unmap;
+		}
+	}
+
 	/* For simplicity we expect to make PAGE_SIZE allocations, but the
 	 * binding can be much more flexible than that. We may be able to
 	 * allocate MTU sized chunks here. Leave that for future work...
 	 */
-	binding->chunk_pool =
-		gen_pool_create(PAGE_SHIFT, dev_to_node(&dev->dev));
+	binding->chunk_pool = gen_pool_create(PAGE_SHIFT,
+					      dev_to_node(&dev->dev));
 	if (!binding->chunk_pool) {
 		err = -ENOMEM;
-		goto err_unmap;
+		goto err_tx_vec;
 	}
 
 	virtual = 0;
@@ -270,24 +284,32 @@ net_devmem_bind_dmabuf(struct net_device *dev, unsigned int dmabuf_fd,
 			niov->owner = &owner->area;
 			page_pool_set_dma_addr_netmem(net_iov_to_netmem(niov),
 						      net_devmem_get_dma_addr(niov));
+			if (direction == DMA_TO_DEVICE)
+				binding->tx_vec[owner->area.base_virtual / PAGE_SIZE + i] = niov;
 		}
 
 		virtual += len;
 	}
 
+	err = xa_alloc_cyclic(&net_devmem_dmabuf_bindings, &binding->id,
+			      binding, xa_limit_32b, &id_alloc_next,
+			      GFP_KERNEL);
+	if (err < 0)
+		goto err_free_chunks;
+
 	return binding;
 
 err_free_chunks:
 	gen_pool_for_each_chunk(binding->chunk_pool,
 				net_devmem_dmabuf_free_chunk_owner, NULL);
 	gen_pool_destroy(binding->chunk_pool);
+err_tx_vec:
+	kvfree(binding->tx_vec);
 err_unmap:
 	dma_buf_unmap_attachment_unlocked(binding->attachment, binding->sgt,
 					  DMA_FROM_DEVICE);
 err_detach:
 	dma_buf_detach(dmabuf, binding->attachment);
-err_free_id:
-	xa_erase(&net_devmem_dmabuf_bindings, binding->id);
 err_free_binding:
 	kfree(binding);
 err_put_dmabuf:
@@ -295,6 +317,21 @@ net_devmem_bind_dmabuf(struct net_device *dev, unsigned int dmabuf_fd,
 	return ERR_PTR(err);
 }
 
+struct net_devmem_dmabuf_binding *net_devmem_lookup_dmabuf(u32 id)
+{
+	struct net_devmem_dmabuf_binding *binding;
+
+	rcu_read_lock();
+	binding = xa_load(&net_devmem_dmabuf_bindings, id);
+	if (binding) {
+		if (!net_devmem_dmabuf_binding_get(binding))
+			binding = NULL;
+	}
+	rcu_read_unlock();
+
+	return binding;
+}
+
 void net_devmem_get_net_iov(struct net_iov *niov)
 {
 	net_devmem_dmabuf_binding_get(net_devmem_iov_binding(niov));
@@ -305,6 +342,49 @@ void net_devmem_put_net_iov(struct net_iov *niov)
 	net_devmem_dmabuf_binding_put(net_devmem_iov_binding(niov));
 }
 
+struct net_devmem_dmabuf_binding *net_devmem_get_binding(struct sock *sk,
+							 unsigned int dmabuf_id)
+{
+	struct net_devmem_dmabuf_binding *binding;
+	struct dst_entry *dst = __sk_dst_get(sk);
+	int err = 0;
+
+	binding = net_devmem_lookup_dmabuf(dmabuf_id);
+	if (!binding || !binding->tx_vec) {
+		err = -EINVAL;
+		goto out_err;
+	}
+
+	/* The dma-addrs in this binding are only reachable to the corresponding
+	 * net_device.
+	 */
+	if (!dst || !dst->dev || dst->dev->ifindex != binding->dev->ifindex) {
+		err = -ENODEV;
+		goto out_err;
+	}
+
+	return binding;
+
+out_err:
+	if (binding)
+		net_devmem_dmabuf_binding_put(binding);
+
+	return ERR_PTR(err);
+}
+
+struct net_iov *
+net_devmem_get_niov_at(struct net_devmem_dmabuf_binding *binding,
+		       size_t virt_addr, size_t *off, size_t *size)
+{
+	if (virt_addr >= binding->dmabuf->size)
+		return NULL;
+
+	*off = virt_addr % PAGE_SIZE;
+	*size = PAGE_SIZE - *off;
+
+	return binding->tx_vec[virt_addr / PAGE_SIZE];
+}
+
 /*** "Dmabuf devmem memory provider" ***/
 
 int mp_dmabuf_devmem_init(struct page_pool *pool)
diff --git a/net/core/devmem.h b/net/core/devmem.h
index 946f2e0157467..67168aae5e5b3 100644
--- a/net/core/devmem.h
+++ b/net/core/devmem.h
@@ -23,8 +23,9 @@ struct net_devmem_dmabuf_binding {
 
 	/* The user holds a ref (via the netlink API) for as long as they want
 	 * the binding to remain alive. Each page pool using this binding holds
-	 * a ref to keep the binding alive. Each allocated net_iov holds a
-	 * ref.
+	 * a ref to keep the binding alive. The page_pool does not release the
+	 * ref until all the net_iovs allocated from this binding are released
+	 * back to the page_pool.
 	 *
 	 * The binding undos itself and unmaps the underlying dmabuf once all
 	 * those refs are dropped and the binding is no longer desired or in
@@ -32,7 +33,10 @@ struct net_devmem_dmabuf_binding {
 	 *
 	 * net_devmem_get_net_iov() on dmabuf net_iovs will increment this
 	 * reference, making sure that the binding remains alive until all the
-	 * net_iovs are no longer used.
+	 * net_iovs are no longer used. net_iovs allocated from this binding
+	 * that are stuck in the TX path for any reason (such as awaiting
+	 * retransmits) hold a reference to the binding until the skb holding
+	 * them is freed.
 	 */
 	refcount_t ref;
 
@@ -48,6 +52,14 @@ struct net_devmem_dmabuf_binding {
 	 * active.
 	 */
 	u32 id;
+
+	/* Array of net_iov pointers for this binding, sorted by virtual
+	 * address. This array is convenient to map the virtual addresses to
+	 * net_iovs in the TX path.
+	 */
+	struct net_iov **tx_vec;
+
+	struct work_struct unbind_w;
 };
 
 #if defined(CONFIG_NET_DEVMEM)
@@ -64,14 +76,17 @@ struct dmabuf_genpool_chunk_owner {
 	dma_addr_t base_dma_addr;
 };
 
-void __net_devmem_dmabuf_binding_free(struct net_devmem_dmabuf_binding *binding);
+void __net_devmem_dmabuf_binding_free(struct work_struct *wq);
 struct net_devmem_dmabuf_binding *
-net_devmem_bind_dmabuf(struct net_device *dev, unsigned int dmabuf_fd,
-		       struct netlink_ext_ack *extack);
+net_devmem_bind_dmabuf(struct net_device *dev,
+		       enum dma_data_direction direction,
+		       unsigned int dmabuf_fd, struct netlink_ext_ack *extack);
+struct net_devmem_dmabuf_binding *net_devmem_lookup_dmabuf(u32 id);
 void net_devmem_unbind_dmabuf(struct net_devmem_dmabuf_binding *binding);
 int net_devmem_bind_dmabuf_to_queue(struct net_device *dev, u32 rxq_idx,
 				    struct net_devmem_dmabuf_binding *binding,
 				    struct netlink_ext_ack *extack);
+void net_devmem_bind_tx_release(struct sock *sk);
 
 static inline struct dmabuf_genpool_chunk_owner *
 net_devmem_iov_to_chunk_owner(const struct net_iov *niov)
@@ -100,10 +115,10 @@ static inline unsigned long net_iov_virtual_addr(const struct net_iov *niov)
 	       ((unsigned long)net_iov_idx(niov) << PAGE_SHIFT);
 }
 
-static inline void
+static inline bool
 net_devmem_dmabuf_binding_get(struct net_devmem_dmabuf_binding *binding)
 {
-	refcount_inc(&binding->ref);
+	return refcount_inc_not_zero(&binding->ref);
 }
 
 static inline void
@@ -112,7 +127,8 @@ net_devmem_dmabuf_binding_put(struct net_devmem_dmabuf_binding *binding)
 	if (!refcount_dec_and_test(&binding->ref))
 		return;
 
-	__net_devmem_dmabuf_binding_free(binding);
+	INIT_WORK(&binding->unbind_w, __net_devmem_dmabuf_binding_free);
+	schedule_work(&binding->unbind_w);
 }
 
 void net_devmem_get_net_iov(struct net_iov *niov);
@@ -123,6 +139,11 @@ net_devmem_alloc_dmabuf(struct net_devmem_dmabuf_binding *binding);
 void net_devmem_free_dmabuf(struct net_iov *ppiov);
 
 bool net_is_devmem_iov(struct net_iov *niov);
+struct net_devmem_dmabuf_binding *
+net_devmem_get_binding(struct sock *sk, unsigned int dmabuf_id);
+struct net_iov *
+net_devmem_get_niov_at(struct net_devmem_dmabuf_binding *binding, size_t addr,
+		       size_t *off, size_t *size);
 
 #else
 struct net_devmem_dmabuf_binding;
@@ -140,18 +161,23 @@ static inline void net_devmem_put_net_iov(struct net_iov *niov)
 {
 }
 
-static inline void
-__net_devmem_dmabuf_binding_free(struct net_devmem_dmabuf_binding *binding)
+static inline void __net_devmem_dmabuf_binding_free(struct work_struct *wq)
 {
 }
 
 static inline struct net_devmem_dmabuf_binding *
 net_devmem_bind_dmabuf(struct net_device *dev, unsigned int dmabuf_fd,
+		       enum dma_data_direction direction,
 		       struct netlink_ext_ack *extack)
 {
 	return ERR_PTR(-EOPNOTSUPP);
 }
 
+static inline struct net_devmem_dmabuf_binding *net_devmem_lookup_dmabuf(u32 id)
+{
+	return NULL;
+}
+
 static inline void
 net_devmem_unbind_dmabuf(struct net_devmem_dmabuf_binding *binding)
 {
@@ -190,6 +216,19 @@ static inline bool net_is_devmem_iov(struct net_iov *niov)
 {
 	return false;
 }
+
+static inline struct net_devmem_dmabuf_binding *
+net_devmem_get_binding(struct sock *sk, unsigned int dmabuf_id)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
+static inline struct net_iov *
+net_devmem_get_niov_at(struct net_devmem_dmabuf_binding *binding, size_t addr,
+		       size_t *off, size_t *size)
+{
+	return NULL;
+}
 #endif
 
 #endif /* _NET_DEVMEM_H */
diff --git a/net/core/netdev-genl.c b/net/core/netdev-genl.c
index 919ce851f1174..db0e9a6a4badc 100644
--- a/net/core/netdev-genl.c
+++ b/net/core/netdev-genl.c
@@ -876,7 +876,8 @@ int netdev_nl_bind_rx_doit(struct sk_buff *skb, struct genl_info *info)
 		goto err_unlock;
 	}
 
-	binding = net_devmem_bind_dmabuf(netdev, dmabuf_fd, info->extack);
+	binding = net_devmem_bind_dmabuf(netdev, DMA_FROM_DEVICE, dmabuf_fd,
+					 info->extack);
 	if (IS_ERR(binding)) {
 		err = PTR_ERR(binding);
 		goto err_unlock;
@@ -937,10 +938,74 @@ int netdev_nl_bind_rx_doit(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
-/* stub */
 int netdev_nl_bind_tx_doit(struct sk_buff *skb, struct genl_info *info)
 {
-	return 0;
+	struct net_devmem_dmabuf_binding *binding;
+	struct netdev_nl_sock *priv;
+	struct net_device *netdev;
+	u32 ifindex, dmabuf_fd;
+	struct sk_buff *rsp;
+	int err = 0;
+	void *hdr;
+
+	if (GENL_REQ_ATTR_CHECK(info, NETDEV_A_DEV_IFINDEX) ||
+	    GENL_REQ_ATTR_CHECK(info, NETDEV_A_DMABUF_FD))
+		return -EINVAL;
+
+	ifindex = nla_get_u32(info->attrs[NETDEV_A_DEV_IFINDEX]);
+	dmabuf_fd = nla_get_u32(info->attrs[NETDEV_A_DMABUF_FD]);
+
+	priv = genl_sk_priv_get(&netdev_nl_family, NETLINK_CB(skb).sk);
+	if (IS_ERR(priv))
+		return PTR_ERR(priv);
+
+	rsp = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!rsp)
+		return -ENOMEM;
+
+	hdr = genlmsg_iput(rsp, info);
+	if (!hdr) {
+		err = -EMSGSIZE;
+		goto err_genlmsg_free;
+	}
+
+	mutex_lock(&priv->lock);
+
+	netdev = netdev_get_by_index_lock(genl_info_net(info), ifindex);
+	if (!netdev) {
+		err = -ENODEV;
+		goto err_unlock_sock;
+	}
+
+	if (!netif_device_present(netdev)) {
+		err = -ENODEV;
+		goto err_unlock_netdev;
+	}
+
+	binding = net_devmem_bind_dmabuf(netdev, DMA_TO_DEVICE, dmabuf_fd,
+					 info->extack);
+	if (IS_ERR(binding)) {
+		err = PTR_ERR(binding);
+		goto err_unlock_netdev;
+	}
+
+	list_add(&binding->list, &priv->bindings);
+
+	nla_put_u32(rsp, NETDEV_A_DMABUF_ID, binding->id);
+	genlmsg_end(rsp, hdr);
+
+	netdev_unlock(netdev);
+	mutex_unlock(&priv->lock);
+
+	return genlmsg_reply(rsp, info);
+
+err_unlock_netdev:
+	netdev_unlock(netdev);
+err_unlock_sock:
+	mutex_unlock(&priv->lock);
+err_genlmsg_free:
+	nlmsg_free(rsp);
+	return err;
 }
 
 void netdev_nl_sock_priv_init(struct netdev_nl_sock *priv)
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 00c22bce98e44..4159107f1666c 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1655,7 +1655,8 @@ void mm_unaccount_pinned_pages(struct mmpin *mmp)
 }
 EXPORT_SYMBOL_GPL(mm_unaccount_pinned_pages);
 
-static struct ubuf_info *msg_zerocopy_alloc(struct sock *sk, size_t size)
+static struct ubuf_info *msg_zerocopy_alloc(struct sock *sk, size_t size,
+					    bool devmem)
 {
 	struct ubuf_info_msgzc *uarg;
 	struct sk_buff *skb;
@@ -1670,7 +1671,7 @@ static struct ubuf_info *msg_zerocopy_alloc(struct sock *sk, size_t size)
 	uarg = (void *)skb->cb;
 	uarg->mmp.user = NULL;
 
-	if (mm_account_pinned_pages(&uarg->mmp, size)) {
+	if (likely(!devmem) && mm_account_pinned_pages(&uarg->mmp, size)) {
 		kfree_skb(skb);
 		return NULL;
 	}
@@ -1693,7 +1694,7 @@ static inline struct sk_buff *skb_from_uarg(struct ubuf_info_msgzc *uarg)
 }
 
 struct ubuf_info *msg_zerocopy_realloc(struct sock *sk, size_t size,
-				       struct ubuf_info *uarg)
+				       struct ubuf_info *uarg, bool devmem)
 {
 	if (uarg) {
 		struct ubuf_info_msgzc *uarg_zc;
@@ -1723,7 +1724,8 @@ struct ubuf_info *msg_zerocopy_realloc(struct sock *sk, size_t size,
 
 		next = (u32)atomic_read(&sk->sk_zckey);
 		if ((u32)(uarg_zc->id + uarg_zc->len) == next) {
-			if (mm_account_pinned_pages(&uarg_zc->mmp, size))
+			if (likely(!devmem) &&
+			    mm_account_pinned_pages(&uarg_zc->mmp, size))
 				return NULL;
 			uarg_zc->len++;
 			uarg_zc->bytelen = bytelen;
@@ -1738,7 +1740,7 @@ struct ubuf_info *msg_zerocopy_realloc(struct sock *sk, size_t size,
 	}
 
 new_alloc:
-	return msg_zerocopy_alloc(sk, size);
+	return msg_zerocopy_alloc(sk, size, devmem);
 }
 EXPORT_SYMBOL_GPL(msg_zerocopy_realloc);
 
@@ -1842,7 +1844,8 @@ EXPORT_SYMBOL_GPL(msg_zerocopy_ubuf_ops);
 
 int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
 			     struct msghdr *msg, int len,
-			     struct ubuf_info *uarg)
+			     struct ubuf_info *uarg,
+			     struct net_devmem_dmabuf_binding *binding)
 {
 	int err, orig_len = skb->len;
 
@@ -1861,7 +1864,8 @@ int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
 			return -EEXIST;
 	}
 
-	err = __zerocopy_sg_from_iter(msg, sk, skb, &msg->msg_iter, len);
+	err = __zerocopy_sg_from_iter(msg, sk, skb, &msg->msg_iter, len,
+				      binding);
 	if (err == -EFAULT || (err == -EMSGSIZE && skb->len == orig_len)) {
 		struct sock *save_sk = skb->sk;
 
diff --git a/net/core/sock.c b/net/core/sock.c
index b64df2463300b..9dd2989040357 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3017,6 +3017,12 @@ int __sock_cmsg_send(struct sock *sk, struct cmsghdr *cmsg,
 		if (!sk_set_prio_allowed(sk, *(u32 *)CMSG_DATA(cmsg)))
 			return -EPERM;
 		sockc->priority = *(u32 *)CMSG_DATA(cmsg);
+		break;
+	case SCM_DEVMEM_DMABUF:
+		if (cmsg->cmsg_len != CMSG_LEN(sizeof(u32)))
+			return -EINVAL;
+		sockc->dmabuf_id = *(u32 *)CMSG_DATA(cmsg);
+
 		break;
 	default:
 		return -EINVAL;
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 6e18d7ec50624..a2705d454fd64 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1014,7 +1014,8 @@ static int __ip_append_data(struct sock *sk,
 				uarg = msg->msg_ubuf;
 			}
 		} else if (sock_flag(sk, SOCK_ZEROCOPY)) {
-			uarg = msg_zerocopy_realloc(sk, length, skb_zcopy(skb));
+			uarg = msg_zerocopy_realloc(sk, length, skb_zcopy(skb),
+						    false);
 			if (!uarg)
 				return -ENOBUFS;
 			extra_uref = !skb_zcopy(skb);	/* only ref on new uarg */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 86c427f166367..b4ba21717e254 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1059,6 +1059,7 @@ int tcp_sendmsg_fastopen(struct sock *sk, struct msghdr *msg, int *copied,
 
 int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 {
+	struct net_devmem_dmabuf_binding *binding = NULL;
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct ubuf_info *uarg = NULL;
 	struct sk_buff *skb;
@@ -1066,11 +1067,24 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 	int flags, err, copied = 0;
 	int mss_now = 0, size_goal, copied_syn = 0;
 	int process_backlog = 0;
+	bool sockc_valid = true;
 	int zc = 0;
 	long timeo;
 
 	flags = msg->msg_flags;
 
+	sockc = (struct sockcm_cookie){ .tsflags = READ_ONCE(sk->sk_tsflags),
+					.dmabuf_id = 0 };
+	if (msg->msg_controllen) {
+		err = sock_cmsg_send(sk, msg, &sockc);
+		if (unlikely(err))
+			/* Don't return error until MSG_FASTOPEN has been
+			 * processed; that may succeed even if the cmsg is
+			 * invalid.
+			 */
+			sockc_valid = false;
+	}
+
 	if ((flags & MSG_ZEROCOPY) && size) {
 		if (msg->msg_ubuf) {
 			uarg = msg->msg_ubuf;
@@ -1078,7 +1092,8 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 				zc = MSG_ZEROCOPY;
 		} else if (sock_flag(sk, SOCK_ZEROCOPY)) {
 			skb = tcp_write_queue_tail(sk);
-			uarg = msg_zerocopy_realloc(sk, size, skb_zcopy(skb));
+			uarg = msg_zerocopy_realloc(sk, size, skb_zcopy(skb),
+						    sockc_valid && !!sockc.dmabuf_id);
 			if (!uarg) {
 				err = -ENOBUFS;
 				goto out_err;
@@ -1087,12 +1102,27 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 				zc = MSG_ZEROCOPY;
 			else
 				uarg_to_msgzc(uarg)->zerocopy = 0;
+
+			if (sockc_valid && sockc.dmabuf_id) {
+				binding = net_devmem_get_binding(sk, sockc.dmabuf_id);
+				if (IS_ERR(binding)) {
+					err = PTR_ERR(binding);
+					binding = NULL;
+					goto out_err;
+				}
+			}
 		}
 	} else if (unlikely(msg->msg_flags & MSG_SPLICE_PAGES) && size) {
 		if (sk->sk_route_caps & NETIF_F_SG)
 			zc = MSG_SPLICE_PAGES;
 	}
 
+	if (sockc_valid && sockc.dmabuf_id &&
+	    (!(flags & MSG_ZEROCOPY) || !sock_flag(sk, SOCK_ZEROCOPY))) {
+		err = -EINVAL;
+		goto out_err;
+	}
+
 	if (unlikely(flags & MSG_FASTOPEN ||
 		     inet_test_bit(DEFER_CONNECT, sk)) &&
 	    !tp->repair) {
@@ -1131,14 +1161,8 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 		/* 'common' sending to sendq */
 	}
 
-	sockc = (struct sockcm_cookie) { .tsflags = READ_ONCE(sk->sk_tsflags)};
-	if (msg->msg_controllen) {
-		err = sock_cmsg_send(sk, msg, &sockc);
-		if (unlikely(err)) {
-			err = -EINVAL;
-			goto out_err;
-		}
-	}
+	if (!sockc_valid)
+		goto out_err;
 
 	/* This should be in poll */
 	sk_clear_bit(SOCKWQ_ASYNC_NOSPACE, sk);
@@ -1258,7 +1282,8 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 					goto wait_for_space;
 			}
 
-			err = skb_zerocopy_iter_stream(sk, skb, msg, copy, uarg);
+			err = skb_zerocopy_iter_stream(sk, skb, msg, copy, uarg,
+						       binding);
 			if (err == -EMSGSIZE || err == -EEXIST) {
 				tcp_mark_push(tp, skb);
 				goto new_segment;
@@ -1339,6 +1364,8 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 	/* msg->msg_ubuf is pinned by the caller so we don't take extra refs */
 	if (uarg && !msg->msg_ubuf)
 		net_zcopy_put(uarg);
+	if (binding)
+		net_devmem_dmabuf_binding_put(binding);
 	return copied + copied_syn;
 
 do_error:
@@ -1356,6 +1383,9 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 		sk->sk_write_space(sk);
 		tcp_chrono_stop(sk, TCP_CHRONO_SNDBUF_LIMITED);
 	}
+	if (binding)
+		net_devmem_dmabuf_binding_put(binding);
+
 	return err;
 }
 EXPORT_SYMBOL_GPL(tcp_sendmsg_locked);
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index ef052ccd93800..7bd29a9ff0db8 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1524,7 +1524,8 @@ static int __ip6_append_data(struct sock *sk,
 				uarg = msg->msg_ubuf;
 			}
 		} else if (sock_flag(sk, SOCK_ZEROCOPY)) {
-			uarg = msg_zerocopy_realloc(sk, length, skb_zcopy(skb));
+			uarg = msg_zerocopy_realloc(sk, length, skb_zcopy(skb),
+						    false);
 			if (!uarg)
 				return -ENOBUFS;
 			extra_uref = !skb_zcopy(skb);	/* only ref on new uarg */
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 7f7de6d880965..6e7b727c781c8 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -87,7 +87,7 @@ static int virtio_transport_init_zcopy_skb(struct vsock_sock *vsk,
 
 		uarg = msg_zerocopy_realloc(sk_vsock(vsk),
 					    iter->count,
-					    NULL);
+					    NULL, false);
 		if (!uarg)
 			return -1;
 
@@ -107,8 +107,7 @@ static int virtio_transport_fill_skb(struct sk_buff *skb,
 {
 	if (zcopy)
 		return __zerocopy_sg_from_iter(info->msg, NULL, skb,
-					       &info->msg->msg_iter,
-					       len);
+					       &info->msg->msg_iter, len, NULL);
 
 	return memcpy_from_msg(skb_put(skb, len), info->msg, len);
 }
-- 
2.49.0.901.g37484f566f-goog


