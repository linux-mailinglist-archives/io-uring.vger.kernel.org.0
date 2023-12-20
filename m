Return-Path: <io-uring+bounces-334-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A64AC81A500
	for <lists+io-uring@lfdr.de>; Wed, 20 Dec 2023 17:28:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CA5331C241C1
	for <lists+io-uring@lfdr.de>; Wed, 20 Dec 2023 16:28:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BA8B3F8D6;
	Wed, 20 Dec 2023 16:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="MkAPsEId"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19D746548
	for <io-uring@vger.kernel.org>; Wed, 20 Dec 2023 16:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-35faacfc938so4186655ab.0
        for <io-uring@vger.kernel.org>; Wed, 20 Dec 2023 08:27:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1703089656; x=1703694456; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C1mIxSkGcvMHEXrssQiRTyVaXILE2LihmkPcIKX6/gc=;
        b=MkAPsEIdr2xEf0VvEc38f/GNSxc/oLr+F7v5jwQEF2BpCZC3iRJgl0QDf5XUdomj/6
         6xAruhQYE1KrUWjN9XXkrnpfrgJJFUnxrEFnRoMjvaQa4wTa3zJXiGFuOgkkD/k+oCHM
         z3Z+XMsfGOBn+nE/6RRot4H5DTdpngoFzHI3Sx4he1dXT6OVC3/GJ/iyrAnASXGgMA5C
         R9hXS4N6e1/xv3yffOuvNQFWBMDpMQAlXKb5JScqKEn8JohFSpNSEWlDxd6q3H1UGdjE
         M6mhLoL/19mrWjMHr5wHZTNymXEqkZ2GMSehZDO8MXuoIGavcIq0N/fNGSPyU5KnWr39
         IS6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703089656; x=1703694456;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C1mIxSkGcvMHEXrssQiRTyVaXILE2LihmkPcIKX6/gc=;
        b=lmN7NVa3T32fSl1t4WyUTvGb5zU1MXyEvVmzbcMJKHZ3X9cGUv6bjRfJeaqzWO3Jb2
         5+NI4Jls+XqVNHY4LiXQb3Xq0b5auZiGIqt7ihGSuIFkhDF4tYtCMKCKE+9zYQ61ewR5
         sihjjQlIoKOMTtYnehPzTiAXRUEVqvBRxqDopPmzsEQxVj3m94udckIahTXkluCso+/X
         BgH/ptm3Mb+BynA1UW95/vOYqDXR+qoMinneZQDIyux+/KvlB3zvr3VyYnRRA4lvGlgP
         ibLLUI+k/OfW7DeOa43GrX24IcDwAEYXr184QxgZF83l2xdb7zcEQS1C9QcR9/ZOoy8T
         OwWQ==
X-Gm-Message-State: AOJu0Yx2xQBLIoJsTW+wZcL1L13HMJlkZr8mte1OrVKAd+gAQfj/q+kj
	URhdH/NF5ljdNn++tMsZMAj9pA==
X-Google-Smtp-Source: AGHT+IH50PBEGf5gW0w+VdHMBw4QC6kHfejgepXL9iGd3W8WHe1WhtmMK5aEeSKarRuV/ugQprzcDw==
X-Received: by 2002:a6b:fe09:0:b0:7b4:2e28:2343 with SMTP id x9-20020a6bfe09000000b007b42e282343mr33254830ioh.1.1703089654139;
        Wed, 20 Dec 2023 08:27:34 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ce6-20020a0566381a8600b0046b692e719esm845855jab.150.2023.12.20.08.27.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Dec 2023 08:27:33 -0800 (PST)
Message-ID: <8a447c17-92a1-40b7-baa7-4098c7701ee9@kernel.dk>
Date: Wed, 20 Dec 2023 09:27:32 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 15/20] io_uring: add io_recvzc request
Content-Language: en-US
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20231219210357.4029713-1-dw@davidwei.uk>
 <20231219210357.4029713-16-dw@davidwei.uk>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20231219210357.4029713-16-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/19/23 2:03 PM, David Wei wrote:
> diff --git a/io_uring/net.c b/io_uring/net.c
> index 454ba301ae6b..7a2aadf6962c 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -637,7 +647,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
>  	unsigned int cflags;
>  
>  	cflags = io_put_kbuf(req, issue_flags);
> -	if (msg->msg_inq && msg->msg_inq != -1)
> +	if (msg && msg->msg_inq && msg->msg_inq != -1)
>  		cflags |= IORING_CQE_F_SOCK_NONEMPTY;
>  
>  	if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
> @@ -652,7 +662,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
>  			io_recv_prep_retry(req);
>  			/* Known not-empty or unknown state, retry */
>  			if (cflags & IORING_CQE_F_SOCK_NONEMPTY ||
> -			    msg->msg_inq == -1)
> +			    (msg && msg->msg_inq == -1))
>  				return false;
>  			if (issue_flags & IO_URING_F_MULTISHOT)
>  				*ret = IOU_ISSUE_SKIP_COMPLETE;

