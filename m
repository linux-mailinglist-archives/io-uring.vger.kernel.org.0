Return-Path: <io-uring+bounces-7734-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EE3F7A9D363
	for <lists+io-uring@lfdr.de>; Fri, 25 Apr 2025 22:50:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7270C461D8B
	for <lists+io-uring@lfdr.de>; Fri, 25 Apr 2025 20:50:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C7D92500DE;
	Fri, 25 Apr 2025 20:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2gVaEuHz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B41230BC1
	for <io-uring@vger.kernel.org>; Fri, 25 Apr 2025 20:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745614080; cv=none; b=CT+UXWBbXQX+UmUuqxBbe9ow7Psgg0CDF4dliOJVv2ovGfXyJ+sftYp4BoBq1pyFJFrG2Bxse8uSUBr1X1+Sk32fj6gFc/+lHxAEsVAGhzk09yKUM3Lqsm5O/w5LGYIUo+75PwOkp3m7mOVA2mDiQcyqkrUx3tWAt9rQPlVB7EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745614080; c=relaxed/simple;
	bh=mi5jiJ5/GpWUtDhToM/mMx2eCstUJTwArBAjW0iLUTw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=llYcvcDrIv7wwMsDXqxSw7YGAisUoXRJM48HP62sY0i4PT690a+lLBQET0GpN9WxPyJP/WPqz1787cxwvDmUS8lD5kdV0LTcLI6VQ7eJGJX0awChs2WP/L3wmslX+oALy4e+vF+nCw50fNLpD/BmukycAPpLr/8/OkhQRoniMGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2gVaEuHz; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-739525d4d7bso2093025b3a.2
        for <io-uring@vger.kernel.org>; Fri, 25 Apr 2025 13:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745614076; x=1746218876; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GF72qCZmNHB/M9wyhDuVX7J4MUP8Sfe1HWRQmktZ2BM=;
        b=2gVaEuHzqV8i1A2SFHXBsPYNycADFZQs3QPjL96uKo62otiNRxf0jbRNt/EV0GLPuz
         JSl5pOOYzEq7o+QHScVRC2MCh+98/AfLy2pDGrrEXkNzK4zvAIF5qbbW47dYJStOOp3z
         8Ut59bpEQ2rb6cT8TbU2lycyx+34uFjN92Gbsyawne57skM/rlz1XBbKr3svhCvqsGuM
         e2ToJaxbquByJBWfB6st8HHFeDK4e7cOjAD6z45gzto/L9yowkSA3pUK4F965DG5bUHK
         BuGYSkpiKWzyfw27aav4i4pbZ5u/OU1/1F1BCPRqyvRqwcoXW656ekSaijaNvFqZcku5
         QMyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745614076; x=1746218876;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GF72qCZmNHB/M9wyhDuVX7J4MUP8Sfe1HWRQmktZ2BM=;
        b=T6clzIu01oJSlEfPU6vwBmPRUlVQZhEUGg4oKPfaqk2JyKWojPEhYkaxJbjMB3aZsG
         4aSFxu6lexecZEuK57Qm2lkvfxwxqv1O+xWZlj1MM8iU2wBEyEaTPfV5lIwQSGmnjI2X
         QCPHv3wlzc8fnvzu24LifGEBAM8sRkgolHOgiWk+1N8F9yJT56eKq/tWNd+bzbvRdwCs
         6G3pwQF13thcILG0lSLTNrBIt5MEfkL714ZLhgi/9pZDdLkHeW2mrG8KE3/aDO0OgyVN
         J5GgAEkke3HiqVrFAUtsQCf00yeunCc+8LqI/fgVTcwVac1+zlaPvP8j1Vf6zfMd9HTd
         cmZQ==
X-Forwarded-Encrypted: i=1; AJvYcCUxl6kqVRqz0XLxRbAQDtcridIX+uWvEMhNA/tM3KwGMpkMQS9q2iwBIpo9NAF5upHXIplXK7ZeNw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzRYiDABbAP/2hIwuq+KDClu2N1o+bRt3cF9VF9DGZs3CZ/fOgk
	29oBiYTsAKG/izWyWg9M5TjqUCsIYdviSvRsfrFoVTUuUtwlojT/Dr/QSaJgX1Zqo+G1yc/suHP
	FlmP9LwgTB3S/NwlFAd7DjQ==
