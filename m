Return-Path: <io-uring+bounces-337-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C1CA181A602
	for <lists+io-uring@lfdr.de>; Wed, 20 Dec 2023 18:10:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2DBB0B219F3
	for <lists+io-uring@lfdr.de>; Wed, 20 Dec 2023 17:10:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5ECE54777A;
	Wed, 20 Dec 2023 17:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TUHvWGe3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C2F47784;
	Wed, 20 Dec 2023 17:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-33662243274so607690f8f.1;
        Wed, 20 Dec 2023 09:10:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703092212; x=1703697012; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=b+h2yrpQ8r+d+IzV5QSLT1nRTB/7XOAtnpYPV+fCbuw=;
        b=TUHvWGe3p0t14xkarJCqlu+b1cikzu9bCCqtzBPKhAARMXmdMoh5LBnp0FPaCXnO9+
         Sm8FBwefuax2Nn0qBj++86gSEkzcqu7fyjzcGV9wuoIPNUFVcuvARZFxUQogu074sUUV
         0I4mfbqKHjDV/fFXyvd1t5tZX0cmSegdS1xWe4VG8Ba/W8lrUHfu+w/tue1qteCXx7Ty
         2whtRy3ZHafkQT3S92LAghkrfHaKW8NvqjbRjJOVw4EWm0RS0c9O0D5UANpo3DQCBa1P
         rA5vCLz7/NI64swJEwZV8CjtVGVBWblFG2k9nz5GoOnpu0MAKtTAi1aXzHxXVkIxj35v
         mN/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703092212; x=1703697012;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b+h2yrpQ8r+d+IzV5QSLT1nRTB/7XOAtnpYPV+fCbuw=;
        b=pBpNYHHFHLIG+N6HMVVJYOOXEum1p94YHFSUjhx9WthXU0HZ0uBVXMfVOPvGBtIhPm
         3PKYEB8CRSy9C2q41hVE2Q806j6kanO5PFcMGpyYgPhy8RAmrNOsj9qkA2Kkh/7NcVtN
         6wIHGi7NrhRkTwtsEU6lE4UN30vdw9UCh8PWvpaE+vkFlY7SlwHW9+UnNYkJYtkqklfF
         rXI20V6FKlLiuZTMclN0FrS35s7yIaSLa3OuyUF13dU6+B5aLqYYZ2Vq2k7yp75C+bIC
         L9gsKBCd2HRXt0hg/077eYiFhTdB+aGxPbXuznzMzrvTVroQ/BhzSxJ8JfUTCBG+BpAE
         Py9Q==
X-Gm-Message-State: AOJu0YwuhVjWwBleEZbMiB7HOputYk6//T9zImHj9OeGZU4jyCMmxnHl
	35AB0KBvIhL6QTyBr9dP3vs=
X-Google-Smtp-Source: AGHT+IFYqsAYOBAkh6gWF4y0l9MWJY3gt8tJL9QoYkb+rKP1hfx1MsO3Udcg2NDSgyrqb//7tiOwPw==
X-Received: by 2002:a05:600c:540b:b0:40c:48c2:d248 with SMTP id he11-20020a05600c540b00b0040c48c2d248mr1860584wmb.158.1703092211631;
        Wed, 20 Dec 2023 09:10:11 -0800 (PST)
Received: from [192.168.8.100] ([148.252.132.119])
        by smtp.gmail.com with ESMTPSA id bi8-20020a05600c3d8800b0040d28bbaf7bsm7475189wmb.10.2023.12.20.09.10.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Dec 2023 09:10:11 -0800 (PST)
Message-ID: <bef81787-bb85-441f-9350-c915572ab82e@gmail.com>
Date: Wed, 20 Dec 2023 17:04:14 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 15/20] io_uring: add io_recvzc request
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20231219210357.4029713-1-dw@davidwei.uk>
 <20231219210357.4029713-16-dw@davidwei.uk>
 <8a447c17-92a1-40b7-baa7-4098c7701ee9@kernel.dk>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <8a447c17-92a1-40b7-baa7-4098c7701ee9@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/20/23 16:27, Jens Axboe wrote:
> On 12/19/23 2:03 PM, David Wei wrote:
>> diff --git a/io_uring/net.c b/io_uring/net.c
>> index 454ba301ae6b..7a2aadf6962c 100644
>> --- a/io_uring/net.c
>> +++ b/io_uring/net.c
>> @@ -637,7 +647,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
>>   	unsigned int cflags;
>>   
>>   	cflags = io_put_kbuf(req, issue_flags);
>> -	if (msg->msg_inq && msg->msg_inq != -1)
>> +	if (msg && msg->msg_inq && msg->msg_inq != -1)
>>   		cflags |= IORING_CQE_F_SOCK_NONEMPTY;
>>   
>>   	if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
>> @@ -652,7 +662,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
>>   			io_recv_prep_retry(req);
>>   			/* Known not-empty or unknown state, retry */
>>   			if (cflags & IORING_CQE_F_SOCK_NONEMPTY ||
>> -			    msg->msg_inq == -1)
>> +			    (msg && msg->msg_inq == -1))
>>   				return false;
>>   			if (issue_flags & IO_URING_F_MULTISHOT)
>>   				*ret = IOU_ISSUE_SKIP_COMPLETE;
> 
> These are a bit ugly, just pass in a dummy msg for this?
> 
>> +int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)
>> +{
>> +	struct io_recvzc *zc = io_kiocb_to_cmd(req, struct io_recvzc);
>> +	struct socket *sock;
>> +	unsigned flags;
>> +	int ret, min_ret = 0;
>> +	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
>> +	struct io_zc_rx_ifq *ifq;
> 
> Eg
> 	struct msghdr dummy_msg;
> 
> 	dummy_msg.msg_inq = -1;
> 
> which will eat some stack, but probably not really an issue.
> 
> 
>> +	if (issue_flags & IO_URING_F_UNLOCKED)
>> +		return -EAGAIN;
> 
> This seems odd, why? If we're called with IO_URING_F_UNLOCKED set, then

It's my addition, let me explain.

io_recvzc() -> io_zc_rx_recv() -> ... -> zc_rx_recv_frag()

This chain posts completions to a buffer completion queue, and
we don't want extra locking to share it with io-wq threads. In
some sense it's quite similar to the CQ locking, considering
we restrict zc to DEFER_TASKRUN. And doesn't change anything
anyway because multishot cannot post completions from io-wq
and are executed from the poll callback in task work.

> it's from io-wq. And returning -EAGAIN there will not do anything to

It will. It's supposed to just requeue for polling (it's not
IOPOLL to keep retrying -EAGAIN), just like multishots do.

Double checking the code, it can actually terminate the request,
which doesn't make much difference for us because multishots
should normally never end up in io-wq anyway, but I guess we
can improve it a liitle bit.

And it should also use IO_URING_F_IOWQ, forgot I split out
it from *F_UNLOCK.

> change that. Usually this check is done to lock if we don't have it
> already, eg with io_ring_submit_unlock(). Maybe I'm missing something
> here!
> 
>> @@ -590,5 +603,230 @@ const struct pp_memory_provider_ops io_uring_pp_zc_ops = {
>>   };
>>   EXPORT_SYMBOL(io_uring_pp_zc_ops);
>>   
>> +static inline struct io_uring_rbuf_cqe *io_zc_get_rbuf_cqe(struct io_zc_rx_ifq *ifq)
>> +{
>> +	struct io_uring_rbuf_cqe *cqe;
>> +	unsigned int cq_idx, queued, free, entries;
>> +	unsigned int mask = ifq->cq_entries - 1;
>> +
>> +	cq_idx = ifq->cached_cq_tail & mask;
>> +	smp_rmb();
>> +	queued = min(io_zc_rx_cqring_entries(ifq), ifq->cq_entries);
>> +	free = ifq->cq_entries - queued;
>> +	entries = min(free, ifq->cq_entries - cq_idx);
>> +	if (!entries)
>> +		return NULL;
>> +
>> +	cqe = &ifq->cqes[cq_idx];
>> +	ifq->cached_cq_tail++;
>> +	return cqe;
>> +}
> 
> smp_rmb() here needs a good comment on what the matching smp_wmb() is,
> and why it's needed. Or maybe it should be an smp_load_acquire()?
> 
>> +
>> +static int zc_rx_recv_frag(struct io_zc_rx_ifq *ifq, const skb_frag_t *frag,
>> +			   int off, int len, unsigned sock_idx)
>> +{
>> +	off += skb_frag_off(frag);
>> +
>> +	if (likely(page_is_page_pool_iov(frag->bv_page))) {
>> +		struct io_uring_rbuf_cqe *cqe;
>> +		struct io_zc_rx_buf *buf;
>> +		struct page_pool_iov *ppiov;
>> +
>> +		ppiov = page_to_page_pool_iov(frag->bv_page);
>> +		if (ppiov->pp->p.memory_provider != PP_MP_IOU_ZCRX ||
>> +		    ppiov->pp->mp_priv != ifq)
>> +			return -EFAULT;
>> +
>> +		cqe = io_zc_get_rbuf_cqe(ifq);
>> +		if (!cqe)
>> +			return -ENOBUFS;
>> +
>> +		buf = io_iov_to_buf(ppiov);
>> +		io_zc_rx_get_buf_uref(buf);
>> +
>> +		cqe->region = 0;
>> +		cqe->off = io_buf_pgid(ifq->pool, buf) * PAGE_SIZE + off;
>> +		cqe->len = len;
>> +		cqe->sock = sock_idx;
>> +		cqe->flags = 0;
>> +	} else {
>> +		return -EOPNOTSUPP;
>> +	}
>> +
>> +	return len;
>> +}
> 
> I think this would read a lot better as:
> 
> 	if (unlikely(!page_is_page_pool_iov(frag->bv_page)))
> 		return -EOPNOTSUPP;

That's a bit of oracle coding, this branch is implemented in
a later patch.

> 
> 	...
> 	return len;
> 

-- 
Pavel Begunkov

