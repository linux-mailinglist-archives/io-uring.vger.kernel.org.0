Return-Path: <io-uring+bounces-12791-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eLhCGQE4wWm7RQQAu9opvQ
	(envelope-from <io-uring+bounces-12791-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 13:54:25 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 05D412F245F
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 13:54:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 35D8330480C4
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 12:44:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A07813AA505;
	Mon, 23 Mar 2026 12:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B8ACGLyR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B10D3AA501
	for <io-uring@vger.kernel.org>; Mon, 23 Mar 2026 12:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774269855; cv=none; b=nmOvwTg3WmQZz06Eezq3uDqBBR9BGk7j3juiaU2AEqUs5anu7zjF8ZaCFljQk2Sc7cHenAhpG3IlsYHmxWp72iKOp66phNY2dsGAFZ9mYKRGSoIVsWAznYM5TqfaQy0Ws62kNAwPwaQeBMQIlGbPw9EUi969kFoJUSWvoK7nReA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774269855; c=relaxed/simple;
	bh=iecoRfimUPE6vEewGiWBzcAjEEjZKMKMijJazI6fRnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QMJwL9dsxLeZkGxW1ShWOk5fNLaaOXIOk93IivtvbSQ4oQCsTlL+PPtGQ9adxWPufaQj8TxqLfrZ+E4sDwsQ5uDGnZZ5OaYXlRLwJrN0L0D2E0HVvBHo9m8wfkN6ePYNfBk7IzcFECL9pqNhJxHPqGqZ28PHWbeLcaBghLGb4Kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B8ACGLyR; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-439d8dc4ae4so3632542f8f.2
        for <io-uring@vger.kernel.org>; Mon, 23 Mar 2026 05:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774269852; x=1774874652; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7Gxx939Ybhx2y1IQUqnzH7FIFuyiXoWdpY5H8gvhFMs=;
        b=B8ACGLyR5OLjqYMmKXi8zp3j4HRLv1vDXz1V1+rkO4Nb8IIAe48hFopqhuTkSWW8PW
         LMnZTfkVlk7q13zkuxije7JffXbRzs9qdnPkXqhpLdKe1MproIfP9bi9qE4Q3j8hKZsg
         nfdOifdqWmQSEZc1O7pdm765cp3W+tkrfv42Pd885a/ED+ylWcmBxl82BoRGDHRmpxyH
         u2vQlPhzCrpXsoj7EWgWR7jgv1Ap3cPtjhiqifQ6EOYpZpm3xGY+oyk1mpZtXBtrFiy2
         wiF6XT/yrPwbeZbzXFLcP6bcot9M88PMOuxnGHjJh91eVVctGpCpMjFmQOE+GNPFeCdO
         G9Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774269852; x=1774874652;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7Gxx939Ybhx2y1IQUqnzH7FIFuyiXoWdpY5H8gvhFMs=;
        b=W5Ae8bp0k37VXmmBZOgHMFEkia9ez9zDcnJnKz0TodytZeZseWbYj027Id1leLUNUL
         uAWISZKlKrA+KnwUegH68QXp3gGiUE0rHpf94AEC8Zc9GePKFtzB3dJDQI3ILZ6vKjVb
         EcaSL9sytzQmSf5NW00fo0gWyMSjWUGPLecwYYdCErXn/OnLdrbSQpl35EujbH7VKm11
         HXEcuwpgRrcMDzqrc391Rhddop4ZhQHY+vf9iZxWBUoS/UhXFUK3dNpwe0inN0Xe8uCs
         C71NO3xgbwrJ5k0Cv/sdlxJBEp5nVBq/dDhMDT+XZMC1sX/axQShI98kiqBn1yoAjRf1
         bCAw==
X-Gm-Message-State: AOJu0YwvvDWQ9mIFEzI1UdkF9BRoxF6oHA6MnUC5aJrBfUZBzO72Qscy
	R36443fI4bdvzptLe53dwewccHVbR0HU6LE9hQCdCrne5onetWptSnfqfWEDWg==
X-Gm-Gg: ATEYQzyQJj736za9OlZrk8qrO8e+GKy72PzCQh7F4EnDiovq8rNq8M0b64l5RAPe+hO
	7mGGKQOAOeWsIXMl+PKar/zb4r7cvcMH8oG2unwvN+2WiyqF6TgwNyUqrx6S8UT6mCD3kSuVgqm
	85mVCmsoegtDw8NPNORH25eeGBxW0nXRHuZ2JpTsY3fZTNJHLdckjSdu23a7ncaNNBHb+kduAzg
	BRRdPu//bJQGeZH9koJLZK/B/uMYROkCf0+s5iRFn9PkL4mFRRFg3qDBybJM9u4fHh6Wby/D6bV
	3t085SZIH0sSBtWALh//zz4F0zwke80n/5UJ2xEjZsNRr4emNL2UdvUm8+/2SnXRIIf3/ZeXM0x
	CDNclfKTlRYZ4bicgcIyamjK4nG6xoPC5LP3FyAkArx23ePraaC4zidBHuNFVHMFPG396oZr0eK
	yrwOJ6KL+LQpaYcvFgasvEeDMG8A7bkDTh1IbEtT5v3eXKIYEap2GOrOfLAfNl/1jjtoGH6iHIY
	L8VCa9trw==
X-Received: by 2002:a5d:588e:0:b0:43b:5767:8f2a with SMTP id ffacd0b85a97d-43b6423a596mr18808751f8f.22.1774269851325;
        Mon, 23 Mar 2026 05:44:11 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:6969])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b6425eeb4sm25520861f8f.0.2026.03.23.05.44.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 05:44:10 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH io_uring-7.1 07/16] io_uring/zcrx: add a struct for refill queue
