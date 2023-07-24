Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB5475FB7F
	for <lists+io-uring@lfdr.de>; Mon, 24 Jul 2023 18:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbjGXQIo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Jul 2023 12:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbjGXQIn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Jul 2023 12:08:43 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD6E510CB
        for <io-uring@vger.kernel.org>; Mon, 24 Jul 2023 09:08:41 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id ca18e2360f4ac-760dff4b701so56438239f.0
        for <io-uring@vger.kernel.org>; Mon, 24 Jul 2023 09:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1690214921; x=1690819721;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wNOF1JdcRe0DswrRjh4bAr6jysq/J++8V+u4H31QvHY=;
        b=DNEvElxfMAwF4xTyodKxfNuxNfLAlczk6wmViBstzmXyR8wHYGk1yoweWWFnKLwfJo
         dXSYbDjEvU1r7d6yrvt3QCQjCYR+nUJscXW06/Ba5K4b+skBoieRTlh361PkA5b7a4Ev
         d2mWAP645C9kAj0cstDe+PX8uwM4fLT3HkrbKMAs9dvxGCEztHOnzx6+IshklKdNhvRy
         FLUV8I43Z9RmW2/AoI5f7nsmeA7Pre9RNHpOy5D+3bOBCMngWI8aEu56SwbpRI/BWT7n
         xP6QXIxw5yqzWUHFHoG6ADJ/OtxKA79bL9N8GoPVijEuxEXGma9wg0S87vRq++B4GbEb
         fbUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690214921; x=1690819721;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wNOF1JdcRe0DswrRjh4bAr6jysq/J++8V+u4H31QvHY=;
        b=P9o813brUfjFN4FRa9ezyEk5DzfUC/0QvR83FCbVYrNUFuyqRS5G+Tfrp+In7dLu5K
         2Dn64QEVpWcniuiEMyeEg9uDxAXGABDMUviIUWdlVwqcfS3XbAWvUcrSwHoAT9FLlJFz
         lqBNNK/M4qPlBhDngUw7xEup8lHk/gdQKiOxutiNY7TcDBS20cf5m2o9Pydp2epHPdxD
         o3TQMnEs81f5gbiYXLxIVBcN1tCJ1ngqwVEDAxv3r2CRO3TfX4nMU0T4T7Z7Wo+33UYR
         tu4ngHxfg9MSdx2XlZhmE3hnU3nc7td01Li5ddG4n6Ujjdtv1wibB6IJ1TsA1Yzi0/O6
         pCWA==
X-Gm-Message-State: ABy/qLYyfvufNoA7kdacaN6E9JH4r9ViCOScuGpWwCFUdc2J5YJQNHVF
        sn39GI/8Ka5l+1IyuHjdc1307w==
X-Google-Smtp-Source: APBJJlE59LeZWE4oqVca4z7/hld8kYGptG2g38wXs/v5wcRL+pR1hrAy8TOzBkwVVCyMjX4XmJ/NNw==
X-Received: by 2002:a92:d44c:0:b0:345:bdc2:eb42 with SMTP id r12-20020a92d44c000000b00345bdc2eb42mr7260683ilm.3.1690214921003;
        Mon, 24 Jul 2023 09:08:41 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id p1-20020a92d681000000b0033e23a5c730sm3086542iln.88.2023.07.24.09.08.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jul 2023 09:08:40 -0700 (PDT)
Message-ID: <0ae07b66-956a-bb62-e4e8-85fa5f72362f@kernel.dk>
Date:   Mon, 24 Jul 2023 10:08:39 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] io_uring: Use io_schedule* in cqring wait
Content-Language: en-US
To:     Phil Elwell <phil@raspberrypi.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>, andres@anarazel.de,
        asml.silence@gmail.com, david@fromorbit.com, hch@lst.de,
        io-uring@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-xfs@vger.kernel.org, stable <stable@vger.kernel.org>
References: <CAMEGJJ2RxopfNQ7GNLhr7X9=bHXKo+G5OOe0LUq=+UgLXsv1Xg@mail.gmail.com>
 <2023072438-aftermath-fracture-3dff@gregkh>
 <140065e3-0368-0b5d-8a0d-afe49b741ad2@kernel.dk>
 <ecb821a2-e90a-fec1-d2ca-b355c16b7515@kernel.dk>
 <CAMEGJJ3SjWdJFwzB+sz79ojWqAAMULa2CFAas0tv+JJLJMwoGQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAMEGJJ3SjWdJFwzB+sz79ojWqAAMULa2CFAas0tv+JJLJMwoGQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/24/23 10:07?AM, Phil Elwell wrote:
>> Even though I don't think this is an actual problem, it is a bit
>> confusing that you get 100% iowait while waiting without having IO
>> pending. So I do think the suggested patch is probably worthwhile
>> pursuing. I'll post it and hopefully have Andres test it too, if he's
>> available.
> 
> If you CC me I'll happily test it for you.

Here it is.

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 89a611541bc4..f4591b912ea8 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2493,11 +2493,20 @@ int io_run_task_work_sig(struct io_ring_ctx *ctx)
 	return 0;
 }
 
+static bool current_pending_io(void)
+{
+	struct io_uring_task *tctx = current->io_uring;
+
+	if (!tctx)
+		return false;
+	return percpu_counter_read_positive(&tctx->inflight);
+}
+
 /* when returns >0, the caller should retry */
 static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 					  struct io_wait_queue *iowq)
 {
-	int token, ret;
+	int io_wait, ret;
 
 	if (unlikely(READ_ONCE(ctx->check_cq)))
 		return 1;
@@ -2511,17 +2520,19 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 		return 0;
 
 	/*
-	 * Use io_schedule_prepare/finish, so cpufreq can take into account
-	 * that the task is waiting for IO - turns out to be important for low
-	 * QD IO.
+	 * Mark us as being in io_wait if we have pending requests, so cpufreq
+	 * can take into account that the task is waiting for IO - turns out
+	 * to be important for low QD IO.
 	 */
-	token = io_schedule_prepare();
+	io_wait = current->in_iowait;
+	if (current_pending_io())
+		current->in_iowait = 1;
 	ret = 0;
 	if (iowq->timeout == KTIME_MAX)
 		schedule();
 	else if (!schedule_hrtimeout(&iowq->timeout, HRTIMER_MODE_ABS))
 		ret = -ETIME;
-	io_schedule_finish(token);
+	current->in_iowait = io_wait;
 	return ret;
 }
 

-- 
Jens Axboe

