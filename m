Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C204E407F28
	for <lists+io-uring@lfdr.de>; Sun, 12 Sep 2021 20:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbhILSQd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Sep 2021 14:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbhILSQc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Sep 2021 14:16:32 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D22DEC061574
        for <io-uring@vger.kernel.org>; Sun, 12 Sep 2021 11:15:17 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id b10so9151664ioq.9
        for <io-uring@vger.kernel.org>; Sun, 12 Sep 2021 11:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ogHesMDpKGxf6RH9yHh1zki41VihTW9bMbJ0zX+O6Kk=;
        b=gtldxaIdkPDYxZinnbQjuEYP4CZvPREGJaJc/qrUdPg4PSz660/r4svAolsYVeXRnF
         J35QhDKf2UVz0TVrA6SoAKefwdcNGki5IMpW0YgSlDk5cMTjPCmNK0TjhtYsNf3WVThn
         fHb7pnJSQTnF00ryQDPB2HacR95x1/tyGDZiVnYR6+uw8u9C8v9ERHu8sEOos7HdKeFc
         ItFsW5T6uXtHjV34/VXCYVoolFKhbYI/0/70acX+gRxP7eAJl94KTxYY6Hxy5bqtUJRD
         BuEi8PzSvsdeATGhCZ7ZGC083eucmD0YVNNPG4AkkqA8FHKGT7bGaewJOMLzdZMRUEyg
         TOrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ogHesMDpKGxf6RH9yHh1zki41VihTW9bMbJ0zX+O6Kk=;
        b=VZYGgyWDb6c966dV2nAXRHey24dx1ttaIdg5oimmUhsuKou4huMCrmtErNUV/WFFlm
         BxDEcjFXMjWFBtXaLxKi4rfH6IPO5qJSAe8HaIhKOx/vBKk60NVMtFc5cFMQH+sUdKQl
         vWW3FRHao/BCyeYaR0AU+somnohn3DY0geU0GJ3BAeJeWaHxvTqOAdaQdsv9Mc7720sl
         azT2PaThSdSCrxz/au1aJ/jsRsnwZBOXoIaKMU5w5e5BaEfpyeqk+Bv79MwVolHEFg7M
         tfQ3fBVWIfDT+k0Is9TpHWvt0QBVlbNglZ0w6k9HSN/xELTgPpgeLpf8CNbOvOuRQfSV
         qmeg==
X-Gm-Message-State: AOAM532TxZ8SOUVJWZC3vftAXDbuYE3sSDbpFYh+InuQ1v90duFG1CZu
        mnycem4fbsyVNYLckNJki2Gp3ftcwqAIDQ==
X-Google-Smtp-Source: ABdhPJwVoHVWarQ3EMuO/ZNQ+40wG5Udt2KNJnm42QCaNgMDIjlYSMAqMA3l/OFi/qeLxtqfyG2cxQ==
X-Received: by 2002:a6b:e712:: with SMTP id b18mr6109092ioh.186.1631470517227;
        Sun, 12 Sep 2021 11:15:17 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id q12sm3032138ioh.20.2021.09.12.11.15.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Sep 2021 11:15:16 -0700 (PDT)