Date: Mon, 23 Mar 2026 12:43:56 +0000
Message-ID: <4ce200da1ff0309c377293b949200f95f80be9ae.1774261953.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774261953.git.asml.silence@gmail.com>
References: <cover.1774261953.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-12791-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk,vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 05D412F245F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Add a new structure that keeps the refill queue state. It's cleaner and
will be useful once we introduce multiple refill queues.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 54 +++++++++++++++++++++++++------------------------
 io_uring/zcrx.h | 14 ++++++++-----
 2 files changed, 37 insertions(+), 31 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index f10df7750740..0a5f8eab92c3 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -389,8 +389,8 @@ static int io_allocate_rbuf_ring(struct io_ring_ctx *ctx,
 		return ret;
 
 	ptr = io_region_get_ptr(&ifq->rq_region);
-	ifq->rq_ring = (struct io_uring *)ptr;
-	ifq->rqes = (struct io_uring_zcrx_rqe *)(ptr + off);
+	ifq->rq.ring = (struct io_uring *)ptr;
+	ifq->rq.rqes = (struct io_uring_zcrx_rqe *)(ptr + off);
 
 	return 0;
 }
@@ -398,8 +398,8 @@ static int io_allocate_rbuf_ring(struct io_ring_ctx *ctx,
 static void io_free_rbuf_ring(struct io_zcrx_ifq *ifq)
 {
 	io_free_region(ifq->user, &ifq->rq_region);
-	ifq->rq_ring = NULL;
-	ifq->rqes = NULL;
+	ifq->rq.ring = NULL;
+	ifq->rq.rqes = NULL;
 }
 
 static void io_zcrx_free_area(struct io_zcrx_ifq *ifq,
@@ -519,7 +519,7 @@ static struct io_zcrx_ifq *io_zcrx_ifq_alloc(struct io_ring_ctx *ctx)
 		return NULL;
 
 	ifq->if_rxq = -1;
-	spin_lock_init(&ifq->rq_lock);
+	spin_lock_init(&ifq->rq.lock);
 	mutex_init(&ifq->pp_lock);
 	refcount_set(&ifq->refs, 1);
 	refcount_set(&ifq->user_refs, 1);
@@ -855,7 +855,7 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 		mmgrab(ctx->mm_account);
 		ifq->mm_account = ctx->mm_account;
 	}
-	ifq->rq_entries = reg.rq_entries;
+	ifq->rq.nr_entries = reg.rq_entries;
 
 	scoped_guard(mutex, &ctx->mmap_lock) {
 		/* preallocate id */
@@ -969,20 +969,19 @@ void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx)
 	xa_destroy(&ctx->zcrx_ctxs);
 }
 
-static inline u32 io_zcrx_rqring_entries(struct io_zcrx_ifq *ifq)
+static inline u32 zcrx_rq_entries(struct zcrx_rq *rq)
 {
 	u32 entries;
 
-	entries = smp_load_acquire(&ifq->rq_ring->tail) - ifq->cached_rq_head;
-	return min(entries, ifq->rq_entries);
+	entries = smp_load_acquire(&rq->ring->tail) - rq->cached_head;
+	return min(entries, rq->nr_entries);
 }
 
