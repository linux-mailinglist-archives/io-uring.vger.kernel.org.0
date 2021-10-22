Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5780C4378D5
	for <lists+io-uring@lfdr.de>; Fri, 22 Oct 2021 16:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233032AbhJVOPZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Oct 2021 10:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232244AbhJVOPY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Oct 2021 10:15:24 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF65C061764;
        Fri, 22 Oct 2021 07:13:07 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id e19so3657275edy.0;
        Fri, 22 Oct 2021 07:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Idky6EnOMcqMfak2UWptIWA1BDb5D9P9K0GrvJjzY0M=;
        b=m7+n0n1SZvQBOOPDhDuoqgS8Ab1Uqx7QzeLrMmoBUH9YSB1Y5rgdZIo36aAuCVLtXd
         2Fys3y7n8b5s9V9FrJjKb81nz8VQvOYsnOlHtXh35XxPQ+ry0XwnqWJMn0Y3xu9QLXPW
         VUhcVBsHLPm7GaQUPsEG10n+phNeA2zZtKFrgVkpBMYNqzngQTNz8173x6CxAhGLJ+Nx
         UbCohJ+GwEstdJJPVnKIWPT9ipsKJwxPmQ7E2rYzsRmiZHCdYiwWncUqXGdo/xDcJNTc
         Db7lbG1+p2A+htbpM9U1Z9wvRAaAlsxeIF8m0H+3bWdec027nMhcVi3a8Bh37nQMp6Hw
         RHFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Idky6EnOMcqMfak2UWptIWA1BDb5D9P9K0GrvJjzY0M=;
        b=OORrEo2+spEEhM81J6O1tRiY8rZq1/WppVp0Tze9JiqI7Jo7yh/gxK3rnlbI7wx6nX
         yqhlHC3dZ0b51vno3UvY1EDv0UKpRzXm51pmPzUqNbO5EDIsw5orbj2C7Ul6/Fburgrt
         Hj+P1X4lId7RYVPJBZWMmmEYTavAJPn6X+bHqV57GIxR5R+mTmJ1/j5JVKTYoZlhZGz2
         DhX3fUW2xcUQmYa6d5VYgLx6P4iXEDCOjHKuELVl3bzHrKvzi9J2+AzxRZHi1/aS+2H9
         clN2EUSN8M9Wdsa7UhTfhAcHvq4gncFUepe8UqU48968zcTQ9v9yh0vAZn6Zg5lDEsIo
         A1Ig==
X-Gm-Message-State: AOAM531pUen+P5x5ocOwzmZrBcvYPqModU9CL7sA+bD23rto6FiN/mnZ
        tO/xu9nuqiz5p0a8jLkzXvs=
X-Google-Smtp-Source: ABdhPJyATZVZpxG7/5RzJfCnsjsSeZVVQc4TmViDOjfzplXWryBmyJRw5uCifSdMB2o3ubMGA8EwhQ==
X-Received: by 2002:aa7:c78f:: with SMTP id n15mr309219eds.338.1634911985650;
        Fri, 22 Oct 2021 07:13:05 -0700 (PDT)
Received: from [192.168.8.198] ([148.252.133.195])
        by smtp.gmail.com with ESMTPSA id c21sm4603739edx.1.2021.10.22.07.13.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Oct 2021 07:13:05 -0700 (PDT)
Message-ID: <1b519092-2ebf-3800-306d-c354c24a9ad1@gmail.com>
Date:   Fri, 22 Oct 2021 15:13:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC] coredump: Do not interrupt dump for TIF_NOTIFY_SIGNAL
Content-Language: en-US
To:     "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <192c9697e379bf084636a8213108be6c3b948d0b.camel@trillion01.com>
 <9692dbb420eef43a9775f425cb8f6f33c9ba2db9.camel@trillion01.com>
 <87h7i694ij.fsf_-_@disp2133>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <87h7i694ij.fsf_-_@disp2133>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/9/21 21:17, Eric W. Biederman wrote:
