Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4EF38F682
	for <lists+io-uring@lfdr.de>; Tue, 25 May 2021 01:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbhEXXxH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 May 2021 19:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbhEXXxH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 May 2021 19:53:07 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95C06C061574
        for <io-uring@vger.kernel.org>; Mon, 24 May 2021 16:51:37 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id f75-20020a1c1f4e0000b0290171001e7329so11779314wmf.1
        for <io-uring@vger.kernel.org>; Mon, 24 May 2021 16:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=MDCeWkmJiZUwQuWx5H+vOczl44JWrYjN2UDvNlEfQbY=;
        b=chcMelLaGCa/eInnJUbjC8JXFM6Rchu02C3YD/I23fczvXt1B10D4fcCosF9yys/wt
         VrNPi97bkGfLc0gsNvA2iWd3OpxBNABWtIfXohqZBI14bCtxwsnyJ7FYIiteiBmWDWG/
         VH6NXzxTUmQ5zOfoc7x+prTJ7XkYzgje1ZjtrhOqWJiO2Xaeri9MkIaunZfv4+gO6VPH
         k5np487NE/vyAYKC+g2UplPK7dctB6hU/lcwglwA5OxvlNLz375pPehHUnWK5i6Axohg
         rUK4nszRw0ALyCgpQbg/ecxvZPSMh+Aasx/rJ4oPMYPozJCDYaKjxZVIUs3AmxlrG1Y8
         LLiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MDCeWkmJiZUwQuWx5H+vOczl44JWrYjN2UDvNlEfQbY=;
        b=TM1Lc8eVw6Mrd6oRnwOpvex+H9dQm0ssCVQ8OJMKZAJi5BNKgtqwlipVnGf3y8wZ5h
         oOIYfqh1sQww7eGTgxuz6xBowX+zV8D+jwJ06yklEIkbgOSI2IBgL6DAn+6MGgpbDAfc
         mLjvNFe8stWMTyl9OYFUGbXRXIslp0fJHkafUWkwikWw+NbS/fAU1+yd4uPlBY2mhSy+
         FIz+sMwF06kQuOoIu4rLH2A7NVANEeZ/+6ddnotzt+OzqktHTuWi6FXShZsrySoDJRs9
         8iK+cTj1XGAQsctoub3Vz2xt3Syeh3ZZAbGnQ5I7M8OzrGydwSIFN233rJoZnNBhUyQO
         F4wg==
X-Gm-Message-State: AOAM532BhM6zoAsUZM5qAXZ1tsw4/DWrho+hy9BO8QssFOg6BgfjD3r7
        XuNNTr5TuFxBozPYQ8fmLOT4vOw8deA1StZp
X-Google-Smtp-Source: ABdhPJyLu8BIXlipoc0ePtYHTqYgmlQ671o7jNUOsdl1vCc46aDbVqnNgFi/h+H1lH6PHadWwiHlxg==
X-Received: by 2002:a7b:c7c6:: with SMTP id z6mr21295930wmk.35.1621900296258;
        Mon, 24 May 2021 16:51:36 -0700 (PDT)
Received: from localhost.localdomain ([85.255.235.116])
        by smtp.gmail.com with ESMTPSA id f7sm8961069wmq.30.2021.05.24.16.51.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 16:51:35 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 09/13] io_uring: remove rsrc put work irq save/restore
Date:   Tue, 25 May 2021 00:51:08 +0100
Message-Id: <bec8ac044ccd077de0e77544d51818a4483041a6.1621899872.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621899872.git.asml.silence@gmail.com>
References: <cover.1621899872.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_rsrc_put_work() is executed by workqueue in non-irq context, so no
need for irqsave/restore variants of spinlocking.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 24178ca660c4..40b70c34c1b2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7550,14 +7550,13 @@ static void __io_rsrc_put_work(struct io_rsrc_node *ref_node)
 
 		if (prsrc->tag) {
 			bool lock_ring = ctx->flags & IORING_SETUP_IOPOLL;
-			unsigned long flags;
 
 			io_ring_submit_lock(ctx, lock_ring);
-			spin_lock_irqsave(&ctx->completion_lock, flags);
+			spin_lock_irq(&ctx->completion_lock);
 			io_cqring_fill_event(ctx, prsrc->tag, 0, 0);
 			ctx->cq_extra++;
 			io_commit_cqring(ctx);
-			spin_unlock_irqrestore(&ctx->completion_lock, flags);
+			spin_unlock_irq(&ctx->completion_lock);
 			io_cqring_ev_posted(ctx);
 			io_ring_submit_unlock(ctx, lock_ring);
 		}
-- 
2.31.1

