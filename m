Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3AB821A987
	for <lists+io-uring@lfdr.de>; Thu,  9 Jul 2020 23:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbgGIVJG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Jul 2020 17:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbgGIVJF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Jul 2020 17:09:05 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1547C08C5CE
        for <io-uring@vger.kernel.org>; Thu,  9 Jul 2020 14:09:05 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id t27so3248285ill.9
        for <io-uring@vger.kernel.org>; Thu, 09 Jul 2020 14:09:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=z5kpSTPgzXajn8kVyl05Fgx6NyHfybhlZ8GJxgZxMMU=;
        b=tFD4oTC42uZfPuPLSs7A/P6FzslnesaflcAKM9TD5fPSlArPg8QjYFtoeXefuOHweD
         1pU3bWPoHM7YHhoMe3MicW3PbSiw+6ff8fgfFYellXwAvI+POr3tZ9WaNMlJOgSX9Gy5
         NZaRxAFNUd3lxc/jDn7Iov+yTXv/Q3+YzGzIv72o91Ay4pszU6FWbcVWRy+y5Vfqd3mw
         /kixgaJOQAYXB999qEYFJI+TWHk6OPLUGNrdrGHJZ3t55TwrJp8TNLPWPxKzrd5rmUWw
         MshHAytW8SldSIPp/vzuT80h8G8m6lFMp/WSXz9iAGq48jBZKprNylY61CuoC8M6kqZ5
         BDtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=z5kpSTPgzXajn8kVyl05Fgx6NyHfybhlZ8GJxgZxMMU=;
        b=InyGn3XHKjLfkHFWLheSM6DGCZoeMtG6mg43vAAWVDfAPks+YwH92EV1T0af122DEQ
         B58hVfvFDTmP7Ww+dHAJCRC7oGAJeBdLqc90twDfWosjJHm1ZCUIx7yooMyQ7Hajbkzx
         KS7Nz28091byXzdU6YOP5nZaJYQrGqvkg/IkcpXtbb1YWt1BuZZGQQyr1jZOcc7j8NVN
         IsC4ETtn67bsYw+FTwQi4PkWXa6TqsDTBVbwP84LRq8MS369KyzxBlFrwqvnBsxe2Jkq
         nYXmqlKO9C3iOmhBpNW6aKK9kGslrDXFLDkpsUtwerXBF0FcvFq9X6STacdwSkKRTRg+
         OBKA==
X-Gm-Message-State: AOAM533vQASYtgbFySULw8zppawo9iS/eVB7cuKsoyRmxt8GOZ401T5y
        PQE42vVmuBC4P8LDExAWpuSiOI9Zed2kdA==
X-Google-Smtp-Source: ABdhPJzwmkGsdezjW25DIJzysZy8HJI9rwEd6JT2U+NvxNnW9w4VTosWvtMXeeaXqsW7B1DeZRRqEw==
X-Received: by 2002:a92:bb55:: with SMTP id w82mr50156887ili.146.1594328944457;
        Thu, 09 Jul 2020 14:09:04 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id a13sm2358844ilk.19.2020.07.09.14.09.03
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2020 14:09:03 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: remove dead 'ctx' argument and move forward
 declaration
Message-ID: <fb623ee3-37ab-7b61-b62b-f38854443e98@kernel.dk>
Date:   Thu, 9 Jul 2020 15:09:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We don't use 'ctx' at all in io_sq_thread_drop_mm(), it just works
on the mm of the current task. Drop the argument.

Move io_file_put_work() to where we have the other forward declarations
of functions.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

No functional changes, just cleanups I came across while doing other
work.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7f2a2cb5c056..3ce02a1613cc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -902,6 +902,7 @@ static int io_file_get(struct io_submit_state *state, struct io_kiocb *req,
 static void __io_queue_sqe(struct io_kiocb *req,
 			   const struct io_uring_sqe *sqe,
 			   struct io_comp_state *cs);
+static void io_file_put_work(struct work_struct *work);
 
 static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 			       struct iovec **iovec, struct iov_iter *iter,
@@ -942,7 +943,7 @@ static void __io_put_req_task(struct io_kiocb *req)
 		put_task_struct(req->task);
 }
 
-static void io_sq_thread_drop_mm(struct io_ring_ctx *ctx)
+static void io_sq_thread_drop_mm(void)
 {
 	struct mm_struct *mm = current->mm;
 
@@ -977,8 +978,6 @@ static inline void req_set_fail_links(struct io_kiocb *req)
 		req->flags |= REQ_F_FAIL_LINK;
 }
 
-static void io_file_put_work(struct work_struct *work);
-
 /*
  * Note: must call io_req_init_async() for the first time you
  * touch any members of io_wq_work.
@@ -6339,7 +6338,7 @@ static int io_sq_thread(void *data)
 			 * adding ourselves to the waitqueue, as the unuse/drop
 			 * may sleep.
 			 */
-			io_sq_thread_drop_mm(ctx);
+			io_sq_thread_drop_mm();
 
 			/*
 			 * We're polling. If we're within the defined idle
@@ -6410,7 +6409,7 @@ static int io_sq_thread(void *data)
 
 	io_run_task_work();
 
-	io_sq_thread_drop_mm(ctx);
+	io_sq_thread_drop_mm();
 	revert_creds(old_cred);
 
 	kthread_parkme();
-- 
Jens Axboe

