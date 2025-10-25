Return-Path: <io-uring+bounces-10206-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D20CAC090C9
	for <lists+io-uring@lfdr.de>; Sat, 25 Oct 2025 15:27:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BF8961896645
	for <lists+io-uring@lfdr.de>; Sat, 25 Oct 2025 13:27:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3E381DF759;
	Sat, 25 Oct 2025 13:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="jm2erwky"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC85238C0A
	for <io-uring@vger.kernel.org>; Sat, 25 Oct 2025 13:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761398827; cv=none; b=VJz0Wj/nQdb0LjpCtRzdLret54kstAVLhDLJwqvB5880fp119mLy303oCVvfJN9yCCPBzaeo4HXR+hoO6WepxwiYHBVPqDyqAgUFTo5BMGESgshLZpciU2SuMri82fIsJbLi78R8S6G4wmqSrtKLYSw+O8KrUxokfAmAi59UmmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761398827; c=relaxed/simple;
	bh=k8cXpNCmR28LWIgyErSMJlosiGhqYYVc3+Boi9DrAIE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Zlz4QSd6RCaK2nrbVTxIiiV/ePPJhxQVEE/pjp+ZcCQ33fHXbxLFYcoUSmhsKbDHVrKucDeVk+bI7qe9pSIHjtcmT1BoMrEGX+Oa6tl7P+78FRqxCDeNaGE/op5dNwCeqgTntVm9QLtVdTfdEBk+2lkeRBit6GeJ/mDQuN7C1qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=jm2erwky; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-430b6a0eaeaso27569865ab.1
        for <io-uring@vger.kernel.org>; Sat, 25 Oct 2025 06:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1761398824; x=1762003624; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q0o8C4vMoT/wqtVhCd1qilOO7b4cOo0+Z3kwre8J7x8=;
        b=jm2erwkyMmeoq2eZ8lFjQYOfUoNvzIBmpq9P3slJRf+HGVL2jbGvrmM3OrnCHPIGQ4
         +wDY61hK1/Hq26T53pJ/I9b5S0BIXonX+x2w2adRV50oQoKp4EWxA8D0mqUvwJ+F5vSm
         YV0pGNEC4MPP59Vp2jBOR1881zNHVmKB5+c08kKNGGblljk2pPsdOUh13++2nGtNb+gh
         sQLCGiNSAZtX7PpicU4/Gu/CCt3eyTcNuvOuRgnffBW8oToTrlobvPfkQGoH43XB/XXP
         V4437r+FyPUv2aepTPQms3KxdbGUh0ORFCIQksZKnMMeBkMFb92jzi/EHAWAjtvohupk
         KW5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761398824; x=1762003624;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q0o8C4vMoT/wqtVhCd1qilOO7b4cOo0+Z3kwre8J7x8=;
        b=sAXTuwFXvEfJbE4V/EWOFc6yJHx/jarQY2bbIARKR/ELGHkwztEfjp9ljBd7qfIp8f
         /2nUTeevM5+rfBp/CRAMsIS7CypUAaubcN3L/PoIlsOyVZbxtXzKOu59M4nTcZb6PXRv
         ZaGrRZ8hBd8R297LL4wZKTU3j4ulT4z49sYzlg34DF6oxEyk1i9xK09x3I2h0RhiwTz1
         pR0MBmVNrBes9VrXxyf6IknJdXuvgUqe7iAr02vvOH7IwR+hdmsUE+V3x8a8Gydc76Gv
         YesuGQOcbcUScbO2XlDJFsrZZ/LdGvloxX+Tll6E/Xt0qhPiPEIC6Pdi/ihz5DJxtL5h
         GYIw==
X-Forwarded-Encrypted: i=1; AJvYcCXLL/n1pjZR2LX7biLFyZaj5qXsNjDDG7CcEniDlzHWMhwaci54RhDl25KmsjRHW9FVJ1eR0fcMuQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyBuixQ+EPpikfj6jNxKSBN5JVtdgAg63d66rtJBrhnFqMVqEdk
	EMwo/ubQBTDrNpmRPoe5Z9z+nhQo/Cq3zokeq/1d1KQbj8BCTpmezorxJnCDBTzv/vk=
