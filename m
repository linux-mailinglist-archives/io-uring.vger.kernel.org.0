Return-Path: <io-uring+bounces-12792-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4L8YM9I1wWm7RQQAu9opvQ
	(envelope-from <io-uring+bounces-12792-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 13:45:06 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 758CA2F223D
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 13:45:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id F2D40301A2D8
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 12:44:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1457F3AA516;
	Mon, 23 Mar 2026 12:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CmE/Up8M"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7D73AA4F7
	for <io-uring@vger.kernel.org>; Mon, 23 Mar 2026 12:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774269856; cv=none; b=ZYIhxSrn1xSFbJudz7dHpLC6aGOhiIimOrR52wAH/1idKmTEnZ79iuIySOF/C/cTcngwqJ7pm5QQgMjeG00Rk/bPcAl6bUWnetSQI9yqlsvNwRQijZgsumEcIimziVAdX9+tLoCDqy6nD5vp92m6+/9UD6BvobWS0q/FqFQCnuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774269856; c=relaxed/simple;
	bh=t3YNfgDZnPrTKEFkekkkpJ5hRPOPrMYsu1bDyIIhuMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aeiQhuErGPMcLr/JXgD8hi/1Mzn/qu+6OH34DmFwUJik7f3F8gJNkPxR+4rnDvBiXsLBcCA/ijvA5kgu04PYfKOQbjYK1XOeQOcq+pnfYWABAlFhcASKE4KIURht5FBFplL0NeS8541ONwLHPbz6HG8n+tgV/iv0jx5H6M+qUxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CmE/Up8M; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-439cd6b0aedso2764975f8f.1
        for <io-uring@vger.kernel.org>; Mon, 23 Mar 2026 05:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774269853; x=1774874653; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FyJO+7VQXVOPuJrhl5pElbnBWCJ+4Iou+InlmbUI3Oc=;
        b=CmE/Up8MWf8bJmYv5I3b7Fc/fmkEmxitQROsstjv+ifuOR7PFUAnkal+n/ZhiFdkr+
         PZhsTgjKf70dZRzNF2lDxYpDiuSeJb1AaXCJvpQh2/G55Bi5QzHjoczkUiUNkk/5YhaD
         skIss4Q42xOMmF/wxzLGfvWjl4zHwKcXIUmyiO1VZnhv2Ee1UWyDdTW8whjjRmKW90pS
         yQkA0hOnYmkKBZOpqIGPFU9DZAmw/sE6GvDK7oe3RvuXLZq85E3xRrJqntIiEUlbrpxG
         hVw+xKv2fOk/6Q4gdI+GZ3CmPBF/7vbDycqC60lqPx8sVHcZXQUiHtMEhbc/oXtFMw68
         ynfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774269853; x=1774874653;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FyJO+7VQXVOPuJrhl5pElbnBWCJ+4Iou+InlmbUI3Oc=;
        b=iBi8iqEiJLQhWFJlwP7IwmJE93m/x02OFQzWKJo3krtQ7fAJmSSo7mSZ6/DAke4it8
         rSs6ff1K36+2Jz82Vn4Q82n1f9udcaejBIJRcjwg/eVnfWF0CKDYSTVeRiHhmEu/whe/
         8kshHRXYMDwgvmr4MmTQNLl62pLD4SlYlR5XcvUPakA/twZs2G3QjuLHsBFU6OGo5zga
         bnx6jZ11gissVkjJ17r6d0yB8ASpLCv6pCXxyTx2KLoRNk/kUjr/HiIuQyB6C17Us6w7
         ajQwQQ9kaG6nJoGNkPwC2nYaUIERvzySL45mHXtdBHg5f3dOiRBTnPIKTCufK5/9TYRy
         7WLw==
X-Gm-Message-State: AOJu0YyjihQBpmkMOrsGnYmGtloMHrOSLtuP8NyxwKop7ZwAw6xM2Xll
	l+V7igDS5mgS7t21HchyU01b7jvWrrnyiy6NCeIpsWHZAXXwssuvKBel8wy94g==
X-Gm-Gg: ATEYQzxDk0dg69YTQ0Gnv818ensgw9ugOokPVOkvmAyYZzko3daVeJTAdOaLQNaqzx0
	VQmkunJimPSOHSzu9TA5+DwZ5JKQZRZqb6QLa0uGHX4NQmxSCwdWFtfNYgTxGrv1iW/b4zmLeCE
	G6rzfQlhh+X+/0UG2bv812UsImw8OVec6CuqW+yZfhThZzCe8O1s+ZchYNBYU6Xd1XlFm+pubal
	jFLCSk/6QqXkZ9XFW+SvxC9IOlG7cvBcZW+pub/DXyOcCh2Q2RDwRkCx4lhMqjs72TXck2Rq610
	Lgnz/GbjZV+5k4oVVPanU7IqL9CvRz9eOfZgtIyMKNpjUxdvWvE+OIZeobGkpvGX37IZdy6e5oG
	rhyRPo8UYXt9hpvGVHVtgBcEwxnnveTiYhxANRBI8k9mJ3FZkyaFqX79rkWFZwrwtXa8sVqPOHM
	o0rUgFcdgLyUxHHndiAvRixcgva9NruF+vwD21uqgAYtYvvUlJ/8rQ/vHjckpcWZKhfHlGP0xnP
	PwFNhkedw==
X-Received: by 2002:a05:6000:3104:b0:43b:3cdc:9414 with SMTP id ffacd0b85a97d-43b6423d93amr19260094f8f.10.1774269852583;
        Mon, 23 Mar 2026 05:44:12 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:6969])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b6425eeb4sm25520861f8f.0.2026.03.23.05.44.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 05:44:11 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH io_uring-7.1 08/16] io_uring/zcrx: use guards for locking
