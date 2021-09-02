Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 359813FF367
	for <lists+io-uring@lfdr.de>; Thu,  2 Sep 2021 20:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347088AbhIBSr6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Sep 2021 14:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347066AbhIBSr6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Sep 2021 14:47:58 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8542C061575
        for <io-uring@vger.kernel.org>; Thu,  2 Sep 2021 11:46:59 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id q3so3773713iot.3
        for <io-uring@vger.kernel.org>; Thu, 02 Sep 2021 11:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=TEMn00oSA5VYih8Aj6llExK+pHCELiSyvXRfGxuQgtg=;
        b=M0t8YfCc3DPykzulolmKugxNkSSE+yp6TNd0DwVndokt+ji1gH39MApX7kWigVy2a7
         mLFTGmhcmgF1hUVycCVaDtjrslWVw0jknkajoU0GCZDftQ35fhjZJtNxbPEEH9rtsrna
         30101gIMxT2LpN1dtJG+lhj06nh8nlXay+SvDQoKH4xuTKcCkKp34ZGjHapbW35knXr6
         il4x35GDHoRoESAzDbRbGZ9dpRDCBjErR9NIYC+3o+4wWBg8DF4wmHT+xx4KWPcp9fOg
         63JVpuz5BjMyq7kUSSA80Yh6WOQwy4bs8ueVAVuS+FfN2SiH+76IxnoD7OItvGo9Hj6X
         5JqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TEMn00oSA5VYih8Aj6llExK+pHCELiSyvXRfGxuQgtg=;
        b=NscL2FnubwQviB0MNsPOFTRFwf3M0ar/lyBTJwd/MFfpcCPeVRx4DukD6/WH3GDmmt
         79+pyVJjcmSZKKCfvYTEiKtT1IpwD8qYjMuvTRMVwGz9COBMvTdjczC0VRkAGa1NSR88
         wnC98MM6S0ydQcMIMRENjRlEIzW8/CPv6xI7iRBtuTyGjBT7yBHWuD4czToDEv27byzg
         xzNJoo+qsMHWmO6zSKITrf5a2tG7EtPZMJJihx/9OHAPC5ZKegQy+Gl6lZvzPVHfKWy3
         KVppsuO2DRcsftPrn34vDnHB7JZTNVOvBhKFAV9DhXIB3JzXRIvoliGmBn7jTCHLwTzB
         Nd7w==
X-Gm-Message-State: AOAM533r1uu3MMDg34+aCV1ARRX1AIutVSFfPkvRNXWNfkIOcCMwNSdy
        N4SsxvEOmcdnW9IykPQrDTISdQ==
X-Google-Smtp-Source: ABdhPJwEENDZCzMS2wo7XGLnmumoKKIphww7ANHv2U9Uph2cWXlYSFQYSMTNKjzxaRbID+o2vAaamA==
X-Received: by 2002:a05:6638:38aa:: with SMTP id b42mr4110120jav.6.1630608418936;
        Thu, 02 Sep 2021 11:46:58 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id b18sm1381194iln.8.2021.09.02.11.46.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Sep 2021 11:46:58 -0700 (PDT)
