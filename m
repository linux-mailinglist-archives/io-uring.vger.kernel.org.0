Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB6E95504FF
	for <lists+io-uring@lfdr.de>; Sat, 18 Jun 2022 15:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbiFRNJU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Jun 2022 09:09:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237147AbiFRNJQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Jun 2022 09:09:16 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67CD9175A0
        for <io-uring@vger.kernel.org>; Sat, 18 Jun 2022 06:09:06 -0700 (PDT)
Message-ID: <337a2a6a-1237-0485-2ca5-745ca6d27696@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1655557745;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RQTJMmwSP+9bbQepMEMvHvxSpkqVSN3FY5QewsEG644=;
        b=CZDt4SlSFOFTWaAgA1wHGG/qTkAVK3795GX1+vRdMxvcoonv82BRf/45ZwPoS5/HblCg6N
        NX9sOY8oImMUptgligcX3K+l3Pia63s9/d4Bo9wU56WsGXQIz3HzHWleXObPpm5Kh3RVBj
        zFQil+x5iv+tKAYgFNuJSddF4fKUgE4=
Date:   Sat, 18 Jun 2022 21:09:00 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] io_uring: add support for passing fixed file
 descriptors
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220617134504.368706-1-axboe@kernel.dk>
 <20220617134504.368706-3-axboe@kernel.dk>
 <37a2034d-6cc1-ccf7-53d3-a334e54c3779@linux.dev>
 <0890d4f2-1f9e-9aa3-c98c-9e415f0dc5d7@kernel.dk>
 <db6d5ce5-5445-d095-8000-3000461a37e7@linux.dev>
 <3eb8c4d5-5e55-2918-01ee-091fa635e950@kernel.dk>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <3eb8c4d5-5e55-2918-01ee-091fa635e950@kernel.dk>
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

On 6/18/22 20:50, Jens Axboe wrote:
> On 6/18/22 6:47 AM, Hao Xu wrote:
>> On 6/18/22 19:34, Jens Axboe wrote:
>>> On 6/18/22 5:02 AM, Hao Xu wrote:
>>>> On 6/17/22 21:45, Jens Axboe wrote:
>>>>> With IORING_OP_MSG_RING, one ring can send a message to another ring.
>>>>> Extend that support to also allow sending a fixed file descriptor to
>>>>> that ring, enabling one ring to pass a registered descriptor to another
>>>>> one.
>>>>>
>>>>> Arguments are extended to pass in:
>>>>>
>>>>> sqe->addr3    fixed file slot in source ring
>>>>> sqe->file_index    fixed file slot in destination ring
>>>>>
>>>>> IORING_OP_MSG_RING is extended to take a command argument in sqe->addr.
>>>>> If set to zero (or IORING_MSG_DATA), it sends just a message like before.
>>>>> If set to IORING_MSG_SEND_FD, a fixed file descriptor is sent according
>>>>> to the above arguments.
>>>>>
>>>>> Undecided:
>>>>>       - Should we post a cqe with the send, or require that the sender
>>>>>         just link a separate IORING_OP_MSG_RING? This makes error
>>>>>         handling easier, as we cannot easily retract the installed
>>>>>         file descriptor if the target CQ ring is full. Right now we do
>>>>>         fill a CQE. If the request completes with -EOVERFLOW, then the
>>>>>         sender must re-send a CQE if the target must get notified.
>>>>
>>>> Hi Jens,
>>>> Since we are have open/accept direct feature, this may be useful. But I
>>>> just can't think of a real case that people use two rings and need to do
>>>> operations to same fd.
>>>
>>> The two cases that people bring up as missing for direct descriptors
>>> that you can currently do with a real fd is:
>>>
>>> 1) Server needs to be shutdown or restarted, pass file descriptors to
>>>      another onei
>>>
>>> 2) Backend is split, and one accepts connections, while others then get
>>>      the fd passed and handle the actual connection.
>>>
>>> Both of those are classic SCM_RIGHTS use cases, and it's not possible to
>>> support them with direct descriptors today.
>>
>> I see, thanks for detail explanation.
> 
> I should put that in the commit message in fact. Will do so.
> 
>>>> Assume there are real cases, then filling a cqe is necessary since users
>>>> need to first make sure the desired fd is registered before doing
>>>> something to it.
>>>
>>> Right, my quesion here was really whether it should be bundled with the
>>> IORING_MSG_SEND_FD operation, or whether the issuer of that should also
>>> be responsible for then posting a "normal" IORING_OP_MSG_SEND to the
>>> target ring to notify it if the fact that an fd has been sent to it.
>>>
>>> If the operation is split like the latter, then it makes the error
>>> handling a bit easier as we eliminate one failing part of the existing
>>> MSG_SEND_FD.
>>>
>>> You could then also pass a number of descriptors and then post a single
>>> OP_MSG_SEND with some data that tells you which descriptors were passed.

[1]

>>>
>>> For the basic use case of just passing a single descriptor, what the
>>> code currently does is probably the sanest approach - send the fd, post
>>> a cqe.

I think it's fine to keep it like this, since we can achieve [1] by a
GROUP_DELIVER flag and set cqe_skip flag for send msg request when it
turns out [1] is indeed necessary.

>>>
>>>> A downside is users have to take care to do fd delivery especially
>>>> when slot resource is in short supply in target_ctx.
>>>>
>>>>                   ctx                            target_ctx
>>>>       msg1(fd1 to target slot x)
>>>>
>>>>       msg2(fd2 to target slot x)
>>>>
>>>>                                                get cqe of msg1
>>>>                                     do something to fd1 by access slot x
>>>>
>>>>
>>>> the msg2 is issued not at the right time. In short not only ctx needs to
>>>> fill a cqe to target_ctx to inform that the file has been registered
>>>> but also the target_ctx has to tell ctx that "my slot x is free now
>>>> for you to deliver fd". So I guess users are inclined to allocate a
>>>> big fixed table and deliver fds to target_ctx in different slots,
>>>> Which is ok but anyway a limitation.
>>>
>>> I suspect the common use case would be to use the alloc feature, since
>>> the sender generally has no way of knowing which slots are free on the
>>> target ring.
>>
>> I mean the sender may not easily know which value to set for
>> msg->dst_fd not about the alloc feature.
> 
> But isn't that the same? The sender may indeed not have any clue, so the
> expected use case is to say "don't care where it ends up, just give me a
> free slot".
> 

Ah, yes, I read your previous words wrong.
