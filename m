Return-Path: <io-uring+bounces-7471-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EB68A8AB95
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 00:50:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4FFF07A6105
	for <lists+io-uring@lfdr.de>; Tue, 15 Apr 2025 22:49:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 296D42D321D;
	Tue, 15 Apr 2025 22:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CPZED5f+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E53A92D29AC
	for <io-uring@vger.kernel.org>; Tue, 15 Apr 2025 22:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744757293; cv=none; b=ZuYdZ1dpZn5ie2v9krpKgekngjzA3z3JdICAeMf+Zvani8cHlI2FN9ViZ4vMWuPphd0uaniHajkGSR3p9Z33YegL/2Lqkx+DOjb3fQm9iYBxKWZWlnmQ0dXJlanst9ElxLq7INObna1F2XN9Lbb0aQWCjzqIvb+5GSWO8DeeuIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744757293; c=relaxed/simple;
	bh=Viz88h4zEJRYftyYyJ62jZ+LAglqsn/DohKIyPH06Pk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pwNpklfa9dcipppC1tS/bAeJW2v2PvW7bp7eaMtxUvc5Hdx/ppSaujgEzT+cJmQ1POV2gRJEbURADrB3ZL8vEl2wTj0xcdkcxNfKnlOi+BDPmgPHqp614cK3LkyZ1j9gP0t3XuOMBlSHkKSX86NkQ11Q+hFxRWXHuaXahxFcae0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CPZED5f+; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ff58318acaso9123386a91.0
        for <io-uring@vger.kernel.org>; Tue, 15 Apr 2025 15:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744757290; x=1745362090; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yZ9hB+alXHD1d6Ke9vNVXo3tJI/1t2sQ+bdR4rE6Q5g=;
        b=CPZED5f+7XnoqftjYUhXbVOK4DrS9hKBboxvlRxisFz5tJFsYI0FjLRTnfjRaRCp2i
         T21RxHASLYyWqWpGRn3w/6MXSxbBcFpnv4pUtb9WoYDDe4pDV2TLlQlTmcOzkI1oajnP
         Akzab/MPiwe7mep8T5ljl7Vdbeuw8QlevojrhgyfVdMlrVH0f3gdI0G62/hXuvaHDNg1
         AajV61mlEAnvBNpNSTEyhNgwRJT3jm0rRQpqZW30oQy20AXqJwdjSOQlKQSKbTX3pVao
         wQIk2+YLzaBL0QGWUqE4NuIoaq5Bbtnj5erVzpei/fF2UtEjXGF1SBrqXy9EuC7O+pB5
         C46g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744757290; x=1745362090;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yZ9hB+alXHD1d6Ke9vNVXo3tJI/1t2sQ+bdR4rE6Q5g=;
        b=i/ye1Dbh1HYjoQJ2nAlyVPSSR85Q4NcSfewayVSkHjxVK2IxsKZXveUwRJrApBL1np
         fGDqmu/dPPfEBJ/DBo+Midr1mXYDZER58MZDIm6GRNPpzNOiD9ODyV5EvFTJ8jOn5EEG
         iZ6d+ejBr37U4dl3c3PqxaPA57QW6KIsE+E26MVz9aV1NQdLj7E2w/IgHZaDkcRkFg+r
         9b1nEuRhLv/n7Q6W1xyQK9NmeR5oGM2MjKVDeXHJ8xnobRb8d/GiHBOYUlJD2Mz08iRK
         X5NqCjDcZKbgSm2GPjM8/gPJeoLghQR5Mx+AiFEh4qMQLB40h4hLQnsemejrlwh8qc5J
         ulRw==
X-Forwarded-Encrypted: i=1; AJvYcCUrLY3AnuMqQ0H/tB0PHvEhfBDMs4MQOMv5gyo7Z/jvPRLCOX8+N7nZ34iajEIjUioqxuiHSq/a4g==@vger.kernel.org
X-Gm-Message-State: AOJu0YyXpDf+85AzLn6Miy6SgxM2KRAoQT/egh/4QXXVUugs3UGCE+Gz
	+FTp8KjHd5742roczi3Kxtx2hHZm2+QFMNs/9DT9enGmLDyzp3gl9Jex7wObuu9G+QASAfOwqJY
	e8dQ8MHMru9HFSHqEUGKbnQ==
