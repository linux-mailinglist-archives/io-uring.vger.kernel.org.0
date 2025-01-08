Return-Path: <io-uring+bounces-5757-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BC0FA067D1
	for <lists+io-uring@lfdr.de>; Wed,  8 Jan 2025 23:07:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AA3191880728
	for <lists+io-uring@lfdr.de>; Wed,  8 Jan 2025 22:07:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A61D6204C10;
	Wed,  8 Jan 2025 22:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="ORlG1huc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41DBD2046BF
	for <io-uring@vger.kernel.org>; Wed,  8 Jan 2025 22:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736374029; cv=none; b=rclMJSHiZLp8mBEKAnEX95YGSw2RGTF03SbcwOWD2+YmQmpYpGUO2o5ApBvoke9kMSpQyjRdGBtRSf9FJqnNYY0U2j7rr+zQqjCej7HI9EHuH+DPjMBQG2MfktvQwYm7GX355N1FDd/gMfImh/IB2A7yKEkunP0OALy0V96CoGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736374029; c=relaxed/simple;
	bh=1iGhFb5yYmlt+N/E7uhnersaFVha+jc84E0nut9lM44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sElno5nXsSHoAI5Yd8Ia795iAOma/35eCtgKE0Fcf7/iqxOnzp4L4rX9y0dEhLiAkUvOZ3cks48fIPfOCC5+eF6DIOYq921l8q3kXGAkYyJimNt+7k0cxpNVufOgF17Uv0nYcztbiqDNT9cVok89YFydzF2BDzdJ3ErVYmFVkHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=ORlG1huc; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2f4409fc8fdso394937a91.1
        for <io-uring@vger.kernel.org>; Wed, 08 Jan 2025 14:07:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1736374026; x=1736978826; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ls7TIJmWbtjH6cQ+zvuFtI+oK15m0KZtEVTJMdgXvRQ=;
        b=ORlG1huc0fXUqqZCeOknixAKVInrzH5ZhZc6jr2haLHq9YjRbrlCRbgijmh4ghw6Ut
         81DwukMX5J1ABeUmZumEOIv1G7C5OOBze6HZmtZwtGXSUn3r7vjoRN936FVAi6BhoCkW
         e/zm2JSEbmxiCw3FHhcs7VLOfu4fFcD1CMDMPrTdy6jwuMet4oY6J+HsHijnHWv7v+SX
         Ca50Ujp7yKkl9qZc1zUQytosycfIPF03HlhOSaqTLjQokLntEAGN+tO8tKlFGrwZBZew
         1LiEqsPnWH+VCxGV0mpWIFtyTzAd2SpWWHhMMTsebxCx7/bf/Zv20c0MiWXJnxcpHUuP
         PCNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736374026; x=1736978826;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ls7TIJmWbtjH6cQ+zvuFtI+oK15m0KZtEVTJMdgXvRQ=;
        b=WUX1VpYdFbxSiSnnn7dNgDPDc2QlLoN1+dwSpA0lkW1nUYNzmycInWh4i332O1PMqw
         /5q43RfUVPUhRH/8LpH+NtFC8CWtFkbJkeltPRfP4qNzMSjQWrV+II5Ps0DetJ1dCuZb
         4mC6pxRBz+3eJ+fbso7l9EEG0oZQ4lp4hLMATpBnYklr5ezEwp9hPr4gzv2mofUmrTla
         HacGxpq+DuML/mPBkych5Q3J8qAhMkrZalmwZxv98+ZvaPLzLjNHoHhNFxcYWAZum6f5
         8X9DAMvuL05T/FwlNJRoyQnvQVlYLjh0mRzQHYOuKKQMPX7TFH2b/i2d+4o9vJd/MzZs
         8ABA==
X-Gm-Message-State: AOJu0YxQf8WzYI8vT15tKX0z8u0iX/97bwOGqNCd8/6zfR8UDFQ5g4Dn
	XDJmedzT4wj/H4YazWKAOfUR7u4ReBQaRmf9155XB2d3fDBPWA+lyRBwTaHb7GdgRM1Nlx7xWwT
	z
X-Gm-Gg: ASbGncs4Zq/Enaqsm40QP0OJd7PF7d271T7iPMSPtfJTFfJVaTJkUyWSeNTs1IyrsPe
	KQm0OqreV1UD7XXEivw3CA2gf3JcmXmNtozuHMwsPI4LJxDK3YmW/KvR4jcnmKcgwlppMN9lZd4
	mRhnkK4Jr1uAzvfCfqRga/IwMQIHqIu7UxP5nNDI1an7YMumk5cvos/4UKsl2TDSda9CUce1FF/
	vwEKwrrxdRC4BQocPsmNYolp1DpcsDoXsZr0lfIAA==
X-Google-Smtp-Source: AGHT+IH9IqSP8v5T7l2QXuQWImU55frwdai+9V8O6x8Vau+rR90vz8gGxOPpZEwrAVkkqcQS0BinDw==
X-Received: by 2002:a17:90b:1a8a:b0:2ef:ad27:7c1a with SMTP id 98e67ed59e1d1-2f5543d2d98mr1325814a91.2.1736374026649;
        Wed, 08 Jan 2025 14:07:06 -0800 (PST)
Received: from localhost ([2a03:2880:ff:12::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f54a2d9168sm2118353a91.39.2025.01.08.14.07.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2025 14:07:06 -0800 (PST)
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
Subject: [PATCH net-next v10 03/22] net: prefix devmem specific helpers
Date: Wed,  8 Jan 2025 14:06:24 -0800
Message-ID: <20250108220644.3528845-4-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250108220644.3528845-1-dw@davidwei.uk>
References: <20250108220644.3528845-1-dw@davidwei.uk>
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

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
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


