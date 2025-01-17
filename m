Return-Path: <io-uring+bounces-5971-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23408A14EC8
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 12:51:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 50F3B7A256B
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 11:51:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 098A31FE45D;
	Fri, 17 Jan 2025 11:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F1tgUJkY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E831FCCE1;
	Fri, 17 Jan 2025 11:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737114681; cv=none; b=e+xQaNdj+rku8loXKUvFYN5VBBULryKxXAssdJ3tfAvh0KSnWYtg3gJrVpuztqIgyzRwV+Ra64guloRx1ZDcpFj7YOdFyFtPobyawOtrIt/qxQZaMsL6S7cJS9pcbFBYcgbvByxa0ZDFP9U/fsjHM+mKOCrcPaYGp3Fv+zni1gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737114681; c=relaxed/simple;
	bh=nycHrz6URtKuAr7PANse+z/kDgvOXuj8asKUoPLA4eU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TUBOXVJtiRFP8Gf9CtRcYsY/Bbip0/QQpr+33OzB5usgWg97aCoKN7J9BNNgfu8+8O0j4oJGhj3TxBAru9B7QnXyHj5p8h7EKhbQ4xRhgEDQ3w1RQntiMWo5Ed1jsRykMZl1d7TM53ak+JfAq+mqQPpsjWLcjyDwqMBpBy8FnRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F1tgUJkY; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5d41848901bso871957a12.0;
        Fri, 17 Jan 2025 03:51:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737114678; x=1737719478; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eKtHrDuuhEMKt4L52bDPc13ByKnEjN91haMyPwn1QCw=;
        b=F1tgUJkYe3Q5ytZeFAml/nTK7gwlii0ODIFld5e9KZWw42J9nMFgzo0W2xi4IJ4bK5
         Kj9C6egB7FBtyk/5n4j3MCpctRV6Dppfkdj4WAQTGScAkG6jV7fv0uNYCm8CcSwyIOz6
         HE/ROPwZSiVsGQ/1MRzYCNiMyi+SjdVoEOj0PrC2QQ2txsAIZvkUHNspMFsxDMXeOLt1
         CGLV3jcpOUmwIZUhYpdP5thrqmUu6LRfPY4EaA2x903/diLb9igUk/KNOeH7TtYY+wn3
         47WWMbcbzz2HYwwrK/fSSDwb2QgW21AlGLqy9PlZqO7aHfetDRzq+pGRx5IH3deM1vSY
         zEGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737114678; x=1737719478;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eKtHrDuuhEMKt4L52bDPc13ByKnEjN91haMyPwn1QCw=;
        b=TqXEcHhkvQAxwALkRvB3lcxcEiY6WZlo458OB9IUHUQnI9H8eOQue8h6qn+Ac2eDMR
         8hNvr2EI1NiFS/gnbwd+0Vlr5Hy4JnuLHkwLSBjC5tx46wnCwtFSCPjG+VqVittOniPc
         M7tEBzIUEg2hVnUux2HcrEocfV+HzHoaGMOKLOlqi/mZnHDplWUj/g0SOI95NMYDABv5
         91KIAidEecd0k8nQyol0uN77hvB6yR3bi+8QOmv6IcLrk2UQ/GZlKhVDn0DbAyToIbhs
         yxzITAlLgT/sNGsUciSwKu6Xd9ajPXxpsRDKnsbOs0cgHpc/+iEJ6AWPRJu35MsVNZo7
         ElGQ==
X-Forwarded-Encrypted: i=1; AJvYcCUF6sLJhSfa4Hb4OTIp3cqtchtxGogpNKWPaBglVuBu1ChsBuCTI86OR6zsqQtFYr8M+9QM5l6FGJm7UjiVZQ==@vger.kernel.org, AJvYcCUlZuESbVt49oRdqia/wOWcvqIJ4r2FY1L2l4Rj4+oG3XIE8/m9xLrwYdB7FZEoGe5ZJyyUC8kPBA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8kIOR58wzn+6RboD1kmSmHDhRclvul3BoeTKsju++PfauGMKK
	9Oe+qL8u0FyFFDrIqm8+4Pi4oQBHe6KdDjxXCu4aLFPD1DpIAaBe
