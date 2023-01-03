Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4238D65B98E
	for <lists+io-uring@lfdr.de>; Tue,  3 Jan 2023 04:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232024AbjACDFa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Jan 2023 22:05:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236625AbjACDF1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Jan 2023 22:05:27 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 534FEBF58
        for <io-uring@vger.kernel.org>; Mon,  2 Jan 2023 19:05:26 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id l26so20182036wme.5
        for <io-uring@vger.kernel.org>; Mon, 02 Jan 2023 19:05:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F6vtilktCsxzq342UKZKm+kG0VKB3HCbCG+3kPZMYhc=;
        b=BggrJkyG1pkd0tBFBd02i9j0xdx1kxDaNBp6M0uZuQp3UUoeCSDX/cMDq0JqtoEzjy
         QMyDrjyz02157vdnvuJ9zMH4utjf+3FVxoSOWkxKjNwzpIOp6zcGv9+VM6AFy8Gmjz4N
         2e5lxTAN3HUOivnRpzZYGKJTqjkVfx3XxpxOLaWtdxomfZCs6ikkBO5kbs/L+A01XUzg
         viW5YfOU5GaL/3NHNSNpiLqnOtCwoOoZteLFuEBKGDQNgWtbDGT4FfltmsXpI8Zotg2i
         H2Kt5nlvboaKYJxbvAk26gIXL3UHkBTwi/drZ9O0HFIJC6rOTWSfC/FtThGFBgsXWOhD
         l2Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F6vtilktCsxzq342UKZKm+kG0VKB3HCbCG+3kPZMYhc=;
        b=i9Whn9BSiD7hpx+sw9UgLbmEoabxnb4gumMHVKi3GByijrFxDJ/zjiSfySrgZieKJL
         zPmOJZJ+iastvJ4AiPCm6IPuWhbOnPqouMh4RvOa91hRfbQDCDzioxOVFqsTM7igSeyB
         Ukt3tE58fdBlEMtwlFynk09P8DPwRZ+I1D7H24p/7ZHW1XXRb2KgUi0agM2w7CW4aXIm
         JkY7nLbSWyBxDuw+LRpoWF03MCfp/cQ85dFOiZViljNpweseRatWdtSeEbCBlMKNOWQ5
         X9DivpuHRNEcDTe9sIupNc0Tt/HjvN2n72QBQerZqeUSlNze0hNuCzW01W+vo20YS93a
         WDDw==
X-Gm-Message-State: AFqh2koE4ZzsKNHxZa39VzP78VgoOM/997TMkH0Q9gTX7F1QPakKh/SJ
        9tN/rzzCjuhqW8jc7W3NjRl0Lw+FkeI=
X-Google-Smtp-Source: AMrXdXvdJ+LSHxNvDp9FwxmPumyMZ4UMm8oIaSAr43nXY8mLQfmK4bkMDdV6S/XL3AcQfVyEbFu0hw==
X-Received: by 2002:a05:600c:4da2:b0:3d2:39dc:f50e with SMTP id v34-20020a05600c4da200b003d239dcf50emr29852055wmp.7.1672715125751;
        Mon, 02 Jan 2023 19:05:25 -0800 (PST)
Received: from 127.0.0.1localhost (188.28.229.101.threembb.co.uk. [188.28.229.101])
        by smtp.gmail.com with ESMTPSA id m1-20020a7bca41000000b003d1de805de5sm39967839wml.16.2023.01.02.19.05.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jan 2023 19:05:25 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [RFC v2 08/13] io_uring: set TASK_RUNNING right after schedule
Date:   Tue,  3 Jan 2023 03:03:59 +0000
Message-Id: <590f0b0e2fa5529e975f3f3ecbb588ff7e67e9c5.1672713341.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1672713341.git.asml.silence@gmail.com>
References: <cover.1672713341.git.asml.silence@gmail.com>
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

Instead of constantly watching that the state of the task is running
before executing tw or taking locks in io_cqring_wait(), switch it back
to TASK_RUNNING immediately.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index a8d3826f3d17..682f4b086f09 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2541,6 +2541,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 		ret = io_cqring_wait_schedule(ctx, &iowq, timeout);
 		if (ret < 0)
 			break;
+		__set_current_state(TASK_RUNNING);
 		/*
 		 * Run task_work after scheduling and before io_should_wake().
 		 * If we got woken because of task_work being processed, run it
@@ -2553,10 +2554,8 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 		check_cq = READ_ONCE(ctx->check_cq);
 		if (unlikely(check_cq)) {
 			/* let the caller flush overflows, retry */
-			if (check_cq & BIT(IO_CHECK_CQ_OVERFLOW_BIT)) {
-				finish_wait(&ctx->cq_wait, &iowq.wq);
+			if (check_cq & BIT(IO_CHECK_CQ_OVERFLOW_BIT))
 				io_cqring_do_overflow_flush(ctx);
-			}
 			if (check_cq & BIT(IO_CHECK_CQ_DROPPED_BIT)) {
 				ret = -EBADR;
 				break;
-- 
2.38.1

