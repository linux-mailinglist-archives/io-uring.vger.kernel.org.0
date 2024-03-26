Return-Path: <io-uring+bounces-1234-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46C1688CC3F
	for <lists+io-uring@lfdr.de>; Tue, 26 Mar 2024 19:46:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5B946B28B8A
	for <lists+io-uring@lfdr.de>; Tue, 26 Mar 2024 18:46:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F401E13CA8F;
	Tue, 26 Mar 2024 18:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="dHTDdOEk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E412513C3CE
	for <io-uring@vger.kernel.org>; Tue, 26 Mar 2024 18:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711478786; cv=none; b=KC8fac2emqAPyCu91gUsuinYrSjfgVnOydXjvHmpMGVoktwwP0MmZyByLh5n+WB5f2ev7hhGZ6d0Wc57XwVDcYg30kvULbfX7zHHWU96aCqt+n8Urm+TOZmzFAAIqKo0Fz3mzd3AgtTHXRK6tyN8cgjFtvbjSFWAABBOYWWoGzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711478786; c=relaxed/simple;
	bh=hqqVwUR8UBgTXC+m3PJGOrCt+4rEJaKqAkmks2x1QfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bct79eTkU2m7K6asNTXaI5kuVH0/IWfeFI88P8oh8+UHPPXLy9+iOI5r8s/LVRh1a5TLRJs6FVDylJJKiVtwziJAK90IyxozhDrCXzy7Q22UM/l9CfAsoVnMkHTZNUJk9NIS3Qf4+QkqOI2Eo+4xytibExzrm+jkvuYANxh/ZK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=dHTDdOEk; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-55b5a37acb6so1075278a12.0
        for <io-uring@vger.kernel.org>; Tue, 26 Mar 2024 11:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711478784; x=1712083584; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NSinA+cYQIpdoVYw+6926mBOgX0n0QlWpqrr0xOSIQ0=;
        b=dHTDdOEkiqi81bZ89GVI0wSA1Tb6r5locy4D2Mk2W5YB4WvGcJ9UpIB+D1gtCHyLMa
         q/7G2NknMAL6F0AwoJpgppM512cXciVms12mNzJNbZH2ZD6BrhZX5tEtOo+KNWl1jh1P
         FBivU6qD3vRQig6N2JaXVJwfKfLdEgfLTnvrnNJLZuPIcu4IcrH8q3LwsC/6yYaER06L
         EvshKK94qAZlfmY1keUypN+SRCB+pOkAR6lgA9vcGfgfXsdXe4Owyy0sdKilAkPlEkHA
         +vpwus3CDSA6xkl27N/mwBsAoz7zcZCIgibxfX2r3SUN1jUXIoM3ny3uY9+HXKa1ooGJ
         +FFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711478784; x=1712083584;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NSinA+cYQIpdoVYw+6926mBOgX0n0QlWpqrr0xOSIQ0=;
        b=q64tqH/rY5tFCO+xYc/Pe326m4CIOctTOACeN9Tua9dwHfacaPBMAR80sB8FldUUXW
         g+CUeAJ4DONfP4gel9sPgZWCc+DTMew3XXSfgd+MAB0toYwdRaHin/8Zoif0Dz0m20uL
         LdDc1LQCXI+/1f1fvoA22rUtP2gUJJtgwciKM+YPNc1uuawVzD0m8M0gs6ZUDlzZA47n
         BZoFu4rGrYaMxP9d18qwRo0ccxc081NnG4oo1zCyFI5MHvrV1L48trftc0ThK8980WLA
         9G6q2+SJtummvxe50K3Zh2aikGdg+ST07/tF8G1z3uR5tEiKyyuyM6enMY0WVBScUom1
         NS9Q==
X-Gm-Message-State: AOJu0YyfDnjObEqD1dzuVZ4Mav/xFRQWsaHQX1qzkfAyLdrTM8AOIfJr
	qh/EuLKchkK6Z2kpiwtGJNTmNdH1NovRm5LKH09c3a7F2w2YYfdlOj1dGdLFGsYjWk9M6SrD1y4
	7
