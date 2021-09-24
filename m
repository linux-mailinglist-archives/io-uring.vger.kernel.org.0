Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7D044178E3
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 18:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245559AbhIXQiA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 12:38:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343577AbhIXQhk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 12:37:40 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EE42C0613B6
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:32:58 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id dj4so38330044edb.5
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=26wKf7Y0pJ6Nu9hS6bgsKsEqDinr+FiGOMwmvdvnNP0=;
        b=FDwVwo+piHXZ19olw4CTHlLl30Sg8t5N23q4OvDGdRl7kNU0ZFMsvHZhEHSUa8vxed
         3RaK2C3YqFnjj/EBn/nDeBDsrwJqzGKXjmSn/6JVjZHzrFwUfn3FB+UReY3R1hWlMyxo
         X6Tw1218ipTsNvIOpcAblt2wRFj368SnG3Xtw0P505lskP3idnXUMxZSlqD4nyOS0qRC
         Bzokyn/TsX7/WJlNrgbrZfgsE1YTYw90EqJGM6xH6FKyNESq67h2XaPmf6/YrRAVYokC
         vD3vUxAy45hjfVOhoyQ20NJgD4N3adSr0tKEnsz6y+VEiWMbrGjvV5ISlkfJbwsh6kxK
         h0NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=26wKf7Y0pJ6Nu9hS6bgsKsEqDinr+FiGOMwmvdvnNP0=;
        b=ZR8qI/0cq6O/IFqVWBArvO5oB6l+4Hf+fDHj3TVwPYuPcrzT4XNmFneF3C9FG2V+W6
         Q2IKnEXbukQu0RWwNOymnljdYXgIrc7MMIdlHufOFeTKsUy/GLYmKajSokPVFjYL96hU
         6ltSCB22aBjeK9BmFIL74OPhJ2Zazm03emYq6dET5Sk/E9z3WZswtArjwdq0yJnUlFiq
         +JwyXALLoBhAxzaIoVMlweTramIN5ABAEtZ7D609fzqUDHceNUFsZtu0cApVWbUy5rpN
         2/hR83oNld/L5vPMLvRRNFbt2HtV5sJYm4dSc2rXlIUT0g6O3EIKeY59byv90XjB467S
         N32w==
X-Gm-Message-State: AOAM533P0o9nXQ7zHt8z1vCwmiaPMEkV/66eJayGwnzqk5YkCd8XtMBR
        MO08ldcqH7m9HoYckkVlDOYLQ1mwwjw=
X-Google-Smtp-Source: ABdhPJz2k/DBWnHzDMjeSXPZkri9G7unWh6Dt3bt5aQ/TAgUU8X42lJRQHAQVNBjLm3/FrOFVcRhpg==
X-Received: by 2002:a17:906:fa05:: with SMTP id lo5mr11669815ejb.204.1632501177161;
        Fri, 24 Sep 2021 09:32:57 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id w10sm6167021eds.30.2021.09.24.09.32.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 09:32:56 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 11/23] io_uring: convert iopoll_completed to store_release
Date:   Fri, 24 Sep 2021 17:31:49 +0100
Message-Id: <9a07690788f5a6e9bf91ea6fbaac1238f1d9343f.1632500264.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632500264.git.asml.silence@gmail.com>
References: <cover.1632500264.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Convert explicit barrier around iopoll_completed to smp_load_acquire()
and smp_store_release(). Similar on the callback side, but replaces a
single smp_rmb() with per-request smp_load_acquire(), neither imply any
extra CPU ordering for x86. Use READ_ONCE as usual where it doesn't
matter.

Use it to move filling CQEs by iopoll earlier, that will be necessary
to avoid traversing the list one extra time in the future.

Suggested-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e1c8374954fc..e5d42ca45bce 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2431,17 +2431,11 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, struct list_head *done)
 	struct req_batch rb;
 	struct io_kiocb *req;
 
-	/* order with ->result store in io_complete_rw_iopoll() */
-	smp_rmb();
-
 	io_init_req_batch(&rb);
 	while (!list_empty(done)) {
 		req = list_first_entry(done, struct io_kiocb, inflight_entry);
 		list_del(&req->inflight_entry);
 
-		__io_cqring_fill_event(ctx, req->user_data, req->result,
-					io_put_rw_kbuf(req));
-
 		if (req_ref_put_and_test(req))
 			io_req_free_batch(&rb, req, &ctx->submit_state);
 	}
@@ -2495,8 +2489,12 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 	wq_list_for_each_resume(pos, prev) {
 		struct io_kiocb *req = container_of(pos, struct io_kiocb, comp_list);
 
-		if (!READ_ONCE(req->iopoll_completed))
+		/* order with io_complete_rw_iopoll(), e.g. ->result updates */
+		if (!smp_load_acquire(&req->iopoll_completed))
 			break;
+		__io_cqring_fill_event(ctx, req->user_data, req->result,
+				       io_put_rw_kbuf(req));
+
 		list_add_tail(&req->inflight_entry, &done);
 		nr_events++;
 	}
@@ -2709,10 +2707,9 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
 		}
 	}
 
-	WRITE_ONCE(req->result, res);
-	/* order with io_iopoll_complete() checking ->result */
-	smp_wmb();
-	WRITE_ONCE(req->iopoll_completed, 1);
+	req->result = res;
+	/* order with io_iopoll_complete() checking ->iopoll_completed */
+	smp_store_release(&req->iopoll_completed, 1);
 }
 
 /*
-- 
2.33.0

