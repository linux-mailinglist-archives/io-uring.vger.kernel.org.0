Return-Path: <io-uring+bounces-349-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BFB7A81C02D
	for <lists+io-uring@lfdr.de>; Thu, 21 Dec 2023 22:32:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3478D1F23F44
	for <lists+io-uring@lfdr.de>; Thu, 21 Dec 2023 21:32:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD19376DC6;
	Thu, 21 Dec 2023 21:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="coyV8JPE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF19776DAC
	for <io-uring@vger.kernel.org>; Thu, 21 Dec 2023 21:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-7ba9356f562so7147839f.1
        for <io-uring@vger.kernel.org>; Thu, 21 Dec 2023 13:32:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1703194323; x=1703799123; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=byj2SHo45qCqUBCaUu6infqMQRQSWgHlBtwm+I1RHa0=;
        b=coyV8JPEtS40ZspbgpWAfvdN8937HfymIKipXLYDabTft3lQcHYZlTUR+MaaaPR0uY
         M9KJFrZWOxtOueXBGZAoZzR9Vwk86fqd5ZSyiD0viF9+1HK5yMq23h08o8PZHCCIxiiR
         45KEP7n7pxtGWjOzpa3bzEzPlrim98MBi0VoNTRtvUIAqjj2K7/YjSEZ+03Tf7eLumRl
         72mRB3KoyJMAY7UMA3/DnNpOj3+CiBJAkGavqAfrHtHlj1k2DRF2N8RNfxDdYBQJKchZ
         X0JD/cGFN42pIqt6u1lXKKbajZyUHFcvBXX51gp0bIJj6AcZ/dX/4YYVHIkKs4kIAaiX
         obGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703194323; x=1703799123;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=byj2SHo45qCqUBCaUu6infqMQRQSWgHlBtwm+I1RHa0=;
        b=k01Y+42DzIxO8raEzEb8FzsUBchRwUad6JzVkyzo896wyEqrt1CY9eDF2egOkqhQ33
         +doj0DEp+4/5J/dJcrOts/vl26qGFjIzo4Uwq05dR6MCs0NfMQFK5vo6fme4YwiTdcJf
         pligg+BxSYP5X398LBBErAz6w4QYNiS/tjWMhXioAHiRI3YkkLYzp9gzGt3+ndvDkNR8
         eBaXmb9yVrk5yBke/f3LeyMwFe3P6IcsCToiTc+gTKGIld6igxcqPL4VZfnCw8ZjYR8S
         kI35E60up6i4QWH0rIA3ORzr74b7JObsJyj6/rt5xzyDGadeq4sq8IiEN9xelNCy7O20
         9PMw==
X-Gm-Message-State: AOJu0YwkZfd00o7xGmNx4z7pevU5Surez01ktabU5+IvBq2EKcd+cME7
	y4kqZ6kFe23+bQ97jqahlffeOr0HkXEkFQ==
X-Google-Smtp-Source: AGHT+IFEjTnrjWFW0vyqABcEMFuqprf7a/JU5mTqv5dgF+hrEC2WvvddEmXXSHGEwxv+vxy/8HI2qw==
X-Received: by 2002:a05:6602:1817:b0:7ba:9b40:1a47 with SMTP id t23-20020a056602181700b007ba9b401a47mr181935ioh.2.1703194322910;
        Thu, 21 Dec 2023 13:32:02 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id cd5-20020a0566381a0500b004290fd3a68dsm664501jab.1.2023.12.21.13.32.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Dec 2023 13:32:02 -0800 (PST)
Message-ID: <9d715976-6f27-4291-a2b4-f34b1bbeaf77@kernel.dk>
Date: Thu, 21 Dec 2023 14:32:00 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 15/20] io_uring: add io_recvzc request
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20231219210357.4029713-1-dw@davidwei.uk>
 <20231219210357.4029713-16-dw@davidwei.uk>
 <8a447c17-92a1-40b7-baa7-4098c7701ee9@kernel.dk>
 <bef81787-bb85-441f-9350-c915572ab82e@gmail.com>
 <7d39e650-0879-45f1-b76c-be111b9ee38e@kernel.dk>
 <6042681c-fef6-456b-8c65-e0505c6b4abb@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <6042681c-fef6-456b-8c65-e0505c6b4abb@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/21/23 11:59 AM, Pavel Begunkov wrote:
> On 12/20/23 18:09, Jens Axboe wrote:
>> On 12/20/23 10:04 AM, Pavel Begunkov wrote:
>>> On 12/20/23 16:27, Jens Axboe wrote:
>>>> On 12/19/23 2:03 PM, David Wei wrote:
>>>>> diff --git a/io_uring/net.c b/io_uring/net.c
>>>>> index 454ba301ae6b..7a2aadf6962c 100644
>>>>> --- a/io_uring/net.c
>>>>> +++ b/io_uring/net.c
>>>>> @@ -637,7 +647,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
>>>>>        unsigned int cflags;
>>>>>          cflags = io_put_kbuf(req, issue_flags);
>>>>> -    if (msg->msg_inq && msg->msg_inq != -1)
>>>>> +    if (msg && msg->msg_inq && msg->msg_inq != -1)
>>>>>            cflags |= IORING_CQE_F_SOCK_NONEMPTY;
>>>>>          if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
>>>>> @@ -652,7 +662,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
>>>>>                io_recv_prep_retry(req);
>>>>>                /* Known not-empty or unknown state, retry */
>>>>>                if (cflags & IORING_CQE_F_SOCK_NONEMPTY ||
>>>>> -                msg->msg_inq == -1)
>>>>> +                (msg && msg->msg_inq == -1))
>>>>>                    return false;
>>>>>                if (issue_flags & IO_URING_F_MULTISHOT)
>>>>>                    *ret = IOU_ISSUE_SKIP_COMPLETE;
>>>>
>>>> These are a bit ugly, just pass in a dummy msg for this?
>>>>
>>>>> +int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)
>>>>> +{
>>>>> +    struct io_recvzc *zc = io_kiocb_to_cmd(req, struct io_recvzc);
>>>>> +    struct socket *sock;
>>>>> +    unsigned flags;
>>>>> +    int ret, min_ret = 0;
>>>>> +    bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
>>>>> +    struct io_zc_rx_ifq *ifq;
>>>>
>>>> Eg
>>>>      struct msghdr dummy_msg;
>>>>
>>>>      dummy_msg.msg_inq = -1;
>>>>
>>>> which will eat some stack, but probably not really an issue.
>>>>
>>>>
>>>>> +    if (issue_flags & IO_URING_F_UNLOCKED)
>>>>> +        return -EAGAIN;
>>>>
>>>> This seems odd, why? If we're called with IO_URING_F_UNLOCKED set, then
>>>
>>> It's my addition, let me explain.
>>>
>>> io_recvzc() -> io_zc_rx_recv() -> ... -> zc_rx_recv_frag()
>>>
>>> This chain posts completions to a buffer completion queue, and
>>> we don't want extra locking to share it with io-wq threads. In
>>> some sense it's quite similar to the CQ locking, considering
>>> we restrict zc to DEFER_TASKRUN. And doesn't change anything
>>> anyway because multishot cannot post completions from io-wq
>>> and are executed from the poll callback in task work.
>>>
>>>> it's from io-wq. And returning -EAGAIN there will not do anything to
>>>
>>> It will. It's supposed to just requeue for polling (it's not
>>> IOPOLL to keep retrying -EAGAIN), just like multishots do.
>>
>> It definitely needs a good comment, as it's highly non-obvious when
>> reading the code!
>>
>>> Double checking the code, it can actually terminate the request,
>>> which doesn't make much difference for us because multishots
>>> should normally never end up in io-wq anyway, but I guess we
>>> can improve it a liitle bit.
>>
>> Right, assumptions seems to be that -EAGAIN will lead to poll arm, which
>> seems a bit fragile.
> 
> The main assumption is that io-wq will eventually leave the
> request alone and push it somewhere else, either queuing for
> polling or terminating, which is more than reasonable. I'd

But surely you don't want it terminated from here? It seems like a very
odd choice. As it stands, if you end up doing more than one loop, then
it won't arm poll and it'll get failed.

> add that it's rather insane for io-wq indefinitely spinning
> on -EAGAIN, but it has long been fixed (for !IOPOLL).

There's no other choice for polling, and it doesn't do it for
non-polling. The current logic makes sense - if you do a blocking
attempt and you get -EAGAIN, that's really the final result and you
cannot sanely retry for !IOPOLL in that case. Before we did poll arm for
io-wq, even the first -EAGAIN would've terminated it. Relying on -EAGAIN
from a blocking attempt to do anything but fail the request with -EAGAIN
res is pretty fragile and odd, I think that needs sorting out.

> As said, can be made a bit better, but it won't change anything
> for real life execution, multishots would never end up there
> after they start listening for poll events.

