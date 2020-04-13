Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 309201A6B52
	for <lists+io-uring@lfdr.de>; Mon, 13 Apr 2020 19:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732761AbgDMRWG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Apr 2020 13:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732579AbgDMRWF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Apr 2020 13:22:05 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8963FC0A3BDC
        for <io-uring@vger.kernel.org>; Mon, 13 Apr 2020 10:22:05 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id n13so4716964pgp.11
        for <io-uring@vger.kernel.org>; Mon, 13 Apr 2020 10:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5HJ6ouZMdSCRjf2fg2IPrnjvRcjz9mtS/Eh5BN/XWUY=;
        b=gfeo0mKFD4qG87ZZ1Ou/F1c016OxO1I53PKbRg/Qn4zjPay46y3/lFXXbHlMaWn6Ut
         zkrbymYCsw7DCCU5WGiBsngiuSDtEJ0wUgAbLd1I3rK3DQsXfeOyXN9TdCu5+clZbxne
         alWjhqnAn8kHq85bzYp6x97yVBc8/khSR6v6e/Lia8+bYQceexs4sF10aTMgiYTzGeKN
         3wMkCR8dEQABR7ZBoGc+u6sEAMZMljtRcH/XQcyFTjezPQkxLHMnivi8x19l13Ql5Hjj
         VjnHfrrsVy9MxmLnkg7B4WuBQLivV1bFsHQqMuAv0oWDBCtIVe6tUkOcwqyeCRdF+cXW
         fmSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5HJ6ouZMdSCRjf2fg2IPrnjvRcjz9mtS/Eh5BN/XWUY=;
        b=VrJsBHIDWTGts1wjP83ioAmV4rndvEdAgXxy1TkfmfS4PY47TdVNJB5bIQjjfT6b0L
         b7mUQzvj/3+b4iAydVu27nDU2XHTJDVnpJurhVA2KD6ordEr6dLADOIPIRCq3FGJ4PI2
         e/xZw9uTSaMqQ8J9Lm04gl0Zox+aEahJBh/2wrBwecB0WdGQAS8SPcA+5WraMOzZmwlk
         t24B42R47gu1iAQ43tOnzxwtSTXWyCb4ca0r1soJQaysxR9ckQLPAwJGFz9psb45mmmZ
         lNk2hQA+0SDWYLFj9U5K+AYN/IbzGJ9rN+IC199Rr5qmz1IdX1uOI+7BfEQGgkNzpEgg
         L65Q==
X-Gm-Message-State: AGi0PuaHaIO6OcL0jlmKSyu208c5jeBwsMflFQ2+WkVP5nHoM3PdSprs
        g0/bfg2UaYAvAWkY7McqLvyCHZtb+ajAcg==
X-Google-Smtp-Source: APiQypL58sSblmGAlNhLzbb/Gfk28X34eL/6UN+1zP/kS/GXC1A86I4XDRyd5Bt488NlWLV4SpjBgg==
X-Received: by 2002:a62:ce08:: with SMTP id y8mr13427382pfg.31.1586798524823;
        Mon, 13 Apr 2020 10:22:04 -0700 (PDT)
Received: from x1.localdomain ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id v25sm8615686pgl.55.2020.04.13.10.22.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2020 10:22:04 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring: io_async_task_func() should check and honor cancelation
Date:   Mon, 13 Apr 2020 11:21:58 -0600
Message-Id: <20200413172158.8126-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200413172158.8126-1-axboe@kernel.dk>
References: <20200413172158.8126-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If the request has been marked as canceled, don't try and issue it.
Instead just fill a canceled event and finish the request.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7b41f6231955..2f9e93892870 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4181,6 +4181,7 @@ static void io_async_task_func(struct callback_head *cb)
 	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
 	struct async_poll *apoll = req->apoll;
 	struct io_ring_ctx *ctx = req->ctx;
+	bool canceled;
 
 	trace_io_uring_task_run(req->ctx, req->opcode, req->user_data);
 
@@ -4192,8 +4193,21 @@ static void io_async_task_func(struct callback_head *cb)
 	if (hash_hashed(&req->hash_node))
 		hash_del(&req->hash_node);
 
+	canceled = READ_ONCE(apoll->poll.canceled);
+	if (canceled) {
+		io_cqring_fill_event(req, -ECANCELED);
+		io_commit_cqring(ctx);
+	}
+
 	spin_unlock_irq(&ctx->completion_lock);
 
+	if (canceled) {
+		kfree(apoll);
+		io_cqring_ev_posted(ctx);
+		req_set_fail_links(req);
+		io_put_req(req);
+	}
+
 	/* restore ->work in case we need to retry again */
 	memcpy(&req->work, &apoll->work, sizeof(req->work));
 
-- 
2.26.0

