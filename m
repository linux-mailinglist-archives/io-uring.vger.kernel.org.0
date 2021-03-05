Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2676332EBDC
	for <lists+io-uring@lfdr.de>; Fri,  5 Mar 2021 14:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbhCENDG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Mar 2021 08:03:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbhCENCp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Mar 2021 08:02:45 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6DE2C061574
        for <io-uring@vger.kernel.org>; Fri,  5 Mar 2021 05:02:44 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id i9so1378660wml.0
        for <io-uring@vger.kernel.org>; Fri, 05 Mar 2021 05:02:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=72Con7c/l/YWuWFaky1WYBcstZNDGg/iYgHhg2KKpzk=;
        b=UkV8c3ZUFwFfi9zlkOySFGvfTtbEbakU9n/ZSH6x+ZVPuYre2SB8U7n/h6UfPHnYhi
         SptNqrXrBLjK0pkH0eEFdnnMWiRVDVQYJNNJaPsPrGToxUQuwgFo83Nsj1gvIXWg2fIG
         zVskZ6iWdn6As2vBVUghrKK9Jz8DDXOctLpK4l44jYGct3K03g18OYkRiwbPgQ02PPsi
         AkAmrce1a1ec72Hw2PdTYuWbirrAGkMP6xi8pp9IiYICtoqDq40nr4ojvUL5Hf84Oth+
         fl4gidj2DFyju3XW4m8qzi+d60D+g4pwaRxTbHhXBOaeIsgri/odkMspto2iBkOFUg45
         Qt9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=72Con7c/l/YWuWFaky1WYBcstZNDGg/iYgHhg2KKpzk=;
        b=hzzk6JsLEnyjRyInkJAZzMpns0QSjTc5qp4KvQEp+PHKdVqwDQXk7z7UhpN1rntCSJ
         o4ZZvfp+4K5NWC4eGvgpd3Eag/CEevGny3dNC/kqLU45POA6Mb/79SEnDZhPAclaciF0
         nDCYhMmiugZO3FZfddb2uCuhuh+eox6YK23n+aB5ACD3/+axng7PMqNL9M1raMWprCqR
         xoL66RggHMCCDMS0+KEyUQY47sPmtqI9UcZRSGe7EDabTq/OM8NEtYtKLnqCUko8znqB
         AEB+8GUqw1uOZSA7In77C3jGKJAW9RlVaLtCW5Zc9Y0lWIxC8oNg6+8SxTeD5qYfkURi
         VK0g==
X-Gm-Message-State: AOAM530kbj1HgvKgTwG3ZIWe3cvcdssXWRQ6/j+gRHgIL/sYuXYu4cSi
        andRzb3erMvQN86vltEEFTTg4lFnO4M8cA==
X-Google-Smtp-Source: ABdhPJycTJouFpLJz/PEgRGdazThXD5rExxpJyoS0R5awD+f/DsnVPiBPvDyPjRE3BfUylfGe9t+rQ==
X-Received: by 2002:a1c:cc14:: with SMTP id h20mr8927256wmb.180.1614949363542;
        Fri, 05 Mar 2021 05:02:43 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.216])
        by smtp.gmail.com with ESMTPSA id h20sm4345385wmm.19.2021.03.05.05.02.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 05:02:42 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v3 1/6] io_uring: make del_task_file more forgiving
Date:   Fri,  5 Mar 2021 12:58:36 +0000
Message-Id: <1612f92861f7e5595f8a5fbdedc376e91b8f5faf.1614942979.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614942979.git.asml.silence@gmail.com>
References: <cover.1614942979.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Rework io_uring_del_task_file(), so it accepts an index to delete, and
it's not necessarily have to be in the ->xa. Infer file from xa_erase()
to maintain a single origin of truth.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 99e37f9688bf..bcf2c08fc12e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8779,15 +8779,18 @@ static int io_uring_add_task_file(struct io_ring_ctx *ctx, struct file *file)
 /*
  * Remove this io_uring_file -> task mapping.
  */
-static void io_uring_del_task_file(struct file *file)
+static void io_uring_del_task_file(unsigned long index)
 {
 	struct io_uring_task *tctx = current->io_uring;
+	struct file *file;
+
+	file = xa_erase(&tctx->xa, index);
+	if (!file)
+		return;
 
 	if (tctx->last == file)
 		tctx->last = NULL;
-	file = xa_erase(&tctx->xa, (unsigned long)file);
-	if (file)
-		fput(file);
+	fput(file);
 }
 
 static void io_uring_clean_tctx(struct io_uring_task *tctx)
@@ -8796,7 +8799,7 @@ static void io_uring_clean_tctx(struct io_uring_task *tctx)
 	unsigned long index;
 
 	xa_for_each(&tctx->xa, index, file)
-		io_uring_del_task_file(file);
+		io_uring_del_task_file(index);
 	if (tctx->io_wq) {
 		io_wq_put_and_exit(tctx->io_wq);
 		tctx->io_wq = NULL;
-- 
2.24.0