X-Google-Smtp-Source: AGHT+IGkejOC043bFHgSkVL9uHCJ44UdIDiSp1spb5spMEGriYvjBX2RAP/Qu3gEalSerk9D0cqCplHd5pfjPkO7UQ==
X-Received: from pfbdh8.prod.google.com ([2002:a05:6a00:4788:b0:736:b2a2:5bfe])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:3919:b0:736:a4ca:62e1 with SMTP id d2e1a72fcca58-73ff7294e69mr1114987b3a.6.1745614076331;
 Fri, 25 Apr 2025 13:47:56 -0700 (PDT)
Date: Fri, 25 Apr 2025 20:47:40 +0000
In-Reply-To: <20250425204743.617260-1-almasrymina@google.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250425204743.617260-1-almasrymina@google.com>
X-Mailer: git-send-email 2.49.0.850.g28803427d3-goog
Message-ID: <20250425204743.617260-7-almasrymina@google.com>
Subject: [PATCH net-next v12 6/9] net: enable driver support for netmem TX
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
	Neal Cardwell <ncardwell@google.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	"=?UTF-8?q?Eugenio=20P=C3=A9rez?=" <eperezma@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, Shuah Khan <shuah@kernel.org>, sdf@fomichev.me, dw@davidwei.uk, 
	Jamal Hadi Salim <jhs@mojatatu.com>, Victor Nogueira <victor@mojatatu.com>, 
	Pedro Tammela <pctammela@mojatatu.com>, Samiullah Khawaja <skhawaja@google.com>
Content-Type: text/plain; charset="UTF-8"

Drivers need to make sure not to pass netmem dma-addrs to the
dma-mapping API in order to support netmem TX.

Add helpers and netmem_dma_*() helpers that enables special handling of
netmem dma-addrs that drivers can use.

Document in netmem.rst what drivers need to do to support netmem TX.

Signed-off-by: Mina Almasry <almasrymina@google.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>

---

v8:
- use spaces instead of tabs (Paolo)

v5:
- Fix netmet TX documentation (Stan).

v4:
- New patch
---
 .../networking/net_cachelines/net_device.rst  |  1 +
 Documentation/networking/netdev-features.rst  |  5 ++++
 Documentation/networking/netmem.rst           | 23 +++++++++++++++++--
 include/linux/netdevice.h                     |  2 ++
 include/net/netmem.h                          | 20 ++++++++++++++++
 5 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/net_cachelines/net_device.rst b/Documentation/networking/net_cachelines/net_device.rst
index ca8605eb82ffc..c69cc89c958e0 100644
--- a/Documentation/networking/net_cachelines/net_device.rst
+++ b/Documentation/networking/net_cachelines/net_device.rst
@@ -10,6 +10,7 @@ Type                                Name                        fastpath_tx_acce
 =================================== =========================== =================== =================== ===================================================================================
 unsigned_long:32                    priv_flags                  read_mostly                             __dev_queue_xmit(tx)
 unsigned_long:1                     lltx                        read_mostly                             HARD_TX_LOCK,HARD_TX_TRYLOCK,HARD_TX_UNLOCK(tx)
+unsigned long:1                     netmem_tx:1;                read_mostly
 char                                name[16]
 struct netdev_name_node*            name_node
 struct dev_ifalias*                 ifalias
diff --git a/Documentation/networking/netdev-features.rst b/Documentation/networking/netdev-features.rst
index 5014f7cc1398b..02bd7536fc0ca 100644
--- a/Documentation/networking/netdev-features.rst
+++ b/Documentation/networking/netdev-features.rst
@@ -188,3 +188,8 @@ Redundancy) frames from one port to another in hardware.
 This should be set for devices which duplicate outgoing HSR (High-availability
 Seamless Redundancy) or PRP (Parallel Redundancy Protocol) tags automatically
 frames in hardware.
