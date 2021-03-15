Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFA2133B277
	for <lists+io-uring@lfdr.de>; Mon, 15 Mar 2021 13:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbhCOMWj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Mar 2021 08:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbhCOMWT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Mar 2021 08:22:19 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17293C061574;
        Mon, 15 Mar 2021 05:22:19 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id v15so8590710wrx.4;
        Mon, 15 Mar 2021 05:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mDAFfJZhogpdlbTSYlFpK3CuRxI3jBVzOjSdK74TWUQ=;
        b=P+Hjcfw7CTKThYuXw672CZQNrPg0uBCA3mqICL7PA+sfZ1+KG2Yyg7NZ1Q107a+cd2
         c5sTu/Q60nWXSKoEbl9HKupLIWqpj9h1PZOZnJwBGn27Og3+4JBgJL3ye67Dj3HssWW1
         WmWOToSEWu0qZNCdX64WtgmpqGVlHscGZ/Fdu2rTBoW2XcROKN+kLI+kGJa5o9/qzFOB
         KV+pnOgxIS5q4ek0whyM2HFxJzhNnupjZxNKQh6l9BoMbMpFOiiO2znfOUAmGDVdwSki
         owZTEn+8wIwfoDAEjd/3fZwXku594Lu1zJfwTe9eFy8Wm3MFSjeHN+y1XF6laUvifMjM
         5Ttg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mDAFfJZhogpdlbTSYlFpK3CuRxI3jBVzOjSdK74TWUQ=;
        b=C1BoMgEF4vEUhnQf3ysWIHD51S8WnNgw3EIITf2hjkW/qoSi+9Epvb+jFs/jposJaA
         u6n4sqmaw43Cvz1y74LK9Z5k1qHlv3XVVFjwyJLjN1AMe3Y3Un3zeze87HjCHF3VaMNr
         A1kVgHLxwX3LQE2XdZeb05SbRlc78If9qvHJkRnhJFCNQh4GgT1FuTToVMzIYfo93jP/
         7xcz+T5oJYXeLpNwhFizHY4ra3pCJJglxuEwy2JJG9jupvcgIA1AwtY95bfwXyciS19v
         T/i4SYY9swoJzYcK+l+1Q2fFB3Hr4fLdPdbf6zYZWfX/eHtyiFW8hXlvJY/8a0qrEcEI
         CRRA==
X-Gm-Message-State: AOAM532UiFjAoPrA9Rh88/Xg5s+lQBA5cZ31e30eB46Wdyemlhgi1mdh
        CMxkDLrlZtB3VS2BXb/Yax0Br9LaUaw=
X-Google-Smtp-Source: ABdhPJx6ojo60goeCm8B8XlsWREB9BSH17FfBDREiKoQuVE7f42UW0zQcbNM8dyDr7PLkDszLtOlcw==
X-Received: by 2002:adf:9bca:: with SMTP id e10mr27237854wrc.364.1615810937800;
        Mon, 15 Mar 2021 05:22:17 -0700 (PDT)
Received: from [192.168.8.151] ([148.252.132.232])
        by smtp.gmail.com with ESMTPSA id d85sm11929131wmd.15.2021.03.15.05.22.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Mar 2021 05:22:17 -0700 (PDT)
Subject: Re: [syzbot] WARNING in __percpu_ref_exit (2)
To:     syzbot <syzbot+d6218cb2fae0b2411e9d@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <0000000000006e9e0705bd91f762@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <a3420ea6-8f91-f97f-9887-1de9aa5bb02e@gmail.com>
Date:   Mon, 15 Mar 2021 12:18:20 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <0000000000006e9e0705bd91f762@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 15/03/2021 11:58, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    75013c6c Merge tag 'perf_urgent_for_v5.12-rc3' of git://gi..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=174df32ad00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=844457676c06b88c
> dashboard link: https://syzkaller.appspot.com/bug?extid=d6218cb2fae0b2411e9d
> userspace arch: i386
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+d6218cb2fae0b2411e9d@syzkaller.appspotmail.com
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 53 at lib/percpu-refcount.c:113 __percpu_ref_exit+0x98/0x100 lib/percpu-refcount.c:113

if (percpu_count) {
	/* non-NULL confirm_switch indicates switching in progress */
	WARN_ON_ONCE(ref->data && ref->data->confirm_switch);
	...
}

Points to this warning. Not sure, but not yet included
"io_uring: halt SQO submission on ctx exit" may fix it or at least is
related.

> Modules linked in:
> CPU: 1 PID: 53 Comm: kworker/u4:2 Not tainted 5.12.0-rc2-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Workqueue: events_unbound io_ring_exit_work
> RIP: 0010:__percpu_ref_exit+0x98/0x100 lib/percpu-refcount.c:113
> Code: fd 49 8d 7c 24 10 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 75 61 49 83 7c 24 10 00 74 07 e8 28 42 ac fd <0f> 0b e8 21 42 ac fd 48 89 ef e8 e9 fa da fd 48 89 da 48 b8 00 00
> RSP: 0018:ffffc90000f1fb78 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: ffff88805c976000 RCX: 0000000000000000
> RDX: ffff888011839bc0 RSI: ffffffff83c76be8 RDI: ffff88802b2a9010
> RBP: 0000607f46077778 R08: 0000000000000000 R09: ffffffff8fab0967
> R10: ffffffff83c76b88 R11: 0000000000000009 R12: ffff88802b2a9000
> R13: 0000000000000001 R14: ffff88802b2a9000 R15: dffffc0000000000
> FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000085a0004 CR3: 000000001896a000 CR4: 00000000001506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  percpu_ref_exit+0x3b/0x140 lib/percpu-refcount.c:134
>  io_ring_ctx_free fs/io_uring.c:8419 [inline]
>  io_ring_exit_work+0x599/0xcf0 fs/io_uring.c:8565
>  process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
>  worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
>  kthread+0x3b1/0x4a0 kernel/kthread.c:292
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
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
