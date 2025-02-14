Return-Path: <io-uring+bounces-6446-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 16831A3659A
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2025 19:18:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C1DC716927B
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2025 18:18:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFBE4267B08;
	Fri, 14 Feb 2025 18:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E4aRYVJM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB65C14B942;
	Fri, 14 Feb 2025 18:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739557088; cv=none; b=E7zDMwGQVLg4rqBM2wv0rwkD5KaDW3ChvEIVkYmpfgL9sasyaPMt8/9hXC4NRWV2ZhzqAmu2yFJ9QIeOE6AsByrNwsfblT/V4XLNfnFTNZiWgrUJP+buLwhTzmAr4FQWf/9hHDtESQ0AmkK3PYhFtkhJJiILluRtrNmnHYUZKcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739557088; c=relaxed/simple;
	bh=Ic5gJeq/hmjUXYKjE77BAaCqGzsk84AUFkY8a5hRTes=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=E77RQK/JWSdg+mYbzRYifTWYw6Vj0WK1Jxt/7NAB6hSuUKo2qpo60wclemzHtObjTf0oY47ZRLaDzYVBvd/4nc8oA/TYn6+ryReOZJwnJk4g02SPMQV5j3O/srBuqtwlRInuhsJf+ZH77Ux2KbSZKE1Z+yQR+z+nCeFMfdLR5IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E4aRYVJM; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-6e46f491275so38415296d6.3;
        Fri, 14 Feb 2025 10:18:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739557085; x=1740161885; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8JmWqruVNU4EPMFiD9C7xsM6jzfCuUrZ2XHs9HxCY5c=;
        b=E4aRYVJMGQI8XyrKdxsBDXx1T8GcjZ/ZSz/Mpay97PV2sUiWyxvV6iUTle4UP6bn8L
         iNMQTN+a3TrCuiCvJQRb69LyoglrIwM+MVC9lWaxUFu/4XNMjnQYiVLNa0xux9ubmpmP
         UzoLji8x0L96ANJui8OYOKti2Etw0mQxYStp4ecdjGcRkbTUAGrwQPqZ1SDAqNo6IHHf
         6GUmQNcQjviq1Hadtf7+P5Cq75gqaUzVgO1Lb2J8Hw7o81ntS7uIjZ0BQ4DeMsc2LlCL
         r58FoGkNr9L7cZLIWQ6kOPNhR0C4hbfV1Ldb0ieE37YMZFu/yjM4f9ouhlDtE0SXQsaa
         oQkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739557085; x=1740161885;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8JmWqruVNU4EPMFiD9C7xsM6jzfCuUrZ2XHs9HxCY5c=;
        b=uJjGe0OKT9o6QqwmTzFns4o72sQLkQB8VmBhECl9cj4ly58C/Dqzyfvc43LXNQm8Nd
         1VgyisxsVuOw0ps4iLrTiNRS+dq5mqZvR0GZC20rlFWFuORLBex4sgVGTvgBAVnOjta+
         qULTJLk0gmkRvm174nv3AVBO9A9etkspLdN76VaLCL6Cee277SHCsA8hX0jXz1yL3S+F
         DJCDGSLudrklsjqzqSG1Y8HALgNVPaXXeQYLRIUP+hg+iUl169Nxgcp0WYUKK80ojjcc
         CRjYDTMUvAIPOWW2hTvMemup9nK+64jQ8NMdKkEWd6Mmk8zACmYkSPsvJeK9BnZ2ogjT
         e0sw==
X-Forwarded-Encrypted: i=1; AJvYcCUBEh7B2aGIBkEv90g06gtsB7qMgWvItpG8yv2WRJdo/q/DLyp6gRLk2FD5YyyajOTzrYa1J29VRq0=@vger.kernel.org, AJvYcCUF0FHJyXmntCUs5SMGSEGyqkSLLEfsAMNL8SGQvf88ya+T/tNljHpbrrPLwhd+WtI5jzg=@vger.kernel.org, AJvYcCUcA3Xy6ufJQs3dIT3krkD+d+3KPgDj2s6vU/7Y22tmbqcYphcfEarkUM7kNm0OywlZ8+Ym3y7N7kvETCtX@vger.kernel.org, AJvYcCWwksrRW/KIhFJ7pBuC0kPzrCWjLePBd/lpyFUGLH9LnkW6BBikhfI5C9fMSabaJB54OJaWEtvX++hedE7R4A==@vger.kernel.org
X-Gm-Message-State: AOJu0YyandrBeQqFHahfKL+4MOtmHefn81kbHcys3sJcZJDsYTixjX7b
	f/kc1+FF7zUxz5jXLmE+WY6NqgUSdSU7mBVhee58ZtnE/qBIkUEmUUhjbhWMZJU=
