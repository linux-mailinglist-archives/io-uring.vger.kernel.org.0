Return-Path: <io-uring+bounces-4206-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D8609B64FF
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 14:59:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4227728233E
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 13:59:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED4F81EB9ED;
	Wed, 30 Oct 2024 13:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="S+/xRcN6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D281EB9F4
	for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 13:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730296696; cv=none; b=co3lrC+/sk7X3KPaX4ttljyaWf7kEhdAW16n8/5jXyhlxK0zt0wibZQBPhf7J5D/X0Vs94C2sZjrHrt/k8IVotlUAgwKVg7NKlWJHPLilcnzU+xjeKI7b/Y1ytR77J4xyX1SO+C5sTbggE6pxsuXfH5QOX5qLlHGFdRb/YrB/bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730296696; c=relaxed/simple;
	bh=XcZHsO5P2RarZ3Z9V5LKcAqTTvCfL2FPnPSkgUZR2O8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PCiK/QY+v01RGn+2ROtVcpHA8cUX11KZrcwlTfbNWgf/H6XK50JY82qqMWhT8pLfper8t+v+RVEFT5y8Bfiiz/qjBgKOb9ZeHcePz7foVB/GhETXU4oCgtstcPkKfO96AKcXOMIh6JztCrz+bkRqxA+6k4eqJALtMoUCY36hkno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=S+/xRcN6; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-539f72c8fc1so8351786e87.1
        for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 06:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730296692; x=1730901492; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HIHuKfBrsze79RJXujpZ5r9OXGKvkO+kCMxrtPGJs2A=;
        b=S+/xRcN6f2mglwpGgAdtEFQcAo5RyFJHpFV1D04Fy9eUxkGi1Om5DX1A2ugDFKPJEL
         xcBiXPFhsRUoH8IxSUChIAh1ubuWwVzVTcXjzYXIkbyBoWjhcGkLWR9KhRD10oPXGIGf
         xP5ZyO7FoUKChNT65PgBxx9iooBgxitqhMYS7yzcdBecd4SARVixOVLoK6h/wyFcDUs6
         kspL6U0fs6oBMIolawoYQNG0CGy7XLDJJLtKknZPguEG+O8Xz3zxWiZ2a+x8gSXR7NHt
         +zufhh/iTW6bUda2zluoZ4fei22+nWfvrezmtJMJI+4YkqSUUfj6VhOyTW9boyis15tT
         73Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730296692; x=1730901492;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HIHuKfBrsze79RJXujpZ5r9OXGKvkO+kCMxrtPGJs2A=;
        b=RcvHDwI1Q8m+yNL8kzfuUTwJUBSOHvYOCEOyzZ7jHu01rfxznJgIXInqvVxUs1HXHh
         cyaKK8/wnVcv5q76CZaRESlKfbXLLYCcqHrqBimJG8WOMzXduTsnxC3VOkM/eWUWij9b
         9C5HL6N9SfMutj/A+O6KHTwXuMP+Y5CwSZEXCfo//6LP0MciBjul/ARhHQH6463m0qGJ
         nEifxv202KdkUfXCPb4Gz7FP5fUbDp4Va9EDwIBbN6SeR1kL3oaZnlesCB5Ws4bh3iCb
         H12Cuq7ONyPqh6K8si/vWeX/9aUtY0MtemZH0VA0LVInC0JTo5eayoUS3zXMmcUW1B9f
         cVtA==
X-Gm-Message-State: AOJu0YxrR65kLpOtwZNugcIv19eRqjONDPY9ql5l4oUQuguxZ+Bs4t9K
	RFkUYRNKbIVxeQeScW+WifzvEjelf+qRS70RWOv8EBO9PCu8cqUGzYTfDcdxVtU=
X-Google-Smtp-Source: AGHT+IEGr70tusIHVcK/47QtUKyo/HGKV/HEMrwpbAy/xbehj4LMeSuQyO9EoTcdVZMlFFB2l2jsEg==
X-Received: by 2002:a05:6512:3d89:b0:539:ee0a:4f8f with SMTP id 2adb3069b0e04-53b7ed18669mr1856401e87.44.1730296692444;
        Wed, 30 Oct 2024 06:58:12 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-431bd947ddbsm22269155e9.14.2024.10.30.06.58.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2024 06:58:12 -0700 (PDT)
Date: Wed, 30 Oct 2024 16:58:08 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Subject: Re: [bug report] io_uring: add support for fixed wait regions
Message-ID: <53d780a8-1761-408f-b334-bd7fa82aa71d@stanley.mountain>
References: <3191af58-8707-4916-a657-ee376b36810a@stanley.mountain>
 <eebde978-cf9b-4586-9dcf-0ff62e535a2d@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eebde978-cf9b-4586-9dcf-0ff62e535a2d@kernel.dk>

On Wed, Oct 30, 2024 at 07:22:49AM -0600, Jens Axboe wrote:
> On 10/30/24 5:40 AM, Dan Carpenter wrote:
> > Hello Jens Axboe,
> > 
> > Commit 4b926ab18279 ("io_uring: add support for fixed wait regions")
> > from Oct 22, 2024 (linux-next), leads to the following Smatch static
> > checker warning:
> > 
> > 	io_uring/register.c:616 io_register_cqwait_reg()
> > 	warn: was expecting a 64 bit value instead of '~(~(((1) << 12) - 1))'
> > 
> > io_uring/register.c
> >     594 static int io_register_cqwait_reg(struct io_ring_ctx *ctx, void __user *uarg)
> >     595 {
> >     596         struct io_uring_cqwait_reg_arg arg;
> >     597         struct io_uring_reg_wait *reg;
> >     598         struct page **pages;
> >     599         unsigned long len;
> >     600         int nr_pages, poff;
> >     601         int ret;
> >     602 
> >     603         if (ctx->cq_wait_page || ctx->cq_wait_arg)
> >     604                 return -EBUSY;
> >     605         if (copy_from_user(&arg, uarg, sizeof(arg)))
> >     606                 return -EFAULT;
> >     607         if (!arg.nr_entries || arg.flags)
> >     608                 return -EINVAL;
> >     609         if (arg.struct_size != sizeof(*reg))
> >     610                 return -EINVAL;
> >     611         if (check_mul_overflow(arg.struct_size, arg.nr_entries, &len))
> >     612                 return -EOVERFLOW;
> >     613         if (len > PAGE_SIZE)
> >     614                 return -EINVAL;
> >     615         /* offset + len must fit within a page, and must be reg_wait aligned */
> > --> 616         poff = arg.user_addr & ~PAGE_MASK;
> > 
> > This is a harmless thing, but on 32 bit systems you can put whatever you want in
> > the high 32 bits of arg.user_addr and it won't affect anything.
> 
> That is certainly true, it'll get masked away. I suspect this kind of
> thing is everywhere, though? What do you suggest?

The way that I normally see these warnings is with code like
"if (u64flags & ~mask)" where only the first 3 bits of u64flags are used.  It's
not normally a real life bug.  Normally fix them the warning, but I have 174 old
warnings from before I started complaining about them.

Maybe:

        if (U32_MAX >= SIZE_MAX && arg.user_addr > SIZE_MAX)
		return -EINVAL;

This code works fine as-is, but eventually I want this code to trigger a couple
more static checker warnings.  It's so suspicious because we're truncating user
data then re-using the same untruncated variable again.

regards,
dan carpenter

