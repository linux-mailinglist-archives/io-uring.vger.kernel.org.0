Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5756EC73C
	for <lists+io-uring@lfdr.de>; Mon, 24 Apr 2023 09:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbjDXHhl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Apr 2023 03:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbjDXHhk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Apr 2023 03:37:40 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB04DE5E
        for <io-uring@vger.kernel.org>; Mon, 24 Apr 2023 00:37:38 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id 2adb3069b0e04-4efea87c578so2131e87.1
        for <io-uring@vger.kernel.org>; Mon, 24 Apr 2023 00:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682321857; x=1684913857;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8vPDN1IVpdxIsn0EC3yloIXo6DGRLNTlpDHTNR3qIwE=;
        b=O+uUN6Nt/f5/IC46DSvy8JpHPyZScu1zJV+qIJlrDLmEOMJTOjYSyGMkE3c3TwaEma
         wRphiMjCvKV1Tj8HCmXWuRpElf/VxaRIWsulypBEFA9bqFfyWMvMke7/YcwT1BdYoM0U
         FXAIKjiV/LI5rwBjGueYRbWJFF8u6kLr+/B8NdmINHjSn49qQeJBsw8QOpXpQOMPqX1M
         TQ3xeGplBZ3VGZXa6L6zh7wAVl1IFeOzDGi0IZdvsIqzuwF+4ZdxLSNNSj23SzZpP118
         fKvPucpSglRlSWO4nZe4aHv7s3r9Rd+aH2/igEzAp9XcguDGFyiWbRjfp/lkonoROd5f
         IhLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682321857; x=1684913857;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8vPDN1IVpdxIsn0EC3yloIXo6DGRLNTlpDHTNR3qIwE=;
        b=Pbwk0tOESg+TjKyskskQQ2tv4ae5pCaDEN67SzlEmypxzFBI43uLogbeLs3WUIEuk6
         xIKVdLhy0eX0Icz2dP6NwtY2evjNttutQSVGHsR0M/dE8Tt8u+9pkd9eawXapJ/0qEfH
         VXUCyg7kdXK+WLLkzW/Jt7mjeXi6pijG7bQHC6NigEvb8fO6dQ/fXyPqxPis0ZJogFsh
         aFStdFIwTCIrRqm/ZirMYjPup2iY9ji/MOTT2s+AEy2tZVqifoiohWDVOL5WnceHOWcY
         /G0wjfWf6yjNlNaDH4y8BRm/v4+Oorc+KaV/4oRhgqG7o5zZ6jj/YlmKVehdGbVA9wOm
         zssw==
X-Gm-Message-State: AAQBX9eS0AbI8NNUIAA4UfMKPVwqHkgVMkQZl/BbWfOF6pwIavXDXC8r
        SMkILEUGHXaKANLrcS3I18sWekXjKbkYXFNUIXJmbA==
X-Google-Smtp-Source: AKy350b3s1yTa7+Lmwcx2UhoZh5NZ1X+UfVTd2wT5LZJZ6DKEuGma1DWJkWhS/FE0tmnAWcK7ep6o8WUpPuJl2gqEvI=
X-Received: by 2002:a05:6512:3e23:b0:4d0:e0ee:fc70 with SMTP id
 i35-20020a0565123e2300b004d0e0eefc70mr203824lfv.0.1682321856802; Mon, 24 Apr
 2023 00:37:36 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000d7848305fa0fd413@google.com>
In-Reply-To: <000000000000d7848305fa0fd413@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 24 Apr 2023 09:37:23 +0200
Message-ID: <CACT4Y+bVUkaoyp5OdzGLipof0b1+ec8xwqS+8cgvObuV0BUc5g@mail.gmail.com>
Subject: Re: [syzbot] [io-uring?] KCSAN: data-race in __io_fill_cqe_req / io_timeout
To:     syzbot <syzbot+cb265db2f3f3468ef436@syzkaller.appspotmail.com>
Cc:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, 24 Apr 2023 at 09:19, syzbot
<syzbot+cb265db2f3f3468ef436@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    3a93e40326c8 Merge tag 'for-linus' of git://git.kernel.org..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1280071ec80000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=f7350c77b8056a38
> dashboard link: https://syzkaller.appspot.com/bug?extid=cb265db2f3f3468ef436
> compiler:       Debian clang version 15.0.7, GNU ld (GNU Binutils for Debian) 2.35.2
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/2122926bc9fe/disk-3a93e403.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/8392992358bc/vmlinux-3a93e403.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/6398a2d19a7e/bzImage-3a93e403.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+cb265db2f3f3468ef436@syzkaller.appspotmail.com

I did not fully grasp what happens here, but it looks suspicious.
The comment in io_timeout() says that it computes "events that need to
occur for this timeout event to be satisfied". But if the range is
racing, it marks a random set of events?


> ==================================================================
> BUG: KCSAN: data-race in __io_fill_cqe_req / io_timeout
>
> read-write to 0xffff888108bf8310 of 4 bytes by task 20447 on cpu 0:
>  io_get_cqe_overflow io_uring/io_uring.h:112 [inline]
>  io_get_cqe io_uring/io_uring.h:124 [inline]
>  __io_fill_cqe_req+0x6c/0x4d0 io_uring/io_uring.h:137
>  io_fill_cqe_req io_uring/io_uring.h:165 [inline]
>  __io_req_complete_post+0x67/0x790 io_uring/io_uring.c:969
>  io_req_complete_post io_uring/io_uring.c:1006 [inline]
>  io_req_task_complete+0xb9/0x110 io_uring/io_uring.c:1654
>  handle_tw_list io_uring/io_uring.c:1184 [inline]
>  tctx_task_work+0x1fe/0x4d0 io_uring/io_uring.c:1246
>  task_work_run+0x123/0x160 kernel/task_work.c:179
>  get_signal+0xe5c/0xfe0 kernel/signal.c:2635
>  arch_do_signal_or_restart+0x89/0x2b0 arch/x86/kernel/signal.c:306
>  exit_to_user_mode_loop+0x6d/0xe0 kernel/entry/common.c:168
>  exit_to_user_mode_prepare+0x6a/0xa0 kernel/entry/common.c:204
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:286 [inline]
>  syscall_exit_to_user_mode+0x26/0x140 kernel/entry/common.c:297
>  do_syscall_64+0x4d/0xc0 arch/x86/entry/common.c:86
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>
> read to 0xffff888108bf8310 of 4 bytes by task 20448 on cpu 1:
>  io_timeout+0x88/0x270 io_uring/timeout.c:546
>  io_issue_sqe+0x147/0x660 io_uring/io_uring.c:1907
>  io_queue_sqe io_uring/io_uring.c:2079 [inline]
>  io_submit_sqe io_uring/io_uring.c:2340 [inline]
>  io_submit_sqes+0x689/0xfe0 io_uring/io_uring.c:2450
>  __do_sys_io_uring_enter io_uring/io_uring.c:3458 [inline]
>  __se_sys_io_uring_enter+0x1e5/0x1b70 io_uring/io_uring.c:3392
>  __x64_sys_io_uring_enter+0x78/0x90 io_uring/io_uring.c:3392
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>
> value changed: 0x00000c75 -> 0x00000c76
>
> Reported by Kernel Concurrency Sanitizer on:
> CPU: 1 PID: 20448 Comm: syz-executor.2 Not tainted 6.3.0-rc4-syzkaller-00025-g3a93e40326c8 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/02/2023
> ==================================================================
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/000000000000d7848305fa0fd413%40google.com.
