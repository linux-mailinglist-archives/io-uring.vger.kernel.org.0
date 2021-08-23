Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE333F428B
	for <lists+io-uring@lfdr.de>; Mon, 23 Aug 2021 02:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbhHWAZb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 22 Aug 2021 20:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbhHWAZb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 22 Aug 2021 20:25:31 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 483E2C061575;
        Sun, 22 Aug 2021 17:24:49 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id u1so9467238wmm.0;
        Sun, 22 Aug 2021 17:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=M8hom/cePfNUNq3N50T4tLymQ2tx/gngaMEz9KvNTLY=;
        b=gx+a0BOgD6YJjY0hiDjv5n823QU94L6+Sn/+FAtnmRWH5rO0qtb97qBs8FXaBSENZB
         bagOHPUF4TM3ZVITvjCynoXtKODN0U5hCmY720FftEBZL0Vke0QJ1nd/oUJKLz5iNaVi
         fStFW+uyIhHgLeCKRCp9DNRIgsnV/ZhmHrKzYl+tvN+p0GAsUDeE4iAqZQUt4j00N/jt
         19y/SX05bsVW9iiN2bL18NKsYMEs1zFPbCFEE9OHR5omQuZyARVVjbp2i7oT9nC5/iWm
         7dJsRUfpwHsuAtqYSBCdgZt1MwstGLlJ5eIYu2KZyEtwQTDMpOR0w4idb2dAxDKKxoxX
         /aGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M8hom/cePfNUNq3N50T4tLymQ2tx/gngaMEz9KvNTLY=;
        b=EzYMlR88ipfR/ceTolAnTIkxGumm3Iy18DjR/hrlwBU2UJfpScluAdPh8TMuwy7eCA
         qwVz2Hryc5PPH20Jyrz5W6vMJL3508xeAOlT9howYjHbuuionA4Y8v3f+A4QsOuXdqNq
         KYoFOBrsy5CBZibbNLyCIPPem6py5BcuexEry27N3WgGcY4QJaB1DDYajJ5W1abAAT+R
         Mhr6hWHUoCSFeeScYQeqtR+OeD8UmZqBRk9CkCRbp7Wt6fQgrmw3HnvkgDzs1kNXhRh1
         i9LRTsan203aY5OrsLxXDTRIjnZmmpxLHU9h/A1wHdlrLHFMAvJpeQsIIoNTWfhlq+hr
         Mr5w==
X-Gm-Message-State: AOAM530UvpwzQTZt3HVi4d2tu4JHby9KsYEiCLnl+S74wGnQ4VIENoxW
        wwalUagiyO6Ffv2gT2ut3ok=
X-Google-Smtp-Source: ABdhPJxaCT5ieIWQWPx6+V5wD1cG5n8l7jcgaZFhS+2RgCsVQc2vTX4VtoLe0CWekUXtANMYw0ouhw==
X-Received: by 2002:a1c:1d13:: with SMTP id d19mr13893577wmd.135.1629678287806;
        Sun, 22 Aug 2021 17:24:47 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.233.176])
        by smtp.gmail.com with ESMTPSA id m16sm1730589wmq.8.2021.08.22.17.24.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Aug 2021 17:24:47 -0700 (PDT)
Subject: Re: [syzbot] KASAN: stack-out-of-bounds Read in iov_iter_revert
To:     syzbot <syzbot+9671693590ef5aad8953@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000c3e60005c95cea4b@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <6e5f874d-ac61-9556-8d7e-575ec7d9682a@gmail.com>
Date:   Mon, 23 Aug 2021 01:24:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <000000000000c3e60005c95cea4b@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/12/21 2:43 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    1746f4db5135 Merge tag 'orphans-v5.14-rc6' of git://git.ke..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=111065fa300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=e3a20bae04b96ccd
> dashboard link: https://syzkaller.appspot.com/bug?extid=9671693590ef5aad8953
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=119dcaf6300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=120d216e300000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+9671693590ef5aad8953@syzkaller.appspotmail.com

#syz test: https://github.com/isilence/linux.git syztest_trunc2

> 
> ==================================================================
> BUG: KASAN: stack-out-of-bounds in iov_iter_revert lib/iov_iter.c:1093 [inline]
> BUG: KASAN: stack-out-of-bounds in iov_iter_revert+0x803/0x900 lib/iov_iter.c:1033
> Read of size 8 at addr ffffc9000cf478b0 by task syz-executor673/8439
> 
> CPU: 0 PID: 8439 Comm: syz-executor673 Not tainted 5.14.0-rc5-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
>  print_address_description.constprop.0.cold+0xf/0x309 mm/kasan/report.c:233
>  __kasan_report mm/kasan/report.c:419 [inline]
>  kasan_report.cold+0x83/0xdf mm/kasan/report.c:436
>  iov_iter_revert lib/iov_iter.c:1093 [inline]
>  iov_iter_revert+0x803/0x900 lib/iov_iter.c:1033
>  io_write+0x57b/0xed0 fs/io_uring.c:3459
>  io_issue_sqe+0x28c/0x6920 fs/io_uring.c:6181
>  __io_queue_sqe+0x1ac/0xf00 fs/io_uring.c:6464
>  io_queue_sqe fs/io_uring.c:6507 [inline]
>  io_submit_sqe fs/io_uring.c:6662 [inline]
>  io_submit_sqes+0x63ea/0x7bc0 fs/io_uring.c:6778
>  __do_sys_io_uring_enter+0xb03/0x1d40 fs/io_uring.c:9389
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x43f8a9
> Code: 28 c3 e8 1a 15 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffcc6759968 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
> RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000043f8a9
> RDX: 0000000000000000 RSI: 00000000000052fe RDI: 0000000000000003
> RBP: 00007ffcc6759988 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffcc6759990
> R13: 0000000000000000 R14: 00000000004ae018 R15: 0000000000400488
> 
> 
> addr ffffc9000cf478b0 is located in stack of task syz-executor673/8439 at offset 152 in frame:
>  io_write+0x0/0xed0 fs/io_uring.c:3335
> 
> this frame has 3 objects:
>  [48, 56) 'iovec'
>  [80, 120) '__iter'
>  [160, 288) 'inline_vecs'
> 
> Memory state around the buggy address:
>  ffffc9000cf47780: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  ffffc9000cf47800: 00 00 00 f1 f1 f1 f1 00 00 00 f2 f2 f2 00 00 00
>> ffffc9000cf47880: 00 00 f2 f2 f2 f2 f2 00 00 00 00 00 00 00 00 00
>                                      ^
>  ffffc9000cf47900: 00 00 00 00 00 00 00 f3 f3 f3 f3 00 00 00 00 00
>  ffffc9000cf47980: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
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
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
> 

-- 
Pavel Begunkov
