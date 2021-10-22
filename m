Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 912AF43787C
	for <lists+io-uring@lfdr.de>; Fri, 22 Oct 2021 15:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233013AbhJVN7X (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Oct 2021 09:59:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232308AbhJVN7V (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Oct 2021 09:59:21 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CAD9C061348;
        Fri, 22 Oct 2021 06:57:03 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id g8so1667480edb.12;
        Fri, 22 Oct 2021 06:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:references:in-reply-to:content-transfer-encoding;
        bh=9GBIxqxLAlUdSLI0YT0QE1Q+00ajjsz6MzjdElN8icY=;
        b=mPvvKMcvchT4dJR4dhprsuM6ofDu8X57XUEhtWepqt3uh0CptChxEl3BHyoHTaeZlA
         wgTxDck6bnduJrCL6/i2TlWQAlFCjPMFv3YEnQ3UaSm5LXd7xaYp++TWYacoV2GjnXud
         jKS9xIHqfG9RELYdrPodx8hr/sM63RjYVqN48E5eyhBIYxUbePrdn7iVoYJmtmw1qh4v
         cXDFLP3tNGbBtAvj5br7akPmjNtGLoKo7442AaUhAztEJNPZ+1l3KnJLniZVw0EaRJ5z
         dusOCp+2Hd0FaLDnqyUN0vpkxhovFkGqjNt9D9p+qA+qU2t2h6x9e68N30MRORzHSaRv
         mDmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:references:in-reply-to
         :content-transfer-encoding;
        bh=9GBIxqxLAlUdSLI0YT0QE1Q+00ajjsz6MzjdElN8icY=;
        b=zYj2vDGG/6doOO+jkfiz6BQQYRjwiPI+RbwHEXjDoZE5DhvIK3LXnx35ukTsqlW7pU
         dbmeO20abWDg4al8O6ENr2miqmLxsoYIw0HMlKmM1ya2pi23uw/88pwSvDwwU7zK6K65
         Z3KYoez0FthoCwegKCcZ1GWExP9oRg2VTtnytKlLdlIE3tJmroMjrMPbq0qjpOw6vYfq
         3WkVml+F20NMQ3k/WFhTIU5J+wLzp+6kjmCkhVjKilN/9rnV41TJwScI2qggDPnCbkmL
         Zmp9p+M7lsdTQ3xIlwyFC9Z9UHpqDx4CJB1Kq4rL8wHhF5JtJyvjKHoBbKVF2t67bn0G
         V+8w==
X-Gm-Message-State: AOAM530M3daq+W8urtTP4xVQEh8Wbx/RdwC2GWwoRbtbMO0JKSzkRVR1
        Y8tc26eSA8q4PtllyMNFZPU=
X-Google-Smtp-Source: ABdhPJzK4/m7d8b2POhowwRi9D4reOUw1wVmvLprb7a11dSUV7QrYXinbt73eazNAGqaAI4FZ1johw==
X-Received: by 2002:a50:be82:: with SMTP id b2mr254859edk.56.1634911021979;
        Fri, 22 Oct 2021 06:57:01 -0700 (PDT)
Received: from [192.168.8.198] ([148.252.133.195])
        by smtp.gmail.com with ESMTPSA id t19sm3785490ejb.115.2021.10.22.06.57.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Oct 2021 06:57:01 -0700 (PDT)
Message-ID: <27280d59-88ff-7eeb-1e43-eb9bd23df761@gmail.com>
Date:   Fri, 22 Oct 2021 14:57:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [syzbot] INFO: task hung in io_wqe_worker
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     syzbot <syzbot+27d62ee6f256b186883e@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <0000000000000012fb05cee99477@google.com>
 <85f96aab-4127-f494-9718-d7bfc035db54@gmail.com>
In-Reply-To: <85f96aab-4127-f494-9718-d7bfc035db54@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/22/21 14:49, Pavel Begunkov wrote:
> On 10/22/21 05:38, syzbot wrote:
>> Hello,
>>
>> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
>> INFO: task hung in io_wqe_worker
>>
>> INFO: task iou-wrk-9392:9401 blocked for more than 143 seconds.
>>        Not tainted 5.15.0-rc2-syzkaller #0
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> task:iou-wrk-9392    state:D stack:27952 pid: 9401 ppid:  7038 flags:0x00004004
>> Call Trace:
>>   context_switch kernel/sched/core.c:4940 [inline]
>>   __schedule+0xb44/0x5960 kernel/sched/core.c:6287
>>   schedule+0xd3/0x270 kernel/sched/core.c:6366
>>   schedule_timeout+0x1db/0x2a0 kernel/time/timer.c:1857
>>   do_wait_for_common kernel/sched/completion.c:85 [inline]
>>   __wait_for_common kernel/sched/completion.c:106 [inline]
>>   wait_for_common kernel/sched/completion.c:117 [inline]
>>   wait_for_completion+0x176/0x280 kernel/sched/completion.c:138
>>   io_worker_exit fs/io-wq.c:183 [inline]
>>   io_wqe_worker+0x66d/0xc40 fs/io-wq.c:597
>>   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> 
> Easily reproducible, it's stuck in
> 
> static void io_worker_exit(struct io_worker *worker)
> {
>      ...
>      wait_for_completion(&worker->ref_done);
>      ...
> }
> 
> The reference belongs to a create_worker_cb() task_work item. It's expected
> to either be executed or cancelled by io_wq_exit_workers(), but the owner
> task never goes __io_uring_cancel (called in do_exit()) and so never
> reaches io_wq_exit_workers().
> 
> Following the owner task, cat /proc/<pid>/stack:
> 
> [<0>] do_coredump+0x1d0/0x10e0
> [<0>] get_signal+0x4a3/0x960
> [<0>] arch_do_signal_or_restart+0xc3/0x6d0
> [<0>] exit_to_user_mode_prepare+0x10e/0x190
> [<0>] irqentry_exit_to_user_mode+0x9/0x20
> [<0>] irqentry_exit+0x36/0x40
> [<0>] exc_page_fault+0x95/0x190
> [<0>] asm_exc_page_fault+0x1e/0x30
> 
> (gdb) l *(do_coredump+0x1d0-5)
> 0xffffffff81343ccb is in do_coredump (fs/coredump.c:469).
> 464
> 465             if (core_waiters > 0) {
> 466                     struct core_thread *ptr;
> 467
> 468                     freezer_do_not_count();
> 469                     wait_for_completion(&core_state->startup);
> 470                     freezer_count();
> 
> Can't say anything more at the moment as not familiar with coredump

A simple hack allowing task works to be executed from there
workarounds the problem


diff --git a/fs/coredump.c b/fs/coredump.c
index 3224dee44d30..f6f9dfb02296 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -466,7 +466,8 @@ static int coredump_wait(int exit_code, struct core_state *core_state)
  		struct core_thread *ptr;
  
  		freezer_do_not_count();
-		wait_for_completion(&core_state->startup);
+		while (wait_for_completion_interruptible(&core_state->startup))
+			tracehook_notify_signal();
  		freezer_count();
  		/*
  		 * Wait for all the threads to become inactive, so that



-- 
Pavel Begunkov
