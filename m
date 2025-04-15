Return-Path: <io-uring+bounces-7465-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 26848A8AB6C
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 00:48:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 44D7B7A4847
	for <lists+io-uring@lfdr.de>; Tue, 15 Apr 2025 22:47:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C03172C3741;
	Tue, 15 Apr 2025 22:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QoIKGYP2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C092C2AA8
	for <io-uring@vger.kernel.org>; Tue, 15 Apr 2025 22:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744757282; cv=none; b=F4HYHV2rC5aEcPpCKpQdVrK8Q5tJ+bX0qkWb5feym8K5YwlS0A8uqaRbz+/GjYhwG0hxa/t23ZeujFGUzQHZqwIEsle8+aRrqbcQqGOInt8l6mQaJUx9SbLF5YWVPvPdKEU5vt0jqfewqidJSitGBKjoS4PdND+qWvsWPiXmF2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744757282; c=relaxed/simple;
	bh=bzIdosGd+iHM8zjgP9Rsnua0zbPT3kVdA4bjl+Uf7gE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EiBwDrMxKNDf80+ibdp7kjd91uHbYYfs09fp2IV5LmU84BQGtCpZItNpWtomxivxlIT84cYyg+mviDD5oofLTszskgmXGhSBmO3TpOeMzrUgsBnQBVcIN5EAEA++Beqk2uwWJ/xQuSrG4tx3gXEpOifeRF0Onjf27C7sU01Gpvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QoIKGYP2; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-22410053005so97622655ad.1
        for <io-uring@vger.kernel.org>; Tue, 15 Apr 2025 15:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744757280; x=1745362080; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PuNq7aIbJvaAGzYHAiXQJH1zhpvVPNevAoggNVBWhr4=;
        b=QoIKGYP2Rb0+t8Sb/7HoYMfV78LA7ClwuVgGiNDRKoagdI+OC28e0dysPprQZZg1Zd
         z1+3hWefftSwxZWMb/Uk24TXN4fVWV5nIU4+TiGirtbHLBsaCBM0yPQ2V8UBrxpKx+iB
         h6r2uJuiAVNoD9m+J7CDZwlY8AB/pwt3wbgVk0EwxcEMpUxA1ZRmvr0YNUUvvArtCRkX
         +D3v9U1LQpsxqp9Ppyqlalg8VcnyTzJupDN7n4Roah8vsDUTEglcPfZXgWd0y/SAUIOl
         7FqIKdoy5omHojJy6Zd0WwUFwyv5hkXTKA6xIT71Lq5vPJMZHkm207Fo0fiM6TS6Pnmk
         Y/NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744757280; x=1745362080;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PuNq7aIbJvaAGzYHAiXQJH1zhpvVPNevAoggNVBWhr4=;
        b=s/k4uIMxB46wIdBKfbSkzdw3YrNzM09ca6mQPpuax4jhHTZ/bYQTjMar14suM2I395
         M1eqqUPVs1UX+aYI+76s61o6UD/UzOxhKpYmqWynaySVbxiVdfMbXbhx2soVk7FOXfNw
         nXuTlfoDmdiJFl2pwQbjG1nz2vNRtrxcIET5z5OupxwIwAdS6GmRKexDBaaH86WKQoiR
         bYM5mLFqi/H+75R0ePQtbLOQcxeCDwiqgf1k4XAE1UCmDgZtoJ+hgK9WwncrADglWQH+
         f4WqWjEu+mAkG6ImUydMIowUwP4motO0yhxnaxv7NScRI+zheiy++mg+WkogVBaRuxV8
         23QQ==
X-Forwarded-Encrypted: i=1; AJvYcCVVWyIo1KAtlPCJA53sMfB7OaAP+Z+ouAicTnfZqNUMfn84HBvgAolJqVP/ATOc8KXdfOeC29k0Mg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwcCYOZzB4pZtBCbHXI7UppF5N3bTyBt0foBSZLNPcPyEHkEu3N
	v+FPPO5sSrrxwnNK4ejn9Ny3Noo0A4JNwN7gH5cg4IC8I+g4nmCoVtN1vv9Gwk7aNdpL2ARGZWv
	2wn+danEYq7IeFN7Xfse1bQ==
X-Google-Smtp-Source: AGHT+IEpKgucNCWhxqPMPHlkoUavIpwNsOatAtmk/awvti8Xf0ESmoJ01qZt5Y/K/efQqdQKBJtHgKq8pcQyXSY0fw==
X-Received: from plec4.prod.google.com ([2002:a17:902:f304:b0:223:58e2:570d])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:f650:b0:220:e5be:29c7 with SMTP id d9443c01a7336-22c31a86871mr12802425ad.39.1744757279797;
 Tue, 15 Apr 2025 15:47:59 -0700 (PDT)
Date: Tue, 15 Apr 2025 22:47:49 +0000
In-Reply-To: <20250415224756.152002-1-almasrymina@google.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250415224756.152002-1-almasrymina@google.com>
X-Mailer: git-send-email 2.49.0.777.g153de2bbd5-goog
Message-ID: <20250415224756.152002-2-almasrymina@google.com>
Subject: [PATCH net-next v8 2/9] net: add get_netmem/put_netmem support
From: Mina Almasry <almasrymina@google.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, io-uring@vger.kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, linux-kselftest@vger.kernel.org
Cc: Mina Almasry <almasrymina@google.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Donald Hunter <donald.hunter@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	Jeroen de Borst <jeroendb@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, 
	Kuniyuki Iwashima <kuniyu@amazon.com>, Willem de Bruijn <willemb@google.com>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, David Ahern <dsahern@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	"=?UTF-8?q?Eugenio=20P=C3=A9rez?=" <eperezma@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Stanislav Fomichev <sdf@fomichev.me>
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
index 0f3c58007488..9e49372ef1a0 100644
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
index 64af9a288c80..1b047cfb9e4f 100644
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
index f5c3a7e6dbb7..dca2ff7cf692 100644
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
index 7fc158d52729..946f2e015746 100644
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
index 74a2d886a35b..17ce5857b116 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -89,6 +89,7 @@
 #include <linux/textsearch.h>
 
 #include "dev.h"
+#include "devmem.h"
 #include "netmem_priv.h"
 #include "sock_destructor.h"
 
@@ -7305,3 +7306,32 @@ bool csum_and_copy_from_iter_full(void *addr, size_t bytes,
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
2.49.0.777.g153de2bbd5-goog


