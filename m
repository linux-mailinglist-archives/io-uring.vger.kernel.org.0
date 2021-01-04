Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA262EA0DA
	for <lists+io-uring@lfdr.de>; Tue,  5 Jan 2021 00:32:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727136AbhADXb7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jan 2021 18:31:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726917AbhADXb7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jan 2021 18:31:59 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7831C061793
        for <io-uring@vger.kernel.org>; Mon,  4 Jan 2021 15:31:18 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id r4so758643wmh.5
        for <io-uring@vger.kernel.org>; Mon, 04 Jan 2021 15:31:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=biohuaz8qHAl2bwblz3F9N6jQTPf4tFievc4sERx/QQ=;
        b=NUCatBEVuWb1vFuqnqe8+XDRjAmZx6vYarOQioxLYGru3sYMe2c8Eh5u5qumRK+dC0
         BpIIxCoevhYIuPA/cRAZCRg0m32JTYtFLwYrMiiW2x/dBdSktkHyaPJXvjTIOAv/KOSx
         wn+oPS9aHoRZM6ji8itmwe2GLqFm35O/gI+BYkQTl1elAACwdTEMpW5wOl7/eFjrMtxC
         ad6Lh6tZfj2MsvX10efheMWYiOHb7eYGM8VZK4jwOE3lCm2Mw+v8WKgqDfJILS5f5OAv
         7QntRW7Y0GokPd+TjFk/87iUt7JjhYe4HvBPTKTE13yf+tZbbDcYaP7O35IbMDV7kqK0
         m9UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=biohuaz8qHAl2bwblz3F9N6jQTPf4tFievc4sERx/QQ=;
        b=K42khyH5m3F5Q5mZQKuNU6+NuRFNB23SXZ5WCI+9an4Ocz5ExA27UVLabzt7F9qO3C
         Ib6Hi7JtB2UDeyb4JpIBcB2Ftooo+RN5RY9mjGvxj86rHrrW8vieqb/g1Orvu1zQ56it
         APfDSa62AKWF6FXhKXqFqaZE6mnhccwtbPq3JMtko9MtFNoRCP6UzutNXKFTnL9GeEI/
         JQm3nKNld3NbaxaFDVLtWQaHrPBVL3TPOfys/3+hUojLY0kNzTOJ2uJHpxOpLqB5V12z
         J+Z4rU+zowVMiBF1KHOYuR9AU/V76q2XXZUMDnuG4RCMszsFhpU43lTgspn8iqQRkiUg
         tb0A==
X-Gm-Message-State: AOAM530BvVnK5wix8i2f8mpcxY+hF1O9h/07s8/uqrug/p8DY4iZFL+w
        IOS3hxL80gPklgzNipd4tbzuId47eQzY8A==
X-Google-Smtp-Source: ABdhPJy+OI4SZYZMJFIG7n00BFahtZ1oojYK1rFEPCx1Y8svPgOomZ2+JV609Fwt1JbnHDVyEZi8aQ==
X-Received: by 2002:a1c:9acb:: with SMTP id c194mr537032wme.43.1609792966027;
        Mon, 04 Jan 2021 12:42:46 -0800 (PST)
Received: from localhost.localdomain ([85.255.233.205])
        by smtp.gmail.com with ESMTPSA id o13sm73525006wrh.88.2021.01.04.12.42.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 12:42:45 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH -v2 2/2] io_uring: cancel more aggressively in exit_work
Date:   Mon,  4 Jan 2021 20:39:08 +0000
Message-Id: <f241b61d3d04b668f186af0cd465b04699274696.1609792653.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1609792653.git.asml.silence@gmail.com>
References: <cover.1609792653.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

While io_ring_exit_work() is running new requests of all sorts may be
issued, so it should do a bit more to cancel them, otherwise they may
just get stuck. e.g. in io-wq, in poll lists, etc.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 85de42c42433..5bccb235271f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -992,6 +992,9 @@ enum io_mem_account {
 	ACCT_PINNED,
 };
 
+static void __io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
+					    struct task_struct *task);
+
 static void destroy_fixed_file_ref_node(struct fixed_file_ref_node *ref_node);
 static struct fixed_file_ref_node *alloc_fixed_file_ref_node(
 			struct io_ring_ctx *ctx);
@@ -8675,7 +8678,7 @@ static void io_ring_exit_work(struct work_struct *work)
 	 * as nobody else will be looking for them.
 	 */
 	do {
-		io_iopoll_try_reap_events(ctx);
+		__io_uring_cancel_task_requests(ctx, NULL);
 	} while (!wait_for_completion_timeout(&ctx->ref_comp, HZ/20));
 	io_ring_ctx_free(ctx);
 }
@@ -8830,9 +8833,11 @@ static void __io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 		enum io_wq_cancel cret;
 		bool ret = false;
 
-		cret = io_wq_cancel_cb(ctx->io_wq, io_cancel_task_cb, &cancel, true);
-		if (cret != IO_WQ_CANCEL_NOTFOUND)
-			ret = true;
+		if (ctx->io_wq) {
+			cret = io_wq_cancel_cb(ctx->io_wq, io_cancel_task_cb,
+					       &cancel, true);
+			ret |= (cret != IO_WQ_CANCEL_NOTFOUND);
+		}
 
 		/* SQPOLL thread does its own polling */
 		if (!(ctx->flags & IORING_SETUP_SQPOLL)) {
-- 
2.24.0

