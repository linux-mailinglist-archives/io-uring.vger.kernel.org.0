Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88F3728CA78
	for <lists+io-uring@lfdr.de>; Tue, 13 Oct 2020 10:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403971AbgJMIrA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 13 Oct 2020 04:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403952AbgJMIrA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 13 Oct 2020 04:47:00 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41BECC0613D0
        for <io-uring@vger.kernel.org>; Tue, 13 Oct 2020 01:47:00 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id b127so8070680wmb.3
        for <io-uring@vger.kernel.org>; Tue, 13 Oct 2020 01:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=qGLI/PB3e0fIRCZL2UgTaetvdtn51hmhe/3z8j8FDzg=;
        b=m47z/LSNOGI2u2L+6EU+dwoHogSv3gFB8P+RcDqbsIOOyxpPZVFexHowxndtc5Co7L
         nvbkQ/vt5iv0Mz4Uh+wpAQQPMbRJgBzVFcactKTY+0tqgovAx78jfpudEqYSfx3LMZ7j
         Kn5Rr6tjiOf2OtKvuI3O0DXtZKEWBEBbUz5NTM9cXUiFeVlJeJXuG0aUWNQwzu5UrJKz
         Gx8sz/JSMGmgrPrFDjmaJoGA464g6vf/GifGj6oX4rCHQdADmd6kzepW7mGJANqJFGyx
         ybPZO77Kg+6kub3IVDOhDwmGlUpPeisuKWztKR05thQ8sAoCK3rDAW6K6IjaqiXXDe5e
         0ZYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qGLI/PB3e0fIRCZL2UgTaetvdtn51hmhe/3z8j8FDzg=;
        b=iKlz+bkfi5bxnzg1UqFoKV1So8kiTtta0fMa4jXUmTsJ98oloxExmIrDFQ88GAiv9Y
         qqnLNFtkJgm5jv1HsNh0hKG4pgacxTvbUZp3UbcTRVqtaiaoXSyMRWKRMm/ZrYDlobBq
         eq9n3yuc7IyNHpfFCVB2YLkLpVo9vbPuG0d0YcRhU+tuWyTrxaHKnsBDG9q6GrjDxznL
         4Hw03a0SrvYQB80BOZXIOSVUSFvxqNRNeuKnIU90iAQsck8aTOWs/OUzLwJo/Arfj+DT
         8pqQBZGSX0K4e6weqtg3XnsJRLZXDyfR2wvFRIeCNeZx2u5J0ELyBWQ2UwaAIyXjHIGJ
         g0gA==
X-Gm-Message-State: AOAM532UX46EN3jLXCtfel8yzUKnsVyr1iFz6QICRajxxpNGmCFKYxMq
        oCyFhog1oB1psh1Bhr/Pybk=
X-Google-Smtp-Source: ABdhPJwaFXd1iOzJzthg9E1I62plA6m/AVcGKlGMwN1lXEbMq8HvIw7M0Jpjiax+5RBKvzjoaV6RAA==
X-Received: by 2002:a1c:b646:: with SMTP id g67mr2526845wmf.87.1602578819039;
        Tue, 13 Oct 2020 01:46:59 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-228.range109-152.btcentralplus.com. [109.152.100.228])
        by smtp.gmail.com with ESMTPSA id p67sm26445168wmp.11.2020.10.13.01.46.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2020 01:46:58 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/5] io_uring: don't put a poll req under spinlock
Date:   Tue, 13 Oct 2020 09:43:58 +0100
Message-Id: <a723ec3fb07e906f28631d3a67b4d125b513b9ee.1602577875.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1602577875.git.asml.silence@gmail.com>
References: <cover.1602577875.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move io_put_req() in io_poll_task_handler() from under spinlock. That's
a good rule to minimise time within spinlock sections, and
performance-wise it should affect only rare cases/slow-path.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3ccc7939d863..ca1cff579873 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4857,10 +4857,9 @@ static void io_poll_task_handler(struct io_kiocb *req, struct io_kiocb **nxt)
 
 	hash_del(&req->hash_node);
 	io_poll_complete(req, req->result, 0);
-	req->flags |= REQ_F_COMP_LOCKED;
-	*nxt = io_put_req_find_next(req);
 	spin_unlock_irq(&ctx->completion_lock);
 
+	*nxt = io_put_req_find_next(req);
 	io_cqring_ev_posted(ctx);
 }
 
-- 
2.24.0

