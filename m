Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBBC0343343
	for <lists+io-uring@lfdr.de>; Sun, 21 Mar 2021 16:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbhCUPnm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Mar 2021 11:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbhCUPnT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Mar 2021 11:43:19 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E58FDC061574
        for <io-uring@vger.kernel.org>; Sun, 21 Mar 2021 08:43:18 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id v2so7006859pgk.11
        for <io-uring@vger.kernel.org>; Sun, 21 Mar 2021 08:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=iJJTTHjhkg3IKG2+5ahibbnd+3jQ6pQuqkguBVsrkvw=;
        b=scTy1Thrc204zSEz4zPnFtKRXy/EaDJsDw/4zzHAwwIQ5hr/pLiENH9yCPiPRqmj05
         CaWgOrbTcAXDgySonQjxeR7Md4amATmb0PlZcoLMIsPAyL5Exx0my++5+wa0DTbr2Ymv
         xI7Y5NFbdCYkgTXUFABdscfLAxet5GclOvcm7rMM8d56RaprmMODQeLs34326/3m5tRQ
         JH2hfUk8hYEezazfA2/ZmDChkVPDY1MYV9SxYZkRM1E3o2je44Bxrml2JNUv5D0cNoe8
         WefyvyoKYEwb+4iTAMbvnj1NUUIJXJahMd9niBx/OwrDDMCQY6Wdlmri7ITtQ1iVXKf8
         QsPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=iJJTTHjhkg3IKG2+5ahibbnd+3jQ6pQuqkguBVsrkvw=;
        b=dDoYqpG2GDuiJUY38wHqh6OBAPtE9sAD+iccD5S4HAxS1WvfMIGqaMs/+DZrFTqwSe
         stNZ+G3yPw1n/GZL51eSzBIesVqDo+WBcLsi5obPlCLr4feHbInTHilVRrvvIltJ9ws8
         ++PGSk8XgXy04SGMCzI7A62IlEz41Wxx2yJ7Lve27PcVoz/9m5cprKnYdy+KtDP2dxDr
         SSlFYJDiQBuBIIyEUrM5NoNe8tYHs0+1ysEbBvZK1udSKIrg/2H7+EwHQQ28YT3eFDwf
         G+f/tT9ZgVWtokI+U5vi9y7AT2Rkdx05qn5B1cvfzkdUO/WV0LIvK8CuadZMFB2HC5Tj
         pK+A==
X-Gm-Message-State: AOAM53383oYWvF3X9AjT6E3Q9CZFBUqDYCNzFSKHuhfHZIrZvn2THu3W
        LSnyHZIzy99J4ytFf2DTtc9mcE1VMsJ+JQ==
X-Google-Smtp-Source: ABdhPJygk3hioIV9qVRwBZeNKJaWsA5n5ziH6bmZvarCQtTHQE3Q898Fdq6Wof4bZR6oMo86WL0IEg==
X-Received: by 2002:a62:cfc4:0:b029:200:49d8:6f29 with SMTP id b187-20020a62cfc40000b029020049d86f29mr17309535pfg.45.1616341398273;
        Sun, 21 Mar 2021 08:43:18 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id z9sm10078465pgs.32.2021.03.21.08.43.17
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Mar 2021 08:43:17 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io-wq: ensure task is running before processing task_work
Message-ID: <b0f22674-5294-cfef-234f-5f161b26cc04@kernel.dk>
Date:   Sun, 21 Mar 2021 09:43:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Mark the current task as running if we need to run task_work from the
io-wq threads as part of work handling. If that is the case, then return
as such so that the caller can appropriately loop back and reset if it
was part of a going-to-sleep flush.

Fixes: 3bfe6106693b ("io-wq: fork worker threads from original task")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io-wq.c b/fs/io-wq.c
index e05f996d088f..3dc10bfd8c3b 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -386,13 +386,16 @@ static struct io_wq_work *io_get_next_work(struct io_wqe *wqe)
 	return NULL;
 }
 
-static void io_flush_signals(void)
+static bool io_flush_signals(void)
 {
 	if (unlikely(test_tsk_thread_flag(current, TIF_NOTIFY_SIGNAL))) {
+		__set_current_state(TASK_RUNNING);
 		if (current->task_works)
 			task_work_run();
 		clear_tsk_thread_flag(current, TIF_NOTIFY_SIGNAL);
+		return true;
 	}
+	return false;
 }
 
 static void io_assign_current_work(struct io_worker *worker,
@@ -499,7 +502,8 @@ static int io_wqe_worker(void *data)
 		}
 		__io_worker_idle(wqe, worker);
 		raw_spin_unlock_irq(&wqe->lock);
-		io_flush_signals();
+		if (io_flush_signals())
+			continue;
 		ret = schedule_timeout(WORKER_IDLE_TIMEOUT);
 		if (try_to_freeze() || ret)
 			continue;

-- 
Jens Axboe

