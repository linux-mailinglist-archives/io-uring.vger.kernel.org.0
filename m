Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 438BE552DFB
	for <lists+io-uring@lfdr.de>; Tue, 21 Jun 2022 11:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346840AbiFUJK3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jun 2022 05:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243660AbiFUJK2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Jun 2022 05:10:28 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62C025F52
        for <io-uring@vger.kernel.org>; Tue, 21 Jun 2022 02:10:27 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id cw10so2341362ejb.3
        for <io-uring@vger.kernel.org>; Tue, 21 Jun 2022 02:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hlxs5bU33Wc66tGL6gcQaBQ2czbjqt6oRXLAavmsM1Y=;
        b=Z2LGjPfQvvCTjHWD4RCt8suG1laOscn3VqyaWXEjd+op/QYCjX5Yt0APFCWFDeZBon
         jxy0JQTOJ1bIJzGWSloH83324g/DGJExnGDxd6gv9YiXVQ3fbbocjFR6CLN3XWBehW+Y
         JN06S621zFk4DiPpPXDRvwPObBEfkcLEpNpIlQfB+b6VBE7Oc+vZm/eH4ktbMh2Vqjwi
         VvHrn/7E9Ru6+6fp+LkdT43VSgi697176TpntW+bW7nB5hCqFb3o0Jy8ZDUAijb7LXp8
         +eHLsLINuRH8ZAUm08a/WCopwW7sV8hO49hqVSYkZib/2/W078NeDT86MkX5RjTqDdeo
         WtNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hlxs5bU33Wc66tGL6gcQaBQ2czbjqt6oRXLAavmsM1Y=;
        b=s/6U9BrQnRxpyo88tm/6ZUY+bN26/kesEiTZfny6AWDyUCYC2yejk98u5rPA9C7/BI
         jdMmIg2Yrs6pIC0EECmTEz5yeKZ8v9PLK2LoLoYj9NNNL3rcyClQbXROL7XzMASKZmwY
         bjoBUAFhprF7gNi2E4gE0/sM8XCbdWtFq6Ua0r43RxiXoCtZMjuL2LUyyTdLMOBU+Vy0
         6cBSxjL+4m+cEYry0CHJnaSVhrKlF8+jHnhQX9HvPjBdeAdVnEeFxQDQjkJdEj1pIwki
         qzRvvfp09Qw6q9sQupH5cmB67m1Ke9agUgCqqvhSp4lbcgQ1cawfRnX3NBUrK5KaM/cq
         /JQA==
X-Gm-Message-State: AJIora8TZ2nWvPdzTJpB7/V6N+kfsPN4rtoCp47lYWOHPuuf5vhBVa7Z
        gkMh9VywjSD2FPdtzx4kXjmMMD2EOZMemw==
X-Google-Smtp-Source: AGRyM1usipu4an35/AXW3J79FWhB1VBf0cgNPIe0s6t4dztT85Zeyi79BdEwTFGItId+GTpO3jMphw==
X-Received: by 2002:a17:906:20c6:b0:716:646d:c019 with SMTP id c6-20020a17090620c600b00716646dc019mr24443875ejc.529.1655802625599;
        Tue, 21 Jun 2022 02:10:25 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:d61a])
        by smtp.gmail.com with ESMTPSA id cq18-20020a056402221200b00435651c4a01sm9194420edb.56.2022.06.21.02.10.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 02:10:25 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 1/4] io_uring: fix poll_add error handling
Date:   Tue, 21 Jun 2022 10:08:59 +0100
Message-Id: <f985e22429cbcb207536b7f4818350c2f2e1b8a4.1655802465.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655802465.git.asml.silence@gmail.com>
References: <cover.1655802465.git.asml.silence@gmail.com>
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

We should first look at the return value of __io_arm_poll_handler() and
only if zero checking for ipt.error, not the other way around. Currently
we may enqueue a tw for such request and then release it inline causing
UAF.

Fixes: 9c1d09f56425e ("io_uring: handle completions in the core")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/poll.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 8f4fff76d3b4..528418aaf3f6 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -782,16 +782,11 @@ int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
 		req->flags &= ~REQ_F_HASH_LOCKED;
 
 	ret = __io_arm_poll_handler(req, poll, &ipt, poll->events);
-	if (ipt.error) {
-		return ipt.error;
-	} else if (ret > 0) {
+	if (ret) {
 		io_req_set_res(req, ret, 0);
 		return IOU_OK;
-	} else if (!ret) {
-		return IOU_ISSUE_SKIP_COMPLETE;
 	}
-
-	return ret;
+	return ipt.error ?: IOU_ISSUE_SKIP_COMPLETE;
 }
 
 int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
-- 
2.36.1

