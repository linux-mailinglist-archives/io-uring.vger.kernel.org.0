Return-Path: <io-uring+bounces-13429-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uB2oInNODGpIeQUAu9opvQ
	(envelope-from <io-uring+bounces-13429-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2026 13:50:11 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 37C7257E04B
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2026 13:50:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9D5DD30CE8B4
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2026 11:44:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F3394A2E1A;
	Tue, 19 May 2026 11:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A0mTk6lJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95C44B8DC3
	for <io-uring@vger.kernel.org>; Tue, 19 May 2026 11:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779191096; cv=none; b=BcBXuYZrqxAye6W9dGN+D+UGLvGrU7hMAO2ZZW7p0oT6ejnDSgZw8J8weZkYtBDV3Brg+k7zfXXQgmck//Cso+mzFzc7dswHhlkF4xhgm4sStXqOSPVW9ORYG/xdiK3PSsZMi8m6lW2Gcj5PU8VzxiQ56cIiBtF1pWJr2wl+11M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779191096; c=relaxed/simple;
	bh=MT7ScsbySYQ4djaKw0kMNHrOpRwk3lWVfJGZzCOLegA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e+eLFiEJwbdQwg9rfxaFCC57mMXv1cEgwaalEpzevKpVZt5h94n5KwxazAIeuGgoIi4CwysZ83xzAeD10/LdP3PgZLsdwf6VDKsvfSfisdx6gylcxRpDx0jl5n2YLnDM06nJ9HSdkiJTFzGkHysgsK7MDuUI3DZoEno5duM+pE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A0mTk6lJ; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-48ff4f8ef0dso39169155e9.3
        for <io-uring@vger.kernel.org>; Tue, 19 May 2026 04:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779191088; x=1779795888; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6SiEKs/5qVboVpmmLgyyak0aq44hXr1t4EdMdCENFsc=;
        b=A0mTk6lJFtGM7BDmXlf4feBUoHFN/NcPIkvGJlxI0lnc1gmufzvKTAPiYNwhzxeyUM
         xOuoIVkFg5zybqzTh2WixxMMZgecBllOR3todPr0FCI+kidEFAT/3iTRv4DBQSgaF1rl
         UdcaMlAEurnoydZmqz2gw3b9WOc7BAjRK9dqxZASBpV8EKq4p2ezDSBCLnvCO0NOT4LN
         oTkV86QUhSeCvpIZUf1j1S0D/YrlQ0l+7VNZ8Xev6MSgMp8g9waPOchyWuvvHB2lFeLb
         d/1nL1lZa1d5PqC/OxxDYrQypL9YwtYxwKsjH6a1mtb6O57N2ejuSMCJWQE71G5G1f4q
         /dzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779191088; x=1779795888;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6SiEKs/5qVboVpmmLgyyak0aq44hXr1t4EdMdCENFsc=;
        b=YIVjC0IUKPXsFryGOhxVJTbhgacATO2bo092wLGt9hCIANGeI9DAIV38S6pH4VWuLA
         i0FzI6rVjofeUz4NMNTA+pbkefb+bXnslVgXpdbw2W4tASBzCrLOToZ/GfsRZ0VjXJEk
         l7Xo6Pr4TB5sU/HlwySPiS4r0PwVQ1S9mFt/w86/NWrFstAe5Dp5oL6Qy5OE/2TBu3+Q
         lXuKYFtSeT7iFJUeWVpdUliVjoZBKjb5FRg899Mwyw6ejGDJyUbuzFrQxyBulr94ivhs
         RhPzimGX6ByNugnDBX332hnur55up5A7/jhMlU0fD/MWrVMdVS5Sb9fZ7WE4xK6ri9EB
         RQwg==
X-Gm-Message-State: AOJu0Yz5fRIWVNabNJDCtGER5vz4Ai0ZG6Q+uSRnC2Sd8hhmimmvq9CP
	fjGLSpQ13uUh+LUm9gqU2FF+61Av4SK+mDqebre07WUmx3JAjVyKK8u58sNTXA==
X-Gm-Gg: Acq92OGsNp810EGfLxY5lrH3sIBnd1tbYb4uMakQ2FpKWaCZvv15tbbXhH1ZAGQUf3i
	cHFBOJsJNFbBP3YifSLSwFmrGZohcc3CL4b8rBoAVQ/5PasxiXwKklf+x/GPC62sSMChIRApX9E
	9mfvpBR+AVGWX13UNsZRoOX1/e2mV9N815O11B1BZTO4X5UJOA3r0k1g6u3dZCbkAQD7Cyidcmk
	dnzMUf/4pHase+yND6LBdo5U5ggzXcTx+S6QwxvZbjdw2LP3R5TBvgdZjObHvmN2WApfxT9yLJj
	BiywsgrziUUTv6eQmVLcG1cm26Uz0Bw7E/7wOAGWwjtlAuD/+XNFPQBonWMMCfo3jPwo+uVCywj
	nzdTnKG1PlzJg+Xn3J3r0NgY25INpULGfYtdNMcjyiV+M7nQSpQIUEZJYHwtnadiNUucwKtDwGK
	37P0ds/+xyzRH6yam9BbeP7li6lk1dlu3P6f1yshHO8aF5w2DrAOrd1mlRSStXKnT8JKckCqcZ8
	3Q/3+50ZiqM0tBPANgUUjildabIF5I6mVzeitM3
X-Received: by 2002:a05:600c:4e87:b0:487:21c7:2885 with SMTP id 5b1f17b1804b1-48fe60e142emr309583625e9.5.1779191087793;
        Tue, 19 May 2026 04:44:47 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe5694f2csm323392445e9.4.2026.05.19.04.44.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 04:44:46 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH 5/8] io_uring/zcrx: add ctx pointer to zcrx
