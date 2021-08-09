Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 629DD3E454C
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 14:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235359AbhHIMFy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 08:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235329AbhHIMFv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 08:05:51 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46179C0613D3
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 05:05:30 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id b128so10421619wmb.4
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 05:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=XOmKk0W8IQcm9ErXNdpy7hpHf296KUrM/k27ihxs/Gs=;
        b=VlfgJB2eauiOJuZdSHmBX5T0zAwdE36Lb56SeCbRPwuMfapscOZKXWn9dLG4mDwE3t
         bFQ+PJXMDTIr3MgZQZuTFjI5KP37pCiTN2FnNH68J8FPKPrpGNJ0D6AkJuGPouSEMY+x
         e7lEZrBuenoYyWKzgJ2PsxaBG2u6dHD34l4Xim3FfYmh7izZd7/biMuPRToBMjlxVT6J
         FGo+Rygl8a1xFS+T324lZaHvwSz6zNz59FA5LwXtCjA55miDe/eh9BzIrjsEGEi7Eqmz
         cfRBNrjuZBMWrPH3dbpHN5wQKdYn5QvSki9YboQx4p6/TgMfwZPZgZ8tJHGmahDQzgy6
         Z/og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XOmKk0W8IQcm9ErXNdpy7hpHf296KUrM/k27ihxs/Gs=;
        b=Vz8UmuDZ1Lb58srr2831hPVOl9nHhez4mAynR6vfze2aaVL+/IZPk4QK98hFbyCc2/
         a/PNqr0DaFSuVz1mOkTAvTFaaAaPW8T2lfyIJ+kAvP2CqLC/ktWzXUUkAPapkveZYMsQ
         9TOp0Nq6iwGe9oxIG1fZiIBBV0UemhF50LLpiK6dOnfv2FAPPieuM59u7pi7zjJnomoK
         SiP1p/5d6UUTgq1ocyJLPWihkT89OznjkgWd98AfEdUY3b6GPRa22j+KrMZmAZ6kOg6Z
         t2XrpqWPAwXTOrSF0iGPsqZT81aMFs8jFh4D3BzxlebfKG7Yl1L7jQy+p1CfiQTUo6U/
         2dtA==
X-Gm-Message-State: AOAM531Xy/lLInw+6BxU4CJpN7DpekDFHALUzvLRj8pyiacTpfZbnewY
        yFbKGbit9kIc3y+iA3beJT2xzF8sJl0=
X-Google-Smtp-Source: ABdhPJzG6LD8uqJXbO66BLgMZ2z3ZfhiUayEcuyFn7/D1GpPVcKq0OEilkh+I4BbC0mGHSxV/QiTdw==
X-Received: by 2002:a1c:9dd5:: with SMTP id g204mr7696872wme.74.1628510728977;
        Mon, 09 Aug 2021 05:05:28 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.119])
        by smtp.gmail.com with ESMTPSA id g35sm4757062wmp.9.2021.08.09.05.05.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 05:05:28 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 28/28] io_uring: inline io_poll_remove_waitqs
Date:   Mon,  9 Aug 2021 13:04:28 +0100
Message-Id: <48213aa32bacf8fe7091711a1eff0abd184cff3b.1628471125.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628471125.git.asml.silence@gmail.com>
References: <cover.1628471125.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Inline io_poll_remove_waitqs() into its only user and clean it up.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9070b7cbd1c3..f6fa635b3ab6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1066,7 +1066,6 @@ static void io_rsrc_put_work(struct work_struct *work);
 
 static void io_req_task_queue(struct io_kiocb *req);
 static void io_submit_flush_completions(struct io_ring_ctx *ctx);
-static bool io_poll_remove_waitqs(struct io_kiocb *req);
 static int io_req_prep_async(struct io_kiocb *req);
 
 static struct kmem_cache *req_cachep;
@@ -5267,34 +5266,24 @@ static bool __io_poll_remove_one(struct io_kiocb *req,
 	return do_complete;
 }
 
-static bool io_poll_remove_waitqs(struct io_kiocb *req)
+static bool io_poll_remove_one(struct io_kiocb *req)
 	__must_hold(&req->ctx->completion_lock)
 {
+	int refs;
 	bool do_complete;
 
 	io_poll_remove_double(req);
 	do_complete = __io_poll_remove_one(req, io_poll_get_single(req), true);
 
-	if (req->opcode != IORING_OP_POLL_ADD && do_complete) {
-		/* non-poll requests have submit ref still */
-		req_ref_put(req);
-	}
-	return do_complete;
-}
-
-static bool io_poll_remove_one(struct io_kiocb *req)
-	__must_hold(&req->ctx->completion_lock)
-{
-	bool do_complete;
-
-	do_complete = io_poll_remove_waitqs(req);
 	if (do_complete) {
 		io_cqring_fill_event(req->ctx, req->user_data, -ECANCELED, 0);
 		io_commit_cqring(req->ctx);
 		req_set_fail(req);
-		io_put_req_deferred(req, 1);
-	}
 
+		/* non-poll requests have submit ref still */
+		refs = 1 + (req->opcode != IORING_OP_POLL_ADD);
+		io_put_req_deferred(req, refs);
+	}
 	return do_complete;
 }
 
-- 
2.32.0

