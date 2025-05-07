Return-Path: <io-uring+bounces-7883-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 61772AAE33A
	for <lists+io-uring@lfdr.de>; Wed,  7 May 2025 16:41:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C1A0B16C241
	for <lists+io-uring@lfdr.de>; Wed,  7 May 2025 14:36:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E87C289365;
	Wed,  7 May 2025 14:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TpbolCoH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E90228001E
	for <io-uring@vger.kernel.org>; Wed,  7 May 2025 14:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746628537; cv=none; b=I61H/9Kt3+ZKxZQCEfHrt0zwI40VSXAPQY7Jend99iOXm9eojxTr2ljj+tKQ+6r1jjtRqETrAkUmAFTO/2xO3mGIy6gBdI7fCU7MIjSOPQHSfIOT96xn9QOr/2jEygd2A504ItMR8B3Rrvcp4zvAxS0FvVw/CWzvrE81mlFGkEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746628537; c=relaxed/simple;
	bh=RSdTiJUczDRN/2ny81z5F7oh3Fql/50p9Kg0p6E2dQM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Yyq7ObYvTkvZ+b7EXAebG7MtLaAmOW1o7FDQyd3i91gjgZCiO75qg8uMEHsuCtDYAVKfDVHgE1dP42B+3FwJ2LcmuCcPkfvih9g720TlrAnEaBBIUnmaOoyYHmmYUpnhUzLxD7wFS/sDIW+2+59k7B0VogZibnBDqsI/q4tinzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TpbolCoH; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-43ea40a6e98so59578775e9.1
        for <io-uring@vger.kernel.org>; Wed, 07 May 2025 07:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746628534; x=1747233334; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TXK4+FMypr15mlU4GRgN0WD4GpXE0KvkX0uv89AxMM4=;
        b=TpbolCoH1qIEgLGOj1yPxO/r34sPB9aoDUnVjImL5XoeOaB24YF1WJ2ax6eY1feryI
         Gl6oBCaX2ntpfD6GzvVSz4zUCBBwQmi4rRZkJDMSKwXPvKDWFeQ7fkH0osFYJ7VyL33E
         xd8SaUQAcjUts1d5QC6XAH9r4CIdExrhBsSwglqyXtiau6S6hGWbmLIOWC8qeQBHye1Y
         mHeIMRMdMEYBlV9IzuDkqcKLdlKRi6csAyNqmNDIG0YcNmJanIeN4zBMB5pzpkViOHJg
         l8HXXWIo0O0IxJlTUmR+r4wMRlc/n7m9mmRdtJ9C2u0zSRYI+pQ7n6cx+dEgqotzeBt7
         t/Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746628534; x=1747233334;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TXK4+FMypr15mlU4GRgN0WD4GpXE0KvkX0uv89AxMM4=;
        b=jO0l9c6JRy+BVbTfZA5V7u/wJN5lojX3sCjNNw2d1dhspk/TsyTc7VvP0di98JGM9Q
         xIV0c1ADBmyMbpaC6MU+doD91gNRq1HsLwMWjkk4WF2o7q1BO/T5bHZcWV5gmOu05TTw
         R/REZ/qXd9uKHR+fXvnvFTnVewsLiyHHAVaws4sE1M6Vi+rvjmOtvVYSZtWfSs7EZu70
         ewXSgphzT26ztwq86ZI85chuljwyWDNKrVuiTaSXF3yVGIqWLj8w5crFWdi4aDviTU4e
         85686fHoAOPEkhwSFmdJz/k0GN+4E6MYBXN41oObPW2lnoKERUr7tZjHMOpFU+/41vk9
         TCQw==
X-Forwarded-Encrypted: i=1; AJvYcCV8PAOnO3mg/DNqQ9xlDDmLGlGsjaWy1IqTkDHA3HQjuqFS37EEY6KD2YwUczOI4PuXhvg/QkH+Bg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4RITO0ChWFIjOgTpH/i0HmC85sJfpMCeecexgrGOpUHUn31Te
	qUGDNcUAfybtZdWZrNnUFeFbvMOEBweZnbZip9aUVR4Hsf6mJXEf216+QQ==
X-Gm-Gg: ASbGnctWdhNvr4MCE5pqQlqh7whGWCeMxvZJaA84hviQ7/g/VTCdXjsjM8C3034hz5+
	K05MvNdoa30PHfLzewThezMSXfWu9PI5Nfa2JGwz/PclIu36kfHwNSyzruE9liMpaNdO3qOtpyU
	83zmjo6SzajpcpzbtYDzTCAUzELyJMWLMDZWwezvMsDL2ewsx6Cz6eA7DTMnNh+ZY6URP1YB4+/
	jW5AexGbIFpkj8rIKAl9ImtfXDIiz+mmgB0GE2Sq3lJHuktrPGK9rD7mjTNvIeoyPm5eXYk9mpm
	YMA/xTxctcjKB99HM7eUM97LD48zG87eWg1LrEHzSNFzDysCug==
X-Google-Smtp-Source: AGHT+IErfF7PLmzRj7086kugfbiFtRGQIfzDh7iFgh4b+M+Ure+16qh87Ihb2Qtal8RqW+26nlD2IA==
X-Received: by 2002:a05:600c:3ac9:b0:439:9b2a:1b2f with SMTP id 5b1f17b1804b1-441d44bc737mr34087145e9.3.1746628533552;
        Wed, 07 May 2025 07:35:33 -0700 (PDT)
Received: from [192.168.8.100] ([185.69.145.185])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-441d15e211asm46539045e9.1.2025.05.07.07.35.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 May 2025 07:35:33 -0700 (PDT)
Message-ID: <c6260e33-ad29-4cd1-85c1-d0658c347a31@gmail.com>
Date: Wed, 7 May 2025 15:36:49 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: ensure deferred completions are flushed for
 multishot
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <a1dffa40-0c30-40d0-87b4-0a03698fd85f@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <a1dffa40-0c30-40d0-87b4-0a03698fd85f@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/7/25 14:56, Jens Axboe wrote:
> Multishot normally uses io_req_post_cqe() to post completions, but when
> stopping it, it may finish up with a deferred completion. This is fine,
> except if another multishot event triggers before the deferred completions
> get flushed. If this occurs, then CQEs may get reordered in the CQ ring,
> as new multishot completions get posted before the deferred ones are
> flushed. This can cause confusion on the application side, if strict
> ordering is required for the use case.
> 
> When multishot posting via io_req_post_cqe(), flush any pending deferred
> completions first, if any.
> 
> Cc: stable@vger.kernel.org # 6.1+
> Reported-by: Norman Maurer <norman_maurer@apple.com>
> Reported-by: Christian Mazakas <christian.mazakas@gmail.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> ---
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 769814d71153..541e65a1eebf 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -848,6 +848,14 @@ bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags)
>   	struct io_ring_ctx *ctx = req->ctx;
>   	bool posted;
>   
> +	/*
> +	 * If multishot has already posted deferred completions, ensure that
> +	 * those are flushed first before posting this one. If not, CQEs
> +	 * could get reordered.
> +	 */
> +	if (!wq_list_empty(&ctx->submit_state.compl_reqs))
> +		__io_submit_flush_completions(ctx);

A request is already dead if it's in compl_reqs, there should be no
way io_req_post_cqe() is called with it. Is it reordering of CQEs
belonging to the same request? And what do you mean by "deferred"
completions?


> +
>   	lockdep_assert(!io_wq_current_is_worker());
>   	lockdep_assert_held(&ctx->uring_lock);
>   

-- 
Pavel Begunkov


