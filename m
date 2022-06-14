Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C566C54B3A7
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 16:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238801AbiFNOiO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 10:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245372AbiFNOiG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 10:38:06 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 613761A811
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:38:04 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id h19so8350665wrc.12
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ROudprvWUcWfvZ4cZzMiGRRFxKziH9KPUlRbWRK/uOQ=;
        b=GAMbl+ZtTPaSwzVHjzrdBbNqiOQR2LQPA3kw5MsErPMNIj6kSHvlmE7GDn0dVHMNyi
         D/eZAegiapZhPiL8E1ZVioDz9skdr+DOpeT2CFjE3mhM7dyc3MKa/uLCfWawmW3yG7s2
         2u6B+soOtm1bm4g0vz7gZ6Ho82e+t/Z1vDAfCwWT1VyjOuCmtDjPwVjkjvk/ZiJQUi33
         E10cY7K6SksEwXQQsBeQi5MZi7HLlr8IAe+nMO50PbwAjMcj+Tr3I7mV3XDKm+OZTMaJ
         k/rIZeO6xLthOvO7dZOJpkJtMa1k86gkXjx3TOtCpBuD7LtnhaO2XnPd92cays4uqkZH
         BPqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ROudprvWUcWfvZ4cZzMiGRRFxKziH9KPUlRbWRK/uOQ=;
        b=beezAI3vuGWk9uTCihTx7SWjYaxqlR1n/0A3RJntSi0P3KN9UjJultVkJB/zYIAeP7
         eG7uRz4mBpe/iyBP1WElVYNIEym0r7VflN1buflzfG5PKDqNxZO8mjO6UOb1zlFD/Eux
         WtBn08sBuRWvJ3c6+7xosAEUe3gmBEtzAu6lAALmYVuuk4YKvNYTUka86THjfVBSuuIy
         jxIn5BHX/tNjGrDZWSupwQ97CBg/H13tMCdnNg7p/itslQffze3Cd7wTvgS/j+WrLxjm
         aRMuIbVX9Bb5Ub7O7bFVJ1n9C5wiOY8hnipZzsORTkVJdbfIz7gKp5Ga+PkBB8KUBQjc
         Czzw==
X-Gm-Message-State: AJIora+dnBZ4lvcKSPmZEnV3VayjtFY3PlTmPGotx6KbXxseadvQR7lZ
        NnHOFUxuvVZgZ613CVxwvxLE0c2f0RYH+g==
X-Google-Smtp-Source: AGRyM1ufJnFvraGneiNgRnc51M/mbO6vW0TmZwNSMXYEgUiPZ9bnD4EEGWIUaZxPd5OTRUR2wE5VDw==
X-Received: by 2002:adf:ed0a:0:b0:217:7f86:2e0c with SMTP id a10-20020adfed0a000000b002177f862e0cmr5316773wro.322.1655217482312;
        Tue, 14 Jun 2022 07:38:02 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id a4-20020adff7c4000000b0021033caa332sm12353064wrq.42.2022.06.14.07.38.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 07:38:01 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v2 20/25] io_uring: use state completion infra for poll reqs
Date:   Tue, 14 Jun 2022 15:37:10 +0100
Message-Id: <f020410e5970a68d2471081eeb07ade292e9013d.1655213915.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655213915.git.asml.silence@gmail.com>
References: <cover.1655213915.git.asml.silence@gmail.com>
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

Use io_req_task_complete() for poll request completions, so it can
utilise state completions and save lots of unnecessary locking.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/poll.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 7fc4aafcca95..c4ce98504986 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -234,12 +234,8 @@ static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 
 	io_poll_remove_entries(req);
 	io_poll_req_delete(req, ctx);
-	spin_lock(&ctx->completion_lock);
-	req->cqe.flags = 0;
-	__io_req_complete_post(req);
-	io_commit_cqring(ctx);
-	spin_unlock(&ctx->completion_lock);
-	io_cqring_ev_posted(ctx);
+	io_req_set_res(req, req->cqe.res, 0);
+	io_req_task_complete(req, locked);
 }
 
 static void io_apoll_task_func(struct io_kiocb *req, bool *locked)
-- 
2.36.1