X-Gm-Gg: ASbGncuW5M6IlpeTHPkCgDHgdIf8jiBP8jchFF7RzSwm3nGISllpz1515G+Tvg1A6ho
	ZRyDtBN+YDDLCvBXAy5sB+aV8c0sJFxD11gCTsWeTVU638Asci+ZymwutELmL+pAX2CL0PBmGeG
	0ok+63ujMl0XgFXTNcwiG6yX9+XXB7g9gvJovBu8TOjttsRj1tBKtryXV98Fhsx3xXLqNVwCJSU
	WANLUh2ApmvmKQueIsYdaFmRtdfbsyIOkCsYYO9HYrjhM8TnP9AJTMQr2Fi9vAu8mFuM5mVItvr
	uwqdjfh8kjI+uI1r27KMy8MlO8jKv/M0eWd2zYU7Ugh6WtV7Hh92nTbL/0hs0joUCZpRIhVZsIY
	t2+4Tn4M=
X-Google-Smtp-Source: AGHT+IGzjod+G/33V3jUtrDFJ9knjHyMbQE4yzF1qZkf3yP5N2geQeFqVOHZev/nQYcS30sz78pBtQ==
X-Received: by 2002:a05:6214:21c8:b0:6e1:697c:d9b8 with SMTP id 6a1803df08f44-6e66cc8b653mr4522336d6.9.1739557085377;
        Fri, 14 Feb 2025 10:18:05 -0800 (PST)
Received: from stef-kernel-development.. (syn-075-130-252-044.res.spectrum.com. [75.130.252.44])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-471c2a30b98sm19905811cf.34.2025.02.14.10.18.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2025 10:18:04 -0800 (PST)
From: Stefano Jordhani <sjordhani@gmail.com>
To: netdev@vger.kernel.org
Cc: Stefano Jordhani <sjordhani@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Joe Damato <jdamato@fastly.com>,
	Jens Axboe <axboe@kernel.dk>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Willem de Bruijn <willemb@google.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Jonathan Lemon <jonathan.lemon@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Mina Almasry <almasrymina@google.com>,
	David Wei <dw@davidwei.uk>,
	linux-fsdevel@vger.kernel.org (open list:FILESYSTEMS (VFS and infrastructure)),
	linux-kernel@vger.kernel.org (open list),
	io-uring@vger.kernel.org (open list:IO_URING),
	bpf@vger.kernel.org (open list:XDP SOCKETS (AF_XDP))
Subject: [PATCH net-next v2] net: use napi_id_valid helper
Date: Fri, 14 Feb 2025 18:17:51 +0000
Message-ID: <20250214181801.931-1-sjordhani@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In commit 6597e8d35851 ("netdev-genl: Elide napi_id when not present"),
napi_id_valid function was added. Use the helper to refactor open-coded
checks in the source.

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Stefano Jordhani <sjordhani@gmail.com>
Reviewed-by: Joe Damato <jdamato@fastly.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk> # for iouring
---
v2:
 - Added Joe's and Jens' (for iouring) Reviewed-by tags. 
 - Respinning because my email client mangled my previous patch.

 fs/eventpoll.c            | 8 ++++----
 include/net/busy_poll.h   | 4 ++--
 io_uring/napi.c           | 4 ++--
 net/core/dev.c            | 6 +++---
 net/core/netdev-genl.c    | 2 +-
 net/core/page_pool_user.c | 2 +-
 net/core/sock.c           | 2 +-
 net/xdp/xsk.c             | 2 +-
 8 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 7c0980db77b3..2fecf66661e9 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -447,7 +447,7 @@ static bool ep_busy_loop(struct eventpoll *ep, int nonblock)
 	if (!budget)
 		budget = BUSY_POLL_BUDGET;
 
