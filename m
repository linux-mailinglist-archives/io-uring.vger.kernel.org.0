Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB8BE26346F
	for <lists+io-uring@lfdr.de>; Wed,  9 Sep 2020 19:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729911AbgIIRUk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Sep 2020 13:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728015AbgIIP0a (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Sep 2020 11:26:30 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79EA3C061347
        for <io-uring@vger.kernel.org>; Wed,  9 Sep 2020 06:53:25 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id g128so3166952iof.11
        for <io-uring@vger.kernel.org>; Wed, 09 Sep 2020 06:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=wGhRxaMDKS3aieIjmunmP17TCIdNm1wCfbjrZKGE2l8=;
        b=FviXqksrPN/G0uJsZgd4Jj/Av4g6EsoTc5Ph3SPSFtG4arGnQr1awUViPSl3zns62A
         DGbclYrBfHXfATuwz3Sv04dwVnloMd5qqbNkzGlYKKvBUYC0MYs3EQI+0z33Ffm9DWoL
         WW5isIhTR0vecWRl60OJJBbGjVK/lEg3xzouT0n83fz1r9vhrLV2Tw/VcD0mtd+gON+k
         z7fuPtKGT9/xfW2bm0+RCH4lHWVRMyDoPd9TFbYlg/tufA96Zdrk2qtsvUE4m9AGLxFY
         evaiuWnSFE0K4Rgzg7Hd1snwGMxGlP2Re6fIvoO2ZW7B+/fb7afbVIHxZePfkaUVKESr
         l7hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wGhRxaMDKS3aieIjmunmP17TCIdNm1wCfbjrZKGE2l8=;
        b=VXt87jTjv0CgRFofHRtL2XhNJ9DD4POECmYW1FSXP1m+lujitNxTbfgyvBFNUBvDQa
         ZiE9lgq1DC6wUwCX4EGjhNfk+oDU59lrvXbUtJ3XoKfMS6zNu9GcnesUly4f21W7nmO5
         oqyHM0h28qM9jnJtVYoVlJgYEkk/4dqZcTS/wnsWqzK59vikQMgw1bSG2EmfifeCscfO
         dsUjLKvHFa0HxLwUFQHCyiUeweIHDB4QaAjuIjjP26w9hpmgPPeBHlzxaM2OOSIT0WwW
         7yKRf2lRZd1atfaCFJX1lAyfeGYDDF6nx6HN0dO4/bicvaU/HZlfywQ7dW2mcPe4l660
         NSHw==
X-Gm-Message-State: AOAM532EqCK3AyZvBS2Og8OzW6BKFZQUlYgnQrLxABTddjlC5TL1vBP+
        0HIdKy2V9JoBA0GWsMGt8cDrzXEljZTwg86L
X-Google-Smtp-Source: ABdhPJxZw3PGgSaAbC6yhbK1ZXbQx1bcJyH4MZxjZdsH9VRM6oAeLImUSmXwBkkhwYbvbSFQ9CGa3w==
X-Received: by 2002:a02:950e:: with SMTP id y14mr4235313jah.106.1599659603963;
        Wed, 09 Sep 2020 06:53:23 -0700 (PDT)
Received: from [192.168.1.10] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id z15sm1411336ilb.73.2020.09.09.06.53.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2020 06:53:22 -0700 (PDT)
Subject: Re: [PATCH for-next] io_uring: ensure IOSQE_ASYNC file table grabbing
 works, with SQPOLL
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <b105ea32-3831-b3c5-3993-4b38cc966667@kernel.dk>
 <8f6871c4-1344-8556-25a7-5c875aebe4a5@gmail.com>
 <622649c5-e30d-bc3c-4709-bbe60729cca1@kernel.dk>
 <1c088b17-53bb-0d6d-6573-a1958db88426@kernel.dk>
 <801ed334-54ea-bdee-4d81-34b7e358b506@gmail.com>
 <370c055e-fa8d-0b80-bd34-ba3ba9bc6b37@kernel.dk>
Message-ID: <623ba520-ba63-e0bf-36c0-32a94d8c0087@kernel.dk>
Date:   Wed, 9 Sep 2020 07:53:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <370c055e-fa8d-0b80-bd34-ba3ba9bc6b37@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/9/20 7:10 AM, Jens Axboe wrote:
> On 9/9/20 1:09 AM, Pavel Begunkov wrote:
>> On 09/09/2020 01:54, Jens Axboe wrote:
>>> On 9/8/20 3:22 PM, Jens Axboe wrote:
>>>> On 9/8/20 2:58 PM, Pavel Begunkov wrote:
>>>>> On 08/09/2020 20:48, Jens Axboe wrote:
>>>>>> Fd instantiating commands like IORING_OP_ACCEPT now work with SQPOLL, but
>>>>>> we have an error in grabbing that if IOSQE_ASYNC is set. Ensure we assign
>>>>>> the ring fd/file appropriately so we can defer grab them.
>>>>>
>>>>> IIRC, for fcheck() in io_grab_files() to work it should be under fdget(),
>>>>> that isn't the case with SQPOLL threads. Am I mistaken?
>>>>>
>>>>> And it looks strange that the following snippet will effectively disable
>>>>> such requests.
>>>>>
>>>>> fd = dup(ring_fd)
>>>>> close(ring_fd)
>>>>> ring_fd = fd
>>>>
>>>> Not disagreeing with that, I think my initial posting made it clear
>>>> it was a hack. Just piled it in there for easier testing in terms
>>>> of functionality.
>>>>
>>>> But the next question is how to do this right...> 
>>> Looking at this a bit more, and I don't necessarily think there's a
>>> better option. If you dup+close, then it just won't work. We have no
>>> way of knowing if the 'fd' changed, but we can detect if it was closed
>>> and then we'll end up just EBADF'ing the requests.
>>>
>>> So right now the answer is that we can support this just fine with
>>> SQPOLL, but you better not dup and close the original fd. Which is not
>>> ideal, but better than NOT being able to support it.
>>>
>>> Only other option I see is to to provide an io_uring_register()
>>> command to update the fd/file associated with it. Which may be useful,
>>> it allows a process to indeed to this, if it absolutely has to.
>>
>> Let's put aside such dirty hacks, at least until someone actually
>> needs it. Ideally, for many reasons I'd prefer to get rid of
> 
> BUt it is actually needed, otherwise we're even more in a limbo state of
> "SQPOLL works for most things now, just not all". And this isn't that
> hard to make right - on the flush() side, we just need to park/stall the
> thread and clear the ring_fd/ring_file, then mark the ring as needing a
> queue enter. On the queue enter, we re-set the fd/file if they're NULL,
> unpark/unstall the thread. That's it. I'll write this up and test it.

Something like this - make sure the thread is idle if the ring fd is
closed, then clear our ring fd/file. Mark the ring as needing a kernel
enter, and when that enter happens, assign the current fd/file. Once
that's done, we can resume processing.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index bd1ac8581d38..652cc53432d4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6704,7 +6704,14 @@ static enum sq_ret __io_sq_thread(struct io_ring_ctx *ctx,
 		mutex_unlock(&ctx->uring_lock);
 	}
 
