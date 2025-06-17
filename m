Return-Path: <io-uring+bounces-8387-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 11B12ADCC04
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 14:53:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 024483AFD29
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 12:52:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C17B128BAB1;
	Tue, 17 Jun 2025 12:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="PGMUNoX4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0621D28BAA4
	for <io-uring@vger.kernel.org>; Tue, 17 Jun 2025 12:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750164787; cv=none; b=n2OYSDZPatLnQu7D1dk6LgQya5Ix4oFaMTYWYM6ksUguVFxEcCiiVkG3NQYnJp7om7pfsnKhXbh9wXRrRCjOdpCRwBb435vg3j8clIWSoYxPbG10wBohySuxP+IYx98Cn5rlJpYMcumP3vMXGhWF18lVWqTDRVFfZVOyIRptu3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750164787; c=relaxed/simple;
	bh=F3+s0/pmwGLdnQuK7Ff/UG+BEutCPeAOuuzNIRijpf4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OXRlvkpoRtvdVmy/nnmBD/3VG7UiyR1VrL5kHVDasRtTxdVFhWgO37abcVZ3e2n7Q+5i5Qv5z88Kl7QH8Sym5cYsIGulR/vE+I9fIZvjYD/eCdPTnML8vzfasKVOjrRkFQvUcUKb02UGvoVQdzFIq+S3BUPZ7HGMdoKbiGOR16A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=PGMUNoX4; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3ddda8e419bso24667925ab.0
        for <io-uring@vger.kernel.org>; Tue, 17 Jun 2025 05:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1750164785; x=1750769585; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PJYeeTODD5BQ4jLbpOEHvWLsKMTX6dvTlOoHFR5Ubkc=;
        b=PGMUNoX4lZ2F4O1EtkSTWwSLPO3luThB8SbIV4trlRPnQZxp2WJJlS3L+95sAYSlgG
         2x462oRMxvxyCc/FbWG3LvBsvLmz/rZ62JDCvC5WtYfQWry2dYGdPVOZbt26EIDYDIT0
         pKZ48J86M+JKvLlONUvzoGZYpOcmQn6rv23wXS0gexCssEno0/IPBTOCxChCw1QNlAk2
         mZKxRymlPybMEFNc0VSn4di3SuFGK9HoqhA/jAj1FRJbckuGfJLj9+ujIwsaK/xqtj7k
         hoeYc9VCk5dm6lkjaMjTb1SQElQkqOTYTtVyr+e+rMM8PnlsDfx3dm3bVdoDeGikiIYM
         vnvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750164785; x=1750769585;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PJYeeTODD5BQ4jLbpOEHvWLsKMTX6dvTlOoHFR5Ubkc=;
        b=GCGzUik1csLJwOz1d0pMbE8+QwR3v6osnLLr9ETJtNZ1v+K3fNPqdyAbImhrmA+Xhw
         E18JbqenPQNcxgSX8ir4OjCXbMkgOD6JE8RyujrrFbu3YzEFZCckgDuy0Y/Mbwv5ia99
         tHyGYqSsPURowa39Tb2cf1woNnD7aa14UTzkeZt53ZOI7/YOGN7+90GPRqAqurbzu61U
         ZviCh7Ivi4BSofsYazrzlNkH7fOVnGO7HPj/IDl2PcFZQqajjEulRAyxh7GYnxiG3Gvs
         pCAu533rUboWLwQTLpHM8i8l0mkajRs5aL9ViUo6QJ95O4TshH/J6djcZeXRdPWZNBX6
         UxSw==
X-Gm-Message-State: AOJu0YzPmanZpGBOPRezjqz7u7glXcinqxpzjoCpkwwMeFubwM1kaXst
	t1DlNq2H6LpGubOfHgv7bV3ZotuMTiAUcsrgdMUkqOv1uOUQ5wU1/aHik6e4QhHolurtsjJpW7Y
	44SQw
X-Gm-Gg: ASbGncsGPnWtd12znYzfKXircym6aX7fWMZuwhd2IzOEP91j93xxuWGP0W9NYNRcUCZ
	Dd9eA/pMOjAWBmvF7dbOz4vUofHJxZMH3bwUqC+krrYuP3TwzjJdkzA0SIexoChoPPL55ub461M
	tC7GRCLUwXaM3saTCONCvjGPUVVHsEEO1+NWsjrhDYX0K7z5htiuYQXLl1CeeLbduQ0p+bUcNVV
	6dp+kd56qLh9mblvPU5d+AQ8RmFVw117a3WrSFI00MaIJ7jpmJi1OuuVcBfxwZ+DxAFVpqWZuPb
	0+R+GwFvZE4WVM/DHUVigtRJYPwJExwbOgVVJ8uSSsJALFJ1fCWap5aPr7I=
X-Google-Smtp-Source: AGHT+IGTDtrBNhMSg0LnpVaxRJ2O/+fab9261ZO16IUYHhfjbaPWlLLSejyGQyz21sFlQkWoUp+I/A==
X-Received: by 2002:a05:6e02:450e:b0:3dd:bf91:23f7 with SMTP id e9e14a558f8ab-3de22cc97bamr26264915ab.7.1750164785074;
        Tue, 17 Jun 2025 05:53:05 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50149c85c1asm2209755173.111.2025.06.17.05.53.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jun 2025 05:53:04 -0700 (PDT)
Message-ID: <618aaa53-14a7-4d85-90d4-6e4a8e1ce3a1@kernel.dk>
Date: Tue, 17 Jun 2025 06:53:04 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: fix page leak in io_sqe_buffer_register()
To: Penglei Jiang <superman.xpt@gmail.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250617123940.40113-1-superman.xpt@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250617123940.40113-1-superman.xpt@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/17/25 6:39 AM, Penglei Jiang wrote:
> Add missing unpin_user_pages() in the error path
> 
> Fixes: d8c2237d0aa9 ("io_uring: add io_pin_pages() helper")
> Signed-off-by: Penglei Jiang <superman.xpt@gmail.com>
> ---
>  io_uring/rsrc.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index c592ceace97d..f5ac1b530e21 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -804,8 +804,10 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
>  	}
>  
>  	imu = io_alloc_imu(ctx, nr_pages);
> -	if (!imu)
> +	if (!imu) {
> +		unpin_user_pages(pages, nr_pages);
>  		goto done;
> +	}
>  
>  	imu->nr_bvecs = nr_pages;
>  	ret = io_buffer_account_pin(ctx, pages, nr_pages, imu, last_hpage);

Wouldn't it be better to have the unpin be part of the normal error
handling? Not sure why the pin accounting failure doesn't do that
already.

Totally untested...

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 94a9db030e0e..a68f0cd677a3 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -809,10 +809,8 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 
 	imu->nr_bvecs = nr_pages;
 	ret = io_buffer_account_pin(ctx, pages, nr_pages, imu, last_hpage);
-	if (ret) {
-		unpin_user_pages(pages, nr_pages);
+	if (ret)
 		goto done;
-	}
 
 	size = iov->iov_len;
 	/* store original address for later verification */
@@ -840,6 +838,7 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 	}
 done:
 	if (ret) {
+		unpin_user_pages(pages, nr_pages);
 		if (imu)
 			io_free_imu(ctx, imu);
 		io_cache_free(&ctx->node_cache, node);

-- 
Jens Axboe