-	if (napi_id >= MIN_NAPI_ID && ep_busy_loop_on(ep)) {
+	if (napi_id_valid(napi_id) && ep_busy_loop_on(ep)) {
 		napi_busy_loop(napi_id, nonblock ? NULL : ep_busy_loop_end,
 			       ep, prefer_busy_poll, budget);
 		if (ep_events_available(ep))
@@ -492,7 +492,7 @@ static inline void ep_set_busy_poll_napi_id(struct epitem *epi)
 	 *	or
 	 * Nothing to do if we already have this ID
 	 */
-	if (napi_id < MIN_NAPI_ID || napi_id == ep->napi_id)
+	if (!napi_id_valid(napi_id) || napi_id == ep->napi_id)
 		return;
 
 	/* record NAPI ID for use in next busy poll */
@@ -546,7 +546,7 @@ static void ep_suspend_napi_irqs(struct eventpoll *ep)
 {
 	unsigned int napi_id = READ_ONCE(ep->napi_id);
 
-	if (napi_id >= MIN_NAPI_ID && READ_ONCE(ep->prefer_busy_poll))
+	if (napi_id_valid(napi_id) && READ_ONCE(ep->prefer_busy_poll))
 		napi_suspend_irqs(napi_id);
 }
 
@@ -554,7 +554,7 @@ static void ep_resume_napi_irqs(struct eventpoll *ep)
 {
 	unsigned int napi_id = READ_ONCE(ep->napi_id);
 
-	if (napi_id >= MIN_NAPI_ID && READ_ONCE(ep->prefer_busy_poll))
+	if (napi_id_valid(napi_id) && READ_ONCE(ep->prefer_busy_poll))
 		napi_resume_irqs(napi_id);
 }
 
diff --git a/include/net/busy_poll.h b/include/net/busy_poll.h
index 741fa7754700..cab6146a510a 100644
--- a/include/net/busy_poll.h
+++ b/include/net/busy_poll.h
@@ -119,7 +119,7 @@ static inline void sk_busy_loop(struct sock *sk, int nonblock)
 #ifdef CONFIG_NET_RX_BUSY_POLL
 	unsigned int napi_id = READ_ONCE(sk->sk_napi_id);
 
-	if (napi_id >= MIN_NAPI_ID)
+	if (napi_id_valid(napi_id))
 		napi_busy_loop(napi_id, nonblock ? NULL : sk_busy_loop_end, sk,
 			       READ_ONCE(sk->sk_prefer_busy_poll),
 			       READ_ONCE(sk->sk_busy_poll_budget) ?: BUSY_POLL_BUDGET);
@@ -134,7 +134,7 @@ static inline void skb_mark_napi_id(struct sk_buff *skb,
 	/* If the skb was already marked with a valid NAPI ID, avoid overwriting
 	 * it.
 	 */
-	if (skb->napi_id < MIN_NAPI_ID)
+	if (!napi_id_valid(skb->napi_id))
 		skb->napi_id = napi->napi_id;
 #endif
 }
diff --git a/io_uring/napi.c b/io_uring/napi.c
index b1ade3fda30f..4a10de03e426 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -44,7 +44,7 @@ int __io_napi_add_id(struct io_ring_ctx *ctx, unsigned int napi_id)
 	struct io_napi_entry *e;
 
 	/* Non-NAPI IDs can be rejected. */
-	if (napi_id < MIN_NAPI_ID)
+	if (!napi_id_valid(napi_id))
 		return -EINVAL;
 
 	hash_list = &ctx->napi_ht[hash_min(napi_id, HASH_BITS(ctx->napi_ht))];
@@ -87,7 +87,7 @@ static int __io_napi_del_id(struct io_ring_ctx *ctx, unsigned int napi_id)
 	struct io_napi_entry *e;
 
 	/* Non-NAPI IDs can be rejected. */
-	if (napi_id < MIN_NAPI_ID)
+	if (!napi_id_valid(napi_id))
 		return -EINVAL;
 
 	hash_list = &ctx->napi_ht[hash_min(napi_id, HASH_BITS(ctx->napi_ht))];
diff --git a/net/core/dev.c b/net/core/dev.c
index d5ab9a4b318e..bcb266ab2912 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1008,7 +1008,7 @@ struct net_device *dev_get_by_napi_id(unsigned int napi_id)
 
 	WARN_ON_ONCE(!rcu_read_lock_held());
 
-	if (napi_id < MIN_NAPI_ID)
+	if (!napi_id_valid(napi_id))
 		return NULL;
 
 	napi = napi_by_id(napi_id);
@@ -6740,7 +6740,7 @@ static void napi_hash_add(struct napi_struct *napi)
 
 	/* 0..NR_CPUS range is reserved for sender_cpu use */
 	do {
-		if (unlikely(++napi_gen_id < MIN_NAPI_ID))
+		if (unlikely(!napi_id_valid(++napi_gen_id)))
 			napi_gen_id = MIN_NAPI_ID;
 	} while (napi_by_id(napi_gen_id));
 
@@ -6911,7 +6911,7 @@ netif_napi_dev_list_add(struct net_device *dev, struct napi_struct *napi)
 
 	higher = &dev->napi_list;
 	list_for_each_entry(pos, &dev->napi_list, dev_list) {
-		if (pos->napi_id >= MIN_NAPI_ID)
+		if (napi_id_valid(pos->napi_id))
 			pos_id = pos->napi_id;
 		else if (pos->config)
 			pos_id = pos->config->napi_id;
diff --git a/net/core/netdev-genl.c b/net/core/netdev-genl.c
index c18bb53d13fd..22ac51356d9f 100644
--- a/net/core/netdev-genl.c
+++ b/net/core/netdev-genl.c
@@ -267,7 +267,7 @@ netdev_nl_napi_dump_one(struct net_device *netdev, struct sk_buff *rsp,
 
 	prev_id = UINT_MAX;
 	list_for_each_entry(napi, &netdev->napi_list, dev_list) {
-		if (napi->napi_id < MIN_NAPI_ID)
+		if (!napi_id_valid(napi->napi_id))
 			continue;
 
 		/* Dump continuation below depends on the list being sorted */
diff --git a/net/core/page_pool_user.c b/net/core/page_pool_user.c
index 9d8a3d8597fa..c82a95beceff 100644
--- a/net/core/page_pool_user.c
+++ b/net/core/page_pool_user.c
@@ -233,7 +233,7 @@ page_pool_nl_fill(struct sk_buff *rsp, const struct page_pool *pool,
 		goto err_cancel;
 
 	napi_id = pool->p.napi ? READ_ONCE(pool->p.napi->napi_id) : 0;
-	if (napi_id >= MIN_NAPI_ID &&
+	if (napi_id_valid(napi_id) &&
 	    nla_put_uint(rsp, NETDEV_A_PAGE_POOL_NAPI_ID, napi_id))
 		goto err_cancel;
 
diff --git a/net/core/sock.c b/net/core/sock.c
index a197f0a0b878..53c7af0038c4 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2042,7 +2042,7 @@ int sk_getsockopt(struct sock *sk, int level, int optname,
 		v.val = READ_ONCE(sk->sk_napi_id);
 
 		/* aggregate non-NAPI IDs down to 0 */
-		if (v.val < MIN_NAPI_ID)
+		if (!napi_id_valid(v.val))
 			v.val = 0;
 
 		break;
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 89d2bef96469..0edf25973072 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -875,7 +875,7 @@ static bool xsk_no_wakeup(struct sock *sk)
 #ifdef CONFIG_NET_RX_BUSY_POLL
 	/* Prefer busy-polling, skip the wakeup. */
 	return READ_ONCE(sk->sk_prefer_busy_poll) && READ_ONCE(sk->sk_ll_usec) &&
-		READ_ONCE(sk->sk_napi_id) >= MIN_NAPI_ID;
+		napi_id_valid(READ_ONCE(sk->sk_napi_id));
 #else
 	return false;
 #endif

base-commit: 7a7e0197133d18cfd9931e7d3a842d0f5730223f
-- 
2.43.0


