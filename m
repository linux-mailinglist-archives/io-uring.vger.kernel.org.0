Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E269432D4D8
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 15:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235289AbhCDOFJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 09:05:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239150AbhCDOEz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 09:04:55 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9691C0613D7
        for <io-uring@vger.kernel.org>; Thu,  4 Mar 2021 06:03:41 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id w7so8140426wmb.5
        for <io-uring@vger.kernel.org>; Thu, 04 Mar 2021 06:03:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=hUh4ahn0H4/uTh7u0t//Xu8QlT6lv/aMB+ziQxUIUn8=;
        b=RmzXcUjJNGQs+f9EtELAs3KjkMd//GFjDP7nJ/53SFSslU2sN0Up+5qb2BP0sLAMbm
         cNLkpczAt4QmhmAiz8vKeHxXtvnU9+Be2wlUAfT3L3y1SbkawOol7NNIpWYtJ/XJas+K
         MCOvJ7uwy/iVTMcGO1prBun7wdtmJzE41YXIRAqdPtfDJFY82m/MMX7dmOal7r7ks6FA
         1psQyMYfNrQch5fwNKstWi22fXUlilg4ICVJCUWAcZbq6fX79o7OtF8VUjZ6spEiBCOP
         myt4WTvo1JEZu51q1Ouxl57obEs7pvUHmzjz+Fqi8bvK5IrIow180Oa3cRD0/jROD7XD
         3S6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hUh4ahn0H4/uTh7u0t//Xu8QlT6lv/aMB+ziQxUIUn8=;
        b=gav/uSCwVWfjO1r40yBkV7NCMJlypJHL4bGMP0dGitjeIjkwi7cmLM8oFMzHQGyIHv
         L3gjh4TsGemaqIXjSYj42kkV4aSiG14JgKf5gLvR+E1+t9VN/L3N8fj8Hq42Y7GogHDI
         AuuKt5Xhmm0JvEuvHls/NIashOAzqbtc4Yus/k7Vshi2DWpnCTf+GHLj0q1b4gt7DBIi
         Tqorw4LAY2f5UG2BfEr/et3lDpzXF1qIKYk06taLpJwqLEX4VXhxUXJOcFIThbWilXv/
         VT0cKw+Fi3MkYts3qBCBk9naL+8JYvCbZJFwBbWg99Rg+aXfsEEuLS1g4GT4SrrWU5Yv
         YpMg==
X-Gm-Message-State: AOAM532XZ6yjJoj/lb+3tkRLmqRO80OMTHmS1oPwm9j92x+bGdvjosAE
        /4f0TdMmFF83hZKpnc3QAnY=
X-Google-Smtp-Source: ABdhPJznoD3ixsD7wUwyCQLyqqSZKsYOdW51p5Ph6Sf63ADE9vxR5sJ652W1Gl5uXbPGNt+w2/+Aow==
X-Received: by 2002:a1c:4e0f:: with SMTP id g15mr4194132wmh.144.1614866620714;
        Thu, 04 Mar 2021 06:03:40 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.216])
        by smtp.gmail.com with ESMTPSA id o124sm9975488wmo.41.2021.03.04.06.03.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 06:03:40 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 6/8] io_uring: don't take task ring-file notes
Date:   Thu,  4 Mar 2021 13:59:29 +0000
Message-Id: <9d075d583f320bf8bcfe821f3d412394ea9abf61.1614866085.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614866085.git.asml.silence@gmail.com>
References: <cover.1614866085.git.asml.silence@gmail.com>
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
index d88f77f4bb7e..da93ae7b3aef 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8808,11 +8808,9 @@ static int io_uring_add_task_file(struct io_ring_ctx *ctx, struct file *file)
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
@@ -8843,6 +8841,8 @@ static void io_uring_del_task_file(unsigned long index)
 	struct io_uring_task *tctx = current->io_uring;
 	struct io_tctx_node *node;
 
+	if (!tctx)
+		return;
 	node = xa_erase(&tctx->xa, index);
 	if (!node)
 		return;
@@ -8856,7 +8856,6 @@ static void io_uring_del_task_file(unsigned long index)
 
 	if (tctx->last == node->file)
 		tctx->last = NULL;
-	fput(node->file);
 	kfree(node);
 }
 
-- 
2.24.0

