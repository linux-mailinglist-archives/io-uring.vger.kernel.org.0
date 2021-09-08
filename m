Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE6854035F4
	for <lists+io-uring@lfdr.de>; Wed,  8 Sep 2021 10:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348030AbhIHIUG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 04:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242762AbhIHIUD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Sep 2021 04:20:03 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6143BC061575;
        Wed,  8 Sep 2021 01:18:55 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id n7-20020a05600c3b8700b002f8ca941d89so842973wms.2;
        Wed, 08 Sep 2021 01:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tx8/2FQ2TGii0Ml7ZBJ0SGzNLbXuL25VCMbDKani9Jc=;
        b=YN6gFiRfE+xG9fQmO9fTZmADBxprBoA4UR9Ks7nlVpj5YkGRK/IFa0v+E0lbtmY8pd
         awb3NEE/yNbycUuismvITIDco3rpSYCt9XbHAFPQsuxGhOPI/g6KoGB3iC9Mqxtf1IBB
         hBpAE+jpTx4T78j3xYylykWQdmz6RTjSexutj7hd6Y/JhtaKB9brIDqfjxaH/AxWGUs8
         jtgzRzkhq/k0tWwVH9y36oH7SgjM2U+fZHoPpLF1m+iQOeUnJ8S1Lwg/DOHEkq5H5vgN
         fIV8fI70XhW/nFZ0vcrwF/hQfMHKyalV3pY4318SEFObKzlizp0WZpajwZsxZ7WqeD2a
         5chg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tx8/2FQ2TGii0Ml7ZBJ0SGzNLbXuL25VCMbDKani9Jc=;
        b=pQzESvhObLjUvSEmc3TiUC6JZCLlXG66SUQCs5GlLw9ro1vAZS8Cq0fCF2uvSWSv+8
         RKun4deStKj2ZjipyEan4KhvJq/W10eTCQusFe0N2ys/5HY82/E73SXfvVJxACD1/FiV
         A1wB1g62aV7xYwhEnfrz7ccN9JVrCRnIhrOCreQiQCzqiefCNG4fYG3eYYNm66HXCp3U
         nXugj4/nli+M7mErJHdGk5Ed10odDSLpkTDawdV+Ukk6KyYraWYTcUnSrCBomvn9XTtm
         c+7CQ7+FYNOyQHFBkWz/eTlw2MmSs1D06i+Vos4wHrA1HytWiAZvrrFQbbpfflMx5uvZ
         FkXA==
X-Gm-Message-State: AOAM531XHP/0ga9KSrIe5QjSyH/zzZJG8hUEpQCWBZ/O5qn+45w0Wjg2
        sYToJPK76w5Qpq/wYPM4buEp3lhNOqI=
X-Google-Smtp-Source: ABdhPJyPYCCDlJUUNNeVU2r59+j7prxHT2c1i2Co46qfpeMe1h274WeDz3BSrbCJKt1SsyChXV6o1w==
X-Received: by 2002:a7b:c18c:: with SMTP id y12mr2215860wmi.3.1631089133673;
        Wed, 08 Sep 2021 01:18:53 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.144.232])
        by smtp.gmail.com with ESMTPSA id a203sm226452wmd.42.2021.09.08.01.18.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 01:18:53 -0700 (PDT)
Subject: Re: WARNING in io_wq_submit_work
To:     Hao Sun <sunhao.th@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.co>,
        io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <CACkBjsa=DmomBxEub98ihEu0T37ryz+_4EQgGF1dURtTvdLEtQ@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <83d5642c-9444-ce94-37e7-4fd26434054d@gmail.com>
Date:   Wed, 8 Sep 2021 09:18:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CACkBjsa=DmomBxEub98ihEu0T37ryz+_4EQgGF1dURtTvdLEtQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/8/21 7:46 AM, Hao Sun wrote:
> Hello,
> 
> When using Healer to fuzz the latest Linux kernel, the following crash
> was triggered.
> 
> HEAD commit: 4b93c544e90e-thunderbolt: test: split up test cases
> git tree: upstream
> console output:
> https://drive.google.com/file/d/1RZfBThifWgo2CiwPTeNzYG4P0gkZlINT/view?usp=sharing
> kernel config: https://drive.google.com/file/d/1c0u2EeRDhRO-ZCxr9MP2VvAtJd6kfg-p/view?usp=sharing
> C reproducer: https://drive.google.com/file/d/18LXBclar1FlOngPkayjq8k-vKcw-SR98/view?usp=sharing
> Syzlang reproducer:
> https://drive.google.com/file/d/1rUgX8kHPhxiYHIbuhZnDZknDe1DzDmhd/view?usp=sharing
> Similar report:
> https://groups.google.com/u/1/g/syzkaller-bugs/c/siEpifWtNAw/m/IkUK1DmOCgAJ
>
> If you fix this issue, please add the following tag to the commit:
> Reported-by: Hao Sun <sunhao.th@gmail.com>

Thanks for the reports! I think I see what happens in
the two with warnings. We'll dig into others as well.

