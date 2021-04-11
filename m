Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E91635B293
	for <lists+io-uring@lfdr.de>; Sun, 11 Apr 2021 11:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235230AbhDKJOH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 11 Apr 2021 05:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbhDKJOG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 11 Apr 2021 05:14:06 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2740C061574;
        Sun, 11 Apr 2021 02:13:50 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id t5-20020a1c77050000b029010e62cea9deso5174944wmi.0;
        Sun, 11 Apr 2021 02:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hhZLQGbpMa+giZg+pQtJeHmdo8x3Qe/tU25gCSxAfZc=;
        b=SQTuijjpNH6xsc4fnXxrrssIw/u7mNU3q+F4aOR0YwcxXER9wLQfr0s3KDbmHiy3Ez
         2fhO9z4JTNYi0ii9eZJCgVA1QsrnE01vYvuqDIZ3H/revp9qCn/qW/Ifb/kaIg5WLR4K
         sfrDADg8BMz/AzjCFLI6wXEtA7WwWSibfUdc9OyRcHatWTGK2hmzerM6FIGE2l6hyzVZ
         S695Xd3QWtkRvXWKDOzHTNf6WmVQ+A1L7yKAD7xEYvZCPSQZ1GGQUbs9CdHvpTK1GEOt
         hgdR0QOW8kQtKLaOhv2SmjzACmA6i4zZTL8HdCY+PIcHWD3KQ9PDjvAo/x+F1qK2EBCM
         17fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=hhZLQGbpMa+giZg+pQtJeHmdo8x3Qe/tU25gCSxAfZc=;
        b=nZAnHgyySZiJ82G6/FoPQOcVajhptDXVgYeXaDJtUi3RTXhWmiRCw2Hiutn79M6AWy
         EXAYopPbC3pCzlSx3MjeEcmxrCJuaP0XVrWCjIA4mD08uLcVW2vlY5Hk+t9aRApXgd/g
         MfAdWvwxSv+NEhEw1QEVsDESuSyRCkbBHVQsxXvceDBIcgo+Lt7COtgmDlyF7hl6SoVH
         l8hexsz6kzrwLy1FbR3YmAH0tGrcnH3Klz/N47MR1y+FmmpjiZIoH2obZenaJJlhzPvV
         qtcbShgOB23eb4pAxQGP5lubEH25vbEKVOmtndesb42Hg95a8KpGdhRe/jeyn/XbSqS0
         NE+A==
X-Gm-Message-State: AOAM5331RBpNHdpbAWsazWzddIfRstj8SljMUGSUKCFbF3wBn+DWtCwn
        kubajt4Bd8iUsWVSo2H5RZQS9KqVBrqoYA==
X-Google-Smtp-Source: ABdhPJwqC022LaUVx4AEh69RxSBl8A7EZdBqCCgCSVK03iQnmiNJVpp3DJyoPApBhHZTa8GLzrBIEw==
X-Received: by 2002:a05:600c:1548:: with SMTP id f8mr21522036wmg.81.1618132429315;
        Sun, 11 Apr 2021 02:13:49 -0700 (PDT)
Received: from [192.168.8.169] ([85.255.237.117])
        by smtp.gmail.com with ESMTPSA id n125sm10671385wme.46.2021.04.11.02.13.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Apr 2021 02:13:48 -0700 (PDT)
To:     Hao Sun <sunhao.th@gmail.com>, axboe@kernel.dk,
        io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <CACkBjsb4Ad60ZTyaaObBj2DKxSv1avmTSo3WUrnvH+amuDuhrA@mail.gmail.com>
 <461a8447-bc48-145f-c3dc-4b049621afcc@gmail.com>
 <CACkBjsZLvtAVYO4MTtB8E+E3TzRDxCrBJ8Y6oeepRC0tRmmiAA@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in
 io_uring_cancel_task_requests