Subject: Re: [syzbot] general protection fault in io_issue_sqe
To:     syzbot <syzbot+de67aa0cf1053e405871@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, haoxu@linux.alibaba.com,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <0000000000001ae8cc05cb075852@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3d956ccb-8f2d-e3aa-eee3-254185314915@kernel.dk>
Date:   Thu, 2 Sep 2021 12:46:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0000000000001ae8cc05cb075852@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/2/21 12:28 PM, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> general protection fault in io_ring_ctx_wait_and_kill
> 
> general protection fault, probably for non-canonical address 0xdffffc0000000016: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x00000000000000b0-0x00000000000000b7]
> CPU: 0 PID: 10163 Comm: syz-executor.2 Not tainted 5.14.0-rc7-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:io_ring_ctx_wait_and_kill+0x24d/0x450 fs/io_uring.c:9180
> Code: ff 48 89 df e8 c4 fb ff ff e8 6f a8 94 ff 48 8b 04 24 48 8d b8 b0 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 d3 01 00 00 48 8b 04 24 48 8b a8 b0 00 00 00 48
> RSP: 0018:ffffc9000a8b7a60 EFLAGS: 00010202
> RAX: dffffc0000000000 RBX: ffff888046aa6000 RCX: 0000000000000000
> RDX: 0000000000000016 RSI: ffffffff81e10061 RDI: 00000000000000b0
> RBP: 0000000000000000 R08: 0000000000000000 R09: ffff888046aa6643
> R10: ffffffff81e1004b R11: 0000000000000000 R12: ffff888046aa63f8
> R13: ffffc9000a8b7a90 R14: ffff8881453f4000 R15: ffff888046aa6040
> FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000561b3ede9400 CR3: 000000000b68e000 CR4: 00000000001506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  io_uring_release+0x3e/0x50 fs/io_uring.c:9198
>  __fput+0x288/0x920 fs/file_table.c:280
>  task_work_run+0xdd/0x1a0 kernel/task_work.c:164
>  exit_task_work include/linux/task_work.h:32 [inline]
>  do_exit+0xbae/0x2a30 kernel/exit.c:825
>  do_group_exit+0x125/0x310 kernel/exit.c:922
>  get_signal+0x47f/0x2160 kernel/signal.c:2808
>  arch_do_signal_or_restart+0x2a9/0x1c40 arch/x86/kernel/signal.c:865
>  handle_signal_work kernel/entry/common.c:148 [inline]
>  exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
>  exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:209
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
>  syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
>  do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x4665f9
> Code: Unable to access opcode bytes at RIP 0x4665cf.
> RSP: 002b:00007faa595bc218 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
> RAX: fffffffffffffe00 RBX: 000000000056c040 RCX: 00000000004665f9
> RDX: 0000000000000000 RSI: 0000000000000080 RDI: 000000000056c040
> RBP: 000000000056c038 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056c044
> R13: 00007fff98399dff R14: 00007faa595bc300 R15: 0000000000022000
> Modules linked in:
> ---[ end trace 641488e48828d1de ]---
> RIP: 0010:io_ring_ctx_wait_and_kill+0x24d/0x450 fs/io_uring.c:9180
> Code: ff 48 89 df e8 c4 fb ff ff e8 6f a8 94 ff 48 8b 04 24 48 8d b8 b0 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 d3 01 00 00 48 8b 04 24 48 8b a8 b0 00 00 00 48
> RSP: 0018:ffffc9000a8b7a60 EFLAGS: 00010202
> RAX: dffffc0000000000 RBX: ffff888046aa6000 RCX: 0000000000000000
> RDX: 0000000000000016 RSI: ffffffff81e10061 RDI: 00000000000000b0
> RBP: 0000000000000000 R08: 0000000000000000 R09: ffff888046aa6643
> R10: ffffffff81e1004b R11: 0000000000000000 R12: ffff888046aa63f8
> R13: ffffc9000a8b7a90 R14: ffff8881453f4000 R15: ffff888046aa6040
> FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000561b3ede9400 CR3: 000000003cbf0000 CR4: 00000000001506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> ----------------
> Code disassembly (best guess), 1 bytes skipped:
>    0:	48 89 df             	mov    %rbx,%rdi
>    3:	e8 c4 fb ff ff       	callq  0xfffffbcc
>    8:	e8 6f a8 94 ff       	callq  0xff94a87c
>    d:	48 8b 04 24          	mov    (%rsp),%rax
>   11:	48 8d b8 b0 00 00 00 	lea    0xb0(%rax),%rdi
>   18:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
>   1f:	fc ff df
>   22:	48 89 fa             	mov    %rdi,%rdx
>   25:	48 c1 ea 03          	shr    $0x3,%rdx
> * 29:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1) <-- trapping instruction
>   2d:	0f 85 d3 01 00 00    	jne    0x206
>   33:	48 8b 04 24          	mov    (%rsp),%rax
>   37:	48 8b a8 b0 00 00 00 	mov    0xb0(%rax),%rbp
>   3e:	48                   	rex.W

That's unrelated, but probably my fault. Let's rerun:

#syz test git://git.kernel.dk/linux-block for-5.15/io_uring

-- 
Jens Axboe

