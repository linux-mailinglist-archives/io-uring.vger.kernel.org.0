Return-Path: <io-uring+bounces-4204-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E1269B63F7
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 14:22:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C09391C20F54
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 13:22:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F313545023;
	Wed, 30 Oct 2024 13:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="j8KcXIkr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F9017579
	for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 13:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730294574; cv=none; b=OBLSYvZz+sncpe50IzTUPEJxscWbPLUX9Kh0bNkqrt5reMtInltKl6/Y2my4BrE/7HMANWyfYlPVHPlYNB+y/tu/6aWzADKsYXt31JUWnsBarwAFItUHKY0Vz+Mr29F3p4Kic5X9jMEchPFYQ0+gol1dfoBZv8NQ+Ot+IfdlKto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730294574; c=relaxed/simple;
	bh=9FK7f+E5aRzs7Lh0jso/B/zfODURd4Qjf+nQAF18gs8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JxrGq+DfIOjeFHsc9rWWbcOX9NS2/fGjWK0oWfozFYS5oINZZfE9oM5gGu8SpXEfh4Q1GgTRk/QbqJoFsP588S73iTHLFGJO4BlxL8n9vMVBxgAei8ujSeh60T4NJBQMeGJqGGTZ/VryMlpObtXNgFcFDWhB7KlY2MfunACbY2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=j8KcXIkr; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-83ac05206c9so253612839f.3
        for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 06:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730294572; x=1730899372; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=myQnaByp07a0IHHurFVWaxlM2x/jJgPeZ0zaUorCsOo=;
        b=j8KcXIkr/T6uKsRvuDSoN9bVu6rjzzLJib6oI9Js38I/2h9ulWLJZsipCQARvkeFzP
         meWtZj79D6oMi/EcpHyn01gzqReR4C1xv93IvcITrTF7BTcLP0pLEug+/S6sgRFrjdoV
         cVMHk1r6eaP5vm4hLHUWk/rv6CCb9BFsQNP9UrJUJ8ADh3x8P7N3tOxgc6lSrEPS3jAs
         pg714j8iTW2PXTdPg2W2o01ht3HfT0MXNG5FfVBjQywWx7gBeZXCSsE7ArAXoubyaV35
         TCq01AtY3gS/5Y1+zKPZOE8dQSE93sG4aDHY/Qsmh+ZyCyjBNNw+I8BkwJrz7HYgc1Qq
         5v9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730294572; x=1730899372;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=myQnaByp07a0IHHurFVWaxlM2x/jJgPeZ0zaUorCsOo=;
        b=n+y8R/GKJpxNNUQ8NDPsVYIuvOLegs4oVYX4P3jyBlxfXgNj0eZRlPZmapKTdU+vvx
         r1atU24Kp+5SYroa4Uo5d6x7SwXi2yRs/l6Q5Eh7WfiYRKvYV7w0WaaTWkRq2lG3/mFB
         UonIWLC/hUN7vaNKIe7ObqckdlkLaYRUFeiq8Y5WPD1Wn2ICsf9osebDX7Dv8uB8st5e
         MPnRiBai3GPnuwAI8LaC7UYoFaaPquTaGE8Hpu0gxtSQRWYx/Hq726gFhc1gC8fukX74
         I2cr4LQrOykIgY9Sq7uclj6jG1yXHn68cpW6u1lL14jyuLuwDlv3V/MoPcAu23gh+i22
         +m1g==
X-Gm-Message-State: AOJu0YzbtsmorY3t7ISGHOaaau5Du1VoaQxrFiw91Dx3YmCESGFIcTYu
	5TeTjygt8puu+6mV7LMNTvnjOFSJXHW7n0N8PSbo07YIbUTK3B9nycfaYM/3bEM2vMeKg3DUN5d
	m
X-Google-Smtp-Source: AGHT+IHQkH9YVrBGdXr9LT+Uswotflo9flvmeEourEVynaPUxwWlc0dIJvOvr39mavGVEsbnpqxuHw==
X-Received: by 2002:a05:6602:60c6:b0:83a:a82b:f855 with SMTP id ca18e2360f4ac-83b1c4ba8acmr1686032139f.9.1730294572041;
        Wed, 30 Oct 2024 06:22:52 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc7275069csm2843942173.111.2024.10.30.06.22.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Oct 2024 06:22:51 -0700 (PDT)
Message-ID: <eebde978-cf9b-4586-9dcf-0ff62e535a2d@kernel.dk>
Date: Wed, 30 Oct 2024 07:22:49 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] io_uring: add support for fixed wait regions
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: io-uring@vger.kernel.org
References: <3191af58-8707-4916-a657-ee376b36810a@stanley.mountain>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <3191af58-8707-4916-a657-ee376b36810a@stanley.mountain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/30/24 5:40 AM, Dan Carpenter wrote:
> Hello Jens Axboe,
> 
> Commit 4b926ab18279 ("io_uring: add support for fixed wait regions")
> from Oct 22, 2024 (linux-next), leads to the following Smatch static
> checker warning:
> 
> 	io_uring/register.c:616 io_register_cqwait_reg()
> 	warn: was expecting a 64 bit value instead of '~(~(((1) << 12) - 1))'
> 
> io_uring/register.c
>     594 static int io_register_cqwait_reg(struct io_ring_ctx *ctx, void __user *uarg)
>     595 {
>     596         struct io_uring_cqwait_reg_arg arg;
>     597         struct io_uring_reg_wait *reg;
>     598         struct page **pages;
>     599         unsigned long len;
>     600         int nr_pages, poff;
>     601         int ret;
>     602 
>     603         if (ctx->cq_wait_page || ctx->cq_wait_arg)
>     604                 return -EBUSY;
>     605         if (copy_from_user(&arg, uarg, sizeof(arg)))
>     606                 return -EFAULT;
>     607         if (!arg.nr_entries || arg.flags)
>     608                 return -EINVAL;
>     609         if (arg.struct_size != sizeof(*reg))
>     610                 return -EINVAL;
>     611         if (check_mul_overflow(arg.struct_size, arg.nr_entries, &len))
>     612                 return -EOVERFLOW;
>     613         if (len > PAGE_SIZE)
>     614                 return -EINVAL;
>     615         /* offset + len must fit within a page, and must be reg_wait aligned */
> --> 616         poff = arg.user_addr & ~PAGE_MASK;
> 
> This is a harmless thing, but on 32 bit systems you can put whatever you want in
> the high 32 bits of arg.user_addr and it won't affect anything.

That is certainly true, it'll get masked away. I suspect this kind of
thing is everywhere, though? What do you suggest?

-- 
Jens Axboe

