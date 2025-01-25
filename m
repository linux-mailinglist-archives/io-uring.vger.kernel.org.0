Return-Path: <io-uring+bounces-6128-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB84DA1C250
	for <lists+io-uring@lfdr.de>; Sat, 25 Jan 2025 09:53:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EDE6E7A250E
	for <lists+io-uring@lfdr.de>; Sat, 25 Jan 2025 08:52:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FC82207670;
	Sat, 25 Jan 2025 08:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=furiosa-ai.20230601.gappssmtp.com header.i=@furiosa-ai.20230601.gappssmtp.com header.b="U622Of/D"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423011E480
	for <io-uring@vger.kernel.org>; Sat, 25 Jan 2025 08:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737795175; cv=none; b=ajoX7Hemw28KpqZO6xxuB6tck2THPdCUrmeSIciUyQ0vyfhwDCIqH3IQYX2CNcWJDjR1kihd75UdEH8zyXVMR3xG34jJ6hQXzSGJ6cVw3EcmxL/qHCcfENapdFAhqNcROUjkmt1rwBfyCraspiDqUKXHI245jyRELs2U0PJyeMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737795175; c=relaxed/simple;
	bh=tJABun/N1pK+asYLZsbyiMBPSGs5hMGWrfJnVw+svLo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LHDKJ2CSGql+hl3fKBiwMCe959XS19/W97pV3ZX0WWNGON6qPB4aahKQdvCBKTpWtWpqyoH70UYNz9UYamG1SMGOTpf/mhqXdfiYkt1/IjxLC2S1R6qStKXf7LA+T1U0XnOyfjI/D7bGLFvYtG4X3vfeWFfdA1KAuSDyZ0FqYVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (2048-bit key) header.d=furiosa-ai.20230601.gappssmtp.com header.i=@furiosa-ai.20230601.gappssmtp.com header.b=U622Of/D; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2166f1e589cso73894185ad.3
        for <io-uring@vger.kernel.org>; Sat, 25 Jan 2025 00:52:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa-ai.20230601.gappssmtp.com; s=20230601; t=1737795172; x=1738399972; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SO72R7UVXTZen40L0IB7KRDP7ojgUTcesZkKgZ/QRis=;
        b=U622Of/D1dgL3U+XkFgueoZRuAc9RyZ9Oil2DY1hNq98pCs4oZQCFlNN5aChmu+/ff
         XS0WT3G12G6ovnB52JMxUbWer2hekq5HCbW0YGPd+5V+1pjyuwk+mTFeJWYARDFUfnqt
         9aviOVAuDDMLwbPEUcI/YyZJiiy4ZfqBwEcrzChLC3GPDC8OrGBxQwWbX/k0XQkoei4J
         kR2+T9jK6ATTnVCyuauzR3vmOpETIKF+X6kCaPVFZ+yg6WzMtfMCOiX4sLZTuKSCKXYN
         6r311fEi7Wp+rBmc9LE14gtvAX2cedt1B8Y6kQWOykuarJS9MIETB5ueMYCL+UML4XHj
         A3Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737795172; x=1738399972;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SO72R7UVXTZen40L0IB7KRDP7ojgUTcesZkKgZ/QRis=;
        b=mXzF7JlVphX7gANK6dd763I37t3/34tQSLwzsZ3uB/2dHM423yPzUX+3SzyUE+S+e6
         2A8dInI9q1nooiU3LhsdjpiVX9YYELIdA3oTTKOuGlDK8RIslu1wzbZs/TBPRlznHGyX
         S1L7otlS+EYPZQYcCr2M6Ay0MmEJQqs65BGYPffMHYLXasQ+y6pp7KBMNj6Wrbsct8RT
         CnZLm6/BNRc6q+F5Q86G70b2Z5u0rpga9Yjkgane0oWvKqemO7Untu/7ci+nSUVeE7+T
         YgtxvCWtXovhHjt7FIb9Zk9i530j9jBBYZmN81qyOEkcNonQMqp9TZfq+STqjSfFIkaN
         ILog==
X-Gm-Message-State: AOJu0YzUq5s6lSGqrvwtYy18rilYHpLXg6fJTatvB5SBPsvDUaFveYTV
	3sWdkLwCsayqEr2VFuGYGbGH4uvbchAls4/8wHws7BRGn7nPqguvmz6nkBZs/QQ=
X-Gm-Gg: ASbGncv5vcWk07Zlc9dq+cA5NnhwLYnSeNMjpI/x2dKF3OuWA+hH7Pc02Y3PfcoAOgi
	XfVFutEL+INbhxEgCP2+y10Ib13uUWlBd1KkpIAthW5z25oRTysqqvvHdHaq994vK3vgfway529
	xr6M/29ZREiP4CbYTVTubS7bD0+e3fNqXuI6Jkxv0HHZV0f9iCEeWo7gsoUQJwdA8lTc+P6ntwn
	f1dkqorz9wpbH1/xxkbigR8PZyDnhGBcY2MxY0gZ/tM4+ci0pRT9bvBokZq84Cv+fcmNODF10VB
	MH6mHKmT4YFfN9BWphY9W9pXibgEFAefxWuSq7c=