> 
> FAULT_INJECTION: forcing a failure.
> name failslab, interval 1, probability 0, space 0, times 0
> CPU: 2 PID: 11607 Comm: syz-executor Not tainted 5.14.0+ #1
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> 1.13.0-1ubuntu1.1 04/01/2014
> Call Trace:
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
>  fail_dump lib/fault-inject.c:52 [inline]
>  should_fail.cold+0x5/0xa lib/fault-inject.c:146
>  should_failslab+0x5/0x10 mm/slab_common.c:1326
>  slab_pre_alloc_hook mm/slab.h:494 [inline]
>  slab_alloc_node mm/slub.c:2880 [inline]
>  kmem_cache_alloc_node+0x67/0x380 mm/slub.c:2995
>  alloc_task_struct_node kernel/fork.c:171 [inline]
>  dup_task_struct kernel/fork.c:883 [inline]
>  copy_process+0x5df/0x73d0 kernel/fork.c:2027
>  create_io_thread+0xb6/0xf0 kernel/fork.c:2533
>  create_io_worker+0x25a/0x540 fs/io-wq.c:758
>  io_wqe_create_worker fs/io-wq.c:267 [inline]
>  io_wqe_enqueue+0x68c/0xba0 fs/io-wq.c:866
>  io_queue_async_work+0x28b/0x5d0 fs/io_uring.c:1473
>  __io_queue_sqe+0x6c3/0xc70 fs/io_uring.c:6933
>  io_queue_sqe fs/io_uring.c:6951 [inline]
>  io_submit_state_end fs/io_uring.c:7141 [inline]
>  io_submit_sqes+0x1da4/0x9c00 fs/io_uring.c:7245
>  __do_sys_io_uring_enter fs/io_uring.c:9875 [inline]
>  __se_sys_io_uring_enter fs/io_uring.c:9817 [inline]
>  __x64_sys_io_uring_enter+0x7a9/0xe80 fs/io_uring.c:9817
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x4739cd
> Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
> 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
> 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007eff5bd9dc58 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
> RAX: ffffffffffffffda RBX: 000000000059c0a0 RCX: 00000000004739cd
> RDX: 0000000000000000 RSI: 000000000000450c RDI: 0000000000000003
> RBP: 00007eff5bd9dc90 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000002
> R13: 00007ffc1b637edf R14: 00007ffc1b638080 R15: 00007eff5bd9ddc0
> ------------[ cut here ]------------
> WARNING: CPU: 2 PID: 11607 at fs/io_uring.c:1164 req_ref_get
> fs/io_uring.c:1164 [inline]
> WARNING: CPU: 2 PID: 11607 at fs/io_uring.c:1164
> io_wq_submit_work+0x2b4/0x310 fs/io_uring.c:6731
> Modules linked in:
> CPU: 2 PID: 11607 Comm: syz-executor Not tainted 5.14.0+ #1
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> 1.13.0-1ubuntu1.1 04/01/2014
> RIP: 0010:req_ref_get fs/io_uring.c:1164 [inline]
> RIP: 0010:io_wq_submit_work+0x2b4/0x310 fs/io_uring.c:6731
> Code: 49 89 c5 0f 84 5b fe ff ff e8 b8 14 91 ff 4c 89 ef e8 80 f3 ff
> ff e9 49 fe ff ff e8 a6 14 91 ff e9 85 fe ff ff e8 9c 14 91 ff <0f> 0b
> eb a7 4c 89 f7 e8 f0 93 d8 ff e9 79 fd ff ff 4c 89 ef e8 53
> RSP: 0018:ffffc90009e4f868 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 000000000000007f RCX: ffff8881025b8000
> RDX: 0000000000000000 RSI: ffff8881025b8000 RDI: 0000000000000002
> RBP: ffff888025a43238 R08: ffffffff81e50ba4 R09: 000000000000007f
> R10: 0000000000000005 R11: ffffed1004b4863b R12: ffff888025a43180
> R13: ffff888025a431dc R14: ffff888025a431d8 R15: 0000000000100000
> FS:  00007eff5bd9e700(0000) GS:ffff888063f00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000000330ac48 CR3: 000000002ef85000 CR4: 0000000000350ee0
> Call Trace:
>  io_run_cancel fs/io-wq.c:809 [inline]
>  io_acct_cancel_pending_work.isra.0+0x2c0/0x640 fs/io-wq.c:950
>  io_wqe_cancel_pending_work+0x6c/0x130 fs/io-wq.c:968
>  io_wq_destroy fs/io-wq.c:1185 [inline]
>  io_wq_put_and_exit+0x78c/0xc10 fs/io-wq.c:1198
>  io_uring_clean_tctx fs/io_uring.c:9607 [inline]
>  io_uring_cancel_generic+0x5fe/0x740 fs/io_uring.c:9687
>  io_uring_files_cancel include/linux/io_uring.h:16 [inline]
>  do_exit+0x25c/0x2dd0 kernel/exit.c:780
>  do_group_exit+0x125/0x340 kernel/exit.c:922
>  get_signal+0x4d5/0x25a0 kernel/signal.c:2868
>  arch_do_signal_or_restart+0x2ed/0x1c40 arch/x86/kernel/signal.c:865
>  handle_signal_work kernel/entry/common.c:148 [inline]
>  exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
>  exit_to_user_mode_prepare+0x192/0x2a0 kernel/entry/common.c:209
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
>  syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
>  do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x4739cd
> Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
> 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
> 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007eff5bd9dcd8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
> RAX: fffffffffffffe00 RBX: 000000000059c0a0 RCX: 00000000004739cd
> RDX: 0000000000000000 RSI: 0000000000000080 RDI: 000000000059c0a8
> RBP: 000000000059c0a8 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000059c0ac
> R13: 00007ffc1b637edf R14: 00007ffc1b638080 R15: 00007eff5bd9ddc0%
> 

-- 
Pavel Begunkov
