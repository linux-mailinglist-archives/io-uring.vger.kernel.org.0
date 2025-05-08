Return-Path: <io-uring+bounces-7898-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A5E7AAF01F
	for <lists+io-uring@lfdr.de>; Thu,  8 May 2025 02:49:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9E835500E12
	for <lists+io-uring@lfdr.de>; Thu,  8 May 2025 00:49:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA3761B422A;
	Thu,  8 May 2025 00:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GhWrb+C8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A81D15687D
	for <io-uring@vger.kernel.org>; Thu,  8 May 2025 00:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746665318; cv=none; b=JuirqFdoMbnjDIv9DkuMaHwhuB9zQH4tz2BPsRHhb+ZEvSA5l9GJfn4jW25wkDMABAax6vzaqy5SQZyJgj0wrf1dLnRZ3/yQseKQ81cMMvmgxapbjVaLbQSe8qKMNtGIOckQFvvKSotNuXyl3Iqx+/C9vXZeZypnPn4LahiZdCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746665318; c=relaxed/simple;
	bh=dyqcNTk9OPsrtIpqTgjziEIAqTB6qpkn/n/NvMbCZEI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Papkpy4278Pj1M90GnEzDfaVeK9+nBZZw45IHiTwRBPMvBiQCeB5EzOteFnXVoTFKbLvAq+RtLQstUO95kYHjkLeQaDbe2bv9bZpXyZHD3IVkMoFayYzo053CcX8CG/v6P8OYG7nJuuEnxULKS+HCALIW/l5Q4NSpnxQK3jyMmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GhWrb+C8; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-22e3b59e46eso6038215ad.2
        for <io-uring@vger.kernel.org>; Wed, 07 May 2025 17:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746665316; x=1747270116; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kYDyR9CQ41BaDC42YOSlqGxpvCJv7HXaEYFXBgq5RBU=;
        b=GhWrb+C87m01B8jmhmUiMpBL5ofGhLPaZpZT5FU0q6P2pCTTJdzxPX9hGJZrq9R7Nq
         FCKopLlT7I2jH2MxdZOLvLL1pVNmsr27Ut9BwlPnMWXWO+Qlh938Nqsf+oL41JXNcuDl
         0iyawIQ7SksEp3O7yh922KNRHIZQy0Zx6o9tv/cb5gZNGSI/oK2X4vypag7pXaGbbtTL
         76bxmsSeWCbpRropEXW8GJgYNKXB0eYCYK9tcG9tYrUVeDxQe4HY+hbfynhhSx3nuNu4
         kmH7s0G+o5iyJEeCAecY/CnVvc0RgEFKwA8UcRuEgaCiluwUncrwDPvT1NVe77QIGDjs
         iQkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746665316; x=1747270116;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kYDyR9CQ41BaDC42YOSlqGxpvCJv7HXaEYFXBgq5RBU=;
        b=D59aJAc7ZPPmOHbITNZJzmModEU5aA8ijwS+pTLytBFuDl851frzEqZIrVTJTE+jik
         U3WxPQTiEMgWIH8XpF9JAmKCQQexexSgoKukRNidAEayIJSO5BfboLxshiw5UKzWS41E
         HCK/VJRErGkh0kzw1jWiMzSiQgagcH6RFf7fMdek+JVTVWvPrVhkCaIQcb9cR0EwkCPh
         3Z2fwAavIWiQc1+0erJ6sSztJhDjR7/fyPeIa8O7GZ87F8f6Bkw66YfM6mbwRl6t3pjO
         CToo6Cfq4PhIqP3jpJV8/1RAcAgA9RSpOYGuqmQwUAUsQK9k5bXeUmtIcsfUDX4rmi7W
         JbDA==
X-Forwarded-Encrypted: i=1; AJvYcCV2essL7Tpetx4a/iv55LDX6W1OpGL/fju1oQZQmfuIqvJIsw1JnLlfrGPEpFfUzRZUN/ImGKza+Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YwacdrwFW0DKjIjPdbeuugOWYFS66T059hDPhkh1a7evd+wg4W+
	Dijb2j7wcCENrvJew7kCugt5HyyLH4mGTnKALBlis4qWp3O+kPzodms25LmhY8QWblDxhJlrKTp
	I5aW/k0/FfpA5aKeDUkP0FA==
X-Google-Smtp-Source: AGHT+IFacogxr0ODO6PRxraF8YX4ITl4t0rUQ989b/4Z3MefJOwdb8bNyzEquX5FLpjdtycoEOAfqSD9j7c/SD4+Ug==
X-Received: from plblg15.prod.google.com ([2002:a17:902:fb8f:b0:22e:4574:b2bc])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:db0c:b0:22e:5e05:b89d with SMTP id d9443c01a7336-22e5ea7caeamr77706365ad.16.1746665315831;
 Wed, 07 May 2025 17:48:35 -0700 (PDT)
