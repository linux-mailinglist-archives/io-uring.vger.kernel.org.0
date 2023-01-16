Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9E1266CE64
	for <lists+io-uring@lfdr.de>; Mon, 16 Jan 2023 19:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232419AbjAPSJv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Jan 2023 13:09:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232403AbjAPSJb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Jan 2023 13:09:31 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE1503E629
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 09:54:22 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id v6so4750352ilq.3
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 09:54:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JPvljqvM2UcSP9Cl25a35r4uBDsPl3z3yfdTzXuhKNM=;
        b=rlz7btLcACEU80xL0e/C59u2bKVTZryWa5AQ20uRanoDuGuKQdfkqzAHQRF9yLcuV7
         XuMHUAppqoVc3mM3cqpGnzYcjpKcFAdxqCBTLEdl8DTygEjEwLtrrh2sAhLM9vX2OXM9
         LC2O5rEbSk73khV3qGnoh4VL131c+/1ZxEpca+YbzrF9q2a3Zoh8OADbvkOKNlJ23w2p
         4TV3WFm0N04bSPJST584/12NhGsjWtL1IL70zpPU+vR+tHZNo0Xx19ZIlsXVBjQjkQsP
         KxIjujm144pK0Fr8SY+K4s7sbL9twCtnouax72sKga7TAY1xmygNY6PpHvoLotQLbz8p
         v/dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JPvljqvM2UcSP9Cl25a35r4uBDsPl3z3yfdTzXuhKNM=;
        b=VOWwrIYPQy6o8UdlpRG1DNH8zRWSc7LswiY+pfGOTSS7h+rrryCHWdipTPLRCyQDY7
         e3drKd5fui492NYtd8m6E4emSsM23szEB0egct35CFvJi1WcDsnXU+y6ANbOBcWjO5Wq
         Vrj4+y1jGVcC/6W/27r6BqBO86/i9VR/mLR8hwtLNSa56hZ4tt7jWWJXlWWNEAA+R0hP
         OnnsY6ZGH2oxQlPigB2p7JQ/GETpcQ0byGBFfwPE0rAqT9HrWOISbKwAQWSg8pSptvpE
         REoIjPAdiiGPgrrwdEBMjcAXT81hFWCVue987sdX2RnQ7NUKhbt+L5KX0FeWUNsjl5rE
         Qpfg==
X-Gm-Message-State: AFqh2kpHizZ5rjMaTz4jGnRdTbraMIgiNP3ztbDdu3EgHa/rwLiaAzXu
        pdl3W+Jb2LHjYwLHw+qIux5oU/F7Zl8uSFO9v6U17g==
X-Google-Smtp-Source: AMrXdXsLqods1YxC3Cdh8Nt6GJ+RJ9rixb59lYOUT7kPVWwVsWv9Dlkp5l/zGgwJk2awF24rofhYJ/6fvFpzd62JM6U=
X-Received: by 2002:a05:6e02:5c3:b0:30c:33da:cb53 with SMTP id
 l3-20020a056e0205c300b0030c33dacb53mr27850ils.173.1673891647618; Mon, 16 Jan
 2023 09:54:07 -0800 (PST)
MIME-Version: 1.0
References: <000000000000e259c105f25c92da@google.com>
In-Reply-To: <000000000000e259c105f25c92da@google.com>
From:   Jann Horn <jannh@google.com>
Date:   Mon, 16 Jan 2023 18:53:31 +0100
Message-ID: <CAG48ez23_TUMENLmi5X4F61vb6ZNiL+mfz6YE96U4Y7bgvYnSg@mail.gmail.com>
Subject: Re: [syzbot] WARNING: refcount bug in mm_update_next_owner
To:     syzbot <syzbot+1d4c86ac0fed92e3fc78@syzkaller.appspotmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Cc:     akpm@linux-foundation.org, arnd@arndb.de, brauner@kernel.org,
        ebiederm@xmission.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

All 5 console logs listed on the syzkaller dashboard for this one have
io-uring with IORING_OP_POLL_ADD somewhere. Could that be related?

On Mon, Jan 16, 2023 at 8:31 AM syzbot
<syzbot+1d4c86ac0fed92e3fc78@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    0a093b2893c7 Add linux-next specific files for 20230112
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=16a8e102480000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=835f3591019836d5
> dashboard link: https://syzkaller.appspot.com/bug?extid=1d4c86ac0fed92e3fc78
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/8111a570d6cb/disk-0a093b28.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/ecc135b7fc9a/vmlinux-0a093b28.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/ca8d73b446ea/bzImage-0a093b28.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+1d4c86ac0fed92e3fc78@syzkaller.appspotmail.com
>
> ------------[ cut here ]------------
> refcount_t: addition on 0; use-after-free.
> WARNING: CPU: 0 PID: 5316 at lib/refcount.c:25 refcount_warn_saturate+0x17c/0x1f0 lib/refcount.c:25
> Modules linked in:
> CPU: 0 PID: 5316 Comm: syz-executor.4 Not tainted 6.2.0-rc3-next-20230112-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> RIP: 0010:refcount_warn_saturate+0x17c/0x1f0 lib/refcount.c:25
> Code: 0a 31 ff 89 de e8 d4 13 78 fd 84 db 0f 85 2e ff ff ff e8 57 17 78 fd 48 c7 c7 60 87 a6 8a c6 05 e0 ce 54 0a 01 e8 98 a7 b2 05 <0f> 0b e9 0f ff ff ff e8 38 17 78 fd 0f b6 1d ca ce 54 0a 31 ff 89
> RSP: 0018:ffffc90005967d80 EFLAGS: 00010286
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: ffff8880829f3a80 RSI: ffffffff8166972c RDI: fffff52000b2cfa2
> RBP: ffff888082ae3aa8 R08: 0000000000000005 R09: 0000000000000000
> R10: 0000000000000001 R11: 0000000000000000 R12: ffff88807e520900
> R13: ffff888082ae3fa8 R14: 0000000000000000 R15: ffff888082ae3aa8
> FS:  0000000000000000(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b32f23000 CR3: 000000007716c000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  __refcount_add include/linux/refcount.h:199 [inline]
>  __refcount_inc include/linux/refcount.h:250 [inline]
>  refcount_inc include/linux/refcount.h:267 [inline]
>  get_task_struct include/linux/sched/task.h:110 [inline]
>  mm_update_next_owner+0x585/0x7b0 kernel/exit.c:504
>  exit_mm kernel/exit.c:562 [inline]
>  do_exit+0x9a4/0x2a90 kernel/exit.c:854
>  do_group_exit+0xd4/0x2a0 kernel/exit.c:1012
>  __do_sys_exit_group kernel/exit.c:1023 [inline]
>  __se_sys_exit_group kernel/exit.c:1021 [inline]
>  __x64_sys_exit_group+0x3e/0x50 kernel/exit.c:1021
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7f51f5a8c0c9
> Code: Unable to access opcode bytes at 0x7f51f5a8c09f.
> RSP: 002b:00007ffe3c730ad8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> RAX: ffffffffffffffda RBX: 000000000000001e RCX: 00007f51f5a8c0c9
> RDX: 00007f51f5a3df7b RSI: ffffffffffffffb8 RDI: 0000000000000000
> RBP: 0000000000000000 R08: 000000002ed3101e R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
> R13: 0000000000000000 R14: 0000000000000001 R15: 00007ffe3c730bc0
>  </TASK>
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
