Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA4EA2DF211
	for <lists+io-uring@lfdr.de>; Sun, 20 Dec 2020 00:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgLSXNx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 19 Dec 2020 18:13:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbgLSXNw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 19 Dec 2020 18:13:52 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A39AAC0613CF
        for <io-uring@vger.kernel.org>; Sat, 19 Dec 2020 15:13:12 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id lj6so3534019pjb.0
        for <io-uring@vger.kernel.org>; Sat, 19 Dec 2020 15:13:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7II2HIpLxXL7rdUJnUCo6oonaERwuOGTnoTKwPRdteU=;
        b=nOIBEPLhOpr3ixEPGO/FoVaTET5CniXvCFoLJMnAAuxenFIgfvUUWiciPTLZWqmGA3
         zqur5sToIVILRDbNiFD/7hjTRb4/x4YTdYxtEOrA1LvDnRRNKpYHngZMDMf/UJTwBy2z
         +eudwxqhc4jVVH7f8MT8DaXoUkQwUUf8/0ekwhCItm6IaP1xzpIucFeC8rgHrgde2JhT
         tlRMNfU5TyOHl2sHie84C1YjWdbJC4gIks1wZLlsf4i4F4chDapIyOa0jtoB+CaRm3jn
         J0ekzmawc4j+ZvEBjnEy7jTIkc8tXr4hUYs8hGYbmZUf0CV4WOo3lnekxSmN02gTV9+e
         lnEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7II2HIpLxXL7rdUJnUCo6oonaERwuOGTnoTKwPRdteU=;
        b=j/wjsgoB17ODlrs5hz/v4Uq0MpJTI9KSw3Ay8EuGw+ULPo1h0BJsoCqu2Tn8Rjb3Cx
         HolrZ//In7MMTcNXKmuuRYMlhMudRXitgS2R8BD83E8qKYczKOxiLKuFSEcqsQZWV1lY
         +CKKKgOcJ3YbzZNB7x59jutuGYIMbUPhuahCquDQcFMpPu0dfJnuGWuBowZzYs7v0d/N
         5lKpXx+tIJDiIJS2k/HyogM4nwCx0NzZ2IjmZWfKNVjkV9liUrCNYm47sGGRIGIZLYR5
         8N+NF+0xVn+BFhW4y5dC2QAacXmzDicM6b5RssYp7tPH+3DuXjUBtvgGM6KfeDpEoOWH
         bkqg==
X-Gm-Message-State: AOAM531eizfAodzx22Yijcwour0rYAjNgUk7m4igtHyo040OOzH0AB7N
        5vvYxxERnEg2MfOjf51m4QqPxNwurqXf3w==
X-Google-Smtp-Source: ABdhPJwdXwp8Ldk86eB4IiOBvf0gyyupQfFUZE10a0VLsqWtrn7UXIEhNNmDttla8mDaJqJbw7wklw==
X-Received: by 2002:a17:90a:b395:: with SMTP id e21mr10831441pjr.197.1608419591715;
        Sat, 19 Dec 2020 15:13:11 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id r67sm12185195pfc.82.2020.12.19.15.13.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Dec 2020 15:13:10 -0800 (PST)
Subject: Re: "Cannot allocate memory" on ring creation (not RLIMIT_MEMLOCK)
From:   Jens Axboe <axboe@kernel.dk>
To:     Josef <josef.grieb@gmail.com>
Cc:     Norman Maurer <norman.maurer@googlemail.com>,
        Dmitry Kadashev <dkadashev@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <4dc9c74b-249d-117c-debf-4bb9e0df2988@kernel.dk>
 <2B352D6C-4CA2-4B09-8751-D7BB8159072D@googlemail.com>
 <d9205a43-ebd7-9412-afc6-71fdcf517a32@kernel.dk>
 <CAAss7+ps4xC785yMjXC6u8NiH9PCCQQoPiH+AhZT7nMX7Q_uEw@mail.gmail.com>
 <0fe708e2-086b-94a8-def4-e4ebd6e0b709@kernel.dk>
