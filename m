Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3ABE17434B
	for <lists+io-uring@lfdr.de>; Sat, 29 Feb 2020 00:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgB1Xip (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Feb 2020 18:38:45 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36764 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbgB1Xij (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Feb 2020 18:38:39 -0500
Received: by mail-wm1-f67.google.com with SMTP id g83so2965554wme.1;
        Fri, 28 Feb 2020 15:38:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=GRyD73+GSi9Lm/Wnjz97qUrMihtNT3qCFZff2uV1q3Q=;
        b=OPc0DEPTXhASqB8iFysDlUl7R04o9dI9FTcr0sEWQgPImf1XU8ilLgs78waEj8Dxhz
         lcpV4MsJ0ItRHgQ1UoPsDAUwZdoSF/jodJkIHuhTU0LioLfHX9PUzw+Oa8VvukTV7yNF
         LIoHAhB7jcv2b7y4YK/Wq7Qd6Fe1FEci06GJ8KPrRLJAasUVAVfe013B9udW46NRH4z3
         jxhmrB9/XXkNv++wnc+MM91Ocols+mpX0Fc1hLBRWqBJvY16LNnbq55FJEoibJoolsmd
         FK1jY39fuZqrkArcK718HDB3d/BxUpZkzaAhpxCuQbDrf17AU0d4N0TBllfF1oYrIhv1
         R2Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GRyD73+GSi9Lm/Wnjz97qUrMihtNT3qCFZff2uV1q3Q=;
        b=Pbw5XoXpTTy5NzcntXAKzNyJ6ITgZaKqfu9rXzKTt2JMFmp9ByKpM/b3oaMVU33m+T
         G6+P4LOkAxnrnoXtz0khihvzW7NukGVz8rTElPqQEVjvCYaQu6PFZG/qyowop/LIhzyQ
         MinQwC+It8w/4i9/KGnfsxh8ypYXNXboYWrUwL9Wiwdk30RMZy8RLGpcQHk4OzhypFve
         bwB6EwYqFsuoDBVmMlRCJ/7J3+Et7UVUl2Ajnr+zqiiZMhm/m51GVgsW+J0pjxljOsFC
         6iG1lxcu7BOd/5Eq9XxkqaDMJiSGriOJBUkKqfY8P73X7gwmftZTywWXj+d4/JRlkEre
         KAIg==
X-Gm-Message-State: APjAAAVPfgrqOPud4BDnhEgV3hKzXW2f9H2pERr1ZNUejJDp2vj94QEh
        Mia+a8EiCCy1BR+xOzicvxm6YiH2
X-Google-Smtp-Source: APXvYqwGmJv4CLVdON+QAVcCgbgl2aXiow0ONPnEGiGPuKuoyTNbtvbGd0o3k7nZOiie/NNxE+j3jQ==
X-Received: by 2002:a1c:61c3:: with SMTP id v186mr1037548wmb.113.1582933118348;
        Fri, 28 Feb 2020 15:38:38 -0800 (PST)
Received: from localhost.localdomain ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id q1sm13762512wrw.5.2020.02.28.15.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 15:38:37 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/5] io_uring: remove io_prep_next_work()
Date:   Sat, 29 Feb 2020 02:37:29 +0300
Message-Id: <6a71864e848e3368fbc7ba493c18bb71e1eb3743.1582932860.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1582932860.git.asml.silence@gmail.com>
References: <cover.1582932860.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io-wq about IO_WQ_WORK_UNBOUND flag only while enqueueing, so it's
useless setting it for a next req of a link. Thet only useful thing
there is io_prep_linked_timeout(). Inline it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index cefbae582b5f..b16cad7ebe40 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -999,17 +999,6 @@ static inline void io_req_work_drop_env(struct io_kiocb *req)
 	}
 }
 
-static inline void io_prep_next_work(struct io_kiocb *req,
-				     struct io_kiocb **link)
-{
-	const struct io_op_def *def = &io_op_defs[req->opcode];
-
-	if (!(req->flags & REQ_F_ISREG) && def->unbound_nonreg_file)
-		req->work.flags |= IO_WQ_WORK_UNBOUND;
-
-	*link = io_prep_linked_timeout(req);
-}
-
 static inline bool io_prep_async_work(struct io_kiocb *req,
 				      struct io_kiocb **link)
 {
@@ -6076,8 +6065,8 @@ static void io_wq_assign_next(struct io_wq_work **workptr, struct io_kiocb *req)
 {
 	struct io_kiocb *link;
 
-	io_prep_next_work(req, &link);
 	*workptr = &req->work;
+	link = io_prep_linked_timeout(req);
 	if (link) {
 		req->work.func = io_link_work_cb;
 		req->work.data = link;
-- 
2.24.0

