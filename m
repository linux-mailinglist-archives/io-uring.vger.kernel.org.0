Return-Path: <io-uring+bounces-6649-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E737A4126E
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 01:17:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 44A6316FEFD
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 00:17:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F528567D;
	Mon, 24 Feb 2025 00:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="rJljjNav"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC56E10F2
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 00:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740356235; cv=none; b=h2I4XT+0BWRo3rN4sE9Mz72QzPEzsempst4W/yzrUPhwKX2XLI7OkCccvdmrRYUdqyDN4/nave8U2rtjtzCZkBzBP8MJNUbLAEcFUm7ckO5GzIN4wdqivHaBGB5PHI7ZYn28biR6PlLVudweGdiHwJgwJTDT7uFFgANc8xvEnnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740356235; c=relaxed/simple;
	bh=4k4wutT66nv0SiOylkanSQUaajkPTPPa+2/71ZXYdgc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mwT8OxZdu587rvPuA0DfT44utkR0o43iYKH2r0HbVr0iHIo5v/8QG6WSNK3FNuBKHuB/bwDrPWaWJZLjR+mkFrszhYLNYbCowTGZqH4eOfHAfPDNazZtsS+PnyYQsG4oG5Bqf7x4MB5tWN6pi5V1ZsrjU42nW8sf7XC8YKCCORg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=rJljjNav; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-220c8eb195aso83219545ad.0
        for <io-uring@vger.kernel.org>; Sun, 23 Feb 2025 16:17:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1740356233; x=1740961033; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1ahYM3aQdeU+NmOWaNchEWAfBdO/AxsNMn7QYR2TtsE=;
        b=rJljjNavqtgDUTZ6RB+MJEK3yMgBmyRJs+vMeZj3tAbrvr+fuAnN5r11fNnc8yl+aE
         wgmSVpupWut/RHrWdf3ZcrzK1HWaYZx6waxvAsstLwC5s9Ub+YZ5+YF/kLhvAE+LNLMD
         eE0WMPDgdwpSsqO/XleElWGlLyU8ve7WYNRpvaqEjm+PnCqfC1TlDZ/u6bKFHlqQJ/Qm
         gut37C/aOkl+XUa/fgdOORuEzY1DE65tNKgICqCKMf26XAHc6SEcgqldOwGTLQf8P1sQ
         Sq7gimuwJx5OguhjiGginqyfUFavs3yjAqPFMZPrf+nS8jd1KKMGxnwonW4K3xqBBoYJ
         K5GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740356233; x=1740961033;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1ahYM3aQdeU+NmOWaNchEWAfBdO/AxsNMn7QYR2TtsE=;
        b=hHYtbRN6eD9stjzIh1A3EIKj010L4MpHqCP+HeKBk5n3SOB1Ys4esdfD6qAuwaviwU
         nhhZoASlsxkMy5yuPTc4DHH/Q0F1GOeXIKpQnPEJ8WeISH+bfQs9NX1MzX4lsy7kUUD3
         vpJ5bFdDixjlePbE7gh17egBt0hxSEljYKddOinsyG1OiuK5Q9WgLENMULAa2rVjITS0
         onbHNM97FXN9oHtJmOPpqjdQrqbLmE6bKDZbzLQq30nxychnCCJ/X2GRtbxsIj6w84n9
         ekPGqRt3HcDMiRGMoyns4w/MIBIYRGL7Hz/QUwujSHPf3V90IxiYZifWXdh92Cheg0AD
         ylgA==
X-Forwarded-Encrypted: i=1; AJvYcCW6zFz6n6OHNEOZYEseANPSEWAogVPQI3VyKqUjjXzKePeIx2rzQ1tSAXDrec1UggQsUVwiyqN24g==@vger.kernel.org
X-Gm-Message-State: AOJu0YwAaYplDHZLEbEowlnrGJBYISMEqHW+E+4gndNGdQHB+8QUU0q8
	hLl/ss5Ww2omOZHCU/uPe8CtWe28ObJ/TviLWtQL4bX/Xn5pi0fssaN2EClyPo0=
X-Gm-Gg: ASbGncv0sY49XVPoiBXRo+uLqqR0KrvKB1wf1ExyO36U3QW42lJIzDwgrtJAkOapr6V
	Ilbagw4gTyhhDq8azInns6phltlO211UDT/gSKy1jVh18lF5HHsIyP7yEwAjE+e+q43RcCpirOr
	VreGwQnmKego7nZjBiSvRp5PzepLiczU3Vl33ncMhY5/AOdukE78pOOU/Rxjbx3icjGKtQK/thN
	dEBjc8idHAlFxqaJGdBUIF2lSPe6cusXYU+Sgzlh1UseZPWmYapl95nwWXs0X1ZkBv+ZP/gCwc2
	6lF/aRqxZlVC6qOlUluQ1MItaWBAS593
