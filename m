Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5DD54CEC8
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 18:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356594AbiFOQen (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 12:34:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356695AbiFOQej (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 12:34:39 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E58C137BFE
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 09:34:34 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id l126-20020a1c2584000000b0039c1a10507fso1428523wml.1
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 09:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WRCMIxAC7zXamLszka2v8x0ZOcaQKYObTE2e1CKL58E=;
        b=KSHjexX/E0H6+oaS3KCHx1+KUqe1carPzWDvJaWvqTlitpwXXNIB3dvMSpyUFqMi4v
         dLrUy6pEqdES1Ri5VeWt0H3KXIVrMOakFHkTOIr0VU2oLhntzcz+mhYAJNh5kxx+++An
         UfHuOn6JqVrtq125xfNAdr5LBcLHAIxYneTbEOiKGkqah9Uoi4Y0Uqazvct4mFXnVP2N
         UBclJOx+2UpGWvfjV7nVZ1uoKUJYHAkazJzuNObtxFvz9xe0WfYlb0A8E0ENlTdVZ+jf
         y2hZBlQfnj44icVCCYgvu3v7ofGs7v6qWsBKO+yHG5Q3RzHpU1MQtfR0psXKlZIir1Qj
         2sxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WRCMIxAC7zXamLszka2v8x0ZOcaQKYObTE2e1CKL58E=;
        b=TZFBlB9yudaY6RwpznuOgGrd9HT46VbIiUr+qEO6KNSHcezfzQn8TdyyZtqRY7Hkug
         V7zrdZlknZCVJemMp02nQwMsrSQpcO8vIBmQ/4bXfOAb5rx8vJnBeOE2SEItcawWsufT
         5JnXPLf5O8Rsb1zSWqygiFfZ1EHuz691IQXHqqN0JCzjHyifcIjS7z5+hMW214+Zs9JA
         p+nRpvJBmcslrCejDuex9tSlaxxWFdt5Yky+F5p88NaK1sSWXZWi2V7CYe7HHK3UIAVl
         c31cM79KKdPkfgPhdMAJCmAJDUYThh2T7yv99TAr656SJm44jBQyh4+MMRiJB/Ssg/+9
         Hjqg==
X-Gm-Message-State: AJIora96/bG3TLtzqr5mQ1C4pa5CnXfRRf/93Fy2Q/Og1VNS2MHk/WB9
        /dTXhWkZwz9BDsXaRhW/AvD/AgFiJ31mhw==
X-Google-Smtp-Source: AGRyM1vHnpGGDgndq/NeNux0Vc/75aMLn8C6vCszMHjvYkHnnfKI5w/v1D1wYcTPx51Mr3AUpW1wGg==
X-Received: by 2002:a05:600c:a4c:b0:39c:6517:1136 with SMTP id c12-20020a05600c0a4c00b0039c65171136mr335694wmq.12.1655310873252;
        Wed, 15 Jun 2022 09:34:33 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id u2-20020a056000038200b0020ff3a2a925sm17894953wrf.63.2022.06.15.09.34.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 09:34:32 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 08/10] io_uring: never defer-complete multi-apoll
Date:   Wed, 15 Jun 2022 17:33:54 +0100
Message-Id: <a65ed3f5effd9321ee06e6edea294a03be3e15a0.1655310733.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655310733.git.asml.silence@gmail.com>
References: <cover.1655310733.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Luckily, nnobody completes multi-apoll requests outside the polling
functions, but don't set IO_URING_F_COMPLETE_DEFER in any case as
there is nobody who is catching REQ_F_COMPLETE_INLINE, and so will leak
requests if used.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index dec288b5f5cd..68ce8666bd32 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2054,7 +2054,7 @@ int io_poll_issue(struct io_kiocb *req, bool *locked)
 	io_tw_lock(req->ctx, locked);
 	if (unlikely(req->task->flags & PF_EXITING))
 		return -EFAULT;
-	return io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER);
+	return io_issue_sqe(req, IO_URING_F_NONBLOCK);
 }
 
 struct io_wq_work *io_wq_free_work(struct io_wq_work *work)
-- 
2.36.1

