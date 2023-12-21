Return-Path: <io-uring+bounces-346-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E60DC81BECB
	for <lists+io-uring@lfdr.de>; Thu, 21 Dec 2023 20:07:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5E2D51F23B1E
	for <lists+io-uring@lfdr.de>; Thu, 21 Dec 2023 19:07:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3621065195;
	Thu, 21 Dec 2023 19:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="au5S6k6m"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83DD265194;
	Thu, 21 Dec 2023 19:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-50e33fe3856so1354964e87.1;
        Thu, 21 Dec 2023 11:07:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703185635; x=1703790435; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XAqzde0dRmJKdXJXFJfHqK3KJUQqDdugtO1Nq73NgJY=;
        b=au5S6k6metoXci8dQIHxrJZm3XogiEZrCODB3zq7mloyCBZ+8YlYSZ2lBkf7RGFs2h
         pt0sm/eKkyyuwyMrDiler/wg7i2Cy08Wt4NQcTH5IxHA4KBS2x98K4p3lcfO70WzCvER
         qMI8ya44cePW1Lqx5/AVovuGZb+6RNkbu6gudv12jNThm94XlxPpsQe4mmL7bMixGWYF
         mUOOX90AyBF6NN60s5YKb5PfQJRhY/8c5DLv80G60C17lj2GwIJ+aqQ+Ycc4EfTAd/z1
         RoyyLIp5YbzSDyd5Vm6SPWdz8RcbQfyz+zoub61mRXEliaAOmO+eo8P5FvM+2tSStONT
         Kz+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703185635; x=1703790435;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XAqzde0dRmJKdXJXFJfHqK3KJUQqDdugtO1Nq73NgJY=;
        b=aCgxQBRM9LPPUrb3ud8T+GAwk10Q5b0fh413smZurfB8NEIZdgxtT3B2gcfFK5cmtI
         cUKFgzQAQyE54NfCdvpJHjwsi090rMz1PleeoxsCnC2A9Z4fli7aPYszD7SWJ+bY682E
         9lM0Rdsad+hNx+5Ye2VHlMwdEqMpJkGUNQbEb1RK4xHtsLTU1pgT1yY6tuzvK0X65war
         86KP6nxkUD7bRrkZ+Ga/L3LU8oIktdA4Rb2f8ngZ5kuaHOb2xqLXScnMk6+OSWwU7eJ2
         qPiUCAPDNKjyr1OidoC+dLFfTaTH4ozCfFrCNYYBUM2pd8y77mQXjck7SK2HEkxoZ4Em
         OgIA==
X-Gm-Message-State: AOJu0YyZqJQwsLXHSTEZTQwrMjTFASGkZKm9yNU0dD2s5M9+ccGcM1aE
	NJSj20dI654EcILfbGkK1Bo=
X-Google-Smtp-Source: AGHT+IHiDGcKUNieZRPplODCW1xswejUOnbsIjI9Wl9NM1bySSBQo88hfeFetkfVh/RayQZwukhOUA==
X-Received: by 2002:a05:6512:10c4:b0:50e:20f4:da6d with SMTP id k4-20020a05651210c400b0050e20f4da6dmr49315lfg.186.1703185635303;
        Thu, 21 Dec 2023 11:07:15 -0800 (PST)
Received: from [192.168.8.100] ([185.69.145.35])
        by smtp.gmail.com with ESMTPSA id e14-20020a50fb8e000000b005530492d900sm1530484edq.58.2023.12.21.11.07.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Dec 2023 11:07:14 -0800 (PST)
Message-ID: <6042681c-fef6-456b-8c65-e0505c6b4abb@gmail.com>
Date: Thu, 21 Dec 2023 18:59:45 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 15/20] io_uring: add io_recvzc request
To: Jens Axboe <axboe@kernel.dk>, David Wei <dw@davidwei.uk>,
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
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <7d39e650-0879-45f1-b76c-be111b9ee38e@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/20/23 18:09, Jens Axboe wrote:
> On 12/20/23 10:04 AM, Pavel Begunkov wrote:
>> On 12/20/23 16:27, Jens Axboe wrote:
>>> On 12/19/23 2:03 PM, David Wei wrote:
>>>> diff --git a/io_uring/net.c b/io_uring/net.c
>>>> index 454ba301ae6b..7a2aadf6962c 100644
>>>> --- a/io_uring/net.c
>>>> +++ b/io_uring/net.c
>>>> @@ -637,7 +647,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
>>>>        unsigned int cflags;
>>>>          cflags = io_put_kbuf(req, issue_flags);
>>>> -    if (msg->msg_inq && msg->msg_inq != -1)
>>>> +    if (msg && msg->msg_inq && msg->msg_inq != -1)
>>>>            cflags |= IORING_CQE_F_SOCK_NONEMPTY;
>>>>          if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
>>>> @@ -652,7 +662,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
>>>>                io_recv_prep_retry(req);
>>>>                /* Known not-empty or unknown state, retry */
>>>>                if (cflags & IORING_CQE_F_SOCK_NONEMPTY ||
>>>> -                msg->msg_inq == -1)
>>>> +                (msg && msg->msg_inq == -1))
>>>>                    return false;
>>>>                if (issue_flags & IO_URING_F_MULTISHOT)
>>>>                    *ret = IOU_ISSUE_SKIP_COMPLETE;
>>>
>>> These are a bit ugly, just pass in a dummy msg for this?
>>>
>>>> +int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)
>>>> +{
>>>> +    struct io_recvzc *zc = io_kiocb_to_cmd(req, struct io_recvzc);
>>>> +    struct socket *sock;
>>>> +    unsigned flags;
>>>> +    int ret, min_ret = 0;
>>>> +    bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
>>>> +    struct io_zc_rx_ifq *ifq;
>>>
>>> Eg
>>>      struct msghdr dummy_msg;
>>>
>>>      dummy_msg.msg_inq = -1;
>>>
>>> which will eat some stack, but probably not really an issue.
>>>
>>>
>>>> +    if (issue_flags & IO_URING_F_UNLOCKED)
>>>> +        return -EAGAIN;
>>>
>>> This seems odd, why? If we're called with IO_URING_F_UNLOCKED set, then
>>
>> It's my addition, let me explain.
>>
>> io_recvzc() -> io_zc_rx_recv() -> ... -> zc_rx_recv_frag()
>>
>> This chain posts completions to a buffer completion queue, and
>> we don't want extra locking to share it with io-wq threads. In
>> some sense it's quite similar to the CQ locking, considering
>> we restrict zc to DEFER_TASKRUN. And doesn't change anything
>> anyway because multishot cannot post completions from io-wq
>> and are executed from the poll callback in task work.
>>
>>> it's from io-wq. And returning -EAGAIN there will not do anything to
>>
>> It will. It's supposed to just requeue for polling (it's not
>> IOPOLL to keep retrying -EAGAIN), just like multishots do.
> 
> It definitely needs a good comment, as it's highly non-obvious when
> reading the code!
> 
>> Double checking the code, it can actually terminate the request,
>> which doesn't make much difference for us because multishots
>> should normally never end up in io-wq anyway, but I guess we
>> can improve it a liitle bit.
> 
> Right, assumptions seems to be that -EAGAIN will lead to poll arm, which
> seems a bit fragile.