X-Google-Smtp-Source: AGHT+IE5NGbq19/m6vaLuznQKlvzFt8PGr+M5P855D0nZAZ1Lobz9KNSOKGIPTVkYBJpNxc2AmPouQ==
X-Received: by 2002:a17:902:d4d0:b0:21f:6a22:b294 with SMTP id d9443c01a7336-2219ff5f93bmr226931605ad.28.1740356232960;
        Sun, 23 Feb 2025 16:17:12 -0800 (PST)
Received: from [192.168.1.12] ([97.126.136.10])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-220d5348f7asm169892255ad.23.2025.02.23.16.17.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Feb 2025 16:17:12 -0800 (PST)
Message-ID: <9d8b1613-ed11-4313-9d47-a5fc357ba910@davidwei.uk>
Date: Sun, 23 Feb 2025 16:17:12 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] io_uring/zcrx: add single shot recvzc
Content-Language: en-GB
To: lizetao <lizetao1@huawei.com>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <20250221205146.1210952-1-dw@davidwei.uk>
 <20250221205146.1210952-2-dw@davidwei.uk>
 <28fef9180ec04610b601b15c06eb70c5@huawei.com>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <28fef9180ec04610b601b15c06eb70c5@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025-02-22 00:54, lizetao wrote:
> Hi,
> 
>> -----Original Message-----
>> From: David Wei <dw@davidwei.uk>
>> Sent: Saturday, February 22, 2025 4:52 AM
>> To: io-uring@vger.kernel.org
>> Cc: Jens Axboe <axboe@kernel.dk>; Pavel Begunkov <asml.silence@gmail.com>
>> Subject: [PATCH v2 1/2] io_uring/zcrx: add single shot recvzc
>>
>> Currently only multishot recvzc requests are supported, but sometimes there is
>> a need to do a single recv e.g. peeking at some data in the socket. Add single
>> shot recvzc requests where IORING_RECV_MULTISHOT is _not_ set and the sqe-
>>> len field is set to the number of bytes to read N.
>>
>> There could be multiple completions containing data, like the multishot case,
>> since N bytes could be split across multiple frags. This is followed by a final
>> completion with res and cflags both set to 0 that indicate the completion of the
>> request, or a -res that indicate an error.
>>
>> Signed-off-by: David Wei <dw@davidwei.uk>
>> ---
>>  io_uring/net.c  | 19 +++++++++++++++++--  io_uring/zcrx.c | 17 ++++++++++++--
>> ---  io_uring/zcrx.h |  2 +-
>>  3 files changed, 30 insertions(+), 8 deletions(-)
>>
>> diff --git a/io_uring/net.c b/io_uring/net.c index 000dc70d08d0..cae34a24266c
>> 100644
>> --- a/io_uring/net.c
>> +++ b/io_uring/net.c
>> @@ -94,6 +94,7 @@ struct io_recvzc {
>>  	struct file			*file;
>>  	unsigned			msg_flags;
>>  	u16				flags;
>> +	u32				len;
>>  	struct io_zcrx_ifq		*ifq;
>>  };
>>
>> @@ -1241,7 +1242,7 @@ int io_recvzc_prep(struct io_kiocb *req, const struct
>> io_uring_sqe *sqe)
>>  	unsigned ifq_idx;
>>
>>  	if (unlikely(sqe->file_index || sqe->addr2 || sqe->addr ||
>> -		     sqe->len || sqe->addr3))
>> +		     sqe->addr3))
>>  		return -EINVAL;
>>
>>  	ifq_idx = READ_ONCE(sqe->zcrx_ifq_idx); @@ -1250,6 +1251,12 @@
>> int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>  	zc->ifq = req->ctx->ifq;
>>  	if (!zc->ifq)
>>  		return -EINVAL;
>> +	zc->len = READ_ONCE(sqe->len);
>> +	if (zc->len == UINT_MAX)
>> +		return -EINVAL;
>> +	/* UINT_MAX means no limit on readlen */
> 
> What is the difference between unlimited read length and IO_URING_F_MULTISHOT?
> In what specific scenarios would unlimited read length be used?

