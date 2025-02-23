Return-Path: <io-uring+bounces-6646-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FADFA4120F
	for <lists+io-uring@lfdr.de>; Sun, 23 Feb 2025 23:39:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 29DF5171A3A
	for <lists+io-uring@lfdr.de>; Sun, 23 Feb 2025 22:39:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4B806EB7C;
	Sun, 23 Feb 2025 22:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="corTlJkt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C0C10A3E
	for <io-uring@vger.kernel.org>; Sun, 23 Feb 2025 22:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740350373; cv=none; b=mBxIL9wKQP9XaDmfT/wcDrik2O7qsZiZEQr3siYVtc54NxOHjXwp6o403Dy5aEA058Mq7lowyE6YSaay8gc4+dsz2eSBk8vmkz7aLmWvlOWsJWzqrhQCr5y0m8rD/Hjn26kmlsTpq/uLIyx4cQByU5iwRPRxgmS09ENqtyo45S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740350373; c=relaxed/simple;
	bh=WzIAPoPyhamaGXz9MUD8R5W70hPlgTaTk1J5orti5V8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Tne0bf4rb9pUgf9z34fb0HkTANerK4sdGSg/m01cGLjmKgQrWGwRd1o0bDmQGcWxEnZmSEmEE7SPzWvG/Hs6EY7q8VYHGfhNdPlctLOw2rVPvpcinZNNl5D6cwaPt7iP3Y+HvTIYUH4VgpflL4GsjAzqDNsDBUIb8/dJab5ObJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=corTlJkt; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2fa8ac56891so6033423a91.2
        for <io-uring@vger.kernel.org>; Sun, 23 Feb 2025 14:39:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1740350371; x=1740955171; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Gz1DG9QaPoFKx+otnJjGNoemPLJmjpSwHL7HRLfvR+0=;
        b=corTlJktE3Ffbh/EtxcS/Fjj4RdKeYOwlSns8gyiqv+7Dm81XRkprglptrqbQMrMYK
         iCeGEaYhDEqfY7Xxid3TPMs1fKoNXG78dMif0ADoAXxYrROsWvD26vEvpiDw3kpOdru+
         1nO6JveSVO3KVKd1c2GdEb5ZX7PkToKzhO60j/hl/wSX8DVIT6spPvHFIIySr+W2Vljr
         aRuqk0bBpcgycymcwajlNQJo6bpuPvKvhk7VNYiRvGjlzIx2N1oS8pwT7XOALg8qIIXJ
         KePxm2sxS/Zv3k+sMeRT1uLsz1QM6wWwI8OC7C9WMWGmL2zW0cfyuT95Jxpzpji3nSF/
         vkvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740350371; x=1740955171;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gz1DG9QaPoFKx+otnJjGNoemPLJmjpSwHL7HRLfvR+0=;
        b=GCSjWfv0BPy+ahaikL9yJUJcCxyafojFt/hW1bxtyefrp8V3MtBQ9mrslKVpo+l+cO
         PD1oeY8qL3kFFWVHxZkRMqqgJWM0ivYyY2hlsO6xGNs/XDrdvbut89xwwL8RkdLnMwOT
         oSyvzZfQ0jwNjNdnDMYtz7IEJgtHr3tkYzwjuOyOS0Qm3Xq+zxkKQXRxHSGxcNjdKeZz
         h654WQSYy8UK5Sm8RLwzvAQV30MHmR+rJOnLGYa9YdDWvbcfFt+wuqypmWfdxFZJdetk
         CAXcOGudQIMjP+YdMItwUSYIB2lnkAb5aGWK6N1hQ9M7Orlbh+trbJMUwOKsY2msImss
         yd+w==
X-Forwarded-Encrypted: i=1; AJvYcCUpzcAIZdEVHnXcoQ9CK15IepvvBkNo4XEfH/erOYpefW4yBFR5ZRxLJu0waGSxHUUNP8wsI86bbw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzrcXLfWkTcSi+gxJQwExgrpRnVQOVLd8vi6vSd/uj7Pfs1Aykw
	SOH3rv8EFbVBvJh760vnMebzM+D9qoXh7H00CLDeOKO+PsOINzODadSZtpsO+9I=
X-Gm-Gg: ASbGnctQ9cm7hfq+VQZRzffB1646spaxTCb93rn4hXYOw4i8N2e99XWjPABRgL4vfjA
	8W0R964U45xpN6H+zOofq5RF4PzValcy3QZQ8SX0LngYaOm8SZFr4mf2bsOUFoQBwNfH3ha8af1
	Jct/Z8PH9x0u/lXWgdAW1S848MBtN1gpPQJnREX37N9qvVWFmG3c2ONdbcsz1Zgv4sCuIbamYWW
	mvTVGUInRifcTTMxe3fvoxcfTR79wH/fMqqKHIeFuV46npnIJnn03a87w/57B/5YGL4UD57h7Fr
	PcMjEcz9i0ijf8Lis9QQjHiz08LxRKHP
X-Google-Smtp-Source: AGHT+IGbT7kTyNq8n8mIH374VKBIiRocXB4l+EKwSrDaCWyChd1TNFSOXL6efGJKQusvEvphgFmPEA==
X-Received: by 2002:a17:90b:2b8f:b0:2ea:3f34:f194 with SMTP id 98e67ed59e1d1-2fce78aab09mr19801264a91.10.1740350371534;
        Sun, 23 Feb 2025 14:39:31 -0800 (PST)
