Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8499E640C90
	for <lists+io-uring@lfdr.de>; Fri,  2 Dec 2022 18:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233845AbiLBRs4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Dec 2022 12:48:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234148AbiLBRsv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Dec 2022 12:48:51 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDB32DEA66
        for <io-uring@vger.kernel.org>; Fri,  2 Dec 2022 09:48:49 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id v124-20020a1cac82000000b003cf7a4ea2caso6996195wme.5
        for <io-uring@vger.kernel.org>; Fri, 02 Dec 2022 09:48:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6EGxL9OtoW/M7niOGVS3YX0lKi57YksW9hdh1P9O0+M=;
        b=YPKaumVvbkJRR7qeFxniS9pF1zvORoUYaTYtTIN0ITzUH7hWSsI4OtuQ91F3oi5Qsq
         yUo0aIisfDqSfIqFWGlqJNCpxCh9PebtZk+4QG/lm0Q1aWD1+Iia5zGKBnN+rpdfVC8k
         TQmCbyQk9WI0gwrTKSzQZx2piGvN5WFsAhBsXPOPJFU5tvwp2DtzLlIOlyGxqGKJx2kw
         HqCPkDUtPUSV+/Zc1KqJAI+6rvdsgpIHOnkN4epJOZ3YvLeJi8eXSG0fpbws1oi8MCVH
         NKpbPwJcOtVfELuBIgtrID3zuEirV+r86pTPUi7EkRv3UVCdCQXTO0M5aJ6+NUlHuAny
         w3wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6EGxL9OtoW/M7niOGVS3YX0lKi57YksW9hdh1P9O0+M=;
        b=cwL6iT8FToKPMv4zljhrFIDhNVpm7ua4pjEwSkxlMfFF04bG+rLITxKIdxzFSZrDS4
         WYegPH98yxgMYk/nCFL8MvgkQ388v+LF77zvvhaJc8PtL3d7WkqeKVKgX9hqFKsEdB/S
         KwuJUpAla138cKlj1wQaf24/nuQw5oBe5RS2mSjbNyzfsioVsaSfTql/ddycm09P9rxP
         GFEuBEyjiGge2kRXgQwyKKp3kfm/RrR1cjX27nqLcx6ohcZuA8m+mmGqYGLjZYiOHpGW
         /6iCWHT+Kv3bFYV4s/Klpm12ytE54ZmIzkiqarQUR4IOzxY4j/tlA86qEOhBdOha610V
         mU9w==
X-Gm-Message-State: ANoB5plvNtydwXLb1wcpJy0bWZav0CAQGvvD88UEMhGgGXzoh/EuMbfH
        M8oSf6/PonPRBadMo4T4tzZKHb7rEg4=
X-Google-Smtp-Source: AA0mqf6W8X+tnS8Phfo95rtONYn0+cxOw73SeePgBFokWoFTMmDW4xZp4FniUgDcyGSITGEQVFc21A==
X-Received: by 2002:a05:600c:19d1:b0:3cf:ca1a:332a with SMTP id u17-20020a05600c19d100b003cfca1a332amr57222837wmq.118.1670003328342;
        Fri, 02 Dec 2022 09:48:48 -0800 (PST)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:a57e])
        by smtp.gmail.com with ESMTPSA id i1-20020adfaac1000000b002238ea5750csm9368585wrc.72.2022.12.02.09.48.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 09:48:48 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 4/4] io_uring: rename __io_fill_cqe_req
Date:   Fri,  2 Dec 2022 17:47:25 +0000
Message-Id: <f7087fb500405ddb7ff754dd0b43b26e097fc492.1670002973.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670002973.git.asml.silence@gmail.com>
References: <cover.1670002973.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There is no io_fill_cqe_req(), remove the previx from
__io_fill_cqe_req().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 4 ++--
 io_uring/io_uring.h | 2 +-
 io_uring/rw.c       | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4593016c6e37..436b1ac8f6d0 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -894,7 +894,7 @@ static void __io_req_complete_post(struct io_kiocb *req)
 
 	io_cq_lock(ctx);
 	if (!(req->flags & REQ_F_CQE_SKIP))
-		__io_fill_cqe_req(ctx, req);
+		io_fill_cqe_req(ctx, req);
 
 	/*
 	 * If we're the last reference to this request, add to our locked
@@ -1405,7 +1405,7 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 					    comp_list);
 
 		if (!(req->flags & REQ_F_CQE_SKIP))
-			__io_fill_cqe_req(ctx, req);
+			io_fill_cqe_req(ctx, req);
 	}
 	io_cq_unlock_post_inline(ctx);
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index ff84c0cfa2f2..62227ec3260c 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -110,7 +110,7 @@ static inline struct io_uring_cqe *io_get_cqe(struct io_ring_ctx *ctx)
 	return io_get_cqe_overflow(ctx, false);
 }
 
-static inline bool __io_fill_cqe_req(struct io_ring_ctx *ctx,
+static inline bool io_fill_cqe_req(struct io_ring_ctx *ctx,
 				     struct io_kiocb *req)
 {
 	struct io_uring_cqe *cqe;
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 1ce065709724..1ecce80508ee 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -1061,7 +1061,7 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 			continue;
 
 		req->cqe.flags = io_put_kbuf(req, 0);
-		__io_fill_cqe_req(req->ctx, req);
+		io_fill_cqe_req(req->ctx, req);
 	}
 
 	if (unlikely(!nr_events))
-- 
2.38.1

