Return-Path: <io-uring+bounces-6386-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F3BF5A33154
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 22:15:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 99334164F3F
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 21:15:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70844202F8D;
	Wed, 12 Feb 2025 21:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cTUtnn/I"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93BD2200BA3;
	Wed, 12 Feb 2025 21:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739394909; cv=none; b=KoCbPfwVwIeILXwVsPh8iVBaqrclmkThLKhwlD1lHAOt8jRpvtoDX/0ny1OpO4CvBf1GYLXZjMI/O7N4ZIF+Yy6uGBp+K6LRm+QmDN/uFGX/g72+KPh/abG1fn3Nl1DclJMsn4Zw3ajGFoGLwi7fRVJLLWH3jtewl1WOiNXy+JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739394909; c=relaxed/simple;
	bh=8oFaZGYB7aKcn3LSIDmTGouwbqxlkl5PDh9Fdqo1MdM=;
	h=From:MIME-Version:Date:Message-ID:Subject:To:Cc:Content-Type; b=gqB2wABoould1n/bsNZKuC7VK/sCwtO2J39d01uHsCzDIfvxUYHhB9V1sb1plcta6LYQUi5y/+Ww8lFSUnYSWlbrue5mf2SaNNiBx9ORrr4LKU4fGuPz8xczw7eWdfR2COFHVoc1/brnqyc1r5zg/9h3p5pcgccn22HX5P4ZGu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cTUtnn/I; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-6e442b79de4so2105966d6.2;
        Wed, 12 Feb 2025 13:15:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739394906; x=1739999706; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:mime-version:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PRpTMU+QQrOptneUAcLbMg6GtdMWUJRT8ADEFKtR/MA=;
        b=cTUtnn/ItXm4nrb/1mnkKDIYbJP0uXrzN5YVUorbM+L6TXfKUBO8iO3JNWQR0Bda3Y
         yUV5fHASajLOrp2hJPKX1mPl+4YTZCjWp1HOmTEOmRoqcykJTLG4jvxZ0uiO7wVKXz1W
         CaLHq9llg3aQI8ESJbcNriqU52M/1h//TSk1MGUOrZLc0OH5AxZH7bXZZ+VI34B7DKzD
         6F4wTGGRqI9GMIEPSpIqIdU2SARZb1liSDHfFD+FCgMW9yhQXB/r1FUZz4YZLvVN7jRV
         C9txyadlHIyrAIXiWy97HvQcwfOZFatbrfdexj0eIa6/MENY0ibVVC1Dv0JT+VIdUEuN
         Doaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739394906; x=1739999706;
        h=cc:to:subject:message-id:date:mime-version:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PRpTMU+QQrOptneUAcLbMg6GtdMWUJRT8ADEFKtR/MA=;
        b=kM9keaTp1HGekmXXmDUtOY+folKG886jFhQe91n/iGkdLANZuQhMcKifyjvzC9R5kg
         1nEt9MGzobydnxCZped7PbifReu/wHayAyZoxgj90wHheoQN+FPzLGJNmyPi4PGhot+x
         jjbexVh/A4LHdPTFjHNmgw48yGvAVIS8x9/DfwHgMtR3hqZDuZfFqswz/4x1f4Cx8dAx
         BCkJRzfnr1OQmAf426+WGUQczOraqpxHc0eGDZ6s7assLXvmwK9Si79t2YZYlwFo4Fg0
         1QeZj9xWKvSbt07eJAmxa5rlXvb4xLnz40u6bsXNH2k4tPCxchchwZxhV/UmoHA6IWIN
         NUzg==
X-Forwarded-Encrypted: i=1; AJvYcCUu8rNKtk4/ss7HYj+n5ZfUbjRd1bxhdqTdQX+r8DIoG77DRr1Yb1/Wx0vm3GzCkZtRyl8nINT2xU8=@vger.kernel.org, AJvYcCVJ77zZVL13Ph3MuUeltJH0geI5ND21/kcjx8HFR/R2d4FVH5SslbsPNhVcP8g51Aab8BmrQ1VBhSJTlt2M2g==@vger.kernel.org, AJvYcCVmgtKI0S54NyzFJBwq2UMX51xN4ItASYB/kzvZPqorM97UtUIeXuPDdAOEKj2l1rCDX0I=@vger.kernel.org, AJvYcCVn3E5p1WUbySe9vOTah5hTAA31+TIEqb2I/ZA8caHXLtcQB4/4aCo9dteQwRCrDoAVUVLIOaQa7iJ/TORP@vger.kernel.org
X-Gm-Message-State: AOJu0YwmRbWCCvXFNXa5y2ZtQ88kZ4yeClNyjC0MMREObUbmUeb627X+
	gFn7AfD2bMnx4o4jsG59QP4fqrxfhRgASMb5HYzR9EomLWJSrWWzNkYjot1qTPDZzdLgDQtHH9B
	wqDhDV3QzfoAl036IH8WXrTD+gpQMaVqj8I0=
X-Gm-Gg: ASbGncv7JNwKlOqugTmStqVMBK4p5elZugqh/fdkwHHAb8Zxxj0lZ2uedfbNIG1ed6a
	7dY0Q3dUgXx+LW1LIVv/c2rzE+6+/7vxzzoGBkU4NtnHSLUjQe+gicrEU093Y68uF4hFZar0y
