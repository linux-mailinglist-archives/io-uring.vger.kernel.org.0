Return-Path: <io-uring+bounces-13970-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id VBGoMusdUmqfMAMAu9opvQ
	(envelope-from <io-uring+bounces-13970-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 12:41:47 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A58D741437
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 12:41:47 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EN9pAWdn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13970-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13970-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id EADA8301F8BA
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 10:41:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FE723BB699;
	Sat, 11 Jul 2026 10:41:12 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAACD3BB684
	for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 10:41:10 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783766472; cv=none; b=AalVj+HEu+cD3g0kXEpyTIzIBulmOpFXS/3Qw83+IwHnaN4mk8e8Tuoco3ePd0WiAHFz5d1UJ0g7aLjO4XT93oy4jlFdrXrft83XulHgMzw98l5U2i0rRk7vxPZ9XGZDWjK9TcskXRDHgPlEyW+8KgEalIglP05NwClVye3NcJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783766472; c=relaxed/simple;
	bh=zkLFA4IwpYfI64hlaKiMkFmdzAb6Z6YKeqUgeL53iUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M/lZJN8k+JFYHOZWFcQ+EF8iUndR9B0Jluyh5CSfzpqyG6mSHOKPuRGTet2OmItpOms9U6XyN9MJce0nMIrm1TBGpyfxY1WcrhPV3aB7o99KY6xrACepwz8VhvZPxetc3ACzfTPaLfpYGa90JTInw0SCfFJfwwnt211XTwc1tSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EN9pAWdn; arc=none smtp.client-ip=209.85.218.41
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c15cb6f5c12so296782966b.0
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 03:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783766469; x=1784371269; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=C0t6RP8+Z0YrUFsaHov/g+ZCVGrpG8FgLG0b0lWoeAw=;
        b=EN9pAWdn+CbcsVxoOxfi7Unrcf0xbDkx5WxFv/Q0smnMBjO/+5Gy46OFGKlgy7rBQv
         TKFyxDsuVtKIN0aKIZ0OI0OIsDEkb3jQY+a3Xahb66wDiGUc3NxGzRyIKy6HfywVy4H/
         L4P+D7HzUJi/4z9Artp093yWY6/JppiFq+5aPtkFjgxkVJq5GjWfNe3gDjmnuSP56mfv
         EnybcJnfWCvo8R2UGiV4zo11ayfeo+7DdO4j+IMUbcKFvtTbfcaReeZpUk0few6j5hEc
         PL5PBe1HAUapfxIrOn1F4xdOKOr8Te+4NDVdOgl59cx7AdzTFj7Bi+qtXKqmcCskNFWx
         c03Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783766469; x=1784371269;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=C0t6RP8+Z0YrUFsaHov/g+ZCVGrpG8FgLG0b0lWoeAw=;
        b=MPqGKn9WfIQR3k+7ETpFdNX3DrMHGN6zYYLf+XHCtzYCnGA5fHk+DP9Z5MRP5gG9Yq
         0pcOQl/CZ77l7x1PFAE1A4jlepwI+7vmCDJSMMe/n2iljZreChy5AhYQJgmvEAxl21gE
         Wr225jgoIGnmKLPpnAdJGnFbyVNjlDMjZlVWMXJs5G7dYfUGQ7UjERMRAUelbHg0C9o2
         fTIoqf4ecx08QcePXkNfZtsaYVLRAxP73RO1UHYSK4vZw5JvScKtj6+F+O6tR/6xkZ+b
         E/9r0VDfF5GGAalOKvU7yOZcv4ZJU4zFbDVQbTiIevEuwaEqGJsG4/1hs+cdfPlUpNNa
         cQiA==
X-Gm-Message-State: AOJu0Yz8G+9/ea98SgMDYgaM+ErUSNEvD2uY+RIbCE9vKLWvhTN82AFX
	T5Lszd2lvrSmD/CKsHOdbiZU5hURpb4z0UDovItyzvxatPa4YByHur//ItH7wA==
X-Gm-Gg: AfdE7cmws1djIQLDUU1BVdiAzNhq9oh3mTFq4I/p7xnBMFIMUe4R+FVLbzG7//F8nT6
	QseXuDkK7nWSFVZy/oWMisBQBQOQQccKimt1c7WX8BXL2aZQNCvdj5GN9WSn0YD+ZPjsOrTwlgH
	abqOAqxRtQY0SaBfkhC1NTNQLblY4lZ7ETHvZ00oz2qiSFW8VUBkn+cH5rp7i3dF55y9wWJ8vG0
	19fg/fAqmSEE9M4Ua+iin0PUbl2zrUCJjTAIUq+BfT7JTbu3Y1HnRwOqG5Enk+l08GTPuQMyalo
	cKI9HfkRvUWb2xc8BSOknYzTHiHr7J3mhvwzklFwhjTf9lqcTyyvLvfzyuIzHIrtr3K8nLiZd26
	4muH7J1+Ji+eE29J9Px3Pu4sGSgcP7dJavGfxSjbdOnMt8L7gOBrRf3/DvXSGoDfkhutPyUebx/
	kHoYJTiOpAn1GBP2i6kOFTtYPDJ4d40xLTQARjMEEA0jv+CLu+fYX4PSVr5OIC6a1te6DX9mBnR
	YmkroAut/cYD58wN4VC3fXGP916hTyhUVOHi/M15spj5LwnAw==
X-Received: by 2002:a17:907:3f03:b0:c16:178b:76cf with SMTP id a640c23a62f3a-c161e930ceamr94967966b.27.1783766469234;
        Sat, 11 Jul 2026 03:41:09 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-222-132.dab.02.net. [82.132.222.132])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c15d5de95e6sm483041566b.39.2026.07.11.03.41.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 03:41:08 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH review-only 13/17] io_uring/zcrx: array of areas
