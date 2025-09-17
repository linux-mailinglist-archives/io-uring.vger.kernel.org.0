Return-Path: <io-uring+bounces-9826-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 12FFEB7FF5A
	for <lists+io-uring@lfdr.de>; Wed, 17 Sep 2025 16:26:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 209211C87B05
	for <lists+io-uring@lfdr.de>; Wed, 17 Sep 2025 14:20:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 211C7296BC0;
	Wed, 17 Sep 2025 14:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="USa1h2N6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603E82D46B3
	for <io-uring@vger.kernel.org>; Wed, 17 Sep 2025 14:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758118699; cv=none; b=F6JasgtXQTzxIQdHShweTWQT8nI9qlMhKjZW2Iqo8qkUywBTr5qJGJJRk3yOSqa54NrTelvVEUBKLM7PWE84ErNwYkQhkTcACr0yTOqwDHN1f3ZuLJuhF8DYJ6Op52GPo/jt2d52LOoIks/OEEl/sFY5g3VcoJpMsjN1jLVFhMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758118699; c=relaxed/simple;
	bh=bxAe6BE//0LRX/4RtjkCh0wtOvyWI3iZ+0dZGqCJ1Ko=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=nXm03FC/0dnOBOso8dSKivatPCVJPIe5ZvsvCRvHoosjx7Z5G0JFyNEsUr6Am3D+ws6akeeCA6lO35V0cGhMVpa9HwRp5iAc4rFJQ+vZRDVqRH/Gy8WrQfxUz6jcLcCYtJhO5I+nGfuH2NGB+OQcQpUF6vtt2vU0ywbJ0IKNOxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=USa1h2N6; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-4242bb22132so1681075ab.3
        for <io-uring@vger.kernel.org>; Wed, 17 Sep 2025 07:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1758118694; x=1758723494; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4E5XWf2xRnBRZK5DaI+VLqxC4Ws8IPzvfWrkBqyKRmE=;
        b=USa1h2N6Hg+mgdMzlQluvxvKJA3yrT2Qrbs+amcIdNSx+sueSPn2XUSUor2liDZi/A
         6tuRjEub+smbCCnhXQNmaXLhOA4XFZazBKZmCUF+F5XP7W2Ioa6nx0g6SeCmFi7BG/Tk
         iPLqwPTs3ItBQtOcL3cNmbNrr2rfreBYONw1JKMLtUyx0chov9LpYm5Af0q8hHxYwx9F
         Kl6KITw8itT6gL9N5wwUx9Njy85KMvLS/wQ1WL9t9AQMUrdbMMPnI/lcxTf8WDxSyf+P
         8bk2RyNe8vQ+px4KE25t7gQ2PkWzQ8lAqGV4y/7up1+SalAaLfXZyrEM9QTrU+op3fpl
         jNlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758118694; x=1758723494;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4E5XWf2xRnBRZK5DaI+VLqxC4Ws8IPzvfWrkBqyKRmE=;
        b=w6fcfnXDxuQN4S4WiDA/6WjqpiufjWfZz8znYIXw5yw8Zf988wxyIAdlC4ZYhps26m
         Ak0wYP6NNhJODOOj37RXvOI6jD1/B/aTpo55iD7fZWIzkNB0KcO3p3SkD2L9XqwR8+F5
         30tBhvM7754LD8qoQm4m5VENDjHGnahmXFiFYA9jojmVpmJLNqbVXnKZZ43bWN0XVNP+
         +6prpvLexjxxoI3xs1pLLpt2cprzYrBv429AuxANsSC5CtdsxaBgqp6Gxc/LspXWWHOc
         ysQZf/vxINdvoqYTa/YI1c/ep7FEKIAn89Qw+QTtt78FPf1VpJ7sGAjP+7g/9WjSH2CZ
         LdMg==
X-Forwarded-Encrypted: i=1; AJvYcCVi73gSEd+SdwKBJN1Ji9KxXxQD4JCt7vW85z2EjZodIM60kfj5hOr8JcrwSo3G3xduLVSg4YC/NA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwITRYmAAReZ9Xx6dJXrZ7WB3ih2ySaFCoRP91ql/9SkLUtTZPh
	Ryad476eBwm5XOc13I+Vx/8fwzZr+Xj2ZO2J5E9EJpVq3fRDeqQy4YkPJaVKHVwjURY=
