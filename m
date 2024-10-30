Return-Path: <io-uring+bounces-4199-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D56699B6349
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 13:49:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9384B2812C0
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 12:49:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C70D1D14F6;
	Wed, 30 Oct 2024 12:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MVZM1PEu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93F51E9090
	for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 12:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730292560; cv=none; b=mMv3N5RlQLe5V0X6BDhcVuBzA/8SLPZLMWfIwjrpVxKdFIvuRBNL1dFRg18GlBuoLd5mdVGwcO4OcbakvT0aG1KozOiPW61HESQnpm4gvkYoUZpupJqfMNFUDjMwTN0ZxyQgoEPTX/gGjXWvBLp23rH5KMYfaNnoH+Y7byTW4nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730292560; c=relaxed/simple;
	bh=ox1XxL2xkJ9AWBVPd2jt2bGWyL7vTmzc+q0U9Jg4ivQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=gh6LNqx4Eq1kw+eRgbTXbSUwPbVLURDPhp9IB7T4tPWEtUVy1R2ALcugrJEuxP39oXbQ4sEYPQyKG+p32no5TwYUo/G0aOUSqoKE0ZKpRu2ExDf5YitTxizwxPgTg0y94W9c6ZenbJgMWtnVt6Xt4SCv2lKUTZcBYPMEMvT2TBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MVZM1PEu; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-431616c23b5so5718465e9.0
        for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 05:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730292556; x=1730897356; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YtBFqcqhLSPTra5O0GoBkLjkqg1dbSgUbpph/miKzHI=;
        b=MVZM1PEuBXRcZexYkLPUYOeDsuByIk+6S8mkGGIIAnYptiA2kua0xce7PTcSCPTFlS
         Po+Y8JwH1Ypi8b4atOYsV7Ghyfax2owFdupt+Jk5GvHouqD9O8L1cgxp/ODPR4dYK63I
         4AmytkOyX3T50bCLJKbW/5CjTRAGRJVSaGXBwqNr/gKzE5Yh5mhq1JYfDrOkU82m8Ppn
         qrqRa0kYl11pIZTmdHLdlr7zeE8fvP5hQYv7+OA4x1WMIgtBPOA6cQXX5iisYV7mGUv/
         /837VbaOLgc0CrQ2GuB8Ct7/b9uvg4htOrLvmGo875KOL2B0ehmEQbmVAZpBi6MjLy02
         oYrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730292556; x=1730897356;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YtBFqcqhLSPTra5O0GoBkLjkqg1dbSgUbpph/miKzHI=;
        b=dcWB945dnnje896RwmpRYkIz6EcqCDbJuGkCynOXZcHlyDdKdiv1b2OlpJXOZpoQ5H
         66N374H6TfFzls5HPWv3eWoe6WRGrNLyTq7I0XdVXq2ho/SfyKxUH0BJ5AJpuWRSdDts
         WRZxc/xJZ+/M97BT4gcfQ+Hc3pdzdf8o2Jucgi8JkrqRRDxOgY1UupH98pej4THfIKHo
         Ig3peeQlaoklJMFMxZxN7T0PhXYiceYA3CWVBAaHSSKBlG15TedDbsnSFmM8wPbUxGo8
         tEPLk+grwl8S5pk2NwzlaPG6VmxbRU1GlkidsXBzwcnGm35bbhrADZa2ck3DuVZBgKH/
         rYHQ==
X-Gm-Message-State: AOJu0YznSY2yLb5oGY1otNd7iI9piaTmzlEiwPfY29rnw0p2FHJ8TQx4
	TPP6vL6f4bT5g0YShyviXJ4hqT2nD6I6iv4CwhJ3zZQsMr/e8fz47P3o+TI3KPqJmLgzAHbFali
	j
X-Google-Smtp-Source: AGHT+IHCfI+HSZ/qemM71hhQe2UBEUJFn4QNp3CB/sSe/ZGvm6iKYY5qIppe9RufXJeFAb722KEz9A==
X-Received: by 2002:a05:600c:19c9:b0:431:52da:9d89 with SMTP id 5b1f17b1804b1-431b5704d0emr48948955e9.1.1730292556248;
        Wed, 30 Oct 2024 05:49:16 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-431bb78b809sm31444325e9.1.2024.10.30.05.49.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2024 05:49:16 -0700 (PDT)
Date: Wed, 30 Oct 2024 14:40:45 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Subject: [bug report] io_uring: add support for fixed wait regions
Message-ID: <3191af58-8707-4916-a657-ee376b36810a@stanley.mountain>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Jens Axboe,

Commit 4b926ab18279 ("io_uring: add support for fixed wait regions")
from Oct 22, 2024 (linux-next), leads to the following Smatch static
checker warning:

	io_uring/register.c:616 io_register_cqwait_reg()
	warn: was expecting a 64 bit value instead of '~(~(((1) << 12) - 1))'

io_uring/register.c
    594 static int io_register_cqwait_reg(struct io_ring_ctx *ctx, void __user *uarg)
    595 {
    596         struct io_uring_cqwait_reg_arg arg;
    597         struct io_uring_reg_wait *reg;
    598         struct page **pages;
    599         unsigned long len;
    600         int nr_pages, poff;
    601         int ret;
    602 
    603         if (ctx->cq_wait_page || ctx->cq_wait_arg)
    604                 return -EBUSY;
    605         if (copy_from_user(&arg, uarg, sizeof(arg)))
    606                 return -EFAULT;
    607         if (!arg.nr_entries || arg.flags)
    608                 return -EINVAL;
    609         if (arg.struct_size != sizeof(*reg))
    610                 return -EINVAL;
    611         if (check_mul_overflow(arg.struct_size, arg.nr_entries, &len))
    612                 return -EOVERFLOW;
    613         if (len > PAGE_SIZE)
    614                 return -EINVAL;
    615         /* offset + len must fit within a page, and must be reg_wait aligned */
--> 616         poff = arg.user_addr & ~PAGE_MASK;

This is a harmless thing, but on 32 bit systems you can put whatever you want in
the high 32 bits of arg.user_addr and it won't affect anything.

    617         if (len + poff > PAGE_SIZE)
    618                 return -EINVAL;
    619         if (poff % arg.struct_size)
    620                 return -EINVAL;
    621 
    622         pages = io_pin_pages(arg.user_addr, len, &nr_pages);

There ought to be a Smatch warning about that sort of thing here really but
there isn't yet.

    623         if (IS_ERR(pages))
    624                 return PTR_ERR(pages);
    625         ret = -EINVAL;
    626         if (nr_pages != 1)
    627                 goto out_free;
    628         if (ctx->user) {
    629                 ret = __io_account_mem(ctx->user, 1);
    630                 if (ret)
    631                         goto out_free;
    632         }
    633 
    634         reg = vmap(pages, 1, VM_MAP, PAGE_KERNEL);
    635         if (reg) {
    636                 ctx->cq_wait_index = arg.nr_entries - 1;
    637                 WRITE_ONCE(ctx->cq_wait_page, pages);
    638                 WRITE_ONCE(ctx->cq_wait_arg, (void *) reg + poff);
    639                 return 0;
    640         }
    641         ret = -ENOMEM;
    642         if (ctx->user)
    643                 __io_unaccount_mem(ctx->user, 1);
    644 out_free:
    645         io_pages_free(&pages, nr_pages);
    646         return ret;
    647 }

regards,
dan carpenter