Date: Mon, 23 Mar 2026 12:43:57 +0000
Message-ID: <eb4667cfaf88c559700f6399da9e434889f5b04a.1774261953.git.asml.silence@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-12792-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 758CA2F223D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Convert last several places using manual locking to guards to simplify
the code.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 0a5f8eab92c3..db723644ddcb 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -586,9 +586,8 @@ static void io_zcrx_return_niov_freelist(struct net_iov *niov)
 {
 	struct io_zcrx_area *area = io_zcrx_iov_to_area(niov);
 
-	spin_lock_bh(&area->freelist_lock);
+	guard(spinlock_bh)(&area->freelist_lock);
 	area->freelist[area->free_count++] = net_iov_idx(niov);
-	spin_unlock_bh(&area->freelist_lock);
 }
 
 static void io_zcrx_return_niov(struct net_iov *niov)
@@ -1051,7 +1050,8 @@ static void io_zcrx_refill_slow(struct page_pool *pp, struct io_zcrx_ifq *ifq)
 {
 	struct io_zcrx_area *area = ifq->area;
 
-	spin_lock_bh(&area->freelist_lock);
+	guard(spinlock_bh)(&area->freelist_lock);
+
 	while (area->free_count && pp->alloc.count < PP_ALLOC_CACHE_REFILL) {
 		struct net_iov *niov = __io_zcrx_get_free_niov(area);
 		netmem_ref netmem = net_iov_to_netmem(niov);
@@ -1060,7 +1060,6 @@ static void io_zcrx_refill_slow(struct page_pool *pp, struct io_zcrx_ifq *ifq)
 		io_zcrx_sync_for_device(pp, niov);
 		net_mp_netmem_place_in_cache(pp, netmem);
 	}
-	spin_unlock_bh(&area->freelist_lock);
 }
 
 static netmem_ref io_pp_zc_alloc_netmems(struct page_pool *pp, gfp_t gfp)
@@ -1283,10 +1282,10 @@ static struct net_iov *io_alloc_fallback_niov(struct io_zcrx_ifq *ifq)
 	if (area->mem.is_dmabuf)
 		return NULL;
 
-	spin_lock_bh(&area->freelist_lock);
-	if (area->free_count)
-		niov = __io_zcrx_get_free_niov(area);
-	spin_unlock_bh(&area->freelist_lock);
+	scoped_guard(spinlock_bh, &area->freelist_lock) {
+		if (area->free_count)
+			niov = __io_zcrx_get_free_niov(area);
+	}
 
 	if (niov)
 		page_pool_fragment_netmem(net_iov_to_netmem(niov), 1);
-- 
2.53.0


