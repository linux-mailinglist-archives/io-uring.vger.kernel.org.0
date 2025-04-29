Return-Path: <io-uring+bounces-7773-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10F74AA0050
	for <lists+io-uring@lfdr.de>; Tue, 29 Apr 2025 05:27:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C4B8E46713F
	for <lists+io-uring@lfdr.de>; Tue, 29 Apr 2025 03:27:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EC9B274647;
	Tue, 29 Apr 2025 03:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="esbx2/te"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481B9270ED6
	for <io-uring@vger.kernel.org>; Tue, 29 Apr 2025 03:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745897214; cv=none; b=XUP8TJrD9+caF5awlXcZlM/Kfcu6PeS+tuTnkN9aRpQYUiXDKJq/8nebORTSoK30Ho/41BR/LbTMtqpMcpFAU6Kfbu4aP7/qkoGhr52Mua1L261KotVcxbE/ApczA8PdFCJG3W6YfPuursfrZVscYq10XLgxJemdPFdvYhUWxmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745897214; c=relaxed/simple;
	bh=qYONgsirpw+HG9jzNfr2dkoVoQvW+diVvY7Qn/lj50U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hBLr1aHpb6eyccc0c+TLX5RhiSw5DEWk318ov8KW6DtFV8B//iA1pEeMR45d9DK2Ytepx6rXfDG153/GmDobD0rDcmhK8umBtWBrwBov5sCe1a0juyvrJ6k69SFkjxfXHbEQWaj/rIVEzmmNZxxY5UGH5bkN7OM8WPSXM0AEjt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=esbx2/te; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-af534e796baso3035756a12.3
        for <io-uring@vger.kernel.org>; Mon, 28 Apr 2025 20:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745897211; x=1746502011; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eFtBAUvX4dtqhO370QX3LWMjzgP24jNRQPJAZGznbZM=;
        b=esbx2/tesx/itJJeyKc7uqB17OCC0Y4ODba/RaWFWbLQL4hwoIOiu7JGfkt+HpkPoa
         EIFzM3uVxwu3Ugp+xfqmrcooVC+Ch3uLvTFc6lPN4lvnpM5usaIdy3cPJ+PVbdt8uPGw
         FnpIfSrLnNoSLQpSyKTB4ZYuDOClGyNKXcGqc8ag1bh1wA0XxdVPvumyYXt5jbU3hVT/
         CIqxjN7cGN6IYVEm8XsHs3LTDLFfaEOLPkDMRZbE1/ISsIABam/uIOy8UqoZQGaaxXzy
         bT7eyd6w3hYi4GQOjPodehpS8XAfuj6HqLzLe0K+IrNYJ3zWUaunFZHNaBcDCS7Je45E
         n5jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745897211; x=1746502011;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eFtBAUvX4dtqhO370QX3LWMjzgP24jNRQPJAZGznbZM=;
        b=TjQ49aNHkgaXuIGFnoJINVJ3WnL/D5nOLjGFHyvJqq2nWJD7EHBh8um5/syNqvWtTn
         /BiQr0Onfp5+bpOp2lZRvl5AximoM5Zbm1cFU8fVBdsGcCvrfNkIIAQ5kqpb6oAuXrtB
         sy1ciz+J0XTG/Ez7LaVlHKNm1gHaI2FcwTgprSrJ64sen+PyEyxvR7ezComD+g2Vd3BO
         6BLxw702nWdkJLVecO3N4Mzn9PZMUWci7S9dBXoiI6TpM7YSB7XGzL99V5fVXN/q+bjL
         danf3GeN+mUMKxA0fIYqM9/lTjtQhJbYg1PHqj4tdGgQQVwqfQSaxSbJhQaWlRXWyDR9
         uMnQ==
X-Forwarded-Encrypted: i=1; AJvYcCWrWGY5LEjE/v+xGdH530qJskW5X0INiWz2aycTA+qjYmLe9jiTKfrwwdGoZfOHGLQrhl0cZpng/w==@vger.kernel.org
X-Gm-Message-State: AOJu0YwTWCG8G8GOPBDOuJtF3IDZoZZhnZLnOhsf/MKoVpH9RdzcqwCj
	Hw9qmE7ow70OY+kjb0ZO7SKQYtNUc6RXiy+dQkit73NQwuCcNROtTVmXuGkaCBqj/BpZwJrpxMS
	xrcdDlgxqigsJDB66uazAXg==
X-Google-Smtp-Source: AGHT+IGnVZSU2hjv8nfXiKBqoWfXJArudTh1iJOkfCVz7lDzsbfKgQurn5BI53YO9QRzpRPQWhvADBlG98KIQiQkTw==
X-Received: from pgbfy19.prod.google.com ([2002:a05:6a02:2a93:b0:b0b:2876:d264])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:d70f:b0:1f5:60fb:8d9 with SMTP id adf61e73a8af0-2093e1236f3mr2614282637.33.1745897211360;
 Mon, 28 Apr 2025 20:26:51 -0700 (PDT)
Date: Tue, 29 Apr 2025 03:26:38 +0000
In-Reply-To: <20250429032645.363766-1-almasrymina@google.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250429032645.363766-1-almasrymina@google.com>
X-Mailer: git-send-email 2.49.0.901.g37484f566f-goog
Message-ID: <20250429032645.363766-3-almasrymina@google.com>
Subject: [PATCH net-next v13 2/9] net: add get_netmem/put_netmem support
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
2.49.0.901.g37484f566f-goog


