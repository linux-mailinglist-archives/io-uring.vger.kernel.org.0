Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B67E97978EE
	for <lists+io-uring@lfdr.de>; Thu,  7 Sep 2023 18:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236814AbjIGQ7C (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Sep 2023 12:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245073AbjIGQ7B (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Sep 2023 12:59:01 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 769E5E46
        for <io-uring@vger.kernel.org>; Thu,  7 Sep 2023 09:58:27 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id 38308e7fff4ca-2bcc187e0b5so21141641fa.1
        for <io-uring@vger.kernel.org>; Thu, 07 Sep 2023 09:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694105841; x=1694710641; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HkUs4bQ1E8KB48LLONDQtfwRnAGik6JPV6A26/jKNqY=;
        b=QgiC9/g+s61gWBOwiUegN3iLqZ9Hre7snJXt9Ei9DwA98FwizVrZod9NAnEqQhovQz
         FgsshU3g5imQUeCnvjqWKCBzM9CEmW3AYjpuBj27TdsKLFYyqGBDMj1mz4EZqFQttyNf
         f/KT3a1vRUkvELgq3hdGoCuqFyp+1LgYsujHw6n+ZkkPjY0Lrr1y8B06vRzP69KYHm4r
         SMHwf7D5z9A9K9xcLoTG0sVImMzUTdoFuvTsXEn3m8Q6YC7v75V3WWJDusBWY3Fg126d
         cv8HVJnoxOMY6Xb53NFk1vxwG7Wrmk97wmPtlXFZgoG+D7BhBCSJ3UhxV5jD9SGdVYjY
         3qDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694105841; x=1694710641;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HkUs4bQ1E8KB48LLONDQtfwRnAGik6JPV6A26/jKNqY=;
        b=nbZToe6qEUAAxWF4asxFU1TZCn9GtZjzMgQ4kdAyECo/z/WoYLl7KwbDwB+pRryR4r
         Xhdo7lIjar8BJIxLhB5LfOZIkNAwPa5SqGhHwihrE5G/2z7RI4b9jZ8p3dkQQGN8F4dK
         IyVxjRW+TrZQPjpSicHNbPrSpwuGBblatD5x4DAIGxkmXARFDQI8siuH3nF30JtuPfpQ
         cVP1AagmmsUkh6I1TIoGFX0Vm+q61sZQ2XfKAFqqIBRakTI3JQNiY3edmxFbr76wFar1
         ASPJK3I3iymste4kLbbcg4SIysqBtKgMlM/mZIxCvrHE0NVMpBVjncnEfXKjXp2T+zx3
         dj5g==
X-Gm-Message-State: AOJu0YxEX3k4Lsdy4Fr+0/6z9H2g7VU7J3n4UnNbYNm6lFCxY9CjvFaO
        3fAMopyTjzxYd9Y3ywFTeoq9V/wTn54=
X-Google-Smtp-Source: AGHT+IGmH7p2LBA2oJDPrCEkq7/BtszlGP65Sf1ghdvfgVDXBbHtkGRDy0w/m1A5DF5q3u45er8JxA==
X-Received: by 2002:a19:650f:0:b0:4fd:d08c:fa3e with SMTP id z15-20020a19650f000000b004fdd08cfa3emr4512294lfb.42.1694091035467;
        Thu, 07 Sep 2023 05:50:35 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.141.16])
        by smtp.gmail.com with ESMTPSA id p11-20020a056402074b00b005231e1780aasm9612279edy.91.2023.09.07.05.50.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Sep 2023 05:50:34 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 2/2] io_uring: fix unprotected iopoll overflow
Date:   Thu,  7 Sep 2023 13:50:08 +0100
Message-ID: <ae1902f240b9f73c10136354bafe6cd562bb76d8.1694054436.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1694054436.git.asml.silence@gmail.com>
References: <cover.1694054436.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

[   71.490669] WARNING: CPU: 3 PID: 17070 at io_uring/io_uring.c:769
io_cqring_event_overflow+0x47b/0x6b0
[   71.498381] Call Trace:
[   71.498590]  <TASK>
[   71.501858]  io_req_cqe_overflow+0x105/0x1e0
[   71.502194]  __io_submit_flush_completions+0x9f9/0x1090
[   71.503537]  io_submit_sqes+0xebd/0x1f00
[   71.503879]  __do_sys_io_uring_enter+0x8c5/0x2380
[   71.507360]  do_syscall_64+0x39/0x80

We decoupled CQ locking from ->task_complete but haven't fixed up places
forcing locking for CQ overflows.

Fixes: ec26c225f06f5 ("io_uring: merge iopoll and normal completion paths")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4674203c1cac..6cce8948bddf 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -883,7 +883,7 @@ static void __io_flush_post_cqes(struct io_ring_ctx *ctx)
 		struct io_uring_cqe *cqe = &ctx->completion_cqes[i];
 
 		if (!io_fill_cqe_aux(ctx, cqe->user_data, cqe->res, cqe->flags)) {
-			if (ctx->task_complete) {
+			if (ctx->lockless_cq) {
 				spin_lock(&ctx->completion_lock);
 				io_cqring_event_overflow(ctx, cqe->user_data,
 							cqe->res, cqe->flags, 0, 0);
@@ -1541,7 +1541,7 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 
 		if (!(req->flags & REQ_F_CQE_SKIP) &&
 		    unlikely(!io_fill_cqe_req(ctx, req))) {
-			if (ctx->task_complete) {
+			if (ctx->lockless_cq) {
 				spin_lock(&ctx->completion_lock);
 				io_req_cqe_overflow(req);
 				spin_unlock(&ctx->completion_lock);
-- 
2.41.0

