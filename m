Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A50A7B5EDE
	for <lists+io-uring@lfdr.de>; Tue,  3 Oct 2023 03:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbjJCB6D (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Oct 2023 21:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjJCB6C (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Oct 2023 21:58:02 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 214409B
        for <io-uring@vger.kernel.org>; Mon,  2 Oct 2023 18:57:59 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id 98e67ed59e1d1-27730028198so78742a91.1
        for <io-uring@vger.kernel.org>; Mon, 02 Oct 2023 18:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1696298278; x=1696903078; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N1vKgn5NQ72/EY/kKALrzQCFoE/Nw1dy6Tqax6+l2KY=;
        b=lWgNXnP5JvaKQ3eRL8NVS3s9uSWoXkoQ5OpRjdIcE84F8mFp5TjC3Dj1k0y/14iqCH
         uSILCtwxmy3iplIe8cS/k7kgVM8JG0lYOSrnERxIAHSJRNjrHLCzm0KwdHtY5H3CHuUE
         KTUODM1LkyL5tsWFxeu48mnLH/EMc4MwimVVv3pXxHIf3G6UEuQNb7HMlRPZhSToDm+T
         6t/lNuZRTmzHNZkdoeCoo+8Jk5a3yPlBEsJizzw8xZRTXKXFUhOp7HfsJjOirLMrRKoe
         vf8QtLapbo1smvIsfhzXDfQxTfWpE7BGfrwaIeTbiPr8Q1Q/lXTueLN1Mfuyx3eDyW0c
         HzUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696298278; x=1696903078;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=N1vKgn5NQ72/EY/kKALrzQCFoE/Nw1dy6Tqax6+l2KY=;
        b=AgJ4m3rWbiPOiUu8/2nw+PRN4vXOFqfGYkasuUbtFToxpvQbcqr5oZm1CZIDSXpT2h
         Uw2qMMj14iGbI/xO+lXEdaqnVl4kFVuFzfV+jXdhcbsNeJ6Nz6X+bVSWXm/s03Q2wW53
         RgngYk8EzycYsVVEMM0JmJmkf/yJII5HHwzoJqTA766WNeHk9gdIKE0iJW/HTxZ19RXT
         O34lFc3V8KbZbSoXhGGotUuA3zO8vDvROwAvkSRORwmQ498HJBIYifHfNfJHqRMMzUpD
         DdLbeH/Fys26XzSMYXnf1YvQ5M/PnJKSnh7yNHR7a/EG+SvD4tw1fF0amvLbYXX5GNsS
         2NMw==
X-Gm-Message-State: AOJu0YwSPwLtLVXG2sjQdQjzej2izlSSv+0h8DWhnRtgIyFnRwKKmglz
        CIu0FHaRyGhu8QDfnnP0N6LT8nRT3Vzk123jVfc=
X-Google-Smtp-Source: AGHT+IEQCKMKaNadJhJHbk/3In7edMFUMFgUCRN9pGQui05TdbjUMnn00HJceYUoDLLk9/kDpTrTqg==
X-Received: by 2002:a17:90a:1090:b0:26d:4ade:fcf0 with SMTP id c16-20020a17090a109000b0026d4adefcf0mr11598940pja.4.1696298277717;
        Mon, 02 Oct 2023 18:57:57 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id x4-20020a17090a388400b00268b9862343sm7612858pjb.24.2023.10.02.18.57.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Oct 2023 18:57:57 -0700 (PDT)
Message-ID: <1e7974dc-395b-448d-8324-0e9056d892ff@kernel.dk>
Date:   Mon, 2 Oct 2023 19:57:56 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: ensure io_lockdep_assert_cq_locked() handles
 disabled rings
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_lockdep_assert_cq_locked() checks that locking is correctly done when
a CQE is posted. If the ring is setup in a disabled state with
IORING_SETUP_R_DISABLED, then ctx->submitter_task isn't assigned until
the ring is later enabled. We generally don't post CQEs in this state,
as no SQEs can be submitted. However it is possible to generate a CQE
if tagged resources are being updated. If this happens and PROVE_LOCKING
is enabled, then the locking check helper will dereference
ctx->submitter_task, which hasn't been set yet.

Fixup io_lockdep_assert_cq_locked() to handle this case correctly. While
at it, convert it to a static inline as well, so that generated line
offsets will actually reflect which condition failed, rather than just
the line offset for io_lockdep_assert_cq_locked() itself.

Reported-by: syzbot+efc45d4e7ba6ab4ef1eb@syzkaller.appspotmail.com
Fixes: f26cc9593581 ("io_uring: lockdep annotate CQ locking")
Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 547c30582fb8..b021d4920baa 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -86,20 +86,27 @@ bool __io_alloc_req_refill(struct io_ring_ctx *ctx);
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
+#if defined(CONFIG_PROVE_LOCKING)
+static inline void io_lockdep_assert_cq_locked(struct io_ring_ctx *ctx)
+{
+	lockdep_assert(in_task());
+
+	if (ctx->flags & IORING_SETUP_IOPOLL) {
+		lockdep_assert_held(&ctx->uring_lock);
+	} else if (!ctx->task_complete) {
+		lockdep_assert_held(&ctx->completion_lock);
+	} else if (ctx->submitter_task) {
+		if (ctx->submitter_task->flags & PF_EXITING)
+			lockdep_assert(current_work());
+		else
+			lockdep_assert(current == ctx->submitter_task);
+	}
+}
+#else
+static inline void io_lockdep_assert_cq_locked(struct io_ring_ctx *ctx)
+{
+}
+#endif
 
 static inline void io_req_task_work_add(struct io_kiocb *req)
 {

-- 
Jens Axboe