The main assumption is that io-wq will eventually leave the
request alone and push it somewhere else, either queuing for
polling or terminating, which is more than reasonable. I'd
add that it's rather insane for io-wq indefinitely spinning
on -EAGAIN, but it has long been fixed (for !IOPOLL).

As said, can be made a bit better, but it won't change anything
for real life execution, multishots would never end up there
after they start listening for poll events.

>> And it should also use IO_URING_F_IOWQ, forgot I split out
>> it from *F_UNLOCK.
> 
> Yep, that'd be clearer.

Not "clearer", but more correct. Even though it's not
a bug because deps between the flags.

>>>> +static int zc_rx_recv_frag(struct io_zc_rx_ifq *ifq, const skb_frag_t *frag,
>>>> +               int off, int len, unsigned sock_idx)
>>>> +{
>>>> +    off += skb_frag_off(frag);
>>>> +
>>>> +    if (likely(page_is_page_pool_iov(frag->bv_page))) {
>>>> +        struct io_uring_rbuf_cqe *cqe;
>>>> +        struct io_zc_rx_buf *buf;
>>>> +        struct page_pool_iov *ppiov;
>>>> +
>>>> +        ppiov = page_to_page_pool_iov(frag->bv_page);
>>>> +        if (ppiov->pp->p.memory_provider != PP_MP_IOU_ZCRX ||
>>>> +            ppiov->pp->mp_priv != ifq)
>>>> +            return -EFAULT;
>>>> +
>>>> +        cqe = io_zc_get_rbuf_cqe(ifq);
>>>> +        if (!cqe)
>>>> +            return -ENOBUFS;
>>>> +
>>>> +        buf = io_iov_to_buf(ppiov);
>>>> +        io_zc_rx_get_buf_uref(buf);
>>>> +
>>>> +        cqe->region = 0;
>>>> +        cqe->off = io_buf_pgid(ifq->pool, buf) * PAGE_SIZE + off;
>>>> +        cqe->len = len;
>>>> +        cqe->sock = sock_idx;
>>>> +        cqe->flags = 0;
>>>> +    } else {
>>>> +        return -EOPNOTSUPP;
>>>> +    }
>>>> +
>>>> +    return len;
>>>> +}
>>>
>>> I think this would read a lot better as:
>>>
>>>      if (unlikely(!page_is_page_pool_iov(frag->bv_page)))
>>>          return -EOPNOTSUPP;
>>
>> That's a bit of oracle coding, this branch is implemented in
>> a later patch.
> 
> Oracle coding?

I.e. knowing how later patches (should) look like.

> Each patch stands separately, there's no reason not to make this one as

They are not standalone, you cannot sanely develop anything not
thinking how and where it's used, otherwise you'd get a set of
functions full of sleeping but later used in irq context or just
unfittable into a desired framework. By extent, code often is
written while trying to look a step ahead. For example, first
patches don't push everything into io_uring.c just to wholesale
move it into zc_rx.c because of exceeding some size threshold.

> clean as it can be. And an error case with the main bits inline is a lot

I agree that it should be clean among all, but it _is_ clean
and readable, all else is stylistic nit picking. And maybe it's
just my opinion, but I also personally appreciate when a patch is
easy to review, which includes not restructuring all written before
with every patch, which also helps with back porting and other
developing aspects.

> nicer imho than two separate indented parts. For the latter addition
> instead of the -EOPNOTSUPP, would probably be nice to have it in a
> separate function. Probably ditto for the page pool case here now, would
> make the later patch simpler too.

If we'd need it in the future, we'll change it then, patches
stand separately, at least it's IMHO not needed in the current
series.

-- 
Pavel Begunkov

