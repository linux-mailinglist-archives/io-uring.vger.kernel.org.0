Return-Path: <io-uring+bounces-13969-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id gAYkD0AeUmqpMAMAu9opvQ
	(envelope-from <io-uring+bounces-13969-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 12:43:12 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D93F741462
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 12:43:11 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KRcjGPBN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13969-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13969-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 966AE3034B76
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 10:41:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D45E73B7B84;
	Sat, 11 Jul 2026 10:41:09 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341233BBA0B
	for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 10:41:08 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783766469; cv=none; b=SrsNmjhNXWDU/DHeaafjPPDLLx0rHd1xw0aVpuHP/4pW2aHJiwNs85hnw6epZ/XnkJJev3r+af/UwaX0h/JMBKQqXUjABA1Mn0fdwRhLR0w5ibIYZHvlzDwVMj/7mTaRgAkkp4qxgiMlDAyXZ20WWqGJo8oa46Ypse3KGFJCGkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783766469; c=relaxed/simple;
	bh=xRgBAtDHyHxqdhOqR4G/l4hvNv+gzIXh7nRx0WknYxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LIwtH+N+4GLlioUG5Cg46lPDyqvkUMMvYijkCmQf2bLdTn1dhdoKNfLQ59A7nV6fjFc4GQAXe0ZQk9leWFLsFNYrRbVJPl8v2VhgSiVrXzsKVtFLTtfZkpx9Ix+4j1VMhfmQSwy4M2sHnz8Y9yed3AkCy5JkLx6MXzdz96QT0fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KRcjGPBN; arc=none smtp.client-ip=209.85.218.46
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c160420289bso191748466b.0
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 03:41:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783766467; x=1784371267; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=40IOAR9jl4nV6USx07Om+oEnXzAVvYxe6ms1YH9xtlE=;
        b=KRcjGPBNNQPRIbBq50rY0XVUSgEhmyMLiFM57o7BHl5jnCxi8+FdP/R/zRuszhdhLq
         FcNtqmlWcvuLgOxw4GoYsebYJ3W+p7NmkcC6XI21afUqYkcfyT+/yM6VJwuUDBN/Da0Y
         IhauYuSZ0FeEiEWW6XjA3eLvlzP1NAG9XJBILAn9cS+2hVeQwvVj9P9ciqBnOCOdG/E5
         wWmEeImruBlQ5vnYUC/Aattg3x3KDh4ZNYxrtERuurZeqTpzUdwUJYD4oyxu0ObA2R9h
         FN1HSrCDFdxzXwv201vz+4EjHXybSxAhZPWR1mOMwbVQHtXKlEDcsfGotiZcyrmwgCFV
         1Lug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783766467; x=1784371267;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=40IOAR9jl4nV6USx07Om+oEnXzAVvYxe6ms1YH9xtlE=;
        b=PPGbUOM/vAz3FV0vysS547lLz0oBAMg8ubxuxCL0nCLFo7zAQDbDrSy+9Dc4KRtfqH
         OjVfdepH9jARlUiTqSVZ9Oxd+X6A/3iqT1FOmmSHdVbJTcDIcpTVZ+7pZrO15/enUF5V
         ygJOrJ1uk2ZTNr8JMgpwe2kFzDgCgxVSjMd5JS1xxx1eCZtFZjnCZzNLPjlag8QvLfkj
         DsgBzb9A8NCrC154flCFkNI05g3hij3t6JkLxGypUj5zzD9kT0I+0hyg9XB73FCIY50S
         Rhye/9A61JAe19xCIrF33oz3lkHKPaZ5sJs6Ggkih17tWUOY730IjcE/3pHNHxdVKEku
         nk2w==
X-Gm-Message-State: AOJu0YybxSNUFppxFdhL2B4JbfYqPFHvLQvxMs35LegL/bVt/6WL7PRj
	WhvKF1F+voTekTamTV7baWTtchnJZRw12ZT0PQCr697KolYI6uFx5z/Zhq9oLg==
X-Gm-Gg: AfdE7cmGT1hXNkYWVonwzwj6yGv8BELESGH2i5hEbGN+Wm9L2WhRUXZR4cEuTVVBOI/
	htcNWpqx8fYlE1AEfIy7H/qk/2bkgkovh4s6tkegOa0hM8H48yICtv/C6GNvBS25YZlwPRKhC0n
	ajVYXkRVQPsxWzKmazj30Nmv+7YTxhbni6K7IwRE1seJziPvUR6A4/qw5u7FAbkx6ZBp48MJh89
	CfWLqsVCdWSBA1tW05NLlSi9q1StA3FKDHFRCtC0oH7ka3UND5FKBzp6PS9tZiFrB70m0eJInyu
	OdB1Sm1Rd43i+kmcvhUKTdF+n9G+S8dTIpqhup2mAwCIxkgT0MXR7kYuu4rzh64P1xLVwMpiMnc
	tcHJF2Ow8AROoPJwR0ShJ1hqgyCutQWxfZMFe0Vk7TCR+u1QiIs/hbKiPzVFpRFBzvlRhyM7QPA
	0u9Evv8ALIjVJ7O4D0ettFRhDGcTyZHxuzgfgAN5qm2TTeV5ESxcwWR7xfC2IcyA+mdCos3CNYq
	7APMZ7mG53Qc12ofYvQpcMvwFd0P/aj+WLUggwjn0ER6CGFEg==
X-Received: by 2002:a17:907:cf87:b0:c12:51d9:bb78 with SMTP id a640c23a62f3a-c161e9b313cmr100622266b.28.1783766466751;
        Sat, 11 Jul 2026 03:41:06 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-222-132.dab.02.net. [82.132.222.132])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c15d5de95e6sm483041566b.39.2026.07.11.03.41.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 03:41:05 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH review-only 12/17] io_uring/zcrx: move freelist lock to struct zcrx
