Return-Path: <io-uring+bounces-6588-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EA544A3E505
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2025 20:29:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 046DE1889AA3
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2025 19:29:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C459E24BD10;
	Thu, 20 Feb 2025 19:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="qpPcsQyI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321A82139CE
	for <io-uring@vger.kernel.org>; Thu, 20 Feb 2025 19:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740079745; cv=none; b=NKZwPpXkq/xytlSX3htfTA60xkmNEpukRxETKyCB7dQxgQSgKRsTR1iT3O4JPTNZeMmntM8WZyhzptNuE0Tiq2hyDrOTSLxuRFktBpmXHEHxovPREe6KajhLEdVAmfo8BhdMs3JNOBWFNlNyxnX8EhOTWTw8YF+Z2Z/P8oTlwXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740079745; c=relaxed/simple;
	bh=Z5WG/dXI1BeTd8dauMdu8taEINCJjgvylDcox/Y6vps=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S12sj+uQheEIQAQjnXnIlwssspVThBJ3FEv7PVrqwc9zPCPE8KaR/RqvhkbHByHoxq7yiGlSBICpteXjEwZODQE+e1Jgfw0OY4pOlOVbK3DE+xqZuODpzermW5B85TWfV9Y3e0DdXe7t1a9xNOdBfZupxHFJJa6bLllQdrShl4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=qpPcsQyI; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-221050f3f00so28424385ad.2
        for <io-uring@vger.kernel.org>; Thu, 20 Feb 2025 11:29:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1740079743; x=1740684543; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q8YHsuiy1+f/A6GfVm+1NpN16RWiUayntjMvwwlwPWo=;
        b=qpPcsQyIqtrKSsBtLqjPU/TXXELHrfOI5cHOlpPz2EwEgnKXqPd9884HJhILh6iJEK
         uPWw+IJAk8IcEZGsO4tSeZgq0dJHH2mmgfKpHZJYKtfmr/404WSW+hAaIh4UZXIH1qDG
         u0riQ6e91xytgu2UNley9YzCOpWELP22S36WH/cOPilQzn5YNKHyosLCE8SRkoxIltqU
         tGnbxbuRWQ2sprCuF/OvYkQCerxcGK6hP/GREDHIuZMXt88cRg+C8N9Vt624nVUSo8wQ
         yl9m67/YnJwtVQ+X7aNovZozRA/C1+xIfXOXOwSzST6kxlSTgZK66UUEiBho+E0pLBR6
         b3Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740079743; x=1740684543;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q8YHsuiy1+f/A6GfVm+1NpN16RWiUayntjMvwwlwPWo=;
        b=IP/hYhC4eO9WGbcht55n4gEidtQoZ/TFa8tZd185mjlEB+sB1IrDAnzoC+JY1ZD3Y9
         EpSjmRIJMlB1ymd2HNRHZHjh1yo5QPSwXDJAdRBoWJxgka5LBxq298V5v9DJj4LHNeE5
         12JjKzzgOo44OjWTIPBL7z5/p5O5dNOcwslq+PsGa4BymInXx0oX8JMr+Mr0oTr5ps5+
         GtaZGggwn3U2EtPQXO38reUOD38fMwTcYQ6AbVKgroK4DfdERuuw+my2F6oGrZ8KfCpB
         IB9ZW2vLYTbFu6YkQat/UuZ+sGDLQyo9RrnGihN9MzUy02gnqdnG/9gyjEjt2UegsaTn
         xk+A==
X-Forwarded-Encrypted: i=1; AJvYcCU40M/99dipMx9lC0+acMkygfUe8lJ9WSjVD0oeEPaHumT5fyuLZ1bljwV64hbJeaHAaeFyFbRM8A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1VOBlICOpD2BW1GsNjBxhcCYTp83fUlBZgUu4VNwprE8sEdYU
	bZksWbTL19LsfqMrs6/zlbRrHZP1oUUnfmSckvzN5u4rwAD4/xDTNAt/2knHGMY=
