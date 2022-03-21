Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFF494E33B1
	for <lists+io-uring@lfdr.de>; Tue, 22 Mar 2022 00:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbiCUXA3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Mar 2022 19:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232521AbiCUW6V (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Mar 2022 18:58:21 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFF1D4FC74
        for <io-uring@vger.kernel.org>; Mon, 21 Mar 2022 15:35:48 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id bi12so32786008ejb.3
        for <io-uring@vger.kernel.org>; Mon, 21 Mar 2022 15:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fZipUaEnH3lqZWsLeRn7d/AUlgfgG9F120+tPhzu4Sk=;
        b=Lzeo77XAlVm125r4thaAV92QI9QQB2wByXuozh6QMk0MV1AVSNd+7/6MxrphvusXzk
         VLN/cZ36mT/9QcyZUIZXgO9V1i1YNIdfWz4WtZzwHLwb02yyzRF68HT0qQlxvWyY0+1O
         5yswqWczNfXmA/3Ekf/ZCrN2NRqzRg7lCzJ/d9lBbWc2NGW5dG68vuMzjjLigWfNe6G6
         Puo2otuR6eASxEQ0FFWyv8ZhYE48jvPqMIn3bmrwDnCBqhtHTBuF6kTr9L1BwpceW/vc
         e23BIfoCa2aAvFqaevkVv9mwrurTdUUhZDkHUCZEQBcX/b0kXahJAtj81NuDNf7SfTS4
         CUjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fZipUaEnH3lqZWsLeRn7d/AUlgfgG9F120+tPhzu4Sk=;
        b=NDJSlr4nsoJofylwpuJ8eGJjqrlL0MEVX2hime6czaKhOYX33E4BeiNg+Drgh+QpeU
         YTlo/uJnGZNB6dzDs5RKtBR4vccfxueJeb5iT6kYTNafL0sBTcLBHmozSGYIqvipeqP/
         r1nEhaQMeMT5+rp6rBZd5u/Es4LxKrIyJhRMnxh1Uw9bc4S21+WloHAYGZCr2gKh3717
         EVTjjiXlhonnstmoHzuNZA2mOPkDRRazgmWEIEA31ZNG1rwyrElrAIKz/1uEevyZtP67
         ol41CurkJi0JGU0HbrmBfWC3eIO9/+eP3V3rZezvT7Lvycl0lh7L6GLfpzHJ/kfwEHS5
         t2CA==
X-Gm-Message-State: AOAM5336UYN4p2bNtLzRNtDJa8MUDUB/f2t6Vku1TaNlaUYq8FI+zXaS
        sq4A5xXgVtr1epsk/ck4rVbxTuf2mxr6Xw==
X-Google-Smtp-Source: ABdhPJxyMmxqv9gNK8kqAEbrSm4gn2xK4NRjao9BM42fWlCe2z3MhAVhO3XUi2beLGA3dDO3LJVRsw==
X-Received: by 2002:a05:6402:5202:b0:419:2b9f:7dd3 with SMTP id s2-20020a056402520200b004192b9f7dd3mr11332707edd.224.1647900241295;
        Mon, 21 Mar 2022 15:04:01 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.105.239.232])
        by smtp.gmail.com with ESMTPSA id qb10-20020a1709077e8a00b006dfedd50ce3sm2779658ejc.143.2022.03.21.15.04.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 15:04:01 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 5/6] io_uring: move poll recycling later in compl flushing
Date:   Mon, 21 Mar 2022 22:02:23 +0000
Message-Id: <31dfe1dafda66ba3ce36b301884ec7e162c777d1.1647897811.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1647897811.git.asml.silence@gmail.com>
References: <cover.1647897811.git.asml.silence@gmail.com>
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

There is a new (req->flags & REQ_F_POLLED) check in
__io_submit_flush_completions() for poll recycling, however
io_free_batch_list() is a much better place for it. First, we prefer it
after putting the last req ref just to avoid potential problems in the
future. Also, it'll enable the recycling for IOPOLL and also will place
it closer to all other req->flags bits clean up requests.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 36bcfcc23193..79294a7455d6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2650,6 +2650,15 @@ static void io_free_batch_list(struct io_ring_ctx *ctx,
 				if (!req_ref_put_and_test(req))
 					continue;
 			}
+			if ((req->flags & REQ_F_POLLED) && req->apoll) {
+				struct async_poll *apoll = req->apoll;
+
+				if (apoll->double_poll)
+					kfree(apoll->double_poll);
+				list_add(&apoll->poll.wait.entry,
+						&ctx->apoll_cache);
+				req->flags &= ~REQ_F_POLLED;
+			}
 			io_queue_next(req);
 			if (unlikely(req->flags & IO_REQ_CLEAN_FLAGS))
 				io_clean_op(req);
@@ -2688,15 +2697,6 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 
 			if (!(req->flags & REQ_F_CQE_SKIP))
 				__io_fill_cqe_req(req, req->result, req->cflags);
-			if ((req->flags & REQ_F_POLLED) && req->apoll) {
-				struct async_poll *apoll = req->apoll;
-
-				if (apoll->double_poll)
-					kfree(apoll->double_poll);
-				list_add(&apoll->poll.wait.entry,
-						&ctx->apoll_cache);
-				req->flags &= ~REQ_F_POLLED;
-			}
 		}
 
 		io_commit_cqring(ctx);
-- 
2.35.1

