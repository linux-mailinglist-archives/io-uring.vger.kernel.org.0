Return-Path: <io-uring+bounces-1444-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E446289B4CE
	for <lists+io-uring@lfdr.de>; Mon,  8 Apr 2024 01:55:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1420F1C20A28
	for <lists+io-uring@lfdr.de>; Sun,  7 Apr 2024 23:55:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D508144C6A;
	Sun,  7 Apr 2024 23:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hNR0xSbd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB6143AC5
	for <io-uring@vger.kernel.org>; Sun,  7 Apr 2024 23:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712534107; cv=none; b=og/aMtG45EoEkBWpm734KNu/wc/7+ULkWJwBGAJ5QgzCCRd4/IJFZVXL4w646qRoZcPdmInyrnW1hTYVg73tqp2GOLGPmHN+IkrUODr2aNnmU7h+g1eL8BdQO1XaAuk4PEXf6M5wHVHsDXnx3yULDCRSOkbpw/8N7gme/3DCLR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712534107; c=relaxed/simple;
	bh=ibQhQkYR6ZKgGp/rrp/wSsi6oPKxgYSIesY2ePMaNR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sY2IbYzQL/6VZ4fZRny5T+gbC5n0uF8/11pt2SEaySfheUzSAzVfNCWqKeTw3JzozeLXJ0aEX+k5MFGFicTpnTwpuHeWcq9/4elZxmAypZXEgbUlES+DWCNgIe6wcMrWZpf4C7gqa2QUPrV6eBf2lqlp/JtLh4fuGTEosckySMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hNR0xSbd; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3455ff1339dso795124f8f.0
        for <io-uring@vger.kernel.org>; Sun, 07 Apr 2024 16:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712534104; x=1713138904; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e3l5Vz2hQAey2d1GzWNMHldQv74X6F729DYYka07Lvw=;
        b=hNR0xSbdZuC72zxm6p0HbPAC95cV8li98M0rXdZ1fTHrtpkuQ4Oz5dlHrSKi4xzCvE
         n1yYm2Ta3J0rjDUbdUVWhMLdvNBeik/BVncXpCKzTJCa95ZKM8jMZO9LYSiroEwdxUH3
         S7h2tTTWh2+vcxjY94JYdUhC0AJprb1eIfR1twjz9cRn0irHltVI/N9erApAUApaDpNo
         f3BcKQuDrIyld07ubRb4d6nqlHGIEBriwc6yEXHgnoZgHYjFOaWyXakYC7IEoidtoXsE
         fHlY9g4utcIi95qenj88qP6ROwGsYEjgWtQvs2EOlGH/daAXXByXVqeXYuWfCR7TvfX9
         m/wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712534104; x=1713138904;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e3l5Vz2hQAey2d1GzWNMHldQv74X6F729DYYka07Lvw=;
        b=uR4I9LdxVRfJEmwVeFCJB03AwewBxvpE7LW+3i1+/sYtvVy3e1yQ4V6nS/bcZoQgzh
         3Rcw0rqwGHqXOur87VDHwZXi5zkX5l8P40ZuuP9g8GRCliKjxPJGtWq/LHyn9KISvGet
         Z/0D7dTXRJH1vA2tnDvGvovBfOcmwA5o8aJtkCe4RXmDd1sWJZXvgfhsm+uiOa+IkU7g
         ZzqrUZXc3MTXr6d8N2A+pWufs9zxM/QOFqIt79IgVDcQT8zH/87dgOMAFDx1u20Drd+5
         Lj82b1CO1OQeD2GVgi0daJwOdCPB6kaILg2rm6eY8YfJYqtZDGlboP84Ra6wXvg5XKqC
         eiJg==
X-Gm-Message-State: AOJu0YxWE5ihtV0KgY7xtChQmHg8NRPIGmtLOvuKu5ka7Sf10c4WdwNU
	CiHNF4d2JjfhtD+7TOqI8yfoN+lYRLy1mGatalAjVvrbPaNSSiaShDZVpVIo
X-Google-Smtp-Source: AGHT+IFpcssxvjl+JBE/tD0oBmJI+bSMyz0Wv9R55hLn+IKKfpQUOWBSi/dzpcapszbTBZMdZtRZYA==
X-Received: by 2002:a05:6000:1202:b0:343:e152:4c43 with SMTP id e2-20020a056000120200b00343e1524c43mr5459510wrx.2.1712534103637;
        Sun, 07 Apr 2024 16:55:03 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.235.79])
        by smtp.gmail.com with ESMTPSA id je4-20020a05600c1f8400b004149536479esm11302917wmb.12.2024.04.07.16.55.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Apr 2024 16:55:03 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH for-next 2/3] io_uring/net: get rid of io_notif_complete_tw_ext
