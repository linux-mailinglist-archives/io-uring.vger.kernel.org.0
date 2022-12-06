Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABB3A644DFA
	for <lists+io-uring@lfdr.de>; Tue,  6 Dec 2022 22:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiLFVa1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Dec 2022 16:30:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiLFVa1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Dec 2022 16:30:27 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E4B62EF33
        for <io-uring@vger.kernel.org>; Tue,  6 Dec 2022 13:30:26 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id v1so6021281ioe.4
        for <io-uring@vger.kernel.org>; Tue, 06 Dec 2022 13:30:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NY1lbrce4WrYO2aGvYwSUN0oSq8qgVYLOPerQDuEDVk=;
        b=bHMIAOHrUWpdrpvyijfOwx3gWz/Ffg++OvunmI2aHY7REE7YLEK7tU4FESMztgW8lS
         TnuYk+jDef9cJYX5nEG8BGlK+nTo6CxfeiMlLyqIKzK1vflYp2VqP2ilc0vnDso5me5V
         0B0qJIgsWAeyj9QoX0/7OKkwTObtkiKBAFwNIeidlTekVTMcksmGhoI7ZS7nSvbb9Ita
         p/NZC7UMTDd62lUf0qcp3Jwf6SkpIFeY9m9BH/YsCHSTzDT7BaYKbQPjmtro6UnEaAf6
         YS5f/ntAbsNr9GXVe8AgDKUmPgokXecQj+h1yl+QuNU5CaUwK3e5ZIFKB2qatpX98cGK
         itIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NY1lbrce4WrYO2aGvYwSUN0oSq8qgVYLOPerQDuEDVk=;
        b=MZ/JqtuYHJ46A4XPLYtrPU/Kg0Hy+2Mwz8vnp0gH+I70/eqUseOU7r3f2pitp1XTsw
         5mG/+ShvcUlithzyR4UD1RsgvqSPMZ0LfF/9P8m3pEaKiEPUsuHjJDiWNeUdMN+Zx03L
         Ix8m1M2klamfQVOzmrFDFc+FOrWVbg7T3yCF1NgNt320jAZwGDU3UvGG4RYVjnZ0Hd6F
         pvleJLVMFR7B5Cocb4wZC7q64MVT5ZmqZ30jCIzI6zAx3sYWn1IRumwdFseAgPehn53n
         LUhHJXVf0lq/0PLsXyYUMxlKK7Fb/tRyd2uS39gtzd2S/0I5s2TSHFxBcvNTawC9alRx
         Is1g==
X-Gm-Message-State: ANoB5pkbULrxlrr9brIo1fOlcaitk+Lp2otGO6F/wQgfWu4Jx+bTh7s1
        kYPmv0TscQO0aYrCKA1ifPggcw==
X-Google-Smtp-Source: AA0mqf57vl31W9FKVe0odlyoCoqs8C7Sc/CSA1W0SnzD/5qSF1ecgzvPZFuqxdH0dVgv36mG6R7Bnw==
X-Received: by 2002:a02:914b:0:b0:363:b3c4:5c47 with SMTP id b11-20020a02914b000000b00363b3c45c47mr33685993jag.237.1670362225336;
        Tue, 06 Dec 2022 13:30:25 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id b7-20020a029587000000b00370decbbff3sm7176072jai.148.2022.12.06.13.30.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Dec 2022 13:30:23 -0800 (PST)
Message-ID: <0c692b20-8aab-7f3d-d30c-4732064a7d13@kernel.dk>
Date:   Tue, 6 Dec 2022 14:30:21 -0700
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
In-Reply-To: <5a643da7-1c28-b680-391e-ea8392210327@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/6/22 2:15?PM, Jens Axboe wrote:
> On 12/6/22 2:38?AM, Harshit Mogalapalli wrote:
>> Syzkaller reports a NULL deref bug as follows:
>>
>>  BUG: KASAN: null-ptr-deref in io_tctx_exit_cb+0x53/0xd3
>>  Read of size 4 at addr 0000000000000138 by task file1/1955
>>
>>  CPU: 1 PID: 1955 Comm: file1 Not tainted 6.1.0-rc7-00103-gef4d3ea40565 #75
>>  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.0-2.el7 04/01/2014
>>  Call Trace:
>>   <TASK>
>>   dump_stack_lvl+0xcd/0x134
>>   ? io_tctx_exit_cb+0x53/0xd3
>>   kasan_report+0xbb/0x1f0
>>   ? io_tctx_exit_cb+0x53/0xd3
>>   kasan_check_range+0x140/0x190
>>   io_tctx_exit_cb+0x53/0xd3
>>   task_work_run+0x164/0x250
>>   ? task_work_cancel+0x30/0x30
>>   get_signal+0x1c3/0x2440
>>   ? lock_downgrade+0x6e0/0x6e0
>>   ? lock_downgrade+0x6e0/0x6e0
>>   ? exit_signals+0x8b0/0x8b0
>>   ? do_raw_read_unlock+0x3b/0x70
>>   ? do_raw_spin_unlock+0x50/0x230
>>   arch_do_signal_or_restart+0x82/0x2470
>>   ? kmem_cache_free+0x260/0x4b0
>>   ? putname+0xfe/0x140
>>   ? get_sigframe_size+0x10/0x10
>>   ? do_execveat_common.isra.0+0x226/0x710
>>   ? lockdep_hardirqs_on+0x79/0x100
>>   ? putname+0xfe/0x140
>>   ? do_execveat_common.isra.0+0x238/0x710
>>   exit_to_user_mode_prepare+0x15f/0x250
>>   syscall_exit_to_user_mode+0x19/0x50
>>   do_syscall_64+0x42/0xb0
>>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
>>  RIP: 0023:0x0
>>  Code: Unable to access opcode bytes at 0xffffffffffffffd6.
>>  RSP: 002b:00000000fffb7790 EFLAGS: 00000200 ORIG_RAX: 000000000000000b
>>  RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
>>  RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
>>  RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
>>  R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
>>  R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>>   </TASK>
>>  Kernel panic - not syncing: panic_on_warn set ...
>>
>> Add a NULL check on tctx to prevent this.
> 
> I agree with Vegard that I don't think this is fixing the core of
> the issue. I think what is happening here is that we don't run the
> task_work in io_uring_cancel_generic() unconditionally, if we don't
> need to in the loop above. But we do need to ensure we run it before
> we clear current->io_uring.
> 
> Do you have a reproducer? If so, can you try the below? I _think_
> this is all we need. We can't be hitting the delayed fput path as
> the task isn't exiting, and we're dealing with current here.

While I think the above is the right description of what happens, I
think there's still a race with the proposed solution. If the task_work
gets added right after the newly inserted io_run_task_work(), then we'll
still crash when the targeted task exits to userspace and runs the
task_work.

It should actually be fine to add that NULL check in io_tctx_exit_cb. We
can't be racing here, as both the clear and io_tctx_exit_cb() are run by
current itself. It's really just an ordering issue.

-- 
Jens Axboe
