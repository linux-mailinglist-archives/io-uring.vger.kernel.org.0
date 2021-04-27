Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6A836C4F4
	for <lists+io-uring@lfdr.de>; Tue, 27 Apr 2021 13:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235364AbhD0LVL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Apr 2021 07:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230270AbhD0LVK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Apr 2021 07:21:10 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C948C061574;
        Tue, 27 Apr 2021 04:20:27 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id i21-20020a05600c3555b029012eae2af5d4so6869032wmq.4;
        Tue, 27 Apr 2021 04:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tLUK+to67j3VH5Q3cisiMaMP2hacGQgyvcke7kzJD2E=;
        b=HrDP9ObVQBISF9ALP2txkaG2y+7IHney6wrbY3sQqoA3YnGAdmBOHHbehgA69Bpq5t
         cwNxs5Os1fD0slKEH0esZgVAObvdu7npczNztb0UTpzXCuCfGMn/zMnvMv+nzZ7Nm2L8
         OjoC2WgYccltmIlyf1EYtk4dO+f5K/vFfEFaAA/owg/25hdbNI0B3ogl72nWJNEmyS2t
         5LZATTNAjmuUxnlgiG6wPNbAHD7molqVrHd0Jp3dYzRV35l2cgEhrkMdf9v1s5d4wC0n
         JUjkRtUx83dYybtCM+HX7aFOmH9zE5KJwhSmKD413+8LGXcvrrsO9JoMVoZwH0i2pXX/
         uapg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tLUK+to67j3VH5Q3cisiMaMP2hacGQgyvcke7kzJD2E=;
        b=qUg1/aOMTMz5mq4Vvciy8ZrvYYVZrcjT1XYKYVc5cJ2/9YmNI9990caKGGkCF5CSDP
         x0m8htJhdAmwwNyd6QVVcoI5+5py/mfL5zm859wGXlNEU3Kynp9ZbYHTtP7d+mM1Sm6C
         TB7BF9xj834TBwCs+P2tAwpRaGffCbEgDEmn8s6wxa6txg7kYuzAYbllRJTeMRDb3sxP
         qp6uRv5X8gqPXbC+3U+VNpmDMs2Vf8eyO/eknYYkmH7JPa7qvewXxTK4o4WyNViysc9c
         oYpp61vSVYZjMRE2WFJfoei1jBJqH3eJEXorfJW3sOc5n+qc04ui9aWxozjmQklZv5Bq
         cXMA==
X-Gm-Message-State: AOAM532etMo+sS2siCZBQYp++CBc/8TnbFPFs6aGo3lUc3SL4FnLtZ8f
        7SGJz1XRXBlvQLX4IjjhRFc=
X-Google-Smtp-Source: ABdhPJxsyyc1OOZ1qaNf9SWQ50u5uViJcH76iIWQmlooycEmtS6eb175LlEZR6O8HIGYd0WwSvLYOA==
X-Received: by 2002:a1c:7e45:: with SMTP id z66mr23988766wmc.126.1619522425812;
        Tue, 27 Apr 2021 04:20:25 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.129.131])
        by smtp.gmail.com with ESMTPSA id h9sm20573625wmb.35.2021.04.27.04.20.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Apr 2021 04:20:25 -0700 (PDT)
Subject: Re: KASAN: null-ptr-deref Write in io_uring_cancel_sqpoll
To:     Palash Oswal <oswalpalash@gmail.com>
Cc:     Dmitry Vyukov <dvyukov@google.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        syzbot+be51ca5a4d97f017cd50@syzkaller.appspotmail.com
References: <00000000000022ebeb05bc39f582@google.com>
 <e939af11-7ce8-46af-8c76-651add0ae56bn@googlegroups.com>
 <CACT4Y+aPRCZcLvkuWgK=A_rR0PqdEAM+xssWU4N7hNRSm9=mSA@mail.gmail.com>
 <CAGyP=7fBRPc+qH9UvhGhid9j-B2PeYhQ4bbde_Vg72Mnx9z75Q@mail.gmail.com>
 <dba3f0a9-cb5d-a162-b696-864295259581@gmail.com>
 <CAGyP=7e6xiNVEV6Bc21i0v+e9GWmm2UdTbhDzyNTmMY4Pa=_ng@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <e67b2f55-dd0a-1e1f-e34b-87e8613cd701@gmail.com>
