Return-Path: <io-uring+bounces-7652-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E9EC7A97D5C
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 05:14:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C43E4189A162
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 03:14:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11096268FF9;
	Wed, 23 Apr 2025 03:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HFsw8dvu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63E7267B77
	for <io-uring@vger.kernel.org>; Wed, 23 Apr 2025 03:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745377894; cv=none; b=l0ujdnCYkzlLXR2egCdWL835VDqWv6zF0QDJijW2c3wvHZvOLnxPHBZne68K1kuIZb9HSOAMNb4kzcOsrkVlilYoZJzDxwi7P6U2yueBg4OkeLIP8Cnjn2+V8CTsQfe5oLzYXE252tjS2xiQ9Q9D2LJeeMwulrVGSeLIZxQTLFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745377894; c=relaxed/simple;
	bh=6/8NFpps55oCa3AYk0X5GT/T8IVzlp9P4uaBDdIiIX0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rYkLDLjgiZSWmhUXFYT0eUqkNHkYVwgv3++oFXdTgC56QEc91A+o8LIiqAHnrKI5JPio66+gNGwUYU90wrcm9tlS6CR0ZNIni7JyBgSMou/m0PqMdypCDItKB3mHG5LWwJZQ9743mfkx8Ynwhd6rpp8N0ltsIRsFeeXIanpa46E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HFsw8dvu; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-736b431ee0dso5010205b3a.0
        for <io-uring@vger.kernel.org>; Tue, 22 Apr 2025 20:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745377891; x=1745982691; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8crc0ZI5juv7i3SKZgQ8E1WkOFtJNTgbW4wVjE0PfXM=;
        b=HFsw8dvutGxQGowNHhb81DrAs3JNuod5smo9IW3t200KWMtaaYA7fqdWaWQVANhUcZ
         r7uEn/FfyNS/IoAnXmWas3M61lrBm+Ux/XPVm/0PUa+Tc920ARnczsROVT3trpYze1t7
         75487474XkAQm8QMcT3LqyQokTqxUHjLXM8hMX65fGLk9MDl64WW5vCoaPltvLeFaVIp
         XUXjLsw3I/3vOdx9JsShmCelKRsJ3+xuObba6gzelfbsEUpdSaTWyDfMxm8vw/8JZHli
         OtgQtdavsoZIXXvJUPTeZozgcnTfgZ8seZRkYltGSJlxjhr82Ftg3lJ5v3JxNwqtrnS4
         PqRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745377891; x=1745982691;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8crc0ZI5juv7i3SKZgQ8E1WkOFtJNTgbW4wVjE0PfXM=;
        b=dU49wW7ySX1ZxGRE1zkjZ4kkcREPcBDe+kPjKa/TBzajgzMizqDEdRrVGDLMuvT32y
         EuFOOzaZGU2IDBVTvpUVYvPz+IfaBJkq9Jme8gCp7SvEzBpYFahAiAwt9b5xNXUoyp/k
         Ux4rLo4sN+0u8tCxx0a9triemHuwpVv9iucvcHDG9BgXUPEu0126fcK+te7N/C1QKuhr
         I+OK8aW8RHnw0NhYCzdY96q3+fOI5BeDABjPs3l+hTr5ijDc/d0emqhalL7gV1vmot0Y
         Y7ook6GLYxkCVABHrvSrhcLCy48QbrqMPTBFqtOlWXIzt1CUBLsAxOwCpbth6UTVKkW6
         MI5Q==
X-Forwarded-Encrypted: i=1; AJvYcCX59EvUAgLcJgg/oXN4nUK2SR9HF6Rbaq1ZAKLEusxwAeBpRI2TgNEBstEPHp2cWpK8qNyY8AGy3w==@vger.kernel.org
X-Gm-Message-State: AOJu0YxUukDXslJZwxsB5BZ4AVqJXo57vq7aTt+a7u7qPfoqpoVPyLrw
	cgOUFPX9RzioX/GYpfdy/fDCwgO08X/ngLVjReKlLI68CtkHIZ/zfJY/B0nVBGS6SWIWKvGB9oc
	Rbtk/s4OvEP112qgto/V4pg==
X-Google-Smtp-Source: AGHT+IH7fp1ttRRtcAYJFlNbY6mdvazj2yUqLFzHBaSUp2tOqJVs25nSVsI+67R/awizw/y6jC3iNCtbA0tUdAWYwg==
X-Received: from pfx55.prod.google.com ([2002:a05:6a00:a477:b0:736:4ad6:1803])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:414d:b0:736:a6e0:e66d with SMTP id d2e1a72fcca58-73dc14a32b9mr24416016b3a.6.1745377890834;
 Tue, 22 Apr 2025 20:11:30 -0700 (PDT)
Date: Wed, 23 Apr 2025 03:11:13 +0000
In-Reply-To: <20250423031117.907681-1-almasrymina@google.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250423031117.907681-1-almasrymina@google.com>
X-Mailer: git-send-email 2.49.0.805.g082f7c87e0-goog
Message-ID: <20250423031117.907681-7-almasrymina@google.com>
Subject: [PATCH net-next v10 6/9] net: enable driver support for netmem TX
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
	Neal Cardwell <ncardwell@google.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	"=?UTF-8?q?Eugenio=20P=C3=A9rez?=" <eperezma@redhat.com>, Shuah Khan <shuah@kernel.org>, sdf@fomichev.me, dw@davidwei.uk, 
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
2.49.0.805.g082f7c87e0-goog


