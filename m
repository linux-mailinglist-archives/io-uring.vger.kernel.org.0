Return-Path: <io-uring+bounces-8389-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 251D3ADCEC4
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 16:08:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D5C33A177C
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 14:02:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 075372E7173;
	Tue, 17 Jun 2025 14:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bs05NptC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8202CCC5;
	Tue, 17 Jun 2025 14:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750168961; cv=none; b=a2v58JBNrQuHQbNr/ixEcdr1LcyRLoZDcUpQCcZuw4b8OvVp/7mGaFyJu6BnfPgDwChZVDS4lp/GOJ4z+xemXAyVibCVbh6x6lQgqbtw+P5WKQVPhTBw1+i2zV13DywtNukxpsug3gumHOlDXLfSZZcZJGN5smMP0MuF3Ja4r6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750168961; c=relaxed/simple;
	bh=P9zYp6tDIUFMpMfxG878+zEknO7QZ7sQkH+KSyaTPj8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=Da3Kcvqf5h2j6g3N9uQ3sH1Yy4Gnp/A9eba72GF9q+cczhjs1c2i1P6jTsFrQc4iTIgdbC/+IlUgx/XQml7NoTRU3EabYi+NVIdgIAhySp8vIpSW9cXr7a5Rlmc6eoMwPksMsAWDkbFQE2o23pEeeznCBkeU6UwgIcxY+LGRfJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bs05NptC; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-b2c40a7ca6eso6043911a12.1;
        Tue, 17 Jun 2025 07:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750168960; x=1750773760; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=QDaAx6iiEt3ZsmgY/NM7GzXn943URIlFJ5nTMeHEO1M=;
        b=bs05NptC7uc0xaAGc03VDlpqc5YHCXQPykzk31CwIj7yw6Dh8X+bsa3b3t7wuoym+a
         YIaGSkO2R1OsQNRk0pwQmMprQZ/AzCrXrO4/bqx6lWO3nEXGA9pg+4MuSLFDGAvyl7W/
         bKaJLmxLoGzM8iEQtBC6zKFZCNtiS6fsioSOXx/pOeFTrwokdlcyyLXHl9dkGhRDT7KX
         C01VCfDmX0j6IrlfNrpEEYt4J4F4UlTkPVuuSXYi1qkM5oi85SmwXKn87pqhzml9Xq1H
         /5MNHsaW8eKLjuAWA0pz8B7MjVqeXtc7ImXuHbF4OpkuFdPv9ink0l6lTMEfWUz3hHtB
         EoYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750168960; x=1750773760;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QDaAx6iiEt3ZsmgY/NM7GzXn943URIlFJ5nTMeHEO1M=;
        b=wp4aSFxJZtDOFAgQKNXIUhgOHy/7UiWckyodTjOWxTKan9ICASRBQxKYrNhsujz3NH
         zB6OQjEyH+gqvQf8NpdjE7kTS/aY8VV9csckLHO2CqYPYGqcGU8C3vFETWxD5wgAHItX
         KhlWlhjB9DBbE6lpNEmTosUcKuZCwXAaq926WxBkJmMKCK7K65/etWaHhzCZAJMTOGIz
         KnWecYG2k73WSDkr5E4jTdFn9i7/ITotk0l8wsj4RGxwduwJVwjmx4n7y3fFaHTuKx2z
         Ngwx9VQwP/qVa1nKbbmWyHMSAP/n3hajw+YyTDeERGHfw6hZt8wTZh+8goBOoN5NUtQ+
         i2tA==
X-Forwarded-Encrypted: i=1; AJvYcCWqJzyrBtz3Dtr0PnQx7wiXwPmhn5RnLNDlKda5BgCH3LBv6kw5fhw3oWSk/2eu1Z5+Unu4T4gq9yjnf5s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4KLU7ZU2CvzJVGp10ib9U8SG0pyi1jzlIxcJAU/OJX4VEg8mt
	PJpWlMSt3e6ujM4sV44fapNu6BYdfbQqaMSHQeK7t9ZdxnOXxxioMZ+9
