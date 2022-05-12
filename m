Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17032525287
	for <lists+io-uring@lfdr.de>; Thu, 12 May 2022 18:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245577AbiELQ2T (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 May 2022 12:28:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241673AbiELQ2S (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 May 2022 12:28:18 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31AB25C846
        for <io-uring@vger.kernel.org>; Thu, 12 May 2022 09:28:17 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id d3so3889295ilr.10
        for <io-uring@vger.kernel.org>; Thu, 12 May 2022 09:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=F8e4nBOXEBYzuB2TiabqOJov2P2+/jlrtrBf4ASMEek=;
        b=cDr2O5XkmwaQaitaktkrmAKV2BXiUT77H5rc4k7uG1MzeuHP3kmfbI/4hT691L0G0f
         zAAKX8nbMORB99lNRu8acPVR+U9tnYLCM8IvZlrWRI5du9veQM7re5lzNOfDxJw2lR7E
         rcrQo9iboKk89yBzvkgtB1GZ2i6Qon3oLNukALDLkeYA4Vi+hIkFItCgn/hy+JsROixt
         bSEKNI0+Pd8es4unjAQYLqjNZXlbGk32TDkaN7l3dTbva54ntF84vRi5INkezrB7+HSc
         EgvQnjCkZia855JzbeV89fJqz50UjeSISj6BooENmi4YMNPkBn3vzEBFkOi3wZrNKFU/
         riAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=F8e4nBOXEBYzuB2TiabqOJov2P2+/jlrtrBf4ASMEek=;
        b=7QpChaCMwekfgJZyARSpyRzTmztKN37LXmF4aA+3hxavXT13TvC5f7eAZlxMKO07Ue
         /JcIh/U7BNQtKsInk+TfW840PUiFY8E12t35kT/eHZMBOi0n/aJXnJI+W077X1FvMcUm
         j0rXZNF28+TbE9TxAwOoq3BLPHgWchpzYvde12SSZmBzkK9KN2wWNhPxgzAfzqfExcsL
         D1p1ua++1JxjvGR+JFyZDmidjg9tr/gQKTwIggRp76GHEEas/728tmmnEpvh4zPtLGeC
         Q+IW4WYJe+3WYKIhCn5FX3lP+Uk1E7hGaOhcnCA3SgfjlI96rJ/yw2stVVHjQkvLNZRX
         TZYQ==
X-Gm-Message-State: AOAM533IJCe9FKwDWcQ1C5WHmFVqvLXk50eiWR0dvipYwibiJKWyMN6G
        bSHha6RADeR0abxBlcZ6NW2/InuW1WVjxA==
X-Google-Smtp-Source: ABdhPJyYSZHJhrowkPF+MIlJZxOFT2JiInUBu622EkuZsy4X+ezBCpNEc1AOC9BmjORO5gxoJ/xrag==
X-Received: by 2002:a05:6e02:2190:b0:2cf:8529:e291 with SMTP id j16-20020a056e02219000b002cf8529e291mr489520ila.22.1652372896461;
        Thu, 12 May 2022 09:28:16 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id i24-20020a023b58000000b0032b3a781750sm1505388jaf.20.2022.05.12.09.28.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 May 2022 09:28:15 -0700 (PDT)
Message-ID: <9c966ff9-ceb2-4fcd-ce0d-1639f2965b38@kernel.dk>
Date:   Thu, 12 May 2022 10:28:14 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: Short sends returned in IORING
Content-Language: en-US
To:     Constantine Gavrilov <constantine.gavrilov@gmail.com>
Cc:     io-uring@vger.kernel.org
References: <CAAL3td0UD3Ht-rCpR5xUfmOLzeEzRSedCVXH4nTQKLR1b16+vA@mail.gmail.com>
 <6fc53990-1814-a45d-7c05-a4385246406c@kernel.dk>
 <CAAL3td3Em=MBPa9iJitYTAkndymzuj2DbSnbQRf=0Emsr5qHVw@mail.gmail.com>
 <744d4b58-e7df-a5fb-dfba-77fe952fe1f8@kernel.dk>
 <71956172-5406-0636-060d-a7c123a2bfab@kernel.dk>
 <CAAL3td2X4a9RESdSt_xFxNN3mYHBUn88cjbUH9O5wAfL86iB1Q@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAAL3td2X4a9RESdSt_xFxNN3mYHBUn88cjbUH9O5wAfL86iB1Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/11/22 8:56 AM, Constantine Gavrilov wrote:
> On Wed, May 4, 2022 at 6:55 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 5/4/22 9:28 AM, Jens Axboe wrote:
>>> On 5/4/22 9:21 AM, Constantine Gavrilov wrote:
>>>> On Wed, May 4, 2022 at 4:54 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>
>>>>> On 5/3/22 5:05 PM, Constantine Gavrilov wrote:
>>>>>> Jens:
>>>>>>
>>>>>> This is related to the previous thread "Fix MSG_WAITALL for
>>>>>> IORING_OP_RECV/RECVMSG".
>>>>>>
>>>>>> We have a similar issue with TCP socket sends. I see short sends
>>>>>> regarding of the method (I tried write, writev, send, and sendmsg
>>>>>> opcodes, while using MSG_WAITALL for send and sendmsg). It does not
>>>>>> make a difference.
>>>>>>
>>>>>> Most of the time, sends are not short, and I never saw short sends
>>>>>> with loopback and my app. But on real network media, I see short
>>>>>> sends.
>>>>>>
>>>>>> This is a real problem, since because of this it is not possible to
>>>>>> implement queue size of > 1 on a TCP socket, which limits the benefit
>>>>>> of IORING. When we have a short send, the next send in queue will
>>>>>> "corrupt" the stream.
>>>>>>
>>>>>> Can we have complete send before it completes, unless the socket is
>>>>>> disconnected?
>>>>>
>>>>> I'm guessing that this happens because we get a task_work item queued
>>>>> after we've processed some of the send, but not all. What kernel are you
>>>>> using?
>>>>>
>>>>> This:
>>>>>
>>>>> https://git.kernel.dk/cgit/linux-block/commit/?h=for-5.19/io_uring&id=4c3c09439c08b03d9503df0ca4c7619c5842892e
>>>>>
>>>>> is queued up for 5.19, would be worth trying.
>>>>>
>>>>> --
>>>>> Jens Axboe
>>>>>
>>>>
>>>> Jens:
>>>>
>>>> Thank you for your reply.
>>>>
>>>> The kernel is 5.17.4-200.fc35.x86_64. I have looked at the patch. With
>>>> the solution in place, I am wondering whether it will be possible to
>>>> use multiple uring send IOs on the same socket. I expect that Linux
>>>> TCP will serialize multiple send operations on the same socket. I am
>>>> not sure it happens with uring (meaning that socket is blocked for
>>>> processing a new IO until the pending IO completes). Do I need
>>>> IOSQE_IO_DRAIN / IOSQE_IO_LINK for this to work? Would not be optimal
>>>> because of multiple different sockets in the same uring. While I
>>>> already have a workaround in the form of a "software" queue for
>>>> streaming data on TCP sockets, I would rather have kernel to do
>>>> "native" queueing in sockets layer, and have exrtra CPU cycles
>>>> available to the  application.
>>>
>>> The patch above will mess with ordering potentially. If the cause is as
>>> I suspect, task_work causing it to think it's signaled, then the better
>>> approach may indeed be to just flush that work and retry without
>>> re-queueing the current one. I can try a patch against 5.18 if you are
>>> willing and able to test?
>>
>> You can try something like this, if you run my for-5.19/io_uring branch.
>> I'd be curious to know if this solves the short send issue for you.
>>
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index f6b6db216478..b835e80be1fa 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -5684,6 +5684,7 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
>>         if (flags & MSG_WAITALL)
>>                 min_ret = iov_iter_count(&kmsg->msg.msg_iter);
>>
>> +retry:
>>         ret = __sys_sendmsg_sock(sock, &kmsg->msg, flags);
>>
>>         if (ret < min_ret) {
>> @@ -5694,6 +5695,8 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
>>                 if (ret > 0 && io_net_retry(sock, flags)) {
>>                         sr->done_io += ret;
>>                         req->flags |= REQ_F_PARTIAL_IO;
>> +                       if (io_run_task_work())
>> +                               goto retry;
>>                         return io_setup_async_msg(req, kmsg);
>>                 }
>>                 req_set_fail(req);
>> @@ -5744,6 +5747,7 @@ static int io_send(struct io_kiocb *req, unsigned int issue_flags)
>>                 min_ret = iov_iter_count(&msg.msg_iter);
>>
>>         msg.msg_flags = flags;
>> +retry:
>>         ret = sock_sendmsg(sock, &msg);
>>         if (ret < min_ret) {
>>                 if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
>> @@ -5755,6 +5759,8 @@ static int io_send(struct io_kiocb *req, unsigned int issue_flags)
>>                         sr->buf += ret;
>>                         sr->done_io += ret;
>>                         req->flags |= REQ_F_PARTIAL_IO;
>> +                       if (io_run_task_work())
>> +                               goto retry;
>>                         return -EAGAIN;
>>                 }
>>                 req_set_fail(req);
>>
>> --
>> Jens Axboe
>>
> 
> Jens:
> 
> I was able to test the first change on the top of Linus kernel git
> (5.18.0-rc6).
> 
> I do not get short sends anymore, but I get corruption in  sent
> packets (corruption is detected by the receiver). It looks like short
> sends handled by the patch intermix data from multiple send SQEs in
> the stream, so ordering of multiple SQEs in URING becomes broken.

Unless you specifically ask for ordering (eg using IOSQE_IO_LINK), then
there is no guaranteed ordering for sends. So it's quite possible to end
up with the scenario you describe, where you end up with interleaved
data from two requests if they are not able to send out all their data
in one go (eg running out of space).


-- 
Jens Axboe

