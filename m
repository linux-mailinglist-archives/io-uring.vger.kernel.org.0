Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33BC225F5B8
	for <lists+io-uring@lfdr.de>; Mon,  7 Sep 2020 10:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbgIGIxS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Sep 2020 04:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727122AbgIGIxR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Sep 2020 04:53:17 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BFDDC061573;
        Mon,  7 Sep 2020 01:53:15 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id j2so14907713wrx.7;
        Mon, 07 Sep 2020 01:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=A7Ob64uVCgQyADTz7K9otXCMPdV+q+h2KonSWJg/dPI=;
        b=uy6UIlJNIh28BNN2taXnkM+toeAasVWdnK9mRy7byXZuqptwG1fsA2L+o850ffbvdO
         2UEq0I5MVdwC6jdAL2XJGP4vJc6dEwDr4AuQjGrYpHEXfZOSkHPOISDqJVvXE4GPuC0s
         hCmmsbakV0DfbXdlnedXJ9NhCT6ZHvquFYWltQjtx7vUOy+zd4Q57zocg+2j6SXIMDvb
         sm3KgsWRZ5Eu4gjm+n9DY9Z1jG2j9bsi1Hy8GFvP9BkTXvVolM5G0dADZXuWz/MXkiP/
         qC6K8cpkLtC3Om+9y8WOA2XLwhpCHf/xKCr2NohzK/D+sMlj6RPwH68XVc20ZNypBECU
         GXkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=A7Ob64uVCgQyADTz7K9otXCMPdV+q+h2KonSWJg/dPI=;
        b=prIvkhClPK0MEOmEbILmpp268g/DaXMCCKr/UuqH3zYYg48DXcHpwjcC4VEMPNsZ3f
         HwMzdNwBwVuH+yJ6NOjp+9YoE+hRurKkQoGBsyRgYw/oXAGlENePpm12bW8ue/38flcG
         wx/PXpCFWIz50a72F13uP0VjzRaVe+z61FDk1R6VOFT1h7uZAHVnvWLmccy8DM2+xcQS
         7B3rkNjdFPsCgMEleytEsPXywxlb1xmvuPzKmFaTIqOEYqinpp1VP/4LIsE2ZPe5jn1o
         OBNbMXr7pD5OQnxRhghLqYTSc1omkYWTD+9YTcloHBgkQtzXC/IDTbVXCnaXqlzeVCkh
         T7xw==
X-Gm-Message-State: AOAM532t0pmXNjJxnWs5DCbR/kHqv+XcAaWPMy/29vacGiGzXojl7F9M
        h5i1o4tBvFhWXrZnVriw/wCA+5r0pa9XVA==
X-Google-Smtp-Source: ABdhPJzsehv6jbJ8lt2kbSXmHNnBpQQh2rLMyffPbBF17Yag9pcsdk7Srj4wgBWeISN7k76h43/gew==
X-Received: by 2002:a5d:4448:: with SMTP id x8mr21753846wrr.207.1599468794056;
        Mon, 07 Sep 2020 01:53:14 -0700 (PDT)
Received: from [192.168.43.239] ([5.100.193.184])
        by smtp.gmail.com with ESMTPSA id 189sm26411087wmb.3.2020.09.07.01.53.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2020 01:53:13 -0700 (PDT)
Subject: Re: [PATCH next] io_uring: fix task hung in io_uring_setup
To:     Jens Axboe <axboe@kernel.dk>, Hillf Danton <hdanton@sina.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk,
        syzbot+107dd59d1efcaf3ffca4@syzkaller.appspotmail.com,
        Stefano Garzarella <sgarzare@redhat.com>,
        Kees Cook <keescook@chromium.org>
References: <20200903132119.14564-1-hdanton@sina.com>
 <9bef23b1-6791-6601-4368-93de53212b22@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <8031fbe7-9e69-4a79-3b42-55b2a1a690e3@gmail.com>
Date:   Mon, 7 Sep 2020 11:50:48 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <9bef23b1-6791-6601-4368-93de53212b22@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 03/09/2020 17:04, Jens Axboe wrote:
> On 9/3/20 7:21 AM, Hillf Danton wrote:
>>
>> The smart syzbot found the following issue:
>>
>> INFO: task syz-executor047:6853 blocked for more than 143 seconds.
>>       Not tainted 5.9.0-rc3-next-20200902-syzkaller #0
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> task:syz-executor047 state:D stack:28104 pid: 6853 ppid:  6847 flags:0x00004000
>> Call Trace:
>>  context_switch kernel/sched/core.c:3777 [inline]
>>  __schedule+0xea9/0x2230 kernel/sched/core.c:4526
>>  schedule+0xd0/0x2a0 kernel/sched/core.c:4601
>>  schedule_timeout+0x1d8/0x250 kernel/time/timer.c:1855
>>  do_wait_for_common kernel/sched/completion.c:85 [inline]
>>  __wait_for_common kernel/sched/completion.c:106 [inline]
>>  wait_for_common kernel/sched/completion.c:117 [inline]
>>  wait_for_completion+0x163/0x260 kernel/sched/completion.c:138
>>  io_sq_thread_stop fs/io_uring.c:6906 [inline]
>>  io_finish_async fs/io_uring.c:6920 [inline]
>>  io_sq_offload_create fs/io_uring.c:7595 [inline]
>>  io_uring_create fs/io_uring.c:8671 [inline]
>>  io_uring_setup+0x1495/0x29a0 fs/io_uring.c:8744
>>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> because the sqo_thread kthread is created in io_sq_offload_create() without
>> being waked up. Then in the error branch of that function we will wait for
>> the sqo kthread that never runs. It's fixed by waking it up before waiting.
> 
> Looks good - applied, thanks.

BTW, I don't see the patch itself, and it's neither in io_uring, block
nor fs mailing lists. Hillf, could you please CC proper lists next time?

-- 
Pavel Begunkov