I will clean up the terminology in the next revision. There isn't a
singleshot vs multishot as such. Rather, it's an unlimited multishot vs
a limited multishot. The unlimited multishot request would be a typical
multishot recv that will keep reading data from the socket. The limited
multishot request will read up to a limit N before completing the
request.

> 
>> +	if (!zc->len)
>> +		zc->len = UINT_MAX;
>>
>>  	zc->flags = READ_ONCE(sqe->ioprio);
>>  	zc->msg_flags = READ_ONCE(sqe->msg_flags); @@ -1269,6 +1276,7
>> @@ int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>> int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)  {
>>  	struct io_recvzc *zc = io_kiocb_to_cmd(req, struct io_recvzc);
>> +	bool limit = zc->len != UINT_MAX;
> 
> It is not used.
> 
>>  	struct socket *sock;
>>  	int ret;
>>
>> @@ -1281,7 +1289,7 @@ int io_recvzc(struct io_kiocb *req, unsigned int
>> issue_flags)
>>  		return -ENOTSOCK;
>>
>>  	ret = io_zcrx_recv(req, zc->ifq, sock, zc->msg_flags | MSG_DONTWAIT,
>> -			   issue_flags);
>> +			   issue_flags, &zc->len);
>>  	if (unlikely(ret <= 0) && ret != -EAGAIN) {
>>  		if (ret == -ERESTARTSYS)
>>  			ret = -EINTR;
>> @@ -1296,6 +1304,13 @@ int io_recvzc(struct io_kiocb *req, unsigned int
>> issue_flags)
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
>> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c index
>> f2d326e18e67..74bca4e471bc 100644
>> --- a/io_uring/zcrx.c
>> +++ b/io_uring/zcrx.c
>> @@ -817,6 +817,7 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct
>> sk_buff *skb,
>>  	int i, copy, end, off;
>>  	int ret = 0;
>>
>> +	len = min_t(size_t, len, desc->count);
>>  	if (unlikely(args->nr_skbs++ > IO_SKBS_PER_CALL_LIMIT))
>>  		return -EAGAIN;
>>
>> @@ -894,26 +895,32 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct
>> sk_buff *skb,
>>  out:
>>  	if (offset == start_off)
>>  		return ret;
>> +	if (desc->count != UINT_MAX)
>> +		desc->count -= (offset - start_off);
>>  	return offset - start_off;
>>  }
>>
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
>> @@ -930,7 +937,7 @@ static int io_zcrx_tcp_recvmsg(struct io_kiocb *req,
>> struct io_zcrx_ifq *ifq,
>>  		ret = IOU_REQUEUE;
>>  	} else if (sock_flag(sk, SOCK_DONE)) {
>>  		/* Make it to retry until it finally gets 0. */
>> -		if (issue_flags & IO_URING_F_MULTISHOT)
>> +		if (!limit && (issue_flags & IO_URING_F_MULTISHOT))
>>  			ret = IOU_REQUEUE;
>>  		else
>>  			ret = -EAGAIN;
>> @@ -942,7 +949,7 @@ static int io_zcrx_tcp_recvmsg(struct io_kiocb *req,
>> struct io_zcrx_ifq *ifq,
>>
>>  int io_zcrx_recv(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
>>  		 struct socket *sock, unsigned int flags,
>> -		 unsigned issue_flags)
>> +		 unsigned issue_flags, unsigned int *len)
>>  {
>>  	struct sock *sk = sock->sk;
>>  	const struct proto *prot = READ_ONCE(sk->sk_prot); @@ -951,5
>> +958,5 @@ int io_zcrx_recv(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
>>  		return -EPROTONOSUPPORT;
>>
>>  	sock_rps_record_flow(sk);
>> -	return io_zcrx_tcp_recvmsg(req, ifq, sk, flags, issue_flags);
>> +	return io_zcrx_tcp_recvmsg(req, ifq, sk, flags, issue_flags, len);
>>  }
>> diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h index
>> a16bdd921f03..1b4042dc48e2 100644
>> --- a/io_uring/zcrx.h
>> +++ b/io_uring/zcrx.h
>> @@ -46,7 +46,7 @@ void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx);  void
>> io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx);  int io_zcrx_recv(struct io_kiocb
>> *req, struct io_zcrx_ifq *ifq,
>>  		 struct socket *sock, unsigned int flags,
>> -		 unsigned issue_flags);
>> +		 unsigned issue_flags, unsigned int *len);
>>  #else
>>  static inline int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
>>  					struct io_uring_zcrx_ifq_reg __user
>> *arg)
>> --
>> 2.43.5
>>
>>
> 
> ---
> Li Zetao