X-Google-Smtp-Source: AGHT+IFQKABJXAJLy4yWiWL0Q5/0eudNOIc8vvLgficgkZYgaud9o5UY5XSmsk51FTTmaHMTwXYtudTOkXnI3SzGsQ==
X-Received: from pjbdb11.prod.google.com ([2002:a17:90a:d64b:b0:2ef:d136:17fc])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3cd0:b0:2ee:edae:75e with SMTP id 98e67ed59e1d1-3085eeb4945mr1177487a91.13.1744757290348;
 Tue, 15 Apr 2025 15:48:10 -0700 (PDT)
Date: Tue, 15 Apr 2025 22:47:55 +0000
In-Reply-To: <20250415224756.152002-1-almasrymina@google.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250415224756.152002-1-almasrymina@google.com>
X-Mailer: git-send-email 2.49.0.777.g153de2bbd5-goog
Message-ID: <20250415224756.152002-8-almasrymina@google.com>
Subject: [PATCH net-next v8 8/9] net: check for driver support in netmem TX
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

We should not enable netmem TX for drivers that don't declare support.

Check for driver netmem TX support during devmem TX binding and fail if
the driver does not have the functionality.

Check for driver support in validate_xmit_skb as well.

Signed-off-by: Mina Almasry <almasrymina@google.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>

---

v8:
- Rebase on latest net-next and resolve conflict.
- Remove likely (Paolo)

v5: https://lore.kernel.org/netdev/20250227041209.2031104-8-almasrymina@google.com/
- Check that the dmabuf mappings belongs to the specific device the TX
  is being sent from (Jakub)

v4:
- New patch

---
 net/core/dev.c         | 34 ++++++++++++++++++++++++++++++++--
 net/core/devmem.h      |  6 ++++++
 net/core/netdev-genl.c |  7 +++++++
 3 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 03d20a98f8b7..2f1aa802c819 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3894,12 +3894,42 @@ int skb_csum_hwoffload_help(struct sk_buff *skb,
 }
 EXPORT_SYMBOL(skb_csum_hwoffload_help);
 
+static struct sk_buff *validate_xmit_unreadable_skb(struct sk_buff *skb,
+						    struct net_device *dev)
+{
+	struct skb_shared_info *shinfo;
+	struct net_iov *niov;
+
+	if (likely(skb_frags_readable(skb)))
+		goto out;
+
+	if (!dev->netmem_tx)
+		goto out_free;
+
+	shinfo = skb_shinfo(skb);
+
+	if (shinfo->nr_frags > 0) {
+		niov = netmem_to_net_iov(skb_frag_netmem(&shinfo->frags[0]));
+		if (net_is_devmem_iov(niov) &&
+		    net_devmem_iov_binding(niov)->dev != dev)
+			goto out_free;
+	}
+
+out:
+	return skb;
+
+out_free:
+	kfree_skb(skb);
+	return NULL;
+}
+
 static struct sk_buff *validate_xmit_skb(struct sk_buff *skb, struct net_device *dev, bool *again)
 {
 	netdev_features_t features;
 
-	if (!skb_frags_readable(skb))
-		goto out_kfree_skb;
+	skb = validate_xmit_unreadable_skb(skb, dev);
+	if (unlikely(!skb))
+		goto out_null;
 
 	features = netif_skb_features(skb);
 	skb = validate_xmit_vlan(skb, features);
diff --git a/net/core/devmem.h b/net/core/devmem.h
index 67168aae5e5b..919e6ed28fdc 100644
--- a/net/core/devmem.h
+++ b/net/core/devmem.h
@@ -229,6 +229,12 @@ net_devmem_get_niov_at(struct net_devmem_dmabuf_binding *binding, size_t addr,
 {
 	return NULL;
 }
+
+static inline struct net_devmem_dmabuf_binding *
+net_devmem_iov_binding(const struct net_iov *niov)
+{
+	return NULL;
+}
 #endif
 
 #endif /* _NET_DEVMEM_H */
diff --git a/net/core/netdev-genl.c b/net/core/netdev-genl.c
index 56502923f885..08a90660ed83 100644
--- a/net/core/netdev-genl.c
+++ b/net/core/netdev-genl.c
@@ -973,6 +973,13 @@ int netdev_nl_bind_tx_doit(struct sk_buff *skb, struct genl_info *info)
 		goto err_unlock;
 	}
 
+	if (!netdev->netmem_tx) {
+		err = -EOPNOTSUPP;
+		NL_SET_ERR_MSG(info->extack,
+			       "Driver does not support netmem TX");
+		goto err_unlock;
+	}
+
 	binding = net_devmem_bind_dmabuf(netdev, DMA_TO_DEVICE, dmabuf_fd,
 					 info->extack);
 	if (IS_ERR(binding)) {
-- 
2.49.0.777.g153de2bbd5-goog


