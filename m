Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49B147B5642
	for <lists+io-uring@lfdr.de>; Mon,  2 Oct 2023 17:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238050AbjJBPUX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Oct 2023 11:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238063AbjJBPUX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Oct 2023 11:20:23 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47726E1
        for <io-uring@vger.kernel.org>; Mon,  2 Oct 2023 08:20:19 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id e9e14a558f8ab-351610727adso3326165ab.0
        for <io-uring@vger.kernel.org>; Mon, 02 Oct 2023 08:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1696260018; x=1696864818; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Qk/XanOarQnfiowuhKuY6lcAi1WRceRpbvvLoOZFAu8=;
        b=AcV39l8LY2WGSepA/YLKrpZvNnUAupdKsXT3F7HXwLvLbmSww1ivpQW5ahrIfPTqhr
         xkU1FAd/jD9y5NUQydkHyxVbPiV4HN2hdd4a23JEJ7s+ZrJZIMlzevZcdCAoXIrozbkY
         5lEJVOlZcCdAOMWE8TcKEAjdlmIfxf+T7BbpQsa9ECJA5T0Ere8ljwR6qJub7BirzV5l
         U5x0UEYLqen8kW2Rf7uR/HrOWtBCbz6EHYZ7mgEaTmd3oUp9FgRadoKFD5CoEKYtxFjQ
         gSYAYhxYkGNSSfz/gSe6CGhv48ObVhEbqYOrb74GAQXLRSrSwha89Qb7IDbcYUikOKB3
         hPLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696260018; x=1696864818;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qk/XanOarQnfiowuhKuY6lcAi1WRceRpbvvLoOZFAu8=;
        b=AUNrEGgj7zBRR4CSNQYLY5Qj9Im2f+K6Ad57n+H5D8i31mBe3ULMuC+e0b9QuSn11r
         wl/yAHFVvCkn8lYkFgOtGtQeoArPLRbDGvh+4myCGpAfMCnLJ2Xc67dP8eLx2D/DIKoS
         k6GFMWO3f5x23tukHonq+88+5mNkJlGKn6qbDSM7WzF7t7IafIEZoBS8Dmdg3nSXSryL
         UhYb0w5DJDqIhET8WNWICZ+8YXnCRWQ2u4pCi6HZ0UlcSRJPliUTakkfHlRen3ci+ZLl
         BX5hW7vb2f/EoCufKaOeTG/E+y5cTlbU5y/7RHbwrTKk3plXOKvC212TnH3nz742pWGG
         Ol6A==
X-Gm-Message-State: AOJu0YwI+cur3y2yI/rNDAGQI3+c80RmwBBz9SwJ8fyjUS6q5V9jyQ3g
        iYgmf5WYNg085NOIjCYXDOM5aw==
X-Google-Smtp-Source: AGHT+IHVKkWVQ0lo/4Oyfs5TolJm2cfk9mrnoCYmsShqdelK85CdLvLpuhRBgRL8+avCiYHCfEkt2g==
X-Received: by 2002:a6b:c94d:0:b0:792:9b50:3c3d with SMTP id z74-20020a6bc94d000000b007929b503c3dmr11280301iof.1.1696260018542;
        Mon, 02 Oct 2023 08:20:18 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id c21-20020a5ea915000000b007a25540c49bsm3068421iod.27.2023.10.02.08.20.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Oct 2023 08:20:18 -0700 (PDT)
Message-ID: <50d68346-d35b-4d3d-a7e5-07540bea3520@kernel.dk>
Date:   Mon, 2 Oct 2023 09:20:17 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] general protection fault in
 io_get_cqe_overflow
Content-Language: en-US
To:     syzbot <syzbot+efc45d4e7ba6ab4ef1eb@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000ab32d40606bcb85e@google.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <000000000000ab32d40606bcb85e@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 547c30582fb8..6206ae73412a 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -86,21 +86,6 @@ bool __io_alloc_req_refill(struct io_ring_ctx *ctx);
 bool io_match_task_safe(struct io_kiocb *head, struct task_struct *task,
 			bool cancel_all);
 
-#define io_lockdep_assert_cq_locked(ctx)				\
-	do {								\
-		lockdep_assert(in_task());				\
-									\
-		if (ctx->flags & IORING_SETUP_IOPOLL) {			\
-			lockdep_assert_held(&ctx->uring_lock);		\
-		} else if (!ctx->task_complete) {			\
-			lockdep_assert_held(&ctx->completion_lock);	\
-		} else if (ctx->submitter_task->flags & PF_EXITING) {	\
-			lockdep_assert(current_work());			\
-		} else {						\
-			lockdep_assert(current == ctx->submitter_task);	\
-		}							\
-	} while (0)
-
 static inline void io_req_task_work_add(struct io_kiocb *req)
 {
 	__io_req_task_work_add(req, 0);
@@ -113,8 +98,6 @@ static inline bool io_get_cqe_overflow(struct io_ring_ctx *ctx,
 					struct io_uring_cqe **ret,
 					bool overflow)
 {
-	io_lockdep_assert_cq_locked(ctx);
-
 	if (unlikely(ctx->cqe_cached >= ctx->cqe_sentinel)) {
 		if (unlikely(!io_cqe_cache_refill(ctx, overflow)))
 			return false;

-- 
Jens Axboe

