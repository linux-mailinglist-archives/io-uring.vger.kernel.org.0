Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5A82E22A6
	for <lists+io-uring@lfdr.de>; Thu, 24 Dec 2020 00:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbgLWXQJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Dec 2020 18:16:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727144AbgLWXQI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Dec 2020 18:16:08 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C832C061794;
        Wed, 23 Dec 2020 15:15:28 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id m5so652764wrx.9;
        Wed, 23 Dec 2020 15:15:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aHHrIZnh0qpR2FxD+LAXphB6YizF39MC4a+bxRPwlQY=;
        b=bMhOMBwlaXVX2gnnBPQTlp7rxjV3awVQtPYJGYMp04R11lYTMERjeERxLEKTqF5I+1
         E3bLCTW7gEuMEryBhbn++T1w7RD96QY6o1JZVQG0GWwnb7t5ey3P639SKQpmlUcdmp0P
         BElOeRyMaoH7DsMG2VWaH55SCYuAFh/pVMVChg9aoa2gykiQM0huFV2kj6z2AhTsOCG6
         hIJFKK6TCguyrQOPo8r3Bln9NDeVNDwWYvmrnJKFN00gjt4/DO3Y8TKwhBIXha0WX+Mz
         c8zGbVmOG61kSpn3GZuH9DA24am2Qpov9ooiRgA2jUUD4yAp3JTamGpdzUaTyoIWZ1Ob
         A2gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aHHrIZnh0qpR2FxD+LAXphB6YizF39MC4a+bxRPwlQY=;
        b=uSLzPAaxM2E5bRyxQHtuAjUD1PwqkZOET1jY0Dbxwbvw0YVaoHAYTHZaT8TBse4BlZ
         07a0k2jetJ4zUX1yKJ5yWXzoxhZduelkaEV5UHxsn+4f17wUfALHnwu7LGrUssp7IP3s
         1ruTfr1/OLEinfcKmPIsfFzsTefR5bbUl/wpQC8iOkBbd4lGIiWKYA07o6JDxcClwniv
         sMB38VxiUf0P47G00XzfR8Op61Pc8sO034zYJbfXy6cKdSXLbXmd8zfcmd/QdNZUNrVq
         8Lghz6vXKqeEW2nfhT9QPHksFduMOM1QPMXKdvYOBnVg17lbG9EvineP7delMBULlakj
         21QA==
X-Gm-Message-State: AOAM533aHj6NDCa6+JmlgNoKzaGyiuiyKj+kbKslm4vSBDfnd/+VYXG0
        9d0u08dk8IEGp1XMDUq6FGs=
X-Google-Smtp-Source: ABdhPJyGqMCEVrqaOLcKx4vkH+6QGq0SLCgL7bzLzkOgnTRQ8gbFHCJk0u3zXTBMd216EsWsrnpjBA==
X-Received: by 2002:a5d:4587:: with SMTP id p7mr30387664wrq.178.1608765327037;
        Wed, 23 Dec 2020 15:15:27 -0800 (PST)
Received: from [192.168.8.148] ([85.255.233.85])
        by smtp.gmail.com with ESMTPSA id 125sm1253634wmc.27.2020.12.23.15.15.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Dec 2020 15:15:26 -0800 (PST)
Subject: Re: WARNING in __percpu_ref_exit
To:     syzbot <syzbot+482debb49aa7d7fa0b09@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
References: <000000000000f9f31005b57ad69d@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <5fb133b1-18ed-1439-6d33-5a8c05632467@gmail.com>
Date:   Wed, 23 Dec 2020 23:12:03 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <000000000000f9f31005b57ad69d@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 02/12/2020 13:01, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    0eedceaf Add linux-next specific files for 20201201
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=1649b753500000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=55aec7153b7827ea
> dashboard link: https://syzkaller.appspot.com/bug?extid=482debb49aa7d7fa0b09
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> 
> Unfortunately, I don't have any reproducer for this issue yet.

#syz dup: WARNING in percpu_ref_kill_and_confirm (2)

> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+482debb49aa7d7fa0b09@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 28 at lib/percpu-refcount.c:112 __percpu_ref_exit+0x98/0x100 lib/percpu-refcount.c:112
> Modules linked in:
> CPU: 0 PID: 28 Comm: kworker/u4:2 Not tainted 5.10.0-rc6-next-20201201-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Workqueue: events_unbound io_ring_exit_work
> RIP: 0010:__percpu_ref_exit+0x98/0x100 lib/percpu-refcount.c:112
> Code: fd 49 8d 7c 24 10 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 75 61 49 83 7c 24 10 00 74 07 e8 d8 63 b7 fd <0f> 0b e8 d1 63 b7 fd 48 89 ef e8 a9 a0 e5 fd 48 89 da 48 b8 00 00
> RSP: 0018:ffffc90000e2fc88 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: ffff88807373f000 RCX: 0000000000000000
> RDX: ffff888010f51ac0 RSI: ffffffff83b95d78 RDI: ffff88801b826810
> RBP: 0000607f45e7fde8 R08: 0000000000000000 R09: ffffffff8ebd389f
> R10: ffffffff83b95d18 R11: 0000000000000000 R12: ffff88801b826800
> R13: 0000000000000000 R14: ffff88801b826800 R15: ffff88805c6135a8
> FS:  0000000000000000(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055c9d3e62ebc CR3: 00000000728e6000 CR4: 00000000001506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  percpu_ref_exit+0x3b/0x140 lib/percpu-refcount.c:133
>  io_ring_ctx_free fs/io_uring.c:8517 [inline]
>  io_ring_exit_work+0x4fa/0x7a0 fs/io_uring.c:8581
>  process_one_work+0x98d/0x15f0 kernel/workqueue.c:2272
>  worker_thread+0x64c/0x1120 kernel/workqueue.c:2418
>  kthread+0x3b1/0x4a0 kernel/kthread.c:292
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
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
