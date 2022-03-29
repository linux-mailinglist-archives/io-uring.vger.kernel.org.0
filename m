Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2B584EB37A
	for <lists+io-uring@lfdr.de>; Tue, 29 Mar 2022 20:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240150AbiC2SmD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 29 Mar 2022 14:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239347AbiC2SmC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 29 Mar 2022 14:42:02 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF06B1AB4
        for <io-uring@vger.kernel.org>; Tue, 29 Mar 2022 11:40:19 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id b9so12991295ila.8
        for <io-uring@vger.kernel.org>; Tue, 29 Mar 2022 11:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=j/Bh8Zj98hBB5xSqPv13R/Z7SxGWT+ahT2azbHRZfIo=;
        b=1N2YWFqjOquY0kc5YvuPjmOJit2rSSmr1/kEdlDdRE6PzHPpS4CEvdLy9WitaCO0T6
         wkPMYgp0i/V3mGjrC+xI9UmgQLHkQqDkNho+IiP/+9C/fXan5chsx9ovYsvUaLtjf5mt
         BxYYwbU5OVR7OjhxEnWXFHcJmBlfFXzcz7bB2hoqZCHBRXuRpAzsrNrSbt/fT8gl+ll6
         Sdjz4mTFhdyTBjed+2A5ITyU+dBIZGcjtBsZfFv/R2IclDeS90qh7Ck5lnPrJlRAtyK7
         Ct/xvhLiYHlQdaCM6sG+JLTGvEsvirP8yYCE1o9SpYGUIa0LeANdFWVw9F31R4gtDNRy
         Rrug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=j/Bh8Zj98hBB5xSqPv13R/Z7SxGWT+ahT2azbHRZfIo=;
        b=7sUk5RSLgr6F0TWPhfck5gJlR8RonXNMWzBi+ZGJfPTqR59GMWaAKNnxLcHAPq8pwI
         vbVxnBm6U/CMxOK9Wy6Qv5NnneKxnJ0i7IuVIadBHOVQw5CychMGhzCDsd4Gk/5obT57
         7Bd3N8k0BnHHSyzZXYgB9tKCqek1OUCoc9LZMdgymIOkAkQVmKWSdx5yB6FJ0XEAICoD
         NLpf5oHgLGaPd3Uohg6JyDz/rR6jVHj8jTDJIldBEdvoom2YNgPpLfRHAngIQZoWl1nL
         ZrDIGGmuXOEeDa3hGVt9EK6UBstX3bRYSQU8XYNZhDRL4s3Xrj4EHcKRy5TXSOSil8zZ
         ZM6g==
X-Gm-Message-State: AOAM532JCgbrchh/ApmLBju3qIbQIHkinYWVuXA5KKeBCRhwYsL2QInR
        2HMWDUqm2ObUV3aMLGD2Qdu9rHHsgeHb4i9x
X-Google-Smtp-Source: ABdhPJx46DejnGImpVoibW0irLLPXTheLhFbYQpvxjqp69juIunR2+ehHKLjYNK60Dv6CnMJMdmZgg==
X-Received: by 2002:a05:6e02:1a43:b0:2c9:8e7c:ed98 with SMTP id u3-20020a056e021a4300b002c98e7ced98mr9062666ilv.235.1648579218237;
        Tue, 29 Mar 2022 11:40:18 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id o15-20020a92d38f000000b002c9aea3cff9sm4352325ilo.2.2022.03.29.11.40.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Mar 2022 11:40:17 -0700 (PDT)
Message-ID: <89322bd1-5e6f-bcc6-7974-ffd22363a165@kernel.dk>
Date:   Tue, 29 Mar 2022 12:40:17 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: io_uring_prep_openat_direct() and link/drain
Content-Language: en-US
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     io-uring@vger.kernel.org
References: <CAJfpegvVpFbDX5so8EVaHxubZLNQ4bo=myAYopWeRtMs0wa6nA@mail.gmail.com>
 <8145e724-d960-dd85-531e-16e564a02f05@kernel.dk>
 <c8872b69-f042-dc35-fa3d-6862f09a5385@kernel.dk>
 <CAJfpegs1o3HNkpxPa85LmNCoVVk-T2rt3vJXBvRf_M93P+6ouA@mail.gmail.com>
 <115fc7d1-9b9c-712b-e75d-39b2041df437@kernel.dk>
 <CAJfpegs=GcTuXcor-pbhaAxDKeS5XRy5rwTGXUcZM0BYYUK2LA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAJfpegs=GcTuXcor-pbhaAxDKeS5XRy5rwTGXUcZM0BYYUK2LA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/29/22 12:31 PM, Miklos Szeredi wrote:
> On Tue, 29 Mar 2022 at 20:26, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 3/29/22 12:21 PM, Miklos Szeredi wrote:
>>> On Tue, 29 Mar 2022 at 19:04, Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> On 3/29/22 10:08 AM, Jens Axboe wrote:
>>>>> On 3/29/22 7:20 AM, Miklos Szeredi wrote:
>>>>>> Hi,
>>>>>>
>>>>>> I'm trying to read multiple files with io_uring and getting stuck,
>>>>>> because the link and drain flags don't seem to do what they are
>>>>>> documented to do.
>>>>>>
>>>>>> Kernel is v5.17 and liburing is compiled from the git tree at
>>>>>> 7a3a27b6a384 ("add tests for nonblocking accept sockets").
>>>>>>
>>>>>> Without those flags the attached example works some of the time, but
>>>>>> that's probably accidental since ordering is not ensured.
>>>>>>
>>>>>> Adding the drain or link flags make it even worse (fail in casese that
>>>>>> the unordered one didn't).
>>>>>>
>>>>>> What am I missing?
>>>>>
>>>>> I don't think you're missing anything, it looks like a bug. What you
>>>>> want here is:
>>>>>
>>>>> prep_open_direct(sqe);
>>>>> sqe->flags |= IOSQE_IO_LINK;
>>>>> ...
>>>>> prep_read(sqe);
>>>
>>> So with the below merge this works.   But if instead I do
>>>
>>> prep_open_direct(sqe);
>>>  ...
>>> prep_read(sqe);
>>> sqe->flags |= IOSQE_IO_DRAIN;
>>>
>>> than it doesn't.  Shouldn't drain have a stronger ordering guarantee than link?
>>
>> I didn't test that, but I bet it's running into the same kind of issue
>> wrt prep. Are you getting -EBADF? The drain will indeed ensure that
>> _execution_ doesn't start until the previous requests have completed,
>> but it's still prepared before.
>>
>> For your use case, IO_LINK is what you want and that must work.
>>
>> I'll check the drain case just in case, it may in fact work if you just
>> edit the code base you're running now and remove these two lines from
>> io_init_req():
>>
>> if (unlikely(!req->file)) {
>> -        if (!ctx->submit_state.link.head)
>> -                return -EBADF;
>>         req->result = fd;
>>         req->flags |= REQ_F_DEFERRED_FILE;
>> }
>>
>> to not make it dependent on link.head. Probably not a bad idea in
>> general, as the rest of the handlers have been audited for req->file
>> usage in prep.
> 
> Nope, that results in the following Oops:
> 
> BUG: kernel NULL pointer dereference, address: 0000000000000044
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page
> PGD 0 P4D 0
> Oops: 0000 [#1] SMP PTI
> CPU: 3 PID: 1126 Comm: readfiles Not tainted
> 5.17.0-00065-g3287b182c9c3-dirty #623
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> rel-1.15.0-29-g6a62e0cb0dfe-prebuilt.qemu.org 04/01/2014
> RIP: 0010:io_rw_init_file+0x15/0x170
> Code: 00 6d 22 82 0f 95 c0 83 c0 02 c3 66 2e 0f 1f 84 00 00 00 00 00
> 0f 1f 44 00 00 41 55 41 54 55 53 4c 8b 2f 4c 8b 67 58 8b 6f 20 <41> 23
> 75 44 0f 84 28 01 00 00 48 89 fb f6 47 44 01 0f 84 08 01 00
> RSP: 0018:ffffc9000108fba8 EFLAGS: 00010207
> RAX: 0000000000000001 RBX: ffff888103ddd688 RCX: ffffc9000108fc18
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff888103ddd600
> RBP: 0000000000000000 R08: ffffc9000108fbd8 R09: 00007ffffffff000
> R10: 0000000000020000 R11: 000056012e2ce2e0 R12: ffff88810276b800
> R13: 0000000000000000 R14: 0000000000000000 R15: ffff888103ddd600
> FS:  00007f9058d72580(0000) GS:ffff888237d80000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000044 CR3: 0000000100966004 CR4: 0000000000370ee0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  io_read+0x65/0x4d0
>  ? select_task_rq_fair+0x602/0xf20
>  ? newidle_balance.constprop.0+0x2ff/0x3a0
>  io_issue_sqe+0xd86/0x21a0
>  ? __schedule+0x228/0x610
>  ? timerqueue_del+0x2a/0x40
>  io_req_task_submit+0x26/0x100
>  tctx_task_work+0x172/0x4b0
>  task_work_run+0x5c/0x90
>  io_cqring_wait+0x48d/0x790
>  ? io_eventfd_put+0x20/0x20
>  __do_sys_io_uring_enter+0x28d/0x5e0
>  ? __cond_resched+0x16/0x40
>  ? task_work_run+0x61/0x90
>  do_syscall_64+0x3b/0x90
>  entry_SYSCALL_64_after_hwframe+0x44/0xae

Ah yes that makes sense, since I only worried the prep file part up for
links. Forgot about that... Let me test, I'll see if it's feasible to do
for drain and send you an incremental.

-- 
Jens Axboe

