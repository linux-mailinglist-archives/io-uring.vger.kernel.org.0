Return-Path: <io-uring+bounces-13940-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id /ofFJBwKUmraLQMAu9opvQ
	(envelope-from <io-uring+bounces-13940-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 11:17:16 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DFAA9741017
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 11:17:15 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Jya+j4G6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13940-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13940-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0C2123064472
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 09:12:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64068385519;
	Sat, 11 Jul 2026 09:12:43 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F34384250
	for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 09:12:41 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783761163; cv=none; b=KCKCXXuvIOmL/rChExW2o5LpxcbuKbrWeUgDTc+edWFxxQt/Yg7VL3D20VuVnRa5SDlOOjyNtRZz2kZ7HK/JmRTtjVridCzPLTLEuGaHTp9cUW0kYg9SZnKuNZ0HFVnkt/dggKK21uW7MVKETJ2jeaEo3Jq81F33JSkH2J+ZA9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783761163; c=relaxed/simple;
	bh=xRgBAtDHyHxqdhOqR4G/l4hvNv+gzIXh7nRx0WknYxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HIAXSzvpNCmrBzocfjD3dbWIsZG8yyskYpzE4fVR3z+a8gxlb8nMMy36rJoJ9Qty9WlBRNFgnOZEqy3RAUVwtT0IPL/ThjMVxmDxGYR61/++ssOKnVmcwpaNo0dzfqS1lN86BVympQIIXVf9LbetTh+fEoovheu/7M5eEHaMCUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jya+j4G6; arc=none smtp.client-ip=209.85.208.44
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6986578d8c0so2431022a12.1
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 02:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783761160; x=1784365960; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=40IOAR9jl4nV6USx07Om+oEnXzAVvYxe6ms1YH9xtlE=;
        b=Jya+j4G6CDP55OJGGSq2ZXwrjx1mjWfqnWtTlYGDez4vyQoQHbJOhh8KtDTh82+DlB
         uV04jZGOZ21m0g8ocXHmos2LpNndk1N7Z5pzG0DYtExLY5pEjTNT2Ud+HeBNXfyyUZlU
         QUb6XNYZoeJpaOINcEX8Bj2BJNGOUjklb9RezqhiZaIAFFUOedWOeSuMf1IzISXEySpT
         cxTtgnbtynv4/B27i98gNv/etgrzOBXMapchP/0Jrh1/9i1GVxtv9DLvRZwusp3kYZ9z
         Tz0JLw38ptyKlCdWUDllmCwLuHqZnbWBR540KSULVPWFGjzTsFHpwRNwklHE3QsFMxS8
         +QRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783761160; x=1784365960;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=40IOAR9jl4nV6USx07Om+oEnXzAVvYxe6ms1YH9xtlE=;
        b=Bd5o1k+VKLGTgAYYJkOXjk3fgj0otwM6umdXrGmOkkWIuXTGk0YpH+78HLe8TlPVLo
         9KA5p5MocGy05tGaQnUdTFj80cVmlU7ZZRV7lkMu1MpTIhWi5bZcxKBNONiv4xBG3/+H
         aWzlnENzag602bOGLvJbvuDX6NyHhgmXNpd+fgxgXKqsc0900EiCV41Vf1u05LsGC1S0
         ir98UVppGYdO3zJE3S011/IxEBDzY7YlEJYVJkZIGR/Aa90n1xyqkcXJ4ChNTWXzTivE
         CHnKHRBcqJOFxhCNHBlO4xaNaILHuWAyaOyO9rISW5+NeurCw5NFoY+jNBotxbG9Dy1m
         fwnA==
X-Gm-Message-State: AOJu0YxZprBV72emJ70Nd5wMd3/TlltxpwnAXz/OrJV2JeAeFKKVkRHu
	jXimS/7CiQsxA7EVjIaNn00yd1aOhoEh5crEymgRdVrSzapatsfd02F+L/Ur5g==
X-Gm-Gg: AfdE7ck9Uz2JHaxIg9IFnTHO0d1LnYSFCI99cfBjAsp0sNVwu2tbg0K3pF+bLSlgjM/
	viyWyuGhdpNRKgVC7FxfDNGKdPmksiQM6spZqesmFb2GUPmXLpU1GWdKWckHOHpWiancRb3oEJs
	tMxpR6v9Dj1DnHS4KphaFtaWuYwmz1MuoxOaMDA36qMjeIcBi8kOieoKitIrT2kgw2PYuTwFSVS
	ldXaKQsa8T4omtK0wEMK1wdt9i7OWBGtsu37NzcXsfTl93Y5Elw3oUi9VZw/4PIi9Lqh8UzMs/R
	bM0qQRbQGNhrvptJh9wmYPIjhxqQ6OzxNtjNxqvdiWfBGn+ZagcE8sRfYaP1B6B0zY8Dxvwyxw+
	vg63UxB49D0H2dm/2BtFzSTiVJ1N6XQqOYsrh1eVEmE380abXsPkOaxaQ73MHersyiZyAx+zE+M
	FofTMJPOxiDKqzB5EQoSsQBauNanF9wctlEeVSwMDHXTqccqFwqAKhRVcR9iC38R+5q1LardLO1
	cCWnc9u0dkk5LdUFCurQYIC6FcFLIGSFUjud2rIr1+Xjr4=
X-Received: by 2002:a05:6402:3224:b0:698:1504:e3e0 with SMTP id 4fb4d7f45d1cf-69c5f116b88mr975464a12.29.1783761160286;
        Sat, 11 Jul 2026 02:12:40 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-221-54.dab.02.net. [82.132.221.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-69c60d47188sm681191a12.27.2026.07.11.02.12.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 02:12:39 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH review-only 12/17] io_uring/zcrx: move freelist lock to struct zcrx
Date: Sat, 11 Jul 2026 10:11:35 +0100
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13940-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: DFAA9741017

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


