Return-Path: <io-uring+bounces-5534-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AC5DE9F5BA4
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 01:37:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8CBBD1895419
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 00:36:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46AB61F5F6;
	Wed, 18 Dec 2024 00:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="V6ybPA68"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44E322F11
	for <io-uring@vger.kernel.org>; Wed, 18 Dec 2024 00:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734482163; cv=none; b=lZER4Ik2re2CVNae9Z7IGp1V7cDYIGkwEHxXnJr4FeU08btcr8ZubVec+CflzpLr/YzjKNy7BYRjpzM2LmSAQ6YuhSECmTwhW4OeEBClOh0apeHYswHzd3GkSFB1Hy8YBr4eL5NYqb5b54ty5foOIJGinomGZsZ7i3SruYogZj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734482163; c=relaxed/simple;
	bh=kokGPXOtKmJ8NMnDjbo7lcERhIq+pUTFKWNlFSMMVJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SbKdhCJRMKRsfh0kaD1NNAD9l4ztt1hXgqXeeL3S3B9gW/TaiILpYpiExmtXYgoF0Abz7WgkufKjv+CTbZ4wEGz8XjuixkYDbXAZmfYu1DqTxDsHl0q/J6+k99B1Ca6Q4HwQ6LGswea752wlwesBrSJ+GLl8UeTFvnXdj5Y850U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=V6ybPA68; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-728e1799d95so6936374b3a.2
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2024 16:36:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1734482161; x=1735086961; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ysSCaIB4GXTEiUBi/fqYnu5BV5g5/6ElTQwwBF3xc+Y=;
        b=V6ybPA68ijZ1VQDl8IpmS1yl4jKYPZL3XuBgLPVZ6nRDG0uaT3cjQLPRz2UDnbOsFf
         5KQJxypQnu9kGtkPt52xNld/J9v9ANskQ5cJVfD7sDKOlMg1hxZP+RbNNnFZCMQGZZog
         TW1LX5h7GRYbb0xo/0BCU5y8Q6zaaCZ2j/Rd0W43C6Vj/NvVWCAACHbX+EcwtmcLQOQF
         LZWKZAcSHxIesrkR6irOszsudw2bDh6ic9WlrB0jKox7A2+/ylkYgvU+IOu7IVGMgjCa
         w40pUl4NShpKWS5M8zP3pN8xNDVNN2gPBRdMbdmWNbRrqys5589GVnPPaC/AU4YrHRr6
         88Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734482161; x=1735086961;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ysSCaIB4GXTEiUBi/fqYnu5BV5g5/6ElTQwwBF3xc+Y=;
        b=EgV63eHVYZvQ1kCbY6uyXH6lH0GQP7lF46R81VrUC73rlcS6Wp8AfODU5kMsDvEpCp
         SSu+kLV233CsCJaUwnSPe5GCk2CQDV8+p0baMQU7GwwsKHgL5JLu6iYfDkAbEbWs4sLB
         CPkwU2cJNSjMO1NmmlGNWp1pt8YUCKiacL1oCc3643ycHRDqn1A58pWVYzk190olE/69
         yEQ0dyT0xXcOFW3+wOmpG54W8U5F0uLyBZM43HR1ce9d1wRWMYu+7cg8pVwBZ+gEkD97
         J/1i38ql3jDXfhNawM1y/lXCPcdrL9N3rTT6rbqDbFDo/6mYAaHfhGkS/UcS38s6lc/9
         OnDg==
X-Gm-Message-State: AOJu0Ywuj386C1a8IlqlpbK9RHPbgW+uYBHuiDS94ASQcwBC0tqF1LTq
	s56VfyaOYjd2gDIlDknb3I0JauKVSCkcfM+KUwtfKTE4NJVPRx2l5PgXjJ6RDqd2pHPSLIU+pqz
	2
X-Gm-Gg: ASbGnct94PzrU7PLTDF6VwXOtg0AOiGBuL97YXuvvXsf3oQr3GgQ5vnipLBN5IS7XPz
	daaXel5E0nsvroUgbFFPU/os7iQIhFr0wXVjcka8NnSNAlNUxtHbIZL2LS6yKP80AXv6MiEX6ri
	oEcZ9E/xKzJlgT0MHTEiRWjz8nUxKRuOflNZDqY/MHgemlKRQBBbc9foiUDtykRICG2pkTwJLvR
	R2iUcz5Vv8qhZBumVBAPE9XkCjR+TJp3wNgRk6P