X-Google-Smtp-Source: AGHT+IH6Y0pukRPpZ3AJp8VaQ6EZZiSZtdNdoQI5BwSmOXpD/35n3N6N4k6kNA0xO3H4Y0XJx9gzpQ==
X-Received: by 2002:a05:6a20:9190:b0:1ea:e8a2:57d6 with SMTP id adf61e73a8af0-1eb2148df2cmr52324716637.14.1737795172465;
        Sat, 25 Jan 2025 00:52:52 -0800 (PST)
Received: from sidongui-MacBookPro.local ([175.195.128.78])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ac495d57c4asm2896020a12.61.2025.01.25.00.52.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jan 2025 00:52:52 -0800 (PST)
Date: Sat, 25 Jan 2025 17:52:48 +0900
From: Sidong Yang <sidong.yang@furiosa.ai>
To: lizetao <lizetao1@huawei.com>
Cc: io-uring <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2] io_uring/futex: Factor out common free logic into
 io_free_ifd()
Message-ID: <Z5SmYD-X51JxCAxk@sidongui-MacBookPro.local>
References: <20250124154344.6928-1-sidong.yang@furiosa.ai>
 <f6b930ef687c4f0d895fcf019fc56eaf@huawei.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6b930ef687c4f0d895fcf019fc56eaf@huawei.com>

On Sat, Jan 25, 2025 at 07:17:06AM +0000, lizetao wrote:
> Hi,
> 
> > -----Original Message-----
> > From: Sidong Yang <sidong.yang@furiosa.ai>
> > Sent: Friday, January 24, 2025 11:44 PM
> > To: io-uring <io-uring@vger.kernel.org>; Jens Axboe <axboe@kernel.dk>
> > Cc: Sidong Yang <sidong.yang@furiosa.ai>
> > Subject: [PATCH v2] io_uring/futex: Factor out common free logic into
> > io_free_ifd()
> > 
> > This patch introduces io_free_ifd() that try to cache or free io_futex_data. It
> > could be used for completion. It also could be used for error path in
> > io_futex_wait(). Old code just release the ifd but it could be cached.
> > 
> > Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
> > ---
> > v2: use io_free_ifd() for completion
> > ---
> >  io_uring/futex.c | 12 +++++++++---
> >  1 file changed, 9 insertions(+), 3 deletions(-)
> > 
> > diff --git a/io_uring/futex.c b/io_uring/futex.c index
> > e29662f039e1..94a7159f9cff 100644
> > --- a/io_uring/futex.c
> > +++ b/io_uring/futex.c
> > @@ -44,6 +44,13 @@ void io_futex_cache_free(struct io_ring_ctx *ctx)
> >  	io_alloc_cache_free(&ctx->futex_cache, kfree);  }
> > 
> > +static void io_free_ifd(struct io_ring_ctx *ctx, struct io_futex_data
> > +*ifd) {
> > +	if (!io_alloc_cache_put(&ctx->futex_cache, ifd)) {
> > +		kfree(ifd);
> > +	}
> > +}
> 
> inline static void io_free_ifd(struct io_ring_ctx *ctx, struct io_futex_data *ifd)
> {
> 	if (!io_alloc_cache_put(&ctx->futex_cache, ifd))
> 		kfree(ifd);
> }
> 
> Maybe inline function would be better here, and the code format needs to be fine-tuned.

Thanks, I missed formatting. inline also good.
> 
> > +
> >  static void __io_futex_complete(struct io_kiocb *req, struct io_tw_state *ts)  {
> >  	req->async_data = NULL;
> > @@ -57,8 +64,7 @@ static void io_futex_complete(struct io_kiocb *req, struct
> > io_tw_state *ts)
> >  	struct io_ring_ctx *ctx = req->ctx;
> > 
> >  	io_tw_lock(ctx, ts);
> > -	if (!io_alloc_cache_put(&ctx->futex_cache, ifd))
> > -		kfree(ifd);
> > +	io_free_ifd(ctx, ifd);
> >  	__io_futex_complete(req, ts);
> >  }
> > 
> > @@ -353,13 +359,13 @@ int io_futex_wait(struct io_kiocb *req, unsigned int
> > issue_flags)
> >  		return IOU_ISSUE_SKIP_COMPLETE;
> >  	}
> > 
> > +	io_free_ifd(ctx, ifd);
> >  done_unlock:
> >  	io_ring_submit_unlock(ctx, issue_flags);
> >  done:
> >  	if (ret < 0)
> >  		req_set_fail(req);
> >  	io_req_set_res(req, ret, 0);
> > -	kfree(ifd);
> 
> Since kfree() is deleted, it is redundant to initialize ifd to NULL. You can consider modifying it like this:
> -       struct io_futex_data *ifd = NULL;
>         struct futex_hash_bucket *hb;
> +       struct io_futex_data *ifd;

This is also good. but is it actually orthogonal to this patch? ifd could be initialized with io_alloc_ifd().

Thanks,
Sidong

> 
> >  	return IOU_OK;
> >  }
> > 
> > --
> > 2.43.0
> > 
> 
> --
> Li Zetao
> 

