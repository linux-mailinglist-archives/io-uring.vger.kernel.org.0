Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0AD625C246
	for <lists+io-uring@lfdr.de>; Thu,  3 Sep 2020 16:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729021AbgICONQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Sep 2020 10:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729190AbgICOLy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Sep 2020 10:11:54 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23D02C06123C
        for <io-uring@vger.kernel.org>; Thu,  3 Sep 2020 07:04:25 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id w3so2593114ilh.5
        for <io-uring@vger.kernel.org>; Thu, 03 Sep 2020 07:04:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=D31H04mUbP+GfSuSCo4lSao/klBUc/vQDz1fdRAoRLI=;
        b=arhvROiKCh0B0OFzraDqlWOtES8RJVlS3wjLrZWs/uK0wr9n+mzsscBgaIX55vzkmO
         UGCeK89hwjdy8ds866T0uNIYWLGZzcwPJt9TPQ21Qbt8ZuosiJjnokEJlG89FxJWAUtO
         AvQ5kLibQEH1hXFKxGwez9PRbpEczSDW6GBM/AFhjv+TlUW6kqpWMXGjy9pYPe/ooujc
         ZJwyaofPEIt5tHRP7Jx0f9Q4juqQufPIAxtM/eSowCN06PRkigTjKSuyFVxGstHW+8zi
         GQr60T3r7BuWtn2iuSBB9KZL1Ho8iWzXapg7hsB4asCX5WfFufGamuO3uXvGiJtmuSoI
         36MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D31H04mUbP+GfSuSCo4lSao/klBUc/vQDz1fdRAoRLI=;
        b=Ss3FIdLQkzF6Hc+frhQMJ0mNmcoQZgcp39xBK+hZBAax4jaLRgYmCEGPV43iaTdkM+
         ye3gwdMvL4lRrmE7nOoFu/vMvz998TAO2bUjUaV2FNUUJTLb9MFEGSZc7jiULeKN09OO
         09sYZaC+JcDVGqQRDoqlie8Ea821hv6gHjeGsY1OpoiLkez3Q9k2McyD2OGWZuBE6nWZ
         n9nSsaqqhdJwPmTSQ1JZvP3/VogBsgCAk6CQwCzj6aMWhNupv6dzIPjvSL9smKZxL4l/
         Wa8OO5GMhKhT87eoSEdI93BZHombx6tnonD69/4By4CPrdr32Kn6yR60MeUUh3K72m+K
         TP9A==
X-Gm-Message-State: AOAM533gjpqg9scag4FJpXaid0MFew08VvdtFNwaH6Rg+8b+v//ZlyzQ
        90GIyFS77qNICJyqh+uqjCPLqg==
X-Google-Smtp-Source: ABdhPJzNX2pngMZo/p4jPhsZsLuRxbuccAvhohxEPGEsSkeD6Qa/tVfYBvZvbtTRHCwT+r3ZmuVI+Q==
X-Received: by 2002:a92:9fc9:: with SMTP id z70mr3242577ilk.91.1599141863740;
        Thu, 03 Sep 2020 07:04:23 -0700 (PDT)
Received: from [192.168.1.57] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id p3sm1497198ilq.59.2020.09.03.07.04.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2020 07:04:23 -0700 (PDT)
Subject: Re: [PATCH next] io_uring: fix task hung in io_uring_setup
To:     Hillf Danton <hdanton@sina.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk,
        syzbot+107dd59d1efcaf3ffca4@syzkaller.appspotmail.com,
        Stefano Garzarella <sgarzare@redhat.com>,
        Kees Cook <keescook@chromium.org>
References: <20200903132119.14564-1-hdanton@sina.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9bef23b1-6791-6601-4368-93de53212b22@kernel.dk>
Date:   Thu, 3 Sep 2020 08:04:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200903132119.14564-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/3/20 7:21 AM, Hillf Danton wrote:
> 
> The smart syzbot found the following issue:
> 
> INFO: task syz-executor047:6853 blocked for more than 143 seconds.
>       Not tainted 5.9.0-rc3-next-20200902-syzkaller #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:syz-executor047 state:D stack:28104 pid: 6853 ppid:  6847 flags:0x00004000
> Call Trace:
>  context_switch kernel/sched/core.c:3777 [inline]
>  __schedule+0xea9/0x2230 kernel/sched/core.c:4526
>  schedule+0xd0/0x2a0 kernel/sched/core.c:4601
>  schedule_timeout+0x1d8/0x250 kernel/time/timer.c:1855
>  do_wait_for_common kernel/sched/completion.c:85 [inline]
>  __wait_for_common kernel/sched/completion.c:106 [inline]
>  wait_for_common kernel/sched/completion.c:117 [inline]
>  wait_for_completion+0x163/0x260 kernel/sched/completion.c:138
>  io_sq_thread_stop fs/io_uring.c:6906 [inline]
>  io_finish_async fs/io_uring.c:6920 [inline]
>  io_sq_offload_create fs/io_uring.c:7595 [inline]
>  io_uring_create fs/io_uring.c:8671 [inline]
>  io_uring_setup+0x1495/0x29a0 fs/io_uring.c:8744
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> because the sqo_thread kthread is created in io_sq_offload_create() without
> being waked up. Then in the error branch of that function we will wait for
> the sqo kthread that never runs. It's fixed by waking it up before waiting.

Looks good - applied, thanks.

-- 
Jens Axboe

