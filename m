Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45403344DCF
	for <lists+io-uring@lfdr.de>; Mon, 22 Mar 2021 18:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbhCVRx2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Mar 2021 13:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbhCVRw6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Mar 2021 13:52:58 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4838FC061574
        for <io-uring@vger.kernel.org>; Mon, 22 Mar 2021 10:52:58 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id k8so14858671iop.12
        for <io-uring@vger.kernel.org>; Mon, 22 Mar 2021 10:52:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=yr3uVFpZsGP6y6mCVcoKrKpf10uPPAPG825Fgeh8r3M=;
        b=sgKE9GEIJZZ8J8QaRVTodmXYIWRVuQ7c5PYk03WbVi3HpRV1tyjW4HSY3p8sNtwf2v
         rHboBLPCle9Yhf2h6BQSjMtFcjUW531sF4rjNYd/fRkdpVbhKXH8tFFPqJCHkIYipK3C
         qLRjWCCvtaZvPZreR/B9C14oRDnUsi3zibwsctPJadUnzNjbr31e/z9i6hergb6CTtCr
         BwY8XWGiy/RUofXKqHFycNt51aiAjLbtIRpM0mtkfZ2bulM/HU/NHxVxL25vcDVPwJOj
         eqzywJn2p28t/pabUStCi6Tf50EidR4paPCDChPDohCBQFBDHjPdxs4MYWP/7cQxRL9k
         5yLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yr3uVFpZsGP6y6mCVcoKrKpf10uPPAPG825Fgeh8r3M=;
        b=CyVEliVyA4tZgLoQqzy+AR5zZMQs/aXlasM3cT1vumnQyXU+4aVp19NXqiLpvQkng0
         Qq6Lo7LiJsoasiEAzDpY74tz/6/bi+TQwaZ4FsbenIXUAxh/MQ4FEG8aPy/5a5RG0TCJ
         Z2Z8D63FGiPYPrE8iqwQwkl/odwTcwUHCHt/41i6J4KNrQab0ztoQWBzBJORL270zg0S
         TdhLeTJ5eO6yfrRTVzR8OVUG8BAI+ZshqgENCmP6LKhK7j6+X3pAS3rW+pjOV8wF5N0X
         V6GWWCYeizrin+MktII9zSdT+ZGurTW2VltorIjeGEJxAL77a8+CDF2OtmAV/tSqHixJ
         yBRA==
X-Gm-Message-State: AOAM531Jt3AyXEMuhfwOG1t2zaQ1ubFSfRSRIJO3qLiDkpdq4Q4Rr1Zt
        RC310Dl89vIPvfohecIVubmf8XXII/pWzA==
X-Google-Smtp-Source: ABdhPJwsTkV+g0gwgComJirE6WV2njA/M8hf5Mp0aimHbzi26uO6yPYNVuMbdGZVLs7aprDGRXwLOQ==
X-Received: by 2002:a05:6638:1648:: with SMTP id a8mr503992jat.25.1616435577699;
        Mon, 22 Mar 2021 10:52:57 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id b19sm7908173ioj.50.2021.03.22.10.52.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Mar 2021 10:52:57 -0700 (PDT)
Subject: Re: [syzbot] WARNING in io_wq_destroy
To:     syzbot <syzbot+831debb250650baf4827@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <00000000000077ef5d05be23841a@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3f06cc8a-0538-c950-9db0-6cf177ebd87d@kernel.dk>
Date:   Mon, 22 Mar 2021 11:52:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <00000000000077ef5d05be23841a@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/22/21 11:37 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    0d02ec6b Linux 5.12-rc4
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1739e4aad00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=5adab0bdee099d7a
> dashboard link: https://syzkaller.appspot.com/bug?extid=831debb250650baf4827
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+831debb250650baf4827@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 15234 at fs/io-wq.c:1068 io_wq_destroy+0x1dd/0x240 fs/io-wq.c:1068
> Modules linked in:
> CPU: 1 PID: 15234 Comm: syz-executor.5 Not tainted 5.12.0-rc4-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:io_wq_destroy+0x1dd/0x240 fs/io-wq.c:1068
> Code: 48 c1 ea 03 80 3c 02 00 75 6e 49 8b 3c 24 e8 2a b3 d8 ff 4c 89 e7 5b 5d 41 5c 41 5d 41 5e 41 5f e9 18 b3 d8 ff e8 73 b1 95 ff <0f> 0b e9 02 ff ff ff e8 67 b1 95 ff 48 89 ef e8 ff b2 d8 ff eb ae
> RSP: 0018:ffffc90016cb7950 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: ffff88801362d4c0 RSI: ffffffff81de3cbd RDI: ffff888022177840
> RBP: ffff888022177800 R08: 000000000000003f R09: ffff8880254cb80f
> R10: ffffffff81de3b50 R11: 0000000000000000 R12: ffff8880254cb800
> R13: dffffc0000000000 R14: ffffed1004a99700 R15: 0000000000000040
> FS:  00007f51c4a75700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b32424000 CR3: 000000002a3f7000 CR4: 00000000001506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  io_wq_put fs/io-wq.c:1079 [inline]
>  io_wq_put_and_exit+0x8d/0xc0 fs/io-wq.c:1086
>  io_uring_clean_tctx+0xed/0x160 fs/io_uring.c:8890
>  __io_uring_files_cancel+0x503/0x5f0 fs/io_uring.c:8955
>  io_uring_files_cancel include/linux/io_uring.h:22 [inline]
>  do_exit+0x299/0x2a60 kernel/exit.c:780
>  do_group_exit+0x125/0x310 kernel/exit.c:922
>  get_signal+0x42c/0x2100 kernel/signal.c:2777
>  arch_do_signal_or_restart+0x2a8/0x1eb0 arch/x86/kernel/signal.c:789
>  handle_signal_work kernel/entry/common.c:147 [inline]
>  exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
>  exit_to_user_mode_prepare+0x148/0x250 kernel/entry/common.c:208
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
>  syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:301
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x466459
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f51c4a75188 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
> RAX: 0000000000000100 RBX: 000000000056bf60 RCX: 0000000000466459
> RDX: 0000000000000000 RSI: 0000000000002039 RDI: 0000000000000003
> RBP: 00000000004bf9fb R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf60
> R13: 0000000000a9fb1f R14: 00007f51c4a75300 R15: 0000000000022000

Still looking into this one, so far no luck in reproducing. But this
report is a dupe/identical of the previous one, so let's not track
both:

#syz dup: [syzbot] WARNING in io_wq_put

-- 
Jens Axboe

