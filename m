Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28DDC214271
	for <lists+io-uring@lfdr.de>; Sat,  4 Jul 2020 02:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726904AbgGDAs1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Jul 2020 20:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726455AbgGDAsY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Jul 2020 20:48:24 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4DA5C061794
        for <io-uring@vger.kernel.org>; Fri,  3 Jul 2020 17:48:23 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id g17so13161172plq.12
        for <io-uring@vger.kernel.org>; Fri, 03 Jul 2020 17:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=BoJ6iFqxhc3kJBQx51cVxrgfjzl0gbLEf25fE6Yqat8=;
        b=kGAjBRKPiyly74bl76cJioRKdH6mCliWxetPLPIYLFPEl5x2OcVWsygKNyYyPhjSJ4
         O5RjVfeD4OLIZ9FvsA6pNe5ig5+PmNf3pUlu/Q8dzijJ0tEp20jNgtQJTR+YcFTYnjEa
         GPBr9Jw10Vy/j4tJFLnhWaO423ghDhxBTIRo1FuGDMzN2p1P/x2yt5K+7Tc2ZtCGkRzr
         sis1n7nJyp5/sJk7RE6NZKPUyhqsTaxnaOnQ0kz0omrGzQIztObPLqyxx4YgNcdpAYNs
         ygx0KlVMEpFQp9tKFCdDQWapOgS4wFnC9aIoBITVnzlI0IPOWATUbhtHBHsm+cZLNtXN
         dhig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BoJ6iFqxhc3kJBQx51cVxrgfjzl0gbLEf25fE6Yqat8=;
        b=de50RKZYs91Tm8BVVNG+LnnB6SqRBRLe5A+GG2RjitC8Amf/Rud3LWUFk2OBghZ5FT
         Xz4Gs+ubFFmBJQYPtcpRmtbsp0TTtL6tb/HBmLxWJENdY+OnyJMFRkyCkzrPJmsd2TmI
         pE9lTq/2+IVXuKV//MJX2RHsZ0K+y0i/vgPGwME9Nkl79JmcKeEhhmY3/j8+BEm93vyD
         pswS+0EHVGzH7zTAqqlcjRY7ZWHKABOs2XalkOEpf2/ThhkRzPAM8LX8QZEojcfz54WZ
         Cg8Ljrme/26/3skF3qyyeP7pdasjAr5jfXiXAAV5m3FHw/NVTyonbbj/EyOHz4AQ8E/a
         l/Pg==
X-Gm-Message-State: AOAM532QkD1R2AsJGaVu9ZrPnm8H1++Zy02pcQH5DT79tK4OvH8Fqbkj
        /qIQrMjLZRUYR7AwaqA0SiSDoVj/7RG7kg==
X-Google-Smtp-Source: ABdhPJy1z9Sd+dLJxDx2MZsPmJeFv6XNKhoL7pNyfgc4GZ9c9e7uo7QVbOmsxQpqJacUgwK7JabuqA==
X-Received: by 2002:a17:90b:1296:: with SMTP id fw22mr2203461pjb.20.1593823702964;
        Fri, 03 Jul 2020 17:48:22 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id b4sm12517675pfo.137.2020.07.03.17.48.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jul 2020 17:48:22 -0700 (PDT)
Subject: Re: signals not reliably interrupting io_uring_enter anymore
To:     Andres Freund <andres@anarazel.de>, io-uring@vger.kernel.org
References: <20200704000049.3elr2mralckeqmej@alap3.anarazel.de>
 <20200704001541.6isrwsr6ptvbykdq@alap3.anarazel.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <70fb9308-2126-052b-730a-bc5adad552f9@kernel.dk>
Date:   Fri, 3 Jul 2020 18:48:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200704001541.6isrwsr6ptvbykdq@alap3.anarazel.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/3/20 6:15 PM, Andres Freund wrote:
> Hi,
> 
> On 2020-07-03 17:00:49 -0700, Andres Freund wrote:
>> I haven't yet fully analyzed the problem, but after updating to
>> cdd3bb54332f82295ed90cd0c09c78cd0c0ee822 io_uring using postgres does
>> not work reliably anymore.
>>
>> The symptom is that io_uring_enter(IORING_ENTER_GETEVENTS) isn't
>> interrupted by signals anymore. The signal handler executes, but
>> afterwards the syscall is restarted. Previously io_uring_enter reliably
>> returned EINTR in that case.
>>
>> Currently postgres relies on signals interrupting io_uring_enter(). We
>> probably can find a way to not do so, but it'd not be entirely trivial.
>>
>> I suspect the issue is
>>
>> commit ce593a6c480a22acba08795be313c0c6d49dd35d (tag: io_uring-5.8-2020-07-01, linux-block/io_uring-5.8)
>> Author: Jens Axboe <axboe@kernel.dk>
>> Date:   2020-06-30 12:39:05 -0600
>>
>>     io_uring: use signal based task_work running
>>
>> as that appears to have changed the error returned by
>> io_uring_enter(GETEVENTS) after having been interrupted by a signal from
>> EINTR to ERESTARTSYS.
>>
>>
>> I'll check to make sure that the issue doesn't exist before the above
>> commit.
> 
> Indeed, on cd77006e01b3198c75fb7819b3d0ff89709539bb the PG issue doesn't
> exist, which pretty much confirms that the above commit is the issue.
> 
> What was the reason for changing EINTR to ERESTARTSYS in the above
> commit? I assume trying to avoid returning spurious EINTRs to userland?

Yeah, for when it's running task_work. I wonder if something like the
below will do the trick?


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 700644a016a7..0efa73d78451 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6197,11 +6197,11 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	do {
 		prepare_to_wait_exclusive(&ctx->wait, &iowq.wq,
 						TASK_INTERRUPTIBLE);
-		/* make sure we run task_work before checking for signals */
-		if (current->task_works)
-			task_work_run();
 		if (signal_pending(current)) {
-			ret = -ERESTARTSYS;
+			if (current->task_works)
+				ret = -ERESTARTSYS;
+			else
+				ret = -EINTR;
 			break;
 		}
 		if (io_should_wake(&iowq, false))
@@ -6210,7 +6210,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	} while (1);
 	finish_wait(&ctx->wait, &iowq.wq);
 
-	restore_saved_sigmask_unless(ret == -ERESTARTSYS);
+	restore_saved_sigmask_unless(ret == -EINTR);
 
 	return READ_ONCE(rings->cq.head) == READ_ONCE(rings->cq.tail) ? ret : 0;
 }

-- 
Jens Axboe

