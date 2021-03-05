Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9D632EBD9
	for <lists+io-uring@lfdr.de>; Fri,  5 Mar 2021 14:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbhCENDH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Mar 2021 08:03:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbhCENCs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Mar 2021 08:02:48 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6069C061574
        for <io-uring@vger.kernel.org>; Fri,  5 Mar 2021 05:02:47 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id u125so1392671wmg.4
        for <io-uring@vger.kernel.org>; Fri, 05 Mar 2021 05:02:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=yhuORutF+eVhBKIoPZ4Q178xO+N7qkHfZ5A57L+QjuU=;
        b=Hq0dkAqO6alfXbbtPhVdcCdb4yj686FfqZZYMFU5qzc/6LJifwlA3gS/wRoLNCGNrO
         q8vomRbR3j4v3BWy2qKpJWZTR8Ydxru+nY2/lqrrHHJMSDB+2ShCBkPeUxv0fFUbiJqA
         2Zosdxx9lPbSxCXXQhM3VW93l4Ov1NtUeTfrJpqieCh7peRZrqaGMOTHfC5W5Z2qJgWM
         2KFw/y6/Mk3b5sv4/wOp6UMw7zOUUwbc4OceLLGvnLwhq0VQuPIO3gjTuigzvlUcwGdP
         1ah3vGUmmMg0MzAifvsbiz2K6yloxC/OFMGvY1B4St86kehbraMsx/hgbQOZo3VGpMNk
         Y8Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yhuORutF+eVhBKIoPZ4Q178xO+N7qkHfZ5A57L+QjuU=;
        b=EPlQrnNYrtH4iBiAqko/TECKoHCVurfSEulhPgX4//4U2vXglvn1v4KArscVNpOWB9
         28z6BxU09CT1n9a8REFbUrEvcuCGBZHwTNHiJcOkYw5JAGMfPTJ+2suagZxzHHLBBl55
         mPienuSwgdwZax982htV/I3a75zaJ3KAEUK7bX64YY5/XP03llSfztAXrBqe4/weW/MI
         QY2TjcalLWTmldE/z6dGTrcqV8PIVpj0LtKJQIzTEompnJcX3xGawWJk8yvliepqlx5B
         q4tpsSgipvAqmlGGkCYPGCcJzi8KKdv6xhsUfzJXKkcOzTXF5fYkN2Qn1YPkEc/fYZen
         D8KA==
X-Gm-Message-State: AOAM532wREr2Zn8CmACmkdHkzHEGwAqjUk6TGpyjX3hjSt/bb9A3Ef0g
        NnMBZkiZeTmXQydKlmcl1Aed5LxwZXM72A==
X-Google-Smtp-Source: ABdhPJz+uZaOfp3U9Awakf9lzAXM8vLhgviecwC7mK6OCkudlQwhysNrEJ0tt5AC648EeZMT498/zA==
X-Received: by 2002:a1c:9a47:: with SMTP id c68mr8618138wme.63.1614949366550;
        Fri, 05 Mar 2021 05:02:46 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.216])
        by smtp.gmail.com with ESMTPSA id h20sm4345385wmm.19.2021.03.05.05.02.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 05:02:46 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v3 4/6] io_uring: don't take task ring-file notes
Date:   Fri,  5 Mar 2021 12:58:39 +0000
Message-Id: <5c394abd70bf5c3b21437c5a3dfd3f9ddfbc7ab3.1614942979.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614942979.git.asml.silence@gmail.com>
References: <cover.1614942979.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

With ->flush() gone we're now leaving all uring file notes until the
task dies/execs, so the ctx will not be freed until all tasks that have
ever submit a request die. It was nicer with flush but not much, we
could have locked as described ctx in many cases.

Now we guarantee that ctx outlives all tctx in a sense that
io_ring_exit_work() waits for all tctxs to drop their corresponding
enties in ->xa, and ctx won't go away until then. Hence, additional
io_uring file reference (a.k.a. task file notes) are not needed anymore.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9865b2c708c2..d819d389f4ee 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8815,11 +8815,9 @@ static int io_uring_add_task_file(struct io_ring_ctx *ctx, struct file *file)
 			node->file = file;
 			node->task = current;
 
-			get_file(file);
 			ret = xa_err(xa_store(&tctx->xa, (unsigned long)file,
 						node, GFP_KERNEL));
 			if (ret) {
-				fput(file);
 				kfree(node);
 				return ret;
 			}
@@ -8850,6 +8848,8 @@ static void io_uring_del_task_file(unsigned long index)
 	struct io_uring_task *tctx = current->io_uring;
 	struct io_tctx_node *node;
 
+	if (!tctx)
+		return;
 	node = xa_erase(&tctx->xa, index);
 	if (!node)
 		return;
@@ -8863,7 +8863,6 @@ static void io_uring_del_task_file(unsigned long index)
 
 	if (tctx->last == node->file)
 		tctx->last = NULL;
-	fput(node->file);
 	kfree(node);
 }
 
-- 
2.24.0

