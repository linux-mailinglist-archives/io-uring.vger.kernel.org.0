Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDFAC50C485
	for <lists+io-uring@lfdr.de>; Sat, 23 Apr 2022 01:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233085AbiDVWnJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Apr 2022 18:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234096AbiDVWm5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Apr 2022 18:42:57 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F38C9161A66
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 14:42:23 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id q3so13629232plg.3
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 14:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pRsE1CnEaS2DEElV/awnCj0Li5JhBojacjcxSXzv1ZI=;
        b=kVKrVSd5Z8XkHTHeywWNtuOjxPdMPtlac+QA4FdfrtC61/z/bi/WgMsLmWSjp0GSe0
         T2n9XnLFwi0PDfh5nyR5iePSl0pC4ybpZ1nC0/agZN5oJA1oK+5VoSl7QUUlBunW1Quh
         rWaWvmK7bdtqG1OtWJgoB0G7GcpJ82mASfKOT+gOr7fyNSfNYpIyaYQoSeqMBALozb5i
         16fxm6wGNZT1sWJm71YpbPJpZdaz3nji27c0nfdjumHf6YUlc5FUQmkFzAgipT6lMtC3
         aNY6yx2w45eb87VLaACGbtG+z+CM/xvv6/TTO4vPw/w0E8u0N+F1FDUzw60vsJj9oQzy
         VJ9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pRsE1CnEaS2DEElV/awnCj0Li5JhBojacjcxSXzv1ZI=;
        b=EGTzm0xBRHjomujbEgbQV92a6iZvSBv+sLSCmRMlxlhiggHQzw8aVHUAny5tzWb0nr
         VDplUWchPI4cGq5mNhUA/yR3UJTFe2Esco63BbQXaws9G62TV2uScT3YTadqCMgOacX4
         bzjW3FsrLBH4/JQCk4gi7xpSvST9ZTUdFgxq1h02BmIJnIn6Fca5gwzgLy74woh447SC
         8YbLgDae5f9jNquigg4nTVX786Yzf7yOcCbhq+DrQjzXBiM3+PyON5VWxcrYCJPmZEEs
         GH8q6li0/a1if+DrHrsvVgPJGBwu/xU61rsUMvxrexjfHWb08h+RqWeGSOQM64bCvbl2
         36rA==
X-Gm-Message-State: AOAM530INj6xItS/wH0oLGPk+jfzSswqbj36GoJUzTZwK4mc3qknwk46
        ocsZkkUbSCyJEHFXS0Z5L1jEZH3Gs9hFwvyF
X-Google-Smtp-Source: ABdhPJykEzOFx5qMxP4edtwjzDa6UOsBQcVzlt634LZKnv6KdJIFA0OJFMugn9y3sgclTTsUhYdQJA==
X-Received: by 2002:a17:90a:5409:b0:1ca:8a21:323b with SMTP id z9-20020a17090a540900b001ca8a21323bmr18648823pjh.135.1650663743136;
        Fri, 22 Apr 2022 14:42:23 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id c5-20020a62f845000000b0050ceac49c1dsm3473098pfm.125.2022.04.22.14.42.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Apr 2022 14:42:22 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/5] io_uring: use TWA_SIGNAL_NO_IPI if IORING_SETUP_NO_RESCHED is used
Date:   Fri, 22 Apr 2022 15:42:14 -0600
Message-Id: <20220422214214.260947-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220422214214.260947-1-axboe@kernel.dk>
References: <20220422214214.260947-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If this is set, io_uring will never use an IPI to deliver a task_work
notification. This can be used in the common case where a single task or
thread communicates with the ring, and doesn't rely on
io_uring_cqe_peek().

This provides a noticeable win in performance, both from eliminating
the IPI itself, but also from avoiding interrupting the submitting
task unnecessarily.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 8 +++++---
 include/uapi/linux/io_uring.h | 1 +
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 20297fe4300b..43634cd5c79d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -11352,9 +11352,10 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 		ctx->user = get_uid(current_user());
 
 	/*
-	 * For SQPOLL, we just need a wakeup, always.
+	 * For SQPOLL, we just need a wakeup, always. For !SQPOLL, if
+	 * NO_RESCHED is set, then IPIs are never needed by the app.
 	 */
-	if (ctx->flags & IORING_SETUP_SQPOLL)
+	if (ctx->flags & (IORING_SETUP_SQPOLL|IORING_SETUP_NO_RESCHED))
 		ctx->notify_method = TWA_SIGNAL_NO_IPI;
 	else
 		ctx->notify_method = TWA_SIGNAL;
@@ -11456,7 +11457,8 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 	if (p.flags & ~(IORING_SETUP_IOPOLL | IORING_SETUP_SQPOLL |
 			IORING_SETUP_SQ_AFF | IORING_SETUP_CQSIZE |
 			IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ |
-			IORING_SETUP_R_DISABLED | IORING_SETUP_SUBMIT_ALL))
+			IORING_SETUP_R_DISABLED | IORING_SETUP_SUBMIT_ALL |
+			IORING_SETUP_NO_RESCHED))
 		return -EINVAL;
 
 	return  io_uring_create(entries, &p, params);
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 980d82eb196e..8a32230aa6f4 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -102,6 +102,7 @@ enum {
 #define IORING_SETUP_ATTACH_WQ	(1U << 5)	/* attach to existing wq */
 #define IORING_SETUP_R_DISABLED	(1U << 6)	/* start with ring disabled */
 #define IORING_SETUP_SUBMIT_ALL	(1U << 7)	/* continue submit on error */
+#define IORING_SETUP_NO_RESCHED	(1U << 8)	/* work doesn't need resched */
 
 enum {
 	IORING_OP_NOP,
-- 
2.35.1

