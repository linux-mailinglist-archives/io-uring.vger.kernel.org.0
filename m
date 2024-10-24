Return-Path: <io-uring+bounces-3974-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73A9F9AEA42
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 17:22:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A56BB1C22989
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 15:21:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA04B1EABD2;
	Thu, 24 Oct 2024 15:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="npyFHIAl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668351EC004
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 15:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729783309; cv=none; b=it03Pa61VRZq2BI8ozTas0uw9mwRCAP1+6uGARymmkDO9UMyoXVBh5IJPxgsc+Qz3OsQkxsnVZ8RaceaMcfKZyKXEmTt/Ed1iCJzpBIPgV8mKikf4ueuWqb5u1MnVmZv3tu1hxEC5YQCW+zXWGxUVKkKYJmTRQkv7afA9HMOM98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729783309; c=relaxed/simple;
	bh=AARVJsoEmIDtMEwMev8FNDxejkORi3W0e19GXbTz5Gc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=OY7o9ivHPMbJjg+YyOdLlgXajwL6cUS/QUcZ5kOrhjGSy+IDskkku/IPmqbXMqatUrRYgj1FfeQdOjIOnc+XAXba3BMdm+r/lZcqZKEZiS6wE+KC7pkEyGDUX5VQemucDHIYTp+V6miNQ7MUCviqWFrpIBIG0PWOW2Lui0TC74g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=npyFHIAl; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a9a5f555cfbso66035966b.1
        for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 08:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729783305; x=1730388105; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3U5jiFOA9iO/tYf7RZbTeK5FY2nxfbgU7juufZl3egs=;
        b=npyFHIAlFE01PmbZQpQSOsViznUkKRpWx5O/+vDJ4U9JyLJSntFE2NCrwvMzcIRlXl
         4iczt0X2XwLudhB6CLou7rn9clfma1osR/HtNKIVdRRXQoYN3hIr68kOID7ZrGwfPDFr
         QcS42nPM8QP4NhP266n735kNM/q3PcdTlDUIM/u1+msRxGsmNSJVb4UTpMyHQePsT2x7
         hGIgLGdwO44Z6ypO70d62S0IfWV+qCNrPkim/aQVV9SqJrQRH1iF1Ino7uU7HULytyu8
         hgU3alLnC94xbeA3qWlIz4frZjr1lgfnN83TSZmh/Q4UsBKlWHe4ZXmmWsqEBcJmNi42
         ko7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729783305; x=1730388105;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3U5jiFOA9iO/tYf7RZbTeK5FY2nxfbgU7juufZl3egs=;
        b=c7vHuXq/OqwxxFEUiTLOUFFgaum6HEJhNyESr7xqHsUuI0AQMZphBuISSfsKfxNYwU
         r9sBvUj4/TQ4nY4WnGJVihfnm5d6E2nbFHpyp/+meux9Hmx3YhaBYiiUKdGKa3AbUsrO
         TVTPuj2UVr4mHCvTvzJSISNVWUKYd5cXieAW99GN680eKKlXYkZieB+bkLPXpbn/KknC
         L0jHCIuYaPtLBzTdqOmFP6MupWcsBHGMHYvGFoR4aPGCy0Zc+VKxF6JUJ2cZP1MOkD/o
         nVvnTVmzAlry1LRQTud9+VgjzaDBvYvHflPTxYP37Qs0cYIWXtm3VdslZ9u4KJ+SRJJn
         s/4A==
X-Forwarded-Encrypted: i=1; AJvYcCXRaPmaB8aFckEbQXLUq5F7KsOPhMcVvyJlUMemtNq3H1PjHxBcB5/QiT1PBblWvw8scwSsdDiO9A==@vger.kernel.org
X-Gm-Message-State: AOJu0YxCF1T9bwJu3Bjhfpk4hX5kEdLuX2Y1ehSPA5rgWuO1jGcHpu5M
	99guje6HVr6iS0fISBoHGduPVmqZZgNMphv3qZ6trH15a007mi6XbBSHPg==
X-Google-Smtp-Source: AGHT+IGduWT6fSnNaaHx9aqZnF8473KK2UxWPhAp9JEPOUpKNQdHaPpjSvf0Yo9y4DouZMuRI2WMPA==
X-Received: by 2002:a05:6402:3591:b0:5cb:6696:4e31 with SMTP id 4fb4d7f45d1cf-5cb8b267fcamr7725307a12.22.1729783305419;
        Thu, 24 Oct 2024 08:21:45 -0700 (PDT)
Received: from [192.168.42.27] ([85.255.233.224])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cb66c72581sm5819950a12.86.2024.10.24.08.21.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 08:21:44 -0700 (PDT)
Message-ID: <84c8f280-09eb-425d-a47f-69117438ae55@gmail.com>
Date: Thu, 24 Oct 2024 16:22:20 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/7] io_uring/kbuf: add support for mapping type
 KBUF_MODE_BVEC
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20241023161522.1126423-1-axboe@kernel.dk>
 <20241023161522.1126423-7-axboe@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241023161522.1126423-7-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/23/24 17:07, Jens Axboe wrote:
> The provided buffer helpers always map to iovecs. Add a new mode,
> KBUF_MODE_BVEC, which instead maps it to a bio_vec array instead. For
> use with zero-copy scenarios, where the caller would want to turn it
> into a bio_vec anyway, and this avoids first iterating and filling out
> and iovec array, only for the caller to then iterate it again and turn
> it into a bio_vec array.
> 
> Since it's now managing both iovecs and bvecs, change the naming of
> buf_sel_arg->nr_iovs member to nr_vecs instead.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   io_uring/kbuf.c | 170 +++++++++++++++++++++++++++++++++++++++++++-----
>   io_uring/kbuf.h |   9 ++-
>   io_uring/net.c  |  10 +--
>   3 files changed, 165 insertions(+), 24 deletions(-)
> 
> diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
> index 42579525c4bd..10a3a7a27e9a 100644
> --- a/io_uring/kbuf.c
> +++ b/io_uring/kbuf.c
...
> +static struct io_mapped_ubuf *io_ubuf_from_buf(struct io_ring_ctx *ctx,
> +					       u64 addr, unsigned int *offset)
> +{
> +	struct io_mapped_ubuf *imu;
> +	u16 idx;
> +
> +	/*
> +	 * Get registered buffer index and offset, encoded into the
> +	 * addr base value.
> +	 */
> +	idx = addr & ((1ULL << IOU_BUF_REGBUF_BITS) - 1);
> +	addr >>= IOU_BUF_REGBUF_BITS;
> +	*offset = addr  & ((1ULL << IOU_BUF_OFFSET_BITS) - 1);

There are two ABI questions with that. First why not use just
user addresses instead of offsets? It's more consistent with
how everything else works. Surely it could've been offsets for
all registered buffers ops from the beggining, but it's not.

And the second, we need to start getting rid of the global node
queue, if we do, this will need to allocate an array of nodes,
store an imu list or something similar, which will be just
as terrible as it sounds, and then it'll need another cache,
sprinking more checks and handling into the hot path and so
on. That's the reason the vectored registered buffer patch
supports juts one registered buffer to index per request, and
I believe this one should do that as well.

-- 
Pavel Begunkov

