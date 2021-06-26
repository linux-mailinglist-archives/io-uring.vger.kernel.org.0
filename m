Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BADC3B501C
	for <lists+io-uring@lfdr.de>; Sat, 26 Jun 2021 22:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbhFZUnm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 26 Jun 2021 16:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbhFZUnl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 26 Jun 2021 16:43:41 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F1E6C061767
        for <io-uring@vger.kernel.org>; Sat, 26 Jun 2021 13:41:17 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id u11so14891217wrw.11
        for <io-uring@vger.kernel.org>; Sat, 26 Jun 2021 13:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=SaM6OKdIF9QBUAZi5grLyvVHu9k0AbCBVKVpz6yEne0=;
        b=kpmlGthlrphbPPQgKBlWr/dNuRbDY01Tz/I4gSdtsvZQIPwI3a2JzkXvV48aSqjBnk
         9ibmTjeb9yTfU3q0Z8j3Mp7ucWhMp7m1gpA6ONqMKabhD5M2CmuOAWX/VBvMJJfwL4QU
         5kaNgda2Y0NvxwXzXkMkfVpZA5PHsH8EoA5AIysIUdn46rzvNsBS1lKMHHKf+hE6Na+2
         QgdMtYZ4gGqt1i7HWl8bv0+VbktQgagYViuyCezhj6O6rwFR3KNfheD1koiqotSXAtJd
         eQ3Jt/scY4R5mLetRdzqAi12m5nW1HPSkLJ20RdnUS2/FEdAmaVWpSOo8Sk0hSU8IWRz
         ItgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SaM6OKdIF9QBUAZi5grLyvVHu9k0AbCBVKVpz6yEne0=;
        b=t8t/i8drR7ryvo+AG9voXGM2JYwT0GLRz06pQwtyzCQJCOuEJCcJY5T0zORkPEh5Qt
         sYhRbG+v/IYxrDR1GiTqtDbSL4K211NWKvtB204so5l4qIbo5p6zJ4LNWxGpPExHfSaD
         38G5ZvFsuLGP3Qg5VUd1F72raT3Lg9myKjLT/z/tEQGpqiONVxUemQC68SdcczNbMe9o
         4f6JMzel4clOAQxBrtVBMW5g/n3drXi+r8omNuHTO2YlfkZrKTxPt7v0VvVflBQ9k3E8
         kQv5swM2y7MigBblTi8mHIXJrj5eesoCOsm5ZutgajLIzl3UHgRt3+mPG+/XNfT5qbjE
         drag==
X-Gm-Message-State: AOAM533WOferIVBCP5brTbSDtl3cUOgH83KPfVsVLaP9XDmX52agK0M9
        ooUyzeMSJ8W4KPaZpN8Ju9sMX8wJC5ACpA==
X-Google-Smtp-Source: ABdhPJzMXlgUXTxFKns8YPSqeXtF8k2LVUA4O1ekrbGyNko2rc4bcY1sr+QmiCXpUrpwwKgzLxkVRw==
X-Received: by 2002:a5d:6daf:: with SMTP id u15mr18668809wrs.400.1624740075762;
        Sat, 26 Jun 2021 13:41:15 -0700 (PDT)
Received: from localhost.localdomain ([148.252.129.84])
        by smtp.gmail.com with ESMTPSA id b9sm11272613wrh.81.2021.06.26.13.41.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Jun 2021 13:41:15 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5/6] io_uring: refactor io_submit_flush_completions
Date:   Sat, 26 Jun 2021 21:40:48 +0100
Message-Id: <ad85512e12bd3a20d521e9782750300970e5afc8.1624739600.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1624739600.git.asml.silence@gmail.com>
References: <cover.1624739600.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't init req_batch before we actually need it. Also, add a small clean
up for req declaration.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4dd2213f5454..873cfd4a8761 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2161,22 +2161,22 @@ static void io_submit_flush_completions(struct io_ring_ctx *ctx)
 {
 	struct io_comp_state *cs = &ctx->submit_state.comp;
 	int i, nr = cs->nr;
-	struct io_kiocb *req;
 	struct req_batch rb;
 
-	io_init_req_batch(&rb);
 	spin_lock_irq(&ctx->completion_lock);
 	for (i = 0; i < nr; i++) {
-		req = cs->reqs[i];
+		struct io_kiocb *req = cs->reqs[i];
+
 		__io_cqring_fill_event(ctx, req->user_data, req->result,
 					req->compl.cflags);
 	}
 	io_commit_cqring(ctx);
 	spin_unlock_irq(&ctx->completion_lock);
-
 	io_cqring_ev_posted(ctx);
+
+	io_init_req_batch(&rb);
 	for (i = 0; i < nr; i++) {
-		req = cs->reqs[i];
+		struct io_kiocb *req = cs->reqs[i];
 
 		/* submission and completion refs */
 		if (req_ref_sub_and_test(req, 2))
-- 
2.32.0

