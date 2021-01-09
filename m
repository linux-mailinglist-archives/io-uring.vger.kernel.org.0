Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5B12F01CF
	for <lists+io-uring@lfdr.de>; Sat,  9 Jan 2021 17:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbhAIQpN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 9 Jan 2021 11:45:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbhAIQpM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 9 Jan 2021 11:45:12 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2204DC061786;
        Sat,  9 Jan 2021 08:44:32 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id v14so10241565wml.1;
        Sat, 09 Jan 2021 08:44:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VtZ6mosAZ+yocjVHG+qKo+6ReK2dhW+ttv0GDUYWvdc=;
        b=ElBsaw9Hx9rv3cPvfJtQeaBno6Q5Ez1lNLL8s60QoYidkkyTiVDUvsmmcqtUMPPDpQ
         Rqa+loEjAuoQu4b54ba4bw+ECV9LJZmDSMmzoNflAdZK63WS2KSvHZZXwhEpWUW4/Nj6
         nEHwsO9hccN8hutb7pDqr71CsNKmkZgw3lJIJGu4mICWNnCv7c4aiquVGzp4aTM87dlL
         pH636WCZFwOHZZ4Tw1gviCVAxMsw4UMJVBiLB0DiUsX3gE7vi1pDTAEWFkQAfn9DKPcF
         hR5Txu9AfCfaJKL0tUy6t4MIYARGiJSp3xlNKwXfYbw39RCK5NXt8tTKCV4I0Yy2aKZt
         k9tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VtZ6mosAZ+yocjVHG+qKo+6ReK2dhW+ttv0GDUYWvdc=;
        b=aZHri+UUhn4LnmbcBgCd9zdKe6nWyHghsLf1NCOlhPh+KwDOS+W7cCmr1S3yDXN2oQ
         SlLitfHar6vKDYKufORjt2KYiqS07sSR3BTPCi9C6EUSzkJ8wTTuk0OZ1OEjwXlCJ5Bm
         qo06YKABQp0r9H0iyunL7AEFHoo5Az4J7sqECfqKHj+F0/y/n+222/M8WnAlkCeBzSPr
         0iOlxTv+MyKQMffUnNwYBiDcnYTQr0yxD6ZvCFcSIF1qd/hvccE5TGoWaYMtI5M4C+E+
         PFyG2qrr9YGL3woyzCdnKc5TsRj9QqAjio9R9uJKJz3R4CBVuPc+wMUvfj8LNDmPNcUK
         WKkQ==
X-Gm-Message-State: AOAM532Zhmymz1iGPz+oWIlvnIkLGL8Pt1dZedNLw6U3IuYTT4JyGRI7
        p5vkfDGzF1wN5cL/Hwj/UfI=
X-Google-Smtp-Source: ABdhPJy34lhvkddFG0pFYMBxAoIkcED3xExLaFNUNONNdo+XuEotSFBuXu54nt4BG+tTsWUqN7a0Kw==
X-Received: by 2002:a1c:2155:: with SMTP id h82mr7733150wmh.132.1610210670816;
        Sat, 09 Jan 2021 08:44:30 -0800 (PST)
Received: from [192.168.8.114] ([185.69.144.125])
        by smtp.gmail.com with ESMTPSA id z15sm18191432wrv.67.2021.01.09.08.44.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Jan 2021 08:44:30 -0800 (PST)
Subject: Re: BUG: unable to handle kernel paging request in percpu_ref_exit
To:     syzbot <syzbot+99ed55100402022a6276@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@kernel.org, mingo@redhat.com, peterz@infradead.org,
        rostedt@goodmis.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk, will@kernel.org
References: <000000000000cfdf1c05b87a25e8@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <06c3d80d-eb09-5cda-e0bf-862400d02433@gmail.com>
Date:   Sat, 9 Jan 2021 16:40:57 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <000000000000cfdf1c05b87a25e8@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 09/01/2021 16:27, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    36bbbd0e Merge branch 'rcu/urgent' of git://git.kernel.org..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=149afeeb500000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=8aa30b9da402d224
> dashboard link: https://syzkaller.appspot.com/bug?extid=99ed55100402022a6276
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10496f70d00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10cedf70d00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+99ed55100402022a6276@syzkaller.appspotmail.com
> Fixes: 4d004099a668 ("lockdep: Fix lockdep recursion")

