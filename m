Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A80D598AE8
	for <lists+io-uring@lfdr.de>; Thu, 18 Aug 2022 20:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbiHRSNf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Aug 2022 14:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238585AbiHRSNf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Aug 2022 14:13:35 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E341BDEED
        for <io-uring@vger.kernel.org>; Thu, 18 Aug 2022 11:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=opcUi6ym9wpNQDcF2rL0NO2MywSIVjIhaI429JlWQyw=; b=vKb2I/EiuNB1+/4PwyTcR8PvRo
        0fv4PbLlLAEyGRPesRdgKAdDOmpsu32j5/jW/B/JlyYGbDE+1K/bE7cJMn0VuNNf73qmNzxn1TVIg
        khygOS44Pg0k3/YGtzB704e7ub5pO0peBaR6rvOxjnvR0UDmTzeZ2KYgnl80f5v1OssAdE9pU7XoF
        wHvVCLYhSWvEH1ousRF4SJ666Qk4BON/ZTkuhMHowkT3I4PyxLcDA/3yMo6RB2uRSZb6UjiWGwRtj
        DJlvBMBhBIPOEWzKgwlyJnypvuBR1Wv8GGqFl6gnpvlk+LD0ACuNKgIUL7GGEm04T3pQ4xC68a9Fo
        UPraa0YjIepaLHFI4HEcDSs4P2pHEctTk22UxAHQT+Cg7DGnzWLU0cbhwk+Z1MC3mTWH6wTwVB9er
        ngF3lWP6mGxhXgdnI+b5ibRpWuDsZfJ7hMdDL/UCJsGhJO5HVXkJ5mS9awZvvC19/8IL0RrvECZXZ
        f3+LWf/8W9CQM3wbi5NBso3H;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oOk1A-000jcP-MI; Thu, 18 Aug 2022 18:13:20 +0000
Message-ID: <5fc449bd-9625-4ff0-5f1b-a9fbea721716@samba.org>
Date:   Thu, 18 Aug 2022 20:13:20 +0200
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
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [RFC 2/2] io_uring/net: allow to override notification tag
In-Reply-To: <9b998187-b985-2938-1494-0bc8c189a3b6@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Am 17.08.22 um 14:42 schrieb Pavel Begunkov:
> On 8/16/22 09:23, Stefan Metzmacher wrote:
>> Am 16.08.22 um 09:42 schrieb Pavel Begunkov:
>>> Considering limited amount of slots some users struggle with
>>> registration time notification tag assignment as it's hard to manage
>>> notifications using sequence numbers. Add a simple feature that copies
>>> sqe->user_data of a send(+flush) request into the notification CQE it
>>> flushes (and only when it's flushes).
>>>
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>>>   include/uapi/linux/io_uring.h | 4 ++++
>>>   io_uring/net.c                | 6 +++++-
>>>   2 files changed, 9 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>>> index 20368394870e..91e7944c9c78 100644
>>> --- a/include/uapi/linux/io_uring.h
>>> +++ b/include/uapi/linux/io_uring.h
>>> @@ -280,11 +280,15 @@ enum io_uring_op {
>>>    *
>>>    * IORING_RECVSEND_NOTIF_FLUSH    Flush a notification after a successful
>>>    *                successful. Only for zerocopy sends.
>>> + *
>>> + * IORING_RECVSEND_NOTIF_COPY_TAG Copy request's user_data into the notification
>>> + *                  completion even if it's flushed.
>>>    */
>>>   #define IORING_RECVSEND_POLL_FIRST    (1U << 0)
>>>   #define IORING_RECV_MULTISHOT        (1U << 1)
>>>   #define IORING_RECVSEND_FIXED_BUF    (1U << 2)
>>>   #define IORING_RECVSEND_NOTIF_FLUSH    (1U << 3)
>>> +#define IORING_RECVSEND_NOTIF_COPY_TAG    (1U << 4)
>>>   /* cqe->res mask for extracting the notification sequence number */
>>>   #define IORING_NOTIF_SEQ_MASK        0xFFFFU
>>> diff --git a/io_uring/net.c b/io_uring/net.c
>>> index bd3fad9536ef..4d271a269979 100644
>>> --- a/io_uring/net.c
>>> +++ b/io_uring/net.c
>>> @@ -858,7 +858,9 @@ int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>       zc->flags = READ_ONCE(sqe->ioprio);
>>>       if (zc->flags & ~(IORING_RECVSEND_POLL_FIRST |
>>> -              IORING_RECVSEND_FIXED_BUF | IORING_RECVSEND_NOTIF_FLUSH))
>>> +              IORING_RECVSEND_FIXED_BUF |
>>> +              IORING_RECVSEND_NOTIF_FLUSH |
>>> +              IORING_RECVSEND_NOTIF_COPY_TAG))
>>>           return -EINVAL;
>>>       if (zc->flags & IORING_RECVSEND_FIXED_BUF) {
>>>           unsigned idx = READ_ONCE(sqe->buf_index);
>>> @@ -1024,6 +1026,8 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
>>>           if (ret == -ERESTARTSYS)
>>>               ret = -EINTR;
>>>       } else if (zc->flags & IORING_RECVSEND_NOTIF_FLUSH) {
>>> +        if (zc->flags & IORING_RECVSEND_NOTIF_COPY_TAG)
>>> +            notif->cqe.user_data = req->cqe.user_data;
>>>           io_notif_slot_flush_submit(notif_slot, 0);
>>>       }
>>
>> This would work but it seems to be confusing.
>>
>> Can't we have a slot-less mode, with slot_idx==U16_MAX,
>> where we always allocate a new notif for each request,
>> this would then get the same user_data and would be referenced on the
>> request in order to reuse the same notif on an async retry after a short send.
> 
> Ok, retries may make slots managing much harder, let me think

With retries it would be much saner to use the same
notif for the whole request. So keeping it referenced
as zc->notif might be a way, maybe doing that in the _prep
function in order to do it just once, then we don't need
zc->slot_idx anymore.

>> And this notif will always be flushed at the end of the request.
>>
>> This:
>>
>> struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx,
>>                                  struct io_notif_slot *slot)
>>
>> would change to:
>>
>> struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx,
>>                                  __u64 cqe_user_data,
>>                  __s32 cqe_res)
>>
>>
>> and:
>>
>> void io_notif_slot_flush(struct io_notif_slot *slot) __must_hold(&ctx->uring_lock)
>>
>> (__must_hold looks wrong there...)
> 
> Nope, it should be there

Shouldn't it be something like
__must_hold(&slot->notif->ctx->uring_lock)

There is not 'ctx' argument.

>> could just be:
>>
>> void io_notif_flush(struct io_notif_*notif)
>>
>> What do you think? It would remove the whole notif slot complexity
>> from caller using IORING_RECVSEND_NOTIF_FLUSH for every request anyway.
> 
> The downside is that requests then should be pretty large or it'll
> lose in performance. Surely not a problem for 8MB per request but
> even 4KB won't suffice. And users may want to put in smaller chunks
> on the wire instead of waiting for mode data to let tcp handle
> pacing and potentially improve latencies by sending earlier.

If this is optional applications can decide what fits better.

> On the other hand that one notification per request idea mentioned
> before can extended to 1-2 CQEs per request, which is interestingly
> the approach zc send discussions started with.

In order to make use of any of this I need any way
to get 2 CQEs with user_data being the same or related.

The only benefit for with slots is being able to avoid or
batch additional CQEs, correct? Or is there more to it?

metze
