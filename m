Return-Path: <io-uring+bounces-6626-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C1E80A403DB
	for <lists+io-uring@lfdr.de>; Sat, 22 Feb 2025 01:08:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0E5C619E1058
	for <lists+io-uring@lfdr.de>; Sat, 22 Feb 2025 00:08:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E55F1800;
	Sat, 22 Feb 2025 00:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="TAZbWjue"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906703D76
	for <io-uring@vger.kernel.org>; Sat, 22 Feb 2025 00:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740182888; cv=none; b=QW3Ahwy7eONhS4xjjTAhYW/AMmm2AwGjPkpw9T5tnE8RkDFCf87zj2rWKmmmScdat4Yx+yJpe6tRPiopkxdWFEzkx24Z6qvzR/fwc9xGraxBYAUi/2J4kYx4RYYCpEyU+rrIpJ/atr2/n0u3wQzoINlVOh9YGXTmcShgAzj0u6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740182888; c=relaxed/simple;
	bh=qVpljStXkBw4vpKtugP25NBAN2p7XHPd1f9u6+Mu3wA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D5ElrjwMrNXsMtBjsVENcHLbqYh5VDUkOSAwgPAjBXSCz99/5QlwLOzxFnxHX3GVSZtXarFGp+ael2Sj7Q4kG2dr6vlPEMmg+L6TDMmUq8J1SouuyqnlO6bKo8GCrWXSaB91oYcF0pZew8NNXMarpzBeq8efwVlsNmsKJaSLj5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=TAZbWjue; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-855b77783e9so76869139f.3
        for <io-uring@vger.kernel.org>; Fri, 21 Feb 2025 16:08:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740182884; x=1740787684; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yJqTxh0S/Wt+3bZ/KrFwInPIwwWKP1ybDG+Eb3+yceI=;
        b=TAZbWjueEGY+q1v4FFohO41u5UBAiYjALwhnVTGUnSuNAD32JZK9k9DNOv3r44KSgm
         PND1J7+suI6xpNbWf3rNAIpUuEiquMoVxNFGSQPIYhrQk0JwyfSpKHoO75xttEarcN7O
         MIDnCgVBsAVCy96RpMUbpucJV3N9hWcAf4PO6+84HVukmqNsra58UcJHew08KQgX+gsH
         A1cczCQjl+zHZ8caNJFguvEt8gqm4bDfQRwW2jYo9FR7+ahuIiWXf0kvkEbOKcyhkhE/
         qI4q5oZpUIyzWXuDMpxsEKkLkePoD9VAQ6tVFWvP4Xlc+e1Tr+OV0m6K7b1fGONEXetY
         kzXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740182884; x=1740787684;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yJqTxh0S/Wt+3bZ/KrFwInPIwwWKP1ybDG+Eb3+yceI=;
        b=feAEj1bJXjcWAekR8zUc/PFBBG8HkjGjobyXroNN+O6Q/KU91wuhhfrJUEIFqi2fa/
         On1NmabPRhINgBGC6+UCvuCKstJ8fsC5dkhUDCTKohIqCDeNmd9qKQ/6hkwucAGxIJ9c
         2Eebs32qR6vhHLJVZ5vXwHhDL90MiYU/NMuVbSDTefgaMovSJOzRTG201sAZdH4/Z3Dx
         WPtPROpPSKMsfWXNg06KKBnDHLlZeOifvOdXka0VkuUW1aemrbV8fdcpHjBqxsXRM3sm
         K+ISz/MGlCuc3WS1hDyPpBz69ldPJlS/kaWvzy9rv4nHUx/45LHHEQTHHe03VMnK50Sc
         ez1g==
X-Forwarded-Encrypted: i=1; AJvYcCWBpRtt39Ed1TJMd9RGkMDffmC65MRjYi39TYv9owOrLtJqNnzIhwtfAWbKhYzPd5AcspT1d7GkfA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxTs8iezaHIugrRRrZaje2Be2/2B4lMyhDl4yKKLj72Z4yS6cGb
	0zugPIKFwVN5ZYe4eAKoeOE9St7ps5Lx/iE+yHYUsQHQiRz0BEtDg+4BNGTYg8c=
X-Gm-Gg: ASbGnctBgZeYjW9sp/8RgT+yBX1A0mF6tIiQeHyRJmi3OXoxlcZjVlJb5kN1XeTgW8I
	oqdRD4F/sxS3B0A4/5DC80eYMsMivKegeWGTlw7vZxC9P/vkI9kSeKb2BVdgB+/NogWwHQKFVmd
	hURxdEzDu9jRhUMoG12o4/s8sZCDPCe7NMmXhISxCCN+X3ykr+Au2tLgi2XIEBwAS3zUQslL+IW
	hD5X/qzLJn2IPveHDseL5gSgPzHFywfdkgMRf1VyrLY+YEt1DikxKuyjnFd9gOBO61j5FmOSEss
	Vbma/aZYZ0D9Zr+PCggclgs=
