Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBFD725FAC4
	for <lists+io-uring@lfdr.de>; Mon,  7 Sep 2020 14:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729345AbgIGMzS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Sep 2020 08:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729281AbgIGMzJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Sep 2020 08:55:09 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A153C061575
        for <io-uring@vger.kernel.org>; Mon,  7 Sep 2020 05:55:08 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id kk9so4108155pjb.2
        for <io-uring@vger.kernel.org>; Mon, 07 Sep 2020 05:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LtZPyi/AukZy15ogdyhyhhfmtD6VdGQ8V+ah+uZ5ZRE=;
        b=h9KtAmbLvtAS6iQDVPynlTja6eFvARzIIqyZGjsQ20GC/J+Yg5jFY7D2QRZMKrFLiz
         dkdtie2ACqm1XDPCxL6BuFnkf1P0yhhdZ+z6efRlhKEBnn2tRUzsOrLKAKteYS3VgSbA
         0IXGpUnL3OAaVlIoFtWisIbQ8UxaacynRRsYiMtJ4VlnpwrfdgrbjBkryuLm+QGNESZq
         e46wSb/XIxBk5v4sHHKdlvTMkWktAxgO4Oy6ypC1/YgB30YLpnfn0pM1juOdO2m6jJ9B
         c9oMbJxuGXEz5NKHKA+r923gYTdTjS7/ZFvAEAgeqJ2vdW6GiHkJ+M13nDsh4aa0Ocoz
         Z6rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LtZPyi/AukZy15ogdyhyhhfmtD6VdGQ8V+ah+uZ5ZRE=;
        b=mfCSv9JNdGyPsvkogtr9IOE1WDp6XGSUXG5pMEqDlMsGqLRGfO9GKfiGt7GUtk85xx
         e5KcOOyUsTjnz6TdqdL4qUyJ7PVuhfjQB7nS6ZMU/MNnoSX3Wg/5VxvWFTGlUhrggh4L
         JC2RgxwWei8vQ8g+kB3h5eq6Y4CEkNY/xePZEPhFstrs9Aa6Bte1pUR9qgyddM9iXOzh
         JDglKHQUarphWgQKicLMBxoXRoCokLdtVBCEp8UEoYVh5s1cEggtZdtmfRvGodAw6hLi
         +BwpTFmEcVdgt/XtIUJGQtOO8x+bMrSnfZBa2NgI3A0aEEDv1SSh2DIzm3dyN0Z7fozW
         5i8g==
X-Gm-Message-State: AOAM531ZDCmuJDCW5GzUX0xiecBkLHrjx7D7LoGvoX/ET7JoSXUwz4bW
        r63k0pTqPyraVEIWk21DjJM+EA==
X-Google-Smtp-Source: ABdhPJwSJhwbdTK3aiOECk1N01cYyEhVPN+DwxgBITkWSDuyKHu9bvElYyztoBA6ts42wvdnXIfuaw==
X-Received: by 2002:a17:902:c692:b029:d0:90a3:24f4 with SMTP id r18-20020a170902c692b02900d090a324f4mr13703671plx.12.1599483307097;
        Mon, 07 Sep 2020 05:55:07 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id z7sm5473517pfj.75.2020.09.07.05.55.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2020 05:55:06 -0700 (PDT)
Subject: Re: [PATCH next] io_uring: fix task hung in io_uring_setup
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Hillf Danton <hdanton@sina.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk,
        syzbot+107dd59d1efcaf3ffca4@syzkaller.appspotmail.com,
        Stefano Garzarella <sgarzare@redhat.com>,
        Kees Cook <keescook@chromium.org>
References: <20200903132119.14564-1-hdanton@sina.com>
 <9bef23b1-6791-6601-4368-93de53212b22@kernel.dk>
 <8031fbe7-9e69-4a79-3b42-55b2a1a690e3@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <192220ac-fd43-c553-e694-a3e51bcbfa4a@kernel.dk>
Date:   Mon, 7 Sep 2020 06:55:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <8031fbe7-9e69-4a79-3b42-55b2a1a690e3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/7/20 2:50 AM, Pavel Begunkov wrote:
> On 03/09/2020 17:04, Jens Axboe wrote:
>> On 9/3/20 7:21 AM, Hillf Danton wrote:
>>>
>>> The smart syzbot found the following issue:
>>>
>>> INFO: task syz-executor047:6853 blocked for more than 143 seconds.
>>>       Not tainted 5.9.0-rc3-next-20200902-syzkaller #0
>>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>> task:syz-executor047 state:D stack:28104 pid: 6853 ppid:  6847 flags:0x00004000
>>> Call Trace:
>>>  context_switch kernel/sched/core.c:3777 [inline]
>>>  __schedule+0xea9/0x2230 kernel/sched/core.c:4526
>>>  schedule+0xd0/0x2a0 kernel/sched/core.c:4601
>>>  schedule_timeout+0x1d8/0x250 kernel/time/timer.c:1855
>>>  do_wait_for_common kernel/sched/completion.c:85 [inline]
>>>  __wait_for_common kernel/sched/completion.c:106 [inline]
>>>  wait_for_common kernel/sched/completion.c:117 [inline]
>>>  wait_for_completion+0x163/0x260 kernel/sched/completion.c:138
>>>  io_sq_thread_stop fs/io_uring.c:6906 [inline]
>>>  io_finish_async fs/io_uring.c:6920 [inline]
>>>  io_sq_offload_create fs/io_uring.c:7595 [inline]
>>>  io_uring_create fs/io_uring.c:8671 [inline]
>>>  io_uring_setup+0x1495/0x29a0 fs/io_uring.c:8744
>>>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>>
>>> because the sqo_thread kthread is created in io_sq_offload_create() without
>>> being waked up. Then in the error branch of that function we will wait for
>>> the sqo kthread that never runs. It's fixed by waking it up before waiting.
>>
>> Looks good - applied, thanks.
> 
> BTW, I don't see the patch itself, and it's neither in io_uring, block
> nor fs mailing lists. Hillf, could you please CC proper lists next time?

He did, but I'm guessing that vger didn't like the email for whatever
reason. Hillf, did you get an error back from vger when sending the patch?

-- 
Jens Axboe

