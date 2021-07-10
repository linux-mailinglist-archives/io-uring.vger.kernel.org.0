Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3CB43C2CAB
	for <lists+io-uring@lfdr.de>; Sat, 10 Jul 2021 03:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbhGJBtO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Jul 2021 21:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbhGJBtO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Jul 2021 21:49:14 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF54EC0613DD
        for <io-uring@vger.kernel.org>; Fri,  9 Jul 2021 18:46:28 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id f9so8855450wrq.11
        for <io-uring@vger.kernel.org>; Fri, 09 Jul 2021 18:46:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V8ErhTefXbn7Nc+draFqxFl4SlylJ3pQlre1Q61Wssg=;
        b=kya5arOJBrK/Lmw8ciB/unPW4QfnGWJavXj4Wd1y1IukRG92XY7/LUkHrs8Cl4ek6G
         gvPTm32olqFLg5b92Ynm6z+pO3gLaK0S4QpVuAlVF4nM7fKpufkE0Icqt91o8zWPgCDQ
         FF9VQy6spncEi7fgYNTQ5kEkJb0gNOwpzDVtvoTI798NnQQ4B4kln7AW9yguCicM/jHp
         XfyAuTGUPOKHQQXBSMIQMD4lnc8zo8HT/40TI6BJOxiNloe3uV26urn0KmxNNiRswGxr
         2mRogxqy8zvMS8KAM5YC6uzlH7ZhpAngngIdwyW13KcK0tOyH7YDwVwMklSYonAsFgcG
         n3qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V8ErhTefXbn7Nc+draFqxFl4SlylJ3pQlre1Q61Wssg=;
        b=j0eGkyhQxxQTntb6CFVVVcSVUBGsG1HhUyyT9bB247FrcCjy8Z2f514NPPRjeUp4yx
         Qsdah361MAborIwq3FNcAZO5Nuo7utPiIRROIW4RkyAxNroRe4YbZVJnDJoDOQuf54DK
         55rSE/1mOtXst8akz8H6RJkq7d7kqiTYfkQFTHu1/YOzwRgphxSxVePjp7cbd/52Vkzz
         Q6fxNY1nGPhCeOO5b/cJSeFkKhZoFLQagNlga7eA0i68Tu8udUM6b6fWjN702eklzpae
         xGKJJVIYulvw2vgzCQctyOIQMd7wrMLDxra1fss2zrSTbJ+xTYK24nDXanKP88Jay5Wu
         7+iw==
X-Gm-Message-State: AOAM5327zNLGILk2xH9fv6QOVfDel3PsWkJTluIl14ChdPJf9k1yNeK8
        XNK0Ho05pnxdxkTf0KqKPy0=
X-Google-Smtp-Source: ABdhPJwDGtPOwlbNFOrXexB/Qg8J5/yfzvrasrEGArJYugy6D0QHu9F+bke4Fcn7uWkmiK1xIIqnzw==
X-Received: by 2002:a5d:4522:: with SMTP id j2mr6783440wra.43.1625881587276;
        Fri, 09 Jul 2021 18:46:27 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.39])
        by smtp.gmail.com with ESMTPSA id j10sm6719732wrt.35.2021.07.09.18.46.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 18:46:26 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
Subject: [PATCH 5.14] io_uring: use right task for exiting checks
Date:   Sat, 10 Jul 2021 02:45:59 +0100
Message-Id: <cb413c715bed0bc9c98b169059ea9c8a2c770715.1625881431.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When we use delayed_work for fallback execution of requests, current
will be not of the submitter task, and so checks in io_req_task_submit()
may not behave as expected. Currently, it leaves inline completions not
flushed, so making io_ring_exit_work() to hang. Use the submitter task
for all those checks.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7167c61c6d1b..770fdcd7d3e4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2016,7 +2016,7 @@ static void io_req_task_submit(struct io_kiocb *req)
 
 	/* ctx stays valid until unlock, even if we drop all ours ctx->refs */
 	mutex_lock(&ctx->uring_lock);
-	if (!(current->flags & PF_EXITING) && !current->in_execve)
+	if (!(req->task->flags & PF_EXITING) && !req->task->in_execve)
 		__io_queue_sqe(req);
 	else
 		io_req_complete_failed(req, -EFAULT);
-- 
2.32.0

