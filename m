Return-Path: <io-uring+bounces-6630-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 931C4A4047A
	for <lists+io-uring@lfdr.de>; Sat, 22 Feb 2025 02:00:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1CC9370272B
	for <lists+io-uring@lfdr.de>; Sat, 22 Feb 2025 01:00:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDB6917578;
	Sat, 22 Feb 2025 01:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BeuzGSeJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E0B10E4
	for <io-uring@vger.kernel.org>; Sat, 22 Feb 2025 01:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740186019; cv=none; b=MwSdJ7xXZy8kPQZvJhTULfoHWyjabVfs/dZNztS/zo4y8YVnrb4jrfAi1GJpjsw5NhtF/1vEBkJFqvdsVgPKjlsVLOXSNzvCmj7xe4laTk665hazrCq7QllpENy5RAQTHqdfOwl73ymrHAX7Ubu0WWD5MRjx1jEMw/H3/UZ7d1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740186019; c=relaxed/simple;
	bh=fvZjyNq7uur6pK2DO6TAWYg9sCGNdv+vwh9Xi/shr6I=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=R+fLjtcBsK2By3fLi18osoXNMEXklOgXdKP9vTY8XJryowdtIvK3a7VnMSp/Y9HjuTF3qkP2xTlkTXRyZoiHswanUobWIWi/vpTC/ej70vML2DDLDo3iRMyE6slsvDPEburp5swYXFuQkklGWLYMpTlveR018MaooUPPvvDxt5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BeuzGSeJ; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4398c8c8b2cso26980265e9.2
        for <io-uring@vger.kernel.org>; Fri, 21 Feb 2025 17:00:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740186016; x=1740790816; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SHzEcslDV1V1fGYHCmENge5jvwOluqiG5GCHUFVoMDs=;
        b=BeuzGSeJf5wyWRGFfqS+PvZJQCWSIFge4Bvl3t/Ckz8pRe7dVlY5ENZzNfeKdr8Qdg
         XSn1YxNbvi+9thVgmXvJdko7SEB292VUD2XnwUsnG8q2D84s/qsicHZzR8Zc9pYQO6RM
         3WSLGw+QzA9L4FpfYsCkBjV4uJAkLhOsziSSy17Of9Qbh8rM7SH7ZT4OIsEVXkKgmSi8
         N4qr75tqU40KqeF/xtH12QB9kirD5t3O0vd7Rim35r89GbcBM0fj04yRme7xttj9oRc6
         t0OnRHkkzWUCB9Q/Kt6eweTbkXMbR7yDlzKkyJqe8A5kl4zY6OHXZWsfzDj9K7fK04s1
         SvIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740186016; x=1740790816;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SHzEcslDV1V1fGYHCmENge5jvwOluqiG5GCHUFVoMDs=;
        b=dBY8R8qZJMaMoKSx39G/2dip6jNaHkZJx4ASgiz3FcebuyYpWtnyGYIk6NxigqDaHB
         r3HGtHzAwXBKko3YJcRvdDrMo2FGTHilbYaLxcQS/3DcEpfqVnlrFKAGaNstt1nBxBCp
         AJqWcwEJR4i4G0kg4vQI6qdseWwxVr+3F3QZ5BOqp00K/AyAMJteZH6x0ByMDod/NxDu
         JCgmxe8tDhESUwpXNqgkxSu9Zm4JD2ytM4g6ukYIcv9G0XqlyG49G+LMqRRs/Tg4tirP
         SsMNVRmSjJG40nBOkT00dLyO4EtcRuLsoZ+h3VrMLUdf2KOQLcNazBT0HRXhxfBiRQiT
         avMw==
X-Forwarded-Encrypted: i=1; AJvYcCXyZFO8SAZfPmUZeAsj03b1jzUtZ2lXlfSWiSKn1nTnuZuCN6GKcDdrp3cODejTKgDjFlEiRTdiSQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3TBSOnL3J5DwFYb/+hBlSi7/iaIpzIEVPwD6fmjiN9X3wANwE
	3DwwR6a2gfQE8NTJd88hHqkMKKiBptiaOr7mGAsNmCfOXOAviNWH
X-Gm-Gg: ASbGncvyMPNwFkADYB+AA/vKhaPWv1ouBgFj85+bzbyelokI0o2wR5aG7QjVcUt5OVp
	NJ7DbIsekc5s0eesBXYNEl2w+2nq+LKmZgOLw/h6KRm35uXusxc10SYYOqDrR7/Djcq6SZhN0l9
	hKpASq3RiYaiqRVY/mUixUuvh12aoUX+nS9LR3SpHrhsvhNgoAESGqx49DhgyM41r8wBDcKfJI7
	+XtpONK46gINteEzx8uvDRViUHIRrQ6j8s5GEToq2wChfsD4yo6GMuGPvMoOvzRvUxzk+Nj0QXq
	A1Zax4RjzYDb/Js9XYypfo0HM612x74fHDAI
