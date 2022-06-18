Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDB0B5504E1
	for <lists+io-uring@lfdr.de>; Sat, 18 Jun 2022 14:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235997AbiFRMuZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Jun 2022 08:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235949AbiFRMuZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Jun 2022 08:50:25 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B7E1D1
        for <io-uring@vger.kernel.org>; Sat, 18 Jun 2022 05:50:23 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id g8so5983915plt.8
        for <io-uring@vger.kernel.org>; Sat, 18 Jun 2022 05:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=eF0v17vLkZWM5AAJ2UO/KHPqRXhwdD2302KiIO2KKhM=;
        b=beo5U1Y4WMjIfQwCIBD3PfYwwjJbCImHaVJY9HTuK8V6VxuF1i7e7bCt47QzPIL8Yp
         YWo5A9TvbPam4sUiF+BDFTEZ0sbQuryTCVltsfdCFhtr37pyWobhveDrm62yZTxnbIe+
         lwGZEnPl/8abgHnGe2u5ZC9gECSJTyw8NL7i8oshUfXf4Era55k04RGL7pZWZKRhVRma
         HHcaFz/5fRoEFeG+uHR5FTiWp+HqY5JPSthA8qd9TkUhWI7KD6pHtp8/OweOBnxOtdZG
         EtbBJB/rrIEf+l9lIqrh5K+iu1CW+fGAAlE+xiixW70nAUz+E/Kd2GNMru5wZCmMNvix
         2Tpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=eF0v17vLkZWM5AAJ2UO/KHPqRXhwdD2302KiIO2KKhM=;
        b=FyG+FRKzA3ILornLEJRjwCmVYxJU8Xx62XojmXJh9mEYIGm+diUBIwwIcLX0OQxNBT
         Yet/M8IzObPAY9/um6oJuUDyH8ggt+ybtB66M5eMyx87eXW281R3464QYQpk9lr+BZrh
         OKGsDRTiqFUYwnwwmi0bsaFSVsT344mQm6Grir0nHNC1Zq93M7+Tffho30j+S8ZkhpS6
         Hay09peuRwKGCNVMkFn0Gj/TY51zygM+Xd3l/B7Wz8qcGlmP0vwMyYCD2LlO3le6VB7o
         PQS08BAoL5rzDO8bzPL2jLTuhX6X/5DJyWvpFcNvuramZFSEO4DoSKJPV95KcGU3a2XQ
         /CRQ==
X-Gm-Message-State: AJIora9iENWM9DnP2RsD73alRNo5SSZdBCbDbTqdJ7SqHRkvJ8L2g8jO
        WLi49TomU5u20A6j50+37M9fcg==
X-Google-Smtp-Source: AGRyM1taC/2qS/3HbwTig78fMq/7QiW86UlfWtfiRwKyPw7HbI18RF21mIeDrzn9IE05mAmOe4ORvA==
X-Received: by 2002:a17:90a:430a:b0:1ea:e7f4:9f59 with SMTP id q10-20020a17090a430a00b001eae7f49f59mr15363701pjg.75.1655556622567;
        Sat, 18 Jun 2022 05:50:22 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d14-20020a17090ad3ce00b001e87bd6f6c2sm7052997pjw.50.2022.06.18.05.50.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jun 2022 05:50:22 -0700 (PDT)
Message-ID: <3eb8c4d5-5e55-2918-01ee-091fa635e950@kernel.dk>
Date:   Sat, 18 Jun 2022 06:50:20 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 2/2] io_uring: add support for passing fixed file
 descriptors
Content-Language: en-US
To:     Hao Xu <hao.xu@linux.dev>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220617134504.368706-1-axboe@kernel.dk>
 <20220617134504.368706-3-axboe@kernel.dk>
 <37a2034d-6cc1-ccf7-53d3-a334e54c3779@linux.dev>
 <0890d4f2-1f9e-9aa3-c98c-9e415f0dc5d7@kernel.dk>
 <db6d5ce5-5445-d095-8000-3000461a37e7@linux.dev>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <db6d5ce5-5445-d095-8000-3000461a37e7@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/18/22 6:47 AM, Hao Xu wrote:
> On 6/18/22 19:34, Jens Axboe wrote:
>> On 6/18/22 5:02 AM, Hao Xu wrote:
>>> On 6/17/22 21:45, Jens Axboe wrote:
>>>> With IORING_OP_MSG_RING, one ring can send a message to another ring.
>>>> Extend that support to also allow sending a fixed file descriptor to
>>>> that ring, enabling one ring to pass a registered descriptor to another
>>>> one.
>>>>
>>>> Arguments are extended to pass in:
>>>>
>>>> sqe->addr3    fixed file slot in source ring
>>>> sqe->file_index    fixed file slot in destination ring
>>>>
>>>> IORING_OP_MSG_RING is extended to take a command argument in sqe->addr.
>>>> If set to zero (or IORING_MSG_DATA), it sends just a message like before.
>>>> If set to IORING_MSG_SEND_FD, a fixed file descriptor is sent according
>>>> to the above arguments.
>>>>
>>>> Undecided:
>>>>      - Should we post a cqe with the send, or require that the sender
>>>>        just link a separate IORING_OP_MSG_RING? This makes error
>>>>        handling easier, as we cannot easily retract the installed
>>>>        file descriptor if the target CQ ring is full. Right now we do
>>>>        fill a CQE. If the request completes with -EOVERFLOW, then the
>>>>        sender must re-send a CQE if the target must get notified.
>>>
>>> Hi Jens,
>>> Since we are have open/accept direct feature, this may be useful. But I
>>> just can't think of a real case that people use two rings and need to do
>>> operations to same fd.
>>
>> The two cases that people bring up as missing for direct descriptors
>> that you can currently do with a real fd is:
>>
>> 1) Server needs to be shutdown or restarted, pass file descriptors to
>>     another onei
>>
>> 2) Backend is split, and one accepts connections, while others then get
>>     the fd passed and handle the actual connection.
>>
>> Both of those are classic SCM_RIGHTS use cases, and it's not possible to
>> support them with direct descriptors today.
> 
> I see, thanks for detail explanation.

I should put that in the commit message in fact. Will do so.

>>> Assume there are real cases, then filling a cqe is necessary since users
>>> need to first make sure the desired fd is registered before doing
>>> something to it.
>>
>> Right, my quesion here was really whether it should be bundled with the
>> IORING_MSG_SEND_FD operation, or whether the issuer of that should also
>> be responsible for then posting a "normal" IORING_OP_MSG_SEND to the
>> target ring to notify it if the fact that an fd has been sent to it.
>>
>> If the operation is split like the latter, then it makes the error
>> handling a bit easier as we eliminate one failing part of the existing
>> MSG_SEND_FD.
>>
>> You could then also pass a number of descriptors and then post a single
>> OP_MSG_SEND with some data that tells you which descriptors were passed.
>>
>> For the basic use case of just passing a single descriptor, what the
>> code currently does is probably the sanest approach - send the fd, post
>> a cqe.
>>
>>> A downside is users have to take care to do fd delivery especially
>>> when slot resource is in short supply in target_ctx.
>>>
>>>                  ctx                            target_ctx
>>>      msg1(fd1 to target slot x)
>>>
>>>      msg2(fd2 to target slot x)
>>>
>>>                                               get cqe of msg1
>>>                                    do something to fd1 by access slot x
>>>
>>>
>>> the msg2 is issued not at the right time. In short not only ctx needs to
>>> fill a cqe to target_ctx to inform that the file has been registered
>>> but also the target_ctx has to tell ctx that "my slot x is free now
>>> for you to deliver fd". So I guess users are inclined to allocate a
>>> big fixed table and deliver fds to target_ctx in different slots,
>>> Which is ok but anyway a limitation.
>>
>> I suspect the common use case would be to use the alloc feature, since
>> the sender generally has no way of knowing which slots are free on the
>> target ring.
> 
> I mean the sender may not easily know which value to set for
> msg->dst_fd not about the alloc feature.

But isn't that the same? The sender may indeed not have any clue, so the
expected use case is to say "don't care where it ends up, just give me a
free slot".

-- 
Jens Axboe