X-Gm-Gg: ASbGncu3dOvdkjb65nwSZJX3drj5/m9tRkt3hr6sXrVGMmjuYeP+9ULECamW/3MX5KO
	tFNHLfJBFJi4PvjnC37lo1EqJYyM9rD2tKLJckPIMZuvUmfkjTaOqtjS+f2FVnQLqz/UdDGMyUB
	HDbR06tMAQA3bXXWhO25MJoJoY/fiC6mn67YfgHZhC9V8AER/z2OlKt9I01vV/seeDfAJ46KoNz
	0Q+JKuuRmtIeKfdceZ6xIih8UDPbtgSK/4W5ZS0puygDp74W7s+uqCWgQmGpc7vwEJkn2IgJ4Fl
	WA3PQjoJ5nrA05R7Gh16mudtcdpD3rskOJV1+AJLlQnBTIvEns+CRRDC/Hh55H6ccF3wHgVyu5F
	nppOlZaY=
X-Google-Smtp-Source: AGHT+IGxlu46JuoRs7SX37W5zvnLj8SuUaGSNH6Wjv5XlWMMKthDM3nr+4HSmo11Rnp8eMdcL/10Jg==
X-Received: by 2002:a05:6a20:9143:b0:1f5:87dc:a315 with SMTP id adf61e73a8af0-21fbd5d85c3mr19622857637.12.1750168959572;
        Tue, 17 Jun 2025 07:02:39 -0700 (PDT)
Received: from ubuntu.localdomain ([39.86.156.14])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b2fe1639eb8sm7519405a12.10.2025.06.17.07.02.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 07:02:39 -0700 (PDT)
From: Penglei Jiang <superman.xpt@gmail.com>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	superman.xpt@gmail.com
Subject: Re: [PATCH] io_uring: fix page leak in io_sqe_buffer_register()
Date: Tue, 17 Jun 2025 07:02:34 -0700
Message-Id: <20250617140234.40664-1-superman.xpt@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <618aaa53-14a7-4d85-90d4-6e4a8e1ce3a1@kernel.dk>
References: <618aaa53-14a7-4d85-90d4-6e4a8e1ce3a1@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

On Tue, 17 Jun 2025 06:53:04 -0600, Jens Axboe wrote:
> On 6/17/25 6:39 AM, Penglei Jiang wrote:
> > Add missing unpin_user_pages() in the error path
> > 
> > Fixes: d8c2237d0aa9 ("io_uring: add io_pin_pages() helper")
> > Signed-off-by: Penglei Jiang <superman.xpt@gmail.com>
> > ---
> >  io_uring/rsrc.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> > index c592ceace97d..f5ac1b530e21 100644
> > --- a/io_uring/rsrc.c
> > +++ b/io_uring/rsrc.c
> > @@ -804,8 +804,10 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
> >  	}
> >  
> >  	imu = io_alloc_imu(ctx, nr_pages);
> > -	if (!imu)
> > +	if (!imu) {
> > +		unpin_user_pages(pages, nr_pages);
> >  		goto done;
> > +	}
> >  
> >  	imu->nr_bvecs = nr_pages;
> >  	ret = io_buffer_account_pin(ctx, pages, nr_pages, imu, last_hpage);
> 
> Wouldn't it be better to have the unpin be part of the normal error
> handling? Not sure why the pin accounting failure doesn't do that
> already.
> 
> Totally untested...
> 
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 94a9db030e0e..a68f0cd677a3 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -809,10 +809,8 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
>  
>  	imu->nr_bvecs = nr_pages;
>  	ret = io_buffer_account_pin(ctx, pages, nr_pages, imu, last_hpage);
> -	if (ret) {
> -		unpin_user_pages(pages, nr_pages);
> +	if (ret)
>  		goto done;
> -	}
>  
>  	size = iov->iov_len;
>  	/* store original address for later verification */
> @@ -840,6 +838,7 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
>  	}
>  done:
>  	if (ret) {
> +		unpin_user_pages(pages, nr_pages);
>  		if (imu)
>  			io_free_imu(ctx, imu);
>  		io_cache_free(&ctx->node_cache, node);

Thank you for taking the time to address this issue!

However, if io_pin_pages() fails, it will also jump to the done label,
but at that point, the value of nr_pages is undefined because nr_pages
is only assigned a value inside io_pin_pages() if it succeeds.

	pages = io_pin_pages((unsigned long) iov->iov_base, iov->iov_len,
				&nr_pages);
	if (IS_ERR(pages)) {
		ret = PTR_ERR(pages);
		pages = NULL;
		goto done;
	}

	...

	done:
		if (ret) {
			unpin_user_pages(NULL, undefined-value);
			...

I'm not sure what the impact of calling unpin_user_pages() in this way would be.

