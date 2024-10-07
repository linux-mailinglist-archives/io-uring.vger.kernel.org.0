Return-Path: <io-uring+bounces-3442-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 842599939EF
	for <lists+io-uring@lfdr.de>; Tue,  8 Oct 2024 00:16:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2A8911F23DD0
	for <lists+io-uring@lfdr.de>; Mon,  7 Oct 2024 22:16:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67C2D18CBFC;
	Mon,  7 Oct 2024 22:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="GLwCkhYZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33E618C34C
	for <io-uring@vger.kernel.org>; Mon,  7 Oct 2024 22:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728339390; cv=none; b=gewbsmXBzHPUVtk2MCDAHs0rPAbyAnvvy92HqGgQgh83wr6gD8Dqjy35QB1FXNWjI4WEG3cb4uhLmfDSaWH43Wh6wxOEslCMl4VMtLPVMWOJM9KRmUZgY2u/dMYdZldwHeZOFgH8d33crDhe+JXsmv+YQZ5XgL351EL3hBG2/Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728339390; c=relaxed/simple;
	bh=hytG+DlCN2LxsU7N8U7DGWbARztmrWTXZ1oJB5kTG2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LJmpQ2d6Smc5VRVquyRoESZ1Ct0Hz4ESgvGchC06udgfMx2TVMvnh3s9mUXWUL9sv4sNCg7iR+3LQA3Q9APAnM31+g4ibs/x1HfOdUyWycgH0qRlDUwZFmbBbf/5y0g0n8xk6Hfb0aDPfiQp634bgMAhOLC/I3kh6kgXSLJwjeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=GLwCkhYZ; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-71de776bc69so2308286b3a.1
        for <io-uring@vger.kernel.org>; Mon, 07 Oct 2024 15:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1728339388; x=1728944188; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=scjT5Hn9k0teOSkkRyDmcqyl/YFn1hQ0QF/jVboTcZU=;
        b=GLwCkhYZULWEmGFf7H1I3LL191isKWZhqPkybXuEEShKtAbyhlXJHAr3XbmQCq1LVY
         rVdISH7/RoEhh4Y6tYh5dINsmHyrl7L7gBqsbnkwJPE6Szr/dOe5clvlFEXuOkx0Q72G
         +v31NixegjIh0wPygwWglAT+e1YFXxAdoh4Mvewv8Ptf/AMiH4dMQ2/AAdWQhfbMWE+Z
         5ZPwTJTnEXucfTen/Yhzi8Ri/+xSKPzxk/C0h9odxp74qWQnf9TDNQBiHm9uReyUNcRA
         e+Jd7an0xnDgipiwtmLDJs7y1eInTZABwURoYGQPDaVu3V63ikl6UQnm2AClfNJt3ErN
         kPDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728339388; x=1728944188;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=scjT5Hn9k0teOSkkRyDmcqyl/YFn1hQ0QF/jVboTcZU=;
        b=L+JZoDYdjiehSpNbUJH2zIC94HS3Q6z5oIUvEycmZfRARRfzThtG5hmtYRTYwKpMZH
         5Qyp5zwnABBw3fxh3h1BOYyLYUtsxrXJWgdQU0d0J/bUOU9KZ2qzaujtqHeHXL+ZxOy4
         NXfbEow70Eeet0CRkieKyiaPfCtOfXd60Y7UcPeIcgK9rFJ40Ekacl1vAtzr7xntpBdU
         ruLMBD6RSBXtoLdVDMF2v4Cw/HhRsFuZCcsqb/QNlFk8TrLzu3b6vTNPoU/r5n19HoIU
         shqj/Ba4ELISctRFjtxuLcFcLn/IC8xqUMK9VcoZihT5ON0acZCFcP8hdPIjAQ7QBq3B
         oMUQ==
X-Gm-Message-State: AOJu0Yy+4SD683T4yqt3ryATyqqZJsC91TqupZMvBkcTHLBP/MUuSHdW
	1NgcV7cWIqtPI3Ku1INzOrFc+y8zhXZfXlmx7Q0/Ph7xscPs+G6BV9nHRWTwD4J/9aoHjyJ9cGE
	K
X-Google-Smtp-Source: AGHT+IFW6HRbeVnFXK0JufimVAIAksganyuaGEKl+hR7te+mOEZlkiH8mVhw9SquXWLMe7WX7iXmvg==
X-Received: by 2002:a05:6a00:2392:b0:71d:fbf3:f769 with SMTP id d2e1a72fcca58-71dfbf3f973mr11784422b3a.28.1728339388174;
        Mon, 07 Oct 2024 15:16:28 -0700 (PDT)