X-Google-Smtp-Source: AGHT+IEhHRC5XW0oKI5o10y2qeAjxhtrlqbwsVB8/J+p/B9AkaR8xHE59gkAklKqwa1UAgZGNcNHuQ==
X-Received: by 2002:a05:600c:5125:b0:439:8c9c:6d32 with SMTP id 5b1f17b1804b1-439ae1f0d96mr49463555e9.13.1740186016131;
        Fri, 21 Feb 2025 17:00:16 -0800 (PST)
Received: from [192.168.8.100] ([148.252.141.194])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f25915785sm25497340f8f.58.2025.02.21.17.00.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2025 17:00:14 -0800 (PST)
Message-ID: <f8409430-a83d-4bda-a654-3f9bedb36bbc@gmail.com>
Date: Sat, 22 Feb 2025 01:01:19 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] io_uring/zcrx: add single shot recvzc
To: Jens Axboe <axboe@kernel.dk>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org
References: <20250221205146.1210952-1-dw@davidwei.uk>
 <20250221205146.1210952-2-dw@davidwei.uk>
 <9d081ae3-6f9d-48d2-a14c-f53430a523d0@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <9d081ae3-6f9d-48d2-a14c-f53430a523d0@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/22/25 00:08, Jens Axboe wrote:
> Just a few minor drive-by nits.
> 
>> @@ -1250,6 +1251,12 @@ int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>   	zc->ifq = req->ctx->ifq;
>>   	if (!zc->ifq)
>>   		return -EINVAL;
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

I think 0 goes better as a special uapi value. It doesn't alter the
uapi, and commonly understood as "no limits", which is the opposite
to the other option, especially since UINT_MAX is not a max value for
an unlimited request, I'd easily expect it to drive more than 4GB.

  
>> @@ -1269,6 +1276,7 @@ int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>   int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)
>>   {
>>   	struct io_recvzc *zc = io_kiocb_to_cmd(req, struct io_recvzc);
>> +	bool limit = zc->len != UINT_MAX;
>>   	struct socket *sock;
>>   	int ret;
> 
> Doesn't seem to be used?
> 
>> @@ -1296,6 +1304,13 @@ int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)
>>   		return IOU_OK;
>>   	}
>>   
>> +	if (zc->len == 0) {
>> +		io_req_set_res(req, 0, 0);
>> +
>> +		if (issue_flags & IO_URING_F_MULTISHOT)
>> +			return IOU_STOP_MULTISHOT;
>> +		return IOU_OK;
>> +	}
>>   	if (issue_flags & IO_URING_F_MULTISHOT)
>>   		return IOU_ISSUE_SKIP_COMPLETE;
>>   	return -EAGAIN;
> 
> Might be cleaner as:
> 
> 	ret = -EAGAIN;
> 	if (!zc->len) {
> 		io_req_set_res(req, 0, 0);
> 		ret = -IOU_OK;
> 	}
>    	if (issue_flags & IO_URING_F_MULTISHOT)
>    		return IOU_ISSUE_SKIP_COMPLETE;
>    	return ret;
> 
> rather than duplicate the flag checking.

You missed IOU_STOP_MULTISHOT, but even without it separate error
codes for polling is already an utter mess to try be smart about it.
I'll try to clean it up, but that's orthogonal.

...
>> @@ -930,7 +937,7 @@ static int io_zcrx_tcp_recvmsg(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
>>   		ret = IOU_REQUEUE;
>>   	} else if (sock_flag(sk, SOCK_DONE)) {
>>   		/* Make it to retry until it finally gets 0. */
>> -		if (issue_flags & IO_URING_F_MULTISHOT)
>> +		if (!limit && (issue_flags & IO_URING_F_MULTISHOT))
>>   			ret = IOU_REQUEUE;
>>   		else
>>   			ret = -EAGAIN;
> 
> In the two above hunks, the limit checking feels a bit hackish. For
> example, why is it related to multishot or not? I think the patch would
> benefit from being split into separate patches for singleshot and length

I agree with the statement, but fwiw there are no single shots and
can't be that, the message is misleading.

> support. Eg one that adds singleshot support, and then one that adds
> length capping on top. That would make it much easier to reason about
> hunks like the above one.
> 
>> @@ -942,7 +949,7 @@ static int io_zcrx_tcp_recvmsg(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
>>   
>>   int io_zcrx_recv(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
>>   		 struct socket *sock, unsigned int flags,
>> -		 unsigned issue_flags)
>> +		 unsigned issue_flags, unsigned int *len)
>>   {
>>   	struct sock *sk = sock->sk;
>>   	const struct proto *prot = READ_ONCE(sk->sk_prot);
> 
> Shouldn't recv support it too?

There is no "msg" variant of the request, if that's what you mean.

-- 
Pavel Begunkov


