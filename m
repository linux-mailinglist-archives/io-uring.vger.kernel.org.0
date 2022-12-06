Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFC4644EC1
	for <lists+io-uring@lfdr.de>; Tue,  6 Dec 2022 23:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiLFWwT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Dec 2022 17:52:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiLFWwM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Dec 2022 17:52:12 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02D6F4A5A6
        for <io-uring@vger.kernel.org>; Tue,  6 Dec 2022 14:52:03 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id k7so15378297pll.6
        for <io-uring@vger.kernel.org>; Tue, 06 Dec 2022 14:52:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HJNyRaJy8oFwsR9UKEwPADMNUPR4eqU7x8iYjSpV8xs=;
        b=n+iNHNrm730lO10OO5wbUMEHz2FPIHD0ZJKN9ibT6CGzBtFuvklRc8AXS8gXn0aZ6U
         AQavEY2JYgYkqDIEebyWIDzLa/EdfE5+F5L7a+S0Hcq4CXAFu1SRvVfzyOWHn6hSJ4/A
         DCGeqImAWqDYXR/npClDrKV5S7Ayqrwe05x0dJAS4XHOZeHUUePpPVDHpaqPs6gT6XrO
         gyzL1vK5e27AD+jJD8/XVdD1QBzxldVnWHxYUNoZPUGOhKz/PTA7iwiXWsvkIsJAxUm6
         yiyBKSHXwgAUfN37cEmrtTaZh/KSPLw47VZK/vXbuDN5fK49YKOKKmUUCLe0c7huHdC3
         ztYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HJNyRaJy8oFwsR9UKEwPADMNUPR4eqU7x8iYjSpV8xs=;
        b=r2M5huIS20xz6aPo5QxxsP5rCPA2ZulGfuzH/ylS6hHul4opt/x0nVq/8Syp7HkxE7
         KM9zHVuZ92OILuERN55tyMG/yRFmm6cXODH7Flpp8gZMOjRcpjGhh+1q6eG3pZTPFBkZ
         xX26hIUByZMKidGQwdXOfCO1dsi5QGUBGdeRCfHe5ogcXyDvCIIYMKTZBKVHi4UtSmaN
         zjgFcUpD9DJEWlQyRTE6saOfZOcwQjfWWdz01BLADQuXMKKAyxCGxZi7NYhQEpdffbmZ
         UtxHMMc5KShJvW8qRxlLqix1SFYAccNUVRaQnYQTkRFfs4DqGgnuxbGtJWRa28nJ1aow
         EIAQ==
X-Gm-Message-State: ANoB5pkkpPVxGpVSw0vkeevDKhBekqIdgo5hO/3bllK8RoUYnznoMba3
        2Dzyb8DPC3ZAVUKKofY5hlrMfg==
X-Google-Smtp-Source: AA0mqf7mnFEcfop69XMzo7yZ/8Zr+45G6eIA2ufzh4ydWwAHlNUUiAr5RoDkqwbOLowoebFijC9KnQ==
X-Received: by 2002:a17:902:d88d:b0:186:cb27:4e01 with SMTP id b13-20020a170902d88d00b00186cb274e01mr73637675plz.139.1670367122293;
        Tue, 06 Dec 2022 14:52:02 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id z17-20020a631911000000b0046f73d92ea5sm10073332pgl.90.2022.12.06.14.52.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Dec 2022 14:52:01 -0800 (PST)
Message-ID: <ba658258-5987-b50b-4ff4-dffe23ee66fa@kernel.dk>
Date:   Tue, 6 Dec 2022 15:51:59 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] io_uring: Fix a null-ptr-deref in io_tctx_exit_cb()
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc:     harshit.m.mogalapalli@gmail.com, vegard.nossum@oracle.com,
        george.kennedy@oracle.com, darren.kenny@oracle.com,
        syzkaller <syzkaller@googlegroups.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221206093833.3812138-1-harshit.m.mogalapalli@oracle.com>
 <5a643da7-1c28-b680-391e-ea8392210327@kernel.dk>
 <0c692b20-8aab-7f3d-d30c-4732064a7d13@kernel.dk>
