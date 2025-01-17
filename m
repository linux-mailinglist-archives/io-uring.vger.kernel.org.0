Return-Path: <io-uring+bounces-5969-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 255DCA14EAF
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 12:46:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 862283A3F43
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 11:46:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A889D1F790F;
	Fri, 17 Jan 2025 11:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UgpcnuJp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3F81FCD08;
	Fri, 17 Jan 2025 11:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737114395; cv=none; b=FSUwh05D/P4QjsWsJsd1G/Z6LRitOj1wddMCSoP3lz5/jPR8WGOunucsJ/mOFPgmmeYIvR9hVJ9PRwRdabKoRghoDYZ/TEDYV2haeTwqmOhufWr0qHZR1sDly1pUYNQGisq1CK+222LRGq6bQ1GEoh0764KobTJlhyw1fmvNrSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737114395; c=relaxed/simple;
	bh=wy2sGlgkCHB8XoFf72DgQXzchRd6Dnj4sl3xWt2ivSc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CmBAWTNpHreq+OxmmoF7h1FnL/n9E7AEzwMtSGwpqc2Ffvry7cvzQ0FLsUo5mTe//KalouMaALKbd2+usXc/In9f7CeNv8Cbbu8NZbTiLOf/RWmwghPWb3olSGmgD4B36ZVTjJOq8ey3MH+d2LX+G7miTzw5uEBHCyaY5L8mFJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UgpcnuJp; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5d7e3f1fdafso3949334a12.0;
        Fri, 17 Jan 2025 03:46:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737114392; x=1737719192; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Xx3KHsMXHlOHH2FEIkfq59/+Y9ujoUpH+gbFLMORCwg=;
        b=UgpcnuJpfhvPGuPW41pJmwCJDke8mTNaWjZEeKNIb8m43iTrcK/lxlfsalVJm9iew7
         SaF0kNcqYIuD7TbJzE29/2ywWLIiEp+HJPCoc7fWDF6xAPx4MoqMKTK25/r3K889B0K1
         kn7M7XJ6OAIom5iQs0a514jVE8pUvinX0reahPLNgvMuj7BZ3h3SIwazDK4fudWMS4z3
         8D2k+uvwtOfSgAdOMOyITVBqeeBTMkIU2qk7BJZOe6iCCJs32YMaPiU5mRq7I0sfsxrB
         KMOoMHjkamQQcRYCn5trITxbR4EBHL3dAnSGHmcnYDGgHBmJ2HPSpiNM3bDuTu+lNvT5
         y82A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737114392; x=1737719192;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xx3KHsMXHlOHH2FEIkfq59/+Y9ujoUpH+gbFLMORCwg=;
        b=D3e82d7LE0CJcbGNRe4EcUJk3+qW43u1fbMRt9S7R18lRZRf4lUNfsfsXojHZUUwQ2
         sfTn+U4N+v7YrgtW4NWxmfI2zdioK+SV6NE5xY0Eu6pvs6vsQCYHOTGYOgvm/9BNAXVo
         F3SFkWOlJvEAoSxfNeEMSj6Qysdo8kjtcDwdHzD4C1CVz6qG6oAH6B5v/RBTo1X6sGCc
         YXuHgvVrkobDiGuD8uw92dO9l+fSoyUP6hNKzOUdHT3xQ3zhv9IpAhTjSldf5iTvqoXQ
         xxcVXKEmOEBuoG5SeYFPqjTHrxBe2FhQsLSTisvjgMsaltWKqwQ0gSgiBGNYqQn0+Pzt
         /vBw==
X-Forwarded-Encrypted: i=1; AJvYcCX0FSEWgtpJIQFgNfuebCQUfVpB0ZMmzFkqkuiKg2uS4WAO6ALc02Lmh0SbTVrOebgTxDOK8jUnPNfr2+Vqgw==@vger.kernel.org, AJvYcCXAnJy5oZdqvzQd/PaxM3o7a+03OuOl24CM4Udi4wuLdxHSg7zDavoLBskymGvir5tChsMLIZIdpA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyyrxh77ljHJmDZ63HnMRf2N8hyVBWmCZMKiNYhYnmuxqnDfhW+
	NolF25VpK2NqUb+JZpOK4lU6GkunaqmGuuGdGQ8vo6ww3tS7MrTM