Looks like the fixed ERR_PTR vs NULL issue.

#syz test: git://git.kernel.dk/linux-block d9d05217cb6990b9a56e13b56e7a1b71e2551f6c

> 
> RBP: 0000000000000005 R08: 0000000000000001 R09: 0000000000401140
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000402860
> R13: 00000000004028f0 R14: 0000000000000000 R15: 0000000000000000
> BUG: unable to handle page fault for address: fffffffffffffffc
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page
> PGD b08f067 P4D b08f067 PUD b091067 PMD 0 
> Oops: 0000 [#1] PREEMPT SMP KASAN
> CPU: 0 PID: 8500 Comm: syz-executor191 Not tainted 5.11.0-rc2-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:percpu_ref_exit+0x2f/0x140 lib/percpu-refcount.c:130
> Code: 54 55 53 48 89 fb e8 f0 fc b6 fd 48 8d 6b 08 48 b8 00 00 00 00 00 fc ff df 48 89 ea 48 c1 ea 03 80 3c 02 00 0f 85 d5 00 00 00 <4c> 8b 73 08 48 89 df e8 c5 fe ff ff 4d 85 f6 0f 84 b3 00 00 00 e8
> RSP: 0018:ffffc9000126fcc8 EFLAGS: 00010246
> RAX: dffffc0000000000 RBX: fffffffffffffff4 RCX: 0000000000000000
> RDX: 1fffffffffffffff RSI: ffffffff83bb78b0 RDI: fffffffffffffff4
> RBP: fffffffffffffffc R08: 0000000000000001 R09: ffffffff8ebda867
> R10: fffffbfff1d7b50c R11: 0000000000000000 R12: 0000000000000000
> R13: ffff88801adee000 R14: 0000000000000002 R15: fffffffffffffff4
> FS:  000000000179f940(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: fffffffffffffffc CR3: 0000000020270000 CR4: 00000000001506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  destroy_fixed_file_ref_node fs/io_uring.c:7703 [inline]
>  io_sqe_files_unregister+0x30b/0x770 fs/io_uring.c:7293
>  __io_uring_register fs/io_uring.c:9916 [inline]
>  __do_sys_io_uring_register+0x1185/0x4080 fs/io_uring.c:10000
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x444df9
> Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db d5 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007ffeb192ade8 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
> RAX: ffffffffffffffda RBX: 00007ffeb192ae90 RCX: 0000000000444df9
> RDX: 0000000000000000 RSI: 0000000000000003 RDI: 0000000000000004
> RBP: 0000000000000005 R08: 0000000000000001 R09: 0000000000401140
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000402860
> R13: 00000000004028f0 R14: 0000000000000000 R15: 0000000000000000
> Modules linked in:
> CR2: fffffffffffffffc
> ---[ end trace ed34d5d65a155c02 ]---
> RIP: 0010:percpu_ref_exit+0x2f/0x140 lib/percpu-refcount.c:130
> Code: 54 55 53 48 89 fb e8 f0 fc b6 fd 48 8d 6b 08 48 b8 00 00 00 00 00 fc ff df 48 89 ea 48 c1 ea 03 80 3c 02 00 0f 85 d5 00 00 00 <4c> 8b 73 08 48 89 df e8 c5 fe ff ff 4d 85 f6 0f 84 b3 00 00 00 e8
> RSP: 0018:ffffc9000126fcc8 EFLAGS: 00010246
> RAX: dffffc0000000000 RBX: fffffffffffffff4 RCX: 0000000000000000
> RDX: 1fffffffffffffff RSI: ffffffff83bb78b0 RDI: fffffffffffffff4
> RBP: fffffffffffffffc R08: 0000000000000001 R09: ffffffff8ebda867
> R10: fffffbfff1d7b50c R11: 0000000000000000 R12: 0000000000000000
> R13: ffff88801adee000 R14: 0000000000000002 R15: fffffffffffffff4
> FS:  000000000179f940(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: fffffffffffffffc CR3: 0000000020270000 CR4: 00000000001506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
> 

-- 
Pavel Begunkov
