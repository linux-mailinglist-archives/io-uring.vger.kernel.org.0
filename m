Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92AC53492D0
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 14:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbhCYNMc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 09:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbhCYNMZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 09:12:25 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57DC6C061763
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 06:12:24 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id j20-20020a05600c1914b029010f31e15a7fso3083084wmq.1
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 06:12:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=e7+LQjmV+m8Ze/+VDCaXDC2vNQ0n1bn2u15ts3xdSK0=;
        b=mi1tSNH7s6V2ZwBzBldF14/+nlY7iv31cnLjvfaWrsHz8zO1j+1cuowMrp/h8Tw4CO
         GpIfIUFgoaW5DmSTpGLSbfJfSfIJFN3jaMsz6D4E4gtMsFifn4Lf6631cYeIMINaIxwl
         UNdjuPoZ6Bpn6jTUlxHDLEgL6l+/9QEyS2MRZHqY3nbdn5TNKWvZrxUI6NqcFdn4rvYX
         ooRIcLD3xZ70yIOlxHNmRNgvNL+YM4DZW+MVAALH5cW4DVuYZ0CYhC8iO1hmYJcCZs7Y
         bDjVXdDHMwymh023YfFGNYRTOuDrMloWceV0qTWrJaJdwgvyzgY7BMIMlOzHD9zy8N7z
         p06Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e7+LQjmV+m8Ze/+VDCaXDC2vNQ0n1bn2u15ts3xdSK0=;
        b=Km4hA7zI9p811qCJ+nxGuLPtgFwpJ1sWRub0lUHmhSgbHYXBvxrQZBL5JRTn2uaFQe
         b3imgFkBc6AmvM5EB4m+cBz6HunchmabdWoCX9EXoY7gIz9Qq8MC9/N2IDcOWPaub7RU
         1M4wWloUGCfEAVWMxINVzIUs6TS5ayxivTnLPr4UVfucV+5f+LmutA4pgre2/XP1aHVl
         UCvPNEjh4qsVvOBd/+tqUppx1fXYT9Qkvay7ozQ5OPWOlwViyF7fXhh4yXCKzgHcVfRt
         WbYiebxWkTJ1RNTqCjlaW6CqYpx4VPdA4M1d4faNUZAeW2r/Q/dETYdDTlzc2oEi4LHY
         wo5w==
X-Gm-Message-State: AOAM531XGdcsComF36XJMyrE/P3iV+zr7UbFSCPQGFyRiPcKmZlxENl2
        0mZG3TnUOoQGnNDvc5YNbQT864XHcnW2BA==
X-Google-Smtp-Source: ABdhPJy/eUdMP069JrZacu8BjQwA9n7NU99LxMrn9ofwnCOPfcWyvgl56YFhJRF8WV0ptNQanRG5GA==
X-Received: by 2002:a7b:c931:: with SMTP id h17mr8078830wml.4.1616677942921;
        Thu, 25 Mar 2021 06:12:22 -0700 (PDT)
Received: from localhost.localdomain ([148.252.129.162])
        by smtp.gmail.com with ESMTPSA id i4sm5754285wmq.12.2021.03.25.06.12.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 06:12:22 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v3 08/17] io_uring: reuse io_rsrc_node_destroy()
Date:   Thu, 25 Mar 2021 13:07:57 +0000
Message-Id: <03532dc084fe421be5b4a0f40c8013f2cea762bb.1616677487.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616677487.git.asml.silence@gmail.com>
References: <cover.1616677487.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Reuse io_rsrc_node_destroy() in __io_rsrc_put_work(). Also move it to a
more appropriate place -- to the other node routines, and remove forward
declaration.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1328ff24d557..9da4a1981560 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1013,7 +1013,6 @@ static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 					 struct task_struct *task,
 					 struct files_struct *files);
 static void io_uring_cancel_sqpoll(struct io_ring_ctx *ctx);
-static void io_rsrc_node_destroy(struct io_rsrc_node *ref_node);
 static struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx);
 static void io_ring_file_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc);
 
@@ -6963,6 +6962,12 @@ static inline void io_rsrc_ref_unlock(struct io_ring_ctx *ctx)
 	spin_unlock_bh(&ctx->rsrc_ref_lock);
 }
 
+static void io_rsrc_node_destroy(struct io_rsrc_node *ref_node)
+{
+	percpu_ref_exit(&ref_node->refs);
+	kfree(ref_node);
+}
+
 static void io_rsrc_node_switch(struct io_ring_ctx *ctx,
 				struct io_rsrc_data *data_to_kill)
 {
@@ -7408,8 +7413,7 @@ static void __io_rsrc_put_work(struct io_rsrc_node *ref_node)
 		kfree(prsrc);
 	}
 
-	percpu_ref_exit(&ref_node->refs);
-	kfree(ref_node);
+	io_rsrc_node_destroy(ref_node);
 	percpu_ref_put(&rsrc_data->refs);
 }
 
@@ -7477,12 +7481,6 @@ static struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx)
 	return ref_node;
 }
 
-static void io_rsrc_node_destroy(struct io_rsrc_node *ref_node)
-{
-	percpu_ref_exit(&ref_node->refs);
-	kfree(ref_node);
-}
-
 static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 				 unsigned nr_args)
 {
-- 
2.24.0