Date: Tue, 19 May 2026 12:44:31 +0100
Message-ID: <b60514b3d1bd92f571e3bd91751166f8c3599256.1779189667.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1779189667.git.asml.silence@gmail.com>
References: <cover.1779189667.git.asml.silence@gmail.com>
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
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13429-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_THREE(0.00)[3];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,meta.com:email]
X-Rspamd-Queue-Id: 37C7257E04B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

zcrx will need to have a pointer to an owning ctx to communicate
different events. Reference the ctx while it's attached to zcrx, and
rely on zcrx termination to drop the ctx to avoid circular ref deps.

Co-developed-by: Vishwanath Seshagiri <vishs@meta.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 39 +++++++++++++++++++++++++++++++--------
 io_uring/zcrx.h |  3 +++
 2 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 24a9ebbd9d8f..2d8a0c453212 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -44,6 +44,17 @@ static inline struct io_zcrx_area *io_zcrx_iov_to_area(const struct net_iov *nio
 	return container_of(owner, struct io_zcrx_area, nia);
 }
 
+static bool zcrx_set_ring_ctx(struct io_zcrx_ifq *zcrx,
+			      struct io_ring_ctx *ctx)
+{
+	guard(spinlock_bh)(&zcrx->ctx_lock);
+	if (zcrx->master_ctx)
+		return false;
+	percpu_ref_get(&ctx->refs);
+	zcrx->master_ctx = ctx;
+	return true;
+}
+
 static inline struct page *io_zcrx_iov_page(const struct net_iov *niov)
 {
 	struct io_zcrx_area *area = io_zcrx_iov_to_area(niov);
@@ -530,6 +541,7 @@ static struct io_zcrx_ifq *io_zcrx_ifq_alloc(struct io_ring_ctx *ctx)
 		return NULL;
 
 	ifq->if_rxq = -1;
+	spin_lock_init(&ifq->ctx_lock);
 	spin_lock_init(&ifq->rq.lock);
 	mutex_init(&ifq->pp_lock);
 	refcount_set(&ifq->refs, 1);
@@ -579,6 +591,8 @@ static void io_zcrx_ifq_free(struct io_zcrx_ifq *ifq)
 		return;
 	if (WARN_ON_ONCE(ifq->netdev != NULL))
 		return;
+	if (WARN_ON_ONCE(ifq->master_ctx))
+		return;
 
 	if (ifq->area)
 		io_zcrx_free_area(ifq, ifq->area);
@@ -655,17 +669,24 @@ static void io_zcrx_scrub(struct io_zcrx_ifq *ifq)
 	}
 }
 
