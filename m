Return-Path: <io-uring+bounces-338-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9082F81A6B2
	for <lists+io-uring@lfdr.de>; Wed, 20 Dec 2023 19:09:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 47C782882A5
	for <lists+io-uring@lfdr.de>; Wed, 20 Dec 2023 18:09:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58036482CB;
	Wed, 20 Dec 2023 18:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="tchsrPnw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1BD482C6
	for <io-uring@vger.kernel.org>; Wed, 20 Dec 2023 18:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-7ba7d17184eso6937639f.0
        for <io-uring@vger.kernel.org>; Wed, 20 Dec 2023 10:09:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1703095759; x=1703700559; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HsXF47PMNjm6G+SXA9yhjR55Oa5Dgkfc/VYhUokffVU=;
        b=tchsrPnwhjPcUlXq6EqlHhK6AAfW91KElUq1LUx6F5inq3a0Vmxu3cdtma2qP/4/AK
         CZq8t8dEAv2FFZ1VyiNXt9pDs2nFM91AcoMKai5eRJMc/VvF7qKRW0YG2KLJWB/YxTXg
         qZb8cpEDWXwsyz5Xmr5QVjRVTnaO6Brpd9URVPs3g8Fqk5sT6Ap1G7MYeFm27/hQAVJ7
         NImiMsmpjD3/6jzqxY8rhMCZR+EhTFs3PfKS11ZgNObhUnENLTvmD3CFebNuBDNR605p
         +sZ3c5ST+o0xJpVR/3EsIEFvakxa7SJmcpCeM2Ih3/UUcFJvRvqKw9oiQIh+jF2p/TX+
         pXRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703095759; x=1703700559;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HsXF47PMNjm6G+SXA9yhjR55Oa5Dgkfc/VYhUokffVU=;
        b=fG+36/CeoOlGsSeMbzuFCHOMRo73eiKiUfnvKGTudH37WJcf4SPLkiaabM40WxzbcZ
         SXfknZEHHsIiC5cYa19wLrI5zliU+AiOp5Nq6WTnlr9Vfgy3WLXG+0SXSKRrz4IuckgK
         IIvgrT/DP3JHsiWzML3x7PhbetIcbyVFXbT5McsfpxzpxoyKbVOthNzmmJhSzxZuvmsD
         ZZpLj/TbtWpGHRuPyCddDdpWJS/uwZWHMmUMTo4Csh+xUAhK80nYs1z5WU+rm9Pggp9+
         UWiNspxOlDkeObAZRFZCQsdowf/lsI7qf0AKykRpBmNkD02YLSQRZZN9OgTKtfVcW1Ax
         9WJQ==
X-Gm-Message-State: AOJu0YzD4Z9MkypUPoyHP5eRrodIFVaBhTuAwtUbvz1alr6+4CSCRVYl
	zeZltejX1/9sLMQ954T56yp2ww==
X-Google-Smtp-Source: AGHT+IETkdNqYreg6GyVCHsBoMgmcya83GRKB8fhAb5mF5wdPQf/aNQ3evMSLVN4osVOYfQjDUkTmw==
X-Received: by 2002:a5e:c80a:0:b0:7ba:72d9:394e with SMTP id y10-20020a5ec80a000000b007ba72d9394emr2733704iol.0.1703095759508;
        Wed, 20 Dec 2023 10:09:19 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id fi1-20020a056638630100b0046b108628e5sm26095jab.76.2023.12.20.10.09.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Dec 2023 10:09:18 -0800 (PST)