Date: Thu,  8 May 2025 00:48:22 +0000
In-Reply-To: <20250508004830.4100853-1-almasrymina@google.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250508004830.4100853-1-almasrymina@google.com>
X-Mailer: git-send-email 2.49.0.987.g0cc8ee98dc-goog
Message-ID: <20250508004830.4100853-3-almasrymina@google.com>
Subject: [PATCH net-next v14 2/9] net: add get_netmem/put_netmem support
From: Mina Almasry <almasrymina@google.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, io-uring@vger.kernel.org, 
	virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: Mina Almasry <almasrymina@google.com>, Donald Hunter <donald.hunter@gmail.com>, 
	Jakub Kicinski <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	Jeroen de Borst <jeroendb@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, 
	Kuniyuki Iwashima <kuniyu@amazon.com>, Willem de Bruijn <willemb@google.com>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, David Ahern <dsahern@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	"=?UTF-8?q?Eugenio=20P=C3=A9rez?=" <eperezma@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, Shuah Khan <shuah@kernel.org>, sdf@fomichev.me, dw@davidwei.uk, 
	Jamal Hadi Salim <jhs@mojatatu.com>, Victor Nogueira <victor@mojatatu.com>, 
	Pedro Tammela <pctammela@mojatatu.com>, Samiullah Khawaja <skhawaja@google.com>
Content-Type: text/plain; charset="UTF-8"

Currently net_iovs support only pp ref counts, and do not support a
page ref equivalent.

This is fine for the RX path as net_iovs are used exclusively with the
pp and only pp refcounting is needed there. The TX path however does not
use pp ref counts, thus, support for get_page/put_page equivalent is
needed for netmem.

Support get_netmem/put_netmem. Check the type of the netmem before
passing it to page or net_iov specific code to obtain a page ref
equivalent.

For dmabuf net_iovs, we obtain a ref on the underlying binding. This
ensures the entire binding doesn't disappear until all the net_iovs have
been put_netmem'ed. We do not need to track the refcount of individual
dmabuf net_iovs as we don't allocate/free them from a pool similar to
what the buddy allocator does for pages.

This code is written to be extensible by other net_iov implementers.
get_netmem/put_netmem will check the type of the netmem and route it to
the correct helper:

pages -> [get|put]_page()
dmabuf net_iovs -> net_devmem_[get|put]_net_iov()
new net_iovs ->	new helpers

Signed-off-by: Mina Almasry <almasrymina@google.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>

---

v5: https://lore.kernel.org/netdev/20250227041209.2031104-2-almasrymina@google.com/

- Updated to check that the net_iov is devmem before calling
  net_devmem_put_net_iov().

- Jakub requested that callers of __skb_frag_ref()/skb_page_unref be
  inspected to make sure that they generate / anticipate skbs with the
  correct pp_recycle and unreadable setting:

skb_page_unref
==============

- skb_page_unref is unreachable from these callers due to unreadable
  checks returning early:

gro_pull_from_frag0, skb_copy_ubufs, __pskb_pull_tail

-  callers that are reachable for unreadable skbs. These would only see rx
   unreadable skbs with pp_recycle set before this patchset and would drop
   a pp ref count. After this patchset they can see tx unreadable skbs
   with no pp attached and no pp_recycle set, and so now they will drop
   a net_iov ref via put_netmem:

__pskb_trim, __pskb_trim_head, skb_release_data, skb_shift

__skb_frag_ref
==============

Before this patchset __skb_frag_ref would not do the right thing if it
saw any unreadable skbs, either with pp_recycle set or not. Because it
unconditionally tries to acquire a page ref, but with RX only support I
can't reproduce calls to __skb_frag_ref even after enabling tc forwarding
to TX.

After this patchset __skb_frag_ref would obtain a page ref equivalent on
dmabuf net_iovs, by obtaining a ref on the binding.

Callers that are unreachable for unreadable skbs:

- veth_xdp_get

Callers that are reachable for unreadable skbs, and from code review they
look specific to the TX path:

- tcp_grow_skb, __skb_zcopy_downgrade_managed, __pskb_copy_fclone,
  pskb_expand_head, skb_zerocopy, skb_split, pksb_carve_inside_header,
  pskb_care_inside_nonlinear, tcp_clone_payload, skb_segment.

Callers that are reachable for unreadable skbs, and from code review they
look reachable in the RX path, although my testing never hit these
paths. These are concerning. Maybe we should put this patch in net and
cc stable? However, no drivers currently enable unreadable netmem, so
fixing this in net-next is fine as well maybe:

- skb_shift, skb_try_coalesce

v2:
- Add comment on top of refcount_t ref explaining the usage in the XT
  path.
- Fix missing definition of net_devmem_dmabuf_binding_put in this patch.

---
 include/linux/skbuff_ref.h |  4 ++--
 include/net/netmem.h       |  3 +++
 net/core/devmem.c          | 10 ++++++++++
 net/core/devmem.h          | 20 ++++++++++++++++++++
 net/core/skbuff.c          | 30 ++++++++++++++++++++++++++++++
 5 files changed, 65 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff_ref.h b/include/linux/skbuff_ref.h