> 
> Folks,
> 
> Olivier Langlois has been struggling with coredumps getting truncated in
> tasks using io_uring.  He has also apparently been struggling with
> the some of his email messages not making it to the lists.

Looks syzbot hit something relevant, see
https://lore.kernel.org/io-uring/0000000000000012fb05cee99477@google.com/

In short, a task creates an io_uring worker thread, then the worker
submits a task_work item to the creator task and won't die until
the item is executed/cancelled. And I found that the creator task is
sleeping in do_coredump() -> wait_for_completion()

0xffffffff81343ccb is in do_coredump (fs/coredump.c:469).
464
465             if (core_waiters > 0) {
466                     struct core_thread *ptr;
467
468                     freezer_do_not_count();
469                     wait_for_completion(&core_state->startup);
470                     freezer_count();


A hack executing tws there helps (see diff below).
Any chance anyone knows what this is and how to fix it?


diff --git a/fs/coredump.c b/fs/coredump.c
index 3224dee44d30..f6f9dfb02296 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -466,7 +466,8 @@ static int coredump_wait(int exit_code, struct core_state *core_state)
          struct core_thread *ptr;
  
          freezer_do_not_count();
-        wait_for_completion(&core_state->startup);
+        while (wait_for_completion_interruptible(&core_state->startup))
+            tracehook_notify_signal();
          freezer_count();
          /*
           * Wait for all the threads to become inactive, so that



> 
> We were talking about some of his struggles and questions in this area
> and he pointed me to this patch he thought he had posted but I could not
> find in the list archives.
> 
> In short the coredump code deliberately supports being interrupted by
> SIGKILL, and depends upon prepare_signal to filter out all other
> signals.  With the io_uring code comes an extra test in signal_pending
> for TIF_NOTIFY_SIGNAL (which is something about asking a task to run
> task_work_run).
> 
> I am baffled why the dumper thread would be getting interrupted by
> TIF_NOTIFY_SIGNAL but apparently it is.  Perhaps it is an io_uring
> thread that is causing the dump.
> 
> Now that we know the problem the question becomes how to fix this issue.
> 
> Is there any chance all of this TWA_SIGNAL logic could simply be removed
> now that io_uring threads are normal process threads?
> 
> There are only the two call sites so I perhaps the could test
> signal->flags & SIGNAL_FLAG_COREDUMP before scheduling a work on
> a process that is dumping core?
> 
> Perhaps the coredump code needs to call task_work_run before it does
> anything?
> 
> -----
> 
> From: Olivier Langlois <olivier@trillion01.com>
> Subject: [PATCH] coredump: Do not interrupt dump for TIF_NOTIFY_SIGNAL
> Date: Mon, 07 Jun 2021 16:25:06 -0400
> 
> io_uring is a big user of task_work and any event that io_uring made a
> task waiting for that occurs during the core dump generation will
> generate a TIF_NOTIFY_SIGNAL.
> 
> Here are the detailed steps of the problem:
> 1. io_uring calls vfs_poll() to install a task to a file wait queue
>     with io_async_wake() as the wakeup function cb from io_arm_poll_handler()
> 2. wakeup function ends up calling task_work_add() with TWA_SIGNAL
> 3. task_work_add() sets the TIF_NOTIFY_SIGNAL bit by calling
>     set_notify_signal()
> 
> Signed-off-by: Olivier Langlois <olivier@trillion01.com>
> ---
>   fs/coredump.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/coredump.c b/fs/coredump.c
> index 2868e3e171ae..79c6e3f114db 100644
> --- a/fs/coredump.c
> +++ b/fs/coredump.c
> @@ -519,7 +519,7 @@ static bool dump_interrupted(void)
>   	 * but then we need to teach dump_write() to restart and clear
>   	 * TIF_SIGPENDING.
>   	 */
> -	return signal_pending(current);
> +	return task_sigpending(current);
>   }
>   
>   static void wait_for_dump_helpers(struct file *file)
> 

-- 
Pavel Begunkov