X-Google-Smtp-Source: AGHT+IH/wfGm3/CAsTBU+YAwWOZncBAj615IMgx+6j59WDBDXnbe//4t1nBqJ8S/66IEaHeTZF3BiaCQpNfOJfjQjQY=
X-Received: by 2002:a05:6214:29c2:b0:6d8:8a60:ef24 with SMTP id
 6a1803df08f44-6e46ed77efcmr70712546d6.9.1739394906262; Wed, 12 Feb 2025
 13:15:06 -0800 (PST)
Received: from 270782892852 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 12 Feb 2025 16:15:05 -0500
Received: from 270782892852 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 12 Feb 2025 16:15:05 -0500
From: Stefano Jordhani <sjordhani@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 12 Feb 2025 16:15:05 -0500
X-Gm-Features: AWEUYZktblv-CWUc8KgHQzjBmPtXup2CD1xGkAjazST08bCQ32ye5meR_Nki59M
Message-ID: <CAEEYqun=uM-VuWZJ5puHnyp7CY06fr5kOU3hYwnOG+AydhhmNA@mail.gmail.com>
Subject: [PATCH net-next] net: use napi_id_valid helper
To: netdev@vger.kernel.org
Cc: Stefano Jordhani <sjordhani@gmail.com>, Paolo Abeni <pabeni@redhat.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, Kuniyuki Iwashima <kuniyu@amazon.com>, 
	Willem de Bruijn <willemb@google.com>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>, 
	Magnus Karlsson <magnus.karlsson@intel.com>, 
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>, Jonathan Lemon <jonathan.lemon@gmail.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Lorenzo Bianconi <lorenzo@kernel.org>, 
	Joe Damato <jdamato@fastly.com>, Alexander Lobakin <aleksander.lobakin@intel.com>, 
	Sridhar Samudrala <sridhar.samudrala@intel.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Mina Almasry <almasrymina@google.com>, 
	"open list:FILESYSTEMS (VFS and infrastructure)" <linux-fsdevel@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, 
	"open list:IO_URING" <io-uring@vger.kernel.org>, 
	"open list:XDP SOCKETS (AF_XDP)" <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

In commit 6597e8d35851 ("netdev-genl: Elide napi_id when not present"),
napi_id_valid function was added. Use the helper to refactor open-coded
checks in the source.

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Stefano Jordhani <sjordhani@gmail.com>
---
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
@@ -492,7 +492,7 @@ static inline void ep_set_busy_poll_napi_id(struct
epitem *epi)
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
@@ -119,7 +119,7 @@ static inline void sk_busy_loop(struct sock *sk,
int nonblock)
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
@@ -44,7 +44,7 @@ int __io_napi_add_id(struct io_ring_ctx *ctx,
unsigned int napi_id)
 	struct io_napi_entry *e;

 	/* Non-NAPI IDs can be rejected. */
-	if (napi_id < MIN_NAPI_ID)
+	if (!napi_id_valid(napi_id))
 		return -EINVAL;

 	hash_list = &ctx->napi_ht[hash_min(napi_id, HASH_BITS(ctx->napi_ht))];
@@ -87,7 +87,7 @@ static int __io_napi_del_id(struct io_ring_ctx *ctx,
unsigned int napi_id)
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
@@ -1008,7 +1008,7 @@ struct net_device *dev_get_by_napi_id(unsigned
int napi_id)

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

@@ -6911,7 +6911,7 @@ netif_napi_dev_list_add(struct net_device *dev,
struct napi_struct *napi)

 	higher = &dev->napi_list;
 	list_for_each_entry(pos, &dev->napi_list, dev_list) {
-		if (pos->napi_id >= MIN_NAPI_ID)
+		if (napi_id_valid(pos->napi_id))
 			pos_id = pos->napi_id;
 		else if (pos->config)
 			pos_id = pos->config->napi_id;
diff --git a/net/core/netdev-genl.c b/net/core/netdev-genl.c
index 0dcd4faefd8d..cdcd39724cb3 100644
--- a/net/core/netdev-genl.c
+++ b/net/core/netdev-genl.c
@@ -267,7 +267,7 @@ netdev_nl_napi_dump_one(struct net_device *netdev,
struct sk_buff *rsp,

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
@@ -233,7 +233,7 @@ page_pool_nl_fill(struct sk_buff *rsp, const
struct page_pool *pool,
 		goto err_cancel;

 	napi_id = pool->p.napi ? READ_ONCE(pool->p.napi->napi_id) : 0;
-	if (napi_id >= MIN_NAPI_ID &&
+	if (napi_id_valid(napi_id) &&
 	    nla_put_uint(rsp, NETDEV_A_PAGE_POOL_NAPI_ID, napi_id))
 		goto err_cancel;

diff --git a/net/core/sock.c b/net/core/sock.c
index eae2ae70a2e0..84dbdc78dea3 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2041,7 +2041,7 @@ int sk_getsockopt(struct sock *sk, int level, int optname,
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

base-commit: 39f54262ba499d862420a97719d2f0eea0cbd394
-- 
2.43.0