Message-ID: <614f8422-3e0e-25b9-4cc2-4f1c07705ab0@kernel.dk>
Date:   Sat, 19 Dec 2020 16:13:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0fe708e2-086b-94a8-def4-e4ebd6e0b709@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/19/20 2:54 PM, Jens Axboe wrote:
> On 12/19/20 1:51 PM, Josef wrote:
>>> And even more so, it's IOSQE_ASYNC on the IORING_OP_READ on an eventfd
>>> file descriptor. You probably don't want/mean to do that as it's
>>> pollable, I guess it's done because you just set it on all reads for the
>>> test?
>>
>> yes exactly, eventfd fd is blocking, so it actually makes no sense to
>> use IOSQE_ASYNC
> 
> Right, and it's pollable too.
> 
>> I just tested eventfd without the IOSQE_ASYNC flag, it seems to work
>> in my tests, thanks a lot :)
>>
>>> In any case, it should of course work. This is the leftover trace when
>>> we should be exiting, but an io-wq worker is still trying to get data
>>> from the eventfd:
>>
>> interesting, btw what kind of tool do you use for kernel debugging?
> 
> Just poking at it and thinking about it, no hidden magic I'm afraid...

Josef, can you try with this added? Looks bigger than it is, most of it
is just moving one function below another.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index f3690dfdd564..96f6445ab827 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8735,10 +8735,43 @@ static void io_cancel_defer_files(struct io_ring_ctx *ctx,
 	}
 }
 
+static void __io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
+					    struct task_struct *task)
+{
+	while (1) {
+		struct io_task_cancel cancel = { .task = task, .files = NULL, };
+		enum io_wq_cancel cret;
+		bool ret = false;
+
+		cret = io_wq_cancel_cb(ctx->io_wq, io_cancel_task_cb, &cancel, true);
+		if (cret != IO_WQ_CANCEL_NOTFOUND)
+			ret = true;
+
+		/* SQPOLL thread does its own polling */
+		if (!(ctx->flags & IORING_SETUP_SQPOLL)) {
+			while (!list_empty_careful(&ctx->iopoll_list)) {
+				io_iopoll_try_reap_events(ctx);
+				ret = true;
+			}
+		}
+
+		ret |= io_poll_remove_all(ctx, task, NULL);
+		ret |= io_kill_timeouts(ctx, task, NULL);
+		if (!ret)
+			break;
+		io_run_task_work();
+		cond_resched();
+	}
+}
+
 static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 				  struct task_struct *task,
 				  struct files_struct *files)
 {
+	/* files == NULL, task is exiting. Cancel all that match task */
+	if (!files)
+		__io_uring_cancel_task_requests(ctx, task);
+
 	while (!list_empty_careful(&ctx->inflight_list)) {
 		struct io_task_cancel cancel = { .task = task, .files = files };
 		struct io_kiocb *req;
@@ -8772,35 +8805,6 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 	}
 }
 
-static void __io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
-					    struct task_struct *task)
-{
-	while (1) {
-		struct io_task_cancel cancel = { .task = task, .files = NULL, };
-		enum io_wq_cancel cret;
-		bool ret = false;
-
-		cret = io_wq_cancel_cb(ctx->io_wq, io_cancel_task_cb, &cancel, true);
-		if (cret != IO_WQ_CANCEL_NOTFOUND)
-			ret = true;
-
-		/* SQPOLL thread does its own polling */
-		if (!(ctx->flags & IORING_SETUP_SQPOLL)) {
-			while (!list_empty_careful(&ctx->iopoll_list)) {
-				io_iopoll_try_reap_events(ctx);
-				ret = true;
-			}
-		}
-
-		ret |= io_poll_remove_all(ctx, task, NULL);
-		ret |= io_kill_timeouts(ctx, task, NULL);
-		if (!ret)
-			break;
-		io_run_task_work();
-		cond_resched();
-	}
-}
-
 /*
  * We need to iteratively cancel requests, in case a request has dependent
  * hard links. These persist even for failure of cancelations, hence keep

-- 
Jens Axboe