X-Gm-Gg: ASbGncvXWFPo2NCiuS0k3GrXSY8PaI6S3q+RLD20xVK7Bg3YME+H8cf2GhQG41TRQ8Q
	ajfmCTA0LzUjg7VjsHvZe0tdAmlmiTnB2utmPiO2BLer0E9Q/k899IiY0p9mtXPylAYMMQ17Iv4
	oodMu5LlzrKjSM9R7azzpSmzwq1O5gMEmlRMtvVa6HVu+p5oYSKaWT40B/KLzjOBsW6YWQSkXNG
	jD4QiJJ8+F2/wQWuhxW6pIj45b9wUgZFKg6W9AvZeMSGT/LCmqSB55K4XtavL+dL5t5LzXp7j6H
	w4k+8zkLsBgoe9fhxHuHCce1YZ+eWE7euXg/hkHsFm0wK+lrLZXh/MtWGOXIYRK1+UB9/jJ3Mpu
	kdsA25FHTImjVeLQqbEg=
X-Google-Smtp-Source: AGHT+IHw9aVHck555OAecVFFSQr5Ag7QufStlk7os7YR9GLVis+RAFxBlhN3ct6/EdoVC4QxpND5hQ==
X-Received: by 2002:a05:6e02:19c6:b0:3f0:d2df:633d with SMTP id e9e14a558f8ab-4241a4d1888mr27257675ab.8.1758118694333;
        Wed, 17 Sep 2025 07:18:14 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-511f2f32facsm7048825173.19.2025.09.17.07.18.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Sep 2025 07:18:14 -0700 (PDT)
Message-ID: <073453e4-c6af-49bf-b74c-5cc205143879@kernel.dk>
Date: Wed, 17 Sep 2025 08:18:13 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/10] io_uring: add support for
 IORING_OP_OPEN_BY_HANDLE_AT
To: Thomas Bertschinger <tahbertschinger@gmail.com>,
 io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 viro@zeniv.linux.org.uk, brauner@kernel.org, linux-nfs@vger.kernel.org,
 linux-xfs@vger.kernel.org, cem@kernel.org, chuck.lever@oracle.com,
 jlayton@kernel.org, amir73il@gmail.com
References: <20250912152855.689917-1-tahbertschinger@gmail.com>
 <20250912152855.689917-10-tahbertschinger@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <20250912152855.689917-10-tahbertschinger@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/12/25 9:28 AM, Thomas Bertschinger wrote:
> +int io_open_by_handle_at_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> +{
> +	struct io_open *open = io_kiocb_to_cmd(req, struct io_open);
> +	struct io_open_handle_async *ah;
> +	u64 flags;
> +	int ret;
> +
> +	flags = READ_ONCE(sqe->open_flags);
> +	open->how = build_open_how(flags, 0);

Maybe kill 'flags' here as it's only used to pass into build_open_how()?

	open->how = build_open_how(READ_ONCE(sqe->open_flags), 0);

> +	ret = __io_open_prep(req, sqe);
> +	if (ret)
> +		return ret;
> +
> +	ah = io_uring_alloc_async_data(NULL, req);
> +	if (!ah)
> +		return -ENOMEM;
> +	memset(&ah->path, 0, sizeof(ah->path));
> +	ah->handle = get_user_handle(u64_to_user_ptr(READ_ONCE(sqe->addr)));
> +	if (IS_ERR(ah->handle))
> +		return PTR_ERR(ah->handle);
> +
> +	req->flags |= REQ_F_NEED_CLEANUP;
> +
> +	return 0;

Prudent to do something ala:

	if (IS_ERR(ah->handle)) {
		ret = PTR_ERR(ah->handle);
		ah->handle = NULL;
		return ret;
	}

> +void io_open_by_handle_cleanup(struct io_kiocb *req)
> +{
> +	struct io_open_handle_async *ah = req->async_data;
> +
> +	if (ah->path.dentry)
> +		path_put(&ah->path);
> +
> +	kfree(ah->handle);
> +}

	kfree(ah->handle);
	ah->hande = NULL;

Just a few minor nits, overall this looks fine.

-- 
Jens Axboe

