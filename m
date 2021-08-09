Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 107313E4CEE
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 21:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235913AbhHITTT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 15:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235918AbhHITTN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 15:19:13 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C67B1C061798
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 12:18:52 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id h13so22817123wrp.1
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 12:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=zLuQkBwO78SdYLfj9AdjFzicRHn5azpsBgm+VCT5ca0=;
        b=NNVGSKWoRBkuu4XkPcMvJ5tylkDoDGP2JHcLR1ad85cvmfOUh31t98c93z9GUVgQ+y
         qnsmlGa8BRqexNWFYglTE20zX4+Ac9LS6QlyCacPYMX3TdEEz58rtXtYlfld6OjcMbCQ
         MnCyFGWg40GSPiAEsDItBEQ0LhlDRA/9Kvp3lMphPwMNiDe4brITHxo7A9u+3fNqnEJn
         AdXZ9BrCW+cS4cqm3ZtJsmyGVv5JYraTKRmwCqn6MxQ9hwIYB15R+/Bej5C6zzLfsdgx
         hDcH+GldU3AMWMRd2suSPHRhzzhUaRpU/pzIjr5tsrNa1O1ift9zKhoK6ivLPgWQWPdf
         pvJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zLuQkBwO78SdYLfj9AdjFzicRHn5azpsBgm+VCT5ca0=;
        b=js9n7gSkggke1rysQiWCkUdIswzYDp3HRW9PG5R4O6xsDHyi6/sxu66ILFknZoFbo8
         oasksFd2DpX0CPgIw7oDdDFPfBQd1guuFftQCsb1wiPv4SBiaJug9qmhdCdB16QWvp+M
         9o4gsoR/e7PldNm21oES99sXWtaGHBwBfzeZthEI7o9NIIk9lXCmRFyEmHiDfYxqeFW6
         GFVwMApEyNuoXmKxlcBxw75A50zReNIMf46Klpvu7SionD+xRh8Aa2Rosu3fykzsASQ3
         3roPmUzww7+xLVF0UlNFjce0oa88CPOXDdsJMgiCufansrRpkVCL/ZIqg6MHi7GlB+ce
         cfPA==
X-Gm-Message-State: AOAM530a6CA6LtTJsTh5Bq8DJzgH/7BZ8HdGEnXelVfo4gDGYMtUihnX
        wQs/tlxYljEhsYv5tjHKOzM=
X-Google-Smtp-Source: ABdhPJwNWPAc0etDXTrVhI5qMVa1q0DddbqPzHxerKBtgEyQq1cTWD/HW5fNU0/Fjp0tDyfQQjqgfA==
X-Received: by 2002:a5d:4ac5:: with SMTP id y5mr27391006wrs.125.1628536731515;
        Mon, 09 Aug 2021 12:18:51 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.119])
        by smtp.gmail.com with ESMTPSA id h11sm13283074wrq.64.2021.08.09.12.18.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 12:18:51 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/7] io_uring: remove redundant args from cache_free
Date:   Mon,  9 Aug 2021 20:18:09 +0100
Message-Id: <6a28b4a58ee0aaf0db98e2179b9c9f06f9b0cca1.1628536684.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628536684.git.asml.silence@gmail.com>
References: <cover.1628536684.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We don't use @tsk argument of io_req_cache_free(), remove it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9aa692625f42..7ad3a1254c59 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8622,13 +8622,11 @@ static void io_destroy_buffers(struct io_ring_ctx *ctx)
 		__io_remove_buffers(ctx, buf, index, -1U);
 }
 
-static void io_req_cache_free(struct list_head *list, struct task_struct *tsk)
+static void io_req_cache_free(struct list_head *list)
 {
 	struct io_kiocb *req, *nxt;
 
 	list_for_each_entry_safe(req, nxt, list, compl.list) {
-		if (tsk && req->task != tsk)
-			continue;
 		list_del(&req->compl.list);
 		kmem_cache_free(req_cachep, req);
 	}
@@ -8648,7 +8646,7 @@ static void io_req_caches_free(struct io_ring_ctx *ctx)
 	}
 
 	io_flush_cached_locked_reqs(ctx, cs);
-	io_req_cache_free(&cs->free_list, NULL);
+	io_req_cache_free(&cs->free_list);
 	mutex_unlock(&ctx->uring_lock);
 }
 
-- 
2.32.0

