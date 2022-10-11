Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 145A25FA9BB
	for <lists+io-uring@lfdr.de>; Tue, 11 Oct 2022 03:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbiJKBJC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Oct 2022 21:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiJKBJB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Oct 2022 21:09:01 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B2743DBD1;
        Mon, 10 Oct 2022 18:08:59 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id e18so7699960wmq.3;
        Mon, 10 Oct 2022 18:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=od2bJIu5rWon4PHbH9X3cJf5MWnSpigV9GhPB7yFis8=;
        b=nvBPiW+pf60cfRpcaSfztDoFClIFK6mZhphdVGr+3bhkmwDcKiv+G8ndguvaxeZS/Z
         ukDWhPsb4TzIySVx0C3pfRbAG1vIFgD0gAUIAJzhh4ob0OvRmmttdn8qEKo8myCLsAbn
         k6jSBnm6Zfr2KdaaTyntStQpq5Isyw5Q9yH6hRUX22v4ji+OZiZwzKdD5qltiAc7lRMZ
         TYcjXNexleFXiwyKCvUwnkvhHWYlEqfI1OAbimdYbSLpV5RMm945kiWmCEjhGmiSgHkG
         HnZed6UXz5SzCen7fCdJyNzZgLsG6/hj72VAFBE6kAynjU1N03xeAXHSwtLuQgArwoB1
         UNEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=od2bJIu5rWon4PHbH9X3cJf5MWnSpigV9GhPB7yFis8=;
        b=olO3wJw7S8Jh7awj1nfAtoooZPVuqJiJw7eWTqfJ1lbapZElyVijTIE4hCyt5VjDMA
         ZC0ST6x5Lv2AcCX5pxPewoZH6wqsZpBpahWptrind3PB9Mc6RSFDpWwpDY1I/VLOrPcN
         5dpc0j+vW0atE+x/naHOfW6QQz0nQvuN6c5qy7PaunSc7kNCnJiAcBPuGtiG0Yc0FQwx
         mq4Za14d3XZ0vUgPlKHDVc3oM5pyOOqaTiZ3Hh4N8vMF4+CZRZppOVa3FklmRQnm/7XV
         3P8oWuAZoiC39Gngx1kRRyIj8WevNQlp/Bs2qV3Slg9QXzA1PzBR2CKkJy9F4o3HJ4l8
         9Oog==
X-Gm-Message-State: ACrzQf1DskKLNRc1SGcFVk9PAyMj82pRJcdh8aJL8URWFS/MKJJArAGh
        GvmOLj25CpvG2U7rDfyzPx8yRI7oqdo=
X-Google-Smtp-Source: AMsMyM5v6kbCc6IHFBeGXc1MFknzwovRtWVfYrRBoa07bYd32Qd9PhDmC9kBsx9GeJEbAUYOavMWPA==
X-Received: by 2002:a05:600c:3506:b0:3b4:c086:fa37 with SMTP id h6-20020a05600c350600b003b4c086fa37mr22592292wmq.165.1665450537891;
        Mon, 10 Oct 2022 18:08:57 -0700 (PDT)
Received: from [192.168.8.100] (94.196.221.180.threembb.co.uk. [94.196.221.180])
        by smtp.gmail.com with ESMTPSA id l36-20020a05600c1d2400b003a62052053csm22351435wms.18.2022.10.10.18.08.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Oct 2022 18:08:57 -0700 (PDT)
Message-ID: <e4487267-effa-32dc-1199-db439dd3bf03@gmail.com>
Date:   Tue, 11 Oct 2022 02:03:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: BUG: corrupted list in io_poll_task_func
To:     Wei Chen <harperchen1110@gmail.com>, axboe@kernel.dk,
        io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <CAO4mrffiwEOr2tC+LXnjzP7QZ56M+V3o87K43Y7m6-rvHfwjwA@mail.gmail.com>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAO4mrffiwEOr2tC+LXnjzP7QZ56M+V3o87K43Y7m6-rvHfwjwA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/10/22 13:41, Wei Chen wrote:
> Dear Linux Developer,
> 
> Recently when using our tool to fuzz kernel, the following crash was triggered:
> 
> HEAD commit: c5eb0a61238d Linux 5.18-rc6
> git tree: upstream
> compiler: clang 12.0.0
> console output:
> https://drive.google.com/file/d/1Obzlp9wrLFx9BogwmOHhmnQqyMYa2z_k/view?usp=sharing
> kernel config: https://drive.google.com/file/d/12fNP5UArsFqTi2jjGomWuCk5evtgU0Gu/view?usp=sharing

It's hard to tell anything as it's rc6 and we have a couple of
poll fixes backported to stable 5.18. Would be great if you tell
whether you see it with a stable kernel. Also a repro would
help if it finds it. Thanks


> Unfortunately, I don't have any reproducer for this crash yet.
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: Wei Chen <harperchen1110@gmail.com>
> 
> list_del corruption. prev->next should be ffff88810ec0ae30, but was
> ffff888114119218. (prev=ffff888114119218)
> ------------[ cut here ]------------
> kernel BUG at lib/list_debug.c:53!
> invalid opcode: 0000 [#1] PREEMPT SMP
> CPU: 0 PID: 20805 Comm: iou-sqp-20802 Not tainted 5.18.0-rc6 #10
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> 1.13.0-1ubuntu1.1 04/01/2014
> RIP: 0010:__list_del_entry_valid+0xa7/0xc0
> Code: 48 c7 c7 54 12 3f 83 4c 89 fe 48 89 da 31 c0 e8 89 e0 21 01 0f
> 0b 48 c7 c7 6f d7 48 83 4c 89 fe 4c 89 e1 31 c0 e8 73 e0 21 01 <0f> 0b
> 48 c7 c7 17 b4 42 83 4c 89 fe 4c 89 f1 31 c0 e8 5d e0 21 01
> RSP: 0018:ffffc900026dbb58 EFLAGS: 00010046
> RAX: 000000000000006d RBX: dead000000000122 RCX: 6101d1e720e71900
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
> RBP: ffff88810ec0ae08 R08: ffffffff8115f303 R09: 0000000000000000
> R10: 0001ffffffffffff R11: 000188813bc1b460 R12: ffff888114119218
> R13: ffff88810ec0ae00 R14: ffff888114119218 R15: ffff88810ec0ae30
> FS:  00007f1e57534700(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f1e574afdb8 CR3: 00000001394b3000 CR4: 0000000000750ef0
> DR0: 0000000020000140 DR1: 0000000020000440 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
> PKRU: 55555554
> Call Trace:
>   <TASK>
>   io_poll_task_func+0x1ca/0x4f0
>   tctx_task_work+0x808/0xae0
>   task_work_run+0x8e/0x110
>   get_signal+0x13c6/0x1520
>   io_sq_thread+0x382/0xbd0
>   ret_from_fork+0x1f/0x30
>   </TASK>
> Modules linked in:
> Dumping ftrace buffer:
>     (ftrace buffer empty)
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:__list_del_entry_valid+0xa7/0xc0
> Code: 48 c7 c7 54 12 3f 83 4c 89 fe 48 89 da 31 c0 e8 89 e0 21 01 0f
> 0b 48 c7 c7 6f d7 48 83 4c 89 fe 4c 89 e1 31 c0 e8 73 e0 21 01 <0f> 0b
> 48 c7 c7 17 b4 42 83 4c 89 fe 4c 89 f1 31 c0 e8 5d e0 21 01
> RSP: 0018:ffffc900026dbb58 EFLAGS: 00010046
> RAX: 000000000000006d RBX: dead000000000122 RCX: 6101d1e720e71900
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
> RBP: ffff88810ec0ae08 R08: ffffffff8115f303 R09: 0000000000000000
> R10: 0001ffffffffffff R11: 000188813bc1b460 R12: ffff888114119218
> R13: ffff88810ec0ae00 R14: ffff888114119218 R15: ffff88810ec0ae30
> FS:  00007f1e57534700(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f1e574afdb8 CR3: 00000001394b3000 CR4: 0000000000750ef0
> DR0: 0000000020000140 DR1: 0000000020000440 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
> PKRU: 55555554
> 
> Best,
> Wei

-- 
Pavel Begunkov