Received: from [192.168.1.12] ([97.126.136.10])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2fceb12dc0fsm5791743a91.46.2025.02.23.14.39.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Feb 2025 14:39:31 -0800 (PST)
Message-ID: <228cb021-f471-4597-aefe-63b8075413b5@davidwei.uk>
Date: Sun, 23 Feb 2025 14:39:30 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] io_uring/zcrx: add single shot recvzc
Content-Language: en-GB
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>
References: <20250221205146.1210952-1-dw@davidwei.uk>
 <20250221205146.1210952-2-dw@davidwei.uk>
 <9d081ae3-6f9d-48d2-a14c-f53430a523d0@kernel.dk>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <9d081ae3-6f9d-48d2-a14c-f53430a523d0@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025-02-21 16:08, Jens Axboe wrote:
> Just a few minor drive-by nits.
> 
>> @@ -1250,6 +1251,12 @@ int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>  	zc->ifq = req->ctx->ifq;
>>  	if (!zc->ifq)
>>  		return -EINVAL;
>> +	zc->len = READ_ONCE(sqe->len);
>> +	if (zc->len == UINT_MAX)
>> +		return -EINVAL;
>> +	/* UINT_MAX means no limit on readlen */
>> +	if (!zc->len)
>> +		zc->len = UINT_MAX;
> 
> Why not just make UINT_MAX allowed, meaning no limit? Would avoid two
> branches here, and as far as I can tell not really change anything in
> terms of API niceness.
> 
>> @@ -1269,6 +1276,7 @@ int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>  int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)
>>  {
>>  	struct io_recvzc *zc = io_kiocb_to_cmd(req, struct io_recvzc);
>> +	bool limit = zc->len != UINT_MAX;
>>  	struct socket *sock;
>>  	int ret;
> 
> Doesn't seem to be used?

Oops, I'll remove it.

> 
>> @@ -1296,6 +1304,13 @@ int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)
>>  		return IOU_OK;
>>  	}
>>  
>> +	if (zc->len == 0) {
>> +		io_req_set_res(req, 0, 0);
>> +
>> +		if (issue_flags & IO_URING_F_MULTISHOT)
>> +			return IOU_STOP_MULTISHOT;
>> +		return IOU_OK;
>> +	}
>>  	if (issue_flags & IO_URING_F_MULTISHOT)
>>  		return IOU_ISSUE_SKIP_COMPLETE;
>>  	return -EAGAIN;
> 
> Might be cleaner as:
> 
> 	ret = -EAGAIN;
> 	if (!zc->len) {
> 		io_req_set_res(req, 0, 0);
> 		ret = -IOU_OK;
> 	}
>   	if (issue_flags & IO_URING_F_MULTISHOT)
>   		return IOU_ISSUE_SKIP_COMPLETE;
>   	return ret;
> 
> rather than duplicate the flag checking.
> 
> 
>>  static int io_zcrx_tcp_recvmsg(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
>>  				struct sock *sk, int flags,
>> -				unsigned issue_flags)
>> +				unsigned issue_flags, unsigned int *outlen)
>>  {
>> +	unsigned int len = *outlen;
>> +	bool limit = len != UINT_MAX;
>>  	struct io_zcrx_args args = {
>>  		.req = req,
>>  		.ifq = ifq,
>>  		.sock = sk->sk_socket,
>>  	};
>>  	read_descriptor_t rd_desc = {
>> -		.count = 1,
>> +		.count = len,
>>  		.arg.data = &args,
>>  	};
>>  	int ret;
>>  
>>  	lock_sock(sk);
>>  	ret = tcp_read_sock(sk, &rd_desc, io_zcrx_recv_skb);
>> +	if (limit && ret)
>> +		*outlen = len - ret;
>>  	if (ret <= 0) {
>>  		if (ret < 0 || sock_flag(sk, SOCK_DONE))
>>  			goto out;
>> @@ -930,7 +937,7 @@ static int io_zcrx_tcp_recvmsg(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
>>  		ret = IOU_REQUEUE;
>>  	} else if (sock_flag(sk, SOCK_DONE)) {
>>  		/* Make it to retry until it finally gets 0. */
>> -		if (issue_flags & IO_URING_F_MULTISHOT)
>> +		if (!limit && (issue_flags & IO_URING_F_MULTISHOT))
>>  			ret = IOU_REQUEUE;
>>  		else
>>  			ret = -EAGAIN;
> 
> In the two above hunks, the limit checking feels a bit hackish. For
> example, why is it related to multishot or not? I think the patch would
> benefit from being split into separate patches for singleshot and length
> support. Eg one that adds singleshot support, and then one that adds
> length capping on top. That would make it much easier to reason about
> hunks like the above one.
> 
>> @@ -942,7 +949,7 @@ static int io_zcrx_tcp_recvmsg(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
>>  
>>  int io_zcrx_recv(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
>>  		 struct socket *sock, unsigned int flags,
>> -		 unsigned issue_flags)
>> +		 unsigned issue_flags, unsigned int *len)
>>  {
>>  	struct sock *sk = sock->sk;
>>  	const struct proto *prot = READ_ONCE(sk->sk_prot);
> 
> Shouldn't recv support it too?
> 

