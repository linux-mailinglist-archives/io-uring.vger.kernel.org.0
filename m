Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08259599B0F
	for <lists+io-uring@lfdr.de>; Fri, 19 Aug 2022 13:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348558AbiHSLnc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Aug 2022 07:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348625AbiHSLnb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Aug 2022 07:43:31 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EEBC2BDD
        for <io-uring@vger.kernel.org>; Fri, 19 Aug 2022 04:43:29 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id c187-20020a1c35c4000000b003a30d88fe8eso3976258wma.2
        for <io-uring@vger.kernel.org>; Fri, 19 Aug 2022 04:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc;
        bh=0WRLXlDuSVtMfw6x2Ph3nUHSRK2tRJ8CmJmjB1gICv0=;
        b=WwsbiOTJqdMA1P8T8GNvbSCSPav0XdTtb3U1Gu+9wefn0KLLwptBkkCbMrtFOvXghe
         c5f9wcE39WsxNQkQ2VTmJ7Cg0oc+4sVRBfQC4OSiAiiLUXzBPJkmYXeKbBQTUgdXU2mX
         uMSIHpnAm+f012TYm2fxE4UGHr9NNEnBsBGjvmtpSIHfARchdLo1Kga10xy+InuVzapB
         uAm2IGoIY1AoI4/IphgX/Ncybwlrmcn64bGstwiexZSAp2NfYPFbEsDitVInwgZ+IlNt
         Ah11qazfjuRq7yF596TSfCaevD3LhCmCQu22amocbutqWVdxy23JPGZ1ytM0EiV08FaE
         3PDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=0WRLXlDuSVtMfw6x2Ph3nUHSRK2tRJ8CmJmjB1gICv0=;
        b=dmUw2Bd7nSviQD5uGuJN2rY8Usp4VEAoqi6CFgOT7GLPn9WdjsIlN7TIL/eja8vMK7
         AGJbfOQYU/HjuP0dO8ypQU4kmvkIvfe4ox/K7p3L97DM+SRYFPYfKv3ON4Qp5XEwIFh1
         k83vSxj2JJAbZUvyybjXuudQGJr/7GekYFjTYgMVrHfgPHlqR/dRYksji3gjmZxXRiXP
         zQPdSqa/swgSm8wAtoMNXhobxgZCQFwuByKBR/2XET9Pn1XGTCF/3nZu78Tvz1MrBlFJ
         9dmQOlLMULv2sLWwyXBLxW25stOWWKdBhLTqFsRwmpK/Utk1yFADS8zpGLcTVEtHHSwt
         MUng==
X-Gm-Message-State: ACgBeo0bf3H+qTzJf2hnhiakSenHFtgtdVCIpRm1AT4Fmh2DozgcpJd8
        VnhKJp5qZO3MhF0UECEzxuZzGiyKHvBuXA==
X-Google-Smtp-Source: AA6agR5K0Mpf7il+37Bk6L4MrSBi9c4KHQumKzIouy/qKwAL1jWu0fZaetZT9IquRd9EzpTs59jpSw==
X-Received: by 2002:a1c:19c3:0:b0:39c:6479:3ca with SMTP id 186-20020a1c19c3000000b0039c647903camr7599866wmz.27.1660909407774;
        Fri, 19 Aug 2022 04:43:27 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::22ef? ([2620:10d:c092:600::2:cdef])
        by smtp.gmail.com with ESMTPSA id g2-20020a5d4882000000b002211fc70174sm4381172wrq.99.2022.08.19.04.43.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Aug 2022 04:43:27 -0700 (PDT)
