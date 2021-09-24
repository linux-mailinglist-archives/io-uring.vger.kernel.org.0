Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C92A8417CB3
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 23:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346621AbhIXVCm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 17:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346683AbhIXVCd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 17:02:33 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2616DC061571
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 14:01:00 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id v18so5596415edc.11
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 14:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HnMU5x+RjAM/5Atw/EqC853HmVYmYe/pn8wOY/yrrHc=;
        b=I5V6zQcmToNbUVgHUfRHp1xwvCXyZMGXURRSYtKCHgGfG7gMRMsHWQP+i6mT2yA7rQ
         lbyLDMgQsbWji3/5D4zNPwPFiu0qnUFiuJ48hzvNQ/MV1s81xJ3krS/NPyiwRIlf0iPY
         HQG/YXwLBzLeqzJV6Hcabzb7uANqmvWheHozNbsxYrcmC9+aS4smxJwaMzyMH+8SzIWE
         /gZu4G+GyAGzN/VY3eOfsq4T8h8kkGrXJ9cGnNCsYoFVmqNrSzmd7RIiQKaY+wBr2oiv
         NCr6hYNmAlueDO4wFj+EBOm5XPi23B4FIpwYnyPPZo4VXvcJCigc1zeg97ffi1jIEhS6
         VM8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HnMU5x+RjAM/5Atw/EqC853HmVYmYe/pn8wOY/yrrHc=;
        b=NYZuzAyszc2S+qPNKKMjb4kw3+5wtoYCZXJXGD8SGp09mWYTfFbDe3HENZyLOOpkWY
         JXRV1yRcfB3CYuDHnadetAwc9in2CvAXRD8xPl10jVLFItmMTDTygAxOQ9WvDZ7No6Fw
         VM4laA+lzFZDDaaDmRauQujituT4YdoaSyLLkJv+R+4WTeeKO/YJwKR7rjorbZritboA
         gcGBIc9JQWZOP3m/Pftofu8i+kfzy3PiLddHz+lTpACF51Z26YnNM/ziBbfF4aa7BSBw
         xVLJobxskZQok86MVzOVlM1Y1TQ8mYLuqfbhk+ezp0+/3l4JYa6N2kLZ3GoA7SHTiJvM
         NK3g==
X-Gm-Message-State: AOAM531+IdgGcO+xErk+5v+EshLpU96WlqcYXa+iCtBY9FG+TU8v/Dwj
        5rvh/36fafU2erYbAGh7cvPlIDcrfQQ=
X-Google-Smtp-Source: ABdhPJw7/gmlYHca/wTPSt1QpLojE0fTuuPv+WKJRq01wQA34xMsdynEoESox04iWXITE8FJEiOMKQ==
X-Received: by 2002:aa7:d592:: with SMTP id r18mr7560185edq.172.1632517258763;
        Fri, 24 Sep 2021 14:00:58 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id bc4sm6276048edb.18.2021.09.24.14.00.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 14:00:58 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 11/24] io_uring: convert iopoll_completed to store_release
Date:   Fri, 24 Sep 2021 21:59:51 +0100
Message-Id: <8bd663cb15efdc72d6247c38ee810964e744a450.1632516769.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632516769.git.asml.silence@gmail.com>
References: <cover.1632516769.git.asml.silence@gmail.com>
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
index ad8af05af4bc..cf7fcbdb5563 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2434,17 +2434,11 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, struct list_head *done)
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
@@ -2498,8 +2492,12 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
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
@@ -2712,10 +2710,9 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
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

