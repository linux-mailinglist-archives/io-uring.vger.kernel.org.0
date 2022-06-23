Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62A22557CDB
	for <lists+io-uring@lfdr.de>; Thu, 23 Jun 2022 15:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbiFWNZd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jun 2022 09:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231228AbiFWNZa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jun 2022 09:25:30 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6212C49C94
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 06:25:29 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id z17so11030751wmi.1
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 06:25:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K1E1JLCe4USh2kriw3egu2gKlFBp9BC0Bq/laD0bxNE=;
        b=HMDtfNCV2sLqSQO6JuzTDSn3fFQl+f3NAC1m0lSuhIrF8gO0H67gATLcM3hyqWKK3i
         yqEnfvUs1rOtQP8B0XBvnigNukWLlasFHy7VR2vGPW7EC3U7kR2gw6cq3AR7RbaKSu8J
         L0eJivenSjonQas6tos6mNaJuUifH1EW8VLmh8Ig8kwGNAO+FrZQXFTaiFTtQwt7Lg57
         JjacqmTT5idjbc7Pn881nH0TaFBIuo/5DnngXOhHymCI/YS/REF1mqnnKYDDz9ff0554
         Utr7kf1eRnGHj35eERZdAzDEnIlNZ05b54oa6fjLsq7LZQXCpKCCitjxEyixAun7voe9
         QObA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K1E1JLCe4USh2kriw3egu2gKlFBp9BC0Bq/laD0bxNE=;
        b=249xgPYLTrIcrYqkELuboGO6feqd8tPH4kMfcGiOmIVCg6US/xsCHyyAQcRwOwLNu3
         dbRJEKpWYwwHOHZaaZrTOYy9QmUhPZGyVyCeGzRqhSJ+atfa6ZXhiEo1pNJi6I9ZyEfm
         RE3bMeskxlepHviikaGp+7wGdPy/KVmVKaUIrLmtuNSzNFVaz2u5KquipfUBbOI36zK3
         Bjg5uXIg3TTY+Zwtbo4h0mp9qO40rhOHF5eG4LLJDBiJOD3YaVCSd11XOozIO6s6zqFV
         DYpiRURuyTaH6eYErjHUhlUJ4fZgY1jLZwjoqKNWUrdMirzNDr5hRAnjw7fYrPMTs9R7
         bCtA==
X-Gm-Message-State: AJIora+gMsKUcSgc/ZYQjgAk6XhRODJAmFGX2NWFaE+elETdAI0t9s2T
        ROwwmGb9s9r8yVmgc56Vt+9J0gvojxLbxxJl
X-Google-Smtp-Source: AGRyM1veqWP32CFObkXU+/SiHC1oLR9PPbW8iKBBqCjEzfJc7NzSnh3MG2C1HtdqOOzIGVznmuAq5g==
X-Received: by 2002:a1c:720f:0:b0:3a0:2ac9:5231 with SMTP id n15-20020a1c720f000000b003a02ac95231mr4171519wmc.39.1655990727732;
        Thu, 23 Jun 2022 06:25:27 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id z14-20020a7bc7ce000000b0039c5a765388sm3160620wmk.28.2022.06.23.06.25.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 06:25:27 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v2 4/6] io_uring: change arm poll return values
Date:   Thu, 23 Jun 2022 14:24:47 +0100
Message-Id: <529e29e9f97f2e6e383ccd44234d8b576a83a921.1655990418.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655990418.git.asml.silence@gmail.com>
References: <cover.1655990418.git.asml.silence@gmail.com>
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

The rules for __io_arm_poll_handler()'s result parsing are complicated,
as the first step don't pass return a mask but pass back a positive
return code and fill ipt->result_mask.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/poll.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index aef77f2a8a9a..80113b036c88 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -34,6 +34,8 @@ struct io_poll_table {
 	struct io_kiocb *req;
 	int nr_entries;
 	int error;
+	/* output value, set only if arm poll returns >0 */
+	__poll_t result_mask;
 };
 
 #define IO_POLL_CANCEL_FLAG	BIT(31)
@@ -462,8 +464,9 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 	if (mask &&
 	   ((poll->events & (EPOLLET|EPOLLONESHOT)) == (EPOLLET|EPOLLONESHOT))) {
 		io_poll_remove_entries(req);
+		ipt->result_mask = mask;
 		/* no one else has access to the req, forget about the ref */
-		return mask;
+		return 1;
 	}
 
 	if (!mask && unlikely(ipt->error || !ipt->nr_entries)) {
@@ -813,7 +816,7 @@ int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
 
 	ret = __io_arm_poll_handler(req, poll, &ipt, poll->events);
 	if (ret) {
-		io_req_set_res(req, ret, 0);
+		io_req_set_res(req, ipt.result_mask, 0);
 		return IOU_OK;
 	}
 	if (ipt.error) {
-- 
2.36.1