Date: Sat, 11 Jul 2026 11:40:06 +0100
Message-ID: <0f2eab2cccaa14e991af3134c53091c5fd17113b.1783616211.git.asml.silence@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13970-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 8A58D741437

Currently, we have only a one area per zcrx instance, and struct
io_zcrx_ifq stores a single pointer. To prepare for adding more areas,
replace it with an array of areas.

We'll be creating them at runtime, and the array is protected by 3
locks: ->pp_lock, ->alloc_lock and ->rq.lock. It takes all of them when
switching arrays, and readers should hold either of them.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 95 ++++++++++++++++++++++++++++++++++++-------------
 io_uring/zcrx.h |  5 ++-
 2 files changed, 75 insertions(+), 25 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 81520bda230d..474ffc217b0b 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -332,6 +332,14 @@ static void io_zcrx_unmap_area(struct io_zcrx_ifq *ifq,
 	}
 }
 
+static void io_zcrx_unmap_areas(struct io_zcrx_ifq *ifq)
+{
+	unsigned area_idx;
+
+	for (area_idx = 0; area_idx < ifq->nr_areas; area_idx++)
+		io_zcrx_unmap_area(ifq, ifq->areas[area_idx]);
+}
+
 static void zcrx_sync_for_device(struct page_pool *pp, struct io_zcrx_ifq *zcrx,
 				 netmem_ref *netmems, unsigned nr)
 {
@@ -459,13 +467,29 @@ static int io_zcrx_append_area(struct io_zcrx_ifq *ifq,
 				struct io_zcrx_area *area)
 {
 	bool kern_readable = !area->mem.is_dmabuf;
+	struct io_zcrx_area **areas, **old_areas;
+	unsigned old_nr;
 
-	if (WARN_ON_ONCE(ifq->area))
-		return -EINVAL;
 	if (WARN_ON_ONCE(ifq->kern_readable != kern_readable))
 		return -EINVAL;
 
-	ifq->area = area;
+	old_areas = ifq->areas;
+	old_nr = ifq->nr_areas;
+
+	areas = kmalloc_array(old_nr + 1, sizeof(areas[0]),
+			      GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	if (!areas)
+		return -ENOMEM;
+	if (old_areas)
+		memcpy(areas, old_areas, old_nr * sizeof(areas[0]));
+	areas[old_nr] = area;
+
+	scoped_guard(spinlock_bh, &ifq->rq.lock) {
+		guard(spinlock_bh)(&ifq->alloc_lock);
+		ifq->areas = areas;
+		ifq->nr_areas = old_nr + 1;
+	}
+	kfree(old_areas);
 	return 0;
 }
 
@@ -621,7 +645,7 @@ static void io_close_queue(struct io_zcrx_ifq *ifq)
 		if (ifq->if_rxq != -1)
 			netif_mp_close_rxq(netdev, ifq->if_rxq, &p);
 
-		io_zcrx_unmap_area(ifq, ifq->area);
+		io_zcrx_unmap_areas(ifq);
 		netdev_unlock(netdev);
 		netdev_put(netdev, &netdev_tracker);
 	}
@@ -630,6 +654,8 @@ static void io_close_queue(struct io_zcrx_ifq *ifq)
 
 static void io_zcrx_ifq_free(struct io_zcrx_ifq *ifq)
 {
+	int i;
+
 	if (WARN_ON_ONCE(ifq->if_rxq != -1))
 		return;
 	if (WARN_ON_ONCE(ifq->netdev != NULL))
@@ -637,8 +663,8 @@ static void io_zcrx_ifq_free(struct io_zcrx_ifq *ifq)
 	if (WARN_ON_ONCE(ifq->master_ctx))
 		return;
 
-	if (ifq->area)
-		io_zcrx_free_area(ifq, ifq->area);
+	for (i = 0; i < ifq->nr_areas; i++)
+		io_zcrx_free_area(ifq, ifq->areas[i]);
 	if (ifq->mm_account)
 		mmdrop(ifq->mm_account);
 	if (ifq->dev)
@@ -647,6 +673,7 @@ static void io_zcrx_ifq_free(struct io_zcrx_ifq *ifq)
 	io_free_rbuf_ring(ifq);
 	free_uid(ifq->user);
 	mutex_destroy(&ifq->pp_lock);
+	kfree(ifq->areas);
 	kfree(ifq);
 }
 
@@ -692,14 +719,10 @@ static void io_zcrx_return_niov(struct net_iov *niov)
 	page_pool_put_unrefed_netmem(niov->desc.pp, netmem, -1, false);
 }
 
