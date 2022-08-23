Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E57959EC65
	for <lists+io-uring@lfdr.de>; Tue, 23 Aug 2022 21:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232326AbiHWTeD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Aug 2022 15:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232215AbiHWTdp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Aug 2022 15:33:45 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAA6B92F63
        for <io-uring@vger.kernel.org>; Tue, 23 Aug 2022 11:27:11 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id h78so11573280iof.13
        for <io-uring@vger.kernel.org>; Tue, 23 Aug 2022 11:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=vvZ+6YfB5+idgplC7NLCltNGeNPQRdHTy8X0/J0b+yc=;
        b=pHjgdw6272fXR3NG+RiZ95v7+6n04PYMc+MwIn8sgcAYtUAh9zX0lbUZ7iCnhP6L1e
         qrXvnFMS1OtkD1OYVHm1LD/BS950cgO+xZLMf36t5wIBi1e327llTZxEDAgVwLSACG2N
         oyzuiUv8jTmjTKFFZjgqZEYMFD7FMlOdrnMs4mBHr5/mACp9eDI3Q8lbn66F1iQSVJgU
         9YpYyvRpDekh7c9/ZhPbr1GZCcNatdryuo+qYnzHzi2qgtUvgxMXD5qGHWQXXkDxq4Vp
         iArbFzBsb0nN1kRkBewpkau02EDpR0JwMYjINpoclePIzuAvlTdJlCkrnyDUaLojIK0u
         6YVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=vvZ+6YfB5+idgplC7NLCltNGeNPQRdHTy8X0/J0b+yc=;
        b=mTXUxo0kdMjeSw7P2hoWvUIoevlaJBljHsas2oYx3Og9eLtdfxwfCsYhh/xQ/NvMA/
         s7xcGXC3Z+6WBnfoL3wK1CgaRih/MjvDCGzoqGilyt3S8gRavLYbVG0t8MvdTc53gdtR
         kCuEFfMijXSqVCPucToyKHHkKEorHANYhpXFQwGz1f7gCfkxipGQFddABKRYS7FEZLBp
         sll5RArHgGRRAd5U8Ez/n+eoJG9J+BIwOgK5OMBqkERy9IR7gqNxXDy75wGZ1wVq0/XF
         20zB5EfnbpxzMOFVZtJbRiDb3Q6awAmOGZ5+v4ACZftQNvAvpEfUay5AVfeCiWZdAOhy
         w7DQ==
X-Gm-Message-State: ACgBeo0gYMsaO+5XyReyFj9NYMY7BjxHR2kn3H6MvYZ3BOKJM3TWCy6E
        Rz3TDgGAPM57zeiTiQv78HOnTQ==
X-Google-Smtp-Source: AA6agR7DhNYSUdgGr9FzRwaAGYMr4Mklx8mLgtzrQtfHwuCPCqcTZF5/fCEZN9V7KRH3whMk6Q3jvA==
X-Received: by 2002:a05:6638:430d:b0:343:69f4:2016 with SMTP id bt13-20020a056638430d00b0034369f42016mr12779119jab.90.1661279230964;
        Tue, 23 Aug 2022 11:27:10 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id cn11-20020a0566383a0b00b003482878ec91sm5971640jab.16.2022.08.23.11.27.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Aug 2022 11:27:08 -0700 (PDT)
Message-ID: <654cb5de-a563-b812-a435-d9b435cee334@kernel.dk>
Date:   Tue, 23 Aug 2022 12:27:06 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH 2/2] coredump: Allow coredumps to pipes to work with
 io_uring
Content-Language: en-US
To:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Olivier Langlois <olivier@trillion01.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        io-uring@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <192c9697e379bf084636a8213108be6c3b948d0b.camel@trillion01.com>
 <9692dbb420eef43a9775f425cb8f6f33c9ba2db9.camel@trillion01.com>
 <87h7i694ij.fsf_-_@disp2133> <1b519092-2ebf-3800-306d-c354c24a9ad1@gmail.com>
 <b3e43e07c68696b83a5bf25664a3fa912ba747e2.camel@trillion01.com>
 <13250a8d-1a59-4b7b-92e4-1231d73cbdda@gmail.com>
 <878rw9u6fb.fsf@email.froward.int.ebiederm.org>
 <303f7772-eb31-5beb-2bd0-4278566591b0@gmail.com>
 <87ilsg13yz.fsf@email.froward.int.ebiederm.org>
 <8218f1a245d054c940e25142fd00a5f17238d078.camel@trillion01.com>
 <a29a1649-5e50-4221-9f44-66a35fbdff80@kernel.dk>
 <87y1wnrap0.fsf_-_@email.froward.int.ebiederm.org>
 <87mtd3rals.fsf_-_@email.froward.int.ebiederm.org>
 <61abfb5a517e0ee253b0dc7ba9cd32ebd558bcb0.camel@trillion01.com>
 <bb423622f97826f483100a1a7f20ce10a9090158.camel@trillion01.com>
 <875yiisttu.fsf@email.froward.int.ebiederm.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <875yiisttu.fsf@email.froward.int.ebiederm.org>
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

On 8/23/22 12:22 PM, Eric W. Biederman wrote:
> Olivier Langlois <olivier@trillion01.com> writes:
> 
>> On Mon, 2022-08-22 at 17:16 -0400, Olivier Langlois wrote:
>>>
>>> What is stopping the task calling do_coredump() to be interrupted and
>>> call task_work_add() from the interrupt context?
>>>
>>> This is precisely what I was experiencing last summer when I did work
>>> on this issue.
>>>
>>> My understanding of how async I/O works with io_uring is that the
>>> task
>>> is added to a wait queue without being put to sleep and when the
>>> io_uring callback is called from the interrupt context,
>>> task_work_add()
>>> is called so that the next time io_uring syscall is invoked, pending
>>> work is processed to complete the I/O.
>>>
>>> So if:
>>>
>>> 1. io_uring request is initiated AND the task is in a wait queue
>>> 2. do_coredump() is called before the I/O is completed
>>>
>>> IMHO, this is how you end up having task_work_add() called while the
>>> coredump is generated.
>>>
>> I forgot to add that I have experienced the issue with TCP/IP I/O.
>>
>> I suspect that with a TCP socket, the race condition window is much
>> larger than if it was disk I/O and this might make it easier to
>> reproduce the issue this way...
> 
> I was under the apparently mistaken impression that the io_uring
> task_work_add only comes from the io_uring userspace helper threads.
> Those are definitely suppressed by my change.
> 
> Do you have any idea in the code where io_uring code is being called in
> an interrupt context?  I would really like to trace that code path so I
> have a better grasp on what is happening.
> 
> If task_work_add is being called from interrupt context then something
> additional from what I have proposed certainly needs to be done.

task_work may come from the helper threads, but generally it does not.
One example would be doing a read from a socket. There's no data there,
poll is armed to trigger a retry. When we get the poll notification that
there's now data to be read, then we kick that off with task_work. Since
it's from the poll handler, it can trigger from interrupt context. See
the path from io_uring/poll.c:io_poll_wake() -> __io_poll_execute() ->
io_req_task_work_add() -> task_work_add().

It can also happen for regular IRQ based reads from regular files, where
the completion is actually done via task_work added from the potentially
IRQ based completion path.

-- 
Jens Axboe