These are a bit ugly, just pass in a dummy msg for this?

> +int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)
> +{
> +	struct io_recvzc *zc = io_kiocb_to_cmd(req, struct io_recvzc);
> +	struct socket *sock;
> +	unsigned flags;
> +	int ret, min_ret = 0;
> +	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
> +	struct io_zc_rx_ifq *ifq;

Eg
	struct msghdr dummy_msg;

	dummy_msg.msg_inq = -1;

which will eat some stack, but probably not really an issue.


> +	if (issue_flags & IO_URING_F_UNLOCKED)
> +		return -EAGAIN;

This seems odd, why? If we're called with IO_URING_F_UNLOCKED set, then
it's from io-wq. And returning -EAGAIN there will not do anything to
change that. Usually this check is done to lock if we don't have it
already, eg with io_ring_submit_unlock(). Maybe I'm missing something
here!

> @@ -590,5 +603,230 @@ const struct pp_memory_provider_ops io_uring_pp_zc_ops = {
>  };
>  EXPORT_SYMBOL(io_uring_pp_zc_ops);
>  
> +static inline struct io_uring_rbuf_cqe *io_zc_get_rbuf_cqe(struct io_zc_rx_ifq *ifq)
> +{
> +	struct io_uring_rbuf_cqe *cqe;
> +	unsigned int cq_idx, queued, free, entries;
> +	unsigned int mask = ifq->cq_entries - 1;
> +
> +	cq_idx = ifq->cached_cq_tail & mask;
> +	smp_rmb();
> +	queued = min(io_zc_rx_cqring_entries(ifq), ifq->cq_entries);
> +	free = ifq->cq_entries - queued;
> +	entries = min(free, ifq->cq_entries - cq_idx);
> +	if (!entries)
> +		return NULL;
> +
> +	cqe = &ifq->cqes[cq_idx];
> +	ifq->cached_cq_tail++;
> +	return cqe;
> +}

smp_rmb() here needs a good comment on what the matching smp_wmb() is,
and why it's needed. Or maybe it should be an smp_load_acquire()?

> +
> +static int zc_rx_recv_frag(struct io_zc_rx_ifq *ifq, const skb_frag_t *frag,
> +			   int off, int len, unsigned sock_idx)
> +{
> +	off += skb_frag_off(frag);
> +
> +	if (likely(page_is_page_pool_iov(frag->bv_page))) {
> +		struct io_uring_rbuf_cqe *cqe;
> +		struct io_zc_rx_buf *buf;
> +		struct page_pool_iov *ppiov;
> +
> +		ppiov = page_to_page_pool_iov(frag->bv_page);
> +		if (ppiov->pp->p.memory_provider != PP_MP_IOU_ZCRX ||
> +		    ppiov->pp->mp_priv != ifq)
> +			return -EFAULT;
> +
> +		cqe = io_zc_get_rbuf_cqe(ifq);
> +		if (!cqe)
> +			return -ENOBUFS;
> +
> +		buf = io_iov_to_buf(ppiov);
> +		io_zc_rx_get_buf_uref(buf);
> +
> +		cqe->region = 0;
> +		cqe->off = io_buf_pgid(ifq->pool, buf) * PAGE_SIZE + off;
> +		cqe->len = len;
> +		cqe->sock = sock_idx;
> +		cqe->flags = 0;
> +	} else {
> +		return -EOPNOTSUPP;
> +	}
> +
> +	return len;
> +}

I think this would read a lot better as:

	if (unlikely(!page_is_page_pool_iov(frag->bv_page)))
		return -EOPNOTSUPP;

	...
	return len;

> +zc_rx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
> +	       unsigned int offset, size_t len)
> +{
> +	struct io_zc_rx_args *args = desc->arg.data;
> +	struct io_zc_rx_ifq *ifq = args->ifq;
> +	struct socket *sock = args->sock;
> +	unsigned sock_idx = sock->zc_rx_idx & IO_ZC_IFQ_IDX_MASK;
> +	struct sk_buff *frag_iter;
> +	unsigned start, start_off;
> +	int i, copy, end, off;
> +	int ret = 0;
> +
> +	start = skb_headlen(skb);
> +	start_off = offset;
> +
> +	if (offset < start)
> +		return -EOPNOTSUPP;
> +
> +	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
> +		const skb_frag_t *frag;
> +
> +		WARN_ON(start > offset + len);

This probably can't happen, but should it abort if it did?

> +
> +		frag = &skb_shinfo(skb)->frags[i];
> +		end = start + skb_frag_size(frag);
> +
> +		if (offset < end) {
> +			copy = end - offset;
> +			if (copy > len)
> +				copy = len;
> +
> +			off = offset - start;
> +			ret = zc_rx_recv_frag(ifq, frag, off, copy, sock_idx);
> +			if (ret < 0)
> +				goto out;
> +
> +			offset += ret;
> +			len -= ret;
> +			if (len == 0 || ret != copy)
> +				goto out;
> +		}
> +		start = end;
> +	}
> +
> +	skb_walk_frags(skb, frag_iter) {
> +		WARN_ON(start > offset + len);
> +
> +		end = start + frag_iter->len;
> +		if (offset < end) {
> +			copy = end - offset;
> +			if (copy > len)
> +				copy = len;
> +
> +			off = offset - start;
> +			ret = zc_rx_recv_skb(desc, frag_iter, off, copy);
> +			if (ret < 0)
> +				goto out;
> +
> +			offset += ret;
> +			len -= ret;
> +			if (len == 0 || ret != copy)
> +				goto out;
> +		}
> +		start = end;
> +	}
> +
> +out:
> +	smp_store_release(&ifq->ring->cq.tail, ifq->cached_cq_tail);
> +	if (offset == start_off)
> +		return ret;
> +	return offset - start_off;
> +}
> +
> +static int io_zc_rx_tcp_read(struct io_zc_rx_ifq *ifq, struct sock *sk)
> +{
> +	struct io_zc_rx_args args = {
> +		.ifq = ifq,
> +		.sock = sk->sk_socket,
> +	};
> +	read_descriptor_t rd_desc = {
> +		.count = 1,
> +		.arg.data = &args,
> +	};
> +
> +	return tcp_read_sock(sk, &rd_desc, zc_rx_recv_skb);
> +}
> +
> +static int io_zc_rx_tcp_recvmsg(struct io_zc_rx_ifq *ifq, struct sock *sk,
> +				unsigned int recv_limit,
> +				int flags, int *addr_len)
> +{
> +	size_t used;
> +	long timeo;
> +	int ret;
> +
> +	ret = used = 0;
> +
> +	lock_sock(sk);
> +
> +	timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
> +	while (recv_limit) {
> +		ret = io_zc_rx_tcp_read(ifq, sk);
> +		if (ret < 0)
> +			break;
> +		if (!ret) {
> +			if (used)
> +				break;
> +			if (sock_flag(sk, SOCK_DONE))
> +				break;
> +			if (sk->sk_err) {
> +				ret = sock_error(sk);
> +				break;
> +			}
> +			if (sk->sk_shutdown & RCV_SHUTDOWN)
> +				break;
> +			if (sk->sk_state == TCP_CLOSE) {
> +				ret = -ENOTCONN;
> +				break;
> +			}
> +			if (!timeo) {
> +				ret = -EAGAIN;
> +				break;
> +			}
> +			if (!skb_queue_empty(&sk->sk_receive_queue))
> +				break;
> +			sk_wait_data(sk, &timeo, NULL);
> +			if (signal_pending(current)) {
> +				ret = sock_intr_errno(timeo);
> +				break;
> +			}
> +			continue;
> +		}
> +		recv_limit -= ret;
> +		used += ret;
> +
> +		if (!timeo)
> +			break;
> +		release_sock(sk);
> +		lock_sock(sk);
> +
> +		if (sk->sk_err || sk->sk_state == TCP_CLOSE ||
> +		    (sk->sk_shutdown & RCV_SHUTDOWN) ||
> +		    signal_pending(current))
> +			break;
> +	}
> +	release_sock(sk);
> +	/* TODO: handle timestamping */
> +	return used ? used : ret;
> +}
> +
> +int io_zc_rx_recv(struct io_zc_rx_ifq *ifq, struct socket *sock,
> +		  unsigned int limit, unsigned int flags)
> +{
> +	struct sock *sk = sock->sk;
> +	const struct proto *prot;
> +	int addr_len = 0;
> +	int ret;
> +
> +	if (flags & MSG_ERRQUEUE)
> +		return -EOPNOTSUPP;
> +
> +	prot = READ_ONCE(sk->sk_prot);
> +	if (prot->recvmsg != tcp_recvmsg)
> +		return -EPROTONOSUPPORT;
> +
> +	sock_rps_record_flow(sk);
> +
> +	ret = io_zc_rx_tcp_recvmsg(ifq, sk, limit, flags, &addr_len);
> +
> +	return ret;
> +}


return io_zc_rx_tcp_recvmsg(ifq, sk, limit, flags, &addr_len);

and then you can remove 'int ret' as well.

-- 
Jens Axboe


