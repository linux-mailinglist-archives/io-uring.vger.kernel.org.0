Return-Path: <io-uring+bounces-231-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D1498056B0
	for <lists+io-uring@lfdr.de>; Tue,  5 Dec 2023 15:02:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2D9201F212B9
	for <lists+io-uring@lfdr.de>; Tue,  5 Dec 2023 14:02:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 321AF5FEF9;
	Tue,  5 Dec 2023 14:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="FJQgM1TD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59DEA1AA
	for <io-uring@vger.kernel.org>; Tue,  5 Dec 2023 06:01:58 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-6ce40061e99so376265b3a.0
        for <io-uring@vger.kernel.org>; Tue, 05 Dec 2023 06:01:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1701784918; x=1702389718; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YVjjE48jLq2LhmxkAA0QBSEDYtiUx0hmwoBJwThRdtY=;
        b=FJQgM1TDuPxUe/DJ0PmtGMeGwAIomHzQKE708CeMrox8L5w3yT6MTeMceka76CxciZ
         7E4ydU4bKLyJatHO8KtjjfBu3m2xnJzZUoRDfsxyJDp5E1Mk4ljF9KoOlXkuulL3uPt2
         0M9aijzovNcIU5jB849AXuxMEuJ/R1H5Jm9HdWnJItd97QRtqCG68ifBw3+VT0AdiP2t
         w6+gw7VNlsjDgZ4OyYcCeujbJYAFxVpBh9Ew8nYYU9jJY3Ny2HntihAYdTAkKtHzIV/P
         dGAk5zHXjEQ5uPx+ddvUwFj2lw4nNaDEbwWqlu7gGNKSgOTYSyA5gNt59db8z/G4IFmv
         p4Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701784918; x=1702389718;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YVjjE48jLq2LhmxkAA0QBSEDYtiUx0hmwoBJwThRdtY=;
        b=NnQDMb5OBrUXmLjuW/eVpi+ok2DJFWVYbJmiZ77mAXSrSUZLj89d6Fmm3mXsgqRNnK
         T1H2U7TKeQ1nz1HeYSUPcRuvKhW/pMcmdT3tKZWFgV9/bRl/exr22jlDTK0KXxTKDUfm
         SqoA7YVHOuZHsSufMi0LVI0NJn4o08H/Viy4JBK29TcYcm1EN6k3bDiYr4K2SRBBZiH8
         K+POtB1luwO9iuEMNUVV+ofZj33dvv3f5GbJ/zHqVD7OKStFwU/rFJzPR/w9hVKQDOL2
         rq24kJewNDTv9Iybv7Uf7vOlQEosRIBpaf3rvt0TsBPlaxc4xzOVEQUl3FNR2jpVhEL6
         bqsg==
X-Gm-Message-State: AOJu0YyXzyC4VF9Q95A6ULMxCOMf37jzg0MIdOr8wAx3veqUcVnkGQzr
	rAPY6mV1+rP/gb+cDRunmCarmA==
X-Google-Smtp-Source: AGHT+IHxnwC1aiquHuFrhMTM1dsb5QVnWqdwzsryGUnUAfVVL3BLnu5PaUJ0Ic0idIFkuK4sB1R7Dw==
X-Received: by 2002:a62:844e:0:b0:6ce:720e:23e with SMTP id k75-20020a62844e000000b006ce720e023emr1399829pfd.1.1701784917356;
        Tue, 05 Dec 2023 06:01:57 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id bs186-20020a6328c3000000b005b96b42f7ccsm9406349pgb.82.2023.12.05.06.01.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Dec 2023 06:01:55 -0800 (PST)
Message-ID: <2c95b60e-88a7-428f-ae8f-4efb71eaa247@kernel.dk>
Date: Tue, 5 Dec 2023 07:01:54 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] io_uring: free io_buffer_list entries via RCU
Content-Language: en-US
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: io-uring@vger.kernel.org
References: <9a411872-46c3-4652-8704-d1610f547583@moroto.mountain>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <9a411872-46c3-4652-8704-d1610f547583@moroto.mountain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/5/23 5:36 AM, Dan Carpenter wrote:
> Hello Jens Axboe,
> 
> This is a semi-automatic email about new static checker warnings.
> 
> The patch 5cf4f52e6d8a: "io_uring: free io_buffer_list entries via 
> RCU" from Nov 27, 2023, leads to the following Smatch complaint:
> 
>     io_uring/kbuf.c:766 io_pbuf_get_address()
>     warn: variable dereferenced before check 'bl' (see line 764)
> 
> io_uring/kbuf.c
>    753  void *io_pbuf_get_address(struct io_ring_ctx *ctx, unsigned long bgid)
>    754  {
>    755          struct io_buffer_list *bl;
>    756  
>    757          bl = __io_buffer_get_list(ctx, smp_load_acquire(&ctx->io_bl), bgid);
>    758  
>    759          /*
>    760           * Ensure the list is fully setup. Only strictly needed for RCU lookup
>    761           * via mmap, and in that case only for the array indexed groups. For
>    762           * the xarray lookups, it's either visible and ready, or not at all.
>    763           */
>    764          if (!smp_load_acquire(&bl->is_ready))
>                                       ^^^^^
> bl dereferenced here
> 
>    765                  return NULL;
>    766          if (!bl || !bl->is_mmap)
>                     ^^^
> Checked for NULL too late.
> 
>    767                  return NULL;
>    768  
>    769          return bl->buf_ring;
>    770  }

Thanks, yeah we should just move the check below the NULL check. I'll
queue up a fixlet.

-- 
Jens Axboe