Right, probably won't ever be a thing for !multishot. As mentioned in my
original reply, it really just needs a comment explaining exactly what
it's doing and why it's fine.

>>> And it should also use IO_URING_F_IOWQ, forgot I split out
>>> it from *F_UNLOCK.
>>
>> Yep, that'd be clearer.
> 
> Not "clearer", but more correct. Even though it's not
> a bug because deps between the flags.

Both clearer and more correct, I would say.

>>>>> +static int zc_rx_recv_frag(struct io_zc_rx_ifq *ifq, const skb_frag_t *frag,
>>>>> +               int off, int len, unsigned sock_idx)
>>>>> +{
>>>>> +    off += skb_frag_off(frag);
>>>>> +
>>>>> +    if (likely(page_is_page_pool_iov(frag->bv_page))) {
>>>>> +        struct io_uring_rbuf_cqe *cqe;
>>>>> +        struct io_zc_rx_buf *buf;
>>>>> +        struct page_pool_iov *ppiov;
>>>>> +
>>>>> +        ppiov = page_to_page_pool_iov(frag->bv_page);
>>>>> +        if (ppiov->pp->p.memory_provider != PP_MP_IOU_ZCRX ||
>>>>> +            ppiov->pp->mp_priv != ifq)
>>>>> +            return -EFAULT;
>>>>> +
>>>>> +        cqe = io_zc_get_rbuf_cqe(ifq);
>>>>> +        if (!cqe)
>>>>> +            return -ENOBUFS;
>>>>> +
>>>>> +        buf = io_iov_to_buf(ppiov);
>>>>> +        io_zc_rx_get_buf_uref(buf);
>>>>> +
>>>>> +        cqe->region = 0;
>>>>> +        cqe->off = io_buf_pgid(ifq->pool, buf) * PAGE_SIZE + off;
>>>>> +        cqe->len = len;
>>>>> +        cqe->sock = sock_idx;
>>>>> +        cqe->flags = 0;
>>>>> +    } else {
>>>>> +        return -EOPNOTSUPP;
>>>>> +    }
>>>>> +
>>>>> +    return len;
>>>>> +}
>>>>
>>>> I think this would read a lot better as:
>>>>
>>>>      if (unlikely(!page_is_page_pool_iov(frag->bv_page)))
>>>>          return -EOPNOTSUPP;
>>>
>>> That's a bit of oracle coding, this branch is implemented in
>>> a later patch.
>>
>> Oracle coding?
> 
> I.e. knowing how later patches (should) look like.
> 
>> Each patch stands separately, there's no reason not to make this one as
> 
> They are not standalone, you cannot sanely develop anything not
> thinking how and where it's used, otherwise you'd get a set of
> functions full of sleeping but later used in irq context or just
> unfittable into a desired framework. By extent, code often is
> written while trying to look a step ahead. For example, first
> patches don't push everything into io_uring.c just to wholesale
> move it into zc_rx.c because of exceeding some size threshold.

Yes, this is how most patch series are - they will compile separately,
but obviously won't necessarily make sense or be functional until you
get to the end. But since you very much do have future knowledge in
these patches, there's no excuse for not making them interact with each
other better. Each patch should not pretend it doesn't know what comes
next in a series, if you can make a followup patch simpler with a tweak
to a previous patch, that is definitely a good idea.

And here, even the end result would be better imho without having

if (a) {
	big blob of stuff
} else {
	other blob of stuff
}

when it could just be

if (a)
	return big_blog_of_stuff();

return other_blog_of_stuff();

instead.

>> clean as it can be. And an error case with the main bits inline is a lot
> 
> I agree that it should be clean among all, but it _is_ clean
> and readable, all else is stylistic nit picking. And maybe it's
> just my opinion, but I also personally appreciate when a patch is
> easy to review, which includes not restructuring all written before
> with every patch, which also helps with back porting and other
> developing aspects.

But that's basically my point, it even makes followup patches simpler to
read as well. Is it stylistic? Certainly, I just prefer having the above
rather than two big indentations. But it also makes the followup patch
simpler and it's basically a one-liner change at that point, and a
bigger hunk of added code that's the new function that handles the new
case.

>> nicer imho than two separate indented parts. For the latter addition
>> instead of the -EOPNOTSUPP, would probably be nice to have it in a
>> separate function. Probably ditto for the page pool case here now, would
>> make the later patch simpler too.
> 
> If we'd need it in the future, we'll change it then, patches
> stand separately, at least it's IMHO not needed in the current
> series.

It's still an RFC series, please do change it for v4.

-- 
Jens Axboe