Message-ID: <a5fc6451-94a8-edbf-d9f7-a05eb49b0113@gmail.com>
Date:   Fri, 19 Aug 2022 12:42:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [RFC 2/2] io_uring/net: allow to override notification tag
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Dylan Yudaken <dylany@fb.com>
References: <cover.1660635140.git.asml.silence@gmail.com>
 <6aa0c662a3fec17a1ade512e7bbb519aa49e6e4d.1660635140.git.asml.silence@gmail.com>
 <bf3d5a0f-c337-f6f3-8bf4-b8665f92acaa@samba.org>
 <9b998187-b985-2938-1494-0bc8c189a3b6@gmail.com>
 <5fc449bd-9625-4ff0-5f1b-a9fbea721716@samba.org>
Content-Language: en-US
In-Reply-To: <5fc449bd-9625-4ff0-5f1b-a9fbea721716@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/18/22 19:13, Stefan Metzmacher wrote:
> Am 17.08.22 um 14:42 schrieb Pavel Begunkov:
>> On 8/16/22 09:23, Stefan Metzmacher wrote:
>>> Am 16.08.22 um 09:42 schrieb Pavel Begunkov:
>>>> Considering limited amount of slots some users struggle with
>>>> registration time notification tag assignment as it's hard to manage
>>>> notifications using sequence numbers. Add a simple feature that copies
>>>> sqe->user_data of a send(+flush) request into the notification CQE it
>>>> flushes (and only when it's flushes).
>>>>
>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>> ---
>>>>   include/uapi/linux/io_uring.h | 4 ++++
>>>>   io_uring/net.c                | 6 +++++-
>>>>   2 files changed, 9 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>>>> index 20368394870e..91e7944c9c78 100644
>>>> --- a/include/uapi/linux/io_uring.h
>>>> +++ b/include/uapi/linux/io_uring.h
>>>> @@ -280,11 +280,15 @@ enum io_uring_op {
>>>>    *
>>>>    * IORING_RECVSEND_NOTIF_FLUSH    Flush a notification after a successful
>>>>    *                successful. Only for zerocopy sends.
>>>> + *
>>>> + * IORING_RECVSEND_NOTIF_COPY_TAG Copy request's user_data into the notification
>>>> + *                  completion even if it's flushed.
>>>>    */
>>>>   #define IORING_RECVSEND_POLL_FIRST    (1U << 0)
>>>>   #define IORING_RECV_MULTISHOT        (1U << 1)
>>>>   #define IORING_RECVSEND_FIXED_BUF    (1U << 2)
>>>>   #define IORING_RECVSEND_NOTIF_FLUSH    (1U << 3)
>>>> +#define IORING_RECVSEND_NOTIF_COPY_TAG    (1U << 4)
>>>>   /* cqe->res mask for extracting the notification sequence number */
>>>>   #define IORING_NOTIF_SEQ_MASK        0xFFFFU
>>>> diff --git a/io_uring/net.c b/io_uring/net.c
>>>> index bd3fad9536ef..4d271a269979 100644
>>>> --- a/io_uring/net.c
>>>> +++ b/io_uring/net.c
>>>> @@ -858,7 +858,9 @@ int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>       zc->flags = READ_ONCE(sqe->ioprio);
>>>>       if (zc->flags & ~(IORING_RECVSEND_POLL_FIRST |
>>>> -              IORING_RECVSEND_FIXED_BUF | IORING_RECVSEND_NOTIF_FLUSH))
>>>> +              IORING_RECVSEND_FIXED_BUF |
>>>> +              IORING_RECVSEND_NOTIF_FLUSH |
>>>> +              IORING_RECVSEND_NOTIF_COPY_TAG))
>>>>           return -EINVAL;
>>>>       if (zc->flags & IORING_RECVSEND_FIXED_BUF) {
>>>>           unsigned idx = READ_ONCE(sqe->buf_index);
>>>> @@ -1024,6 +1026,8 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
>>>>           if (ret == -ERESTARTSYS)
>>>>               ret = -EINTR;
>>>>       } else if (zc->flags & IORING_RECVSEND_NOTIF_FLUSH) {
>>>> +        if (zc->flags & IORING_RECVSEND_NOTIF_COPY_TAG)
>>>> +            notif->cqe.user_data = req->cqe.user_data;
>>>>           io_notif_slot_flush_submit(notif_slot, 0);
>>>>       }
>>>
>>> This would work but it seems to be confusing.
>>>
>>> Can't we have a slot-less mode, with slot_idx==U16_MAX,
>>> where we always allocate a new notif for each request,
>>> this would then get the same user_data and would be referenced on the
>>> request in order to reuse the same notif on an async retry after a short send.
>>
>> Ok, retries may make slots managing much harder, let me think
> 
> With retries it would be much saner to use the same
> notif for the whole request. So keeping it referenced
> as zc->notif might be a way, maybe doing that in the _prep
> function in order to do it just once, then we don't need
> zc->slot_idx anymore.