X-Gm-Gg: ASbGncuLCrBoUG8vFXD7gKnu27ruyZwob12IUj9pXeLt3BMqaL/P74oYuBOm8vyIwFI
	GQfFpEXhxTTQpaRL8s19cN1n5yZ5YJ6ed0qtYchGyHsNcifXDniWp4hFnKNfS6/xhrQIlawkBJk
	Y7J7bQNaPxFjFpXPdG9foUpEzmJ+iEd4WbjaBejhPBAvOdK6jStxa6rnyRpoxkVpSDQWzKn4twK
	MTwgY5ndlb8/vYh6yOZm4R2OaukSwiXpt+wUM7+A7oLhIehJjvvlPSSg0VUKe85TCZO6Jd2c+gR
	qahSkEmRmGKf7g==
X-Google-Smtp-Source: AGHT+IFg9gj7ytT8x2KUHeMdnRro1xYqqdVVqzs1HVFORVEr7JmNWZdpmxwI9XqKCAtj5viNpEM7ww==
X-Received: by 2002:a05:6402:35d6:b0:5d9:f1fd:c1a2 with SMTP id 4fb4d7f45d1cf-5db7dcec1afmr2042834a12.12.1737114678426;
        Fri, 17 Jan 2025 03:51:18 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:56de])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5db73683c1asm1396667a12.35.2025.01.17.03.51.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2025 03:51:18 -0800 (PST)
Message-ID: <38277e7a-027a-40e7-85d5-9baa43800067@gmail.com>
Date: Fri, 17 Jan 2025 11:52:02 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 15/17] fuse: {io-uring} Prevent mount point hang on
 fuse-server termination
To: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>,
 Josef Bacik <josef@toxicpanda.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>,
 bernd@bsbernd.com
References: <20250107-fuse-uring-for-6-10-rfc4-v9-0-9c786f9a7a9d@ddn.com>
 <20250107-fuse-uring-for-6-10-rfc4-v9-15-9c786f9a7a9d@ddn.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250107-fuse-uring-for-6-10-rfc4-v9-15-9c786f9a7a9d@ddn.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/7/25 00:25, Bernd Schubert wrote:
> When the fuse-server terminates while the fuse-client or kernel
> still has queued URING_CMDs, these commands retain references
> to the struct file used by the fuse connection. This prevents
> fuse_dev_release() from being invoked, resulting in a hung mount
> point.

lgtm

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com> # io_uring

> 
> This patch addresses the issue by making queued URING_CMDs
> cancelable, allowing fuse_dev_release() to proceed as expected
> and preventing the mount point from hanging.
> 
> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
> ---
>   fs/fuse/dev.c         |  2 ++
>   fs/fuse/dev_uring.c   | 71 ++++++++++++++++++++++++++++++++++++++++++++++++---
>   fs/fuse/dev_uring_i.h |  9 +++++++
>   3 files changed, 79 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index afafa960d4725d9b64b22f17bf09c846219396d6..1b593b23f7b8c319ec38c7e726dabf516965500e 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -599,8 +599,10 @@ static int fuse_request_queue_background(struct fuse_req *req)
>   	}
>   	__set_bit(FR_ISREPLY, &req->flags);
>   
> +#ifdef CONFIG_FUSE_IO_URING
>   	if (fuse_uring_ready(fc))
>   		return fuse_request_queue_background_uring(fc, req);
> +#endif


Looks like it should've been a part of some earlier commit.

>   
>   	spin_lock(&fc->bg_lock);
>   	if (likely(fc->connected)) {


-- 
Pavel Begunkov


