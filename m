Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3524B599C34
	for <lists+io-uring@lfdr.de>; Fri, 19 Aug 2022 14:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349001AbiHSMhS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Aug 2022 08:37:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348954AbiHSMhP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Aug 2022 08:37:15 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D82BA1015AE
        for <io-uring@vger.kernel.org>; Fri, 19 Aug 2022 05:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=YvNnItQoKDlTlhSGS0by87pJYLY8YXz/6Vd+Bo+ZBFE=; b=GjmwQcVhWE9XozbE6fit+OqHkX
        FrAtY+RIf1RMjDnlSUolnHLO/cMqPDCUdYNrMEHlCERmCWh9cUUdIdwtNPCs2+Vv6O+qmst9VXC1+
        5I80pZKnhaSPFzSIsj6ou1VZoj2Clm8YHhy6TrwIGL6w0HCr1G/SdBNY2FYfNpQNxdCFsB1/vCQbX
        Is9hj/QMWDBoIPFwPBpLSBpkG4LFP298e+SCjAvd0ElyyTO/i4mLc/M0ILruXX7y5IJtcnMbx4tEg
        lobbPjR5uXE4lM9Bv/i7x9P8Cs4c8ipO7GF5nNk+QcIaJG1QbEvj3t+BXp5vJ/vVmGOIKCG7s6vSX
        JnJosbccB2Zg7HbD07o/sRI37c3PnQ3eVCi7cCZmeF11EKpRxto3ZCdENYRKq2EWXQhiQC9D0oD2f
        TCwcMegD6Z81MXpDCZGQz3itvAKb5gK3Lx1YMJgiDRYtkVgaHtyJL7lwqWDx477fobxxjBlq0bcZz
        dD+lp2raQpStHjhMqzA9YQO/;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oP1FD-000qcu-1s; Fri, 19 Aug 2022 12:36:59 +0000
Message-ID: <697172bd-24fa-966c-e76d-f52812f9a4b0@samba.org>
Date:   Fri, 19 Aug 2022 14:36:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Dylan Yudaken <dylany@fb.com>
References: <cover.1660635140.git.asml.silence@gmail.com>
 <6aa0c662a3fec17a1ade512e7bbb519aa49e6e4d.1660635140.git.asml.silence@gmail.com>
 <bf3d5a0f-c337-f6f3-8bf4-b8665f92acaa@samba.org>
 <9b998187-b985-2938-1494-0bc8c189a3b6@gmail.com>
 <5fc449bd-9625-4ff0-5f1b-a9fbea721716@samba.org>
 <a5fc6451-94a8-edbf-d9f7-a05eb49b0113@gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [RFC 2/2] io_uring/net: allow to override notification tag
