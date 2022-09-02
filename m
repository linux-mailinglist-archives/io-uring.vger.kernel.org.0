Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 645535ABAF5
	for <lists+io-uring@lfdr.de>; Sat,  3 Sep 2022 01:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbiIBXBA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 19:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiIBXA6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 19:00:58 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77CC6E830A
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 16:00:57 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id t11-20020a17090a510b00b001fac77e9d1fso6815385pjh.5
        for <io-uring@vger.kernel.org>; Fri, 02 Sep 2022 16:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=14O1H6cyL6/k0HHmoAv6g1KFSTuITnmhuTbbqklDRjk=;
        b=xXtQbvySjBRd44CkxNkhfkdj4N1gz19UqdXxSNHzSxrjfBjlWUsLiHSCp2tDI9YZLN
         JFouxJuOfKiRHn9fO/2Fr/wf6Qa8M00rS1kAF1bAPikttMAfk605E4pvVmhYuI6LMTIv
         1whFZb/NXnrickYRCbP3udTaS9bDJXbQQTaoKQzNKQFJW57Sv5NzTGc2f4zFSU5Y1pzt
         tRaH50lPZ3HyKe0IulBPrc3uNu0pB02Sn5NMb1xhG1QV8Ux5tmKPe+EB/P2txJsCgJwD
         Xd0lDnsb+sjW36ZSX6a9PvhqAXKBRmaPzb0sn/CxlHJh4xHVnOOyAmFwpE0ldbyVjbz6
         pngg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=14O1H6cyL6/k0HHmoAv6g1KFSTuITnmhuTbbqklDRjk=;
        b=M4JkSeUo95Cv7dySUMOhHYJIFR+Z4bVXTSuhKjeb1x8YQKnhZAvAZyYqHocwkhvMpa
         /cgo0J8yBWm+0jIpG+HJnUCvq1QmW7NNyLLe0WBACfCIYTIDY+AdY5XpBxByxUrMkDzX
         w2p9IYvJYsb30pyujausm5M4YBILuMGjYq58bUCzeCEranW+wM2bCo659qvnXaBN04EB
         i7oyRxFtY3ZUxPDKMcgJqReDYon2es2DTWTbgIXW/W5Sml7efXJ4Fw8J7LwzqZHCNLyo
         2xyX+5nXLP0YYXkbEielFxK46U93Mxqi33wjbhoW7MVi1gg5krRcVsBWGqCVmyWPp+fL
         EK1g==
X-Gm-Message-State: ACgBeo3OQiL7QYP6+4Sg9MougBGJEw7ribEn8lJz0TAj4pP1jB6Uwt98
        WDBjeD3sHMxqqQw+p5Y8ebORFrbH4fGeKg==
X-Google-Smtp-Source: AA6agR5ioGU0Fy7S7RKzZVFAx9/1hcJfLyk2E9LuNa8hjxgnWRdRtUBSz7AyBZJWQVY+HPx1B56ZtQ==
X-Received: by 2002:a17:902:e889:b0:175:3e0e:169f with SMTP id w9-20020a170902e88900b001753e0e169fmr16468634plg.114.1662159656323;
        Fri, 02 Sep 2022 16:00:56 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 12-20020a170902c10c00b0016c5306917fsm2202104pli.53.2022.09.02.16.00.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 16:00:55 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     joshi.k@samsung.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring: cleanly separate request types for iopoll
Date:   Fri,  2 Sep 2022 17:00:50 -0600
Message-Id: <20220902230052.275835-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220902230052.275835-1-axboe@kernel.dk>
References: <20220902230052.275835-1-axboe@kernel.dk>
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

After the addition of iopoll support for passthrough, there's a bit of
a mixup here. Clean it up and get rid of the casting for the passthrough
command type.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/rw.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 9698a789b3d5..3f03b6d2a5a3 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -994,7 +994,7 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 
 	wq_list_for_each(pos, start, &ctx->iopoll_list) {
 		struct io_kiocb *req = container_of(pos, struct io_kiocb, comp_list);
-		struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
+		struct file *file = req->file;
 		int ret;
 
 		/*
@@ -1006,12 +1006,15 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 			break;
 
 		if (req->opcode == IORING_OP_URING_CMD) {
-			struct io_uring_cmd *ioucmd = (struct io_uring_cmd *)rw;
+			struct io_uring_cmd *ioucmd;
 
-			ret = req->file->f_op->uring_cmd_iopoll(ioucmd);
-		} else
-			ret = rw->kiocb.ki_filp->f_op->iopoll(&rw->kiocb, &iob,
-							poll_flags);
+			ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
+			ret = file->f_op->uring_cmd_iopoll(ioucmd, poll_flags);
+		} else {
+			struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
+
+			ret = file->f_op->iopoll(&rw->kiocb, &iob, poll_flags);
+		}
 		if (unlikely(ret < 0))
 			return ret;
 		else if (ret)
-- 
2.35.1

