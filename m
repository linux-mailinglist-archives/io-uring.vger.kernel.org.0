Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B42054B3A0
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 16:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235339AbiFNOh7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 10:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347316AbiFNOhx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 10:37:53 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41E08219C
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:37:53 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id v14so11585026wra.5
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S94zs6oiwyxg9I3NOeaPA1zyFabatRdXZPpjQjN6XFg=;
        b=npdYI4kZDZ8RktRge70L5dHrSMQvOgs0FLocrcrhBq4e4dCKCYyHY2KLXtTwuLraLu
         lXQwIjxijVsYrYukL2OY3S18Yxn2qZDGusxEsmIRJs0hwcx1qIFd816PX14/qHgs6gvh
         3AjWlwVZZ86iLTIk8D0H7V5Z5k4J+j1tPnxKU/fy74TxKPyNWZLBDSIQZxBsuB0JGomB
         0AwJpaTdeGAky97MbK8WhvPg6Qc9Gv0COllTCZ9sm5ZxvhVM8Ex+OdHcnN/slsjWL62C
         LT15xKUPeJJC13XRn0/jK57kHUsj9odGvxq4HCXPkUbLY6+AoVuMzFkT+44DpMPHsOMY
         zvow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S94zs6oiwyxg9I3NOeaPA1zyFabatRdXZPpjQjN6XFg=;
        b=t7wL/LZBu/uVZxWpM4Ht91347hxI93Nw2devvi5/GY3Ld1PtJV1FvlK/qr7074k99i
         APp3gz9x2kPgG75XnRjrg9zjX0iSmOZi7iIgBSXDBYfUA2wjkp1Vdei25kGmmZEbBT4N
         Zcv4PkKxE7U4TXAj0eanYdKOP2rb/3Klt/ARuB9lZVdPpAxvw+/0RDecFZu/o4uptYDh
         9so5ntXipH974QT4s9aDlrTH9US9jVJ8NvHuV5I8uZ8Uu3Wb1ZpOpSK/SvjklW2r9gf6
         Ljw7Bn0Jkm5oDW50nE2M750pHNC10aLuCbXXJSQUTzovGWZ+3Vho5vn33VKrXMThD8x6
         iCFw==
X-Gm-Message-State: AJIora8krkDTe0r9BhPxpD5zKl8opjY6/lndNwrrpHGUQNbxns8Z2N36
        PMooxO9dMy/4Rj0oTkd1aOydYy0Fy77VQw==
X-Google-Smtp-Source: AGRyM1scPg0tfWZO5WQUoSwUiGjGGaecX4AmUgmsoJxvumw43/tprrVJm3cWbuf3LoDzgOcjQ9w1uA==
X-Received: by 2002:a5d:6da3:0:b0:211:3597:62b1 with SMTP id u3-20020a5d6da3000000b00211359762b1mr5361834wrs.660.1655217471445;
        Tue, 14 Jun 2022 07:37:51 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id a4-20020adff7c4000000b0021033caa332sm12353064wrq.42.2022.06.14.07.37.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 07:37:51 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v2 11/25] io_uring: refactor io_req_task_complete()
Date:   Tue, 14 Jun 2022 15:37:01 +0100
Message-Id: <60f4b51e219d1be0a390d53aae2e5a19b775ab69.1655213915.git.asml.silence@gmail.com>
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

Clean up io_req_task_complete() and deduplicate io_put_kbuf() calls.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index fcee58c6c35e..0f6edf82f262 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1857,15 +1857,19 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 
 	return ret;
 }
-inline void io_req_task_complete(struct io_kiocb *req, bool *locked)
+
+void io_req_task_complete(struct io_kiocb *req, bool *locked)
 {
-	if (*locked) {
-		req->cqe.flags |= io_put_kbuf(req, 0);
+	if (req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING)) {
+		unsigned issue_flags = *locked ? IO_URING_F_UNLOCKED : 0;
+
+		req->cqe.flags |= io_put_kbuf(req, issue_flags);
+	}
+
+	if (*locked)
 		io_req_add_compl_list(req);
-	} else {
-		req->cqe.flags |= io_put_kbuf(req, IO_URING_F_UNLOCKED);
+	else
 		io_req_complete_post(req);
-	}
 }
 
 /*
-- 
2.36.1

