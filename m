Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 575EE5892D5
	for <lists+io-uring@lfdr.de>; Wed,  3 Aug 2022 21:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238466AbiHCTjN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Aug 2022 15:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238444AbiHCTjL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Aug 2022 15:39:11 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE69165AF
        for <io-uring@vger.kernel.org>; Wed,  3 Aug 2022 12:39:09 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id h139so179244iof.12
        for <io-uring@vger.kernel.org>; Wed, 03 Aug 2022 12:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=fSy7JOI2OPrBvYYSmGHOL+R7BpjU4u61ICdJviI28dU=;
        b=UVi/S2oOqwI47l5CWS7rAmwDkC+xVfeWVNsUO2aK6oiFW7r9dbtjz0QDsbNz/S3Wwu
         VMniJDi3d8L6RPlEhMm52w4lgLo4ArrVgxqK1Kpn2ulA3PLzfjBg08arK0NISmUDDymB
         /WtkZBnE1WEFto+Zgk2UuMFf4CX80IrB3XG7PNE0dm6OTPU8oWFT5z2cwC5oWFSt4kVY
         RpzNCWBypdVhu/nPL6/k+lFW7Liuyi6R39nkpgp1hd/ttgiHsWmkLKOrv2XNjWaXhngX
         63P96uw6WlRbRF/czLxVhQDHGul8/QjlKeJZbwPTCHdB3Jkv7ttcQ7UBK+YM8Pyhakue
         bnRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fSy7JOI2OPrBvYYSmGHOL+R7BpjU4u61ICdJviI28dU=;
        b=wyPTuF19DZgo7ME+6j99OiYes9EAlHIKFk5pPrPp3+6lDhCmQZUHxONK9f9mD1/4F3
         NcblJOaGNrZuRELPz/DzNtEfX/RXcojYqQg7chdtYR65A4QMeOX1j5yJVQ1U1CCAobdp
         PuAUeNsBw1cJSHXsrXrJDfBVYknZSpUshSZn3mjBt7XjKyhLe7F0Ml++k1DgsCejj84O
         ux7INIFsU7xP+lwa5vGohWQVqoy7bcd4METAwZNTUu+knJI11nyoJwHpsM2f91o6kx0M
         0fs2hdNMFJ0vxsNsp6XY1fjG4WJF1o6rF8tuzu32VYbee6V2DioTw2zZTE2xqepRs8Y4
         Qy1w==
X-Gm-Message-State: ACgBeo0XkbWgw21O9a+YSi1F7qAJYOhAEnJmhhG96ufk3nDf2K3ly9/D
        qj7ZkhlQ+r5+LVaWsY4AUKF+SQ==
X-Google-Smtp-Source: AA6agR5yz6fayuEmHNxdmTfro1gBVCR4ygOjwcExgpR5dMILeYMqFiapzUwtu7CJooNgvW9kytirsg==
X-Received: by 2002:a05:6638:5a4:b0:342:7040:9a04 with SMTP id b4-20020a05663805a400b0034270409a04mr7965064jar.196.1659555549201;
        Wed, 03 Aug 2022 12:39:09 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id s13-20020a02b14d000000b0034277c336b0sm3856738jah.58.2022.08.03.12.39.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Aug 2022 12:39:08 -0700 (PDT)
Message-ID: <54d7ec45-3f69-294b-7036-b9350cb1ab4c@kernel.dk>
Date:   Wed, 3 Aug 2022 13:39:08 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] audit, io_uring, io-wq: Fix memory leak in io_sq_thread()
 and io_wqe_worker()
Content-Language: en-US
To:     Paul Moore <paul@paul-moore.com>, Peilin Ye <yepeilin.cs@gmail.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Eric Paris <eparis@redhat.com>,
        Peilin Ye <peilin.ye@bytedance.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com
References: <20220803050230.30152-1-yepeilin.cs@gmail.com>
 <CAHC9VhRXypjNgDAwdARZz-md_DaSTs+9BpMik8AzWojG7ChexA@mail.gmail.com>
 <CAHC9VhRYGgCLiWx5LCoqgTj_RW_iQRLrzivWci7_UneN_=rwmw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHC9VhRYGgCLiWx5LCoqgTj_RW_iQRLrzivWci7_UneN_=rwmw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/3/22 1:28 PM, Paul Moore wrote:
> On Wed, Aug 3, 2022 at 9:16 AM Paul Moore <paul@paul-moore.com> wrote:
>> On Wed, Aug 3, 2022 at 1:03 AM Peilin Ye <yepeilin.cs@gmail.com> wrote:
>>>
>>> Currently @audit_context is allocated twice for io_uring workers:
>>>
>>>   1. copy_process() calls audit_alloc();
>>>   2. io_sq_thread() or io_wqe_worker() calls audit_alloc_kernel() (which
>>>      is effectively audit_alloc()) and overwrites @audit_context,
>>>      causing:
>>>
>>>   BUG: memory leak
>>>   unreferenced object 0xffff888144547400 (size 1024):
>>> <...>
>>>     hex dump (first 32 bytes):
>>>       00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00  ................
>>>       00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>>     backtrace:
>>>       [<ffffffff8135cfc3>] audit_alloc+0x133/0x210
>>>       [<ffffffff81239e63>] copy_process+0xcd3/0x2340
>>>       [<ffffffff8123b5f3>] create_io_thread+0x63/0x90
>>>       [<ffffffff81686604>] create_io_worker+0xb4/0x230
>>>       [<ffffffff81686f68>] io_wqe_enqueue+0x248/0x3b0
>>>       [<ffffffff8167663a>] io_queue_iowq+0xba/0x200
>>>       [<ffffffff816768b3>] io_queue_async+0x113/0x180
>>>       [<ffffffff816840df>] io_req_task_submit+0x18f/0x1a0
>>>       [<ffffffff816841cd>] io_apoll_task_func+0xdd/0x120
>>>       [<ffffffff8167d49f>] tctx_task_work+0x11f/0x570
>>>       [<ffffffff81272c4e>] task_work_run+0x7e/0xc0
>>>       [<ffffffff8125a688>] get_signal+0xc18/0xf10
>>>       [<ffffffff8111645b>] arch_do_signal_or_restart+0x2b/0x730
>>>       [<ffffffff812ea44e>] exit_to_user_mode_prepare+0x5e/0x180
>>>       [<ffffffff844ae1b2>] syscall_exit_to_user_mode+0x12/0x20
>>>       [<ffffffff844a7e80>] do_syscall_64+0x40/0x80
>>>
>>> Then,
>>>
>>>   3. io_sq_thread() or io_wqe_worker() frees @audit_context using
>>>      audit_free();
>>>   4. do_exit() eventually calls audit_free() again, which is okay
>>>      because audit_free() does a NULL check.
>>>
>>> Free the old @audit_context first in audit_alloc_kernel(), and delete
>>> the redundant calls to audit_free() for less confusion.
>>>
>>> Fixes: 5bd2182d58e9 ("audit,io_uring,io-wq: add some basic audit support to io_uring")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
>>> ---
>>> Hi all,
>>>
>>> A better way to fix this memleak would probably be checking
>>> @args->io_thread in copy_process()?  Something like:
>>>
>>>     if (args->io_thread)
>>>         retval = audit_alloc_kernel();
>>>     else
>>>         retval = audit_alloc();
>>>
>>> But I didn't want to add another if to copy_process() for this bugfix.
>>> Please suggest, thanks!
>>
>> Thanks for the report and patch!  I'll take a closer look at this
>> today and get back to you.
> 
> I think the best solution to this is simply to remove the calls to
> audit_alloc_kernel() in the io_uring and io-wq code, as well as the
> audit_alloc_kernel() function itself.  As long as create_io_thread()
> ends up calling copy_process to create the new kernel thread the
> audit_context should be allocated correctly.  Peilin Ye, are you able
> to draft a patch to do that and give it a test?
> 
> For those that may be wondering how this happened (I definitely was!),
> it looks like when I first started working on the LSM/audit support
> for io_uring it was before the v5.12-rc1 release when
> create_io_thread() was introduced.  Prior to create_io_thread() it
> appears that io_uring/io-wq wasn't calling into copy_process() and
> thus was not getting an audit_context allocated in the kernel thread's
> task_struct; the solution for those original development drafts was to
> add a call to a new audit_alloc_kernel() which would handle the
> audit_context allocation.  Unfortunately, I didn't notice the move to
> create_io_thread() during development and the redundant
> audit_alloc_kernel() calls remained :/

I agree with your analysis and suggested solution. Post the native io-wq
workers create_io_thread() -> copy_process() is always used for io-wq
(and sqpoll, for that matter).

-- 
Jens Axboe