Even though it's possible atm with some userspace consideration,
it's definitely should be patched up.

>>> And this notif will always be flushed at the end of the request.
>>>
>>> This:
>>>
>>> struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx,
>>>                                  struct io_notif_slot *slot)
>>>
>>> would change to:
>>>
>>> struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx,
>>>                                  __u64 cqe_user_data,
>>>                  __s32 cqe_res)
>>>
>>>
>>> and:
>>>
>>> void io_notif_slot_flush(struct io_notif_slot *slot) __must_hold(&ctx->uring_lock)
>>>
>>> (__must_hold looks wrong there...)
>>
>> Nope, it should be there
> 
> Shouldn't it be something like
> __must_hold(&slot->notif->ctx->uring_lock)
> 
> There is not 'ctx' argument.

Ah, in this sense, agree

>>> What do you think? It would remove the whole notif slot complexity
>>> from caller using IORING_RECVSEND_NOTIF_FLUSH for every request anyway.
>>
>> The downside is that requests then should be pretty large or it'll
>> lose in performance. Surely not a problem for 8MB per request but
>> even 4KB won't suffice. And users may want to put in smaller chunks
>> on the wire instead of waiting for mode data to let tcp handle
>> pacing and potentially improve latencies by sending earlier.
> 
> If this is optional applications can decide what fits better.
> 
>> On the other hand that one notification per request idea mentioned
>> before can extended to 1-2 CQEs per request, which is interestingly
>> the approach zc send discussions started with.
> 
> In order to make use of any of this I need any way
> to get 2 CQEs with user_data being the same or related.

The idea described above will post 2 CQEs (mostly) per request
as you want with an optional way to have only 1 CQE. My current
sentiment is to kill all the slot business, leave this 1-2 CQE
per request and see if there are users for whom it won't be
enough. It's anyway just a slight deviation from what I wanted
to push as a complimentary interface.

> The only benefit for with slots is being able to avoid or
> batch additional CQEs, correct? Or is there more to it?

CQE batching is a lesser problem, I'm more concerned of how
it sticks with the network. In short, it'll hugely underperform
with TCP if requests are not large enough.

A simple bench with some hacks, localhost, TCP, run by

./msg_zerocopy -6 -r tcp -s <size> &
./io_uring_zerocopy_tx -6 -D "::1" -s <size> -m <0,2> tcp


non-zerocopy:
4000B:  tx=8711880 (MB=33233), tx/s=1742376 (MB/s=6646)
16000B: tx=3196528 (MB=48775), tx/s=639305 (MB/s=9755)
60000B: tx=1036536 (MB=59311), tx/s=207307 (MB/s=11862)

zerocopy:
4000B:  tx=3003488 (MB=11457), tx/s=600697 (MB/s=2291)
16000B: tx=2940296 (MB=44865), tx/s=588059 (MB/s=8973)
60000B: tx=2621792 (MB=150020), tx/s=524358 (MB/s=30004)

Reusing notifications with slots will change the picture.
And it this has nothing to do with io_uring overhead like
CQE posting and so on.

-- 
Pavel Begunkov