X-Gm-Gg: ASbGncsgHJuAHMA+JzqCRNhbChL1Y+QUwrlStJNHFY6U9MDHoWNcj6ojFeLtDBfXJ1y
	sbVyaVP0IR60Y2h7jjsSSP/IYJOxOUw438ov3kyh9UOI8WXph7B34DNqpWC8usZMT/sweUQ2wwp
	9RKn/RBLyMXc5KWyEufPv+WgqYQnzJnRcy2teV8CRbVP6zNVu8bW7a3yDKBP1w5OUzFsiSmbQLf
	iLIdvKvWd31OkfBZS/LqTmDW+Lx0e/lTFtw2dAUxB76tI2XljLEsQb4syEKznHFAlNnygQkrDu0
	EolTq7RPLSYAvg==
X-Google-Smtp-Source: AGHT+IFovGRiXvvOZKvsxXv/Tl/6arXE38x9R+vMzWWevtGXnm07GgBJcFQNKzcK+M604x1OYKpTCQ==
X-Received: by 2002:a05:6402:2110:b0:5da:c38:b1cf with SMTP id 4fb4d7f45d1cf-5db7d2dc135mr1905328a12.3.1737114391896;
        Fri, 17 Jan 2025 03:46:31 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:56de])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5db73eb769dsm1350228a12.50.2025.01.17.03.46.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2025 03:46:31 -0800 (PST)
Message-ID: <946df966-b50b-483c-a8cf-e480e8f9b4c3@gmail.com>
Date: Fri, 17 Jan 2025 11:47:16 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 13/17] fuse: Allow to queue fg requests through
 io-uring
To: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>,
 Josef Bacik <josef@toxicpanda.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>,
 bernd@bsbernd.com
References: <20250107-fuse-uring-for-6-10-rfc4-v9-0-9c786f9a7a9d@ddn.com>
 <20250107-fuse-uring-for-6-10-rfc4-v9-13-9c786f9a7a9d@ddn.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250107-fuse-uring-for-6-10-rfc4-v9-13-9c786f9a7a9d@ddn.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/7/25 00:25, Bernd Schubert wrote:
> This prepares queueing and sending foreground requests through
> io-uring.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com> # io_uring


> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
> ---
>   fs/fuse/dev_uring.c   | 185 ++++++++++++++++++++++++++++++++++++++++++++++++--
>   fs/fuse/dev_uring_i.h |  11 ++-
>   2 files changed, 187 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> index 01a908b2ef9ada14b759ca047eab40b4c4431d89..89a22a4eee23cbba49bac7a2d2126bb51193326f 100644
> --- a/fs/fuse/dev_uring.c
> +++ b/fs/fuse/dev_uring.c
> @@ -26,6 +26,29 @@ bool fuse_uring_enabled(void)
>   	return enable_uring;
>   }
>  
...
> +
> +/*
> + * This prepares and sends the ring request in fuse-uring task context.
> + * User buffers are not mapped yet - the application does not have permission
> + * to write to it - this has to be executed in ring task context.
> + */
> +static void
> +fuse_uring_send_req_in_task(struct io_uring_cmd *cmd,
> +			    unsigned int issue_flags)
> +{
> +	struct fuse_ring_ent *ent = uring_cmd_to_ring_ent(cmd);
> +	struct fuse_ring_queue *queue = ent->queue;
> +	int err;
> +
> +	if (unlikely(issue_flags & IO_URING_F_TASK_DEAD)) {
> +		err = -ECANCELED;
> +		goto terminating;
> +	}
> +
> +	err = fuse_uring_prepare_send(ent);
> +	if (err)
> +		goto err;
> +
> +terminating:
> +	spin_lock(&queue->lock);
> +	ent->state = FRRS_USERSPACE;
> +	list_move(&ent->list, &queue->ent_in_userspace);
> +	spin_unlock(&queue->lock);
> +	io_uring_cmd_done(cmd, err, 0, issue_flags);
> +	ent->cmd = NULL;

Might be worth moving inside the critical section as well.


-- 
Pavel Begunkov


