Return-Path: <io-uring+bounces-12793-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gOflJVM2wWm7RQQAu9opvQ
	(envelope-from <io-uring+bounces-12793-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 13:47:15 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B38CD2F22C8
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 13:47:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 39B96300F785
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 12:44:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E0153A9D9E;
	Mon, 23 Mar 2026 12:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZilVZL0W"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6FF03AA50E
	for <io-uring@vger.kernel.org>; Mon, 23 Mar 2026 12:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774269857; cv=none; b=OnIR0C/OqnVPpTW8Qm1zkeZIAb4CAGYpHPhh/ap4zO7ZPjp52IfXNvOG4QOMikqOFKYNnMNNXdQ4vdREgMv3OyZmdvA8N/iF6BhPSBUZU4pH40J/8bhiE3BKpMbsgIoyOJ8Elw+CgZqovIuKICrBqIcgSjYuQcHr4swPyT1tTAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774269857; c=relaxed/simple;
	bh=L0jgbh5QnjPUJeWtTG9GDB7Wye3648tRWFl79As3/GE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=musrRzJkeufbBRcjkyJURpTUsK0rRnd2HYP4qoubBAhWoMovSPTzbUJ2ADutEiWpJjHjHJdwWuu0V9OLJJPeN0DuA6hfkOARmdBqNTIpiALQaT7corw2HxX+YqVya1LRfZJnu8Cu2XMD7/wvT6C9JgqsUdTTMk052YPQWhBkswA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZilVZL0W; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-43b4915161fso2702738f8f.2
        for <io-uring@vger.kernel.org>; Mon, 23 Mar 2026 05:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774269854; x=1774874654; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pOFMbD1yGFpg9uDtw+lz6ASK6S7C9npp14S2Mdro1S4=;
        b=ZilVZL0WimX69w8SwMKbbcmBPhcNBhfI087N6ym2i8VknCeiuYgPxipnCHGyW+EbQx
         Cx0tX6BekCmFDmv2loyb7IxrbXHmvI1k0uhKb63LLgL48GPKI1iX5CUN3Z7fUCgTkstJ
         KAxLClX3c8C5ev0nWe23s+PUrDWQSy+0B7svNR9JxzoEHBAsEhyJnU/yLW4A+o0GcWxi
         YnHqkACGRbAMDFDCaDURYcgTd7g2sHxhX62Qz9UpaFWdNQ17QcVkBdpeVYgbbQ1NGiP/
         bxr+4LFPHwTI9Fv8deRkJ/qVzl5kxsg1IMEo9HMsg4NpwgPrLk+kZRB3kMstKNAHd2Aq
         s3eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774269854; x=1774874654;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pOFMbD1yGFpg9uDtw+lz6ASK6S7C9npp14S2Mdro1S4=;
        b=bsutcDEkRg/Z0UZowqRl29cssdCTyZm92eI2rNKXSxkmxGdAehDBTTWc5KsLWf26HY
         II4IAvupVWZptD6dmM21CnUqvwEjgrMnwVr3u+Iz+rZlZAD6qVWdU3BbiNPFTKpQy0r5
         Mxag21fl0S7SXy/DAd+HfvdlccEcMSNckdngXeJ+b+vz1gIJbL4jjMebYvRUdmZpxXl6
         dtlNLzCktIc+8pSJVeTWC1ar1upi6hye/HnP33Jd2lwRn4ACq0oCFtSdqbBrhDwrurpk
         CqdCaQf+aC8c6GWz4hQl220kLfFL29kdYXg7r+OLAOcrQpA6YFnVX+Zx9GqrSi2p0VCR
         arPQ==
X-Gm-Message-State: AOJu0YxVm9wWRV2wV/X/0D5qCaM1JiiEp/w2MZBYuJc9x0K5EWnKNyaf
	Zz6AgmUT4xDUTeNh9iYu49V/SS+AlHZNlBQBwmQ8BGttwizzJxWY1fpYGewPjQ==
X-Gm-Gg: ATEYQzyj4wY0A3/YbofQB9EhfntJ/TglRtCIbhQ18Wlmbv8b9JHVRtfuLUy5TnjaVtO
	cxuSN7ZXFWbG7axzI18F9wrCQ6/Eb6epMpvuQ8od5d761dNxykOIH/QFT6vyDB8Rzu4ctpdw5y5
	RI8Y6qEXVy5kxe/QY14+Qly1UawNAmmiQaCkqSV3rbPod6Ek/SaOSISOGM6HJO3O36LYhYpcQ8N
	B9WSuvr6tRSPaC+oZoVgXOfZ61eMNlmA+IBJ+TI75dw7aUS+q58cE10zll+gbN3wiffhcmqQfat
	XleQmMcqrb2+WBWD8RKFIN9m1+p7eMAIW9+gxUTx1z4qEHo4aQtKKiSayb4cP8TMVAlgxdK0UGa
	H8tgXk6WO5JAts1B/48wNJ8oUH+Kp4tF5re/mqBljP2sQcmuh+j0dEGe91dhGrBY+BcWrrVYzkE
	4UkQa9JaCUjqkOZxLMrjx6BEhRFwHlyUrvztXSjcYc08jQGbwjhVqsv5vzGOYZAcnQ+xIzHJq3s
	C/xFx1b6w==
X-Received: by 2002:a05:6000:401e:b0:43b:3bed:1548 with SMTP id ffacd0b85a97d-43b64270cb6mr18580832f8f.42.1774269853731;
        Mon, 23 Mar 2026 05:44:13 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:6969])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b6425eeb4sm25520861f8f.0.2026.03.23.05.44.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 05:44:12 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH io_uring-7.1 09/16] io_uring/zcrx: move count check into zcrx_get_free_niov
