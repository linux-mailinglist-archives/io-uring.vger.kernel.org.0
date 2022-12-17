Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB28464FC48
	for <lists+io-uring@lfdr.de>; Sat, 17 Dec 2022 21:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbiLQUs7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 17 Dec 2022 15:48:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbiLQUs6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 17 Dec 2022 15:48:58 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39FFFBE39
        for <io-uring@vger.kernel.org>; Sat, 17 Dec 2022 12:48:48 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id n3so3867550pfq.10
        for <io-uring@vger.kernel.org>; Sat, 17 Dec 2022 12:48:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PYSsCr+Ik/F4WG/ELewOiL4Scs8dwzJEodg6CdQ0kkY=;
        b=c62GtoxZ/PpKdy2uVKx+bqvCscJKxeYWkORaZkG5vwfDxtIgjDxiKhOx/RZefCFhiT
         6VbMs3sQgClDmg5m5kHgUYSWhINvnOD0d0mxeKDwqsbmW6KmqDpEg8ARV2qSNdXcP8w8
         63hFMDwAgPy+cSa6adxKBVHgfATq4N+eRe9ltnHNe4Qb9edY8/tpbku5n9WkMdlEuNFm
         uFKl9Ndkz3bsS11vAlRR+yaoGYj632ibReuCF4acEul8im8eDTXYRJ44V43mN5DLRBgY
         ttG8a6/HFrBtQemVJA2NupI1EmQwBuxsQ7fDP0Sc/BBr5jqu9fy0KiK/5hYWMq3/rzjt
         9zsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PYSsCr+Ik/F4WG/ELewOiL4Scs8dwzJEodg6CdQ0kkY=;
        b=z5BBUgUne/cPikEaojDYp1YP31HeVriADpFsdTdufB5jaYe5oBtAZprxM8TT2TRZlf
         M0fzi/HrLDaaiIecGGz6M4T6DQGwg3Iq8RCMPVKBIMThJlDQmU/3xPKEvZBbYFvhqKVI
         j60Ny9btHdtANUbcbBsRkhs/JmPgd1/gjal4kqYTADNYffuxUNrVasZ/f7jA60WXj9cW
         8KY/ZoNyS07bbj0W47AIfpZe/LLSWo5r4CmD1SRAph75QHGxCpHJbL4svUIJUyUfYX9a
         jLkhn0caXtS7qzFnPXr4w3u06qzGuZTirSqh7C/f+ObTL5H6N6kKnYm2ysVce8b8+tXu
         2E+g==
X-Gm-Message-State: ANoB5pny41sUabBoGtqLhlEddvpEAwg8ERSfrJ/cfHthINxAvfBJP6wA
        uY+XoiDVGKNY0XplZGW37TCunqs0cTnuozEvZZw=
X-Google-Smtp-Source: AA0mqf7WzVs1nr43bhlU6ctPpe85ptuqdZ1G8bdpfvIedEz8ueVsOcyNRfTH8nCd5UY9CUUjE9Ai2A==
X-Received: by 2002:aa7:8395:0:b0:575:dfe6:5df2 with SMTP id u21-20020aa78395000000b00575dfe65df2mr7665945pfm.2.1671310127278;
        Sat, 17 Dec 2022 12:48:47 -0800 (PST)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id i62-20020a62c141000000b0057737e403d9sm3528761pfg.209.2022.12.17.12.48.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Dec 2022 12:48:46 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     dylany@meta.com, asml.silence@gmail.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring: include task_work run after scheduling in wait for events
Date:   Sat, 17 Dec 2022 13:48:40 -0700
Message-Id: <20221217204840.45213-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221217204840.45213-1-axboe@kernel.dk>
References: <20221217204840.45213-1-axboe@kernel.dk>
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

It's quite possible that we got woken up because task_work was queued,
and we need to process this task_work to generate the events waited for.
If we return to the wait loop without running task_work, we'll end up
adding the task to the waitqueue again, only to call
io_cqring_wait_schedule() again which will run the task_work. This is
less efficient than it could be, as it requires adding to the cq_wait
queue again. It also triggers the wakeup path for completions as
cq_wait is now non-empty with the task itself, and it'll require another
lock grab and deletion to remove ourselves from the waitqueue.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 16a323a9ff70..945bea3e8e5f 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2481,7 +2481,7 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 	}
 	if (!schedule_hrtimeout(&timeout, HRTIMER_MODE_ABS))
 		return -ETIME;
-	return 1;
+	return io_run_task_work_sig(ctx);
 }
 
 /*
@@ -2546,6 +2546,8 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 		prepare_to_wait_exclusive(&ctx->cq_wait, &iowq.wq,
 						TASK_INTERRUPTIBLE);
 		ret = io_cqring_wait_schedule(ctx, &iowq, timeout);
+		if (__io_cqring_events_user(ctx) >= min_events)
+			break;
 		cond_resched();
 	} while (ret > 0);
 
-- 
2.35.1

