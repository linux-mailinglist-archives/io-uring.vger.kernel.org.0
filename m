Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4F1644DCD
	for <lists+io-uring@lfdr.de>; Tue,  6 Dec 2022 22:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiLFVPG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Dec 2022 16:15:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiLFVPF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Dec 2022 16:15:05 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ACDC4219B
        for <io-uring@vger.kernel.org>; Tue,  6 Dec 2022 13:15:04 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id 3so4339427iou.12
        for <io-uring@vger.kernel.org>; Tue, 06 Dec 2022 13:15:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P+zJzPA5j2fSPXiFPqe/ELh6l+2nGcRmsM+yat0BzBM=;
        b=Mhti21mTcFzhALFJjLSv3wMyhlM/mH3Qnsg+VRrSiOk9Y82RvCyzDCsYlQotRmIgKD
         Ddgt6J13ic33BCajPYxyU6Q+cwlIS4qUt9JdVGCzJ0a6Rtf0UyTItqFTnlcqMTo975Zf
         2CnGgEH350HiI17LNlzh5hkbcNfp0MHaxjVYKGOUaGuyUTTbFHFberFKA/m6WkLlvyBY
         tgG0EcWXa9inIegrQA8W+ERiJYqacqO/ieNrvUSvdRcg23glZlNT1QUVEvimxABbs/Fk
         x+K0GkitEsvntV44HuyAlJCysV8GZrvmCVp/Tff8HgvMwM3U4EVH3jU/SEF0/jaqhHlt
         znPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P+zJzPA5j2fSPXiFPqe/ELh6l+2nGcRmsM+yat0BzBM=;
        b=lZr4xbo1OHYMPAb0pdatgJPTaiatzjRmFWlzM8r0ara2OO9GbW5qfCzW+mQOWeh7Rw
         4/LXFercIa6x5UKD6oE832ievXpktwP5NuI+Y1kNURjG5QFwj1xH3MN2re0Un7gKKv0h
         HQezkr5yNpUFvQ8dslD96CgZLgUgxAeLei0PbE067LuZf2+g80YTH2LV42kHIbaLARHh
         qnwYMYv5eaqL5XPPqyls/ZbkMFfcmPN88QelKfqjFwHyi8CG2awmgDS7eocCZuTzWpKC
         vW6ffK0XPq3FEgI4irhPiYiBRQyvOWXlO8bkCFg/2pSF3W94bdC6FPPnobQtx6neT8or
         B5ag==
X-Gm-Message-State: ANoB5plLiySsIJRYcaM7moG1h4tlZDZui6yckl7GI8gSAkerRHYmd0RM
        mLL4DWkMvy6iL762nnJW1AZKxnUUHvCChR9gnVM=
X-Google-Smtp-Source: AA0mqf5DaswT/ZwWOpfxsGHbnMU0DuoB4lCMRBnfFlXmMS1yLONJdW/lsJwS6zoGOrO/5OOy9ki42A==
X-Received: by 2002:a05:6602:2143:b0:6bc:6352:9853 with SMTP id y3-20020a056602214300b006bc63529853mr38986910ioy.65.1670361302143;
        Tue, 06 Dec 2022 13:15:02 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id z17-20020a056602081100b006ddd15ca0absm2604999iow.25.2022.12.06.13.15.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Dec 2022 13:15:01 -0800 (PST)
Message-ID: <5a643da7-1c28-b680-391e-ea8392210327@kernel.dk>
Date:   Tue, 6 Dec 2022 14:15:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] io_uring: Fix a null-ptr-deref in io_tctx_exit_cb()
Content-Language: en-US
To:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc:     harshit.m.mogalapalli@gmail.com, vegard.nossum@oracle.com,
        george.kennedy@oracle.com, darren.kenny@oracle.com,
        syzkaller <syzkaller@googlegroups.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221206093833.3812138-1-harshit.m.mogalapalli@oracle.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20221206093833.3812138-1-harshit.m.mogalapalli@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/6/22 2:38?AM, Harshit Mogalapalli wrote:
> Syzkaller reports a NULL deref bug as follows:
> 
>  BUG: KASAN: null-ptr-deref in io_tctx_exit_cb+0x53/0xd3
>  Read of size 4 at addr 0000000000000138 by task file1/1955
> 
>  CPU: 1 PID: 1955 Comm: file1 Not tainted 6.1.0-rc7-00103-gef4d3ea40565 #75
>  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.0-2.el7 04/01/2014
>  Call Trace:
>   <TASK>
>   dump_stack_lvl+0xcd/0x134
>   ? io_tctx_exit_cb+0x53/0xd3
>   kasan_report+0xbb/0x1f0
>   ? io_tctx_exit_cb+0x53/0xd3
>   kasan_check_range+0x140/0x190
>   io_tctx_exit_cb+0x53/0xd3
>   task_work_run+0x164/0x250
>   ? task_work_cancel+0x30/0x30
>   get_signal+0x1c3/0x2440
>   ? lock_downgrade+0x6e0/0x6e0
>   ? lock_downgrade+0x6e0/0x6e0
>   ? exit_signals+0x8b0/0x8b0
>   ? do_raw_read_unlock+0x3b/0x70
>   ? do_raw_spin_unlock+0x50/0x230
>   arch_do_signal_or_restart+0x82/0x2470
>   ? kmem_cache_free+0x260/0x4b0
>   ? putname+0xfe/0x140
>   ? get_sigframe_size+0x10/0x10
>   ? do_execveat_common.isra.0+0x226/0x710
>   ? lockdep_hardirqs_on+0x79/0x100
>   ? putname+0xfe/0x140
>   ? do_execveat_common.isra.0+0x238/0x710
>   exit_to_user_mode_prepare+0x15f/0x250
>   syscall_exit_to_user_mode+0x19/0x50
>   do_syscall_64+0x42/0xb0
>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
>  RIP: 0023:0x0
>  Code: Unable to access opcode bytes at 0xffffffffffffffd6.
>  RSP: 002b:00000000fffb7790 EFLAGS: 00000200 ORIG_RAX: 000000000000000b
>  RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
>  RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
>  RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
>  R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
>  R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>   </TASK>
>  Kernel panic - not syncing: panic_on_warn set ...
> 
> Add a NULL check on tctx to prevent this.

I agree with Vegard that I don't think this is fixing the core of
the issue. I think what is happening here is that we don't run the
task_work in io_uring_cancel_generic() unconditionally, if we don't
need to in the loop above. But we do need to ensure we run it before
we clear current->io_uring.

Do you have a reproducer? If so, can you try the below? I _think_
this is all we need. We can't be hitting the delayed fput path as
the task isn't exiting, and we're dealing with current here.


diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 36cb63e4174f..4791d94c88f5 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3125,6 +3125,15 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
 
 	io_uring_clean_tctx(tctx);
 	if (cancel_all) {
+		/*
+		 * If we didn't run task_work in the loop above, ensure we
+		 * do so here. If an fput() queued up exit task_work for the
+		 * ring descriptor before we started the exec that led to this
+		 * cancelation, then we need to have that run before we proceed
+		 * with tearing down current->io_uring.
+		 */
+		io_run_task_work();
+
 		/*
 		 * We shouldn't run task_works after cancel, so just leave
 		 * ->in_idle set for normal exit.

-- 
Jens Axboe
