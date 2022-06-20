Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48BB0550DD8
	for <lists+io-uring@lfdr.de>; Mon, 20 Jun 2022 02:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237288AbiFTA0m (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Jun 2022 20:26:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237232AbiFTA0l (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Jun 2022 20:26:41 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 829E3A1B0
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 17:26:40 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id z9so4950554wmf.3
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 17:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mrkOxIqYNTJX3Mqz4qXBAvXoRisCgrhflp6PCeCHkxE=;
        b=hcaMhZuTGE53VE1ov4y1o8qudccp9i58HZSDcSoPvIUZiKY1eRU67N8/fl4LiskIog
         u1/pKJgQBEdzmRMN8xifhC+leUsNyV+lYsaNgopKEzlypSuvoJ716VYLgQRLqSac4MzT
         dPR1WUGm0NUJrxwDHXZ1er9fP1uqUAsEZe3FcC73/sgxAAkSK37Njler+hBMv29hilRl
         k01y9Nvf8C2fvW3g3p//fwzgMlHJ3RexyySVQ2/r3cBuZWXvdwRbH0u6rFnt8LVoswHO
         TLK3wX5wG8g6SXnftwpJ2gUNrro0x8BTs7cKLOpm/xLaby2122bEkfkOcyUcHdVAxPhg
         1wiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mrkOxIqYNTJX3Mqz4qXBAvXoRisCgrhflp6PCeCHkxE=;
        b=s3s17+Rp7+CB3/gyj7kP8PI290Ro3ZeKQV1TRjMVLeSiT1KOmt28CSWoOP8WSv9Q7P
         /Yv0OwBvKZdtkHzgU+ggZ0HRthZhacdy6yHpYJEXysQaHtVIeyG2/H8WSj0cHnpkWHj0
         pCmSDT6g6Na2kT2eeHKUSQe8B72UtH7B1tLfjFYZbyn2KZkximUKQpdNcrZ2xcyh2n23
         B+bpTAgjMzHZy+xsouTOpEmyeQ9WMGhoxjYRZR7uVjRXeVZpGKsuCqgDbamXx5cPSylv
         8Gk0ZF2ydB4kbu39rKKgUKxMyGGY+qIvxHRK3Xk7KdjCeVRXwuUJAF2BsZYEyBr2007M
         bzBQ==
X-Gm-Message-State: AOAM533ndvznoOMHRC500ItmUwaHojPLi/usprt1Adz76R4mHyz9kZNE
        K8rxxHsGwVFde/0pNpJTVAbUXFkgPorRvQ==
X-Google-Smtp-Source: ABdhPJxCweayE/Wm7eTR6A5/L5fRVBgkUYGUnWhSAletns3al3K1zkzDpxb/23v45uBQoMWt6as3MA==
X-Received: by 2002:a05:600c:1ca5:b0:39b:a66b:7805 with SMTP id k37-20020a05600c1ca500b0039ba66b7805mr31522250wms.87.1655684799851;
        Sun, 19 Jun 2022 17:26:39 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id h18-20020a5d4312000000b002167efdd549sm11543807wrq.38.2022.06.19.17.26.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jun 2022 17:26:39 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 09/10] io_uring: consistent naming for inline completion
Date:   Mon, 20 Jun 2022 01:26:00 +0100
Message-Id: <797c619943dac06529e9d3fcb16e4c3cde6ad1a3.1655684496.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655684496.git.asml.silence@gmail.com>
References: <cover.1655684496.git.asml.silence@gmail.com>
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

Improve naming of the inline/deferred completion helper so it's
consistent with it's *_post counterpart. Add some comments and extra
lockdeps to ensure the locking is done right.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c |  4 ++--
 io_uring/io_uring.h | 10 +++++++++-
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 0be942ca91c4..afda42246d12 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1380,7 +1380,7 @@ void io_req_task_complete(struct io_kiocb *req, bool *locked)
 	}
 
 	if (*locked)
-		io_req_add_compl_list(req);
+		io_req_complete_defer(req);
 	else
 		io_req_complete_post(req);
 }
@@ -1648,7 +1648,7 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (ret == IOU_OK) {
 		if (issue_flags & IO_URING_F_COMPLETE_DEFER)
-			io_req_add_compl_list(req);
+			io_req_complete_defer(req);
 		else
 			io_req_complete_post(req);
 	} else if (ret != IOU_ISSUE_SKIP_COMPLETE)
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index afca7ff8956c..7a00bbe85d35 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -222,10 +222,18 @@ static inline void io_tw_lock(struct io_ring_ctx *ctx, bool *locked)
 	}
 }
 
-static inline void io_req_add_compl_list(struct io_kiocb *req)
+/*
+ * Don't complete immediately but use deferred completion infrastructure.
+ * Protected by ->uring_lock and can only be used either with
+ * IO_URING_F_COMPLETE_DEFER or inside a tw handler holding the mutex.
+ */
+static inline void io_req_complete_defer(struct io_kiocb *req)
+	__must_hold(&req->ctx->uring_lock)
 {
 	struct io_submit_state *state = &req->ctx->submit_state;
 
+	lockdep_assert_held(&req->ctx->uring_lock);
+
 	wq_list_add_tail(&req->comp_list, &state->compl_reqs);
 }
 
-- 
2.36.1