Message-ID: <23a3e43b-e4bb-c557-08b1-c578827a0a34@gmail.com>
Date:   Sun, 11 Apr 2021 10:09:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <CACkBjsZLvtAVYO4MTtB8E+E3TzRDxCrBJ8Y6oeepRC0tRmmiAA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/04/2021 09:58, Hao Sun wrote:
> Pavel Begunkov <asml.silence@gmail.com> 于2021年4月11日周日 下午4:14写道：
>>
>> On 11/04/2021 04:08, Hao Sun wrote:
>>> Hi
>>>
>>> When using Healer(https://github.com/SunHao-0/healer/tree/dev) to fuzz
>>> the Linux kernel, I found a null-ptr-deref bug in
>>> io_uring_cancel_task_requests under fault injection condition, but I'm
>>> not sure about this.
>>> Sorry, I do not have a reproducing program for this bug.
>>> I hope that the stack trace information in the crash log can help you
>>> locate the problem.
>>
>> Thanks Hao. io_cqring_wait() fails should not anyhow affect
>> cancellation, so the log doesn't make sense from first sight,
>> something strange is going on.
>>
> Is it possible that the failure of io_cqring_wait affects other
> operations with side effects between io_cqring_wait and cancellation,
> which eventually leads to the cancellation bug?

It shouldn't in theory, but need to a look deeper

TL;DR;
ctx->flags is NULL dereference, means that tctx->xa entry is invalid
or file->private got corrupted/not set. Your kernel is old enough
(5.11-ish), so it's a bit more safer in that regard and all
manipulations with ->xa are pretty much made by the task itself,
so should be synchronised.

There are things like io_run_task_work() or overflow_flush() that
are done in the cqring_wait(), but not much. It also grabs a file
beforehand and puts afterwards, extra reference would lead to hangs
not such failures.

> I found the last call sequence (Syzlang format) executed by the fuzzer
> before triggering the bug.
> This may be helpful, but there is no guarantee that this is the direct
> cause of the bug.

appreciate that

> 
> Possible guilty test case:
> r19 = syz_io_uring_setup(0x7211,
> &(0x7f0000000540)={0x6e3620b713f86b87,0xf615,0x2,0x1000,0x1a6,0xa26bc79d6b5315eb,0x0,[0x0,0x0,0x0],[0x813a698e7df9790f,0x1,0xb43ab5cc286248ee,0xe543f3b8cf765dd5,0x8005afeb090b0e62,0x1a29b15882d5d0b7,0xd7dc82c17c7ba1a7,0xab9d3c813ad3ae79,0x0,0x0],[0x1,0xd3a439e17ea7133c,0x4b845483eeeab284,0xf6fdf7f35d59044,0xf,0x99a9733bb1278a03,0xf8a69ea77c12e2b2,0x1,0x1,0x176ecee6d3c04836]},
> &(0x7f0000000000/0x5000)=nil, &(0x7f0000000000/0x120000)=nil,
> &(0x7f00000005c0)=<r17=>0x0, &(0x7f0000000600)=<r18=>0x0)
> io_uring_enter(r19, 0x1, 0x66ab, 0x3,
> &(0x7f0000000040)={[0xfffe8c2bdda0afdd]}, 0x8)
> io_uring_register$IORING_UNREGISTER_EVENTFD(r19, 0x5, 0x0, 0x0)
> 
>>>
>>> Here is the details:
>>> commit:   3b9cdafb5358eb9f3790de2f728f765fef100731
>>> version:   linux 5.11
>>> git tree:    upstream
>>> Full log can be found in the attachment.
>>> cqwait()
>>> Fault injection log:
>>> FAULT_INJECTION: forcing a failure.
>>> name fail_usercopy, interval 1, probability 0, space 0, times 0
>>> CPU: 1 PID: 9161 Comm: executor Not tainted 5.11.0+ #5
>>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
>>> rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
>>> Call Trace:
>>>  __dump_stack lib/dump_stack.c:79 [inline]
>>>  dump_stack+0x137/0x194 lib/dump_stack.c:120
>>>  fail_dump lib/fault-inject.c:52 [inline]
>>>  should_fail+0x23e/0x250 lib/fault-inject.c:146
>>>  should_fail_usercopy+0x16/0x20 lib/fault-inject-usercopy.c:37
>>>  _copy_from_user+0x1c/0xd0 lib/usercopy.c:14
>>>  copy_from_user include/linux/uaccess.h:192 [inline]
>>>  set_user_sigmask+0x4b/0x110 kernel/signal.c:3015
>>>  io_cqring_wait+0x2e3/0x8b0 fs/io_uring.c:7250
>>>  __do_sys_io_uring_enter fs/io_uring.c:9480 [inline]
>>>  __se_sys_io_uring_enter+0x8fc/0xb70 fs/io_uring.c:9397
>>>  __x64_sys_io_uring_enter+0x74/0x80 fs/io_uring.c:9397
>>>  do_syscall_64+0x39/0x80 arch/x86/entry/common.c:46
>>>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>>> RIP: 0033:0x46a379
>>> Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8 48
>>> 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
>>> 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
>>> RSP: 002b:00007f046fa19c58 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
>>> RAX: ffffffffffffffda RBX: 000000000078c080 RCX: 000000000046a379
>>> RDX: 00000000000066ab RSI: 0000000000000001 RDI: 0000000000000003
>>> RBP: 00007f046fa19c90 R08: 0000000020000040 R09: 0000000000000008
>>> R10: 0000000000000003 R11: 0000000000000246 R12: 0000000000000000
>>> R13: 0000000000000000 R14: 000000000078c080 R15: 00007fff769deef0
>>>
>>> Crash log:
>>> BUG: kernel NULL pointer dereference, address: 0000000000000040
>>> #PF: supervisor read access in kernel mode
>>> #PF: error_code(0x0000) - not-present page
>>> PGD 49954067 P4D 49954067 PUD 45f92067 PMD 0
>>> Oops: 0000 [#1] PREEMPT SMP
>>> CPU: 1 PID: 9161 Comm: executor Not tainted 5.11.0+ #5
>>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
>>> rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
>>> RIP: 0010:io_uring_cancel_task_requests+0x3f/0x990 fs/io_uring.c:9045
>>> Code: 48 8b 04 25 28 00 00 00 48 89 44 24 68 e8 89 e6 c5 ff 65 4c 8b
>>> 34 25 00 6d 01 00 49 8d 7c 24 40 48 89 7c 24 30 e8 81 97 d6 ff <41> 8b
>>> 5c 24 40 89 de 83 e6 02 31 ff e8 70 ea c5 ff 83 e3 02 48 89
>>> RSP: 0018:ffffc90002a97b48 EFLAGS: 00010246
>>> RAX: ffff88804b8e0d38 RBX: ffff88804b8ad700 RCX: 0000000000000764
>>> RDX: 0000000000000040 RSI: ffff8880409d5140 RDI: 0000000000000040
>>> RBP: ffff8880409d5140 R08: 0000000000000000 R09: 0000000000000043
>>> R10: 0001ffffffffffff R11: ffff88804b8e0280 R12: 0000000000000000
>>> R13: ffff8880409d5140 R14: ffff88804b8e0280 R15: ffff8880481c1800
>>> FS:  00007f046fa1a700(0000) GS:ffff88807ec00000(0000) knlGS:0000000000000000
>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> CR2: 0000000000000040 CR3: 00000000479a5000 CR4: 0000000000750ee0
>>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>>> PKRU: 55555554
>>> Call Trace:
>>>  __io_uring_files_cancel+0x9b/0x200 fs/io_uring.c:9140
>>>  io_uring_files_cancel include/linux/io_uring.h:65 [inline]
>>>  do_exit+0x1a8/0x16d0 kernel/exit.c:780
>>>  do_group_exit+0xc5/0x180 kernel/exit.c:922
>>>  get_signal+0xd90/0x1470 kernel/signal.c:2773
>>>  arch_do_signal_or_restart+0x2a/0x260 arch/x86/kernel/signal.c:811
>>>  handle_signal_work kernel/entry/common.c:147 [inline]
>>>  exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
>>>  exit_to_user_mode_prepare+0x109/0x1a0 kernel/entry/common.c:208
>>>  __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
>>>  syscall_exit_to_user_mode+0x20/0x40 kernel/entry/common.c:301
>>>  do_syscall_64+0x45/0x80 arch/x86/entry/common.c:56
>>>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>>> RIP: 0033:0x46a379
>>> Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8 48
>>> 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
>>> 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
>>> RSP: 002b:00007f046fa19cd8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
>>> RAX: fffffffffffffe00 RBX: 000000000078c080 RCX: 000000000046a379
>>> RDX: 0000000000000000 RSI: 0000000000000080 RDI: 000000000078c088
>>> RBP: 000000000078c088 R08: 0000000000000000 R09: 0000000000000000
>>> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000078c08c
>>> R13: 0000000000000000 R14: 000000000078c080 R15: 00007fff769deef0
>>> Modules linked in:
>>> Dumping ftrace buffer:
>>>    (ftrace buffer empty)
>>> CR2: 0000000000000040
>>> ---[ end trace 613db1a25ecf6443 ]---
>>> RIP: 0010:io_uring_cancel_task_requests+0x3f/0x990 fs/io_uring.c:9045
>>> Code: 48 8b 04 25 28 00 00 00 48 89 44 24 68 e8 89 e6 c5 ff 65 4c 8b
>>> 34 25 00 6d 01 00 49 8d 7c 24 40 48 89 7c 24 30 e8 81 97 d6 ff <41> 8b
>>> 5c 24 40 89 de 83 e6 02 31 ff e8 70 ea c5 ff 83 e3 02 48 89
>>> RSP: 0018:ffffc90002a97b48 EFLAGS: 00010246
>>> RAX: ffff88804b8e0d38 RBX: ffff88804b8ad700 RCX: 0000000000000764
>>> RDX: 0000000000000040 RSI: ffff8880409d5140 RDI: 0000000000000040
>>> RBP: ffff8880409d5140 R08: 0000000000000000 R09: 0000000000000043
>>> R10: 0001ffffffffffff R11: ffff88804b8e0280 R12: 0000000000000000
>>> R13: ffff8880409d5140 R14: ffff88804b8e0280 R15: ffff8880481c1800
>>> FS:  00007f046fa1a700(0000) GS:ffff88807ec00000(0000) knlGS:0000000000000000
>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> CR2: 0000000000000040 CR3: 00000000479a5000 CR4: 0000000000750ee0
>>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>>> PKRU: 55555554
>>>
>>
>> --
>> Pavel Begunkov

-- 
Pavel Begunkov
