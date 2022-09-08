Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDED5B22EE
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 17:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbiIHP7G (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 11:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbiIHP7F (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 11:59:05 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B490F7546
        for <io-uring@vger.kernel.org>; Thu,  8 Sep 2022 08:59:04 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id lz22so18247624ejb.3
        for <io-uring@vger.kernel.org>; Thu, 08 Sep 2022 08:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=djYdNzXWZEtmnQhM1MYMHWws4q0FI7BUKIiZyuQPvkA=;
        b=g1Xq2d+q8JLBTZIE0j2J4dUEvqy5lkzYuwyNG9QlUJlIcQm3tsIekgWl8aimIcLrqs
         AA1HZ4PHe+7cEh8ZCnGb35fBu+aBgrJN7LO/ev1+aWJ3YogpQe8zSb0+pnu5LyK6e5Ki
         INypVmeupLt/2P0JtNP1LZz6yQ8ZjbaiCx5WROi3iyoouRG/wBBPJ1brXo3w9SvtBwGv
         H+D9xe7l1TcRBv6pA41hnyH7lc52M/Ec3c6y5oODQ4uF4Zi4ySKESOG3EzQKTEfbWgwA
         j4bE+MtfnkxG9CwqZn+8tMXyQkiJN9XOIERhlrggxCcOFL1xPMpwCRbAHtJzKVLur3+O
         NWkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=djYdNzXWZEtmnQhM1MYMHWws4q0FI7BUKIiZyuQPvkA=;
        b=TUs5gIxXPPOzNX/Dac0hcex8aLWNp6grMucJ96oTy9ZqypP8iXtjXraLLXs6nfB9g/
         u8ZmZ8KmNwsqyZfV9ObG+/KVoTaU+Pwtwo+bgaDr7vNyaeELuGZkk5P7PEw1awPn+TtV
         sqLWklnU5w9PjFhIkFoWzR/Wps4UGpXycQMa9B73h4aWTfN5OyuPdz6+C/jXtX7mWVGz
         Fdq82/ln+SpXeOt4/PNfoEHCwY+R2Vr7XOEPMu5K/B36lggZ/hpBfq/Byu8AJZZOOHID
         YtYhgKdrdSddmIFnVb/lOMRoq6FSgN7KF5qdP3COzIUpHthXrpALQtYo/CdmetChLsiM
         2+9g==
X-Gm-Message-State: ACgBeo2cey6zI36ZcAaXbRrWgfclhDa9kfx6WR/FlWiz1jY2J70aztMw
        16LbD2ePXCQmfEADng+GHQ5gTiaSIDY=
X-Google-Smtp-Source: AA6agR6MFe7vTAFz0crNTi8xGBvLnqUvC2hRwUdm/PzYzUHVLFs91moi84B089u7fQ3F4cwJ6MTSuA==
X-Received: by 2002:a17:906:ef90:b0:730:9d18:17b3 with SMTP id ze16-20020a170906ef9000b007309d1817b3mr6810418ejb.141.1662652742579;
        Thu, 08 Sep 2022 08:59:02 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:cfb9])
        by smtp.gmail.com with ESMTPSA id q26-20020a1709060e5a00b0073872f367cesm1392503eji.112.2022.09.08.08.59.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 08:59:02 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH 4/6] io_uring/iopoll: unify tw breaking logic
Date:   Thu,  8 Sep 2022 16:56:55 +0100
Message-Id: <d2fa8a44f8114f55a4807528da438cde93815360.1662652536.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1662652536.git.asml.silence@gmail.com>
References: <cover.1662652536.git.asml.silence@gmail.com>
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

Let's keep checks for whether to break the iopoll loop or not same for
normal and defer tw, this includes ->cached_cq_tail checks guarding
against polling more than asked for.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 8233a375e8c9..2fb5f1e78fb2 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1428,21 +1428,21 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 		 */
 		if (wq_list_empty(&ctx->iopoll_list) ||
 		    io_task_work_pending(ctx)) {
+			u32 tail = ctx->cached_cq_tail;
+
 			if (!llist_empty(&ctx->work_llist))
 				__io_run_local_work(ctx, true);
+
 			if (task_work_pending(current) ||
 			    wq_list_empty(&ctx->iopoll_list)) {
-				u32 tail = ctx->cached_cq_tail;
-
 				mutex_unlock(&ctx->uring_lock);
 				io_run_task_work();
 				mutex_lock(&ctx->uring_lock);
-
-				/* some requests don't go through iopoll_list */
-				if (tail != ctx->cached_cq_tail ||
-				    wq_list_empty(&ctx->iopoll_list))
-					break;
 			}
+			/* some requests don't go through iopoll_list */
+			if (tail != ctx->cached_cq_tail ||
+			    wq_list_empty(&ctx->iopoll_list))
+				break;
 		}
 		ret = io_do_iopoll(ctx, !min);
 		if (ret < 0)
-- 
2.37.2

