Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 178864DDAF8
	for <lists+io-uring@lfdr.de>; Fri, 18 Mar 2022 14:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236895AbiCRNzK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Mar 2022 09:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236904AbiCRNzJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Mar 2022 09:55:09 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A5AC192368
        for <io-uring@vger.kernel.org>; Fri, 18 Mar 2022 06:53:50 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id u10so11832684wra.9
        for <io-uring@vger.kernel.org>; Fri, 18 Mar 2022 06:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Cotu7f1hSNtQkSjMN6OlZm9xjjg5JZZExS/3eskPU7A=;
        b=qpBS4npP0fw1+p1JUMyp2XBL4ix+1iYtqpDfpfjEsfE5B3knqa8MQnNyK5z5Lop9pc
         jo1BoyC/QKl0FPH65zAtvcEDxD4KvGJ8zLhJ1HnfuNxiCDth1qMss6n8w6IpSkXVe/ML
         fH33319oHlD4HynWvqELoFqPrXEEakyHM/nM4yy2FRr//6+0lG3Z4otKMYzoAEs1xYTD
         iklK0sL03K4f9FzisZYjoNZYFR3WR21UTjdy+kjbJXexpSg4Ln4qft6MmrDKt9hpTd7g
         rnyfx7DhXZGFI1BYdN0KzdNiQmhY0jUteisvRQWCWr8iv7hcvRMqoKSMJcD3AUbYr8R9
         gSsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cotu7f1hSNtQkSjMN6OlZm9xjjg5JZZExS/3eskPU7A=;
        b=GZ8RLLytI6LlH+fL5uMB9rSYzjRUHB5n/QtYakzeRdv/VXXYaDXTk++cVYmgHPT0ol
         3pYF6E0Rt0fJllGgO7w3rCjCf3sV7hUe546CLzNJW+0QJk4vQkQ1p6D0b0kN91vBh+TM
         L9g+u5vN0SAUp6zteRvprtewdc3jhKJMXLFfF8Mi5xl4OoyGjU2DkVu9B7IgrVOx2w8U
         jCi6yUjCu24LXjiC/4k//E07H+WySE0Y8aEzeHxY05nFlPEUyGcaNbnp3SGoyYLFX1xA
         HfcRrxI3DrZ5RMAfwIFaSzeIbtNwyr34zZrDU1mFOEu02BBSI8Tz4w58TX1NSCqFJblp
         aaJA==
X-Gm-Message-State: AOAM530yTdyI7ETe5Y9DoNCnv8cC/iRmlWs5jnqi5A+n0ZxmBY0T0usF
        izoU0FMKoY8GN8Qs8/7/APVGJol0VCPFjg==
X-Google-Smtp-Source: ABdhPJxtIEv5ysXZCa9EtLYtvwwZK/tYKVEfeDR1A/r7yWTv5eYNsef1WhFbXh/rHXhV6vvvt7t9Zg==
X-Received: by 2002:a5d:5847:0:b0:203:8c46:9e1e with SMTP id i7-20020a5d5847000000b002038c469e1emr8706778wrf.350.1647611629231;
        Fri, 18 Mar 2022 06:53:49 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.234.70])
        by smtp.gmail.com with ESMTPSA id j8-20020a05600c1c0800b0038c8da4d9b8sm1290375wms.30.2022.03.18.06.53.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 06:53:48 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 2/4] io_uring: get rid of raw fill_cqe in io_fail_links
Date:   Fri, 18 Mar 2022 13:52:21 +0000
Message-Id: <37cd4691cf4fd7388f26c6be57fa588966f46371.1647610155.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1647610155.git.asml.silence@gmail.com>
References: <cover.1647610155.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Replace fill_cqe insside of io_fail_links with tw. The CQE ordering
guarantees rely on the fact that io_uring's tw's are executed in order.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0e04e0997d7d..fff66f4d00c4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2335,11 +2335,13 @@ static void io_fail_links(struct io_kiocb *req)
 		trace_io_uring_fail_link(req->ctx, req, req->user_data,
 					req->opcode, link);
 
-		if (!ignore_cqes) {
+		if (!ignore_cqes)
 			link->flags &= ~REQ_F_CQE_SKIP;
-			io_fill_cqe_req(link, res, 0);
-		}
-		io_put_req_deferred(link);
+		/*
+		 * linked CQEs should be ordered, we rely on the tw
+		 * infrastructure executing them in the right order
+		 */
+		io_req_tw_queue_complete(link, res);
 		link = nxt;
 	}
 }
-- 
2.35.1

