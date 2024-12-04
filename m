Return-Path: <io-uring+bounces-5214-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 027E19E428C
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 18:56:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CD7FA165D85
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 17:56:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22CF42139B5;
	Wed,  4 Dec 2024 17:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="dsxAUX8d"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC4E205AB3
	for <io-uring@vger.kernel.org>; Wed,  4 Dec 2024 17:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733332965; cv=none; b=b4BNqsT2d+KoneLMbdU/PIz2byzIw9fXuaeaQWYkBbouqGFA6epQN867R70r7vuvh1oRnQIZm/mkuIt1FODn31Eh7DYVr+7eBvn2FUTllVy6P5mf1t+Uynu9joDvLol4O3j/3LP2WSgKeGMqdric7kra6fL2Hlxt2FABn3iJyTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733332965; c=relaxed/simple;
	bh=XvRdkvazrDmZ1Kd7Oyb1j/+3ssBezOG7u0Y2B0T4Z0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=csdaEUAqbak6yjORG6Zaj7cmqNMPdO6pcEGJXkKDZfox3mAj9HeId3YE/N72YGbYpI00cQ4aY7l/2N7f1oWAxBJRycF0P4k+AsPkBQf2C8Kmo1IfxkOxnUBcKdRK/ZeRfqnBBttLenzY7PQHb2T6xwXiVeHX1B/aqRvhbhE3Kjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=dsxAUX8d; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-215810fff52so42443915ad.1
        for <io-uring@vger.kernel.org>; Wed, 04 Dec 2024 09:22:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1733332963; x=1733937763; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ED4HczsmESLV9aByZwZf3sriAwBjJXMtxojVRAGQXDk=;
        b=dsxAUX8djduAXYOfg4kS1D9X94hWuXRFNGGxdVuHI5cuSNfQkHllV/7Fq3qRWd6vpt
         0wFVQxe5njrA5RBGB4Lbli8katkygN1NloUZTSmGiu5ZId6BpntkckGdXDZPLmEtANfw
         KsArPglTwMRD6vSrGJeB5Ath0tjSQzMelMSbsRNqu5XHaOtyfLFFyvgYMqz1U5ZL29v/
         YQj+ESnwwH74n/I4nn9H/MswZvFdyIbIhjYL8AYMxubJuT3aaFfWu5BgqelvgGgQOuHe
         7ZooZ9vEPJ2YJx639dziHyLBG2K4WNfyx53ajfcTZrbvwurmDvG1CRfVW2JCgRzFuKPQ
         KwPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733332963; x=1733937763;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ED4HczsmESLV9aByZwZf3sriAwBjJXMtxojVRAGQXDk=;
        b=RyacE+4PPH6WOI4Tc79xJq5M1yxEN8SXytjSVf9SSjc+GDzFlS0fd9eBZ9OnFsZnH7
         QnBAn95fsS2gdluGxUfxr/T4hB6IfG7T7B7sy6B6ZC8LQ7WC4g/ChbBvI6+AB6UDotWG
         09qrQUp5fXk9rusXhJAw5SIX4Q03G1MnxMyK9JWuZalpkDazk5pUPApQq4EZM3n217BN
         GgdChC8oRxfOq4nhd2eSSU5ZS4aDv99nC2V1/voYV4L64/KflawMKJ0vWDNI/V3eQBfQ
         E598wajYcp8YEYve36slFtHFktNnrhuaUX3poJzpPTkATQ9I7PX0wlwbrSEXQA4BqOnd
         RFuw==
X-Gm-Message-State: AOJu0YzQdJbpss737MqyqTMFZUuVjnB9pDswqKLTHexdHscBvJ2bk0Jy
	QJPu3x9GJEoBeuJfEJxGmUsDx1w8N29wTDdvp7+LnLouqSBgFmf4KFY10c0Ls1pkalAuMZ0SqLB
	q
X-Gm-Gg: ASbGncs2rBFR+LJA90NEqbdpq7JruTB9Q3AGMGiH9pxyBYojDL9mlBEtWNY+4RoBIm8
	QFc8tD7+S7vNj6LkgqedAPvsMGS3Wr3KDAeAeJEaDQRgEpa7J+UrJDeNWhFN9zJsCQo/cvPT4tC
	ThtLkLZvROT4QsfLbysfKjwx/9m474WXUWruX/ER0vIECJCzUv7etSarA4te8rEf5GoY0rBIvaD
	Ig04ABduZRNY6O17Doide5jQHCSLnzwNw==
X-Google-Smtp-Source: AGHT+IGVbPmbB7ozafq1v0+R5E2YCOhtJ/A0zSt3AergeaNjiTx9OBuin0TzWvA0ObY/YTRvSiBMqg==
X-Received: by 2002:a17:902:d504:b0:215:620f:8de4 with SMTP id d9443c01a7336-215bd1b4700mr96159175ad.2.1733332962844;
        Wed, 04 Dec 2024 09:22:42 -0800 (PST)
Received: from localhost ([2a03:2880:ff:8::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2158b08969bsm59633955ad.265.2024.12.04.09.22.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2024 09:22:42 -0800 (PST)
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
Subject: [PATCH net-next v8 01/17] net: prefix devmem specific helpers
Date: Wed,  4 Dec 2024 09:21:40 -0800
Message-ID: <20241204172204.4180482-2-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241204172204.4180482-1-dw@davidwei.uk>
References: <20241204172204.4180482-1-dw@davidwei.uk>
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
 net/core/devmem.c |  2 +-
 net/core/devmem.h | 14 +++++++-------
 net/ipv4/tcp.c    |  2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

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


