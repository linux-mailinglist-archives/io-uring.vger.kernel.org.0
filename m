Return-Path: <io-uring+bounces-7696-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 31345A99FF7
	for <lists+io-uring@lfdr.de>; Thu, 24 Apr 2025 06:06:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2AFA41946743
	for <lists+io-uring@lfdr.de>; Thu, 24 Apr 2025 04:06:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 717441F4CA1;
	Thu, 24 Apr 2025 04:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jZ1c4KMv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694781F3FC6
	for <io-uring@vger.kernel.org>; Thu, 24 Apr 2025 04:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745467401; cv=none; b=JkHaVsiKwF5usj3acll+AzuSCiyI5/AX1Dm6X+1RHg0alhviqSOGWohcHmQ33qthd7FWcAOxiHGV1XTtJzMRIlqr6BnP+lJcfWShP4gfocnU673ipt7s8A8T1ICu3Q28uVJbp5yka/WE9FQZqbOu1xfBwQSBfxxr2KpM4JMAzlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745467401; c=relaxed/simple;
	bh=7NgBY2/M7RX3ZWIExGTnoM9nMea+0yUh7UHHWuhJ4Bk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=c8twfxipHUiItLkWNsRQXSNuJKxpogGbMDlzcTOZvds+geM2wREHS5UBRZyjalVbfYaapLLV6qRoVbitTDnbns7d3gycnN7687ElX3m/RmY6IpdrF1rM1177GF0NTd1iA0sQXVuE92XqmcNFDUr070APkX28ELAcOzTQThvyZs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jZ1c4KMv; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-736bf7eb149so364738b3a.0
        for <io-uring@vger.kernel.org>; Wed, 23 Apr 2025 21:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745467399; x=1746072199; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Dm+KUe9Ww/e6Vyl6aeeJ+DObwsjW8ys4qGoTcP5xOok=;
        b=jZ1c4KMvnZuK3XFchcG5cPV675VfERwiiWWxLd19118Uwd0SbJFwp9AwAuV/hLOXh+
         bz+tHL5BcMMDgQ5Q1rNeVobOLq+dUmTgNJXow+jPCYJIzlGoGtIJngvXusdIMQI7k/hp
         4EnZHsWQJ21hZ7IDc8ZmV+apDzoZG+gRDXhJO9U3taJRoYc9VQ7hnzNxaJ0bfiyppOhA
         i66ukbAHnMrUXEIsPxGOrMMRlveNhK5k1R0LKRUKY5nZXDvUKQirVe6WWYUzpN8pXGtK
         r7J2DrNB1e6wIuXtQI74OeFkLIH7ANM/R8Hwa8odp86xeqr8rCe9OZcP8K/Uwf0eA57+
         hn3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745467399; x=1746072199;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Dm+KUe9Ww/e6Vyl6aeeJ+DObwsjW8ys4qGoTcP5xOok=;
        b=orWa9qYDa4cn6ftqCd3Fijm5Qy9xr+2trEoRWmaDbfay4ka2fq3nri9pT0n2DxF1Po
         5MGdZ60zthoiqcEQKo3JJeELT0rtHW9ESHSdJVsKq6ClnXLU663WDX4CBPOtUd+57T3U
         1DlUGG6nAFOhqzenN3+HDZFnefwl7FUYmLl91xjrhWQ/CJwsnCyA9MVO4E0VbPzV9C7+
         7yjRE4jLys0dI6dGAgawBcRQsUqEX7JtaCz3VsuP2+xcAw9t01gnab/Ra3hHHp/rFOSX
         p4PsElkh3sNIdTvWanVtsSU4HLoeRSUPQd9xRupRbb+AjgYkbVbsNnH+rdaFr3h22fCF
         Hqgw==
X-Forwarded-Encrypted: i=1; AJvYcCVEyCcyaz3pjSLJULyK4EckMeG+gn8spxDs54lrIOoPAyjM50icerRh8o2Qo1hb43fSlzy9qo1XBA==@vger.kernel.org
X-Gm-Message-State: AOJu0YybQiAlcADSRgzb/4deZ9CLGZfVaNOyWrA+cNaploD8M44JJBYC
	bl3MmeEGbvQvwYK1S65xMe6xZJfVpD7yLcHQCl672XI6TMRrZWh4YhIo6dvj0aBzGZHaMa5+EUG
	1JaZfrLPC+a6oyBOo7kub2A==
X-Google-Smtp-Source: AGHT+IFLPIU2yWmxJxJgjQYe70sSW4SkHs7h5xwWXVAjgbGENSUaZlxA7iNR4GkvJCd9MTDUDy3y/0RyI7kIx5Ea4g==
X-Received: from pfx55.prod.google.com ([2002:a05:6a00:a477:b0:736:4ad6:1803])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:2d04:b0:1f5:619a:7f4c with SMTP id adf61e73a8af0-20444f2d5a0mr1681293637.29.1745467398744;
 Wed, 23 Apr 2025 21:03:18 -0700 (PDT)
Date: Thu, 24 Apr 2025 04:03:00 +0000
In-Reply-To: <20250424040301.2480876-1-almasrymina@google.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250424040301.2480876-1-almasrymina@google.com>
X-Mailer: git-send-email 2.49.0.805.g082f7c87e0-goog
Message-ID: <20250424040301.2480876-9-almasrymina@google.com>
Subject: [PATCH net-next v11 8/8] net: check for driver support in netmem TX
From: Mina Almasry <almasrymina@google.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, io-uring@vger.kernel.org, 
	virtualization@lists.linux.dev, kvm@vger.kernel.org
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
	"=?UTF-8?q?Eugenio=20P=C3=A9rez?=" <eperezma@redhat.com>, sdf@fomichev.me, dw@davidwei.uk, 
	Jamal Hadi Salim <jhs@mojatatu.com>, Victor Nogueira <victor@mojatatu.com>, 
	Pedro Tammela <pctammela@mojatatu.com>, Samiullah Khawaja <skhawaja@google.com>
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
index d1a8cad0c99c4..66f0c122de80e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3896,12 +3896,42 @@ int skb_csum_hwoffload_help(struct sk_buff *skb,
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
index 67168aae5e5b3..919e6ed28fdcd 100644
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
index 292606df834de..84c033574eb16 100644
--- a/net/core/netdev-genl.c
+++ b/net/core/netdev-genl.c
@@ -979,6 +979,13 @@ int netdev_nl_bind_tx_doit(struct sk_buff *skb, struct genl_info *info)
 		goto err_unlock_netdev;
 	}
 
+	if (!netdev->netmem_tx) {
+		err = -EOPNOTSUPP;
+		NL_SET_ERR_MSG(info->extack,
+			       "Driver does not support netmem TX");
+		goto err_unlock_netdev;
+	}
+
 	binding = net_devmem_bind_dmabuf(netdev, DMA_TO_DEVICE, dmabuf_fd,
 					 info->extack);
 	if (IS_ERR(binding)) {
-- 
2.49.0.805.g082f7c87e0-goog