index 0f3c58007488a..9e49372ef1a05 100644
--- a/include/linux/skbuff_ref.h
+++ b/include/linux/skbuff_ref.h
@@ -17,7 +17,7 @@
  */
 static inline void __skb_frag_ref(skb_frag_t *frag)
 {
-	get_page(skb_frag_page(frag));
+	get_netmem(skb_frag_netmem(frag));
 }
 
 /**
@@ -40,7 +40,7 @@ static inline void skb_page_unref(netmem_ref netmem, bool recycle)
 	if (recycle && napi_pp_put_page(netmem))
 		return;
 #endif
-	put_page(netmem_to_page(netmem));
+	put_netmem(netmem);
 }
 
 /**
diff --git a/include/net/netmem.h b/include/net/netmem.h
index 973fdbcfef38b..ecb6b29c93f61 100644
--- a/include/net/netmem.h
+++ b/include/net/netmem.h
@@ -273,4 +273,7 @@ static inline unsigned long netmem_get_dma_addr(netmem_ref netmem)
 	return __netmem_clear_lsb(netmem)->dma_addr;
 }
 
+void get_netmem(netmem_ref netmem);
+void put_netmem(netmem_ref netmem);
+
 #endif /* _NET_NETMEM_H */
diff --git a/net/core/devmem.c b/net/core/devmem.c
index f5c3a7e6dbb7b..dca2ff7cf6923 100644
--- a/net/core/devmem.c
+++ b/net/core/devmem.c
@@ -295,6 +295,16 @@ net_devmem_bind_dmabuf(struct net_device *dev, unsigned int dmabuf_fd,
 	return ERR_PTR(err);
 }
 
+void net_devmem_get_net_iov(struct net_iov *niov)
+{
+	net_devmem_dmabuf_binding_get(net_devmem_iov_binding(niov));
+}
+
+void net_devmem_put_net_iov(struct net_iov *niov)
+{
+	net_devmem_dmabuf_binding_put(net_devmem_iov_binding(niov));
+}
+
 /*** "Dmabuf devmem memory provider" ***/
 
 int mp_dmabuf_devmem_init(struct page_pool *pool)
diff --git a/net/core/devmem.h b/net/core/devmem.h
index 7fc158d527293..946f2e0157467 100644
--- a/net/core/devmem.h
+++ b/net/core/devmem.h
@@ -29,6 +29,10 @@ struct net_devmem_dmabuf_binding {
 	 * The binding undos itself and unmaps the underlying dmabuf once all
 	 * those refs are dropped and the binding is no longer desired or in
 	 * use.
+	 *
+	 * net_devmem_get_net_iov() on dmabuf net_iovs will increment this
+	 * reference, making sure that the binding remains alive until all the
+	 * net_iovs are no longer used.
 	 */
 	refcount_t ref;
 
@@ -111,6 +115,9 @@ net_devmem_dmabuf_binding_put(struct net_devmem_dmabuf_binding *binding)
 	__net_devmem_dmabuf_binding_free(binding);
 }
 
+void net_devmem_get_net_iov(struct net_iov *niov);
+void net_devmem_put_net_iov(struct net_iov *niov);
+
 struct net_iov *
 net_devmem_alloc_dmabuf(struct net_devmem_dmabuf_binding *binding);
 void net_devmem_free_dmabuf(struct net_iov *ppiov);
@@ -120,6 +127,19 @@ bool net_is_devmem_iov(struct net_iov *niov);
 #else
 struct net_devmem_dmabuf_binding;
 
+static inline void
+net_devmem_dmabuf_binding_put(struct net_devmem_dmabuf_binding *binding)
+{
+}
+
+static inline void net_devmem_get_net_iov(struct net_iov *niov)
+{
+}
+
+static inline void net_devmem_put_net_iov(struct net_iov *niov)
+{
+}
+
 static inline void
 __net_devmem_dmabuf_binding_free(struct net_devmem_dmabuf_binding *binding)
 {
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index d73ad79fe739d..00c22bce98e44 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -89,6 +89,7 @@
 #include <linux/textsearch.h>
 
 #include "dev.h"
+#include "devmem.h"
 #include "netmem_priv.h"
 #include "sock_destructor.h"
 
@@ -7313,3 +7314,32 @@ bool csum_and_copy_from_iter_full(void *addr, size_t bytes,
 	return false;
 }
 EXPORT_SYMBOL(csum_and_copy_from_iter_full);
+
+void get_netmem(netmem_ref netmem)
+{
+	struct net_iov *niov;
+
+	if (netmem_is_net_iov(netmem)) {
+		niov = netmem_to_net_iov(netmem);
+		if (net_is_devmem_iov(niov))
+			net_devmem_get_net_iov(netmem_to_net_iov(netmem));
+		return;
+	}
+	get_page(netmem_to_page(netmem));
+}
+EXPORT_SYMBOL(get_netmem);
+
+void put_netmem(netmem_ref netmem)
+{
+	struct net_iov *niov;
+
+	if (netmem_is_net_iov(netmem)) {
+		niov = netmem_to_net_iov(netmem);
+		if (net_is_devmem_iov(niov))
+			net_devmem_put_net_iov(netmem_to_net_iov(netmem));
+		return;
+	}
+
+	put_page(netmem_to_page(netmem));
+}
+EXPORT_SYMBOL(put_netmem);
-- 
2.49.0.987.g0cc8ee98dc-goog