X-Gm-Gg: ASbGncudt6d3KVZDl9mJV+Fe+NkFcoxuuYQOYMlbJXTGuwAZlZxJQ7qs5LiVH8qDzgG
	y0EZQ2b+q7zshKkw5XWOKTlMolw4fxf2V1YLPBs/KqoaQ5CeH/2w5I5qSKc0tP0meROP3rtjNjZ
	YIwpQRI4nwcLxPj/ylMdHzhl/CQD9aoJrVMNjNRI8JdLtFo/nwhbH6y9QracYaDLTlnVCwNPPqK
	KqkTOc/r+ZE02yukt5V3Kx0uSisJz15Sh/kDX56qTdtWIyMR1gWlCMc46qCu96OKrdE0nmQoWXP
	PJ1KfTF9P54XGO2whXrHqAbCqkxPJ++RfTAXHUkTLmZJK5RW5asKWzPldCMVTwpFaAJJmHYRwQX
	2ImoK50JgHZfYigIEl1vXUBjTWrvjRK0g86vSRh+YXuDSvvQE3H6VG/Ne698MlugImIH8TzKRyg
	==
X-Google-Smtp-Source: AGHT+IEcl+ouTWzQondoTJD6nHB5VGbeQjWrfedXKmB7gFnl4vZIVF56W7+RyOoq7o8xM20OVp6aJQ==
X-Received: by 2002:a05:6e02:300a:b0:431:d864:364c with SMTP id e9e14a558f8ab-431d86438femr149277995ab.17.1761398824146;
        Sat, 25 Oct 2025 06:27:04 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-431f68747b2sm8084375ab.17.2025.10.25.06.27.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Oct 2025 06:27:02 -0700 (PDT)
Message-ID: <f61afa55-f610-478b-9079-d37ad9c2f232@kernel.dk>
Date: Sat, 25 Oct 2025 07:27:01 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] io_uring: Introduce getsockname io_uring cmd
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: netdev@vger.kernel.org, io-uring@vger.kernel.org,
 Jakub Kicinski <kuba@kernel.org>, "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>
References: <20251024154901.797262-1-krisman@suse.de>
 <20251024154901.797262-4-krisman@suse.de>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <20251024154901.797262-4-krisman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/24/25 9:49 AM, Gabriel Krisman Bertazi wrote:
> Introduce a socket-specific io_uring_cmd to support
> getsockname/getpeername via io_uring.  I made this an io_uring_cmd
> instead of a new operation to avoid polluting the command namespace with
> what is exclusively a socket operation.  In addition, since we don't
> need to conform to existing interfaces, this merges the
> getsockname/getpeername in a single operation, since the implementation
> is pretty much the same.
> 
> This has been frequently requested, for instance at [1] and more
> recently in the project Discord channel. The main use-case is to support
> fixed socket file descriptors.

Just two nits below, otherwise looks good!

> diff --git a/io_uring/cmd_net.c b/io_uring/cmd_net.c
> index 27a09aa4c9d0..092844358729 100644
> --- a/io_uring/cmd_net.c
> +++ b/io_uring/cmd_net.c
> @@ -132,6 +132,28 @@ static int io_uring_cmd_timestamp(struct socket *sock,
>  	return -EAGAIN;
>  }
>  
> +static int io_uring_cmd_getsockname(struct socket *sock,
> +				    struct io_uring_cmd *cmd,
> +				    unsigned int issue_flags)
> +{
> +	const struct io_uring_sqe *sqe = cmd->sqe;
> +

Random newline.

> +	struct sockaddr_storage address;
> +	struct sockaddr __user *uaddr;
> +	int __user *ulen;
> +	unsigned int peer;
> +
> +	uaddr = u64_to_user_ptr(READ_ONCE(sqe->addr));
> +	ulen = u64_to_user_ptr(sqe->addr3);
> +	peer = READ_ONCE(sqe->optlen);
> +
> +	if (sqe->ioprio || sqe->__pad1 || sqe->len || sqe->rw_flags)
> +		return -EINVAL;

Most/all prep handlers tend to check these first, then proceed with
setting up if not set. Would probably make sense to mirror that here
too.

-- 
Jens Axboe

