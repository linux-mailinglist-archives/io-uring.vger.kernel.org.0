Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 339743C5CE3
	for <lists+io-uring@lfdr.de>; Mon, 12 Jul 2021 15:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234226AbhGLNDS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Jul 2021 09:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233807AbhGLNDR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Jul 2021 09:03:17 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89AC7C0613DD;
        Mon, 12 Jul 2021 06:00:29 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id l18-20020a1ced120000b029014c1adff1edso14390996wmh.4;
        Mon, 12 Jul 2021 06:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=PgvnSqoEi8Bhyc4rxrR+Sp00RAeQczQRheeViCZ5sH0=;
        b=oDTMIBmiSrELCTHUmLhbGXm1N2nCGK7RED4Z60m9ykYKxYobROmbLqK2wVABKcYwih
         sVfRtk/F1vO3dKBu5p8JzR5bE/AtW7u89G5E0OAEfjlU/Pj8BTwBwc9soHI56+wYH/FO
         1ztKkdjHplfr7IrIQzZLvZRTYc4f0wYPLRvsgNDiFAakzRrp/VnuA+loMj48D+MmHLFy
         KOo5zHciYqt6KdzUwm3lIYdQ8MYs5e4kugDEIYc9JPxojQ8+EPrDV7m4RBY1gvpNLMT2
         3430Rb1n6tLg8zzUl+bqr2W2q3yus2jDkr3p4IVvItX7E4GMj8/Sta2GD7gPLFEzeU4e
         SPng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PgvnSqoEi8Bhyc4rxrR+Sp00RAeQczQRheeViCZ5sH0=;
        b=Rwvdk+whDhRTkbZsLzOwpViM8QbLN3RAr8Kbe/sSVDAbb+kzrOJqSbfM0Z5tWlhHO7
         amO7StFbztdKDWCz4iSv3mZR9lttAgMT6F/Ey/QUKDk92IbIXsP/pZRZSZ8AE8LA1xc/
         aGLT6tdnu7Tjt4cCR02v3hKxEf2+8XUzNbsisUEPruvumVYK1dfsYSpayt9fv0AkYnea
         ja1Xi4H+eWLkQ32+pB/BZiUAOTYsPvu9wPQFngbnKszisxfzkDtO9jIpZ2lY/Pv7ciAM
         G606l5gv0W/tL+1BkxooF/TRqwP7+e0euzJosmaZZphZKZJrKxW9QO5BWYwLESeR/vmL
         sgzA==
X-Gm-Message-State: AOAM530xwaCvJFz/i50+60f1juE49AN6yqOo5UrNXKw7tK1/JcdInlVz
        HrpGqUVkmhZG2LLTcI17L0c=
X-Google-Smtp-Source: ABdhPJweAY5MR6hZ1diCHpNZouJ+Cq8l33LrMJ+ITJyr7uqCHUyuZi2Ke8VJBueUDIvgLiOPli+GSg==
X-Received: by 2002:a1c:7ec3:: with SMTP id z186mr54805538wmc.83.1626094828075;
        Mon, 12 Jul 2021 06:00:28 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.233.168])
        by smtp.gmail.com with ESMTPSA id b9sm17013840wrh.81.2021.07.12.06.00.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jul 2021 06:00:27 -0700 (PDT)
To:     syzbot <syzbot+d50e4f20cfad4510ec22@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000d0615505c6e9bd7f@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [syzbot] kernel BUG in io_queue_async_work
Message-ID: <34411b70-e29f-3631-a81c-df20c2964211@gmail.com>
Date:   Mon, 12 Jul 2021 14:00:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <000000000000d0615505c6e9bd7f@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/12/21 10:28 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    e2f74b13 Add linux-next specific files for 20210708
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=14fc6fb4300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=59e1e3bbc3afca75
> dashboard link: https://syzkaller.appspot.com/bug?extid=d50e4f20cfad4510ec22
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+d50e4f20cfad4510ec22@syzkaller.appspotmail.com

[...]

>  __io_queue_sqe+0x913/0xf10 fs/io_uring.c:6444

Shouldn't have got here from fallback, so very similar to a bug fixed
by an already sent "io_uring: use right task for exiting checks"

>  io_req_task_submit+0x100/0x120 fs/io_uring.c:2020
>  io_fallback_req_func+0x81/0xb0 fs/io_uring.c:2437
>  process_one_work+0x98d/0x1630 kernel/workqueue.c:2276
>  worker_thread+0x658/0x11f0 kernel/workqueue.c:2422
>  kthread+0x3e5/0x4d0 kernel/kthread.c:319
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> Modules linked in:
> ---[ end trace 4d51acadba583174 ]---
> RIP: 0010:io_queue_async_work+0x539/0x5f0 fs/io_uring.c:1293
> Code: 89 be 89 00 00 00 48 c7 c7 00 8a 9a 89 c6 05 28 5f 77 0b 01 e8 be e9 06 07 e9 6e ff ff ff e8 be 1e 95 ff 0f 0b e8 b7 1e 95 ff <0f> 0b e8 b0 1e 95 ff 0f 0b e9 1a fd ff ff e8 d4 2f db ff e9 47 fb
> RSP: 0018:ffffc900032efba8 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: ffff88802840c800 RCX: 0000000000000000
> RDX: ffff888082e09c80 RSI: ffffffff81e07d49 RDI: ffff8880224da498
> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000043736500
> R10: ffffffff81e222ff R11: 0000000000000000 R12: ffff8880782e78c0
> R13: 0000000000000019 R14: ffff88802840c8b0 R15: ffff8880782e7918
> FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f3dee45e000 CR3: 000000002dd4e000 CR4: 00000000001506f0
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
> 

-- 
Pavel Begunkov