-static struct io_uring_zcrx_rqe *io_zcrx_get_rqe(struct io_zcrx_ifq *ifq,
-						 unsigned mask)
+static struct io_uring_zcrx_rqe *zcrx_next_rqe(struct zcrx_rq *rq, unsigned mask)
 {
-	unsigned int idx = ifq->cached_rq_head++ & mask;
+	unsigned int idx = rq->cached_head++ & mask;
 
-	return &ifq->rqes[idx];
+	return &rq->rqes[idx];
 }
 
 static inline bool io_parse_rqe(struct io_uring_zcrx_rqe *rqe,
@@ -1011,18 +1010,19 @@ static inline bool io_parse_rqe(struct io_uring_zcrx_rqe *rqe,
 static void io_zcrx_ring_refill(struct page_pool *pp,
 				struct io_zcrx_ifq *ifq)
 {
-	unsigned int mask = ifq->rq_entries - 1;
+	struct zcrx_rq *rq = &ifq->rq;
+	unsigned int mask = rq->nr_entries - 1;
 	unsigned int entries;
 
-	guard(spinlock_bh)(&ifq->rq_lock);
+	guard(spinlock_bh)(&rq->lock);
 
-	entries = io_zcrx_rqring_entries(ifq);
+	entries = zcrx_rq_entries(rq);
 	entries = min_t(unsigned, entries, PP_ALLOC_CACHE_REFILL);
 	if (unlikely(!entries))
 		return;
 
 	do {
-		struct io_uring_zcrx_rqe *rqe = io_zcrx_get_rqe(ifq, mask);
+		struct io_uring_zcrx_rqe *rqe = zcrx_next_rqe(rq, mask);
 		struct net_iov *niov;
 		netmem_ref netmem;
 
@@ -1044,7 +1044,7 @@ static void io_zcrx_ring_refill(struct page_pool *pp,
 		net_mp_netmem_place_in_cache(pp, netmem);
 	} while (--entries);
 
-	smp_store_release(&ifq->rq_ring->head, ifq->cached_rq_head);
+	smp_store_release(&rq->ring->head, rq->cached_head);
 }
 
 static void io_zcrx_refill_slow(struct page_pool *pp, struct io_zcrx_ifq *ifq)
@@ -1157,14 +1157,14 @@ static const struct memory_provider_ops io_uring_pp_zc_ops = {
 };
 
 static unsigned zcrx_parse_rq(netmem_ref *netmem_array, unsigned nr,
-			      struct io_zcrx_ifq *zcrx)
+			      struct io_zcrx_ifq *zcrx, struct zcrx_rq *rq)
 {
-	unsigned int mask = zcrx->rq_entries - 1;
+	unsigned int mask = rq->nr_entries - 1;
 	unsigned int i;
 
-	nr = min(nr, io_zcrx_rqring_entries(zcrx));
+	nr = min(nr, zcrx_rq_entries(rq));
 	for (i = 0; i < nr; i++) {
-		struct io_uring_zcrx_rqe *rqe = io_zcrx_get_rqe(zcrx, mask);
+		struct io_uring_zcrx_rqe *rqe = zcrx_next_rqe(rq, mask);
 		struct net_iov *niov;
 
 		if (!io_parse_rqe(rqe, zcrx, &niov))
@@ -1172,7 +1172,7 @@ static unsigned zcrx_parse_rq(netmem_ref *netmem_array, unsigned nr,
 		netmem_array[i] = net_iov_to_netmem(niov);
 	}
 
-	smp_store_release(&zcrx->rq_ring->head, zcrx->cached_rq_head);
+	smp_store_release(&rq->ring->head, rq->cached_head);
 	return i;
 }
 
@@ -1206,8 +1206,10 @@ static int zcrx_flush_rq(struct io_ring_ctx *ctx, struct io_zcrx_ifq *zcrx,
 		return -EINVAL;
 
 	do {
-		scoped_guard(spinlock_bh, &zcrx->rq_lock) {
-			nr = zcrx_parse_rq(netmems, ZCRX_FLUSH_BATCH, zcrx);
+		struct zcrx_rq *rq = &zcrx->rq;
+
+		scoped_guard(spinlock_bh, &rq->lock) {
+			nr = zcrx_parse_rq(netmems, ZCRX_FLUSH_BATCH, zcrx, rq);
 			zcrx_return_buffers(netmems, nr);
 		}
 
@@ -1216,7 +1218,7 @@ static int zcrx_flush_rq(struct io_ring_ctx *ctx, struct io_zcrx_ifq *zcrx,
 		if (fatal_signal_pending(current))
 			break;
 		cond_resched();
-	} while (nr == ZCRX_FLUSH_BATCH && total < zcrx->rq_entries);
+	} while (nr == ZCRX_FLUSH_BATCH && total < zcrx->rq.nr_entries);
 
 	return 0;
 }
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index 3b2681a1fafd..893cd3708a06 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -41,17 +41,21 @@ struct io_zcrx_area {
 	struct io_zcrx_mem	mem;
 };
 
+struct zcrx_rq {
+	spinlock_t			lock;
+	struct io_uring			*ring;
+	struct io_uring_zcrx_rqe	*rqes;
+	u32				cached_head;
+	u32				nr_entries;
+};
+
 struct io_zcrx_ifq {
 	struct io_zcrx_area		*area;
 	unsigned			niov_shift;
 	struct user_struct		*user;
 	struct mm_struct		*mm_account;
 
-	spinlock_t			rq_lock ____cacheline_aligned_in_smp;
-	struct io_uring			*rq_ring;
-	struct io_uring_zcrx_rqe	*rqes;
-	u32				cached_rq_head;
-	u32				rq_entries;
+	struct zcrx_rq			rq ____cacheline_aligned_in_smp;
 
 	u32				if_rxq;
 	struct device			*dev;
-- 
2.53.0