Date:   Tue, 27 Apr 2021 12:20:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <CAGyP=7e6xiNVEV6Bc21i0v+e9GWmm2UdTbhDzyNTmMY4Pa=_ng@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/27/21 11:39 AM, Palash Oswal wrote:
> On Tue, Apr 27, 2021 at 2:07 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> io_sq_offload_create() {
>>     ...
>>     ret = io_uring_alloc_task_context(tsk, ctx);
>>     wake_up_new_task(tsk);
>>     if (ret)
>>         goto err;
>> }
>>
>> Shouldn't happen unless offload create has failed. Just add
>> a return in *cancel_sqpoll() for this case. It's failing
>> so no requests has been submitted and no cancellation is needed.
> 
> io_uring_cancel_sqpoll can be called by two flows:
> 1. io_uring_task_cancel() -> io_sqpoll_cancel_sync() ->
> io_uring_cancel_sqpoll ;  which properly sanitises current->io_uring
> to be non NULL. (
> https://elixir.bootlin.com/linux/v5.12/source/include/linux/io_uring.h#L21
> )
> 2. io_sq_offload_create -> io_sq_thread -> io_uring_cancel_sqpoll ;
> which does not check the value of current->io_uring
> 
> In the second flow,
> https://elixir.bootlin.com/linux/v5.12/source/fs/io_uring.c#L7970
> The initialization of current->io_uring (i.e
> io_uring_alloc_task_context() ) happens after calling io_sq_thread.
> And, therefore io_uring_cancel_sqpoll receives a NULL value for
> current->io_uring.

Right, exactly as I wrote in the previous message. And still placing
the check in io_uring_cancel_sqpoll() is a better (safer) option.

Just send a patch for 5.13 and mark it stable

> 
> The backtrace from the crash confirms the second scenario:
> [   70.661551] ==================================================================
> [   70.662764] BUG: KASAN: null-ptr-deref in io_uring_cancel_sqpoll+0x203/0x350
> [   70.663834] Write of size 4 at addr 0000000000000060 by task iou-sqp-750/755
> [   70.664025]
> [   70.664025] CPU: 1 PID: 755 Comm: iou-sqp-750 Not tainted 5.12.0 #101
> [   70.664025] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS 1.14.0-1 04/01/2014
> [   70.664025] Call Trace:
> [   70.664025]  dump_stack+0xe9/0x168
> [   70.664025]  ? io_uring_cancel_sqpoll+0x203/0x350
> [   70.664025]  __kasan_report+0x166/0x1c0
> [   70.664025]  ? io_uring_cancel_sqpoll+0x203/0x350
> [   70.664025]  kasan_report+0x4f/0x70
> [   70.664025]  kasan_check_range+0x2f3/0x340
> [   70.664025]  __kasan_check_write+0x14/0x20
> [   70.664025]  io_uring_cancel_sqpoll+0x203/0x350
> [   70.664025]  ? io_sq_thread_unpark+0xd0/0xd0
> [   70.664025]  ? mutex_lock+0xbb/0x130
> [   70.664025]  ? init_wait_entry+0xe0/0xe0
> [   70.664025]  ? wait_for_completion_killable_timeout+0x20/0x20
> [   70.664025]  io_sq_thread+0x174c/0x18c0
> [   70.664025]  ? io_rsrc_put_work+0x380/0x380
> [   70.664025]  ? init_wait_entry+0xe0/0xe0
> [   70.664025]  ? _raw_spin_lock_irq+0xa5/0x180
> [   70.664025]  ? _raw_spin_lock_irqsave+0x190/0x190
> [   70.664025]  ? calculate_sigpending+0x6b/0xa0
> [   70.664025]  ? io_rsrc_put_work+0x380/0x380
> [   70.664025]  ret_from_fork+0x22/0x30
> 
> We might want to add additional validation before calling
> io_uring_cancel_sqpoll. I did verify that the reproducer stopped
> producing the bug after the following change.
> ---
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index dff34975d86b..36fc9abe8022 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -6832,8 +6832,10 @@ static int io_sq_thread(void *data)
>                 timeout = jiffies + sqd->sq_thread_idle;
>         }
> 
> -       list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
> -               io_uring_cancel_sqpoll(ctx);
> +       list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
> +               if (current->io_uring)
> +                       io_uring_cancel_sqpoll(ctx);
> +       }
>         sqd->thread = NULL;
>         list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
>                 io_ring_set_wakeup_flag(ctx);
> 

-- 
Pavel Begunkov
