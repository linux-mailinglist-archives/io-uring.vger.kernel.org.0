Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDF1632F99D
	for <lists+io-uring@lfdr.de>; Sat,  6 Mar 2021 12:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbhCFLHG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 6 Mar 2021 06:07:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbhCFLGZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 6 Mar 2021 06:06:25 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AB6CC061761
        for <io-uring@vger.kernel.org>; Sat,  6 Mar 2021 03:06:24 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id 124-20020a1c00820000b029010b871409cfso854742wma.4
        for <io-uring@vger.kernel.org>; Sat, 06 Mar 2021 03:06:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=W7541bf5ypBBsWz8qmulrj4/uvHC9zamcWrHElZ0cGc=;
        b=oP6KxD5KfpsbYl2orHvTJ/dMsAoJ3ccwGzd81HgYKBKlQEJ5hBfQmHpHyATbR4TqRN
         EiDQfarpAqdDqV9OcW/5HDJZU2U7nvDIHxEUnI3Yz14LsFE/eqJ3Z/MPdXRkMwZtFH0q
         CABMhT3S+FPQGy08wRLULdFvZOaih/3D0rO17oyZZmx9b4s/xgbhONB8bh4AP4QWeHdX
         1imOa4IkdvypBq4pPLuFZne8hzLxJKMVConeU6Lqbve5xin8OOI8kvFck752G/Z+cJW1
         knJiKzuMTYEv4tgqQ69uTFqzR7pxV+9ZH5ugrrKDiBZUEmJkCzAI+qYeWSW0LUqmoyUi
         TOKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W7541bf5ypBBsWz8qmulrj4/uvHC9zamcWrHElZ0cGc=;
        b=nEKlncQ4E8jkeG77T59OPPkXDqhoqwq2HDypHriZDzYgnSKi4P2I1g/AcFUz1dwZFN
         oZ9VvYHkJr6haZfpUorICw7kUfE5PWjQOfe9WaoHj2tT90W+cmpBYN6La9QWocXI+0yk
         uZQC17CGw7shAYGBB1wVTu+xqlS5wn5XXPzbn94Ae+NGJ+bYryC14mly9dRHct1ujprs
         Ur4SnRDntQNDUWyyfB2DA6rZ9lEFjFrpkfRgofhUqlcEbhWxu87vDlgQ21u6XVorTXQI
         f1xmqDP9y6uBwv6LzLSD5h7/5L7vZ07bNa+Ay6/KomiL+gfWB6Ao9hqyQ+5dyH0iZnAZ
         Vwjw==
X-Gm-Message-State: AOAM530frkIStL2f5S9HNkpzoq4FnvvROkgjh8k2T4n7Df9+fGtYZtyp
        Pg1XzukiD00tj3WYOwbKYBhBoxrZn8qDKA==
X-Google-Smtp-Source: ABdhPJyL9LRxNrcoEC4ngYSBjfB5dWOTzOwJC8mOEN0Rec6HGCQqvFGK1yGz0A25agVtyVLaRU5Ygw==
X-Received: by 2002:a7b:cdef:: with SMTP id p15mr13392861wmj.0.1615028783271;
        Sat, 06 Mar 2021 03:06:23 -0800 (PST)
Received: from localhost.localdomain ([148.252.133.8])
        by smtp.gmail.com with ESMTPSA id h2sm9442365wrq.81.2021.03.06.03.06.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Mar 2021 03:06:22 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v4 4/8] io_uring: don't take task ring-file notes
Date:   Sat,  6 Mar 2021 11:02:14 +0000
Message-Id: <4aca4982ce38822b46010fe297306013eed31b68.1615028377.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1615028377.git.asml.silence@gmail.com>
References: <cover.1615028377.git.asml.silence@gmail.com>
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
index 692096e85749..a4e5acb058d2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8816,11 +8816,9 @@ static int io_uring_add_task_file(struct io_ring_ctx *ctx, struct file *file)
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
@@ -8851,6 +8849,8 @@ static void io_uring_del_task_file(unsigned long index)
 	struct io_uring_task *tctx = current->io_uring;
 	struct io_tctx_node *node;
 
+	if (!tctx)
+		return;
 	node = xa_erase(&tctx->xa, index);
 	if (!node)
 		return;
@@ -8864,7 +8864,6 @@ static void io_uring_del_task_file(unsigned long index)
 
 	if (tctx->last == node->file)
 		tctx->last = NULL;
-	fput(node->file);
 	kfree(node);
 }
 
-- 
2.24.0

