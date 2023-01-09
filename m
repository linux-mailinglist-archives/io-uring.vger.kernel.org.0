Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55E8D662697
	for <lists+io-uring@lfdr.de>; Mon,  9 Jan 2023 14:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234641AbjAINMM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Jan 2023 08:12:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237109AbjAINL1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Jan 2023 08:11:27 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E51F1EC74;
        Mon,  9 Jan 2023 05:10:27 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id ud5so19960055ejc.4;
        Mon, 09 Jan 2023 05:10:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/K/fxGXGinKRnD/4uKPoB9HqjfHISlsVt9E/se+mTeE=;
        b=FQp8Qs+Lg64/PthSL4C+ZWqJuT4pBbR9ISEMJthxOjRM1P+28JTrjVzY9GU873zGDp
         SE2h6SbA/Ndk7kZEGdAlCZW3HM76wWdbpKOA4qgPAcZ5/wP4CLlWpCJF3xR9pURClS17
         ZBoeP4U72rQ9RieXNWXd09Epw8tf2VrdRPMY3OiY4j9s/dQe9pOcEAKK5b3FSu3+vlpL
         L9wnE7a7Ln8FMqAYRHr/NyglI+GpXSef8qSZrv25yJmCNO1wz7ZD719Z1xYiEXB+vZnS
         J2HruXq1KHY7Zz1ABZme+LZezy/WN597mfxLdunDJ05lpZb2P/Fjsh2DZxo9vKxzQ6Rd
         1yMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/K/fxGXGinKRnD/4uKPoB9HqjfHISlsVt9E/se+mTeE=;
        b=hSrGR06AxZeohvDgnPYENT57vO+GpM8UY0U97d+3S0l7AUKJG52DdtP0hRSNjXwSv9
         2VxbmbDkAkIxyhP24nZekQ3wAjSAzhj4juIzQoBGnQGRgNRBPYA0pEJ6hfre5IPvz7OF
         Xj4m6JIdBGOR8hio/qWXtpz1/q2hgrxn26TD6SGLRbyv6CJ4pBB8Ct9jnCChTYJdR2ac
         Dxmy3oTGPxM/4Cx60CspWx1RNAUBS7HhFTvQ86JI5xizJrSSgTohjObNagpDPGf6u6W+
         anzr2kvUWz6AVX2sEQVipmgeQ1/8YUpSpKLiIJj1Cvgw853xhhtoogSLt32zSpezY4L+
         45/w==
X-Gm-Message-State: AFqh2kq24i8POVl/Hg9j480CQbhlQnfLvqWzm0p5spJuQWnmSsFDuAZS
        UGmkXLOPFWhRa06VCVXf2U4LgH1QlBk=
X-Google-Smtp-Source: AMrXdXvkwVrHaOOJuN9MWBkAJa5IiH/3slygWa2mUptHt2G+eR002Rrd/0KnDjEHEuPzD7io1r25kw==
X-Received: by 2002:a17:907:6e16:b0:7c1:b64:e290 with SMTP id sd22-20020a1709076e1600b007c10b64e290mr98248584ejc.45.1673269825820;
        Mon, 09 Jan 2023 05:10:25 -0800 (PST)
Received: from [192.168.8.100] (188.29.102.7.threembb.co.uk. [188.29.102.7])
        by smtp.gmail.com with ESMTPSA id x11-20020a170906b08b00b0084c62b7b7d8sm3739852ejy.187.2023.01.09.05.10.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Jan 2023 05:10:25 -0800 (PST)
Message-ID: <c955f0b8-f7f7-b3b7-970b-32aefc06a010@gmail.com>
Date:   Mon, 9 Jan 2023 13:09:29 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [syzbot] memory leak in io_submit_sqes (4)
Content-Language: en-US
To:     syzbot <syzbot+6c95df01470a47fc3af4@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <0000000000009f829805f1ce87b2@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <0000000000009f829805f1ce87b2@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/9/23 06:03, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:

#syz test: git://git.kernel.dk/linux.git syztest