X-Gm-Gg: ASbGnctFh1uoykoEwPF6QHK4Z1G6EMMX3nu1vvoXsmYUue/lKB8xUAThKFc31MTPKqN
	vMQfNtfp2zW33H6Ec2TqdwaCglh/xdJXT8zVeVyIixz31cnLBjes69DvgWXt/kmY9R3HT+fJorh
	jupY0dgUkGapjls4pkOx/a+TQHrpks5aCJHFbIjE/rgF2bwLTpnnVbZxY5ghqvk95fuPnqjvJa/
	68mYEKX6lepS6iRqnYHSmYpmJrqqg/i8Bmn681+tAle2ihakZpT+OtBUjiTGXQW5WDWelvFrXAQ
	qhyIQTmHMIDzMqBXFDowAbVU/VZUshcjD2BjZR3rGWkoZamBYZ77iA==
X-Google-Smtp-Source: AGHT+IEWL1CJJIlw8wKxBVIA4VDp1ROlSiE+1PdAElJt82OynPmlWxDAlVLjKvSBprf2tnzuTuNdxA==
X-Received: by 2002:a05:6a00:3e14:b0:730:949d:2d36 with SMTP id d2e1a72fcca58-73426d77d68mr97516b3a.18.1740079743390;
        Thu, 20 Feb 2025 11:29:03 -0800 (PST)
Received: from ?IPV6:2a03:83e0:1156:1:18cb:90d0:372a:99ae? ([2620:10d:c090:500::6:d6c0])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73242568adasm14683273b3a.52.2025.02.20.11.29.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2025 11:29:03 -0800 (PST)
Message-ID: <32e90909-f6b5-4810-b2f1-30c6c9767159@davidwei.uk>
Date: Thu, 20 Feb 2025 11:29:00 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/2] io_uring/zcrx: add single shot recvzc
Content-Language: en-GB
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Simon Horman <horms@kernel.org>
References: <20250218165714.56427-1-dw@davidwei.uk>
 <20250218165714.56427-2-dw@davidwei.uk>
 <270ce534-d33e-4642-b0dc-87e377025825@gmail.com>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <270ce534-d33e-4642-b0dc-87e377025825@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025-02-20 05:45, Pavel Begunkov wrote:
