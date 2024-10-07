Return-Path: <io-uring+bounces-3443-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 66D1A9939F0
	for <lists+io-uring@lfdr.de>; Tue,  8 Oct 2024 00:16:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0C51B1F23AC9
	for <lists+io-uring@lfdr.de>; Mon,  7 Oct 2024 22:16:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9047318D652;
	Mon,  7 Oct 2024 22:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="fRdt8+T2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9E718C930
	for <io-uring@vger.kernel.org>; Mon,  7 Oct 2024 22:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728339391; cv=none; b=UDEpB7c44+4vfBz27TdCfJr8OVYt3SOO8oH2csYQsvhsMWAS9R6iODcXidkhDiWCeuNvbZURxIlzwLc9wpJucMHc1JjX7G3MjU9AT4/rfrL5Dd1MV0mIbdChWTWSL0i5IxiOA8sSgAwmn29+OpQHEV0QpYeWIwD4jZ8y+oeBN3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728339391; c=relaxed/simple;
	bh=ZfCGft5xpVBEnR3/fijfSn9cgPXUCC73fR3567SvbkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ad6xrPBWtIFPUwk8zx2lqDybfUApfeZAaTgY6d2ogXDOmyh2ou9ziUrm1AO88XIGnlf6kz78wjcY6G7uSX6ILDGxOqYEiph84sCNEk2c47w7KyoXdDYwviVe6ODP7q9W4zLdPx7EygWEAg+kZdn6LPfDVZtn6dULe43XAPFv7dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=fRdt8+T2; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-71dea49e808so2846314b3a.1
        for <io-uring@vger.kernel.org>; Mon, 07 Oct 2024 15:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1728339389; x=1728944189; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mnc2aj24bs6F6f4vp0LuYLnguSpST4iVAkcBGLbjMjc=;
        b=fRdt8+T26mPbaYpHlAE2BnRwtLriyTgMhdDkf+3sj1kqyScp1OzAWI8BWM+kcm+bwW
         oVAaqWl4pWBlF/P+8HnCRUtt+DUCst2s3pMnEPkCP0SaaSt023qru7s+Ws77InQVnNB/
         n7pzdyhRVwPZi3FgfM/NoiBaPRUBLzhqvRm+wLIdeYwFajV8PvCn5IBRwbMQaidE9LwJ
         MAHXZIbTLg2sdjc0LdVycLVXQIfsNA9pekg0+MkQT+SS92zg9UGhLLpbiGTP+y9BQXhR
         lr4lSxxAGhdWq4btapxjcg2cYdMwwEhJbYJbeSvQfC8CbdBSKHXg/LMoMAtA9GPCa21l
         uMGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728339389; x=1728944189;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mnc2aj24bs6F6f4vp0LuYLnguSpST4iVAkcBGLbjMjc=;
        b=PH8p0DtUY2dBAB7RuiWN6hudPY+ovuplj5bF+WHHi3PVdd7jPoc11hkfg+J8FD2KY/
         yb5JcQdbnNXcyk7pC2kejeXiBT8C9qfwiA0WNofJnBKHtyx2yZOuWjfhXghuOAWtdm9I
         QUKIs+kA3/Vg+oLwulo/rCuxbGo1KOXIcU9HUjZqP55rgjFaI+MnsJoQgWzaCwmhZ1ay
         G8TFh10FsbC1KwQaa/w5Av1t3gaAiRt9fuobZr1IzbImxuBZSc0QIFh6lz7j8em1dera
         aRn4lqpPI2j2GyvYOUwaPtrQFZ/uVG+PoRr55PQPPXjmsQu7Sp5+LxvCIYlE64puHFI1
         89jg==
X-Gm-Message-State: AOJu0YzETK3G82qVSD2NsUvBaYXAnB8IuOhYK5kt8a6IT1OkTHg1/TKc
	XUe8jJLVI/dyFfsgBK7cQ5RLeszPonPnd55n0e5mXsHvutvQbYzRITAdVDfBGKOVtIB0W2v9AK2
	Z
X-Google-Smtp-Source: AGHT+IGVsAURER/HsQepSDlOXpx3y6gjR1WuypY0frHO80NxNLtIO071JazgfX4mx5fkA96PITPJYg==
X-Received: by 2002:a05:6a00:a91:b0:71d:d2a9:6ebf with SMTP id d2e1a72fcca58-71de23a9290mr22888892b3a.6.1728339389576;
        Mon, 07 Oct 2024 15:16:29 -0700 (PDT)
Received: from localhost (fwdproxy-prn-112.fbsv.net. [2a03:2880:ff:70::face:b00c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71df0cd14f8sm4895835b3a.65.2024.10.07.15.16.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2024 15:16:29 -0700 (PDT)
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
Subject: [PATCH v1 02/15] net: prefix devmem specific helpers
Date: Mon,  7 Oct 2024 15:15:50 -0700
Message-ID: <20241007221603.1703699-3-dw@davidwei.uk>
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

Add prefixes to all helpers that are specific to devmem TCP, i.e.
net_iov_binding[_id].

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 net/core/devmem.c | 2 +-
 net/core/devmem.h | 6 +++---
 net/ipv4/tcp.c    | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/core/devmem.c b/net/core/devmem.c
index 11b91c12ee11..858982858f81 100644
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
index cf66e53b358f..80f38fe46930 100644
--- a/net/core/devmem.h
+++ b/net/core/devmem.h
@@ -75,14 +75,14 @@ static inline unsigned int net_iov_idx(const struct net_iov *niov)
 }
 
 static inline struct net_devmem_dmabuf_binding *
-net_iov_binding(const struct net_iov *niov)
+net_devmem_iov_binding(const struct net_iov *niov)
 {
 	return net_iov_owner(niov)->binding;
 }
 
-static inline u32 net_iov_binding_id(const struct net_iov *niov)
+static inline u32 net_devmem_iov_binding_id(const struct net_iov *niov)
 {
-	return net_iov_owner(niov)->binding->id;
+	return net_devmem_iov_binding(niov)->id;
 }
 
 static inline unsigned long net_iov_virtual_addr(const struct net_iov *niov)
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 4f77bd862e95..5feef46426f4 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2493,7 +2493,7 @@ static int tcp_recvmsg_dmabuf(struct sock *sk, const struct sk_buff *skb,
 
 				/* Will perform the exchange later */
 				dmabuf_cmsg.frag_token = tcp_xa_pool.tokens[tcp_xa_pool.idx];
-				dmabuf_cmsg.dmabuf_id = net_iov_binding_id(niov);
+				dmabuf_cmsg.dmabuf_id = net_devmem_iov_binding_id(niov);
 
 				offset += copy;
 				remaining_len -= copy;
-- 
2.43.5