-static void zcrx_unregister_user(struct io_zcrx_ifq *ifq)
+static void zcrx_unregister_user(struct io_zcrx_ifq *ifq, struct io_ring_ctx *ctx)
 {
+	scoped_guard(spinlock_bh, &ifq->ctx_lock) {
+		if (ctx && ifq->master_ctx == ctx) {
+			ifq->master_ctx = NULL;
+			percpu_ref_put(&ctx->refs);
+		}
+	}
+
 	if (refcount_dec_and_test(&ifq->user_refs)) {
 		io_close_queue(ifq);
 		io_zcrx_scrub(ifq);
 	}
 }
 
-static void zcrx_unregister(struct io_zcrx_ifq *ifq)
+static void zcrx_unregister(struct io_zcrx_ifq *ifq, struct io_ring_ctx *ctx)
 {
-	zcrx_unregister_user(ifq);
+	zcrx_unregister_user(ifq, ctx);
 	io_put_zcrx_ifq(ifq);
 }
 
@@ -685,7 +706,7 @@ static int zcrx_box_release(struct inode *inode, struct file *file)
 
 	if (WARN_ON_ONCE(!ifq))
 		return -EFAULT;
-	zcrx_unregister(ifq);
+	zcrx_unregister(ifq, NULL);
 	return 0;
 }
 
@@ -710,7 +731,7 @@ static int zcrx_export(struct io_ring_ctx *ctx, struct io_zcrx_ifq *ifq,
 	file = anon_inode_create_getfile("[zcrx]", &zcrx_box_fops,
 					 ifq, O_CLOEXEC, NULL);
 	if (IS_ERR(file)) {
-		zcrx_unregister(ifq);
+		zcrx_unregister(ifq, NULL);
 		return PTR_ERR(file);
 	}
 
@@ -786,7 +807,7 @@ static int import_zcrx(struct io_ring_ctx *ctx,
 	scoped_guard(mutex, &ctx->mmap_lock)
 		xa_erase(&ctx->zcrx_ctxs, id);
 err:
-	zcrx_unregister(ifq);
+	zcrx_unregister(ifq, ctx);
 	return ret;
 }
 
@@ -931,12 +952,14 @@ int io_register_zcrx(struct io_ring_ctx *ctx,
 		ret = -EFAULT;
 		goto err;
 	}
+
+	zcrx_set_ring_ctx(ifq, ctx);
 	return 0;
 err:
 	scoped_guard(mutex, &ctx->mmap_lock)
 		xa_erase(&ctx->zcrx_ctxs, id);
 ifq_free:
-	zcrx_unregister(ifq);
+	zcrx_unregister(ifq, ctx);
 	return ret;
 }
 
@@ -966,7 +989,7 @@ void io_terminate_zcrx(struct io_ring_ctx *ctx)
 			break;
 		set_zcrx_entry_mark(ctx, id);
 		id++;
-		zcrx_unregister_user(ifq);
+		zcrx_unregister_user(ifq, ctx);
 	}
 }
 
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index 75e0a4e6ef6e..76389a5dd50f 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -72,6 +72,9 @@ struct io_zcrx_ifq {
 	 */
 	struct mutex			pp_lock;
 	struct io_mapped_region		rq_region;
+
+	spinlock_t			ctx_lock;
+	struct io_ring_ctx		*master_ctx;
 };
 
 #if defined(CONFIG_IO_URING_ZCRX)
-- 
2.54.0


