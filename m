Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB6A3DA718
	for <lists+io-uring@lfdr.de>; Thu, 29 Jul 2021 17:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237737AbhG2PGh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Jul 2021 11:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237640AbhG2PGh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Jul 2021 11:06:37 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E38AC0613D3
        for <io-uring@vger.kernel.org>; Thu, 29 Jul 2021 08:06:33 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id d8so7360717wrm.4
        for <io-uring@vger.kernel.org>; Thu, 29 Jul 2021 08:06:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ThdC8IRHLGzkKCHd1MhFEZSIYhmxSctrUEuXKBvqZYY=;
        b=i98/m/eO6hq8l3zrdyHEabuyPJlyo6BxIGmaecIpX5Lc2Xacaz0eSRzS79mKngD5Pj
         VGRxTajEfJ+ZHDW1lPtqVNd4SUbiD78Dbwlt35c331G5yIDEp3wNmTdx4o4w4VbopKBv
         pVZdItN8Atubee8Ytmw6OeHoB9Vxsf67e3VMbXk8ejDdrWNPXlOngsb9Qrh3+77BFxtw
         fFY7suRhFuhmVnXQBmH/HNqN8fHtWiAAE7N18+ZrAdmjAgktC8H1LXYigTR2GbplzOvG
         WOuO8TIH4ScyX/COB3FOaa3jZdPdlQsNmXs6RMnsUfMgOIXTxT0rzLcaPM+ji1vBbQwT
         sbvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ThdC8IRHLGzkKCHd1MhFEZSIYhmxSctrUEuXKBvqZYY=;
        b=gZ4+6l5yjT3xuq0NWs6IIzmNA7SDrLqCzU7b74pOQ6P2lNWH3yJE9k/wpF6qCqhTJn
         pziVv2lBDJKfsl2NeopeL1mmDdU1oDLpVhrmAqpwFctnv47UwQ0iU/fKc/0LPSk2b+Q5
         /58IIwjmaHhkfrHXEegqaq0BLI9F2LiRjb3WSnkCtrtPuh1r2ZPnypmOg970hjBZC7vA
         9AdI/gEKHI9QS0B2WZ3diBfjuimHEOR1XAEi0FYo2rshws+RuU+IZhCEGgp11tN7NNfh
         2OUL5ADUAppeISpO9btK55+0uzbiIud2hrfqv2huUiZi8CRmGAJBEOWZLetz/yFnf1la
         9tnw==
X-Gm-Message-State: AOAM532CeyquuTjVHIwjgVxWEUblgZiGn1vq1hg3y1pieIVooaMSR8/O
        RIjIyIk5703dLZ4J79pu9cY=
X-Google-Smtp-Source: ABdhPJxIWpkqb7FShDqzIcYrlWWs9+6qA0erJNCDaC+UOtDNWASKIAeZElapGn64q1ZhFo9s5ncy/w==
X-Received: by 2002:a5d:4951:: with SMTP id r17mr5288633wrs.208.1627571191944;
        Thu, 29 Jul 2021 08:06:31 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.141])
        by smtp.gmail.com with ESMTPSA id e6sm4764577wrg.18.2021.07.29.08.06.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 08:06:31 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 10/23] io_uring: inline io_free_req_deferred
Date:   Thu, 29 Jul 2021 16:05:37 +0100
Message-Id: <6fbd12a256b5320fd275175729693950b36fa1ba.1627570633.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1627570633.git.asml.silence@gmail.com>
References: <cover.1627570633.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Inline io_free_req_deferred(), there is no reason to keep it separated.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d45d18c9fb76..04b78b449e9d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2170,16 +2170,12 @@ static inline void io_put_req(struct io_kiocb *req)
 		io_free_req(req);
 }
 
-static void io_free_req_deferred(struct io_kiocb *req)
-{
-	req->io_task_work.func = io_free_req;
-	io_req_task_work_add(req);
-}
-
 static inline void io_put_req_deferred(struct io_kiocb *req, int refs)
 {
-	if (req_ref_sub_and_test(req, refs))
-		io_free_req_deferred(req);
+	if (req_ref_sub_and_test(req, refs)) {
+		req->io_task_work.func = io_free_req;
+		io_req_task_work_add(req);
+	}
 }
 
 static unsigned io_cqring_events(struct io_ring_ctx *ctx)
-- 
2.32.0

