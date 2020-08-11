Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC672241D19
	for <lists+io-uring@lfdr.de>; Tue, 11 Aug 2020 17:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728783AbgHKPXj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Aug 2020 11:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728872AbgHKPXj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Aug 2020 11:23:39 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41983C061787
        for <io-uring@vger.kernel.org>; Tue, 11 Aug 2020 08:23:39 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id t10so6961364plz.10
        for <io-uring@vger.kernel.org>; Tue, 11 Aug 2020 08:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=HxieFkRZWq00JV9lR+5XbSvCe+B5iPNdODCDbUs/JLU=;
        b=IuRuu3zgNiX229uq7mxEp/i2KZS867qZt/oBDZ0AV1DvlqipwojqjckR+lTiTssbDE
         hlZCn6+Kdk6eAoXSRPaWoiqjvvUsdGDilV1ttLg0qebK3u/Ihfb/HA8+tQmc/KREiXbz
         gk0PTE7Hptl275Uc3ikPL3xK4gAXnfUlmg8weqeEnDpVh6Acejw5pNhkjT/Erq2WWjZ1
         pFj8zOA+mW4KO4fS6Fs3PSxYmLLuc9MThwRdEj62vuHL5EpAikPsF8mAm0zFTuFXE1XD
         WeIx8Wav5UYIdMq8FaAekec28Mv1HDQB9RdWFtr2nj2x+yQo9vsc5XMCkD12DuqXclBz
         +TRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HxieFkRZWq00JV9lR+5XbSvCe+B5iPNdODCDbUs/JLU=;
        b=RWzKTyiLi6chsOwKxX9e9eN0SIgjXj6nck7sMujGS8Xpaw1e+fRdswj08s7j457lMw
         U74g7bvgq5DaLq6dwNRSR2faHSWSIWfwcPklJWAuealwvmYyhDHgM4ygv180CNfnOLum
         xhar4S809KMnAUIhOIYKRENjSw3p5n5E6ya5lbZSD6RUl/gyyg9AkhiYaJPsHQv/5jZI
         b4ZvU8nIbMwd40ZM4+WF6BFF+vCLMvZpJgustgPr0C5sJYj/VzLM7yENptQLRTSkTevp
         tGkfuA9Xv99/3ybCYzguB9PYRc9Peh9iOUXn0Xpy7HIQEgCm55VbpLKItVUqjqEhEMM1
         sN0g==
X-Gm-Message-State: AOAM531+RL9pefYO8srzMpGBxruGGuO+c4ChVlFQJmyrU7b0l/7Cp6F3
        ql1ZBfuBG4dCz5s8Z/fV/gZ8Mg==
X-Google-Smtp-Source: ABdhPJzqE8fat8E/a9WshMnlyZXkqIzxXRD7Dte7Dcpc5pqILimdLBh1UNgUOIomdLKQe5eqoxP2ug==
X-Received: by 2002:a17:90a:cd06:: with SMTP id d6mr1527683pju.202.1597159417674;
        Tue, 11 Aug 2020 08:23:37 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id a26sm21521948pgm.20.2020.08.11.08.23.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2020 08:23:37 -0700 (PDT)
Subject: Re: memory leak in io_submit_sqes
From:   Jens Axboe <axboe@kernel.dk>
To:     syzbot <syzbot+a730016dc0bdce4f6ff5@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
References: <000000000000f50fb505ac9a72c9@google.com>
 <b8c5db23-c3cf-7daf-6a0a-8a5f713e9803@kernel.dk>
Message-ID: <f0386716-eba3-392c-b6b6-35109a1b009b@kernel.dk>
Date:   Tue, 11 Aug 2020 09:23:35 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <b8c5db23-c3cf-7daf-6a0a-8a5f713e9803@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/11/20 8:59 AM, Jens Axboe wrote:
> On 8/11/20 7:57 AM, syzbot wrote:
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    d6efb3ac Merge tag 'tty-5.9-rc1' of git://git.kernel.org/p..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=13cb0762900000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=42163327839348a9
>> dashboard link: https://syzkaller.appspot.com/bug?extid=a730016dc0bdce4f6ff5
>> compiler:       gcc (GCC) 10.1.0-syz 20200507
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16e877dc900000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1608291a900000
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+a730016dc0bdce4f6ff5@syzkaller.appspotmail.com
>>
>> executing program
>> executing program
>> executing program
>> executing program
>> executing program
>> BUG: memory leak
>> unreferenced object 0xffff888124949100 (size 256):
>>   comm "syz-executor808", pid 6480, jiffies 4294949911 (age 33.960s)
>>   hex dump (first 32 bytes):
>>     00 78 74 2a 81 88 ff ff 00 00 00 00 00 00 00 00  .xt*............
>>     90 b0 51 81 ff ff ff ff 00 00 00 00 00 00 00 00  ..Q.............
>>   backtrace:
>>     [<0000000084e46f34>] io_alloc_req fs/io_uring.c:1503 [inline]
>>     [<0000000084e46f34>] io_submit_sqes+0x5dc/0xc00 fs/io_uring.c:6306
>>     [<000000006d4e19eb>] __do_sys_io_uring_enter+0x582/0x830 fs/io_uring.c:8036
>>     [<00000000a4116b07>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>     [<0000000067b2aefc>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> BUG: memory leak
>> unreferenced object 0xffff88811751d200 (size 96):
>>   comm "syz-executor808", pid 6480, jiffies 4294949911 (age 33.960s)
>>   hex dump (first 32 bytes):
>>     00 78 74 2a 81 88 ff ff 00 00 00 00 00 00 00 00  .xt*............
>>     0e 01 00 00 00 00 75 22 00 00 00 00 00 0f 1f 04  ......u"........
>>   backtrace:
>>     [<00000000073ea2ba>] kmalloc include/linux/slab.h:555 [inline]
>>     [<00000000073ea2ba>] io_arm_poll_handler fs/io_uring.c:4773 [inline]
>>     [<00000000073ea2ba>] __io_queue_sqe+0x445/0x6b0 fs/io_uring.c:5988
>>     [<000000001551bde0>] io_queue_sqe+0x309/0x550 fs/io_uring.c:6060
>>     [<000000002dfb908f>] io_submit_sqe fs/io_uring.c:6130 [inline]
>>     [<000000002dfb908f>] io_submit_sqes+0x8b8/0xc00 fs/io_uring.c:6327
>>     [<000000006d4e19eb>] __do_sys_io_uring_enter+0x582/0x830 fs/io_uring.c:8036
>>     [<00000000a4116b07>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>     [<0000000067b2aefc>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> This one looks very odd, and I cannot reproduce it. The socket() calls
> reliably fails for me, and even if I hack it to use 0 for protocol instead
> of 2, I don't see anything interesting happening here. An IORING_OP_WRITEV
> is submitted on the socket, which just fails with ENOTCONN.

Dug a bit deeper and found the missing option, I can now reproduce this!
I'll take a look.

-- 
Jens Axboe

