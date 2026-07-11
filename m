Return-Path: <io-uring+bounces-13942-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id aXPyJRwJUmq5LQMAu9opvQ
	(envelope-from <io-uring+bounces-13942-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 11:13:00 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AB31740FB1
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 11:13:00 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=niCZAxw2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13942-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13942-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id DDC16301D75F
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 09:12:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46D173019DC;
	Sat, 11 Jul 2026 09:12:48 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C47C384CC3
	for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 09:12:46 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783761168; cv=none; b=D67RuVW6QJFO4zrQZg4nIhIfQvfq2hG8KdymnOkF3vSio+r3T5WovHV8iXkHABhDI2IQoc592zK2COgT0BrLLqpvMEYfQZ0unIrQu+CreGFkOWOKcyVGFpSYLN9To3NcArDRysKSGyNDsAOhgrO6KH0CAniXIuSwqfgN7plcJZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783761168; c=relaxed/simple;
	bh=zkLFA4IwpYfI64hlaKiMkFmdzAb6Z6YKeqUgeL53iUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t+sJNHZkSUKSMCzjCIVdFOxl6vsDSkkMfHWWStUbuACZmLIEEz3e5z/DCNRzmxFmDe8w4ylYRaEhyxxXVeSDDg4W23T378Xm9JSSjHsfUE6N7LVWlrs2eLB6lIo5tlunMhdRUN1nDpp3HXnouto07TzYUmZT5t7wc4GWeqFc+BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=niCZAxw2; arc=none smtp.client-ip=209.85.208.42
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6989c0ec3c5so3229178a12.2
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 02:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783761165; x=1784365965; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=C0t6RP8+Z0YrUFsaHov/g+ZCVGrpG8FgLG0b0lWoeAw=;
        b=niCZAxw2LIdWjB5r9PgC7LbpGPLvcI7H63+RT2ONbZnF0OgaqqxA73Lhk8XIXrzO3O
         LwRwqxx0nvngyDeQnh0nDQmjreempNeXlvcMwjbhrB7GRuIpDRPElWwI1fQzOzdtOu0B
         areY3FB8tC+0h5/xYiZkLbcqefHRieknw631z2mEBbGsCZO4wTfF99qPiVw276gG11Qs
         3GERQ/sNSUMKBc13JyuY3UrAB5+sJshi18I6e4DHM8j+KpjrrrzJjZOFH4wLKiDsksDO
         HJB3rZ8TrAMRal4c6moC3Hc2Xsk5DT8gNt+Z76Q30vfUkbeMNp7W1Hh9Fzmo3jhJSEsg
         y/Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783761165; x=1784365965;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=C0t6RP8+Z0YrUFsaHov/g+ZCVGrpG8FgLG0b0lWoeAw=;
        b=iGPLMEKdUFatla6NHnRZklJ5eSh2gH0XtxhY36c19DE8y1cSYj9T5yNKfaiCpWFb7e
         KxIIjp2Sg9FHDQ/pD+GvzdAH+c16g+bC8DnapojEOzi7L3DuLzbagkM32XKrdrpazK+u
         KmtVPTtOrHqvBLEfjXJ8L/4sC58e9li2JGWv/cnpJiKQe17+wGiEaSqWMeA2widE8DHz
         sChrkmuT6Qz8V8ptI9I1j6Pvo3lOBppRGbZSQZ7JfXDdVYg0wIuHlZxq9jgHjP0nQhER
         Lwbn8KyNv6S+iy70ST2mi/X7ZtTrHDDtPZz9cmrjwpvEZoXmoor3tg8c/xS9l3CQaKRe
         JoFg==
X-Gm-Message-State: AOJu0YwriXJObTpu8mZmvoQhwntxTVfkVwN5mMyTpQ+mQ9HaN9DWDTdZ
	TBNWGaD0pcoja2N8GCoCPMD1Zm50TiBWjjCY+e9fqvTAHc7FC3lyHCy7kIa2mg==
X-Gm-Gg: AfdE7clylH9zQTTuI0MI7n14ouYR1zCyKGR82B5bMZRcav3wzu2eR+FIVZn4DK0NZxb
	viGR+GAS3soNA8I31MPmfdzxTf1k2ytc8TMDZQnByeVpMRWiGsQyearOM/rNBOHNGq6dR14SAEz
	arrL+9G9VNxRIGhmAGLI6GH0i7PzvqRPwpm17sphtfASUHndcCFXKvXbDQrDbxj72/0CDGSvbt1
	bUQyd6H7Y3hNO9le4ASlX0kaNQNTKHqAnOLBfAGcR/lvtpudSqrfhw4OKFRGFE0tChivdpAxmm+
	Ra5GgvgPnFySEV1Uxn1pJ7FMBLRrucqbeQ6DlQac8wv9wIn7aWkcUT504IEnG5EaNMtBu4wQhOC
	UCNGdJ3QRDa3zVbEe585gS7d8V6q8FR0MeXeparruZZ5PAyTRtpGJSRrUtoyde23cuNkekxtthA
	mzzljj3zLt2Bk5wJzUp2Jt2oygRTuUE3+IYJzMymUps3+1FuhijpPZHN4m34HPh7YIdIfbwv7KM
	w1/ieXxClPXR6qAR2Dol8bh65ncB/f0kBjkV6cT9Syg/Nw=
X-Received: by 2002:a05:6402:4403:b0:699:8397:55f8 with SMTP id 4fb4d7f45d1cf-69c5f0cb88cmr1063858a12.18.1783761164821;
        Sat, 11 Jul 2026 02:12:44 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-221-54.dab.02.net. [82.132.221.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-69c60d47188sm681191a12.27.2026.07.11.02.12.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 02:12:43 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH review-only 13/17] io_uring/zcrx: array of areas
Date: Sat, 11 Jul 2026 10:11:36 +0100
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13942-lists,io-uring=lfdr.de];
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
X-Rspamd-Queue-Id: 4AB31740FB1

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