X-Google-Smtp-Source: AGHT+IHLseNXFe6GPClXEbdamfk2/3kNPnz5xrtNqxsdR4B0zAXhYvYrqMUz5Zp3wwr/43U5x0W1qA==
X-Received: by 2002:a05:6e02:3103:b0:3d2:6f1e:8a4b with SMTP id e9e14a558f8ab-3d2cb5151ccmr49378585ab.16.1740182884277;
        Fri, 21 Feb 2025 16:08:04 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4eeba18a947sm1608286173.127.2025.02.21.16.08.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2025 16:08:03 -0800 (PST)
Message-ID: <9d081ae3-6f9d-48d2-a14c-f53430a523d0@kernel.dk>
Date: Fri, 21 Feb 2025 17:08:02 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] io_uring/zcrx: add single shot recvzc
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>
References: <20250221205146.1210952-1-dw@davidwei.uk>
 <20250221205146.1210952-2-dw@davidwei.uk>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250221205146.1210952-2-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Just a few minor drive-by nits.

> @@ -1250,6 +1251,12 @@ int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  	zc->ifq = req->ctx->ifq;
>  	if (!zc->ifq)
>  		return -EINVAL;
> +	zc->len = READ_ONCE(sqe->len);
> +	if (zc->len == UINT_MAX)
> +		return -EINVAL;
> +	/* UINT_MAX means no limit on readlen */
> +	if (!zc->len)
> +		zc->len = UINT_MAX;

Why not just make UINT_MAX allowed, meaning no limit? Would avoid two
branches here, and as far as I can tell not really change anything in
terms of API niceness.

> @@ -1269,6 +1276,7 @@ int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)
>  {
>  	struct io_recvzc *zc = io_kiocb_to_cmd(req, struct io_recvzc);
> +	bool limit = zc->len != UINT_MAX;
>  	struct socket *sock;
>  	int ret;

Doesn't seem to be used?

> @@ -1296,6 +1304,13 @@ int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)
>  		return IOU_OK;
>  	}
>  
> +	if (zc->len == 0) {
> +		io_req_set_res(req, 0, 0);
> +
> +		if (issue_flags & IO_URING_F_MULTISHOT)
> +			return IOU_STOP_MULTISHOT;
> +		return IOU_OK;
> +	}
>  	if (issue_flags & IO_URING_F_MULTISHOT)
>  		return IOU_ISSUE_SKIP_COMPLETE;
>  	return -EAGAIN;

Might be cleaner as:

	ret = -EAGAIN;
	if (!zc->len) {
		io_req_set_res(req, 0, 0);
		ret = -IOU_OK;
	}
  	if (issue_flags & IO_URING_F_MULTISHOT)
  		return IOU_ISSUE_SKIP_COMPLETE;
  	return ret;

rather than duplicate the flag checking.


>  static int io_zcrx_tcp_recvmsg(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
>  				struct sock *sk, int flags,
> -				unsigned issue_flags)
> +				unsigned issue_flags, unsigned int *outlen)
>  {
> +	unsigned int len = *outlen;
> +	bool limit = len != UINT_MAX;
>  	struct io_zcrx_args args = {
>  		.req = req,
>  		.ifq = ifq,
>  		.sock = sk->sk_socket,
>  	};
>  	read_descriptor_t rd_desc = {
> -		.count = 1,
> +		.count = len,
>  		.arg.data = &args,
>  	};
>  	int ret;
>  
>  	lock_sock(sk);
>  	ret = tcp_read_sock(sk, &rd_desc, io_zcrx_recv_skb);
> +	if (limit && ret)
> +		*outlen = len - ret;
>  	if (ret <= 0) {
>  		if (ret < 0 || sock_flag(sk, SOCK_DONE))
>  			goto out;
> @@ -930,7 +937,7 @@ static int io_zcrx_tcp_recvmsg(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
>  		ret = IOU_REQUEUE;
>  	} else if (sock_flag(sk, SOCK_DONE)) {
>  		/* Make it to retry until it finally gets 0. */
> -		if (issue_flags & IO_URING_F_MULTISHOT)
> +		if (!limit && (issue_flags & IO_URING_F_MULTISHOT))
>  			ret = IOU_REQUEUE;
>  		else
>  			ret = -EAGAIN;

In the two above hunks, the limit checking feels a bit hackish. For
example, why is it related to multishot or not? I think the patch would
benefit from being split into separate patches for singleshot and length
support. Eg one that adds singleshot support, and then one that adds
length capping on top. That would make it much easier to reason about
hunks like the above one.

> @@ -942,7 +949,7 @@ static int io_zcrx_tcp_recvmsg(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
>  
>  int io_zcrx_recv(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
>  		 struct socket *sock, unsigned int flags,
> -		 unsigned issue_flags)
> +		 unsigned issue_flags, unsigned int *len)
>  {
>  	struct sock *sk = sock->sk;
>  	const struct proto *prot = READ_ONCE(sk->sk_prot);

Shouldn't recv support it too?

-- 
Jens Axboe

