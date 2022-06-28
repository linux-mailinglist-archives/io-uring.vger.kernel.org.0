Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32F0455E4CF
	for <lists+io-uring@lfdr.de>; Tue, 28 Jun 2022 15:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346614AbiF1NeL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jun 2022 09:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346646AbiF1Ndz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jun 2022 09:33:55 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77640BF4B
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 06:33:54 -0700 (PDT)
Message-ID: <71863a44-93bc-b222-ec07-0be958c8ed1d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1656423232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UBgCqOrpMqzlJ83SWK6qJq5KV0Zt9EmUvpcN4zVl7i8=;
        b=kLDOHbKxFvSh0A6Isnt2XqnfRl42QjtPEOJXe/4V730Jh4YMHbB4zp9PWKKSUagh56H28S
        M83Xr+bUkKb2oQ2lxRkYVd/1joMm55eBNcTJ6Mt0Zh7m7rqB9QLXv4V8Ch/qcMFMt2PcVM
        r0LZM4E5uqxVJARXf7BzaDLKcr63tV4=
Date:   Tue, 28 Jun 2022 21:33:40 +0800
MIME-Version: 1.0
Subject: Re: [RFC] a new way to achieve asynchronous IO
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, dvernet@fb.com
References: <3d1452da-ecec-fdc7-626c-bcd79df23c92@linux.dev>
 <b297ac50-c336-dabe-b6ee-c067b7f418c7@kernel.dk>
 <1237fa26-3190-7c92-c516-9cf2a750fab4@linux.dev>
 <698e189e-834c-60b0-6cb8-fdad78cd0a49@kernel.dk>
 <9e4dbeaa-609b-8850-2f20-3e48ba6cb386@linux.dev>
In-Reply-To: <9e4dbeaa-609b-8850-2f20-3e48ba6cb386@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/27/22 15:11, Hao Xu wrote:
> On 6/23/22 22:08, Jens Axboe wrote:
>> On 6/23/22 7:31 AM, Hao Xu wrote:
>>> On 6/20/22 21:41, Jens Axboe wrote:
>>>> On 6/20/22 6:01 AM, Hao Xu wrote:
>>>>> Hi,
>>>>> I've some thought on the way of doing async IO. The current model is:
>>>>> (given we are using SQPOLL mode)
>>>>>
>>>>> the sqthread does:
>>>>> (a) Issue a request with nowait/nonblock flag.
>>>>> (b) If it would block, reutrn -EAGAIN
>>>>> (c) The io_uring layer captures this -EAGAIN and wake up/create
>>>>> a io-worker to execute the request synchronously.
>>>>> (d) Try to issue other requests in the above steps again.
>>>>>
>>>>> This implementation has two downsides:
>>>>> (1) we have to find all the block point in the IO stack manually and
>>>>> change them into "nowait/nonblock friendly".
>>>>> (2) when we raise another io-worker to do the request, we submit the
>>>>> request from the very beginning. This isn't a little bit inefficient.
>>>>>
>>>>>
>>>>> While I think we can actually do it in a reverse way:
>>>>> (given we are using SQPOLL mode)
>>>>>
>>>>> the sqthread1 does:
>>>>> (a) Issue a request in the synchronous way
>>>>> (b) If it is blocked/scheduled soon, raise another sqthread2
>>>>> (c) sqthread2 tries to issue other requests in the same way.
>>>>>
>>>>> This solves problem (1), and may solve (2).
>>>>> For (1), we just do the sqthread waken-up at the beginning of 
>>>>> schedule()
>>>>> just like what the io-worker and system-worker do. No need to find all
>>>>> the block point.
>>>>> For (2), we continue the blocked request from where it is blocked when
>>>>> resource is satisfied.
>>>>>
>>>>> What we need to take care is making sure there is only one task
>>>>> submitting the requests.
>>>>>
>>>>> To achieve this, we can maintain a pool of sqthread just like the 
>>>>> iowq.
>>>>>
>>>>> I've done a very simple/ugly POC to demonstrate this:
>>>>>
>>>>> https://github.com/HowHsu/linux/commit/183be142493b5a816b58bd95ae4f0926227b587b 
>>>>>
>>>>>
>>>>> I also wrote a simple test to test it, which submits two sqes, one
>>>>> read(pipe), one nop request. The first one will be block since no data
>>>>> in the pipe. Then a new sqthread was created/waken up to submit the
>>>>> second one and then some data is written to the pipe(by a unrelated
>>>>> user thread), soon the first sqthread is waken up and continues the
>>>>> request.
>>>>>
>>>>> If the idea sounds no fatal issue I'll change the POC to real patches.
>>>>> Any comments are welcome!
>>>>
>>>> One thing I've always wanted to try out is kind of similar to this, but
>>>> a superset of it. Basically io-wq isn't an explicit offload mechanism,
>>>> it just happens automatically if the issue blocks. This applies to both
>>>> SQPOLL and non-SQPOLL.
>>>>
>>>> This takes a page out of the old syslet/threadlet that Ingo Molnar did
>>>> way back in the day [1], but it never really went anywhere. But the
>>>> pass-on-block primitive would apply very nice to io_uring.
>>>
>>> I've read a part of the syslet/threadlet patchset, seems it has
>>> something that I need, my first idea about the new iowq offload is
>>> just like syslet----if blocked, trigger a new worker, deliver the
>>> context to it, and then update the current context so that we return
>>> to the place of sqe submission. But I just didn't know how to do it.
>>
>> Exactly, what you mentioned was very close to what I had considered in
>> the past, and what the syslet/threadlet attempted to do. Except it flips
>> it upside down a bit, which I do think is probably the saner way to do
>> it rather than have the original block and fork a new one.
>>
>>> By the way, may I ask why the syslet/threadlet is not merged to the
>>> mainline. The mail thread is very long, haven't gotten a chance to
>>> read all of it.
>>
>> Not quite sure, it's been a long time. IMHO it's a good idea looking for
>> the right interface, which we now have. So the time may be ripe to do
>> something like this, finally.
> 
> I've been blocked by an issue:
> if we deliver context from task a to b, we may have no ways to wake it
> up... because when the resource which blocks a is released by another
> task like c, c wakes up a, not b.
> If we want to make it work, we have to deliver the struct task_struct
> as well. That means the original task uses a new task_struct and the
> new task uses the old one. And in the meanwhile we have to maintain
> the pid, parent task .etc stuff.(since we swap the task_struct, the
> pid and other stuff also changed).
> Any thoughts?
> 

Just ignore this, seems I misunderstood something..