X-Google-Smtp-Source: AGHT+IHK6RI0g4RndMxzssu5s+vJ3eAoHV4b2tI6m6aTkW2JbWD2HemNCOpu054vZvqLojVx6HHW/Q==
X-Received: by 2002:a05:6a00:1807:b0:725:4615:a778 with SMTP id d2e1a72fcca58-72a8d225a2bmr1336107b3a.7.1734482161021;
        Tue, 17 Dec 2024 16:36:01 -0800 (PST)
Received: from localhost ([2a03:2880:ff:b::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72918ad658esm7268702b3a.50.2024.12.17.16.36.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 16:36:00 -0800 (PST)
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
Subject: [--bla-- 02/20] net: prefix devmem specific helpers
Date: Tue, 17 Dec 2024 16:35:30 -0800
Message-ID: <20241218003549.786301-3-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241218003549.786301-1-dw@davidwei.uk>
References: <20241218003549.786301-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

Add prefixes to all helpers that are specific to devmem TCP, i.e.
net_iov_binding[_id].

Reviewed-by: Mina Almasry <almasrymina@google.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 net/core/devmem.c |  2 +-
 net/core/devmem.h | 14 +++++++-------
 net/ipv4/tcp.c    |  2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/core/devmem.c b/net/core/devmem.c
index 0b6ed7525b22..5e1a05082ab8 100644
--- a/net/core/devmem.c
+++ b/net/core/devmem.c
@@ -93,7 +93,7 @@ net_devmem_alloc_dmabuf(struct net_devmem_dmabuf_binding *binding)
 
 void net_devmem_free_dmabuf(struct net_iov *niov)
 {
-	struct net_devmem_dmabuf_binding *binding = net_iov_binding(niov);
+	struct net_devmem_dmabuf_binding *binding = net_devmem_iov_binding(niov);
 	unsigned long dma_addr = net_devmem_get_dma_addr(niov);
 
 	if (WARN_ON(!gen_pool_has_addr(binding->chunk_pool, dma_addr,
diff --git a/net/core/devmem.h b/net/core/devmem.h
index 76099ef9c482..99782ddeca40 100644
--- a/net/core/devmem.h
+++ b/net/core/devmem.h
@@ -86,11 +86,16 @@ static inline unsigned int net_iov_idx(const struct net_iov *niov)
 }
 
 static inline struct net_devmem_dmabuf_binding *
-net_iov_binding(const struct net_iov *niov)
+net_devmem_iov_binding(const struct net_iov *niov)
 {
 	return net_iov_owner(niov)->binding;
 }
 
+static inline u32 net_devmem_iov_binding_id(const struct net_iov *niov)
+{
+	return net_devmem_iov_binding(niov)->id;
+}
+
 static inline unsigned long net_iov_virtual_addr(const struct net_iov *niov)
 {
 	struct dmabuf_genpool_chunk_owner *owner = net_iov_owner(niov);
@@ -99,11 +104,6 @@ static inline unsigned long net_iov_virtual_addr(const struct net_iov *niov)
 	       ((unsigned long)net_iov_idx(niov) << PAGE_SHIFT);
 }
 
-static inline u32 net_iov_binding_id(const struct net_iov *niov)
-{
-	return net_iov_owner(niov)->binding->id;
-}
-
 static inline void
 net_devmem_dmabuf_binding_get(struct net_devmem_dmabuf_binding *binding)
 {
@@ -171,7 +171,7 @@ static inline unsigned long net_iov_virtual_addr(const struct net_iov *niov)
 	return 0;
 }
 
-static inline u32 net_iov_binding_id(const struct net_iov *niov)
+static inline u32 net_devmem_iov_binding_id(const struct net_iov *niov)
 {
 	return 0;
 }
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 0d704bda6c41..b872de9a8271 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2494,7 +2494,7 @@ static int tcp_recvmsg_dmabuf(struct sock *sk, const struct sk_buff *skb,
 
 				/* Will perform the exchange later */
 				dmabuf_cmsg.frag_token = tcp_xa_pool.tokens[tcp_xa_pool.idx];
-				dmabuf_cmsg.dmabuf_id = net_iov_binding_id(niov);
+				dmabuf_cmsg.dmabuf_id = net_devmem_iov_binding_id(niov);
 
 				offset += copy;
 				remaining_len -= copy;
-- 
2.43.5