-static void io_zcrx_scrub(struct io_zcrx_ifq *ifq)
+static void io_zcrx_scrub_area(struct io_zcrx_ifq *ifq, struct io_zcrx_area *area)
 {
-	struct io_zcrx_area *area = ifq->area;
 	int i;
 
-	if (!area)
-		return;
-
 	/* Reclaim back all buffers given to the user space. */
 	for (i = 0; i < area->nia.num_niovs; i++) {
 		struct net_iov *niov = &area->nia.niovs[i];
@@ -713,6 +736,15 @@ static void io_zcrx_scrub(struct io_zcrx_ifq *ifq)
 	}
 }
 
+static void io_zcrx_scrub(struct io_zcrx_ifq *ifq)
+{
+	int i;
+
+	guard(mutex)(&ifq->pp_lock);
+	for (i = 0; i < ifq->nr_areas; i++)
+		io_zcrx_scrub_area(ifq, ifq->areas[i]);
+}
+
 static void zcrx_unregister_user(struct io_zcrx_ifq *ifq, struct io_ring_ctx *ctx)
 {
 	scoped_guard(spinlock_bh, &ifq->ctx_lock) {
@@ -1185,12 +1217,15 @@ static inline bool io_parse_rqe(struct io_uring_zcrx_rqe *rqe,
 	unsigned niov_idx, area_idx;
 	struct io_zcrx_area *area;
 
+	lockdep_assert_held(&ifq->rq.lock);
+
 	area_idx = off >> IORING_ZCRX_AREA_SHIFT;
 	niov_idx = (off & ~IORING_ZCRX_AREA_MASK) >> ifq->niov_shift;
 
-	if (unlikely(rqe->__pad || area_idx))
+	if (unlikely(rqe->__pad || area_idx >= ifq->nr_areas))
 		return false;
-	area = ifq->area;
+	area_idx = array_index_nospec(area_idx, ifq->nr_areas);
+	area = ifq->areas[area_idx];
 
 	if (unlikely(niov_idx >= area->nia.num_niovs))
 		return false;
@@ -1260,18 +1295,24 @@ static unsigned io_zcrx_ring_refill(struct page_pool *pp,
 static unsigned io_zcrx_refill_slow(struct page_pool *pp, struct io_zcrx_ifq *ifq,
 				    netmem_ref *netmems, unsigned to_alloc)
 {
-	struct io_zcrx_area *area = ifq->area;
+	unsigned area_idx = 0;
 	unsigned allocated = 0;
 
 	guard(spinlock_bh)(&ifq->alloc_lock);
 
-	for (allocated = 0; allocated < to_alloc; allocated++) {
-		struct net_iov *niov = zcrx_get_free_niov(area);
+	while (allocated < to_alloc) {
+		struct net_iov *niov = zcrx_get_free_niov(ifq->areas[area_idx]);
+
+		if (!niov) {
+			area_idx++;
+			if (area_idx >= ifq->nr_areas)
+				break;
+			continue;
+		}
 
-		if (!niov)
-			break;
 		net_mp_niov_set_page_pool(pp, niov);
 		netmems[allocated] = net_iov_to_netmem(niov);
+		allocated++;
 	}
 	return allocated;
 }
@@ -1407,8 +1448,8 @@ static void io_pp_uninstall(void *mp_priv, struct netdev_rx_queue *rxq)
 	struct pp_memory_provider_params *p = &rxq->mp_params;
 	struct io_zcrx_ifq *ifq = mp_priv;
 
+	io_zcrx_unmap_areas(ifq);
 	io_zcrx_drop_netdev(ifq);
-	io_zcrx_unmap_area(ifq, ifq->area);
 
 	p->mp_ops = NULL;
 	p->mp_priv = NULL;
@@ -1569,16 +1610,22 @@ static bool io_zcrx_queue_cqe(struct io_kiocb *req, struct net_iov *niov,
 static struct net_iov *io_alloc_fallback_niov(struct io_zcrx_ifq *ifq)
 {
 	struct net_iov *niov = NULL;
+	unsigned area_idx;
 
 	if (!ifq->kern_readable)
 		return NULL;
 
-	scoped_guard(spinlock_bh, &ifq->alloc_lock)
-		niov = zcrx_get_free_niov(ifq->area);
+	guard(spinlock_bh)(&ifq->alloc_lock);
+
+	for (area_idx = 0; area_idx < ifq->nr_areas; area_idx++) {
+		niov = zcrx_get_free_niov(ifq->areas[area_idx]);
+		if (niov) {
+			page_pool_fragment_netmem(net_iov_to_netmem(niov), 1);
+			return niov;
+		}
+	}
 
-	if (niov)
-		page_pool_fragment_netmem(net_iov_to_netmem(niov), 1);
-	return niov;
+	return NULL;
 }
 
 struct io_copy_cache {
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index 302659669ba4..05598f08eda0 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -57,7 +57,10 @@ struct zcrx_rq {
 };
 
 struct io_zcrx_ifq {
-	struct io_zcrx_area		*area;
+	/* read-protected by any of: ->pp_lock, ->alloc_lock, ->rq.lock */
+	struct io_zcrx_area		**areas;
+	unsigned			nr_areas;
+
 	unsigned			niov_shift;
 	struct user_struct		*user;
 	struct mm_struct		*mm_account;
-- 
2.54.0