> On 2/18/25 16:57, David Wei wrote:
>> Currently only multishot recvzc requests are supported, but sometimes
>> there is a need to do a single recv e.g. peeking at some data in the
>> socket. Add single shot recvzc requests where IORING_RECV_MULTISHOT is
>> _not_ set and the sqe->len field is set to the number of bytes to read
>> N.
>>
>> There could be multiple completions containing data, like the multishot
>> case, since N bytes could be split across multiple frags. This is
>> followed by a final completion with res and cflags both set to 0 that
>> indicate the completion of the request, or a -res that indicate an
>> error.
>>
>> Signed-off-by: David Wei <dw@davidwei.uk>
>> ---
>>   io_uring/net.c  | 26 ++++++++++++++++++--------
>>   io_uring/zcrx.c | 17 ++++++++++++++---
>>   io_uring/zcrx.h |  2 +-
>>   3 files changed, 33 insertions(+), 12 deletions(-)
>>
>> diff --git a/io_uring/net.c b/io_uring/net.c
>> index 000dc70d08d0..d3a9aaa52a13 100644
>> --- a/io_uring/net.c
>> +++ b/io_uring/net.c
>> @@ -94,6 +94,7 @@ struct io_recvzc {
>>       struct file            *file;
>>       unsigned            msg_flags;
>>       u16                flags;
>> +    u32                len;
> 
> Something is up with the types, it's u32, for which you use
> UINT_MAX, and later convert to ulong.

Inconsistency is my middle name.

I'll fix it up.

> 
>>       struct io_zcrx_ifq        *ifq;
>>   };
>>   
> ...
>> @@ -1250,6 +1251,9 @@ int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>       zc->ifq = req->ctx->ifq;
>>       if (!zc->ifq)
>>           return -EINVAL;
>> +    zc->len = READ_ONCE(sqe->len);
>> +    if (zc->len == UINT_MAX)
>> +        return -EINVAL;
>>         zc->flags = READ_ONCE(sqe->ioprio);
>>       zc->msg_flags = READ_ONCE(sqe->msg_flags);
>> @@ -1257,12 +1261,14 @@ int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>           return -EINVAL;
>>       if (zc->flags & ~(IORING_RECVSEND_POLL_FIRST | IORING_RECV_MULTISHOT))
>>           return -EINVAL;
>> -    /* multishot required */
>> -    if (!(zc->flags & IORING_RECV_MULTISHOT))
>> -        return -EINVAL;
>> -    /* All data completions are posted as aux CQEs. */
>> -    req->flags |= REQ_F_APOLL_MULTISHOT;
>> -
>> +    if (zc->flags & IORING_RECV_MULTISHOT) {
>> +        if (zc->len)
>> +            return -EINVAL;
>> +        /* All data completions are posted as aux CQEs. */
>> +        req->flags |= REQ_F_APOLL_MULTISHOT;
> 
> If you're posting "aux" cqes you have to set the flag for
> synchronisation reasons. We probably can split out a "I want to post
> aux cqes" flag, but it seems like you don't actually care about
> multishot here but limiting the length, or limiting the length + nowait.

Yeah, it's still "multishot" because there are still aux cqes for data
notifications. The requested N bytes could be in multiple frags. I'll
make sure REQ_F_APOLL_MULTISHOT is set.

> 
>> +    }
>> +    if (!zc->len)
>> +        zc->len = UINT_MAX;
>>       return 0;
>>   }
>>   @@ -1281,7 +1287,7 @@ int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)
>>           return -ENOTSOCK;
>>         ret = io_zcrx_recv(req, zc->ifq, sock, zc->msg_flags | MSG_DONTWAIT,
>> -               issue_flags);
>> +               issue_flags, zc->len);
>>       if (unlikely(ret <= 0) && ret != -EAGAIN) {
>>           if (ret == -ERESTARTSYS)
>>               ret = -EINTR;
>> @@ -1296,6 +1302,10 @@ int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)
>>           return IOU_OK;
>>       }
>>   +    if (zc->len != UINT_MAX) {
>> +        io_req_set_res(req, ret, 0);
>> +        return IOU_OK;
>> +    }
>>       if (issue_flags & IO_URING_F_MULTISHOT)
>>           return IOU_ISSUE_SKIP_COMPLETE;
>>       return -EAGAIN;
>> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
>> index ea099f746599..834c887743c8 100644
>> --- a/io_uring/zcrx.c
>> +++ b/io_uring/zcrx.c
>> @@ -106,6 +106,7 @@ struct io_zcrx_args {
>>       struct io_zcrx_ifq    *ifq;
>>       struct socket        *sock;
>>       unsigned        nr_skbs;
>> +    unsigned long        len;
>>   };
>>     static const struct memory_provider_ops io_uring_pp_zc_ops;
>> @@ -826,6 +827,10 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
>>       int i, copy, end, off;
>>       int ret = 0;
>>   +    if (args->len == 0)
>> +        return -EINTR;
>> +    len = (args->len != UINT_MAX) ? min_t(size_t, len, args->len) : len;
> 
> Just min?

Yes :facepalm:

> 
>> +
>>       if (unlikely(args->nr_skbs++ > IO_SKBS_PER_CALL_LIMIT))
>>           return -EAGAIN;
>>   @@ -920,17 +925,21 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
>>   out:
>>       if (offset == start_off)
>>           return ret;
>> +    args->len -= (offset - start_off);
> 
> Doesn't it unconditionally change the magic value UINT_MAX
> you're trying to preserve?

Yes, you're right. I will fix this and add a test case.

> 
>> +    if (args->len == 0)
>> +        desc->count = 0;
>>       return offset - start_off;
>>   }
>>     static int io_zcrx_tcp_recvmsg(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
>>                   struct sock *sk, int flags,
>> -                unsigned issue_flags)
>> +                unsigned issue_flags, unsigned long len)
>>   {
>>       struct io_zcrx_args args = {
>>           .req = req,
>>           .ifq = ifq,
>>           .sock = sk->sk_socket,
>> +        .len = len,
>>       };
>>       read_descriptor_t rd_desc = {
>>           .count = 1,
>> @@ -956,6 +965,8 @@ static int io_zcrx_tcp_recvmsg(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
>>           ret = IOU_REQUEUE;
>>       } else if (sock_flag(sk, SOCK_DONE)) {
>>           /* Make it to retry until it finally gets 0. */
>> +        if (len != UINT_MAX)
>> +            goto out;
>>           if (issue_flags & IO_URING_F_MULTISHOT)
>>               ret = IOU_REQUEUE;
>>           else
> 

