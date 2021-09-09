Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF91B404240
	for <lists+io-uring@lfdr.de>; Thu,  9 Sep 2021 02:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348383AbhIIAX6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 20:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348278AbhIIAX6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Sep 2021 20:23:58 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14B0C061575;
        Wed,  8 Sep 2021 17:22:49 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id v20-20020a1cf714000000b002e71f4d2026so94949wmh.1;
        Wed, 08 Sep 2021 17:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=3bmDHztmN1bRB4M7GynQYPShvTahsoeCAXxI3yMeopA=;
        b=WEi2pUtTuRJajbYr51bn/x+S21fhmlVXrZHo48MJE5tnNtlgJKr5JuEC6Twr1tubkQ
         ZFU4iCai2BpcHbo5hcYQykf/4rTz3/nmu3OmQZYJyxejeEojai+mUKY0PDoOIbTcfRjs
         I/Gd2U0XZ7sWyDOZ3TDS7RddCVwRQHp6eYF+KeLYh+zcqNmOVx++3IVcDzZW8rMRet50
         IRGm67rAXPMBcjNJC/POvjTEuCDgNKOcykH4iH4xXTCgIKovjiYz9PJPzy1517AqSbca
         gMzgJBNbSEHW6roG38M/AGqwpsZ7yLRRS7uWyrBTjJ6mmLvsD0cmcvS0A5z+9kz/BkmO
         9OvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3bmDHztmN1bRB4M7GynQYPShvTahsoeCAXxI3yMeopA=;
        b=76KZZELpuFkkGmwUb/ZAKe++HHqcCqoaSbDQ+IOc5IN8MONCznwaa0+72gNNLgXeTs
         ohAZgHgz/8EbccfcDN7w4WwnFidefRq1e7F1/AXQ/jx+2kD6jlrKRLYr5KwhLhELYHTY
         FtXIgVILtSUoGI+3BUjHudDbBs9q1wpMXpH9+7ql4y9BtBepDsnQtl39d66Rmh6Au5yj
         fggXNV2ZFWW/v4UEKl4yrBFWyjkRsZogXjUoYNKkGMkJhKycBEhJQT7FcPPnBpG9dA6I
         sE/n8PkCU+MfoWzZunVLDe2unu/xJcb6FOBbVVisiUyHEfYOWCsuQ8/OotAuyoWkb/Hu
         gMMA==
X-Gm-Message-State: AOAM5307Sh1xhl/6hoBrEzV9n3GVIgRMckfQwUDK7RpTrRiQm3oNYHGA
        s7/yRZZkv+u+Z1sk5pv586M=
X-Google-Smtp-Source: ABdhPJwCKDvm7y/uUAq4H3uB1yy8DmGUilbJLrmHeia9jx1A8Jf8ctgikq78+X4+Wuzyk0pYnBTfrg==
X-Received: by 2002:a05:600c:364f:: with SMTP id y15mr59733wmq.193.1631146968598;
        Wed, 08 Sep 2021 17:22:48 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.235.167])
        by smtp.gmail.com with ESMTPSA id z19sm102328wma.0.2021.09.08.17.22.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 17:22:48 -0700 (PDT)
Subject: Re: [syzbot] WARNING in io_req_complete_post
To:     syzbot <syzbot+a0516daac8b536b4b8c0@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <0000000000006a0acd05cb84d626@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <a486fe70-68ac-2ecb-c5b4-08328aced022@gmail.com>
Date:   Thu, 9 Sep 2021 01:22:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <0000000000006a0acd05cb84d626@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/9/21 1:11 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    b2bb710d34d5 Add linux-next specific files for 20210907
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=14a956b3300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=457dbc3619116cdf
> dashboard link: https://syzkaller.appspot.com/bug?extid=a0516daac8b536b4b8c0
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+a0516daac8b536b4b8c0@syzkaller.appspotmail.com

It's probably is a dup of "WARNING in io_wq_submit_work (2)",
let see if it can find a reproducer.

> 
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 14536 at fs/io_uring.c:1151 req_ref_put_and_test fs/io_uring.c:1151 [inline]
> WARNING: CPU: 0 PID: 14536 at fs/io_uring.c:1151 req_ref_put_and_test fs/io_uring.c:1146 [inline]
> WARNING: CPU: 0 PID: 14536 at fs/io_uring.c:1151 io_req_complete_post+0x946/0xa50 fs/io_uring.c:1794
> Modules linked in:
> CPU: 0 PID: 14536 Comm: syz-executor.3 Not tainted 5.14.0-next-20210907-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:req_ref_put_and_test fs/io_uring.c:1151 [inline]
> RIP: 0010:req_ref_put_and_test fs/io_uring.c:1146 [inline]
> RIP: 0010:io_req_complete_post+0x946/0xa50 fs/io_uring.c:1794
> Code: e9 94 ff 48 8b 34 24 31 ff e8 76 ee 94 ff e9 6e fc ff ff e8 0c e9 94 ff 4c 89 ef e8 d4 c0 62 ff e9 38 f8 ff ff e8 fa e8 94 ff <0f> 0b e9 8a fb ff ff e8 ee e8 94 ff 49 8d 7e 58 31 c9 ba 01 00 00
> RSP: 0018:ffffc9000bf6fda8 EFLAGS: 00010216
> RAX: 000000000000ec57 RBX: ffff88806c12e000 RCX: ffffc9000fa5e000
> RDX: 0000000000040000 RSI: ffffffff81e12466 RDI: 0000000000000003
> RBP: ffff88801cfea000 R08: 000000000000007f R09: ffff88806c12e05f
> R10: ffffffff81e11fed R11: 0000000000000000 R12: ffff88801cfea640
> R13: ffff88806c12e05c R14: 000000000000007f R15: ffff88806c12e058
> FS:  00007f03ce5d4700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f03ce5d4718 CR3: 00000000149d2000 CR4: 00000000001506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  tctx_task_work+0x189/0x6c0 fs/io_uring.c:2158
>  task_work_run+0xdd/0x1a0 kernel/task_work.c:164
>  tracehook_notify_signal include/linux/tracehook.h:212 [inline]
>  handle_signal_work kernel/entry/common.c:146 [inline]
>  exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
>  exit_to_user_mode_prepare+0x256/0x290 kernel/entry/common.c:209
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
>  syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
>  do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x4665f9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f03ce5d4188 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
> RAX: 0000000000000080 RBX: 000000000056c038 RCX: 00000000004665f9
> RDX: 0000000000000000 RSI: 000000000000688c RDI: 0000000000000003
> RBP: 00000000004bfcc4 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056c038
> R13: 00007ffde5bbb8df R14: 00007f03ce5d4300 R15: 0000000000022000
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

-- 
Pavel Begunkov