-	to_submit = io_sqring_entries(ctx);
+	/*
+	 * If ->ring_file is NULL, we're waiting on new fd/file assigment.
+	 * Don't submit anything new until that happens.
+	 */
+	if (ctx->ring_file)
+		to_submit = io_sqring_entries(ctx);
+	else
+		to_submit = 0;
 
 	/*
 	 * If submit got -EBUSY, flag us as needing the application
@@ -6748,7 +6755,7 @@ static enum sq_ret __io_sq_thread(struct io_ring_ctx *ctx,
 		}
 
 		to_submit = io_sqring_entries(ctx);
-		if (!to_submit || ret == -EBUSY)
+		if (!to_submit || ret == -EBUSY || !ctx->ring_file)
 			return SQT_IDLE;
 
 		finish_wait(&sqd->wait, &ctx->sqo_wait_entry);
@@ -8521,6 +8528,18 @@ static int io_uring_flush(struct file *file, void *data)
 	if (fatal_signal_pending(current) || (current->flags & PF_EXITING)) {
 		io_sq_thread_stop(ctx);
 		io_wq_cancel_cb(ctx->io_wq, io_cancel_task_cb, current, true);
+	} else if (ctx->flags & IORING_SETUP_SQPOLL) {
+		struct io_sq_data *sqd = ctx->sq_data;
+
+		/* Ring is being closed, mark us as neding new assignment */
+		if (sqd->thread)
+			kthread_park(sqd->thread);
+		ctx->ring_fd = -1;
+		ctx->ring_file = NULL;
+		set_bit(1, &ctx->sq_check_overflow);
+		io_ring_set_wakeup_flag(ctx);
+		if (sqd->thread)
+			kthread_unpark(sqd->thread);
 	}
 
 	return 0;
@@ -8656,6 +8675,20 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		if (!list_empty_careful(&ctx->cq_overflow_list))
 			io_cqring_overflow_flush(ctx, false);
+		/* marked as needing new fd assigment, process it now */
+		if (test_bit(1, &ctx->sq_check_overflow) &&
+		    test_and_clear_bit(1, &ctx->sq_check_overflow)) {
+			struct io_sq_data *sqd = ctx->sq_data;
+
+			if (sqd->thread)
+				kthread_park(sqd->thread);
+
+			ctx->ring_fd = fd;
+			ctx->ring_file = f.file;
+
+			if (sqd->thread)
+				kthread_unpark(sqd->thread);
+		}
 		if (flags & IORING_ENTER_SQ_WAKEUP)
 			wake_up(&ctx->sq_data->wait);
 		if (flags & IORING_ENTER_SQ_WAIT)

-- 
Jens Axboe