Subject: Re: io-uring: KASAN failure, presumably
To:     Nadav Amit <nadav.amit@gmail.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <2C3AECED-1915-4080-B143-5BA4D76FB5CD@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <859829f3-ecd0-0c01-21d4-28c17382aa52@kernel.dk>
Date:   Sun, 12 Sep 2021 12:15:15 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <2C3AECED-1915-4080-B143-5BA4D76FB5CD@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/11/21 8:34 PM, Nadav Amit wrote:
> Hello Jens (& Pavel),
> 
> I hope you are having a nice weekend. I ran into a KASAN failure in io-uring
> which I think is not "my fault".
> 
> The failure does not happen very infrequently, so my analysis is based on
> reading the code. IIUC the failure, then I do not understand the code well
> enough, as to say I do not understand how it was supposed to work. I would
> appreciate your feedback.
> 
> The failure happens on my own custom kernel (do not try to correlate the line
> numbers). The gist of the splat is:
> 
> [84142.034456] ==================================================================
> [84142.035552] BUG: KASAN: use-after-free in io_req_complete_post (fs/io_uring.c:1629)
> [84142.036473] Read of size 4 at addr ffff8881a1577e60 by task memcached/246246
> [84142.037415]
> [84142.037621] CPU: 0 PID: 246246 Comm: memcached Not tainted 5.13.1+ #236
> [84142.038509] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/22/2020
> [84142.040151] Call Trace:      
> [84142.040495] dump_stack (lib/dump_stack.c:122)
> [84142.040962] print_address_description.constprop.0 (mm/kasan/report.c:234)
> [84142.041751] ? io_req_complete_post (fs/io_uring.c:1629)
> [84142.042365] kasan_report.cold (mm/kasan/report.c:420 mm/kasan/report.c:436)
> [84142.042921] ? io_req_complete_post (fs/io_uring.c:1629)
> [84142.043534] __asan_load4 (mm/kasan/generic.c:252) 
> [84142.044008] io_req_complete_post (fs/io_uring.c:1629) 
> [84142.044609] __io_complete_rw.isra.0 (fs/io_uring.c:2525) 
> [84142.045264] ? lockdep_hardirqs_on_prepare (kernel/locking/lockdep.c:4123) 
> [84142.045949] io_complete_rw (fs/io_uring.c:2532) 
> [84142.046447] handle_userfault (fs/userfaultfd.c:778) 
> 
> [snip]
> 
> [84142.072667] Freed by task 246231:
> [84142.073197] kasan_save_stack (mm/kasan/common.c:39)
> [84142.073896] kasan_set_track (mm/kasan/common.c:46)
> [84142.074421] kasan_set_free_info (mm/kasan/generic.c:359)
> [84142.075015] __kasan_slab_free (mm/kasan/common.c:362 mm/kasan/common.c:325 mm/kasan/common.c:368)
> [84142.075578] kmem_cache_free (mm/slub.c:1608 mm/slub.c:3168 mm/slub.c:3184)
> [84142.076116] __io_free_req (./arch/x86/include/asm/preempt.h:80 ./include/linux/rcupdate.h:68 ./include/linux/rcupdate.h:655 ./include/linux/percpu-refcount.h:317 ./include/linux/percpu-refcount.h:338 fs/io_uring.c:1802)
> [84142.076641] io_free_req (fs/io_uring.c:2113)
> [84142.077110] __io_queue_sqe (fs/io_uring.c:2208 fs/io_uring.c:6533)
> [84142.077628] io_queue_sqe (fs/io_uring.c:6568)
> [84142.078121] io_submit_sqes (fs/io_uring.c:6730 fs/io_uring.c:6838)
> [84142.078665] __x64_sys_io_uring_enter (fs/io_uring.c:9428 fs/io_uring.c:9369 fs/io_uring.c:9369)
> [84142.079463] do_syscall_64 (arch/x86/entry/common.c:47)
> [84142.079967] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:112)
> 
> 
> I believe the issue is related to the handling of REQ_F_REISSUE and
> specifically to commit 230d50d448acb ("io_uring: move reissue into regular IO
> path"). There seems to be a race between io_write()/io_read()
> and __io_complete_rw()/kiocb_done().
> 
> __io_complete_rw() sets REQ_F_REIUSSE:
> 
>                if ((res == -EAGAIN || res == -EOPNOTSUPP) &&
>                     io_rw_should_reissue(req)) {
>                         req->flags |= REQ_F_REISSUE;
>                         return;
>                }
> 
> And then kiocb_done() then checks REQ_F_REISSUE and clear it:
> 
>         if (check_reissue && req->flags & REQ_F_REISSUE) {
>                 req->flags &= ~REQ_F_REISSUE;
>                 ...
> 
> 
> These two might race with io_write() for instance, which issues the I/O
> (__io_complete_rw() and kiocb_done() might run immediately after
> call_write_iter() is called) and then check and clear REQ_F_REISSUE.
> 
>         if (req->file->f_op->write_iter)
>                 ret2 = call_write_iter(req->file, kiocb, iter);
>         else if (req->file->f_op->write)
>                 ret2 = loop_rw_iter(WRITE, req, iter);
>         else
>                 ret2 = -EINVAL;
> 
>         if (req->flags & REQ_F_REISSUE) {
>                 req->flags &= ~REQ_F_REISSUE;
>                 ret2 = -EAGAIN;
>         }
> 
> 
> So if call_write_iter() returns -EIOCBQUEUED, this return value can be
> lost/ignored if kiocb_done() was called with result of -EAGAIN. Presumably,
> other bad things might happen due to the fact both io_write() and
> kiocb_done() see REQ_F_REISSUE set.
> 
> You might ask why, after enqueuing the IO for async execution, kiocb_done()
> would be called with -EAGAIN as a result. Indeed, this might be more
> unique to my use-case that is under development (userfaultfd might
> return -EAGAIN if the mappings undergoing changes; presumably -EBUSY or some
> wait-queue would be better.) Having said that, the current behavior still
> seems valid.
> 
> So I do not understand the check for REQ_F_REISSUE in io_write()/io_read().
> Shouldn't it just be removed? I do not suppose you want to do
> bit-test-and-clear to avoid such a race.

I think this is specific to your use case, but I also think that we
should narrow the scope for this type of REQ_F_REISSUE trigger. It
really should only happen on bdev backed regular files, where we cannot
easily pass back congestion. For that case, the completion for this is
called while we're in ->write_iter() for example, and hence there is no
race here.

I'll ponder this a bit...

-- 
Jens Axboe