Received: from localhost (fwdproxy-prn-032.fbsv.net. [2a03:2880:ff:20::face:b00c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71df0ccd1aesm4932993b3a.67.2024.10.07.15.16.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2024 15:16:27 -0700 (PDT)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: David Wei <dw@davidwei.uk>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>
Subject: [PATCH v1 01/15] net: devmem: pull struct definitions out of ifdef
Date: Mon,  7 Oct 2024 15:15:49 -0700
Message-ID: <20241007221603.1703699-2-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241007221603.1703699-1-dw@davidwei.uk>
References: <20241007221603.1703699-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

Don't hide structure definitions under conditional compilation, it only
makes messier and harder to maintain. Move struct
dmabuf_genpool_chunk_owner definition out of CONFIG_NET_DEVMEM ifdef
together with a bunch of trivial inlined helpers using the structure.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 net/core/devmem.h | 44 +++++++++++++++++---------------------------
 1 file changed, 17 insertions(+), 27 deletions(-)

diff --git a/net/core/devmem.h b/net/core/devmem.h
index 76099ef9c482..cf66e53b358f 100644
--- a/net/core/devmem.h
+++ b/net/core/devmem.h
@@ -44,7 +44,6 @@ struct net_devmem_dmabuf_binding {
 	u32 id;
 };
 
-#if defined(CONFIG_NET_DEVMEM)
 /* Owner of the dma-buf chunks inserted into the gen pool. Each scatterlist
  * entry from the dmabuf is inserted into the genpool as a chunk, and needs
  * this owner struct to keep track of some metadata necessary to create
@@ -64,16 +63,6 @@ struct dmabuf_genpool_chunk_owner {
 	struct net_devmem_dmabuf_binding *binding;
 };
 
-void __net_devmem_dmabuf_binding_free(struct net_devmem_dmabuf_binding *binding);
-struct net_devmem_dmabuf_binding *
-net_devmem_bind_dmabuf(struct net_device *dev, unsigned int dmabuf_fd,
-		       struct netlink_ext_ack *extack);
-void net_devmem_unbind_dmabuf(struct net_devmem_dmabuf_binding *binding);
-int net_devmem_bind_dmabuf_to_queue(struct net_device *dev, u32 rxq_idx,
-				    struct net_devmem_dmabuf_binding *binding,
-				    struct netlink_ext_ack *extack);
-void dev_dmabuf_uninstall(struct net_device *dev);
-
 static inline struct dmabuf_genpool_chunk_owner *
 net_iov_owner(const struct net_iov *niov)
 {
@@ -91,6 +80,11 @@ net_iov_binding(const struct net_iov *niov)
 	return net_iov_owner(niov)->binding;
 }
 
+static inline u32 net_iov_binding_id(const struct net_iov *niov)
+{
+	return net_iov_owner(niov)->binding->id;
+}
+
 static inline unsigned long net_iov_virtual_addr(const struct net_iov *niov)
 {
 	struct dmabuf_genpool_chunk_owner *owner = net_iov_owner(niov);
@@ -99,10 +93,18 @@ static inline unsigned long net_iov_virtual_addr(const struct net_iov *niov)
 	       ((unsigned long)net_iov_idx(niov) << PAGE_SHIFT);
 }
 
-static inline u32 net_iov_binding_id(const struct net_iov *niov)
-{
-	return net_iov_owner(niov)->binding->id;
-}
+#if defined(CONFIG_NET_DEVMEM)
+
+void __net_devmem_dmabuf_binding_free(struct net_devmem_dmabuf_binding *binding);
+struct net_devmem_dmabuf_binding *
+net_devmem_bind_dmabuf(struct net_device *dev, unsigned int dmabuf_fd,
+		       struct netlink_ext_ack *extack);
+void net_devmem_unbind_dmabuf(struct net_devmem_dmabuf_binding *binding);
+int net_devmem_bind_dmabuf_to_queue(struct net_device *dev, u32 rxq_idx,
+				    struct net_devmem_dmabuf_binding *binding,
+				    struct netlink_ext_ack *extack);
+void dev_dmabuf_uninstall(struct net_device *dev);
+
 
 static inline void
 net_devmem_dmabuf_binding_get(struct net_devmem_dmabuf_binding *binding)
@@ -124,8 +126,6 @@ net_devmem_alloc_dmabuf(struct net_devmem_dmabuf_binding *binding);
 void net_devmem_free_dmabuf(struct net_iov *ppiov);
 
 #else
-struct net_devmem_dmabuf_binding;
-
 static inline void
 __net_devmem_dmabuf_binding_free(struct net_devmem_dmabuf_binding *binding)
 {
@@ -165,16 +165,6 @@ net_devmem_alloc_dmabuf(struct net_devmem_dmabuf_binding *binding)
 static inline void net_devmem_free_dmabuf(struct net_iov *ppiov)
 {
 }
-
-static inline unsigned long net_iov_virtual_addr(const struct net_iov *niov)
-{
-	return 0;
-}
-
-static inline u32 net_iov_binding_id(const struct net_iov *niov)
-{
-	return 0;
-}
 #endif
 
 #endif /* _NET_DEVMEM_H */
-- 
2.43.5


