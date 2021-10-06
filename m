Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90802424A64
	for <lists+io-uring@lfdr.de>; Thu,  7 Oct 2021 01:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbhJFXPb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Oct 2021 19:15:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231223AbhJFXP3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Oct 2021 19:15:29 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B457C061755
        for <io-uring@vger.kernel.org>; Wed,  6 Oct 2021 16:13:37 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id p80so4641564iod.10
        for <io-uring@vger.kernel.org>; Wed, 06 Oct 2021 16:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fB0J1oLaWn8aQX1qmT2pF+15JxKPoNeiCpTQYqkrAY4=;
        b=nLas33MUIpZaohjazlCL17urrtmqiKZ3QzMe/8Om2Fpq5nCQQwiuLkYYuUviOpjacy
         VSqAu7nWldscev6+JBRyILC0rX1rrfCu6TUlWdG5CZwDgClU8DzgW22kUQ3WZi9UfZSm
         u/AcvsJotbJPNr5Bkugzbdak0iZLfJcMbYFTB7RWD2nOtJTYbzjCjdb4ZLp1yXEVNccx
         HnALQWp2Fa1RyGTI4dTH50GP+lgJlIJu/abSLCJAMGWQw+cIV2QxflOOTfYgQaWQMv48
         Vi4p35pX0oCT1fMS9jWIXM7T7YgyRPT7JiQyWwhWV4FYo4vgMs+JoY2dM3v9YRTyUlRK
         PECA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fB0J1oLaWn8aQX1qmT2pF+15JxKPoNeiCpTQYqkrAY4=;
        b=WAR7e0J4SZQoinVcTVccxf+2OppsIhph0qmCBzSSQ42kP3PUWA5RrBhAfNkQ+W3iYx
         rSjGBjiCjvt7oHY+y9cH+QhMdKFS1HQVO+a0qNN62Zmr4saJkM0s8E3LKr9GbBpVUcHX
         /vlircCbx7pYy8YxwwxwAh9SsZ9Xa3dpVUfsjAgP5bTDqj0sYTpOzuMNuOEr5A8fk5/Q
         /gb3KozVtwU9C53b4K+tOoAVAfMqo7VwNeDzROGZ3s1H6wdbKDT6QYEsPVQZoHpLnJK7
         jVJA+xKhWyV1aIYFKgcSE2pT8fYOUzCBc+Ku054vBKuo8j9mCpTGSxOfAcq/svrOoA0Q
         suNg==
X-Gm-Message-State: AOAM533WQUtpZ9SolQldzR5QxZnUYU7XAgVwF3z3F+7/F6tvqpY/4GHF
        bCTAhApIQA3QouYVMijaWWj+cQ==
X-Google-Smtp-Source: ABdhPJw0I/o3+XDl8OxTztxBYD/piLLj1nuhTQ8r5NvmhLggRDnuU+3L1lqRAAeRa8IGwiWX/YKUew==
X-Received: by 2002:a02:c7d2:: with SMTP id s18mr385807jao.68.1633562016617;
        Wed, 06 Oct 2021 16:13:36 -0700 (PDT)
Received: from p1.localdomain ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id o1sm12955203ilj.41.2021.10.06.16.13.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 16:13:36 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-block@vger.kernel.org
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring: inform block layer of how many requests we are submitting
Date:   Wed,  6 Oct 2021 17:13:30 -0600
Message-Id: <20211006231330.20268-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211006231330.20268-1-axboe@kernel.dk>
References: <20211006231330.20268-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The block layer can use this knowledge to make smarter decisions on
how to handle the request, if it knows that N more may be coming. Switch
to using blk_start_plug_nr_ios() to pass in that information.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 73135c5c6168..90af264fdac6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -316,6 +316,7 @@ struct io_submit_state {
 
 	bool			plug_started;
 	bool			need_plug;
+	unsigned short		submit_nr;
 	struct blk_plug		plug;
 };
 
@@ -7027,7 +7028,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		if (state->need_plug && io_op_defs[opcode].plug) {
 			state->plug_started = true;
 			state->need_plug = false;
-			blk_start_plug(&state->plug);
+			blk_start_plug_nr_ios(&state->plug, state->submit_nr);
 		}
 
 		req->file = io_file_get(ctx, req, READ_ONCE(sqe->fd),
@@ -7148,6 +7149,7 @@ static void io_submit_state_start(struct io_submit_state *state,
 {
 	state->plug_started = false;
 	state->need_plug = max_ios > 2;
+	state->submit_nr = max_ios;
 	/* set only head, no need to init link_last in advance */
 	state->link.head = NULL;
 }
-- 
2.33.0