+
+* netmem-tx
+
+This should be set for devices which support netmem TX. See
+Documentation/networking/netmem.rst
diff --git a/Documentation/networking/netmem.rst b/Documentation/networking/netmem.rst
index 7de21ddb54129..b63aded463370 100644
--- a/Documentation/networking/netmem.rst
+++ b/Documentation/networking/netmem.rst
@@ -19,8 +19,8 @@ Benefits of Netmem :
 * Simplified Development: Drivers interact with a consistent API,
   regardless of the underlying memory implementation.
 
-Driver Requirements
-===================
+Driver RX Requirements
+======================
 
 1. The driver must support page_pool.
 
@@ -77,3 +77,22 @@ Driver Requirements
    that purpose, but be mindful that some netmem types might have longer
    circulation times, such as when userspace holds a reference in zerocopy
    scenarios.
+
+Driver TX Requirements
+======================
+
+1. The Driver must not pass the netmem dma_addr to any of the dma-mapping APIs
+   directly. This is because netmem dma_addrs may come from a source like
+   dma-buf that is not compatible with the dma-mapping APIs.
+
+   Helpers like netmem_dma_unmap_page_attrs() & netmem_dma_unmap_addr_set()
+   should be used in lieu of dma_unmap_page[_attrs](), dma_unmap_addr_set().
+   The netmem variants will handle netmem dma_addrs correctly regardless of the
+   source, delegating to the dma-mapping APIs when appropriate.
+
+   Not all dma-mapping APIs have netmem equivalents at the moment. If your
+   driver relies on a missing netmem API, feel free to add and propose to
+   netdev@, or reach out to the maintainers and/or almasrymina@google.com for
+   help adding the netmem API.
+
+2. Driver should declare support by setting `netdev->netmem_tx = true`
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 0321fd952f708..a661820a26c44 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1772,6 +1772,7 @@ enum netdev_reg_state {
  *	@lltx:		device supports lockless Tx. Deprecated for real HW
  *			drivers. Mainly used by logical interfaces, such as
  *			bonding and tunnels
+ *	@netmem_tx:	device support netmem_tx.
  *
  *	@name:	This is the first field of the "visible" part of this structure
  *		(i.e. as seen by users in the "Space.c" file).  It is the name
@@ -2087,6 +2088,7 @@ struct net_device {
 	struct_group(priv_flags_fast,
 		unsigned long		priv_flags:32;
 		unsigned long		lltx:1;
+		unsigned long		netmem_tx:1;
 	);
 	const struct net_device_ops *netdev_ops;
 	const struct header_ops *header_ops;
diff --git a/include/net/netmem.h b/include/net/netmem.h
index 1b047cfb9e4f7..8a9210e2868d3 100644
--- a/include/net/netmem.h
+++ b/include/net/netmem.h
@@ -8,6 +8,7 @@
 #ifndef _NET_NETMEM_H
 #define _NET_NETMEM_H
 
+#include <linux/dma-mapping.h>
 #include <linux/mm.h>
 #include <net/net_debug.h>
 
@@ -276,4 +277,23 @@ static inline unsigned long netmem_get_dma_addr(netmem_ref netmem)
 void get_netmem(netmem_ref netmem);
 void put_netmem(netmem_ref netmem);
 
+#define netmem_dma_unmap_addr_set(NETMEM, PTR, ADDR_NAME, VAL)   \
+	do {                                                     \
+		if (!netmem_is_net_iov(NETMEM))                  \
+			dma_unmap_addr_set(PTR, ADDR_NAME, VAL); \
+		else                                             \
+			dma_unmap_addr_set(PTR, ADDR_NAME, 0);   \
+	} while (0)
+
+static inline void netmem_dma_unmap_page_attrs(struct device *dev,
+					       dma_addr_t addr, size_t size,
+					       enum dma_data_direction dir,
+					       unsigned long attrs)
+{
+	if (!addr)
+		return;
+
+	dma_unmap_page_attrs(dev, addr, size, dir, attrs);
+}
+
 #endif /* _NET_NETMEM_H */
-- 
2.49.0.850.g28803427d3-goog