In-Reply-To: <0c692b20-8aab-7f3d-d30c-4732064a7d13@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/6/22 2:30 PM, Jens Axboe wrote:
> On 12/6/22 2:15?PM, Jens Axboe wrote:
>> On 12/6/22 2:38?AM, Harshit Mogalapalli wrote:
>>> Syzkaller reports a NULL deref bug as follows:
>>>
>>>  BUG: KASAN: null-ptr-deref in io_tctx_exit_cb+0x53/0xd3
>>>  Read of size 4 at addr 0000000000000138 by task file1/1955
>>>
>>>  CPU: 1 PID: 1955 Comm: file1 Not tainted 6.1.0-rc7-00103-gef4d3ea40565 #75
>>>  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.0-2.el7 04/01/2014
>>>  Call Trace:
>>>   <TASK>
>>>   dump_stack_lvl+0xcd/0x134
>>>   ? io_tctx_exit_cb+0x53/0xd3
>>>   kasan_report+0xbb/0x1f0
>>>   ? io_tctx_exit_cb+0x53/0xd3
>>>   kasan_check_range+0x140/0x190
>>>   io_tctx_exit_cb+0x53/0xd3
>>>   task_work_run+0x164/0x250
>>>   ? task_work_cancel+0x30/0x30
>>>   get_signal+0x1c3/0x2440
>>>   ? lock_downgrade+0x6e0/0x6e0
>>>   ? lock_downgrade+0x6e0/0x6e0
>>>   ? exit_signals+0x8b0/0x8b0
>>>   ? do_raw_read_unlock+0x3b/0x70
>>>   ? do_raw_spin_unlock+0x50/0x230
>>>   arch_do_signal_or_restart+0x82/0x2470
>>>   ? kmem_cache_free+0x260/0x4b0
>>>   ? putname+0xfe/0x140
>>>   ? get_sigframe_size+0x10/0x10
>>>   ? do_execveat_common.isra.0+0x226/0x710
>>>   ? lockdep_hardirqs_on+0x79/0x100
>>>   ? putname+0xfe/0x140
>>>   ? do_execveat_common.isra.0+0x238/0x710
>>>   exit_to_user_mode_prepare+0x15f/0x250
>>>   syscall_exit_to_user_mode+0x19/0x50
>>>   do_syscall_64+0x42/0xb0
>>>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
>>>  RIP: 0023:0x0
>>>  Code: Unable to access opcode bytes at 0xffffffffffffffd6.
>>>  RSP: 002b:00000000fffb7790 EFLAGS: 00000200 ORIG_RAX: 000000000000000b
>>>  RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
>>>  RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
>>>  RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
>>>  R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
>>>  R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>>>   </TASK>
>>>  Kernel panic - not syncing: panic_on_warn set ...
>>>
>>> Add a NULL check on tctx to prevent this.
>>
>> I agree with Vegard that I don't think this is fixing the core of
>> the issue. I think what is happening here is that we don't run the
>> task_work in io_uring_cancel_generic() unconditionally, if we don't
>> need to in the loop above. But we do need to ensure we run it before
>> we clear current->io_uring.
>>
>> Do you have a reproducer? If so, can you try the below? I _think_
>> this is all we need. We can't be hitting the delayed fput path as
>> the task isn't exiting, and we're dealing with current here.
> 
> While I think the above is the right description of what happens, I
> think there's still a race with the proposed solution. If the task_work
> gets added right after the newly inserted io_run_task_work(), then we'll
> still crash when the targeted task exits to userspace and runs the
> task_work.
> 
> It should actually be fine to add that NULL check in io_tctx_exit_cb. We
> can't be racing here, as both the clear and io_tctx_exit_cb() are run by
> current itself. It's really just an ordering issue.

I've queued it up with an improved commit message, and also a code
comment:

https://git.kernel.dk/cgit/linux-block/commit/?h=for-6.2/io_uring-next&id=6d1b48314b989d059642958fc94ef0a58b25fc8c

-- 
Jens Axboe


