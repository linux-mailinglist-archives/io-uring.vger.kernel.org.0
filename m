Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3850425EB0C
	for <lists+io-uring@lfdr.de>; Sat,  5 Sep 2020 23:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728681AbgIEVrv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 5 Sep 2020 17:47:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbgIEVrt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 5 Sep 2020 17:47:49 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E010C061245
        for <io-uring@vger.kernel.org>; Sat,  5 Sep 2020 14:47:49 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id p9so13039746ejf.6
        for <io-uring@vger.kernel.org>; Sat, 05 Sep 2020 14:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=OcAfMl4EW3m302Hp4cGzDFY6Mcmry3J4SvC04/ws6e4=;
        b=VTDCuVGvIED1htIY6T8JDX7fYV/LtdeHcLbuOtTSnRwRcVLOaADTeH62LTtHkxGShY
         stb1YJqwqn30biP+e+6K+Z3r74t6MKg1GQCHxr+GoIe0G+J4NDuo2hNAKM161LOKJ2xx
         OuetLII7AVqGG5kSDdW5ASAMgdG88Zhtpp2e2xwq+6YU103sNoCMoF6W+C59xx/60QWx
         SHjew1zE5JfElwTfwzVTgfY4MBNC1L/Lptr5U91coCfAPSkBDiq12YkoDR1BJXxXvmmq
         Y3P7EO8FX9Y9tTmqp8ZpiVwhX3PSJofHRZ7jGbZF+JBIEZNx/ff8cS631LQiX06rPCSk
         g3tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OcAfMl4EW3m302Hp4cGzDFY6Mcmry3J4SvC04/ws6e4=;
        b=CdK1iOAs5ezuPeFfWI7A47Gyn7b9J81CJ69OMBO4Ltf54tHgBakDFombiGTB6G/6KE
         zTrZwdROGBSRtHZ4CB/YhaphyRoAX7fbz6ASmW9Gcvp1laJ2O6HSsq/xRRS28s34ltvX
         pDfce9L9iP5p08f4K4H82xXJsGeChXFCtUpp6wIkQcwupYFDPHBJoIKWf03RSj24kFMf
         Oks60b/J9CofTR21Igen3iSzmWwN06pXHV85qn0P1TBDbi46Bt1Yha26Qj8MgPGfbmCu
         r7mUQ7S8qZQf4D55lQAzfvfLhgXw1NbPJh6eSG0fi0NlP68+56FACZ7T57fZUiYuVmmF
         cXkA==
X-Gm-Message-State: AOAM5302GwSRObXrmdm8EugYC5QG7O36dW5XcJSOyeA8YDg3pZ3qvSR3
        L4tdRzaFq+kiFejKzz9XRtd3XBqOrXU=
X-Google-Smtp-Source: ABdhPJxGtltOdEWeqd22K64R9I17f7xCBDPNZzTt+1PTdd43ygXYHf5yOGXvlZ0SaCvFXDLsWxBCqQ==
X-Received: by 2002:a17:906:1f43:: with SMTP id d3mr13407183ejk.295.1599342467923;
        Sat, 05 Sep 2020 14:47:47 -0700 (PDT)
Received: from localhost.localdomain ([5.100.192.56])
        by smtp.gmail.com with ESMTPSA id c5sm2399121ejk.37.2020.09.05.14.47.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2020 14:47:47 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/2] io_uring: fix linked deferred ->files cancellation
Date:   Sun,  6 Sep 2020 00:45:15 +0300
Message-Id: <403cf67159f252b2f774e065984cd39120eaa9e4.1599340635.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1599340635.git.asml.silence@gmail.com>
References: <cover.1599340635.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

While looking for ->files in ->defer_list, consider that requests there
may actually be links.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 20b647afe206..f56e2cad97cc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8018,6 +8018,26 @@ static bool io_match_link(struct io_kiocb *preq, struct io_kiocb *req)
 	return false;
 }
 
+static inline bool io_match_files(struct io_kiocb *req,
+				       struct files_struct *file)
+{
+	return (req->flags & REQ_F_WORK_INITIALIZED) && req->work.files == file;
+}
+
+static bool io_match_link_files(struct io_kiocb *req,
+				struct files_struct *files)
+{
+	struct io_kiocb *link;
+
+	if (io_match_files(req, files))
+		return true;
+	if (req->flags & REQ_F_LINK_HEAD)
+		list_for_each_entry(link, &req->link_list, link_list)
+			if (io_match_files(link, files))
+				return true;
+	return false;
+}
+
 /*
  * We're looking to cancel 'req' because it's holding on to our files, but
  * 'req' could be a link to another request. See if it is, and cancel that
@@ -8100,8 +8120,7 @@ static void io_cancel_defer_files(struct io_ring_ctx *ctx,
 
 	spin_lock_irq(&ctx->completion_lock);
 	list_for_each_entry_reverse(de, &ctx->defer_list, list)
-		if ((de->req->flags & REQ_F_WORK_INITIALIZED)
-			&& de->req->work.files == files) {
+		if (io_match_link_files(de->req, files)) {
 			list_cut_position(&list, &ctx->defer_list, &de->list);
 			break;
 		}
-- 
2.24.0