In-Reply-To: <a5fc6451-94a8-edbf-d9f7-a05eb49b0113@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Am 19.08.22 um 13:42 schrieb Pavel Begunkov:
> On 8/18/22 19:13, Stefan Metzmacher wrote:
>> Am 17.08.22 um 14:42 schrieb Pavel Begunkov:
>>> On 8/16/22 09:23, Stefan Metzmacher wrote:
>>>> Am 16.08.22 um 09:42 schrieb Pavel Begunkov:
>>>>> Considering limited amount of slots some users struggle with
>>>>> registration time notification tag assignment as it's hard to manage
>>>>> notifications using sequence numbers. Add a simple feature that copies
>>>>> sqe->user_data of a send(+flush) request into the notification CQE it
>>>>> flushes (and only when it's flushes).
>>>>>
>>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>>> ---
>>>>>   include/uapi/linux/io_uring.h | 4 ++++
>>>>>   io_uring/net.c                | 6 +++++-
>>>>>   2 files changed, 9 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>>>>> index 20368394870e..91e7944c9c78 100644
>>>>> --- a/include/uapi/linux/io_uring.h
>>>>> +++ b/include/uapi/linux/io_uring.h
>>>>> @@ -280,11 +280,15 @@ enum io_uring_op {
>>>>>    *
>>>>>    * IORING_RECVSEND_NOTIF_FLUSH    Flush a notification after a successful
>>>>>    *                successful. Only for zerocopy sends.
>>>>> + *
>>>>> + * IORING_RECVSEND_NOTIF_COPY_TAG Copy request's user_data into the notification
>>>>> + *                  completion even if it's flushed.
>>>>>    */
>>>>>   #define IORING_RECVSEND_POLL_FIRST    (1U << 0)
>>>>>   #define IORING_RECV_MULTISHOT        (1U << 1)
>>>>>   #define IORING_RECVSEND_FIXED_BUF    (1U << 2)
>>>>>   #define IORING_RECVSEND_NOTIF_FLUSH    (1U << 3)
>>>>> +#define IORING_RECVSEND_NOTIF_COPY_TAG    (1U << 4)
>>>>>   /* cqe->res mask for extracting the notification sequence number */
>>>>>   #define IORING_NOTIF_SEQ_MASK        0xFFFFU
>>>>> diff --git a/io_uring/net.c b/io_uring/net.c
>>>>> index bd3fad9536ef..4d271a269979 100644
>>>>> --- a/io_uring/net.c
>>>>> +++ b/io_uring/net.c
>>>>> @@ -858,7 +858,9 @@ int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>>       zc->flags = READ_ONCE(sqe->ioprio);
>>>>>       if (zc->flags & ~(IORING_RECVSEND_POLL_FIRST |
>>>>> -              IORING_RECVSEND_FIXED_BUF | IORING_RECVSEND_NOTIF_FLUSH))
>>>>> +              IORING_RECVSEND_FIXED_BUF |
>>>>> +              IORING_RECVSEND_NOTIF_FLUSH |
>>>>> +              IORING_RECVSEND_NOTIF_COPY_TAG))
>>>>>           return -EINVAL;
>>>>>       if (zc->flags & IORING_RECVSEND_FIXED_BUF) {
>>>>>           unsigned idx = READ_ONCE(sqe->buf_index);
>>>>> @@ -1024,6 +1026,8 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
>>>>>           if (ret == -ERESTARTSYS)
>>>>>               ret = -EINTR;
>>>>>       } else if (zc->flags & IORING_RECVSEND_NOTIF_FLUSH) {
>>>>> +        if (zc->flags & IORING_RECVSEND_NOTIF_COPY_TAG)
>>>>> +            notif->cqe.user_data = req->cqe.user_data;
>>>>>           io_notif_slot_flush_submit(notif_slot, 0);
>>>>>       }
>>>>
>>>> This would work but it seems to be confusing.
>>>>
>>>> Can't we have a slot-less mode, with slot_idx==U16_MAX,
>>>> where we always allocate a new notif for each request,
>>>> this would then get the same user_data and would be referenced on the
>>>> request in order to reuse the same notif on an async retry after a short send.
>>>
>>> Ok, retries may make slots managing much harder, let me think
>>
>> With retries it would be much saner to use the same
>> notif for the whole request. So keeping it referenced
>> as zc->notif might be a way, maybe doing that in the _prep
>> function in order to do it just once, then we don't need
>> zc->slot_idx anymore.
> 
> Even though it's possible atm with some userspace consideration,
> it's definitely should be patched up.
> 
>>>> And this notif will always be flushed at the end of the request.
>>>>
>>>> This:
>>>>
>>>> struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx,
>>>>                                  struct io_notif_slot *slot)
>>>>
>>>> would change to:
>>>>
>>>> struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx,
>>>>                                  __u64 cqe_user_data,
>>>>                  __s32 cqe_res)
>>>>
>>>>
>>>> and:
>>>>
>>>> void io_notif_slot_flush(struct io_notif_slot *slot) __must_hold(&ctx->uring_lock)
>>>>
>>>> (__must_hold looks wrong there...)
>>>
>>> Nope, it should be there
>>
>> Shouldn't it be something like
>> __must_hold(&slot->notif->ctx->uring_lock)
>>
>> There is not 'ctx' argument.
> 
> Ah, in this sense, agree
> 
>>>> What do you think? It would remove the whole notif slot complexity
>>>> from caller using IORING_RECVSEND_NOTIF_FLUSH for every request anyway.
>>>
>>> The downside is that requests then should be pretty large or it'll
>>> lose in performance. Surely not a problem for 8MB per request but
>>> even 4KB won't suffice. And users may want to put in smaller chunks
>>> on the wire instead of waiting for mode data to let tcp handle
>>> pacing and potentially improve latencies by sending earlier.
>>
>> If this is optional applications can decide what fits better.
>>
>>> On the other hand that one notification per request idea mentioned
>>> before can extended to 1-2 CQEs per request, which is interestingly
>>> the approach zc send discussions started with.
>>
>> In order to make use of any of this I need any way
>> to get 2 CQEs with user_data being the same or related.
> 
> The idea described above will post 2 CQEs (mostly) per request
> as you want with an optional way to have only 1 CQE. My current
> sentiment is to kill all the slot business, leave this 1-2 CQE
> per request and see if there are users for whom it won't be
> enough. It's anyway just a slight deviation from what I wanted
> to push as a complimentary interface.

Ah, ok, removing the slot stuff again would be fine for me...

>> The only benefit for with slots is being able to avoid or
>> batch additional CQEs, correct? Or is there more to it?
> 
> CQE batching is a lesser problem, I'm more concerned of how
> it sticks with the network. In short, it'll hugely underperform
> with TCP if requests are not large enough.
> 
> A simple bench with some hacks, localhost, TCP, run by
> 
> ./msg_zerocopy -6 -r tcp -s <size> &
> ./io_uring_zerocopy_tx -6 -D "::1" -s <size> -m <0,2> tcp
> 
> 
> non-zerocopy:
> 4000B:  tx=8711880 (MB=33233), tx/s=1742376 (MB/s=6646)
> 16000B: tx=3196528 (MB=48775), tx/s=639305 (MB/s=9755)
> 60000B: tx=1036536 (MB=59311), tx/s=207307 (MB/s=11862)
> 
> zerocopy:
> 4000B:  tx=3003488 (MB=11457), tx/s=600697 (MB/s=2291)
> 16000B: tx=2940296 (MB=44865), tx/s=588059 (MB/s=8973)
> 60000B: tx=2621792 (MB=150020), tx/s=524358 (MB/s=30004)

So with something between 16k and 60k we reach the point where
ZC starts to be faster, correct?

Did you remove the loopback restriction as described in
Documentation/networking/msg_zerocopy.rst ?

Are the results similar when using ./msg_zerocopy -6 tcp -s <size>
as client?

And the reason is some page pinning overhead from iov_iter_get_pages2()
in __zerocopy_sg_from_iter()?

> Reusing notifications with slots will change the picture.
> And it this has nothing to do with io_uring overhead like
> CQE posting and so on.

Hmm I don't understand how the number of notif structures
would have any impact? Is it related to io_sg_from_iter()?

metze