> HEAD commit:    0a71553536d2 Merge tag 'drm-fixes-2023-01-06' of git://ano..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=164951c2480000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=5ddca4921a53cff2
> dashboard link: https://syzkaller.appspot.com/bug?extid=6c95df01470a47fc3af4
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12929d9a480000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=105ffae2480000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/ad52353dc15f/disk-0a715535.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/90927b7e9870/vmlinux-0a715535.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/553a64766dcc/bzImage-0a715535.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+6c95df01470a47fc3af4@syzkaller.appspotmail.com
> 
> executing program
> executing program
> executing program
> executing program
> executing program
> BUG: memory leak
> unreferenced object 0xffff88810de89200 (size 256):
>    comm "syz-executor286", pid 5100, jiffies 4294952261 (age 14.130s)
>    hex dump (first 32 bytes):
>      00 8f 90 0a 81 88 ff ff 00 00 00 00 00 00 00 00  ................
>      00 00 00 00 00 00 00 00 00 40 00 00 00 00 00 00  .........@......
>    backtrace:
>      [<ffffffff84769af3>] __io_alloc_req_refill+0x55/0x193 io_uring/io_uring.c:1040
>      [<ffffffff8476b084>] io_alloc_req_refill io_uring/io_uring.h:378 [inline]
>      [<ffffffff8476b084>] io_submit_sqes.cold+0x65/0x8a io_uring/io_uring.c:2384
>      [<ffffffff823986bd>] __do_sys_io_uring_enter+0x76d/0x1490 io_uring/io_uring.c:3345
>      [<ffffffff848ef735>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>      [<ffffffff848ef735>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>      [<ffffffff84a00087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> BUG: memory leak
> unreferenced object 0xffff888109cac600 (size 96):
>    comm "syz-executor286", pid 5100, jiffies 4294952261 (age 14.130s)
>    hex dump (first 32 bytes):
>      00 8f 90 0a 81 88 ff ff 00 00 00 00 00 00 00 00  ................
>      7b 20 00 c0 00 00 00 00 00 00 00 00 00 00 00 00  { ..............
>    backtrace:
>      [<ffffffff814f94a0>] kmalloc_trace+0x20/0x90 mm/slab_common.c:1062
>      [<ffffffff823a702c>] kmalloc include/linux/slab.h:580 [inline]
>      [<ffffffff823a702c>] io_req_alloc_apoll io_uring/poll.c:650 [inline]
>      [<ffffffff823a702c>] io_arm_poll_handler+0x1fc/0x470 io_uring/poll.c:694
>      [<ffffffff82395e4d>] io_queue_async+0x8d/0x2e0 io_uring/io_uring.c:2006
>      [<ffffffff82397b98>] io_queue_sqe io_uring/io_uring.c:2037 [inline]
>      [<ffffffff82397b98>] io_submit_sqe io_uring/io_uring.c:2286 [inline]
>      [<ffffffff82397b98>] io_submit_sqes+0x968/0xb70 io_uring/io_uring.c:2397
>      [<ffffffff823986bd>] __do_sys_io_uring_enter+0x76d/0x1490 io_uring/io_uring.c:3345
>      [<ffffffff848ef735>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>      [<ffffffff848ef735>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>      [<ffffffff84a00087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> BUG: memory leak
> unreferenced object 0xffff88810a72bb00 (size 256):
>    comm "syz-executor286", pid 5100, jiffies 4294952261 (age 14.130s)
>    hex dump (first 32 bytes):
>      00 8f 90 0a 81 88 ff ff 00 00 00 00 00 00 00 00  ................
>      00 00 00 00 00 00 00 00 00 40 00 00 00 00 00 00  .........@......
>    backtrace:
>      [<ffffffff84769af3>] __io_alloc_req_refill+0x55/0x193 io_uring/io_uring.c:1040
>      [<ffffffff8476b084>] io_alloc_req_refill io_uring/io_uring.h:378 [inline]
>      [<ffffffff8476b084>] io_submit_sqes.cold+0x65/0x8a io_uring/io_uring.c:2384
>      [<ffffffff823986bd>] __do_sys_io_uring_enter+0x76d/0x1490 io_uring/io_uring.c:3345
>      [<ffffffff848ef735>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>      [<ffffffff848ef735>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>      [<ffffffff84a00087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> BUG: memory leak
> unreferenced object 0xffff88810f18f600 (size 96):
>    comm "syz-executor286", pid 5100, jiffies 4294952261 (age 14.130s)
>    hex dump (first 32 bytes):
>      00 8f 90 0a 81 88 ff ff 00 00 00 00 00 00 00 00  ................
>      7b 20 00 c0 00 00 00 00 00 00 00 00 00 00 00 00  { ..............
>    backtrace:
>      [<ffffffff814f94a0>] kmalloc_trace+0x20/0x90 mm/slab_common.c:1062
>      [<ffffffff823a702c>] kmalloc include/linux/slab.h:580 [inline]
>      [<ffffffff823a702c>] io_req_alloc_apoll io_uring/poll.c:650 [inline]
>      [<ffffffff823a702c>] io_arm_poll_handler+0x1fc/0x470 io_uring/poll.c:694
>      [<ffffffff82395e4d>] io_queue_async+0x8d/0x2e0 io_uring/io_uring.c:2006
>      [<ffffffff82397b98>] io_queue_sqe io_uring/io_uring.c:2037 [inline]
>      [<ffffffff82397b98>] io_submit_sqe io_uring/io_uring.c:2286 [inline]
>      [<ffffffff82397b98>] io_submit_sqes+0x968/0xb70 io_uring/io_uring.c:2397
>      [<ffffffff823986bd>] __do_sys_io_uring_enter+0x76d/0x1490 io_uring/io_uring.c:3345
>      [<ffffffff848ef735>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>      [<ffffffff848ef735>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>      [<ffffffff84a00087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
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

-- 
Pavel Begunkov