Message-ID: <7d39e650-0879-45f1-b76c-be111b9ee38e@kernel.dk>
Date: Wed, 20 Dec 2023 11:09:17 -0700
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
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <bef81787-bb85-441f-9350-c915572ab82e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/20/23 10:04 AM, Pavel Begunkov wrote:
> On 12/20/23 16:27, Jens Axboe wrote:
>> On 12/19/23 2:03 PM, David Wei wrote:
>>> diff --git a/io_uring/net.c b/io_uring/net.c
>>> index 454ba301ae6b..7a2aadf6962c 100644
>>> --- a/io_uring/net.c
>>> +++ b/io_uring/net.c
>>> @@ -637,7 +647,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
>>>       unsigned int cflags;
>>>         cflags = io_put_kbuf(req, issue_flags);
>>> -    if (msg->msg_inq && msg->msg_inq != -1)
>>> +    if (msg && msg->msg_inq && msg->msg_inq != -1)
>>>           cflags |= IORING_CQE_F_SOCK_NONEMPTY;
>>>         if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
>>> @@ -652,7 +662,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
>>>               io_recv_prep_retry(req);
>>>               /* Known not-empty or unknown state, retry */
>>>               if (cflags & IORING_CQE_F_SOCK_NONEMPTY ||
>>> -                msg->msg_inq == -1)
>>> +                (msg && msg->msg_inq == -1))
>>>                   return false;
>>>               if (issue_flags & IO_URING_F_MULTISHOT)
>>>                   *ret = IOU_ISSUE_SKIP_COMPLETE;
>>
>> These are a bit ugly, just pass in a dummy msg for this?
>>
>>> +int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)
>>> +{
>>> +    struct io_recvzc *zc = io_kiocb_to_cmd(req, struct io_recvzc);
>>> +    struct socket *sock;
>>> +    unsigned flags;
>>> +    int ret, min_ret = 0;
>>> +    bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
>>> +    struct io_zc_rx_ifq *ifq;
>>
>> Eg
>>     struct msghdr dummy_msg;
>>
>>     dummy_msg.msg_inq = -1;
>>
>> which will eat some stack, but probably not really an issue.
>>
>>
>>> +    if (issue_flags & IO_URING_F_UNLOCKED)
>>> +        return -EAGAIN;
>>
>> This seems odd, why? If we're called with IO_URING_F_UNLOCKED set, then
> 
> It's my addition, let me explain.
> 
> io_recvzc() -> io_zc_rx_recv() -> ... -> zc_rx_recv_frag()
> 
> This chain posts completions to a buffer completion queue, and
> we don't want extra locking to share it with io-wq threads. In
> some sense it's quite similar to the CQ locking, considering
> we restrict zc to DEFER_TASKRUN. And doesn't change anything
> anyway because multishot cannot post completions from io-wq
> and are executed from the poll callback in task work.
> 
>> it's from io-wq. And returning -EAGAIN there will not do anything to
> 
> It will. It's supposed to just requeue for polling (it's not
> IOPOLL to keep retrying -EAGAIN), just like multishots do.

It definitely needs a good comment, as it's highly non-obvious when
reading the code!

> Double checking the code, it can actually terminate the request,
> which doesn't make much difference for us because multishots
> should normally never end up in io-wq anyway, but I guess we
> can improve it a liitle bit.

Right, assumptions seems to be that -EAGAIN will lead to poll arm, which
seems a bit fragile.

> And it should also use IO_URING_F_IOWQ, forgot I split out
> it from *F_UNLOCK.

Yep, that'd be clearer.

>>> +static int zc_rx_recv_frag(struct io_zc_rx_ifq *ifq, const skb_frag_t *frag,
>>> +               int off, int len, unsigned sock_idx)
>>> +{
>>> +    off += skb_frag_off(frag);
>>> +
>>> +    if (likely(page_is_page_pool_iov(frag->bv_page))) {
>>> +        struct io_uring_rbuf_cqe *cqe;
>>> +        struct io_zc_rx_buf *buf;
>>> +        struct page_pool_iov *ppiov;
>>> +
>>> +        ppiov = page_to_page_pool_iov(frag->bv_page);
>>> +        if (ppiov->pp->p.memory_provider != PP_MP_IOU_ZCRX ||
>>> +            ppiov->pp->mp_priv != ifq)
>>> +            return -EFAULT;
>>> +
>>> +        cqe = io_zc_get_rbuf_cqe(ifq);
>>> +        if (!cqe)
>>> +            return -ENOBUFS;
>>> +
>>> +        buf = io_iov_to_buf(ppiov);
>>> +        io_zc_rx_get_buf_uref(buf);
>>> +
>>> +        cqe->region = 0;
>>> +        cqe->off = io_buf_pgid(ifq->pool, buf) * PAGE_SIZE + off;
>>> +        cqe->len = len;
>>> +        cqe->sock = sock_idx;
>>> +        cqe->flags = 0;
>>> +    } else {
>>> +        return -EOPNOTSUPP;
>>> +    }
>>> +
>>> +    return len;
>>> +}
>>
>> I think this would read a lot better as:
>>
>>     if (unlikely(!page_is_page_pool_iov(frag->bv_page)))
>>         return -EOPNOTSUPP;
> 
> That's a bit of oracle coding, this branch is implemented in
> a later patch.

Oracle coding?

Each patch stands separately, there's no reason not to make this one as
clean as it can be. And an error case with the main bits inline is a lot
nicer imho than two separate indented parts. For the latter addition
instead of the -EOPNOTSUPP, would probably be nice to have it in a
separate function. Probably ditto for the page pool case here now, would
make the later patch simpler too.

-- 
Jens Axboe