X-Google-Smtp-Source: AGHT+IFx1RHyoEpiNPhE7nNWvFPVY1oZ7COplYJUI/g6yODL+1334ia+xcjg7yemg20Bt2XOesHjsA==
X-Received: by 2002:a17:902:7b8f:b0:1dd:7350:29f6 with SMTP id w15-20020a1709027b8f00b001dd735029f6mr11251596pll.3.1711478783790;
        Tue, 26 Mar 2024 11:46:23 -0700 (PDT)
Received: from m2max.thefacebook.com ([2620:10d:c090:600::1:163c])
        by smtp.gmail.com with ESMTPSA id lg4-20020a170902fb8400b001dede7dd3c7sm7152833plb.111.2024.03.26.11.46.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Mar 2024 11:46:21 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/4] io_uring: switch fallback work to io_wq_work_list
Date: Tue, 26 Mar 2024 12:42:47 -0600
Message-ID: <20240326184615.458820-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240326184615.458820-1-axboe@kernel.dk>
References: <20240326184615.458820-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Just like what was done for deferred task_work, convert the fallback
task_work to a normal io_wq_work_list.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  2 +-
 io_uring/io_uring.c            | 24 +++++++++++++++++++-----
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index e51bf15196e4..2bc253f8147d 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -400,7 +400,7 @@ struct io_ring_ctx {
 	struct mm_struct		*mm_account;
 
 	/* ctx exit and cancelation */
-	struct llist_head		fallback_llist;
+	struct io_wq_work_list		fallback_list;
 	struct delayed_work		fallback_work;
 	struct work_struct		exit_work;
 	struct list_head		tctx_list;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 9c06911077db..8d7138eaa921 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -243,14 +243,22 @@ static __cold void io_fallback_req_func(struct work_struct *work)
 {
 	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx,
 						fallback_work.work);
-	struct llist_node *node = llist_del_all(&ctx->fallback_llist);
-	struct io_kiocb *req, *tmp;
+	struct io_wq_work_node *node;
 	struct io_tw_state ts = {};
+	struct io_kiocb *req;
+
+	spin_lock_irq(&ctx->work_lock);
+	node = ctx->fallback_list.first;
+	INIT_WQ_LIST(&ctx->fallback_list);
+	spin_unlock_irq(&ctx->work_lock);
 
 	percpu_ref_get(&ctx->refs);
 	mutex_lock(&ctx->uring_lock);
-	llist_for_each_entry_safe(req, tmp, node, io_task_work.llist_node)
+	while (node) {
+		req = container_of(node, struct io_kiocb, io_task_work.node);
+		node = node->next;
 		req->io_task_work.func(req, &ts);
+	}
 	io_submit_flush_completions(ctx);
 	mutex_unlock(&ctx->uring_lock);
 	percpu_ref_put(&ctx->refs);
@@ -1167,6 +1175,9 @@ static __cold void io_fallback_tw(struct io_uring_task *tctx, bool sync)
 	struct io_kiocb *req;
 
 	while (node) {
+		unsigned long flags;
+		bool do_wake;
+
 		req = container_of(node, struct io_kiocb, io_task_work.llist_node);
 		node = node->next;
 		if (sync && last_ctx != req->ctx) {
@@ -1177,8 +1188,11 @@ static __cold void io_fallback_tw(struct io_uring_task *tctx, bool sync)
 			last_ctx = req->ctx;
 			percpu_ref_get(&last_ctx->refs);
 		}
-		if (llist_add(&req->io_task_work.llist_node,
-			      &req->ctx->fallback_llist))
+		spin_lock_irqsave(&req->ctx->work_lock, flags);
+		do_wake = wq_list_empty(&req->ctx->fallback_list);
+		wq_list_add_tail(&req->io_task_work.node, &req->ctx->fallback_list);
+		spin_unlock_irqrestore(&req->ctx->work_lock, flags);
+		if (do_wake)
 			schedule_delayed_work(&req->ctx->fallback_work, 1);
 	}
 
-- 
2.43.0


