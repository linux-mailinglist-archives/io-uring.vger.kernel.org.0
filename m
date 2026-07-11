Return-Path: <io-uring+bounces-13952-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id TJr0KI8LUmoULgMAu9opvQ
	(envelope-from <io-uring+bounces-13952-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 11:23:27 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 134087410A2
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 11:23:27 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=l3pjmX9q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13952-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13952-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id F331D3034337
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 09:22:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE036386C2A;
	Sat, 11 Jul 2026 09:22:59 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26EC388E5B
	for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 09:22:57 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783761779; cv=none; b=jxnWj/XOZiS8O3xPutZyTrqkMY2wIcf0zWjk4u5ibbRtCHcbUXr5KFFkEC4oSEV82vDOiGspsTbsRNxeKMXyXY+/MFKauUXWFxT/D6lABuawUPe9eInfRyvYdrbtiOD3obRX6w/m4365Tx3ReS/A7aIOw8LoSUo1LK9ykV/q/xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783761779; c=relaxed/simple;
	bh=Jda4QkbNThkx+4lg1Zv13xaozFgwbAW6ZQxqsFrQi90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uHR5pwl7kTp0XwYFeKdVB7TQdY8aUxG9bv7T4zak4FHJ6qLZRuHouwPPbsH/2FpRoL9OwyziliHdSiRyPJGaE2vi/cDrp09+KEa7babqw2YLn/omcJRjNovQ1DHuvQcMqcWJOubQ9mZE3SnjRB9mx8ZiJ1bM5rglxn/voLQ3nNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l3pjmX9q; arc=none smtp.client-ip=209.85.218.47
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c15f6d667bcso214858866b.2
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 02:22:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783761776; x=1784366576; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ok0G6w94YSQ9QCAQ1qFbJtTqWiCrPlJelIngdYo3gm0=;
        b=l3pjmX9qV8kxgYSMrPlTP0Deck/MabwHa14mbuHaZZPQmzjv+ke677DoUqg3015lEj
         Xz2c2DYBAli8DZ7fRffn37+0oKATxw+ay3PyZ+eDLYX3+LrLmiJO9gyCVXjnfNFmQg4P
         2g1W3rPqRLbAcLE5QM/xdB+kFxawk2ug2K1LXlObrKE2Imp1jUBpBwGtZwHQeKQElVR+
         BywJwlEHHc25/WQmMqtDAf3Ldz7RSu89PxLTsjyavowqSbMuG0htrTZDtrrmfXv7XSmk
         imKJbE7SxCorO39De4Rl5SmD+pNHFJex9hCr03o5EbKl/UlLSHM+By9S5RXMfXpuSG3H
         JDIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783761776; x=1784366576;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ok0G6w94YSQ9QCAQ1qFbJtTqWiCrPlJelIngdYo3gm0=;
        b=oz6q9yEeJAyZtXpts8qnMqkX0nJZIt/CY6Mrku5IvB1M/SPr1yz8L/eKt4J3oC98Cp
         RZE/8ryJcY77aSP3dsxcRQZArLnnqsGy/2udRTHBbslhYMJW43bZcfax1ZtT2qvnMbVu
         RoxY0+YQmxXz/ANLNAyGzUNNqlGcgugaVi/bmNEpe4DnsILkwuc+Aaw/z6/7s8EioJvl
         5R3vG28jJzq1l8XJ74SdJ+dmEXHGonN9K8ZFKYi5qfBW19r6z51R+9g/fGIMGPyL9gmX
         DxipmKMMAJqvRTP1jdKn+nfgSGSCy7hVrlPh8xh8FoyjDX3bNiVjON8mx0lIcM22N+jr
         NPnA==
X-Gm-Message-State: AOJu0YyDVdBMB0f2m/FAr0g6X+OxMe2bffviLGiTJ+wIGxPS8spCFRJg
	44ZR3tnTVDwJ0w4N92q6lt5q8aNhw+Ft5MapwcPm09/rPjURecaEo/y0
X-Gm-Gg: AfdE7cmjS56LAn91yY8SKWEM4DODpbB5BpOPqmQsaGo5Ko6uvvC+7Flv+7Wtpc5a8uO
	786bct8TM248OIci7SqA/Q27cgvzZ4S5VXDvzYlb7JTWhW5ZwANPgu1p0QY9UfksTYJaU0kh/TW
	BhFE2Ydcp+cWO4IESNjKokcV7MstfgFLe4znQ7nT3UTJ6k5vnUpZOpqcEbFOelZenXB78Qcc/dS
	oPjScB029AVPhdV3qELyCeeBgPLpc/4eFxDQe9pLjwsImN5BmVK9m+vo2p3DPBHVKH/KKi5ziLF
	lwEevQ32ZxVBfjw/Ky80mAiJWZZ9TlRUMt60xpGoLak0kgSQg/24eGoPLCQlqJxH8JALaROI+6b
	p0jn2TjQPgvuVCjJY1lyPUBdkGqC39EPbq+/ATzEDcRwIS/gD6xs/t2mqPaMWkRWJpuFc6HCDTt
	4BDzVf+TDuhy/Y3jRURv3N3GdNd52UMwSk9iNeN1MJp8ANG+z6oudDjOLGjlBjcBNQ5ksIBA0tx
	cDo3OGm1kxO4eCVYulSpPdexlT73J1rtvOkpBHA5ZGnwL8=
X-Received: by 2002:a17:907:7206:b0:c15:bfd4:d422 with SMTP id a640c23a62f3a-c161e8fa2d7mr86419966b.25.1783761775527;
        Sat, 11 Jul 2026 02:22:55 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-221-54.dab.02.net. [82.132.221.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c15d3859f69sm517493566b.27.2026.07.11.02.22.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 02:22:54 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	netdev@vger.kernel.org
Cc: io-uring@vger.kernel.org,
	asml.silence@gmail.com
Subject: [RFC 6/9] io_uring/zcrx: implement skb stealing
Date: Sat, 11 Jul 2026 10:22:16 +0100
Message-ID: <633a28643c100a38345441e134dc0460fcf7d920.1783619193.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1783619193.git.asml.silence@gmail.com>
References: <cover.1783619193.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-13952-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:davem@davemloft.net,m:edumazet@google.com,m:kuba@kernel.org,m:pabeni@redhat.com,m:horms@kernel.org,m:netdev@vger.kernel.org,m:io-uring@vger.kernel.org,m:asml.silence@gmail.com,m:asmlsilence@gmail.com,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 134087410A2

One of major hotspots for zcrx is handing buffers to the user space and
getting them back from the refill queue. For each niov we keep an atomic
reference counter, which is incremented from the syscall path when we
give the buffer to the user space, and decremented from NAPI when
processing the refill queue on page pool allocation. When user space and
NAPI run on different CPUs it causes cache bouncing.

Instead of bumping the ref counter for each frag on receive, try to steal
the entire skb and send it to NAPI for zcrx to process it, so that put
and gets happen on the same CPU. We trade a bunch of atomics with cache
bouncing with a single ptr_ring produce / consume. It achieves same goals
and replaces skb_attempt_defer_free() but also improves locality for zcrx
specific accounting.

It still uses atomics for "user" counting in this patch, but now it's
accessed by a single CPU only when the optimisation works. It also
improves temporal locality as well as we delay grabbing reference,
however we need to make sure that skbs are processed before the
corresponding RQEs.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 112 +++++++++++++++++++++++++++++++++++++++++-------
 io_uring/zcrx.h |   3 ++
 2 files changed, 99 insertions(+), 16 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 80aa68ab9968..80a26b5798d3 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -40,6 +40,8 @@
 
 #define IO_DMA_ATTR (DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDERING)
 
+static void zcrx_release_skbs(struct io_zcrx_ifq *ifq);
+
 static inline u64 zcrx_area_id_to_token(u32 area_id)
 {
 	return (u64)area_id << IORING_ZCRX_AREA_SHIFT;
@@ -677,6 +679,9 @@ static void io_zcrx_ifq_free(struct io_zcrx_ifq *ifq)
 		return;
 	if (WARN_ON_ONCE(ifq->master_ctx))
 		return;
+	if (WARN_ON_ONCE(!__ptr_ring_empty(&ifq->skb_ring)))
+		return;
+
 
 	for (i = 0; i < ifq->nr_areas; i++)
 		io_zcrx_free_area(ifq, ifq->areas[i]);
@@ -685,6 +690,7 @@ static void io_zcrx_ifq_free(struct io_zcrx_ifq *ifq)
 	if (ifq->dev)
 		put_device(ifq->dev);
 
+	ptr_ring_cleanup(&ifq->skb_ring, NULL);
 	io_free_rbuf_ring(ifq);
 	free_uid(ifq->user);
 	mutex_destroy(&ifq->pp_lock);
@@ -755,6 +761,9 @@ static void io_zcrx_scrub(struct io_zcrx_ifq *ifq)
 {
 	int i;
 
+	scoped_guard(spinlock_bh, &ifq->rq.lock)
+		zcrx_release_skbs(ifq);
+
 	guard(mutex)(&ifq->pp_lock);
 	for (i = 0; i < ifq->nr_areas; i++)
 		io_zcrx_scrub_area(ifq, ifq->areas[i]);
@@ -1039,6 +1048,9 @@ int io_register_zcrx(struct io_ring_ctx *ctx,
 	ifq = io_zcrx_ifq_alloc(ctx);
 	if (!ifq)
 		return -ENOMEM;
+	ret = ptr_ring_init(&ifq->skb_ring, 1024, GFP_KERNEL_ACCOUNT);
+	if (ret < 0)
+		goto ifq_free;
 
 	ifq->notif_data = notif.user_data;
 	ifq->allowed_notif_mask = notif.type_mask;
@@ -1188,9 +1200,10 @@ static inline u32 __zcrx_rq_entries(struct zcrx_rq *rq)
 	return min(entries, rq->nr_entries);
 }
 
-static inline u32 zcrx_rq_entries(struct zcrx_rq *rq)
+static inline u32 zcrx_rq_entries(struct zcrx_rq *rq, struct io_zcrx_ifq *ifq)
 {
 	rq->cached_tail = smp_load_acquire(&rq->ring->tail);
+	zcrx_release_skbs(ifq);
 	return __zcrx_rq_entries(rq);
 }
 
@@ -1209,6 +1222,7 @@ static inline void zcrx_rq_iter_init(struct zcrx_rq_iter *it,
 }
 
 static inline bool zcrx_rq_iter_next(struct zcrx_rq_iter *it,
+				     struct io_zcrx_ifq *ifq,
 				     struct zcrx_rq *rq,
 				     struct io_uring_zcrx_rqe **rqe)
 {
@@ -1217,6 +1231,14 @@ static inline bool zcrx_rq_iter_next(struct zcrx_rq_iter *it,
 		if (it->flushed)
 			return false;
 		rq->cached_tail = smp_load_acquire(&rq->ring->tail);
+
+		/*
+		 * skbs carry user niov references from the syscall path,
+		 * process them first before refilling will try to put
+		 * them back down.
+		 */
+		zcrx_release_skbs(ifq);
+
 		it->rqes_left = min_t(unsigned, __zcrx_rq_entries(rq),
 				      ZCRX_REFILL_CAP);
 		it->flushed = true;
@@ -1270,6 +1292,42 @@ static bool zcrx_put_refill_niov(struct net_iov *niov, struct page_pool *pp,
 	return true;
 }
 
+static void zcrx_user_ref_frags(struct io_zcrx_ifq *ifq, struct sk_buff *skb,
+				unsigned start, unsigned nr)
+{
+	struct skb_shared_info *shi = skb_shinfo(skb);
+	unsigned i;
+
+	nr = min_t(unsigned, nr, shi->nr_frags);
+	for (i = start; i < nr; i++) {
+		const skb_frag_t *frag = &shi->frags[i];
+		struct net_iov *niov = netmem_to_net_iov(frag->netmem);
+
+		/*
+		 * Prevent it from being recycled while user is accessing it.
+		 * It has to be done before grabbing a user reference.
+		 */
+		page_pool_ref_netmem(net_iov_to_netmem(niov));
+		io_zcrx_get_niov_uref(niov);
+	}
+}
+
+static void zcrx_release_skbs(struct io_zcrx_ifq *ifq)
+{
+	while (1) {
+		struct sk_buff *skb = __ptr_ring_consume(&ifq->skb_ring);
+
+		if (!skb)
+			break;
+
+		zcrx_user_ref_frags(ifq, skb, 0, -1U);
+		if (skb->fclone != SKB_FCLONE_UNAVAILABLE)
+			__kfree_skb(skb);
+		else
+			__napi_kfree_skb(skb, SKB_CONSUMED);
+	}
+}
+
 static unsigned io_zcrx_ring_refill(struct page_pool *pp,
 				    struct io_zcrx_ifq *ifq,
 				    netmem_ref *netmems, unsigned to_alloc)
@@ -1285,7 +1343,7 @@ static unsigned io_zcrx_ring_refill(struct page_pool *pp,
 
 	zcrx_rq_iter_init(&it, rq);
 
-	while (allocated < to_alloc - 1 && zcrx_rq_iter_next(&it, rq, &rqe)) {
+	while (allocated < to_alloc - 1 && zcrx_rq_iter_next(&it, ifq, rq, &rqe)) {
 		struct net_iov *next_niov;
 
 		if (!io_parse_rqe(rqe, ifq, &next_niov))
@@ -1489,7 +1547,7 @@ static unsigned zcrx_parse_rq(netmem_ref *netmem_array, unsigned nr,
 	unsigned int mask = rq->nr_entries - 1;
 	unsigned int i;
 
-	nr = min(nr, zcrx_rq_entries(rq));
+	nr = min(nr, zcrx_rq_entries(rq, zcrx));
 	for (i = 0; i < nr; i++) {
 		struct io_uring_zcrx_rqe *rqe = zcrx_next_rqe(rq, mask);
 		struct net_iov *niov;
@@ -1814,7 +1872,7 @@ static int zcrx_recv_niov(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 }
 
 static int __zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
-			   unsigned int offset, size_t len)
+			   unsigned int offset, size_t len, bool frag_skb)
 {
 	struct io_zcrx_args *args = desc->arg.data;
 	struct io_zcrx_ifq *ifq = args->ifq;
@@ -1822,6 +1880,8 @@ static int __zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 	struct sk_buff *frag_iter;
 	unsigned start, start_off = offset;
 	struct skb_shared_info *shi;
+	unsigned first_frag;
+	bool can_steal;
 	int i, ret = 0;
 
 	len = min_t(size_t, len, desc->count);
@@ -1868,6 +1928,8 @@ static int __zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 		start = frag_end;
 	}
 
+	first_frag = i;
+
 	for (; i < shi->nr_frags; i++) {
 		const skb_frag_t *frag = &shi->frags[i];
 		unsigned frag_end = start + skb_frag_size(frag);
@@ -1881,7 +1943,7 @@ static int __zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 		if (unlikely(!skb_frag_is_net_iov(frag))) {
 			ret = io_zcrx_copy_frag(req, ifq, frag, frag_off, copy);
 			if (ret < 0)
-				goto out;
+				break;
 		} else {
 			struct net_iov *niov = netmem_to_net_iov(frag->netmem);
 
@@ -1889,20 +1951,38 @@ static int __zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 					     frag_off + skb_frag_off(frag),
 					     copy);
 			if (ret < 0)
-				goto out;
-			/*
-			 * Prevent it from being recycled while user is accessing it.
-			 * It has to be done before grabbing a user reference.
-			 */
-			page_pool_ref_netmem(net_iov_to_netmem(niov));
-			io_zcrx_get_niov_uref(niov);
+				break;
 		}
 
 		offset += ret;
 		len -= ret;
-		if (len == 0 || ret != copy)
-			goto out;
+		if (len == 0 || ret != copy) {
+			i++;
+			len = 0;
+			break;
+		}
+	}
+
+	if (start != offset || ret < 0) {
+		if (!skb_frags_readable(skb))
+			zcrx_user_ref_frags(ifq, skb, first_frag, i);
+		goto out;
+	}
+
+	can_steal = !skb_frags_readable(skb) && !skb_has_frag_list(skb) &&
+		    start_off == 0 && !frag_skb;
+
+	if (can_steal && !__ptr_ring_full(&ifq->skb_ring) &&
+	    tcp_read_sock_steal_skb(desc, skb, args->sock->sk)) {
+		ret = ptr_ring_produce(&ifq->skb_ring, skb);
+		if (ret) {
+			zcrx_user_ref_frags(ifq, skb, first_frag, i);
+			__kfree_skb(skb);
+		}
+		goto out;
 	}
+	if (!skb_frags_readable(skb))
+		zcrx_user_ref_frags(ifq, skb, first_frag, i);
 
 	skb_walk_frags(skb, frag_iter) {
 		unsigned frag_end;
@@ -1915,7 +1995,7 @@ static int __zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 			unsigned copy = min(frag_end - offset, len);
 			unsigned frag_off = offset - start;
 
-			ret = __zcrx_recv_skb(desc, frag_iter, frag_off, copy);
+			ret = __zcrx_recv_skb(desc, frag_iter, frag_off, copy, true);
 			if (ret < 0)
 				goto out;
 
@@ -1939,7 +2019,7 @@ int io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 {
 	int ret;
 
-	ret = __zcrx_recv_skb(desc, skb, offset, len);
+	ret = __zcrx_recv_skb(desc, skb, offset, len, false);
 	desc->count -= max(0, ret);
 	return ret;
 }
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index 05598f08eda0..7fc12e53c8a1 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -5,6 +5,7 @@
 #include <linux/io_uring_types.h>
 #include <linux/dma-buf.h>
 #include <linux/socket.h>
+#include <linux/ptr_ring.h>
 #include <net/page_pool/types.h>
 #include <net/net_trackers.h>
 
@@ -69,6 +70,8 @@ struct io_zcrx_ifq {
 	struct zcrx_rq			rq ____cacheline_aligned_in_smp;
 	spinlock_t			alloc_lock ____cacheline_aligned_in_smp;
 
+	struct ptr_ring			skb_ring;
+
 	u32				if_rxq;
 	struct device			*dev;
 	struct net_device		*netdev;
-- 
2.54.0