Date: Mon,  8 Apr 2024 00:54:56 +0100
Message-ID: <025a124a5e20e2474a57e2f04f16c422eb83063c.1712534031.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1712534031.git.asml.silence@gmail.com>
References: <cover.1712534031.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_notif_complete_tw_ext() can be removed and combined with
io_notif_complete_tw to make it simpler without sacrificing
anything.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c   | 10 +++++-----
 io_uring/notif.c | 18 +++++-------------
 io_uring/notif.h |  6 ++++--
 3 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 27b853033d6f..f97014566b52 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1019,8 +1019,11 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		if (zc->flags & ~IO_ZC_FLAGS_VALID)
 			return -EINVAL;
 		if (zc->flags & IORING_SEND_ZC_REPORT_USAGE) {
-			io_notif_set_extended(notif);
-			io_notif_to_data(notif)->zc_report = true;
+			struct io_notif_data *nd = io_notif_to_data(notif);
+
+			nd->zc_report = true;
+			nd->zc_used = false;
+			nd->zc_copied = false;
 		}
 	}
 
@@ -1129,7 +1132,6 @@ static int io_send_zc_import(struct io_kiocb *req, struct io_async_msghdr *kmsg)
 			return ret;
 		kmsg->msg.sg_from_iter = io_sg_from_iter;
 	} else {
-		io_notif_set_extended(sr->notif);
 		ret = import_ubuf(ITER_SOURCE, sr->buf, sr->len, &kmsg->msg.msg_iter);
 		if (unlikely(ret))
 			return ret;
@@ -1218,8 +1220,6 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 	unsigned flags;
 	int ret, min_ret = 0;
 
-	io_notif_set_extended(sr->notif);
-
 	sock = sock_from_file(req->file);
 	if (unlikely(!sock))
 		return -ENOTSOCK;
diff --git a/io_uring/notif.c b/io_uring/notif.c
index 47ff2da8c421..b561bd763435 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -9,12 +9,12 @@
 #include "notif.h"
 #include "rsrc.h"
 
-static void io_notif_complete_tw_ext(struct io_kiocb *notif, struct io_tw_state *ts)
+void io_notif_tw_complete(struct io_kiocb *notif, struct io_tw_state *ts)
 {
 	struct io_notif_data *nd = io_notif_to_data(notif);
 	struct io_ring_ctx *ctx = notif->ctx;
 
-	if (nd->zc_report && (nd->zc_copied || !nd->zc_used))
+	if (unlikely(nd->zc_report) && (nd->zc_copied || !nd->zc_used))
 		notif->cqe.res |= IORING_NOTIF_USAGE_ZC_COPIED;
 
 	if (nd->account_pages && ctx->user) {
@@ -37,17 +37,10 @@ static void io_tx_ubuf_callback(struct sk_buff *skb, struct ubuf_info *uarg,
 			WRITE_ONCE(nd->zc_copied, true);
 	}
 
-	if (refcount_dec_and_test(&uarg->refcnt))
+	if (refcount_dec_and_test(&uarg->refcnt)) {
+		notif->io_task_work.func = io_notif_tw_complete;
 		__io_req_task_work_add(notif, IOU_F_TWQ_LAZY_WAKE);
-}
-
-void io_notif_set_extended(struct io_kiocb *notif)
-{
-	struct io_notif_data *nd = io_notif_to_data(notif);
-
-	nd->zc_used = false;
-	nd->zc_copied = false;
-	notif->io_task_work.func = io_notif_complete_tw_ext;
+	}
 }
 
 struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
@@ -64,7 +57,6 @@ struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
 	notif->task = current;
 	io_get_task_refs(1);
 	notif->rsrc_node = NULL;
-	notif->io_task_work.func = io_req_task_complete;
 
 	nd = io_notif_to_data(notif);
 	nd->zc_report = false;
diff --git a/io_uring/notif.h b/io_uring/notif.h
index 86d32bd9f856..52e124a9957c 100644
--- a/io_uring/notif.h
+++ b/io_uring/notif.h
@@ -20,7 +20,7 @@ struct io_notif_data {
 };
 
 struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx);
-void io_notif_set_extended(struct io_kiocb *notif);
+void io_notif_tw_complete(struct io_kiocb *notif, struct io_tw_state *ts);
 
 static inline struct io_notif_data *io_notif_to_data(struct io_kiocb *notif)
 {
@@ -33,8 +33,10 @@ static inline void io_notif_flush(struct io_kiocb *notif)
 	struct io_notif_data *nd = io_notif_to_data(notif);
 
 	/* drop slot's master ref */
-	if (refcount_dec_and_test(&nd->uarg.refcnt))
+	if (refcount_dec_and_test(&nd->uarg.refcnt)) {
+		notif->io_task_work.func = io_notif_tw_complete;
 		__io_req_task_work_add(notif, IOU_F_TWQ_LAZY_WAKE);
+	}
 }
 
 static inline int io_notif_account_mem(struct io_kiocb *notif, unsigned len)
-- 
2.44.0


