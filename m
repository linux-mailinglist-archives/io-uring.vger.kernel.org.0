Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F11E5332FF
	for <lists+io-uring@lfdr.de>; Tue, 24 May 2022 23:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241914AbiEXVhe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 24 May 2022 17:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241898AbiEXVhd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 24 May 2022 17:37:33 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0331C7C179
        for <io-uring@vger.kernel.org>; Tue, 24 May 2022 14:37:33 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id j6so17532162pfe.13
        for <io-uring@vger.kernel.org>; Tue, 24 May 2022 14:37:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lgzn2/RNupZuM19wVXWP3Kb3O3MsoN+ITbAK60/ayrA=;
        b=PguG1nrHMNp1L2LFUmj1GMgG+cSxNkTJHN9wATHFGJUE8pFUKGEnPG7R38AI/gAEbC
         h7DFgpgYP+f8VOUOzN5WjjZ3d9i8DKh9PzFZUEjyoHL7TV3q6cOh1H0plyw++Wi+fPOP
         BY/fC4yHugq93tlVi2Sovu3HQZyQUmw6tFgt6lyHQaaMEZympLAo85/3MzaxoDm0vNVF
         F1afpc6GJvJPHwMHAqws0c2HzyYIiDDHjXkJHSKHIT57WUo4S9eZPGx8CoKAAksMUNCT
         uKY4KCeeunE+sXWvWcs3cJDHNLtI9CV5z90Og/1gHlP4AUXJx3zBx/dJA2P6Dxg0O7IA
         dmVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lgzn2/RNupZuM19wVXWP3Kb3O3MsoN+ITbAK60/ayrA=;
        b=5xPQ5Xt+DrBzgTnWkTXqXfo85uQZkDQZNEqZIOjcFUjIJcA9lfcRL5iBXogVzaMYFD
         j4FSG+CSSvYnaBAK95FXWKhOPc/EBny7Y4DyScBNnERvQeh+gXagb1XpUl3D/b3hJfnD
         y9uMS0zZhR2Xjdr/a1qrBi6OS4gsWTyYLQ1MnyzC3pj9g/L6TnO+TpJCBmDo0SW2mkFq
         BGSlfxTpWlOq+oFAydE7XmamAx+2g55ztJRA4Ggc+y3PfG7FOWzjBH6/oFthRGmCcMkV
         FW6ZD3EpgAJNHhdVSTgu6zhZjvXJJyWQSy7cd6GN3Lz6lRkrJLXMAU0Fnyk5mzeFvwMh
         QTPg==
X-Gm-Message-State: AOAM533NUmddo9K0D45sqx95dnPuz10h/vopoeW1HvT25sX7WTnvz3YJ
        1V+abqIyuveyGbK1QHCqwpL6Zp3cv4Xlqg==
X-Google-Smtp-Source: ABdhPJxAdtAjfW7yYfGn55nhXeGwvZZ6Gb0L4+lI0r1GmdzJnmb+uRg90M2QDZHYgbl58nkaoBZ0tQ==
X-Received: by 2002:a63:104a:0:b0:3fa:d1ea:54d7 with SMTP id 10-20020a63104a000000b003fad1ea54d7mr1166284pgq.124.1653428252092;
        Tue, 24 May 2022 14:37:32 -0700 (PDT)
Received: from localhost.localdomain ([2600:380:4a61:523:72ca:65a5:f684:5e4])
        by smtp.gmail.com with ESMTPSA id k21-20020a170902761500b0015e8d4eb1easm7834327pll.52.2022.05.24.14.37.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 14:37:31 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/6] io_uring: make timeout prep handlers consistent with other prep handlers
Date:   Tue, 24 May 2022 15:37:22 -0600
Message-Id: <20220524213727.409630-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220524213727.409630-1-axboe@kernel.dk>
References: <20220524213727.409630-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

All other opcodes take a {req, sqe} set for prep handling, split out
a timeout prep handler so that timeout and linked timeouts can use
the same one.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9f1c682d7caf..c3991034b26a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7698,8 +7698,9 @@ static int io_timeout_remove(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
-static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
-			   bool is_timeout_link)
+static int __io_timeout_prep(struct io_kiocb *req,
+			     const struct io_uring_sqe *sqe,
+			     bool is_timeout_link)
 {
 	struct io_timeout_data *data;
 	unsigned flags;
@@ -7754,6 +7755,18 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	return 0;
 }
 
+static int io_timeout_prep(struct io_kiocb *req,
+			   const struct io_uring_sqe *sqe)
+{
+	return __io_timeout_prep(req, sqe, false);
+}
+
+static int io_link_timeout_prep(struct io_kiocb *req,
+				const struct io_uring_sqe *sqe)
+{
+	return __io_timeout_prep(req, sqe, true);
+}
+
 static int io_timeout(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -8039,13 +8052,13 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	case IORING_OP_CONNECT:
 		return io_connect_prep(req, sqe);
 	case IORING_OP_TIMEOUT:
-		return io_timeout_prep(req, sqe, false);
+		return io_timeout_prep(req, sqe);
 	case IORING_OP_TIMEOUT_REMOVE:
 		return io_timeout_remove_prep(req, sqe);
 	case IORING_OP_ASYNC_CANCEL:
 		return io_async_cancel_prep(req, sqe);
 	case IORING_OP_LINK_TIMEOUT:
-		return io_timeout_prep(req, sqe, true);
+		return io_link_timeout_prep(req, sqe);
 	case IORING_OP_ACCEPT:
 		return io_accept_prep(req, sqe);
 	case IORING_OP_FALLOCATE:
-- 
2.35.1