Date: Mon, 23 Mar 2026 12:43:58 +0000
Message-ID: <6df04a6b3a6170f86d4345da9864f238311163f9.1774261953.git.asml.silence@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-12793-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B38CD2F22C8
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Instead of relying on the caller of __io_zcrx_get_free_niov() to check
that there are free niovs available (i.e. free_count > 0), move the
check into the function and return NULL if can't allocate. It
consolidates the free count checks, and it'll be easier to extend the
niov free list allocator in the future.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 38 +++++++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 17 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index db723644ddcb..b4352c7b2d84 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -590,6 +590,19 @@ static void io_zcrx_return_niov_freelist(struct net_iov *niov)
 	area->freelist[area->free_count++] = net_iov_idx(niov);
 }
 
+static struct net_iov *zcrx_get_free_niov(struct io_zcrx_area *area)
+{
+	unsigned niov_idx;
+
+	lockdep_assert_held(&area->freelist_lock);
+
+	if (unlikely(!area->free_count))
+		return NULL;
+
+	niov_idx = area->freelist[--area->free_count];
+	return &area->nia.niovs[niov_idx];
+}
+
 static void io_zcrx_return_niov(struct net_iov *niov)
 {
 	netmem_ref netmem = net_iov_to_netmem(niov);
@@ -903,16 +916,6 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 	return ret;
 }
 
-static struct net_iov *__io_zcrx_get_free_niov(struct io_zcrx_area *area)
-{
-	unsigned niov_idx;
-
-	lockdep_assert_held(&area->freelist_lock);
-
-	niov_idx = area->freelist[--area->free_count];
-	return &area->nia.niovs[niov_idx];
-}
-
 static inline bool is_zcrx_entry_marked(struct io_ring_ctx *ctx, unsigned long id)
 {
 	return xa_get_mark(&ctx->zcrx_ctxs, id, XA_MARK_0);
@@ -1052,12 +1055,15 @@ static void io_zcrx_refill_slow(struct page_pool *pp, struct io_zcrx_ifq *ifq)
 
 	guard(spinlock_bh)(&area->freelist_lock);
 
-	while (area->free_count && pp->alloc.count < PP_ALLOC_CACHE_REFILL) {
-		struct net_iov *niov = __io_zcrx_get_free_niov(area);
-		netmem_ref netmem = net_iov_to_netmem(niov);
+	while (pp->alloc.count < PP_ALLOC_CACHE_REFILL) {
+		struct net_iov *niov = zcrx_get_free_niov(area);
+		netmem_ref netmem;
 
+		if (!niov)
+			break;
 		net_mp_niov_set_page_pool(pp, niov);
 		io_zcrx_sync_for_device(pp, niov);
+		netmem = net_iov_to_netmem(niov);
 		net_mp_netmem_place_in_cache(pp, netmem);
 	}
 }
@@ -1282,10 +1288,8 @@ static struct net_iov *io_alloc_fallback_niov(struct io_zcrx_ifq *ifq)
 	if (area->mem.is_dmabuf)
 		return NULL;
 
-	scoped_guard(spinlock_bh, &area->freelist_lock) {
-		if (area->free_count)
-			niov = __io_zcrx_get_free_niov(area);
-	}
+	scoped_guard(spinlock_bh, &area->freelist_lock)
+		niov = zcrx_get_free_niov(area);
 
 	if (niov)
 		page_pool_fragment_netmem(net_iov_to_netmem(niov), 1);
-- 
2.53.0


