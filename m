Return-Path: <io-uring+bounces-5978-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EE86A153CB
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 17:11:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BFE851635FA
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 16:11:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92A9919B5B1;
	Fri, 17 Jan 2025 16:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hnHapYmg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D92198822;
	Fri, 17 Jan 2025 16:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737130282; cv=none; b=EeP9Q07RIht29XdswubBLvhi9Dly0iXZktXYp3gY5q2AMfec3T0K2Nzpbpn1z6QgMJFmWQMZtSmws7wfqLbSzqgA2FODq0nOMAZMIc5foW127sozbOj2bCXoYVs+FkcGs1fOMDmgLjAD5pLEAlRRggBD6TqTy230udBWRJA+MC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737130282; c=relaxed/simple;
	bh=xNV5PSzGQkIbUJf+1h9bYQMhTbtUCoF4OXpyhvdcOrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L0PXTmrk2BDe9vtRlXl8k1iygXMAgLQSbAFGVGcUE8jBPnXH0OOaeLoMdSev6Pn8uoyA1f2PLyf9eqXw8FWG0BcN77LvUDe4OHQtJsyUV7DSdVU0gYc5KlmI7uJQq+mjagbqHejKR5tzH/LOjbb4d/g/YyOUJkMyoOzbIt/OJvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hnHapYmg; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5d3d14336f0so4056100a12.3;
        Fri, 17 Jan 2025 08:11:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737130279; x=1737735079; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gm3TPDkykLNtCw5xss6LQT+wSBxwN0LqpzUDne1C954=;
        b=hnHapYmg3IBruHstneiyLQ1uWxNmK8W/jexeipg8eg/SVAQ6I1Xq41wHrrx+CA3IFP
         FCwo21TM81NFGyvwOhqAWKP/bE6NLsj9YQ8IANJJDZ+2mzcS0W0ytmodTjQZdjllqMGb
         xUXcODrf+ym6jZAMBwA6qDKPpfnPBnf7q7s0gYJGeQZ7jnaR3/sqNQVU6VAaT64KLlbf
         GFc/u7LzyYzDmTXuWg0pMq3o7XQtrQODn0uHhs2Zrco+SJ2e3QETAdj2tmnkdcqKP8u7
         mN7JPePn/OHUUmQiKpDF4xWxWxl/Pb2MlhC5bKwmhnQDXZl1km427tJ6Ct/0tBJYmcRH
         jIVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737130279; x=1737735079;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gm3TPDkykLNtCw5xss6LQT+wSBxwN0LqpzUDne1C954=;
        b=V9lhz9myuVxHvjmYSE4yHkHmIt94UapZFL3YS1Sd5WEWZzcrb5/bhTeBOyVkh6gMXp
         L7KPUbemRlM3eqbg69+ozfMYGckuPG6bH12tobRWbM9eT1rBtRqdJv2qUjVljWTF9NhX
         w/6uwGaVu5S/9rGfI/w89FXz//ioNc/7lomP3Tr+KnSsoX5zixUW0AmMN/dSueuLV08E
         D7hfPK7+PngurtK0B87DDypgEW7Jljm1xYA5AyzErf7BARDHfUByS/IMeOq6xlHb5KUY
         ey/uouGeLizEx5zk4QxPPLHinbqkIKUv2f+hTohq5oWC8B+3v7S0yeUeyEl3+h6MvpOX
         DjqA==
X-Forwarded-Encrypted: i=1; AJvYcCVYEO0298aLE93h51WJB9+QfyTcoih4muvmm4+/yXxsg4RX5NXHUSKIxaoGBOZAdkRsUldWKAQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxp6n3Z+o0VFMrlxa6PqMhc8tSJ/yEH5YWfF25qZemZs05wqIct
	2H1orYxqdBOnLG1Sgi7/8gNQ37De724qsFEekIrmFIrhF5uukCWDsFTa8Q==
X-Gm-Gg: ASbGncs8zwbTM0Nmc9LTwzAC23j346KlB3RULgoCIjFfhGT2PeRAgQhRbIHLkfW1gOS
	9jro+UXjUTccTS3wRN0esl8/NCiWhFgkPtdYCZZSXBsIGWaKkWIFFM0IA+T4uaTLDZVhl49LYcE
	/+tf9Gwg18TFwIJo/KacMGKhSdxedJylWm4TpVVXH1vv7kV8M8h0ILhdFntXUzd1ljzqpUhG6h4
	UvwltCT4JVhQhvUf98QVJntOiFUtC3dN2GJRyQI
X-Google-Smtp-Source: AGHT+IFUAl8wAlqtDicZghczHXpiwTnm5n8kfwoGC581koqcUgOkSXVT5mb+rbZVzvBl9/jomo6qkg==
X-Received: by 2002:a17:907:970b:b0:aa6:74a9:ce6e with SMTP id a640c23a62f3a-ab38b240b20mr274337166b.16.1737130278846;
        Fri, 17 Jan 2025 08:11:18 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:56de])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab384f23007sm193716366b.96.2025.01.17.08.11.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2025 08:11:18 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: asml.silence@gmail.com,
	Jens Axboe <axboe@kernel.dk>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Stanislav Fomichev <stfomichev@gmail.com>,
	Joe Damato <jdamato@fastly.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	David Wei <dw@davidwei.uk>
Subject: [PATCH net-next v12 02/10] net: prefix devmem specific helpers
Date: Fri, 17 Jan 2025 16:11:40 +0000
Message-ID: <b5dfe5b1271d29dc5b2c79544a6145d7d213e5f8.1737129699.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1737129699.git.asml.silence@gmail.com>
References: <cover.1737129699.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add prefixes to all helpers that are specific to devmem TCP, i.e.
net_iov_binding[_id].

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/core/devmem.c |  2 +-
 net/core/devmem.h | 14 +++++++-------
 net/ipv4/tcp.c    |  2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/core/devmem.c b/net/core/devmem.c
index c971b8aceac8..acd3e390a3da 100644
--- a/net/core/devmem.c
+++ b/net/core/devmem.c
@@ -94,7 +94,7 @@ net_devmem_alloc_dmabuf(struct net_devmem_dmabuf_binding *binding)
 
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
2.47.1