Date: Sat, 11 Jul 2026 11:40:05 +0100
Message-ID: <ed0885e4de57871906c039e2c8e76842e9eac4a4.1783616211.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1783616211.git.asml.silence@gmail.com>
References: <cover.1783616211.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13969-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:io-uring@vger.kernel.org,m:asml.silence@gmail.com,m:netdev@vger.kernel.org,m:asmlsilence@gmail.com,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	TO_DN_NONE(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 9D93F741462

freelist_lock, which protects slow path allocations, is currently stored
in struct io_zcrx_area. Once we add support for multiple queues, we'll
need a lock in the zcrx ctx, move it there.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 14 +++++++-------
 io_uring/zcrx.h |  2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 40cabf4384d1..81520bda230d 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -544,7 +544,6 @@ static int __zcrx_create_area(struct io_zcrx_ifq *ifq,
 	/* we're only supporting one area per ifq for now */
 	area->area_id = 0;
 	area_reg->rq_area_token = zcrx_area_id_to_token(area->area_id);
-	spin_lock_init(&area->freelist_lock);
 	*res_area = area;
 	return 0;
 err:
@@ -585,6 +584,7 @@ static struct io_zcrx_ifq *io_zcrx_ifq_alloc(struct io_ring_ctx *ctx)
 	ifq->if_rxq = -1;
 	spin_lock_init(&ifq->ctx_lock);
 	spin_lock_init(&ifq->rq.lock);
+	spin_lock_init(&ifq->alloc_lock);
 	mutex_init(&ifq->pp_lock);
 	refcount_set(&ifq->refs, 1);
 	refcount_set(&ifq->user_refs, 1);
@@ -659,8 +659,9 @@ static void io_put_zcrx_ifq(struct io_zcrx_ifq *ifq)
 static void io_zcrx_return_niov_freelist(struct net_iov *niov)
 {
 	struct io_zcrx_area *area = io_zcrx_iov_to_area(niov);
+	struct io_zcrx_ifq *ifq = area->ifq;
 
-	guard(spinlock_bh)(&area->freelist_lock);
+	guard(spinlock_bh)(&ifq->alloc_lock);
 	if (WARN_ON_ONCE(area->free_count >= area->nia.num_niovs))
 		return;
 	area->freelist[area->free_count++] = net_iov_idx(niov);
@@ -670,7 +671,7 @@ static struct net_iov *zcrx_get_free_niov(struct io_zcrx_area *area)
 {
 	unsigned niov_idx;
 
-	lockdep_assert_held(&area->freelist_lock);
+	lockdep_assert_held(&area->ifq->alloc_lock);
 
 	if (unlikely(!area->free_count))
 		return NULL;
@@ -1262,7 +1263,7 @@ static unsigned io_zcrx_refill_slow(struct page_pool *pp, struct io_zcrx_ifq *if
 	struct io_zcrx_area *area = ifq->area;
 	unsigned allocated = 0;
 
-	guard(spinlock_bh)(&area->freelist_lock);
+	guard(spinlock_bh)(&ifq->alloc_lock);
 
 	for (allocated = 0; allocated < to_alloc; allocated++) {
 		struct net_iov *niov = zcrx_get_free_niov(area);
@@ -1567,14 +1568,13 @@ static bool io_zcrx_queue_cqe(struct io_kiocb *req, struct net_iov *niov,
 
 static struct net_iov *io_alloc_fallback_niov(struct io_zcrx_ifq *ifq)
 {
-	struct io_zcrx_area *area = ifq->area;
 	struct net_iov *niov = NULL;
 
 	if (!ifq->kern_readable)
 		return NULL;
 
-	scoped_guard(spinlock_bh, &area->freelist_lock)
-		niov = zcrx_get_free_niov(area);
+	scoped_guard(spinlock_bh, &ifq->alloc_lock)
+		niov = zcrx_get_free_niov(ifq->area);
 
 	if (niov)
 		page_pool_fragment_netmem(net_iov_to_netmem(niov), 1);
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index 0eb7ea35a9ff..302659669ba4 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -36,7 +36,6 @@ struct io_zcrx_area {
 	u16			area_id;
 
 	/* freelist */
-	spinlock_t		freelist_lock ____cacheline_aligned_in_smp;
 	u32			free_count;
 	u32			*freelist;
 
@@ -65,6 +64,7 @@ struct io_zcrx_ifq {
 	bool				kern_readable;
 
 	struct zcrx_rq			rq ____cacheline_aligned_in_smp;
+	spinlock_t			alloc_lock ____cacheline_aligned_in_smp;
 
 	u32				if_rxq;
 	struct device			*dev;
-- 
2.54.0


